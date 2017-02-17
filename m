Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20309 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934159AbdBQQVD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2017 11:21:03 -0500
Date: Fri, 17 Feb 2017 08:20:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: simplify xfs_rtallocate_extent
Message-ID: <20170217162056.GL6813@birch.djwong.org>
References: <20170217124911.11669-1-hch@lst.de>
 <20170217124911.11669-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170217124911.11669-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 17, 2017 at 01:49:10PM +0100, Christoph Hellwig wrote:
> We can deduce the allocation type from the bno argument, and do the
> return without prod much simpler internally.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(Sending it out for 4.11 testing now...)

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 13 ++++---------
>  fs/xfs/xfs_rtalloc.c   | 24 ++++++++----------------
>  fs/xfs/xfs_rtalloc.h   |  1 -
>  3 files changed, 12 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index c1417919ab0a..890094d2a493 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -88,7 +88,6 @@ int
>  xfs_bmap_rtalloc(
>  	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
>  {
> -	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
>  	int		error;		/* error return value */
>  	xfs_mount_t	*mp;		/* mount point structure */
>  	xfs_extlen_t	prod = 0;	/* product factor for allocators */
> @@ -155,18 +154,14 @@ xfs_bmap_rtalloc(
>  	/*
>  	 * Realtime allocation, done through xfs_rtallocate_extent.
>  	 */
> -	atype = ap->blkno == 0 ?  XFS_ALLOCTYPE_ANY_AG : XFS_ALLOCTYPE_NEAR_BNO;
>  	do_div(ap->blkno, mp->m_sb.sb_rextsize);
>  	rtb = ap->blkno;
>  	ap->length = ralen;
> -	if ((error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1, ap->length,
> -				&ralen, atype, ap->wasdel, prod, &rtb)))
> -		return error;
> -	if (rtb == NULLFSBLOCK && prod > 1 &&
> -	    (error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1,
> -					   ap->length, &ralen, atype,
> -					   ap->wasdel, 1, &rtb)))
> +	error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1, ap->length,
> +				&ralen, ap->wasdel, prod, &rtb);
> +	if (error)
>  		return error;
> +
>  	ap->blkno = rtb;
>  	if (ap->blkno != NULLFSBLOCK) {
>  		ap->blkno *= mp->m_sb.sb_rextsize;
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 802bcc326d9f..c57aa7f18087 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1093,7 +1093,6 @@ xfs_rtallocate_extent(
>  	xfs_extlen_t	minlen,		/* minimum length to allocate */
>  	xfs_extlen_t	maxlen,		/* maximum length to allocate */
>  	xfs_extlen_t	*len,		/* out: actual length allocated */
> -	xfs_alloctype_t	type,		/* allocation type XFS_ALLOCTYPE... */
>  	int		wasdel,		/* was a delayed allocation extent */
>  	xfs_extlen_t	prod,		/* extent product factor */
>  	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
> @@ -1123,27 +1122,16 @@ xfs_rtallocate_extent(
>  		}
>  	}
>  
> +retry:
>  	sumbp = NULL;
> -	/*
> -	 * Allocate by size, or near another block, or exactly at some block.
> -	 */
> -	switch (type) {
> -	case XFS_ALLOCTYPE_ANY_AG:
> +	if (bno == 0) {
>  		error = xfs_rtallocate_extent_size(mp, tp, minlen, maxlen, len,
>  				&sumbp,	&sb, prod, &r);
> -		break;
> -	case XFS_ALLOCTYPE_NEAR_BNO:
> +	} else {
>  		error = xfs_rtallocate_extent_near(mp, tp, bno, minlen, maxlen,
>  				len, &sumbp, &sb, prod, &r);
> -		break;
> -	case XFS_ALLOCTYPE_THIS_BNO:
> -		error = xfs_rtallocate_extent_exact(mp, tp, bno, minlen, maxlen,
> -				len, &sumbp, &sb, prod, &r);
> -		break;
> -	default:
> -		error = -EIO;
> -		ASSERT(0);
>  	}
> +
>  	if (error)
>  		return error;
>  
> @@ -1158,7 +1146,11 @@ xfs_rtallocate_extent(
>  			xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FREXTENTS, -slen);
>  		else
>  			xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, -slen);
> +	} else if (prod > 1) {
> +		prod = 1;
> +		goto retry;
>  	}
> +
>  	*rtblock = r;
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> index 355dd9e1cb64..18c8e821a0e4 100644
> --- a/fs/xfs/xfs_rtalloc.h
> +++ b/fs/xfs/xfs_rtalloc.h
> @@ -40,7 +40,6 @@ xfs_rtallocate_extent(
>  	xfs_extlen_t		minlen,	/* minimum length to allocate */
>  	xfs_extlen_t		maxlen,	/* maximum length to allocate */
>  	xfs_extlen_t		*len,	/* out: actual length allocated */
> -	xfs_alloctype_t		type,	/* allocation type XFS_ALLOCTYPE... */
>  	int			wasdel,	/* was a delayed allocation extent */
>  	xfs_extlen_t		prod,	/* extent product factor */
>  	xfs_rtblock_t		*rtblock); /* out: start block allocated */
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
