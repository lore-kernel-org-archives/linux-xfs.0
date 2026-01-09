Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71B1368283
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 17:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767979315; cv=none; b=hr20wpgzuvbCE6XmK5ztrFW38Ku75LpStkcl5RH7uuEGhToa6tN0V83zzO95fveXVxWQgXsbfuMJFfp9C6Owum8Y+3BlgKr+52iVj7KSIcMUX+foPsaAu3IYEi5YQ6fvuo4ixr/3+uky/9RkwRY3Uqgq6YP+bYIAf3yVqUaQP5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767979315; c=relaxed/simple;
	bh=6J2kODReLOs8MSKY/RKp+2t407Anrxj2sXHrXyBFFsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxt99GBVAoHOEUBAwdiDp/CSbVt+7AJFOjil8f9vvbfJnsyWlKNYPO/W0R74WFMKADMgQCbPJR99EGL75onux/rQou3DmjQVJyFKSenPpAw0vmyQZB5Cqrctw4RkRBvzPuUepvZ4fF3X2y0tz5aXjf/pwxsvD36Oe7/4hKyCkL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qRQmDaZ9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qRQmDaZ9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mI5gSCyQy2wER+CgekdDjuPBSHGPbRhz8Idb1mNp1Cc=; b=qRQmDaZ9STK9p1EpAlJQupgFQr
	QKrC7QAQPjSm5X9Uizc3E0kqVdn5TM8USo4TMQcKyvkTkqEP/7Q0efXpTFIH1TJyhOvBqz3sNgmQb
	PW2Pg0FXvD3169bKao60HgtV1cicS1tfnnNAgv4AcSR7n7wMd2oNqjfZMlVi63+zlIhub9rCjJD/+
	HWbA/dar5WEEr2uYedl7PvnyVOehjHONchUE5L3vDzE0OovZKajUbca6WyDHPAnN69UEarxrXmKMz
	6Ohz3jFqMgQx5RoqZewu/bCWjG9xrekUrOlUI9Z3xiVlRWwQ2DbBEa8vOHhyJHc2ACoeLrqNOOU0l
	DIzr4JBg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veGBL-00000002nYO-0kUp;
	Fri, 09 Jan 2026 17:21:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: pass the write pointer to xfs_init_zone
Date: Fri,  9 Jan 2026 18:20:48 +0100
Message-ID: <20260109172139.2410399-4-hch@lst.de>
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

Move the two methods to query the write pointer out of xfs_init_zone into
the callers, so that xfs_init_zone doesn't have to bother with the
blk_zone structure and instead operates purely at the XFS realtime group
level.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 66 +++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index bbcf21704ea0..013228eab0ac 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -981,43 +981,43 @@ struct xfs_init_zones {
 	uint64_t		reclaimable;
 };
 
+/*
+ * For sequential write required zones, we restart writing at the hardware write
+ * pointer.
+ *
+ * For conventional zones or conventional devices we have query the rmap to
+ * find the highest recorded block and set the write pointer to the block after
+ * that.  In case of a power loss this misses blocks where the data I/O has
+ * completed but not recorded in the rmap yet, and it also rewrites blocks if
+ * the most recently written ones got deleted again before unmount, but this is
+ * the best we can do without hardware support.
+ */
+static xfs_rgblock_t
+xfs_rmap_write_pointer(
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
+		write_pointer = xfs_rmap_write_pointer(rtg);
+	error = xfs_init_zone(iz, rtg, write_pointer);
 	xfs_rtgroup_rele(rtg);
 	return error;
 }
@@ -1290,7 +1297,8 @@ xfs_mount_zones(
 		struct xfs_rtgroup	*rtg = NULL;
 
 		while ((rtg = xfs_rtgroup_next(mp, rtg))) {
-			error = xfs_init_zone(&iz, rtg, NULL);
+			error = xfs_init_zone(&iz, rtg,
+					xfs_rmap_write_pointer(rtg));
 			if (error) {
 				xfs_rtgroup_rele(rtg);
 				goto out_free_zone_info;
-- 
2.47.3

