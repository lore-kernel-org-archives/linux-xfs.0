Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC94368282
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 17:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767979318; cv=none; b=CTNQ1TuVbDPhj6EqSFZdWXdLh/NKwK009SlV/bN0TKkUkAb3j6RKxsqNk7bRGH1rjjVVkVNFb2y2PB38RmM3vbl/0+kmUUptzWoIo//lAu89C8XHq0YCcc9SoCvRPxyYOAwkMnpndFuQP4+WdnwGvSdAvueVcyAWlrhRlKu5pyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767979318; c=relaxed/simple;
	bh=mgfwRe64iK7RD2OiVX8fjN+dkbEHh7r5Z25X2VmN/Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZKf7fUZoFbFFcIugR15SLDiTIi7huiocGVB8HNAIJ3oLve7S1b2zb+nF6rVbgkjwXd3veUsuBBfszWxy4Mk/bZypP+lJp2KMvB5MQkXNGTpCTXSIFlr3usM8d5E+12bJnRP66G20/+l4I/++I4wu4fJdXjvzoN+yZEFCCYzLG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z0ow3sRK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z0ow3sRK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IDJZHDA5Db8CPWCeU70Vq4hzY2NYsY7ID6Oh9Y9Jsi4=; b=z0ow3sRKN6awbt7d4aaSg5wMWB
	ayVlTYTg3+fwulm+cW5I1EKhJy1nWsawIL6wP98BSI1STNDEBpy9dc4DVTyjymIU0o+5JGBmvHRVb
	lg8Dr6Sp2BZGD9+9UgERzyRtXU9oPJAUIr26RKoeltbMTQwQ8MYDB0aF9BNoSXRB8dgf6Y/SmpByN
	0Da8DYbixWg57dg5jmSSG8V0v6Iku2in0tuj2ghVek28ErO4CwHIcFGh3iELD0fG1S7uLBOfcCylO
	3xaIC3DGFa7vQLh6mH7nO1khkD65Gmrm1EJds18YEOD595YM6ay5ImGHHDPW7m9O1ylWgSLPZvki8
	/7NTWBLA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veGBO-00000002nYf-1Oed;
	Fri, 09 Jan 2026 17:21:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: split and refactor zone validation
Date: Fri,  9 Jan 2026 18:20:49 +0100
Message-ID: <20260109172139.2410399-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109172139.2410399-1-hch@lst.de>
References: <20260109172139.2410399-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently xfs_zone_validate mixes validating the software zone state in
the XFS realtime group with validating the hardware state reported in
struct blk_zone and deriving the write pointer from that.

Move all code that works on the realtime group to xfs_init_zone, and only
keep the hardware state validation in xfs_zone_validate.  This makes the
code more clear, and allows for better reuse in userspace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_zones.c | 142 ++++++++++----------------------------
 fs/xfs/libxfs/xfs_zones.h |   5 +-
 fs/xfs/xfs_zone_alloc.c   |  26 ++++++-
 3 files changed, 63 insertions(+), 110 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_zones.c b/fs/xfs/libxfs/xfs_zones.c
index b40f71f878b5..8d54452744ae 100644
--- a/fs/xfs/libxfs/xfs_zones.c
+++ b/fs/xfs/libxfs/xfs_zones.c
@@ -14,174 +14,102 @@
 #include "xfs_rtgroup.h"
 #include "xfs_zones.h"
 
-static bool
-xfs_zone_validate_empty(
-	struct blk_zone		*zone,
-	struct xfs_rtgroup	*rtg,
-	xfs_rgblock_t		*write_pointer)
-{
-	struct xfs_mount	*mp = rtg_mount(rtg);
-
-	if (rtg_rmap(rtg)->i_used_blocks > 0) {
-		xfs_warn(mp, "empty zone %u has non-zero used counter (0x%x).",
-			 rtg_rgno(rtg), rtg_rmap(rtg)->i_used_blocks);
-		return false;
-	}
-
-	*write_pointer = 0;
-	return true;
-}
-
-static bool
-xfs_zone_validate_wp(
-	struct blk_zone		*zone,
-	struct xfs_rtgroup	*rtg,
-	xfs_rgblock_t		*write_pointer)
-{
-	struct xfs_mount	*mp = rtg_mount(rtg);
-	xfs_rtblock_t		wp_fsb = xfs_daddr_to_rtb(mp, zone->wp);
-
-	if (rtg_rmap(rtg)->i_used_blocks > rtg->rtg_extents) {
-		xfs_warn(mp, "zone %u has too large used counter (0x%x).",
-			 rtg_rgno(rtg), rtg_rmap(rtg)->i_used_blocks);
-		return false;
-	}
-
-	if (xfs_rtb_to_rgno(mp, wp_fsb) != rtg_rgno(rtg)) {
-		xfs_warn(mp, "zone %u write pointer (0x%llx) outside of zone.",
-			 rtg_rgno(rtg), wp_fsb);
-		return false;
-	}
-
-	*write_pointer = xfs_rtb_to_rgbno(mp, wp_fsb);
-	if (*write_pointer >= rtg->rtg_extents) {
-		xfs_warn(mp, "zone %u has invalid write pointer (0x%x).",
-			 rtg_rgno(rtg), *write_pointer);
-		return false;
-	}
-
-	return true;
-}
-
-static bool
-xfs_zone_validate_full(
-	struct blk_zone		*zone,
-	struct xfs_rtgroup	*rtg,
-	xfs_rgblock_t		*write_pointer)
-{
-	struct xfs_mount	*mp = rtg_mount(rtg);
-
-	if (rtg_rmap(rtg)->i_used_blocks > rtg->rtg_extents) {
-		xfs_warn(mp, "zone %u has too large used counter (0x%x).",
-			 rtg_rgno(rtg), rtg_rmap(rtg)->i_used_blocks);
-		return false;
-	}
-
-	*write_pointer = rtg->rtg_extents;
-	return true;
-}
-
 static bool
 xfs_zone_validate_seq(
+	struct xfs_mount	*mp,
 	struct blk_zone		*zone,
-	struct xfs_rtgroup	*rtg,
+	unsigned int		zone_no,
 	xfs_rgblock_t		*write_pointer)
 {
-	struct xfs_mount	*mp = rtg_mount(rtg);
-
 	switch (zone->cond) {
 	case BLK_ZONE_COND_EMPTY:
-		return xfs_zone_validate_empty(zone, rtg, write_pointer);
+		*write_pointer = 0;
+		return true;
 	case BLK_ZONE_COND_IMP_OPEN:
 	case BLK_ZONE_COND_EXP_OPEN:
 	case BLK_ZONE_COND_CLOSED:
 	case BLK_ZONE_COND_ACTIVE:
-		return xfs_zone_validate_wp(zone, rtg, write_pointer);
+		if (zone->wp < zone->start ||
+		    zone->wp >= zone->start + zone->capacity) {
+			xfs_warn(mp,
+	"zone %u write pointer (%llu) outside of zone.",
+				zone_no, zone->wp);
+			return false;
+		}
+
+		*write_pointer = XFS_BB_TO_FSB(mp, zone->wp - zone->start);
+		return true;
 	case BLK_ZONE_COND_FULL:
-		return xfs_zone_validate_full(zone, rtg, write_pointer);
+		*write_pointer = XFS_BB_TO_FSB(mp, zone->capacity);
+		return true;
 	case BLK_ZONE_COND_NOT_WP:
 	case BLK_ZONE_COND_OFFLINE:
 	case BLK_ZONE_COND_READONLY:
 		xfs_warn(mp, "zone %u has unsupported zone condition 0x%x.",
-			rtg_rgno(rtg), zone->cond);
+			zone_no, zone->cond);
 		return false;
 	default:
 		xfs_warn(mp, "zone %u has unknown zone condition 0x%x.",
-			rtg_rgno(rtg), zone->cond);
+			zone_no, zone->cond);
 		return false;
 	}
 }
 
 static bool
 xfs_zone_validate_conv(
+	struct xfs_mount	*mp,
 	struct blk_zone		*zone,
-	struct xfs_rtgroup	*rtg)
+	unsigned int		zone_no)
 {
-	struct xfs_mount	*mp = rtg_mount(rtg);
-
 	switch (zone->cond) {
 	case BLK_ZONE_COND_NOT_WP:
 		return true;
 	default:
 		xfs_warn(mp,
 "conventional zone %u has unsupported zone condition 0x%x.",
-			 rtg_rgno(rtg), zone->cond);
+			 zone_no, zone->cond);
 		return false;
 	}
 }
 
 bool
 xfs_zone_validate(
+	struct xfs_mount	*mp,
 	struct blk_zone		*zone,
-	struct xfs_rtgroup	*rtg,
+	unsigned int		zone_no,
+	uint32_t		expected_size,
+	uint32_t		expected_capacity,
 	xfs_rgblock_t		*write_pointer)
 {
-	struct xfs_mount	*mp = rtg_mount(rtg);
-	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
-	uint32_t		expected_size;
-
 	/*
 	 * Check that the zone capacity matches the rtgroup size stored in the
 	 * superblock.  Note that all zones including the last one must have a
 	 * uniform capacity.
 	 */
-	if (XFS_BB_TO_FSB(mp, zone->capacity) != g->blocks) {
+	if (XFS_BB_TO_FSB(mp, zone->capacity) != expected_capacity) {
 		xfs_warn(mp,
-"zone %u capacity (0x%llx) does not match RT group size (0x%x).",
-			rtg_rgno(rtg), XFS_BB_TO_FSB(mp, zone->capacity),
-			g->blocks);
+"zone %u capacity (%llu) does not match RT group size (%u).",
+			zone_no, XFS_BB_TO_FSB(mp, zone->capacity),
+			expected_capacity);
 		return false;
 	}
 
-	if (g->has_daddr_gaps) {
-		expected_size = 1 << g->blklog;
-	} else {
-		if (zone->len != zone->capacity) {
-			xfs_warn(mp,
-"zone %u has capacity != size ((0x%llx vs 0x%llx)",
-				rtg_rgno(rtg),
-				XFS_BB_TO_FSB(mp, zone->len),
-				XFS_BB_TO_FSB(mp, zone->capacity));
-			return false;
-		}
-		expected_size = g->blocks;
-	}
-
 	if (XFS_BB_TO_FSB(mp, zone->len) != expected_size) {
 		xfs_warn(mp,
-"zone %u length (0x%llx) does match geometry (0x%x).",
-			rtg_rgno(rtg), XFS_BB_TO_FSB(mp, zone->len),
+"zone %u length (%llu) does not match geometry (%u).",
+			zone_no, XFS_BB_TO_FSB(mp, zone->len),
 			expected_size);
+		return false;
 	}
 
 	switch (zone->type) {
 	case BLK_ZONE_TYPE_CONVENTIONAL:
-		return xfs_zone_validate_conv(zone, rtg);
+		return xfs_zone_validate_conv(mp, zone, zone_no);
 	case BLK_ZONE_TYPE_SEQWRITE_REQ:
-		return xfs_zone_validate_seq(zone, rtg, write_pointer);
+		return xfs_zone_validate_seq(mp, zone, zone_no, write_pointer);
 	default:
 		xfs_warn(mp, "zoned %u has unsupported type 0x%x.",
-			rtg_rgno(rtg), zone->type);
+			zone_no, zone->type);
 		return false;
 	}
 }
diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
index df10a34da71d..b5b3df04a066 100644
--- a/fs/xfs/libxfs/xfs_zones.h
+++ b/fs/xfs/libxfs/xfs_zones.h
@@ -37,7 +37,8 @@ struct blk_zone;
  */
 #define XFS_DEFAULT_MAX_OPEN_ZONES	128
 
-bool xfs_zone_validate(struct blk_zone *zone, struct xfs_rtgroup *rtg,
-	xfs_rgblock_t *write_pointer);
+bool xfs_zone_validate(struct xfs_mount *mp, struct blk_zone *zone,
+	unsigned int zone_no, uint32_t expected_size,
+	uint32_t expected_capacity, xfs_rgblock_t *write_pointer);
 
 #endif /* _LIBXFS_ZONES_H */
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 013228eab0ac..d8df219fd3b4 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -977,6 +977,8 @@ xfs_free_open_zones(
 
 struct xfs_init_zones {
 	struct xfs_mount	*mp;
+	uint32_t		zone_size;
+	uint32_t		zone_capacity;
 	uint64_t		available;
 	uint64_t		reclaimable;
 };
@@ -1018,6 +1020,25 @@ xfs_init_zone(
 	uint32_t		used = rtg_rmap(rtg)->i_used_blocks;
 	int			error;
 
+	if (write_pointer > rtg->rtg_extents) {
+		xfs_warn(mp, "zone %u has invalid write pointer (0x%x).",
+			 rtg_rgno(rtg), write_pointer);
+		return -EFSCORRUPTED;
+	}
+
+	if (used > rtg->rtg_extents) {
+		xfs_warn(mp,
+"zone %u has used counter (0x%x) larger than zone capacity (0x%llx).",
+			 rtg_rgno(rtg), used, rtg->rtg_extents);
+		return -EFSCORRUPTED;
+	}
+
+	if (write_pointer == 0 && used != 0) {
+		xfs_warn(mp, "empty zone %u has non-zero used counter (0x%x).",
+			rtg_rgno(rtg), used);
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * If there are no used blocks, but the zone is not in empty state yet
 	 * we lost power before the zoned reset.  In that case finish the work
@@ -1081,7 +1102,8 @@ xfs_get_zone_info_cb(
 		xfs_warn(mp, "realtime group not found for zone %u.", rgno);
 		return -EFSCORRUPTED;
 	}
-	if (!xfs_zone_validate(zone, rtg, &write_pointer)) {
+	if (!xfs_zone_validate(mp, zone, idx, iz->zone_size,
+			iz->zone_capacity, &write_pointer)) {
 		xfs_rtgroup_rele(rtg);
 		return -EFSCORRUPTED;
 	}
@@ -1227,6 +1249,8 @@ xfs_mount_zones(
 {
 	struct xfs_init_zones	iz = {
 		.mp		= mp,
+		.zone_capacity	= mp->m_groups[XG_TYPE_RTG].blocks,
+		.zone_size	= xfs_rtgroup_raw_size(mp),
 	};
 	struct xfs_buftarg	*bt = mp->m_rtdev_targp;
 	xfs_extlen_t		zone_blocks = mp->m_groups[XG_TYPE_RTG].blocks;
-- 
2.47.3

