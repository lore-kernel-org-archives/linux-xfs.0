Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TMAnZZ145388 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 17:10:50 -0500
Received: from e33.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 708CA42333
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 15:10:49 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id 2ftZdxJ7sMaTgK6p for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2011 15:10:49 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5TM3GMW008063
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 16:03:16 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5TMAFc9096700 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 16:10:31 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5TGAEAG012106
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 10:10:14 -0600
Subject: [PATCH] xfs: Remove the second parameter to xfs_sb_count()
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 29 Jun 2011 15:10:14 -0700
Message-ID: <1309385414.5505.6282.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS Mailing List <xfs@oss.sgi.com>
Cc: Alex Elder <aelder@sgi.com>


Remove the second parameter to xfs_sb_count() since all callers of the
function set them.

Also, fix the header comment regarding it being called periodically.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    2 +-
 fs/xfs/xfs_mount.c          |   15 +++++----------
 fs/xfs/xfs_mount.h          |    2 +-
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 8ecad5f..b32c09e 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -436,7 +436,7 @@ xfs_quiesce_attr(
 	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
 
 	/* Push the superblock and write an unmount record */
-	error = xfs_log_sbcount(mp, 1);
+	error = xfs_log_sbcount(mp);
 	if (error)
 		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
 				"Frozen image may not be consistent.");
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b49b823..e569b77 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1532,7 +1532,7 @@ xfs_unmountfs(
 		xfs_warn(mp, "Unable to free reserved block pool. "
 				"Freespace may not be correct on next mount.");
 
-	error = xfs_log_sbcount(mp, 1);
+	error = xfs_log_sbcount(mp);
 	if (error)
 		xfs_warn(mp, "Unable to update superblock counters. "
 				"Freespace may not be correct on next mount.");
@@ -1568,18 +1568,14 @@ xfs_fs_writable(xfs_mount_t *mp)
 /*
  * xfs_log_sbcount
  *
- * Called either periodically to keep the on disk superblock values
- * roughly up to date or from unmount to make sure the values are
- * correct on a clean unmount.
+ * Sync the superblock counters to disk.
  *
  * Note this code can be called during the process of freezing, so
- * we may need to use the transaction allocator which does not not
+ * we may need to use the transaction allocator which does not
  * block when the transaction subsystem is in its frozen state.
  */
 int
-xfs_log_sbcount(
-	xfs_mount_t	*mp,
-	uint		sync)
+xfs_log_sbcount(xfs_mount_t *mp)
 {
 	xfs_trans_t	*tp;
 	int		error;
@@ -1605,8 +1601,7 @@ xfs_log_sbcount(
 	}
 
 	xfs_mod_sb(tp, XFS_SB_IFREE | XFS_SB_ICOUNT | XFS_SB_FDBLOCKS);
-	if (sync)
-		xfs_trans_set_sync(tp);
+	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp, 0);
 	return error;
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3d68bb2..bb24dac 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -371,7 +371,7 @@ typedef struct xfs_mod_sb {
 	int64_t		msb_delta;	/* Change to make to specified field */
 } xfs_mod_sb_t;
 
-extern int	xfs_log_sbcount(xfs_mount_t *, uint);
+extern int	xfs_log_sbcount(xfs_mount_t *);
 extern __uint64_t xfs_default_resblks(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp);
 
-- 
1.7.1



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
