Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p34I3nRG178954 for <xfs@oss.sgi.com>; Mon, 4 Apr 2011 13:03:49 -0500
Subject: Re: [PATCH 3/3] xfs: exact busy extent tracking
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110331112844.596870320@bombadil.infradead.org>
References: <20110331112700.735969269@bombadil.infradead.org>
	<20110331112844.596870320@bombadil.infradead.org>
Date: Mon, 04 Apr 2011 13:06:25 -0500
Message-ID: <1301940385.2630.54.camel@doink>
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

On Thu, 2011-03-31 at 07:27 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-better-busy-extent-tracking)
> Update the extent tree in case we have to reuse a busy extent, so that it
> always is kept uptodate.  This is done by replacing the busy list searches
> with a new xfs_alloc_busy_reuse helper, which updates the busy extent tree
> in case of a reuse.  This allows us to allow reusing metadata extents
> unconditionally, and thus avoid log forces especially for allocation btree
> blocks.

I have a few comments, and it looks like there are problems again
in your logic for clipping busy extents.  (Please double-check
my conclusions.)

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_alloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-31 12:19:35.078088911 +0200
> +++ xfs/fs/xfs/xfs_alloc.c	2011-03-31 12:24:16.758203747 +0200

. . .

> @@ -2699,12 +2565,196 @@ xfs_alloc_busy_search(
>  		}
>  	}
>  	spin_unlock(&pag->pagb_lock);
> -	trace_xfs_alloc_busysearch(mp, agno, bno, len, !!match);
>  	xfs_perag_put(pag);
>  	return match;
>  }
>  
>  /*
> + * The found free extent [fbno, fend] overlaps part or all of the given busy
> + * extent.  If the overlap covers the beginning, the end, or all of the busy
> + * extent, the overlapping portion can be made unbusy and used for the
> + * allocation.  We can't split a busy extent because we can't modify a
> + * transaction/CIL context busy list, but we can update an entries block
                                                             entry's

> + * number or length.
> + *
> + * Returns true if the extent can safely be reused, or false if the search
> + * needs to be restarted.  Releases pagb_lock in the failure case.

I see why you do this (because you had to release the lock
to force the log).  But I would prefer to have the lock
get re-acquired here, so that the lock/unlock in the
caller is symmetrical there (as would be the unlock/lock
here).

> + */
> +STATIC bool
> +xfs_alloc_busy_update_extent(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag,
> +	struct xfs_busy_extent	*busyp,
> +	xfs_agblock_t		fbno,
> +	xfs_extlen_t		flen,
> +	bool			userdata)
> +{
> +	xfs_agblock_t		fend = fbno + flen;
> +	xfs_agblock_t		bbno = busyp->bno;
> +	xfs_agblock_t		bend = bbno + busyp->length;
> +
> +	/*
> +	 * If there is a busy extent verlapping a user allocation, we have
                                      overlapping

> +	 * no chance but to force the log and retry the search.
               choice

> +	 *
> +	 * Fortunately this does not happen during normal operation, but
> +	 * only if the filesystem is very low on space and has to dip into
> +	 * the AGFL for normal allocations.

. . .

> +		 * so set the length to zero to mark it invalid.
> +		 *
> +		 * We also need to restart the busy extent search from the
> +		 * tree root, as we just delete the rbtree node and thus cannot
> +		 * continue the search for other busy extents.

		 * We also need to restart the busy extent search from
		 * the tree root, because erasing the node can rearrange
		 * the rbtree.

> +		 */
> +		rb_erase(&busyp->rb_node, &pag->pagb_tree);
> +		busyp->length = 0;
> +		spin_unlock(&pag->pagb_lock);

		(As I suggested above--don't unlock here.)

> +		return false;
> +	} else if (bbno == fbno) {

	} else if (fend < bend) {

Reasoning:
1 ) We know the found free and the busy extent overlap
    (true upon entry to this function).
2)  We know the overlap does not split the busy extent.
3)  We know the busy extent is not completely covered by
    the found free extent.

Therefore the busy extent either extends beyond the found
free extent on the "Right" (i.e., toward bend/fend) or the
Left (toward bbno/fbno).

This case and the next cover those two, and in both we
are clipping out the intersection of the two extents.
In this case we're moving the start of the busy extent
up to the end of the found free extent, so the busy
extent extends beyond the Right.  Which is to say:
    (fend < bend)

> +		/*
> +		 * Case 6:
> +		 *              bbno           bend
> +		 *             +BBBBBBBBBBBBBBBBB+
> +		 *             +---------+
> +		 *             fbno   fend
> +		 *

This case (the one described here as "Case 7") does not
match the "bbno == fbno" condition.  (Message here is
that once the logic is right, make sure your diagrams
match the cases you're handling.)

> +		 * Case 7:
> +		 *             bbno           bend
> +		 *             +BBBBBBBBBBBBBBBBB+
> +		 *    +------------------+
> +		 *    fbno            fend
> +		 *
> +		 */
> +		busyp->bno = fend;
> +	} else if (bend == fend) {

	} else if (bbno < fbno) {

Reasoning is the same as above.  This is the "busy
extent starts before the found free block" case,
which is stated as (bbno < fbno).

> +		/*
> +		 * Case 8:
> +		 *    bbno           bend
> +		 *    +BBBBBBBBBBBBBBBBB+
> +		 *        +-------------+
> +		 *        fbno       fend
> +		 *

Make sure the pictures match the logic when you're done
fixing it here too.

> +		 * Case 9:
> +		 *    bbno           bend
> +		 *    +BBBBBBBBBBBBBBBBB+
> +		 *        +----------------------+
> +		 *        fbno                fend
> +		 */
> +		busyp->length = fbno - busyp->bno;
> +	} else {
> +		ASSERT(0);
> +	}
> +
> +	trace_xfs_alloc_busy_reuse(mp, pag->pag_agno, fbno, flen);
> +	return true;
> +
> +out_force_log:
> +	spin_unlock(&pag->pagb_lock);
> +	xfs_log_force(mp, XFS_LOG_SYNC);
> +	trace_xfs_alloc_busy_force(mp, pag->pag_agno, fbno, flen);

(As I suggested above, re-acquire the spinlock here.)

> +	return false;
> +}
> +
> +
> +/*
> + * For a given extent [fbno, flen], make sure we can reuse it safely.
> + */
> +void
> +xfs_alloc_busy_reuse(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		fbno,
> +	xfs_extlen_t		flen,
> +	bool			userdata)
> +{
> +	struct xfs_perag	*pag;
> +	struct rb_node		*rbp;
> +
> +	ASSERT(flen > 0);
> +
> +	pag = xfs_perag_get(mp, agno);
> +restart:
> +	spin_lock(&pag->pagb_lock);

(As I suggested above, don't re-acquire the spinlock
when restarting.)

	spin_lock(&pag->pagb_lock);
restart:
	rbp = pag->pagb_tree.rb_node;

> +	rbp = pag->pagb_tree.rb_node;
> +	while (rbp) {
> +		struct xfs_busy_extent *busyp =
> +			rb_entry(rbp, struct xfs_busy_extent, rb_node);
> +		xfs_agblock_t	bbno = busyp->bno;
> +		xfs_agblock_t	bend = bbno + busyp->length;
> +
> +		if (fbno + flen <= bbno) {
> +			rbp = rbp->rb_left;
> +			continue;
> +		} else if (fbno >= bend) {
> +			rbp = rbp->rb_right;

. . .

The rest is OK.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
