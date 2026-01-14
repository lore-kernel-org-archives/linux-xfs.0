Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F4C36E48D
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 06:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768373648; cv=none; b=PbvdTJUUC9B3q9HcxnFKgOFBsF0GA+GBpLl/Becef/4zzkWfhh+LJHmm2sLNB5K+nULFiHDZ//aOV4X/w8a9GZGelUlVguHHhaXPFELo1wV1yCRU1SAmu58qmuyhpHfaXkexbvPfpe9fDjY7Clj1Z5mnUmnZTjS3O51aNvCuapA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768373648; c=relaxed/simple;
	bh=cGjHvHxhdanmlsXihBID1DbYsOOTOmXf796Xo3G/lGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuPaoAbNqvejYVv7JZ8rUIstIQOhNgXZlhKr/SwJHndPpKQ0Ps4Wout4rP/0u+8p17w0rFUahebC3Lj6fzpUtN9LK9U1eBpmwZWQvUJm2DYKymMTzuXgy/I8JWRehfgqTnIFVJBdhwQ3+J8OC79+lrxi9izfiQAODn+KRE7Iluk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ikt0GLis; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ikt0GLis"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mjSSTbd2DMyX+jDKSzawWXxgIDUtcS8qE80TrFOUlCs=; b=ikt0GLisJmoC4DaUIeB//pg5Il
	IBq906ZSXOaeeje80n+pcZP8XrD3K4b3OHhUBSzk0RfHHWHGchepHiUPapJJq4fynd7UhdHXL+wP6
	Nz1LCxeqyp3xp9c0fDSNyoIWJ9ThoS+Z640CSp8mYETFihiVhyNRAuflJQKpWCIKAOWE+sMVu9QLY
	tpxlX75Lvakn1OOboASZqmACyEEofr9u+rdIrg55aoynsT9IirSGkThrOOyvBk6GdA+kkvSSakTB3
	abdP3syLnvLX5l5hj+yon/f8XCS+NwgEI/wSspSXrB0+2jKWV2V4Zc5G+o98OmwyMwHTYlmDctSQ7
	Dxl8yzgw==;
Received: from 85-127-106-146.dsl.dynamic.surfer.at ([85.127.106.146] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfulP-000000089hK-1jck;
	Wed, 14 Jan 2026 06:53:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: pass the write pointer to xfs_init_zone
Date: Wed, 14 Jan 2026 07:53:26 +0100
Message-ID: <20260114065339.3392929-4-hch@lst.de>
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

Move the two methods to query the write pointer out of xfs_init_zone into
the callers, so that xfs_init_zone doesn't have to bother with the
blk_zone structure and instead operates purely at the XFS realtime group
level.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 66 +++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 4ca7769b5adb..87243644d88e 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -981,43 +981,43 @@ struct xfs_init_zones {
 	uint64_t		reclaimable;
 };
 
+/*
+ * For sequential write required zones, we restart writing at the hardware write
+ * pointer returned by xfs_zone_validate().
+ *
+ * For conventional zones or conventional devices we have query the rmap to
+ * find the highest recorded block and set the write pointer to the block after
+ * that.  In case of a power loss this misses blocks where the data I/O has
+ * completed but not recorded in the rmap yet, and it also rewrites blocks if
+ * the most recently written ones got deleted again before unmount, but this is
+ * the best we can do without hardware support.
+ */
+static xfs_rgblock_t
+xfs_rmap_estimate_write_pointer(
+	struct xfs_rtgroup	*rtg)
+{
+	xfs_rgblock_t		highest_rgbno;
+
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+
+	if (highest_rgbno == NULLRGBLOCK)
+		return 0;
+	return highest_rgbno + 1;
+}
+
 static int
 xfs_init_zone(
 	struct xfs_init_zones	*iz,
 	struct xfs_rtgroup	*rtg,
-	struct blk_zone		*zone)
+	xfs_rgblock_t		write_pointer)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_zone_info	*zi = mp->m_zone_info;
 	uint32_t		used = rtg_rmap(rtg)->i_used_blocks;
-	xfs_rgblock_t		write_pointer, highest_rgbno;
 	int			error;
 
-	if (zone && !xfs_zone_validate(zone, rtg, &write_pointer))
-		return -EFSCORRUPTED;
-
-	/*
-	 * For sequential write required zones we retrieved the hardware write
-	 * pointer above.
-	 *
-	 * For conventional zones or conventional devices we don't have that
-	 * luxury.  Instead query the rmap to find the highest recorded block
-	 * and set the write pointer to the block after that.  In case of a
-	 * power loss this misses blocks where the data I/O has completed but
-	 * not recorded in the rmap yet, and it also rewrites blocks if the most
-	 * recently written ones got deleted again before unmount, but this is
-	 * the best we can do without hardware support.
-	 */
-	if (!zone || zone->cond == BLK_ZONE_COND_NOT_WP) {
-		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
-		highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
-		if (highest_rgbno == NULLRGBLOCK)
-			write_pointer = 0;
-		else
-			write_pointer = highest_rgbno + 1;
-		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
-	}
-
 	/*
 	 * If there are no used blocks, but the zone is not in empty state yet
 	 * we lost power before the zoned reset.  In that case finish the work
@@ -1066,6 +1066,7 @@ xfs_get_zone_info_cb(
 	struct xfs_mount	*mp = iz->mp;
 	xfs_fsblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
 	xfs_rgnumber_t		rgno;
+	xfs_rgblock_t		write_pointer;
 	struct xfs_rtgroup	*rtg;
 	int			error;
 
@@ -1080,7 +1081,13 @@ xfs_get_zone_info_cb(
 		xfs_warn(mp, "realtime group not found for zone %u.", rgno);
 		return -EFSCORRUPTED;
 	}
-	error = xfs_init_zone(iz, rtg, zone);
+	if (!xfs_zone_validate(zone, rtg, &write_pointer)) {
+		xfs_rtgroup_rele(rtg);
+		return -EFSCORRUPTED;
+	}
+	if (zone->cond == BLK_ZONE_COND_NOT_WP)
+		write_pointer = xfs_rmap_estimate_write_pointer(rtg);
+	error = xfs_init_zone(iz, rtg, write_pointer);
 	xfs_rtgroup_rele(rtg);
 	return error;
 }
@@ -1290,7 +1297,8 @@ xfs_mount_zones(
 		struct xfs_rtgroup	*rtg = NULL;
 
 		while ((rtg = xfs_rtgroup_next(mp, rtg))) {
-			error = xfs_init_zone(&iz, rtg, NULL);
+			error = xfs_init_zone(&iz, rtg,
+					xfs_rmap_estimate_write_pointer(rtg));
 			if (error) {
 				xfs_rtgroup_rele(rtg);
 				goto out_free_zone_info;
-- 
2.47.3

