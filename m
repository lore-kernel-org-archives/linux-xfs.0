Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209C7C41603
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F24F56135B
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241571AbhESMOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:14:51 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:48765 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353394AbhESMOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:45 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 316621AFDC1
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:21 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m2C-P3
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002SIH-HP
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 38/39] xfs: xlog_sync() manually adjusts grant head space
Date:   Wed, 19 May 2021 22:13:16 +1000
Message-Id: <20210519121317.585244-39-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=vhzcWsXmtM9S7ZmMwX4A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When xlog_sync() rounds off the tail the iclog that is being
flushed, it manually subtracts that space from the grant heads. This
space is actually reserved by the transaction ticket that covers
the xlog_sync() call from xlog_write(), but we don't plumb the
ticket down far enough for it to account for the space consumed in
the current log ticket.

The grant heads are hot, so we really should be accounting this to
the ticket is we can, rather than adding thousands of extra grant
head updates every CIL commit.

Interestingly, this actually indicates a potential log space overrun
can occur when we force the log. By the time that xfs_log_force()
pushes out an active iclog and consumes the roundoff space, the
reservation for that roundoff space has been returned to the grant
heads and is no longer covered by a reservation. In theory the
roundoff added to log force on an already full log could push the
write head past the tail. In practice, the CIL commit that writes to
the log and needs the iclog pushed will have reserved space for
roundoff, so when it releases the ticket there will still be
physical space for the roundoff to be committed to the log, even
though it is no longer reserved. This roundoff won't be enough space
to allow a transaction to be woken if the log is full, so overruns
should not actually occur in practice.

That said, it indicates that we should not release the CIL context
log ticket until after we've released the commit iclog. It also
means that xlog_sync() still needs the direct grant head
manipulation if we don't provide it with a ticket. Log forces are
rare when we are in fast paths running 1.5 million transactions/s
that make the grant heads hot, so let's optimise the hot case and
pass CIL log tickets down to the xlog_sync() code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 39 +++++++++++++++++++++++++--------------
 fs/xfs/xfs_log_cil.c  | 19 ++++++++++++++-----
 fs/xfs/xfs_log_priv.h |  3 ++-
 3 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5511c5de6b78..63e2358f160a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -55,7 +55,8 @@ xlog_grant_push_ail(
 STATIC void
 xlog_sync(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog);
+	struct xlog_in_core	*iclog,
+	struct xlog_ticket	*ticket);
 #if defined(DEBUG)
 STATIC void
 xlog_verify_dest_ptr(
@@ -537,7 +538,8 @@ __xlog_state_release_iclog(
 int
 xlog_state_release_iclog(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog)
+	struct xlog_in_core	*iclog,
+	struct xlog_ticket	*ticket)
 {
 	lockdep_assert_held(&log->l_icloglock);
 
@@ -547,7 +549,7 @@ xlog_state_release_iclog(
 	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
 	    __xlog_state_release_iclog(log, iclog)) {
 		spin_unlock(&log->l_icloglock);
-		xlog_sync(log, iclog);
+		xlog_sync(log, iclog, ticket);
 		spin_lock(&log->l_icloglock);
 	}
 
@@ -908,7 +910,7 @@ xlog_unmount_write(
 	 * iclog containing the unmount record is written.
 	 */
 	iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
-	error = xlog_state_release_iclog(log, iclog);
+	error = xlog_state_release_iclog(log, iclog, tic);
 	xlog_wait_on_iclog(iclog);
 
 	if (tic) {
@@ -1939,7 +1941,8 @@ xlog_calc_iclog_size(
 STATIC void
 xlog_sync(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog)
+	struct xlog_in_core	*iclog,
+	struct xlog_ticket	*ticket)
 {
 	unsigned int		count;		/* byte count of bwrite */
 	unsigned int		roundoff;       /* roundoff to BB or stripe */
@@ -1950,12 +1953,20 @@ xlog_sync(
 
 	count = xlog_calc_iclog_size(log, iclog, &roundoff);
 
-	/* move grant heads by roundoff in sync */
-	xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
-	xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
+	/*
+	 * If we have a ticket, account for the roundoff via the ticket
+	 * reservation to avoid touching the hot grant heads needlessly.
+	 * Otherwise, we have to move grant heads directly.
+	 */
+	if (ticket) {
+		ticket->t_curr_res -= roundoff;
+	} else {
+		xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
+		xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
+	}
 
 	/* put cycle number in every block */
-	xlog_pack_data(log, iclog, roundoff); 
+	xlog_pack_data(log, iclog, roundoff);
 
 	/* real byte length */
 	size = iclog->ic_offset;
@@ -2195,7 +2206,7 @@ xlog_write_get_more_iclog_space(
 	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
 	ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
 	       iclog->ic_state == XLOG_STATE_IOERROR);
-	error = xlog_state_release_iclog(log, iclog);
+	error = xlog_state_release_iclog(log, iclog, ticket);
 	spin_unlock(&log->l_icloglock);
 	if (error)
 		return error;
@@ -2465,7 +2476,7 @@ xlog_write(
 	if (commit_iclog)
 		*commit_iclog = iclog;
 	else
-		error = xlog_state_release_iclog(log, iclog);
+		error = xlog_state_release_iclog(log, iclog, ticket);
 	spin_unlock(&log->l_icloglock);
 
 	return error;
@@ -2923,7 +2934,7 @@ xlog_state_get_iclog_space(
 		 * reference to the iclog.
 		 */
 		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
-			error = xlog_state_release_iclog(log, iclog);
+			error = xlog_state_release_iclog(log, iclog, ticket);
 		spin_unlock(&log->l_icloglock);
 		if (error)
 			return error;
@@ -3151,7 +3162,7 @@ xfs_log_force(
 			atomic_inc(&iclog->ic_refcnt);
 			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 			xlog_state_switch_iclogs(log, iclog, 0);
-			if (xlog_state_release_iclog(log, iclog))
+			if (xlog_state_release_iclog(log, iclog, NULL))
 				goto out_error;
 
 			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
@@ -3244,7 +3255,7 @@ xlog_force_lsn(
 		}
 		atomic_inc(&iclog->ic_refcnt);
 		xlog_state_switch_iclogs(log, iclog, 0);
-		if (xlog_state_release_iclog(log, iclog))
+		if (xlog_state_release_iclog(log, iclog, NULL))
 			goto out_error;
 		if (log_flushed)
 			*log_flushed = 1;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 672cbaa4606c..64e247cadb33 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -832,6 +832,7 @@ xlog_cil_push_work(
 	struct bio		bio;
 	DECLARE_COMPLETION_ONSTACK(bdev_flush);
 	bool			push_commit_stable;
+	struct xlog_ticket	*ticket;
 
 	new_ctx = xlog_cil_ctx_alloc();
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
@@ -1039,12 +1040,10 @@ xlog_cil_push_work(
 	if (error)
 		goto out_abort_free_ticket;
 
-	xfs_log_ticket_ungrant(log, ctx->ticket);
-
 	spin_lock(&commit_iclog->ic_callback_lock);
 	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
 		spin_unlock(&commit_iclog->ic_callback_lock);
-		goto out_abort;
+		goto out_abort_free_ticket;
 	}
 	ASSERT_ALWAYS(commit_iclog->ic_state == XLOG_STATE_ACTIVE ||
 		      commit_iclog->ic_state == XLOG_STATE_WANT_SYNC);
@@ -1061,6 +1060,15 @@ xlog_cil_push_work(
 	wake_up_all(&cil->xc_commit_wait);
 	spin_unlock(&cil->xc_push_lock);
 
+	/*
+	 * Pull the ticket off the ctx so we can ungrant it after releasing the
+	 * commit_iclog. The ctx may be freed by the time we return from
+	 * releasing the commit_iclog (i.e. checkpoint has been completed and
+	 * callback run) so we can't reference the ctx after the call to
+	 * xlog_state_release_iclog().
+	 */
+	ticket = ctx->ticket;
+
 	/*
 	 * If the checkpoint spans multiple iclogs, wait for all previous
 	 * iclogs to complete before we submit the commit_iclog. In this case,
@@ -1087,8 +1095,10 @@ xlog_cil_push_work(
 	commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
 	if (push_commit_stable && commit_iclog->ic_state == XLOG_STATE_ACTIVE)
 		xlog_state_switch_iclogs(log, commit_iclog, 0);
-	xlog_state_release_iclog(log, commit_iclog);
+	xlog_state_release_iclog(log, commit_iclog, ticket);
 	spin_unlock(&log->l_icloglock);
+
+	xfs_log_ticket_ungrant(log, ticket);
 	return;
 
 out_skip:
@@ -1099,7 +1109,6 @@ xlog_cil_push_work(
 
 out_abort_free_ticket:
 	xfs_log_ticket_ungrant(log, ctx->ticket);
-out_abort:
 	ASSERT(XLOG_FORCED_SHUTDOWN(log));
 	xlog_cil_committed(ctx);
 }
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 071367a96d8d..615beb6781dd 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -488,7 +488,8 @@ void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
 void xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
 		int eventual_size);
-int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog);
+int xlog_state_release_iclog(struct xlog *xlog, struct xlog_in_core *iclog,
+		struct xlog_ticket *ticket);
 
 /*
  * When we crack an atomic LSN, we sample it first so that the value will not
-- 
2.31.1

