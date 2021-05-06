Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E52C43460
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8731613EC
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 07:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhEFHV6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 03:21:58 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:35552 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233378AbhEFHV5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 03:21:57 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 251661B08FB
        for <linux-xfs@vger.kernel.org>; Thu,  6 May 2021 17:20:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-005loT-Jp
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-00197n-Be
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/22] xfs: simplify xfs_dialloc_select_ag() return values
Date:   Thu,  6 May 2021 17:20:49 +1000
Message-Id: <20210506072054.271157-18-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210506072054.271157-1-david@fromorbit.com>
References: <20210506072054.271157-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=doXGbGp_frx70r1nsmQA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The only caller of xfs_dialloc_select_ag() will always return
-ENOSPC to it's caller if the agbp returned from
xfs_dialloc_select_ag() is NULL. IOWs, failure to find a candidate
AGI we can allocate inodes from is always an ENOSPC condition, so
move this logic up into xfs_dialloc_select_ag() so we can simplify
the return logic in this function.

xfs_dialloc_select_ag() now only ever returns 0 with a locked
agbp, or an error with no agbp.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 23 ++++++++---------------
 fs/xfs/xfs_inode.c         |  3 ---
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 4540fbcd68a3..872591e8f5cb 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1717,7 +1717,7 @@ xfs_dialloc_roll(
  * This function will ensure that the selected AG has free inodes available to
  * allocate from. The selected AGI will be returned locked to the caller, and it
  * will allocate more free inodes if required. If no free inodes are found or
- * can be allocated, no AGI will be returned.
+ * can be allocated, -ENOSPC be returned.
  */
 int
 xfs_dialloc_select_ag(
@@ -1730,7 +1730,6 @@ xfs_dialloc_select_ag(
 	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
 	int			error;
-	bool			noroom = false;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
@@ -1744,7 +1743,7 @@ xfs_dialloc_select_ag(
 	 */
 	start_agno = xfs_ialloc_ag_select(*tpp, parent, mode);
 	if (start_agno == NULLAGNUMBER)
-		return 0;
+		return -ENOSPC;
 
 	/*
 	 * If we have already hit the ceiling of inode blocks then clear
@@ -1757,7 +1756,6 @@ xfs_dialloc_select_ag(
 	if (igeo->maxicount &&
 	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
 							> igeo->maxicount) {
-		noroom = true;
 		okalloc = false;
 	}
 
@@ -1794,10 +1792,8 @@ xfs_dialloc_select_ag(
 		if (error)
 			break;
 
-		if (pag->pagi_freecount) {
-			xfs_perag_put(pag);
+		if (pag->pagi_freecount)
 			goto found_ag;
-		}
 
 		if (!okalloc)
 			goto nextag_relse_buffer;
@@ -1805,9 +1801,6 @@ xfs_dialloc_select_ag(
 		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
 		if (error < 0) {
 			xfs_trans_brelse(*tpp, agbp);
-
-			if (error == -ENOSPC)
-				error = 0;
 			break;
 		}
 
@@ -1818,12 +1811,11 @@ xfs_dialloc_select_ag(
 			 * allocate one of the new inodes.
 			 */
 			ASSERT(pag->pagi_freecount > 0);
-			xfs_perag_put(pag);
 
 			error = xfs_dialloc_roll(tpp, agbp);
 			if (error) {
 				xfs_buf_relse(agbp);
-				return error;
+				break;
 			}
 			goto found_ag;
 		}
@@ -1831,16 +1823,17 @@ xfs_dialloc_select_ag(
 nextag_relse_buffer:
 		xfs_trans_brelse(*tpp, agbp);
 nextag:
-		xfs_perag_put(pag);
 		if (++agno == mp->m_sb.sb_agcount)
 			agno = 0;
 		if (agno == start_agno)
-			return noroom ? -ENOSPC : 0;
+			break;
+		xfs_perag_put(pag);
 	}
 
 	xfs_perag_put(pag);
-	return error;
+	return error ? error : -ENOSPC;
 found_ag:
+	xfs_perag_put(pag);
 	*IO_agbp = agbp;
 	return 0;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 25910b145d70..3918c99fa95b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -923,9 +923,6 @@ xfs_dir_ialloc(
 	if (error)
 		return error;
 
-	if (!agibp)
-		return -ENOSPC;
-
 	/* Allocate an inode from the selected AG */
 	error = xfs_dialloc_ag(*tpp, agibp, parent_ino, &ino);
 	if (error)
-- 
2.31.1

