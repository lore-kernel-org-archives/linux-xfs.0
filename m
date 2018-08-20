Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:39951 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726021AbeHTIDX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 04:03:23 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0006S3-6P
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0000QJ-5K
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/10] xfs: convert remaining mount flags to state flags
Date: Mon, 20 Aug 2018 14:48:46 +1000
Message-Id: <20180820044851.414-6-david@fromorbit.com>
In-Reply-To: <20180820044851.414-1-david@fromorbit.com>
References: <20180820044851.414-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The remaining mount flags kept in m_flags are actually runtime state
flags. These change dynamically, so they really should be updated
atomically so we don't potentially lose an update dur to racing
modifications.

Rename m_flags to m_state, and convert it to use atomic bitops to
set and clear the flags. This also adds a couple of simple wrappers
for common state checks - read only and shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  2 +-
 fs/xfs/libxfs/xfs_sb.c    |  4 ++--
 fs/xfs/scrub/scrub.c      |  2 +-
 fs/xfs/xfs_buf_item.c     |  2 +-
 fs/xfs/xfs_export.c       |  5 +++--
 fs/xfs/xfs_filestream.c   |  2 +-
 fs/xfs/xfs_fsops.c        |  2 +-
 fs/xfs/xfs_inode.c        |  4 ++--
 fs/xfs/xfs_ioctl.c        |  6 +++---
 fs/xfs/xfs_iops.c         |  2 +-
 fs/xfs/xfs_log.c          | 39 ++++++++++++++++++++++-----------------
 fs/xfs/xfs_log_recover.c  |  2 +-
 fs/xfs/xfs_mount.c        | 25 +++++++++++--------------
 fs/xfs/xfs_mount.h        | 36 +++++++++++++++++++++++-------------
 fs/xfs/xfs_super.c        | 28 +++++++++++++---------------
 15 files changed, 86 insertions(+), 75 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index edf0fbd58ee5..ad7e63d2cd67 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2839,7 +2839,7 @@ xfs_alloc_vextent(
 		 * the first a.g. fails.
 		 */
 		if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
-		    (mp->m_flags & XFS_MOUNT_32BITINODES)) {
+		    test_bit(XFS_STATE_32BITINODES, &mp->m_state)) {
 			args->fsbno = XFS_AGB_TO_FSB(mp,
 					((mp->m_agfrotor / rotorstep) %
 					mp->m_sb.sb_agcount), 0);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5dcb9005173c..ee4d483e1209 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -183,7 +183,7 @@ xfs_validate_sb_read(
 "Superblock has unknown read-only compatible features (0x%x) enabled.",
 			(sbp->sb_features_ro_compat &
 					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
-		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		if (!test_bit(XFS_STATE_RDONLY, &mp->m_state)) {
 			xfs_warn(mp,
 "Attempted to mount read-only compatible filesystem read-write.");
 			xfs_warn(mp,
@@ -981,7 +981,7 @@ xfs_initialize_perag_data(
 
 	xfs_reinit_percpu_counters(mp);
 out:
-	mp->m_flags &= ~XFS_MOUNT_BAD_SUMMARY;
+	clear_bit(XFS_STATE_BAD_SUMMARY, &mp->m_state);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a3698e9b084a..f2cb022a23ab 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -437,7 +437,7 @@ xchk_validate_inputs(
 			goto out;
 
 		error = -EROFS;
-		if (mp->m_flags & XFS_MOUNT_RDONLY)
+		if (xfs_is_readonly(mp))
 			goto out;
 	}
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 5d8495380d2b..de99015fd715 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1133,7 +1133,7 @@ xfs_buf_iodone_callback_error(
 			goto permanent_error;
 
 	/* At unmount we may treat errors differently */
-	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
+	if (test_bit(XFS_STATE_UNMOUNTING, &mp->m_state) && mp->m_fail_unmount)
 		goto permanent_error;
 
 	/*
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index cc1f7d09102f..9630e481f7f9 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -47,6 +47,7 @@ xfs_fs_encode_fh(
 	int		*max_len,
 	struct inode	*parent)
 {
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
 	struct fid		*fid = (struct fid *)fh;
 	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fh;
 	int			fileid_type;
@@ -66,8 +67,8 @@ xfs_fs_encode_fh(
 	 * large enough filesystem may contain them, thus the slightly
 	 * confusing looking conditional below.
 	 */
-	if (!xfs_has_small_inums(XFS_M(inode->i_sb)) ||
-	    (XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_32BITINODES))
+	if (!xfs_has_small_inums(mp) ||
+	    test_bit(XFS_STATE_32BITINODES, &mp->m_state))
 		fileid_type |= XFS_FILEID_TYPE_64FLAG;
 
 	/*
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 182501373af2..b6b1690c4b42 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -330,7 +330,7 @@ xfs_filestream_lookup_ag(
 	 * Set the starting AG using the rotor for inode32, otherwise
 	 * use the directory inode's AG.
 	 */
-	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
+	if (test_bit(XFS_STATE_32BITINODES, &mp->m_state)) {
 		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
 		startag = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
 		mp->m_agfrotor = (mp->m_agfrotor + 1) %
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 7c00b8bedfe3..7c429c5b3a53 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -491,7 +491,7 @@ xfs_do_force_shutdown(
 		return;
 
 	/*
-	 * This flags XFS_MOUNT_FS_SHUTDOWN, makes sure that we don't
+	 * This flags XFS_STATE_SHUTDOWN, makes sure that we don't
 	 * queue up anybody new on the log reservations, and wakes up
 	 * everybody who's sleeping on log reservations to tell them
 	 * the bad news.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0f67ca516c87..5e396dca456e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1620,7 +1620,7 @@ xfs_release(
 		return 0;
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (xfs_is_readonly(mp))
 		return 0;
 
 	if (!XFS_FORCED_SHUTDOWN(mp)) {
@@ -1847,7 +1847,7 @@ xfs_inactive(
 	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (xfs_is_readonly(mp))
 		return;
 
 	/* Try to clean out the cow blocks if there are any. */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 350b9276e6fe..d3bd93ba29a8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1142,7 +1142,7 @@ xfs_ioctl_setattr_get_trans(
 	struct xfs_trans	*tp;
 	int			error = -EROFS;
 
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (xfs_is_readonly(mp))
 		goto out_unlock;
 	error = -EIO;
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -2055,7 +2055,7 @@ xfs_file_ioctl(
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		if (mp->m_flags & XFS_MOUNT_RDONLY)
+		if (xfs_is_readonly(mp))
 			return -EROFS;
 
 		if (copy_from_user(&inout, arg, sizeof(inout)))
@@ -2172,7 +2172,7 @@ xfs_file_ioctl(
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		if (mp->m_flags & XFS_MOUNT_RDONLY)
+		if (xfs_is_readonly(mp))
 			return -EROFS;
 
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0241471916d9..58ef007bccea 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -581,7 +581,7 @@ xfs_vn_change_ok(
 {
 	struct xfs_mount	*mp = XFS_I(d_inode(dentry))->i_mount;
 
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (xfs_is_readonly(mp))
 		return -EROFS;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bcc068dee92a..47811fc143b5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -607,7 +607,7 @@ xfs_log_mount(
 		xfs_notice(mp,
 "Mounting V%d filesystem in no-recovery mode. Filesystem will be inconsistent.",
 			   XFS_SB_VERSION_NUM(&mp->m_sb));
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+		ASSERT(xfs_is_readonly(mp));
 	}
 
 	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
@@ -686,15 +686,17 @@ xfs_log_mount(
 	 * just worked.
 	 */
 	if (!xfs_has_norecovery(mp)) {
-		bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
-
-		if (readonly)
-			mp->m_flags &= ~XFS_MOUNT_RDONLY;
+		bool	readonly;
 
+		/*
+		 * log recovery ignores readonly state and so we need to clear
+		 * mount-based read only state so it can write to disk.
+		 */
+		readonly = test_and_clear_bit(XFS_STATE_RDONLY, &mp->m_state);
 		error = xlog_recover(mp->m_log);
-
 		if (readonly)
-			mp->m_flags |= XFS_MOUNT_RDONLY;
+			set_bit(XFS_STATE_RDONLY, &mp->m_state);
+
 		if (error) {
 			xfs_warn(mp, "log mount/recovery failed: error %d",
 				error);
@@ -743,17 +745,20 @@ xfs_log_mount_finish(
 	struct xfs_mount	*mp)
 {
 	int	error = 0;
-	bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
+	bool	readonly;
 	bool	recovered = mp->m_log->l_flags & XLOG_RECOVERY_NEEDED;
 
 	if (xfs_has_norecovery(mp)) {
-		ASSERT(readonly);
+		ASSERT(xfs_is_readonly(mp));
 		return 0;
-	} else if (readonly) {
-		/* Allow unlinked processing to proceed */
-		mp->m_flags &= ~XFS_MOUNT_RDONLY;
 	}
 
+	/*
+	 * log recovery ignores readonly state and so we need to clear
+	 * mount-based read only state so it can write to disk.
+	 */
+	readonly = test_and_clear_bit(XFS_STATE_RDONLY, &mp->m_state);
+
 	/*
 	 * During the second phase of log recovery, we need iget and
 	 * iput to behave like they do for an active filesystem.
@@ -797,7 +802,7 @@ xfs_log_mount_finish(
 	xfs_wait_buftarg(mp->m_ddev_targp);
 
 	if (readonly)
-		mp->m_flags |= XFS_MOUNT_RDONLY;
+		set_bit(XFS_STATE_RDONLY, &mp->m_state);
 
 	return error;
 }
@@ -861,7 +866,7 @@ xfs_log_write_unmount_record(
 	 * recalculated during log recovery at next mount.  Refer to
 	 * xlog_check_unmount_rec for more details.
 	 */
-	if (XFS_TEST_ERROR((mp->m_flags & XFS_MOUNT_BAD_SUMMARY), mp,
+	if (XFS_TEST_ERROR(test_bit(XFS_STATE_BAD_SUMMARY, &mp->m_state), mp,
 			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
 		xfs_alert(mp, "%s: will fix summary counters at next mount",
 				__func__);
@@ -932,7 +937,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	 */
 	if (xfs_has_norecovery(mp) ||
 	    xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+		ASSERT(xfs_is_readonly(mp));
 		return 0;
 	}
 
@@ -3966,7 +3971,7 @@ xfs_log_force_umount(
 	 */
 	if (!log ||
 	    log->l_flags & XLOG_ACTIVE_RECOVERY) {
-		mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
+		set_bit(XFS_STATE_SHUTDOWN, &mp->m_state);
 		if (mp->m_sb_bp)
 			mp->m_sb_bp->b_flags |= XBF_DONE;
 		return 0;
@@ -3996,7 +4001,7 @@ xfs_log_force_umount(
 	 * everybody up to tell them the bad news.
 	 */
 	spin_lock(&log->l_icloglock);
-	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
+	set_bit(XFS_STATE_SHUTDOWN, &mp->m_state);
 	if (mp->m_sb_bp)
 		mp->m_sb_bp->b_flags |= XBF_DONE;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d57b992f6f6e..49579de464f6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1484,7 +1484,7 @@ xlog_find_tail(
 	 * headers if we have a filesystem using non-persistent counters.
 	 */
 	if (clean)
-		log->l_mp->m_flags |= XFS_MOUNT_WAS_CLEAN;
+		set_bit(XFS_STATE_WAS_CLEAN, &log->l_mp->m_state);
 
 	/*
 	 * Make sure that there are no blocks in front of the head
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 624387661cbc..7cb2577dbd73 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -634,11 +634,11 @@ xfs_check_summary_counts(
 	 * counters.  If any of them are obviously incorrect, we can recompute
 	 * them from the AGF headers in the next step.
 	 */
-	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
+	if (test_bit(XFS_STATE_WAS_CLEAN, &mp->m_state) &&
 	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
 	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
 	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
-		mp->m_flags |= XFS_MOUNT_BAD_SUMMARY;
+		set_bit(XFS_STATE_BAD_SUMMARY, &mp->m_state);
 
 	/*
 	 * We can safely re-initialise incore superblock counters from the
@@ -652,8 +652,8 @@ xfs_check_summary_counts(
 	 * Otherwise, recalculate the summary counters.
 	 */
 	if ((!xfs_has_lazysbcount(mp) ||
-	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
-	    !(mp->m_flags & XFS_MOUNT_BAD_SUMMARY))
+	     test_bit(XFS_STATE_WAS_CLEAN, &mp->m_state)) &&
+	     !test_bit(XFS_STATE_BAD_SUMMARY, &mp->m_state))
 		return 0;
 
 	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
@@ -926,7 +926,7 @@ xfs_mountfs(
 	 * the next remount into writeable mode.  Otherwise we would never
 	 * perform the update e.g. for the root filesystem.
 	 */
-	if (mp->m_update_sb && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (mp->m_update_sb && !xfs_is_readonly(mp)) {
 		error = xfs_sync_sb(mp, false);
 		if (error) {
 			xfs_warn(mp, "failed to write sb changes");
@@ -977,7 +977,7 @@ xfs_mountfs(
 	 * We use the same quiesce mechanism as the rw->ro remount, as they are
 	 * semantically identical operations.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !xfs_has_norecovery(mp))
+	if (xfs_is_readonly(mp) && !xfs_has_norecovery(mp))
 		xfs_quiesce_attr(mp);
 
 	/*
@@ -1001,7 +1001,7 @@ xfs_mountfs(
 	 * This may drive us straight to ENOSPC on mount, but that implies
 	 * we were already there on the last unmount. Warn if this occurs.
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (!xfs_is_readonly(mp)) {
 		resblks = xfs_default_resblks(mp);
 		error = xfs_reserve_blocks(mp, &resblks, NULL);
 		if (error)
@@ -1049,7 +1049,7 @@ xfs_mountfs(
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
  out_log_dealloc:
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
+	set_bit(XFS_STATE_UNMOUNTING, &mp->m_state);
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
@@ -1115,7 +1115,7 @@ xfs_unmountfs(
 	 * out anything that we have been retrying in the background. This will
 	 * prevent neverending retries in AIL pushing from hanging the unmount.
 	 */
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
+	set_bit(XFS_STATE_UNMOUNTING, &mp->m_state);
 
 	/*
 	 * Flush all pending changes from the AIL.
@@ -1187,7 +1187,7 @@ xfs_fs_writable(
 {
 	ASSERT(level > SB_UNFROZEN);
 	if ((mp->m_super->s_writers.frozen >= level) ||
-	    XFS_FORCED_SHUTDOWN(mp) || (mp->m_flags & XFS_MOUNT_RDONLY))
+	    XFS_FORCED_SHUTDOWN(mp) || xfs_is_readonly(mp))
 		return false;
 
 	return true;
@@ -1424,8 +1424,5 @@ xfs_force_summary_recalc(
 {
 	if (!xfs_has_lazysbcount(mp))
 		return;
-
-	spin_lock(&mp->m_sb_lock);
-	mp->m_flags |= XFS_MOUNT_BAD_SUMMARY;
-	spin_unlock(&mp->m_sb_lock);
+	set_bit(XFS_STATE_BAD_SUMMARY, &mp->m_state);
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fee11d015b5a..03f4681c1ba6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -126,7 +126,7 @@ typedef struct xfs_mount {
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	struct mutex		m_growlock;	/* growfs mutex */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
-	uint64_t		m_flags;	/* global mount flags */
+	unsigned long		m_state;	/* dynamic state flags */
 	uint64_t		m_features;	/* active filesystem features */
 	bool			m_inotbt_nores; /* no per-AG finobt resv. */
 	int			m_ialloc_inos;	/* inodes in inode allocation */
@@ -316,17 +316,28 @@ __XFS_HAS_FEAT(noattr2, NOATTR2)
 __XFS_HAS_FEAT(noalign, NOALIGN)
 
 /*
- * Flags for m_flags.
+ * Mount state flags
+ *
+ * Use these with atomic bit ops only!
  */
-#define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
-#define XFS_MOUNT_BAD_SUMMARY	(1ULL << 2)	/* summary counters are bad */
-#define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
-#define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
-						   operations, typically for
-						   disk errors in metadata */
-#define XFS_MOUNT_32BITINODES	(1ULL << 15)	/* inode32 allocator active */
-#define XFS_MOUNT_RDONLY	(1ULL << 20)	/* read-only fs */
+#define XFS_STATE_UNMOUNTING	0	/* filesystem is unmounting */
+#define XFS_STATE_BAD_SUMMARY	1	/* summary counters are bad */
+#define XFS_STATE_WAS_CLEAN	2	/* mount was clean */
+#define XFS_STATE_SHUTDOWN	3	/* atomic stop of all filesystem
+					   operations, typically for
+					   disk errors in metadata */
+#define XFS_STATE_32BITINODES	4	/* inode32 allocator active */
+#define XFS_STATE_RDONLY	5	/* read-only fs */
+
+static inline bool xfs_is_readonly(struct xfs_mount *mp)
+{
+	return test_bit(XFS_STATE_RDONLY, &mp->m_state);
+}
 
+static inline bool xfs_is_shut_down(struct xfs_mount *mp)
+{
+	return test_bit(XFS_STATE_SHUTDOWN, &mp->m_state);
+}
 
 /*
  * Default minimum read and write sizes.
@@ -372,9 +383,8 @@ xfs_preferred_iosize(xfs_mount_t *mp)
 	return PAGE_SIZE;
 }
 
-#define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
-				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
-#define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
+#define XFS_FORCED_SHUTDOWN(mp) \
+		test_bit(XFS_STATE_SHUTDOWN, &(mp)->m_state)
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
 #define xfs_force_shutdown(m,f)	\
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d3dff878be99..9938d9fb420b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -191,7 +191,7 @@ xfs_parseargs(
 	 * Copy binary VFS mount flags we are interested in.
 	 */
 	if (sb_rdonly(sb))
-		mp->m_flags |= XFS_MOUNT_RDONLY;
+		set_bit(XFS_STATE_RDONLY, &mp->m_state);
 	if (sb->s_flags & SB_DIRSYNC)
 		mp->m_features |= XFS_FEAT_DIRSYNC;
 	if (sb->s_flags & SB_SYNCHRONOUS)
@@ -361,7 +361,7 @@ xfs_parseargs(
 	/*
 	 * no recovery flag requires a read-only mount
 	 */
-	if (xfs_has_norecovery(mp) && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (xfs_has_norecovery(mp) && !xfs_is_readonly(mp)) {
 		xfs_warn(mp, "no-recovery mounts must be read-only.");
 		return -EINVAL;
 	}
@@ -567,7 +567,7 @@ xfs_max_file_offset(
  *
  * Inode allocation patterns are altered only if inode32 is requested
  * (XFS_FEAT_SMALL_INUMS), and the filesystem is sufficiently large.
- * If altered, XFS_MOUNT_32BITINODES is set as well.
+ * If altered, XFS_STATE_32BITINODES is set as well.
  *
  * An agcount independent of that in the mount structure is provided
  * because in the growfs case, mp->m_sb.sb_agcount is not yet updated
@@ -609,13 +609,13 @@ xfs_set_inode_alloc(
 
 	/*
 	 * If user asked for no more than 32-bit inodes, and the fs is
-	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
+	 * sufficiently large, set XFS_STATE_32BITINODES if we must alter
 	 * the allocator to accommodate the request.
 	 */
 	if (xfs_has_small_inums(mp) && ino > XFS_MAXINUMBER_32)
-		mp->m_flags |= XFS_MOUNT_32BITINODES;
+		set_bit(XFS_STATE_32BITINODES, &mp->m_state);
 	else
-		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
+		clear_bit(XFS_STATE_32BITINODES, &mp->m_state);
 
 	for (index = 0; index < agcount; index++) {
 		struct xfs_perag	*pag;
@@ -624,7 +624,7 @@ xfs_set_inode_alloc(
 
 		pag = xfs_perag_get(mp, index);
 
-		if (mp->m_flags & XFS_MOUNT_32BITINODES) {
+		if (test_bit(XFS_STATE_32BITINODES, &mp->m_state)) {
 			if (ino > XFS_MAXINUMBER_32) {
 				pag->pagi_inodeok = 0;
 				pag->pagf_metadata = 0;
@@ -644,7 +644,7 @@ xfs_set_inode_alloc(
 		xfs_perag_put(pag);
 	}
 
-	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
+	return test_bit(XFS_STATE_32BITINODES, &mp->m_state) ? maxagi : agcount;
 }
 
 STATIC int
@@ -1294,7 +1294,7 @@ xfs_fs_remount(
 	}
 
 	/* ro -> rw */
-	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
+	if (xfs_is_readonly(mp) && !(*flags & SB_RDONLY)) {
 		if (xfs_has_norecovery(mp)) {
 			xfs_warn(mp,
 		"ro->rw transition prohibited on norecovery mount");
@@ -1311,7 +1311,7 @@ xfs_fs_remount(
 			return -EINVAL;
 		}
 
-		mp->m_flags &= ~XFS_MOUNT_RDONLY;
+		clear_bit(XFS_STATE_RDONLY, &mp->m_state);
 
 		/*
 		 * If this is the first remount to writeable state we
@@ -1350,7 +1350,7 @@ xfs_fs_remount(
 	}
 
 	/* rw -> ro */
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
+	if (!xfs_is_readonly(mp) && (*flags & SB_RDONLY)) {
 		/*
 		 * Cancel background eofb scanning so it cannot race with the
 		 * final log force+buftarg wait and deadlock the remount.
@@ -1381,7 +1381,7 @@ xfs_fs_remount(
 		xfs_save_resvblks(mp);
 
 		xfs_quiesce_attr(mp);
-		mp->m_flags |= XFS_MOUNT_RDONLY;
+		set_bit(XFS_STATE_RDONLY, &mp->m_state);
 	}
 
 	return 0;
@@ -1433,8 +1433,6 @@ STATIC int
 xfs_finish_flags(
 	struct xfs_mount	*mp)
 {
-	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
-
 	/* Fail a mount where the logbuf is smaller than the log stripe */
 	if (xfs_has_logv2(mp)) {
 		if (mp->m_logbsize <= 0 &&
@@ -1467,7 +1465,7 @@ xfs_finish_flags(
 	/*
 	 * prohibit r/w mounts of read-only filesystems
 	 */
-	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !ronly) {
+	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !xfs_is_readonly(mp)) {
 		xfs_warn(mp,
 			"cannot mount a read-only filesystem as read-write");
 		return -EROFS;
-- 
2.17.0
