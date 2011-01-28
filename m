Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S5YWLU111642 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 23:34:33 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 687001A46532
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 21:36:55 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Zh9tWO4q9lRvfCk2 for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 21:36:55 -0800 (PST)
Date: Fri, 28 Jan 2011 16:36:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: optimize xfs_alloc_fix_freelist
Message-ID: <20110128053653.GS21311@dastard>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092551.185804716@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110121092551.185804716@bombadil.infradead.org>
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

On Fri, Jan 21, 2011 at 04:22:31AM -0500, Christoph Hellwig wrote:
> If we shorten the freelist in xfs_alloc_fix_freelist there is no need
> to wait for busy blocks as they will be marked busy again when we call
> xfs_free_ag_extent.  Avoid this by not marking blocks coming from the
> freelist as busy in xfs_free_ag_extent, and not marking transactions
> with busy extents as synchronous in xfs_alloc_get_freelist.  Unlike
> xfs_free_ag_extent which already has the isfl argument,
> xfs_alloc_get_freelist needs to be told about the usage of the blocks
> it returns.  For this we extend the btreeblk flag to a type argument
> which specifies in detail what the block is going to be used for.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

(This is mostly notes I wrote as I analysed the change)

Ok, so prior to this change we added extents to the busy list:

	- unconditionally in xfs_free_ag_extent(). i.e. freeing an
	  extent back into the freespace btree
	- unconditionally in xfs_allocbt_free_block() when freeing a
	  btree block back to the freelist

And we search for busy extents in:

	- unconditionally in xfs_alloc_get_freelist()
	- unconditionally in xfs_alloc_ag_vextent()
	- unconditionally in xfs_trim_extents()

So, for blocks on the freelist, they may or may not be in the busy
list depending on whether they were placed there via
xfs_alloc_fix_freelist() or xfs_allocbt_free_block().

In the case they were put there via xfs_alloc_fix_freelist(), the
extent will not be in the busy list so this change should be a
no-op.

In the case they were put there via xfs_allocbt_free_block(), they
will already be in the busy list when we call
xfs_alloc_get_freelist() and hence the transaction will always be
marked synchronous. The change here is to avoid marking transactions
which "allocate" blocks via xfs_alloc_get_freelist() synchronous if
possible.

So, if we get a block via xfs_alloc_ag_vextent_small(), it is tagged
XFS_FREELIST_ALLOC. If we get a block via xfs_alloc_fix_freelist, it
is tagged XFS_FREELIST_BALANCE, and if we are allocating a block for
the alloc btree, it is tagged XFS_FREELIST_BTREE. If the tag is
XFS_FREELIST_BALANCE, we do not do a busy list search as we are not
actually allocating the block for use, otherwise we do the search.

Then, in xfs_free_ag_extent() itself, when the block is coming from
the freelist, we do not add it to the busy extent list as it is
already in the busy list if it is necessary for it to be there. i.e.
if a block goes freespace -> freelist -> freespace, then there is no
need for it to be marked busy.

----

Ok, I've convinced myself that the changes are sane, though I think
it could do with a bit more explaination in the changelog and a
description of what the XFS_FREELIST_* tags do where they are
declared.

Thinking through this a bit more - we don't need to do a busy search
for metadata allocations - it's only necessary for metadata -> data
extent transistions. Metadata modifications are all logged, so there
is no need to force out the busy extent transaction if the next
allocation is for metadata. If the new transaction hits the disk,
then it will only be replayed if the previous transaction to free
the extent is on the disk and has already been replayed.

Hence I think we only need to do a busy search in these cases for
XFS_FREELIST_ALLOC when args->userdata == 0. The XFS_FREELIST_BTREE
case is definitely a metadata allocation, so it seems to me that
there is further scope for optimisation here. i.e. that allocbt ->
freelist -> allocbt doesn't require a sync transaction to be issued.

The code as it stands looks good; the question is should we take
this next step as well? Have I missed anything that makes this a bad
thing to do, Christoph?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
