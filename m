Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39337 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdH2SNS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 14:13:18 -0400
Date: Tue, 29 Aug 2017 11:13:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/8] xfs: switch xfs_bmap_local_to_extents to use
 xfs_iext_insert
Message-ID: <20170829181313.GW4757@magnolia>
References: <20170829174835.2218-1-hch@lst.de>
 <20170829174835.2218-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829174835.2218-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 07:48:29PM +0200, Christoph Hellwig wrote:
> Use the helper instead of open coding it, to provide a better abstraction
> for the scalable extent list work.  This also gets an additional assert
> and trace point for free.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 502f531e4634..bbde43c99323 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -880,7 +880,7 @@ xfs_bmap_local_to_extents(
>  	xfs_ifork_t	*ifp;		/* inode fork pointer */
>  	xfs_alloc_arg_t	args;		/* allocation arguments */
>  	xfs_buf_t	*bp;		/* buffer for extent block */
> -	xfs_bmbt_rec_host_t *ep;	/* extent record pointer */
> +	struct xfs_bmbt_irec rec;
>  
>  	/*
>  	 * We don't want to deal with the case of keeping inode data inline yet.
> @@ -943,9 +943,12 @@ xfs_bmap_local_to_extents(
>  	xfs_bmap_local_to_extents_empty(ip, whichfork);
>  	flags |= XFS_ILOG_CORE;
>  
> -	xfs_iext_add(ifp, 0, 1);
> -	ep = xfs_iext_get_ext(ifp, 0);
> -	xfs_bmbt_set_allf(ep, 0, args.fsbno, 1, XFS_EXT_NORM);
> +	rec.br_startoff = 0;
> +	rec.br_startblock = args.fsbno;
> +	rec.br_blockcount = 1;
> +	rec.br_state = XFS_EXT_NORM;
> +	xfs_iext_insert(ip, 0, 1, &rec, 0);
> +
>  	trace_xfs_bmap_post_update(ip, 0,
>  			whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0,
>  			_THIS_IP_);
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
