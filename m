Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8C7eCm029967 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 06:07:40 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	5rvxYwbgPy08iy9i (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 04:10:06 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1ThJEM-0004hz-Am
	for xfs@oss.sgi.com; Sat, 08 Dec 2012 12:10:06 +0000
Message-Id: <20121208121006.286014845@bombadil.infradead.org>
Date: Sat, 08 Dec 2012 07:08:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/5] xfs: simplify the fallocate path
References: <20121208120812.755863148@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-fallocate
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

Call xfs_alloc_file_space or xfs_free_file_space directly from
xfs_file_fallocate instead of going through xfs_change_file_space.

This simplified the code by removing the unessecary marshalling of the
arguments into an xfs_flock64_t structure and allows removing checks that
are already done in the VFS code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_file.c     |   81 ++++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_vnodeops.c |   39 ++----------------------
 fs/xfs/xfs_vnodeops.h |    3 +
 3 files changed, 60 insertions(+), 63 deletions(-)

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2012-11-30 16:52:18.396009912 -0800
+++ xfs/fs/xfs/xfs_file.c	2012-11-30 18:33:53.496011458 -0800
@@ -806,44 +806,69 @@ out:
 
 STATIC long
 xfs_file_fallocate(
-	struct file	*file,
-	int		mode,
-	loff_t		offset,
-	loff_t		len)
+	struct file		*file,
+	int			mode,
+	loff_t			offset,
+	loff_t			len)
 {
-	struct inode	*inode = file->f_path.dentry->d_inode;
-	long		error;
-	loff_t		new_size = 0;
-	xfs_flock64_t	bf;
-	xfs_inode_t	*ip = XFS_I(inode);
-	int		cmd = XFS_IOC_RESVSP;
-	int		attr_flags = 0;
+	struct inode		*inode = file->f_path.dentry->d_inode;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_trans	*tp;
+	bool			setprealloc = false;
+	long			error;
+	loff_t			new_size = 0;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
-	bf.l_whence = 0;
-	bf.l_start = offset;
-	bf.l_len = len;
-
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		error = xfs_free_file_space(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	} else {
+		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+		    offset + len > i_size_read(inode)) {
+			new_size = offset + len;
+			error = -inode_newsize_ok(inode, new_size);
+			if (error)
+				goto out_unlock;
+		}
 
-	if (mode & FALLOC_FL_PUNCH_HOLE)
-		cmd = XFS_IOC_UNRESVSP;
-
-	/* check the new inode size is valid before allocating */
-	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-	    offset + len > i_size_read(inode)) {
-		new_size = offset + len;
-		error = inode_newsize_ok(inode, new_size);
+		error = xfs_alloc_file_space(ip, offset, len,
+					     XFS_BMAPI_PREALLOC);
 		if (error)
 			goto out_unlock;
+		setprealloc = true;
 	}
 
-	if (file->f_flags & O_DSYNC)
-		attr_flags |= XFS_ATTR_SYNC;
 
-	error = -xfs_change_file_space(ip, cmd, &bf, 0, attr_flags);
+	tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_WRITEID);
+	error = xfs_trans_reserve(tp, 0, XFS_WRITEID_LOG_RES(ip->i_mount),
+				  0, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		goto out_unlock;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	ip->i_d.di_mode &= ~S_ISUID;
+	if (ip->i_d.di_mode & S_IXGRP)
+		ip->i_d.di_mode &= ~S_ISGID;
+
+	if (!(mode & FALLOC_FL_PUNCH_HOLE))
+		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	if (file->f_flags & O_DSYNC)
+		xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp, 0);
 	if (error)
 		goto out_unlock;
 
@@ -853,12 +878,12 @@ xfs_file_fallocate(
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
-		error = -xfs_setattr_size(ip, &iattr);
+		error = xfs_setattr_size(ip, &iattr);
 	}
 
 out_unlock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-	return error;
+	return -error;
 }
 
 
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2012-11-30 16:52:18.396009912 -0800
+++ xfs/fs/xfs/xfs_vnodeops.c	2012-11-30 16:54:23.704013121 -0800
@@ -1627,28 +1627,9 @@ xfs_set_dmattrs(
 	return error;
 }
 
-/*
- * xfs_alloc_file_space()
- *      This routine allocates disk space for the given file.
- *
- *	If alloc_type == 0, this request is for an ALLOCSP type
- *	request which will change the file size.  In this case, no
- *	DMAPI event will be generated by the call.  A TRUNCATE event
- *	will be generated later by xfs_setattr.
- *
- *	If alloc_type != 0, this request is for a RESVSP type
- *	request, and a DMAPI DM_EVENT_WRITE will be generated if the
- *	lower block boundary byte address is less than the file's
- *	length.
- *
- * RETURNS:
- *       0 on success
- *      errno on error
- *
- */
-STATIC int
+int
 xfs_alloc_file_space(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	xfs_off_t		offset,
 	xfs_off_t		len,
 	int			alloc_type)
@@ -1895,21 +1876,9 @@ xfs_zero_remaining_bytes(
 	return error;
 }
 
-/*
- * xfs_free_file_space()
- *      This routine frees disk space for the given file.
- *
- *	This routine is only called by xfs_change_file_space
- *	for an UNRESVSP type call.
- *
- * RETURNS:
- *       0 on success
- *      errno on error
- *
- */
-STATIC int
+int
 xfs_free_file_space(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2012-11-30 16:52:18.400009913 -0800
+++ xfs/fs/xfs/xfs_vnodeops.h	2012-11-30 16:54:23.704013121 -0800
@@ -36,6 +36,9 @@ int xfs_symlink(struct xfs_inode *dp, st
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
 int xfs_change_file_space(struct xfs_inode *ip, int cmd,
 		xfs_flock64_t *bf, xfs_off_t offset, int attr_flags);
+int xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset, xfs_off_t len,
+			 int alloc_type);
+int xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset, xfs_off_t len);
 int xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
 		struct xfs_inode *src_ip, struct xfs_inode *target_dp,
 		struct xfs_name *target_name, struct xfs_inode *target_ip);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
