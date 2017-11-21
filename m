Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18329 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752067AbdKUBsk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2017 20:48:40 -0500
Date: Mon, 20 Nov 2017 17:48:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: abstract out dev_t conversions
Message-ID: <20171121014832.GA2135@magnolia>
References: <20171120093356.16355-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171120093356.16355-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Mon, Nov 20, 2017 at 10:33:56AM +0100, Christoph Hellwig wrote:
> And move them to xfs_linux.h so that xfsprogs can stub them out more
> easily.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, but I want Eric to have a quick look at this because he's the
stuckee on this one. :P

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> This should make life for xfsprogs a lot easier.  And it's mostly trivial
> so it should be ok for 4.15.
> 
>  fs/xfs/libxfs/xfs_inode_fork.c |  8 ++------
>  fs/xfs/xfs_linux.h             | 10 ++++++++++
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 1c90ec41e9df..c79a1616b79d 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -42,11 +42,6 @@ STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
>  STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
>  STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
>  
> -static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
> -{
> -	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
> -}
> -
>  /*
>   * Copy inode type and data and attr format specific information from the
>   * on-disk inode to the in-core inode and fork structures.  For fifos, devices,
> @@ -792,7 +787,8 @@ xfs_iflush_fork(
>  	case XFS_DINODE_FMT_DEV:
>  		if (iip->ili_fields & XFS_ILOG_DEV) {
>  			ASSERT(whichfork == XFS_DATA_FORK);
> -			xfs_dinode_put_rdev(dip, sysv_encode_dev(VFS_I(ip)->i_rdev));
> +			xfs_dinode_put_rdev(dip,
> +					linux_to_xfs_dev_t(VFS_I(ip)->i_rdev));
>  		}
>  		break;
>  
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 6282bfc1afa9..99562ec0de56 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -204,6 +204,16 @@ static inline kgid_t xfs_gid_to_kgid(uint32_t gid)
>  	return make_kgid(&init_user_ns, gid);
>  }
>  
> +static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
> +{
> +	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
> +}
> +
> +static inline xfs_dev_t linux_to_xfs_dev_t(dev_t dev)
> +{
> +	return sysv_encode_dev(dev);
> +}
> +
>  /*
>   * Various platform dependent calls that don't fit anywhere else
>   */
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
