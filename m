Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35957 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731985AbfDRDKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 23:10:18 -0400
Date: Thu, 18 Apr 2019 13:10:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
Message-ID: <20190418031013.GX29573@dread.disaster.area>
References: <20190404165737.30889-1-amir73il@gmail.com>
 <20190404211730.GD26298@dastard>
 <20190408103303.GA18239@quack2.suse.cz>
 <1554741429.3326.43.camel@suse.com>
 <20190411011117.GC29573@dread.disaster.area>
 <20190416122240.GN29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416122240.GN29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Davidlohr Bueso <dbueso@suse.com>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Apr 16, 2019 at 10:22:40PM +1000, Dave Chinner wrote:
> On Thu, Apr 11, 2019 at 11:11:17AM +1000, Dave Chinner wrote:
> > On Mon, Apr 08, 2019 at 09:37:09AM -0700, Davidlohr Bueso wrote:
> > > On Mon, 2019-04-08 at 12:33 +0200, Jan Kara wrote:
> > > > On Fri 05-04-19 08:17:30, Dave Chinner wrote:
> > > > > FYI, I'm working on a range lock implementation that should both
> > > > > solve the performance issue and the reader starvation issue at the
> > > > > same time by allowing concurrent buffered reads and writes to
> > > > > different file ranges.
> > > > 
> > > > Are you aware of range locks Davidlohr has implemented [1]? It didn't get
> > > > merged because he had no in-tree user at the time (he was more aiming at
> > > > converting mmap_sem which is rather difficult). But the generic lock
> > > > implementation should be well usable.
> > > > 
> > > > Added Davidlohr to CC.
.....
> Fio randrw numbers on a single file on a pmem device on a 16p
> machine using 4kB AIO-DIO iodepth 128 w/ fio on 5.1.0-rc3:
> 
> 			IOPS read/write (direct IO)
> fio processes		rwsem			rangelock
>  1			78k / 78k		75k / 75k
>  2			131k / 131k		123k / 123k
>  4			267k / 267k		183k / 183k
>  8			372k / 372k		177k / 177k
>  16			315k / 315k		135k / 135k
....

> FWIW, I'm not convinced about the scalability of the rb/interval
> tree, to tell you the truth. We got rid of the rbtree in XFS for
> cache indexing because the multi-level pointer chasing was just too
> expensive to do under a spinlock - it's just not a cache efficient
> structure for random index object storage.

Yeah, definitely not convinced an rbtree is the right structure
here. Locking of the tree is the limitation....

> FWIW, I have basic hack to replace the i_rwsem in XFS with a full
> range read or write lock with my XFS range lock implementation so it
> just behaves like a rwsem at this point. It is not in any way
> optimised at this point. Numbers for same AIO-DIO test are:

Now the stuff I've been working on has the same interface as
Davidlohr's patch, so I can swap and change them without thinking
about it. It's still completely unoptimised, but:

			IOPS read/write (direct IO)
processes	rwsem		DB rangelock	XFS rangelock
 1		78k / 78k	75k / 75k	72k / 72k
 2		131k / 131k	123k / 123k	133k / 133k
 4		267k / 267k	183k / 183k	237k / 237k
 8		372k / 372k	177k / 177k	265k / 265k
 16		315k / 315k	135k / 135k	228k / 228k

It's still substantially faster than the interval tree code.

BTW, if I take away the rwsem serialisation altogether, this
test tops out at just under 500k/500k at 8 threads, and at 16
threads has started dropping off (~440k/440k). So the rwsem is
a scalability limitation at just 8 threads....

/me goes off and thinks more about adding optimistic lock coupling
to the XFS iext btree to get rid of the need for tree-wide
locking altogether

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
