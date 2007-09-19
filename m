Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 08:47:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8JFlQv0001339
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 08:47:34 -0700
Message-ID: <46F0876A.5090809@sgi.com>
Date: Wed, 19 Sep 2007 12:20:26 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] simplify vn_revalidate
References: <20070914162752.GC7110@lst.de>
In-Reply-To: <20070914162752.GC7110@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Anyone know why we don't copy the atime across?

Should we be marking the inode dirty at the end of vn_revalidate()?

Christoph Hellwig wrote:
> No need to allocate a bhv_vattr_t on stack and call xfs_getattr to
> update a few fields in the Linux inode from the XFS inode, just
> do it directly.
> 
> And yes, this function is in dire need of a better name and prototype,
> I'll do in a separate patch, though.
Good to know, thanks.

> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-09-06 10:18:02.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2007-09-06 10:26:33.000000000 +0200
> @@ -1217,7 +1217,7 @@ xfs_ioc_xattr(
>  
>  		error = xfs_setattr(ip, vattr, attr_flags, NULL);
>  		if (likely(!error))
> -			__vn_revalidate(vp, vattr);	/* update flags */
> +			vn_revalidate(vp);	/* update flags */
>  		error = -error;
>  		break;
>  	}
> @@ -1273,7 +1273,7 @@ xfs_ioc_xattr(
>  
>  		error = xfs_setattr(ip, vattr, attr_flags, NULL);
>  		if (likely(!error))
> -			__vn_revalidate(vp, vattr);	/* update flags */
> +			vn_revalidate(vp);	/* update flags */
>  		error = -error;
>  		break;
>  	}
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-09-06 10:25:54.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-09-06 10:26:33.000000000 +0200
> @@ -645,7 +645,7 @@ xfs_vn_setattr(
>  
>  	error = xfs_setattr(XFS_I(inode), &vattr, flags, NULL);
>  	if (likely(!error))
> -		__vn_revalidate(vn_from_inode(inode), &vattr);
> +		vn_revalidate(vn_from_inode(inode));
>  	return -error;
>  }
>  
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-09-06 10:18:00.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-09-06 10:26:33.000000000 +0200
> @@ -183,7 +183,6 @@ EXPORT_SYMBOL(uuid_table_remove);
>  EXPORT_SYMBOL(vn_hold);
>  EXPORT_SYMBOL(vn_initialize);
>  EXPORT_SYMBOL(vn_revalidate);
> -EXPORT_SYMBOL(vn_revalidate_core);
>  
>  #if defined(CONFIG_XFS_POSIX_ACL)
>  EXPORT_SYMBOL(xfs_acl_vtoacl);
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2007-09-06 10:18:00.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2007-09-06 10:38:40.000000000 +0200
> @@ -97,69 +97,57 @@ vn_initialize(
>  }
>  
>  /*
> - * Revalidate the Linux inode from the vattr.
> + * Revalidate the Linux inode from the XFS inode.
>   * Note: i_size _not_ updated; we must hold the inode
>   * semaphore when doing that - callers responsibility.
>   */
> -void
> -vn_revalidate_core(
> -	bhv_vnode_t	*vp,
> -	bhv_vattr_t	*vap)
> -{
> -	struct inode	*inode = vn_to_inode(vp);
> -
> -	inode->i_mode	    = vap->va_mode;
> -	inode->i_nlink	    = vap->va_nlink;
> -	inode->i_uid	    = vap->va_uid;
> -	inode->i_gid	    = vap->va_gid;
> -	inode->i_blocks	    = vap->va_nblocks;
> -	inode->i_mtime	    = vap->va_mtime;
> -	inode->i_ctime	    = vap->va_ctime;
> -	if (vap->va_xflags & XFS_XFLAG_IMMUTABLE)
> +int
> +vn_revalidate(
> +	bhv_vnode_t		*vp)
> +{
> +	struct inode		*inode = vn_to_inode(vp);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	unsigned long		xflags;
> +
> +	xfs_itrace_entry(ip);
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -EIO;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	inode->i_mode	    = ip->i_d.di_mode;
> +	inode->i_nlink	    = ip->i_d.di_nlink;
> +	inode->i_uid	    = ip->i_d.di_uid;
> +	inode->i_gid	    = ip->i_d.di_gid;
> +	inode->i_blocks	    =
> +		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
> +	inode->i_mtime.tv_sec = ip->i_d.di_mtime.t_sec;
> +	inode->i_mtime.tv_nsec = ip->i_d.di_mtime.t_nsec;
> +	inode->i_ctime.tv_sec = ip->i_d.di_ctime.t_sec;
> +	inode->i_ctime.tv_nsec = ip->i_d.di_ctime.t_nsec;
> +
> +	xflags = xfs_ip2xflags(ip);
> +	if (xflags & XFS_XFLAG_IMMUTABLE)
>  		inode->i_flags |= S_IMMUTABLE;
>  	else
>  		inode->i_flags &= ~S_IMMUTABLE;
> -	if (vap->va_xflags & XFS_XFLAG_APPEND)
> +	if (xflags & XFS_XFLAG_APPEND)
>  		inode->i_flags |= S_APPEND;
>  	else
>  		inode->i_flags &= ~S_APPEND;
> -	if (vap->va_xflags & XFS_XFLAG_SYNC)
> +	if (xflags & XFS_XFLAG_SYNC)
>  		inode->i_flags |= S_SYNC;
>  	else
>  		inode->i_flags &= ~S_SYNC;
> -	if (vap->va_xflags & XFS_XFLAG_NOATIME)
> +	if (xflags & XFS_XFLAG_NOATIME)
>  		inode->i_flags |= S_NOATIME;
>  	else
>  		inode->i_flags &= ~S_NOATIME;
> -}
> -
> -/*
> - * Revalidate the Linux inode from the vnode.
> - */
> -int
> -__vn_revalidate(
> -	bhv_vnode_t	*vp,
> -	bhv_vattr_t	*vattr)
> -{
> -	int		error;
> -
> -	xfs_itrace_entry(xfs_vtoi(vp));
> -	vattr->va_mask = XFS_AT_STAT | XFS_AT_XFLAGS;
> -	error = xfs_getattr(xfs_vtoi(vp), vattr, 0);
> -	if (likely(!error)) {
> -		vn_revalidate_core(vp, vattr);
> -		xfs_iflags_clear(xfs_vtoi(vp), XFS_IMODIFIED);
> -	}
> -	return -error;
> -}
> -
> -int
> -vn_revalidate(
> -	bhv_vnode_t	*vp)
> -{
> -	bhv_vattr_t	vattr;
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  
> -	return __vn_revalidate(vp, &vattr);
> +	xfs_iflags_clear(ip, XFS_IMODIFIED);
> +	return 0;
>  }
>  
>  /*
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-09-06 10:18:50.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-09-06 10:26:33.000000000 +0200
> @@ -189,8 +189,6 @@ typedef struct bhv_vattr {
>  extern void	vn_init(void);
>  extern bhv_vnode_t	*vn_initialize(struct inode *);
>  extern int	vn_revalidate(bhv_vnode_t *);
> -extern int	__vn_revalidate(bhv_vnode_t *, bhv_vattr_t *);
> -extern void	vn_revalidate_core(bhv_vnode_t *, bhv_vattr_t *);
>  
>  /*
>   * Yeah, these don't take vnode anymore at all, all this should be
> 
> 
> 
