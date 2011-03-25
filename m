Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PL1Va4247137 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 16:01:31 -0500
Subject: Re: [PATCH 4/6] xfs: allow reusing busy extents where safe
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110322200137.837735220@bombadil.infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.837735220@bombadil.infradead.org>
Date: Fri, 25 Mar 2011 16:04:39 -0500
Message-ID: <1301087079.2537.690.camel@doink>
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
> Allow reusing any busy extent for metadata allocations, and reusing busy
> userdata extents for userdata allocations.  Most of the complexity is
> propagating the userdata information from the XFS_BMAPI_METADATA flag
> to xfs_bunmapi into the low-level extent freeing routines.  After that
> we can just track what type of busy extent we have and treat it accordingly.

Why is it OK to reuse user data extents for user data allocations?
I accept it is, I just haven't worked through in my mind why.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_alloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-21 14:49:14.000000000 +0100
> +++ xfs/fs/xfs/xfs_alloc.c	2011-03-21 14:51:31.746155282 +0100
> @@ -1396,7 +1396,8 @@ xfs_alloc_ag_vextent_small(
>  		if (error)
>  			goto error0;
>  		if (fbno != NULLAGBLOCK) {
> -			xfs_alloc_busy_reuse(args->tp, args->agno, fbno, 1);
> +			xfs_alloc_busy_reuse(args->tp, args->agno, fbno, 1,
> +					     args->userdata);
>  
>  			if (args->userdata) {
>  				xfs_buf_t	*bp;
> @@ -2431,7 +2432,8 @@ int				/* error */
>  xfs_free_extent(
>  	xfs_trans_t	*tp,	/* transaction pointer */
>  	xfs_fsblock_t	bno,	/* starting block number of extent */
> -	xfs_extlen_t	len)	/* length of extent */
> +	xfs_extlen_t	len,
> +	bool		userdata)/* length of extent */

	xfs_extlen_t	len,	/* length of extent */
	bool		userdata)

>  {
>  	xfs_alloc_arg_t	args;
>  	int		error;

. . .


> @@ -2717,7 +2723,7 @@ restart:		(in xfs_alloc_busy_reuse())
>  
>  		overlap = xfs_alloc_busy_try_reuse(pag, busyp,
>  						   fbno, fbno + flen);
> -		if (overlap) {
> +		if (overlap == -1 || (overlap && userdata)) {

xfs_alloc_busy_try_reuse() (still) never returns non-zero,
so this could just be:
    if (overlap == -1 || userdata) {

I understand why we can skip forcing the log if
we're not doing a userdata allocation.  But why
don't you also check busyp->flags here when it's
a userdata allocation, to see if it represents a
busy userdata section and therefore would allow
avoiding the log force (like is done below in
xfs_alloc_busy_trim())?  You would have to grab
the flag value in busyp before the call.

>  			spin_unlock(&pag->pagb_lock);
>  			xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
>  			goto restart;
> @@ -2754,6 +2760,7 @@ xfs_alloc_busy_trim(
>  
>  	ASSERT(flen > 0);
>  
> +restart:
>  	spin_lock(&args->pag->pagb_lock);
>  	rbp = args->pag->pagb_tree.rb_node;
>  	while (rbp && flen >= args->minlen) {
> @@ -2771,6 +2778,31 @@ xfs_alloc_busy_trim(
>  			continue;
>  		}
>  
> +		if (!args->userdata ||
> +		    (busyp->flags & XFS_ALLOC_BUSY_USERDATA)) {
> +			int overlap;
> +
> +			overlap = xfs_alloc_busy_try_reuse(args->pag, busyp,
> +							   fbno, fbno + flen);
> +			if (unlikely(overlap == -1)) {
> +				spin_unlock(&args->pag->pagb_lock);
> +				xfs_log_force(args->mp, XFS_LOG_SYNC);
> +				goto restart;
> +			}
> +
> +			/*
> +			 * No more busy extents to search.
> +			 */
> +			if (bbno <= fbno && bend >= fend)
> +				goto out;
> +
> +			if (fbno < bbno)
> +				rbp = rbp->rb_left;
> +			else
> +				rbp = rbp->rb_right;
> +			continue;
> +		}
> +
>  		if (bbno <= fbno) {
>  			/* start overlap */
>  

. . .

> Index: xfs/fs/xfs/xfs_ag.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_ag.h	2011-03-21 14:48:04.000000000 +0100
> +++ xfs/fs/xfs/xfs_ag.h	2011-03-21 14:49:21.941981228 +0100

. . .

> @@ -3750,6 +3744,7 @@ xfs_bmap_add_free(
>  	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
>  	new->xbfi_startblock = bno;
>  	new->xbfi_blockcount = (xfs_extlen_t)len;
> +	new->xbfi_flags = XFS_BFI_USERDATA;

Couldn't you arrange for the the xfs_bmbt_free_block() path
to *not* set this?  (As it stands, it will always be set.)

>  	for (prev = NULL, cur = flist->xbf_first;
>  	     cur != NULL;
>  	     prev = cur, cur = cur->xbfi_next) {

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
