Return-Path: <SRS0=7MVS=IG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBC4C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 04:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 181496514A
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 04:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhCHEsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 23:48:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232439AbhCHEsi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Mar 2021 23:48:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0BCF6514A;
        Mon,  8 Mar 2021 04:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615178917;
        bh=brw/3JiqgETJJH+jcqEp31L+TIFSBInBILOSPNf3IQg=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ClOTRMtRbp7dy0faEkYIVtmPwU7H5X9xT8uFocq+O3oxNPnrXdoOKvXkdSiQ15PDL
         UFgjGxJqaISuGk9HnNE9WaJBuKgBDfh9GfEDy4nyXRdvKAJ9buGSuAb0/0P2UtCAVv
         FBmxHppUy8wBi42bPZf1/gDS9MJ7SgyMib8kvV1C6AY/8RHCb6WRC30jVMj1pIbokf
         U/F+qsIMKfaLHaSlukh67BX7ZChWBRgZcVSLOD21zIsF+gDjZ9IWsyxUj8Of3o5WlW
         quh/4SkjzDBdgynLCt1eC6auMEP1IbJbYISm7OJtkRvb212fkF0RdW5rpjqEadb6Lx
         DAkg347Xyofbg==
Date:   Sun, 7 Mar 2021 20:48:37 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: [PATCH v2.1 3/4] xfs: force log and push AIL to clear pinned inodes
 when aborting mount
Message-ID: <20210308044837.GN3419940@magnolia>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
 <161514875722.698643.971171271199400538.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161514875722.698643.971171271199400538.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we allocate quota inodes in the process of mounting a filesystem but
then decide to abort the mount, it's possible that the quota inodes are
sitting around pinned by the log.  Now that inode reclaim relies on the
AIL to flush inodes, we have to force the log and push the AIL in
between releasing the quota inodes and kicking off reclaim to tear down
all the incore inodes.  Do this by extracting the bits we need from the
unmount path and reusing them; as an added bonus, failed writes during
a failed mount will not retry forever.

This was originally found during a fuzz test of metadata directories
(xfs/1546), but the actual symptom was that reclaim hung up on the quota
inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2.1: consolidate the comments.
---
 fs/xfs/xfs_mount.c |   90 +++++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 52370d0a3f43..1c97b155a8ee 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -634,6 +634,47 @@ xfs_check_summary_counts(
 	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
 }
 
+/*
+ * Flush and reclaim dirty inodes in preparation for unmount. Inodes and
+ * internal inode structures can be sitting in the CIL and AIL at this point,
+ * so we need to unpin them, write them back and/or reclaim them before unmount
+ * can proceed.
+ *
+ * An inode cluster that has been freed can have its buffer still pinned in
+ * memory because the transaction is still sitting in a iclog. The stale inodes
+ * on that buffer will be pinned to the buffer until the transaction hits the
+ * disk and the callbacks run. Pushing the AIL will skip the stale inodes and
+ * may never see the pinned buffer, so nothing will push out the iclog and
+ * unpin the buffer.
+ *
+ * Hence we need to force the log to unpin everything first. However, log
+ * forces don't wait for the discards they issue to complete, so we have to
+ * explicitly wait for them to complete here as well.
+ *
+ * Then we can tell the world we are unmounting so that error handling knows
+ * that the filesystem is going away and we should error out anything that we
+ * have been retrying in the background.  This will prevent never-ending
+ * retries in AIL pushing from hanging the unmount.
+ *
+ * Finally, we can push the AIL to clean all the remaining dirty objects, then
+ * reclaim the remaining inodes that are still in memory at this point in time.
+ */
+static void
+xfs_unmount_flush_inodes(
+	struct xfs_mount	*mp)
+{
+	xfs_log_force(mp, XFS_LOG_SYNC);
+	xfs_extent_busy_wait_all(mp);
+	flush_workqueue(xfs_discard_wq);
+
+	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
+
+	xfs_ail_push_all_sync(mp->m_ail);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_reclaim_inodes(mp);
+	xfs_health_unmount(mp);
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -1008,7 +1049,7 @@ xfs_mountfs(
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
 	/*
-	 * Cancel all delayed reclaim work and reclaim the inodes directly.
+	 * Flush all inode reclamation work and flush the log.
 	 * We have to do this /after/ rtunmount and qm_unmount because those
 	 * two will have scheduled delayed reclaim for the rt/quota inodes.
 	 *
@@ -1018,11 +1059,8 @@ xfs_mountfs(
 	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
 	 * quota inodes.
 	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
  out_log_dealloc:
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
@@ -1063,47 +1101,7 @@ xfs_unmountfs(
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
 
-	/*
-	 * We can potentially deadlock here if we have an inode cluster
-	 * that has been freed has its buffer still pinned in memory because
-	 * the transaction is still sitting in a iclog. The stale inodes
-	 * on that buffer will be pinned to the buffer until the
-	 * transaction hits the disk and the callbacks run. Pushing the AIL will
-	 * skip the stale inodes and may never see the pinned buffer, so
-	 * nothing will push out the iclog and unpin the buffer. Hence we
-	 * need to force the log here to ensure all items are flushed into the
-	 * AIL before we go any further.
-	 */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	/*
-	 * Wait for all busy extents to be freed, including completion of
-	 * any discard operation.
-	 */
-	xfs_extent_busy_wait_all(mp);
-	flush_workqueue(xfs_discard_wq);
-
-	/*
-	 * We now need to tell the world we are unmounting. This will allow
-	 * us to detect that the filesystem is going away and we should error
-	 * out anything that we have been retrying in the background. This will
-	 * prevent neverending retries in AIL pushing from hanging the unmount.
-	 */
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
-
-	/*
-	 * Flush all pending changes from the AIL.
-	 */
-	xfs_ail_push_all_sync(mp->m_ail);
-
-	/*
-	 * Reclaim all inodes. At this point there should be no dirty inodes and
-	 * none should be pinned or locked. Stop background inode reclaim here
-	 * if it is still running.
-	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
 
 	xfs_qm_unmount(mp);
 
