Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8CCC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A9AF64FD4
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhCEFMC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:12:02 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:51834 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhCEFL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:11:56 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 12FA4107890
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:52 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-00Fbpk-It
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-000lam-BL
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 42/45] xfs: __percpu_counter_compare() inode count debug too expensive
Date:   Fri,  5 Mar 2021 16:11:40 +1100
Message-Id: <20210305051143.182133-43-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=sMu_4l5kZS4VzaOAmzIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

 - 21.92% __xfs_trans_commit
     - 21.62% xfs_log_commit_cil
	- 11.69% xfs_trans_unreserve_and_mod_sb
	   - 11.58% __percpu_counter_compare
	      - 11.45% __percpu_counter_sum
		 - 10.29% _raw_spin_lock_irqsave
		    - 10.28% do_raw_spin_lock
			 __pv_queued_spin_lock_slowpath

We debated just getting rid of it last time this came up and
there was no real objection to removing it. Now it's the biggest
scalability limitation for debug kernels even on smallish machines,
so let's just get rid of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b20e68279808..637d084c8aa8 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -616,19 +616,12 @@ xfs_trans_unreserve_and_mod_sb(
 		ASSERT(!error);
 	}
 
-	if (idelta) {
+	if (idelta)
 		percpu_counter_add_batch(&mp->m_icount, idelta,
 					 XFS_ICOUNT_BATCH);
-		if (idelta < 0)
-			ASSERT(__percpu_counter_compare(&mp->m_icount, 0,
-							XFS_ICOUNT_BATCH) >= 0);
-	}
 
-	if (ifreedelta) {
+	if (ifreedelta)
 		percpu_counter_add(&mp->m_ifree, ifreedelta);
-		if (ifreedelta < 0)
-			ASSERT(percpu_counter_compare(&mp->m_ifree, 0) >= 0);
-	}
 
 	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
 		return;
-- 
2.28.0

