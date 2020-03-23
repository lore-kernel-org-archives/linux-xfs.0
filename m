Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C954C4332B
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5630A2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 13:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jXsPXQeI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgCWNHW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:07:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33890 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgCWNHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 09:07:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SEA1jKsfYpqQ7HlgdLaZUU29QZmru2pYOMHW0D1gzUQ=; b=jXsPXQeISHB0miJb4bm25TYHvE
        AkkNXiZURcvYzFf9NkxkU5IcrB5k0gWZ/I3JfaEZg8FkUQITuCJy5V3TW7J6Yet9LYjTH54piVaHN
        yIdrivPJRyN4oabAiNztGQtEapgKTwRrF3r0y0dVKVMC+S4na8gUbKvsgZW+VVv7aJMMPcHiyEWD2
        TahM8po+sneHmNqvo7ePPBD6oX8aH4ySJgswNbGo1acV/Fy2L+p+ZzevADxTqTNF1wR0ysmadoOqz
        H2+u+nHM7RiVXXGNbodOOjERQSQVgonb7xXbbFK3t4pIgFNEFHvY88PbnTgr/dT3Ts+HQYebAAtI0
        gpUCEPbQ==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGMnZ-0005ij-7K; Mon, 23 Mar 2020 13:07:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com
Subject: [PATCH 4/9] xfs: split xlog_ticket_done
Date:   Mon, 23 Mar 2020 14:07:01 +0100
Message-Id: <20200323130706.300436-5-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323130706.300436-1-hch@lst.de>
References: <20200323130706.300436-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Split the regrant case out of xlog_ticket_done and into a new
xlog_ticket_regrant helper.  Merge both functions with the low-level
functions implementing the actual functionality and adjust the
tracepoints.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 84 ++++++++++++++-----------------------------
 fs/xfs/xfs_log_cil.c  |  9 +++--
 fs/xfs/xfs_log_priv.h |  4 +--
 fs/xfs/xfs_trace.h    | 14 ++++----
 fs/xfs/xfs_trans.c    |  9 +++--
 5 files changed, 47 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4b24fbf8b06c..c4ee4d95c658 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -66,14 +66,6 @@ xlog_grant_push_ail(
 	struct xlog		*log,
 	int			need_bytes);
 STATIC void
-xlog_regrant_reserve_log_space(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket);
-STATIC void
-xlog_ungrant_log_space(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket);
-STATIC void
 xlog_sync(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog);
@@ -502,27 +494,6 @@ xlog_write_done(
 	return xlog_commit_record(log, ticket, iclog, lsn);
 }
 
-/*
- * Release or regrant the ticket reservation now the transaction is done with
- * it depending on caller context. Rolling transactions need the ticket
- * regranted, otherwise we release it completely.
- */
-void
-xlog_ticket_done(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket,
-	bool			regrant)
-{
-	if (!regrant) {
-		trace_xfs_log_done_nonperm(log, ticket);
-		xlog_ungrant_log_space(log, ticket);
-	} else {
-		trace_xfs_log_done_perm(log, ticket);
-		xlog_regrant_reserve_log_space(log, ticket);
-	}
-	xfs_log_ticket_put(ticket);
-}
-
 static bool
 __xlog_state_release_iclog(
 	struct xlog		*log,
@@ -921,8 +892,7 @@ xfs_log_write_unmount_record(
 
 	if (tic) {
 		trace_xfs_log_umount_write(log, tic);
-		xlog_ungrant_log_space(log, tic);
-		xfs_log_ticket_put(tic);
+		xlog_ticket_done(log, tic);
 	}
 }
 
@@ -2987,19 +2957,18 @@ xlog_state_get_iclog_space(
 	return 0;
 }	/* xlog_state_get_iclog_space */
 
-/* The first cnt-1 times through here we don't need to
- * move the grant write head because the permanent
- * reservation has reserved cnt times the unit amount.
- * Release part of current permanent unit reservation and
- * reset current reservation to be one units worth.  Also
- * move grant reservation head forward.
+/*
+ * The first cnt-1 times through here we don't need to move the grant write head
+ * because the permanent reservation has reserved cnt times the unit amount.
+ * Release part of current permanent unit reservation and reset current
+ * reservation to be one units worth.  Also move grant reservation head forward.
  */
-STATIC void
-xlog_regrant_reserve_log_space(
+void
+xlog_ticket_regrant(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket)
 {
-	trace_xfs_log_regrant_reserve_enter(log, ticket);
+	trace_xfs_log_ticket_regrant(log, ticket);
 
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
@@ -3011,21 +2980,20 @@ xlog_regrant_reserve_log_space(
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
 
-	trace_xfs_log_regrant_reserve_sub(log, ticket);
+	trace_xfs_log_ticket_regrant_sub(log, ticket);
 
 	/* just return if we still have some of the pre-reserved space */
-	if (ticket->t_cnt > 0)
-		return;
+	if (!ticket->t_cnt) {
+		xlog_grant_add_space(log, &log->l_reserve_head.grant,
+				     ticket->t_unit_res);
+		trace_xfs_log_ticket_regrant_exit(log, ticket);
 
-	xlog_grant_add_space(log, &log->l_reserve_head.grant,
-					ticket->t_unit_res);
-
-	trace_xfs_log_regrant_reserve_exit(log, ticket);
-
-	ticket->t_curr_res = ticket->t_unit_res;
-	xlog_tic_reset_res(ticket);
-}	/* xlog_regrant_reserve_log_space */
+		ticket->t_curr_res = ticket->t_unit_res;
+		xlog_tic_reset_res(ticket);
+	}
 
+	xfs_log_ticket_put(ticket);
+}
 
 /*
  * Give back the space left from a reservation.
@@ -3041,18 +3009,19 @@ xlog_regrant_reserve_log_space(
  * space, the count will stay at zero and the only space remaining will be
  * in the current reservation field.
  */
-STATIC void
-xlog_ungrant_log_space(
+void
+xlog_ticket_done(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket)
 {
-	int	bytes;
+	int			bytes;
+
+	trace_xfs_log_ticket_done(log, ticket);
 
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	trace_xfs_log_ungrant_enter(log, ticket);
-	trace_xfs_log_ungrant_sub(log, ticket);
+	trace_xfs_log_ticket_done_sub(log, ticket);
 
 	/*
 	 * If this is a permanent reservation ticket, we may be able to free
@@ -3067,9 +3036,10 @@ xlog_ungrant_log_space(
 	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
 	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
 
-	trace_xfs_log_ungrant_exit(log, ticket);
+	trace_xfs_log_ticket_done_exit(log, ticket);
 
 	xfs_log_space_wake(log->l_mp);
+	xfs_log_ticket_put(ticket);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 880de1aa4288..27de462d2ba4 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -843,7 +843,7 @@ xlog_cil_push_work(
 	if (error)
 		goto out_abort_free_ticket;
 
-	xlog_ticket_done(log, tic, false);
+	xlog_ticket_done(log, tic);
 
 	spin_lock(&commit_iclog->ic_callback_lock);
 	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
@@ -876,7 +876,7 @@ xlog_cil_push_work(
 	return;
 
 out_abort_free_ticket:
-	xlog_ticket_done(log, tic, false);
+	xlog_ticket_done(log, tic);
 out_abort:
 	ASSERT(XLOG_FORCED_SHUTDOWN(log));
 	xlog_cil_committed(ctx);
@@ -1008,7 +1008,10 @@ xfs_log_commit_cil(
 	if (commit_lsn)
 		*commit_lsn = xc_commit_lsn;
 
-	xlog_ticket_done(log, tp->t_ticket, regrant);
+	if (regrant)
+		xlog_ticket_regrant(log, tp->t_ticket);
+	else
+		xlog_ticket_done(log, tp->t_ticket);
 	tp->t_ticket = NULL;
 	xfs_trans_unreserve_and_mod_sb(tp);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 32bb6856e69d..d4f53664ae12 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -445,8 +445,8 @@ int xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
 			struct xlog_in_core **commit_iclog, uint flags);
 int xlog_write_done(struct xlog *log, struct xlog_ticket *ticket,
 			struct xlog_in_core **iclog, xfs_lsn_t *lsn);
-void xlog_ticket_done(struct xlog *log, struct xlog_ticket *ticket,
-			bool regrant);
+void xlog_ticket_done(struct xlog *log, struct xlog_ticket *ticket);
+void xlog_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
 /*
  * When we crack an atomic LSN, we sample it first so that the value will not
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index efc7751550d9..fbfdd9cf160d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1001,8 +1001,6 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 DEFINE_EVENT(xfs_loggrant_class, name, \
 	TP_PROTO(struct xlog *log, struct xlog_ticket *tic), \
 	TP_ARGS(log, tic))
-DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm);
-DEFINE_LOGGRANT_EVENT(xfs_log_done_perm);
 DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake);
@@ -1011,12 +1009,12 @@ DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
 DEFINE_LOGGRANT_EVENT(xfs_log_reserve_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant_exit);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done_exit);
 
 DECLARE_EVENT_CLASS(xfs_log_item_class,
 	TP_PROTO(struct xfs_log_item *lip),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 123ecc8435f6..6542b541c47c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -231,7 +231,7 @@ xfs_trans_reserve(
 	 */
 undo_log:
 	if (resp->tr_logres > 0) {
-		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
+		xlog_ticket_done(mp->m_log, tp->t_ticket);
 		tp->t_ticket = NULL;
 		tp->t_log_res = 0;
 		tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
@@ -1001,7 +1001,10 @@ __xfs_trans_commit(
 	 */
 	xfs_trans_unreserve_and_mod_dquots(tp);
 	if (tp->t_ticket) {
-		xlog_ticket_done(mp->m_log, tp->t_ticket, regrant);
+		if (regrant)
+			xlog_ticket_regrant(mp->m_log, tp->t_ticket);
+		else
+			xlog_ticket_done(mp->m_log, tp->t_ticket);
 		tp->t_ticket = NULL;
 	}
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
@@ -1060,7 +1063,7 @@ xfs_trans_cancel(
 	xfs_trans_unreserve_and_mod_dquots(tp);
 
 	if (tp->t_ticket) {
-		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
+		xlog_ticket_done(mp->m_log, tp->t_ticket);
 		tp->t_ticket = NULL;
 	}
 
-- 
2.25.1

