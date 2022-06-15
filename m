Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5985ACCA480
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 07:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343836AbiFOHxq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243638AbiFOHxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 03:53:40 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90A1141981
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 00:53:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1CFD75ECAAE
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 17:53:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-006rRV-RE
        for linux-xfs@vger.kernel.org; Wed, 15 Jun 2022 17:53:32 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-00FJyG-Q9
        for linux-xfs@vger.kernel.org;
        Wed, 15 Jun 2022 17:53:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/14] xfs: convert log vector chain to use list heads
Date:   Wed, 15 Jun 2022 17:53:26 +1000
Message-Id: <20220615075330.3651541-11-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615075330.3651541-1-david@fromorbit.com>
References: <20220615075330.3651541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62a98ffe
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=0QCIYeYKnweKUEuHm34A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because the next change is going to require sorting log vectors, and
that requires arbitrary rearrangement of the list which cannot be
done easily with a single linked list.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c        | 11 +++++----
 fs/xfs/xfs_log.h        |  2 +-
 fs/xfs/xfs_log_cil.c    | 54 +++++++++++++++++++++++------------------
 fs/xfs/xfs_log_priv.h   |  4 +--
 fs/xfs/xfs_trans.c      |  4 +--
 fs/xfs/xfs_trans_priv.h |  3 ++-
 6 files changed, 43 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f428d7aebf6d..bc4a5f2f04e8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -944,6 +944,8 @@ xlog_write_unmount_record(
 		.lv_niovecs = 1,
 		.lv_iovecp = &reg,
 	};
+	LIST_HEAD(lv_chain);
+	list_add(&vec.lv_list, &lv_chain);
 
 	BUILD_BUG_ON((sizeof(struct xlog_op_header) +
 		      sizeof(struct xfs_unmount_log_format)) !=
@@ -952,7 +954,7 @@ xlog_write_unmount_record(
 	/* account for space used by record data */
 	ticket->t_curr_res -= sizeof(unmount_rec);
 
-	return xlog_write(log, NULL, &vec, ticket, reg.i_len);
+	return xlog_write(log, NULL, &lv_chain, ticket, reg.i_len);
 }
 
 /*
@@ -2466,13 +2468,13 @@ int
 xlog_write(
 	struct xlog		*log,
 	struct xfs_cil_ctx	*ctx,
-	struct xfs_log_vec	*log_vector,
+	struct list_head	*lv_chain,
 	struct xlog_ticket	*ticket,
 	uint32_t		len)
 
 {
 	struct xlog_in_core	*iclog = NULL;
-	struct xfs_log_vec	*lv = log_vector;
+	struct xfs_log_vec	*lv;
 	uint32_t		record_cnt = 0;
 	uint32_t		data_cnt = 0;
 	int			error = 0;
@@ -2500,7 +2502,7 @@ xlog_write(
 	if (ctx)
 		xlog_cil_set_ctx_write_state(ctx, iclog);
 
-	while (lv) {
+	list_for_each_entry(lv, lv_chain, lv_list) {
 		/*
 		 * If the entire log vec does not fit in the iclog, punt it to
 		 * the partial copy loop which can handle this case.
@@ -2521,7 +2523,6 @@ xlog_write(
 			xlog_write_full(lv, ticket, iclog, &log_offset,
 					 &len, &record_cnt, &data_cnt);
 		}
-		lv = lv->lv_next;
 	}
 	ASSERT(len == 0);
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index f3ce046a7d45..e7bf3c780cb4 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -9,7 +9,7 @@
 struct xfs_cil_ctx;
 
 struct xfs_log_vec {
-	struct xfs_log_vec	*lv_next;	/* next lv in build list */
+	struct list_head	lv_list;	/* CIL lv chain ptrs */
 	int			lv_niovecs;	/* number of iovecs in lv */
 	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
 	struct xfs_log_item	*lv_item;	/* owner */
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index a0792b8db38b..0e69e855d710 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -105,6 +105,7 @@ xlog_cil_ctx_alloc(void)
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
 	INIT_LIST_HEAD(&ctx->log_items);
+	INIT_LIST_HEAD(&ctx->lv_chain);
 	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
 	return ctx;
 }
@@ -338,6 +339,7 @@ xlog_cil_alloc_shadow_bufs(
 
 			memset(lv, 0, xlog_cil_iovec_space(niovecs));
 
+			INIT_LIST_HEAD(&lv->lv_list);
 			lv->lv_item = lip;
 			lv->lv_size = buf_size;
 			if (ordered)
@@ -353,7 +355,6 @@ xlog_cil_alloc_shadow_bufs(
 			else
 				lv->lv_buf_len = 0;
 			lv->lv_bytes = 0;
-			lv->lv_next = NULL;
 		}
 
 		/* Ensure the lv is set up according to ->iop_size */
@@ -480,7 +481,6 @@ xlog_cil_insert_format_items(
 		if (lip->li_lv && shadow->lv_size <= lip->li_lv->lv_size) {
 			/* same or smaller, optimise common overwrite case */
 			lv = lip->li_lv;
-			lv->lv_next = NULL;
 
 			if (ordered)
 				goto insert;
@@ -685,14 +685,14 @@ xlog_cil_insert_items(
 
 static void
 xlog_cil_free_logvec(
-	struct xfs_log_vec	*log_vector)
+	struct list_head	*lv_chain)
 {
 	struct xfs_log_vec	*lv;
 
-	for (lv = log_vector; lv; ) {
-		struct xfs_log_vec *next = lv->lv_next;
+	while (!list_empty(lv_chain)) {
+		lv = list_first_entry(lv_chain, struct xfs_log_vec, lv_list);
+		list_del_init(&lv->lv_list);
 		kmem_free(lv);
-		lv = next;
 	}
 }
 
@@ -792,7 +792,7 @@ xlog_cil_committed(
 		spin_unlock(&ctx->cil->xc_push_lock);
 	}
 
-	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
+	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, &ctx->lv_chain,
 					ctx->start_lsn, abort);
 
 	xfs_extent_busy_sort(&ctx->busy_extents);
@@ -803,7 +803,7 @@ xlog_cil_committed(
 	list_del(&ctx->committing);
 	spin_unlock(&ctx->cil->xc_push_lock);
 
-	xlog_cil_free_logvec(ctx->lv_chain);
+	xlog_cil_free_logvec(&ctx->lv_chain);
 
 	if (!list_empty(&ctx->busy_extents))
 		xlog_discard_busy_extents(mp, ctx);
@@ -962,7 +962,6 @@ xlog_cil_order_write(
 static int
 xlog_cil_write_chain(
 	struct xfs_cil_ctx	*ctx,
-	struct xfs_log_vec	*chain,
 	uint32_t		chain_len)
 {
 	struct xlog		*log = ctx->cil->xc_log;
@@ -971,7 +970,7 @@ xlog_cil_write_chain(
 	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _START_RECORD);
 	if (error)
 		return error;
-	return xlog_write(log, ctx, chain, ctx->ticket, chain_len);
+	return xlog_write(log, ctx, &ctx->lv_chain, ctx->ticket, chain_len);
 }
 
 /*
@@ -1000,6 +999,8 @@ xlog_cil_write_commit_record(
 		.lv_iovecp = &reg,
 	};
 	int			error;
+	LIST_HEAD(lv_chain);
+	list_add(&vec.lv_list, &lv_chain);
 
 	if (xlog_is_shutdown(log))
 		return -EIO;
@@ -1010,7 +1011,7 @@ xlog_cil_write_commit_record(
 
 	/* account for space used by record data */
 	ctx->ticket->t_curr_res -= reg.i_len;
-	error = xlog_write(log, ctx, &vec, ctx->ticket, reg.i_len);
+	error = xlog_write(log, ctx, &lv_chain, ctx->ticket, reg.i_len);
 	if (error)
 		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 	return error;
@@ -1076,7 +1077,6 @@ xlog_cil_build_trans_hdr(
 	lvhdr->lv_niovecs = 2;
 	lvhdr->lv_iovecp = &hdr->lhdr[0];
 	lvhdr->lv_bytes = hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
-	lvhdr->lv_next = ctx->lv_chain;
 
 	tic->t_curr_res -= lvhdr->lv_bytes;
 }
@@ -1117,12 +1117,11 @@ xlog_cil_build_lv_chain(
 	uint32_t		*num_iovecs,
 	uint32_t		*num_bytes)
 {
-	struct xfs_log_vec	*lv = NULL;
-
 	list_sort(NULL, &ctx->log_items, xlog_cil_order_cmp);
 
 	while (!list_empty(&ctx->log_items)) {
 		struct xfs_log_item	*item;
+		struct xfs_log_vec	*lv;
 
 		item = list_first_entry(&ctx->log_items,
 					struct xfs_log_item, li_cil);
@@ -1133,19 +1132,17 @@ xlog_cil_build_lv_chain(
 			continue;
 		}
 
-		list_del_init(&item->li_cil);
-		item->li_order_id = 0;
-		if (!ctx->lv_chain)
-			ctx->lv_chain = item->li_lv;
-		else
-			lv->lv_next = item->li_lv;
 		lv = item->li_lv;
-		item->li_lv = NULL;
-		*num_iovecs += lv->lv_niovecs;
 
 		/* we don't write ordered log vectors */
 		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
 			*num_bytes += lv->lv_bytes;
+		*num_iovecs += lv->lv_niovecs;
+		list_add_tail(&lv->lv_list, &ctx->lv_chain);
+
+		list_del_init(&item->li_cil);
+		item->li_order_id = 0;
+		item->li_lv = NULL;
 	}
 }
 
@@ -1189,7 +1186,7 @@ xlog_cil_push_work(
 	int			num_bytes = 0;
 	int			error = 0;
 	struct xlog_cil_trans_hdr thdr;
-	struct xfs_log_vec	lvhdr = { NULL };
+	struct xfs_log_vec	lvhdr = {};
 	xfs_csn_t		push_seq;
 	bool			push_commit_stable;
 	LIST_HEAD		(whiteouts);
@@ -1299,11 +1296,20 @@ xlog_cil_push_work(
 	 * Build a checkpoint transaction header and write it to the log to
 	 * begin the transaction. We need to account for the space used by the
 	 * transaction header here as it is not accounted for in xlog_write().
+	 * Add the lvhdr to the head of the lv chain we pass to xlog_write() so
+	 * it gets written into the iclog first.
 	 */
 	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
 	num_bytes += lvhdr.lv_bytes;
+	list_add(&lvhdr.lv_list, &ctx->lv_chain);
 
-	error = xlog_cil_write_chain(ctx, &lvhdr, num_bytes);
+	/*
+	 * Take the lvhdr back off the lv_chain immediately after calling
+	 * xlog_cil_write_chain() as it should not be passed to log IO
+	 * completion.
+	 */
+	error = xlog_cil_write_chain(ctx, num_bytes);
+	list_del(&lvhdr.lv_list);
 	if (error)
 		goto out_abort_free_ticket;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f00f11c18116..d4270a2d4ffb 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -225,7 +225,7 @@ struct xfs_cil_ctx {
 	atomic_t		space_used;	/* aggregate size of regions */
 	struct list_head	busy_extents;	/* busy extents in chkpt */
 	struct list_head	log_items;	/* log items in chkpt */
-	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
+	struct list_head	lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
 	struct work_struct	discard_endio_work;
@@ -508,7 +508,7 @@ struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
 void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
-		struct xfs_log_vec *log_vector, struct xlog_ticket *tic,
+		struct list_head *lv_chain, struct xlog_ticket *tic,
 		uint32_t len);
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 82cf0189c0db..ec347717ce78 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -760,7 +760,7 @@ xfs_log_item_batch_insert(
 void
 xfs_trans_committed_bulk(
 	struct xfs_ail		*ailp,
-	struct xfs_log_vec	*log_vector,
+	struct list_head	*lv_chain,
 	xfs_lsn_t		commit_lsn,
 	bool			aborted)
 {
@@ -775,7 +775,7 @@ xfs_trans_committed_bulk(
 	spin_unlock(&ailp->ail_lock);
 
 	/* unpin all the log items */
-	for (lv = log_vector; lv; lv = lv->lv_next ) {
+	list_for_each_entry(lv, lv_chain, lv_list) {
 		struct xfs_log_item	*lip = lv->lv_item;
 		xfs_lsn_t		item_lsn;
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index f0d79a9050ba..d5400150358e 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -19,7 +19,8 @@ void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
-void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
+void	xfs_trans_committed_bulk(struct xfs_ail *ailp,
+				struct list_head *lv_chain,
 				xfs_lsn_t commit_lsn, bool aborted);
 /*
  * AIL traversal cursor.
-- 
2.35.1

