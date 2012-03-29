Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2T6U9lw042679 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 01:30:09 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sm4oo6OkcF4NDzNq for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 23:30:06 -0700 (PDT)
Date: Thu, 29 Mar 2012 17:30:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: Ensure inode reclaim can run during quotacheck
Message-ID: <20120329063002.GO5091@dastard>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-4-git-send-email-david@fromorbit.com>
	<20120322151548.GS7762@sgi.com> <20120322210723.GC5091@dastard>
	<4F6C7BE7.3060100@sgi.com> <20120325232253.GJ5091@dastard>
	<4F7086FA.9010003@sgi.com> <20120326215709.GM5091@dastard>
	<20120328194018.GE7762@sgi.com> <20120329002949.GA692@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120329002949.GA692@dastard>
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
To: Ben Myers <bpm@sgi.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Thu, Mar 29, 2012 at 11:29:49AM +1100, Dave Chinner wrote:
> On Wed, Mar 28, 2012 at 02:40:18PM -0500, Ben Myers wrote:
> 
> [ snip repeated arguments about startup races ]
> 
> [ insert repeated responses about "fixed in next patch" ]
> 
> [ wait for circle to go around again ]
> 
> > I suggest 3 and 4 should be combined into one patch.
> 
> Why didn't you just say that's what you want? I have no problem
> doing that.  I just kept them separate as there are two logical
> changes to the fix - startup order changes, and MS_ACTIVE guard
> changes.  Do you want me to send a new combined patch?

Here's a new combined patch against current linus+xfsdev TOT.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: Ensure inode reclaim can run during quotacheck

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
index dab9a5f..aef50ab 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -981,8 +981,6 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	xfs_syncd_stop(mp);
-
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
 	 * This can and will cause log traffic as inodes go inactive
@@ -993,6 +991,7 @@ xfs_fs_put_super(
 	xfs_flush_buftarg(mp->m_ddev_targp, 1);
 
 	xfs_unmountfs(mp);
+	xfs_syncd_stop(mp);
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
@@ -1362,31 +1361,33 @@ xfs_fs_fill_super(
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
@@ -1403,8 +1404,6 @@ out_destroy_workqueues:
  out:
 	return -error;
 
- out_syncd_stop:
-	xfs_syncd_stop(mp);
  out_unmount:
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
@@ -1416,6 +1415,7 @@ out_destroy_workqueues:
 	xfs_flush_buftarg(mp->m_ddev_targp, 1);
 
 	xfs_unmountfs(mp);
+	xfs_syncd_stop(mp);
 	goto out_free_sb;
 }
 
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 205ebcb..c318d8a 100644
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
