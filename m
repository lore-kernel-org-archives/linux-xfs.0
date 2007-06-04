Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 07:33:59 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l54EXsWt017205
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 07:33:56 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l54EXro6008984
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 16:33:53 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l54EXqwD008980
	for xfs@oss.sgi.com; Mon, 4 Jun 2007 16:33:52 +0200
Date: Mon, 4 Jun 2007 16:33:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of file_count abuse
Message-ID: <20070604143352.GA8721@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

A check for file_count is always a bad idea.  Linux has the ->release
method to deal with cleanups on last close and ->flush is only for the
very rare case where we want to perform an operation on every drop of
a reference to a file struct.

This patch gets rid of vop_close and surrounding code in favour of
simply doing the page flushing from ->release.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_file.c	2007-06-01 13:20:26.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2007-06-01 13:20:41.000000000 +0200
@@ -208,15 +208,6 @@ xfs_file_open(
 }
 
 STATIC int
-xfs_file_close(
-	struct file	*filp,
-	fl_owner_t	id)
-{
-	return -bhv_vop_close(vn_from_inode(filp->f_path.dentry->d_inode), 0,
-				file_count(filp) > 1 ? L_FALSE : L_TRUE, NULL);
-}
-
-STATIC int
 xfs_file_release(
 	struct inode	*inode,
 	struct file	*filp)
@@ -461,7 +452,6 @@ const struct file_operations xfs_file_op
 #endif
 	.mmap		= xfs_file_mmap,
 	.open		= xfs_file_open,
-	.flush		= xfs_file_close,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
 #ifdef HAVE_FOP_OPEN_EXEC
@@ -484,7 +474,6 @@ const struct file_operations xfs_invis_f
 #endif
 	.mmap		= xfs_file_mmap,
 	.open		= xfs_file_open,
-	.flush		= xfs_file_close,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
 };
Index: linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-06-01 13:19:59.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h	2007-06-01 13:21:05.000000000 +0200
@@ -129,10 +129,7 @@ typedef enum bhv_vchange {
 	VCHANGE_FLAGS_IOEXCL_COUNT	= 4
 } bhv_vchange_t;
 
-typedef enum { L_FALSE, L_TRUE } lastclose_t;
-
 typedef int	(*vop_open_t)(bhv_desc_t *, struct cred *);
-typedef int	(*vop_close_t)(bhv_desc_t *, int, lastclose_t, struct cred *);
 typedef ssize_t (*vop_read_t)(bhv_desc_t *, struct kiocb *,
 				const struct iovec *, unsigned int,
 				loff_t *, int, struct cred *);
@@ -203,7 +200,6 @@ typedef int	(*vop_iflush_t)(bhv_desc_t *
 typedef struct bhv_vnodeops {
 	bhv_position_t  vn_position;    /* position within behavior chain */
 	vop_open_t		vop_open;
-	vop_close_t		vop_close;
 	vop_read_t		vop_read;
 	vop_write_t		vop_write;
 	vop_sendfile_t		vop_sendfile;
@@ -249,7 +245,6 @@ typedef struct bhv_vnodeops {
 #define VNHEAD(vp)	((vp)->v_bh.bh_first)
 #define VOP(op, vp)	(*((bhv_vnodeops_t *)VNHEAD(vp)->bd_ops)->op)
 #define bhv_vop_open(vp, cr)		VOP(vop_open, vp)(VNHEAD(vp),cr)
-#define bhv_vop_close(vp, f,last,cr)	VOP(vop_close, vp)(VNHEAD(vp),f,last,cr)
 #define bhv_vop_read(vp,file,iov,segs,offset,ioflags,cr)		\
 		VOP(vop_read, vp)(VNHEAD(vp),file,iov,segs,offset,ioflags,cr)
 #define bhv_vop_write(vp,file,iov,segs,offset,ioflags,cr)		\
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2007-06-01 13:17:41.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2007-06-01 13:19:54.000000000 +0200
@@ -77,36 +77,6 @@ xfs_open(
 	return 0;
 }
 
-STATIC int
-xfs_close(
-	bhv_desc_t	*bdp,
-	int		flags,
-	lastclose_t	lastclose,
-	cred_t		*credp)
-{
-	bhv_vnode_t	*vp = BHV_TO_VNODE(bdp);
-	xfs_inode_t	*ip = XFS_BHVTOI(bdp);
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return XFS_ERROR(EIO);
-
-	if (lastclose != L_TRUE || !VN_ISREG(vp))
-		return 0;
-
-	/*
-	 * If we previously truncated this file and removed old data in
-	 * the process, we want to initiate "early" writeout on the last
-	 * close.  This is an attempt to combat the notorious NULL files
-	 * problem which is particularly noticable from a truncate down,
-	 * buffered (re-)write (delalloc), followed by a crash.  What we
-	 * are effectively doing here is significantly reducing the time
-	 * window where we'd otherwise be exposed to that problem.
-	 */
-	if (VUNTRUNCATE(vp) && VN_DIRTY(vp) && ip->i_delayed_blks > 0)
-		return bhv_vop_flush_pages(vp, 0, -1, XFS_B_ASYNC, FI_NONE);
-	return 0;
-}
-
 /*
  * xfs_getattr
  */
@@ -1560,6 +1530,22 @@ xfs_release(
 	if (vp->v_vfsp->vfs_flag & VFS_RDONLY)
 		return 0;
 
+	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		/*
+		 * If we previously truncated this file and removed old data
+		 * in the process, we want to initiate "early" writeout on
+		 * the last close.  This is an attempt to combat the notorious
+		 * NULL files problem which is particularly noticable from a
+		 * truncate down, buffered (re-)write (delalloc), followed by
+		 * a crash.  What we are effectively doing here is
+		 * significantly reducing the time window where we'd otherwise
+		 * be exposed to that problem.
+		 */
+		if (VUNTRUNCATE(vp) && VN_DIRTY(vp) && ip->i_delayed_blks > 0)
+			bhv_vop_flush_pages(vp, 0, -1, XFS_B_ASYNC, FI_NONE);
+	}
+
+
 #ifdef HAVE_REFCACHE
 	/* If we are in the NFS reference cache then don't do this now */
 	if (ip->i_refcache)
@@ -4678,7 +4664,6 @@ xfs_change_file_space(
 bhv_vnodeops_t xfs_vnodeops = {
 	BHV_IDENTITY_INIT(VN_BHV_XFS,VNODE_POSITION_XFS),
 	.vop_open		= xfs_open,
-	.vop_close		= xfs_close,
 	.vop_read		= xfs_read,
 #ifdef HAVE_SENDFILE
 	.vop_sendfile		= xfs_sendfile,
