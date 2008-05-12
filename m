Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 May 2008 18:47:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4C1kuuU008572
	for <xfs@oss.sgi.com>; Sun, 11 May 2008 18:47:03 -0700
Date: Mon, 12 May 2008 11:47:21 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] kill attr_capable callbacks
Message-ID: <20080512014721.GV155679365@sgi.com>
References: <20080430112213.GA16966@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430112213.GA16966@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Tim,

Seeing you are working on xattr stuff right now, can you pick this up?
(and the followup patch as well?)

Cheers,

Dave.

On Wed, Apr 30, 2008 at 01:22:13PM +0200, Christoph Hellwig wrote:
> No need for addition permission checks in the xattr handler,
> fs/xattr.c:xattr_permission() already does them, and in fact slightly
> more strict then what was in the attr_capable handlers.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-04-29 21:32:56.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-04-29 21:33:30.000000000 +0200
> @@ -747,15 +747,11 @@ xfs_vn_setxattr(
>  	char		*attr = (char *)name;
>  	attrnames_t	*namesp;
>  	int		xflags = 0;
> -	int		error;
>  
>  	namesp = attr_lookup_namespace(attr, attr_namespaces, ATTR_NAMECOUNT);
>  	if (!namesp)
>  		return -EOPNOTSUPP;
>  	attr += namesp->attr_namelen;
> -	error = namesp->attr_capable(vp, NULL);
> -	if (error)
> -		return error;
>  
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (flags & XATTR_CREATE)
> @@ -777,15 +773,11 @@ xfs_vn_getxattr(
>  	char		*attr = (char *)name;
>  	attrnames_t	*namesp;
>  	int		xflags = 0;
> -	ssize_t		error;
>  
>  	namesp = attr_lookup_namespace(attr, attr_namespaces, ATTR_NAMECOUNT);
>  	if (!namesp)
>  		return -EOPNOTSUPP;
>  	attr += namesp->attr_namelen;
> -	error = namesp->attr_capable(vp, NULL);
> -	if (error)
> -		return error;
>  
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (!size) {
> @@ -825,15 +817,12 @@ xfs_vn_removexattr(
>  	char		*attr = (char *)name;
>  	attrnames_t	*namesp;
>  	int		xflags = 0;
> -	int		error;
>  
>  	namesp = attr_lookup_namespace(attr, attr_namespaces, ATTR_NAMECOUNT);
>  	if (!namesp)
>  		return -EOPNOTSUPP;
>  	attr += namesp->attr_namelen;
> -	error = namesp->attr_capable(vp, NULL);
> -	if (error)
> -		return error;
> +
>  	xflags |= namesp->attr_flag;
>  	return namesp->attr_remove(vp, attr, xflags);
>  }
> Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c	2008-04-29 21:32:25.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_attr.c	2008-04-29 21:32:51.000000000 +0200
> @@ -2622,43 +2622,6 @@ attr_lookup_namespace(
>  	return NULL;
>  }
>  
> -/*
> - * Some checks to prevent people abusing EAs to get over quota:
> - * - Don't allow modifying user EAs on devices/symlinks;
> - * - Don't allow modifying user EAs if sticky bit set;
> - */
> -STATIC int
> -attr_user_capable(
> -	bhv_vnode_t	*vp,
> -	cred_t		*cred)
> -{
> -	struct inode	*inode = vn_to_inode(vp);
> -
> -	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> -		return -EPERM;
> -	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode) &&
> -	    !capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> -	if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
> -	    (current_fsuid(cred) != inode->i_uid) && !capable(CAP_FOWNER))
> -		return -EPERM;
> -	return 0;
> -}
> -
> -STATIC int
> -attr_trusted_capable(
> -	bhv_vnode_t	*vp,
> -	cred_t		*cred)
> -{
> -	struct inode	*inode = vn_to_inode(vp);
> -
> -	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
> -		return -EPERM;
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> -	return 0;
> -}
> -
>  STATIC int
>  attr_system_set(
>  	bhv_vnode_t *vp, char *name, void *data, size_t size, int xflags)
> @@ -2709,7 +2672,6 @@ struct attrnames attr_system = {
>  	.attr_get	= attr_system_get,
>  	.attr_set	= attr_system_set,
>  	.attr_remove	= attr_system_remove,
> -	.attr_capable	= (attrcapable_t)fs_noerr,
>  };
>  
>  struct attrnames attr_trusted = {
> @@ -2719,7 +2681,6 @@ struct attrnames attr_trusted = {
>  	.attr_get	= attr_generic_get,
>  	.attr_set	= attr_generic_set,
>  	.attr_remove	= attr_generic_remove,
> -	.attr_capable	= attr_trusted_capable,
>  };
>  
>  struct attrnames attr_secure = {
> @@ -2729,7 +2690,6 @@ struct attrnames attr_secure = {
>  	.attr_get	= attr_generic_get,
>  	.attr_set	= attr_generic_set,
>  	.attr_remove	= attr_generic_remove,
> -	.attr_capable	= (attrcapable_t)fs_noerr,
>  };
>  
>  struct attrnames attr_user = {
> @@ -2738,7 +2698,6 @@ struct attrnames attr_user = {
>  	.attr_get	= attr_generic_get,
>  	.attr_set	= attr_generic_set,
>  	.attr_remove	= attr_generic_remove,
> -	.attr_capable	= attr_user_capable,
>  };
>  
>  struct attrnames *attr_namespaces[] =
> Index: linux-2.6-xfs/fs/xfs/xfs_attr.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_attr.h	2008-04-29 21:33:38.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_attr.h	2008-04-29 21:33:52.000000000 +0200
> @@ -42,7 +42,6 @@ typedef int (*attrset_t)(bhv_vnode_t *, 
>  typedef int (*attrget_t)(bhv_vnode_t *, char *, void *, size_t, int);
>  typedef int (*attrremove_t)(bhv_vnode_t *, char *, int);
>  typedef int (*attrexists_t)(bhv_vnode_t *);
> -typedef int (*attrcapable_t)(bhv_vnode_t *, struct cred *);
>  
>  typedef struct attrnames {
>  	char *		attr_name;
> @@ -52,7 +51,6 @@ typedef struct attrnames {
>  	attrset_t	attr_set;
>  	attrremove_t	attr_remove;
>  	attrexists_t	attr_exists;
> -	attrcapable_t	attr_capable;
>  } attrnames_t;
>  
>  #define ATTR_NAMECOUNT	4
> 

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
