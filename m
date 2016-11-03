Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:50659 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754885AbcKCXA1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2016 19:00:27 -0400
Date: Fri, 4 Nov 2016 10:00:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [rfe]: finobt option separable from crc option? (was [rfc]
 larger batches for crc32c)
Message-ID: <20161103230018.GC28177@dastard>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
 <20161027214244.GO14023@dastard>
 <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
 <20161028160218.1af40906@roar.ozlabs.ibm.com>
 <20161031030853.GK22126@dastard>
 <20161101143918.4f154154@roar.ozlabs.ibm.com>
 <20161101054725.GZ14023@dastard>
 <58194CF8.1000501@tlinx.org>
 <20161103082950.GJ9920@dastard>
 <581B601A.4060403@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <581B601A.4060403@tlinx.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "L.A. Walsh" <xfs@tlinx.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 03, 2016 at 09:04:42AM -0700, L.A. Walsh wrote:
> 
> 
> Dave Chinner wrote:
> >
> >As most users never have things go wrong, all they think is "CRCs
> >are unnecessary overhead". It's just like backups - how many people
> >don't make backups because they cost money right now and there's no
> >tangible benefit until something goes wrong which almost never
> >happens?
> ----
> 	But it's not like backups.  You can't run a util
> program upon discovering bad CRC's that will fix the file system
> because the file system is no longer usable.

xfs_repair will fix it, just like it will fix the same corruption
on non-CRC filesystems.

> >Exactly my point. Humans are terrible at risk assessment and
> >mitigation because most people are unaware of the unconcious
> >cognitive biases that affect this sort of decision making.
> ---
> 	My risk is near 0 since my file systems are monitored
> by a raid controller with read patrols made over the data on
> a period basis.

If I had a dollar for every time someone said "hardware raid
protects me" I'd have retired years ago.

Media scrubbing does not protect against misdirected writes,
corruptions to/from the storage, memory errors, software bugs, bad
compilers (yes, we've already had XFS CRCs find a compiler bug),
etc.

> I'll assert that the chance of data randomly
> going corrupt is much higher because there is ALOT more data than
> metadata.  On top of that, because I keep backups, my risk, is
> at worst, the same without crc's as with them.

The /scale of disaster/ for metadata corruption is far higher than
for file data - a single bit error can trash the entire filesystem.

You may not care about this, but plenty of other XFS users do.

> i.e. the finobt provides more
> >deterministic inode allocation overhead, not "faster" allocation.
> >
> >Let me demonstrate with some numbers on empty filesystem create
> >rate:
> >
> >			create rate	sys CPU time	write rate
> >			(files/s)	(seconds)	  (MB/s)
> >crc = 0, finobt = 0:	238943		  2629		 ~200
> >crc = 1, finobt = 0:	231582		  2711		  ~40
> >crc = 1, finobt = 1:	232563		  2766		  ~40
> >*hacked* crc disable:   231435	  2789		  ~40
> 
> 
> >We can see that the system CPU time increased by 3.1% with the
> >"addition of CRCs".  The CPU usage increases by a further 2% with
> >the addition of the free inode btree,
> ---
> 	On an empty file system or older ones that are >50%
> used?
>
> It's *nice* to be able to benchmarks, but not allowing
> crc to be disabled, disables that possibility -- and that's
> sorta the point. 

If you want to reproduce the above numbers, the script is below.
You don't need the "CRC disable" hack to test whether CRCs have
overhead or not, CPU profiles are sufficient for that. But, really,
I don't care about whether you can reproduce these tests, because
microbenchmarks don't matter to production systems.

That is,, you haven't provided any numbers to back up your
assertions that CRCs have excessive overhead for /your workload/.
For me to care about what you are saying, you need to demonstrate a
performance degradation between v4 and v5 filesystem formats for
/your workloads/.

I can't do this for you. I don't know what your workload is, nor
what hardware you use.  *Give me numbers* that I can work with -
something we can measure and fix. You need to do the work to show
there's an issue - I can't do that for you, and no amount of
demanding that I do will change that.

> >IOWs, for most workloads CRCs have no impact on filesystem
> >performance.
> ---
> 	Too bad no one can test such the effect on their
> own workloads, though if not doing crc's takes more CPU, then
> it sounds like an algorithm problem: crc calculations don't
> take "negative time", and a benchmark showing they do indicates
> something else is causing the slowdown.

I'm guessing that you aren't aware of how memory access patterns
affect performance on modern CPUs. i.e. sequential memory access to
a structure is much faster than random meory access becase the
hardware prefetchers detect the sequential accesses and minimises
cache miss latency.

e.g. for a typical 4k btree block, doing a binary search on a cache
cold block requires 10-12 cache misses for complete search. However,
if we run a CRC check on it, we take a couple of cache misses before
the hardware prefetcher kicks in then it's just CPU time to run the
calc. Then the binary search doesn't have a cache miss at all. Hence
if the CRC calc is fast enough (and for h/w accel it is fast enough)
adding CRCs will make the code run faster....

This is actually a well known behaviour of modern CPUs - for
years we've been using memset() to initialise structures when it's
technically not necessary because it's the fastest way to prime the
CPU caches for upcoming accesses to that structure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

#!/bin/bash

QUOTA=
MKFSOPTS=
NFILES=100000
DEV=/dev/vdc
LOGBSIZE=256k

while [ $# -gt 0 ]; do
	case "$1" in
	-q)	QUOTA="uquota,gquota,pquota" ;;
	-N)	NFILES=$2 ; shift ;;
	-d)	DEV=$2 ; shift ;;
	-l)	LOGBSIZE=$2; shift ;;
	--)	shift ; break ;;
	esac
	shift
done
MKFSOPTS="$MKFSOPTS $*"

echo QUOTA=$QUOTA
echo MKFSOPTS=$MKFSOPTS
echo DEV=$DEV

sudo umount /mnt/scratch > /dev/null 2>&1
sudo mkfs.xfs -f $MKFSOPTS $DEV
sudo mount -o nobarrier,logbsize=$LOGBSIZE,$QUOTA $DEV /mnt/scratch
sudo chmod 777 /mnt/scratch
cd /home/dave/src/fs_mark-3.3/
sudo sh -c "echo 1 > /proc/sys/fs/xfs/stats_clear"
time ./fs_mark  -D  10000  -S0  -n  $NFILES  -s  0  -L  32 \
	-d  /mnt/scratch/0  -d  /mnt/scratch/1 \
	-d  /mnt/scratch/2  -d  /mnt/scratch/3 \
	-d  /mnt/scratch/4  -d  /mnt/scratch/5 \
	-d  /mnt/scratch/6  -d  /mnt/scratch/7 \
	-d  /mnt/scratch/8  -d  /mnt/scratch/9 \
	-d  /mnt/scratch/10  -d  /mnt/scratch/11 \
	-d  /mnt/scratch/12  -d  /mnt/scratch/13 \
	-d  /mnt/scratch/14  -d  /mnt/scratch/15 \
	| tee >(stats --trim-outliers | tail -1 1>&2)
sync
sudo umount /mnt/scratch
