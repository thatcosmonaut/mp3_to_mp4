#!/bin/bash

image=''
audio_dir=''
output_dir=''

while getopts ":i:f:o:" opt; do
  case $opt in
    i)
      image=$OPTARG >&2
      ;;
    f)
      audio_dir=$OPTARG >&2
      ;;
    o)
      output_dir=$OPTARG >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ "$image" = '' ]; then
  echo "Option -i is required." >&2
  echo "Usage: " >&2
  echo "mp3_to_mp4.sh -i /path/to/image -f /path/to/audio/dir -o /path/to/output/dir" >&2
  exit 1
fi

if [ "$audio_dir" = '' ]; then
  echo "Option -f is required." >&2
  echo "Usage: " >&2
  echo "mp3_to_mp4.sh -i /path/to/image -f /path/to/audio/dir -o /path/to/output/dir" >&2
  exit 1
fi

if [ "$output_dir" = '' ]; then
  echo "Option -o is required." >&2
  echo "Usage: " >&2
  echo "mp3_to_mp4.sh -i /path/to/image -f /path/to/audio/dir -o /path/to/output/dir" >&2
  exit 1
fi

for f in $audio_dir/*.mp3
do
  echo $f
  stripped_name=$(basename "$f" .mp3)
  output_file="$output_dir/$stripped_name.mp4"
  ffmpeg -loop 1 -i "${image}" -i "${f}" -c:v libx264 -c:a copy -shortest "${output_file}"
done
