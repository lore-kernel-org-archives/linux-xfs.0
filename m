Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B13FC2B9FB
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26565611AE
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353395AbhESMOx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:14:53 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:49007 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353402AbhESMOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:46 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 025FA1AFDE9
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m1r-Hp
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002SHw-AD
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 31/39] xfs: track CIL ticket reservation in percpu structure
Date:   Wed, 19 May 2021 22:13:09 +1000
Message-Id: <20210519121317.585244-32-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=Wp8qEqptLqL0ODnh_0MA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To get it out from under the cil spinlock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c  | 20 +++++++++++++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 72693fba929b..4ddc302a766b 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -90,6 +90,10 @@ xlog_cil_pcp_aggregate(
 
 	for_each_online_cpu(cpu) {
 		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+
+		ctx->ticket->t_curr_res += cilpcp->space_reserved;
+		ctx->ticket->t_unit_res += cilpcp->space_reserved;
+		cilpcp->space_reserved = 0;
 		cilpcp->space_used = 0;
 	}
 }
@@ -510,6 +514,7 @@ xlog_cil_insert_items(
 	 * based on how close we are to the hard limit.
 	 */
 	cilpcp = get_cpu_ptr(cil->xc_pcp);
+	cilpcp->space_reserved += ctx_res;
 	cilpcp->space_used += len;
 	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
 	    cilpcp->space_used >
@@ -520,10 +525,6 @@ xlog_cil_insert_items(
 	}
 	put_cpu_ptr(cilpcp);
 
-	spin_lock(&cil->xc_cil_lock);
-	ctx->ticket->t_unit_res += ctx_res;
-	ctx->ticket->t_curr_res += ctx_res;
-
 	/*
 	 * If we've overrun the reservation, dump the tx details before we move
 	 * the log items. Shutdown is imminent...
@@ -545,6 +546,7 @@ xlog_cil_insert_items(
 	 * We do this here so we only need to take the CIL lock once during
 	 * the transaction commit.
 	 */
+	spin_lock(&cil->xc_cil_lock);
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 
 		/* Skip items which aren't dirty in this transaction. */
@@ -1434,12 +1436,20 @@ xlog_cil_pcp_dead(
 	spin_lock(&xlog_cil_pcp_lock);
 	list_for_each_entry_safe(cil, n, &xlog_cil_pcp_list, xc_pcp_list) {
 		struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+		struct xfs_cil_ctx	*ctx;
 
 		spin_unlock(&xlog_cil_pcp_lock);
 		down_write(&cil->xc_ctx_lock);
+		ctx = cil->xc_ctx;
+
+		atomic_add(cilpcp->space_used, &ctx->space_used);
+		if (ctx->ticket) {
+			ctx->ticket->t_curr_res += cilpcp->space_reserved;
+			ctx->ticket->t_unit_res += cilpcp->space_reserved;
+		}
 
-		atomic_add(cilpcp->space_used, &cil->xc_ctx->space_used);
 		cilpcp->space_used = 0;
+		cilpcp->space_reserved = 0;
 
 		up_write(&cil->xc_ctx_lock);
 		spin_lock(&xlog_cil_pcp_lock);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 7dc6275818de..b80cb3a0edb7 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -232,7 +232,7 @@ struct xfs_cil_ctx {
  */
 struct xlog_cil_pcp {
 	uint32_t		space_used;
-	uint32_t		curr_res;
+	uint32_t		space_reserved;
 	struct list_head	busy_extents;
 	struct list_head	log_items;
 };
-- 
2.31.1

