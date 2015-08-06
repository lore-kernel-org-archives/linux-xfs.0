Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1AB6F7F8A
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 12:44:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8D160AC005
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 10:44:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gMXsEAuCqnGOTQLA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 10:44:35 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id DA138D4252
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 17:44:34 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t76HiY9i017998
	for <xfs@oss.sgi.com>; Thu, 6 Aug 2015 13:44:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 06/11] xfs: don't leave EFIs on AIL on mount failure
Date: Thu,  6 Aug 2015 13:44:27 -0400
Message-Id: <1438883072-28706-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Log recovery occurs in two phases at mount time. In the first phase,
EFIs and EFDs are processed and potentially cancelled out. EFIs without
EFD objects are inserted into the AIL for processing and recovery in the
second phase. xfs_mountfs() runs various other operations between the
phases and is thus subject to failure. If failure occurs after the first
phase but before the second, pending EFIs sit on the AIL, pin it and
cause the mount to hang.

Update the mount sequence to ensure that pending EFIs are cancelled in
the event of failure. Add a recovery cancellation mechanism to iterate
the AIL and cancel all EFI items when requested. Plumb cancellation
support through the log mount finish helper and update xfs_mountfs() to
invoke cancellation in the event of failure after recovery has started.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c         | 16 +++++++++++-----
 fs/xfs/xfs_log.h         |  2 +-
 fs/xfs/xfs_log_priv.h    |  2 ++
 fs/xfs/xfs_log_recover.c | 41 ++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_mount.c       | 35 +++++++++++++++++++++++------------
 5 files changed, 73 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6b5a84a..522286c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -740,19 +740,25 @@ out:
  * it.
  */
 int
-xfs_log_mount_finish(xfs_mount_t *mp)
+xfs_log_mount_finish(
+	struct xfs_mount	*mp,
+	bool			cancel)
 {
 	int	error = 0;
 
-	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
+		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+		return 0;
+	}
+
+	if (cancel) {
+		error = xlog_recover_cancel(mp->m_log);
+	} else {
 		error = xlog_recover_finish(mp->m_log);
 		if (!error)
 			xfs_log_work_queue(mp);
-	} else {
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 	}
 
-
 	return error;
 }
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index fa27aae..425e880 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -146,7 +146,7 @@ int	  xfs_log_mount(struct xfs_mount	*mp,
 			struct xfs_buftarg	*log_target,
 			xfs_daddr_t		start_block,
 			int		 	num_bblocks);
-int	  xfs_log_mount_finish(struct xfs_mount *mp);
+int	  xfs_log_mount_finish(struct xfs_mount *mp, bool);
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	  xfs_log_space_wake(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 1c87c8a..950f3f9 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -426,6 +426,8 @@ xlog_recover(
 extern int
 xlog_recover_finish(
 	struct xlog		*log);
+extern int
+xlog_recover_cancel(struct xlog *);
 
 extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
 			    char *dp, int size);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a74ff68..a7ba078 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3823,10 +3823,11 @@ abort_error:
  */
 STATIC int
 xlog_recover_process_efis(
-	struct xlog	*log)
+	struct xlog		*log,
+	bool			cancel)
 {
-	xfs_log_item_t		*lip;
-	xfs_efi_log_item_t	*efip;
+	struct xfs_log_item	*lip;
+	struct xfs_efi_log_item	*efip;
 	int			error = 0;
 	struct xfs_ail_cursor	cur;
 	struct xfs_ail		*ailp;
@@ -3847,10 +3848,24 @@ xlog_recover_process_efis(
 			break;
 		}
 
+		efip = (struct xfs_efi_log_item *) lip;
+
+		/*
+		 * A cancel occurs when the mount has failed and we're bailing
+		 * out. Release all pending EFIs so they don't pin the AIL.
+		 */
+		if (cancel) {
+			spin_unlock(&ailp->xa_lock);
+			xfs_efi_release(efip);
+			spin_lock(&ailp->xa_lock);
+
+			lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			continue;
+		}
+
 		/*
 		 * Skip EFIs that we've already processed.
 		 */
-		efip = (xfs_efi_log_item_t *)lip;
 		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags)) {
 			lip = xfs_trans_ail_cursor_next(ailp, &cur);
 			continue;
@@ -4617,8 +4632,13 @@ xlog_recover_finish(
 	 */
 	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
 		int	error;
-		error = xlog_recover_process_efis(log);
+		error = xlog_recover_process_efis(log, false);
 		if (error) {
+			/*
+			 * We could still have pending EFIs. Cancel them so we
+			 * don't hang...
+			 */
+			xlog_recover_process_efis(log, true);
 			xfs_alert(log->l_mp, "Failed to recover EFIs");
 			return error;
 		}
@@ -4644,6 +4664,17 @@ xlog_recover_finish(
 	return 0;
 }
 
+int
+xlog_recover_cancel(
+	struct xlog	*log)
+{
+	int		error = 0;
+
+	if (log->l_flags & XLOG_RECOVERY_NEEDED)
+		error = xlog_recover_process_efis(log, true);
+
+	return error;
+}
 
 #if defined(DEBUG)
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 461e791..45a33d5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -615,14 +615,15 @@ xfs_default_resblks(xfs_mount_t *mp)
  */
 int
 xfs_mountfs(
-	xfs_mount_t	*mp)
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
-	xfs_inode_t	*rip;
-	__uint64_t	resblks;
-	uint		quotamount = 0;
-	uint		quotaflags = 0;
-	int		error = 0;
+	struct xfs_sb		*sbp = &(mp->m_sb);
+	struct xfs_inode	*rip;
+	__uint64_t		resblks;
+	uint			quotamount = 0;
+	uint			quotaflags = 0;
+	int			error = 0;
+	bool			log_mount_cancel = false;
 
 	xfs_sb_mount_common(mp, sbp);
 
@@ -799,7 +800,10 @@ xfs_mountfs(
 	}
 
 	/*
-	 * log's mount-time initialization. Perform 1st part recovery if needed
+	 * Log's mount-time initialization. The first part of recovery can place
+	 * some items on the AIL, to be handled when recovery is finished. Set
+	 * the cancel flag to ensure that the recovery is cancelled should we
+	 * fail before then.
 	 */
 	error = xfs_log_mount(mp, mp->m_logdev_targp,
 			      XFS_FSB_TO_DADDR(mp, sbp->sb_logstart),
@@ -808,6 +812,7 @@ xfs_mountfs(
 		xfs_warn(mp, "log mount failed");
 		goto out_fail_wait;
 	}
+	log_mount_cancel = true;
 
 	/*
 	 * Now the log is mounted, we know if it was an unclean shutdown or
@@ -910,11 +915,15 @@ xfs_mountfs(
 	}
 
 	/*
-	 * Finish recovering the file system.  This part needed to be
-	 * delayed until after the root and real-time bitmap inodes
-	 * were consistently read in.
+	 * Finish recovering the file system.  This part needed to be delayed
+	 * until after the root and real-time bitmap inodes were consistently
+	 * read in.
+	 *
+	 * Reset the cancel flag as the finish cleans up after itself on
+	 * failure.
 	 */
-	error = xfs_log_mount_finish(mp);
+	log_mount_cancel = false;
+	error = xfs_log_mount_finish(mp, false);
 	if (error) {
 		xfs_warn(mp, "log mount finish failed");
 		goto out_rtunmount;
@@ -956,6 +965,8 @@ xfs_mountfs(
  out_rele_rip:
 	IRELE(rip);
  out_log_dealloc:
+	if (log_mount_cancel)
+		xfs_log_mount_finish(mp, true);
 	xfs_log_unmount(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
