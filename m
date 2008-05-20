Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 23:35:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4K6ZgIG031387
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 23:35:43 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60BEF118768A
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 23:36:30 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id gyNWAXZGJZaZ49u4 for <xfs@oss.sgi.com>; Mon, 19 May 2008 23:36:30 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m4K6aMF3008910
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 08:36:22 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m4K6aMhn008908
	for xfs@oss.sgi.com; Tue, 20 May 2008 08:36:22 +0200
Date: Tue, 20 May 2008 08:36:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sanitize xfs_initialize_vnode
Message-ID: <20080520063622.GA8869@lst.de>
References: <20080502105215.GA17870@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502105215.GA17870@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

ping?

On Fri, May 02, 2008 at 12:52:15PM +0200, Christoph Hellwig wrote:
> Sanitize setting up the Linux indode.
> 
> Setting up the xfs_inode <-> inode link is opencoded in xfs_iget_core
> now because that's the only place it needs to be done,
> xfs_initialize_vnode is renamed to xfs_setup_inode and loses all
> superflous paramaters.  The check for I_NEW is removed because it always
> is true and the di_mode check moves into xfs_iget_core because it's only
> needed there.
> 
> xfs_set_inodeops and xfs_revalidate_inode are merged into
> xfs_setup_inode and the whole things is moved into xfs_iops.c where it
> belongs.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-05-02 08:41:27.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-05-02 08:51:46.000000000 +0200
> @@ -777,7 +777,7 @@ out_error:
>  	return error;
>  }
>  
> -const struct inode_operations xfs_inode_operations = {
> +static const struct inode_operations xfs_inode_operations = {
>  	.permission		= xfs_vn_permission,
>  	.truncate		= xfs_vn_truncate,
>  	.getattr		= xfs_vn_getattr,
> @@ -789,7 +789,7 @@ const struct inode_operations xfs_inode_
>  	.fallocate		= xfs_vn_fallocate,
>  };
>  
> -const struct inode_operations xfs_dir_inode_operations = {
> +static const struct inode_operations xfs_dir_inode_operations = {
>  	.create			= xfs_vn_create,
>  	.lookup			= xfs_vn_lookup,
>  	.link			= xfs_vn_link,
> @@ -808,7 +808,7 @@ const struct inode_operations xfs_dir_in
>  	.listxattr		= xfs_vn_listxattr,
>  };
>  
> -const struct inode_operations xfs_symlink_inode_operations = {
> +static const struct inode_operations xfs_symlink_inode_operations = {
>  	.readlink		= generic_readlink,
>  	.follow_link		= xfs_vn_follow_link,
>  	.put_link		= xfs_vn_put_link,
> @@ -820,3 +820,95 @@ const struct inode_operations xfs_symlin
>  	.removexattr		= generic_removexattr,
>  	.listxattr		= xfs_vn_listxattr,
>  };
> +
> +STATIC void
> +xfs_diflags_to_iflags(
> +	struct inode		*inode,
> +	struct xfs_inode	*ip)
> +{
> +	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
> +		inode->i_flags |= S_IMMUTABLE;
> +	else
> +		inode->i_flags &= ~S_IMMUTABLE;
> +	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
> +		inode->i_flags |= S_APPEND;
> +	else
> +		inode->i_flags &= ~S_APPEND;
> +	if (ip->i_d.di_flags & XFS_DIFLAG_SYNC)
> +		inode->i_flags |= S_SYNC;
> +	else
> +		inode->i_flags &= ~S_SYNC;
> +	if (ip->i_d.di_flags & XFS_DIFLAG_NOATIME)
> +		inode->i_flags |= S_NOATIME;
> +	else
> +		inode->i_flags &= ~S_NOATIME;
> +}
> +
> +/*
> + * Initialize the Linux inode, set up the operation vectors and
> + * unlock the inode.
> + *
> + * When reading existing inodes from disk this is called directly
> + * from xfs_iget, when creating a new inode it is called from
> + * xfs_ialloc after setting up the inode.
> + */
> +void
> +xfs_setup_inode(
> +	struct xfs_inode	*ip)
> +{
> +	struct inode		*inode = ip->i_vnode;
> +
> +	inode->i_mode	= ip->i_d.di_mode;
> +	inode->i_nlink	= ip->i_d.di_nlink;
> +	inode->i_uid	= ip->i_d.di_uid;
> +	inode->i_gid	= ip->i_d.di_gid;
> +
> +	switch (inode->i_mode & S_IFMT) {
> +	case S_IFBLK:
> +	case S_IFCHR:
> +		inode->i_rdev =
> +			MKDEV(sysv_major(ip->i_df.if_u2.if_rdev) & 0x1ff,
> +			      sysv_minor(ip->i_df.if_u2.if_rdev));
> +		break;
> +	default:
> +		inode->i_rdev = 0;
> +		break;
> +	}
> +
> +	inode->i_generation = ip->i_d.di_gen;
> +	i_size_write(inode, ip->i_d.di_size);
> +	inode->i_atime.tv_sec	= ip->i_d.di_atime.t_sec;
> +	inode->i_atime.tv_nsec	= ip->i_d.di_atime.t_nsec;
> +	inode->i_mtime.tv_sec	= ip->i_d.di_mtime.t_sec;
> +	inode->i_mtime.tv_nsec	= ip->i_d.di_mtime.t_nsec;
> +	inode->i_ctime.tv_sec	= ip->i_d.di_ctime.t_sec;
> +	inode->i_ctime.tv_nsec	= ip->i_d.di_ctime.t_nsec;
> +	xfs_diflags_to_iflags(inode, ip);
> +	xfs_iflags_clear(ip, XFS_IMODIFIED);
> +
> +	switch (inode->i_mode & S_IFMT) {
> +	case S_IFREG:
> +		inode->i_op = &xfs_inode_operations;
> +		inode->i_fop = &xfs_file_operations;
> +		inode->i_mapping->a_ops = &xfs_address_space_operations;
> +		break;
> +	case S_IFDIR:
> +		inode->i_op = &xfs_dir_inode_operations;
> +		inode->i_fop = &xfs_dir_file_operations;
> +		break;
> +	case S_IFLNK:
> +		inode->i_op = &xfs_symlink_inode_operations;
> +		if (!(ip->i_df.if_flags & XFS_IFINLINE))
> +			inode->i_mapping->a_ops = &xfs_address_space_operations;
> +		break;
> +	default:
> +		inode->i_op = &xfs_inode_operations;
> +		init_special_inode(inode, inode->i_mode, inode->i_rdev);
> +		break;
> +	}
> +
> +	xfs_iflags_clear(ip, XFS_INEW);
> +	barrier();
> +
> +	unlock_new_inode(inode);
> +}
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.h	2008-05-02 08:41:27.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h	2008-05-02 08:41:35.000000000 +0200
> @@ -18,9 +18,7 @@
>  #ifndef __XFS_IOPS_H__
>  #define __XFS_IOPS_H__
>  
> -extern const struct inode_operations xfs_inode_operations;
> -extern const struct inode_operations xfs_dir_inode_operations;
> -extern const struct inode_operations xfs_symlink_inode_operations;
> +struct xfs_inode;
>  
>  extern const struct file_operations xfs_file_operations;
>  extern const struct file_operations xfs_dir_file_operations;
> @@ -28,10 +26,11 @@ extern const struct file_operations xfs_
>  
>  extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
>  
> -struct xfs_inode;
>  extern void xfs_ichgtime(struct xfs_inode *, int);
>  extern void xfs_ichgtime_fast(struct xfs_inode *, struct inode *, int);
>  
> +extern void xfs_setup_inode(struct xfs_inode *);
> +
>  #define xfs_vtoi(vp) \
>  	((struct xfs_inode *)vn_to_inode(vp)->i_private)
>  
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-05-02 08:41:27.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-05-02 08:41:35.000000000 +0200
> @@ -155,12 +155,9 @@ EXPORT_SYMBOL(kmem_zone_free);
>  EXPORT_SYMBOL(kmem_zone_init);
>  EXPORT_SYMBOL(kmem_zone_zalloc);
>  EXPORT_SYMBOL(xfs_address_space_operations);
> -EXPORT_SYMBOL(xfs_dir_inode_operations);
>  EXPORT_SYMBOL(xfs_dir_file_operations);
> -EXPORT_SYMBOL(xfs_inode_operations);
>  EXPORT_SYMBOL(xfs_file_operations);
>  EXPORT_SYMBOL(xfs_invis_file_operations);
> -EXPORT_SYMBOL(xfs_symlink_inode_operations);
>  EXPORT_SYMBOL(xfs_buf_delwri_dequeue);
>  EXPORT_SYMBOL(_xfs_buf_find);
>  EXPORT_SYMBOL(xfs_buf_iostart);
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-05-02 08:41:34.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-05-02 08:51:43.000000000 +0200
> @@ -558,115 +558,6 @@ xfs_max_file_offset(
>  	return (((__uint64_t)pagefactor) << bitshift) - 1;
>  }
>  
> -STATIC_INLINE void
> -xfs_set_inodeops(
> -	struct inode		*inode)
> -{
> -	switch (inode->i_mode & S_IFMT) {
> -	case S_IFREG:
> -		inode->i_op = &xfs_inode_operations;
> -		inode->i_fop = &xfs_file_operations;
> -		inode->i_mapping->a_ops = &xfs_address_space_operations;
> -		break;
> -	case S_IFDIR:
> -		inode->i_op = &xfs_dir_inode_operations;
> -		inode->i_fop = &xfs_dir_file_operations;
> -		break;
> -	case S_IFLNK:
> -		inode->i_op = &xfs_symlink_inode_operations;
> -		if (!(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE))
> -			inode->i_mapping->a_ops = &xfs_address_space_operations;
> -		break;
> -	default:
> -		inode->i_op = &xfs_inode_operations;
> -		init_special_inode(inode, inode->i_mode, inode->i_rdev);
> -		break;
> -	}
> -}
> -
> -STATIC_INLINE void
> -xfs_revalidate_inode(
> -	xfs_mount_t		*mp,
> -	bhv_vnode_t		*vp,
> -	xfs_inode_t		*ip)
> -{
> -	struct inode		*inode = vn_to_inode(vp);
> -
> -	inode->i_mode	= ip->i_d.di_mode;
> -	inode->i_nlink	= ip->i_d.di_nlink;
> -	inode->i_uid	= ip->i_d.di_uid;
> -	inode->i_gid	= ip->i_d.di_gid;
> -
> -	switch (inode->i_mode & S_IFMT) {
> -	case S_IFBLK:
> -	case S_IFCHR:
> -		inode->i_rdev =
> -			MKDEV(sysv_major(ip->i_df.if_u2.if_rdev) & 0x1ff,
> -			      sysv_minor(ip->i_df.if_u2.if_rdev));
> -		break;
> -	default:
> -		inode->i_rdev = 0;
> -		break;
> -	}
> -
> -	inode->i_generation = ip->i_d.di_gen;
> -	i_size_write(inode, ip->i_d.di_size);
> -	inode->i_atime.tv_sec	= ip->i_d.di_atime.t_sec;
> -	inode->i_atime.tv_nsec	= ip->i_d.di_atime.t_nsec;
> -	inode->i_mtime.tv_sec	= ip->i_d.di_mtime.t_sec;
> -	inode->i_mtime.tv_nsec	= ip->i_d.di_mtime.t_nsec;
> -	inode->i_ctime.tv_sec	= ip->i_d.di_ctime.t_sec;
> -	inode->i_ctime.tv_nsec	= ip->i_d.di_ctime.t_nsec;
> -	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
> -		inode->i_flags |= S_IMMUTABLE;
> -	else
> -		inode->i_flags &= ~S_IMMUTABLE;
> -	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
> -		inode->i_flags |= S_APPEND;
> -	else
> -		inode->i_flags &= ~S_APPEND;
> -	if (ip->i_d.di_flags & XFS_DIFLAG_SYNC)
> -		inode->i_flags |= S_SYNC;
> -	else
> -		inode->i_flags &= ~S_SYNC;
> -	if (ip->i_d.di_flags & XFS_DIFLAG_NOATIME)
> -		inode->i_flags |= S_NOATIME;
> -	else
> -		inode->i_flags &= ~S_NOATIME;
> -	xfs_iflags_clear(ip, XFS_IMODIFIED);
> -}
> -
> -void
> -xfs_initialize_vnode(
> -	struct xfs_mount	*mp,
> -	bhv_vnode_t		*vp,
> -	struct xfs_inode	*ip)
> -{
> -	struct inode		*inode = vn_to_inode(vp);
> -
> -	if (!ip->i_vnode) {
> -		ip->i_vnode = vp;
> -		inode->i_private = ip;
> -	}
> -
> -	/*
> -	 * We need to set the ops vectors, and unlock the inode, but if
> -	 * we have been called during the new inode create process, it is
> -	 * too early to fill in the Linux inode.  We will get called a
> -	 * second time once the inode is properly set up, and then we can
> -	 * finish our work.
> -	 */
> -	if (ip->i_d.di_mode != 0 && (inode->i_state & I_NEW)) {
> -		xfs_revalidate_inode(mp, vp, ip);
> -		xfs_set_inodeops(inode);
> -
> -		xfs_iflags_clear(ip, XFS_INEW);
> -		barrier();
> -
> -		unlock_new_inode(inode);
> -	}
> -}
> -
>  int
>  xfs_blkdev_get(
>  	xfs_mount_t		*mp,
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.h	2008-05-02 08:41:27.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h	2008-05-02 08:41:35.000000000 +0200
> @@ -72,9 +72,6 @@ struct block_device;
>  
>  extern __uint64_t xfs_max_file_offset(unsigned int);
>  
> -extern void xfs_initialize_vnode(struct xfs_mount *mp, bhv_vnode_t *vp,
> -		struct xfs_inode *ip);
> -
>  extern void xfs_flush_inode(struct xfs_inode *);
>  extern void xfs_flush_device(struct xfs_inode *);
>  
> Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2008-05-02 08:41:27.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2008-05-02 08:53:18.000000000 +0200
> @@ -288,10 +288,17 @@ finish_inode:
>  	*ipp = ip;
>  
>  	/*
> +	 * Set up the Linux with the Linux inode.
> +	 */
> +	ip->i_vnode = inode;
> +	inode->i_private = ip;
> +
> +	/*
>  	 * If we have a real type for an on-disk inode, we can set ops(&unlock)
>  	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
>  	 */
> -	xfs_initialize_vnode(mp, inode, ip);
> +	if (ip->i_d.di_mode != 0)
> +		xfs_setup_inode(ip);
>  	return 0;
>  }
>  
> Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-05-02 08:41:27.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-05-02 08:41:35.000000000 +0200
> @@ -1046,7 +1046,6 @@ xfs_ialloc(
>  {
>  	xfs_ino_t	ino;
>  	xfs_inode_t	*ip;
> -	bhv_vnode_t	*vp;
>  	uint		flags;
>  	int		error;
>  
> @@ -1077,7 +1076,6 @@ xfs_ialloc(
>  	}
>  	ASSERT(ip != NULL);
>  
> -	vp = XFS_ITOV(ip);
>  	ip->i_d.di_mode = (__uint16_t)mode;
>  	ip->i_d.di_onlink = 0;
>  	ip->i_d.di_nlink = nlink;
> @@ -1220,7 +1218,7 @@ xfs_ialloc(
>  	xfs_trans_log_inode(tp, ip, flags);
>  
>  	/* now that we have an i_mode we can setup inode ops and unlock */
> -	xfs_initialize_vnode(tp->t_mountp, vp, ip);
> +	xfs_setup_inode(ip);
>  
>  	*ipp = ip;
>  	return 0;
---end quoted text---
