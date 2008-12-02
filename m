Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2GBqAM032525 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:11:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7E0F164F2B5
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:11:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0oKyr8JAT7b1fql1 for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:11:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xlz-0007TT-C3
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:51 +0000
Message-Id: <20081202160651.264876000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 12/22] kill dead inode flags
Content-Disposition: inline; filename=xfs-kill-dead-inode-flags
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There are a few inode flags around that aren't used anywhere, so remove
them.  Also update xfsidbg to display all used inode flags correctly.

(First sent on July 23nd)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-master/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_aops.c	2008-12-02 11:12:44.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_aops.c	2008-12-02 11:15:28.000000000 +0100
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
Index: xfs-master/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_file.c	2008-12-02 11:07:08.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_file.c	2008-12-02 11:15:28.000000000 +0100
@@ -283,11 +283,8 @@ xfs_file_ioctl(
 	unsigned int	cmd,
 	unsigned long	p)
 {
-	int		error;
 	struct inode	*inode = filp->f_path.dentry->d_inode;
 
-	error = xfs_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
-	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
 
 	/* NOTE:  some of the ioctl's return positive #'s as a
 	 *	  byte count indicating success, such as
@@ -295,7 +292,7 @@ xfs_file_ioctl(
 	 *	  like most other routines.  This means true
 	 *	  errors need to be returned as a negative value.
 	 */
-	return error;
+	return xfs_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
 }
 
 STATIC long
@@ -304,11 +301,8 @@ xfs_file_ioctl_invis(
 	unsigned int	cmd,
 	unsigned long	p)
 {
-	int		error;
 	struct inode	*inode = filp->f_path.dentry->d_inode;
 
-	error = xfs_ioctl(XFS_I(inode), filp, IO_INVIS, cmd, (void __user *)p);
-	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
 
 	/* NOTE:  some of the ioctl's return positive #'s as a
 	 *	  byte count indicating success, such as
@@ -316,7 +310,7 @@ xfs_file_ioctl_invis(
 	 *	  like most other routines.  This means true
 	 *	  errors need to be returned as a negative value.
 	 */
-	return error;
+	return xfs_ioctl(XFS_I(inode), filp, IO_INVIS, cmd, (void __user *)p);
 }
 
 /*
Index: xfs-master/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-12-02 11:13:27.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_iops.c	2008-12-02 11:15:28.000000000 +0100
@@ -159,8 +159,6 @@ xfs_init_security(
 	}
 
 	error = xfs_attr_set(ip, name, value, length, ATTR_SECURE);
-	if (!error)
-		xfs_iflags_set(ip, XFS_IMODIFIED);
 
 	kfree(name);
 	kfree(value);
@@ -261,7 +259,6 @@ xfs_vn_mknod(
 		error = _ACL_INHERIT(inode, mode, default_acl);
 		if (unlikely(error))
 			goto out_cleanup_inode;
-		xfs_iflags_set(ip, XFS_IMODIFIED);
 		_ACL_FREE(default_acl);
 	}
 
@@ -377,7 +374,6 @@ xfs_vn_link(
 	if (unlikely(error))
 		return -error;
 
-	xfs_iflags_set(XFS_I(dir), XFS_IMODIFIED);
 	atomic_inc(&inode->i_count);
 	d_instantiate(dentry, inode);
 	return 0;
@@ -888,7 +884,6 @@ xfs_setup_inode(
 	inode->i_ctime.tv_sec	= ip->i_d.di_ctime.t_sec;
 	inode->i_ctime.tv_nsec	= ip->i_d.di_ctime.t_nsec;
 	xfs_diflags_to_iflags(inode, ip);
-	xfs_iflags_clear(ip, XFS_IMODIFIED);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
Index: xfs-master/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_super.c	2008-12-02 11:06:57.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_super.c	2008-12-02 11:15:28.000000000 +0100
@@ -1025,7 +1025,6 @@ xfs_fs_clear_inode(
 	XFS_STATS_DEC(vn_active);
 
 	xfs_inactive(ip);
-	xfs_iflags_clear(ip, XFS_IMODIFIED);
 }
 
 STATIC void
Index: xfs-master/fs/xfs/xfs_iget.c
===================================================================
--- xfs-master.orig/fs/xfs/xfs_iget.c	2008-12-02 11:13:13.000000000 +0100
+++ xfs-master/fs/xfs/xfs_iget.c	2008-12-02 11:15:28.000000000 +0100
@@ -362,7 +362,6 @@ again:
 	}
 	xfs_put_perag(mp, pag);
 
-	xfs_iflags_set(ip, XFS_IMODIFIED);
 	*ipp = ip;
 
 	ASSERT(ip->i_df.if_ext_max ==
Index: xfs-master/fs/xfs/xfs_inode.h
===================================================================
--- xfs-master.orig/fs/xfs/xfs_inode.h	2008-12-02 11:13:13.000000000 +0100
+++ xfs-master/fs/xfs/xfs_inode.h	2008-12-02 11:15:28.000000000 +0100
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

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
