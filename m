Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E2440629B
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 15:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970785; cv=none; b=UciVXj6fqmRI3WlvZ9/ygjTzPgpE8OIFeSApcdOM7PV6v5qgBBrjjJQz2bRUqON2Agv1LsXK9SzeCpOLuzh0Xtq4E7zDlC2Uri0m5QHr815AyVVXX4iw8zx3J2CUWjhNNAN2u5SpnjzN6wOh1Mj+us9b2wM6Zj89OP1zSFplIcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970785; c=relaxed/simple;
	bh=+O2/3nQ+rfcaXn+8PugGi2DkOUTt9W008x1wfRpJNa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDRrUz2sTdYJbp2DWuEFzYIs+RL8NSI/CLRpMHo+JcdajNphg3zbSOsv5NZSTgaCeuxsJQVXAzDQbtZkIIUdk5TemRr/DGR67rVgsmKyzaWZyP895gH6Ux7eSgShxaONady5I9CQGEOhPM4HlmU3qhjADrcUugMSMzlBzrdLt0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YSqSYvhX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YSqSYvhX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EhtCahzhPc0GZ8SUOyypIm3vA6DxB0n2UaP2rCGwiqs=; b=YSqSYvhXoqTj0f+ay3YPp/9LGU
	tCXXg39noQOdkC3XthIACJN/32C/Frui+ZBiMkr2yayQHqEaO+yRYYxDn4JOxgTGMI4PwC4+1Z9ed
	7x0RD/72DDTJsKqyaA9IFhYBaUNDtAxs8d00JmlL5bTA2CI1qKMg20BCVsGyjyAThSIP75qaeVlNu
	P/HytaLmnyQrbX9pMFWQrjmVSduKoiyzgmIeOU5Vjr69GUIrX0i/HjsYEmZnYqQThm6kbrVPTTYMi
	rMT65EAo/gMHZ9yI6XOQ+tc3cRopDLFKIWMcPNBMLohS4gy4nyPe9zw2ShITUl9Rpl89CHRSX8ayY
	6b3jGCsg==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7az1-0000000DAxF-3l3I;
	Tue, 31 Mar 2026 15:26:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: refactor xfs_mount_zones
Date: Tue, 31 Mar 2026 17:26:05 +0200
Message-ID: <20260331152617.4047908-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331152617.4047908-1-hch@lst.de>
References: <20260331152617.4047908-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_mount_zones has grown a bit too big and unorganized.  Split the
zone reporting loop into a separate helper, hiding the rtg variable
there.  Print the mount message last, and also keep the VFS writeback
chunk size last instead of in the middle of the logic to calculate
the free/available blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_zone_alloc.c | 54 ++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 06e2cb79030e..e9f1d9d08620 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1230,6 +1230,29 @@ xfs_free_zone_info(
 	kfree(zi);
 }
 
+static int
+xfs_report_zones(
+	struct xfs_mount	*mp,
+	struct xfs_init_zones	*iz)
+{
+	struct xfs_rtgroup	*rtg = NULL;
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		xfs_rgblock_t		write_pointer;
+		int			error;
+
+		error = xfs_query_write_pointer(iz, rtg, &write_pointer);
+		if (!error)
+			error = xfs_init_zone(iz, rtg, write_pointer);
+		if (error) {
+			xfs_rtgroup_rele(rtg);
+			return error;
+		}
+	}
+
+	return 0;
+}
+
 int
 xfs_mount_zones(
 	struct xfs_mount	*mp)
@@ -1238,7 +1261,6 @@ xfs_mount_zones(
 		.zone_capacity	= mp->m_groups[XG_TYPE_RTG].blocks,
 		.zone_size	= xfs_rtgroup_raw_size(mp),
 	};
-	struct xfs_rtgroup	*rtg = NULL;
 	int			error;
 
 	if (!mp->m_rtdev_targp) {
@@ -1268,9 +1290,13 @@ xfs_mount_zones(
 	if (!mp->m_zone_info)
 		return -ENOMEM;
 
-	xfs_info(mp, "%u zones of %u blocks (%u max open zones)",
-		 mp->m_sb.sb_rgcount, iz.zone_capacity, mp->m_max_open_zones);
-	trace_xfs_zones_mount(mp);
+	error = xfs_report_zones(mp, &iz);
+	if (error)
+		goto out_free_zone_info;
+
+	xfs_set_freecounter(mp, XC_FREE_RTAVAILABLE, iz.available);
+	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
+			iz.available + iz.reclaimable);
 
 	/*
 	 * The writeback code switches between inodes regularly to provide
@@ -1296,22 +1322,6 @@ xfs_mount_zones(
 		XFS_FSB_TO_B(mp, min(iz.zone_capacity, XFS_MAX_BMBT_EXTLEN)) >>
 			PAGE_SHIFT;
 
-	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
-		xfs_rgblock_t		write_pointer;
-
-		error = xfs_query_write_pointer(&iz, rtg, &write_pointer);
-		if (!error)
-			error = xfs_init_zone(&iz, rtg, write_pointer);
-		if (error) {
-			xfs_rtgroup_rele(rtg);
-			goto out_free_zone_info;
-		}
-	}
-
-	xfs_set_freecounter(mp, XC_FREE_RTAVAILABLE, iz.available);
-	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
-			iz.available + iz.reclaimable);
-
 	/*
 	 * The user may configure GC to free up a percentage of unused blocks.
 	 * By default this is 0. GC will always trigger at the minimum level
@@ -1322,6 +1332,10 @@ xfs_mount_zones(
 	error = xfs_zone_gc_mount(mp);
 	if (error)
 		goto out_free_zone_info;
+
+	xfs_info(mp, "%u zones of %u blocks (%u max open zones)",
+		 mp->m_sb.sb_rgcount, iz.zone_capacity, mp->m_max_open_zones);
+	trace_xfs_zones_mount(mp);
 	return 0;
 
 out_free_zone_info:
-- 
2.47.3

