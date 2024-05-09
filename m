Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C5D85C43
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 23:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715297118; cv=none; b=KAgkkx+claBPTdqhiuMUqWQY+RxjXQVyPnLXSwEXNAh4CSBWjvAyBESW4fP/O1eI6r/2V88kVCVHSDG9iHwiWFah2nO+mgyhcmDcJV//JJ166bmTvBLjnFrD/D8NrFuj9mesTRZjHb6dsXnK854rQ0sGjXHogo5VZwKLiYa1S6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715297118; c=relaxed/simple;
	bh=lSLhlAlrHioC1yK+2ZM68U3zfEI4wLeBLgyzQsG51rI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TvEdRDo/hh3vQH8HSFsONlLI+I7nAklCCN1j3o0gJxSwDvqqTuAZtYYlh1n6wSMKkrhl3F3yUVYnCHCjF9WM5WwIJpp+yORHaJPU/NSwGZjpsH6JeOylNqDxvi/6OG+7aPOManld0sC9YdVobZC1kAmReCc0xwbG3oIwRYHEXDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NSRkIb/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NSRkIb/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F61C116B1;
	Thu,  9 May 2024 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715297118;
	bh=lSLhlAlrHioC1yK+2ZM68U3zfEI4wLeBLgyzQsG51rI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NSRkIb/PsYGiV7hj3y4k3ly+aSnyRyHMSTs4JpLhtWvak+9ZU9NdY6K5ftxJxlF2A
	 05uRgvidYchgtIoDAsVE+Tw9JxKD5HFNGgpJFXS1lmNitxVtL2yP0bM7J+aaZbkBfc
	 dZ/pEuZDX52NTmwSwhUdpsnPZ9SVUKbGYrsEP9Jz1/io4lE9VlKU8JCJmRylIaemyh
	 fpk8KO26p+KcDAlof0VHZKPDvMQlJYEAGn55Jm572ji8aw98OWt2PvvDyKMCx1g96G
	 uaWGIBEIZu03XrLq9b7rbSzYvTy/lCvh+srVLOrc2myxdkoadOgaqn00jM6rY/UJ/A
	 tVyi5wgW4ypjg==
Date: Thu, 9 May 2024 16:25:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: add XFS_IOC_SETFSXATTRAT and
 XFS_IOC_GETFSXATTRAT
Message-ID: <20240509232517.GR360919@frogsfrogsfrogs>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
 <20240509151459.3622910-6-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509151459.3622910-6-aalbersh@redhat.com>

On Thu, May 09, 2024 at 05:15:00PM +0200, Andrey Albershteyn wrote:
> XFS has project quotas which could be attached to a directory. All
> new inodes in these directories inherit project ID.
> 
> The project is created from userspace by opening and calling
> FS_IOC_FSSETXATTR on each inode. This is not possible for special
> files such as FIFO, SOCK, BLK etc. as opening them return special
> inode from VFS. Therefore, some inodes are left with empty project
> ID.
> 
> This patch adds new XFS ioctl which allows userspace, such as
> xfs_quota, to set project ID on special files. This will let
> xfs_quota set ID on all inodes and also reset it when project is
> removed.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h   | 11 +++++
>  fs/xfs/xfs_ioctl.c       | 86 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/fileattr.h |  2 +-
>  3 files changed, 98 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 97996cb79aaa..f68e98005d4b 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -670,6 +670,15 @@ typedef struct xfs_swapext
>  	struct xfs_bstat sx_stat;	/* stat of target b4 copy */
>  } xfs_swapext_t;
>  
> +/*
> + * Structure passed to XFS_IOC_GETFSXATTRAT/XFS_IOC_GETFSXATTRAT
> + */
> +struct xfs_xattrat_req {
> +	struct fsxattr	__user *fsx;		/* XATTR to get/set */

Shouldn't this fsxattr object be embedded directly into xfs_xattrat_req?
That's one less pointer to mess with.

> +	__u32		dfd;			/* parent dir */
> +	const char	__user *path;

Fugly wart: passing in a pointer as part of a ioctl structure means that
you also have to implement an ioctl32.c wrapper because pointer sizes
are not the same across the personalities that the kernel can run (e.g.
i386 on an x64 kernel).

Unfortunately the only way I know of to work around the ioctl32 crud is
to declare this as a __u64 field, employ a bunch of uintptr_t casting to
shut up gcc, and pretend that pointers never exceed 64 bits.

> +};
> +
>  /*
>   * Flags for going down operation
>   */
> @@ -997,6 +1006,8 @@ struct xfs_getparents_by_handle {
>  #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
>  #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
>  #define XFS_IOC_EXCHANGE_RANGE	     _IOWR('X', 129, struct xfs_exchange_range)
> +#define XFS_IOC_GETFSXATTRAT	     _IOR ('X', 130, struct xfs_xattrat_req)
> +#define XFS_IOC_SETFSXATTRAT	     _IOW ('X', 131, struct xfs_xattrat_req)

These really ought to be defined in the VFS alongside
FS_IOC_FSGETXATTR, not in XFS.

>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 515c9b4b862d..d54dba9128a0 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1408,6 +1408,74 @@ xfs_ioctl_fs_counts(
>  	return 0;
>  }
>  
> +static int
> +xfs_xattrat_get(
> +	struct file		*dir,
> +	const char __user	*pathname,
> +	struct xfs_xattrat_req	*xreq)
> +{
> +	struct path		filepath;
> +	struct xfs_inode	*ip;
> +	struct fileattr		fa;
> +	int			error = -EBADF;
> +
> +	memset(&fa, 0, sizeof(struct fileattr));
> +
> +	if (!S_ISDIR(file_inode(dir)->i_mode))
> +		return error;
> +
> +	error = user_path_at(xreq->dfd, pathname, 0, &filepath);
> +	if (error)
> +		return error;
> +
> +	ip = XFS_I(filepath.dentry->d_inode);

Can we trust that this path points to an XFS inode?  Or even the same
filesystem as the ioctl fd?  I think if you put the user_path_at part in
the VFS, you could use the resulting filepath.dentry to call the regular
->fileattr_[gs]et functions, couldn't you?

--D

> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	xfs_fill_fsxattr(ip, XFS_DATA_FORK, &fa);
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +	error = copy_fsxattr_to_user(&fa, xreq->fsx);
> +
> +	path_put(&filepath);
> +	return error;
> +}
> +
> +static int
> +xfs_xattrat_set(
> +	struct file		*dir,
> +	const char __user	*pathname,
> +	struct xfs_xattrat_req	*xreq)
> +{
> +	struct fileattr		fa;
> +	struct path		filepath;
> +	struct mnt_idmap	*idmap = file_mnt_idmap(dir);
> +	int			error = -EBADF;
> +
> +	if (!S_ISDIR(file_inode(dir)->i_mode))
> +		return error;
> +
> +	error = copy_fsxattr_from_user(&fa, xreq->fsx);
> +	if (error)
> +		return error;
> +
> +	error = user_path_at(xreq->dfd, pathname, 0, &filepath);
> +	if (error)
> +		return error;
> +
> +	error = mnt_want_write(filepath.mnt);
> +	if (error) {
> +		path_put(&filepath);
> +		return error;
> +	}
> +
> +	fa.fsx_valid = true;
> +	error = vfs_fileattr_set(idmap, filepath.dentry, &fa);
> +
> +	mnt_drop_write(filepath.mnt);
> +	path_put(&filepath);
> +	return error;
> +}
> +
>  /*
>   * These long-unused ioctls were removed from the official ioctl API in 5.17,
>   * but retain these definitions so that we can log warnings about them.
> @@ -1652,6 +1720,24 @@ xfs_file_ioctl(
>  		sb_end_write(mp->m_super);
>  		return error;
>  	}
> +	case XFS_IOC_GETFSXATTRAT: {
> +		struct xfs_xattrat_req xreq;
> +
> +		if (copy_from_user(&xreq, arg, sizeof(struct xfs_xattrat_req)))
> +			return -EFAULT;
> +
> +		error = xfs_xattrat_get(filp, xreq.path, &xreq);
> +		return error;
> +	}
> +	case XFS_IOC_SETFSXATTRAT: {
> +		struct xfs_xattrat_req xreq;
> +
> +		if (copy_from_user(&xreq, arg, sizeof(struct xfs_xattrat_req)))
> +			return -EFAULT;
> +
> +		error = xfs_xattrat_set(filp, xreq.path, &xreq);
> +		return error;
> +	}
>  
>  	case XFS_IOC_EXCHANGE_RANGE:
>  		return xfs_ioc_exchange_range(filp, arg);
> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> index 3c4f8c75abc0..8598e94b530b 100644
> --- a/include/linux/fileattr.h
> +++ b/include/linux/fileattr.h
> @@ -34,7 +34,7 @@ struct fileattr {
>  };
>  
>  int copy_fsxattr_to_user(const struct fileattr *fa, struct fsxattr __user *ufa);
> -int copy_fsxattr_from_user(struct fileattr *fa, struct fsxattr __user *ufa)
> +int copy_fsxattr_from_user(struct fileattr *fa, struct fsxattr __user *ufa);
>  
>  void fileattr_fill_xflags(struct fileattr *fa, u32 xflags);
>  void fileattr_fill_flags(struct fileattr *fa, u32 flags);
> -- 
> 2.42.0
> 
> 
