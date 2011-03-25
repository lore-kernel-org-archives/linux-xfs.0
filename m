Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PL1DCC247045 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 16:01:13 -0500
Subject: Re: [PATCH 3/6] xfs: exact busy extent tracking
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110322200137.657110761@bombadil.infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.657110761@bombadil.infradead.org>
Date: Fri, 25 Mar 2011 16:04:20 -0500
Message-ID: <1301087060.2537.689.camel@doink>
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

On Tue, 2011-03-22 at 15:55 -0400, Christoph Hellwig wrote:
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

In this one, xfs_alloc_busy_reuse() is broken, or at least it has some
dead code in it now.  (But now that I've looked at the later patches
I see that's a temporary artifact.  I've left my original comments
in place anyway, in case any insights remain despite that.)

More below.

> Index: xfs/fs/xfs/xfs_alloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-20 19:41:55.835479390 +0100
> +++ xfs/fs/xfs/xfs_alloc.c	2011-03-21 14:49:14.157973188 +0100

. . .

> @@ -2459,100 +2459,6 @@ error0:
>  	return error;
>  }
>  
> -
> -/*
> - * AG Busy list management
> - * The busy list contains block ranges that have been freed but whose
> - * transactions have not yet hit disk.  If any block listed in a busy
> - * list is reused, the transaction that freed it must be forced to disk
> - * before continuing to use the block.
> - *
> - * xfs_alloc_busy_insert - add to the per-ag busy list
> - * xfs_alloc_busy_clear - remove an item from the per-ag busy list
> - * xfs_alloc_busy_search - search for a busy extent
> - */
> -
> -/*
> - * Insert a new extent into the busy tree.

OK, to be honest I haven't re-read this entire block of
comment text to identify what might be of value.  But
is there really *nothing* worth saving?  Is the busy
extent tree documented adequately elsewhere?

> - * The busy extent tree is indexed by the start block of the busy extent.
> - * there can be multiple overlapping ranges in the busy extent tree but only
> - * ever one entry at a given start block. The reason for this is that
> - * multi-block extents can be freed, then smaller chunks of that extent
> - * allocated and freed again before the first transaction commit is on disk.
> - * If the exact same start block is freed a second time, we have to wait for
> - * that busy extent to pass out of the tree before the new extent is inserted.
> - * There are two main cases we have to handle here.

. . .

> @@ -2583,66 +2487,30 @@ xfs_alloc_busy_insert(
>  	new->agno = agno;
>  	new->bno = bno;
>  	new->length = len;
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

This comment isn't really right any more (BUG_ON that condition).

>  			rbp = &(*rbp)->rb_left;
> -			if (new->bno + new->length > busyp->bno)
> -				match = busyp->tid == new->tid ? 1 : -1;
> +			BUG_ON(new->bno + new->length > busyp->bno);
>  		} else if (new->bno > busyp->bno) {
>  			/* may overlap, but exact start block is higher */

This one too.

>  			rbp = &(*rbp)->rb_right;
> -			if (bno < busyp->bno + busyp->length)
> -				match = busyp->tid == new->tid ? 1 : -1;
> +			BUG_ON(bno < busyp->bno + busyp->length);
>  		} else {
> -			match = busyp->tid == new->tid ? 1 : -1;
> -			break;
> +			BUG();
>  		}

. . .

> @@ -2704,6 +2571,173 @@ xfs_alloc_busy_search(
>  	return match;
>  }
>  

/*
 * The found free extent [fbno, fend] overlaps part or all
 * of the given busy extent.  If the overlap covers the
 * beginning, the end, or all of the busy extent, the
 * overlapping portion can be made unbusy and used for
 * the allocation.  We can't split a busy extent because
 * we can't modify a transaction/CIL context busy list,
 * but we can update an entry's block number or length.
 *
 * The caller will force the log and re-check the busy
 * list after returning from this function.
 */

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
> +		 *
> +		 * Force out the log to clear the busy extents
> +		 * and retry the search.

The caller forces the log.  Rely on a comment in this
function's header to say that (not here).

> +		 */
> +		return -1;
> +	} else if (bbno >= fbno && bend <= fend) {
> +		/*
> +		 * Case 2:
> +		 *    bbno           bend
> +		 *    +BBBBBBBBBBBBBBBBB+
> +		 *    +-----------------+
> +		 *    fbno           fend

. . .

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

I was going to suggest:
		/* Extent overlaps busy extent */

here, but I think that may not be the case any more if
busyp->length is zero.  Or rather, the extent may
surround the zero-length busy extent (which I suppose
could be considered overlap).

If busyp->length is zero, I think the call to
xfs_alloc_busy_try_reuse() is not needed; in fact,
if it is already 0, that function will call
rb_erase() on the entry again.

> +		overlap = xfs_alloc_busy_try_reuse(pag, busyp,
> +						   fbno, fbno + flen);

Note that xfs_alloc_busy_try_reuse() only returns 1 or -1 now...

> +		if (overlap) {

...therefore this branch is always taken, and the code
below this block to the end of the loop is not reached.

Since this is the only place it's used, xfs_alloc_busy_try_reuse()
might as well be defined as a void function.

(Ahh, but now that I've looked at the later patches
I see it gets used again later.  I'm leaving my
comments here nevertheless.)

> +			spin_unlock(&pag->pagb_lock);
> +			xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
> +			goto restart;
> +		}

+------ code starting here is never reached
|
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
|
+------ end of code not reached

> +	}
> +	spin_unlock(&pag->pagb_lock);
> +	xfs_perag_put(pag);
> +}
> +
>  /*
>   * For a given extent [fbno, flen], search the busy extent list
>   * to find a subset of the extent that is not busy.

 * If part or all of the extent is busy, force the log, then
 * verify it is no longer busy before returning.

> @@ -2889,14 +2923,12 @@ xfs_alloc_busy_clear(
>  	trace_xfs_alloc_unbusy(mp, busyp->agno, busyp->bno,
>  						busyp->length);
>  
> -	ASSERT(xfs_alloc_busy_search(mp, busyp->agno, busyp->bno,
> -						busyp->length) == 1);
> -
>  	list_del_init(&busyp->list);
>  
>  	pag = xfs_perag_get(mp, busyp->agno);
>  	spin_lock(&pag->pagb_lock);
> -	rb_erase(&busyp->rb_node, &pag->pagb_tree);
> +	if (busyp->length)
> +		rb_erase(&busyp->rb_node, &pag->pagb_tree);
>  	spin_unlock(&pag->pagb_lock);
>  	xfs_perag_put(pag);
>  

. . .



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
