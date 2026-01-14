Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE6133F8A7
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 06:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768373658; cv=none; b=DuJ166n+sbBbvTeZoyB1mHL+oE06a5Oty6u3R0FB3MXhVzICDVd+PjyFoJXR7MkkVH+Pm6U7wZrFfwwerJTznMOBE3gHi698VoBMGBEMI8SSKN1W8azWAYHVyjtfkhy6Ab3qbYdS12Z2EVPjKEKPCG6kWVQqx+wVuVQrWVWNMIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768373658; c=relaxed/simple;
	bh=7LERgt4zcqhs9Y3p6osnZNCGtS2Nemf9y/lm6s3meJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCkAijOka+xyvgItBnNXtOYpcFMKzpkfborbUXez4g6o4RM3oYDgn1wOmIL/cumChfBf0ESAvP3yrLlOi7Bk6jexAW9aloQDc8BwWCBH+IVghZRLGh83duB9mDTSeiJWJVw/cvNg9IdxTKCz8r3gcCDFOYtfbx0c3hjma5JS10U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DD8hTFEK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DD8hTFEK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UFkznxLUX7SE3vtwNee+t57DxsbRIidc76+maVOcOyo=; b=DD8hTFEKzeL/32nIreCCdc91og
	YcttDlH1XhHk4QOwElvJFbf82rtuyEE9UcTt14QmmEmvSVf2jPgORBYGZ9zCXtVbcMSGcKbV1jQqs
	s/MSRdhJlmtOmTBZajFUvib2HevNtUb8vG09WQ0N83PeLpUi5KhZr5zW6VKCRvU6pjOby5ynOFz37
	C3qSOMBLjFqfCu3v8zWJOAtjzrG6NxS7+ULC1iQxuMBvPCNtCkOjPMivR0uKuMNlFHeX7ZXzlMeko
	hqxkn6hqPFFNSfzqsII8EPFvI7FbpcS/slJ5BzAWO6mJh/DJwz0Ti+K4fQk6TEeq5LnJkzahSUpns
	YfZY9+Rg==;
Received: from 85-127-106-146.dsl.dynamic.surfer.at ([85.127.106.146] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfuld-000000089iS-2rzX;
	Wed, 14 Jan 2026 06:54:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: use blkdev_get_zone_info to simplify zone reporting
Date: Wed, 14 Jan 2026 07:53:29 +0100
Message-ID: <20260114065339.3392929-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114065339.3392929-1-hch@lst.de>
References: <20260114065339.3392929-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Unwind the callback based programming model by querying the cached
zone information using blkdev_get_zone_info.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 114 ++++++++++++++++++----------------------
 1 file changed, 50 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 5ad9ae368996..211ec08cb508 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -976,7 +976,6 @@ xfs_free_open_zones(
 }
 
 struct xfs_init_zones {
-	struct xfs_mount	*mp;
 	uint32_t		zone_size;
 	uint32_t		zone_capacity;
 	uint64_t		available;
@@ -994,19 +993,52 @@ struct xfs_init_zones {
  * the most recently written ones got deleted again before unmount, but this is
  * the best we can do without hardware support.
  */
-static xfs_rgblock_t
-xfs_rmap_estimate_write_pointer(
-	struct xfs_rtgroup	*rtg)
+static int
+xfs_query_write_pointer(
+	struct xfs_init_zones	*iz,
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		*write_pointer)
 {
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct block_device	*bdev = mp->m_rtdev_targp->bt_bdev;
+	sector_t		start = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
 	xfs_rgblock_t		highest_rgbno;
+	struct blk_zone		zone = {};
+	int			error;
+
+	if (bdev_is_zoned(bdev)) {
+		error = blkdev_get_zone_info(bdev, start, &zone);
+		if (error)
+			return error;
+		if (zone.start != start) {
+			xfs_warn(mp, "mismatched zone start: 0x%llx/0x%llx.",
+				zone.start, start);
+			return -EFSCORRUPTED;
+		}
+
+		if (!xfs_validate_blk_zone(mp, &zone, rtg_rgno(rtg),
+				iz->zone_size, iz->zone_capacity,
+				write_pointer))
+			return -EFSCORRUPTED;
+
+		/*
+		 * Use the hardware write pointer returned by
+		 * xfs_validate_blk_zone for sequential write required zones,
+		 * else fall through to the rmap-based estimation below.
+		 */
+		if (zone.cond != BLK_ZONE_COND_NOT_WP)
+			return 0;
+	}
 
 	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
 	highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
 	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
 
 	if (highest_rgbno == NULLRGBLOCK)
-		return 0;
-	return highest_rgbno + 1;
+		*write_pointer = 0;
+	else
+		*write_pointer = highest_rgbno + 1;
+	return 0;
 }
 
 static int
@@ -1084,43 +1116,6 @@ xfs_init_zone(
 	return 0;
 }
 
-static int
-xfs_get_zone_info_cb(
-	struct blk_zone		*zone,
-	unsigned int		idx,
-	void			*data)
-{
-	struct xfs_init_zones	*iz = data;
-	struct xfs_mount	*mp = iz->mp;
-	xfs_fsblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
-	xfs_rgnumber_t		rgno;
-	xfs_rgblock_t		write_pointer;
-	struct xfs_rtgroup	*rtg;
-	int			error;
-
-	if (xfs_rtb_to_rgbno(mp, zsbno) != 0) {
-		xfs_warn(mp, "mismatched zone start 0x%llx.", zsbno);
-		return -EFSCORRUPTED;
-	}
-
-	rgno = xfs_rtb_to_rgno(mp, zsbno);
-	rtg = xfs_rtgroup_grab(mp, rgno);
-	if (!rtg) {
-		xfs_warn(mp, "realtime group not found for zone %u.", rgno);
-		return -EFSCORRUPTED;
-	}
-	if (!xfs_validate_blk_zone(mp, zone, idx, iz->zone_size,
-			iz->zone_capacity, &write_pointer)) {
-		xfs_rtgroup_rele(rtg);
-		return -EFSCORRUPTED;
-	}
-	if (zone->cond == BLK_ZONE_COND_NOT_WP)
-		write_pointer = xfs_rmap_estimate_write_pointer(rtg);
-	error = xfs_init_zone(iz, rtg, write_pointer);
-	xfs_rtgroup_rele(rtg);
-	return error;
-}
-
 /*
  * Calculate the max open zone limit based on the of number of backing zones
  * available.
@@ -1255,15 +1250,13 @@ xfs_mount_zones(
 	struct xfs_mount	*mp)
 {
 	struct xfs_init_zones	iz = {
-		.mp		= mp,
 		.zone_capacity	= mp->m_groups[XG_TYPE_RTG].blocks,
 		.zone_size	= xfs_rtgroup_raw_size(mp),
 	};
-	struct xfs_buftarg	*bt = mp->m_rtdev_targp;
-	xfs_extlen_t		zone_blocks = mp->m_groups[XG_TYPE_RTG].blocks;
+	struct xfs_rtgroup	*rtg = NULL;
 	int			error;
 
-	if (!bt) {
+	if (!mp->m_rtdev_targp) {
 		xfs_notice(mp, "RT device missing.");
 		return -EINVAL;
 	}
@@ -1291,7 +1284,7 @@ xfs_mount_zones(
 		return -ENOMEM;
 
 	xfs_info(mp, "%u zones of %u blocks (%u max open zones)",
-		 mp->m_sb.sb_rgcount, zone_blocks, mp->m_max_open_zones);
+		 mp->m_sb.sb_rgcount, iz.zone_capacity, mp->m_max_open_zones);
 	trace_xfs_zones_mount(mp);
 
 	/*
@@ -1315,25 +1308,18 @@ xfs_mount_zones(
 	 * or beneficial.
 	 */
 	mp->m_super->s_min_writeback_pages =
-		XFS_FSB_TO_B(mp, min(zone_blocks, XFS_MAX_BMBT_EXTLEN)) >>
+		XFS_FSB_TO_B(mp, min(iz.zone_capacity, XFS_MAX_BMBT_EXTLEN)) >>
 			PAGE_SHIFT;
 
-	if (bdev_is_zoned(bt->bt_bdev)) {
-		error = blkdev_report_zones_cached(bt->bt_bdev,
-				XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart),
-				mp->m_sb.sb_rgcount, xfs_get_zone_info_cb, &iz);
-		if (error < 0)
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		xfs_rgblock_t		write_pointer;
+
+		error = xfs_query_write_pointer(&iz, rtg, &write_pointer);
+		if (!error)
+			error = xfs_init_zone(&iz, rtg, write_pointer);
+		if (error) {
+			xfs_rtgroup_rele(rtg);
 			goto out_free_zone_info;
-	} else {
-		struct xfs_rtgroup	*rtg = NULL;
-
-		while ((rtg = xfs_rtgroup_next(mp, rtg))) {
-			error = xfs_init_zone(&iz, rtg,
-					xfs_rmap_estimate_write_pointer(rtg));
-			if (error) {
-				xfs_rtgroup_rele(rtg);
-				goto out_free_zone_info;
-			}
 		}
 	}
 
-- 
2.47.3

