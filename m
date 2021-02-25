Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	TVD_PH_BODY_META_ALL,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39485C43332
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 069A864ED6
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhBYDiR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 22:38:17 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36699 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233077AbhBYDiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 22:38:13 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1A1FC104118D
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 14:37:27 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-0038B5-Jf
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-00EvjZ-C3
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/12] xfs: move CIL ordering to the logvec chain
Date:   Thu, 25 Feb 2021 14:37:23 +1100
Message-Id: <20210225033725.3558450-11-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210225033725.3558450-1-david@fromorbit.com>
References: <20210225033725.3558450-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=AOyw4GDG7F-P3STw26YA:9
        a=SRwAY8YBePh4dedJ:21 a=-e-h8rg4gnLZ_6bK:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Adding a list_sort() call to the CIL push work while the xc_ctx_lock
is held exclusively has resulted in fairly long lock hold times and
that stops all front end transaction commits from making progress.

We can move the sorting out of the xc_ctx_lock if we can transfer
the ordering information to the log vectors as they are detached
from the log items and then we can sort the log vectors. This
requires log vectors to use a list_head rather than a single linked
list and to hold an order ID field. With these changes, we can move
the list_sort() call to just before we call xlog_write() when we
aren't holding any locks at all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c        | 43 ++++++++++++++++++++--------
 fs/xfs/xfs_log.h        |  3 +-
 fs/xfs/xfs_log_cil.c    | 63 +++++++++++++++++++++++++----------------
 fs/xfs/xfs_log_priv.h   |  4 +--
 fs/xfs/xfs_trans.c      |  4 +--
 fs/xfs/xfs_trans_priv.h |  4 +--
 6 files changed, 77 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 17a3af893e00..05aaf00f6c58 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -843,11 +843,14 @@ xlog_write_unmount_record(
 		.lv_niovecs = 1,
 		.lv_iovecp = &reg,
 	};
+	LIST_HEAD(lv_chain);
+	INIT_LIST_HEAD(&vec.lv_chain);
+	list_add(&vec.lv_chain, &lv_chain);
 
 	/* account for space used by record data */
 	ticket->t_curr_res -= sizeof(unmount_rec);
-	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS,
-				reg.i_len);
+	return xlog_write(log, &lv_chain, ticket, NULL, NULL,
+				XLOG_UNMOUNT_TRANS, reg.i_len);
 }
 
 /*
@@ -1560,14 +1563,17 @@ xlog_commit_record(
 		.lv_iovecp = &reg,
 	};
 	int	error;
+	LIST_HEAD(lv_chain);
+	INIT_LIST_HEAD(&vec.lv_chain);
+	list_add(&vec.lv_chain, &lv_chain);
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 
 	/* account for space used by record data */
 	ticket->t_curr_res -= reg.i_len;
-	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
-				reg.i_len);
+	error = xlog_write(log, &lv_chain, ticket, lsn, iclog,
+				XLOG_COMMIT_TRANS, reg.i_len);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
@@ -2117,6 +2123,7 @@ xlog_print_trans(
  */
 static struct xfs_log_vec *
 xlog_write_single(
+	struct list_head	*lv_chain,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	*iclog,
@@ -2135,7 +2142,8 @@ xlog_write_single(
 		iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
 	ptr = iclog->ic_datap + *log_offset;
-	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
+	while (
+	       (!lv->lv_niovecs || index < lv->lv_niovecs)) {
 
 
 		/* ordered log vectors have no regions to write */
@@ -2171,7 +2179,11 @@ xlog_write_single(
 			continue;
 next_lv:
 		/* move to the next logvec */
-		lv = lv->lv_next;
+		lv = list_next_entry(lv, lv_chain);
+		if (list_entry_is_head(lv, lv_chain, lv_chain)) {
+			lv = NULL;
+			break;
+		}
 		index = 0;
 	}
 	ASSERT(*len == 0 || lv);
@@ -2219,6 +2231,7 @@ xlog_write_get_more_iclog_space(
 static struct xfs_log_vec *
 xlog_write_partial(
 	struct xlog		*log,
+	struct list_head	*lv_chain,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclogp,
@@ -2358,7 +2371,10 @@ xlog_write_partial(
 	 * the caller so it can go back to fast path copying.
 	 */
 	*iclogp = iclog;
-	return lv->lv_next;
+	lv = list_next_entry(lv, lv_chain);
+	if (list_entry_is_head(lv, lv_chain, lv_chain))
+		return NULL;
+	return lv;
 }
 
 /*
@@ -2404,7 +2420,7 @@ xlog_write_partial(
 int
 xlog_write(
 	struct xlog		*log,
-	struct xfs_log_vec	*log_vector,
+	struct list_head	*lv_chain,
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*start_lsn,
 	struct xlog_in_core	**commit_iclog,
@@ -2412,7 +2428,7 @@ xlog_write(
 	uint32_t		len)
 {
 	struct xlog_in_core	*iclog = NULL;
-	struct xfs_log_vec	*lv = log_vector;
+	struct xfs_log_vec	*lv;
 	int			record_cnt = 0;
 	int			data_cnt = 0;
 	int			error = 0;
@@ -2444,15 +2460,18 @@ xlog_write(
 	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
 		iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
+	lv = list_first_entry_or_null(lv_chain, struct xfs_log_vec, lv_chain);
 	while (lv) {
-		lv = xlog_write_single(lv, ticket, iclog, &log_offset,
+
+		lv = xlog_write_single(lv_chain, lv, ticket, iclog, &log_offset,
 					&len, &record_cnt, &data_cnt);
 		if (!lv)
 			break;
 
 		ASSERT(!(optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)));
-		lv = xlog_write_partial(log, lv, ticket, &iclog, &log_offset,
-					&len, &record_cnt, &data_cnt);
+		lv = xlog_write_partial(log, lv_chain, lv, ticket, &iclog,
+					&log_offset, &len, &record_cnt,
+					&data_cnt);
 		if (IS_ERR(lv)) {
 			error = PTR_ERR(lv);
 			break;
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 6d397c32a08a..259b30ba6e6f 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -9,7 +9,8 @@
 struct xfs_cil_ctx;
 
 struct xfs_log_vec {
-	struct xfs_log_vec	*lv_next;	/* next lv in build list */
+	struct list_head	lv_chain;	/* lv chain ptrs */
+	int			lv_order_id;	/* chain ordering info */
 	int			lv_niovecs;	/* number of iovecs in lv */
 	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
 	struct xfs_log_item	*lv_item;	/* owner */
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 810ebb226f94..79dc185f2dba 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -72,6 +72,7 @@ xlog_cil_ctx_alloc(void)
 	ctx = kmem_zalloc(sizeof(*ctx), KM_NOFS);
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
+	INIT_LIST_HEAD(&ctx->lv_chain);
 	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
 	return ctx;
 }
@@ -237,6 +238,7 @@ xlog_cil_alloc_shadow_bufs(
 			lv = kmem_alloc_large(buf_size, KM_NOFS);
 			memset(lv, 0, xlog_cil_iovec_space(niovecs));
 
+			INIT_LIST_HEAD(&lv->lv_chain);
 			lv->lv_item = lip;
 			lv->lv_size = buf_size;
 			if (ordered)
@@ -252,7 +254,6 @@ xlog_cil_alloc_shadow_bufs(
 			else
 				lv->lv_buf_len = 0;
 			lv->lv_bytes = 0;
-			lv->lv_next = NULL;
 		}
 
 		/* Ensure the lv is set up according to ->iop_size */
@@ -379,8 +380,6 @@ xlog_cil_insert_format_items(
 		if (lip->li_lv && shadow->lv_size <= lip->li_lv->lv_size) {
 			/* same or smaller, optimise common overwrite case */
 			lv = lip->li_lv;
-			lv->lv_next = NULL;
-
 			if (ordered)
 				goto insert;
 
@@ -547,14 +546,14 @@ xlog_cil_insert_items(
 
 static void
 xlog_cil_free_logvec(
-	struct xfs_log_vec	*log_vector)
+	struct list_head	*lv_chain)
 {
 	struct xfs_log_vec	*lv;
 
-	for (lv = log_vector; lv; ) {
-		struct xfs_log_vec *next = lv->lv_next;
+	while(!list_empty(lv_chain)) {
+		lv = list_first_entry(lv_chain, struct xfs_log_vec, lv_chain);
+		list_del_init(&lv->lv_chain);
 		kmem_free(lv);
-		lv = next;
 	}
 }
 
@@ -653,7 +652,7 @@ xlog_cil_committed(
 		spin_unlock(&ctx->cil->xc_push_lock);
 	}
 
-	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
+	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, &ctx->lv_chain,
 					ctx->start_lsn, abort);
 
 	xfs_extent_busy_sort(&ctx->busy_extents);
@@ -664,7 +663,7 @@ xlog_cil_committed(
 	list_del(&ctx->committing);
 	spin_unlock(&ctx->cil->xc_push_lock);
 
-	xlog_cil_free_logvec(ctx->lv_chain);
+	xlog_cil_free_logvec(&ctx->lv_chain);
 
 	if (!list_empty(&ctx->busy_extents))
 		xlog_discard_busy_extents(mp, ctx);
@@ -744,7 +743,7 @@ xlog_cil_build_trans_hdr(
 	lvhdr->lv_niovecs = 2;
 	lvhdr->lv_iovecp = &hdr->lhdr[0];
 	lvhdr->lv_bytes = hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
-	lvhdr->lv_next = ctx->lv_chain;
+	list_add(&lvhdr->lv_chain, &ctx->lv_chain);
 
 	tic->t_curr_res -= lvhdr->lv_bytes;
 }
@@ -755,12 +754,14 @@ xlog_cil_order_cmp(
 	struct list_head	*a,
 	struct list_head	*b)
 {
-	struct xfs_log_item	*l1 = container_of(a, struct xfs_log_item, li_cil);
-	struct xfs_log_item	*l2 = container_of(b, struct xfs_log_item, li_cil);
+	struct xfs_log_vec	*l1 = container_of(a, struct xfs_log_vec,
+							lv_chain);
+	struct xfs_log_vec	*l2 = container_of(b, struct xfs_log_vec,
+							lv_chain);
 
-	if (l1->li_order_id > l2->li_order_id)
+	if (l1->lv_order_id > l2->lv_order_id)
 		return 1;
-	if (l1->li_order_id < l2->li_order_id)
+	if (l1->lv_order_id < l2->lv_order_id)
 		return -1;
 	return 0;
 }
@@ -905,26 +906,25 @@ xlog_cil_push_work(
 	 * needed on the transaction commit side which is currently locked out
 	 * by the flush lock.
 	 */
-	list_sort(NULL, &log_items, xlog_cil_order_cmp);
 	lv = NULL;
 	while (!list_empty(&log_items)) {
 		struct xfs_log_item	*item;
 
 		item = list_first_entry(&log_items,
 					struct xfs_log_item, li_cil);
-		list_del_init(&item->li_cil);
-		item->li_order_id = 0;
-		if (!ctx->lv_chain)
-			ctx->lv_chain = item->li_lv;
-		else
-			lv->lv_next = item->li_lv;
+
 		lv = item->li_lv;
-		item->li_lv = NULL;
+		lv->lv_order_id = item->li_order_id;
 		num_iovecs += lv->lv_niovecs;
-
 		/* we don't write ordered log vectors */
 		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
 			num_bytes += lv->lv_bytes;
+		list_add_tail(&lv->lv_chain, &ctx->lv_chain);
+
+		list_del_init(&item->li_cil);
+		item->li_order_id = 0;
+		item->li_lv = NULL;
+
 	}
 
 	/*
@@ -957,6 +957,13 @@ xlog_cil_push_work(
 	spin_unlock(&cil->xc_push_lock);
 	up_write(&cil->xc_ctx_lock);
 
+	/*
+	 * Sort the log vector chain before we add the transaction headers.
+	 * This ensures we always have the transaction headers at the start
+	 * of the chain.
+	 */
+	list_sort(NULL, &ctx->lv_chain, xlog_cil_order_cmp);
+
 	/*
 	 * Build a checkpoint transaction header and write it to the log to
 	 * begin the transaction. We need to account for the space used by the
@@ -978,8 +985,14 @@ xlog_cil_push_work(
 	 * use the commit record lsn then we can move the tail beyond the grant
 	 * write head.
 	 */
-	error = xlog_write(log, &lvhdr, ctx->ticket, &ctx->start_lsn, NULL,
-				XLOG_START_TRANS, num_bytes);
+	error = xlog_write(log, &ctx->lv_chain, ctx->ticket, &ctx->start_lsn,
+				NULL, XLOG_START_TRANS, num_bytes);
+
+	/*
+	 * Take the lvhdr back off the lv_chain as it should not be passed
+	 * to log IO completion.
+	 */
+	list_del(&lvhdr.lv_chain);
 	if (error)
 		goto out_abort_free_ticket;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index fb8399414131..8f17bf8e2524 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -224,7 +224,7 @@ struct xfs_cil_ctx {
 	int			nvecs;		/* number of regions */
 	atomic_t		space_used;	/* aggregate size of regions */
 	struct list_head	busy_extents;	/* busy extents in chkpt */
-	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
+	struct list_head	lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
 	struct work_struct	discard_endio_work;
@@ -480,7 +480,7 @@ xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
 
 void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
-int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
+int	xlog_write(struct xlog *log, struct list_head *lv_chain,
 		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
 		struct xlog_in_core **commit_iclog, uint optype, uint32_t len);
 int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bbc752311b63..c4d958a12ee6 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -745,7 +745,7 @@ xfs_log_item_batch_insert(
 void
 xfs_trans_committed_bulk(
 	struct xfs_ail		*ailp,
-	struct xfs_log_vec	*log_vector,
+	struct list_head	*lv_chain,
 	xfs_lsn_t		commit_lsn,
 	bool			aborted)
 {
@@ -760,7 +760,7 @@ xfs_trans_committed_bulk(
 	spin_unlock(&ailp->ail_lock);
 
 	/* unpin all the log items */
-	for (lv = log_vector; lv; lv = lv->lv_next ) {
+	list_for_each_entry(lv, lv_chain, lv_chain) {
 		struct xfs_log_item	*lip = lv->lv_item;
 		xfs_lsn_t		item_lsn;
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 3004aeac9110..b0bf78e6ff76 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -18,8 +18,8 @@ void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
-void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
-				xfs_lsn_t commit_lsn, bool aborted);
+void	xfs_trans_committed_bulk(struct xfs_ail *ailp,
+		struct list_head *lv_chain, xfs_lsn_t commit_lsn, bool aborted);
 /*
  * AIL traversal cursor.
  *
-- 
2.28.0

