Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 18:15:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA11FMRE029739
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 18:15:24 -0700
Message-ID: <472928C1.5080707@sgi.com>
Date: Thu, 01 Nov 2007 12:15:45 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Implement fallocate
References: <20071029233841.GT995458@sgi.com>
In-Reply-To: <20071029233841.GT995458@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

David Chinner wrote:
> XFS fallocate() callout.
> 
> Allocate the range requested as unwritten extents. Atomically
> change the file size if requested.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/linux-2.6/xfs_iops.c |   45 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-10-30 10:18:59.061735503 +1100
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_iops.c	2007-10-30 10:19:26.498185998 +1100
> @@ -52,6 +52,7 @@
>  #include <linux/xattr.h>
>  #include <linux/namei.h>
>  #include <linux/security.h>
> +#include <linux/falloc.h>
>  
>  /*
>   * Bring the atime in the XFS inode uptodate.
> @@ -796,6 +797,49 @@ xfs_vn_removexattr(
>  	return namesp->attr_remove(vp, attr, xflags);
>  }
>  
> +/*
> + * generic space allocation vector.
> + */
> +STATIC long
> +xfs_vn_fallocate(
> +	struct inode	*inode,
> +	int		mode,
> +	loff_t		offset,
> +	loff_t		len)
> +{
> +	long		error;
> +	loff_t		new_size = 0;
> +	xfs_flock64_t	bf;
> +
> +	/* preallocation on directories not yet supported */
> +	error = -ENODEV;
> +	if (S_ISDIR(inode->i_mode))
> +		goto out_error;
> +
> +	bf.l_whence = 0;
> +	bf.l_start = offset;
> +	bf.l_len = len;
> +
> +	xfs_ilock(XFS_I(inode), XFS_IOLOCK_EXCL);
> +	error = xfs_change_file_space(XFS_I(inode), XFS_IOC_RESVSP, &bf,
> +						0, NULL, ATTR_NOLOCK);
> +	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
> +	    offset + len > i_size_read(inode))
> +		new_size = offset + len;
> +
> +	/* Change file size if needed */
> +	if (new_size) {
> +		bhv_vattr_t	va;
> +
> +		va.va_mask = XFS_AT_SIZE;
> +		va.va_size = new_size;
> +		error = xfs_setattr(XFS_I(inode), &va, ATTR_NOLOCK, NULL);
> +	}

Is it necessary to call xfs_setattr() here?  Could we just do an explicit
call to xfs_zero_eof(), set the new size, set i_update_core/size and mark
the inode dirty?  Hmmm, then again, that approach wouldn't be as clean as
above.

> +
> +	xfs_iunlock(XFS_I(inode), XFS_IOLOCK_EXCL);
> +out_error:
> +	return error;
> +}
>  
>  const struct inode_operations xfs_inode_operations = {
>  	.permission		= xfs_vn_permission,
> @@ -806,6 +850,7 @@ const struct inode_operations xfs_inode_
>  	.getxattr		= xfs_vn_getxattr,
>  	.listxattr		= xfs_vn_listxattr,
>  	.removexattr		= xfs_vn_removexattr,
> +	.fallocate		= xfs_vn_fallocate,
>  };
>  
>  const struct inode_operations xfs_dir_inode_operations = {
> 
