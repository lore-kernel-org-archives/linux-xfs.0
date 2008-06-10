Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Jun 2008 18:49:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5A1mr3e001523
	for <xfs@oss.sgi.com>; Mon, 9 Jun 2008 18:48:55 -0700
Message-ID: <484DDDB3.70000@sgi.com>
Date: Tue, 10 Jun 2008 11:49:39 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Filestreams
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net>
In-Reply-To: <484CA425.3080606@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Richard Scobie <richard@sauce.co.nz>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Richard Scobie wrote:
>> Is my understanding of filestreams correct, in that files written to a 
>> particular filestreams enabled directory are all allocated to 1 ag as 
>> long as the filestreams timeout is not exceeded - which I believe is 30s?
>>
>> In other words, if I copy 100 files into a directory, (cp -a 
>> dir_containing_100_files dest_dir), wait 60 seconds and do (cp -a 
>> dir_containing_100_different_files dest_dir), each directory and 
>> contents in dest_dir will be stored in a single, different ag?
>>
>> Also, would it be possible for the filestreams parameter to be added to 
>> man pages/kernel docs?
> 
> Yes please :)  I was just noticing last week that there is no
> documentation anywhere on this feature ....
> 
> -Eric
> 
>> Thanks,
>>
>> Richard
>>
>>
> 

Sounds a reasonable idea :)


BTW, Sam Vaughan wrote some tutorial notes on the allocator and in particular
filestreams which I've pasted below:
(I thought it might be here:
 http://oss.sgi.com/projects/xfs/training/ but I can't see it
 in the allocator lab and slides).

-------------------------------------------------------------------------
Filestreams Allocator

A certain class of applications such as those doing film scanner
video ingest will write many large files to a directory in sequence.
It's important for playback performance that these files end up
allocated next to each other on disk, since consecutive data is
retrieved optimally by hardware RAID read-ahead.

XFS's standard allocator starts out doing the right thing as far
as file allocation is concerned.  Even if multiple streams are being
written simultaneously, their files will be placed separately and
contiguously on disk.  The problem is that once an allocation group
fills up, a new one must be chosen and there's no longer a parent
directory in a unique AG to use as an AG "owner".  Without a way
to reserve the new AG for the original directory's use, all the
files being allocated by all the streams will start getting placed
in the same AGs as each other.  The result is that consecutive
frames in one directory are placed on disk with frames from other
directories interleaved between them, which is a worst-case layout
for playback performance.  When reading back the frames in directory
A, hardware RAID read-ahead will cache data from frames in directory
B which is counterproductive.

Create a file system with a small AG size to demonstrate:

sles10:~ sjv: sudo mkfs.xfs -d agsize=64m /dev/sdb7 > /dev/null
sles10:~ sjv: sudo mount /dev/sdb7 /test
sles10:~ sjv: sudo chmod 777 /test
sles10:~ sjv: cd /test
sles10:/test sjv:

Create ten 10MB files concurrently in two directories:

sles10:/test sjv: mkdir a b
sles10:/test sjv: for dir in a b; do
> for file in `seq 0 9`; do
> xfs_mkfile 10m $dir/$file
> done &
> done; wait 2>/dev/null
[1] 30904
[2] 30905
sles10:/test sjv: ls -lid * */*
   131 drwxr-xr-x 2 sjv users       86 2006-10-20 13:48 a
   132 -rw------- 1 sjv users 10485760 2006-10-20 13:48 a/0
   133 -rw------- 1 sjv users 10485760 2006-10-20 13:48 a/1
   134 -rw------- 1 sjv users 10485760 2006-10-20 13:48 a/2
   135 -rw------- 1 sjv users 10485760 2006-10-20 13:48 a/3
   136 -rw------- 1 sjv users 10485760 2006-10-20 13:48 a/4
   137 -rw------- 1 sjv users 10485760 2006-10-20 13:48 a/5
   138 -rw------- 1 sjv users 10485760 2006-10-20 13:48 a/6
   139 -rw------- 1 sjv users 10485760 2006-10-20 13:48 a/7
   140 -rw------- 1 sjv users 10485760 2006-10-20 13:48 a/8
   141 -rw------- 1 sjv users 10485760 2006-10-20 13:48 a/9
262272 drwxr-xr-x 2 sjv users       86 2006-10-20 13:48 b
262273 -rw------- 1 sjv users 10485760 2006-10-20 13:48 b/0
262274 -rw------- 1 sjv users 10485760 2006-10-20 13:48 b/1
262275 -rw------- 1 sjv users 10485760 2006-10-20 13:48 b/2
262276 -rw------- 1 sjv users 10485760 2006-10-20 13:48 b/3
262277 -rw------- 1 sjv users 10485760 2006-10-20 13:48 b/4
262278 -rw------- 1 sjv users 10485760 2006-10-20 13:48 b/5
262279 -rw------- 1 sjv users 10485760 2006-10-20 13:48 b/6
262280 -rw------- 1 sjv users 10485760 2006-10-20 13:48 b/7
262281 -rw------- 1 sjv users 10485760 2006-10-20 13:48 b/8
262282 -rw------- 1 sjv users 10485760 2006-10-20 13:48 b/9
sles10:/test sjv:

Note that all the inodes are in the same AGs as each other.  What
about the file data?  Use xfs_bmap -v to examine the extents:

sles10:/test sjv: for file in `seq 0 9`; do
> bmap_a=`xfs_bmap -v a/$file | tail -1`
> bmap_b=`xfs_bmap -v b/$file | tail -1`
> ag_a=`echo $bmap_a | awk '{print $4}'`
> ag_b=`echo $bmap_b | awk '{print $4}'`
> br_a=`echo $bmap_a | awk '{printf "%-18s", $3}'`
> br_b=`echo $bmap_b | awk '{printf "%-18s", $3}'`
> echo a/$file: $ag_a "$br_a" b/$file: $ag_b "$br_b"
> done
a/0: 0 96..20575          b/0: 1 131168..151647
a/1: 0 20576..41055       b/1: 1 151648..172127
a/2: 0 41056..61535       b/2: 1 172128..192607
a/3: 0 61536..82015       b/3: 1 192608..213087
a/4: 0 82016..102495      b/4: 1 213088..233567
a/5: 0 102496..122975     b/5: 1 233568..254047
a/6: 2 299600..300111     b/6: 2 262208..275007
a/7: 2 338016..338527     b/7: 2 312400..312911
a/8: 2 344672..361567     b/8: 3 393280..401983
a/9: 2 361568..382047     b/9: 3 401984..421951
sles10:/test sjv:

The middle column is the AG number and the right column is the block
range.  Note how the extents for files in both directories get
placed on top of each other in AG 2.

Something to note in the results is that even though the file extents
have worked their way up into AGs 2 and 3, the inode numbers show
that the file inodes are all in the same AGs as their parent
directory, i.e. AGs 0 and 1.  Why is this?  To understand, it's
important to consider the order in which events are occurring.  The
two bash processes writing files are calling xfs_mkfile, which
starts by opening a file with the O_CREAT flag.  At this point, XFS
has no idea how large the file's data is going to be, so it dutifully
creates a new inode for the file in the same AG as the parent
directory.  The call returns successfully and the system continues
with its tasks.  When XFS is asked write the file data a short time
later, a new AG must be found for it because the AG the inode is
in is full.  The result is a violation of the original goal to keep
file data close to its inode on disk.  In practice, because inodes
are allocated in clusters on disk, a process that's reading back a
stream is likely to cache all the inodes it needs with just one or
two reads, so the disk seeking involved won't be as bad as it first
seems.

On the other hand, the extent data placement seen in the xfs_bmap
-v output is a problem.  Once the data extents spilled into AG 2,
both processes were given allocations there on a first-come-first-served
basis.  This destroyed the neatly contiguous allocation pattern for
the files and will certainly degrade read performance later on.

To address this issue, a new allocation algorithm was added to XFS
that associates a parent directory with an AG until a preset
inactivity timeout elapses.  The new algorithm is called the
Filestreams allocator and it is enabled in one of two ways.  Either
the filesystem is mounted with the -o filestreams option, or the
filestreams chattr flag is applied to a directory to indicate that
all allocations beneath that point in the directory hierarchy should
use the filestreams allocator.

With the filestreams allocator enabled, the above test produces
results that look like this:

a/0: 0 96..20575          b/0: 1 131168..151647
a/1: 0 20576..41055       b/1: 1 151648..172127
a/2: 0 41056..61535       b/2: 1 172128..192607
a/3: 0 61536..82015       b/3: 1 192608..213087
a/4: 0 82016..102495      b/4: 1 213088..233567
a/5: 0 102496..122975     b/5: 1 233568..254047
a/6: 2 272456..273479     b/6: 3 393280..410271
a/7: 2 290904..300119     b/7: 3 410272..426655
a/8: 2 300632..321111     b/8: 3 426656..441503
a/9: 2 329304..343639     b/9: 3 441504..459935

Once the process writing files to the first directory starts using
AG 2, that AG is no longer considered available so the other process
skips it and moves to AG 3.

---------------------------------
