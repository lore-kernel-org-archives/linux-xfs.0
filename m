Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 13:34:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9QKYbNu027088
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:38 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5629A548F44
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 6u8eWjp7sQaRUYvI for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:38 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuCJp-0001TY-ED
	for xfs@oss.sgi.com; Sun, 26 Oct 2008 20:34:37 +0000
Date: Sun, 26 Oct 2008 16:34:37 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] wire up ->open for directories
Message-ID: <20081026203437.GB4173@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=xfs-wire-up-open
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Currently there's no ->open method set for directories on XFS.  That
means we don't perform any check for opening too large directories
without O_LARGEFILE, we don't check for shut down filesystems, and we
don't actually do the readahead for the first block in the directory.

Instead of just setting the directories open routine to xfs_file_open
we merge the shutdown check directly into xfs_file_open and create
a new xfs_dir_open that first calls xfs_file_open and then performs
the readahead for block 0.

(First sent on September 29th)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2008-09-09 17:35:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c	2008-09-09 17:44:13.000000000 +0200
@@ -38,6 +38,7 @@
 #include "xfs_rw.h"
 #include "xfs_ioctl32.h"
 #include "xfs_vnodeops.h"
+#include "xfs_da_btree.h"
 
 #include <linux/dcache.h>
 #include <linux/smp_lock.h>
@@ -172,11 +173,37 @@ xfs_file_splice_write_invis(
 STATIC int
 xfs_file_open(
 	struct inode	*inode,
-	struct file	*filp)
+	struct file	*file)
 {
-	if (!(filp->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
+	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
 		return -EFBIG;
-	return -xfs_open(XFS_I(inode));
+	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
+		return -EIO;
+	return 0;
+}
+
+STATIC int
+xfs_dir_open(
+	struct inode	*inode,
+	struct file	*file)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	int		mode;
+	int		error;
+
+	error = xfs_file_open(inode, file);
+	if (error)
+		return error;
+
+	/*
+	 * If there are any blocks, read-ahead block 0 as we're almost
+	 * certain to have the next operation be a read there.
+	 */
+	mode = xfs_ilock_map_shared(ip);
+	if (ip->i_d.di_nextents > 0)
+		xfs_da_reada_buf(NULL, ip, 0, XFS_DATA_FORK);
+	xfs_iunlock(ip, mode);
+	return 0;
 }
 
 STATIC int
@@ -533,6 +560,7 @@ const struct file_operations xfs_invis_f
 
 
 const struct file_operations xfs_dir_file_operations = {
+	.open		= xfs_dir_open,
 	.read		= generic_read_dir,
 	.readdir	= xfs_file_readdir,
 	.unlocked_ioctl	= xfs_file_ioctl,
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-09-09 17:35:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-09-09 17:35:59.000000000 +0200
@@ -54,28 +54,6 @@
 #include "xfs_vnodeops.h"
 
 int
-xfs_open(
-	xfs_inode_t	*ip)
-{
-	int		mode;
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return XFS_ERROR(EIO);
-
-	/*
-	 * If it's a directory with any blocks, read-ahead block 0
-	 * as we're almost certain to have the next operation be a read there.
-	 */
-	if (S_ISDIR(ip->i_d.di_mode) && ip->i_d.di_nextents > 0) {
-		mode = xfs_ilock_map_shared(ip);
-		if (ip->i_d.di_nextents > 0)
-			(void)xfs_da_reada_buf(NULL, ip, 0, XFS_DATA_FORK);
-		xfs_iunlock(ip, mode);
-	}
-	return 0;
-}
-
-int
 xfs_setattr(
 	struct xfs_inode	*ip,
 	struct iattr		*iattr,
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-09-09 17:35:42.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-09-09 17:35:45.000000000 +0200
@@ -14,7 +14,6 @@ struct xfs_inode;
 struct xfs_iomap;
 
 
-int xfs_open(struct xfs_inode *ip);
 int xfs_setattr(struct xfs_inode *ip, struct iattr *vap, int flags,
 		struct cred *credp);
 #define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */

-- 
