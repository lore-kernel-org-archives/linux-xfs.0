Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfDZSSE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Apr 2019 14:18:04 -0400
Date: Fri, 26 Apr 2019 14:18:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/8] xfs: flush page mappings as part of setting immutable
Message-ID: <20190426181759.GD34536@bfoster>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
 <155552788742.20411.8968554209133632884.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155552788742.20411.8968554209133632884.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

On Wed, Apr 17, 2019 at 12:04:47PM -0700, Darrick J. Wong wrote:
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
>  fs/xfs/xfs_ioctl.c |   52 +++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 45 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 21d6f433c375..de35cf4469f6 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1009,6 +1009,31 @@ xfs_diflags_to_linux(
>  #endif
>  }
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

Ok, so I take it this is because the xfs_setattr_path() can call down
into here via dax_invalidate() and then subsequently via the immutable
check. Instead of burying this down here, could we just check join_flags
!= 0 prior to the second setattr_flush() call? Otherwise this looks Ok
to me.

Brian

> +	/* Lock and flush all mappings and IO in preparation for flag change */
> +	*join_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> +	xfs_ilock(ip, *join_flags);
> +	inode_dio_wait(inode);
> +	return filemap_write_and_wait(inode->i_mapping);
> +}
> +
>  static int
>  xfs_ioctl_setattr_xflags(
>  	struct xfs_trans	*tp,
> @@ -1103,25 +1128,22 @@ xfs_ioctl_setattr_dax_invalidate(
>  	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
>  		return 0;
>  
> -	if (S_ISDIR(inode->i_mode))
> +	if (!S_ISREG(inode->i_mode))
>  		return 0;
>  
>  	/* lock, flush and invalidate mapping in preparation for flag change */
> -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
> -	error = filemap_write_and_wait(inode->i_mapping);
> +	error = xfs_ioctl_setattr_flush(ip, join_flags);
>  	if (error)
>  		goto out_unlock;
>  	error = invalidate_inode_pages2(inode->i_mapping);
>  	if (error)
>  		goto out_unlock;
> -
> -	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
>  	return 0;
>  
>  out_unlock:
> -	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
> +	xfs_iunlock(ip, *join_flags);
> +	*join_flags = 0;
>  	return error;
> -
>  }
>  
>  /*
> @@ -1367,6 +1389,22 @@ xfs_ioctl_setattr(
>  	if (code)
>  		goto error_free_dquots;
>  
> +	/*
> +	 * Wait for all pending directio and then flush all the dirty pages
> +	 * for this file.  The flush marks all the pages readonly, so any
> +	 * subsequent attempt to write to the file (particularly mmap pages)
> +	 * will come through the filesystem and fail.
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
>  	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
>  	if (IS_ERR(tp)) {
>  		code = PTR_ERR(tp);
> 
