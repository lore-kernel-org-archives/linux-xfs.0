Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Jun 2007 16:47:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l56NleWt018353
	for <xfs@oss.sgi.com>; Wed, 6 Jun 2007 16:47:42 -0700
Date: Thu, 7 Jun 2007 09:47:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Reducing memory requirements for high extent xfs files
Message-ID: <20070606234723.GC86004887@sgi.com>
References: <200705301649.l4UGnckA027406@oss.sgi.com> <20070530225516.GB85884050@sgi.com> <4665E276.9020406@agami.com> <20070606013601.GR86004887@sgi.com> <4666EC56.9000606@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4666EC56.9000606@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Wed, Jun 06, 2007 at 10:18:14AM -0700, Michael Nishimoto wrote:
> David Chinner wrote:
> >On Tue, Jun 05, 2007 at 03:23:50PM -0700, Michael Nishimoto wrote:
> >> When using NFS over XFS, slowly growing files (can be ascii log files)
> >> tend to fragment quite a bit.
> >
> >Oh, that problem.
.....
> >And so XFS truncates the allocation beyond EOF on close. Hence
> >the next write requires a new allocation and that results in
> >a non-contiguous file because the adjacent blocks have already
> >been used....
> >
> Yes, we diagnosed this same issue.
> 
> >Options:
> >
> >        1 NFS server open file cache to avoid the close.
> >        2 add detection to XFS to determine if the called is
> >          an NFS thread and don't truncate on close.
> >        3 use preallocation.
> >        4 preallocation on the file once will result in the
> >          XFS_DIFLAG_PREALLOC being set on the inode and it
> >          won't truncate on close.
> >        5 append only flag will work in the same way as the
> >          prealloc flag w.r.t preventing truncation on close.
> >        6 run xfs_fsr
> >
> We have discussed doing number 1.

So has the community - there may even be patches floating around...

> The problem with number 2,
> 3, 4, & 5 is that we ended up with a bunch of files which appeared
> to leak space.  If the truncate isn't done at file close time, the extra
> space sits around forever.

That's not a problem for slowly growing log files - they will
eventually use the space.

I'm not saying that the truncate should be avoided on all files,
just the slow growing ones that get fragmented....

> >However, I think we should be trying to fix the root cause of this
> >worst case fragmentation rather than trying to make the rest of the
> >filesystem accommodate an extreme corner case efficiently.  i.e.
> >let's look at the test cases and determine what piece of logic we
> >need to add or remove to prevent this cause of fragmentation.

> I guess there are multiple ways to look at this problem.  I have been
> going under the assumption that xfs' inability to handle a large number
> of extents is the root cause.

Fair enough.

> When a filesystem is full, defragmentation
> might not be possible.

Yes, that's true.

> Also, should we consider a file with 1MB extents as
> fragmented?  A 100GB file with 1MB extents has 100k extents.

Yes, that's fragmented - it has 4 orders of magnitude more extents
than optimal - and the extents are too small to allow reads or
writes to acheive full bandwidth on high end raid configs....

> As disks
> and, hence, filesystems get larger, it's possible to have a larger number
> of such files in a filesystem.

Yes. But as disks get larger, there's more space available from which
to allocate contiguous ranges and so that sort of problem is less
likely to occur (until filesytsem gets full).

> I still think that trying to not fragment up front is required as well 
> as running
> xfs_fsr, but I don't think those alone can be a complete solution.
> 
> Getting back to the original question, has there ever been serious thought
> in what it might take to handle large extent files?

Yes, I've thought about it from a relatively high level, but enough
to indicate real problems that breed complexity.

> What might be involved
> with trying to page extent blocks?

 - Rewriting all of the incore extent handling code to support missing
   extent ranges (currently uses deltas from the previous block for
   file offset).
 - changing the bmap btree code to convert to incore, uncompressed format
   on a block by block basis rather than into a global table
 - add code to demand read the extent list
   	- needs to use cursors to pin blocks in memory while doing traversals
	- needs to work in ENOMEM conditions
 - convert xfs_buf.c to be able to use mempools for both xfs_buf_t and block
   dev page cache so that we can read blocks when ENOMEM in the writeback
   path
 - convert in-core extent structures to use mempools so we can read blocks
   when -ENOMEM in the writeback path
 - any new allocated structures will also have to use mempools
 - add memory shaker interfaces
 
> I'm most concerned about the potential locking consequences and streaming
> performance implications.

In reality, the worst problem is writeback at ENOMEM. Who cares about
locking and performance if it's fundamentally unworkable when the
machine is out of memory?

Even using mempools we may not be able to demand page extent blocks
safely in all cases. This is my big worry about it, and the more I
thought about it, the less that demand paging made sense - it gets
horrendously complex when you have to start playing by mempool rules
and given that the lifetime of modified buffers is determined by the
log and AIL flushing behaviour we have serious problems guaranteeing
when objects would be returned to the mempool. This is a showstopper
issue, IMO. I'm happy to be proven wrong, but it looks *extremely*
messy and complex at this point....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
