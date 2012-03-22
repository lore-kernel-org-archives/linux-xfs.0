Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2M5FUsg180372 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 00:15:30 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PtN3Mp5x2fRgs7Wi for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2012 22:15:28 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SAaMt-00035h-Ul
	for xfs@oss.sgi.com; Thu, 22 Mar 2012 16:15:24 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SAaMm-0000WV-Gt
	for xfs@oss.sgi.com; Thu, 22 Mar 2012 16:15:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: remove MS_ACTIVE guard from inode reclaim work
Date: Thu, 22 Mar 2012 16:15:09 +1100
Message-Id: <1332393313-1955-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1332393313-1955-1-git-send-email-david@fromorbit.com>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
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

We need to be able to queue inode reclaim work during the mount
process as quotacheck can cause large amounts of inodes to be read
and we need to clean them up periodically as the shrinkers can not
run until after the mount process has completed.

The reclaim work is currently protected from running during the
unmount process by a check against MS_ACTIVE. Unfortunately, this
also means that the relcaim work cannot run during mount.  The
unmount process should stop the reclaim cleanly before freeing
anything that the reclaim work depends on, so there is no need to
have this guard in place.

Also, the inode reclaim work is demand driven, so there is no need
to start it immediately during mount. It will be started the moment
an inode is queued for reclaim, so qutoacheck will trigger it just
fine.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c |    3 +--
 fs/xfs/xfs_sync.c  |   27 ++++++++++++++++-----------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a08c56d..3e87b02 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -965,8 +965,6 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	xfs_syncd_stop(mp);
-
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
 	 * This can and will cause log traffic as inodes go inactive
@@ -977,6 +975,7 @@ xfs_fs_put_super(
 	xfs_flush_buftarg(mp->m_ddev_targp, 1);
 
 	xfs_unmountfs(mp);
+	xfs_syncd_stop(mp);
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 205ebcb..6771fcd 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -460,7 +460,15 @@ xfs_sync_worker(
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
@@ -488,14 +496,6 @@ xfs_syncd_queue_reclaim(
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
@@ -564,7 +564,6 @@ xfs_syncd_init(
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 
 	xfs_syncd_queue_sync(mp);
-	xfs_syncd_queue_reclaim(mp);
 
 	return 0;
 }
@@ -574,7 +573,13 @@ xfs_syncd_stop(
 	struct xfs_mount	*mp)
 {
 	cancel_delayed_work_sync(&mp->m_sync_work);
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
+
+	/*
+	 * we flush any pending inode reclaim work rather than cancel it here.
+	 * This ensures that there are no clean inodes queued during unmount
+	 * left unreclaimed when we return.
+	 */
+	flush_delayed_work_sync(&mp->m_reclaim_work);
 	cancel_work_sync(&mp->m_flush_work);
 }
 
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
