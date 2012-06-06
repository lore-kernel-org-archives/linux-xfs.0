Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q56L1WWe002999 for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 16:01:33 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	RLe4WFH8U0b4ZT9N (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Jun 2012 14:01:28 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1ScNM8-0003Ln-A6
	for xfs@oss.sgi.com; Wed, 06 Jun 2012 21:01:28 +0000
Date: Wed, 6 Jun 2012 17:01:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: implement ->update_time
Message-ID: <20120606210128.GA12819@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Use this new method to replace our hacky use of ->dirty_inode.  An additional
benefit is that we can now propagate errors up the stack.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_iops.c  |   45 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c |   56 -----------------------------------------------------
 fs/xfs/xfs_trace.h |    2 -
 3 files changed, 46 insertions(+), 57 deletions(-)

Index: xfs/fs/xfs/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.c	2012-06-04 07:45:36.000000000 -0400
+++ xfs/fs/xfs/xfs_iops.c	2012-06-05 18:41:09.060068319 -0400
@@ -897,6 +897,47 @@ xfs_vn_setattr(
 	return -xfs_setattr_nonsize(XFS_I(dentry->d_inode), iattr, 0);
 }
 
+STATIC int
+xfs_vn_update_time(
+	struct inode		*inode,
+	struct timespec		*now,
+	int			flags)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	trace_xfs_update_time(ip);
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
+	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return -error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if (flags & S_CTIME) {
+		inode->i_ctime = *now;
+		ip->i_d.di_ctime.t_sec = (__int32_t)now->tv_sec;
+		ip->i_d.di_ctime.t_nsec = (__int32_t)now->tv_nsec;
+	}
+	if (flags & S_MTIME) {
+		inode->i_mtime = *now;
+		ip->i_d.di_mtime.t_sec = (__int32_t)now->tv_sec;
+		ip->i_d.di_mtime.t_nsec = (__int32_t)now->tv_nsec;
+	}
+	if (flags & S_ATIME) {
+		inode->i_atime = *now;
+		ip->i_d.di_atime.t_sec = (__int32_t)now->tv_sec;
+		ip->i_d.di_atime.t_nsec = (__int32_t)now->tv_nsec;
+	}
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
+	return -xfs_trans_commit(tp, 0);
+}
+
 #define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
 
 /*
@@ -991,6 +1032,7 @@ static const struct inode_operations xfs
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.fiemap			= xfs_vn_fiemap,
+	.update_time		= xfs_vn_update_time,
 };
 
 static const struct inode_operations xfs_dir_inode_operations = {
@@ -1016,6 +1058,7 @@ static const struct inode_operations xfs
 	.getxattr		= generic_getxattr,
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
+	.update_time		= xfs_vn_update_time,
 };
 
 static const struct inode_operations xfs_dir_ci_inode_operations = {
@@ -1041,6 +1084,7 @@ static const struct inode_operations xfs
 	.getxattr		= generic_getxattr,
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
+	.update_time		= xfs_vn_update_time,
 };
 
 static const struct inode_operations xfs_symlink_inode_operations = {
@@ -1054,6 +1098,7 @@ static const struct inode_operations xfs
 	.getxattr		= generic_getxattr,
 	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
+	.update_time		= xfs_vn_update_time,
 };
 
 STATIC void
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2012-06-04 07:45:36.000000000 -0400
+++ xfs/fs/xfs/xfs_super.c	2012-06-05 18:35:03.876058962 -0400
@@ -868,61 +868,6 @@ xfs_fs_inode_init_once(
 		     "xfsino", ip->i_ino);
 }
 
-/*
- * This is called by the VFS when dirtying inode metadata.  This can happen
- * for a few reasons, but we only care about timestamp updates, given that
- * we handled the rest ourselves.  In theory no other calls should happen,
- * but for example generic_write_end() keeps dirtying the inode after
- * updating i_size.  Thus we check that the flags are exactly I_DIRTY_SYNC,
- * and skip this call otherwise.
- *
- * We'll hopefull get a different method just for updating timestamps soon,
- * at which point this hack can go away, and maybe we'll also get real
- * error handling here.
- */
-STATIC void
-xfs_fs_dirty_inode(
-	struct inode		*inode,
-	int			flags)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
-	int			error;
-
-	if (flags != I_DIRTY_SYNC)
-		return;
-
-	trace_xfs_dirty_inode(ip);
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
-	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		goto trouble;
-	}
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	/*
-	 * Grab all the latest timestamps from the Linux inode.
-	 */
-	ip->i_d.di_atime.t_sec = (__int32_t)inode->i_atime.tv_sec;
-	ip->i_d.di_atime.t_nsec = (__int32_t)inode->i_atime.tv_nsec;
-	ip->i_d.di_ctime.t_sec = (__int32_t)inode->i_ctime.tv_sec;
-	ip->i_d.di_ctime.t_nsec = (__int32_t)inode->i_ctime.tv_nsec;
-	ip->i_d.di_mtime.t_sec = (__int32_t)inode->i_mtime.tv_sec;
-	ip->i_d.di_mtime.t_nsec = (__int32_t)inode->i_mtime.tv_nsec;
-
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
-	error = xfs_trans_commit(tp, 0);
-	if (error)
-		goto trouble;
-	return;
-
-trouble:
-	xfs_warn(mp, "failed to update timestamps for inode 0x%llx", ip->i_ino);
-}
-
 STATIC void
 xfs_fs_evict_inode(
 	struct inode		*inode)
@@ -1436,7 +1381,6 @@ xfs_fs_free_cached_objects(
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
-	.dirty_inode		= xfs_fs_dirty_inode,
 	.evict_inode		= xfs_fs_evict_inode,
 	.drop_inode		= xfs_fs_drop_inode,
 	.put_super		= xfs_fs_put_super,
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2012-06-04 07:45:36.000000000 -0400
+++ xfs/fs/xfs/xfs_trace.h	2012-06-05 18:38:32.292064313 -0400
@@ -578,8 +578,8 @@ DEFINE_INODE_EVENT(xfs_ioctl_setattr);
 DEFINE_INODE_EVENT(xfs_dir_fsync);
 DEFINE_INODE_EVENT(xfs_file_fsync);
 DEFINE_INODE_EVENT(xfs_destroy_inode);
-DEFINE_INODE_EVENT(xfs_dirty_inode);
 DEFINE_INODE_EVENT(xfs_evict_inode);
+DEFINE_INODE_EVENT(xfs_update_time);
 
 DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
 DEFINE_INODE_EVENT(xfs_dquot_dqdetach);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
