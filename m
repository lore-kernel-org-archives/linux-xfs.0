Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35452 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbeFSF05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 01:26:57 -0400
Date: Mon, 18 Jun 2018 22:26:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/24] xfs: move locking into
 xfs_bmap_punch_delalloc_range
Message-ID: <20180619052651.GQ8128@magnolia>
References: <20180615130209.1970-1-hch@lst.de>
 <20180615130209.1970-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615130209.1970-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Jun 15, 2018 at 03:01:51PM +0200, Christoph Hellwig wrote:
> Both callers want the same looking, so do it only once.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c      | 2 --
>  fs/xfs/xfs_bmap_util.c | 9 +++++----
>  fs/xfs/xfs_iomap.c     | 3 ---
>  3 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index d94dd6fe5127..026721c4991e 100644
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
> index 0070b877ed94..6690a038892d 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -712,16 +712,15 @@ xfs_bmap_punch_delalloc_range(
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
> -		return 0;
> +		goto out_unlock;
>  
>  	while (got.br_startoff + got.br_blockcount > start_fsb) {
>  		del = got;
> @@ -745,6 +744,8 @@ xfs_bmap_punch_delalloc_range(
>  			break;
>  	}
>  
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 85c66e78f9e8..758ad9572d04 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1205,11 +1205,8 @@ xfs_file_iomap_end_delalloc(
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
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
