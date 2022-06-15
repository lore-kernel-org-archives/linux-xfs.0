Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F7FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 07:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343550AbiFOHxm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343518AbiFOHxi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 03:53:38 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 126C741617
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 00:53:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 829E410E74F5
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 17:53:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-006rRE-NL
        for linux-xfs@vger.kernel.org; Wed, 15 Jun 2022 17:53:32 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-00FJxu-MB
        for linux-xfs@vger.kernel.org;
        Wed, 15 Jun 2022 17:53:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/14] xfs: track CIL ticket reservation in percpu structure
Date:   Wed, 15 Jun 2022 17:53:22 +1000
Message-Id: <20220615075330.3651541-7-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615075330.3651541-1-david@fromorbit.com>
References: <20220615075330.3651541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a98ffe
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=vUsicihHAahmRoZZVqUA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To get it out from under the cil spinlock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c  | 16 ++++++++++++----
 fs/xfs/xfs_log_priv.h |  1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 2d16add7a8d4..e38e10082da2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -125,6 +125,9 @@ xlog_cil_push_pcp_aggregate(
 	for_each_online_cpu(cpu) {
 		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
 
+		ctx->ticket->t_curr_res += cilpcp->space_reserved;
+		cilpcp->space_reserved = 0;
+
 		/*
 		 * We're in the middle of switching cil contexts.  Reset the
 		 * counter we use to detect when the current context is nearing
@@ -608,6 +611,7 @@ xlog_cil_insert_items(
 			ctx_res = split_res * tp->t_ticket->t_iclog_hdrs;
 		atomic_sub(tp->t_ticket->t_iclog_hdrs, &cil->xc_iclog_hdrs);
 	}
+	cilpcp->space_reserved += ctx_res;
 
 	/*
 	 * Accurately account when over the soft limit, otherwise fold the
@@ -632,14 +636,12 @@ xlog_cil_insert_items(
 	}
 	put_cpu_ptr(cilpcp);
 
-	spin_lock(&cil->xc_cil_lock);
-	ctx->ticket->t_curr_res += ctx_res;
-
 	/*
 	 * Now (re-)position everything modified at the tail of the CIL.
 	 * We do this here so we only need to take the CIL lock once during
 	 * the transaction commit.
 	 */
+	spin_lock(&cil->xc_cil_lock);
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		/* Skip items which aren't dirty in this transaction. */
 		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
@@ -1746,9 +1748,15 @@ xlog_cil_pcp_dead(
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+	struct xfs_cil_ctx	*ctx;
 
 	down_write(&cil->xc_ctx_lock);
-	atomic_add(cilpcp->space_used, &cil->xc_ctx->space_used);
+	ctx = cil->xc_ctx;
+	if (ctx->ticket)
+		ctx->ticket->t_curr_res += cilpcp->space_reserved;
+	cilpcp->space_reserved = 0;
+
+	atomic_add(cilpcp->space_used, &ctx->space_used);
 	cilpcp->space_used = 0;
 	up_write(&cil->xc_ctx_lock);
 }
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f4c13704ef8c..05a5668d8789 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -236,6 +236,7 @@ struct xfs_cil_ctx {
  */
 struct xlog_cil_pcp {
 	int32_t			space_used;
+	uint32_t		space_reserved;
 	struct list_head	busy_extents;
 	struct list_head	log_items;
 };
-- 
2.35.1

