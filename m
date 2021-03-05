Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03942C4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6A9065013
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhCEFM5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:12:57 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58881 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhCEFMT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:12:19 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 09A1D828113
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:52 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-00Fbpg-Hz
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-000laj-AE
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 41/45] xfs: move CIL ordering to the logvec chain
Date:   Fri,  5 Mar 2021 16:11:39 +1100
Message-Id: <20210305051143.182133-42-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=xvtivy5LyCy7Q2jPmfEA:9
        a=efn6qEVgltjbn7IR:21 a=EvgdL0HIMYCb13tF:21
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
 fs/xfs/xfs_log.c        | 46 +++++++++++++++++++++---------
 fs/xfs/xfs_log.h        |  3 +-
 fs/xfs/xfs_log_cil.c    | 63 +++++++++++++++++++++++++----------------
 fs/xfs/xfs_log_priv.h   |  4 +--
 fs/xfs/xfs_trans.c      |  4 +--
 fs/xfs/xfs_trans_priv.h |  4 +--
 6 files changed, 78 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 46a006d41184..fd58c3213ebf 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -846,6 +846,9 @@ xlog_write_unmount_record(
 		.lv_niovecs = 1,
 		.lv_iovecp = &reg,
 	};
+	LIST_HEAD(lv_chain);
+	INIT_LIST_HEAD(&vec.lv_chain);
+	list_add(&vec.lv_chain, &lv_chain);
 
 	/* account for space used by record data */
 	ticket->t_curr_res -= sizeof(unmount_rec);
@@ -857,8 +860,8 @@ xlog_write_unmount_record(
 	 */
 	if (log->l_targ != log->l_mp->m_ddev_targp)
 		blkdev_issue_flush(log->l_targ->bt_bdev);
-	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS,
-				reg.i_len);
+	return xlog_write(log, &lv_chain, ticket, NULL, NULL,
+				XLOG_UNMOUNT_TRANS, reg.i_len);
 }
 
 /*
@@ -1571,14 +1574,17 @@ xlog_commit_record(
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
@@ -2109,6 +2115,7 @@ xlog_print_trans(
  */
 static struct xfs_log_vec *
 xlog_write_single(
+	struct list_head	*lv_chain,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	*iclog,
@@ -2117,7 +2124,7 @@ xlog_write_single(
 	uint32_t		*record_cnt,
 	uint32_t		*data_cnt)
 {
-	struct xfs_log_vec	*lv = log_vector;
+	struct xfs_log_vec	*lv;
 	void			*ptr;
 	int			index;
 
@@ -2125,10 +2132,13 @@ xlog_write_single(
 		iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
 	ptr = iclog->ic_datap + *log_offset;
-	for (lv = log_vector; lv; lv = lv->lv_next) {
+	for (lv = log_vector;
+	     !list_entry_is_head(lv, lv_chain, lv_chain);
+	     lv = list_next_entry(lv, lv_chain)) {
 		/*
-		 * If the entire log vec does not fit in the iclog, punt it to
-		 * the partial copy loop which can handle this case.
+		 * If the log vec contains data that needs to be copied and does
+		 * not entirely fit in the iclog, punt it to the partial copy
+		 * loop which can handle this case.
 		 */
 		if (lv->lv_niovecs &&
 		    lv->lv_bytes > iclog->ic_size - *log_offset)
@@ -2154,6 +2164,8 @@ xlog_write_single(
 			*data_cnt += reg->i_len;
 		}
 	}
+	if (list_entry_is_head(lv, lv_chain, lv_chain))
+		lv = NULL;
 	ASSERT(*len == 0 || lv);
 	return lv;
 }
@@ -2199,6 +2211,7 @@ xlog_write_get_more_iclog_space(
 static struct xfs_log_vec *
 xlog_write_partial(
 	struct xlog		*log,
+	struct list_head	*lv_chain,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclogp,
@@ -2338,7 +2351,10 @@ xlog_write_partial(
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
@@ -2384,7 +2400,7 @@ xlog_write_partial(
 int
 xlog_write(
 	struct xlog		*log,
-	struct xfs_log_vec	*log_vector,
+	struct list_head	*lv_chain,
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*start_lsn,
 	struct xlog_in_core	**commit_iclog,
@@ -2392,7 +2408,7 @@ xlog_write(
 	uint32_t		len)
 {
 	struct xlog_in_core	*iclog = NULL;
-	struct xfs_log_vec	*lv = log_vector;
+	struct xfs_log_vec	*lv;
 	int			record_cnt = 0;
 	int			data_cnt = 0;
 	int			error = 0;
@@ -2424,15 +2440,17 @@ xlog_write(
 	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
 		iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
+	lv = list_first_entry_or_null(lv_chain, struct xfs_log_vec, lv_chain);
 	while (lv) {
-		lv = xlog_write_single(lv, ticket, iclog, &log_offset,
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
 		if (IS_ERR_OR_NULL(lv)) {
 			error = PTR_ERR_OR_ZERO(lv);
 			break;
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index af54ea3f8c90..0445dd6acbce 100644
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
index 3d43a5088154..6dcc23829bef 100644
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
@@ -907,26 +908,25 @@ xlog_cil_push_work(
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
@@ -959,6 +959,13 @@ xlog_cil_push_work(
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
@@ -981,8 +988,14 @@ xlog_cil_push_work(
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
index 12a1a36eef7e..6a4160200417 100644
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
index 83c2b7f22eb7..b20e68279808 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -747,7 +747,7 @@ xfs_log_item_batch_insert(
 void
 xfs_trans_committed_bulk(
 	struct xfs_ail		*ailp,
-	struct xfs_log_vec	*log_vector,
+	struct list_head	*lv_chain,
 	xfs_lsn_t		commit_lsn,
 	bool			aborted)
 {
@@ -762,7 +762,7 @@ xfs_trans_committed_bulk(
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

