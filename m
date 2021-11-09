Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1540FC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10C861105
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240313AbhKIBxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:53:48 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:49164 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240381AbhKIBxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:53:46 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 17D4946CA4F
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:50:58 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006ZYF-Bw
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:50:58 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006Ucw-AP
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:50:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/16] xfs: pass lv chain length into xlog_write()
Date:   Tue,  9 Nov 2021 12:50:48 +1100
Message-Id: <20211109015055.1547604-10-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015055.1547604-1-david@fromorbit.com>
References: <20211109015055.1547604-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6189d403
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=r1RjEeUhuTgk3y8VTxQA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The caller of xlog_write() usually has a close accounting of the
aggregated vector length contained in the log vector chain passed to
xlog_write(). There is no need to iterate the chain to calculate he
length of the data in xlog_write_calculate_len() if the caller is
already iterating that chain to build it.

Passing in the vector length avoids doing an extra chain iteration,
which can be a significant amount of work given that large CIL
commits can have hundreds of thousands of vectors attached to the
chain.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 35 +++++------------------------------
 fs/xfs/xfs_log_cil.c  | 25 +++++++++++++++++--------
 fs/xfs/xfs_log_priv.h |  2 +-
 3 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bd2e50804cb4..76d5a743f6fb 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -972,7 +972,8 @@ xlog_write_unmount_record(
 	/* account for space used by record data */
 	ticket->t_curr_res -= sizeof(unmount_rec);
 
-	return xlog_write(log, NULL, &vec, ticket, XLOG_UNMOUNT_TRANS);
+	return xlog_write(log, NULL, &vec, ticket, XLOG_UNMOUNT_TRANS,
+			reg.i_len);
 }
 
 /*
@@ -2223,32 +2224,6 @@ xlog_print_trans(
 	}
 }
 
-/*
- * Calculate the potential space needed by the log vector. All regions contain
- * their own opheaders and they are accounted for in region space so we don't
- * need to add them to the vector length here.
- */
-static int
-xlog_write_calc_vec_length(
-	struct xlog_ticket	*ticket,
-	struct xfs_log_vec	*log_vector,
-	uint			optype)
-{
-	struct xfs_log_vec	*lv;
-	int			len = 0;
-	int			i;
-
-	for (lv = log_vector; lv; lv = lv->lv_next) {
-		/* we don't write ordered log vectors */
-		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
-			continue;
-
-		for (i = 0; i < lv->lv_niovecs; i++)
-			len += lv->lv_iovecp[i].i_len;
-	}
-	return len;
-}
-
 static xlog_op_header_t *
 xlog_write_setup_ophdr(
 	struct xlog_op_header	*ophdr,
@@ -2402,13 +2377,14 @@ xlog_write(
 	struct xfs_cil_ctx	*ctx,
 	struct xfs_log_vec	*log_vector,
 	struct xlog_ticket	*ticket,
-	uint			optype)
+	uint			optype,
+	uint32_t		len)
+
 {
 	struct xlog_in_core	*iclog = NULL;
 	struct xfs_log_vec	*lv = log_vector;
 	struct xfs_log_iovec	*vecp = lv->lv_iovecp;
 	int			index = 0;
-	int			len;
 	int			partial_copy = 0;
 	int			partial_copy_len = 0;
 	int			contwr = 0;
@@ -2423,7 +2399,6 @@ xlog_write(
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	}
 
-	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
 	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
 		void		*ptr;
 		int		log_offset;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index dc49b8072b9b..00243939b220 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -791,7 +791,8 @@ xlog_cil_order_write(
 static int
 xlog_cil_write_chain(
 	struct xfs_cil_ctx	*ctx,
-	struct xfs_log_vec	*chain)
+	struct xfs_log_vec	*chain,
+	uint32_t		chain_len)
 {
 	struct xlog		*log = ctx->cil->xc_log;
 	int			error;
@@ -799,7 +800,8 @@ xlog_cil_write_chain(
 	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _START_RECORD);
 	if (error)
 		return error;
-	return xlog_write(log, ctx, chain, ctx->ticket, XLOG_START_TRANS);
+	return xlog_write(log, ctx, chain, ctx->ticket, XLOG_START_TRANS,
+			chain_len);
 }
 
 /*
@@ -838,7 +840,8 @@ xlog_cil_write_commit_record(
 
 	/* account for space used by record data */
 	ctx->ticket->t_curr_res -= reg.i_len;
-	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS);
+	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS,
+			reg.i_len);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
@@ -900,11 +903,12 @@ xlog_cil_build_trans_hdr(
 				sizeof(struct xfs_trans_header);
 	hdr->lhdr[1].i_type = XLOG_REG_TYPE_TRANSHDR;
 
-	tic->t_curr_res -= hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
-
 	lvhdr->lv_niovecs = 2;
 	lvhdr->lv_iovecp = &hdr->lhdr[0];
+	lvhdr->lv_bytes = hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
 	lvhdr->lv_next = ctx->lv_chain;
+
+	tic->t_curr_res -= lvhdr->lv_bytes;
 }
 
 /*
@@ -931,7 +935,8 @@ xlog_cil_push_work(
 	struct xlog		*log = cil->xc_log;
 	struct xfs_log_vec	*lv;
 	struct xfs_cil_ctx	*new_ctx;
-	int			num_iovecs;
+	int			num_iovecs = 0;
+	int			num_bytes = 0;
 	int			error = 0;
 	struct xlog_cil_trans_hdr thdr;
 	struct xfs_log_vec	lvhdr = { NULL };
@@ -1032,7 +1037,6 @@ xlog_cil_push_work(
 	 * by the flush lock.
 	 */
 	lv = NULL;
-	num_iovecs = 0;
 	while (!list_empty(&cil->xc_cil)) {
 		struct xfs_log_item	*item;
 
@@ -1046,6 +1050,10 @@ xlog_cil_push_work(
 		lv = item->li_lv;
 		item->li_lv = NULL;
 		num_iovecs += lv->lv_niovecs;
+
+		/* we don't write ordered log vectors */
+		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
+			num_bytes += lv->lv_bytes;
 	}
 
 	/*
@@ -1084,6 +1092,7 @@ xlog_cil_push_work(
 	 * transaction header here as it is not accounted for in xlog_write().
 	 */
 	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
+	num_bytes += lvhdr.lv_bytes;
 
 	/*
 	 * Before we format and submit the first iclog, we have to ensure that
@@ -1091,7 +1100,7 @@ xlog_cil_push_work(
 	 */
 	wait_for_completion(&bdev_flush);
 
-	error = xlog_cil_write_chain(ctx, &lvhdr);
+	error = xlog_cil_write_chain(ctx, &lvhdr, num_bytes);
 	if (error)
 		goto out_abort_free_ticket;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 47165c4d2a49..56df86d62430 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -492,7 +492,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
 		struct xfs_log_vec *log_vector, struct xlog_ticket *tic,
-		uint optype);
+		uint optype, uint32_t len);
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
-- 
2.33.0

