Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 23:35:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6F6ZVFr030554
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 23:35:33 -0700
Message-ID: <487C456D.3010509@sgi.com>
Date: Tue, 15 Jul 2008 16:36:29 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] kill vn_revalidate
References: <20080627154602.GC31476@lst.de> <20080705172110.GB7177@lst.de>
In-Reply-To: <20080705172110.GB7177@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Hi,

Looks reasonable.

Looking at changes...
* remove calls to vn_revalidate from:
-> xfs_ioctl_setattr (but call xfs_diflags_to_linux(ip) for FSX_XFLAGS instead
   which is the relevant bit of vn_revalidate)
-> xfs_dm_set_fileattr (after call to xfs_setattr)
-> xfs_vn_setattr (after call to xfs_setattr)
-> xfs_xattr_system_set 
   (after call to xfs_acl_vset -> xfs_acl_setmode -> xfs_setattr)

So we now do inode field sets in xfs_setattr instead of waiting until
after calling xfs_setattr (either directly or indirectly) to get vn_revalidate
to set the inode fields. Okay.

* in xfs_setattr we now explicitly set for linux inode:
i_mode, i_uid, i_gid, i_atime, i_mtime, i_ctime
It looks like we didn't set i_atime in vn_revalidate previously.


This change looks weird:
>  	 */
> -	iattr.ia_mask = XFS_AT_MODE;
> +	iattr.ia_valid = ATTR_MODE;
>  	iattr.ia_mode = xfs_vtoi(vp)->i_d.di_mode;

I didn't think there was an ia_mask field - was this really
from another patch? Confused.

--Tim

Christoph Hellwig wrote:
> On Fri, Jun 27, 2008 at 05:46:02PM +0200, Christoph Hellwig wrote:
>> These days most of the attributes in struct inode are properly kept in
>> sync by XFS.  This patch removes the need for vn_revalidate completely
>> by:
>>
>>  - keeping inode.i_flags uptodate after any flags are updated in
>>    xfs_ioctl_setattr
>>  - keeping i_mode, i_uid and i_gid uptodate in xfs_setattr
> 
> Version that doesn't require the generic ACL patch below:
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-07-05 10:04:56.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-07-05 12:02:24.000000000 +0200
> @@ -2665,7 +2665,6 @@ xfs_dm_set_fileattr(
>  {
>  	dm_fileattr_t	stat;
>  	struct iattr	iattr;
> -	int		error;
>  
>  	/* Returns negative errors to DMAPI */
>  
> @@ -2720,10 +2719,7 @@ xfs_dm_set_fileattr(
>  		iattr.ia_size = stat.fa_size;
>  	}
>  
> -	error = xfs_setattr(XFS_I(inode), &iattr, XFS_ATTR_DMI, NULL);
> -	if (!error)
> -		vn_revalidate(vn_from_inode(inode));	/* update Linux inode flags */
> -	return(-error); /* Return negative error to DMAPI */
> +	return -xfs_setattr(XFS_I(inode), &iattr, XFS_ATTR_DMI, NULL);
>  }
>  
>  
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-07-05 10:04:56.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-07-05 12:02:24.000000000 +0200
> @@ -920,6 +920,30 @@ xfs_set_diflags(
>  	ip->i_d.di_flags = di_flags;
>  }
>  
> +STATIC void
> +xfs_diflags_to_linux(
> +	struct xfs_inode	*ip)
> +{
> +	struct inode		*inode = XFS_ITOV(ip);
> +	unsigned int		xflags = xfs_ip2xflags(ip);
> +
> +	if (xflags & XFS_XFLAG_IMMUTABLE)
> +		inode->i_flags |= S_IMMUTABLE;
> +	else
> +		inode->i_flags &= ~S_IMMUTABLE;
> +	if (xflags & XFS_XFLAG_APPEND)
> +		inode->i_flags |= S_APPEND;
> +	else
> +		inode->i_flags &= ~S_APPEND;
> +	if (xflags & XFS_XFLAG_SYNC)
> +		inode->i_flags |= S_SYNC;
> +	else
> +		inode->i_flags &= ~S_SYNC;
> +	if (xflags & XFS_XFLAG_NOATIME)
> +		inode->i_flags |= S_NOATIME;
> +	else
> +		inode->i_flags &= ~S_NOATIME;
> +}
>  
>  #define FSX_PROJID	1
>  #define FSX_EXTSIZE	2
> @@ -1118,8 +1142,10 @@ xfs_ioctl_setattr(
>  
>  	if (mask & FSX_EXTSIZE)
>  		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
> -	if (mask & FSX_XFLAGS)
> +	if (mask & FSX_XFLAGS) {
>  		xfs_set_diflags(ip, fa->fsx_xflags);
> +		xfs_diflags_to_linux(ip);
> +	}
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
> @@ -1157,7 +1183,6 @@ xfs_ioctl_setattr(
>  				(mask & FSX_NONBLOCK) ? DM_FLAGS_NDELAY : 0);
>  	}
>  
> -	vn_revalidate(XFS_ITOV(ip));	/* update flags */
>  	return 0;
>  
>   error_return:
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-07-05 10:04:56.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-07-05 12:02:24.000000000 +0200
> @@ -658,21 +658,7 @@ xfs_vn_setattr(
>  	struct dentry	*dentry,
>  	struct iattr	*iattr)
>  {
> -	struct inode	*inode = dentry->d_inode;
> -	int		error;
> -
> -	if (iattr->ia_valid & ATTR_ATIME)
> -		inode->i_atime = iattr->ia_atime;
> -
> -	if (iattr->ia_valid & ATTR_MODE) {
> -		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> -			inode->i_mode &= ~S_ISGID;
> -	}
> -
> -	error = xfs_setattr(XFS_I(inode), iattr, 0, NULL);
> -	if (likely(!error))
> -		vn_revalidate(vn_from_inode(inode));
> -	return -error;
> +	return -xfs_setattr(XFS_I(dentry->d_inode), iattr, 0, NULL);
>  }
>  
>  /*
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-07-05 10:04:17.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-07-05 12:02:24.000000000 +0200
> @@ -177,7 +177,6 @@ EXPORT_SYMBOL(uuid_hash64);
>  EXPORT_SYMBOL(uuid_is_nil);
>  EXPORT_SYMBOL(uuid_table_remove);
>  EXPORT_SYMBOL(vn_hold);
> -EXPORT_SYMBOL(vn_revalidate);
>  
>  #if defined(CONFIG_XFS_POSIX_ACL)
>  EXPORT_SYMBOL(xfs_acl_vtoacl);
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2008-07-05 10:02:09.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2008-07-05 10:04:57.000000000 +0200
> @@ -82,56 +82,6 @@ vn_ioerror(
>  		xfs_do_force_shutdown(ip->i_mount, SHUTDOWN_DEVICE_REQ, f, l);
>  }
>  
> -/*
> - * Revalidate the Linux inode from the XFS inode.
> - * Note: i_size _not_ updated; we must hold the inode
> - * semaphore when doing that - callers responsibility.
> - */
> -int
> -vn_revalidate(
> -	bhv_vnode_t		*vp)
> -{
> -	struct inode		*inode = vn_to_inode(vp);
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	struct xfs_mount	*mp = ip->i_mount;
> -	unsigned long		xflags;
> -
> -	xfs_itrace_entry(ip);
> -
> -	if (XFS_FORCED_SHUTDOWN(mp))
> -		return -EIO;
> -
> -	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	inode->i_mode	    = ip->i_d.di_mode;
> -	inode->i_uid	    = ip->i_d.di_uid;
> -	inode->i_gid	    = ip->i_d.di_gid;
> -	inode->i_mtime.tv_sec = ip->i_d.di_mtime.t_sec;
> -	inode->i_mtime.tv_nsec = ip->i_d.di_mtime.t_nsec;
> -	inode->i_ctime.tv_sec = ip->i_d.di_ctime.t_sec;
> -	inode->i_ctime.tv_nsec = ip->i_d.di_ctime.t_nsec;
> -
> -	xflags = xfs_ip2xflags(ip);
> -	if (xflags & XFS_XFLAG_IMMUTABLE)
> -		inode->i_flags |= S_IMMUTABLE;
> -	else
> -		inode->i_flags &= ~S_IMMUTABLE;
> -	if (xflags & XFS_XFLAG_APPEND)
> -		inode->i_flags |= S_APPEND;
> -	else
> -		inode->i_flags &= ~S_APPEND;
> -	if (xflags & XFS_XFLAG_SYNC)
> -		inode->i_flags |= S_SYNC;
> -	else
> -		inode->i_flags &= ~S_SYNC;
> -	if (xflags & XFS_XFLAG_NOATIME)
> -		inode->i_flags |= S_NOATIME;
> -	else
> -		inode->i_flags &= ~S_NOATIME;
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -
> -	xfs_iflags_clear(ip, XFS_IMODIFIED);
> -	return 0;
> -}
>  
>  /*
>   * Add a reference to a referenced vnode.
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-05 10:04:56.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-05 10:04:57.000000000 +0200
> @@ -67,7 +67,6 @@ static inline struct inode *vn_to_inode(
>  
>  
>  extern void	vn_init(void);
> -extern int	vn_revalidate(bhv_vnode_t *);
>  
>  /*
>   * Yeah, these don't take vnode anymore at all, all this should be
> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-07-05 10:04:56.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-07-05 10:04:57.000000000 +0200
> @@ -83,6 +83,7 @@ xfs_setattr(
>  	cred_t			*credp)
>  {
>  	xfs_mount_t		*mp = ip->i_mount;
> +	struct inode		*inode = XFS_ITOV(ip);
>  	int			mask = iattr->ia_valid;
>  	xfs_trans_t		*tp;
>  	int			code;
> @@ -446,6 +447,9 @@ xfs_setattr(
>  		ip->i_d.di_mode &= S_IFMT;
>  		ip->i_d.di_mode |= iattr->ia_mode & ~S_IFMT;
>  
> +		inode->i_mode &= S_IFMT;
> +		inode->i_mode |= iattr->ia_mode & ~S_IFMT;
> +
>  		xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
>  		timeflags |= XFS_ICHGTIME_CHG;
>  	}
> @@ -481,6 +485,7 @@ xfs_setattr(
>  							&ip->i_udquot, udqp);
>  			}
>  			ip->i_d.di_uid = uid;
> +			inode->i_uid = uid;
>  		}
>  		if (igid != gid) {
>  			if (XFS_IS_GQUOTA_ON(mp)) {
> @@ -491,6 +496,7 @@ xfs_setattr(
>  							&ip->i_gdquot, gdqp);
>  			}
>  			ip->i_d.di_gid = gid;
> +			inode->i_gid = gid;
>  		}
>  
>  		xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
> @@ -503,12 +509,14 @@ xfs_setattr(
>  	 */
>  	if (mask & (ATTR_ATIME|ATTR_MTIME)) {
>  		if (mask & ATTR_ATIME) {
> +			inode->i_atime = iattr->ia_atime;
>  			ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
>  			ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
>  			ip->i_update_core = 1;
>  			timeflags &= ~XFS_ICHGTIME_ACC;
>  		}
>  		if (mask & ATTR_MTIME) {
> +			inode->i_mtime = iattr->ia_mtime;
>  			ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
>  			ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
>  			timeflags &= ~XFS_ICHGTIME_MOD;
> @@ -524,6 +532,7 @@ xfs_setattr(
>  	 */
>  
>  	if ((flags & XFS_ATTR_DMI) && (mask & ATTR_CTIME)) {
> +		inode->i_ctime = iattr->ia_ctime;
>  		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
>  		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
>  		ip->i_update_core = 1;
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_xattr.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_xattr.c	2008-07-05 10:02:09.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_xattr.c	2008-07-05 12:02:24.000000000 +0200
> @@ -64,7 +64,7 @@ static int
>  xfs_xattr_system_set(struct inode *inode, const char *name,
>  		const void *value, size_t size, int flags)
>  {
> -	int error, acl;
> +	int acl;
>  
>  	acl = xfs_decode_acl(name);
>  	if (acl < 0)
> @@ -75,10 +75,7 @@ xfs_xattr_system_set(struct inode *inode
>  	if (!value)
>  		return xfs_acl_vremove(inode, acl);
>  
> -	error = xfs_acl_vset(inode, (void *)value, size, acl);
> -	if (!error)
> -		vn_revalidate(inode);
> -	return error;
> +	return xfs_acl_vset(inode, (void *)value, size, acl);
>  }
>  
>  static struct xattr_handler xfs_xattr_system_handler = {
> Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2008-07-05 12:26:45.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2008-07-05 12:26:53.000000000 +0200
> @@ -734,7 +734,7 @@ xfs_acl_setmode(
>  	 * Copy the u::, g::, o::, and m:: bits from the ACL into the
>  	 * mode.  The m:: bits take precedence over the g:: bits.
>  	 */
> -	iattr.ia_mask = XFS_AT_MODE;
> +	iattr.ia_valid = ATTR_MODE;
>  	iattr.ia_mode = xfs_vtoi(vp)->i_d.di_mode;
>  	iattr.ia_mode &= ~(S_IRWXU|S_IRWXG|S_IRWXO);
>  	ap = acl->acl_entry;
> 
