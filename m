Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58452 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751716AbcJQBx0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Oct 2016 21:53:26 -0400
Date: Mon, 17 Oct 2016 12:52:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161017015251.GU23194@dastard>
References: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
 <20161015223454.GS23194@dastard>
 <20161017002427.GA70229@clm-mbp.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161017002427.GA70229@clm-mbp.masoncoding.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 16, 2016 at 08:24:33PM -0400, Chris Mason wrote:
> On Sun, Oct 16, 2016 at 09:34:54AM +1100, Dave Chinner wrote:
> >On Fri, Oct 14, 2016 at 08:27:24AM -0400, Chris Mason wrote:
> >>
> >>Hi Dave,
> >>
> >>This is part of a series of patches we're growing to fix a perf
> >>regression on a few straggler tiers that are still on v3.10.  In this
> >>case, hadoop had to switch back to v3.10 because v4.x is as much as 15%
> >>slower on recent kernels.
> >>
> >>Between v3.10 and v4.x, kswapd is less effective overall.  This leads
> >>more and more procs to get bogged down in direct reclaim Using SYNC_WAIT
> >>in xfs_reclaim_inodes_ag().
> >>
> >>Since slab shrinking happens very early in direct reclaim, we've seen
> >>systems with 130GB of ram where hundreds of procs are stuck on the xfs
> >>slab shrinker fighting to walk a slab 900MB in size.  They'd have better
> >>luck moving on to the page cache instead.
> >
> >We've already scanned the page cache for direct reclaim by the time
> >we get to running the shrinkers. Indeed, the amount of work the
> >shrinkers do is directly controlled by the amount of work done
> >scanning the page cache beforehand....
> >
> >>Also, we're going into direct reclaim much more often than we should
> >>because kswapd is getting stuck on XFS inode locks and writeback.
> >
> >Where and what locks, exactly?
> 
> This is from v4.0, because all of my newer hosts are trying a
> variety of patched kernels.  But the traces were very similar on
> newer kernels:
> 
> # cat /proc/282/stack
> [<ffffffff812ea2cd>] xfs_buf_submit_wait+0xbd/0x1d0
> [<ffffffff812ea6e4>] xfs_bwrite+0x24/0x60
> [<ffffffff812f18a4>] xfs_reclaim_inode+0x304/0x320
> [<ffffffff812f1b17>] xfs_reclaim_inodes_ag+0x257/0x370
> [<ffffffff812f2613>] xfs_reclaim_inodes_nr+0x33/0x40
> [<ffffffff81300fb9>] xfs_fs_free_cached_objects+0x19/0x20
> [<ffffffff811bb13b>] super_cache_scan+0x18b/0x190
> [<ffffffff8115acc6>] shrink_slab.part.40+0x1f6/0x380
> [<ffffffff8115e9da>] shrink_zone+0x30a/0x320
> [<ffffffff8115f94f>] kswapd+0x51f/0x9e0
> [<ffffffff810886b2>] kthread+0xd2/0xf0
> [<ffffffff81770d88>] ret_from_fork+0x58/0x90
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> This one hurts the most.  While kswapd is waiting for IO, all the
> other reclaim he might have been doing is backing up.

Which says two things: the journal tail pushing nor the background
inode reclaim threads are keeping up with dirty inode writeback
demand. Without knowing why that is occurring, we cannot solve the
problem.

> The other common path is the pag->pag_ici_reclaim_lock lock in
> xfs_reclaim_inodes_ag.  It goes through the trylock loop, didn't
> free enough, and then waits on the locks for real.

Which is the "prevent hundreds of threads from all issuing inode
writeback concurrently" throttling. Working as designed.

> XFS is also limiting the direct reclaim speed of all the other
> slabs.  We have 15 drives, each with its own filesystem.  But end
> result of the current system is to bottleneck behind whichever FS is
> slowest at any given moment.

So why is the filesystem slow in 4.0 and not slow at all in 3.10?

And how does a 4.8 kernel compare, given there were major changes to
the mm/ subsystem in this release? i.e. are you chasing a mm/
problem that has already been solved?

> >What XFS is doing is not wrong - the synchrnous behaviour is the
> >primary memory reclaim feedback mechanism that prevents reclaim from
> >trashing the working set of clean inodes when under memory pressure.
> >It's also the choke point where we prevent lots of concurrent
> >threads from trying to do reclaim at once, contending on locks
> >and inodes and causing catastrophic IO breakdown because such
> >reclaim results in random IO patterns for inode writeback instead of
> >nice clean ascending offset ordered IO.
> 
> It's also blocking kswapd (and all the other procs directly calling
> shrinkers) on IO.  Either IO it directly issues or IO run by other
> procs.  This causes the conditions that make all the threads want to
> do reclaim at once.

Yup, that's what it's meant to do. As I keep repeating - this
behaviour is indicative of /some other problem/ occurring. If inode
writeback and reclaim is occurring efficiently and correctly, then
kswapd will not throttle like this because it will never block on
IO. And, by design, when we throttle kswapd we effectively throttle
direct reclaim, too.

> >That commit (which I had to go find because you helpfully didn't
> >quote it) was a7b339f1b869 ("xfs: introduce background inode reclaim
> >work") introduced asynchronous background reclaim work and so made
> >the reclaim function able to handle both async and sync reclaim. To
> >maintain the direct reclaim throttling behaviour of the shrinker,
> >that function now needed to be told to be sycnhronous, hence the
> >addtion of the SYNC_WAIT. We didn't introduce sync
> >reclaim with this commit in 2.6.39(!), we've had that behaviour
> >since well before that. Hence if the analysis performed stopped at
> >this point in history, it was flawed.
> 
> This was an RFC because I was RFCing.  We're stuffing kswapd behind
> synchronous IO, and limiting the rate at which we can reclaim pages
> on the system.  I'm happy to toss unpatched kernels into the
> workload and gather stats to hep us nail down good behaviour, but
> really I'm asking what those stats might be.

I can't suggest anything right now, because you haven't given me
system/workload details or concrete analysis to base any suggestions
on.

> What we have now is a single synchronous shrinker taking the box
> over.  Nothing happens until XFS gets its inodes down the pipe, even
> when there are a considerable number of other freeable pages on the
> box.
> 
> There are probably a series of other optimizations we can be making
> in the MM code around when the shrinkers are called, and how well it
> deals with the constant churn from this workload.   I want to try
> those too,  but we're stuck right now on this one spot.
> 
> An over all description of the hadoop workload:
> 
> Lots of java threads, spanning 15 filesystems, 4T each.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Things like number of allocation groups, journal size, what the
physical storage is, IO scheduler (or lack of), etc, are all
important here.

> Each thread runs an unpredictable amount of disk and network IO and
> uses massive amounts of CPU.  The threads last for unpredictable
> amounts of time.  These boxes have ~130GB of ram and two sockets of
> CPUs (12 cores per-cpu, HT enabled). The files themselves are
> relatively large and are mostly streaming reads/writes.

Again, details. meminfo, iostat, etc, details of how memory usage
and IO patterns change when everything backs up on inode reclaim,
etc are /really important/ here. I need to be able to reproduce a
similar memory imbalance myself to be able to test any solution we
come up with.

Here's some immediate questions I have from the workload
description:

	- If the workload is mostly large files and streaming reads
	  and writes, then why are there so many inodes that need
	  writeback that reclaim is getting stuck on them?
	- Why aren't the inodes getting written back regularly via
	  periodic log work (e.g. via the xfs_ail_push_all() call
	  that occur every 30s)?
	- Is there so much data IO that metadata IO is being
	  starved?
	- Why does it take a week to manifest - when does the system
	  go out of balance and is there anything in userspace that
	  changes behaviour that might trigger it?
	- Is there a behavioural step-change in the workload of
	  some threads?
	- are you running at near ENOSPC and so maybe hitting some
	  filesystem fragmentation level that causes the seek load
	  to slowly increase until there's no IOPS left in the
	  storage?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
