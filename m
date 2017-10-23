Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18152 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdJWXcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 19:32:19 -0400
Date: Mon, 23 Oct 2017 16:32:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] xfs: add a new xfs_iext_lookup_extent_before helper
Message-ID: <20171023233215.GH5483@magnolia>
References: <20171023063017.11520-1-hch@lst.de>
 <20171023063017.11520-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171023063017.11520-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2017 at 08:30:17AM +0200, Christoph Hellwig wrote:
> This helper looks up the last extent the covers space before the passed
> in block number.  This is useful for truncate and similar operations that
> operate backwards over the extent list.  For xfs_bunmapi it also is
> a slight optimization as we can return early if there are not extents
> at or below the end of the to be truncated range.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 27 +++++++--------------------
>  fs/xfs/libxfs/xfs_inode_fork.c | 21 +++++++++++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.h |  4 ++++
>  fs/xfs/xfs_reflink.c           | 19 +++++++------------
>  4 files changed, 39 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 53ff6d92b532..b26c4ece7cbe 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1380,17 +1380,8 @@ xfs_bmap_last_before(
>  			return error;
>  	}
>  
> -	if (xfs_iext_lookup_extent(ip, ifp, *last_block - 1, &idx, &got)) {
> -		if (got.br_startoff <= *last_block - 1)
> -			return 0;
> -	}
> -
> -	if (xfs_iext_get_extent(ifp, idx - 1, &got)) {
> -		*last_block = got.br_startoff + got.br_blockcount;
> -		return 0;
> -	}
> -
> -	*last_block = 0;
> +	if (!xfs_iext_lookup_extent_before(ip, ifp, last_block, &idx, &got))
> +		*last_block = 0;
>  	return 0;
>  }
>  
> @@ -5154,17 +5145,13 @@ __xfs_bunmapi(
>  	}
>  	XFS_STATS_INC(mp, xs_blk_unmap);
>  	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
> -	end = start + len - 1;
> +	end = start + len;
>  
> -	/*
> -	 * Check to see if the given block number is past the end of the
> -	 * file, back up to the last block if so...
> -	 */
> -	if (!xfs_iext_lookup_extent(ip, ifp, end, &lastx, &got)) {
> -		ASSERT(lastx > 0);
> -		xfs_iext_get_extent(ifp, --lastx, &got);
> -		end = got.br_startoff + got.br_blockcount - 1;
> +	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &lastx, &got)) {
> +		*rlen = 0;
> +		return 0;
>  	}
> +	end--;
>  
>  	logflags = 0;
>  	if (ifp->if_flags & XFS_IFBROOT) {
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index c70f9ef07b6d..5b90f912e41a 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -1960,6 +1960,27 @@ xfs_iext_lookup_extent(
>  	return true;
>  }
>  
> +/*
> + * Returns the last extent before end, and if this extent doesn't cover
> + * end, update end to the end of the extent.
> + */
> +bool
> +xfs_iext_lookup_extent_before(
> +	struct xfs_inode	*ip,
> +	struct xfs_ifork	*ifp,
> +	xfs_fileoff_t		*end,
> +	xfs_extnum_t		*idxp,
> +	struct xfs_bmbt_irec	*gotp)
> +{
> +	if (xfs_iext_lookup_extent(ip, ifp, *end - 1, idxp, gotp) &&
> +	    gotp->br_startoff <= *end - 1)
> +		return true;
> +	if (!xfs_iext_get_extent(ifp, --*idxp, gotp))
> +		return false;
> +	*end = gotp->br_startoff + gotp->br_blockcount;
> +	return true;
> +}
> +
>  /*
>   * Return true if there is an extent at index idx, and return the expanded
>   * extent structure at idx in that case.  Else return false.
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index e0c42ea9b8d0..113fd42ec36d 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -183,6 +183,10 @@ void		xfs_iext_irec_update_extoffs(struct xfs_ifork *, int, int);
>  bool		xfs_iext_lookup_extent(struct xfs_inode *ip,
>  			struct xfs_ifork *ifp, xfs_fileoff_t bno,
>  			xfs_extnum_t *idxp, struct xfs_bmbt_irec *gotp);
> +bool		xfs_iext_lookup_extent_before(struct xfs_inode *ip,
> +			struct xfs_ifork *ifp, xfs_fileoff_t *end,
> +			xfs_extnum_t *idxp, struct xfs_bmbt_irec *gotp);
> +
>  bool		xfs_iext_get_extent(struct xfs_ifork *ifp, xfs_extnum_t idx,
>  			struct xfs_bmbt_irec *gotp);
>  void		xfs_iext_update_extent(struct xfs_inode *ip, int state,
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 37e603bf1591..1205747e1409 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -733,18 +733,13 @@ xfs_reflink_end_cow(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	/* If there is a hole at end_fsb - 1 go to the previous extent */
> -	if (!xfs_iext_lookup_extent(ip, ifp, end_fsb - 1, &idx, &got) ||
> -	    got.br_startoff > end_fsb) {
> -		/*
> -		 * In case of racing, overlapping AIO writes no COW extents
> -		 * might be left by the time I/O completes for the loser of
> -		 * the race.  In that case we are done.
> -		 */
> -		if (idx <= 0)
> -			goto out_cancel;
> -		xfs_iext_get_extent(ifp, --idx, &got);
> -	}
> +	/*
> +	 * In case of racing, overlapping AIO writes no COW extents might be
> +	 * left by the time I/O completes for the loser of the race.  In that
> +	 * case we are done.
> +	 */
> +	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &idx, &got))
> +		goto out_cancel;
>  
>  	/* Walk backwards until we're out of the I/O range... */
>  	while (got.br_startoff + got.br_blockcount > offset_fsb) {
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
