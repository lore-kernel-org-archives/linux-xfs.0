Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757097AbeEJNzG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 09:55:06 -0400
Date: Thu, 10 May 2018 09:55:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/12] xfs: superblock scrub should use short-lived
 buffers
Message-ID: <20180510135504.GG69384@bfoster.bfoster>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
 <152537080489.16676.3127430066483939602.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152537080489.16676.3127430066483939602.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 11:06:44AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Secondary superblocks are rarely used, so create a helper to read a
> given non-primary AG's superblock and ensure that it won't stick around
> hogging memory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_sb.c     |   22 ++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_sb.h     |    3 +++
>  fs/xfs/libxfs/xfs_shared.h |    1 +
>  fs/xfs/scrub/agheader.c    |    4 +---
>  4 files changed, 27 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index d9b94bd5f689..d9bef41a3f26 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -972,3 +972,25 @@ xfs_fs_geometry(
>  
>  	return 0;
>  }
> +
> +/* Read a secondary superblock. */
> +int
> +xfs_sb_read_secondary(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	struct xfs_buf		**bpp)
> +{
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	ASSERT(agno != 0 && agno != NULLAGNUMBER);
> +	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> +			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> +			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> +	if (error)
> +		return error;
> +	xfs_buf_set_ref(bp, XFS_SSB_REF);
> +	*bpp = bp;
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 63dcd2a1a657..5166d78b2c34 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -37,5 +37,8 @@ extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
>  #define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
>  extern int	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
>  				int struct_version);
> +extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
> +				struct xfs_trans *tp, xfs_agnumber_t agno,
> +				struct xfs_buf **bpp);
>  
>  #endif	/* __XFS_SB_H__ */
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index d0b84da0cb1e..d23f33c02f64 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -127,6 +127,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>  #define	XFS_ATTR_BTREE_REF	1
>  #define	XFS_DQUOT_REF		1
>  #define	XFS_REFC_BTREE_REF	1
> +#define	XFS_SSB_REF		0
>  
>  /*
>   * Flags for xfs_trans_ichgtime().
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 018aabbd9394..cd24ac56c21e 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -157,9 +157,7 @@ xfs_scrub_superblock(
>  	if (agno == 0)
>  		return 0;
>  
> -	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> -		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> -		  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> +	error = xfs_sb_read_secondary(mp, sc->tp, agno, &bp);
>  	/*
>  	 * The superblock verifier can return several different error codes
>  	 * if it thinks the superblock doesn't look right.  For a mount these
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
