Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE2677F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 17:52:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C995AC004
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 15:52:40 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id FJxtoGKhLTJonmr4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Jul 2013 15:52:39 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 15 Jul 2013 18:52:38 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 68C3B6E803A
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 18:52:31 -0400 (EDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6FMqZgs092558 for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 18:52:36 -0400
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6FMtBQN004626
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 16:55:11 -0600
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r6FMtBqc004613 for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 16:55:11 -0600
Subject: [PATCH] xfs: Fix a deadlock in xfs_log_commit_cil() code path
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 15 Jul 2013 17:52:34 -0500
Message-ID: <1373928754.20769.41.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

While testing and rearranging my pquota/gquota code, I stumbled
on a xfs_shutdown() during a mount. But the mount just hung.

I debugged and found that there is a deadlock involving
&log->l_cilp->xc_ctx_lock.

It is in a code path where &log->l_cilp->xc_ctx_lock is first
acquired in read mode and some levels down the same semaphore
is being acquired in write mode causing a deadlock.

This is the stack:
xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
  xlog_print_tic_res
    xfs_force_shutdown
      xfs_log_force_umount
        xlog_cil_force
          xlog_cil_force_lsn
            xlog_cil_push_foreground
              xlog_cil_push - tries to acquire same semaphore in write mode

This patch fixes the deadlock by not calling xfs_force_shutdown() while
holding the semaphore, instead calling it after dropping teh semaphore.

Thanks to Dave for suggesting this solution.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
 fs/xfs/xfs_log.c      |    6 +++---
 fs/xfs/xfs_log_cil.c  |   10 ++++++----
 fs/xfs/xfs_log_priv.h |    2 +-
 fs/xfs/xfs_trans.c    |    2 +-
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d852a2b..b9fa2da 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1837,7 +1837,7 @@ xlog_state_finish_copy(
  * print out info relating to regions written which consume
  * the reservation
  */
-void
+int
 xlog_print_tic_res(
 	struct xfs_mount	*mp,
 	struct xlog_ticket	*ticket)
@@ -1941,7 +1941,7 @@ xlog_print_tic_res(
 
 	xfs_alert_tag(mp, XFS_PTAG_LOGRES,
 		"xlog_write: reservation ran out. Need to up reservation");
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return EFSCORRUPTED;
 }
 
 /*
@@ -2215,7 +2215,7 @@ xlog_write(
 		ticket->t_curr_res -= sizeof(xlog_op_header_t);
 
 	if (ticket->t_curr_res < 0)
-		xlog_print_tic_res(log->l_mp, ticket);
+		return xlog_print_tic_res(log->l_mp, ticket);
 
 	index = 0;
 	lv = log_vector;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 02b9cf3..93ba7bd 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -730,10 +730,6 @@ xfs_log_commit_cil(
 	/* xlog_cil_insert_items() destroys log_vector list */
 	xlog_cil_insert_items(log, log_vector, tp->t_ticket);
 
-	/* check we didn't blow the reservation */
-	if (tp->t_ticket->t_curr_res < 0)
-		xlog_print_tic_res(log->l_mp, tp->t_ticket);
-
 	/* attach the transaction to the CIL if it has any busy extents */
 	if (!list_empty(&tp->t_busy)) {
 		spin_lock(&log->l_cilp->xc_cil_lock);
@@ -742,6 +738,12 @@ xfs_log_commit_cil(
 		spin_unlock(&log->l_cilp->xc_cil_lock);
 	}
 
+	/* check we didn't blow the reservation */
+	if (tp->t_ticket->t_curr_res < 0) {
+		up_read(&log->l_cilp->xc_ctx_lock);
+		return xlog_print_tic_res(log->l_mp, tp->t_ticket);
+	}
+
 	tp->t_commit_lsn = *commit_lsn;
 	xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
 	xfs_trans_unreserve_and_mod_sb(tp);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b9ea262..4f2fa6d 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -576,7 +576,7 @@ xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
 	*off += bytes;
 }
 
-void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
+int	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 int
 xlog_write(
 	struct xlog		*log,
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 35a2299..d96022f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1547,7 +1547,7 @@ xfs_trans_commit(
 	xfs_trans_apply_dquot_deltas(tp);
 
 	error = xfs_log_commit_cil(mp, tp, &commit_lsn, flags);
-	if (error == ENOMEM) {
+	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 		error = XFS_ERROR(EIO);
 		goto out_unreserve;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
