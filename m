Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6022A12BF15
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998973; cv=none; b=JojhHhW03x8q5PgE5ut1RojqYEfbZDQ6nHMHx4iWjQ6cBWvERGQiSfDrFN3BxqW4gWEukP69dlLCchkOWxYGYelDAsIxm9gu1Oj7b7MRkm7FmHNaGaqBv2OY1DbX15u78L3xe2uosj0o0q6Dkz0XGSYaUgkUL9TRRZreak4upSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998973; c=relaxed/simple;
	bh=+yX8qFceCEYbhtGXifMqEc6KWzkYECr3QfVEK89BUjA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmVcI9K84CZ+Zvyy/YkLhnE4T+dYcPTUw9O0MzZ8SklELIZZkihM1qCw4IMJmi+8M4v1Yn8S8KgGGAqsZaus8xr1n4XSpaRDA4B434BHXavlofCVaE0PPPFz2Ot0Qs3O2eJAz7zKHA+c2DkDEeo9zbdihzoVfQkvcOwLUK6l9WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXgcDFB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXgcDFB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A314C433F1
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998971;
	bh=+yX8qFceCEYbhtGXifMqEc6KWzkYECr3QfVEK89BUjA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gXgcDFB6ehih2iiS+AOmXox+yrDWATx/xhmPyRtlrbgbAF6EaA7QjoNdS2aGVvRmy
	 hAx1UUj4Luype54p6ZR4nsaLKWjo/8AAkycQ4b5jTfo6EBg2IsgUv2byDLDkYSyNP1
	 NcWDF8RhI9NHG7VXBIL7cQ9+9/IRbsb8Q1TPkk15Qqv62vMbXi5xdLwkQxLADOD1Ye
	 Wk5TGB+/XOAbC74f0BThQxc2BYEu3elikMzUw2J7tyfxJVucG57p6tGvg3qFtb2e0U
	 7sfVmELlzANfCzJCg+si0gJSPARKy1qu4THnoPDfIYx805a6TrAlWV8Atoj1Kqoxmo
	 HnjHm/hQzhlIg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 16/35] xfs: use shifting and masking when converting rt extents, if possible
Date: Thu, 15 Feb 2024 13:08:28 +0100
Message-ID: <20240215120907.1542854-17-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: ef5a83b7e597038d1c734ddb4bc00638082c2bf1

Avoid the costs of integer division (32-bit and 64-bit) if the realtime
extent size is a power of two.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/xfs_mount.h   |  2 ++
 libxfs/libxfs_priv.h  | 24 ++++++++++++++++++++++++
 libxfs/xfs_rtbitmap.h | 29 +++++++++++++++++++++++++++++
 libxfs/xfs_sb.c       |  2 ++
 4 files changed, 57 insertions(+)

diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 9adc1f898..98d5b199d 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -71,6 +71,7 @@ typedef struct xfs_mount {
 	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
 	uint8_t			m_sectbb_log;	/* sectorlog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
+	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -93,6 +94,7 @@ typedef struct xfs_mount {
 	struct radix_tree_root	m_perag_tree;
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
+	uint64_t		m_rtxblkmask;	/* rt extent block mask */
 	unsigned long		m_opstate;	/* dynamic state flags */
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	uint			m_qflags;	/* quota status flags */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ed437e38e..30ff8dba9 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -323,6 +323,30 @@ roundup_pow_of_two(uint v)
 	return 0;
 }
 
+/* If @b is a power of 2, return log2(b).  Else return -1. */
+static inline int8_t log2_if_power2(unsigned long b)
+{
+	unsigned long	mask = 1;
+	unsigned int	i;
+	unsigned int	ret = 1;
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
index ecf5645dd..3686a53e0 100644
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
 
@@ -45,6 +57,9 @@ xfs_rtb_to_rtx(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
+	if (likely(mp->m_rtxblklog >= 0))
+		return rtbno >> mp->m_rtxblklog;
+
 	return div_u64(rtbno, mp->m_sb.sb_rextsize);
 }
 
@@ -54,6 +69,9 @@ xfs_rtb_to_rtxoff(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
+	if (likely(mp->m_rtxblklog >= 0))
+		return rtbno & mp->m_rtxblkmask;
+
 	return do_div(rtbno, mp->m_sb.sb_rextsize);
 }
 
@@ -67,6 +85,11 @@ xfs_rtb_to_rtxrem(
 	xfs_rtblock_t		rtbno,
 	xfs_extlen_t		*off)
 {
+	if (likely(mp->m_rtxblklog >= 0)) {
+		*off = rtbno & mp->m_rtxblkmask;
+		return rtbno >> mp->m_rtxblklog;
+	}
+
 	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, off);
 }
 
@@ -79,6 +102,12 @@ xfs_rtb_to_rtxup(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
+	if (likely(mp->m_rtxblklog >= 0)) {
+		if (rtbno & mp->m_rtxblkmask)
+			return (rtbno >> mp->m_rtxblklog) + 1;
+		return rtbno >> mp->m_rtxblklog;
+	}
+
 	if (do_div(rtbno, mp->m_sb.sb_rextsize))
 		rtbno++;
 	return rtbno;
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 01935017c..1ebdb7ec4 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -973,6 +973,8 @@ xfs_sb_mount_common(
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
+	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
+	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
-- 
2.43.0

