Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbfGGWaI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Jul 2019 18:30:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x67MTiMw100854
        for <linux-xfs@vger.kernel.org>; Sun, 7 Jul 2019 22:30:07 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tjm9qbapy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 07 Jul 2019 22:30:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x67MSOWL069579
        for <linux-xfs@vger.kernel.org>; Sun, 7 Jul 2019 22:30:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tjgrt847n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 07 Jul 2019 22:30:06 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x67MU6pE021076
        for <linux-xfs@vger.kernel.org>; Sun, 7 Jul 2019 22:30:06 GMT
Subject: Re: [PATCH 3/3] xfs: make the dax inode flag advisory
References: <156174692684.1557952.3770482995772643434.stgit@magnolia>
 <156174694534.1557952.14317442337573957232.stgit@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <b2dd95e7-a248-b5c8-6b84-ce48f88a5f19@oracle.com>
Date: Sun, 7 Jul 2019 15:30:05 -0700
MIME-Version: 1.0
In-Reply-To: <156174694534.1557952.14317442337573957232.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/28/19 11:35 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We have no ability to change S_DAX on an inode, which means that this
> flag is purely advisory.  Remove all the (broken) code that tried to
> change the state since it's cluttering up the code for no good reason.
> If the kernel ever gains the ability to change S_DAX on the fly we can
> always add this back.
> 
Looks ok to me.
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_ioctl.c |   76 ----------------------------------------------------
>   1 file changed, 76 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d2526d9070d2..dda681698555 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1001,12 +1001,6 @@ xfs_diflags_to_linux(
>   		inode->i_flags |= S_NOATIME;
>   	else
>   		inode->i_flags &= ~S_NOATIME;
> -#if 0	/* disabled until the flag switching races are sorted out */
> -	if (xflags & FS_XFLAG_DAX)
> -		inode->i_flags |= S_DAX;
> -	else
> -		inode->i_flags &= ~S_DAX;
> -#endif
>   }
>   
>   static int
> @@ -1077,63 +1071,6 @@ xfs_ioctl_setattr_drain_writes(
>   	return inode_drain_writes(inode);
>   }
>   
> -/*
> - * If we are changing DAX flags, we have to ensure the file is clean and any
> - * cached objects in the address space are invalidated and removed. This
> - * requires us to lock out other IO and page faults similar to a truncate
> - * operation. The locks need to be held until the transaction has been committed
> - * so that the cache invalidation is atomic with respect to the DAX flag
> - * manipulation.
> - *
> - * The caller must use @join_flags to release the locks which are held on @ip
> - * regardless of return value.
> - */
> -static int
> -xfs_ioctl_setattr_dax_invalidate(
> -	struct xfs_inode	*ip,
> -	struct fsxattr		*fa,
> -	int			*join_flags)
> -{
> -	struct inode		*inode = VFS_I(ip);
> -	struct super_block	*sb = inode->i_sb;
> -	int			error;
> -
> -	/*
> -	 * It is only valid to set the DAX flag on regular files and
> -	 * directories on filesystems where the block size is equal to the page
> -	 * size. On directories it serves as an inherited hint so we don't
> -	 * have to check the device for dax support or flush pagecache.
> -	 */
> -	if (fa->fsx_xflags & FS_XFLAG_DAX) {
> -		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
> -			return -EINVAL;
> -		if (S_ISREG(inode->i_mode) &&
> -		    !bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
> -				sb->s_blocksize))
> -			return -EINVAL;
> -	}
> -
> -	/* If the DAX state is not changing, we have nothing to do here. */
> -	if ((fa->fsx_xflags & FS_XFLAG_DAX) && IS_DAX(inode))
> -		return 0;
> -	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
> -		return 0;
> -
> -	if (S_ISDIR(inode->i_mode))
> -		return 0;
> -
> -	/* lock, flush and invalidate mapping in preparation for flag change */
> -	if (*join_flags == 0) {
> -		*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
> -		xfs_ilock(ip, *join_flags);
> -		error = filemap_write_and_wait(inode->i_mapping);
> -		if (error)
> -			return error;
> -	}
> -
> -	return invalidate_inode_pages2(inode->i_mapping);
> -}
> -
>   /*
>    * Set up the transaction structure for the setattr operation, checking that we
>    * have permission to do so. On success, return a clean transaction and the
> @@ -1346,19 +1283,6 @@ xfs_ioctl_setattr(
>   		goto error_free_dquots;
>   	}
>   
> -	/*
> -	 * Changing DAX config may require inode locking for mapping
> -	 * invalidation. These need to be held all the way to transaction commit
> -	 * or cancel time, so need to be passed through to
> -	 * xfs_ioctl_setattr_get_trans() so it can apply them to the join call
> -	 * appropriately.
> -	 */
> -	code = xfs_ioctl_setattr_dax_invalidate(ip, fa, &join_flags);
> -	if (code) {
> -		xfs_iunlock(ip, join_flags);
> -		goto error_free_dquots;
> -	}
> -
>   	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
>   	if (IS_ERR(tp)) {
>   		code = PTR_ERR(tp);
> 
