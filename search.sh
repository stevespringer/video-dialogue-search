#!/bin/bash

# Check if searchterm and baseurl arguments were provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <searchterm> <baseurl>"
  exit 1
fi

filename="results/$(date +%s%3N).json"

grep -wriHT $1 videos/*.tsv |
    jq -Rs '
        split("\n") |
        map(select(length > 0)) |
        map(split("\t")) |
        map(
            {"file": (.[0] | sub("\\.tsv:$"; ".mp4")),
            "start": .[1],
            "end": .[2],
            "text": .[3]}
        ) ' > $filename

echo "$2/searchresults.html?data=$filename&query=$1"
