Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DE1C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BFD561051
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbhHJFZT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:25:19 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44124 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237582AbhHJFZT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:25:19 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 54680867622
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:24:55 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDKFy-00GZfp-Rf
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:24:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDKFy-000Apv-JP
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:24:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/16] xfs: convert remaining mount flags to state flags
Date:   Tue, 10 Aug 2021 15:24:43 +1000
Message-Id: <20210810052451.41578-9-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810052451.41578-1-david@fromorbit.com>
References: <20210810052451.41578-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=16L4F-L6eCpXPEbgHp8A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The remaining mount flags kept in m_flags are actually runtime state
flags. These change dynamically, so they really should be updated
atomically so we don't potentially lose an update due to racing
modifications.

Convert these remaining flags to be stored in m_opstate and use
atomic bitops to set and clear the flags. This also adds a couple of
simple wrappers for common state checks - read only and shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |  2 +-
 fs/xfs/libxfs/xfs_sb.c    |  2 +-
 fs/xfs/scrub/common.c     |  2 +-
 fs/xfs/scrub/scrub.c      |  2 +-
 fs/xfs/xfs_buf.c          |  2 +-
 fs/xfs/xfs_export.c       |  4 ++--
 fs/xfs/xfs_filestream.c   |  2 +-
 fs/xfs/xfs_fsops.c        |  7 +------
 fs/xfs/xfs_icache.c       |  2 +-
 fs/xfs/xfs_inode.c        |  6 +++---
 fs/xfs/xfs_ioctl.c        |  6 +++---
 fs/xfs/xfs_iops.c         |  2 +-
 fs/xfs/xfs_log.c          | 31 ++++++++++++++++-------------
 fs/xfs/xfs_log_recover.c  |  2 +-
 fs/xfs/xfs_mount.c        | 15 +++++++-------
 fs/xfs/xfs_mount.h        | 42 +++++++++++++++++++++------------------
 fs/xfs/xfs_super.c        | 32 ++++++++++++++---------------
 fs/xfs/xfs_trace.h        |  4 ++--
 18 files changed, 82 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5f943a804d9e..f408ea68dbd0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3166,7 +3166,7 @@ xfs_alloc_vextent(
 		 * the first a.g. fails.
 		 */
 		if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
-		    (mp->m_flags & XFS_MOUNT_32BITINODES)) {
+		    xfs_is_inode32(mp)) {
 			args->fsbno = XFS_AGB_TO_FSB(mp,
 					((mp->m_agfrotor / rotorstep) %
 					mp->m_sb.sb_agcount), 0);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a1e286fb8ac3..baaec7e6a975 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -122,7 +122,7 @@ xfs_validate_sb_read(
 "Superblock has unknown read-only compatible features (0x%x) enabled.",
 			(sbp->sb_features_ro_compat &
 					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
-		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		if (!xfs_is_readonly(mp)) {
 			xfs_warn(mp,
 "Attempted to mount read-only compatible filesystem read-write.");
 			xfs_warn(mp,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 08ba2fa75f67..8ad347842583 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -886,7 +886,7 @@ xchk_start_reaping(
 	 * Readonly filesystems do not perform inactivation or speculative
 	 * preallocation, so there's no need to restart the workers.
 	 */
-	if (!(sc->mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (!xfs_is_readonly(sc->mp)) {
 		xfs_inodegc_start(sc->mp);
 		xfs_blockgc_start(sc->mp);
 	}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index d9534fe0c69b..96c623c464f0 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -419,7 +419,7 @@ xchk_validate_inputs(
 			goto out;
 
 		error = -EROFS;
-		if (mp->m_flags & XFS_MOUNT_RDONLY)
+		if (xfs_is_readonly(mp))
 			goto out;
 	}
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 5d2ebee263d9..958b1343ed59 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1144,7 +1144,7 @@ xfs_buf_ioerror_permanent(
 		return true;
 
 	/* At unmount we may treat errors differently */
-	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
+	if (xfs_is_unmounting(mp) && mp->m_fail_unmount)
 		return true;
 
 	return false;
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index cb359ec3389b..1064c2342876 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -44,6 +44,7 @@ xfs_fs_encode_fh(
 	int		*max_len,
 	struct inode	*parent)
 {
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
 	struct fid		*fid = (struct fid *)fh;
 	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fh;
 	int			fileid_type;
@@ -63,8 +64,7 @@ xfs_fs_encode_fh(
 	 * large enough filesystem may contain them, thus the slightly
 	 * confusing looking conditional below.
 	 */
-	if (!xfs_has_small_inums(XFS_M(inode->i_sb)) ||
-	    (XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_32BITINODES))
+	if (!xfs_has_small_inums(mp) || xfs_is_inode32(mp))
 		fileid_type |= XFS_FILEID_TYPE_64FLAG;
 
 	/*
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index eed6ca5f8f91..6a3ce0f6dc9e 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -295,7 +295,7 @@ xfs_filestream_lookup_ag(
 	 * Set the starting AG using the rotor for inode32, otherwise
 	 * use the directory inode's AG.
 	 */
-	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
+	if (xfs_is_inode32(mp)) {
 		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
 		startag = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
 		mp->m_agfrotor = (mp->m_agfrotor + 1) %
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index cbdb9a86edfc..4224cb0d0966 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -527,15 +527,10 @@ xfs_do_force_shutdown(
 	int		tag;
 	const char	*why;
 
-	spin_lock(&mp->m_sb_lock);
-	if (XFS_FORCED_SHUTDOWN(mp)) {
-		spin_unlock(&mp->m_sb_lock);
+	if (test_and_set_bit(XFS_OPSTATE_SHUTDOWN, &mp->m_opstate))
 		return;
-	}
-	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
 	if (mp->m_sb_bp)
 		mp->m_sb_bp->b_flags |= XBF_DONE;
-	spin_unlock(&mp->m_sb_lock);
 
 	if (flags & SHUTDOWN_FORCE_UMOUNT)
 		xfs_alert(mp, "User initiated shutdown received.");
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 35fec850af69..7fb4e070aa98 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -976,7 +976,7 @@ static inline bool
 xfs_want_reclaim_sick(
 	struct xfs_mount	*mp)
 {
-	return (mp->m_flags & XFS_MOUNT_UNMOUNTING) || xfs_has_norecovery(mp) ||
+	return xfs_is_unmounting(mp) || xfs_has_norecovery(mp) ||
 	       XFS_FORCED_SHUTDOWN(mp);
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 822f73d60f92..972a1a8e20cc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1434,7 +1434,7 @@ xfs_release(
 		return 0;
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (xfs_is_readonly(mp))
 		return 0;
 
 	if (!XFS_FORCED_SHUTDOWN(mp)) {
@@ -1674,7 +1674,7 @@ xfs_inode_needs_inactive(
 		return false;
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (xfs_is_readonly(mp))
 		return false;
 
 	/* If the log isn't running, push inodes straight to reclaim. */
@@ -1735,7 +1735,7 @@ xfs_inactive(
 	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (xfs_is_readonly(mp))
 		goto out;
 
 	/* Metadata inodes require explicit resource cleanup. */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e42f09a2bee3..59953c1928e0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1262,7 +1262,7 @@ xfs_ioctl_setattr_get_trans(
 	struct xfs_trans	*tp;
 	int			error = -EROFS;
 
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (xfs_is_readonly(mp))
 		goto out_error;
 	error = -EIO;
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -2080,7 +2080,7 @@ xfs_file_ioctl(
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		if (mp->m_flags & XFS_MOUNT_RDONLY)
+		if (xfs_is_readonly(mp))
 			return -EROFS;
 
 		if (copy_from_user(&inout, arg, sizeof(inout)))
@@ -2197,7 +2197,7 @@ xfs_file_ioctl(
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		if (mp->m_flags & XFS_MOUNT_RDONLY)
+		if (xfs_is_readonly(mp))
 			return -EROFS;
 
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ff7ba534415c..2185acdf4c7a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -673,7 +673,7 @@ xfs_vn_change_ok(
 {
 	struct xfs_mount	*mp = XFS_I(d_inode(dentry))->i_mount;
 
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (xfs_is_readonly(mp))
 		return -EROFS;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fa59be56ee46..b171f472e79b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -645,7 +645,7 @@ xfs_log_mount(
 		xfs_notice(mp,
 "Mounting V%d filesystem in no-recovery mode. Filesystem will be inconsistent.",
 			   XFS_SB_VERSION_NUM(&mp->m_sb));
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+		ASSERT(xfs_is_readonly(mp));
 	}
 
 	log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
@@ -725,15 +725,15 @@ xfs_log_mount(
 	 * just worked.
 	 */
 	if (!xfs_has_norecovery(mp)) {
-		bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
-
-		if (readonly)
-			mp->m_flags &= ~XFS_MOUNT_RDONLY;
-
+		/*
+		 * log recovery ignores readonly state and so we need to clear
+		 * mount-based read only state so it can write to disk.
+		 */
+		bool	readonly = test_and_clear_bit(XFS_OPSTATE_READONLY,
+						&mp->m_opstate);
 		error = xlog_recover(log);
-
 		if (readonly)
-			mp->m_flags |= XFS_MOUNT_RDONLY;
+			set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 		if (error) {
 			xfs_warn(mp, "log mount/recovery failed: error %d",
 				error);
@@ -782,17 +782,20 @@ xfs_log_mount_finish(
 	struct xfs_mount	*mp)
 {
 	struct xlog		*log = mp->m_log;
-	bool			readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
+	bool			readonly;
 	int			error = 0;
 
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
+	readonly = test_and_clear_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
+
 	/*
 	 * During the second phase of log recovery, we need iget and
 	 * iput to behave like they do for an active filesystem.
@@ -844,7 +847,7 @@ xfs_log_mount_finish(
 
 	clear_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
 	if (readonly)
-		mp->m_flags |= XFS_MOUNT_RDONLY;
+		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 
 	/* Make sure the log is dead if we're returning failure. */
 	ASSERT(!error || xlog_is_shutdown(log));
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d462b856cea3..a985aa1a721c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1347,7 +1347,7 @@ xlog_find_tail(
 	 * headers if we have a filesystem using non-persistent counters.
 	 */
 	if (clean)
-		log->l_mp->m_flags |= XFS_MOUNT_WAS_CLEAN;
+		set_bit(XFS_OPSTATE_CLEAN, &log->l_mp->m_opstate);
 
 	/*
 	 * Make sure that there are no blocks in front of the head
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3fc53c082aa2..7a567d4b6911 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -488,7 +488,7 @@ xfs_check_summary_counts(
 	 * counters.  If any of them are obviously incorrect, we can recompute
 	 * them from the AGF headers in the next step.
 	 */
-	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
+	if (xfs_is_clean(mp) &&
 	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
 	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
 	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
@@ -505,8 +505,7 @@ xfs_check_summary_counts(
 	 * superblock to be correct and we don't need to do anything here.
 	 * Otherwise, recalculate the summary counters.
 	 */
-	if ((!xfs_has_lazysbcount(mp) ||
-	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
+	if ((!xfs_has_lazysbcount(mp) || xfs_is_clean(mp)) &&
 	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
 		return 0;
 
@@ -547,7 +546,7 @@ xfs_unmount_flush_inodes(
 	xfs_extent_busy_wait_all(mp);
 	flush_workqueue(xfs_discard_wq);
 
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
+	set_bit(XFS_OPSTATE_UNMOUNTING, &mp->m_opstate);
 
 	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_inodegc_stop(mp);
@@ -835,7 +834,7 @@ xfs_mountfs(
 	 * the next remount into writeable mode.  Otherwise we would never
 	 * perform the update e.g. for the root filesystem.
 	 */
-	if (mp->m_update_sb && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (mp->m_update_sb && !xfs_is_readonly(mp)) {
 		error = xfs_sync_sb(mp, false);
 		if (error) {
 			xfs_warn(mp, "failed to write sb changes");
@@ -892,7 +891,7 @@ xfs_mountfs(
 	 * We use the same quiesce mechanism as the rw->ro remount, as they are
 	 * semantically identical operations.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !xfs_has_norecovery(mp))
+	if (xfs_is_readonly(mp) && !xfs_has_norecovery(mp))
 		xfs_log_clean(mp);
 
 	/*
@@ -916,7 +915,7 @@ xfs_mountfs(
 	 * This may drive us straight to ENOSPC on mount, but that implies
 	 * we were already there on the last unmount. Warn if this occurs.
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (!xfs_is_readonly(mp)) {
 		resblks = xfs_default_resblks(mp);
 		error = xfs_reserve_blocks(mp, &resblks, NULL);
 		if (error)
@@ -1077,7 +1076,7 @@ xfs_fs_writable(
 {
 	ASSERT(level > SB_UNFROZEN);
 	if ((mp->m_super->s_writers.frozen >= level) ||
-	    XFS_FORCED_SHUTDOWN(mp) || (mp->m_flags & XFS_MOUNT_RDONLY))
+	    XFS_FORCED_SHUTDOWN(mp) || xfs_is_readonly(mp))
 		return false;
 
 	return true;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 47fb8008f0e3..1cbd35f2caa9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -147,7 +147,6 @@ typedef struct xfs_mount {
 	uint			m_rsumsize;	/* size of rt summary, bytes */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_qflags;	/* quota status flags */
-	uint64_t		m_flags;	/* global mount flags */
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
@@ -343,8 +342,8 @@ __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 /*
  * Mount features
  *
- * These do not change dynamically - features that can come and go,
- * such as 32 bit inodes and read-only state, are kept as flags rather than
+ * These do not change dynamically - features that can come and go, such as 32
+ * bit inodes and read-only state, are kept as operational state rather than
  * features.
  */
 __XFS_HAS_FEAT(noattr2, NOATTR2)
@@ -365,31 +364,28 @@ __XFS_HAS_FEAT(norecovery, NORECOVERY)
 __XFS_HAS_FEAT(nouuid, NOUUID)
 
 /*
- * Flags for m_flags.
+ * Operational mount state flags
+ *
+ * Use these with atomic bit ops only!
  */
-#define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
-						   must be synchronous except
-						   for space allocations */
-#define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
-#define XFS_MOUNT_WAS_CLEAN	(1ULL << 2)
-#define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 3)	/* atomic stop of all filesystem
-						   operations, typically for
-						   disk errors in metadata */
-#define XFS_MOUNT_32BITINODES	(1ULL << 15)	/* inode32 allocator active */
-#define XFS_MOUNT_RDONLY	(1ULL << 4)	/* read-only fs */
+#define XFS_OPSTATE_UNMOUNTING		0	/* filesystem is unmounting */
+#define XFS_OPSTATE_CLEAN		1	/* mount was clean */
+#define XFS_OPSTATE_SHUTDOWN		2	/* stop all fs operations */
+#define XFS_OPSTATE_INODE32		3	/* inode32 allocator active */
+#define XFS_OPSTATE_READONLY		4	/* read-only fs */
 
 /*
  * If set, inactivation worker threads will be scheduled to process queued
  * inodegc work.  If not, queued inodes remain in memory waiting to be
  * processed.
  */
-#define XFS_OPSTATE_INODEGC_ENABLED	0
+#define XFS_OPSTATE_INODEGC_ENABLED	5
 /*
  * If set, background speculative prealloc gc worker threads will be scheduled
  * to process queued blockgc work.  If not, inodes retain their preallocations
  * until explicitly deleted.
  */
-#define XFS_OPSTATE_BLOCKGC_ENABLED	1
+#define XFS_OPSTATE_BLOCKGC_ENABLED	6
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -405,10 +401,20 @@ static inline bool xfs_set_ ## name (struct xfs_mount *mp) \
 	return test_and_set_bit(XFS_OPSTATE_ ## NAME, &mp->m_opstate); \
 }
 
+__XFS_IS_OPSTATE(unmounting, UNMOUNTING)
+__XFS_IS_OPSTATE(clean, CLEAN)
+__XFS_IS_OPSTATE(shutdown, SHUTDOWN)
+__XFS_IS_OPSTATE(inode32, INODE32)
+__XFS_IS_OPSTATE(readonly, READONLY)
 __XFS_IS_OPSTATE(inodegc_enabled, INODEGC_ENABLED)
 __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
 
 #define XFS_OPSTATE_STRINGS \
+	{ (1UL << XFS_OPSTATE_UNMOUNTING),		"unmounting" }, \
+	{ (1UL << XFS_OPSTATE_CLEAN),			"clean" }, \
+	{ (1UL << XFS_OPSTATE_SHUTDOWN),		"shutdown" }, \
+	{ (1UL << XFS_OPSTATE_INODE32),			"inode32" }, \
+	{ (1UL << XFS_OPSTATE_READONLY),		"read_only" }, \
 	{ (1UL << XFS_OPSTATE_INODEGC_ENABLED),		"inodegc" }, \
 	{ (1UL << XFS_OPSTATE_BLOCKGC_ENABLED),		"blockgc" }
 
@@ -419,9 +425,7 @@ __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
 #define XFS_MAX_IO_LOG		30	/* 1G */
 #define XFS_MIN_IO_LOG		PAGE_SHIFT
 
-#define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
-				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
-#define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
+#define XFS_FORCED_SHUTDOWN(mp)		xfs_is_shutdown(mp)
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
 #define xfs_force_shutdown(m,f)	\
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 21d3257404f1..337ea37bfe4d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -250,7 +250,7 @@ xfs_fs_show_options(
  *
  * Inode allocation patterns are altered only if inode32 is requested
  * (XFS_FEAT_SMALL_INUMS), and the filesystem is sufficiently large.
- * If altered, XFS_MOUNT_32BITINODES is set as well.
+ * If altered, XFS_OPSTATE_INODE32 is set as well.
  *
  * An agcount independent of that in the mount structure is provided
  * because in the growfs case, mp->m_sb.sb_agcount is not yet updated
@@ -292,13 +292,13 @@ xfs_set_inode_alloc(
 
 	/*
 	 * If user asked for no more than 32-bit inodes, and the fs is
-	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
+	 * sufficiently large, set XFS_OPSTATE_INODE32 if we must alter
 	 * the allocator to accommodate the request.
 	 */
 	if (xfs_has_small_inums(mp) && ino > XFS_MAXINUMBER_32)
-		mp->m_flags |= XFS_MOUNT_32BITINODES;
+		set_bit(XFS_OPSTATE_INODE32, &mp->m_opstate);
 	else
-		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
+		clear_bit(XFS_OPSTATE_INODE32, &mp->m_opstate);
 
 	for (index = 0; index < agcount; index++) {
 		struct xfs_perag	*pag;
@@ -307,7 +307,7 @@ xfs_set_inode_alloc(
 
 		pag = xfs_perag_get(mp, index);
 
-		if (mp->m_flags & XFS_MOUNT_32BITINODES) {
+		if (xfs_is_inode32(mp)) {
 			if (ino > XFS_MAXINUMBER_32) {
 				pag->pagi_inodeok = 0;
 				pag->pagf_metadata = 0;
@@ -327,7 +327,7 @@ xfs_set_inode_alloc(
 		xfs_perag_put(pag);
 	}
 
-	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
+	return xfs_is_inode32(mp) ? maxagi : agcount;
 }
 
 STATIC int
@@ -896,7 +896,7 @@ xfs_fs_freeze(
 	 * here, so we can restart safely without racing with a stop in
 	 * xfs_fs_sync_fs().
 	 */
-	if (ret && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (ret && !xfs_is_readonly(mp)) {
 		xfs_blockgc_start(mp);
 		xfs_inodegc_start(mp);
 	}
@@ -919,7 +919,7 @@ xfs_fs_unfreeze(
 	 * worker because there are no speculative preallocations on a readonly
 	 * filesystem.
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (!xfs_is_readonly(mp)) {
 		xfs_blockgc_start(mp);
 		xfs_inodegc_start(mp);
 	}
@@ -935,8 +935,6 @@ STATIC int
 xfs_finish_flags(
 	struct xfs_mount	*mp)
 {
-	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
-
 	/* Fail a mount where the logbuf is smaller than the log stripe */
 	if (xfs_has_logv2(mp)) {
 		if (mp->m_logbsize <= 0 &&
@@ -969,7 +967,7 @@ xfs_finish_flags(
 	/*
 	 * prohibit r/w mounts of read-only filesystems
 	 */
-	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !ronly) {
+	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !xfs_is_readonly(mp)) {
 		xfs_warn(mp,
 			"cannot mount a read-only filesystem as read-write");
 		return -EROFS;
@@ -1343,7 +1341,7 @@ xfs_fs_validate_params(
 	struct xfs_mount	*mp)
 {
 	/* No recovery flag requires a read-only mount */
-	if (xfs_has_norecovery(mp) && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (xfs_has_norecovery(mp) && !xfs_is_readonly(mp)) {
 		xfs_warn(mp, "no-recovery mounts must be read-only.");
 		return -EINVAL;
 	}
@@ -1722,7 +1720,7 @@ xfs_remount_rw(
 		return -EINVAL;
 	}
 
-	mp->m_flags &= ~XFS_MOUNT_RDONLY;
+	clear_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 
 	/*
 	 * If this is the first remount to writeable state we might have some
@@ -1810,7 +1808,7 @@ xfs_remount_ro(
 	xfs_save_resvblks(mp);
 
 	xfs_log_clean(mp);
-	mp->m_flags |= XFS_MOUNT_RDONLY;
+	set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 
 	return 0;
 }
@@ -1860,14 +1858,14 @@ xfs_fs_reconfigure(
 	}
 
 	/* ro -> rw */
-	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
+	if (xfs_is_readonly(mp) && !(flags & SB_RDONLY)) {
 		error = xfs_remount_rw(mp);
 		if (error)
 			return error;
 	}
 
 	/* rw -> ro */
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
+	if (!xfs_is_readonly(mp) && (flags & SB_RDONLY)) {
 		error = xfs_remount_ro(mp);
 		if (error)
 			return error;
@@ -1934,7 +1932,7 @@ static int xfs_init_fs_context(
 	 * Copy binary VFS mount flags we are interested in.
 	 */
 	if (fc->sb_flags & SB_RDONLY)
-		mp->m_flags |= XFS_MOUNT_RDONLY;
+		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 	if (fc->sb_flags & SB_DIRSYNC)
 		mp->m_features |= XFS_FEAT_DIRSYNC;
 	if (fc->sb_flags & SB_SYNCHRONOUS)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 70c142f6aeb2..5bb974c468e8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -186,13 +186,13 @@ DECLARE_EVENT_CLASS(xfs_fs_class,
 	TP_fast_assign(
 		if (mp) {
 			__entry->dev = mp->m_super->s_dev;
-			__entry->mflags = mp->m_flags;
+			__entry->mflags = mp->m_features;
 			__entry->opstate = mp->m_opstate;
 			__entry->sbflags = mp->m_super->s_flags;
 		}
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d m_flags 0x%llx opstate (%s) s_flags 0x%lx caller %pS",
+	TP_printk("dev %d:%d m_features 0x%llx opstate (%s) s_flags 0x%lx caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->mflags,
 		  __print_flags(__entry->opstate, "|", XFS_OPSTATE_STRINGS),
-- 
2.31.1

