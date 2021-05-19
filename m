Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563AEC2B9F6
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 380E0611AE
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353392AbhESMOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:14:51 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:43269 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353395AbhESMOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:45 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 1095B11403A2
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:21 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m1t-IT
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002SHz-B7
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 32/39] xfs: convert CIL busy extents to per-cpu
Date:   Wed, 19 May 2021 22:13:10 +1000
Message-Id: <20210519121317.585244-33-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=3A6U50GPjzoxoPTa4dIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To get them out from under the CIL lock.

This is an unordered list, so we can simply punt it to per-cpu lists
during transaction commits and reaggregate it back into a single
list during the CIL push work.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 4ddc302a766b..b12a2f9ba23a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -93,6 +93,11 @@ xlog_cil_pcp_aggregate(
 
 		ctx->ticket->t_curr_res += cilpcp->space_reserved;
 		ctx->ticket->t_unit_res += cilpcp->space_reserved;
+		if (!list_empty(&cilpcp->busy_extents)) {
+			list_splice_init(&cilpcp->busy_extents,
+					&ctx->busy_extents);
+		}
+
 		cilpcp->space_reserved = 0;
 		cilpcp->space_used = 0;
 	}
@@ -523,6 +528,9 @@ xlog_cil_insert_items(
 		atomic_add(cilpcp->space_used, &ctx->space_used);
 		cilpcp->space_used = 0;
 	}
+	/* attach the transaction to the CIL if it has any busy extents */
+	if (!list_empty(&tp->t_busy))
+		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
 	put_cpu_ptr(cilpcp);
 
 	/*
@@ -562,9 +570,6 @@ xlog_cil_insert_items(
 			list_move_tail(&lip->li_cil, &cil->xc_cil);
 	}
 
-	/* attach the transaction to the CIL if it has any busy extents */
-	if (!list_empty(&tp->t_busy))
-		list_splice_init(&tp->t_busy, &ctx->busy_extents);
 	spin_unlock(&cil->xc_cil_lock);
 
 	if (tp->t_ticket->t_curr_res < 0)
@@ -1447,6 +1452,10 @@ xlog_cil_pcp_dead(
 			ctx->ticket->t_curr_res += cilpcp->space_reserved;
 			ctx->ticket->t_unit_res += cilpcp->space_reserved;
 		}
+		if (!list_empty(&cilpcp->busy_extents)) {
+			list_splice_init(&cilpcp->busy_extents,
+					&ctx->busy_extents);
+		}
 
 		cilpcp->space_used = 0;
 		cilpcp->space_reserved = 0;
@@ -1502,7 +1511,9 @@ static void __percpu *
 xlog_cil_pcp_alloc(
 	struct xfs_cil		*cil)
 {
+	struct xlog_cil_pcp	*cilpcp;
 	void __percpu		*pcp;
+	int			cpu;
 
 	pcp = alloc_percpu(struct xlog_cil_pcp);
 	if (!pcp)
@@ -1512,6 +1523,11 @@ xlog_cil_pcp_alloc(
 		free_percpu(pcp);
 		return NULL;
 	}
+
+	for_each_possible_cpu(cpu) {
+		cilpcp = per_cpu_ptr(pcp, cpu);
+		INIT_LIST_HEAD(&cilpcp->busy_extents);
+	}
 	return pcp;
 }
 
-- 
2.31.1

