Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30935 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932126AbdJWPlZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 11:41:25 -0400
Date: Mon, 23 Oct 2017 08:41:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfs: remove xfs_bmbt_validate_extent
Message-ID: <20171023154119.GC5483@magnolia>
References: <20171023063017.11520-1-hch@lst.de>
 <20171023063017.11520-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171023063017.11520-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2017 at 08:30:15AM +0200, Christoph Hellwig wrote:
> We have stop supporting file systems without unwritten extent bit support
> a long time ago, so remove the debug code for it which will get in the way
> of future changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       |  8 +-------
>  fs/xfs/libxfs/xfs_bmap_btree.h | 14 --------------
>  fs/xfs/libxfs/xfs_inode_fork.c |  7 -------
>  3 files changed, 1 insertion(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 46813b71dd74..19ec8b1f99dd 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1166,8 +1166,7 @@ xfs_bmap_add_attrfork(
>  /*
>   * Read in the extents to if_extents.
>   * All inode fields are set up by caller, we just traverse the btree
> - * and copy the records in. If the file system cannot contain unwritten
> - * extents, the records are checked for no "state" flags.
> + * and copy the records in.
>   */
>  int					/* error */
>  xfs_bmap_read_extents(
> @@ -1255,11 +1254,6 @@ xfs_bmap_read_extents(
>  			xfs_bmbt_rec_host_t *trp = xfs_iext_get_ext(ifp, i);
>  			trp->l0 = be64_to_cpu(frp->l0);
>  			trp->l1 = be64_to_cpu(frp->l1);
> -			if (!xfs_bmbt_validate_extent(mp, whichfork, trp)) {
> -				XFS_ERROR_REPORT("xfs_bmap_read_extents(2)",
> -						 XFS_ERRLEVEL_LOW, mp);
> -				goto error0;
> -			}
>  			trace_xfs_read_extent(ip, i, state, _THIS_IP_);
>  		}
>  		xfs_trans_brelse(tp, bp);
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> index 6f891eeb88f6..82d397de8e00 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> @@ -123,18 +123,4 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
>  extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
>  		struct xfs_trans *, struct xfs_inode *, int);
>  
> -/*
> - * Check that the extent does not contain an invalid unwritten extent flag.
> - */
> -static inline bool xfs_bmbt_validate_extent(struct xfs_mount *mp, int whichfork,
> -		struct xfs_bmbt_rec_host *ep)
> -{
> -	if (ep->l0 >> (64 - BMBT_EXNTFLAG_BITLEN) == 0)
> -		return true;
> -	if (whichfork == XFS_DATA_FORK &&
> -	    xfs_sb_version_hasextflgbit(&mp->m_sb))
> -		return true;
> -	return false;

By removing this, I think we no longer report corruption if we encounter
'unwritten' attr fork extents, which (AFAIK) aren't allowed.

--D

> -}
> -
>  #endif	/* __XFS_BMAP_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index b1e69734c450..48a5dec360cd 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -373,11 +373,6 @@ xfs_iformat_extents(
>  			xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
>  			ep->l0 = get_unaligned_be64(&dp->l0);
>  			ep->l1 = get_unaligned_be64(&dp->l1);
> -			if (!xfs_bmbt_validate_extent(mp, whichfork, ep)) {
> -				XFS_ERROR_REPORT("xfs_iformat_extents(2)",
> -						 XFS_ERRLEVEL_LOW, mp);
> -				return -EFSCORRUPTED;
> -			}



>  			trace_xfs_read_extent(ip, i, state, _THIS_IP_);
>  		}
>  	}
> @@ -801,8 +796,6 @@ xfs_iextents_copy(
>  	for (i = 0; i < nrecs; i++) {
>  		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
>  
> -		ASSERT(xfs_bmbt_validate_extent(ip->i_mount, whichfork, ep));
> -
>  		start_block = xfs_bmbt_get_startblock(ep);
>  		if (isnullstartblock(start_block)) {
>  			/*
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
