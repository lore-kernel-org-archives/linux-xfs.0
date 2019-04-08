Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54380 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfDHFtV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Apr 2019 01:49:21 -0400
Subject: Re: [PATCH 3/4] xfs: flush page mappings as part of setting immutable
References: <155466882175.633834.15261194784129614735.stgit@magnolia>
 <155466884294.633834.1486289166159962611.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e5749655-2c12-a3a0-7ce8-8f5a9a9eb20e@oracle.com>
Date: Sun, 7 Apr 2019 22:49:14 -0700
MIME-Version: 1.0
In-Reply-To: <155466884294.633834.1486289166159962611.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On 4/7/19 1:27 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The chattr manpage has this to say about immutable files:
> 
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
> 
> This means that we need to flush the page cache when setting the
> immutable flag so that all mappings will become read-only again and
> therefore programs cannot continue to write to writable mappings.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_ioctl.c |   51 ++++++++++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 44 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 91938c4f3c67..5a1b96dad901 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -998,6 +998,31 @@ xfs_diflags_to_linux(
>   #endif
>   }
>   
> +/*
> + * Lock the inode against file io and page faults, then flush all dirty pages
> + * and wait for writeback and direct IO operations to finish.  Returns with
> + * the relevant inode lock flags set in @join_flags.  Caller is responsible for
> + * unlocking even on error return.
> + */
> +static int
> +xfs_ioctl_setattr_flush(
> +	struct xfs_inode	*ip,
> +	int			*join_flags)
> +{
> +	struct inode		*inode = VFS_I(ip);
> +
> +	/* Already locked the inode from IO?  Assume we're done. */
> +	if (((*join_flags) & (XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL)) ==
> +			     (XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL))
> +		return 0;
> +
> +	/* Lock and flush all mappings and IO in preparation for flag change */
> +	*join_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
Did you mean |= here?  It looks like this code came from 
xfs_ioctl_setattr_dax_invalidate, but now calling from 
xfs_ioctl_setattr, we may be over writing flags where we previously had 
not, so that may not be expected.

Allison

> +	xfs_ilock(ip, *join_flags);
> +	inode_dio_wait(inode);
> +	return filemap_write_and_wait(inode->i_mapping);
> +}
> +
>   static int
>   xfs_ioctl_setattr_xflags(
>   	struct xfs_trans	*tp,
> @@ -1092,25 +1117,22 @@ xfs_ioctl_setattr_dax_invalidate(
>   	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
>   		return 0;
>   
> -	if (S_ISDIR(inode->i_mode))
> +	if (!S_ISREG(inode->i_mode))
>   		return 0;
>   
>   	/* lock, flush and invalidate mapping in preparation for flag change */
> -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
> -	error = filemap_write_and_wait(inode->i_mapping);
> +	error = xfs_ioctl_setattr_flush(ip, join_flags);
>   	if (error)
>   		goto out_unlock;
>   	error = invalidate_inode_pages2(inode->i_mapping);
>   	if (error)
>   		goto out_unlock;
> -
> -	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
>   	return 0;
>   
>   out_unlock:
> -	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
> +	xfs_iunlock(ip, *join_flags);
> +	*join_flags = 0;
>   	return error;
> -
>   }
>   
>   /*
> @@ -1356,6 +1378,21 @@ xfs_ioctl_setattr(
>   	if (code)
>   		goto error_free_dquots;
>   
> +	/*
> +	 * If we are trying to set immutable on a file then flush everything to
> +	 * disk to force all writable memory mappings back through the
> +	 * pagefault handler.
> +	 */
> +	if (S_ISREG(VFS_I(ip)->i_mode) && !IS_IMMUTABLE(VFS_I(ip)) &&
> +	    (fa->fsx_xflags & FS_XFLAG_IMMUTABLE)) {
> +		code = xfs_ioctl_setattr_flush(ip, &join_flags);
> +		if (code) {
> +			xfs_iunlock(ip, join_flags);
> +			join_flags = 0;
> +			goto error_free_dquots;
> +		}
> +	}
> +
>   	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
>   	if (IS_ERR(tp)) {
>   		code = PTR_ERR(tp);
> 
