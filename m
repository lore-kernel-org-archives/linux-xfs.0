Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55217 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752018AbcJOXHe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Oct 2016 19:07:34 -0400
Date: Sun, 16 Oct 2016 09:34:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag
 during slab reclaim
Message-ID: <20161015223454.GS23194@dastard>
References: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06aade22-b29e-f55e-7f00-39154f220aa6@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 14, 2016 at 08:27:24AM -0400, Chris Mason wrote:
> 
> Hi Dave,
> 
> This is part of a series of patches we're growing to fix a perf
> regression on a few straggler tiers that are still on v3.10.  In this
> case, hadoop had to switch back to v3.10 because v4.x is as much as 15%
> slower on recent kernels.
> 
> Between v3.10 and v4.x, kswapd is less effective overall.  This leads
> more and more procs to get bogged down in direct reclaim Using SYNC_WAIT
> in xfs_reclaim_inodes_ag().
> 
> Since slab shrinking happens very early in direct reclaim, we've seen
> systems with 130GB of ram where hundreds of procs are stuck on the xfs
> slab shrinker fighting to walk a slab 900MB in size.  They'd have better
> luck moving on to the page cache instead.

We've already scanned the page cache for direct reclaim by the time
we get to running the shrinkers. Indeed, the amount of work the
shrinkers do is directly controlled by the amount of work done
scanning the page cache beforehand....

> Also, we're going into direct reclaim much more often than we should
> because kswapd is getting stuck on XFS inode locks and writeback.

Where and what locks, exactly?

> Dropping the SYNC_WAIT means that kswapd can move on to other things and
> let the async worker threads get kicked to work on the inodes.

Correct me if I'm wrong, but we introduced this shrinker behaviour
long before 3.10. I think the /explicit/ SYNC_WAIT was added some
time around 3.0 when I added the background async reclaim, but IIRC
the synchronous reclaim behaviour predates that by quite a bit.

IOWs, XFS shrinkers have the same blocking behaviour in 3.10 as they
do in current 4.x kernels. Hence if you're getting problems with
excessive blocking during reclaim on more recent 4.x kernels, then
it's more likely there is a change in memory reclaim balance in the
vmscan code that drives the shrinkers - that has definitely changed
between 3.10 and 4.x, but the XFS shrinker behaviour has not.

What XFS is doing is not wrong - the synchrnous behaviour is the
primary memory reclaim feedback mechanism that prevents reclaim from
trashing the working set of clean inodes when under memory pressure.
It's also the choke point where we prevent lots of concurrent
threads from trying to do reclaim at once, contending on locks
and inodes and causing catastrophic IO breakdown because such
reclaim results in random IO patterns for inode writeback instead of
nice clean ascending offset ordered IO.

This happens to be exactly the situation you are describing -
hundreds of processes all trying to run inode reclaim concurrently,
which if we don't block will repaid trash the clean inode cache
leaving only the dirty inodes around.

Hence to remove the SYNC_WAIT simply breaks the overload prevention
and throttling feedback mechanisms the XFS inode shrinker uses to
maintain performance under severe memory pressure.

> We're still working on the series, and this is only compile tested on
> current Linus git.  I'm working out some better simulations for the
> hadoop workload to stuff into Mel's tests.  Numbers from prod take
> roughly 3 days to stabilize, so I haven't isolated this patch from the rest
> of the series.
> 
> Unpatched v4.x our base allocation stall rate goes up to as much as
> 200-300/sec, averaging 70/sec.  The series I'm finalizing gets that
> number down to < 1 /sec.

That doesn't mean you've 'fixed' the problem. AFAICT you're just
disconnecting memory allocation from the rate at which inode reclaim
can clean and reclaim inodes. Yes, direct reclaim stalls will go
away, but that doesn't speed up inode reclaim, nor does it do
anything to prevent random inode writeback patterns. With the amount
of memory your machines have, removing SYNC_WAIT will simply hide
the problem by leaving the inodes dirty until journal pressure
forces the inode to be cleaned and then the background reclaimer can
free it. In general, that doesn't work particularly well because
journals can index more dirty objects that can be easily cached in
memory, and that's why we have to drive IO and throttle direct
reclaim.

> Omar Sandoval did some digging and found you added the SYNC_WAIT in
> response to a workload I sent ages ago. 

That commit (which I had to go find because you helpfully didn't
quote it) was a7b339f1b869 ("xfs: introduce background inode reclaim
work") introduced asynchronous background reclaim work and so made
the reclaim function able to handle both async and sync reclaim. To
maintain the direct reclaim throttling behaviour of the shrinker,
that function now needed to be told to be sycnhronous, hence the
addtion of the SYNC_WAIT. We didn't introduce sync
reclaim with this commit in 2.6.39(!), we've had that behaviour
since well before that. Hence if the analysis performed stopped at
this point in history, it was flawed.

> I tried to make this OOM with
> fsmark creating empty files, and it has been soaking in memory
> constrained workloads in production for almost two weeks.

That workload reclaims mostly from the background worker because
a) the majority of allocations are GFP_NOFS and so the inode
shrinker doesn't run very often, b) inode allocation is sequential
so inode writeback optimises into large sequential writes, not slow
random writes, c) it generates significant journal pressure so
drives inode writeback through tail-pushing the journal, and d)
sequential, ascending order inode allocation and inode writeback
optimisations means reclaim rarely comes across dirty inodes because
it reclaims inodes in the same order they are allocated and cleaned.

I'm sure there's a solution to whatever problem is occurring at FB,
but you're going to need to start by describing the problems and
documenting the analysis so we can understand what the problem is
before we start discussion potential solutions. It seems that the
problem is excessive direct reclaim concurrency and XFS throttling
concurrency back to the maximum the underlying filesystem can
optimise sanely, but nobody has explained why that is happening on
4.x and not 3.10.

i.e. We need to clearly understand the root cause of the problem
before we discuss potential solutions. Changes to long standing (and
unchanged) behaviours might end up being the fix, but it's not
something we'll do without first understanding the problem or
exploring other potential solutions...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
