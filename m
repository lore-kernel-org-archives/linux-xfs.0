Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8E1367F58
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 16:15:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6912A304043
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 14:15:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PHVQwWDuhCR5aVJQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 14:15:32 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id F09529D1DB
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 21:15:31 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t77LFVGb032048
	for <xfs@oss.sgi.com>; Fri, 7 Aug 2015 17:15:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 06/12] xfs: don't leave EFIs on AIL on mount failure
Date: Fri,  7 Aug 2015 17:15:22 -0400
Message-Id: <1438982128-38618-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
References: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
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
 fs/xfs/xfs_log.c         | 30 ++++++++++++++++++-----
 fs/xfs/xfs_log.h         |  1 +
 fs/xfs/xfs_log_priv.h    |  2 ++
 fs/xfs/xfs_log_recover.c | 63 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_mount.c       | 26 +++++++++++---------
 5 files changed, 100 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6b5a84a..3a5592c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -700,6 +700,7 @@ xfs_log_mount(
 		if (error) {
 			xfs_warn(mp, "log mount/recovery failed: error %d",
 				error);
+			xlog_recover_cancel(mp->m_log);
 			goto out_destroy_ail;
 		}
 	}
@@ -740,18 +741,35 @@ out:
  * it.
  */
 int
-xfs_log_mount_finish(xfs_mount_t *mp)
+xfs_log_mount_finish(
+	struct xfs_mount	*mp)
 {
 	int	error = 0;
 
-	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
-		error = xlog_recover_finish(mp->m_log);
-		if (!error)
-			xfs_log_work_queue(mp);
-	} else {
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+		return 0;
 	}
 
+	error = xlog_recover_finish(mp->m_log);
+	if (!error)
+		xfs_log_work_queue(mp);
+
+	return error;
+}
+
+/*
+ * The mount has failed. Cancel the recovery if it hasn't completed and destroy
+ * the log.
+ */
+int
+xfs_log_mount_cancel(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	error = xlog_recover_cancel(mp->m_log);
+	xfs_log_unmount(mp);
 
 	return error;
 }
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index fa27aae..09d91d3 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -147,6 +147,7 @@ int	  xfs_log_mount(struct xfs_mount	*mp,
 			xfs_daddr_t		start_block,
 			int		 	num_bblocks);
 int	  xfs_log_mount_finish(struct xfs_mount *mp);
+int	xfs_log_mount_cancel(struct xfs_mount *);
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
index 113042e..c1c4de2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3823,10 +3823,10 @@ abort_error:
  */
 STATIC int
 xlog_recover_process_efis(
-	struct xlog	*log)
+	struct xlog		*log)
 {
-	xfs_log_item_t		*lip;
-	xfs_efi_log_item_t	*efip;
+	struct xfs_log_item	*lip;
+	struct xfs_efi_log_item	*efip;
 	int			error = 0;
 	struct xfs_ail_cursor	cur;
 	struct xfs_ail		*ailp;
@@ -3850,7 +3850,7 @@ xlog_recover_process_efis(
 		/*
 		 * Skip EFIs that we've already processed.
 		 */
-		efip = (xfs_efi_log_item_t *)lip;
+		efip = (struct xfs_efi_log_item *) lip;
 		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags)) {
 			lip = xfs_trans_ail_cursor_next(ailp, &cur);
 			continue;
@@ -3870,6 +3870,50 @@ out:
 }
 
 /*
+ * A cancel occurs when the mount has failed and we're bailing out. Release all
+ * pending EFIs so they don't pin the AIL.
+ */
+STATIC int
+xlog_recover_cancel_efis(
+	struct xlog		*log)
+{
+	struct xfs_log_item	*lip;
+	struct xfs_efi_log_item	*efip;
+	int			error = 0;
+	struct xfs_ail_cursor	cur;
+	struct xfs_ail		*ailp;
+
+	ailp = log->l_ailp;
+	spin_lock(&ailp->xa_lock);
+	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	while (lip != NULL) {
+		/*
+		 * We're done when we see something other than an EFI.
+		 * There should be no EFIs left in the AIL now.
+		 */
+		if (lip->li_type != XFS_LI_EFI) {
+#ifdef DEBUG
+			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
+				ASSERT(lip->li_type != XFS_LI_EFI);
+#endif
+			break;
+		}
+
+		efip = (struct xfs_efi_log_item *) lip;
+
+		spin_unlock(&ailp->xa_lock);
+		xfs_efi_release(efip);
+		spin_lock(&ailp->xa_lock);
+
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+	}
+
+	xfs_trans_ail_cursor_done(&cur);
+	spin_unlock(&ailp->xa_lock);
+	return error;
+}
+
+/*
  * This routine performs a transaction to null out a bad inode pointer
  * in an agi unlinked inode hash bucket.
  */
@@ -4644,6 +4688,17 @@ xlog_recover_finish(
 	return 0;
 }
 
+int
+xlog_recover_cancel(
+	struct xlog	*log)
+{
+	int		error = 0;
+
+	if (log->l_flags & XLOG_RECOVERY_NEEDED)
+		error = xlog_recover_cancel_efis(log);
+
+	return error;
+}
 
 #if defined(DEBUG)
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 461e791..4825a8a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -615,14 +615,14 @@ xfs_default_resblks(xfs_mount_t *mp)
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
 
 	xfs_sb_mount_common(mp, sbp);
 
@@ -799,7 +799,9 @@ xfs_mountfs(
 	}
 
 	/*
-	 * log's mount-time initialization. Perform 1st part recovery if needed
+	 * Log's mount-time initialization. The first part of recovery can place
+	 * some items on the AIL, to be handled when recovery is finished or
+	 * cancelled.
 	 */
 	error = xfs_log_mount(mp, mp->m_logdev_targp,
 			      XFS_FSB_TO_DADDR(mp, sbp->sb_logstart),
@@ -910,9 +912,9 @@ xfs_mountfs(
 	}
 
 	/*
-	 * Finish recovering the file system.  This part needed to be
-	 * delayed until after the root and real-time bitmap inodes
-	 * were consistently read in.
+	 * Finish recovering the file system.  This part needed to be delayed
+	 * until after the root and real-time bitmap inodes were consistently
+	 * read in.
 	 */
 	error = xfs_log_mount_finish(mp);
 	if (error) {
@@ -956,7 +958,7 @@ xfs_mountfs(
  out_rele_rip:
 	IRELE(rip);
  out_log_dealloc:
-	xfs_log_unmount(mp);
+	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_wait_buftarg(mp->m_logdev_targp);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
