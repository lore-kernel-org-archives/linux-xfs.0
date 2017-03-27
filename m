Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47746 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752607AbdC0PVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 11:21:33 -0400
Date: Mon, 27 Mar 2017 08:21:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH (TRIVIAL)] xfs: fix up inode validation failure message
Message-ID: <20170327152122.GF5722@birch.djwong.org>
References: <59d16175-1c24-4bc2-5cd9-ac7a062e5ae3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59d16175-1c24-4bc2-5cd9-ac7a062e5ae3@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 17, 2017 at 08:47:38AM -0700, Eric Sandeen wrote:
> "xfs_iread: validation failed for inode 96 failed"
> 
> One "failed" seems like enough.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Yo dawg, I heard you like failed so I put failed in your
> failed so you can fail while you fail.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Will queue for 4.12.

--D

> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index d93f9d9..09c3d1a 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -508,7 +508,7 @@
>  
>  	/* even unallocated inodes are verified */
>  	if (!xfs_dinode_verify(mp, ip->i_ino, dip)) {
> -		xfs_alert(mp, "%s: validation failed for inode %lld failed",
> +		xfs_alert(mp, "%s: validation failed for inode %lld",
>  				__func__, ip->i_ino);
>  
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
