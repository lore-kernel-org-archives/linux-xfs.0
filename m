Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6VL40DS171471 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 16:04:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0A2239B445
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 14:04:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GZWoh9Oh4aTS743c for
	<xfs@oss.sgi.com>; Fri, 31 Jul 2009 14:04:48 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MWzHU-0003Xz-8Y
	for xfs@oss.sgi.com; Fri, 31 Jul 2009 21:04:48 +0000
Message-Id: <20090731210448.040369000@bombadil.infradead.org>
Date: Fri, 31 Jul 2009 17:03:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: do not take the iolock in xfs_inactive
References: <20090731210340.638586000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-lockdep-inactive
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

When xfs_inactive is called we already have the inode torn down and no
one else can have a reference to it.  That means the iolock here is
superflous as all other users require a proper reference to it:

 - xfs_vm_vmap, xfs_vn_fallocate, xfs_read, xfs_write, xfs_splice_read,
   xfs_splice_write and xfs_setattr are all implementations of VFS methods
   that require such a life inode
 - xfs_getbmap and xfs_swap_extents are ioctl sub command for which the
   same is true
 - xfs_truncate_file is only called on quota inodes just return from
   xfs_iget
 - xfs_sync_inode_data does the lock just after an igrab()
 - xfs_filestream_associate and xfs_filestream_new_ag take the iolock
   on the parent inode of an inode which by VFS rules must be referenced

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2009-07-31 15:52:40.039355590 +0200
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2009-07-31 16:08:57.005082581 +0200
@@ -869,10 +869,10 @@ xfs_inactive_symlink_rmt(
 	 * the second transaction.  In the error paths we need it
 	 * held so the cancel won't rele it, see below.
 	 */
-	xfs_ilock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	size = (int)ip->i_d.di_size;
 	ip->i_d.di_size = 0;
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_ihold(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	/*
@@ -917,7 +917,7 @@ xfs_inactive_symlink_rmt(
 	 * Mark it dirty so it will be logged and moved forward in the log as
 	 * part of every commit.
 	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_ihold(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	/*
@@ -977,7 +977,7 @@ xfs_inactive_symlink_rmt(
 	 * joined to the transaction.
 	 */
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	*tpp = NULL;
 	return error;
 
@@ -1006,7 +1006,7 @@ xfs_inactive_symlink_local(
 		*tpp = NULL;
 		return error;
 	}
-	xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	/*
 	 * Zero length symlinks _can_ exist.
@@ -1029,7 +1029,6 @@ xfs_inactive_attrs(
 	int		error;
 	xfs_mount_t	*mp;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	tp = *tpp;
 	mp = ip->i_mount;
 	ASSERT(ip->i_d.di_forkoff != 0);
@@ -1051,7 +1050,7 @@ xfs_inactive_attrs(
 		goto error_cancel;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_ihold(tp, ip);
 	xfs_idestroy_fork(ip, XFS_ATTR_FORK);
 
@@ -1065,7 +1064,6 @@ error_cancel:
 	xfs_trans_cancel(tp, 0);
 error_unlock:
 	*tpp = NULL;
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	return error;
 }
 
@@ -1210,12 +1208,10 @@ xfs_inactive(
 		 * will call into the buffer cache and we can't
 		 * do that within a transaction.
 		 */
-		xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return VN_INACTIVE_CACHE;
 		}
 
@@ -1227,12 +1223,11 @@ xfs_inactive(
 			/* Don't call itruncate_cleanup */
 			ASSERT(XFS_FORCED_SHUTDOWN(mp));
 			xfs_trans_cancel(tp, 0);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return VN_INACTIVE_CACHE;
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 		xfs_trans_ihold(tp, ip);
 
 		/*
@@ -1248,7 +1243,7 @@ xfs_inactive(
 		if (error) {
 			xfs_trans_cancel(tp,
 				XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			return VN_INACTIVE_CACHE;
 		}
 	} else if ((ip->i_d.di_mode & S_IFMT) == S_IFLNK) {
@@ -1266,7 +1261,7 @@ xfs_inactive(
 			return VN_INACTIVE_CACHE;
 		}
 
-		xfs_trans_ijoin(tp, ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 		xfs_trans_ihold(tp, ip);
 	} else {
 		error = xfs_trans_reserve(tp, 0,
@@ -1279,8 +1274,8 @@ xfs_inactive(
 			return VN_INACTIVE_CACHE;
 		}
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 		xfs_trans_ihold(tp, ip);
 	}
 
@@ -1346,7 +1341,7 @@ xfs_inactive(
 	 * Release the dquots held by inode, if any.
 	 */
 	xfs_qm_dqdetach(ip);
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
  out:
 	return VN_INACTIVE_CACHE;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
