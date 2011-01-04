Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p044lbpl176146 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 22:47:38 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0BF61D08392
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 20:49:34 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	5HFGpiplVOOwXdNj for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 20:49:34 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40314813-1927428
	for <xfs@oss.sgi.com>; Tue, 04 Jan 2011 15:19:33 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PZypv-0000TW-Nk
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:49:31 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PZypt-0003vI-Vs
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:49:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: ensure log covering transactions are synchronous
Date: Tue,  4 Jan 2011 15:49:29 +1100
Message-Id: <1294116569-15052-1-git-send-email-david@fromorbit.com>
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

To ensure the log is covered and the filesystem idles correctly, we
need to ensure that dummy transactions hit the disk and do not stay
pinned in memory.  If the superblock is pinned in memory, it can't
be flushed so the log covering cannot make progress. The result is
dependent on timing - more oftent han not we continue to issues a
log covering transaction every 36s rather than idling after ~90s.

Fix this by making the log covering transaction synchronous. To
avoid additional log force from xfssyncd, make the log covering
transaction take the place of the existing log force in the xfssyncd
background sync process.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 fs/xfs/linux-2.6/xfs_sync.c  |   11 ++++++-----
 fs/xfs/xfs_fsops.c           |   10 +++++-----
 fs/xfs/xfs_fsops.h           |    2 +-
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index c51faaa..af32f37 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1413,7 +1413,7 @@ xfs_fs_freeze(
 
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
-	return -xfs_fs_log_dummy(mp, SYNC_WAIT);
+	return -xfs_fs_log_dummy(mp);
 }
 
 STATIC int
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index a02480d..e22f005 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -362,7 +362,7 @@ xfs_quiesce_data(
 
 	/* mark the log as covered if needed */
 	if (xfs_log_need_covered(mp))
-		error2 = xfs_fs_log_dummy(mp, SYNC_WAIT);
+		error2 = xfs_fs_log_dummy(mp);
 
 	/* flush data-only devices */
 	if (mp->m_rtdev_targp)
@@ -503,13 +503,14 @@ xfs_sync_worker(
 	int		error;
 
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		xfs_log_force(mp, 0);
-		xfs_reclaim_inodes(mp, 0);
 		/* dgc: errors ignored here */
-		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 		if (mp->m_super->s_frozen == SB_UNFROZEN &&
 		    xfs_log_need_covered(mp))
-			error = xfs_fs_log_dummy(mp, 0);
+			error = xfs_fs_log_dummy(mp);
+		else
+			xfs_log_force(mp, 0);
+		xfs_reclaim_inodes(mp, 0);
+		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 	}
 	mp->m_sync_seq++;
 	wake_up(&mp->m_wait_single_sync_task);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index f56d30e..cec89dd 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -612,12 +612,13 @@ out:
  *
  * We cannot use an inode here for this - that will push dirty state back up
  * into the VFS and then periodic inode flushing will prevent log covering from
- * making progress. Hence we log a field in the superblock instead.
+ * making progress. Hence we log a field in the superblock instead and use a
+ * synchronous transaction to ensure the superblock is immediately unpinned
+ * and can be written back.
  */
 int
 xfs_fs_log_dummy(
-	xfs_mount_t	*mp,
-	int		flags)
+	xfs_mount_t	*mp)
 {
 	xfs_trans_t	*tp;
 	int		error;
@@ -632,8 +633,7 @@ xfs_fs_log_dummy(
 
 	/* log the UUID because it is an unchanging field */
 	xfs_mod_sb(tp, XFS_SB_UUID);
-	if (flags & SYNC_WAIT)
-		xfs_trans_set_sync(tp);
+	xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp, 0);
 }
 
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index a786c52..1b6a98b 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -25,6 +25,6 @@ extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
-extern int xfs_fs_log_dummy(xfs_mount_t *mp, int flags);
+extern int xfs_fs_log_dummy(struct xfs_mount *mp);
 
 #endif	/* __XFS_FSOPS_H__ */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
