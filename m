Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39150 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388541AbeGXWZd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 18:25:33 -0400
Date: Tue, 24 Jul 2018 13:46:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 07/15] xfs: pack holes in xfs_defer_ops and xfs_trans
Message-ID: <20180724204630.GF4813@magnolia>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-8-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:06AM -0400, Brian Foster wrote:
> Both structures have holes due to member alignment. Move dop_low to
> the end of xfs_defer ops to sanitize the cache line alignment and
> move t_flags to save 8 bytes in xfs_trans.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.h | 3 ++-
>  fs/xfs/xfs_trans.h        | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 58c979c9f3fa..8f58f217fdff 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -49,13 +49,14 @@ enum xfs_defer_ops_type {
>  #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
>  
>  struct xfs_defer_ops {
> -	bool			dop_low;	/* alloc in low mode */
>  	struct list_head	dop_intake;	/* unlogged pending work */
>  	struct list_head	dop_pending;	/* logged pending work */
>  
>  	/* relog these with each roll */
>  	struct xfs_inode	*dop_inodes[XFS_DEFER_OPS_NR_INODES];
>  	struct xfs_buf		*dop_bufs[XFS_DEFER_OPS_NR_BUFS];
> +
> +	bool			dop_low;	/* alloc in low mode */
>  };
>  
>  void xfs_defer_add(struct xfs_defer_ops *dop, enum xfs_defer_ops_type type,
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 37fdacc690c7..6f857af61455 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -102,12 +102,12 @@ typedef struct xfs_trans {
>  	unsigned int		t_blk_res_used;	/* # of resvd blocks used */
>  	unsigned int		t_rtx_res;	/* # of rt extents resvd */
>  	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
> +	unsigned int		t_flags;	/* misc flags */
>  	xfs_fsblock_t		t_firstblock;	/* first block allocated */
>  	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
>  	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
>  	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
>  	struct xfs_defer_ops	*t_dfops;	/* dfops reference */
> -	unsigned int		t_flags;	/* misc flags */
>  	int64_t			t_icount_delta;	/* superblock icount change */
>  	int64_t			t_ifree_delta;	/* superblock ifree change */
>  	int64_t			t_fdblocks_delta; /* superblock fdblocks chg */
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
