Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52519 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbfDTXyT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Apr 2019 19:54:19 -0400
Date: Sun, 21 Apr 2019 09:54:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
Message-ID: <20190420235412.GY29573@dread.disaster.area>
References: <20190404165737.30889-1-amir73il@gmail.com>
 <20190404211730.GD26298@dastard>
 <20190408103303.GA18239@quack2.suse.cz>
 <1554741429.3326.43.camel@suse.com>
 <20190411011117.GC29573@dread.disaster.area>
 <20190416122240.GN29573@dread.disaster.area>
 <20190418031013.GX29573@dread.disaster.area>
 <1555611694.18313.12.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1555611694.18313.12.camel@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Davidlohr Bueso <dbueso@suse.com>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Apr 18, 2019 at 11:21:34AM -0700, Davidlohr Bueso wrote:
> On Thu, 2019-04-18 at 13:10 +1000, Dave Chinner wrote:
> > Now the stuff I've been working on has the same interface as
> > Davidlohr's patch, so I can swap and change them without thinking
> > about it. It's still completely unoptimised, but:
> > 
> > 			IOPS read/write (direct IO)
> > processes	rwsem		DB rangelock	XFS
> > rangelock
> >  1		78k / 78k	75k / 75k	72k / 72k
> >  2		131k / 131k	123k / 123k	133k / 133k
> >  4		267k / 267k	183k / 183k	237k / 237k
> >  8		372k / 372k	177k / 177k	265k / 265k
> >  16		315k / 315k	135k / 135k	228k / 228k
> > 
> > It's still substantially faster than the interval tree code.
> 
> In general another big difference between both rangelock vs rwsems
> (when comparing them with full ranges) is that the latter will do
> writer optimistic spinning, so saving a context switch under the right
> scenarios provides mayor wins for rwsems -- I'm not sure if this
> applies to your fio tests, though. And pretty soon readers will also do
> this, hence rwsem will become a try-hard-not-to-sleep lock.

Right, the optimistic spin-on-owner behaviour basically causes both
rwsems and mutexes to behave as spin locks under these fio workloads
until all CPUs are spinning at 100% CPU usage before they even start
to behave like a sleeping lock. Essentailly, when I'm using the XFS
range locks as "full range only" rwsem equivalent locks, they end up
behaving like rwsems in terms of spinning on the tree mutex as the
single read-lock range is shared between all concurrent readers and
so has relatively low lookup and modification cost.

If I optmised the record update, it would be even closer to the
rwsem performance, but full range read locks are going to be rare.
Hell, even conflicting lock ranges are going to be rare in the IO
path, because the application is doing something very wrong if it is
doing overlapping concurrent IOs....

> One of the reasons why I was hesitant with Btrees was the fact that
> insertion requires memory allocation, something I wanted to avoid...

Yup, that's an issue, and one of the reasons why I've used a mutex
for the tree lock rather than a spin lock. But in the end, there's
no difference to CPU usage on contention as they both act as spin
locks in these cases...

If it becomes an issue, I'll add a mempool for the tree nodes and
make sure that it is pre-populated sufficiently before starting a
multi-level tree modification.

> per your numbers, sacrificing tree depth was the wrong choice. Thanks
> for sharing these numbers.

Yeah, anything that pointer chases through cachelines and dirties
multiple cachelines on rebalance really doesn't scale for a
fast-lookup structure. For btrees multi-level split/merge hurt, but
for the lookup and simple insert/remove case the cacheline miss cost
is substantially amortised by packing multiple records per
cacheline.

> > BTW, if I take away the rwsem serialisation altogether, this
> > test tops out at just under 500k/500k at 8 threads, and at 16
> > threads has started dropping off (~440k/440k). So the rwsem is
> > a scalability limitation at just 8 threads....
> > 
> > /me goes off and thinks more about adding optimistic lock coupling
> > to the XFS iext btree to get rid of the need for tree-wide
> > locking altogether
> 
> I was not aware of this code.

It's relatively new, and directly tailored to the needs of caching
the XFS extent tree - it's not really a generic btree in that it's
record store format is the XFS on-disk extent record. i.e. it
only stores 54 bits of start offset and 21 bits of length in it's 16
byte records, and the rest of the space is for the record data.

As such, I'm not really implementing a generic range lock - it is
highly tailored to the requirements and constraints of XFS
filesystem IO. e.g. using max(block size, PAGE_SIZE) granularity
range indexing means we can support maximum IO sizes (4GB) with 21
bits of length in the record.  And RANGE_LOCK_FULL is implemented as
length = MAXEXTLEN + a hidden state bit so it supports exclusive
locking from (start, RANGE_LOCK_FULL) and things like truncate, EOF
zeroing use this to exclude IO from the range they are working on
correctly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
