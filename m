Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEDC1401C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609065; cv=none; b=pofvdXylQFkXBM2ArJPXF9HeZghOsd1sHAh5aCwRrlkqP4V77QV3EX1s97DfXQ6yAZSN2gd2y1qUqpgj7s5CzyQ/3kwDlvx2ykO8TDcH+XaYUdLc1YD+q5bOX6IcSHXDceyPPDxSBnpIriUTGjMdNZwQxZAQOCi1nnGujJ827bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609065; c=relaxed/simple;
	bh=0dIuf3BzaNKyxwT2uyLiuOje3+GkhyPvleTWo+Xwec0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d60JGq+2/Ios2aBCn+qoE/9nxReRIaxJWSP9dPlQ4+lpbi7e+L3QB5r08TxUrKUzm2xsCrS4KlgUZOxJckdnW0U6x5hVDf2Sx+MZ06QBn16pmyX6nDRWJ1QulvjpVCu7uZOihvuveLEvyYCyWCIGmy9BoBpb0nUacXO1LS51Jag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KYCFGKQq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KYCFGKQq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=betUB/PM2eK7LD2K6Pfm68VWZkji2t/V7wiGvRouCPQ=; b=KYCFGKQqqkhZG9H4WAw/OwHHSJ
	JDtOkApwEclMZnhg1RwTovSgZlJMpcv+3LcLRttpcGWAtg2LVeoCf298eKOjmsYKe1umrRlxOYDsT
	wK3Qm1FQrgAV69SEc9Vj5fiQVb+ICHha4rM3Fertp1SrSkZ7DNjoHhuv5doi68tSMO1emgstcUF1I
	2Fb5PizK3vU2sSkj0FSfrnjHfmsmZn7G5n07YS97kqIKWCZbfjLnnabvbas6K2Vv1HzKJ43ZUKPrp
	2rFMAlOog10HpmjdOATiznOaD8GnEOdGIlwU8alGb+mOwaq27PSL+kAK3YyuuxsZTHdVasq3MxiL6
	cwTNTzQg==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVr-00000000iKH-2e3o;
	Mon, 14 Apr 2025 05:37:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 24/43] xfs: support zone gaps
Date: Mon, 14 Apr 2025 07:36:07 +0200
Message-ID: <20250414053629.360672-25-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 97c69ba1c08d5a2bb3cacecae685b63e20e4d485

Zoned devices can have gaps beyond the usable capacity of a zone and the
end in the LBA/daddr address space.  In other words, the hardware
equivalent to the RT groups already takes care of the power of 2
alignment for us.  In this case the sparse FSB/RTB address space maps 1:1
to the device address space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h  |  4 +++-
 libxfs/xfs_group.h   |  6 +++++-
 libxfs/xfs_rtgroup.h | 13 ++++++++-----
 libxfs/xfs_sb.c      |  3 +++
 libxfs/xfs_zones.c   | 19 +++++++++++++++++--
 5 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index cee7e26f23bd..9566a7623365 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -398,6 +398,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 8)  /* metadata dir tree */
 #define XFS_SB_FEAT_INCOMPAT_ZONED	(1 << 9)  /* zoned RT allocator */
+#define XFS_SB_FEAT_INCOMPAT_ZONE_GAPS	(1 << 10) /* RTGs have LBA gaps */
 
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
@@ -409,7 +410,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
 		 XFS_SB_FEAT_INCOMPAT_PARENT | \
 		 XFS_SB_FEAT_INCOMPAT_METADIR | \
-		 XFS_SB_FEAT_INCOMPAT_ZONED)
+		 XFS_SB_FEAT_INCOMPAT_ZONED | \
+		 XFS_SB_FEAT_INCOMPAT_ZONE_GAPS)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index cff3f815947b..4423932a2313 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
@@ -123,7 +123,11 @@ xfs_gbno_to_daddr(
 	struct xfs_groups	*g = &mp->m_groups[xg->xg_type];
 	xfs_fsblock_t		fsbno;
 
-	fsbno = (xfs_fsblock_t)xg->xg_gno * g->blocks + gbno;
+	if (g->has_daddr_gaps)
+		fsbno = xfs_gbno_to_fsb(xg, gbno);
+	else
+		fsbno = (xfs_fsblock_t)xg->xg_gno * g->blocks + gbno;
+
 	return XFS_FSB_TO_BB(mp, g->start_fsb + fsbno);
 }
 
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index b325aff28264..d36a6ae0abe5 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -245,11 +245,14 @@ xfs_rtb_to_daddr(
 	xfs_rtblock_t		rtbno)
 {
 	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
-	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
-	uint64_t		start_bno = (xfs_rtblock_t)rgno * g->blocks;
 
-	return XFS_FSB_TO_BB(mp,
-		g->start_fsb + start_bno + (rtbno & g->blkmask));
+	if (xfs_has_rtgroups(mp) && !g->has_daddr_gaps) {
+		xfs_rgnumber_t	rgno = xfs_rtb_to_rgno(mp, rtbno);
+
+		rtbno = (xfs_rtblock_t)rgno * g->blocks + (rtbno & g->blkmask);
+	}
+
+	return XFS_FSB_TO_BB(mp, g->start_fsb + rtbno);
 }
 
 static inline xfs_rtblock_t
@@ -261,7 +264,7 @@ xfs_daddr_to_rtb(
 	xfs_rfsblock_t		bno;
 
 	bno = XFS_BB_TO_FSBT(mp, daddr) - g->start_fsb;
-	if (xfs_has_rtgroups(mp)) {
+	if (xfs_has_rtgroups(mp) && !g->has_daddr_gaps) {
 		xfs_rgnumber_t	rgno;
 		uint32_t	rgbno;
 
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 8df99e518c70..078c75febf4f 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1202,6 +1202,9 @@ xfs_sb_mount_rextsize(
 		rgs->blklog = mp->m_sb.sb_rgblklog;
 		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
 		rgs->start_fsb = mp->m_sb.sb_rtstart;
+		if (xfs_sb_has_incompat_feature(sbp,
+				XFS_SB_FEAT_INCOMPAT_ZONE_GAPS))
+			rgs->has_daddr_gaps = true;
 	} else {
 		rgs->blocks = 0;
 		rgs->blklog = 0;
diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
index 712c0fe9b0da..7a81d83f5b3e 100644
--- a/libxfs/xfs_zones.c
+++ b/libxfs/xfs_zones.c
@@ -139,6 +139,7 @@ xfs_zone_validate(
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	uint32_t		expected_size;
 
 	/*
 	 * Check that the zone capacity matches the rtgroup size stored in the
@@ -153,11 +154,25 @@ xfs_zone_validate(
 		return false;
 	}
 
-	if (XFS_BB_TO_FSB(mp, zone->len) != 1 << g->blklog) {
+	if (g->has_daddr_gaps) {
+		expected_size = 1 << g->blklog;
+	} else {
+		if (zone->len != zone->capacity) {
+			xfs_warn(mp,
+"zone %u has capacity != size ((0x%llx vs 0x%llx)",
+				rtg_rgno(rtg),
+				XFS_BB_TO_FSB(mp, zone->len),
+				XFS_BB_TO_FSB(mp, zone->capacity));
+			return false;
+		}
+		expected_size = g->blocks;
+	}
+
+	if (XFS_BB_TO_FSB(mp, zone->len) != expected_size) {
 		xfs_warn(mp,
 "zone %u length (0x%llx) does match geometry (0x%x).",
 			rtg_rgno(rtg), XFS_BB_TO_FSB(mp, zone->len),
-			1 << g->blklog);
+			expected_size);
 	}
 
 	switch (zone->type) {
-- 
2.47.2

