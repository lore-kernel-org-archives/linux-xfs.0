Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934028AbeAOOlV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Jan 2018 09:41:21 -0500
Date: Mon, 15 Jan 2018 09:41:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs: check sb_agblocks and sb_agblklog when
 validating superblock
Message-ID: <20180115144108.GA47688@bfoster.bfoster>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579464601.8694.5478076755339350941.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151579464601.8694.5478076755339350941.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 12, 2018 at 02:04:06PM -0800, Darrick J. Wong wrote:
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
>  fs/xfs/libxfs/xfs_fs.h |    7 +++++++
>  fs/xfs/libxfs/xfs_sb.c |    3 +++
>  2 files changed, 10 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index fc4386a..2701ea0 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -233,6 +233,13 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_MAX_LOG_BLOCKS	(1024 * 1024ULL)
>  #define XFS_MIN_LOG_BYTES	(10 * 1024 * 1024ULL)
>  
> +/* Limits on sb_agblocks/sb_agblklog */
> +#define XFS_AG_BYTES(bblog)	((long long)BBSIZE << (bblog))
> +#define XFS_AG_MIN_BYTES	((XFS_AG_BYTES(15)))	/* 16 MB */
> +#define XFS_AG_MAX_BYTES	((XFS_AG_BYTES(31)))	/* 1 TB */
> +#define XFS_AG_MIN_BLOCKS(blog)	(XFS_AG_MIN_BYTES >> (blog))
> +#define XFS_AG_MAX_BLOCKS(blog)	((XFS_AG_MAX_BYTES - 1) >> (blog))
> +

Hmm, we have some similar but differently named definitions just above.
E.g., XFS_MIN_AG_BLOCKS vs. XFS_AG_MIN_BLOCKS()..? I'm not sure where
the 64 block value comes from, but assuming it's valid.. perhaps we
should use that field for the block count and new ones for byte values?

Regardless of whether we want to check the block count here at all, I
think it's more straightforward (and less code) to just define two new
XFS_MIN/MAX_AG_BYTES values and then update the checks to use existing
conversions in terms of bytes (rather than obfuscate what is really a
size check behind block macros). For example, something like:

	...
	XFS_FSB_TO_B(mp, sbp->sb_agblocks) < XFS_MIN_AG_BYTES ||
	XFS_FSB_TO_B(mp, sbp->ag_agblocks) > XFS_MAX_AG_BYTES ||
	...

Brian

>  /* keep the maximum size under 2^31 by a small amount */
>  #define XFS_MAX_LOG_BYTES \
>  	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 08e44a0..1f81b49 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -253,6 +253,9 @@ xfs_mount_validate_sb(
>  	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
>  	    sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE			||
>  	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
> +	    sbp->sb_agblocks < XFS_AG_MIN_BLOCKS(sbp->sb_blocklog)	||
> +	    sbp->sb_agblocks > XFS_AG_MAX_BLOCKS(sbp->sb_blocklog)	||
> +	    sbp->sb_agblklog != xfs_highbit32(sbp->sb_agblocks - 1) + 1	||
>  	    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)	||
>  	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||
>  	    (sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)	||
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
