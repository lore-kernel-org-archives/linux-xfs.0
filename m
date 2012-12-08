Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8C7e5A029958 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 06:07:40 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	x8akRhNCfteLbT8i (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 04:10:06 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1ThJEL-0004gw-US
	for xfs@oss.sgi.com; Sat, 08 Dec 2012 12:10:06 +0000
Message-Id: <20121208121005.902710659@bombadil.infradead.org>
Date: Sat, 08 Dec 2012 07:08:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: always take the iolock around xfs_setattr_size
References: <20121208120812.755863148@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There is no reason to conditionally take the iolock inside xfs_setattr_size
when we can let the caller handle it unconditionally, which just incrases
the lock hold time for the case where it was previously taken internally
by a few instructions.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_file.c     |    2 +-
 fs/xfs/xfs_iops.c     |   28 +++++++++++++++-------------
 fs/xfs/xfs_vnodeops.c |    3 +--
 fs/xfs/xfs_vnodeops.h |    2 +-
 4 files changed, 18 insertions(+), 17 deletions(-)

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2012-11-30 18:39:45.396020469 -0800
+++ xfs/fs/xfs/xfs_file.c	2012-11-30 18:39:56.240020746 -0800
@@ -853,7 +853,7 @@ xfs_file_fallocate(
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
-		error = -xfs_setattr_size(ip, &iattr, XFS_ATTR_NOLOCK);
+		error = -xfs_setattr_size(ip, &iattr);
 	}
 
 out_unlock:
Index: xfs/fs/xfs/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.c	2012-11-30 18:39:45.396020469 -0800
+++ xfs/fs/xfs/xfs_iops.c	2012-11-30 18:39:56.240020746 -0800
@@ -689,8 +689,7 @@ out_dqrele:
 int
 xfs_setattr_size(
 	struct xfs_inode	*ip,
-	struct iattr		*iattr,
-	int			flags)
+	struct iattr		*iattr)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
@@ -718,11 +717,6 @@ xfs_setattr_size(
 			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
 			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
 
-	if (!(flags & XFS_ATTR_NOLOCK)) {
-		lock_flags |= XFS_IOLOCK_EXCL;
-		xfs_ilock(ip, lock_flags);
-	}
-
 	oldsize = inode->i_size;
 	newsize = iattr->ia_size;
 
@@ -736,7 +730,6 @@ xfs_setattr_size(
 		/*
 		 * Use the regular setattr path to update the timestamps.
 		 */
-		xfs_iunlock(ip, lock_flags);
 		iattr->ia_valid &= ~ATTR_SIZE;
 		return xfs_setattr_nonsize(ip, iattr, 0);
 	}
@@ -893,12 +886,21 @@ out_trans_cancel:
 
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
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2012-11-30 18:39:45.396020469 -0800
+++ xfs/fs/xfs/xfs_vnodeops.c	2012-11-30 18:39:56.244020743 -0800
@@ -2291,8 +2291,7 @@ xfs_change_file_space(
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = startoffset;
 
-		error = xfs_setattr_size(ip, &iattr,
-					 attr_flags | XFS_ATTR_NOLOCK);
+		error = xfs_setattr_size(ip, &iattr);
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
 		if (error)
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2012-11-30 18:39:53.784020685 -0800
+++ xfs/fs/xfs/xfs_vnodeops.h	2012-11-30 18:39:56.244020743 -0800
@@ -13,7 +13,7 @@ struct xfs_inode;
 
 
 int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap, int flags);
-int xfs_setattr_size(struct xfs_inode *ip, struct iattr *vap, int flags);
+int xfs_setattr_size(struct xfs_inode *ip, struct iattr *iattr);
 #define	XFS_ATTR_DMI		0x01	/* invocation from a DMI function */
 #define XFS_ATTR_NOLOCK		0x04	/* Don't grab any conflicting locks */
 #define XFS_ATTR_NOACL		0x08	/* Don't call xfs_acl_chmod */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
