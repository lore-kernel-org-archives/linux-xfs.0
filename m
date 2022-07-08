Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3304CCA480
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 01:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiGHB4G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 21:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236154AbiGHB4F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 21:56:05 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED2EC735B6
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 18:56:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2BD1110E7C46
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 11:56:03 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-00FqlO-Es
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 11:56:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9dDs-004lCx-E9
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 11:56:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: AIL targets log space, not grant space
Date:   Fri,  8 Jul 2022 11:55:52 +1000
Message-Id: <20220708015558.1134330-3-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708015558.1134330-1-david@fromorbit.com>
References: <20220708015558.1134330-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62c78eb3
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=B2GHJCnhYXAUFIiIiqAA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently the AIL attempts to keep 25% of the "log space" free,
where the current used space is tracked by the reserve grant head.
That is, it tracks both physical space used plus the amount reserved
by transactions in progress.

When we start tail pushing, we are trying to make space for new
reservations by writing back older metadata and the log is generally
physically full of dirty metadata, and reservations for modifications
in flight take up whatever space the AIL can physically free up.

Hence we don't really need to take into account the reservation
space that has been used - we just need to keep the log tail moving
as fast as we can to free up space for more reservations to be made.
We know exactly how much physical space the journal is consuming in
the AIL (i.e. max LSN - min LSN) so we can base push thresholds
directly on AIL state rather than have to look at grant head
reservations to determine how much to physically push out of the
log.

COnvert the xfs_ail_push_target() to use physical log space for the
calculation, and get rid of the need to look at any internal log at
all to calculate the push targets.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_priv.h  | 18 ++++++++++++
 fs/xfs/xfs_trans_ail.c | 64 ++++++++++++++++++++----------------------
 2 files changed, 48 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 91a8c74f4626..9f8c601a302b 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -622,6 +622,24 @@ xlog_wait(
 
 int xlog_wait_on_iclog(struct xlog_in_core *iclog);
 
+/* Calculate the distance between two LSNs in bytes */
+static inline uint64_t
+xlog_lsn_sub(
+	struct xlog	*log,
+	xfs_lsn_t	high,
+	xfs_lsn_t	low)
+{
+	uint32_t	hi_cycle = CYCLE_LSN(high);
+	uint32_t	hi_block = BLOCK_LSN(high);
+	uint32_t	lo_cycle = CYCLE_LSN(low);
+	uint32_t	lo_block = BLOCK_LSN(low);
+
+	if (hi_cycle == lo_cycle)
+	       return BBTOB(hi_block - lo_block);
+	ASSERT((hi_cycle == lo_cycle + 1) || xlog_is_shutdown(log));
+	return (uint64_t)log->l_logsize - BBTOB(lo_block - hi_block);
+}
+
 /*
  * The LSN is valid so long as it is behind the current LSN. If it isn't, this
  * means that the next log record that includes this metadata could have a
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 23d395a74362..e41951894b96 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -404,46 +404,42 @@ xfs_lsn_t
 __xfs_ail_push_target(
 	struct xfs_ail		*ailp)
 {
-	struct xlog	*log = ailp->ail_log;
-	xfs_lsn_t	threshold_lsn = 0;
-	xfs_lsn_t	last_sync_lsn;
-	int		free_blocks;
-	int		free_bytes;
-	int		threshold_block;
-	int		threshold_cycle;
-	int		free_threshold;
-
-	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
-	free_blocks = BTOBBT(free_bytes);
+	struct xlog		*log = ailp->ail_log;
+	struct xfs_log_item	*lip;
 
-	/*
-	 * Set the threshold for the minimum number of free blocks in the
-	 * log to the maximum of what the caller needs, one quarter of the
-	 * log, and 256 blocks.
-	 */
-	free_threshold = log->l_logBBsize >> 2;
-	if (free_blocks >= free_threshold)
+	xfs_lsn_t	target_lsn = 0;
+	xfs_lsn_t	max_lsn;
+	xfs_lsn_t	min_lsn;
+	int32_t		free_bytes;
+	uint32_t	target_block;
+	uint32_t	target_cycle;
+
+	lip = xfs_ail_max(ailp);
+	if (!lip)
+		return NULLCOMMITLSN;
+	max_lsn = lip->li_lsn;
+	min_lsn = __xfs_ail_min_lsn(ailp);
+
+	/* If there is more than 25% free space in the log, nothing to push */
+	free_bytes = log->l_logsize - xlog_lsn_sub(log, max_lsn, min_lsn);
+	if (free_bytes >= log->l_logsize >> 2)
 		return NULLCOMMITLSN;
 
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
-						&threshold_block);
-	threshold_block += free_threshold;
-	if (threshold_block >= log->l_logBBsize) {
-		threshold_block -= log->l_logBBsize;
-		threshold_cycle += 1;
+	target_cycle = CYCLE_LSN(min_lsn);
+	target_block = BLOCK_LSN(min_lsn) + (log->l_logBBsize >> 2);
+	if (target_block >= log->l_logBBsize) {
+		target_block -= log->l_logBBsize;
+		target_cycle += 1;
 	}
-	threshold_lsn = xlog_assign_lsn(threshold_cycle,
-					threshold_block);
+	target_lsn = xlog_assign_lsn(target_cycle, target_block);
+
 	/*
-	 * Don't pass in an lsn greater than the lsn of the last
-	 * log record known to be on disk. Use a snapshot of the last sync lsn
-	 * so that it doesn't change between the compare and the set.
+	 * Don't pass in an lsn greater than the lsn of the last log record
+	 * known to be on disk (max lsn).
 	 */
-	last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
-	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
-		threshold_lsn = last_sync_lsn;
-
-	return threshold_lsn;
+	if (XFS_LSN_CMP(target_lsn, max_lsn) > 0)
+		return max_lsn;
+	return target_lsn;
 }
 
 static long
-- 
2.36.1

