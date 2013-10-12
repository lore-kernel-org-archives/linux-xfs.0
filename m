Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D1B407F5D
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 02:56:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7AFA2AC001
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 00:56:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id ycmWmrpdsSHEn53e (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Oct 2013 00:56:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VUu40-0000kk-20
	for xfs@oss.sgi.com; Sat, 12 Oct 2013 07:56:40 +0000
Message-Id: <20131012075639.940898263@bombadil.infradead.org>
Date: Sat, 12 Oct 2013 00:55:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] xfs: always take the iolock around xfs_setattr_size
References: <20131012075503.370510641@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_setattr_size-locking
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There is no reason to conditionally take the iolock inside xfs_setattr_size
when we can let the caller handle it unconditionally, which just incrases
the lock hold time for the case where it was previously taken internally
by a few instructions.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_bmap_util.c |    3 +--
 fs/xfs/xfs_file.c      |    2 +-
 fs/xfs/xfs_iops.c      |   29 ++++++++++++++++-------------
 fs/xfs/xfs_iops.h      |    2 +-
 4 files changed, 19 insertions(+), 17 deletions(-)

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2013-10-01 21:20:47.564230097 +0200
+++ xfs/fs/xfs/xfs_file.c	2013-10-01 21:20:54.312230257 +0200
@@ -852,7 +852,7 @@ xfs_file_fallocate(
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
-		error = -xfs_setattr_size(ip, &iattr, XFS_ATTR_NOLOCK);
+		error = -xfs_setattr_size(ip, &iattr);
 	}
 
 out_unlock:
Index: xfs/fs/xfs/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.c	2013-10-01 21:20:47.564230097 +0200
+++ xfs/fs/xfs/xfs_iops.c	2013-10-01 21:20:54.316230257 +0200
@@ -709,8 +709,7 @@ out_dqrele:
 int
 xfs_setattr_size(
 	struct xfs_inode	*ip,
-	struct iattr		*iattr,
-	int			flags)
+	struct iattr		*iattr)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
@@ -733,15 +732,11 @@ xfs_setattr_size(
 	if (error)
 		return XFS_ERROR(error);
 
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(S_ISREG(ip->i_d.di_mode));
 	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
 			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
 
-	if (!(flags & XFS_ATTR_NOLOCK)) {
-		lock_flags |= XFS_IOLOCK_EXCL;
-		xfs_ilock(ip, lock_flags);
-	}
-
 	oldsize = inode->i_size;
 	newsize = iattr->ia_size;
 
@@ -755,7 +750,6 @@ xfs_setattr_size(
 		/*
 		 * Use the regular setattr path to update the timestamps.
 		 */
-		xfs_iunlock(ip, lock_flags);
 		iattr->ia_valid &= ~ATTR_SIZE;
 		return xfs_setattr_nonsize(ip, iattr, 0);
 	}
@@ -916,12 +910,21 @@ out_trans_cancel:
 
 STATIC int
 xfs_vn_setattr(
-	struct dentry	*dentry,
-	struct iattr	*iattr)
+	struct dentry		*dentry,
+	struct iattr		*iattr)
 {
-	if (iattr->ia_valid & ATTR_SIZE)
-		return -xfs_setattr_size(XFS_I(dentry->d_inode), iattr, 0);
-	return -xfs_setattr_nonsize(XFS_I(dentry->d_inode), iattr, 0);
+	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
+	int			error;
+
+	if (iattr->ia_valid & ATTR_SIZE) {
+		xfs_ilock(ip, XFS_IOLOCK_EXCL);
+		error = xfs_setattr_size(ip, iattr);
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	} else {
+		error = xfs_setattr_nonsize(ip, iattr, 0);
+	}
+
+	return -error;
 }
 
 STATIC int
Index: xfs/fs/xfs/xfs_bmap_util.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-10-01 21:20:47.564230097 +0200
+++ xfs/fs/xfs/xfs_bmap_util.c	2013-10-01 21:20:54.316230257 +0200
@@ -1622,8 +1622,7 @@ xfs_change_file_space(
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = startoffset;
 
-		error = xfs_setattr_size(ip, &iattr,
-					 attr_flags | XFS_ATTR_NOLOCK);
+		error = xfs_setattr_size(ip, &iattr);
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
 		if (error)
Index: xfs/fs/xfs/xfs_iops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.h	2013-10-01 21:20:47.680230100 +0200
+++ xfs/fs/xfs/xfs_iops.h	2013-10-01 21:20:54.316230257 +0200
@@ -38,6 +38,6 @@ extern void xfs_setup_inode(struct xfs_i
 
 extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
 			       int flags);
-extern int xfs_setattr_size(struct xfs_inode *ip, struct iattr *vap, int flags);
+extern int xfs_setattr_size(struct xfs_inode *ip, struct iattr *vap);
 
 #endif /* __XFS_IOPS_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
