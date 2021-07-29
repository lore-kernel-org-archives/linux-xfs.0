Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7DD1C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9996860249
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhG2Sor (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhG2Soq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:44:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7733A60F4B;
        Thu, 29 Jul 2021 18:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584283;
        bh=RD5Ly8BlmxSqcwAUkz4SXDG/aW738l8wL3a1ZnheI0E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qmUfRnZt8gx+ht1t+oViF7pWlIwsDgBrBwGrzvRZqhs55ZT2EsguHNhvm8ilWmUeH
         A8jnacI25H2zvOZXjxDhxyodV8I/l6/GI7aZUYHim1vMvhShf+3UN962iTdfzjKIqh
         UsrWyA64/g+8y2QQJHdriqjlYC/ztS8NsmW+CrGFw58Wj/K7TeWU5dO+D74V33Iqw4
         sdkhsZDzrc78WE07rZitJSNzZyQ75sy4LT+6tt5u6sm0jPN44wlguxRkVXnywpsV+i
         OeVs6xDUEuNF5Kj5X/HeqWln8ZPaai+2kHZdpzwvQhUlxvPdMs6zP2Ya/sl5j07Bao
         99Eka2NPdfnhQ==
Subject: [PATCH 09/20] xfs: reduce inactivation delay when free space is tight
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:44:43 -0700
Message-ID: <162758428318.332903.10268108408219495793.stgit@magnolia>
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

Now that we have made the inactivation of unlinked inodes a background
task to increase the throughput of file deletions, we need to be a
little more careful about how long of a delay we can tolerate.

On a mostly empty filesystem, the risk of the allocator making poor
decisions due to fragmentation of the free space on account a lengthy
delay in background updates is minimal because there's plenty of space.
However, if free space is tight, we want to deallocate unlinked inodes
as quickly as possible to avoid fallocate ENOSPC and to give the
allocator the best shot at optimal allocations for new writes.

Therefore, use the same free space thresholds that we use to limit
preallocation to scale down the delay between an AG being tagged for
needing inodgc work and the inodegc worker being executed.  This follows
the same principle that XFS becomes less aggressive about allocations
(and more precise about accounting) when nearing full.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   96 ++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_trace.h  |   38 ++++++++++++++++++++
 2 files changed, 124 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 69f7fb048116..6418e50518f8 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -212,6 +212,39 @@ xfs_reclaim_work_queue(
 	rcu_read_unlock();
 }
 
+/*
+ * Scale down the background work delay if we're low on free space.  Similar to
+ * the way that we throttle preallocations, we halve the delay time for every
+ * low free space threshold that isn't met.  Return value is in ms.
+ */
+static inline unsigned int
+xfs_gc_delay_freesp(
+	struct xfs_mount	*mp,
+	unsigned int		tag,
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
+	if (shift)
+		trace_xfs_gc_delay_fdblocks(mp, tag, shift);
+
+	return delay_ms >> shift;
+}
+
 /*
  * Compute the lag between scheduling and executing some kind of background
  * garbage collection work.  Return value is in ms.
@@ -239,7 +272,7 @@ xfs_gc_delay_ms(
 		return 0;
 	}
 
-	return default_ms;
+	return xfs_gc_delay_freesp(mp, tag, default_ms);
 }
 
 /*
@@ -265,7 +298,8 @@ xfs_blockgc_queue(
  */
 static void
 xfs_inodegc_queue(
-	struct xfs_mount        *mp)
+	struct xfs_mount        *mp,
+	struct xfs_inode	*ip)
 {
 	if (!test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
 		return;
@@ -282,14 +316,55 @@ xfs_inodegc_queue(
 	rcu_read_unlock();
 }
 
+/*
+ * Reschedule the background inactivation worker immediately if space is
+ * getting tight and the worker hasn't started running yet.
+ */
+static void
+xfs_gc_requeue_now(
+	struct xfs_mount	*mp,
+	unsigned int		tag)
+{
+	struct delayed_work	*dwork;
+	unsigned int		opflag_bit;
+	unsigned int		default_ms;
+
+	switch (tag) {
+	case XFS_ICI_INODEGC_TAG:
+		dwork = &mp->m_inodegc_work;
+		default_ms = xfs_inodegc_ms;
+		opflag_bit = XFS_OPFLAG_INODEGC_RUNNING_BIT;
+		break;
+	default:
+		return;
+	}
+
+	if (!delayed_work_pending(dwork) ||
+	    !test_bit(opflag_bit, &mp->m_opflags))
+		return;
+
+	rcu_read_lock();
+	if (!radix_tree_tagged(&mp->m_perag_tree, tag))
+		goto unlock;
+
+	if (xfs_gc_delay_ms(mp, tag) == default_ms)
+		goto unlock;
+
+	trace_xfs_gc_requeue_now(mp, tag);
+	queue_delayed_work(mp->m_gc_workqueue, dwork, 0);
+unlock:
+	rcu_read_unlock();
+}
+
 /* Set a tag on both the AG incore inode tree and the AG radix tree. */
 static void
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
@@ -302,8 +377,10 @@ xfs_perag_set_inode_tag(
 	else if (tag == XFS_ICI_INODEGC_TAG)
 		pag->pag_ici_needs_inactive++;
 
-	if (was_tagged)
+	if (was_tagged) {
+		xfs_gc_requeue_now(mp, tag);
 		return;
+	}
 
 	/* propagate the tag up into the perag radix tree */
 	spin_lock(&mp->m_perag_lock);
@@ -319,7 +396,7 @@ xfs_perag_set_inode_tag(
 		xfs_blockgc_queue(pag);
 		break;
 	case XFS_ICI_INODEGC_TAG:
-		xfs_inodegc_queue(mp);
+		xfs_inodegc_queue(mp, ip);
 		break;
 	}
 
@@ -479,7 +556,7 @@ xfs_inode_mark_reclaimable(
 		tag = XFS_ICI_RECLAIM_TAG;
 	}
 
-	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino), tag);
+	xfs_perag_set_inode_tag(pag, ip, tag);
 
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
@@ -1367,8 +1444,7 @@ xfs_blockgc_set_iflag(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 
-	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			XFS_ICI_BLOCKGC_TAG);
+	xfs_perag_set_inode_tag(pag, ip, XFS_ICI_BLOCKGC_TAG);
 
 	spin_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
@@ -1849,7 +1925,7 @@ xfs_inodegc_inactivate(
 	ip->i_flags |= XFS_IRECLAIMABLE;
 
 	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_INODEGC_TAG);
-	xfs_perag_set_inode_tag(pag, agino, XFS_ICI_RECLAIM_TAG);
+	xfs_perag_set_inode_tag(pag, ip, XFS_ICI_RECLAIM_TAG);
 
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
@@ -1915,7 +1991,7 @@ xfs_inodegc_start(
 		return;
 
 	trace_xfs_inodegc_start(mp, __return_address);
-	xfs_inodegc_queue(mp);
+	xfs_inodegc_queue(mp, NULL);
 }
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d3f3f6a32872..2092a8542862 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -213,6 +213,28 @@ TRACE_EVENT(xfs_inodegc_requeue_mempressure,
 		  __entry->caller_ip)
 );
 
+TRACE_EVENT(xfs_gc_delay_fdblocks,
+	TP_PROTO(struct xfs_mount *mp, unsigned int tag, unsigned int shift),
+	TP_ARGS(mp, tag, shift),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long long, fdblocks)
+		__field(unsigned int, tag)
+		__field(unsigned int, shift)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->fdblocks = percpu_counter_read(&mp->m_fdblocks);
+		__entry->tag = tag;
+		__entry->shift = shift;
+	),
+	TP_printk("dev %d:%d tag %u shift %u fdblocks %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tag,
+		  __entry->shift,
+		  __entry->fdblocks)
+);
+
 DECLARE_EVENT_CLASS(xfs_gc_queue_class,
 	TP_PROTO(struct xfs_mount *mp, unsigned int delay_ms),
 	TP_ARGS(mp, delay_ms),
@@ -234,6 +256,22 @@ DEFINE_EVENT(xfs_gc_queue_class, name,	\
 	TP_ARGS(mp, delay_ms))
 DEFINE_GC_QUEUE_EVENT(xfs_inodegc_queue);
 
+TRACE_EVENT(xfs_gc_requeue_now,
+	TP_PROTO(struct xfs_mount *mp, unsigned int tag),
+	TP_ARGS(mp, tag),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, tag)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->tag = tag;
+	),
+	TP_printk("dev %d:%d tag %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tag)
+);
+
 TRACE_EVENT(xfs_inodegc_throttle_mempressure,
 	TP_PROTO(struct xfs_mount *mp),
 	TP_ARGS(mp),

