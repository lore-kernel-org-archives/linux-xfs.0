Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33549 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751381AbdKCQd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 12:33:58 -0400
Date: Fri, 3 Nov 2017 09:33:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/21] xfs: pass an on-disk extent to
 xfs_bmbt_validate_extent
Message-ID: <20171103163354.GK4911@magnolia>
References: <20171103144539.2187-1-hch@lst.de>
 <20171103144539.2187-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103144539.2187-10-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 03, 2017 at 05:45:27PM +0300, Christoph Hellwig wrote:
> This prepares for getting rid of the current in-memory extent format.
> At the end of the series we will change the calling convention again
> to pass the xfs_bmbt_irec structure once it is available everywhere.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 6 +++---
>  fs/xfs/libxfs/xfs_bmap_btree.h | 4 ++--
>  fs/xfs/libxfs/xfs_inode_fork.c | 9 ++++-----
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 62270b871d06..8ce7bf19916f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1260,14 +1260,14 @@ xfs_iread_extents(
>  		frp = XFS_BMBT_REC_ADDR(mp, block, 1);
>  		for (j = 0; j < num_recs; j++, i++, frp++) {
>  			xfs_bmbt_rec_host_t *trp = xfs_iext_get_ext(ifp, i);
> -			trp->l0 = be64_to_cpu(frp->l0);
> -			trp->l1 = be64_to_cpu(frp->l1);
> -			if (!xfs_bmbt_validate_extent(mp, whichfork, trp)) {
> +			if (!xfs_bmbt_validate_extent(mp, whichfork, frp)) {
>  				XFS_ERROR_REPORT("xfs_bmap_read_extents(2)",
>  						 XFS_ERRLEVEL_LOW, mp);
>  				error = -EFSCORRUPTED;
>  				goto out_brelse;
>  			}
> +			trp->l0 = be64_to_cpu(frp->l0);
> +			trp->l1 = be64_to_cpu(frp->l1);
>  			trace_xfs_read_extent(ip, i, state, _THIS_IP_);
>  		}
>  		xfs_trans_brelse(tp, bp);
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> index 6f891eeb88f6..2fbfe2a24b15 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> @@ -127,9 +127,9 @@ extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
>   * Check that the extent does not contain an invalid unwritten extent flag.
>   */
>  static inline bool xfs_bmbt_validate_extent(struct xfs_mount *mp, int whichfork,
> -		struct xfs_bmbt_rec_host *ep)
> +		struct xfs_bmbt_rec *ep)
>  {
> -	if (ep->l0 >> (64 - BMBT_EXNTFLAG_BITLEN) == 0)
> +	if (get_unaligned_be64(&ep->l0) >> (64 - BMBT_EXNTFLAG_BITLEN) == 0)
>  		return true;
>  	if (whichfork == XFS_DATA_FORK &&
>  	    xfs_sb_version_hasextflgbit(&mp->m_sb))
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index bb63f38b97cc..abe601b48c9c 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -371,13 +371,13 @@ xfs_iformat_extents(
>  		dp = (xfs_bmbt_rec_t *) XFS_DFORK_PTR(dip, whichfork);
>  		for (i = 0; i < nex; i++, dp++) {
>  			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
> -			ep->l0 = get_unaligned_be64(&dp->l0);
> -			ep->l1 = get_unaligned_be64(&dp->l1);
> -			if (!xfs_bmbt_validate_extent(mp, whichfork, ep)) {
> +			if (!xfs_bmbt_validate_extent(mp, whichfork, dp)) {
>  				XFS_ERROR_REPORT("xfs_iformat_extents(2)",
>  						 XFS_ERRLEVEL_LOW, mp);
>  				return -EFSCORRUPTED;
>  			}
> +			ep->l0 = get_unaligned_be64(&dp->l0);
> +			ep->l1 = get_unaligned_be64(&dp->l1);
>  			trace_xfs_read_extent(ip, i, state, _THIS_IP_);
>  		}
>  	}
> @@ -764,8 +764,6 @@ xfs_iextents_copy(
>  	for (i = 0; i < nrecs; i++) {
>  		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
>  
> -		ASSERT(xfs_bmbt_validate_extent(ip->i_mount, whichfork, ep));
> -
>  		start_block = xfs_bmbt_get_startblock(ep);
>  		if (isnullstartblock(start_block)) {
>  			/*
> @@ -779,6 +777,7 @@ xfs_iextents_copy(
>  		/* Translate to on disk format */
>  		put_unaligned_be64(ep->l0, &dp->l0);
>  		put_unaligned_be64(ep->l1, &dp->l1);
> +		ASSERT(xfs_bmbt_validate_extent(ip->i_mount, whichfork, dp));
>  
>  		dp++;
>  		copied++;
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
