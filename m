Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54A51135582 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:10 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ARfn6NwzHSGCC2HH for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:55 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbA-0003II-3Y
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:52 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Paz-0003gk-Tj
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 067/102] xfs: Ensure inode reclaim can run during quotacheck
Date: Thu, 23 Aug 2012 15:02:25 +1000
Message-Id: <1345698180-13612-68-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

Upstream commit: 8a00ebe4cfc90eda9ecb575ba97e22021cd8cf70

Because the mount process can run a quotacheck and consume lots of
inodes, we need to be able to run periodic inode reclaim during the
mount process. This will prevent running the system out of memory
during quota checks.

This essentially reverts 2bcf6e97, but that is safe to do now that
the quota sync code that was causing problems during long quotacheck
executions is now gone.

The reclaim work is currently protected from running during the
unmount process by a check against MS_ACTIVE. Unfortunately, this
also means that the reclaim work cannot run during mount.  The
unmount process should stop the reclaim cleanly before freeing
anything that the reclaim work depends on, so there is no need to
have this guard in place.

Also, the inode reclaim work is demand driven, so there is no need
to start it immediately during mount. It will be started the moment
an inode is queued for reclaim, so qutoacheck will trigger it just
fine.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   17 +++++++++--------
 fs/xfs/linux-2.6/xfs_sync.c  |   19 +++++++++----------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index b86c460..9c7f4b9 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1008,7 +1008,6 @@ xfs_fs_put_super(
 	 * structure so we don't have memory reclaim racing with us here.
 	 */
 	xfs_inode_shrinker_unregister(mp);
-	xfs_syncd_stop(mp);
 
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
@@ -1020,6 +1019,7 @@ xfs_fs_put_super(
 	XFS_bflush(mp->m_ddev_targp);
 
 	xfs_unmountfs(mp);
+	xfs_syncd_stop(mp);
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
@@ -1397,22 +1397,22 @@ xfs_fs_fill_super(
 
 	xfs_inode_shrinker_register(mp);
 
-	error = xfs_mountfs(mp);
+	error = xfs_syncd_init(mp);
 	if (error)
 		goto out_filestream_unmount;
 
-	error = xfs_syncd_init(mp);
+	error = xfs_mountfs(mp);
 	if (error)
-		goto out_unmount;
+		goto out_syncd_stop;
 
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
 		error = ENOENT;
-		goto out_syncd_stop;
+		goto out_unmount;
 	}
 	if (is_bad_inode(root)) {
 		error = EINVAL;
-		goto out_syncd_stop;
+		goto out_unmount;
 	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
@@ -1422,6 +1422,8 @@ xfs_fs_fill_super(
 
 	return 0;
 
+ out_syncd_stop:
+	xfs_syncd_stop(mp);
  out_filestream_unmount:
 	xfs_inode_shrinker_unregister(mp);
 	xfs_filestream_unmount(mp);
@@ -1441,8 +1443,6 @@ out_destroy_workqueues:
 
  out_iput:
 	iput(root);
- out_syncd_stop:
-	xfs_syncd_stop(mp);
  out_unmount:
 	xfs_inode_shrinker_unregister(mp);
 
@@ -1456,6 +1456,7 @@ out_destroy_workqueues:
 	XFS_bflush(mp->m_ddev_targp);
 
 	xfs_unmountfs(mp);
+	xfs_syncd_stop(mp);
 	goto out_free_sb;
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index cf26dd3..ccb77cf 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -466,7 +466,15 @@ xfs_sync_worker(
 					struct xfs_mount, m_sync_work);
 	int		error;
 
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	/*
+	 * We shouldn't write/force the log if we are in the mount/unmount
+	 * process or on a read only filesystem. The workqueue still needs to be
+	 * active in both cases, however, because it is used for inode reclaim
+	 * during these times. hence use the MS_ACTIVE flag to avoid doing
+	 * anything in these periods.
+	 */
+	if (!(mp->m_super->s_flags & MS_ACTIVE) &&
+	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		/* dgc: errors ignored here */
 		if (mp->m_super->s_frozen == SB_UNFROZEN &&
 		    xfs_log_need_covered(mp))
@@ -495,14 +503,6 @@ xfs_syncd_queue_reclaim(
 	struct xfs_mount        *mp)
 {
 
-	/*
-	 * We can have inodes enter reclaim after we've shut down the syncd
-	 * workqueue during unmount, so don't allow reclaim work to be queued
-	 * during unmount.
-	 */
-	if (!(mp->m_super->s_flags & MS_ACTIVE))
-		return;
-
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
 		queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
@@ -571,7 +571,6 @@ xfs_syncd_init(
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 
 	xfs_syncd_queue_sync(mp);
-	xfs_syncd_queue_reclaim(mp);
 
 	return 0;
 }
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
