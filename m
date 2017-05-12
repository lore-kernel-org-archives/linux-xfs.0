Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43942 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdELCKw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 22:10:52 -0400
From: Shan Hai <shan.hai@oracle.com>
Subject: [V2 PATCH 1/1] xfs: remove lsn relevant fields from xfs_trans structure and its users
Date: Fri, 12 May 2017 10:10:15 +0800
Message-Id: <1494555015-6039-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: hch@infradead.org

The t_lsn is not used anymore and the t_commit_lsn is used as a tmp
storage for the checkpoint sequence number only in the current code.

And the start/commit lsn are tracked as a transaction group tag in
the xfs_cil_ctx instead of a single transaction, so remove them from
the xfs_trans structure and their users to match with the design.

Signed-off-by: Shan Hai <shan.hai@oracle.com>
---
 fs/xfs/xfs_log_cil.c |  7 ++++---
 fs/xfs/xfs_trace.h   | 19 -------------------
 fs/xfs/xfs_trans.h   |  4 ----
 3 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 82f1cbc..10309cf 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -973,6 +973,7 @@
 {
 	struct xlog		*log = mp->m_log;
 	struct xfs_cil		*cil = log->l_cilp;
+	xfs_lsn_t		xc_commit_lsn;
 
 	/*
 	 * Do all necessary memory allocation before we lock the CIL.
@@ -990,9 +991,9 @@
 	if (tp->t_ticket->t_curr_res < 0)
 		xlog_print_tic_res(mp, tp->t_ticket);
 
-	tp->t_commit_lsn = cil->xc_ctx->sequence;
+	xc_commit_lsn = cil->xc_ctx->sequence;
 	if (commit_lsn)
-		*commit_lsn = tp->t_commit_lsn;
+		*commit_lsn = xc_commit_lsn;
 
 	xfs_log_done(mp, tp->t_ticket, NULL, regrant);
 	xfs_trans_unreserve_and_mod_sb(tp);
@@ -1008,7 +1009,7 @@
 	 * the log items. This affects (at least) processing of stale buffers,
 	 * inodes and EFIs.
 	 */
-	xfs_trans_free_items(tp, tp->t_commit_lsn, false);
+	xfs_trans_free_items(tp, xc_commit_lsn, false);
 
 	xlog_cil_push_background(log);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7c5a165..0712eb7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1490,25 +1490,6 @@
 		  __entry->tlen)
 );
 
-TRACE_EVENT(xfs_trans_commit_lsn,
-	TP_PROTO(struct xfs_trans *trans),
-	TP_ARGS(trans),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(struct xfs_trans *, tp)
-		__field(xfs_lsn_t, lsn)
-	),
-	TP_fast_assign(
-		__entry->dev = trans->t_mountp->m_super->s_dev;
-		__entry->tp = trans;
-		__entry->lsn = trans->t_commit_lsn;
-	),
-	TP_printk("dev %d:%d trans 0x%p commit_lsn 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->tp,
-		  __entry->lsn)
-);
-
 TRACE_EVENT(xfs_agf,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags,
 		 unsigned long caller_ip),
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a07acbf..80b3ed5 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -105,10 +105,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 	unsigned int		t_rtx_res;	/* # of rt extents resvd */
 	unsigned int		t_rtx_res_used;	/* # of resvd rt extents used */
 	struct xlog_ticket	*t_ticket;	/* log mgr ticket */
-	xfs_lsn_t		t_lsn;		/* log seq num of start of
-						 * transaction. */
-	xfs_lsn_t		t_commit_lsn;	/* log seq num of end of
-						 * transaction. */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
 	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
 	unsigned int		t_flags;	/* misc flags */
-- 
1.8.3.1

