Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A066C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0664B60F5C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhG2SpU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhG2SpU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:45:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8493660F4B;
        Thu, 29 Jul 2021 18:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584316;
        bh=i4wP2LsH03Eg9h57CZpYYsEkShFN0B5u8vPamnz1hBM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s4g85qHWxnt8dT55QVoLXLcS92eHXzKgilQRylFdUWIBxLFARFKhnMGvjNXUOR0YG
         vi9Ygq3bWEbjHY2yGSDQdM8JF8DFoUpuUg0bMjhI9oTnm5ISBenMkK8fS82L0+S7vx
         mPLLHw2A05guoSiK+kX/VK9Lu3IpANAIBrca7o3jEovqgnS6Lwl+GPPVeJ26tXykyp
         0mPuRR4msqXlSZy2rWaj/aOrrCFa+7Nl5K+Hm+ZHhmN/3zXpdK1sc8Zp/d/iF56PtD
         2Wgof+kekS/Sr76GJa+szeysWx/AFiBElISwdiqylqbwB8SqOzmCQVvhU+dcjPv+sY
         ppBYrqCNZxlxA==
Subject: [PATCH 15/20] xfs: reduce inactivation delay when AG free space are
 tight
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:45:16 -0700
Message-ID: <162758431624.332903.3577155349499604841.stgit@magnolia>
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
free space in an AG.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_mount.c  |    2 ++
 fs/xfs/xfs_mount.h  |    1 +
 fs/xfs/xfs_trace.h  |   27 ++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6e9ca483c100..17cc2ac76809 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -353,6 +353,47 @@ xfs_gc_delay_freesp(
 	return delay_ms >> shift;
 }
 
+/*
+ * Scale down the background work delay if we're low on free space in this AG.
+ * Similar to the way that we throttle preallocations, we halve the delay time
+ * for every low free space threshold that isn't met.  Return value is in ms.
+ */
+static inline unsigned int
+xfs_gc_delay_perag(
+	struct xfs_perag	*pag,
+	unsigned int		tag,
+	unsigned int		delay_ms)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	xfs_extlen_t		freesp;
+	unsigned int		shift = 0;
+
+	if (!pag->pagf_init)
+		return delay_ms;
+
+	/* Free space in this AG that can be allocated to file data */
+	freesp = pag->pagf_freeblks + pag->pagf_flcount;
+	freesp -= (pag->pag_meta_resv.ar_reserved +
+		   pag->pag_rmapbt_resv.ar_reserved);
+
+	if (freesp < mp->m_ag_low_space[XFS_LOWSP_5_PCNT]) {
+		shift = 2;
+		if (freesp < mp->m_ag_low_space[XFS_LOWSP_4_PCNT])
+			shift++;
+		if (freesp < mp->m_ag_low_space[XFS_LOWSP_3_PCNT])
+			shift++;
+		if (freesp < mp->m_ag_low_space[XFS_LOWSP_2_PCNT])
+			shift++;
+		if (freesp < mp->m_ag_low_space[XFS_LOWSP_1_PCNT])
+			shift++;
+	}
+
+	if (shift)
+		trace_xfs_gc_delay_agfreeblks(pag, tag, shift);
+
+	return delay_ms >> shift;
+}
+
 /*
  * Compute the lag between scheduling and executing some kind of background
  * garbage collection work.  Return value is in ms.  If an inode is passed in,
@@ -360,12 +401,13 @@ xfs_gc_delay_freesp(
  */
 static inline unsigned int
 xfs_gc_delay_ms(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_inode	*ip,
 	unsigned int		tag)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	unsigned int		default_ms;
-	unsigned int		udelay, gdelay, pdelay, fdelay, rdelay;
+	unsigned int		udelay, gdelay, pdelay, fdelay, rdelay, adelay;
 
 	switch (tag) {
 	case XFS_ICI_INODEGC_TAG:
@@ -388,9 +430,11 @@ xfs_gc_delay_ms(
 	pdelay = xfs_gc_delay_dquot(ip, XFS_DQTYPE_PROJ, tag, default_ms);
 	fdelay = xfs_gc_delay_freesp(mp, tag, default_ms);
 	rdelay = xfs_gc_delay_freertx(mp, ip, tag, default_ms);
+	adelay = xfs_gc_delay_perag(pag, tag, default_ms);
 
 	udelay = min(udelay, gdelay);
 	pdelay = min(pdelay, fdelay);
+	rdelay = min(rdelay, adelay);
 
 	udelay = min(udelay, pdelay);
 
@@ -432,7 +476,7 @@ xfs_inodegc_queue(
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
 		unsigned int	delay;
 
-		delay = xfs_gc_delay_ms(mp, ip, XFS_ICI_INODEGC_TAG);
+		delay = xfs_gc_delay_ms(pag, ip, XFS_ICI_INODEGC_TAG);
 		trace_xfs_inodegc_queue(pag, delay);
 		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_inodegc_work,
 				msecs_to_jiffies(delay));
@@ -473,7 +517,7 @@ xfs_gc_requeue_now(
 	if (!radix_tree_tagged(&mp->m_perag_tree, tag))
 		goto unlock;
 
-	if (xfs_gc_delay_ms(mp, ip, tag) == default_ms)
+	if (xfs_gc_delay_ms(pag, ip, tag) == default_ms)
 		goto unlock;
 
 	trace_xfs_gc_requeue_now(pag, tag);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 37afb0e0d879..811ce8e9310e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -367,6 +367,7 @@ xfs_set_low_space_thresholds(
 {
 	uint64_t		dblocks = mp->m_sb.sb_dblocks;
 	uint64_t		rtexts = mp->m_sb.sb_rextents;
+	uint32_t		agblocks = mp->m_sb.sb_agblocks / 100;
 	int			i;
 
 	do_div(dblocks, 100);
@@ -375,6 +376,7 @@ xfs_set_low_space_thresholds(
 	for (i = 0; i < XFS_LOWSP_MAX; i++) {
 		mp->m_low_space[i] = dblocks * (i + 1);
 		mp->m_low_rtexts[i] = rtexts * (i + 1);
+		mp->m_ag_low_space[i] = agblocks * (i + 1);
 	}
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index edd5c4fd6533..74ca2a458b14 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -131,6 +131,7 @@ typedef struct xfs_mount {
 	uint			m_rsumsize;	/* size of rt summary, bytes */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_qflags;	/* quota status flags */
+	int32_t			m_ag_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_flags;	/* global mount flags */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 	int64_t			m_low_rtexts[XFS_LOWSP_MAX];
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2c504c3e63e6..43fb699e6aaf 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -318,6 +318,33 @@ TRACE_EVENT(xfs_gc_delay_frextents,
 		  __entry->frextents)
 );
 
+TRACE_EVENT(xfs_gc_delay_agfreeblks,
+	TP_PROTO(struct xfs_perag *pag, unsigned int tag, unsigned int shift),
+	TP_ARGS(pag, tag, shift),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(unsigned int, freeblks)
+		__field(unsigned int, tag)
+		__field(unsigned int, shift)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->freeblks = pag->pagf_freeblks + pag->pagf_flcount;
+		__entry->freeblks -= (pag->pag_meta_resv.ar_reserved +
+				      pag->pag_rmapbt_resv.ar_reserved);
+		__entry->tag = tag;
+		__entry->shift = shift;
+	),
+	TP_printk("dev %d:%d tag %u shift %u agno %u freeblks %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tag,
+		  __entry->shift,
+		  __entry->agno,
+		  __entry->freeblks)
+);
+
 DECLARE_EVENT_CLASS(xfs_gc_queue_class,
 	TP_PROTO(struct xfs_perag *pag, unsigned int delay_ms),
 	TP_ARGS(pag, delay_ms),

