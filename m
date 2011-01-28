Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S6V0Wt123419 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 00:31:01 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64548154A148
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 22:33:23 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qx5ErwGSHfqzekFt for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 22:33:23 -0800 (PST)
Date: Fri, 28 Jan 2011 17:33:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: do not classify freed allocation btree blocks
	as busy
Message-ID: <20110128063320.GU21311@dastard>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092551.402449845@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110121092551.402449845@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jan 21, 2011 at 04:22:32AM -0500, Christoph Hellwig wrote:
> During an allocation or freeing of an extent, we occasionally have an
> interesting situation happen during a btree update.  We may merge a block
> as part of a record delete, then allocate it again immediately afterwards
> when inserting a modified extent.  xfs_alloc_fixup_trees() does this sort
> of manipulation to the btrees, and so can merge then immediately split
> the tree resulting the in the same busy block being used from the
> freelist.
> 
> Previously, this would trigger a synchronous log force of the entire log
> (as the current transaction had a lsn of 0 until committed), but continue
> to allow the extent to be used because if it is not on disk now then it
> must have been freed and marked busy in this transaction.
> 
> In the case of allocbt blocks, we log the fact that they get moved to the
> freelist and we also log them when the move off the free list back into
> the free space trees.  When we move the blocks off the freelist back to
> the trees, we mark the extent busy at that point so that it doesn't get
> reused until the transaction is committed.

I'm not sure this is correct - it's when they are put on the
freelist that they are marked busy (xfs_allocbt_free_block), and
with the previous patch they now don't get marked busy when freed
back to the trees.

> This means that as long as the block is on the AGFL and is only used
> for allocbt blocks, we don't have to force the log to ensure prior
> manipulating transactions are on disk as the process of log recovery
> will replay the transactions in the correct order.

I think that as long as the busy extent is reallocated as metadata
of any kind, it does not require us to force the log/mark the
transaction synchronous. That is, the metadata modifications will
not be written to the extent until the allocation transaction has
hit the disk regardless of whether we force the log here or not.
Hence log recovery will always do the right thing here.

It's the metadata -> data extent re-allocation that we need the
protecion for, as we cannot serialise data extent writes against log
recovery requirements. That is, we have no idea if the data extent
contents have been written or not when we run log recovery, so we
cannot allow data to be written until we are certain that that the
data extent allocation overrides all the recorded metadata changes
in the log.

For data -> metadata reallocation, this is not a problem as we know
the metadata writes will not be done (and therefore overwrite the
data on disk) until the transactions are on disk and the metadata
buffers unpinned. The same goes for metadata->metadata reallocation.

Hence I don't think we specifically need to track allocbt blocks in
the busy list - we track all freed blocks like we currently do, but
we only need to search the busy block list and mark transactions
synchronous for data extent allocations.

This removes the complexity of removing busy allocbt blocks from the
busy tree when they get reused - if they remain allocated they will
be removed from the tree as transactions/checkpoints are committed
to disk just like they currently are. That also avoids the problem
of a transaction commit trying to remove a busy extent from the
tree that isn't in there anymore or potential races based around
transactions adding and removing busy blocks that log IO completion
will be trying to remove.

Does this make sense? I understand this code a lot better than I did
when I originally wrote these patches, and to tell the truth I can't
remember exactly why I took this approach. Looking over the patches
makes me think that I was trying to do the minimum possible semantic
change to solve the specific problem I was seeing, rather than
understanding the entire workings of the busy extent list and how to
optimise from there...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
