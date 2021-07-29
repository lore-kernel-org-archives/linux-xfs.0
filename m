Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 540E2C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F0ED60F5C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhG2Sow (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231469AbhG2Sow (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:44:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F059B60249;
        Thu, 29 Jul 2021 18:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584289;
        bh=zgNjZ6aqbKS1GYyy2VCWf5WuraCfD/WejfW1+0Y2wvI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RvcIc/CdLXjn4Onssh7fq7TDrS2wCamS4oUyZ8mtqI9c175oJO2ZO7jxtIRwBu3mc
         HpOdDXm1H4DQo1m2xkxlK3hP/LeKF3vWpT1C/X/+nvo0mxgz6+sUe2B2S5Y6S/205E
         EKcDLtbwMdY55XqDXXhaVCYc6bsLoJTF8pYsif7iY1FsmYO1rs4DlRYANxfRNN42bV
         1jjFfd4sbdvJsPkiyCjV2NxFvZBtagmnfC1//XP7GPW8fJC6AIZzaswfbognLV5AQN
         FozADHmMxCtaQ7WWvk80jekCk/x25IdL76nycWwWZqs3F54HZWNi2wfYNPxO5yKZm6
         MXHHgwEEI3tOA==
Subject: [PATCH 10/20] xfs: reduce inactivation delay when quota are tight
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:44:48 -0700
Message-ID: <162758428867.332903.757283672300988786.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Implement the same scaling down of inodegc delays when we're tight on
quota.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.h  |   10 ++++++
 fs/xfs/xfs_icache.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trace.h  |   34 ++++++++++++++++++++
 3 files changed, 125 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index f642884a6834..6b5e3cf40c8b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -54,6 +54,16 @@ struct xfs_dquot_res {
 	xfs_qwarncnt_t		warnings;
 };
 
+static inline bool
+xfs_dquot_res_over_limits(
+	const struct xfs_dquot_res	*qres)
+{
+	if ((qres->softlimit && qres->softlimit < qres->reserved) ||
+	    (qres->hardlimit && qres->hardlimit < qres->reserved))
+		return true;
+	return false;
+}
+
 /*
  * The incore dquot structure
  */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6418e50518f8..7ba80d7bff41 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -212,6 +212,73 @@ xfs_reclaim_work_queue(
 	rcu_read_unlock();
 }
 
+/*
+ * Scale down the background work delay if we're close to a quota limit.
+ * Similar to the way that we throttle preallocations, we halve the delay time
+ * for every low free space threshold that isn't met, and we zero it if we're
+ * over the hard limit.  Return value is in ms.
+ */
+static inline unsigned int
+xfs_gc_delay_dquot(
+	struct xfs_inode	*ip,
+	xfs_dqtype_t		type,
+	unsigned int		tag,
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
+	if (xfs_dquot_res_over_limits(&dqp->q_ino) ||
+	    xfs_dquot_res_over_limits(&dqp->q_rtb)) {
+		trace_xfs_gc_delay_dquot(dqp, tag, 32);
+		return 0;
+	}
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
+	if (dqp->q_blk.reserved >= dqp->q_prealloc_hi_wmark) {
+		trace_xfs_gc_delay_dquot(dqp, tag, 32);
+		return 0;
+	}
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
+	if (shift)
+		trace_xfs_gc_delay_dquot(dqp, tag, shift);
+
+	delay_ms >>= shift;
+out:
+	return delay_ms;
+}
+
 /*
  * Scale down the background work delay if we're low on free space.  Similar to
  * the way that we throttle preallocations, we halve the delay time for every
@@ -247,14 +314,17 @@ xfs_gc_delay_freesp(
 
 /*
  * Compute the lag between scheduling and executing some kind of background
- * garbage collection work.  Return value is in ms.
+ * garbage collection work.  Return value is in ms.  If an inode is passed in,
+ * its dquots will be considered in the lag computation.
  */
 static inline unsigned int
 xfs_gc_delay_ms(
 	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
 	unsigned int		tag)
 {
 	unsigned int		default_ms;
+	unsigned int		udelay, gdelay, pdelay, fdelay;
 
 	switch (tag) {
 	case XFS_ICI_INODEGC_TAG:
@@ -272,7 +342,12 @@ xfs_gc_delay_ms(
 		return 0;
 	}
 
-	return xfs_gc_delay_freesp(mp, tag, default_ms);
+	udelay = xfs_gc_delay_dquot(ip, XFS_DQTYPE_USER, tag, default_ms);
+	gdelay = xfs_gc_delay_dquot(ip, XFS_DQTYPE_GROUP, tag, default_ms);
+	pdelay = xfs_gc_delay_dquot(ip, XFS_DQTYPE_PROJ, tag, default_ms);
+	fdelay = xfs_gc_delay_freesp(mp, tag, default_ms);
+
+	return min(min(udelay, gdelay), min(pdelay, fdelay));
 }
 
 /*
@@ -308,7 +383,7 @@ xfs_inodegc_queue(
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
 		unsigned int	delay;
 
-		delay = xfs_gc_delay_ms(mp, XFS_ICI_INODEGC_TAG);
+		delay = xfs_gc_delay_ms(mp, ip, XFS_ICI_INODEGC_TAG);
 		trace_xfs_inodegc_queue(mp, delay);
 		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
 				msecs_to_jiffies(delay));
@@ -323,6 +398,7 @@ xfs_inodegc_queue(
 static void
 xfs_gc_requeue_now(
 	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
 	unsigned int		tag)
 {
 	struct delayed_work	*dwork;
@@ -347,7 +423,7 @@ xfs_gc_requeue_now(
 	if (!radix_tree_tagged(&mp->m_perag_tree, tag))
 		goto unlock;
 
-	if (xfs_gc_delay_ms(mp, tag) == default_ms)
+	if (xfs_gc_delay_ms(mp, ip, tag) == default_ms)
 		goto unlock;
 
 	trace_xfs_gc_requeue_now(mp, tag);
@@ -378,7 +454,7 @@ xfs_perag_set_inode_tag(
 		pag->pag_ici_needs_inactive++;
 
 	if (was_tagged) {
-		xfs_gc_requeue_now(mp, tag);
+		xfs_gc_requeue_now(mp, ip, tag);
 		return;
 	}
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2092a8542862..001fd202dbfb 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -213,6 +213,40 @@ TRACE_EVENT(xfs_inodegc_requeue_mempressure,
 		  __entry->caller_ip)
 );
 
+TRACE_EVENT(xfs_gc_delay_dquot,
+	TP_PROTO(struct xfs_dquot *dqp, unsigned int tag, unsigned int shift),
+	TP_ARGS(dqp, tag, shift),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(u32, id)
+		__field(xfs_dqtype_t, type)
+		__field(unsigned int, tag)
+		__field(unsigned int, shift)
+		__field(unsigned long long, reserved)
+		__field(unsigned long long, hi_mark)
+		__field(unsigned long long, lo_mark)
+	),
+	TP_fast_assign(
+		__entry->dev = dqp->q_mount->m_super->s_dev;
+		__entry->id = dqp->q_id;
+		__entry->type = dqp->q_type;
+		__entry->reserved = dqp->q_blk.reserved;
+		__entry->hi_mark = dqp->q_prealloc_hi_wmark;
+		__entry->lo_mark = dqp->q_prealloc_lo_wmark;
+		__entry->tag = tag;
+		__entry->shift = shift;
+	),
+	TP_printk("dev %d:%d tag %u shift %u dqid 0x%x dqtype %s reserved %llu hi %llu lo %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tag,
+		  __entry->shift,
+		  __entry->id,
+		  __print_flags(__entry->type, "|", XFS_DQTYPE_STRINGS),
+		  __entry->reserved,
+		  __entry->hi_mark,
+		  __entry->lo_mark)
+);
+
 TRACE_EVENT(xfs_gc_delay_fdblocks,
 	TP_PROTO(struct xfs_mount *mp, unsigned int tag, unsigned int shift),
 	TP_ARGS(mp, tag, shift),

