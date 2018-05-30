Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753293AbeE3Nfy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 May 2018 09:35:54 -0400
Date: Wed, 30 May 2018 09:35:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/18] xfs: move locking into
 xfs_bmap_punch_delalloc_range
Message-ID: <20180530133551.GE112411@bfoster.bfoster>
References: <20180530100013.31358-1-hch@lst.de>
 <20180530100013.31358-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530100013.31358-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 12:00:00PM +0200, Christoph Hellwig wrote:
> Both callers want the same looking, so do it only once.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c      | 2 --
>  fs/xfs/xfs_bmap_util.c | 7 ++++---
>  fs/xfs/xfs_iomap.c     | 3 ---
>  3 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f2333e351e07..5dd09e83c81c 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -761,10 +761,8 @@ xfs_aops_discard_page(
>  		"page discard on page "PTR_FMT", inode 0x%llx, offset %llu.",
>  			page, ip->i_ino, offset);
>  
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
>  			PAGE_SIZE / i_blocksize(inode));
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	if (error && !XFS_FORCED_SHUTDOWN(mp))
>  		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
>  out_invalidate:
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f2b87873612d..86a7ee425bfc 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -712,12 +712,11 @@ xfs_bmap_punch_delalloc_range(
>  	struct xfs_iext_cursor	icur;
>  	int			error = 0;
>  
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>  		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
>  		if (error)
> -			return error;
> +			goto out_unlock;
>  	}
>  
>  	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))

There's a return 0 just below here that needs the exit label treatment.
Otherwise looks Ok.

Brian

> @@ -738,6 +737,8 @@ xfs_bmap_punch_delalloc_range(
>  		}
>  	}
>  
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index da6d1995e460..f949f0dd7382 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1203,11 +1203,8 @@ xfs_file_iomap_end_delalloc(
>  		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
>  					 XFS_FSB_TO_B(mp, end_fsb) - 1);
>  
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
>  					       end_fsb - start_fsb);
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -
>  		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
>  			xfs_alert(mp, "%s: unable to clean up ino %lld",
>  				__func__, ip->i_ino);
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
