Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24893C43217
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0805461105
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240965AbhKIBzd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:55:33 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:48953 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241385AbhKIBzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:55:31 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id A75DF101476
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:52:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006Za9-1M
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:52:44 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJX-006Uif-W7
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:52:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/14] xfs: track CIL ticket reservation in percpu structure
Date:   Tue,  9 Nov 2021 12:52:32 +1100
Message-Id: <20211109015240.1547991-7-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015240.1547991-1-david@fromorbit.com>
References: <20211109015240.1547991-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6189d46c
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=vUsicihHAahmRoZZVqUA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To get it out from under the cil spinlock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c  | 20 +++++++++++++++-----
 fs/xfs/xfs_log_priv.h |  1 +
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index ddc8d262d9f9..74717bdd992b 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -91,6 +91,10 @@ xlog_cil_pcp_aggregate(
 	for_each_online_cpu(cpu) {
 		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
 
+		ctx->ticket->t_curr_res += cilpcp->space_reserved;
+		ctx->ticket->t_unit_res += cilpcp->space_reserved;
+		cilpcp->space_reserved = 0;
+
 		/*
 		 * We're in the middle of switching cil contexts.  Reset the
 		 * counter we use to detect when the current context is nearing
@@ -524,6 +528,7 @@ xlog_cil_insert_items(
 	 * based on how close we are to the hard limit.
 	 */
 	cilpcp = get_cpu_ptr(cil->xc_pcp);
+	cilpcp->space_reserved += ctx_res;
 	cilpcp->space_used += len;
 	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
 	    cilpcp->space_used >
@@ -534,10 +539,6 @@ xlog_cil_insert_items(
 	}
 	put_cpu_ptr(cilpcp);
 
-	spin_lock(&cil->xc_cil_lock);
-	ctx->ticket->t_unit_res += ctx_res;
-	ctx->ticket->t_curr_res += ctx_res;
-
 	/*
 	 * If we've overrun the reservation, dump the tx details before we move
 	 * the log items. Shutdown is imminent...
@@ -559,6 +560,7 @@ xlog_cil_insert_items(
 	 * We do this here so we only need to take the CIL lock once during
 	 * the transaction commit.
 	 */
+	spin_lock(&cil->xc_cil_lock);
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 
 		/* Skip items which aren't dirty in this transaction. */
@@ -1600,9 +1602,17 @@ xlog_cil_pcp_dead(
 {
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+	struct xfs_cil_ctx	*ctx;
 
 	down_write(&cil->xc_ctx_lock);
-	atomic_add(cilpcp->space_used, &cil->xc_ctx->space_used);
+	ctx = cil->xc_ctx;
+	if (ctx->ticket) {
+		ctx->ticket->t_curr_res += cilpcp->space_reserved;
+		ctx->ticket->t_unit_res += cilpcp->space_reserved;
+	}
+	cilpcp->space_reserved = 0;
+
+	atomic_add(cilpcp->space_used, &ctx->space_used);
 	cilpcp->space_used = 0;
 	up_write(&cil->xc_ctx_lock);
 }
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b9c96609705b..5150b4a7d086 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -236,6 +236,7 @@ struct xfs_cil_ctx {
  */
 struct xlog_cil_pcp {
 	uint32_t		space_used;
+	uint32_t		space_reserved;
 	struct list_head	busy_extents;
 	struct list_head	log_items;
 };
-- 
2.33.0

