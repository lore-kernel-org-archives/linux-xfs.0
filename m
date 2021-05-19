Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5C7C2B9F9
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ADD86109F
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353394AbhESMOw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:14:52 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41509 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243881AbhESMOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:46 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 30D9480B787
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:21 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m28-Nw
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002SIE-GX
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 37/39] xfs: avoid cil push lock if possible
Date:   Wed, 19 May 2021 22:13:15 +1000
Message-Id: <20210519121317.585244-38-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=F6O72S5bnyPC6Df_giEA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because now it hurts when the CIL fills up.

  - 37.20% __xfs_trans_commit
      - 35.84% xfs_log_commit_cil
         - 19.34% _raw_spin_lock
            - do_raw_spin_lock
                 19.01% __pv_queued_spin_lock_slowpath
         - 4.20% xfs_log_ticket_ungrant
              0.90% xfs_log_space_wake


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index cfd3128399f6..672cbaa4606c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1125,10 +1125,18 @@ xlog_cil_push_background(
 	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
 
 	/*
-	 * Don't do a background push if we haven't used up all the
-	 * space available yet.
+	 * We are done if:
+	 * - we haven't used up all the space available yet; or
+	 * - we've already queued up a push; and
+	 * - we're not over the hard limit; and
+	 * - nothing has been over the hard limit.
+	 *
+	 * If so, we don't need to take the push lock as there's nothing to do.
 	 */
-	if (space_used < XLOG_CIL_SPACE_LIMIT(log)) {
+	if (space_used < XLOG_CIL_SPACE_LIMIT(log) ||
+	    (cil->xc_push_seq == cil->xc_current_sequence &&
+	     space_used < XLOG_CIL_BLOCKING_SPACE_LIMIT(log) &&
+	     !waitqueue_active(&cil->xc_push_wait))) {
 		up_read(&cil->xc_ctx_lock);
 		return;
 	}
-- 
2.31.1

