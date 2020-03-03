Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5583C3F2CD
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 04:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FCD522B48
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 04:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgCCEHm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 23:07:42 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52373 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgCCEHm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 23:07:42 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B988F3A2450;
        Tue,  3 Mar 2020 15:07:36 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j8yqF-0006Lv-Rd; Tue, 03 Mar 2020 15:07:35 +1100
Date:   Tue, 3 Mar 2020 15:07:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 3/9] xfs: automatic relogging reservation
 management
Message-ID: <20200303040735.GR10776@dread.disaster.area>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-4-bfoster@redhat.com>
 <20200302030750.GH10776@dread.disaster.area>
 <20200302180650.GB10946@bfoster>
 <20200302232529.GN10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302232529.GN10776@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8 a=48gLqm1qsMDSgp4xQlQA:9
        a=o4Vezn4k5IxIexWm:21 a=GG4CmX3yZRfRCdhp:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 10:25:29AM +1100, Dave Chinner wrote:
> On Mon, Mar 02, 2020 at 01:06:50PM -0500, Brian Foster wrote:
> OK, XLOG_TIC_INITED is redundant, and should be removed. And
> xfs_log_done() needs to be split into two, one for releasing the
> ticket, one for completing the xlog_write() call. Compile tested
> only patch below for you :P

And now with sample patch.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: kill XLOG_TIC_INITED

From: Dave Chinner <dchinner@redhat.com>

Delayed logging made this redundant as we never directly write
transactions to the log anymore. Hence we no longer make multiple
xlog_write() calls for a transaction as we format individual items
in a transaction, and hence don't need to keep track of whether we
should be writing a start record for every xlog_write call.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 79 ++++++++++++++++++---------------------------------
 fs/xfs/xfs_log.h      |  4 ---
 fs/xfs/xfs_log_cil.c  | 13 +++++----
 fs/xfs/xfs_log_priv.h | 18 ++++++------
 fs/xfs/xfs_trans.c    | 24 ++++++++--------
 5 files changed, 55 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6006d94a581..a45f3eefee39 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -496,8 +496,8 @@ xfs_log_reserve(
  * This routine is called when a user of a log manager ticket is done with
  * the reservation.  If the ticket was ever used, then a commit record for
  * the associated transaction is written out as a log operation header with
- * no data.  The flag XLOG_TIC_INITED is set when the first write occurs with
- * a given ticket.  If the ticket was one with a permanent reservation, then
+ * no data. 
+ * If the ticket was one with a permanent reservation, then
  * a few operations are done differently.  Permanent reservation tickets by
  * default don't release the reservation.  They just commit the current
  * transaction with the belief that the reservation is still needed.  A flag
@@ -506,49 +506,38 @@ xfs_log_reserve(
  * the inited state again.  By doing this, a start record will be written
  * out when the next write occurs.
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
@@ -2148,8 +2137,9 @@ xlog_print_trans(
 }
 
 /*
- * Calculate the potential space needed by the log vector.  Each region gets
- * its own xlog_op_header_t and may need to be double word aligned.
+ * Calculate the potential space needed by the log vector.  We always write a
+ * start record, and each region gets its own xlog_op_header_t and may need to
+ * be double word aligned.
  */
 static int
 xlog_write_calc_vec_length(
@@ -2157,14 +2147,10 @@ xlog_write_calc_vec_length(
 	struct xfs_log_vec	*log_vector)
 {
 	struct xfs_log_vec	*lv;
-	int			headers = 0;
+	int			headers = 1;
 	int			len = 0;
 	int			i;
 
-	/* acct for start rec of xact */
-	if (ticket->t_flags & XLOG_TIC_INITED)
-		headers++;
-
 	for (lv = log_vector; lv; lv = lv->lv_next) {
 		/* we don't write ordered log vectors */
 		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
@@ -2195,17 +2181,11 @@ xlog_write_start_rec(
 	struct xlog_op_header	*ophdr,
 	struct xlog_ticket	*ticket)
 {
-	if (!(ticket->t_flags & XLOG_TIC_INITED))
-		return 0;
-
 	ophdr->oh_tid	= cpu_to_be32(ticket->t_tid);
 	ophdr->oh_clientid = ticket->t_clientid;
 	ophdr->oh_len = 0;
 	ophdr->oh_flags = XLOG_START_TRANS;
 	ophdr->oh_res2 = 0;
-
-	ticket->t_flags &= ~XLOG_TIC_INITED;
-
 	return sizeof(struct xlog_op_header);
 }
 
@@ -2410,12 +2390,10 @@ xlog_write(
 	len = xlog_write_calc_vec_length(ticket, log_vector);
 
 	/*
-	 * Region headers and bytes are already accounted for.
-	 * We only need to take into account start records and
-	 * split regions in this function.
+	 * Region headers and bytes are already accounted for.  We only need to
+	 * take into account start records and split regions in this function.
 	 */
-	if (ticket->t_flags & XLOG_TIC_INITED)
-		ticket->t_curr_res -= sizeof(xlog_op_header_t);
+	ticket->t_curr_res -= sizeof(xlog_op_header_t);
 
 	/*
 	 * Commit record headers need to be accounted for. These
@@ -3609,7 +3587,6 @@ xlog_ticket_alloc(
 	tic->t_ocnt		= cnt;
 	tic->t_tid		= prandom_u32();
 	tic->t_clientid		= client;
-	tic->t_flags		= XLOG_TIC_INITED;
 	if (permanent)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
 
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
index b192c5a9f9fd..6965d164ff45 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -53,11 +53,9 @@ enum xlog_iclog_state {
 /*
  * Flags to log ticket
  */
-#define XLOG_TIC_INITED		0x1	/* has been initialized */
 #define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
 
 #define XLOG_TIC_FLAGS \
-	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
 	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
 
 /*
@@ -438,14 +436,14 @@ xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
 
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
 
