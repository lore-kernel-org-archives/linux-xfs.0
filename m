Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFA6C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6379664EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhBYDiK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 22:38:10 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58520 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232276AbhBYDiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 22:38:08 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 1E6081AD7AB
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 14:37:27 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-0038At-FP
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-00EvjN-83
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/12] xfs: track CIL ticket reservation in percpu structure
Date:   Thu, 25 Feb 2021 14:37:19 +1100
Message-Id: <20210225033725.3558450-7-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210225033725.3558450-1-david@fromorbit.com>
References: <20210225033725.3558450-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=OVMH6THyl8vKEaUu_IkA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To get it out from under the cil spinlock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c  | 11 ++++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 68998416b388..65685889a9c3 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -492,6 +492,7 @@ xlog_cil_insert_items(
 	 * based on how close we are to the hard limit.
 	 */
 	cilpcp = get_cpu_ptr(cil->xc_pcp);
+	cilpcp->space_reserved += ctx_res;
 	cilpcp->space_used += len;
 	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
 	    cilpcp->space_used >
@@ -502,10 +503,6 @@ xlog_cil_insert_items(
 	}
 	put_cpu_ptr(cilpcp);
 
-	spin_lock(&cil->xc_cil_lock);
-	ctx->ticket->t_unit_res += ctx_res;
-	ctx->ticket->t_curr_res += ctx_res;
-
 	/*
 	 * If we've overrun the reservation, dump the tx details before we move
 	 * the log items. Shutdown is imminent...
@@ -527,6 +524,7 @@ xlog_cil_insert_items(
 	 * We do this here so we only need to take the CIL lock once during
 	 * the transaction commit.
 	 */
+	spin_lock(&cil->xc_cil_lock);
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 
 		/* Skip items which aren't dirty in this transaction. */
@@ -797,10 +795,13 @@ xlog_cil_push_work(
 
 	down_write(&cil->xc_ctx_lock);
 
-	/* Reset the CIL pcp counters */
+	/* Aggregate and reset the CIL pcp counters */
 	for_each_online_cpu(cpu) {
 		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+		ctx->ticket->t_curr_res += cilpcp->space_reserved;
 		cilpcp->space_used = 0;
+		cilpcp->space_reserved = 0;
+
 	}
 
 	spin_lock(&cil->xc_push_lock);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 76413315913a..ab933faacbad 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -236,7 +236,7 @@ struct xfs_cil_ctx {
  */
 struct xlog_cil_pcp {
 	uint32_t		space_used;
-	uint32_t		curr_res;
+	uint32_t		space_reserved;
 	struct list_head	busy_extents;
 	struct list_head	log_items;
 };
-- 
2.28.0

