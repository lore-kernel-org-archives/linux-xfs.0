Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE737C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98CA164FD4
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCEFM3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:12:29 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:52434 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhCEFMK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:12:10 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id EED2C107B83
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-00FbpY-Ey
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-000laa-7I
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 38/45] xfs: convert CIL busy extents to per-cpu
Date:   Fri,  5 Mar 2021 16:11:36 +1100
Message-Id: <20210305051143.182133-39-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=3A6U50GPjzoxoPTa4dIA:9
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
 fs/xfs/xfs_log_cil.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index a2f93bd7644b..7428b98c8279 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -501,6 +501,9 @@ xlog_cil_insert_items(
 		atomic_add(cilpcp->space_used, &ctx->space_used);
 		cilpcp->space_used = 0;
 	}
+	/* attach the transaction to the CIL if it has any busy extents */
+	if (!list_empty(&tp->t_busy))
+		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
 	put_cpu_ptr(cilpcp);
 
 	/*
@@ -540,9 +543,6 @@ xlog_cil_insert_items(
 			list_move_tail(&lip->li_cil, &cil->xc_cil);
 	}
 
-	/* attach the transaction to the CIL if it has any busy extents */
-	if (!list_empty(&tp->t_busy))
-		list_splice_init(&tp->t_busy, &ctx->busy_extents);
 	spin_unlock(&cil->xc_cil_lock);
 
 	if (tp->t_ticket->t_curr_res < 0)
@@ -802,7 +802,10 @@ xlog_cil_push_work(
 		ctx->ticket->t_curr_res += cilpcp->space_reserved;
 		cilpcp->space_used = 0;
 		cilpcp->space_reserved = 0;
-
+		if (!list_empty(&cilpcp->busy_extents)) {
+			list_splice_init(&cilpcp->busy_extents,
+					&ctx->busy_extents);
+		}
 	}
 
 	spin_lock(&cil->xc_push_lock);
@@ -1459,17 +1462,24 @@ static void __percpu *
 xlog_cil_pcp_alloc(
 	struct xfs_cil		*cil)
 {
+	void __percpu		*pcptr;
 	struct xlog_cil_pcp	*cilpcp;
+	int			cpu;
 
-	cilpcp = alloc_percpu(struct xlog_cil_pcp);
-	if (!cilpcp)
+	pcptr = alloc_percpu(struct xlog_cil_pcp);
+	if (!pcptr)
 		return NULL;
 
+	for_each_possible_cpu(cpu) {
+		cilpcp = per_cpu_ptr(pcptr, cpu);
+		INIT_LIST_HEAD(&cilpcp->busy_extents);
+	}
+
 	if (xlog_cil_pcp_hpadd(cil) < 0) {
-		free_percpu(cilpcp);
+		free_percpu(pcptr);
 		return NULL;
 	}
-	return cilpcp;
+	return pcptr;
 }
 
 static void
-- 
2.28.0

