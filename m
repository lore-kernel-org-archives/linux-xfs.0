Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932125AbcJQRxB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 13:53:01 -0400
Date: Mon, 17 Oct 2016 13:52:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/9] xfs: optimize xfs_reflink_cancel_cow_blocks
Message-ID: <20161017175259.GI12736@bfoster.bfoster>
References: <1476521554-1894-1-git-send-email-hch@lst.de>
 <1476521554-1894-8-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476521554-1894-8-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Sat, Oct 15, 2016 at 10:52:32AM +0200, Christoph Hellwig wrote:
> Rewrite xfs_reflink_cancel_cow_blocks so that we only do a search for
> the first extent in the extent list and then iterate over the remaining
> extents using the extent index, passing the extent we operate on
> directly to xfs_bmap_del_extent_delay or xfs_bmap_del_extent_cow instead
> of going through xfs_bunmapi and doing yet another extent list lookup.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c | 51 +++++++++++++++++++++++----------------------------
>  1 file changed, 23 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index f33f737..7979d46 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -512,53 +512,49 @@ xfs_reflink_cancel_cow_blocks(
>  	xfs_fileoff_t			offset_fsb,
>  	xfs_fileoff_t			end_fsb)
>  {
> -	struct xfs_bmbt_irec		irec;
> -	xfs_filblks_t			count_fsb;
> +	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> +	struct xfs_bmbt_irec		got, prev, del;
> +	xfs_extnum_t			idx;
>  	xfs_fsblock_t			firstfsb;
>  	struct xfs_defer_ops		dfops;
> -	int				error = 0;
> -	int				nimaps;
> +	int				error = 0, eof = 0;
>  
>  	if (!xfs_is_reflink_inode(ip))
>  		return 0;
>  
> -	/* Go find the old extent in the CoW fork. */
> -	while (offset_fsb < end_fsb) {
> -		nimaps = 1;
> -		count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
> -		error = xfs_bmapi_read(ip, offset_fsb, count_fsb, &irec,
> -				&nimaps, XFS_BMAPI_COWFORK);
> -		if (error)
> -			break;
> -		ASSERT(nimaps == 1);
> +	xfs_bmap_search_extents(ip, offset_fsb, XFS_COW_FORK, &eof, &idx,
> +			&got, &prev);
> +	if (eof)
> +		return 0;
>  
> -		trace_xfs_reflink_cancel_cow(ip, &irec);
> +	while (got.br_startoff < end_fsb) {
> +		del = got;
> +		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
> +		trace_xfs_reflink_cancel_cow(ip, &del);
>  
> -		if (irec.br_startblock == DELAYSTARTBLOCK) {
> -			/* Remove the mapping from the CoW fork. */
> -			error = xfs_bunmapi_cow(ip, &irec);
> +		if (isnullstartblock(del.br_startblock)) {
> +			error = xfs_bmap_del_extent_delay(ip, XFS_COW_FORK,
> +					&idx, &got, &del);
>  			if (error)
>  				break;
> -		} else if (irec.br_startblock == HOLESTARTBLOCK) {
> -			/* empty */
>  		} else {
>  			xfs_trans_ijoin(*tpp, ip, 0);
>  			xfs_defer_init(&dfops, &firstfsb);
>  
>  			/* Free the CoW orphan record. */
>  			error = xfs_refcount_free_cow_extent(ip->i_mount,
> -					&dfops, irec.br_startblock,
> -					irec.br_blockcount);
> +					&dfops, del.br_startblock,
> +					del.br_blockcount);
>  			if (error)
>  				break;
>  
>  			xfs_bmap_add_free(ip->i_mount, &dfops,
> -					irec.br_startblock, irec.br_blockcount,
> +					del.br_startblock, del.br_blockcount,
>  					NULL);
>  
>  			/* Update quota accounting */
>  			xfs_trans_mod_dquot_byino(*tpp, ip, XFS_TRANS_DQ_BCOUNT,
> -					-(long)irec.br_blockcount);
> +					-(long)del.br_blockcount);
>  
>  			/* Roll the transaction */
>  			error = xfs_defer_finish(tpp, &dfops, ip);
> @@ -568,13 +564,12 @@ xfs_reflink_cancel_cow_blocks(
>  			}
>  
>  			/* Remove the mapping from the CoW fork. */
> -			error = xfs_bunmapi_cow(ip, &irec);
> -			if (error)
> -				break;
> +			xfs_bmap_del_extent_cow(ip, &idx, &got, &del);
>  		}
>  
> -		/* Roll on... */
> -		offset_fsb = irec.br_startoff + irec.br_blockcount;
> +		if (++idx >= ifp->if_bytes / sizeof(struct xfs_bmbt_rec))
> +			return 0;
> +		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &got);
>  	}
>  
>  	return error;
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
