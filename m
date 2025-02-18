Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B10F22F160
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866438; cv=none; b=HVM2hDomtwlVVev9tq4un2fGuLb3k7nFoQD/sLbGm5g/qaT9zg5ldwa82kInHZSXBIE5bl7gOED4Ad9/FIYkcbamBbpdPVYMDNPsxSsCMiGTuOp8aCtScux6dxHs02UtX2KUzECH9WtA44AlO/moz4fA8e2mU5BzFBbYlFQ92vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866438; c=relaxed/simple;
	bh=yJPcp7ARFBbeIYnNT5m/61BTg5xntYlDoNGvUV/uuJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWSqVESwM1BhGKw5zkvlRi5+gZI9QX05sUUjxi0oXGHGPdthD5Io29Yan49DHsw2SePvu6DUnwnEnVki9cWp6gh9YSwPzgp5Xh7PM0RSelNp0KhH2Xhfd8UYGHqaR+8MteY+kZ3/tP0wCVa8MK/Sdaj5iojcBfKOfXgDR7tgowE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yX3BA6Xm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yX3BA6Xm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DoWgBFmdg2aYxa3hZZDjZunfLIypWG0LPGg93adUZKI=; b=yX3BA6XmvCFD/1WmwrI4xXNd3j
	m0EsSNJ2/Ni52AudxorSQC7fBaMik1a1G0Bv2f+dFAVrtR5UTj0MW0vJjJ6gfOkCwE0OJ+usNhPTS
	l+w1lPkzz0KkiQTDqNg8W4HhYj44VegbTKnUIINC6pt++hgwaPgB2c2slZLSfK3oEZHXL9+aHcZP/
	tMW8T6FzccZxSFIMGWfQe7y0cGEulKoZsYDZdPG86TkWPezPTrIC2UDSGuAGTKMfk+F7vjm2xZGhl
	udYtBRi5DK9PeSNYCyomo21KAC6Kv5R2H3vDlDHYP1B8fySievN7Z109ujhFAawzP4h3CVjgA0laL
	iDuYhMKQ==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIjs-00000007Cta-1su9;
	Tue, 18 Feb 2025 08:13:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 39/45] xfs: support zone gaps
Date: Tue, 18 Feb 2025 09:10:42 +0100
Message-ID: <20250218081153.3889537-40-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zoned devices can have gaps beyond the usable capacity of a zone and the
end in the LBA/daddr address space.  In other words, the hardware
equivalent to the RT groups already takes care of the power of 2
alignment for us.  In this case the sparse FSB/RTB address space maps 1:1
to the device address space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h  |  4 +++-
 fs/xfs/libxfs/xfs_group.h   |  6 +++++-
 fs/xfs/libxfs/xfs_rtgroup.h | 13 ++++++++-----
 fs/xfs/libxfs/xfs_sb.c      |  3 +++
 fs/xfs/libxfs/xfs_zones.c   | 19 +++++++++++++++++--
 fs/xfs/xfs_mount.h          |  9 +++++++++
 6 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index cee7e26f23bd..9566a7623365 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index cff3f815947b..4423932a2313 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
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
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index b325aff28264..d36a6ae0abe5 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
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
 
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 65256e109e64..e42bfd04a7c6 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1205,6 +1205,9 @@ xfs_sb_mount_rextsize(
 		rgs->blklog = mp->m_sb.sb_rgblklog;
 		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
 		rgs->start_fsb = mp->m_sb.sb_rtstart;
+		if (xfs_sb_has_incompat_feature(sbp,
+				XFS_SB_FEAT_INCOMPAT_ZONE_GAPS))
+			rgs->has_daddr_gaps = true;
 	} else {
 		rgs->blocks = 0;
 		rgs->blklog = 0;
diff --git a/fs/xfs/libxfs/xfs_zones.c b/fs/xfs/libxfs/xfs_zones.c
index b022ed960eac..b0791a71931c 100644
--- a/fs/xfs/libxfs/xfs_zones.c
+++ b/fs/xfs/libxfs/xfs_zones.c
@@ -137,6 +137,7 @@ xfs_zone_validate(
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	uint32_t		expected_size;
 
 	/*
 	 * Check that the zone capacity matches the rtgroup size stored in the
@@ -151,11 +152,25 @@ xfs_zone_validate(
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
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 4b406f57548a..181b9bcff2cb 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -97,6 +97,15 @@ struct xfs_groups {
 	 */
 	uint8_t			blklog;
 
+	/*
+	 * Zoned devices can have gaps beyond the usable capacity of a zone and
+	 * the end in the LBA/daddr address space.  In other words, the hardware
+	 * equivalent to the RT groups already takes care of the power of 2
+	 * alignment for us.  In this case the sparse FSB/RTB address space maps
+	 * 1:1 to the device address space.
+	 */
+	bool			has_daddr_gaps;
+
 	/*
 	 * Mask to extract the group-relative block number from a FSB.
 	 * For a pre-rtgroups filesystem we pretend to have one very large
-- 
2.45.2

