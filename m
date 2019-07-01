Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbfGAQrb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 12:47:31 -0400
Date: Mon, 1 Jul 2019 09:47:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: linux-next: manual merge of the xfs tree with the f2fs tree
Message-ID: <20190701164705.GN1404256@magnolia>
References: <20190701110603.5abcbb2c@canb.auug.org.au>
 <20190701163146.GA195588@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701163146.GA195588@google.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Jul 01, 2019 at 09:31:46AM -0700, Eric Biggers wrote:
> [+f2fs mailing list]
> 
> On Mon, Jul 01, 2019 at 11:06:03AM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the xfs tree got a conflict in:
> > 
> >   fs/f2fs/file.c
> > 
> > between commit:
> > 
> >   360985573b55 ("f2fs: separate f2fs i_flags from fs_flags and ext4 i_flags")
> > 
> > from the f2fs tree and commits:
> > 
> >   de2baa49bbae ("vfs: create a generic checking and prep function for FS_IOC_SETFLAGS")
> >   3dd3ba36a8ee ("vfs: create a generic checking function for FS_IOC_FSSETXATTR")
> > 
> > from the xfs tree.
> > 
> > I fixed it up (I think - see below) and can carry the fix as necessary.
> > This is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> > 
> > -- 
> > Cheers,
> > Stephen Rothwell
> > 
> > diff --cc fs/f2fs/file.c
> > index e7c368db8185,8799468724f9..000000000000
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@@ -1645,22 -1648,45 +1645,23 @@@ static int f2fs_file_flush(struct file 
> >   	return 0;
> >   }
> >   
> >  -static int f2fs_ioc_getflags(struct file *filp, unsigned long arg)
> >  -{
> >  -	struct inode *inode = file_inode(filp);
> >  -	struct f2fs_inode_info *fi = F2FS_I(inode);
> >  -	unsigned int flags = fi->i_flags;
> >  -
> >  -	if (IS_ENCRYPTED(inode))
> >  -		flags |= F2FS_ENCRYPT_FL;
> >  -	if (f2fs_has_inline_data(inode) || f2fs_has_inline_dentry(inode))
> >  -		flags |= F2FS_INLINE_DATA_FL;
> >  -	if (is_inode_flag_set(inode, FI_PIN_FILE))
> >  -		flags |= F2FS_NOCOW_FL;
> >  -
> >  -	flags &= F2FS_FL_USER_VISIBLE;
> >  -
> >  -	return put_user(flags, (int __user *)arg);
> >  -}
> >  -
> >  -static int __f2fs_ioc_setflags(struct inode *inode, unsigned int flags)
> >  +static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
> >   {
> >   	struct f2fs_inode_info *fi = F2FS_I(inode);
> >  -	unsigned int oldflags;
> >  +	u32 oldflags;
> > + 	int err;
> >   
> >   	/* Is it quota file? Do not allow user to mess with it */
> >   	if (IS_NOQUOTA(inode))
> >   		return -EPERM;
> >   
> >  -	flags = f2fs_mask_flags(inode->i_mode, flags);
> >  -
> >   	oldflags = fi->i_flags;
> >   
> > - 	if ((iflags ^ oldflags) & (F2FS_APPEND_FL | F2FS_IMMUTABLE_FL))
> > - 		if (!capable(CAP_LINUX_IMMUTABLE))
> > - 			return -EPERM;
> >  -	err = vfs_ioc_setflags_prepare(inode, oldflags, flags);
> > ++	err = vfs_ioc_setflags_prepare(inode, oldflags, iflags);
> > + 	if (err)
> > + 		return err;
> 
> I don't think this is the correct resolution.  Now f2fs_setflags_common() is
> meant to take the f2fs on-disk i_flags, which aren't necessarily the same as the
> flags passed to the FS_IOC_SETFLAGS ioctl.  So it's not appropriate to call
> vfs_ioc_setflags_prepare() in it.  It should be in f2fs_ioc_setflags() instead.
> 
> I've pushed up what I think is the correct resolution to
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=f2fs-setflags-resolved
> 
> Here is my diff of fs/f2fs/file.c from f2fs/dev.  Darrick, can you check that
> this is what you would have done if you had patched f2fs/dev instead of v5.2?

Yep, that's roughly what I was planning to do to connect f2fs to the
checking functions.

I withdrew the fs/f2fs/ parts of the setflags/fssetxattr cleanups from
the branch with the intent to fix it after f2fs-dev lands, because I
think this is too messy a merge resolution to push through Linus.

Would you mind resending this with a proper subject line and SOB? :)

--D

> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index e7c368db81851f..64f157f2e8d5e4 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -1648,19 +1648,12 @@ static int f2fs_file_flush(struct file *file, fl_owner_t id)
>  static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
>  {
>  	struct f2fs_inode_info *fi = F2FS_I(inode);
> -	u32 oldflags;
>  
>  	/* Is it quota file? Do not allow user to mess with it */
>  	if (IS_NOQUOTA(inode))
>  		return -EPERM;
>  
> -	oldflags = fi->i_flags;
> -
> -	if ((iflags ^ oldflags) & (F2FS_APPEND_FL | F2FS_IMMUTABLE_FL))
> -		if (!capable(CAP_LINUX_IMMUTABLE))
> -			return -EPERM;
> -
> -	fi->i_flags = iflags | (oldflags & ~mask);
> +	fi->i_flags = iflags | (fi->i_flags & ~mask);
>  
>  	if (fi->i_flags & F2FS_PROJINHERIT_FL)
>  		set_inode_flag(inode, FI_PROJ_INHERIT);
> @@ -1765,7 +1758,8 @@ static int f2fs_ioc_getflags(struct file *filp, unsigned long arg)
>  static int f2fs_ioc_setflags(struct file *filp, unsigned long arg)
>  {
>  	struct inode *inode = file_inode(filp);
> -	u32 fsflags;
> +	struct f2fs_inode_info *fi = F2FS_I(inode);
> +	u32 fsflags, old_fsflags;
>  	u32 iflags;
>  	int ret;
>  
> @@ -1789,8 +1783,14 @@ static int f2fs_ioc_setflags(struct file *filp, unsigned long arg)
>  
>  	inode_lock(inode);
>  
> +	old_fsflags = f2fs_iflags_to_fsflags(fi->i_flags);
> +	ret = vfs_ioc_setflags_prepare(inode, old_fsflags, fsflags);
> +	if (ret)
> +		goto out;
> +
>  	ret = f2fs_setflags_common(inode, iflags,
>  			f2fs_fsflags_to_iflags(F2FS_SETTABLE_FS_FL));
> +out:
>  	inode_unlock(inode);
>  	mnt_drop_write_file(filp);
>  	return ret;
> @@ -2850,52 +2850,32 @@ static inline u32 f2fs_xflags_to_iflags(u32 xflags)
>  	return iflags;
>  }
>  
> -static int f2fs_ioc_fsgetxattr(struct file *filp, unsigned long arg)
> +static void f2fs_fill_fsxattr(struct inode *inode, struct fsxattr *fa)
>  {
> -	struct inode *inode = file_inode(filp);
>  	struct f2fs_inode_info *fi = F2FS_I(inode);
> -	struct fsxattr fa;
>  
> -	memset(&fa, 0, sizeof(struct fsxattr));
> -	fa.fsx_xflags = f2fs_iflags_to_xflags(fi->i_flags);
> +	simple_fill_fsxattr(fa, f2fs_iflags_to_xflags(fi->i_flags));
>  
>  	if (f2fs_sb_has_project_quota(F2FS_I_SB(inode)))
> -		fa.fsx_projid = (__u32)from_kprojid(&init_user_ns,
> -							fi->i_projid);
> -
> -	if (copy_to_user((struct fsxattr __user *)arg, &fa, sizeof(fa)))
> -		return -EFAULT;
> -	return 0;
> +		fa->fsx_projid = from_kprojid(&init_user_ns, fi->i_projid);
>  }
>  
> -static int f2fs_ioctl_check_project(struct inode *inode, struct fsxattr *fa)
> +static int f2fs_ioc_fsgetxattr(struct file *filp, unsigned long arg)
>  {
> -	/*
> -	 * Project Quota ID state is only allowed to change from within the init
> -	 * namespace. Enforce that restriction only if we are trying to change
> -	 * the quota ID state. Everything else is allowed in user namespaces.
> -	 */
> -	if (current_user_ns() == &init_user_ns)
> -		return 0;
> +	struct inode *inode = file_inode(filp);
> +	struct fsxattr fa;
>  
> -	if (__kprojid_val(F2FS_I(inode)->i_projid) != fa->fsx_projid)
> -		return -EINVAL;
> -
> -	if (F2FS_I(inode)->i_flags & F2FS_PROJINHERIT_FL) {
> -		if (!(fa->fsx_xflags & FS_XFLAG_PROJINHERIT))
> -			return -EINVAL;
> -	} else {
> -		if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
> -			return -EINVAL;
> -	}
> +	f2fs_fill_fsxattr(inode, &fa);
>  
> +	if (copy_to_user((struct fsxattr __user *)arg, &fa, sizeof(fa)))
> +		return -EFAULT;
>  	return 0;
>  }
>  
>  static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
>  {
>  	struct inode *inode = file_inode(filp);
> -	struct fsxattr fa;
> +	struct fsxattr fa, old_fa;
>  	u32 iflags;
>  	int err;
>  
> @@ -2918,7 +2898,9 @@ static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
>  		return err;
>  
>  	inode_lock(inode);
> -	err = f2fs_ioctl_check_project(inode, &fa);
> +
> +	f2fs_fill_fsxattr(inode, &old_fa);
> +	err = vfs_ioc_fssetxattr_check(inode, &old_fa, &fa);
>  	if (err)
>  		goto out;
>  	err = f2fs_setflags_common(inode, iflags,
