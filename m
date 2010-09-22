Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8M6hv8Q050835 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 01:43:57 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60253183AE06
	for <xfs@oss.sgi.com>; Tue, 21 Sep 2010 23:44:48 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	jKM4OyH9aY2fszH3 for <xfs@oss.sgi.com>;
	Tue, 21 Sep 2010 23:44:48 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40287956-1927428
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 16:14:47 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OyJ4Q-0003th-Cz
	for xfs@oss.sgi.com; Wed, 22 Sep 2010 16:44:46 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OyJ4E-0002kx-7u
	for xfs@oss.sgi.com; Wed, 22 Sep 2010 16:44:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/16] xfs: don't use vfs writeback for pure metadata
	modifications
Date: Wed, 22 Sep 2010 16:44:17 +1000
Message-Id: <1285137869-10310-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1285137869-10310-1-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Under heavy multi-way parallel create workloads, the VFS struggles
to write back all the inodes that have been changed in age order.
The bdi flusher thread becomes CPU bound, spending 85% of it's time
in the VFS code, mostly traversing the superblock dirty inode list
to separate dirty inodes old enough to flush.

We already keep an index of all metadata changes in age order - in
the AIL - and continued log pressure will do age ordered writeback
without any extra overhead at all. If there is no pressure on the
log, the xfssyncd will periodically write back metadata in ascending
disk address offset order so will be very efficient.

Hence we can stop marking VFS inodes dirty during transaction commit
or when changing timestamps during transactions. This will keep the
inodes in the superblock dirty list to those containing data or
unlogged metadata changes.

However, the timstamp changes are slightly more complex than this -
there are a couple of places that do unlogged updates of the
timestamps, and the VFS need to be informed of these. Hence add a
new function xfs_trans_inode_chgtime() for transactional changes,
and leave xfs_ichgtime() for the non-transactional changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c   |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c    |   55 ++++++++++++++++++++++++++++-----------
 fs/xfs/quota/xfs_qm_syscalls.c |    2 +-
 fs/xfs/xfs_attr.c              |   36 +++++++++++++-------------
 fs/xfs/xfs_inode.h             |    1 +
 fs/xfs/xfs_inode_item.c        |    9 ------
 fs/xfs/xfs_rename.c            |   12 ++++++---
 fs/xfs/xfs_utils.c             |    4 +-
 fs/xfs/xfs_vnodeops.c          |   10 +++---
 9 files changed, 75 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 03aa908..10206be 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1088,8 +1088,8 @@ xfs_ioctl_setattr(
 		xfs_diflags_to_linux(ip);
 	}
 
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
 
 	XFS_STATS_INC(xs_ig_attrchg);
 
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index b1fc2a6..37918f4 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -96,40 +96,63 @@ xfs_mark_inode_dirty(
 
 /*
  * Change the requested timestamp in the given inode.
- * We don't lock across timestamp updates, and we don't log them but
- * we do record the fact that there is dirty information in core.
  */
-void
-xfs_ichgtime(
-	xfs_inode_t	*ip,
-	int		flags)
+static int
+xfs_ichgtime_int(
+	struct xfs_inode	*ip,
+	int			flags)
 {
-	struct inode	*inode = VFS_I(ip);
-	timespec_t	tv;
-	int		sync_it = 0;
+	struct inode		*inode = VFS_I(ip);
+	timespec_t		tv;
+	int			dirty = 0;
 
 	tv = current_fs_time(inode->i_sb);
 
 	if ((flags & XFS_ICHGTIME_MOD) &&
 	    !timespec_equal(&inode->i_mtime, &tv)) {
 		inode->i_mtime = tv;
-		sync_it = 1;
+		dirty = 1;
 	}
 	if ((flags & XFS_ICHGTIME_CHG) &&
 	    !timespec_equal(&inode->i_ctime, &tv)) {
 		inode->i_ctime = tv;
-		sync_it = 1;
+		dirty = 1;
 	}
+	return dirty;
+}
 
-	/*
-	 * Update complete - now make sure everyone knows that the inode
-	 * is dirty.
-	 */
-	if (sync_it)
+/*
+ * Non-transactional inode timestamp update. Does not require locks to be held,
+ * and marks the inode dirty at the VFS level so that the change is not lost.
+ */
+void
+xfs_ichgtime(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	if (xfs_ichgtime_int(ip, flags))
 		xfs_mark_inode_dirty_sync(ip);
 }
 
 /*
+ * Transactional inode timestamp update. requires inod to be locked and joined
+ * to the transaction supplied. Relies on the transaction subsystem to track
+ * dirty state and update/writeback the inode accordingly.
+ */
+void
+xfs_trans_ichgtime(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	ASSERT(tp);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(ip->i_transp == tp);
+
+	xfs_ichgtime_int(ip, flags);
+}
+
+/*
  * Hook in SELinux.  This is not quite correct yet, what we really need
  * here (as we do for default ACLs) is a mechanism by which creation of
  * these attrs can be journalled at inode creation time (along with the
diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index 45e5849..7a71336 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -276,7 +276,7 @@ xfs_qm_scall_trunc_qfile(
 		goto out_unlock;
 	}
 
-	xfs_ichgtime(ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 
 out_unlock:
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index c256824..1effc19 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -355,16 +355,18 @@ xfs_attr_set_int(
 			if (mp->m_flags & XFS_MOUNT_WSYNC) {
 				xfs_trans_set_sync(args.trans);
 			}
-			err2 = xfs_trans_commit(args.trans,
-						 XFS_TRANS_RELEASE_LOG_RES);
-			xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
 			/*
 			 * Hit the inode change time.
 			 */
 			if (!error && (flags & ATTR_KERNOTIME) == 0) {
-				xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
+				xfs_trans_ichgtime(args.trans, dp,
+							XFS_ICHGTIME_CHG);
 			}
+			err2 = xfs_trans_commit(args.trans,
+						 XFS_TRANS_RELEASE_LOG_RES);
+			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+
 			return(error == 0 ? err2 : error);
 		}
 
@@ -421,19 +423,18 @@ xfs_attr_set_int(
 	}
 
 	/*
+	 * Hit the inode change time.
+	 */
+	if ((flags & ATTR_KERNOTIME) == 0)
+		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
+
+	/*
 	 * Commit the last in the sequence of transactions.
 	 */
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
 	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
-	/*
-	 * Hit the inode change time.
-	 */
-	if (!error && (flags & ATTR_KERNOTIME) == 0) {
-		xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
-	}
-
 	return(error);
 
 out:
@@ -568,19 +569,18 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	}
 
 	/*
+	 * Hit the inode change time.
+	 */
+	if ((flags & ATTR_KERNOTIME) == 0)
+		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
+
+	/*
 	 * Commit the last in the sequence of transactions.
 	 */
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
 	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
-	/*
-	 * Hit the inode change time.
-	 */
-	if (!error && (flags & ATTR_KERNOTIME) == 0) {
-		xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
-	}
-
 	return(error);
 
 out:
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0898c54..37deff1 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -472,6 +472,7 @@ void		xfs_iext_realloc(xfs_inode_t *, int, int);
 void		xfs_iunpin_wait(xfs_inode_t *);
 int		xfs_iflush(xfs_inode_t *, uint);
 void		xfs_ichgtime(xfs_inode_t *, int);
+void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 void		xfs_lock_two_inodes(xfs_inode_t *, xfs_inode_t *, uint);
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fe00777..c7ac020 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -223,15 +223,6 @@ xfs_inode_item_format(
 	nvecs	     = 1;
 
 	/*
-	 * Make sure the linux inode is dirty. We do this before
-	 * clearing i_update_core as the VFS will call back into
-	 * XFS here and set i_update_core, so we need to dirty the
-	 * inode first so that the ordering of i_update_core and
-	 * unlogged modifications still works as described below.
-	 */
-	xfs_mark_inode_dirty_sync(ip);
-
-	/*
 	 * Clear i_update_core if the timestamps (or any other
 	 * non-transactional modification) need flushing/logging
 	 * and we're about to log them with the rest of the core.
diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
index 8fca957..9028733 100644
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -211,7 +211,9 @@ xfs_rename(
 			goto error_return;
 		if (error)
 			goto abort_return;
-		xfs_ichgtime(target_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		xfs_trans_ichgtime(tp, target_dp,
+					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
 		if (new_parent && src_is_directory) {
 			error = xfs_bumplink(tp, target_dp);
@@ -249,7 +251,9 @@ xfs_rename(
 					&first_block, &free_list, spaceres);
 		if (error)
 			goto abort_return;
-		xfs_ichgtime(target_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+		xfs_trans_ichgtime(tp, target_dp,
+					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
 		/*
 		 * Decrement the link count on the target since the target
@@ -292,7 +296,7 @@ xfs_rename(
 	 * inode isn't really being changed, but old unix file systems did
 	 * it and some incremental backup programs won't work without it.
 	 */
-	xfs_ichgtime(src_ip, XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(tp, src_ip, XFS_ICHGTIME_CHG);
 
 	/*
 	 * Adjust the link count on src_dp.  This is necessary when
@@ -315,7 +319,7 @@ xfs_rename(
 	if (error)
 		goto abort_return;
 
-	xfs_ichgtime(src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
index b7d5769..4c2ba6f 100644
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -235,7 +235,7 @@ xfs_droplink(
 {
 	int	error;
 
-	xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
 	ASSERT (ip->i_d.di_nlink > 0);
 	ip->i_d.di_nlink--;
@@ -299,7 +299,7 @@ xfs_bumplink(
 {
 	if (ip->i_d.di_nlink >= XFS_MAXLINK)
 		return XFS_ERROR(EMLINK);
-	xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
 	ASSERT(ip->i_d.di_nlink > 0);
 	ip->i_d.di_nlink++;
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index dc6e4fb..7413a02 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1391,7 +1391,7 @@ xfs_create(
 		ASSERT(error != ENOSPC);
 		goto out_trans_abort;
 	}
-	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
 	if (is_dir) {
@@ -1742,7 +1742,7 @@ xfs_remove(
 		ASSERT(error != ENOENT);
 		goto out_bmap_cancel;
 	}
-	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
 	if (is_dir) {
 		/*
@@ -1895,7 +1895,7 @@ xfs_link(
 					&first_block, &free_list, resblks);
 	if (error)
 		goto abort_return;
-	xfs_ichgtime(tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	error = xfs_bumplink(tp, sip);
@@ -2129,7 +2129,7 @@ xfs_symlink(
 					&first_block, &free_list, resblks);
 	if (error)
 		goto error1;
-	xfs_ichgtime(dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
 	/*
@@ -2833,7 +2833,7 @@ xfs_change_file_space(
 		if (ip->i_d.di_mode & S_IXGRP)
 			ip->i_d.di_mode &= ~S_ISGID;
 
-		xfs_ichgtime(ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+		xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	}
 	if (setprealloc)
 		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
