Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41376 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752625AbeAQMzi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Jan 2018 07:55:38 -0500
Date: Wed, 17 Jan 2018 07:55:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 1/5] xfs: check sb_agblocks and sb_agblklog when
 validating superblock
Message-ID: <20180117125535.GB37072@bfoster.bfoster>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579464601.8694.5478076755339350941.stgit@magnolia>
 <20180117012022.GC25805@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180117012022.GC25805@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Tue, Jan 16, 2018 at 05:20:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, we don't check sb_agblocks or sb_agblklog when we validate
> the superblock, which means that we can fuzz garbage values into those
> values and the mount succeeds.  This leads to all sorts of UBSAN
> warnings in xfs/350 since we can then coerce other parts of xfs into
> shifting by ridiculously large values.
> 
> Once we've validated agblocks, make sure the agcount makes sense.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: also check that dblocks/agcount/agblocks make sense
> v2: simplify ag min/max size definitions
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_fs.h |    7 +++++++
>  fs/xfs/libxfs/xfs_sb.c |   14 ++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index fc4386a..1de8555 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -233,6 +233,13 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_MAX_LOG_BLOCKS	(1024 * 1024ULL)
>  #define XFS_MIN_LOG_BYTES	(10 * 1024 * 1024ULL)
>  
> +/*
> + * Limits on sb_agblocks/sb_agblklog -- mkfs won't format AGs smaller than
> + * 16MB or larger than 1TB.
> + */
> +#define XFS_MIN_AG_BYTES	(1ULL << 24)	/* 16 MB */
> +#define XFS_MAX_AG_BYTES	(1ULL << 40)	/* 1 TB */
> +
>  /* keep the maximum size under 2^31 by a small amount */
>  #define XFS_MAX_LOG_BYTES \
>  	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 08e44a0..e2b82d7 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -119,6 +119,9 @@ xfs_mount_validate_sb(
>  	bool		check_inprogress,
>  	bool		check_version)
>  {
> +	u32		agcount = 0;
> +	u32		rem;
> +
>  	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
>  		xfs_warn(mp, "bad magic number");
>  		return -EWRONGFS;
> @@ -229,6 +232,13 @@ xfs_mount_validate_sb(
>  		return -EINVAL;
>  	}
>  
> +	/* Compute agcount for this number of dblocks and agblocks */
> +	if (sbp->sb_agblocks) {
> +		agcount = div_u64_rem(sbp->sb_dblocks, sbp->sb_agblocks, &rem);
> +		if (rem)
> +			agcount++;
> +	}
> +
>  	/*
>  	 * More sanity checking.  Most of these were stolen directly from
>  	 * xfs_repair.
> @@ -253,6 +263,10 @@ xfs_mount_validate_sb(
>  	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
>  	    sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE			||
>  	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
> +	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) < XFS_MIN_AG_BYTES	||
> +	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) > XFS_MAX_AG_BYTES	||
> +	    sbp->sb_agblklog != xfs_highbit32(sbp->sb_agblocks - 1) + 1	||
> +	    agcount == 0 || agcount != sbp->sb_agcount			||
>  	    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)	||
>  	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||
>  	    (sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)	||
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
