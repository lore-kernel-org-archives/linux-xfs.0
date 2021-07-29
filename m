Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08889C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E481D60F4B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhG2So6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhG2So5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:44:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 767E760249;
        Thu, 29 Jul 2021 18:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584294;
        bh=RGeNKyFUdxtLDOS/2l9Pc4k6g6iFKMIZGHDYl4iGpLc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=N/HuLJ6cDVzbyOhIWydG6RE+NgSsCwBZHzJeenpG+5506KuMTxCtHaELWRP2X6tyg
         tI9CQHzBzRnpXbdV06NSWnsa3G6oAHkWgN+FpM6FL2MA2UoF53lnKVkdDT1feOIsLK
         qwsL0azTpqpeL6VKtBpx1C/UxQa0mBGz4G5H6/NYOmHP7GL3UOIgfK7RTbc9E1330K
         CpfDtoDd7hO518VMjyRnqzzcWw1G7eQZhwV0oASeS7/NKiBbLhZ0LFVp4EksuxcmLY
         OotsCb8FSpDXIzzKPpRmTSJaTG/FzxN5gCCBhyZg5i0T+eOEx52HvMc3d0OzQ0I7ay
         rh4SL693ftuYw==
Subject: [PATCH 11/20] xfs: reduce inactivation delay when realtime extents
 are tight
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:44:54 -0700
Message-ID: <162758429418.332903.3457822685619578961.stgit@magnolia>
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
realtime extents that we do for free blocks on the data device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_mount.c  |   13 ++++++++-----
 fs/xfs/xfs_mount.h  |    1 +
 fs/xfs/xfs_trace.h  |   22 ++++++++++++++++++++++
 4 files changed, 80 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7ba80d7bff41..91a1dc7eb352 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -279,6 +279,47 @@ xfs_gc_delay_dquot(
 	return delay_ms;
 }
 
+/*
+ * Scale down the background work delay if we're low on free rt extents.
+ * Return value is in ms.
+ */
+static inline unsigned int
+xfs_gc_delay_freertx(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	unsigned int		tag,
+	unsigned int		delay_ms)
+{
+	int64_t			freertx;
+	unsigned int		shift = 0;
+
+	if (ip && !XFS_IS_REALTIME_INODE(ip))
+		return delay_ms;
+	if (!xfs_sb_version_hasrealtime(&mp->m_sb))
+		return delay_ms;
+
+	spin_lock(&mp->m_sb_lock);
+	freertx = mp->m_sb.sb_rextents;
+	spin_unlock(&mp->m_sb_lock);
+
+	if (freertx < mp->m_low_rtexts[XFS_LOWSP_5_PCNT]) {
+		shift = 2;
+		if (freertx < mp->m_low_rtexts[XFS_LOWSP_4_PCNT])
+			shift++;
+		if (freertx < mp->m_low_rtexts[XFS_LOWSP_3_PCNT])
+			shift++;
+		if (freertx < mp->m_low_rtexts[XFS_LOWSP_2_PCNT])
+			shift++;
+		if (freertx < mp->m_low_rtexts[XFS_LOWSP_1_PCNT])
+			shift++;
+	}
+
+	if (shift)
+		trace_xfs_gc_delay_frextents(mp, tag, shift);
+
+	return delay_ms >> shift;
+}
+
 /*
  * Scale down the background work delay if we're low on free space.  Similar to
  * the way that we throttle preallocations, we halve the delay time for every
@@ -324,7 +365,7 @@ xfs_gc_delay_ms(
 	unsigned int		tag)
 {
 	unsigned int		default_ms;
-	unsigned int		udelay, gdelay, pdelay, fdelay;
+	unsigned int		udelay, gdelay, pdelay, fdelay, rdelay;
 
 	switch (tag) {
 	case XFS_ICI_INODEGC_TAG:
@@ -346,8 +387,14 @@ xfs_gc_delay_ms(
 	gdelay = xfs_gc_delay_dquot(ip, XFS_DQTYPE_GROUP, tag, default_ms);
 	pdelay = xfs_gc_delay_dquot(ip, XFS_DQTYPE_PROJ, tag, default_ms);
 	fdelay = xfs_gc_delay_freesp(mp, tag, default_ms);
+	rdelay = xfs_gc_delay_freertx(mp, ip, tag, default_ms);
 
-	return min(min(udelay, gdelay), min(pdelay, fdelay));
+	udelay = min(udelay, gdelay);
+	pdelay = min(pdelay, fdelay);
+
+	udelay = min(udelay, pdelay);
+
+	return min(udelay, rdelay);
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ac953c486b9f..32b46593a169 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -365,13 +365,16 @@ void
 xfs_set_low_space_thresholds(
 	struct xfs_mount	*mp)
 {
-	int i;
+	uint64_t		dblocks = mp->m_sb.sb_dblocks;
+	uint64_t		rtexts = mp->m_sb.sb_rextents;
+	int			i;
+
+	do_div(dblocks, 100);
+	do_div(rtexts, 100);
 
 	for (i = 0; i < XFS_LOWSP_MAX; i++) {
-		uint64_t space = mp->m_sb.sb_dblocks;
-
-		do_div(space, 100);
-		mp->m_low_space[i] = space * (i + 1);
+		mp->m_low_space[i] = dblocks * (i + 1);
+		mp->m_low_rtexts[i] = rtexts * (i + 1);
 	}
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7844b44d45ea..225b3d289336 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -133,6 +133,7 @@ typedef struct xfs_mount {
 	uint			m_qflags;	/* quota status flags */
 	uint64_t		m_flags;	/* global mount flags */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
+	int64_t			m_low_rtexts[XFS_LOWSP_MAX];
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
 						/* low free space thresholds */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 001fd202dbfb..0579775e1e15 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -269,6 +269,28 @@ TRACE_EVENT(xfs_gc_delay_fdblocks,
 		  __entry->fdblocks)
 );
 
+TRACE_EVENT(xfs_gc_delay_frextents,
+	TP_PROTO(struct xfs_mount *mp, unsigned int tag, unsigned int shift),
+	TP_ARGS(mp, tag, shift),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long long, frextents)
+		__field(unsigned int, tag)
+		__field(unsigned int, shift)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->frextents = mp->m_sb.sb_frextents;
+		__entry->tag = tag;
+		__entry->shift = shift;
+	),
+	TP_printk("dev %d:%d tag %u shift %u frextents %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tag,
+		  __entry->shift,
+		  __entry->frextents)
+);
+
 DECLARE_EVENT_CLASS(xfs_gc_queue_class,
 	TP_PROTO(struct xfs_mount *mp, unsigned int delay_ms),
 	TP_ARGS(mp, delay_ms),

