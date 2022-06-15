Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B157C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 07:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244257AbiFOHxm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245688AbiFOHxi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 03:53:38 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11FD94133A
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 00:53:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2C6A010E74F8
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 17:53:33 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-006rRe-UF
        for linux-xfs@vger.kernel.org; Wed, 15 Jun 2022 17:53:32 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-00FJyU-Sw
        for linux-xfs@vger.kernel.org;
        Wed, 15 Jun 2022 17:53:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/14] xfs: xlog_sync() manually adjusts grant head space
Date:   Wed, 15 Jun 2022 17:53:29 +1000
Message-Id: <20220615075330.3651541-14-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615075330.3651541-1-david@fromorbit.com>
References: <20220615075330.3651541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62a98ffe
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
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
 fs/xfs/xfs_log.c      | 35 +++++++++++++++++++++++------------
 fs/xfs/xfs_log_cil.c  | 20 ++++++++++++++++----
 fs/xfs/xfs_log_priv.h |  3 ++-
 3 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bc4a5f2f04e8..81940a99f8aa 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -57,7 +57,8 @@ xlog_grant_push_ail(
 STATIC void
 xlog_sync(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog);
+	struct xlog_in_core	*iclog,
+	struct xlog_ticket	*ticket);
 #if defined(DEBUG)
 STATIC void
 xlog_verify_grant_tail(
@@ -567,7 +568,8 @@ xlog_state_shutdown_callbacks(
 int
 xlog_state_release_iclog(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog)
+	struct xlog_in_core	*iclog,
+	struct xlog_ticket	*ticket)
 {
 	xfs_lsn_t		tail_lsn;
 	bool			last_ref;
@@ -614,7 +616,7 @@ xlog_state_release_iclog(
 	trace_xlog_iclog_syncing(iclog, _RET_IP_);
 
 	spin_unlock(&log->l_icloglock);
-	xlog_sync(log, iclog);
+	xlog_sync(log, iclog, ticket);
 	spin_lock(&log->l_icloglock);
 	return 0;
 }
@@ -881,7 +883,7 @@ xlog_force_iclog(
 	iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
 	if (iclog->ic_state == XLOG_STATE_ACTIVE)
 		xlog_state_switch_iclogs(iclog->ic_log, iclog, 0);
-	return xlog_state_release_iclog(iclog->ic_log, iclog);
+	return xlog_state_release_iclog(iclog->ic_log, iclog, NULL);
 }
 
 /*
@@ -2027,7 +2029,8 @@ xlog_calc_iclog_size(
 STATIC void
 xlog_sync(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog)
+	struct xlog_in_core	*iclog,
+	struct xlog_ticket	*ticket)
 {
 	unsigned int		count;		/* byte count of bwrite */
 	unsigned int		roundoff;       /* roundoff to BB or stripe */
@@ -2039,12 +2042,20 @@ xlog_sync(
 
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
@@ -2272,7 +2283,7 @@ xlog_write_get_more_iclog_space(
 	spin_lock(&log->l_icloglock);
 	ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);
 	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
-	error = xlog_state_release_iclog(log, iclog);
+	error = xlog_state_release_iclog(log, iclog, ticket);
 	spin_unlock(&log->l_icloglock);
 	if (error)
 		return error;
@@ -2534,7 +2545,7 @@ xlog_write(
 	 */
 	spin_lock(&log->l_icloglock);
 	xlog_state_finish_copy(log, iclog, record_cnt, 0);
-	error = xlog_state_release_iclog(log, iclog);
+	error = xlog_state_release_iclog(log, iclog, ticket);
 	spin_unlock(&log->l_icloglock);
 
 	return error;
@@ -2954,7 +2965,7 @@ xlog_state_get_iclog_space(
 		 * reference to the iclog.
 		 */
 		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
-			error = xlog_state_release_iclog(log, iclog);
+			error = xlog_state_release_iclog(log, iclog, ticket);
 		spin_unlock(&log->l_icloglock);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 78f8537860df..eccbfb99e894 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1189,6 +1189,7 @@ xlog_cil_push_work(
 	xfs_csn_t		push_seq;
 	bool			push_commit_stable;
 	LIST_HEAD		(whiteouts);
+	struct xlog_ticket	*ticket;
 
 	new_ctx = xlog_cil_ctx_alloc();
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
@@ -1323,7 +1324,14 @@ xlog_cil_push_work(
 	if (error)
 		goto out_abort_free_ticket;
 
-	xfs_log_ticket_ungrant(log, ctx->ticket);
+	/*
+	 * Grab the ticket from the ctx so we can ungrant it after releasing the
+	 * commit_iclog. The ctx may be freed by the time we return from
+	 * releasing the commit_iclog (i.e. checkpoint has been completed and
+	 * callback run) so we can't reference the ctx after the call to
+	 * xlog_state_release_iclog().
+	 */
+	ticket = ctx->ticket;
 
 	/*
 	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
@@ -1373,12 +1381,14 @@ xlog_cil_push_work(
 	if (push_commit_stable &&
 	    ctx->commit_iclog->ic_state == XLOG_STATE_ACTIVE)
 		xlog_state_switch_iclogs(log, ctx->commit_iclog, 0);
-	xlog_state_release_iclog(log, ctx->commit_iclog);
+	ticket = ctx->ticket;
+	xlog_state_release_iclog(log, ctx->commit_iclog, ticket);
 
 	/* Not safe to reference ctx now! */
 
 	spin_unlock(&log->l_icloglock);
 	xlog_cil_cleanup_whiteouts(&whiteouts);
+	xfs_log_ticket_ungrant(log, ticket);
 	return;
 
 out_skip:
@@ -1388,17 +1398,19 @@ xlog_cil_push_work(
 	return;
 
 out_abort_free_ticket:
-	xfs_log_ticket_ungrant(log, ctx->ticket);
 	ASSERT(xlog_is_shutdown(log));
 	xlog_cil_cleanup_whiteouts(&whiteouts);
 	if (!ctx->commit_iclog) {
+		xfs_log_ticket_ungrant(log, ctx->ticket);
 		xlog_cil_committed(ctx);
 		return;
 	}
 	spin_lock(&log->l_icloglock);
-	xlog_state_release_iclog(log, ctx->commit_iclog);
+	ticket = ctx->ticket;
+	xlog_state_release_iclog(log, ctx->commit_iclog, ticket);
 	/* Not safe to reference ctx now! */
 	spin_unlock(&log->l_icloglock);
+	xfs_log_ticket_ungrant(log, ticket);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index d4270a2d4ffb..1bd2963e8fbd 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -515,7 +515,8 @@ void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
 void xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
 		int eventual_size);
-int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog);
+int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog,
+		struct xlog_ticket *ticket);
 
 /*
  * When we crack an atomic LSN, we sample it first so that the value will not
-- 
2.35.1

