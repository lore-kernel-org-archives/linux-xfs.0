Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 12:50:49 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NJoa4l012041
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:50:40 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67F551B3E7E4
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:51:46 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id w6u3765F3Dt4dDRj for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:51:46 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NJpbNg006773
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 21:51:37 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NJpbWQ006771
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 21:51:37 +0200
Date: Wed, 23 Jul 2008 21:51:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove dead inode flags
Message-ID: <20080723195137.GB6645@lst.de>
References: <20080723142630.GA22859@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723142630.GA22859@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Btw, this needs "[PATCH] sanitize xfs_initialize_vnode" applied first.

On Wed, Jul 23, 2008 at 04:26:30PM +0200, Christoph Hellwig wrote:
> There are a few inode flags around that aren't used anywhere, so remove
> them.  Also update xfsidbg to display all used inode flags correctly.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-07-23 15:11:57.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-07-23 15:12:00.000000000 +0200
> @@ -2481,7 +2481,6 @@ xfs_dm_punch_hole(
>  	/* Let threads in send_data_event know we punched the file. */
>  	ip->i_d.di_dmstate++;
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> -	xfs_iflags_set(ip, XFS_IMODIFIED);
>  
>  up_and_out:
>  	up_rw_sems(inode, DM_SEM_FLAG_WR);
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2008-07-23 15:11:38.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2008-07-23 15:12:00.000000000 +0200
> @@ -318,14 +318,9 @@ xfs_map_blocks(
>  	xfs_iomap_t		*mapp,
>  	int			flags)
>  {
> -	xfs_inode_t		*ip = XFS_I(inode);
> -	int			error, nmaps = 1;
> +	int			nmaps = 1;
>  
> -	error = xfs_iomap(ip, offset, count,
> -				flags, mapp, &nmaps);
> -	if (!error && (flags & (BMAPI_WRITE|BMAPI_ALLOCATE)))
> -		xfs_iflags_set(ip, XFS_IMODIFIED);
> -	return -error;
> +	return -xfs_iomap(XFS_I(inode), offset, count, flags, mapp, &nmaps);
>  }
>  
>  STATIC_INLINE int
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2008-07-23 15:11:38.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c	2008-07-23 15:12:00.000000000 +0200
> @@ -407,11 +407,8 @@ xfs_file_ioctl(
>  	unsigned int	cmd,
>  	unsigned long	p)
>  {
> -	int		error;
>  	struct inode	*inode = filp->f_path.dentry->d_inode;
>  
> -	error = xfs_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
> -	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
>  
>  	/* NOTE:  some of the ioctl's return positive #'s as a
>  	 *	  byte count indicating success, such as
> @@ -419,7 +416,7 @@ xfs_file_ioctl(
>  	 *	  like most other routines.  This means true
>  	 *	  errors need to be returned as a negative value.
>  	 */
> -	return error;
> +	return xfs_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
>  }
>  
>  STATIC long
> @@ -428,11 +425,8 @@ xfs_file_ioctl_invis(
>  	unsigned int	cmd,
>  	unsigned long	p)
>  {
> -	int		error;
>  	struct inode	*inode = filp->f_path.dentry->d_inode;
>  
> -	error = xfs_ioctl(XFS_I(inode), filp, IO_INVIS, cmd, (void __user *)p);
> -	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
>  
>  	/* NOTE:  some of the ioctl's return positive #'s as a
>  	 *	  byte count indicating success, such as
> @@ -440,7 +434,7 @@ xfs_file_ioctl_invis(
>  	 *	  like most other routines.  This means true
>  	 *	  errors need to be returned as a negative value.
>  	 */
> -	return error;
> +	return xfs_ioctl(XFS_I(inode), filp, IO_INVIS, cmd, (void __user *)p);
>  }
>  
>  #ifdef HAVE_DMAPI
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-07-23 15:11:44.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-07-23 15:12:14.000000000 +0200
> @@ -214,8 +214,6 @@ xfs_init_security(
>  	}
>  
>  	error = xfs_attr_set(ip, name, value, length, ATTR_SECURE);
> -	if (!error)
> -		xfs_iflags_set(ip, XFS_IMODIFIED);
>  
>  	kfree(name);
>  	kfree(value);
> @@ -316,7 +314,6 @@ xfs_vn_mknod(
>  		error = _ACL_INHERIT(inode, mode, default_acl);
>  		if (unlikely(error))
>  			goto out_cleanup_inode;
> -		xfs_iflags_set(ip, XFS_IMODIFIED);
>  		_ACL_FREE(default_acl);
>  	}
>  
> @@ -436,7 +433,6 @@ xfs_vn_link(
>  		return -error;
>  	}
>  
> -	xfs_iflags_set(XFS_I(dir), XFS_IMODIFIED);
>  	d_instantiate(dentry, inode);
>  	return 0;
>  }
> @@ -856,7 +852,6 @@ xfs_setup_inode(
>  	inode->i_ctime.tv_sec	= ip->i_d.di_ctime.t_sec;
>  	inode->i_ctime.tv_nsec	= ip->i_d.di_ctime.t_nsec;
>  	xfs_diflags_to_iflags(inode, ip);
> -	xfs_iflags_clear(ip, XFS_IMODIFIED);
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFREG:
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-07-23 15:12:23.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-07-23 15:12:38.000000000 +0200
> @@ -375,7 +375,6 @@ xfs_compat_ioctl(
>  	unsigned long	arg)
>  {
>  	struct inode	*inode = file->f_path.dentry->d_inode;
> -	int		error;
>  
>  	switch (cmd) {
>  	case XFS_IOC_DIOINFO:
> @@ -463,10 +462,7 @@ xfs_compat_ioctl(
>  		return -ENOIOCTLCMD;
>  	}
>  
> -	error = xfs_ioctl(XFS_I(inode), file, mode, cmd, (void __user *)arg);
> -	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
> -
> -	return error;
> +	return xfs_ioctl(XFS_I(inode), file, mode, cmd, (void __user *)arg);
>  }
>  
>  long
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 15:12:17.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 15:12:19.000000000 +0200
> @@ -993,7 +993,6 @@ xfs_fs_clear_inode(
>  		XFS_STATS_DEC(vn_active);
>  
>  		xfs_inactive(ip);
> -		xfs_iflags_clear(ip, XFS_IMODIFIED);
>  		if (xfs_reclaim(ip))
>  			panic("%s: cannot reclaim 0x%p\n", __func__, inode);
>  	}
> Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2008-07-23 15:12:46.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2008-07-23 15:12:52.000000000 +0200
> @@ -284,7 +284,6 @@ finish_inode:
>  	ASSERT(ip->i_df.if_ext_max ==
>  	       XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t));
>  
> -	xfs_iflags_set(ip, XFS_IMODIFIED);
>  	*ipp = ip;
>  
>  	/*
> Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-07-23 15:13:05.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-07-23 15:17:20.000000000 +0200
> @@ -364,17 +364,12 @@ xfs_iflags_test_and_clear(xfs_inode_t *i
>  /*
>   * In-core inode flags.
>   */
> -#define XFS_IGRIO	0x0001  /* inode used for guaranteed rate i/o */
> -#define XFS_IUIOSZ	0x0002  /* inode i/o sizes have been explicitly set */
> -#define XFS_IQUIESCE    0x0004  /* we have started quiescing for this inode */
> -#define XFS_IRECLAIM    0x0008  /* we have started reclaiming this inode    */
> -#define XFS_ISTALE	0x0010	/* inode has been staled */
> -#define XFS_IRECLAIMABLE 0x0020 /* inode can be reclaimed */
> -#define XFS_INEW	0x0040
> -#define XFS_IFILESTREAM	0x0080	/* inode is in a filestream directory */
> -#define XFS_IMODIFIED	0x0100	/* XFS inode state possibly differs */
> -				/* to the Linux inode state. */
> -#define XFS_ITRUNCATED	0x0200	/* truncated down so flush-on-close */
> +#define XFS_IRECLAIM    0x0001  /* we have started reclaiming this inode    */
> +#define XFS_ISTALE	0x0002	/* inode has been staled */
> +#define XFS_IRECLAIMABLE 0x0004 /* inode can be reclaimed */
> +#define XFS_INEW	0x0008	/* inode has just been allocated */
> +#define XFS_IFILESTREAM	0x0010	/* inode is in a filestream directory */
> +#define XFS_ITRUNCATED	0x0020	/* truncated down so flush-on-close */
>  
>  /*
>   * Flags for inode locking.
> Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-07-23 15:12:57.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-07-23 15:16:58.000000000 +0200
> @@ -155,7 +155,6 @@ static void	xfsidbg_xiclogall(xlog_in_co
>  static void	xfsidbg_xiclogcb(xlog_in_core_t *);
>  static void	xfsidbg_xinodes(xfs_mount_t *);
>  static void	xfsidbg_delayed_blocks(xfs_mount_t *);
> -static void	xfsidbg_xinodes_quiesce(xfs_mount_t *);
>  static void	xfsidbg_xlog(xlog_t *);
>  static void	xfsidbg_xlog_ritem(xlog_recover_item_t *);
>  static void	xfsidbg_xlog_rtrans(xlog_recover_t *);
> @@ -1280,26 +1279,6 @@ static int	kdbm_xfs_delayed_blocks(
>  	return 0;
>  }
>  
> -
> -static int	kdbm_xfs_xinodes_quiesce(
> -	int	argc,
> -	const char **argv)
> -{
> -	unsigned long addr;
> -	int nextarg = 1;
> -	long offset = 0;
> -	int diag;
> -
> -	if (argc != 1)
> -		return KDB_ARGCOUNT;
> -	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
> -	if (diag)
> -		return diag;
> -
> -	xfsidbg_xinodes_quiesce((xfs_mount_t *) addr);
> -	return 0;
> -}
> -
>  static int	kdbm_xfs_xlog(
>  	int	argc,
>  	const char **argv)
> @@ -2374,8 +2353,6 @@ static struct xif xfsidbg_funcs[] = {
>  #endif
>    {  "xinodes",	kdbm_xfs_xinodes,	"<xfs_mount_t>",
>  				"Dump XFS inodes per mount"},
> -  {  "xquiesce",kdbm_xfs_xinodes_quiesce, "<xfs_mount_t>",
> -				"Dump non-quiesced XFS inodes per mount"},
>  #ifdef XFS_LOG_TRACE
>    {  "xl_grtr",	kdbm_xfs_xlog_granttrace,	"<xlog_t>",
>  				"Dump XFS log grant trace" },
> @@ -5776,28 +5753,6 @@ xfsidbg_delayed_blocks(xfs_mount_t *mp)
>  	kdb_printf("delayed blocks total: %d in %d inodes\n", total, icount);
>  }
>  
> -static void
> -xfsidbg_xinodes_quiesce(xfs_mount_t *mp)
> -{
> -	xfs_inode_t	*ip;
> -
> -	kdb_printf("xfs_mount at 0x%p\n", mp);
> -	ip = mp->m_inodes;
> -	if (ip != NULL) {
> -		do {
> -			if (ip->i_mount == NULL) {
> -				ip = ip->i_mnext;
> -				continue;
> -			}
> -			if (!(ip->i_flags & XFS_IQUIESCE)) {
> -				kdb_printf("ip 0x%p not quiesced\n", ip);
> -			}
> -			ip = ip->i_mnext;
> -		} while (ip != mp->m_inodes);
> -	}
> -	kdb_printf("\nEnd of Inodes\n");
> -}
> -
>  static char *
>  xfsidbg_get_cstate(int state)
>  {
> @@ -6399,12 +6354,11 @@ static void
>  xfsidbg_xnode(xfs_inode_t *ip)
>  {
>  	static char *tab_flags[] = {
> -		"grio",		/* XFS_IGRIO */
> -		"uiosize",	/* XFS_IUIOSZ */
> -		"quiesce",	/* XFS_IQUIESCE */
>  		"reclaim",	/* XFS_IRECLAIM */
>  		"stale",	/* XFS_ISTALE */
> -		"modified",	/* XFS_IMODIFIED */
> +		"reclaimable",	/* XFS_IRECLAIMABLE */
> +		"new",		/* XFS_INEW */
> +		"filestream",	/* XFS_IFILESTREAM */
>  		"truncated",	/* XFS_ITRUNCATED */
>  		NULL
>  	};
---end quoted text---
