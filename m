Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46886 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdLHE2A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 23:28:00 -0500
Date: Thu, 7 Dec 2017 20:27:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] mkfs: remove use-once default macros
Message-ID: <20171208042756.GL19219@magnolia>
References: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
 <bf7aac6f-dc75-d00f-d6ec-23599a8b156a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf7aac6f-dc75-d00f-d6ec-23599a8b156a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Dec 07, 2017 at 10:18:42PM -0600, Eric Sandeen wrote:
> sb_feat was a weird mishmash of hardcoded defaults and macros
> (which were used in only this place).
> 
> Make it consistent by removing the use-once macros, and remove
> the unused XFS_DFL_LOG_SIZE while we're in here.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  include/xfs_multidisk.h | 3 ---
>  mkfs/xfs_mkfs.c         | 4 ++--
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
> index e5f53b7..54913d8 100644
> --- a/include/xfs_multidisk.h
> +++ b/include/xfs_multidisk.h
> @@ -29,10 +29,7 @@
>  #define	XFS_MIN_DATA_BLOCKS	100
>  #define	XFS_MIN_INODE_PERBLOCK	2		/* min inodes per block */
>  #define	XFS_DFL_IMAXIMUM_PCT	25		/* max % of space for inodes */
> -#define	XFS_IFLAG_ALIGN		true		/* -i align defaults on */
>  #define	XFS_MIN_REC_DIRSIZE	12		/* 4096 byte dirblocks (V2) */
> -#define	XFS_DFL_DIR_VERSION	2		/* default directory version */
> -#define	XFS_DFL_LOG_SIZE	1000		/* default log size, blocks */
>  #define	XFS_DFL_LOG_FACTOR	5		/* default log size, factor */
>  						/* with max trans reservation */
>  #define XFS_MAX_INODE_SIG_BITS	32		/* most significant bits in an
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3f6315d..a321ff2 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3850,8 +3850,8 @@ main(
>  		.sb_feat = {
>  			.log_version = 2,
>  			.attr_version = 2,
> -			.dir_version = XFS_DFL_DIR_VERSION,
> -			.inode_align = XFS_IFLAG_ALIGN,
> +			.dir_version = 2,
> +			.inode_align = true,
>  			.nci = false,
>  			.lazy_sb_counters = true,
>  			.projid32bit = true,
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
