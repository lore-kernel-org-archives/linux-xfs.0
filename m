Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41838 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726241AbfDPMWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 08:22:45 -0400
Date: Tue, 16 Apr 2019 22:22:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
Message-ID: <20190416122240.GN29573@dread.disaster.area>
References: <20190404165737.30889-1-amir73il@gmail.com>
 <20190404211730.GD26298@dastard>
 <20190408103303.GA18239@quack2.suse.cz>
 <1554741429.3326.43.camel@suse.com>
 <20190411011117.GC29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411011117.GC29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Davidlohr Bueso <dbueso@suse.com>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Apr 11, 2019 at 11:11:17AM +1000, Dave Chinner wrote:
> On Mon, Apr 08, 2019 at 09:37:09AM -0700, Davidlohr Bueso wrote:
> > On Mon, 2019-04-08 at 12:33 +0200, Jan Kara wrote:
> > > On Fri 05-04-19 08:17:30, Dave Chinner wrote:
> > > > FYI, I'm working on a range lock implementation that should both
> > > > solve the performance issue and the reader starvation issue at the
> > > > same time by allowing concurrent buffered reads and writes to
> > > > different file ranges.
> > > 
> > > Are you aware of range locks Davidlohr has implemented [1]? It didn't get
> > > merged because he had no in-tree user at the time (he was more aiming at
> > > converting mmap_sem which is rather difficult). But the generic lock
> > > implementation should be well usable.
> > > 
> > > Added Davidlohr to CC.
> > > 
> > > 								Honza
> > > 
> > > [1] https://lkml.org/lkml/2017/3/7/22
> > 
> > fyi this was the latest version (had some naming updates per peterz).
> > 
> > https://lkml.org/lkml/2018/2/4/232
> 
> No, I wasn't aware of these because they haven't ever been posted to
> a list I subscribe to and they haven't been merged. I'll go have a
> look at them over the next few days.

Rather disappointing, to tell the truth.

The implementation doesn't scale nearly as a rwsem for concurrent IO
using shared access (i.e. XFS direct IO). That's the baseline we
need to get close to for range locks to be a viable prospect.

Fio randrw numbers on a single file on a pmem device on a 16p
machine using 4kB AIO-DIO iodepth 128 w/ fio on 5.1.0-rc3:

			IOPS read/write (direct IO)
fio processes		rwsem			rangelock
 1			78k / 78k		75k / 75k
 2			131k / 131k		123k / 123k
 4			267k / 267k		183k / 183k
 8			372k / 372k		177k / 177k
 16			315k / 315k		135k / 135k

So uncontended, non-overlapping range performance is not
really even in the ballpark right now, unfortunately.

To indicate that range locking is actually working, let's do
buffered read/write, which takes the rwsem exclusive for writes
and so will be bound by that:

			IOPS read/write (buffered IO)
fio processes		rwsem			rangelock
 1			57k / 57k		64k / 64k
 2			61k / 61k		111k / 111k
 4			61k / 61k		228k / 228k
 8			55k / 55k		195k / 195k
 16			15k / 15k		 40k /  40k

So the win for mixed buffered IO is huge but it's at the cost
of direct IO performance. We can't make that tradeoff, so if this
implementation cannot be substantially improved we really can'ti
use it.

FUndamentally, the problem is that the interval tree work is all
done under a spinlock, so by the time we get to 16p, 70% of the 16p
that is being burnt is on the spinlock, and only 30% of the CPU time
is actually doing IO work:

+   70.78%     2.50%  [kernel]             [k] do_raw_spin_lock
+   69.72%     0.07%  [kernel]             [k] _raw_spin_lock_irqsave
-   68.27%    68.10%  [kernel]             [k] __pv_queued_spin_lock_slowpath
.....
+   15.61%     0.07%  [kernel]             [k] range_write_unlock
+   15.39%     0.06%  [kernel]             [k] range_read_unlock
+   15.11%     0.12%  [kernel]             [k] range_read_lock
+   15.11%     0.13%  [kernel]             [k] range_write_lock
.....
+   12.92%     0.11%  [kernel]             [k] range_is_locked

FWIW, I'm not convinced about the scalability of the rb/interval
tree, to tell you the truth. We got rid of the rbtree in XFS for
cache indexing because the multi-level pointer chasing was just too
expensive to do under a spinlock - it's just not a cache efficient
structure for random index object storage.

FWIW, I have basic hack to replace the i_rwsem in XFS with a full
range read or write lock with my XFS range lock implementation so it
just behaves like a rwsem at this point. It is not in any way
optimised at this point. Numbers for same AIO-DIO test are:

			IOPS read/write (direct IO)
processes	rwsem		DB rangelock	XFS rangelock
 1		78k / 78k	75k / 75k	74k / 74k
 2		131k / 131k	123k / 123k	134k / 134k
 4		267k / 267k	183k / 183k	246k / 246k
 8		372k / 372k	177k / 177k	306k / 306k
 16		315k / 315k	135k / 135k	240k / 240k

Performance is much closer to rwsems, but the single lock critical
section still causes serious amounts of cacheline contention on pure
shared-read lock workloads like this.

FWIW, the XFS rangelock numbers match what I've been seeing with
userspace perf tests using unoptimised pthread mutexes - ~600,000
lock/unlock cycles a second over ~100 concurrent non-overlapping
ranges seem to be the limitation before futex contention burns down
the house

AS it is, I've done all the work to make XFS use proper range locks
on top of your patch - I'll go back tomorrow and modify the XFS
range locks to use the same API as your lock implementation. I'm
interested to see what falls out when they are used as real range
locks rather than a glorified rwsem....

Cheers,

Dave.

PS: there's a double lock bug in range_is_locked().....
-- 
Dave Chinner
david@fromorbit.com
