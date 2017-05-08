Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753044AbdEHUpJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 May 2017 16:45:09 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 399C3C0567A1
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2017 20:45:09 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 090CA7CE17
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2017 20:45:09 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/3] xfs: refactor xlog_cil_insert_items() to facilitate transaction dump
Date: Mon,  8 May 2017 16:45:06 -0400
Message-Id: <1494276307-36887-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1494276307-36887-1-git-send-email-bfoster@redhat.com>
References: <1494276307-36887-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Transaction reservation overrun detection currently occurs too late
to print useful information about the offending transaction.
Ideally, the transaction data is printed before the associated log
items are moved from the transaction to the CIL, which occurs in
xlog_cil_insert_items(), such that details of the items logged by
the transaction are available for analysis.

Refactor xlog_cil_insert_items() to facilitate moving tx overrun
detection to this function. Update the function to track each bit of
extra log reservation stolen from the transaction (i.e., such as for
the CIL context ticket) and perform the log item migration as the
last operation before the CIL lock is released. This creates a
context where the transaction reservation consumption has been fully
calculated when the log items are moved to the CIL. This patch makes
no functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 62 +++++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 52fe042..8de3baa 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -410,6 +410,7 @@ xlog_cil_insert_items(
 	int			len = 0;
 	int			diff_iovecs = 0;
 	int			iclog_space;
+	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
 
 	ASSERT(tp);
 
@@ -419,30 +420,11 @@ xlog_cil_insert_items(
 	 */
 	xlog_cil_insert_format_items(log, tp, &len, &diff_iovecs);
 
-	/*
-	 * Now (re-)position everything modified at the tail of the CIL.
-	 * We do this here so we only need to take the CIL lock once during
-	 * the transaction commit.
-	 */
 	spin_lock(&cil->xc_cil_lock);
-	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
-		struct xfs_log_item	*lip = lidp->lid_item;
-
-		/* Skip items which aren't dirty in this transaction. */
-		if (!(lidp->lid_flags & XFS_LID_DIRTY))
-			continue;
-
-		/*
-		 * Only move the item if it isn't already at the tail. This is
-		 * to prevent a transient list_empty() state when reinserting
-		 * an item that is already the only item in the CIL.
-		 */
-		if (!list_is_last(&lip->li_cil, &cil->xc_cil))
-			list_move_tail(&lip->li_cil, &cil->xc_cil);
-	}
 
 	/* account for space used by new iovec headers  */
-	len += diff_iovecs * sizeof(xlog_op_header_t);
+	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t);
+	len += iovhdr_res;
 	ctx->nvecs += diff_iovecs;
 
 	/* attach the transaction to the CIL if it has any busy extents */
@@ -457,27 +439,47 @@ xlog_cil_insert_items(
 	 * during the transaction commit.
 	 */
 	if (ctx->ticket->t_curr_res == 0) {
-		ctx->ticket->t_curr_res = ctx->ticket->t_unit_res;
-		tp->t_ticket->t_curr_res -= ctx->ticket->t_unit_res;
+		ctx_res = ctx->ticket->t_unit_res;
+		ctx->ticket->t_curr_res = ctx_res;
+		tp->t_ticket->t_curr_res -= ctx_res;
 	}
 
 	/* do we need space for more log record headers? */
 	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
 	if (len > 0 && (ctx->space_used / iclog_space !=
 				(ctx->space_used + len) / iclog_space)) {
-		int hdrs;
-
-		hdrs = (len + iclog_space - 1) / iclog_space;
+		split_res = (len + iclog_space - 1) / iclog_space;
 		/* need to take into account split region headers, too */
-		hdrs *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
-		ctx->ticket->t_unit_res += hdrs;
-		ctx->ticket->t_curr_res += hdrs;
-		tp->t_ticket->t_curr_res -= hdrs;
+		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
+		ctx->ticket->t_unit_res += split_res;
+		ctx->ticket->t_curr_res += split_res;
+		tp->t_ticket->t_curr_res -= split_res;
 		ASSERT(tp->t_ticket->t_curr_res >= len);
 	}
 	tp->t_ticket->t_curr_res -= len;
 	ctx->space_used += len;
 
+	/*
+	 * Now (re-)position everything modified at the tail of the CIL.
+	 * We do this here so we only need to take the CIL lock once during
+	 * the transaction commit.
+	 */
+	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
+		struct xfs_log_item	*lip = lidp->lid_item;
+
+		/* Skip items which aren't dirty in this transaction. */
+		if (!(lidp->lid_flags & XFS_LID_DIRTY))
+			continue;
+
+		/*
+		 * Only move the item if it isn't already at the tail. This is
+		 * to prevent a transient list_empty() state when reinserting
+		 * an item that is already the only item in the CIL.
+		 */
+		if (!list_is_last(&lip->li_cil, &cil->xc_cil))
+			list_move_tail(&lip->li_cil, &cil->xc_cil);
+	}
+
 	spin_unlock(&cil->xc_cil_lock);
 }
 
-- 
2.7.4

