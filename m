Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44046 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727343AbfEQHcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:13 -0400
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXLh-0000ir-2q
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:13 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/20] xfs: stop using XFS_LI_ABORTED as a parameter flag
Date: Fri, 17 May 2019 09:31:01 +0200
Message-Id: <20190517073119.30178-3-hch@lst.de>
In-Reply-To: <20190517073119.30178-1-hch@lst.de>
References: <20190517073119.30178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Just pass a straight bool aborted instead of abusing XFS_LI_ABORTED as a
flag in function parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c     | 25 +++++++++++--------------
 fs/xfs/xfs_log.h     |  2 +-
 fs/xfs/xfs_log_cil.c |  4 ++--
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 457ced3ee3e1..1eb0938165fc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -54,12 +54,9 @@ xlog_dealloc_log(
 	struct xlog		*log);
 
 /* local state machine functions */
-STATIC void xlog_state_done_syncing(xlog_in_core_t *iclog, int);
-STATIC void
-xlog_state_do_callback(
-	struct xlog		*log,
-	int			aborted,
-	struct xlog_in_core	*iclog);
+STATIC void xlog_state_done_syncing(
+	struct xlog_in_core	*iclog,
+	bool			aborted);
 STATIC int
 xlog_state_get_iclog_space(
 	struct xlog		*log,
@@ -1255,7 +1252,7 @@ xlog_iodone(xfs_buf_t *bp)
 {
 	struct xlog_in_core	*iclog = bp->b_log_item;
 	struct xlog		*l = iclog->ic_log;
-	int			aborted = 0;
+	bool			aborted = false;
 
 	/*
 	 * Race to shutdown the filesystem if we see an error or the iclog is in
@@ -1275,9 +1272,9 @@ xlog_iodone(xfs_buf_t *bp)
 		 * callback routines to let them know that the log-commit
 		 * didn't succeed.
 		 */
-		aborted = XFS_LI_ABORTED;
+		aborted = true;
 	} else if (iclog->ic_state & XLOG_STATE_IOERROR) {
-		aborted = XFS_LI_ABORTED;
+		aborted = true;
 	}
 
 	/* log I/O is always issued ASYNC */
@@ -2697,7 +2694,7 @@ xlog_get_lowest_lsn(
 STATIC void
 xlog_state_do_callback(
 	struct xlog		*log,
-	int			aborted,
+	bool			aborted,
 	struct xlog_in_core	*ciclog)
 {
 	xlog_in_core_t	   *iclog;
@@ -2936,10 +2933,10 @@ xlog_state_do_callback(
  */
 STATIC void
 xlog_state_done_syncing(
-	xlog_in_core_t	*iclog,
-	int		aborted)
+	struct xlog_in_core	*iclog,
+	bool			aborted)
 {
-	struct xlog	   *log = iclog->ic_log;
+	struct xlog		*log = iclog->ic_log;
 
 	spin_lock(&log->l_icloglock);
 
@@ -4026,7 +4023,7 @@ xfs_log_force_umount(
 	 * avoid races.
 	 */
 	wake_up_all(&log->l_cilp->xc_commit_wait);
-	xlog_state_do_callback(log, XFS_LI_ABORTED, NULL);
+	xlog_state_do_callback(log, true, NULL);
 
 #ifdef XFSERRORDEBUG
 	{
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 73a64bf32f6f..4450a2a26a1a 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -77,7 +77,7 @@ xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
  */
 typedef struct xfs_log_callback {
 	struct xfs_log_callback	*cb_next;
-	void			(*cb_func)(void *, int);
+	void			(*cb_func)(void *, bool);
 	void			*cb_arg;
 } xfs_log_callback_t;
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 5e595948bc5a..1b54002d3874 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -577,7 +577,7 @@ xlog_discard_busy_extents(
 static void
 xlog_cil_committed(
 	void	*args,
-	int	abort)
+	bool	abort)
 {
 	struct xfs_cil_ctx	*ctx = args;
 	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
@@ -864,7 +864,7 @@ xlog_cil_push(
 out_abort_free_ticket:
 	xfs_log_ticket_put(tic);
 out_abort:
-	xlog_cil_committed(ctx, XFS_LI_ABORTED);
+	xlog_cil_committed(ctx, true);
 	return -EIO;
 }
 
-- 
2.20.1
