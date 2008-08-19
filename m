Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 06:17:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7JDFce2022841
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:15:38 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FD3412F9416
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:16:58 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id l6WiEu2JmoIoOhcs for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:16:58 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KVR4u-0008BI-Ax
	for xfs@oss.sgi.com; Tue, 19 Aug 2008 23:16:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 17/28] XFS: Move remaining quiesce code.
Date: Tue, 19 Aug 2008 23:16:33 +1000
Message-Id: <1219151804-30749-18-git-send-email-david@fromorbit.com>
In-Reply-To: <1219151804-30749-1-git-send-email-david@fromorbit.com>
References: <1219151804-30749-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

With all the other filesystem sync code it in xfs_sync.c
including the data quiesce code, it makes sense to move
the remaining quiesce code to the same place.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    6 ++--
 fs/xfs/linux-2.6/xfs_sync.c  |   56 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_sync.h  |    1 +
 fs/xfs/xfs_vfsops.c          |   57 ------------------------------------------
 fs/xfs/xfs_vfsops.h          |    1 -
 5 files changed, 60 insertions(+), 61 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 1846ea7..8c47ed1 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1158,7 +1158,7 @@ xfs_fs_remount(
 	/* rw -> ro */
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
 		xfs_quiesce_data(mp);
-		xfs_attr_quiesce(mp);
+		xfs_quiesce_attr(mp);
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
 
@@ -1167,7 +1167,7 @@ xfs_fs_remount(
 
 /*
  * Second stage of a freeze. The data is already frozen so we only
- * need to take care of themetadata. Once that's done write a dummy
+ * need to take care of the metadata. Once that's done write a dummy
  * record to dirty the log in case of a crash while frozen.
  */
 STATIC void
@@ -1176,7 +1176,7 @@ xfs_fs_lockfs(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	xfs_attr_quiesce(mp);
+	xfs_quiesce_attr(mp);
 	xfs_fs_log_dummy(mp);
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index c134cad..98a33a5 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -352,6 +352,62 @@ xfs_quiesce_data(
 	return error;
 }
 
+STATIC void
+xfs_quiesce_fs(
+	struct xfs_mount	*mp)
+{
+	int	count = 0, pincount;
+
+	xfs_flush_buftarg(mp->m_ddev_targp, 0);
+	xfs_finish_reclaim_all(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
+
+	/*
+	 * This loop must run at least twice.  The first instance of the loop
+	 * will flush most meta data but that will generate more meta data
+	 * (typically directory updates).  Which then must be flushed and
+	 * logged before we can write the unmount record.
+	 */
+	do {
+		xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
+		xfs_sync_inodes(mp, SYNC_ATTR|SYNC_WAIT);
+		pincount = xfs_flush_buftarg(mp->m_ddev_targp, 1);
+		if (!pincount) {
+			delay(50);
+			count++;
+		}
+	} while (count < 2);
+}
+
+/*
+ * Second stage of a quiesce. The data is already synced, now we have to take
+ * care of the metadata. New transactions are already blocked, so we need to
+ * wait for any remaining transactions to drain out before proceding.
+ */
+void
+xfs_quiesce_attr(
+	struct xfs_mount	*mp)
+{
+	int	error = 0;
+
+	/* wait for all modifications to complete */
+	while (atomic_read(&mp->m_active_trans) > 0)
+		delay(100);
+
+	/* flush inodes and push all remaining buffers out to disk */
+	xfs_quiesce_fs(mp);
+
+	ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
+
+	/* Push the superblock and write an unmount record */
+	error = xfs_log_sbcount(mp, 1);
+	if (error)
+		xfs_fs_cmn_err(CE_WARN, mp,
+				"xfs_attr_quiesce: failed to log sb changes. "
+				"Frozen image may not be consistent.");
+	xfs_log_unmount_write(mp);
+	xfs_unmountfs_writesb(mp);
+}
+
 /*
  * Enqueue a work item to be picked up by the vfs xfssyncd thread.
  * Doing this has two advantages:
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 4591dc0..3b49aa3 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -40,6 +40,7 @@ int xfs_sync_inodes(struct xfs_mount *mp, int flags);
 int xfs_sync_fsdata(struct xfs_mount *mp, int flags);
 
 int xfs_quiesce_data(struct xfs_mount *mp);
+void xfs_quiesce_attr(struct xfs_mount *mp);
 
 void xfs_flush_inode(struct xfs_inode *ip);
 void xfs_flush_device(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_vfsops.c b/fs/xfs/xfs_vfsops.c
index c82b955..72b3265 100644
--- a/fs/xfs/xfs_vfsops.c
+++ b/fs/xfs/xfs_vfsops.c
@@ -58,63 +58,6 @@
 #include "xfs_utils.h"
 #include "xfs_sync.h"
 
-
-STATIC void
-xfs_quiesce_fs(
-	xfs_mount_t		*mp)
-{
-	int			count = 0, pincount;
-
-	xfs_flush_buftarg(mp->m_ddev_targp, 0);
-	xfs_finish_reclaim_all(mp, 0, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
-
-	/*
-	 * This loop must run at least twice.  The first instance of the loop
-	 * will flush most meta data but that will generate more meta data
-	 * (typically directory updates).  Which then must be flushed and
-	 * logged before we can write the unmount record.
-	 */
-	do {
-		xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
-		xfs_sync_inodes(mp, SYNC_ATTR|SYNC_WAIT);
-		pincount = xfs_flush_buftarg(mp->m_ddev_targp, 1);
-		if (!pincount) {
-			delay(50);
-			count++;
-		}
-	} while (count < 2);
-}
-
-/*
- * Second stage of a quiesce. The data is already synced, now we have to take
- * care of the metadata. New transactions are already blocked, so we need to
- * wait for any remaining transactions to drain out before proceding.
- */
-void
-xfs_attr_quiesce(
-	xfs_mount_t	*mp)
-{
-	int	error = 0;
-
-	/* wait for all modifications to complete */
-	while (atomic_read(&mp->m_active_trans) > 0)
-		delay(100);
-
-	/* flush inodes and push all remaining buffers out to disk */
-	xfs_quiesce_fs(mp);
-
-	ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
-
-	/* Push the superblock and write an unmount record */
-	error = xfs_log_sbcount(mp, 1);
-	if (error)
-		xfs_fs_cmn_err(CE_WARN, mp,
-				"xfs_attr_quiesce: failed to log sb changes. "
-				"Frozen image may not be consistent.");
-	xfs_log_unmount_write(mp);
-	xfs_unmountfs_writesb(mp);
-}
-
 /*
  * xfs_unmount_flush implements a set of flush operation on special
  * inodes, which are needed as a separate set of operations so that
diff --git a/fs/xfs/xfs_vfsops.h b/fs/xfs/xfs_vfsops.h
index 6701d0e..6b8e0b5 100644
--- a/fs/xfs/xfs_vfsops.h
+++ b/fs/xfs/xfs_vfsops.h
@@ -10,6 +10,5 @@ struct xfs_mount_args;
 
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
-void xfs_attr_quiesce(struct xfs_mount *mp);
 
 #endif /* _XFS_VFSOPS_H */
-- 
1.5.6
