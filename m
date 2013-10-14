Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D54CE7F52
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 09:09:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A78A2304039
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 07:09:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id T9bSezVg7EpwihPA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 07:09:36 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VVipz-0008Ku-2j
	for xfs@oss.sgi.com; Mon, 14 Oct 2013 14:09:35 +0000
Date: Mon, 14 Oct 2013 07:09:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5 v3] xfs: always take the iolock around xfs_setattr_size
Message-ID: <20131014140935.GA32035@infradead.org>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075639.940898263@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131012075639.940898263@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
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
 fs/xfs/xfs_iops.c      |   39 +++++++++++++++++++++------------------
 fs/xfs/xfs_iops.h      |    2 +-
 4 files changed, 24 insertions(+), 22 deletions(-)

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2013-10-11 20:05:38.272512388 +0200
+++ xfs/fs/xfs/xfs_file.c	2013-10-14 16:07:38.316153285 +0200
@@ -852,7 +852,7 @@ xfs_file_fallocate(
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
-		error = -xfs_setattr_size(ip, &iattr, XFS_ATTR_NOLOCK);
+		error = -xfs_setattr_size(ip, &iattr);
 	}
 
 out_unlock:
Index: xfs/fs/xfs/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.c	2013-10-11 20:05:38.272512388 +0200
+++ xfs/fs/xfs/xfs_iops.c	2013-10-14 15:28:38.900097685 +0200
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
 
@@ -750,12 +745,11 @@ xfs_setattr_size(
 	 */
 	if (newsize == 0 && oldsize == 0 && ip->i_d.di_nextents == 0) {
 		if (!(mask & (ATTR_CTIME|ATTR_MTIME)))
-			goto out_unlock;
+			return 0;
 
 		/*
 		 * Use the regular setattr path to update the timestamps.
 		 */
-		xfs_iunlock(ip, lock_flags);
 		iattr->ia_valid &= ~ATTR_SIZE;
 		return xfs_setattr_nonsize(ip, iattr, 0);
 	}
@@ -765,7 +759,7 @@ xfs_setattr_size(
 	 */
 	error = xfs_qm_dqattach(ip, 0);
 	if (error)
-		goto out_unlock;
+		return error;
 
 	/*
 	 * Now we can make the changes.  Before we join the inode to the
@@ -783,7 +777,7 @@ xfs_setattr_size(
 		 */
 		error = xfs_zero_eof(ip, newsize, oldsize);
 		if (error)
-			goto out_unlock;
+			return error;
 	}
 
 	/*
@@ -802,7 +796,7 @@ xfs_setattr_size(
 		error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
 						      ip->i_d.di_size, newsize);
 		if (error)
-			goto out_unlock;
+			return error;
 	}
 
 	/*
@@ -812,7 +806,7 @@ xfs_setattr_size(
 
 	error = -block_truncate_page(inode->i_mapping, newsize, xfs_get_blocks);
 	if (error)
-		goto out_unlock;
+		return error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
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
--- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-10-11 20:05:38.272512388 +0200
+++ xfs/fs/xfs/xfs_bmap_util.c	2013-10-14 16:07:38.316153285 +0200
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
--- xfs.orig/fs/xfs/xfs_iops.h	2013-10-11 20:05:38.272512388 +0200
+++ xfs/fs/xfs/xfs_iops.h	2013-10-14 16:07:38.440153288 +0200
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
