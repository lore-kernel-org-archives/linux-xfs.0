Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46385 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754769AbcJQAYo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Oct 2016 20:24:44 -0400
Date: Sun, 16 Oct 2016 20:24:33 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161017002427.GA70229@clm-mbp.masoncoding.com>
References: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
 <20161015223454.GS23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20161015223454.GS23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 16, 2016 at 09:34:54AM +1100, Dave Chinner wrote:
>On Fri, Oct 14, 2016 at 08:27:24AM -0400, Chris Mason wrote:
>>
>> Hi Dave,
>>
>> This is part of a series of patches we're growing to fix a perf
>> regression on a few straggler tiers that are still on v3.10.  In this
>> case, hadoop had to switch back to v3.10 because v4.x is as much as 15%
>> slower on recent kernels.
>>
>> Between v3.10 and v4.x, kswapd is less effective overall.  This leads
>> more and more procs to get bogged down in direct reclaim Using SYNC_WAIT
>> in xfs_reclaim_inodes_ag().
>>
>> Since slab shrinking happens very early in direct reclaim, we've seen
>> systems with 130GB of ram where hundreds of procs are stuck on the xfs
>> slab shrinker fighting to walk a slab 900MB in size.  They'd have better
>> luck moving on to the page cache instead.
>
>We've already scanned the page cache for direct reclaim by the time
>we get to running the shrinkers. Indeed, the amount of work the
>shrinkers do is directly controlled by the amount of work done
>scanning the page cache beforehand....
>
>> Also, we're going into direct reclaim much more often than we should
>> because kswapd is getting stuck on XFS inode locks and writeback.
>
>Where and what locks, exactly?

This is from v4.0, because all of my newer hosts are trying a variety of 
patched kernels.  But the traces were very similar on newer kernels:

# cat /proc/282/stack
[<ffffffff812ea2cd>] xfs_buf_submit_wait+0xbd/0x1d0
[<ffffffff812ea6e4>] xfs_bwrite+0x24/0x60
[<ffffffff812f18a4>] xfs_reclaim_inode+0x304/0x320
[<ffffffff812f1b17>] xfs_reclaim_inodes_ag+0x257/0x370
[<ffffffff812f2613>] xfs_reclaim_inodes_nr+0x33/0x40
[<ffffffff81300fb9>] xfs_fs_free_cached_objects+0x19/0x20
[<ffffffff811bb13b>] super_cache_scan+0x18b/0x190
[<ffffffff8115acc6>] shrink_slab.part.40+0x1f6/0x380
[<ffffffff8115e9da>] shrink_zone+0x30a/0x320
[<ffffffff8115f94f>] kswapd+0x51f/0x9e0
[<ffffffff810886b2>] kthread+0xd2/0xf0
[<ffffffff81770d88>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

This one hurts the most.  While kswapd is waiting for IO, all the other 
reclaim he might have been doing is backing up.

The other common path is the pag->pag_ici_reclaim_lock lock in 
xfs_reclaim_inodes_ag.  It goes through the trylock loop, didn't free 
enough, and then waits on the locks for real.

>
>> Dropping the SYNC_WAIT means that kswapd can move on to other things and
>> let the async worker threads get kicked to work on the inodes.
>
>Correct me if I'm wrong, but we introduced this shrinker behaviour
>long before 3.10. I think the /explicit/ SYNC_WAIT was added some
>time around 3.0 when I added the background async reclaim, but IIRC
>the synchronous reclaim behaviour predates that by quite a bit.

With this workload, it can take as much as a week to verify a given 
change really makes it better.  So, I'm much more focused on a high 
level view of making the MM in current kernels more efficient than I am 
in digging through each commit between v3.10 and v4.x that may be 
related.

Once I've nailed down a good list of fixes, I'll start making some tests 
to make sure they keep fixing things in the future.  I'm starting with 
obvious things:  direct reclaim is happening because kswapd isn't 
processing the lists fast enough because he's stuck in D state.

This lead to two changes.  This patch, and lowering the dirty ratios to 
make sure background writeout can keep up and kswapd doesn't have to 
call pageout().

XFS is also limiting the direct reclaim speed of all the other slabs.  
We have 15 drives, each with its own filesystem.  But end result of the 
current system is to bottleneck behind whichever FS is slowest at any 
given moment.

>
>IOWs, XFS shrinkers have the same blocking behaviour in 3.10 as they
>do in current 4.x kernels. Hence if you're getting problems with
>excessive blocking during reclaim on more recent 4.x kernels, then
>it's more likely there is a change in memory reclaim balance in the
>vmscan code that drives the shrinkers - that has definitely changed
>between 3.10 and 4.x, but the XFS shrinker behaviour has not.

Correct, I got down this path assuming that commits between v3.10 and 
4.x changed how often we're calling the xfs shrinker, even though the 
shrinker was the same.

>
>What XFS is doing is not wrong - the synchrnous behaviour is the
>primary memory reclaim feedback mechanism that prevents reclaim from
>trashing the working set of clean inodes when under memory pressure.
>It's also the choke point where we prevent lots of concurrent
>threads from trying to do reclaim at once, contending on locks
>and inodes and causing catastrophic IO breakdown because such
>reclaim results in random IO patterns for inode writeback instead of
>nice clean ascending offset ordered IO.

It's also blocking kswapd (and all the other procs directly calling 
shrinkers) on IO.  Either IO it directly issues or IO run by other 
procs.  This causes the conditions that make all the threads want to do 
reclaim at once.

>That commit (which I had to go find because you helpfully didn't
>quote it) was a7b339f1b869 ("xfs: introduce background inode reclaim
>work") introduced asynchronous background reclaim work and so made
>the reclaim function able to handle both async and sync reclaim. To
>maintain the direct reclaim throttling behaviour of the shrinker,
>that function now needed to be told to be sycnhronous, hence the
>addtion of the SYNC_WAIT. We didn't introduce sync
>reclaim with this commit in 2.6.39(!), we've had that behaviour
>since well before that. Hence if the analysis performed stopped at
>this point in history, it was flawed.

This was an RFC because I was RFCing.  We're stuffing kswapd behind 
synchronous IO, and limiting the rate at which we can reclaim pages on 
the system.  I'm happy to toss unpatched kernels into the workload and 
gather stats to hep us nail down good behaviour, but really I'm asking 
what those stats might be.

What we have now is a single synchronous shrinker taking the box over.  
Nothing happens until XFS gets its inodes down the pipe, even when there 
are a considerable number of other freeable pages on the box.

There are probably a series of other optimizations we can be making in 
the MM code around when the shrinkers are called, and how well it deals 
with the constant churn from this workload.   I want to try those too,  
but we're stuck right now on this one spot.

An over all description of the hadoop workload:

Lots of java threads, spanning 15 filesystems, 4T each.

Each thread runs an unpredictable amount of disk and network IO and uses 
massive amounts of CPU.  The threads last for unpredictable amounts of 
time.  These boxes have ~130GB of ram and two sockets of CPUs (12 cores 
per-cpu, HT enabled).  The files themselves are relatively large and are 
mostly streaming reads/writes.

-chris

