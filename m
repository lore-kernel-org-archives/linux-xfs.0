Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC70CCA473
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 07:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343555AbiFOHxq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343588AbiFOHxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 03:53:39 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A202841989
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 00:53:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 97BA810E74FA
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 17:53:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-006rRF-OE
        for linux-xfs@vger.kernel.org; Wed, 15 Jun 2022 17:53:32 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-00FJy1-NE
        for linux-xfs@vger.kernel.org;
        Wed, 15 Jun 2022 17:53:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/14] xfs: convert CIL busy extents to per-cpu
Date:   Wed, 15 Jun 2022 17:53:23 +1000
Message-Id: <20220615075330.3651541-8-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615075330.3651541-1-david@fromorbit.com>
References: <20220615075330.3651541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a98ffe
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=vUsicihHAahmRoZZVqUA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To get them out from under the CIL lock.

This is an unordered list, so we can simply punt it to per-cpu lists
during transaction commits and reaggregate it back into a single
list during the CIL push work.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index e38e10082da2..f02a75d5a03e 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -128,6 +128,11 @@ xlog_cil_push_pcp_aggregate(
 		ctx->ticket->t_curr_res += cilpcp->space_reserved;
 		cilpcp->space_reserved = 0;
 
+		if (!list_empty(&cilpcp->busy_extents)) {
+			list_splice_init(&cilpcp->busy_extents,
+					&ctx->busy_extents);
+		}
+
 		/*
 		 * We're in the middle of switching cil contexts.  Reset the
 		 * counter we use to detect when the current context is nearing
@@ -634,6 +639,9 @@ xlog_cil_insert_items(
 	} else {
 		cilpcp->space_used += len;
 	}
+	/* attach the transaction to the CIL if it has any busy extents */
+	if (!list_empty(&tp->t_busy))
+		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
 	put_cpu_ptr(cilpcp);
 
 	/*
@@ -656,9 +664,6 @@ xlog_cil_insert_items(
 			list_move_tail(&lip->li_cil, &cil->xc_cil);
 	}
 
-	/* attach the transaction to the CIL if it has any busy extents */
-	if (!list_empty(&tp->t_busy))
-		list_splice_init(&tp->t_busy, &ctx->busy_extents);
 	spin_unlock(&cil->xc_cil_lock);
 
 	/*
@@ -1756,6 +1761,8 @@ xlog_cil_pcp_dead(
 		ctx->ticket->t_curr_res += cilpcp->space_reserved;
 	cilpcp->space_reserved = 0;
 
+	if (!list_empty(&cilpcp->busy_extents))
+		list_splice_init(&cilpcp->busy_extents, &ctx->busy_extents);
 	atomic_add(cilpcp->space_used, &ctx->space_used);
 	cilpcp->space_used = 0;
 	up_write(&cil->xc_ctx_lock);
@@ -1766,10 +1773,12 @@ xlog_cil_pcp_dead(
  */
 int
 xlog_cil_init(
-	struct xlog	*log)
+	struct xlog		*log)
 {
-	struct xfs_cil	*cil;
-	struct xfs_cil_ctx *ctx;
+	struct xfs_cil		*cil;
+	struct xfs_cil_ctx	*ctx;
+	struct xlog_cil_pcp	*cilpcp;
+	int			cpu;
 
 	cil = kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
 	if (!cil)
@@ -1789,6 +1798,11 @@ xlog_cil_init(
 	if (!cil->xc_pcp)
 		goto out_destroy_wq;
 
+	for_each_possible_cpu(cpu) {
+		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+		INIT_LIST_HEAD(&cilpcp->busy_extents);
+	}
+
 	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
-- 
2.35.1

