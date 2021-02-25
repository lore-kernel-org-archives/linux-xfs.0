Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E284C4332E
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F5064EF1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhBYDiO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 22:38:14 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57568 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232870AbhBYDiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 22:38:09 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1B36882819B
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 14:37:27 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-0038Af-AR
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-00EvjB-3F
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/12] xfs: lift init CIL reservation out of xc_cil_lock
Date:   Thu, 25 Feb 2021 14:37:15 +1100
Message-Id: <20210225033725.3558450-3-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210225033725.3558450-1-david@fromorbit.com>
References: <20210225033725.3558450-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=63avsRBh0cCWs8EafugA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The xc_cil_lock is the most highly contended lock in XFS now. To
start the process of getting rid of it, lift the initial reservation
of the CIL log space out from under the xc_cil_lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index d6a19d0047f0..5799978eaee2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -430,23 +430,19 @@ xlog_cil_insert_items(
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
@@ -456,11 +452,9 @@ xlog_cil_insert_items(
 		/* need to take into account split region headers, too */
 		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
 		ctx->ticket->t_unit_res += split_res;
-		ctx->ticket->t_curr_res += split_res;
-		tp->t_ticket->t_curr_res -= split_res;
-		ASSERT(tp->t_ticket->t_curr_res >= len);
 	}
-	tp->t_ticket->t_curr_res -= len;
+	tp->t_ticket->t_curr_res -= split_res + ctx_res + len;
+	ctx->ticket->t_curr_res += split_res + ctx_res;
 	ctx->space_used += len;
 
 	/*
@@ -498,6 +492,9 @@ xlog_cil_insert_items(
 			list_move_tail(&lip->li_cil, &cil->xc_cil);
 	}
 
+	/* attach the transaction to the CIL if it has any busy extents */
+	if (!list_empty(&tp->t_busy))
+		list_splice_init(&tp->t_busy, &ctx->busy_extents);
 	spin_unlock(&cil->xc_cil_lock);
 
 	if (tp->t_ticket->t_curr_res < 0)
-- 
2.28.0

