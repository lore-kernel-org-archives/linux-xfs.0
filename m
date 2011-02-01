Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p11Mxw45249441 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 17:00:00 -0600
Subject: Re: [PATCH 5/6] xfs: do not classify freed allocation btree blocks
	as busy
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110121092551.402449845@bombadil.infradead.org>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092551.402449845@bombadil.infradead.org>
Date: Tue, 01 Feb 2011 17:02:22 -0600
Message-ID: <1296601342.2350.129.camel@doink>
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

OK, it's taken a while but I'm finally ready to comment on
these last two patches.  I've been thinking about how these
freed blocks ought to be handled, but that's really a separate
discussion so I'll stick to the patch at hand for now.

It has a few problems.  I also think it may be making an
already a bit confusing situation possibly less obvious.
What I mean is, there are some rules we're depending on
here and those rules aren't very explicitly documented
very well in the code.  (Like, "if a btree node block
is freed it goes into the freelist, and in that case it
needs to be marked busy; normally the log will need to
be forced if that block gets reallocated later, but not
if it is getting reallocated later for use in the
allocation btree.")  It's not the nicest thing to
have to try to explain, but that means it's even
more important to do so.

I think some of the commit explanations help, but I
think the code itself ought to be more clear about
what's going on.

> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_ag.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_ag.h	2011-01-17 22:03:15.000000000 +0100
> +++ xfs/fs/xfs/xfs_ag.h	2011-01-17 22:32:06.541004201 +0100
> @@ -188,6 +188,11 @@ struct xfs_busy_extent {
>  	xfs_agblock_t	bno;
>  	xfs_extlen_t	length;
>  	xlog_tid_t	tid;		/* transaction that created this */
> +	int		flags;
> +};
> +
> +enum {
> +	XFS_BUSY_FREELIST	= 0x0001, /* busy extent on freelist from abt */

I don't really like the name here.  It emphasizes the freelist
rather than the fact that the extent was freed from the
allocation btree, which is I think the more important bit.

I think it's named this because it represents who called
xfs_alloc_busy_insert() (xfs_alloc_put_freelist(), as
opposed to xfs_free_ag_extent() which would pass 0 for
its "flags" value).  There's probably not a good concise
name to represent that call site, but I think I'd prefer
to have one rather than just passing 0.

In any case, the real distinction is whether the extent
being marked busy is a block previously used for the
allocation btree or not.

>  };
>  
>  /*
> Index: xfs/fs/xfs/xfs_alloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_alloc.c	2011-01-17 22:30:54.000000000 +0100
> +++ xfs/fs/xfs/xfs_alloc.c	2011-01-17 22:39:29.021005529 +0100

Note that there are some comments in this file that begin
with:
 * AG Busy list management
They ought to be updated to give a one-line description of
the new functions.

. . .

> @@ -1996,22 +2000,23 @@ xfs_alloc_get_freelist(
>  	xfs_alloc_log_agf(tp, agbp, logflags);
>  	*bnop = bno;
>  
> -	/*
> -	 * As blocks are freed, they are added to the per-ag busy list and
> -	 * remain there until the freeing transaction is committed to disk.
> -	 * Now that we have allocated blocks, this list must be searched to see
> -	 * if a block is being reused.  If one is, then the freeing transaction
> -	 * must be pushed to disk before this transaction.
> -	 *
> -	 * We do this by setting the current transaction to a sync transaction
> -	 * which guarantees that the freeing transaction is on disk before this
> -	 * transaction. This is done instead of a synchronous log force here so
> -	 * that we don't sit and wait with the AGF locked in the transaction
> -	 * during the log force.
> -	 */
>  	if (type != XFS_FREELIST_BALANCE) {
> -		if (xfs_alloc_busy_search(mp, agno, bno, 1))
> -			xfs_trans_set_sync(tp);
> +		/*
> +		 * If this block is marked busy we may have to force out the
> +		 * log to prevent reuse until the freeing transaction has been
> +		 * commited.
> +		 *
> +		 * If we're just allocating the block to rebalance the the
> +		 * freelist size we can skip this exercise as the block
> +		 * just keeps its busy marking while migrating to the
> +		 * allocation btree.
> +		 *
> +		 * If the block was freed from a btree and gets reallocated
> +		 * to it we may skip the log force, but details are handled
> +		 * by xfs_alloc_busy_force.
> +		 */
> +		xfs_alloc_busy_force(mp, agno, bno, 1,
> +				     type == XFS_FREELIST_BTREE);

With the "if (type...)" above and the conditional expression
being passed as the last argument here you're basically
enumerating all possible values of "type".  I think it might
look cleaner to just pass type as-is, and let xfs_alloc_busy_force()
hide this part of the logic also.

>  	}
>  
>  	return 0;

. . .

> @@ -2123,6 +2129,14 @@ xfs_alloc_put_freelist(
>  		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl),
>  		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl +
>  			sizeof(xfs_agblock_t) - 1));
> +
> +	/*
> +	 * If it's a btree block, mark it busy as it has just been freed.
> +	 * Otherwise we are just replenishing the free list with extents
> +	 * that are already free so we don't need to track them.
> +	 */
> +	if (btreeblk)
> +		xfs_alloc_busy_insert(tp, agno, bno, 1, XFS_BUSY_FREELIST);

On second thought...  You could just pass the value of btreeblk
as the last argument here and let xfs_alloc_busy_insert() decide
whether inserting it is needed or not.

>  	return 0;
>  }
>  
. . .
> @@ -2733,6 +2749,62 @@ xfs_alloc_busy_search(
>  	return match;
>  }
>  
> +STATIC void
> +xfs_alloc_busy_force(

It's a shame this and xfs_alloc_busy_search() (as well
as the *_trim() variant) can't rely on a common helper
function, since they rely on basically the same logic
for searching the tree.

> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		bno,
> +	xfs_extlen_t		len,
> +	int			btreeblk)
> +{
> +	struct xfs_perag	*pag;
> +	struct rb_node		*rbp;
> +	struct xfs_busy_extent	*busyp;
> +	int			match = 0;
> +
> +	pag = xfs_perag_get(mp, agno);
> +	spin_lock(&pag->pagb_lock);
> +
> +	rbp = pag->pagb_tree.rb_node;
> +
> +	/* find closest start bno overlap */
> +	while (rbp) {
> +		busyp = rb_entry(rbp, struct xfs_busy_extent, rb_node);
> +		if (bno < busyp->bno) {
> +			/* may overlap, but exact start block is lower */
> +			if (bno + len > busyp->bno) {
> +				match = 1;
> +				break;
> +			}
> +			rbp = rbp->rb_left;
> +		} else if (bno > busyp->bno) {
> +			/* may overlap, but exact start block is higher */
> +			if (bno < busyp->bno + busyp->length) {
> +				match = 1;
> +				break;
> +			}
> +			rbp = rbp->rb_right;
> +		} else {
> +			/* bno matches busyp, length determines exact match */
> +			match = 1;

I believe this is not sufficient.  You need to check for
an exact match.  More below.

> +			break;
> +		}
> +	}
> +
> +	if (match && btreeblk && (busyp->flags & XFS_BUSY_FREELIST)) {
> +		list_del_init(&busyp->list);

If xfs_alloc_busy_insert() finds that an extent being marked
busy abuts or overlaps an existing busy extent entry, it
combines the two.  Because of this, I think it's possible that
a busy entry found to overlap the range provided here (i.e.,
[bno, bno+len)) may contain more than just the overlapping
region.  Specifically this case will be freeing a single block,
and what I'm saying is that this single block could have been
merged with another by a different call to xfs_alloc_busy_insert().

So simply deleting the entire entry is wrong here.  You have
to see if we're in the situation I describe, and handle it
accordingly.  That gets messy, unfortunately.

This also highlights another issue with the addition of
the "flags" value to the xfs_busy_extent structure.  It
is no longer valid to simply combine two busy entries.
You only can combine them if their flag values match.
Otherwise, when combining them you could either gain
or lose flag values associated with the involved extents.

> +		rb_erase(&busyp->rb_node, &pag->pagb_tree);
> +		kmem_free(busyp);
> +		match = 0;
> +	}
> +	spin_unlock(&pag->pagb_lock);
> +	trace_xfs_alloc_busysearch(mp, agno, bno, len, !!match);
> +	xfs_perag_put(pag);
> +
> +	if (match)
> +		xfs_log_force(mp, XFS_LOG_SYNC);

I'm not sure how much difference it makes, but why can't
we just call xfs_log_force_lsn(mp, lsn, flags), where
"lsn" is the sequence number for the operation that
freed the extent that's being re-allocated.  (This
applies to the existing code as well, not just this
change.)  This suggestion also gets tricky due to
merging busy extents (similar to what I said about
"flags" above, but in this case it's the lsn).

> +}
> +
>  /*
>   * For a given extent [fbno, flen], search the busy extent list
>   * to find a subset of the extent that is no
. . .

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
