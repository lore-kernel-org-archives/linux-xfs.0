Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B6BC48BDF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCCB861284
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhFMRWs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhFMRWs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:22:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC54561107;
        Sun, 13 Jun 2021 17:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604846;
        bh=BJogehxRorbaOlZZFDwUdra0JwVpUn672r2IriDHHUM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gh++hvcXBGcxKqcv/OWwuuY817vJ6QZ1IUfzaJWosR6Y97FuKX6Ky/f0NSSeapzue
         Bs6fSitB2L464JnhP4VinfWNz76/IFYzFQFGiMjVWNtoXNQVSC24tie7j+c6d6Qb+m
         n/N7IUWPRPwbd+lGUKG+JiDRpLQSlBaXI6Lr/+ZitNDDk1MbmmB+o6J9avf/zV8hDR
         T54+Ul2wYPGUdrIVBzfIbjASJo0/a5Dj+sTP2UIHA9n9ZnGfCdaNhFi3E1nkGx7HkY
         8GjK7bQesxStQ/PmmQBH4DxYg7p/hz0jfNTHDno78hC2IVcsg2InJQD1kwTsjmsE2k
         ZOqJX8SLau9PQ==
Subject: [PATCH 09/16] xfs: reduce inactivation delay when things are tight
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:20:46 -0700
Message-ID: <162360484641.1530792.6759006798754085532.stgit@locust>
In-Reply-To: <162360479631.1530792.17147217854887531696.stgit@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have made the inactivation of unlinked inodes a background
task to increase the throughput of file deletions, we need to be a
little more careful about how long of a delay we can tolerate.

On a mostly empty filesystem, the risk of the allocator making poor
decisions due to fragmentation of the free space on account a lengthy
delay in background updates is minimal because there's plenty of space.
However, if free space is tight, we want to deallocate unlinked inodes
as quickly as possible to avoid fallocate ENOSPC and to give the
allocator the best shot at optimal allocations for new writes.

Furthermore, if we're near the quota limits, we want to run the
background work as soon as possible to avoid going over the limits even
temporarily.

Therefore, use the same free space and quota thresholds that we use to
limit preallocation to scale down the delay between an AG being tagged
for needing inodgc work and the inodegc worker being executed.  This
follows the same principle that XFS becomes less aggressive about
allocations (and more precise about accounting) when nearing full.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  169 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 157 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ddf43a60a55c..97c2901017e4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -215,6 +215,111 @@ xfs_reclaim_work_queue(
 	rcu_read_unlock();
 }
 
+/*
+ * Scale down the background work delay if we're close to a quota limit.
+ * Similar to the way that we throttle preallocations, we halve the delay time
+ * for every low free space threshold that isn't met, and we zero it if we're
+ * over the hard limit.  Return value is in ms.
+ */
+static inline unsigned int
+xfs_worker_delay_dquot(
+	struct xfs_inode	*ip,
+	xfs_dqtype_t		type,
+	unsigned int		delay_ms)
+{
+	struct xfs_dquot	*dqp;
+	int64_t			freesp;
+	unsigned int		shift = 0;
+
+	if (!ip)
+		goto out;
+
+	/*
+	 * Leave the delay untouched if there are no quota limits to enforce.
+	 * These comparisons are done locklessly because at worst we schedule
+	 * background work sooner than necessary.
+	 */
+	dqp = xfs_inode_dquot(ip, type);
+	if (!dqp || !xfs_dquot_is_enforced(dqp))
+		goto out;
+
+	/* no hi watermark, no throttle */
+	if (!dqp->q_prealloc_hi_wmark)
+		goto out;
+
+	/* under the lo watermark, no throttle */
+	if (dqp->q_blk.reserved < dqp->q_prealloc_lo_wmark)
+		goto out;
+
+	/* If we're over the hard limit, run immediately. */
+	if (dqp->q_blk.reserved >= dqp->q_prealloc_hi_wmark)
+		return 0;
+
+	/* Scale down the delay if we're close to the soft limits. */
+	freesp = dqp->q_prealloc_hi_wmark - dqp->q_blk.reserved;
+	if (freesp < dqp->q_low_space[XFS_QLOWSP_5_PCNT]) {
+		shift = 2;
+		if (freesp < dqp->q_low_space[XFS_QLOWSP_3_PCNT])
+			shift += 2;
+		if (freesp < dqp->q_low_space[XFS_QLOWSP_1_PCNT])
+			shift += 2;
+	}
+
+	delay_ms >>= shift;
+out:
+	return delay_ms;
+}
+
+/*
+ * Scale down the background work delay if we're low on free space.  Similar to
+ * the way that we throttle preallocations, we halve the delay time for every
+ * low free space threshold that isn't met.  Return value is in ms.
+ */
+static inline unsigned int
+xfs_worker_delay_freesp(
+	struct xfs_mount	*mp,
+	unsigned int		delay_ms)
+{
+	int64_t			freesp;
+	unsigned int		shift = 0;
+
+	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
+	if (freesp < mp->m_low_space[XFS_LOWSP_5_PCNT]) {
+		shift = 2;
+		if (freesp < mp->m_low_space[XFS_LOWSP_4_PCNT])
+			shift++;
+		if (freesp < mp->m_low_space[XFS_LOWSP_3_PCNT])
+			shift++;
+		if (freesp < mp->m_low_space[XFS_LOWSP_2_PCNT])
+			shift++;
+		if (freesp < mp->m_low_space[XFS_LOWSP_1_PCNT])
+			shift++;
+	}
+
+	return delay_ms >> shift;
+}
+
+/*
+ * Compute the lag between scheduling and executing background work based on
+ * free space in the filesystem.  If an inode is passed in, its dquots will
+ * be considered in the lag computation.  Return value is in ms.
+ */
+static inline unsigned int
+xfs_worker_delay_ms(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	unsigned int		default_ms)
+{
+	unsigned int		udelay, gdelay, pdelay, fdelay;
+
+	udelay = xfs_worker_delay_dquot(ip, XFS_DQTYPE_USER, default_ms);
+	gdelay = xfs_worker_delay_dquot(ip, XFS_DQTYPE_GROUP, default_ms);
+	pdelay = xfs_worker_delay_dquot(ip, XFS_DQTYPE_PROJ, default_ms);
+	fdelay = xfs_worker_delay_freesp(mp, default_ms);
+
+	return min(min(udelay, gdelay), min(pdelay, fdelay));
+}
+
 /*
  * Background scanning to trim preallocated space. This is queued based on the
  * 'speculative_prealloc_lifetime' tunable (5m by default).
@@ -238,28 +343,63 @@ xfs_blockgc_queue(
  */
 static void
 xfs_inodegc_queue(
-	struct xfs_mount        *mp)
+	struct xfs_mount        *mp,
+	struct xfs_inode	*ip)
 {
 	if (!test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
 		return;
 
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
-		trace_xfs_inodegc_queue(mp, xfs_inodegc_ms, _RET_IP_);
+		unsigned int	delay;
+
+		delay = xfs_worker_delay_ms(mp, ip, xfs_inodegc_ms);
+		trace_xfs_inodegc_queue(mp, delay, _RET_IP_);
 		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
-				msecs_to_jiffies(xfs_inodegc_ms));
+				msecs_to_jiffies(delay));
 	}
 	rcu_read_unlock();
 }
 
-/* Set a tag on both the AG incore inode tree and the AG radix tree. */
+/*
+ * Reschedule the background inactivation worker immediately if space is
+ * getting tight and the worker hasn't started running yet.
+ */
 static void
+xfs_inodegc_queue_sooner(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip)
+{
+	if (!XFS_IS_QUOTA_ON(mp) ||
+	    !delayed_work_pending(&mp->m_inodegc_work) ||
+	    !test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
+		return;
+
+	rcu_read_lock();
+	if (!radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
+		goto unlock;
+
+	if (xfs_worker_delay_ms(mp, ip, xfs_inodegc_ms) == xfs_inodegc_ms)
+		goto unlock;
+
+	trace_xfs_inodegc_queue(mp, 0, _RET_IP_);
+	queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
+unlock:
+	rcu_read_unlock();
+}
+
+/*
+ * Set a tag on both the AG incore inode tree and the AG radix tree.
+ * Returns true if the tag was previously set on any item in the incore tree.
+ */
+static bool
 xfs_perag_set_inode_tag(
 	struct xfs_perag	*pag,
-	xfs_agino_t		agino,
+	struct xfs_inode	*ip,
 	unsigned int		tag)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	bool			was_tagged;
 
 	lockdep_assert_held(&pag->pag_ici_lock);
@@ -271,7 +411,7 @@ xfs_perag_set_inode_tag(
 		pag->pag_ici_reclaimable++;
 
 	if (was_tagged)
-		return;
+		return true;
 
 	/* propagate the tag up into the perag radix tree */
 	spin_lock(&mp->m_perag_lock);
@@ -287,11 +427,12 @@ xfs_perag_set_inode_tag(
 		xfs_blockgc_queue(pag);
 		break;
 	case XFS_ICI_INODEGC_TAG:
-		xfs_inodegc_queue(mp);
+		xfs_inodegc_queue(mp, ip);
 		break;
 	}
 
 	trace_xfs_perag_set_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
+	return false;
 }
 
 /* Clear a tag on both the AG incore inode tree and the AG radix tree. */
@@ -367,6 +508,7 @@ xfs_inode_mark_reclaimable(
 	struct xfs_perag	*pag;
 	unsigned int		tag;
 	bool			need_inactive = xfs_inode_needs_inactive(ip);
+	bool			already_queued;
 
 	if (!need_inactive) {
 		/* Going straight to reclaim, so drop the dquots. */
@@ -413,10 +555,14 @@ xfs_inode_mark_reclaimable(
 		tag = XFS_ICI_RECLAIM_TAG;
 	}
 
-	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino), tag);
+	already_queued = xfs_perag_set_inode_tag(pag, ip, tag);
 
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
+
+	if (need_inactive && already_queued)
+		xfs_inodegc_queue_sooner(mp, ip);
+
 	xfs_perag_put(pag);
 }
 
@@ -1413,8 +1559,7 @@ xfs_blockgc_set_iflag(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 
-	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			XFS_ICI_BLOCKGC_TAG);
+	xfs_perag_set_inode_tag(pag, ip, XFS_ICI_BLOCKGC_TAG);
 
 	spin_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
@@ -1895,7 +2040,7 @@ xfs_inodegc_inactivate(
 	ip->i_flags |= XFS_IRECLAIMABLE;
 
 	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_INODEGC_TAG);
-	xfs_perag_set_inode_tag(pag, agino, XFS_ICI_RECLAIM_TAG);
+	xfs_perag_set_inode_tag(pag, ip, XFS_ICI_RECLAIM_TAG);
 
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
@@ -1955,7 +2100,7 @@ xfs_inodegc_start(
 		return;
 
 	trace_xfs_inodegc_start(mp, 0, _RET_IP_);
-	xfs_inodegc_queue(mp);
+	xfs_inodegc_queue(mp, NULL);
 }
 
 /* XFS Inode Cache Walking Code */

