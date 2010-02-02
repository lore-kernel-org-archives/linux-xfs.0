Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1329Ua9204063 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 20:09:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C9981A72E5
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 18:10:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	HSHzon25eAb5NBWs for <xfs@oss.sgi.com>;
	Tue, 02 Feb 2010 18:10:38 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	12207825-1927428
	for <xfs@oss.sgi.com>; Wed, 03 Feb 2010 12:40:37 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NcS7X-0003nq-IY
	for xfs@oss.sgi.com; Wed, 03 Feb 2010 10:25:23 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NcS7W-0006j6-GI
	for xfs@oss.sgi.com; Wed, 03 Feb 2010 10:25:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/10] xfs: move the inode locking outside xfs_fsync()
Date: Wed,  3 Feb 2010 10:25:02 +1100
Message-Id: <1265153104-29680-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1265153104-29680-1-git-send-email-david@fromorbit.com>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
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

We have a need for a delayed write inode flush operation
to be made atomically with an fsync to avoid physically
writing inodes but still keeping inode buffer information
up to date for bulkstat.

Move the inode locking outside xfs_fsync() to allow this to
be done.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_file.c |    6 +++++-
 fs/xfs/linux-2.6/xfs_lrw.c  |    5 +++--
 fs/xfs/xfs_vnodeops.c       |   34 ++++++++++++++++------------------
 fs/xfs/xfs_vnodeops.h       |    2 +-
 4 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index e4caeb2..a2c8321 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -177,9 +177,13 @@ xfs_file_fsync(
 	int			datasync)
 {
 	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
+	int			error;
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
-	return -xfs_fsync(ip);
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	error = -xfs_fsync(ip, XFS_ILOCK_SHARED);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return error;
 }
 
 STATIC int
diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index c80fa00..508135c 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -754,11 +754,12 @@ write_retry:
 			error = error2;
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
-		xfs_ilock(xip, iolock);
+		xfs_ilock(xip, iolock | XFS_ILOCK_SHARED);
 
-		error2 = xfs_fsync(xip);
+		error2 = xfs_fsync(xip, XFS_ILOCK_SHARED);
 		if (!error)
 			error = error2;
+		xfs_iunlock(xip, XFS_ILOCK_SHARED);
 	}
 
  out_unlock_internal:
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 43241e2..afcb635 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -590,10 +590,22 @@ xfs_readlink(
  * the I/O lock while flushing the data, and the inode lock while flushing the
  * inode.  The inode lock CANNOT be held while flushing the data, so acquire
  * after we're done with that.
+ *
+ * We always need to make sure that the required inode state is safe on disk.
+ * The inode might be clean but we still might need to force the log because of
+ * committed transactions that haven't hit the disk yet.  Likewise, there could
+ * be unflushed non-transactional changes to the inode core that have to go to
+ * disk and this requires us to issue a synchronous transaction to capture
+ * these changes correctly.
+ *
+ * This code relies on the assumption that if the update_* fields of the inode
+ * are clear and the inode is unpinned then it is clean and no action is
+ * required.
  */
 int
 xfs_fsync(
-	xfs_inode_t	*ip)
+	xfs_inode_t	*ip,
+	int		lock_mode)
 {
 	xfs_trans_t	*tp;
 	int		error = 0;
@@ -604,20 +616,6 @@ xfs_fsync(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return XFS_ERROR(EIO);
 
-	/*
-	 * We always need to make sure that the required inode state is safe on
-	 * disk.  The inode might be clean but we still might need to force the
-	 * log because of committed transactions that haven't hit the disk yet.
-	 * Likewise, there could be unflushed non-transactional changes to the
-	 * inode core that have to go to disk and this requires us to issue
-	 * a synchronous transaction to capture these changes correctly.
-	 *
-	 * This code relies on the assumption that if the update_* fields
-	 * of the inode are clear and the inode is unpinned then it is clean
-	 * and no action is required.
-	 */
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-
 	if (!ip->i_update_core) {
 		/*
 		 * Timestamps/size haven't changed since last inode flush or
@@ -627,7 +625,6 @@ xfs_fsync(
 		 * disk yet, the inode will be still be pinned.  If it is,
 		 * force the log.
 		 */
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		if (xfs_ipincount(ip)) {
 			error = _xfs_log_force(ip->i_mount, XFS_LOG_SYNC,
 					       &log_flushed);
@@ -637,7 +634,7 @@ xfs_fsync(
 		 * Kick off a transaction to log the inode core to get the
 		 * updates.  The sync transaction will also force the log.
 		 */
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		xfs_iunlock(ip, lock_mode);
 		tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_FSYNC_TS);
 		error = xfs_trans_reserve(tp, 0,
 				XFS_FSYNC_TS_LOG_RES(ip->i_mount), 0, 0, 0);
@@ -662,7 +659,8 @@ xfs_fsync(
 		xfs_trans_set_sync(tp);
 		error = _xfs_trans_commit(tp, 0, &log_flushed);
 
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		if (lock_mode != XFS_ILOCK_EXCL)
+			xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
 	}
 
 	if (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) {
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index 774f407..eacd297 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -21,7 +21,7 @@ int xfs_setattr(struct xfs_inode *ip, struct iattr *vap, int flags);
 #define XFS_ATTR_NOACL		0x08	/* Don't call xfs_acl_chmod */
 
 int xfs_readlink(struct xfs_inode *ip, char *link);
-int xfs_fsync(struct xfs_inode *ip);
+int xfs_fsync(struct xfs_inode *ip, int lock_mode);
 int xfs_release(struct xfs_inode *ip);
 int xfs_inactive(struct xfs_inode *ip);
 int xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
