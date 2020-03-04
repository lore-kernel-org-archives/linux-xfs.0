Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C001BC3F2D7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 08:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A1912187F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 08:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725283AbgCDILc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 03:11:32 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47621 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725271AbgCDILc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 03:11:32 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D41667E919B
        for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2020 19:11:28 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqw-0007ln-4O
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:02 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqw-0005cr-2G
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/11] xfs: merge unmount record write iclog cleanup.
Date:   Wed,  4 Mar 2020 18:53:59 +1100
Message-Id: <20200304075401.21558-10-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200304075401.21558-1-david@fromorbit.com>
References: <20200304075401.21558-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=_kU_IPfDU8L_TcjNku8A:9 a=uZXimcwsb_s-5M2f:21 a=AXX_iIusX2xWdw9j:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The unmount iclog handling is duplicated in both
xfs_log_unmount_write() and xfs_log_write_unmount_record(). We only
need one copy of it in xfs_log_unmount_write() because that is the
only function that calls xfs_log_write_unmount_record().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 130 +++++++++++++++++------------------------------
 1 file changed, 48 insertions(+), 82 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bdf604d31d8c..a687c20dd77d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -898,16 +898,11 @@ xlog_state_ioerror(
 	return 0;
 }
 
-/*
- * Mark the filesystem clean by writing an unmount record to the head of the
- * log.
- */
-static void
+static int
 xlog_unmount_write(
 	struct xlog		*log)
 {
 	struct xfs_mount	*mp = log->l_mp;
-	struct xlog_in_core	*iclog;
 	struct xlog_ticket	*tic = NULL;
 	xfs_lsn_t		lsn;
 	uint			flags = XLOG_UNMOUNT_TRANS;
@@ -931,61 +926,41 @@ xlog_unmount_write(
 	}
 
 	error = xlog_write_unmount_record(log, tic, &lsn, flags);
-	/*
-	 * At this point, we're umounting anyway, so there's no point in
-	 * transitioning log state to IOERROR. Just continue...
-	 */
-out_err:
-	if (error)
-		xfs_alert(mp, "%s: unmount record failed", __func__);
-
-	spin_lock(&log->l_icloglock);
-	iclog = log->l_iclog;
-	atomic_inc(&iclog->ic_refcnt);
-	xlog_state_want_sync(log, iclog);
-	error = xlog_state_release_iclog(log, iclog);
-	switch (iclog->ic_state) {
-	default:
-		if (!XLOG_FORCED_SHUTDOWN(log)) {
-			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
-			break;
-		}
-		/* fall through */
-	case XLOG_STATE_ACTIVE:
-	case XLOG_STATE_DIRTY:
+	if (error) {
+		/* A full shutdown is unnecessary at this point of unmount */
+		spin_lock(&log->l_icloglock);
+		log->l_flags |= XLOG_IO_ERROR;
+		xlog_state_ioerror(log);
 		spin_unlock(&log->l_icloglock);
-		break;
 	}
 
-	if (tic) {
-		trace_xfs_log_umount_write(log, tic);
-		xlog_ungrant_log_space(log, tic);
-		xfs_log_ticket_put(tic);
-	}
+	trace_xfs_log_umount_write(log, tic);
+	xlog_ungrant_log_space(log, tic);
+	xfs_log_ticket_put(tic);
+out_err:
+	if (error)
+		xfs_alert(mp, "%s: unmount record failed", __func__);
+	return error;
 }
 
 /*
- * Unmount record used to have a string "Unmount filesystem--" in the
- * data section where the "Un" was really a magic number (XLOG_UNMOUNT_TYPE).
- * We just write the magic number now since that particular field isn't
- * currently architecture converted and "Unmount" is a bit foo.
- * As far as I know, there weren't any dependencies on the old behaviour.
+ * Finalise the unmount by writing the unmount record to the log. This is the
+ * mark that the filesystem was cleanly unmounted.
+ *
+ * Avoid writing the unmount record on no-recovery mounts, ro-devices, or when
+ * the log has already been shut down.
  */
-
 static int
-xfs_log_unmount_write(xfs_mount_t *mp)
+xfs_log_unmount_write(
+	struct xfs_mount	*mp)
 {
-	struct xlog	 *log = mp->m_log;
-	xlog_in_core_t	 *iclog;
+	struct xlog		*log = mp->m_log;
+	struct xlog_in_core	*iclog;
 #ifdef DEBUG
-	xlog_in_core_t	 *first_iclog;
+	struct xlog_in_core	*first_iclog;
 #endif
-	int		 error;
+	int			error;
 
-	/*
-	 * Don't write out unmount record on norecovery mounts or ro devices.
-	 * Or, if we are doing a forced umount (typically because of IO errors).
-	 */
 	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
 	    xfs_readonly_buftarg(log->l_targ)) {
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
@@ -1005,41 +980,32 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		iclog = iclog->ic_next;
 	} while (iclog != first_iclog);
 #endif
-	if (! (XLOG_FORCED_SHUTDOWN(log))) {
-		xlog_unmount_write(log);
-	} else {
-		/*
-		 * We're already in forced_shutdown mode, couldn't
-		 * even attempt to write out the unmount transaction.
-		 *
-		 * Go through the motions of sync'ing and releasing
-		 * the iclog, even though no I/O will actually happen,
-		 * we need to wait for other log I/Os that may already
-		 * be in progress.  Do this as a separate section of
-		 * code so we'll know if we ever get stuck here that
-		 * we're in this odd situation of trying to unmount
-		 * a file system that went into forced_shutdown as
-		 * the result of an unmount..
-		 */
-		spin_lock(&log->l_icloglock);
-		iclog = log->l_iclog;
-		atomic_inc(&iclog->ic_refcnt);
-		xlog_state_want_sync(log, iclog);
-		error =  xlog_state_release_iclog(log, iclog);
-		switch (iclog->ic_state) {
-		case XLOG_STATE_ACTIVE:
-		case XLOG_STATE_DIRTY:
-		case XLOG_STATE_IOERROR:
-			spin_unlock(&log->l_icloglock);
-			break;
-		default:
-			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
-			break;
-		}
-	}
 
+	if (!XLOG_FORCED_SHUTDOWN(log))
+		error = xlog_unmount_write(log);
+
+	/*
+	 * Sync and release the current iclog so the unmount record gets to
+	 * disk. If we are in a shutdown state, no IO will be done, but we still
+	 * we need to wait for other log I/Os that may already be in progress.
+	 */
+	spin_lock(&log->l_icloglock);
+	iclog = log->l_iclog;
+	atomic_inc(&iclog->ic_refcnt);
+	xlog_state_want_sync(log, iclog);
+	error =  xlog_state_release_iclog(log, iclog);
+	switch (iclog->ic_state) {
+	case XLOG_STATE_ACTIVE:
+	case XLOG_STATE_DIRTY:
+	case XLOG_STATE_IOERROR:
+		spin_unlock(&log->l_icloglock);
+		break;
+	default:
+		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
+		break;
+	}
 	return error;
-}	/* xfs_log_unmount_write */
+}
 
 /*
  * Empty the log for unmount/freeze.
-- 
2.24.0.rc0

