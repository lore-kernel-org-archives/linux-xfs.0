Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE084C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 21:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3C5E205CB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 21:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgESVst (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 17:48:49 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36822 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726985AbgESVss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 17:48:48 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 658647EB5A9
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 07:48:43 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbA6N-0000C7-0U
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 07:48:43 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbA6M-00AmfY-O6
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 07:48:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: reduce free inode accounting overhead
Date:   Wed, 20 May 2020 07:48:40 +1000
Message-Id: <20200519214840.2570159-3-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200519214840.2570159-1-david@fromorbit.com>
References: <20200519214840.2570159-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=BTeA3XvPAAAA:8
        a=oV0B5G6YaPx4KlPK-o4A:9 a=tafbbOV3vt1XuEhzTjGK:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Shaokun Zhang reported that XFs was using substantial CPU time in
percpu_count_sum() when running a single threaded benchmark on
a high CPU count (128p) machine from xfs_mod_ifree(). The issue
is that the filesystem is empty when the benchmark runs, so inode
allocation is running with a very low inode free count.

With the percpu counter batching, this means comparisons when the
counter is less that 128 * 256 = 32768 use the slow path of adding
up all the counters across the CPUs, and this is expensive on high
CPU count machines.

The summing in xfs_mod_ifree() is only used to fire an assert if an
underrun occurs. The error is ignored by the higher level code.
Hence this is really just debug code and we don't need to run it
on production kernels, nor do we need such debug checks to return
error values just to trigger an assert.

Finally, xfs_mod_icount/xfs_mod_ifree are only called from
xfs_trans_unreserve_and_mod_sb(), so get rid of them and just
directly call the percpu_counter_add/percpu_counter_compare
functions. The compare functions are now run only on debug builds as
they are internal to ASSERT() checks and so only compiled in when
ASSERTs are active (CONFIG_XFS_DEBUG=y or CONFIG_XFS_WARN=y).

Reported-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c | 33 ---------------------------------
 fs/xfs/xfs_mount.h |  2 --
 fs/xfs/xfs_trans.c | 17 +++++++++++++----
 3 files changed, 13 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bb91f04266b9a..d5dcf98698600 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1189,39 +1189,6 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	return xfs_sync_sb(mp, true);
 }
 
-/*
- * Deltas for the inode count are +/-64, hence we use a large batch size
- * of 128 so we don't need to take the counter lock on every update.
- */
-#define XFS_ICOUNT_BATCH	128
-int
-xfs_mod_icount(
-	struct xfs_mount	*mp,
-	int64_t			delta)
-{
-	percpu_counter_add_batch(&mp->m_icount, delta, XFS_ICOUNT_BATCH);
-	if (__percpu_counter_compare(&mp->m_icount, 0, XFS_ICOUNT_BATCH) < 0) {
-		ASSERT(0);
-		percpu_counter_add(&mp->m_icount, -delta);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-int
-xfs_mod_ifree(
-	struct xfs_mount	*mp,
-	int64_t			delta)
-{
-	percpu_counter_add(&mp->m_ifree, delta);
-	if (percpu_counter_compare(&mp->m_ifree, 0) < 0) {
-		ASSERT(0);
-		percpu_counter_add(&mp->m_ifree, -delta);
-		return -EINVAL;
-	}
-	return 0;
-}
-
 /*
  * Deltas for the block count can vary from 1 to very large, but lock contention
  * only occurs on frequent small block count updates such as in the delayed
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index aba5a15792792..4835581f3eb00 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -392,8 +392,6 @@ extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
 				     xfs_agnumber_t *maxagi);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
-extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
-extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 4522ceaaf57ba..b055a5ab53465 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -545,7 +545,12 @@ xfs_trans_apply_sb_deltas(
  * used block counts are not updated in the on disk superblock. In this case,
  * XFS_TRANS_SB_DIRTY will not be set when the transaction is updated but we
  * still need to update the incore superblock with the changes.
+ *
+ * Deltas for the inode count are +/-64, hence we use a large batch size of 128
+ * so we don't need to take the counter lock on every update.
  */
+#define XFS_ICOUNT_BATCH	128
+
 void
 xfs_trans_unreserve_and_mod_sb(
 	struct xfs_trans	*tp)
@@ -585,13 +590,17 @@ xfs_trans_unreserve_and_mod_sb(
 	}
 
 	if (idelta) {
-		error = xfs_mod_icount(mp, idelta);
-		ASSERT(!error);
+		percpu_counter_add_batch(&mp->m_icount, idelta,
+					 XFS_ICOUNT_BATCH);
+		if (idelta < 0)
+			ASSERT(__percpu_counter_compare(&mp->m_icount, 0,
+							XFS_ICOUNT_BATCH) >= 0);
 	}
 
 	if (ifreedelta) {
-		error = xfs_mod_ifree(mp, ifreedelta);
-		ASSERT(!error);
+		percpu_counter_add(&mp->m_ifree, ifreedelta);
+		if (ifreedelta < 0)
+			ASSERT(percpu_counter_compare(&mp->m_ifree, 0) >= 0);
 	}
 
 	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
-- 
2.26.2.761.g0e0b3e54be

