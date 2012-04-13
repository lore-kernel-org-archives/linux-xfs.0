Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DCB7JQ037744 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 07:11:07 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GgRDFEr1nfTI7n0z for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 05:11:06 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SIfLE-00030p-5S
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:04 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SIfLD-0003Nv-Py
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/18] xfs: Ensure inode reclaim can run during quotacheck
Date: Fri, 13 Apr 2012 22:10:44 +1000
Message-Id: <1334319061-12968-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-1-git-send-email-david@fromorbit.com>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_super.c |   20 ++++++++++----------
 fs/xfs/xfs_sync.c  |   19 +++++++++----------
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6306882..744d6b0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -981,10 +981,9 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	xfs_syncd_stop(mp);
-
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
+	xfs_syncd_stop(mp);
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
@@ -1354,31 +1353,33 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
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
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {
 		error = ENOMEM;
-		goto out_syncd_stop;
+		goto out_unmount;
 	}
 
 	return 0;
 
+ out_syncd_stop:
+	xfs_syncd_stop(mp);
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
  out_free_sb:
@@ -1395,11 +1396,10 @@ out_destroy_workqueues:
  out:
 	return -error;
 
- out_syncd_stop:
-	xfs_syncd_stop(mp);
  out_unmount:
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
+	xfs_syncd_stop(mp);
 	goto out_free_sb;
 }
 
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index f0f1894..f7f019f 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -379,7 +379,15 @@ xfs_sync_worker(
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
@@ -407,14 +415,6 @@ xfs_syncd_queue_reclaim(
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
@@ -483,7 +483,6 @@ xfs_syncd_init(
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 
 	xfs_syncd_queue_sync(mp);
-	xfs_syncd_queue_reclaim(mp);
 
 	return 0;
 }
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
