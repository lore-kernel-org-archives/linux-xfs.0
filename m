Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbeIUCJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 22:09:04 -0400
Date: Thu, 20 Sep 2018 13:23:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/10] xfs: don't bring in extents in
 xfs_bmap_punch_delalloc_range
Message-ID: <20180920202345.GP20086@magnolia>
References: <20180917205354.15401-1-hch@lst.de>
 <20180917205354.15401-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180917205354.15401-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 17, 2018 at 10:53:46PM +0200, Christoph Hellwig wrote:
> This function is only used to punch out delayed allocations on I/O
> failure, which means we need to have read the extents earlier.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index addbd74ecd8e..418e1e725f3a 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -702,13 +702,9 @@ xfs_bmap_punch_delalloc_range(
>  	struct xfs_iext_cursor	icur;
>  	int			error = 0;
>  
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> -		if (error)
> -			goto out_unlock;
> -	}
> +	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
>  
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
>  		goto out_unlock;
>  
> -- 
> 2.18.0
> 
