Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:40840 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1760847AbdJQWGF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2017 18:06:05 -0400
Date: Wed, 18 Oct 2017 09:06:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 24/30] xfs: scrub directory metadata
Message-ID: <20171017220602.GT15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777259980.1724.8093055918170430129.stgit@magnolia>
 <20171017001433.GX4703@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171017001433.GX4703@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 05:14:33PM -0700, Darrick J. Wong wrote:
> Scrub the hash tree and all the entries in a directory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: use helpers to extract DT_ codes, #define buffer size magic numbers
> ---
....
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index e0792d0..0ae0b92 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -446,4 +446,21 @@ int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
>  struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
>  		int error_class, int error);
>  
> +/*
> + * The Linux API doesn't pass down the total size of the buffer
> + * we read into down to the filesystem.  With the filldir concept
> + * it's not needed for correct information, but the XFS dir2 leaf
> + * code wants an estimate of the buffer size to calculate it's
> + * readahead window and size the buffers used for mapping to
> + * physical blocks.
> + *
> + * Try to give it an estimate that's good enough, maybe at some
> + * point we can change the ->readdir prototype to include the
> + * buffer size.  For now we use the current glibc buffer size.
> + * musl libc hardcodes 2k and dietlibc uses PAGE_SIZE.
> + */
> +#define XFS_READDIR_BUFSIZE	(32768)
> +
> +unsigned char xfs_dir3_get_dtype(struct xfs_mount *mp, uint8_t filetype);
> +
>  #endif	/* __XFS_MOUNT_H__ */

I think these belong in xfs_dir2.h, next to the declaration of
xfs_mode_to_ftype()....

Other than that,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
