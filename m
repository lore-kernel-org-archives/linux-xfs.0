Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6E7C47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6795E613E6
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhFCFZE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 01:25:04 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:57252 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229667AbhFCFZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 01:25:04 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 0E8A11140D45
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 15:22:52 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofoh-008Mrb-Ic
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:51 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lofoh-000ims-Aq
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 35/39] xfs: convert log vector chain to use list heads
Date:   Thu,  3 Jun 2021 15:22:36 +1000
Message-Id: <20210603052240.171998-36-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603052240.171998-1-david@fromorbit.com>
References: <20210603052240.171998-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=jXe00CcTslu8MUNN16oA:9 a=WI0PLuyhFX_T0COE:21 a=F02lmZsJYUrVVW-l:21
        a=AjGcO6oz07-iQ99wixmX:22
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
 fs/xfs/xfs_log.c        | 35 +++++++++++++++++++++++++---------
 fs/xfs/xfs_log.h        |  2 +-
 fs/xfs/xfs_log_cil.c    | 42 +++++++++++++++++++++++------------------
 fs/xfs/xfs_log_priv.h   |  4 ++--
 fs/xfs/xfs_trans.c      |  4 ++--
 fs/xfs/xfs_trans_priv.h |  3 ++-
 6 files changed, 57 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 77d9ea7daf26..5511c5de6b78 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -848,6 +848,9 @@ xlog_write_unmount_record(
 		.lv_niovecs = 1,
 		.lv_iovecp = &reg,
 	};
+	LIST_HEAD(lv_chain);
+	INIT_LIST_HEAD(&vec.lv_list);
+	list_add(&vec.lv_list, &lv_chain);
 
 	BUILD_BUG_ON((sizeof(struct xlog_op_header) +
 		      sizeof(struct xfs_unmount_log_format)) !=
@@ -863,7 +866,7 @@ xlog_write_unmount_record(
 	 */
 	if (log->l_targ != log->l_mp->m_ddev_targp)
 		blkdev_issue_flush(log->l_targ->bt_bdev);
-	return xlog_write(log, &vec, ticket, NULL, NULL, reg.i_len);
+	return xlog_write(log, &lv_chain, ticket, NULL, NULL, reg.i_len);
 }
 
 /*
@@ -1581,13 +1584,16 @@ xlog_commit_record(
 		.lv_iovecp = &reg,
 	};
 	int	error;
+	LIST_HEAD(lv_chain);
+	INIT_LIST_HEAD(&vec.lv_list);
+	list_add(&vec.lv_list, &lv_chain);
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return -EIO;
 
 	/* account for space used by record data */
 	ticket->t_curr_res -= reg.i_len;
-	error = xlog_write(log, &vec, ticket, lsn, iclog, reg.i_len);
+	error = xlog_write(log, &lv_chain, ticket, lsn, iclog, reg.i_len);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
@@ -2118,6 +2124,7 @@ xlog_print_trans(
  */
 static struct xfs_log_vec *
 xlog_write_single(
+	struct list_head	*lv_chain,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	*iclog,
@@ -2134,7 +2141,9 @@ xlog_write_single(
 		iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
 	ptr = iclog->ic_datap + *log_offset;
-	for (lv = log_vector; lv; lv = lv->lv_next) {
+	for (lv = log_vector;
+	     !list_entry_is_head(lv, lv_chain, lv_list);
+	     lv = list_next_entry(lv, lv_list)) {
 		/*
 		 * If the entire log vec does not fit in the iclog, punt it to
 		 * the partial copy loop which can handle this case.
@@ -2163,6 +2172,8 @@ xlog_write_single(
 			*data_cnt += reg->i_len;
 		}
 	}
+	if (list_entry_is_head(lv, lv_chain, lv_list))
+		lv = NULL;
 	ASSERT(*len == 0 || lv);
 	return lv;
 }
@@ -2208,6 +2219,7 @@ xlog_write_get_more_iclog_space(
 static struct xfs_log_vec *
 xlog_write_partial(
 	struct xlog		*log,
+	struct list_head	*lv_chain,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclogp,
@@ -2347,7 +2359,10 @@ xlog_write_partial(
 	 * the caller so it can go back to fast path copying.
 	 */
 	*iclogp = iclog;
-	return lv->lv_next;
+	lv = list_next_entry(lv, lv_list);
+	if (list_entry_is_head(lv, lv_chain, lv_list))
+		return NULL;
+	return lv;
 }
 
 /*
@@ -2393,14 +2408,14 @@ xlog_write_partial(
 int
 xlog_write(
 	struct xlog		*log,
-	struct xfs_log_vec	*log_vector,
+	struct list_head	*lv_chain,
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*start_lsn,
 	struct xlog_in_core	**commit_iclog,
 	uint32_t		len)
 {
 	struct xlog_in_core	*iclog = NULL;
-	struct xfs_log_vec	*lv = log_vector;
+	struct xfs_log_vec	*lv;
 	int			record_cnt = 0;
 	int			data_cnt = 0;
 	int			error = 0;
@@ -2422,14 +2437,16 @@ xlog_write(
 	if (start_lsn)
 		*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 
+	lv = list_first_entry_or_null(lv_chain, struct xfs_log_vec, lv_list);
 	while (lv) {
-		lv = xlog_write_single(lv, ticket, iclog, &log_offset,
+		lv = xlog_write_single(lv_chain, lv, ticket, iclog, &log_offset,
 					&len, &record_cnt, &data_cnt);
 		if (!lv)
 			break;
 
-		lv = xlog_write_partial(log, lv, ticket, &iclog, &log_offset,
-					&len, &record_cnt, &data_cnt);
+		lv = xlog_write_partial(log, lv_chain, lv, ticket, &iclog,
+					&log_offset, &len, &record_cnt,
+					&data_cnt);
 		if (IS_ERR_OR_NULL(lv)) {
 			error = PTR_ERR_OR_ZERO(lv);
 			break;
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index af54ea3f8c90..b4ad0e37a0c5 100644
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
index 3ca9fce57584..65910fca652f 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -73,6 +73,7 @@ xlog_cil_ctx_alloc(void)
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
 	INIT_LIST_HEAD(&ctx->log_items);
+	INIT_LIST_HEAD(&ctx->lv_chain);
 	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
 	return ctx;
 }
@@ -274,6 +275,7 @@ xlog_cil_alloc_shadow_bufs(
 			lv = kmem_alloc_large(buf_size, KM_NOFS);
 			memset(lv, 0, xlog_cil_iovec_space(niovecs));
 
+			INIT_LIST_HEAD(&lv->lv_list);
 			lv->lv_item = lip;
 			lv->lv_size = buf_size;
 			if (ordered)
@@ -289,7 +291,6 @@ xlog_cil_alloc_shadow_bufs(
 			else
 				lv->lv_buf_len = 0;
 			lv->lv_bytes = 0;
-			lv->lv_next = NULL;
 		}
 
 		/* Ensure the lv is set up according to ->iop_size */
@@ -416,7 +417,6 @@ xlog_cil_insert_format_items(
 		if (lip->li_lv && shadow->lv_size <= lip->li_lv->lv_size) {
 			/* same or smaller, optimise common overwrite case */
 			lv = lip->li_lv;
-			lv->lv_next = NULL;
 
 			if (ordered)
 				goto insert;
@@ -583,14 +583,14 @@ xlog_cil_insert_items(
 
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
 
@@ -689,7 +689,7 @@ xlog_cil_committed(
 		spin_unlock(&ctx->cil->xc_push_lock);
 	}
 
-	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
+	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, &ctx->lv_chain,
 					ctx->start_lsn, abort);
 
 	xfs_extent_busy_sort(&ctx->busy_extents);
@@ -700,7 +700,7 @@ xlog_cil_committed(
 	list_del(&ctx->committing);
 	spin_unlock(&ctx->cil->xc_push_lock);
 
-	xlog_cil_free_logvec(ctx->lv_chain);
+	xlog_cil_free_logvec(&ctx->lv_chain);
 
 	if (!list_empty(&ctx->busy_extents))
 		xlog_discard_busy_extents(mp, ctx);
@@ -780,7 +780,6 @@ xlog_cil_build_trans_hdr(
 	lvhdr->lv_niovecs = 2;
 	lvhdr->lv_iovecp = &hdr->lhdr[0];
 	lvhdr->lv_bytes = hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
-	lvhdr->lv_next = ctx->lv_chain;
 
 	tic->t_curr_res -= lvhdr->lv_bytes;
 }
@@ -920,25 +919,23 @@ xlog_cil_push_work(
 	xlog_cil_pcp_aggregate(cil, ctx);
 
 	list_sort(NULL, &ctx->log_items, xlog_cil_order_cmp);
-
 	while (!list_empty(&ctx->log_items)) {
 		struct xfs_log_item	*item;
 
 		item = list_first_entry(&ctx->log_items,
 					struct xfs_log_item, li_cil);
+		lv = item->li_lv;
 		list_del_init(&item->li_cil);
 		item->li_order_id = 0;
-		if (!ctx->lv_chain)
-			ctx->lv_chain = item->li_lv;
-		else
-			lv->lv_next = item->li_lv;
-		lv = item->li_lv;
 		item->li_lv = NULL;
-		num_iovecs += lv->lv_niovecs;
 
+		num_iovecs += lv->lv_niovecs;
 		/* we don't write ordered log vectors */
 		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
 			num_bytes += lv->lv_bytes;
+
+		list_add_tail(&lv->lv_list, &ctx->lv_chain);
+
 	}
 
 	/*
@@ -975,9 +972,12 @@ xlog_cil_push_work(
 	 * Build a checkpoint transaction header and write it to the log to
 	 * begin the transaction. We need to account for the space used by the
 	 * transaction header here as it is not accounted for in xlog_write().
+	 * Add the lvhdr to the head of the lv chain we pass to xlog_write() so
+	 * it gets written into the iclog first.
 	 */
 	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
 	num_bytes += lvhdr.lv_bytes;
+	list_add(&lvhdr.lv_list, &ctx->lv_chain);
 
 	/*
 	 * Before we format and submit the first iclog, we have to ensure that
@@ -991,8 +991,14 @@ xlog_cil_push_work(
 	 * use the commit record lsn then we can move the tail beyond the grant
 	 * write head.
 	 */
-	error = xlog_write(log, &lvhdr, ctx->ticket, &ctx->start_lsn, NULL,
-				num_bytes);
+	error = xlog_write(log, &ctx->lv_chain, ctx->ticket, &ctx->start_lsn,
+				NULL, num_bytes);
+
+	/*
+	 * Take the lvhdr back off the lv_chain as it should not be passed
+	 * to log IO completion.
+	 */
+	list_del(&lvhdr.lv_list);
 	if (error)
 		goto out_abort_free_ticket;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index d3bf3b367370..071367a96d8d 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -221,7 +221,7 @@ struct xfs_cil_ctx {
 	atomic_t		space_used;	/* aggregate size of regions */
 	struct list_head	busy_extents;	/* busy extents in chkpt */
 	struct list_head	log_items;	/* log items in chkpt */
-	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
+	struct list_head	lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
 	struct work_struct	discard_endio_work;
@@ -477,7 +477,7 @@ xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
 
 void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
-int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
+int	xlog_write(struct xlog *log, struct list_head *lv_chain,
 		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
 		struct xlog_in_core **commit_iclog, uint32_t len);
 int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bc72826d1f97..0f8300adb12d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -735,7 +735,7 @@ xfs_log_item_batch_insert(
 void
 xfs_trans_committed_bulk(
 	struct xfs_ail		*ailp,
-	struct xfs_log_vec	*log_vector,
+	struct list_head	*lv_chain,
 	xfs_lsn_t		commit_lsn,
 	bool			aborted)
 {
@@ -750,7 +750,7 @@ xfs_trans_committed_bulk(
 	spin_unlock(&ailp->ail_lock);
 
 	/* unpin all the log items */
-	for (lv = log_vector; lv; lv = lv->lv_next ) {
+	list_for_each_entry(lv, lv_chain, lv_list) {
 		struct xfs_log_item	*lip = lv->lv_item;
 		xfs_lsn_t		item_lsn;
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 3004aeac9110..fc8667c728e3 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -18,7 +18,8 @@ void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
-void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
+void	xfs_trans_committed_bulk(struct xfs_ail *ailp,
+				struct list_head *lv_chain,
 				xfs_lsn_t commit_lsn, bool aborted);
 /*
  * AIL traversal cursor.
-- 
2.31.1

