Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0RNHjhF047580 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 17:17:45 -0600
Subject: Re: [PATCH 3/6] xfs: do not immediately reuse busy extent ranges
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110121092550.933551564@bombadil.infradead.org>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092550.933551564@bombadil.infradead.org>
Date: Thu, 27 Jan 2011 17:20:06 -0600
Message-ID: <1296170406.7651.523.camel@doink>
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
> Every time we reallocate a busy extent, we cause a synchronous log force
> to occur to ensure the freeing transaction is on disk before we continue
> and use the newly allocated extent.  This is extremely sub-optimal as we
> have to mark every transaction with blocks that get reused as synchronous.
> 
> Instead of searching the busy extent list after deciding on the extent to
> allocate, check each candidate extent during the allocation decisions as
> to whether they are in the busy list.  If they are in the busy list, we
> trim the busy range out of the extent we have found and determine if that
> trimmed range is still OK for allocation. In many cases, this check can
> be incorporated into the allocation extent alignment code which already
> does trimming of the found extent before determining if it is a valid
> candidate for allocation.
> 
> [hch: merged two earlier patches from Dave and fixed various bugs]
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

You know, I must really not be looking at this right, because
the way I am interpreting your xfs_alloc_busy_search_trim(),
it's just plain wrong.  Perhaps it arrives at an OK result
anyway, but please take a look to see if I'm just confused.

I have a few other comments, not as important.

Generally the rest of it looks good.

I'll pick up with the rest of the series tomorrow.

					-Alex


> Index: xfs/fs/xfs/xfs_alloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_alloc.c	2011-01-17 22:05:27.146004341 +0100
> +++ xfs/fs/xfs/xfs_alloc.c	2011-01-18 13:04:30.239023407 +0100

. . .

> @@ -2654,6 +2730,71 @@ xfs_alloc_busy_search(
>  	return match;
>  }
>  
> +/*
> + * For a given extent [fbno, flen], search the busy extent list
> + * to find a subset of the extent that is not busy.
> + */
> +void
> +xfs_alloc_busy_search_trim(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag,
> +	xfs_agblock_t		fbno,
> +	xfs_extlen_t		flen,
> +	xfs_agblock_t		*rbno,
> +	xfs_extlen_t		*rlen)
> +{
> +	struct rb_node		*rbp;
> +	xfs_agblock_t           bno = fbno;
> +	xfs_extlen_t            len = flen;
> +

I don't know if it's important, but you could ASSERT(flen > 0) here.

> +	spin_lock(&pag->pagb_lock);
> +	rbp = pag->pagb_tree.rb_node;
> +	while (rbp) {

	while (rbp && len) {

> +		struct xfs_busy_extent *busyp =
> +			rb_entry(rbp, struct xfs_busy_extent, rb_node);
> +		xfs_agblock_t	end = bno + len;
> +		xfs_agblock_t	bend = busyp->bno + busyp->length;
> +
> +		if (bno + len <= busyp->bno) {
> +			rbp = rbp->rb_left;
> +			continue;
> +		} else if (bno >= busyp->bno + busyp->length) {
> +			rbp = rbp->rb_right;
> +			continue;
> +		}
> +
> +		if (busyp->bno < bno) {
> +			/* start overlap */
> +			ASSERT(bend >= bno);
			ASSERT(bend > bno);

> +			ASSERT(bend <= end);
> +			len -= bno - bend;
       NO:		len -= bend - bno;

> +			bno = bend;
> +		} else if (bend > end) {
> +			/* end overlap */
> +			ASSERT(busyp->bno >= bno);
> +			ASSERT(busyp->bno < end);
> +			len -= bend - end;
       NO:		len -= end - busyp->bn;

> +		} else {
> +			/* middle overlap - return larger segment */
> +			ASSERT(busyp->bno >= bno);
> +			ASSERT(bend <= end);
> +			len = busyp->bno - bno;
> +			if (len >= end - bend) {
> +				/* use first segment */
> +				len = len;
> +			} else {
> +				/* use last segment */
> +				bno = bend;
> +				len = end - bend;
> +			}

 			/* Use the first segment... */
			len = busp->bno - bno;
			if (len < end - bend) {
				/* unless the second is larger */
				bno = bend;
				len = end - bend;
			}


> +		}
> +	}
> +	spin_unlock(&pag->pagb_lock);
> +
> +	*rbno = bno;
> +	*rlen = len;
> +}
> +
>  void
>  xfs_alloc_busy_clear(
>  	struct xfs_mount	*mp,

. . .
 
> Index: xfs/fs/xfs/linux-2.6/xfs_discard.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_discard.c	2011-01-17 22:06:13.004005040 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_discard.c	2011-01-17 22:14:09.133005668 +0100
> @@ -77,8 +77,8 @@ xfs_trim_extents(
>  	 * enough to be worth discarding.
>  	 */
>  	while (i) {
> -		xfs_agblock_t fbno;
> -		xfs_extlen_t flen;
> +		xfs_agblock_t	fbno, tbno;
> +		xfs_extlen_t	flen, tlen;

Does "f" represent "found" and "t" represent "trimmed" here?
(Just curious--it's fine.)

>  
>  		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
>  		if (error)
> @@ -90,7 +90,7 @@ xfs_trim_extents(
>  		 * Too small?  Give up.
>  		 */
>  		if (flen < minlen) {
> -			trace_xfs_discard_toosmall(mp, agno, fbno, flen);
> +			trace_xfs_discard_toosmall(mp, agno, tbno, flen);
"tbno" appears to be possibly used before set here.  At this point
don't you actually want the found block number anyway?

>  			goto out_del_cursor;
>  		}
>  

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
