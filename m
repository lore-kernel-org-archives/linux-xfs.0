Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46350 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbeEOUSJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 16:18:09 -0400
Date: Tue, 15 May 2018 13:17:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfs: New function for secondary superblock updates
Message-ID: <20180515201748.GL4933@magnolia>
References: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
 <7e8d428a-2150-d044-c1f3-5b53c5404246@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e8d428a-2150-d044-c1f3-5b53c5404246@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, May 14, 2018 at 12:36:36PM -0500, Eric Sandeen wrote:
> Relabel must update all secondary superblocks, as offline relabel does.
> 
> This is essentially a simpler copy of the current growfs code, which is
> undergoing an independent refactor; we can see about merging stuff back
> together after all this work is done.  In the meantime, this is a fairly
> small, simple bit of code to facilitate the online label work.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_fsops.h |  1 +
>  2 files changed, 49 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 523792768080..1aaa93051f78 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -71,6 +71,54 @@ xfs_growfs_get_hdr_buf(
>  	return bp;
>  }
>  
> +/*
> + * Copy the contents of the primary super to all backup supers.
> + * Not currently used for growfs, as it only looks at existing supers.
> + */
> +int
> +xfs_update_secondary_supers(
> +	xfs_mount_t		*mp)
> +{
> +	int			error, saved_error;
> +	xfs_agnumber_t		agno;
> +	xfs_buf_t		*bp;
> +
> +	error = saved_error = 0;
> +
> +	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
> +		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> +			  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> +			  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);

This whole thing /should/ use the new xfs_sb_read_secondary() helper,
but between Dave's growfs refactor, this series, and secondary sb online
repair I think I prefer to land all three and immediately clean up all
three common use cases.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +		/*
> +		 * If we get an error reading or writing alternate superblocks,
> +		 * continue.  xfs_repair chooses the "best" superblock based
> +		 * on most matches; if we break early, we'll leave more
> +		 * superblocks un-updated than updated, and xfs_repair may
> +		 * pick them over the properly-updated primary.
> +		 */
> +		if (error) {
> +			xfs_warn(mp,
> +		"error %d reading secondary superblock for ag %d",
> +				error, agno);
> +			saved_error = error;
> +			continue;
> +		}
> +		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
> +
> +		error = xfs_bwrite(bp);
> +		xfs_buf_relse(bp);
> +		if (error) {
> +			xfs_warn(mp,
> +		"write error %d updating secondary superblock for ag %d",
> +				error, agno);
> +			saved_error = error;
> +			continue;
> +		}
> +	}
> +
> +	return saved_error ? saved_error : error;
> +}
> +
>  static int
>  xfs_growfs_data_private(
>  	xfs_mount_t		*mp,		/* mount point for filesystem */
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 20484ed5e919..257d3018bc39 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -18,6 +18,7 @@
>  #ifndef __XFS_FSOPS_H__
>  #define	__XFS_FSOPS_H__
>  
> +extern int xfs_update_secondary_supers(xfs_mount_t *mp);
>  extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
>  extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
>  extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
