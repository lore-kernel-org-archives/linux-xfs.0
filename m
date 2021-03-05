Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BFEC433E9
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EDBE65004
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhCEFM4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:12:56 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58877 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229552AbhCEFMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:12:18 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E9320827B24
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-00FbpV-EK
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-000laX-6W
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 37/45] xfs: track CIL ticket reservation in percpu structure
Date:   Fri,  5 Mar 2021 16:11:35 +1100
Message-Id: <20210305051143.182133-38-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=OVMH6THyl8vKEaUu_IkA:9
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
index 5519d112c1fd..a2f93bd7644b 100644
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
@@ -798,10 +796,13 @@ xlog_cil_push_work(
 
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
index 4eb373357f26..278b9eaea582 100644
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

