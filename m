Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55399 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751638AbcKNBAS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Nov 2016 20:00:18 -0500
Date: Sun, 13 Nov 2016 20:00:04 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161114005951.GB2127@clm-mbp.thefacebook.com>
References: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
 <20161015223454.GS23194@dastard>
 <20161017002427.GA70229@clm-mbp.masoncoding.com>
 <20161017015251.GU23194@dastard>
 <e0c37926-a670-98b6-4bd7-b438def130bd@fb.com>
 <20161017223057.GV23194@dastard>
 <f6dadb97-4233-4bbf-3edc-4985c7727548@fb.com>
 <20161018020324.GA23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20161018020324.GA23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 18, 2016 at 01:03:24PM +1100, Dave Chinner wrote:

[ Long stalls from xfs_reclaim_inodes_ag ]

>XFS has *1* tunable that can change the behaviour of metadata
>writeback. Please try it.

[ weeks go by, so this email is insanely long ]

Testing all of this was slow going because two of the three test boxes I 
had with the hadoop configuration starting having hardware problems.  
The good news is that while I was adjusting the benchmark, we lined up 
access to a bunch of duplicate boxes, so I can now try ~20 different 
configurations in parallel.

My rough benchmark is here:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/simoop.git

The command line I ended up using was:

simoop -t 512 -m 190 -M 128 -C 28 -r 60000 -f 70 -T 20 -R1 -W 1 -i 60 -w 
300 -D 2 /hammer/*

I'll break down how I came up with that command line and the end of the 
email.

This isn't trying to be like hadoop, it's more trying to create the same 
VM pressures that hadoop does.  It's missing all of the network traffic, 
which is at least as much of the workload as disk.

The benchmark has a few parts:

Fill the drives to ~60-70% full.  This working set is reused run to run
Read things
Write things
Burn CPU -- it's important that kswapd have to compete for CPU slices
Allocate things

I'm pretending to be java here, so anything that could be done with a 
one thread was done with 10 threads for good luck.

Stage one is to create a working set of files across all the drives.  We 
use 15 drives, and each drive has its own filesystem.  On my current 
boxes, the drives are 8TB each, but production can be as small as 4TB.  
The multiple FS part of the benchmark is important to reproduce what we 
see, but I doubt you need all 15.  If you want to try this out, I'm 
happy to match your config and help come up with a command line that 
reproduces for me.

While I was reproducing the problem, I was trying to avoid the one part 
of hadoop that bothers me the most.  It has one thread per filesystem 
that runs du on the whole FS every 10 minutes or so.  There are patches 
in upstream hadoop to use df instead, but ugh.  I think what's happening 
is that when the du thread kicks in, we get a lot of inodes that are 
tossed soon after.  This in turn means XFS_ICI_RECLAIM_TAG is set on a 
lot of ags, which makes it easier to trigger my stalls.

In hopes of simulating a workload less dumb, my simoop runs periodically 
stat all the files on only two of the 15 drives.  The idea is that a 
mixed workload is slowing the system down to the slowest drive.

We find the allocation stalls counters in /proc/vmstat roughly matches 
poor performance overall.  So, the benchmark reads that from time to 
time includes it in the output.

Some example results, plain v4.8 kernel.  This run had xfssyncd tuning 
left at the default, but I did crank it down last week without any real 
change in the numbers.  The bad news is it takes the runs a long time to 
stabilize, I run at least an hour.

v4.8
___
Run time: 3623 seconds
Read latency (p50: 21,594,112) (p95: 31,621,120) (p99: 36,896,768)
Write latency (p50: 19,169,280) (p95: 31,096,832) (p99: 37,158,912)
Allocation latency (p50: 12,992,512) (p95: 28,934,144) (p99: 36,110,336)
work rate = 9.12/sec (avg 8.77/sec) (p50: 8.91) (p95: 9.11) (p99: 9.99)
alloc stall rate = 44.98/sec (avg: 41.22) (p50: 39.56) (p95: 41.20) (p99: 50.96)

In general, we care most about the p99 of the latencies.
Once you average things over the fleet, most users see the p99 often 
enough that it really hurts.  The latency times here are in usec, but 
read/write latencies are the time it took for N threads to start, do IO 
and return.

work rate is a made up number, and basically summarizes the combination 
of reading, writing, allocating and hogging the CPU.  For that, we'd use 
the avg or p50 number to measure production.

Comparing with the patch:
___
Run time: 3614 seconds
Read latency (p50: 18,644,992) (p95: 29,720,576) (p99: 34,930,688)
Write latency (p50: 12,173,312) (p95: 22,839,296) (p99: 29,851,648)
Allocation latency (p50: 9,322,496) (p95: 25,395,200) (p99: 30,834,688)
work rate = 10.82/sec (avg 11.16/sec) (p50: 10.90) (p95: 11.14) (p99: 11.30)
alloc stall rate = 28.05/sec (avg: 19.52) (p50: 23.56) (p95: 31.48) (p99: 36.12)

I also had a bpf probe running alongside the test to measure how long 
we're spending in xfs_reclaim_inodes_ag().  argdist.py comes with the 
bcc iovisor: https://github.com/iovisor/bcc.  I ran:

argdist.py -i 600 -H 'r::xfs_reclaim_inodes_ag():u64:$latency:$latency < 
56137438953472'

(v4.9-rc fixes a bug where the latencies go negative, so you have to 
ignore crazy numbers from v4.8 or older).  

Unpatched:

	       $latency                      : count     distribution
		   0 -> 1                    : 0        |                    |
		   2 -> 3                    : 0        |                    |
		   4 -> 7                    : 0        |                    |
		   8 -> 15                   : 0        |                    |
		  16 -> 31                   : 0        |                    |
		  32 -> 63                   : 0        |                    |
		  64 -> 127                  : 0        |                    |
		 128 -> 255                  : 0        |                    |
		 256 -> 511                  : 0        |                    |
		 512 -> 1023                 : 0        |                    |
		1024 -> 2047                 : 0        |                    |
		2048 -> 4095                 : 1        |                    |
		4096 -> 8191                 : 0        |                    |
		8192 -> 16383                : 6        |                    |
	       16384 -> 32767                : 27       |                    |
	       32768 -> 65535                : 35       |                    |
	       65536 -> 131071               : 80       |                    |
	      131072 -> 262143               : 249      |**                  |
	      262144 -> 524287               : 701      |*******             |
	      524288 -> 1048575              : 1761     |********************|
	     1048576 -> 2097151              : 634      |*******             |
	     2097152 -> 4194303              : 28       |                    |
	     4194304 -> 8388607              : 0        |                    |
	     8388608 -> 16777215             : 0        |                    |
	    16777216 -> 33554431             : 0        |                    |
	    33554432 -> 67108863             : 0        |                    |
	    67108864 -> 134217727            : 0        |                    |
	   134217728 -> 268435455            : 0        |                    |
	   268435456 -> 536870911            : 0        |                    |
	   536870912 -> 1073741823           : 43       |                    |
	  1073741824 -> 2147483647           : 23       |                    |
	  2147483648 -> 4294967295           : 23       |                    |
	  4294967296 -> 8589934591           : 25       |                    |
	  8589934592 -> 17179869183          : 24       |                    |
	 17179869184 -> 34359738367          : 2        |                    |
	 34359738368 -> 68719476735          : 6        |                    |

-i 600 means to collect data for 600 seconds and then print the 
histogram and reset.  The latencies are in nanoseconds, so v4.8 had six 
calls that lasted between 34 and 68 seconds.

Same stats for v4.8-patched:

[04:54:22]
	       $latency                      : count     distribution
		   0 -> 1                    : 0        |                    |
		   2 -> 3                    : 0        |                    |
		   4 -> 7                    : 0        |                    |
		   8 -> 15                   : 0        |                    |
		  16 -> 31                   : 0        |                    |
		  32 -> 63                   : 0        |                    |
		  64 -> 127                  : 0        |                    |
		 128 -> 255                  : 0        |                    |
		 256 -> 511                  : 0        |                    |
		 512 -> 1023                 : 0        |                    |
		1024 -> 2047                 : 1        |                    |
		2048 -> 4095                 : 8        |                    |
		4096 -> 8191                 : 9        |                    |
		8192 -> 16383                : 23       |                    |
	       16384 -> 32767                : 48       |                    |
	       32768 -> 65535                : 73       |                    |
	       65536 -> 131071               : 164      |                    |
	      131072 -> 262143               : 245      |                    |
	      262144 -> 524287               : 393      |                    |
	      524288 -> 1048575              : 857      |*                   |
	     1048576 -> 2097151              : 14980    |********************|
	     2097152 -> 4194303              : 287      |                    |
	     4194304 -> 8388607              : 1        |                    |
	     8388608 -> 16777215             : 2        |                    |
	    16777216 -> 33554431             : 11       |                    |
	    33554432 -> 67108863             : 10       |                    |
	    67108864 -> 134217727            : 8        |                    |
	   134217728 -> 268435455            : 0        |                    |
	   268435456 -> 536870911            : 0        |                    |
	   536870912 -> 1073741823           : 152      |                    |

There are consistently more calls in the histogram on the patched 
kernel, and consistently huge stalls (30 seconds plus) in the unpatched 
kernel.

I've already written a small novel here, but I'll talk about where I got 
the command line for simoop:

simoop -t 512 -m 190 -M 128 -C 28 -r 60000 -f 70 -T 20 -R1 -W 1 -i 60 -w 
300 -D 2 /hammer/*

The box has 130GB of ram, two sockets (14 cores each) the overall goals 
are:

95-99% user CPU
200MB-500MB/s reads and writes
Filesystems 60% full
Allocation stalls between 30 and 50/sec

Allocation stalls over 100 tend to oom the box eventually.

These are the most important knobs:

-t 512 worker threads
-m 190 is the per-thread working set ram (in MB).  It's allocated once 
per thread and stays in use the whole time.

-M 128 is the allocation we time for latencies, it's freed almost right 
away.

-C 28 threads that just burn cpus.

The rest tune how much IO is done (-R, -W) and how many subthreads do 
the IO (-T).  -w 300 gives us 300 seconds of warm up time before we 
reset the stats for the long haul.

-D 2 are the du threads.  I'm sorry.

I have a few more answers for why v3.10 in prod has so many fewer 
allocation stalls than v4.0+. It's partially because some slabs have 
gotten a little bigger.  It's also because netlink started using larger 
order allocations (this is an even better story than the du threads), 
and because our stacks jumped up to 16K contiguous.

My goal in posting all of this is to help find a way to put proper 
throttling on the slab so we don't have to do synchronous waiting and IO 
in the shrinker.

As far as I can tell, simoop roughly mirrors the benefits I get from my 
one liner in production, but this is v0.000001 so there is a lot of room 
for improvement.

 -chris
