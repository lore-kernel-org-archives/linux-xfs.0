Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EE830E0F2
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291576; cv=none; b=eU7j1LMBLWGiv9FJ64lJHTrhuNwsqqxiYsVJs6c2PyP5LwuUTjvDaazcQRhZHIaC0fKfpTx5cbC1k+S9HHP4dD+w5ODX7jT+pBqkI24WhaG5FVxuxCqs7Q0GYn7/rKGi5w3B9GqXCf2cCvgJ7fISWDHkIGr5P6G9o63kH+LMfxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291576; c=relaxed/simple;
	bh=kUWQ3t8B3DdRRckl2gT5kxILGUTQBKtsc3yIXgykjcc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fm4cXS8X6/wGKUDDF46w/wCbbMnjmVo9jKQDsCItknneVNYS4AHv67oGthWwqRd1iV6Xr6OLQ0u2hRo7ut2v1WRpFReT/eO5dL4njrsyxRhOegevDDu+smHOMh9xpyqph5d6I1X4bmH7ueSWlCZ3EodW0rCYaB4rGA7DLfxPcL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPUBR6Aw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPUBR6Aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2C4C4CEF7;
	Mon, 23 Mar 2026 18:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291575;
	bh=kUWQ3t8B3DdRRckl2gT5kxILGUTQBKtsc3yIXgykjcc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LPUBR6AwKz57lWZK/O6gvPTjI0XPGE861UyQ4PlvexFKa9elPQP8utNvKeUhW8BvP
	 Pr+/lTYfeUcEw44RdV8XE67WpQ1WZkCcDFleXtwbe/2w4sjuwgt8VRDRapyLchdxLV
	 iabM3upKJwnA1Q/EM/Vdwjqaib5AcjmCMCskeJ9hnxrD6lIGzrzcFiIsH4T1xJ/b35
	 7hJUcEVIWUSkno9ruOZhGfiiHSgYqDaMrB6KL6WibY/XOgfxeTL/EjECqioHvCAM91
	 oRnvxTIyrItNJVZPrlZ2fWUhMLT7nA4NwJvPcI9GQ5fz2jxYpKWLF7Zxaky9SedSCu
	 e1Zry1DoJ5YVw==
Date: Mon, 23 Mar 2026 11:46:15 -0700
Subject: [PATCH 19/40] xfs: split and refactor zone validation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, dlemoal@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429121090.2266274.3832005701849875880.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 19c5b6051ed62d8c4b1cf92e463c1bcf629107f4

Currently xfs_zone_validate mixes validating the software zone state in
the XFS realtime group with validating the hardware state reported in
struct blk_zone and deriving the write pointer from that.

Move all code that works on the realtime group to xfs_init_zone, and only
keep the hardware state validation in xfs_zone_validate.  This makes the
code more clear, and allows for better reuse in userspace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 -
 libxfs/xfs_zones.h       |    5 +-
 libxfs/xfs_zones.c       |  149 ++++++++++++----------------------------------
 repair/zoned.c           |    5 +-
 4 files changed, 47 insertions(+), 114 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index fe00e19bada9d8..d7c912e778799c 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -412,7 +412,7 @@
 #define xfs_verify_rgbno		libxfs_verify_rgbno
 #define xfs_verify_rtbno		libxfs_verify_rtbno
 #define xfs_zero_extent			libxfs_zero_extent
-#define xfs_zone_validate		libxfs_zone_validate
+#define xfs_validate_blk_zone		libxfs_validate_blk_zone
 
 /* Please keep this list alphabetized. */
 
diff --git a/libxfs/xfs_zones.h b/libxfs/xfs_zones.h
index df10a34da71d64..c16089c9a652da 100644
--- a/libxfs/xfs_zones.h
+++ b/libxfs/xfs_zones.h
@@ -37,7 +37,8 @@ struct blk_zone;
  */
 #define XFS_DEFAULT_MAX_OPEN_ZONES	128
 
-bool xfs_zone_validate(struct blk_zone *zone, struct xfs_rtgroup *rtg,
-	xfs_rgblock_t *write_pointer);
+bool xfs_validate_blk_zone(struct xfs_mount *mp, struct blk_zone *zone,
+	unsigned int zone_no, uint32_t expected_size,
+	uint32_t expected_capacity, xfs_rgblock_t *write_pointer);
 
 #endif /* _LIBXFS_ZONES_H */
diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
index e31e1dc0913efe..4f9820dc54197e 100644
--- a/libxfs/xfs_zones.c
+++ b/libxfs/xfs_zones.c
@@ -16,173 +16,102 @@
 #include "xfs_zones.h"
 
 static bool
-xfs_zone_validate_empty(
+xfs_validate_blk_zone_seq(
+	struct xfs_mount	*mp,
 	struct blk_zone		*zone,
-	struct xfs_rtgroup	*rtg,
+	unsigned int		zone_no,
 	xfs_rgblock_t		*write_pointer)
 {
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
-static bool
-xfs_zone_validate_seq(
-	struct blk_zone		*zone,
-	struct xfs_rtgroup	*rtg,
-	xfs_rgblock_t		*write_pointer)
-{
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
-xfs_zone_validate_conv(
+xfs_validate_blk_zone_conv(
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
-xfs_zone_validate(
+xfs_validate_blk_zone(
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
+		return xfs_validate_blk_zone_conv(mp, zone, zone_no);
 	case BLK_ZONE_TYPE_SEQWRITE_REQ:
-		return xfs_zone_validate_seq(zone, rtg, write_pointer);
+		return xfs_validate_blk_zone_seq(mp, zone, zone_no,
+				write_pointer);
 	default:
 		xfs_warn(mp, "zoned %u has unsupported type 0x%x.",
-			rtg_rgno(rtg), zone->type);
+			zone_no, zone->type);
 		return false;
 	}
 }
diff --git a/repair/zoned.c b/repair/zoned.c
index c721709d137064..6ab91371d95af6 100644
--- a/repair/zoned.c
+++ b/repair/zoned.c
@@ -39,7 +39,10 @@ report_zones_cb(
 	if (!rtg_rmap(rtg))
 		do_warn(_("no rmap inode for zone %u."), rgno);
 	else
-		libxfs_zone_validate(zone, rtg, &write_pointer);
+		libxfs_validate_blk_zone(mp, zone, rtg_rgno(rtg),
+				xfs_rtgroup_raw_size(mp),
+				mp->m_groups[XG_TYPE_RTG].blocks,
+				&write_pointer);
 	libxfs_rtgroup_rele(rtg);
 }
 

