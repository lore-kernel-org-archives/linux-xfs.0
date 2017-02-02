Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31532 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751811AbdBBRpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 12:45:54 -0500
Date: Thu, 2 Feb 2017 09:45:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: update ctime and mtime on clone destinatation inodes
Message-ID: <20170202174547.GN9134@birch.djwong.org>
References: <20170202162456.20574-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170202162456.20574-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 02, 2017 at 05:24:56PM +0100, Christoph Hellwig wrote:
> We're changing both metadata and data, so we need to update the
> timestamps.   This follows existing btrfs behavior.

/me wonders, should the mtime change if we're deduping?  We're
definitely changing metadata, but we shouldn't be making any
user-visible changes to the file data.

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_reflink.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index d5a2cf2b469b..8877e6f5e35d 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -967,9 +967,6 @@ xfs_reflink_update_dest(
>  	struct xfs_trans	*tp;
>  	int			error;
>  
> -	if (newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0)
> -		return 0;
> -
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
>  	if (error)
>  		goto out_error;
> @@ -988,6 +985,7 @@ xfs_reflink_update_dest(
>  		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  	}
>  
> +	xfs_trans_ichgtime(tp, dest, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
>  
>  	error = xfs_trans_commit(tp);
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
