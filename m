Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35794 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbeAZVyO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 16:54:14 -0500
Date: Fri, 26 Jan 2018 13:44:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable
 inode
Message-ID: <20180126214404.GE9068@magnolia>
References: <1516952669-14769-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516952669-14769-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Jan 26, 2018 at 09:44:29AM +0200, Amir Goldstein wrote:
> Commit 66f364649d870 ("xfs: remove if_rdev") moved storing of rdev
> value for special inodes to VFS inodes, but forgot to preserve the
> value of i_rdev when recycling a reclaimable xfs_inode.
> 
> This was detected by xfstest overlay/017 with inodex=on mount option
> and xfs base fs. The test does a lookup of overlay chardev and blockdev
> right after drop caches.
> 
> Overlayfs inodes hold a reference on underlying xfs inodes when mount
> option index=on is configured. If drop caches reclaim xfs inodes, before
> it relclaims overlayfs inodes, that can sometimes leave a reclaimable xfs
> inode and that test hits that case quite often.
> 
> When that happens, the xfs inode cache remains broken (zere i_rdev)
> until the next cycle mount or drop caches.
> 
> Fixes: 66f364649d870 ("xfs: remove if_rdev")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> Darrick,
> 
> You may want to rush this last minute v4.15 regression fix.
> 
> Thanks,
> Amir.
> 
>  fs/xfs/xfs_icache.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 3861d61fb265..3ce946063ffe 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -295,6 +295,7 @@ xfs_reinit_inode(
>  	uint32_t	generation = inode->i_generation;
>  	uint64_t	version = inode->i_version;
>  	umode_t		mode = inode->i_mode;
> +	dev_t		dev = inode->i_rdev;
>  
>  	error = inode_init_always(mp->m_super, inode);
>  
> @@ -302,6 +303,7 @@ xfs_reinit_inode(
>  	inode->i_generation = generation;
>  	inode->i_version = version;
>  	inode->i_mode = mode;
> +	inode->i_rdev = dev;
>  	return error;
>  }
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
