Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2MNigrB055897 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 18:44:48 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F285A36BC4A
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 16:47:31 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Dvy7vFJFadE6Iz2e for <xfs@oss.sgi.com>;
	Tue, 22 Mar 2011 16:47:31 -0700 (PDT)
Date: Wed, 23 Mar 2011 10:47:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: exact busy extent tracking
Message-ID: <20110322234728.GE15270@dastard>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.657110761@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110322200137.657110761@bombadil.infradead.org>
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

On Tue, Mar 22, 2011 at 03:55:53PM -0400, Christoph Hellwig wrote:
> Update the extent tree in case we have to reuse a busy extent, so that it
> always is kept uptodate.  This is done by replacing the busy list searches
> with a new xfs_alloc_busy_reuse helper, which updates the busy extent tree
> in case of a reuse.   Also replace setting transactions to sync with forcing
> the log out in case we found a busy extent to reuse.  This makes the code a
> lot more simple, and is required for discard support later on.  While it
> will cause performance regressios with just this patch applied, the impact
> is more than mitigated by the next patch in the series.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_alloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-20 19:41:55.835479390 +0100
> +++ xfs/fs/xfs/xfs_alloc.c	2011-03-21 14:49:14.157973188 +0100
.....
> -	new->tid = xfs_log_get_trans_ident(tp);
> -
>  	INIT_LIST_HEAD(&new->list);
>  
>  	/* trace before insert to be able to see failed inserts */
>  	trace_xfs_alloc_busy(tp, agno, bno, len, 0);
>  
>  	pag = xfs_perag_get(tp->t_mountp, new->agno);
> -restart:
>  	spin_lock(&pag->pagb_lock);
>  	rbp = &pag->pagb_tree.rb_node;
> -	parent = NULL;
> -	busyp = NULL;
> -	match = 0;
> -	while (*rbp && match >= 0) {
> +	while (*rbp) {
>  		parent = *rbp;
>  		busyp = rb_entry(parent, struct xfs_busy_extent, rb_node);
>  
>  		if (new->bno < busyp->bno) {
>  			/* may overlap, but exact start block is lower */
>  			rbp = &(*rbp)->rb_left;
> -			if (new->bno + new->length > busyp->bno)
> -				match = busyp->tid == new->tid ? 1 : -1;
> +			BUG_ON(new->bno + new->length > busyp->bno);

BUG_ON() inside a spinlock will effectively lock up the machine as
other CPUs try to take the spinlock that was held by the thread that
went bad. It causes the machine to die a horrible, undebuggable death
rather than just kill the thread that caused the oops and leaving
everything else still functional.

If it were an ASSERT(), that's probably OK because it is only debug
systems that woul dhave this problem, but the use of BUG(_ON) means
it will cause production systems to die as well.

>  		} else if (new->bno > busyp->bno) {
>  			/* may overlap, but exact start block is higher */
>  			rbp = &(*rbp)->rb_right;
> -			if (bno < busyp->bno + busyp->length)
> -				match = busyp->tid == new->tid ? 1 : -1;
> +			BUG_ON(bno < busyp->bno + busyp->length);
>  		} else {
> -			match = busyp->tid == new->tid ? 1 : -1;
> -			break;
> +			BUG();
>  		}
>  	}
> -	if (match < 0) {
> -		/* overlap marked busy in different transaction */
> -		spin_unlock(&pag->pagb_lock);
> -		xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
> -		goto restart;
> -	}
> -	if (match > 0) {
> -		/*
> -		 * overlap marked busy in same transaction. Update if exact
> -		 * start block match, otherwise combine the busy extents into
> -		 * a single range.
> -		 */
> -		if (busyp->bno == new->bno) {
> -			busyp->length = max(busyp->length, new->length);
> -			spin_unlock(&pag->pagb_lock);
> -			ASSERT(tp->t_flags & XFS_TRANS_SYNC);
> -			xfs_perag_put(pag);
> -			kmem_free(new);
> -			return;
> -		}
> -		rb_erase(&busyp->rb_node, &pag->pagb_tree);
> -		new->length = max(busyp->bno + busyp->length,
> -					new->bno + new->length) -
> -				min(busyp->bno, new->bno);
> -		new->bno = min(busyp->bno, new->bno);
> -	} else
> -		busyp = NULL;
>  
>  	rb_link_node(&new->rb_node, parent, rbp);
>  	rb_insert_color(&new->rb_node, &pag->pagb_tree);
> @@ -2650,7 +2518,6 @@ restart:
>  	list_add(&new->list, &tp->t_busy);
>  	spin_unlock(&pag->pagb_lock);
>  	xfs_perag_put(pag);
> -	kmem_free(busyp);
>  }
>  
>  /*
> @@ -2704,6 +2571,173 @@ xfs_alloc_busy_search(
>  	return match;
>  }
>  
> +STATIC int
> +xfs_alloc_busy_try_reuse(
> +	struct xfs_perag	*pag,
> +	struct xfs_busy_extent	*busyp,
> +	xfs_agblock_t		fbno,
> +	xfs_agblock_t		fend)
> +{
> +	xfs_agblock_t	bbno = busyp->bno;
> +	xfs_agblock_t	bend = bbno + busyp->length;
> +
> +	if (bbno < fbno && bend > fend) {
> +		/*
> +		 * Case 1:
> +		 *    bbno           bend
> +		 *    +BBBBBBBBBBBBBBBBB+
> +		 *        +---------+
> +		 *        fbno   fend
> +		 */
> +
> +		/*
> +		 * We would have to split the busy extent to be able
> +		 * to track it correct, which we cannot do because we
> +		 * would have to modify the list of busy extents
> +		 * attached to the transaction/CIL context, which
> +		 * is mutable.

		      immutable?

> +		 *
> +		 * Force out the log to clear the busy extents
> +		 * and retry the search.
> +		 */

BTW, these comments appear to wrap at 68 columns - any particular
reason?

> +		return -1;
> +	} else if (bbno >= fbno && bend <= fend) {
> +		/*
> +		 * Case 2:
> +		 *    bbno           bend
> +		 *    +BBBBBBBBBBBBBBBBB+
> +		 *    +-----------------+
> +		 *    fbno           fend
> +		 *
> +		 * Case 3:
> +		 *    bbno           bend
> +		 *    +BBBBBBBBBBBBBBBBB+
> +		 *    +--------------------------+
> +		 *    fbno                    fend
> +		 *
> +		 * Case 4:
> +		 *             bbno           bend
> +		 *             +BBBBBBBBBBBBBBBBB+
> +		 *    +--------------------------+
> +		 *    fbno                    fend
> +		 *
> +		 * Case 5:
> +		 *             bbno           bend
> +		 *             +BBBBBBBBBBBBBBBBB+
> +		 *    +-----------------------------------+
> +		 *    fbno                             fend
> +		 *
> +		 */
> +
> +		/*
> +		 * The busy extent is fully covered by the extent
> +		 * we are allocating, and can simply be removed from
> +		 * the rbtree.  However we cannot remove it from the
> +		 * immutable list tracking busy extents in the
> +		 * transaction or CIL context, so set the length
> +		 * to zero to mark it invalid.
> +		 */
> +		rb_erase(&busyp->rb_node, &pag->pagb_tree);
> +		busyp->length = 0;
> +	} else if (bbno == fbno) {
> +		/*
> +		 * Case 6:
> +		 *              bbno           bend
> +		 *             +BBBBBBBBBBBBBBBBB+
> +		 *             +---------+
> +		 *             fbno   fend
> +		 *
> +		 * Case 7:
> +		 *             bbno           bend
> +		 *             +BBBBBBBBBBBBBBBBB+
> +		 *    +------------------+
> +		 *    fbno            fend
> +		 *
> +		 */
> +
> +		busyp->bno = fend;
> +	} else if (bend == fend) {
> +		/*
> +		 * Case 8:
> +		 *    bbno           bend
> +		 *    +BBBBBBBBBBBBBBBBB+
> +		 *        +-------------+
> +		 *        fbno       fend
> +		 *
> +		 * Case 9:
> +		 *    bbno           bend
> +		 *    +BBBBBBBBBBBBBBBBB+
> +		 *        +----------------------+
> +		 *        fbno                fend
> +		 */
> +
> +		busyp->length = fbno - busyp->bno;
> +	} else {
> +		BUG();
> +	}
> +
> +	return 1;
> +}
> +
> +
> +/*
> + * For a given extent [fbno, flen], make sure we can reuse it safely.
> + */
> +void
> +xfs_alloc_busy_reuse(
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	xfs_agblock_t		fbno,
> +	xfs_extlen_t		flen)
> +{
> +	struct xfs_perag	*pag;
> +	struct rb_node		*rbp;
> +
> +	ASSERT(flen > 0);
> +
> +	pag = xfs_perag_get(tp->t_mountp, agno);
> +restart:
> +	spin_lock(&pag->pagb_lock);
> +	rbp = pag->pagb_tree.rb_node;
> +	while (rbp) {
> +		struct xfs_busy_extent *busyp =
> +			rb_entry(rbp, struct xfs_busy_extent, rb_node);
> +		xfs_agblock_t	fend = fbno + flen;
> +		xfs_agblock_t	bbno = busyp->bno;
> +		xfs_agblock_t	bend = bbno + busyp->length;
> +		int		overlap;
> +
> +		if (fend <= bbno) {
> +			rbp = rbp->rb_left;
> +			continue;
> +		} else if (fbno >= bend) {
> +			rbp = rbp->rb_right;
> +			continue;
> +		}
> +
> +		overlap = xfs_alloc_busy_try_reuse(pag, busyp,
> +						   fbno, fbno + flen);
> +		if (overlap) {
> +			spin_unlock(&pag->pagb_lock);
> +			xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
> +			goto restart;
> +		}

xfs_alloc_busy_try_reuse() only ever returns -1 or 1, which means
this will always trigger a log force on overlap....

> +
> +		/*
> +		 * No more busy extents to search.
> +		 */
> +		if (bbno <= fbno && bend >= fend)
> +			break;
> +
> +		if (fbno < bbno)
> +			rbp = rbp->rb_left;
> +		else
> +			rbp = rbp->rb_right;

and this code is never executed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
