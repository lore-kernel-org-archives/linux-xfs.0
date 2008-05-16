Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 18:58:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4G1vvwE032515
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 18:58:00 -0700
Date: Fri, 16 May 2008 11:58:28 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()
Message-ID: <20080516015828.GC155679365@sgi.com>
References: <482CE39F.9050404@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482CE39F.9050404@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 16, 2008 at 11:30:07AM +1000, Lachlan McIlroy wrote:
> There's a new check added to dentry_open():
> 
>    if (!mnt) {
>        printk(KERN_WARNING "%s called with NULL vfsmount\n", __func__);
>        dump_stack();
>        return ERR_PTR(-EINVAL);
>    }
> 
> We need to pass a mountpoint in the call to dentry_open() in xfs_dm_rdwr()
> to avoid this code.
> 
> --- fs/xfs/dmapi/xfs_dm.c_1.72	2008-05-15 13:23:41.000000000 +1000
> +++ fs/xfs/dmapi/xfs_dm.c	2008-05-15 17:51:41.000000000 +1000
> @@ -52,6 +52,8 @@
> #include <dmapi_kern.h>
> #include "xfs_dm.h"
> 
> +#include <linux/mount.h>

Should be defined in fs/xfs/linux-2.6/xfs_linux.h, right?

> +
> #define MAXNAMLEN MAXNAMELEN
> 
> #define MIN_DIO_SIZE(mp)		((mp)->m_sb.sb_sectsize)
> @@ -1121,7 +1123,7 @@ xfs_dm_rdwr(
> 		return ENOMEM;
> 	}
> 
> -	file = dentry_open(dentry, NULL, oflags);
> +	file = dentry_open(dentry, mntget(ip->i_mount->m_vfsmount), oflags);
> 	if (IS_ERR(file)) {
> 		return -PTR_ERR(file);
> 	}
> --- fs/xfs/linux-2.6/xfs_super.c_1.416	2008-05-15 13:23:43.000000000 +1000
> +++ fs/xfs/linux-2.6/xfs_super.c	2008-05-15 13:29:49.000000000 +1000
> @@ -1397,8 +1397,14 @@ xfs_fs_get_sb(
> 	void			*data,
> 	struct vfsmount		*mnt)
> {
> -	return get_sb_bdev(fs_type, flags, dev_name, data, xfs_fs_fill_super,
> +	int	error;
> +
> +	error = get_sb_bdev(fs_type, flags, dev_name, data, 
> xfs_fs_fill_super,
> 			   mnt);
> +	if (!error)
> +		((struct xfs_mount *)mnt->mnt_sb->s_fs_info)->m_vfsmount = 
> mnt;

As I previously suggested, please use XFS_M(mnt->mnt_sb) for this.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
