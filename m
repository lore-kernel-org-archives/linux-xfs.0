Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Aug 2008 18:12:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7I1CQJG010885
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 18:12:27 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D235E3A897A
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 18:13:45 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 4CEyRsX1XkOSsFkp for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 18:13:45 -0700 (PDT)
Date: Mon, 18 Aug 2008 11:13:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/7] RFC: combine linux and XFS inodes
Message-ID: <20080818011340.GI19760@disturbed>
References: <1218698083-11226-1-git-send-email-david@fromorbit.com> <20080814194550.GA12237@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814194550.GA12237@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Aug 14, 2008 at 03:45:50PM -0400, Christoph Hellwig wrote:
> On Thu, Aug 14, 2008 at 05:14:36PM +1000, Dave Chinner wrote:
> > However, this means the linux inodes are unhashed, which means we
> > now need to do our own tracking of dirty state. We do this by
> > hooking ->dirty_inode and ->set_page_dirty to move the inode to the
> > superblock dirty list when appropriate. We also need to hook
> > ->drop_inode to ensure we do writeback of dirty inodes during
> > reclaim. In future, this can be moved entirely into XFS based on
> > radix tree tags to track dirty inodes instead of a separate list.
> 
> This part (patches 1, 2 and 3) is horrible, and I think avoidable.

Yeah, it's not pretty in it's initial form.

> We can just insert the inode into the Linux inode hash anyway, even
> if we never use it later.

Ok, that will avoid the writeback bits, However it doesn't avoid
the need for these hooks - the next 3 patches after this add dirty
tagging to the inode radix trees via ->dirty_inode and
->set_page_dirty, then use that for inode writeback clustering.

> That avoids these whole three patches
> and all the duplication of core code inside XFS, including the
> inode_lock issue and the potential problem of getting out of sync
> when the core code is updated.

The adding of the inode to the superblock dirty lists is only
temporary - with the tracking of dirty inodes in the radix trees
we can clean inodes much more effectively ourselves than pdflush
can because we know what are optimal write patterns and pdflush
doesn't...

As for cleaning the inode in ->drop_inode, I was planning on
letting reclaim handle the dirty inode case for both linked and
unlinked inodes so that we can batch the data and inode writeback
and move it out of the direct VM reclaim path. That is, allow the
shrinker simply to mark inodes for reclaim, then allow XFS to batch
the work as efficiently as possible in the background...

> If you really, really want to avoid inserting the inode into the Linux
> inode cache (and that would need a sound reason) the way to go would
> be to remove the assumptions of no writeback for unhashed inodes form
> the core code and replace it with a flag that's normally set/cleared
> during hashing/unhashing but could also be set/cleared from XFS.

As I mentioned above, I'm looking to remove the writeback of inodes
almost completely out of the VFS hands and tightly integrate it into
the internal structures of XFS.

e.g. to avoid problems like synchronous RMW cycles on inode cluster
buffers we need to move to a multi-stage writeback infrastructure
that the VFS simply cannot support at the moment. I'd like to get
that structure in place before considering promoting it at the VFS
level. Basically we need:

	pass 1: collect inodes to be written
	pass 2: extract inodes with data and sort into optimal data
		writeback order, issue data async data writes
	pass 3: issue async readahead and pin all inode cluster
		buffers to be written in memory.
	pass 4: if sync flush, wait for all data writeback to
		complete. Force the log (async) to unpin all inodes
		that allocations have been done on.
	pass 5: write all inodes back to buffers and issue async.
	pass 6: if sync flush, wait for inode writeback to complete.

And of course, this can be done in parallel across multiple AGs at
once.  With dirty tagging in the radix tree we have all the
collection, sorting and parallel access infrstrastructure we need
already in place....

FWIW, the inode sort and cluster readahead pass can make 3-4 orders
of magnitude difference in inode writeback speeds under workloads
that span a large number of files on systems with limited memory
(think typical NFS servers).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
