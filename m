Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0SMFVxF176283 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 16:15:31 -0600
Subject: Re: [PATCH 5/6] xfs: do not classify freed allocation btree blocks
	as busy
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110121092551.402449845@bombadil.infradead.org>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092551.402449845@bombadil.infradead.org>
Date: Fri, 28 Jan 2011 16:17:56 -0600
Message-ID: <1296253076.2342.284.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Fri, 2011-01-21 at 04:22 -0500, Christoph Hellwig wrote:
> During an allocation or freeing of an extent, we occasionally have an
> interesting situation happen during a btree update.  We may merge a block
> as part of a record delete, then allocate it again immediately afterwards
> when inserting a modified extent.  xfs_alloc_fixup_trees() does this sort
> of manipulation to the btrees, and so can merge then immediately split
> the tree resulting the in the same busy block being used from the
> freelist.

Methinks someone must have observed this stuff by tracing...

> Previously, this would trigger a synchronous log force of the entire log
> (as the current transaction had a lsn of 0 until committed), but continue
> to allow the extent to be used because if it is not on disk now then it
> must have been freed and marked busy in this transaction.

This could explain a mysterious slowdown I was looking at
a while ago.

> In the case of allocbt blocks, we log the fact that they get moved to the
> freelist and we also log them when the move off the free list back into
> the free space trees.  When we move the blocks off the freelist back to
> the trees, we mark the extent busy at that point so that it doesn't get
> reused until the transaction is committed.
> 
> This means that as long as the block is on the AGFL and is only used
> for allocbt blocks, we don't have to force the log to ensure prior
> manipulating transactions are on disk as the process of log recovery
> will replay the transactions in the correct order.
> 
> However, we still need to protect against the fact that as we approach
> ENOSPC in an AG we can allocate data and metadata blocks direct from the
> AGFL. In this case, we need to treat btree blocks just like any other
> busy extent. Hence we still need to track btree blocks in the busy extent
> tree, but we need to distinguish them from normal extents so we can apply
> the necessary exceptions for btree block allocation.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Sorry, this ended up being a pretty pointless note...
I see what you're doing here but have not completed
my detailed review.  I also have read Dave's comments
and I think he's right that what the block is being
allocated *for* (metadata or data) determines whether
the log force is required.

Anyway, I need to go now unfortunately.  I'll try to
finish reviewing this and the last one by Monday.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
