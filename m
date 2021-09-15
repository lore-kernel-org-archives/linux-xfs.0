Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8388AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65581600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhIOXLR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232740AbhIOXLQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23EFD610A6;
        Wed, 15 Sep 2021 23:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747397;
        bh=7Jn1RlKApKlv574wQ4S7KHa8KQBapTImLrwbU32Bng0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cGRG9yDE8OLlodF+FGlvp9LT3YBO29oUI3zFPFV2IX4HMZNPGhyHoTh1uhKEAgLw+
         feUwlIIggFFl4SrG7SdjS2THbkyPgcQHzyYcZOFn2VZtEk157T2m4150lmIrXfXfR/
         I39zWLwkpZtAAwJWrbHmqSVjy7BogF5st+P2WKa1PldmJdEoyqrbYuVHKHCwfpmQ7O
         YDdrHAC3OPNlecrGW70ArzbShAsGnGoXm48pFNIhl+R713G++mY8IO1Tlhu9JfmJQW
         SQ7lVpdn51uVzagDX7gpjHgVAQgButE5/xvJOZKQeJDrApd13g3maLYwlPUbqHfWb3
         HA8UPRTQnYdXg==
Subject: [PATCH 37/61] xfs: simplify xfs_dialloc_select_ag() return values
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:09:56 -0700
Message-ID: <163174739685.350433.16255120354845871335.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 4268547305c91b35ae7871374078de788a822ed1

The only caller of xfs_dialloc_select_ag() will always return
-ENOSPC to it's caller if the agbp returned from
xfs_dialloc_select_ag() is NULL. IOWs, failure to find a candidate
AGI we can allocate inodes from is always an ENOSPC condition, so
move this logic up into xfs_dialloc_select_ag() so we can simplify
the return logic in this function.

xfs_dialloc_select_ag() now only ever returns 0 with a locked
agbp, or an error with no agbp.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b6652be3..15785417 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1712,7 +1712,7 @@ xfs_dialloc_roll(
  * This function will ensure that the selected AG has free inodes available to
  * allocate from. The selected AGI will be returned locked to the caller, and it
  * will allocate more free inodes if required. If no free inodes are found or
- * can be allocated, no AGI will be returned.
+ * can be allocated, -ENOSPC be returned.
  */
 int
 xfs_dialloc_select_ag(
@@ -1725,7 +1725,6 @@ xfs_dialloc_select_ag(
 	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
 	int			error;
-	bool			noroom = false;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
@@ -1739,7 +1738,7 @@ xfs_dialloc_select_ag(
 	 */
 	start_agno = xfs_ialloc_ag_select(*tpp, parent, mode);
 	if (start_agno == NULLAGNUMBER)
-		return 0;
+		return -ENOSPC;
 
 	/*
 	 * If we have already hit the ceiling of inode blocks then clear
@@ -1752,7 +1751,6 @@ xfs_dialloc_select_ag(
 	if (igeo->maxicount &&
 	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
 							> igeo->maxicount) {
-		noroom = true;
 		okalloc = false;
 	}
 
@@ -1789,10 +1787,8 @@ xfs_dialloc_select_ag(
 		if (error)
 			break;
 
-		if (pag->pagi_freecount) {
-			xfs_perag_put(pag);
+		if (pag->pagi_freecount)
 			goto found_ag;
-		}
 
 		if (!okalloc)
 			goto nextag_relse_buffer;
@@ -1800,9 +1796,6 @@ xfs_dialloc_select_ag(
 		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
 		if (error < 0) {
 			xfs_trans_brelse(*tpp, agbp);
-
-			if (error == -ENOSPC)
-				error = 0;
 			break;
 		}
 
@@ -1813,12 +1806,11 @@ xfs_dialloc_select_ag(
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
@@ -1826,16 +1818,17 @@ xfs_dialloc_select_ag(
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

