Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48150 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbeGDAzv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:55:51 -0400
Date: Tue, 3 Jul 2018 17:55:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 23/25] xfs: use ->t_firstblock in extent swap
Message-ID: <20180704005537.GW32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-24-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-24-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:17PM -0400, Brian Foster wrote:
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 6d2baf51fec9..96810bea07fd 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1569,7 +1569,6 @@ xfs_swap_extent_rmap(
>  	xfs_fileoff_t			offset_fsb;
>  	xfs_fileoff_t			end_fsb;
>  	xfs_filblks_t			count_fsb;
> -	xfs_fsblock_t			firstfsb;
>  	int				error;
>  	xfs_filblks_t			ilen;
>  	xfs_filblks_t			rlen;
> @@ -1605,7 +1604,7 @@ xfs_swap_extent_rmap(
>  
>  		/* Unmap the old blocks in the source file. */
>  		while (tirec.br_blockcount) {
> -			xfs_defer_init(tp, tp->t_dfops, &firstfsb);
> +			xfs_defer_init(tp, tp->t_dfops, &tp->t_firstblock);
>  			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
>  
>  			/* Read extent from the source file */
> @@ -1847,7 +1846,6 @@ xfs_swap_extents(
>  	struct xfs_ifork	*cowfp;
>  	uint64_t		f;
>  	int			resblks = 0;
> -	xfs_fsblock_t		firstfsb;
>  
>  	/*
>  	 * Lock the inodes against other IO, page faults and truncate to
> @@ -1910,7 +1908,7 @@ xfs_swap_extents(
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
>  	if (error)
>  		goto out_unlock;
> -	xfs_defer_init(tp, &dfops, &firstfsb);
> +	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  
>  	/*
>  	 * Lock and join the inodes to the tansaction so that transaction commit
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
