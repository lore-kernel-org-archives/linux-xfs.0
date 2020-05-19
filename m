Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96318C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 21:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C54D205CB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 21:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgESVsv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 17:48:51 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:44783 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbgESVsu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 17:48:50 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 870791083A6
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 07:48:46 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbA6M-0000C5-Ve
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 07:48:42 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbA6M-00AmfT-MQ
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 07:48:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()
Date:   Wed, 20 May 2020 07:48:39 +1000
Message-Id: <20200519214840.2570159-2-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200519214840.2570159-1-david@fromorbit.com>
References: <20200519214840.2570159-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=3c2E5njS45-I7yXB1VkA:9
        a=pHzHmUro8NiASowvMSCR:22 a=nt3jZW36AmriUCFCBwmW:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The error handling in xfs_trans_unreserve_and_mod_sb() is largely
incorrect - rolling back the changes in the transaction if only one
counter underruns makes all the other counters incorrect. We still
allow the change to proceed and committing the transaction, except
now we have multiple incorrect counters instead of a single
underflow.

Further, we don't actually report the error to the caller, so this
is completely silent except on debug kernels that will assert on
failure before we even get to the rollback code.  Hence this error
handling is broken, untested, and largely unnecessary complexity.

Just remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c | 170 +++++++--------------------------------------
 1 file changed, 27 insertions(+), 143 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 28b983ff8b113..4522ceaaf57ba 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -534,57 +534,9 @@ xfs_trans_apply_sb_deltas(
 				  sizeof(sbp->sb_frextents) - 1);
 }
 
-STATIC int
-xfs_sb_mod8(
-	uint8_t			*field,
-	int8_t			delta)
-{
-	int8_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
-STATIC int
-xfs_sb_mod32(
-	uint32_t		*field,
-	int32_t			delta)
-{
-	int32_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
-STATIC int
-xfs_sb_mod64(
-	uint64_t		*field,
-	int64_t			delta)
-{
-	int64_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
 /*
- * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations
- * and apply superblock counter changes to the in-core superblock.  The
+ * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations and
+ * apply superblock counter changes to the in-core superblock.  The
  * t_res_fdblocks_delta and t_res_frextents_delta fields are explicitly NOT
  * applied to the in-core superblock.  The idea is that that has already been
  * done.
@@ -629,20 +581,17 @@ xfs_trans_unreserve_and_mod_sb(
 	/* apply the per-cpu counters */
 	if (blkdelta) {
 		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
-		if (error)
-			goto out;
+		ASSERT(!error);
 	}
 
 	if (idelta) {
 		error = xfs_mod_icount(mp, idelta);
-		if (error)
-			goto out_undo_fdblocks;
+		ASSERT(!error);
 	}
 
 	if (ifreedelta) {
 		error = xfs_mod_ifree(mp, ifreedelta);
-		if (error)
-			goto out_undo_icount;
+		ASSERT(!error);
 	}
 
 	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
@@ -650,95 +599,30 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
-	if (rtxdelta) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
-		if (error)
-			goto out_undo_ifree;
-	}
-
-	if (tp->t_dblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_dblocks, tp->t_dblocks_delta);
-		if (error)
-			goto out_undo_frextents;
-	}
-	if (tp->t_agcount_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_agcount, tp->t_agcount_delta);
-		if (error)
-			goto out_undo_dblocks;
-	}
-	if (tp->t_imaxpct_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_imax_pct, tp->t_imaxpct_delta);
-		if (error)
-			goto out_undo_agcount;
-	}
-	if (tp->t_rextsize_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rextsize,
-				     tp->t_rextsize_delta);
-		if (error)
-			goto out_undo_imaxpct;
-	}
-	if (tp->t_rbmblocks_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rbmblocks,
-				     tp->t_rbmblocks_delta);
-		if (error)
-			goto out_undo_rextsize;
-	}
-	if (tp->t_rblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rblocks, tp->t_rblocks_delta);
-		if (error)
-			goto out_undo_rbmblocks;
-	}
-	if (tp->t_rextents_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rextents,
-				     tp->t_rextents_delta);
-		if (error)
-			goto out_undo_rblocks;
-	}
-	if (tp->t_rextslog_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_rextslog,
-				     tp->t_rextslog_delta);
-		if (error)
-			goto out_undo_rextents;
-	}
+	mp->m_sb.sb_frextents += rtxdelta;
+	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
+	mp->m_sb.sb_agcount += tp->t_agcount_delta;
+	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
+	mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
+	mp->m_sb.sb_rbmblocks += tp->t_rbmblocks_delta;
+	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
+	mp->m_sb.sb_rextents += tp->t_rextents_delta;
+	mp->m_sb.sb_rextslog += tp->t_rextslog_delta;
 	spin_unlock(&mp->m_sb_lock);
-	return;
 
-out_undo_rextents:
-	if (tp->t_rextents_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rextents, -tp->t_rextents_delta);
-out_undo_rblocks:
-	if (tp->t_rblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rblocks, -tp->t_rblocks_delta);
-out_undo_rbmblocks:
-	if (tp->t_rbmblocks_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, -tp->t_rbmblocks_delta);
-out_undo_rextsize:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rextsize, -tp->t_rextsize_delta);
-out_undo_imaxpct:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod8(&mp->m_sb.sb_imax_pct, -tp->t_imaxpct_delta);
-out_undo_agcount:
-	if (tp->t_agcount_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_agcount, -tp->t_agcount_delta);
-out_undo_dblocks:
-	if (tp->t_dblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_dblocks, -tp->t_dblocks_delta);
-out_undo_frextents:
-	if (rtxdelta)
-		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
-out_undo_ifree:
-	spin_unlock(&mp->m_sb_lock);
-	if (ifreedelta)
-		xfs_mod_ifree(mp, -ifreedelta);
-out_undo_icount:
-	if (idelta)
-		xfs_mod_icount(mp, -idelta);
-out_undo_fdblocks:
-	if (blkdelta)
-		xfs_mod_fdblocks(mp, -blkdelta, rsvd);
-out:
-	ASSERT(error == 0);
+	/*
+	 * Debug checks outside of the spinlock so they don't lock up the
+	 * machine if they fail.
+	 */
+	ASSERT(&mp->m_sb.sb_frextents >= 0);
+	ASSERT(&mp->m_sb.sb_dblocks >= 0);
+	ASSERT(&mp->m_sb.sb_agcount >= 0);
+	ASSERT(&mp->m_sb.sb_imax_pct >= 0);
+	ASSERT(&mp->m_sb.sb_rextsize >= 0);
+	ASSERT(&mp->m_sb.sb_rbmblocks >= 0);
+	ASSERT(&mp->m_sb.sb_rblocks >= 0);
+	ASSERT(&mp->m_sb.sb_rextents >= 0);
+	ASSERT(&mp->m_sb.sb_rextslog >= 0);
 	return;
 }
 
-- 
2.26.2.761.g0e0b3e54be

