Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:49:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDmlFY027424
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:47 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 203C754B902
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id dAd0vfr19oWcyOL9 for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:48:46 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSSc-0001gE-Br
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:48:46 +0000
Date: Mon, 27 Oct 2008 09:48:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/10] kill dead inode flags
Message-ID: <20081027134846.GC6440@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-kill-dead-inode-flags
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

There are a few inode flags around that aren't used anywhere, so remove
them.  Also update xfsidbg to display all used inode flags correctly.

(First sent on July 23nd)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-10-25 13:00:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-10-25 13:15:42.000000000 +0200
@@ -2494,7 +2494,6 @@ xfs_dm_punch_hole(
 	/* Let threads in send_data_event know we punched the file. */
 	ip->i_d.di_dmstate++;
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-	xfs_iflags_set(ip, XFS_IMODIFIED);
 
 up_and_out:
 	up_rw_sems(inode, DM_SEM_FLAG_WR);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2008-10-25 13:00:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2008-10-25 13:15:42.000000000 +0200
@@ -317,14 +317,9 @@ xfs_map_blocks(
 	xfs_iomap_t		*mapp,
 	int			flags)
 {
-	xfs_inode_t		*ip = XFS_I(inode);
-	int			error, nmaps = 1;
+	int			nmaps = 1;
 
-	error = xfs_iomap(ip, offset, count,
-				flags, mapp, &nmaps);
-	if (!error && (flags & (BMAPI_WRITE|BMAPI_ALLOCATE)))
-		xfs_iflags_set(ip, XFS_IMODIFIED);
-	return -error;
+	return -xfs_iomap(XFS_I(inode), offset, count, flags, mapp, &nmaps);
 }
 
 STATIC_INLINE int
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2008-10-25 13:11:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c	2008-10-25 13:15:42.000000000 +0200
@@ -434,11 +434,8 @@ xfs_file_ioctl(
 	unsigned int	cmd,
 	unsigned long	p)
 {
-	int		error;
 	struct inode	*inode = filp->f_path.dentry->d_inode;
 
-	error = xfs_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
-	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
 
 	/* NOTE:  some of the ioctl's return positive #'s as a
 	 *	  byte count indicating success, such as
@@ -446,7 +443,7 @@ xfs_file_ioctl(
 	 *	  like most other routines.  This means true
 	 *	  errors need to be returned as a negative value.
 	 */
-	return error;
+	return xfs_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
 }
 
 STATIC long
@@ -455,11 +452,8 @@ xfs_file_ioctl_invis(
 	unsigned int	cmd,
 	unsigned long	p)
 {
-	int		error;
 	struct inode	*inode = filp->f_path.dentry->d_inode;
 
-	error = xfs_ioctl(XFS_I(inode), filp, IO_INVIS, cmd, (void __user *)p);
-	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
 
 	/* NOTE:  some of the ioctl's return positive #'s as a
 	 *	  byte count indicating success, such as
@@ -467,7 +461,7 @@ xfs_file_ioctl_invis(
 	 *	  like most other routines.  This means true
 	 *	  errors need to be returned as a negative value.
 	 */
-	return error;
+	return xfs_ioctl(XFS_I(inode), filp, IO_INVIS, cmd, (void __user *)p);
 }
 
 #ifdef HAVE_DMAPI
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-10-25 13:13:24.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-10-25 13:15:54.000000000 +0200
@@ -158,8 +158,6 @@ xfs_init_security(
 	}
 
 	error = xfs_attr_set(ip, name, value, length, ATTR_SECURE);
-	if (!error)
-		xfs_iflags_set(ip, XFS_IMODIFIED);
 
 	kfree(name);
 	kfree(value);
@@ -260,7 +258,6 @@ xfs_vn_mknod(
 		error = _ACL_INHERIT(inode, mode, default_acl);
 		if (unlikely(error))
 			goto out_cleanup_inode;
-		xfs_iflags_set(ip, XFS_IMODIFIED);
 		_ACL_FREE(default_acl);
 	}
 
@@ -376,7 +373,6 @@ xfs_vn_link(
 	if (unlikely(error))
 		return -error;
 
-	xfs_iflags_set(XFS_I(dir), XFS_IMODIFIED);
 	atomic_inc(&inode->i_count);
 	d_instantiate(dentry, inode);
 	return 0;
@@ -805,7 +801,6 @@ xfs_setup_inode(
 	inode->i_ctime.tv_sec	= ip->i_d.di_ctime.t_sec;
 	inode->i_ctime.tv_nsec	= ip->i_d.di_ctime.t_nsec;
 	xfs_diflags_to_iflags(inode, ip);
-	xfs_iflags_clear(ip, XFS_IMODIFIED);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-10-25 13:00:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2008-10-25 13:15:42.000000000 +0200
@@ -375,7 +375,6 @@ xfs_compat_ioctl(
 	unsigned long	arg)
 {
 	struct inode	*inode = file->f_path.dentry->d_inode;
-	int		error;
 
 	switch (cmd) {
 	case XFS_IOC_DIOINFO:
@@ -463,10 +462,7 @@ xfs_compat_ioctl(
 		return -ENOIOCTLCMD;
 	}
 
-	error = xfs_ioctl(XFS_I(inode), file, mode, cmd, (void __user *)arg);
-	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
-
-	return error;
+	return xfs_ioctl(XFS_I(inode), file, mode, cmd, (void __user *)arg);
 }
 
 long
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-10-25 13:00:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-10-25 13:15:42.000000000 +0200
@@ -1021,7 +1021,6 @@ xfs_fs_clear_inode(
 	XFS_STATS_DEC(vn_active);
 
 	xfs_inactive(ip);
-	xfs_iflags_clear(ip, XFS_IMODIFIED);
 }
 
 STATIC void
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2008-10-25 13:02:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2008-10-25 13:15:42.000000000 +0200
@@ -275,7 +275,6 @@ again:
 	}
 	xfs_put_perag(mp, pag);
 
-	xfs_iflags_set(ip, XFS_IMODIFIED);
 	*ipp = ip;
 
 	ASSERT(ip->i_df.if_ext_max ==
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-10-25 13:02:57.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-10-25 13:15:42.000000000 +0200
@@ -403,17 +403,12 @@ static inline void xfs_ifunlock(xfs_inod
 /*
  * In-core inode flags.
  */
-#define XFS_IGRIO	0x0001  /* inode used for guaranteed rate i/o */
-#define XFS_IUIOSZ	0x0002  /* inode i/o sizes have been explicitly set */
-#define XFS_IQUIESCE    0x0004  /* we have started quiescing for this inode */
-#define XFS_IRECLAIM    0x0008  /* we have started reclaiming this inode    */
-#define XFS_ISTALE	0x0010	/* inode has been staled */
-#define XFS_IRECLAIMABLE 0x0020 /* inode can be reclaimed */
-#define XFS_INEW	0x0040
-#define XFS_IFILESTREAM	0x0080	/* inode is in a filestream directory */
-#define XFS_IMODIFIED	0x0100	/* XFS inode state possibly differs */
-				/* to the Linux inode state. */
-#define XFS_ITRUNCATED	0x0200	/* truncated down so flush-on-close */
+#define XFS_IRECLAIM    0x0001  /* we have started reclaiming this inode    */
+#define XFS_ISTALE	0x0002	/* inode has been staled */
+#define XFS_IRECLAIMABLE 0x0004 /* inode can be reclaimed */
+#define XFS_INEW	0x0008	/* inode has just been allocated */
+#define XFS_IFILESTREAM	0x0010	/* inode is in a filestream directory */
+#define XFS_ITRUNCATED	0x0020	/* truncated down so flush-on-close */
 
 /*
  * Flags for inode locking.
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2008-10-25 13:15:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2008-10-25 13:15:42.000000000 +0200
@@ -157,7 +157,6 @@ static void	xfsidbg_xiclogall(xlog_in_co
 static void	xfsidbg_xiclogcb(xlog_in_core_t *);
 static void	xfsidbg_xinodes(xfs_mount_t *);
 static void	xfsidbg_delayed_blocks(xfs_mount_t *);
-static void	xfsidbg_xinodes_quiesce(xfs_mount_t *);
 static void	xfsidbg_xlog(xlog_t *);
 static void	xfsidbg_xlog_ritem(xlog_recover_item_t *);
 static void	xfsidbg_xlog_rtrans(xlog_recover_t *);
@@ -1318,26 +1317,6 @@ static int	kdbm_xfs_delayed_blocks(
 	return 0;
 }
 
-
-static int	kdbm_xfs_xinodes_quiesce(
-	int	argc,
-	const char **argv)
-{
-	unsigned long addr;
-	int nextarg = 1;
-	long offset = 0;
-	int diag;
-
-	if (argc != 1)
-		return KDB_ARGCOUNT;
-	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
-	if (diag)
-		return diag;
-
-	xfsidbg_xinodes_quiesce((xfs_mount_t *) addr);
-	return 0;
-}
-
 static int	kdbm_xfs_xlog(
 	int	argc,
 	const char **argv)
@@ -2415,8 +2394,6 @@ static struct xif xfsidbg_funcs[] = {
 #endif
   {  "xinodes",	kdbm_xfs_xinodes,	"<xfs_mount_t>",
 				"Dump XFS inodes per mount"},
-  {  "xquiesce",kdbm_xfs_xinodes_quiesce, "<xfs_mount_t>",
-				"Dump non-quiesced XFS inodes per mount"},
 #ifdef XFS_LOG_TRACE
   {  "xl_grtr",	kdbm_xfs_xlog_granttrace,	"<xlog_t>",
 				"Dump XFS log grant trace" },
@@ -5971,35 +5948,6 @@ xfsidbg_delayed_blocks(xfs_mount_t *mp)
 	kdb_printf("delayed blocks total: %d in %d inodes\n", total, icount);
 }
 
-static void
-xfsidbg_xinodes_quiesce(xfs_mount_t *mp)
-{
-	int		i;
-
-	kdb_printf("xfs_mount at 0x%p\n", mp);
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-		xfs_perag_t	*pag = &mp->m_perag[i];
-		xfs_inode_t	*ip = NULL;
-		int		first_index = 0;
-		int		nr_found;
-
-		if (!pag->pag_ici_init)
-			continue;
-		do {
-			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-						(void**)&ip, first_index, 1);
-			if (!nr_found)
-				break;
-			/* update the index for the next lookup */
-			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-			if (!(ip->i_flags & XFS_IQUIESCE)) {
-				kdb_printf("ip 0x%p not quiesced\n", ip);
-			}
-		} while (nr_found);
-	}
-	kdb_printf("\nEnd of Inodes\n");
-}
-
 static char *
 xfsidbg_get_cstate(int state)
 {
@@ -6597,12 +6545,11 @@ static void
 xfsidbg_xnode(xfs_inode_t *ip)
 {
 	static char *tab_flags[] = {
-		"grio",		/* XFS_IGRIO */
-		"uiosize",	/* XFS_IUIOSZ */
-		"quiesce",	/* XFS_IQUIESCE */
 		"reclaim",	/* XFS_IRECLAIM */
 		"stale",	/* XFS_ISTALE */
-		"modified",	/* XFS_IMODIFIED */
+		"reclaimable",	/* XFS_IRECLAIMABLE */
+		"new",		/* XFS_INEW */
+		"filestream",	/* XFS_IFILESTREAM */
 		"truncated",	/* XFS_ITRUNCATED */
 		NULL
 	};

-- 
