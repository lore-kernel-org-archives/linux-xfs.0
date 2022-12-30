Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E455AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbiLaCXv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbiLaCXv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:23:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4AE19C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:23:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A17261CBB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7919FC433D2;
        Sat, 31 Dec 2022 02:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453429;
        bh=Y9+YQlNUaEVi7eydmWZiSyacyrCGJuqqAq3Gi/L96Wo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gfe9z7e2GyxLKdnk7sbqLQyP8teAHkjbDKCVB/q5uRnJ2jgrweuf7mwbCiqQ6KDbO
         ogyCfT4iW2PGw1UpX87wxKu/P7wB1idU2negkjJyz1j26DYAELWsw51pKcKfJh92wF
         q1fsN6uF9XUaf2drqoP2Qw17Y5bxTh/8dnsPMso14IO62Cayrgqo2e5rOZdTW9TAZT
         uURYjYpMouDXCTGDRKjMoAWJs2ZcvPkKEhfq8zMLmQdmx5LRJ2dKGCWy0sEkUMk1eO
         zajwSplDdIQwhLRohYCEJY3w7wIgQeYcXxVvU/1A9HU5d6heCAq/rN2N7cyBbDVy/X
         45TobiHwfno9A==
Subject: [PATCH 08/10] xfs: use shifting and masking when converting rt
 extents, if possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:29 -0800
Message-ID: <167243876921.727509.1590098999260165627.stgit@magnolia>
In-Reply-To: <167243876812.727509.17144221830951566022.stgit@magnolia>
References: <167243876812.727509.17144221830951566022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Avoid the costs of integer division (32-bit and 64-bit) if the realtime
extent size is a power of two.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h   |    2 ++
 libxfs/libxfs_priv.h  |   24 ++++++++++++++++++++++++
 libxfs/xfs_rtbitmap.h |   20 ++++++++++++++++++++
 libxfs/xfs_sb.c       |    2 ++
 4 files changed, 48 insertions(+)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 4347098dc7e..6de360d33d3 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -67,6 +67,7 @@ typedef struct xfs_mount {
 	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
 	uint8_t			m_sectbb_log;	/* sectorlog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
+	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -88,6 +89,7 @@ typedef struct xfs_mount {
 	uint			m_ag_max_usable; /* max space per AG */
 	struct radix_tree_root	m_perag_tree;
 	uint64_t		m_features;	/* active filesystem features */
+	uint64_t		m_rtxblkmask;	/* rt extent block mask */
 	unsigned long		m_opstate;	/* dynamic state flags */
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	uint			m_qflags;	/* quota status flags */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 71abfdbe401..268c52b508d 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -371,6 +371,30 @@ howmany_64(uint64_t x, uint32_t y)
 	return x;
 }
 
+/* If @b is a power of 2, return log2(b).  Else return -1. */
+static inline int8_t log2_if_power2(unsigned long b)
+{
+	unsigned long   mask = 1;
+	unsigned int    i;
+	unsigned int    ret = 1;
+
+	if (!is_power_of_2(b))
+		return -1;
+
+	for (i = 0; i < NBBY * sizeof(unsigned long); i++, mask <<= 1) {
+		if (b & mask)
+			ret = i;
+	}
+
+	return ret;
+}
+
+/* If @b is a power of 2, return a mask of the lower bits, else return zero. */
+static inline unsigned long long mask64_if_power2(unsigned long b)
+{
+	return is_power_of_2(b) ? b - 1 : 0;
+}
+
 /* buffer management */
 #define XBF_TRYLOCK			0
 #define XBF_UNMAPPED			0
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index bc51d3bfc7c..9dd791181ca 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -11,6 +11,9 @@ xfs_rtx_to_rtb(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
+	if (mp->m_rtxblklog >= 0)
+		return rtx << mp->m_rtxblklog;
+
 	return rtx * mp->m_sb.sb_rextsize;
 }
 
@@ -19,6 +22,9 @@ xfs_rtxlen_to_extlen(
 	struct xfs_mount	*mp,
 	xfs_rtxlen_t		rtxlen)
 {
+	if (mp->m_rtxblklog >= 0)
+		return rtxlen << mp->m_rtxblklog;
+
 	return rtxlen * mp->m_sb.sb_rextsize;
 }
 
@@ -28,6 +34,9 @@ xfs_extlen_to_rtxmod(
 	struct xfs_mount	*mp,
 	xfs_extlen_t		len)
 {
+	if (mp->m_rtxblklog >= 0)
+		return len & mp->m_rtxblkmask;
+
 	return len % mp->m_sb.sb_rextsize;
 }
 
@@ -36,6 +45,9 @@ xfs_extlen_to_rtxlen(
 	struct xfs_mount	*mp,
 	xfs_extlen_t		len)
 {
+	if (mp->m_rtxblklog >= 0)
+		return len >> mp->m_rtxblklog;
+
 	return len / mp->m_sb.sb_rextsize;
 }
 
@@ -45,6 +57,11 @@ xfs_rtb_to_rtx(
 	xfs_rtblock_t		rtbno,
 	xfs_extlen_t		*mod)
 {
+	if (mp->m_rtxblklog >= 0) {
+		*mod = rtbno & mp->m_rtxblkmask;
+		return rtbno >> mp->m_rtxblklog;
+	}
+
 	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, mod);
 }
 
@@ -53,6 +70,9 @@ xfs_rtb_to_rtxt(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
+	if (mp->m_rtxblklog >= 0)
+		return rtbno >> mp->m_rtxblklog;
+
 	return div_u64(rtbno, mp->m_sb.sb_rextsize);
 }
 
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 55a5c5fc631..8605c91e212 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -950,6 +950,8 @@ xfs_sb_mount_common(
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
+	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
+	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);

