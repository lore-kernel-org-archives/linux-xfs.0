Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45841 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdH3QRH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 12:17:07 -0400
Date: Wed, 30 Aug 2017 09:17:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: disable per-inode DAX flag
Message-ID: <20170830161701.GM4757@magnolia>
References: <20170830145119.3013-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830145119.3013-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 04:51:19PM +0200, Christoph Hellwig wrote:
> Currently flag switching can be used to easily crash the kernel.  Disable
> the per-inode DAX flag until that is sorted out.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 9c0c7a920304..06ca244c323a 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1008,11 +1008,12 @@ xfs_diflags_to_linux(
>  		inode->i_flags |= S_NOATIME;
>  	else
>  		inode->i_flags &= ~S_NOATIME;
> +#if 0	/* disabled until the flag switching races are sorted out */

#ifdef DEBUG ?

So that we developers can play with DAX without having to patch this out?

If that's fine with you I'll just change it on the way in.

--D

>  	if (xflags & FS_XFLAG_DAX)
>  		inode->i_flags |= S_DAX;
>  	else
>  		inode->i_flags &= ~S_DAX;
> -
> +#endif
>  }
>  
>  static int
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
