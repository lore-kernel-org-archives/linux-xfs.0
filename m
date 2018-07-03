Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56722 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752775AbeGCVWo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 17:22:44 -0400
Date: Tue, 3 Jul 2018 14:22:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 21/24] xfs: use ->t_dfops for rmap extent swap operations
Message-ID: <20180703212229.GQ32415@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-22-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-22-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:33PM -0400, Brian Foster wrote:
> xfs_swap_extent_rmap() uses a local dfops instance with a
> transaction from the caller. Since there is only one caller, pull
> the dfops structure into the caller and attach it to the
> transaction. This avoids the need to clear ->t_dfops to prevent
> invalid stack memory access.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2c0c9534941c..4fdf013603ab 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1570,6 +1570,8 @@ xfs_swap_extent_rmap(
>  	struct xfs_inode		*ip,
>  	struct xfs_inode		*tip)
>  {
> +	struct xfs_trans		*tp = *tpp;
> +	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_bmbt_irec		irec;
>  	struct xfs_bmbt_irec		uirec;
>  	struct xfs_bmbt_irec		tirec;
> @@ -1577,7 +1579,6 @@ xfs_swap_extent_rmap(
>  	xfs_fileoff_t			end_fsb;
>  	xfs_filblks_t			count_fsb;
>  	xfs_fsblock_t			firstfsb;
> -	struct xfs_defer_ops		dfops;
>  	int				error;
>  	xfs_filblks_t			ilen;
>  	xfs_filblks_t			rlen;
> @@ -1613,7 +1614,7 @@ xfs_swap_extent_rmap(
>  
>  		/* Unmap the old blocks in the source file. */
>  		while (tirec.br_blockcount) {
> -			xfs_defer_init(&dfops, &firstfsb);
> +			xfs_defer_init(tp->t_dfops, &firstfsb);
>  			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
>  
>  			/* Read extent from the source file */
> @@ -1635,31 +1636,32 @@ xfs_swap_extent_rmap(
>  			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
>  
>  			/* Remove the mapping from the donor file. */
> -			error = xfs_bmap_unmap_extent((*tpp)->t_mountp, &dfops,
> -					tip, &uirec);
> +			error = xfs_bmap_unmap_extent(mp, tp->t_dfops, tip,
> +					&uirec);
>  			if (error)
>  				goto out_defer;
>  
>  			/* Remove the mapping from the source file. */
> -			error = xfs_bmap_unmap_extent((*tpp)->t_mountp, &dfops,
> -					ip, &irec);
> +			error = xfs_bmap_unmap_extent(mp, tp->t_dfops, ip,
> +					&irec);
>  			if (error)
>  				goto out_defer;
>  
>  			/* Map the donor file's blocks into the source file. */
> -			error = xfs_bmap_map_extent((*tpp)->t_mountp, &dfops,
> -					ip, &uirec);
> +			error = xfs_bmap_map_extent(mp, tp->t_dfops, ip,
> +					&uirec);
>  			if (error)
>  				goto out_defer;
>  
>  			/* Map the source file's blocks into the donor file. */
> -			error = xfs_bmap_map_extent((*tpp)->t_mountp, &dfops,
> -					tip, &irec);
> +			error = xfs_bmap_map_extent(mp, tp->t_dfops, tip,
> +					&irec);
>  			if (error)
>  				goto out_defer;
>  
> -			xfs_defer_ijoin(&dfops, ip);
> -			error = xfs_defer_finish(tpp, &dfops);
> +			xfs_defer_ijoin(tp->t_dfops, ip);
> +			error = xfs_defer_finish(tpp, tp->t_dfops);
> +			tp = *tpp;
>  			if (error)
>  				goto out_defer;
>  
> @@ -1679,7 +1681,7 @@ xfs_swap_extent_rmap(
>  	return 0;
>  
>  out_defer:
> -	xfs_defer_cancel(&dfops);
> +	xfs_defer_cancel(tp->t_dfops);
>  out:
>  	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
>  	tip->i_d.di_flags2 = tip_flags2;
> @@ -1846,6 +1848,7 @@ xfs_swap_extents(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
> +	struct xfs_defer_ops	dfops;
>  	struct xfs_bstat	*sbp = &sxp->sx_stat;
>  	int			src_log_flags, target_log_flags;
>  	int			error = 0;
> @@ -1853,6 +1856,7 @@ xfs_swap_extents(
>  	struct xfs_ifork	*cowfp;
>  	uint64_t		f;
>  	int			resblks = 0;
> +	xfs_fsblock_t		firstfsb;
>  
>  	/*
>  	 * Lock the inodes against other IO, page faults and truncate to
> @@ -1915,6 +1919,8 @@ xfs_swap_extents(
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
>  	if (error)
>  		goto out_unlock;
> +	xfs_defer_init(&dfops, &firstfsb);
> +	tp->t_dfops = &dfops;

Hmm... another redundant initialization here, and extra stack usage too.

If we're going to move the dfops into struct xfs_trans I don't want this
series and that series to be split across a release with all these bits
scattered everywhere for a single release.

It's at this point I'm tempted to suggest starting this series over with
adding a new dfops to the transaction and then converting the
t_agfl_dfops and the open-coded/stack-allocated dfops to use the one
embedded in the transaction, if nothing else to avoid all this scattered
churn.

OTOH I also see that you already moved firstblock into the transaction.
I'll keep my mouth shut until I get to the end of that series because I
sense there's a lot of changes captured in those two series that would
happen even if you'd started with putting the dfops in the transaction.
Maybe you're really close to mailing out that last piece anyway.

Code otherwise looks ok, if a bit messy:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
