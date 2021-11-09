Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615E7C43217
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 371A261159
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbhKIBzf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:55:35 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58536 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241551AbhKIBzd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:55:33 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id EB43B46CA5B
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:52:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006ZaT-BJ
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:52:44 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006UjE-A3
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:52:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/14] xfs: xlog_sync() manually adjusts grant head space
Date:   Tue,  9 Nov 2021 12:52:39 +1100
Message-Id: <20211109015240.1547991-14-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015240.1547991-1-david@fromorbit.com>
References: <20211109015240.1547991-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6189d46d
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
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
 fs/xfs/xfs_log.c      | 33 ++++++++++++++++++++++-----------
 fs/xfs/xfs_log_cil.c  | 23 ++++++++++++++++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 3 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2fa8b0009d63..ccdc8f9a36d8 100644
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
@@ -571,6 +572,7 @@ int
 xlog_state_release_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
+	struct xlog_ticket	*ticket,
 	xfs_lsn_t		old_tail_lsn)
 {
 	xfs_lsn_t		tail_lsn;
@@ -627,7 +629,7 @@ xlog_state_release_iclog(
 	trace_xlog_iclog_syncing(iclog, _RET_IP_);
 
 	spin_unlock(&log->l_icloglock);
-	xlog_sync(log, iclog);
+	xlog_sync(log, iclog, ticket);
 	spin_lock(&log->l_icloglock);
 	return 0;
 }
@@ -895,7 +897,7 @@ xlog_force_iclog(
 	iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
 	if (iclog->ic_state == XLOG_STATE_ACTIVE)
 		xlog_state_switch_iclogs(iclog->ic_log, iclog, 0);
-	return xlog_state_release_iclog(iclog->ic_log, iclog, 0);
+	return xlog_state_release_iclog(iclog->ic_log, iclog, NULL, 0);
 }
 
 /*
@@ -2041,7 +2043,8 @@ xlog_calc_iclog_size(
 STATIC void
 xlog_sync(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog)
+	struct xlog_in_core	*iclog,
+	struct xlog_ticket	*ticket)
 {
 	unsigned int		count;		/* byte count of bwrite */
 	unsigned int		roundoff;       /* roundoff to BB or stripe */
@@ -2053,12 +2056,20 @@ xlog_sync(
 
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
@@ -2288,7 +2299,7 @@ xlog_write_get_more_iclog_space(
 	spin_lock(&log->l_icloglock);
 	ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);
 	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
-	error = xlog_state_release_iclog(log, iclog, 0);
+	error = xlog_state_release_iclog(log, iclog, ticket, 0);
 	spin_unlock(&log->l_icloglock);
 	if (error)
 		return error;
@@ -2550,7 +2561,7 @@ xlog_write(
 	 */
 	spin_lock(&log->l_icloglock);
 	xlog_state_finish_copy(log, iclog, record_cnt, 0);
-	error = xlog_state_release_iclog(log, iclog, 0);
+	error = xlog_state_release_iclog(log, iclog, ticket, 0);
 	spin_unlock(&log->l_icloglock);
 
 	return error;
@@ -2970,7 +2981,7 @@ xlog_state_get_iclog_space(
 		 * reference to the iclog.
 		 */
 		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
-			error = xlog_state_release_iclog(log, iclog, 0);
+			error = xlog_state_release_iclog(log, iclog, ticket, 0);
 		spin_unlock(&log->l_icloglock);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 3355da50d5c0..9488db6c6b21 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1029,6 +1029,7 @@ xlog_cil_push_work(
 	struct bio		bio;
 	DECLARE_COMPLETION_ONSTACK(bdev_flush);
 	bool			push_commit_stable;
+	struct xlog_ticket	*ticket;
 
 	new_ctx = xlog_cil_ctx_alloc();
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
@@ -1188,6 +1189,15 @@ xlog_cil_push_work(
 	 */
 	wait_for_completion(&bdev_flush);
 
+	/*
+	 * Grab the ticket from the ctx so we can ungrant it after releasing the
+	 * commit_iclog. The ctx may be freed by the time we return from
+	 * releasing the commit_iclog (i.e. checkpoint has been completed and
+	 * callback run) so we can't reference the ctx after the call to
+	 * xlog_state_release_iclog().
+	 */
+	ticket = ctx->ticket;
+
 	/*
 	 * Take the lvhdr back off the lv_chain immediately after calling
 	 * xlog_cil_write_chain() as it should not be passed to log IO
@@ -1202,8 +1212,6 @@ xlog_cil_push_work(
 	if (error)
 		goto out_abort_free_ticket;
 
-	xfs_log_ticket_ungrant(log, ctx->ticket);
-
 	/*
 	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
 	 * to complete before we submit the commit_iclog. We can't use state
@@ -1252,11 +1260,14 @@ xlog_cil_push_work(
 	if (push_commit_stable &&
 	    ctx->commit_iclog->ic_state == XLOG_STATE_ACTIVE)
 		xlog_state_switch_iclogs(log, ctx->commit_iclog, 0);
-	xlog_state_release_iclog(log, ctx->commit_iclog, preflush_tail_lsn);
+	ticket = ctx->ticket;
+	xlog_state_release_iclog(log, ctx->commit_iclog, ticket,
+			preflush_tail_lsn);
 
 	/* Not safe to reference ctx now! */
 
 	spin_unlock(&log->l_icloglock);
+	xfs_log_ticket_ungrant(log, ticket);
 	return;
 
 out_skip:
@@ -1266,16 +1277,18 @@ xlog_cil_push_work(
 	return;
 
 out_abort_free_ticket:
-	xfs_log_ticket_ungrant(log, ctx->ticket);
 	ASSERT(xlog_is_shutdown(log));
 	if (!ctx->commit_iclog) {
+		xfs_log_ticket_ungrant(log, ctx->ticket);
 		xlog_cil_committed(ctx);
 		return;
 	}
 	spin_lock(&log->l_icloglock);
-	xlog_state_release_iclog(log, ctx->commit_iclog, 0);
+	ticket = ctx->ticket;
+	xlog_state_release_iclog(log, ctx->commit_iclog, ticket, 0);
 	/* Not safe to reference ctx now! */
 	spin_unlock(&log->l_icloglock);
+	xfs_log_ticket_ungrant(log, ticket);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f3b665362ac3..cf9a861eda86 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -507,7 +507,7 @@ void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 void xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
 		int eventual_size);
 int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog,
-		xfs_lsn_t log_tail_lsn);
+		struct xlog_ticket *ticket, xfs_lsn_t log_tail_lsn);
 
 /*
  * When we crack an atomic LSN, we sample it first so that the value will not
-- 
2.33.0

