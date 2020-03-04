Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B0EC3F2D7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0144B20866
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgCDHyG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:54:06 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33749 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgCDHyG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 02:54:06 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 134FD3A27B1
        for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2020 18:54:03 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0007lU-Sj
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0005cY-Q6
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/11] xfs: refactor and split xfs_log_done()
Date:   Wed,  4 Mar 2020 18:53:53 +1100
Message-Id: <20200304075401.21558-4-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200304075401.21558-1-david@fromorbit.com>
References: <20200304075401.21558-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=VfLmM3KQg9FqGSJa3SoA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_log_done() does two separate things. Firstly, it triggers commit
records to be written for permanent transactions, and secondly it
releases or regrants transaction reservation space.

Since delayed logging was introduced, transactions no longer write
directly to the log, hence they never have the XLOG_TIC_INITED flag
cleared on them. Hence transactions never write commit records to
the log and only need to modify reservation space.

Split up xfs_log_done into two parts, and only call the parts of the
operation needed for the context xfs_log_done() is currently being
called from.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 64 ++++++++++++++-----------------------------
 fs/xfs/xfs_log.h      |  4 ---
 fs/xfs/xfs_log_cil.c  | 13 +++++----
 fs/xfs/xfs_log_priv.h | 16 +++++------
 fs/xfs/xfs_trans.c    | 24 ++++++++--------
 5 files changed, 47 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d6c42954b70c..702b38e4db6e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -493,62 +493,40 @@ xfs_log_reserve(
  */
 
 /*
- * This routine is called when a user of a log manager ticket is done with
- * the reservation.  If the ticket was ever used, then a commit record for
- * the associated transaction is written out as a log operation header with
- * no data.  The flag XLOG_TIC_INITED is set when the first write occurs with
- * a given ticket.  If the ticket was one with a permanent reservation, then
- * a few operations are done differently.  Permanent reservation tickets by
- * default don't release the reservation.  They just commit the current
- * transaction with the belief that the reservation is still needed.  A flag
- * must be passed in before permanent reservations are actually released.
- * When these type of tickets are not released, they need to be set into
- * the inited state again.  By doing this, a start record will be written
- * out when the next write occurs.
+ * Write a commit record to the log to close off a running log write.
  */
-xfs_lsn_t
-xfs_log_done(
-	struct xfs_mount	*mp,
+int
+xlog_write_done(
+	struct xlog		*log,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclog,
-	bool			regrant)
+	xfs_lsn_t		*lsn)
 {
-	struct xlog		*log = mp->m_log;
-	xfs_lsn_t		lsn = 0;
-
-	if (XLOG_FORCED_SHUTDOWN(log) ||
-	    /*
-	     * If nothing was ever written, don't write out commit record.
-	     * If we get an error, just continue and give back the log ticket.
-	     */
-	    (((ticket->t_flags & XLOG_TIC_INITED) == 0) &&
-	     (xlog_commit_record(log, ticket, iclog, &lsn)))) {
-		lsn = (xfs_lsn_t) -1;
-		regrant = false;
-	}
+	if (XLOG_FORCED_SHUTDOWN(log))
+		return -EIO;
 
+	return xlog_commit_record(log, ticket, iclog, lsn);
+}
 
+/*
+ * Release or regrant the ticket reservation now the transaction is done with
+ * it depending on caller context. Rolling transactions need the ticket
+ * regranted, otherwise we release it completely.
+ */
+void
+xlog_ticket_done(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket,
+	bool			regrant)
+{
 	if (!regrant) {
 		trace_xfs_log_done_nonperm(log, ticket);
-
-		/*
-		 * Release ticket if not permanent reservation or a specific
-		 * request has been made to release a permanent reservation.
-		 */
 		xlog_ungrant_log_space(log, ticket);
 	} else {
 		trace_xfs_log_done_perm(log, ticket);
-
 		xlog_regrant_reserve_log_space(log, ticket);
-		/* If this ticket was a permanent reservation and we aren't
-		 * trying to release it, reset the inited flags; so next time
-		 * we write, a start record will be written out.
-		 */
-		ticket->t_flags |= XLOG_TIC_INITED;
 	}
-
 	xfs_log_ticket_put(ticket);
-	return lsn;
 }
 
 static bool
@@ -2400,8 +2378,6 @@ xlog_write(
 	 * to account for an extra xlog_op_header here.
 	 */
 	ticket->t_curr_res -= sizeof(xlog_op_header_t);
-	if (ticket->t_flags & XLOG_TIC_INITED)
-		ticket->t_flags &= ~XLOG_TIC_INITED;
 	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
 		start_rec_size = 0;
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 84e06805160f..85f8d0966811 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -105,10 +105,6 @@ struct xfs_log_item;
 struct xfs_item_ops;
 struct xfs_trans;
 
-xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
-		       struct xlog_ticket *ticket,
-		       struct xlog_in_core **iclog,
-		       bool regrant);
 int	  xfs_log_force(struct xfs_mount *mp, uint flags);
 int	  xfs_log_force_lsn(struct xfs_mount *mp, xfs_lsn_t lsn, uint flags,
 		int *log_forced);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 48435cf2aa16..255065d276fc 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -841,10 +841,11 @@ xlog_cil_push(
 	}
 	spin_unlock(&cil->xc_push_lock);
 
-	/* xfs_log_done always frees the ticket on error. */
-	commit_lsn = xfs_log_done(log->l_mp, tic, &commit_iclog, false);
-	if (commit_lsn == -1)
-		goto out_abort;
+	error = xlog_write_done(log, tic, &commit_iclog, &commit_lsn);
+	if (error)
+		goto out_abort_free_ticket;
+
+	xlog_ticket_done(log, tic, false);
 
 	spin_lock(&commit_iclog->ic_callback_lock);
 	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
@@ -876,7 +877,7 @@ xlog_cil_push(
 	return 0;
 
 out_abort_free_ticket:
-	xfs_log_ticket_put(tic);
+	xlog_ticket_done(log, tic, false);
 out_abort:
 	xlog_cil_committed(ctx, true);
 	return -EIO;
@@ -1017,7 +1018,7 @@ xfs_log_commit_cil(
 	if (commit_lsn)
 		*commit_lsn = xc_commit_lsn;
 
-	xfs_log_done(mp, tp->t_ticket, NULL, regrant);
+	xlog_ticket_done(log, tp->t_ticket, regrant);
 	tp->t_ticket = NULL;
 	xfs_trans_unreserve_and_mod_sb(tp);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b192c5a9f9fd..081d4c6de2c8 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -438,14 +438,14 @@ xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
 
 void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
-int
-xlog_write(
-	struct xlog		*log,
-	struct xfs_log_vec	*log_vector,
-	struct xlog_ticket	*tic,
-	xfs_lsn_t		*start_lsn,
-	struct xlog_in_core	**commit_iclog,
-	uint			flags);
+
+int xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
+			struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
+			struct xlog_in_core **commit_iclog, uint flags);
+int xlog_write_done(struct xlog *log, struct xlog_ticket *ticket,
+			struct xlog_in_core **iclog, xfs_lsn_t *lsn);
+void xlog_ticket_done(struct xlog *log, struct xlog_ticket *ticket,
+			bool regrant);
 
 /*
  * When we crack an atomic LSN, we sample it first so that the value will not
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3b208f9a865c..85ea3727878b 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -9,6 +9,7 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
+#include "xfs_log_priv.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_extent_busy.h"
@@ -150,8 +151,9 @@ xfs_trans_reserve(
 	uint			blocks,
 	uint			rtextents)
 {
-	int		error = 0;
-	bool		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error = 0;
+	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
 	/* Mark this thread as being in a transaction */
 	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
@@ -162,7 +164,7 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (blocks > 0) {
-		error = xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), rsvd);
+		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 			return -ENOSPC;
@@ -191,9 +193,9 @@ xfs_trans_reserve(
 
 		if (tp->t_ticket != NULL) {
 			ASSERT(resp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
-			error = xfs_log_regrant(tp->t_mountp, tp->t_ticket);
+			error = xfs_log_regrant(mp, tp->t_ticket);
 		} else {
-			error = xfs_log_reserve(tp->t_mountp,
+			error = xfs_log_reserve(mp,
 						resp->tr_logres,
 						resp->tr_logcount,
 						&tp->t_ticket, XFS_TRANSACTION,
@@ -213,7 +215,7 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (rtextents > 0) {
-		error = xfs_mod_frextents(tp->t_mountp, -((int64_t)rtextents));
+		error = xfs_mod_frextents(mp, -((int64_t)rtextents));
 		if (error) {
 			error = -ENOSPC;
 			goto undo_log;
@@ -229,7 +231,7 @@ xfs_trans_reserve(
 	 */
 undo_log:
 	if (resp->tr_logres > 0) {
-		xfs_log_done(tp->t_mountp, tp->t_ticket, NULL, false);
+		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
 		tp->t_ticket = NULL;
 		tp->t_log_res = 0;
 		tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
@@ -237,7 +239,7 @@ xfs_trans_reserve(
 
 undo_blocks:
 	if (blocks > 0) {
-		xfs_mod_fdblocks(tp->t_mountp, (int64_t)blocks, rsvd);
+		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
 
@@ -999,9 +1001,7 @@ __xfs_trans_commit(
 	 */
 	xfs_trans_unreserve_and_mod_dquots(tp);
 	if (tp->t_ticket) {
-		commit_lsn = xfs_log_done(mp, tp->t_ticket, NULL, regrant);
-		if (commit_lsn == -1 && !error)
-			error = -EIO;
+		xlog_ticket_done(mp->m_log, tp->t_ticket, regrant);
 		tp->t_ticket = NULL;
 	}
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
@@ -1060,7 +1060,7 @@ xfs_trans_cancel(
 	xfs_trans_unreserve_and_mod_dquots(tp);
 
 	if (tp->t_ticket) {
-		xfs_log_done(mp, tp->t_ticket, NULL, false);
+		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
 		tp->t_ticket = NULL;
 	}
 
-- 
2.24.0.rc0

