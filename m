Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44096 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbeCMUpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 16:45:09 -0400
Date: Tue, 13 Mar 2018 13:45:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/8] xfs: assert that xfs_reflink_allocate_cow is called
 with XFS_ILOCK_EXCL
Message-ID: <20180313204504.GE4865@magnolia>
References: <20180313143601.30028-1-hch@lst.de>
 <20180313143601.30028-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313143601.30028-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 03:35:56PM +0100, Christoph Hellwig wrote:
> Now that we convert COW preallocations from unwritten to real on every
> call this function needs to be called with the ilock held exclusively.
> 
> Fortunately we already do that, but update the assert to match.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_reflink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index d81c4f868d69..90aac8889dd9 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -394,7 +394,7 @@ xfs_reflink_allocate_cow(
>  
>  retry:
>  	ASSERT(xfs_is_reflink_inode(ip));
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
>  	/*
>  	 * Even if the extent is not shared we might have a preallocation for
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
