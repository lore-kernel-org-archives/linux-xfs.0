Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35630 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730161AbeGSATr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 20:19:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6INcxgC110746
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:31 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2k9yjx3nfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:31 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6INdUrT030940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:30 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6INdUBn011628
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 23:39:30 GMT
Subject: [PATCH 2/3] xfs: refactor unmount record write
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Jul 2018 16:39:29 -0700
Message-ID: <153195716953.16758.3719225666646928225.stgit@magnolia>
In-Reply-To: <153195715716.16758.18150859087945516040.stgit@magnolia>
References: <153195715716.16758.18150859087945516040.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the writing of the unmount record into a separate helper.  No
functionality changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c |  130 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 68 insertions(+), 62 deletions(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5e56f3b93d4b..f114e9031af8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -826,6 +826,73 @@ xfs_log_mount_cancel(
  * deallocation must not be done until source-end.
  */
 
+/* Actually write the unmount record to disk. */
+static void
+xfs_log_write_unmount_record(
+	struct xfs_mount	*mp)
+{
+	/* the data section must be 32 bit size aligned */
+	struct {
+		uint16_t magic;
+		uint16_t pad1;
+		uint32_t pad2; /* may as well make it 64 bits */
+	} magic = {
+		.magic = XLOG_UNMOUNT_TYPE,
+	};
+	struct xfs_log_iovec reg = {
+		.i_addr = &magic,
+		.i_len = sizeof(magic),
+		.i_type = XLOG_REG_TYPE_UNMOUNT,
+	};
+	struct xfs_log_vec vec = {
+		.lv_niovecs = 1,
+		.lv_iovecp = &reg,
+	};
+	struct xlog		*log = mp->m_log;
+	struct xlog_in_core	*iclog;
+	struct xlog_ticket	*tic = NULL;
+	xfs_lsn_t		lsn;
+	int			error;
+
+	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
+	if (error)
+		goto out_err;
+
+	/* remove inited flag, and account for space used */
+	tic->t_flags = 0;
+	tic->t_curr_res -= sizeof(magic);
+	error = xlog_write(log, &vec, tic, &lsn, NULL, XLOG_UNMOUNT_TRANS);
+	/*
+	 * At this point, we're umounting anyway,
+	 * so there's no point in transitioning log state
+	 * to IOERROR. Just continue...
+	 */
+out_err:
+	if (error)
+		xfs_alert(mp, "%s: unmount record failed", __func__);
+
+	spin_lock(&log->l_icloglock);
+	iclog = log->l_iclog;
+	atomic_inc(&iclog->ic_refcnt);
+	xlog_state_want_sync(log, iclog);
+	spin_unlock(&log->l_icloglock);
+	error = xlog_state_release_iclog(log, iclog);
+
+	spin_lock(&log->l_icloglock);
+	if (!(iclog->ic_state == XLOG_STATE_ACTIVE ||
+	      iclog->ic_state == XLOG_STATE_DIRTY) &&
+	    !XLOG_FORCED_SHUTDOWN(log))
+		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
+	else
+		spin_unlock(&log->l_icloglock);
+
+	if (tic) {
+		trace_xfs_log_umount_write(log, tic);
+		xlog_ungrant_log_space(log, tic);
+		xfs_log_ticket_put(tic);
+	}
+}
+
 /*
  * Unmount record used to have a string "Unmount filesystem--" in the
  * data section where the "Un" was really a magic number (XLOG_UNMOUNT_TYPE).
@@ -842,8 +909,6 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 #ifdef DEBUG
 	xlog_in_core_t	 *first_iclog;
 #endif
-	xlog_ticket_t	*tic = NULL;
-	xfs_lsn_t	 lsn;
 	int		 error;
 
 	/*
@@ -870,66 +935,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	} while (iclog != first_iclog);
 #endif
 	if (! (XLOG_FORCED_SHUTDOWN(log))) {
-		error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
-		if (!error) {
-			/* the data section must be 32 bit size aligned */
-			struct {
-			    uint16_t magic;
-			    uint16_t pad1;
-			    uint32_t pad2; /* may as well make it 64 bits */
-			} magic = {
-				.magic = XLOG_UNMOUNT_TYPE,
-			};
-			struct xfs_log_iovec reg = {
-				.i_addr = &magic,
-				.i_len = sizeof(magic),
-				.i_type = XLOG_REG_TYPE_UNMOUNT,
-			};
-			struct xfs_log_vec vec = {
-				.lv_niovecs = 1,
-				.lv_iovecp = &reg,
-			};
-
-			/* remove inited flag, and account for space used */
-			tic->t_flags = 0;
-			tic->t_curr_res -= sizeof(magic);
-			error = xlog_write(log, &vec, tic, &lsn,
-					   NULL, XLOG_UNMOUNT_TRANS);
-			/*
-			 * At this point, we're umounting anyway,
-			 * so there's no point in transitioning log state
-			 * to IOERROR. Just continue...
-			 */
-		}
-
-		if (error)
-			xfs_alert(mp, "%s: unmount record failed", __func__);
-
-
-		spin_lock(&log->l_icloglock);
-		iclog = log->l_iclog;
-		atomic_inc(&iclog->ic_refcnt);
-		xlog_state_want_sync(log, iclog);
-		spin_unlock(&log->l_icloglock);
-		error = xlog_state_release_iclog(log, iclog);
-
-		spin_lock(&log->l_icloglock);
-		if (!(iclog->ic_state == XLOG_STATE_ACTIVE ||
-		      iclog->ic_state == XLOG_STATE_DIRTY)) {
-			if (!XLOG_FORCED_SHUTDOWN(log)) {
-				xlog_wait(&iclog->ic_force_wait,
-							&log->l_icloglock);
-			} else {
-				spin_unlock(&log->l_icloglock);
-			}
-		} else {
-			spin_unlock(&log->l_icloglock);
-		}
-		if (tic) {
-			trace_xfs_log_umount_write(log, tic);
-			xlog_ungrant_log_space(log, tic);
-			xfs_log_ticket_put(tic);
-		}
+		xfs_log_write_unmount_record(mp);
 	} else {
 		/*
 		 * We're already in forced_shutdown mode, couldn't

