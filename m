Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD540C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 07:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbiFOHxk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245255AbiFOHxg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 03:53:36 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA4E641335
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 00:53:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1DD4710E74EC
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 17:53:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-006rR4-Ig
        for linux-xfs@vger.kernel.org; Wed, 15 Jun 2022 17:53:32 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-00FJxc-Hl
        for linux-xfs@vger.kernel.org;
        Wed, 15 Jun 2022 17:53:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/14] xfs: lift init CIL reservation out of xc_cil_lock
Date:   Wed, 15 Jun 2022 17:53:18 +1000
Message-Id: <20220615075330.3651541-3-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615075330.3651541-1-david@fromorbit.com>
References: <20220615075330.3651541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a98ffe
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=63avsRBh0cCWs8EafugA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The xc_cil_lock is the most highly contended lock in XFS now. To
start the process of getting rid of it, lift the initial reservation
of the CIL log space out from under the xc_cil_lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 36c0ce77d41b..8a83d901e465 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -462,23 +462,19 @@ xlog_cil_insert_items(
 	 */
 	xlog_cil_insert_format_items(log, tp, &len);
 
-	spin_lock(&cil->xc_cil_lock);
-
-	/* attach the transaction to the CIL if it has any busy extents */
-	if (!list_empty(&tp->t_busy))
-		list_splice_init(&tp->t_busy, &ctx->busy_extents);
-
 	/*
 	 * We need to take the CIL checkpoint unit reservation on the first
 	 * commit into the CIL. Test the XLOG_CIL_EMPTY bit first so we don't
-	 * unnecessarily do an atomic op in the fast path here.
+	 * unnecessarily do an atomic op in the fast path here. We don't need to
+	 * hold the xc_cil_lock here to clear the XLOG_CIL_EMPTY bit as we are
+	 * under the xc_ctx_lock here and that needs to be held exclusively to
+	 * reset the XLOG_CIL_EMPTY bit.
 	 */
 	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags) &&
-	    test_and_clear_bit(XLOG_CIL_EMPTY, &cil->xc_flags)) {
+	    test_and_clear_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
 		ctx_res = ctx->ticket->t_unit_res;
-		ctx->ticket->t_curr_res = ctx_res;
-		tp->t_ticket->t_curr_res -= ctx_res;
-	}
+
+	spin_lock(&cil->xc_cil_lock);
 
 	/* do we need space for more log record headers? */
 	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
@@ -488,13 +484,12 @@ xlog_cil_insert_items(
 		/* need to take into account split region headers, too */
 		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
 		ctx->ticket->t_unit_res += split_res;
-		ctx->ticket->t_curr_res += split_res;
-		tp->t_ticket->t_curr_res -= split_res;
-		ASSERT(tp->t_ticket->t_curr_res >= len);
 	}
-	tp->t_ticket->t_curr_res -= len;
-	tp->t_ticket->t_curr_res += released_space;
+	tp->t_ticket->t_curr_res -= split_res + ctx_res + len;
+	ctx->ticket->t_curr_res += split_res + ctx_res;
 	ctx->space_used += len;
+
+	tp->t_ticket->t_curr_res += released_space;
 	ctx->space_used -= released_space;
 
 	/*
@@ -532,6 +527,9 @@ xlog_cil_insert_items(
 			list_move_tail(&lip->li_cil, &cil->xc_cil);
 	}
 
+	/* attach the transaction to the CIL if it has any busy extents */
+	if (!list_empty(&tp->t_busy))
+		list_splice_init(&tp->t_busy, &ctx->busy_extents);
 	spin_unlock(&cil->xc_cil_lock);
 
 	if (tp->t_ticket->t_curr_res < 0)
-- 
2.35.1

