Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEAC1EA84
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 17:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227521; cv=none; b=rC7UjcXwbb1bTv7FPl9adYrOtBRX8CrgWGHdWkXK7SfXbmUMAHhu4BNtxcaRjXPpyTUXaAS/1jscvaHyDJ1/KCYKpYdcYsD5Z+tiWJkJHBdz4iLdAca2Yk+jr8FDCFeMcEblBXYpOZd7nSPQTUf88/Nb2gCbVEKGjSTsnIFbFcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227521; c=relaxed/simple;
	bh=rwJWbg6X7aLS1wpa7/BXRJ/67ibBxSLCg0SkysQIg84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDjGPgE1WaceyovL8qmJGgeS9U0gGsJW1zIHYPRHB/FqnAc+1RRtcYV9rPfwIZT4x+OXulPqCCBMP4iZuyQH4MmZxcxPJKhPnKq9zDaB5Mnni3K1T/Ib5l7Q9LC9T+ARNQQUgIkWHSvI8FWv5D20DOtk3g11YvB3mOluRlg+gQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VbW2+IKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VbW2+IKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2CFC2BD10;
	Mon, 20 May 2024 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716227520;
	bh=rwJWbg6X7aLS1wpa7/BXRJ/67ibBxSLCg0SkysQIg84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VbW2+IKFdkdf6JFFxgw2vkuVbLQ6zPuqVg7kF1Wizs4VbWPiK6RaJIgdrH18yhi4Y
	 tmwifKFOXA1Y7Toft54loqP2UcCY4ijiiHnEI1x1UFRDn9tw8GdgVHLrX1PqZVkSJT
	 KnvP/Xdw/tBeELPwWHueK/KpZDYAbNy5pDFTpaJ2C46c0ZQfhyMsfmkxh3PQaLJy2M
	 jkt1Y1YVfvEdDgkf7Jq4OOuG+jPjzv2jxTqjaxG57e1foAPSv6RhFrkkjuTWqRPN8h
	 BTXR1g5jwa3Qe6YlEyTRlgvNvIgFWB2ltNTwWx57P88CmngBdbTWqHqLfkDDdS31aI
	 2jvpZQUut7eDg==
Date: Mon, 20 May 2024 10:51:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/4] fs: add FS_IOC_FSSETXATTRAT and
 FS_IOC_FSGETXATTRAT
Message-ID: <20240520175159.GD25518@frogsfrogsfrogs>
References: <20240520164624.665269-2-aalbersh@redhat.com>
 <20240520164624.665269-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520164624.665269-4-aalbersh@redhat.com>

On Mon, May 20, 2024 at 06:46:21PM +0200, Andrey Albershteyn wrote:
> XFS has project quotas which could be attached to a directory. All
> new inodes in these directories inherit project ID set on parent
> directory.
> 
> The project is created from userspace by opening and calling
> FS_IOC_FSSETXATTR on each inode. This is not possible for special
> files such as FIFO, SOCK, BLK etc. as opening them returns a special
> inode from VFS. Therefore, some inodes are left with empty project
> ID. Those inodes then are not shown in the quota accounting but
> still exist in the directory.
> 
> This patch adds two new ioctls which allows userspace, such as
> xfs_quota, to set project ID on special files by using parent
> directory to open FS inode. This will let xfs_quota set ID on all
> inodes and also reset it when project is removed. Also, as
> vfs_fileattr_set() is now will called on special files too, let's
> forbid any other attributes except projid and nextents (symlink can
> have one).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/ioctl.c              | 93 +++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/fs.h | 11 +++++
>  2 files changed, 104 insertions(+)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 1d5abfdf0f22..3e3aacb6ea6e 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -22,6 +22,7 @@
>  #include <linux/mount.h>
>  #include <linux/fscrypt.h>
>  #include <linux/fileattr.h>
> +#include <linux/namei.h>
>  
>  #include "internal.h"
>  
> @@ -647,6 +648,19 @@ static int fileattr_set_prepare(struct inode *inode,
>  	if (fa->fsx_cowextsize == 0)
>  		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
>  
> +	/*
> +	 * The only use case for special files is to set project ID, forbid any
> +	 * other attributes
> +	 */
> +	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
> +		if (fa->fsx_xflags & ~FS_XFLAG_PROJINHERIT)

When would PROJINHERIT be set on a non-reg/non-dir file?

> +			return -EINVAL;
> +		if (!S_ISLNK(inode->i_mode) && fa->fsx_nextents)

FS_IOC_FSSETXATTR doesn't enforce anything for fsx_nextents for any
other type of file, does it?

> +			return -EINVAL;
> +		if (fa->fsx_extsize || fa->fsx_cowextsize)
> +			return -EINVAL;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -763,6 +777,79 @@ static int ioctl_fssetxattr(struct file *file, void __user *argp)
>  	return err;
>  }
>  
> +static int ioctl_fsgetxattrat(struct file *file, void __user *argp)
> +{
> +	struct path filepath;
> +	struct fsxattrat fsxat;
> +	struct fileattr fa;
> +	int error;
> +
> +	if (!S_ISDIR(file_inode(file)->i_mode))
> +		return -EBADF;
> +
> +	if (copy_from_user(&fsxat, argp, sizeof(struct fsxattrat)))
> +		return -EFAULT;
> +
> +	error = user_path_at(fsxat.dfd, fsxat.path, 0, &filepath);
> +	if (error)
> +		return error;
> +
> +	error = vfs_fileattr_get(filepath.dentry, &fa);
> +	if (error) {
> +		path_put(&filepath);
> +		return error;
> +	}
> +
> +	fsxat.fsx.fsx_xflags = fa.fsx_xflags;
> +	fsxat.fsx.fsx_extsize = fa.fsx_extsize;
> +	fsxat.fsx.fsx_nextents = fa.fsx_nextents;
> +	fsxat.fsx.fsx_projid = fa.fsx_projid;
> +	fsxat.fsx.fsx_cowextsize = fa.fsx_cowextsize;
> +
> +	if (copy_to_user(argp, &fsxat, sizeof(struct fsxattrat)))
> +		error = -EFAULT;
> +
> +	path_put(&filepath);
> +	return error;
> +}
> +
> +static int ioctl_fssetxattrat(struct file *file, void __user *argp)
> +{
> +	struct mnt_idmap *idmap = file_mnt_idmap(file);
> +	struct fsxattrat fsxat;
> +	struct path filepath;
> +	struct fileattr fa;
> +	int error;
> +
> +	if (!S_ISDIR(file_inode(file)->i_mode))
> +		return -EBADF;
> +
> +	if (copy_from_user(&fsxat, argp, sizeof(struct fsxattrat)))
> +		return -EFAULT;
> +
> +	error = user_path_at(fsxat.dfd, fsxat.path, 0, &filepath);
> +	if (error)
> +		return error;
> +
> +	error = mnt_want_write(filepath.mnt);
> +	if (error) {
> +		path_put(&filepath);
> +		return error;

This could be a goto to the path_put below.

> +	}
> +
> +	fileattr_fill_xflags(&fa, fsxat.fsx.fsx_xflags);
> +	fa.fsx_extsize = fsxat.fsx.fsx_extsize;
> +	fa.fsx_nextents = fsxat.fsx.fsx_nextents;
> +	fa.fsx_projid = fsxat.fsx.fsx_projid;
> +	fa.fsx_cowextsize = fsxat.fsx.fsx_cowextsize;
> +	fa.fsx_valid = true;
> +
> +	error = vfs_fileattr_set(idmap, filepath.dentry, &fa);

Why not pass &fsxat.fsx directly to vfs_fileattr_set?

> +	mnt_drop_write(filepath.mnt);
> +	path_put(&filepath);
> +	return error;
> +}
> +
>  static int ioctl_getfsuuid(struct file *file, void __user *argp)
>  {
>  	struct super_block *sb = file_inode(file)->i_sb;
> @@ -872,6 +959,12 @@ static int do_vfs_ioctl(struct file *filp, unsigned int fd,
>  	case FS_IOC_FSSETXATTR:
>  		return ioctl_fssetxattr(filp, argp);
>  
> +	case FS_IOC_FSGETXATTRAT:
> +		return ioctl_fsgetxattrat(filp, argp);
> +
> +	case FS_IOC_FSSETXATTRAT:
> +		return ioctl_fssetxattrat(filp, argp);
> +
>  	case FS_IOC_GETFSUUID:
>  		return ioctl_getfsuuid(filp, argp);
>  
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 45e4e64fd664..f8cd8d7bf35d 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -139,6 +139,15 @@ struct fsxattr {
>  	unsigned char	fsx_pad[8];
>  };
>  
> +/*
> + * Structure passed to FS_IOC_FSGETXATTRAT/FS_IOC_FSSETXATTRAT
> + */
> +struct fsxattrat {
> +	struct fsxattr	fsx;		/* XATTR to get/set */
> +	__u32		dfd;		/* parent dir */
> +	const char	__user *path;

As I mentioned last time[1], embedding a pointer in an ioctl structure
creates porting problems because pointer sizes vary between process
personalities, so the size of struct fsxattrat will vary and lead to
copy_to/from_user overflows.


[1] https://lore.kernel.org/linux-xfs/20240509232517.GR360919@frogsfrogsfrogs/

--D

> +};
> +
>  /*
>   * Flags for the fsx_xflags field
>   */
> @@ -231,6 +240,8 @@ struct fsxattr {
>  #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
>  #define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
>  #define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
> +#define FS_IOC_FSGETXATTRAT		_IOR('X', 33, struct fsxattrat)
> +#define FS_IOC_FSSETXATTRAT		_IOW('X', 34, struct fsxattrat)
>  #define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
>  #define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
>  /* Returns the external filesystem UUID, the same one blkid returns */
> -- 
> 2.42.0
> 
> 
