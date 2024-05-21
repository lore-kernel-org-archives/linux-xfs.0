Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4207F48C
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 14:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716300425; cv=none; b=U1dEBVPajqDsapQ4UM6wxot2AKU7BYp2ROxWSlTecnjKOo7PWm8zIIM+3aXRG+Jm1q5FeAZO/SlfjtGnBl3+Buk4IHtGzVrMlVmZG98dcIvLCVvbMnif8BAvdL2KmYRtKYKsTQIfY90/7katdTOX7s1L8kblGdiu9DzfUI17+es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716300425; c=relaxed/simple;
	bh=Qfn3z09rW7YImCZUHJSMx4k+jtGRGaYJ0HcFLoXbsqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oG3SIERNwTt2OKiHypYTgXynCy346jTdJ5UpSbD7Y2rKWcD6DA9U00xDBj87PJBLdkKkNzeenB9AlnzK/aBUkyTueLQGYJ1ML7IWNwuckuQIqZmZTAg7Acx3oagPqiplEqwaGigw7Pqyfcj8CQCq9K44uIMCCMMO9LU9bNk+H1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qSm5bxa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qSm5bxa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74BEC32789;
	Tue, 21 May 2024 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716300424;
	bh=Qfn3z09rW7YImCZUHJSMx4k+jtGRGaYJ0HcFLoXbsqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qSm5bxa2aAykqdQlNbEtPcvtjpV38Ds3A3L2bxVjJmc/BXnvV6yFVhY4jblBK7msk
	 Qk4P1LeB6JizCAb6XTa1OvbGnFsCrCqY+2vUzAkHB3G/z7/OvAZEd549AOsZZxCacp
	 mop7pggR7le+u/sTSXzYxlzEssxyAOd/sGOjzLOt4a/TTJQ4Skq9pyTBmpEAQ9ggsv
	 WFMcWH/90f5bhRTRy0s7Po/SMSzSrYZCxKB/GzOdZwlTsn2fUpZW8ldA6UOVVR2uWT
	 x/3+G/b7IOBA8XcYNXqDHZtAv3WDHdx0x75SQ6eQCAAGGTlBIsMm+FA8gM/8T3A+2/
	 T0AdjZhn1BB3Q==
Date: Tue, 21 May 2024 16:06:15 +0200
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
	linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/4] fs: add FS_IOC_FSSETXATTRAT and
 FS_IOC_FSGETXATTRAT
Message-ID: <20240521-sabotieren-autowerkstatt-f4f052fa1874@brauner>
References: <20240520164624.665269-2-aalbersh@redhat.com>
 <20240520164624.665269-4-aalbersh@redhat.com>
 <20240520175159.GD25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240520175159.GD25518@frogsfrogsfrogs>

On Mon, May 20, 2024 at 10:51:59AM -0700, Darrick J. Wong wrote:
> On Mon, May 20, 2024 at 06:46:21PM +0200, Andrey Albershteyn wrote:
> > XFS has project quotas which could be attached to a directory. All
> > new inodes in these directories inherit project ID set on parent
> > directory.
> > 
> > The project is created from userspace by opening and calling
> > FS_IOC_FSSETXATTR on each inode. This is not possible for special
> > files such as FIFO, SOCK, BLK etc. as opening them returns a special
> > inode from VFS. Therefore, some inodes are left with empty project
> > ID. Those inodes then are not shown in the quota accounting but
> > still exist in the directory.
> > 
> > This patch adds two new ioctls which allows userspace, such as
> > xfs_quota, to set project ID on special files by using parent
> > directory to open FS inode. This will let xfs_quota set ID on all
> > inodes and also reset it when project is removed. Also, as
> > vfs_fileattr_set() is now will called on special files too, let's
> > forbid any other attributes except projid and nextents (symlink can
> > have one).
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fs/ioctl.c              | 93 +++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/fs.h | 11 +++++
> >  2 files changed, 104 insertions(+)
> > 
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 1d5abfdf0f22..3e3aacb6ea6e 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/mount.h>
> >  #include <linux/fscrypt.h>
> >  #include <linux/fileattr.h>
> > +#include <linux/namei.h>
> >  
> >  #include "internal.h"
> >  
> > @@ -647,6 +648,19 @@ static int fileattr_set_prepare(struct inode *inode,
> >  	if (fa->fsx_cowextsize == 0)
> >  		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
> >  
> > +	/*
> > +	 * The only use case for special files is to set project ID, forbid any
> > +	 * other attributes
> > +	 */
> > +	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
> > +		if (fa->fsx_xflags & ~FS_XFLAG_PROJINHERIT)
> 
> When would PROJINHERIT be set on a non-reg/non-dir file?
> 
> > +			return -EINVAL;
> > +		if (!S_ISLNK(inode->i_mode) && fa->fsx_nextents)
> 
> FS_IOC_FSSETXATTR doesn't enforce anything for fsx_nextents for any
> other type of file, does it?
> 
> > +			return -EINVAL;
> > +		if (fa->fsx_extsize || fa->fsx_cowextsize)
> > +			return -EINVAL;
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> > @@ -763,6 +777,79 @@ static int ioctl_fssetxattr(struct file *file, void __user *argp)
> >  	return err;
> >  }
> >  
> > +static int ioctl_fsgetxattrat(struct file *file, void __user *argp)
> > +{
> > +	struct path filepath;
> > +	struct fsxattrat fsxat;
> > +	struct fileattr fa;
> > +	int error;
> > +
> > +	if (!S_ISDIR(file_inode(file)->i_mode))
> > +		return -EBADF;
> > +
> > +	if (copy_from_user(&fsxat, argp, sizeof(struct fsxattrat)))
> > +		return -EFAULT;
> > +
> > +	error = user_path_at(fsxat.dfd, fsxat.path, 0, &filepath);
> > +	if (error)
> > +		return error;
> > +
> > +	error = vfs_fileattr_get(filepath.dentry, &fa);
> > +	if (error) {
> > +		path_put(&filepath);
> > +		return error;
> > +	}
> > +
> > +	fsxat.fsx.fsx_xflags = fa.fsx_xflags;
> > +	fsxat.fsx.fsx_extsize = fa.fsx_extsize;
> > +	fsxat.fsx.fsx_nextents = fa.fsx_nextents;
> > +	fsxat.fsx.fsx_projid = fa.fsx_projid;
> > +	fsxat.fsx.fsx_cowextsize = fa.fsx_cowextsize;
> > +
> > +	if (copy_to_user(argp, &fsxat, sizeof(struct fsxattrat)))
> > +		error = -EFAULT;
> > +
> > +	path_put(&filepath);
> > +	return error;
> > +}
> > +
> > +static int ioctl_fssetxattrat(struct file *file, void __user *argp)
> > +{
> > +	struct mnt_idmap *idmap = file_mnt_idmap(file);
> > +	struct fsxattrat fsxat;
> > +	struct path filepath;
> > +	struct fileattr fa;
> > +	int error;
> > +
> > +	if (!S_ISDIR(file_inode(file)->i_mode))
> > +		return -EBADF;
> > +
> > +	if (copy_from_user(&fsxat, argp, sizeof(struct fsxattrat)))
> > +		return -EFAULT;
> > +
> > +	error = user_path_at(fsxat.dfd, fsxat.path, 0, &filepath);
> > +	if (error)
> > +		return error;
> > +
> > +	error = mnt_want_write(filepath.mnt);
> > +	if (error) {
> > +		path_put(&filepath);
> > +		return error;
> 
> This could be a goto to the path_put below.

(Unrelated to content but we should probably grow cleanup guards for
path_get()/path_put() and mnt_want_write()/mnt_drop_write() then stuff
like this becomes a no-brainer.)

> 
> > +	}
> > +
> > +	fileattr_fill_xflags(&fa, fsxat.fsx.fsx_xflags);
> > +	fa.fsx_extsize = fsxat.fsx.fsx_extsize;
> > +	fa.fsx_nextents = fsxat.fsx.fsx_nextents;
> > +	fa.fsx_projid = fsxat.fsx.fsx_projid;
> > +	fa.fsx_cowextsize = fsxat.fsx.fsx_cowextsize;
> > +	fa.fsx_valid = true;
> > +
> > +	error = vfs_fileattr_set(idmap, filepath.dentry, &fa);
> 
> Why not pass &fsxat.fsx directly to vfs_fileattr_set?
> 
> > +	mnt_drop_write(filepath.mnt);
> > +	path_put(&filepath);
> > +	return error;
> > +}
> > +
> >  static int ioctl_getfsuuid(struct file *file, void __user *argp)
> >  {
> >  	struct super_block *sb = file_inode(file)->i_sb;
> > @@ -872,6 +959,12 @@ static int do_vfs_ioctl(struct file *filp, unsigned int fd,
> >  	case FS_IOC_FSSETXATTR:
> >  		return ioctl_fssetxattr(filp, argp);
> >  
> > +	case FS_IOC_FSGETXATTRAT:
> > +		return ioctl_fsgetxattrat(filp, argp);
> > +
> > +	case FS_IOC_FSSETXATTRAT:
> > +		return ioctl_fssetxattrat(filp, argp);
> > +
> >  	case FS_IOC_GETFSUUID:
> >  		return ioctl_getfsuuid(filp, argp);
> >  
> > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > index 45e4e64fd664..f8cd8d7bf35d 100644
> > --- a/include/uapi/linux/fs.h
> > +++ b/include/uapi/linux/fs.h
> > @@ -139,6 +139,15 @@ struct fsxattr {
> >  	unsigned char	fsx_pad[8];
> >  };
> >  
> > +/*
> > + * Structure passed to FS_IOC_FSGETXATTRAT/FS_IOC_FSSETXATTRAT
> > + */
> > +struct fsxattrat {
> > +	struct fsxattr	fsx;		/* XATTR to get/set */
> > +	__u32		dfd;		/* parent dir */
> > +	const char	__user *path;
> 
> As I mentioned last time[1], embedding a pointer in an ioctl structure
> creates porting problems because pointer sizes vary between process
> personalities, so the size of struct fsxattrat will vary and lead to
> copy_to/from_user overflows.
> 
> 
> [1] https://lore.kernel.org/linux-xfs/20240509232517.GR360919@frogsfrogsfrogs/

So as you've mentioned in that thread using a u64 or here an aligned_u64
makes the most sense. The kernel has all the necessary magic to deal
with this already (u64_to_user_ptr() helper etc.). If you want to be
extra-sure it's possible to slap a size for that path as well.

The ioctl structure can be versioned by size if it's 64bit aligned. The
ioctl code encodes the size of the struct and since the current
structure is all nicely 64bit aligned it should just work (tm).

kernel/seccomp.c does that size verisioning by ioctl as an example. Then
one can do:

#define EA_IOCTL(cmd)   ((cmd) & ~(IOC_INOUT | IOCSIZE_MASK))

        switch (EA_IOCTL(cmd)) {
        case EA_IOCTL(FS_IOC_FSGETXATTRAT):
	        ret = copy_struct_from_user(&kstruct, sizeof(kstruct), usstruct, _IOC_SIZE(cmd));

Which will do all the heavy lifting for you. To me that seems
workable but I might miss other problems you're thinking of.
