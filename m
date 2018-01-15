Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:12498 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750732AbeAOVc2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jan 2018 16:32:28 -0500
Date: Tue, 16 Jan 2018 08:31:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/5] xfs: check sb_agblocks and sb_agblklog when
 validating superblock
Message-ID: <20180115213102.GZ16421@dastard>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579464601.8694.5478076755339350941.stgit@magnolia>
 <20180115200313.GC5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180115200313.GC5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Mon, Jan 15, 2018 at 12:03:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, we don't check sb_agblocks or sb_agblklog when we validate
> the superblock, which means that we can fuzz garbage values into those
> values and the mount succeeds.  This leads to all sorts of UBSAN
> warnings in xfs/350 since we can then coerce other parts of xfs into
> shifting by ridiculously large values.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: simplify ag min/max size definitions
> ---
>  fs/xfs/libxfs/xfs_fs.h |    7 +++++++
>  fs/xfs/libxfs/xfs_sb.c |    3 +++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index fc4386a..3ab1870 100644
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
> +#define XFS_AG_MIN_BYTES	(1ULL << 24)	/* 16 MB */
> +#define XFS_AG_MAX_BYTES	(1ULL << 40)	/* 1 TB */

Sure, but....
> +
>  /* keep the maximum size under 2^31 by a small amount */
>  #define XFS_MAX_LOG_BYTES \
>  	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 08e44a0..bdb4f74 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -253,6 +253,9 @@ xfs_mount_validate_sb(
>  	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
>  	    sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE			||
>  	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
> +	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) < XFS_AG_MIN_BYTES	||
> +	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) > XFS_AG_MAX_BYTES	||

.... this really needs to be checked against sb_dblocks /
sb_agcount. i.e. check against current filesystem size and geometry,
not against the theoretical maximum.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
