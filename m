Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB41B2D600
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185533; cv=none; b=Lo2uo9MjlHF9mcx99UDsBzNvIvoq8Sdgpz0TI62jJg0vCa7e+y3RqgKz17y6Exo8Uff/80uXq+9GVjzGnw+RXvuTw3q3vc+fPmSRc6Rm7uYqpATX1pnrBCXFxv74HlQCdVPNtZitkfURVRCxx/2PY2w+PxM8omKcId4JYljDxeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185533; c=relaxed/simple;
	bh=D+sc/pSmZUA8AKNB3kjzui0yYosBfi1woGrsEf3++rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyyLBxJBusdAtHOCmOxyZ2s+2loogajYKRjc6XWgOOi7Qi09cjKo0py3d7bE62CLVMcE+LP0qYEcDgzvfzThXSrhY5RpLUqlKevLrwkmmzXzvjQqBv/s5pVtzx5KKVO065cY5IAIlz9iLmPnBmm0JqQ8kWBRqMoWDAqI9i2qlug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FP79uDBp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FP79uDBp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XktpU5hvFnhG1hElHYkkpBodauKLasxDdlFpjApZuFc=; b=FP79uDBpAXbcFMuuQMIV+VqEt9
	5CiroIMjMkZtp9qR03gaetaJdf/n1ykXP5GMwwkmw1k2Sg1FT5wzWDHZb3vXN7ScXt5vlIdg32jcj
	gaaLYodZjrLMMyScs8CIwlmY9/ww2VesK7wGJcsRkuH26Cy5RlJzYIvPxMAQE8MXyyN2ks5XJVwbs
	1tgE9m+NBePmgESqlusDFDR9d6CCHkss75IMuUP6md+3nSKIHJrF+ILpjv3g7llPy2UxfRNcx3R4M
	Uqc3v0zjm6lKAwdb1bf4frUezYTuPgfRrJtU7D1A25b6wqz6NDQzemeBf8AkbWDQ/tewKLJAk5oQp
	LyeyxENw==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QKh-00000006Up3-0fa3;
	Wed, 09 Apr 2025 07:58:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 43/45] xfs_scrub: handle internal RT devices
Date: Wed,  9 Apr 2025 09:55:46 +0200
Message-ID: <20250409075557.3535745-44-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Handle the synthetic fmr_device values.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase6.c   | 65 ++++++++++++++++++++++++++++--------------------
 scrub/phase7.c   | 28 +++++++++++++++------
 scrub/spacemap.c | 17 +++++++++----
 3 files changed, 70 insertions(+), 40 deletions(-)

diff --git a/scrub/phase6.c b/scrub/phase6.c
index 2a52b2c92419..abf6f9713f1a 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -56,12 +56,21 @@ dev_to_pool(
 	struct media_verify_state	*vs,
 	dev_t				dev)
 {
-	if (dev == ctx->fsinfo.fs_datadev)
-		return vs->rvp_data;
-	else if (dev == ctx->fsinfo.fs_logdev)
-		return vs->rvp_log;
-	else if (dev == ctx->fsinfo.fs_rtdev)
-		return vs->rvp_realtime;
+	if (ctx->mnt.fsgeom.rtstart) {
+		if (dev == XFS_DEV_DATA)
+			return vs->rvp_data;
+		if (dev == XFS_DEV_LOG)
+			return vs->rvp_log;
+		if (dev == XFS_DEV_RT)
+			return vs->rvp_realtime;
+	} else {
+		if (dev == ctx->fsinfo.fs_datadev)
+			return vs->rvp_data;
+		if (dev == ctx->fsinfo.fs_logdev)
+			return vs->rvp_log;
+		if (dev == ctx->fsinfo.fs_rtdev)
+			return vs->rvp_realtime;
+	}
 	abort();
 }
 
@@ -71,12 +80,21 @@ disk_to_dev(
 	struct scrub_ctx	*ctx,
 	struct disk		*disk)
 {
-	if (disk == ctx->datadev)
-		return ctx->fsinfo.fs_datadev;
-	else if (disk == ctx->logdev)
-		return ctx->fsinfo.fs_logdev;
-	else if (disk == ctx->rtdev)
-		return ctx->fsinfo.fs_rtdev;
+	if (ctx->mnt.fsgeom.rtstart) {
+		if (disk == ctx->datadev)
+			return XFS_DEV_DATA;
+		if (disk == ctx->logdev)
+			return XFS_DEV_LOG;
+		if (disk == ctx->rtdev)
+			return XFS_DEV_RT;
+	} else {
+		if (disk == ctx->datadev)
+			return ctx->fsinfo.fs_datadev;
+		if (disk == ctx->logdev)
+			return ctx->fsinfo.fs_logdev;
+		if (disk == ctx->rtdev)
+			return ctx->fsinfo.fs_rtdev;
+	}
 	abort();
 }
 
@@ -87,11 +105,9 @@ bitmap_for_disk(
 	struct disk			*disk,
 	struct media_verify_state	*vs)
 {
-	dev_t				dev = disk_to_dev(ctx, disk);
-
-	if (dev == ctx->fsinfo.fs_datadev)
+	if (disk == ctx->datadev)
 		return vs->d_bad;
-	else if (dev == ctx->fsinfo.fs_rtdev)
+	if (disk == ctx->rtdev)
 		return vs->r_bad;
 	return NULL;
 }
@@ -501,14 +517,11 @@ report_ioerr(
 		.length			= length,
 	};
 	struct disk_ioerr_report	*dioerr = arg;
-	dev_t				dev;
-
-	dev = disk_to_dev(dioerr->ctx, dioerr->disk);
 
 	/* Go figure out which blocks are bad from the fsmap. */
-	keys[0].fmr_device = dev;
+	keys[0].fmr_device = disk_to_dev(dioerr->ctx, dioerr->disk);
 	keys[0].fmr_physical = start;
-	keys[1].fmr_device = dev;
+	keys[1].fmr_device = keys[0].fmr_device;
 	keys[1].fmr_physical = start + length - 1;
 	keys[1].fmr_owner = ULLONG_MAX;
 	keys[1].fmr_offset = ULLONG_MAX;
@@ -675,14 +688,12 @@ remember_ioerr(
 	int				ret;
 
 	if (!length) {
-		dev_t			dev = disk_to_dev(ctx, disk);
-
-		if (dev == ctx->fsinfo.fs_datadev)
+		if (disk == ctx->datadev)
 			vs->d_trunc = true;
-		else if (dev == ctx->fsinfo.fs_rtdev)
-			vs->r_trunc = true;
-		else if (dev == ctx->fsinfo.fs_logdev)
+		else if (disk == ctx->logdev)
 			vs->l_trunc = true;
+		else if (disk == ctx->rtdev)
+			vs->r_trunc = true;
 		return;
 	}
 
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 01097b678798..e25502668b1c 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -68,25 +68,37 @@ count_block_summary(
 	void			*arg)
 {
 	struct summary_counts	*counts;
+	bool			is_rt = false;
 	unsigned long long	len;
 	int			ret;
 
+	if (ctx->mnt.fsgeom.rtstart) {
+		if (fsmap->fmr_device == XFS_DEV_LOG)
+			return 0;
+		if (fsmap->fmr_device == XFS_DEV_RT)
+			is_rt = true;
+	} else {
+		if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
+			return 0;
+		if (fsmap->fmr_device == ctx->fsinfo.fs_rtdev)
+			is_rt = true;
+	}
+
 	counts = ptvar_get((struct ptvar *)arg, &ret);
 	if (ret) {
 		str_liberror(ctx, -ret, _("retrieving summary counts"));
 		return -ret;
 	}
-	if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
-		return 0;
+
 	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
 	    fsmap->fmr_owner == XFS_FMR_OWN_FREE) {
 		uint64_t	blocks;
 
 		blocks = cvt_b_to_off_fsbt(&ctx->mnt, fsmap->fmr_length);
-		if (fsmap->fmr_device == ctx->fsinfo.fs_datadev)
-			hist_add(&counts->datadev_hist, blocks);
-		else if (fsmap->fmr_device == ctx->fsinfo.fs_rtdev)
+		if (is_rt)
 			hist_add(&counts->rtdev_hist, blocks);
+		else
+			hist_add(&counts->datadev_hist, blocks);
 		return 0;
 	}
 
@@ -94,10 +106,10 @@ count_block_summary(
 
 	/* freesp btrees live in free space, need to adjust counters later. */
 	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
-	    fsmap->fmr_owner == XFS_FMR_OWN_AG) {
+	    fsmap->fmr_owner == XFS_FMR_OWN_AG)
 		counts->agbytes += fsmap->fmr_length;
-	}
-	if (fsmap->fmr_device == ctx->fsinfo.fs_rtdev) {
+
+	if (is_rt) {
 		/* Count realtime extents. */
 		counts->rbytes += len;
 	} else {
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index c293ab44a528..1ee4d1946d3d 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -103,9 +103,12 @@ scan_ag_rmaps(
 	bperag = (off_t)ctx->mnt.fsgeom.agblocks *
 		 (off_t)ctx->mnt.fsgeom.blocksize;
 
-	keys[0].fmr_device = ctx->fsinfo.fs_datadev;
+	if (ctx->mnt.fsgeom.rtstart)
+		keys[0].fmr_device = XFS_DEV_DATA;
+	else
+		keys[0].fmr_device = ctx->fsinfo.fs_datadev;
 	keys[0].fmr_physical = agno * bperag;
-	keys[1].fmr_device = ctx->fsinfo.fs_datadev;
+	keys[1].fmr_device = keys[0].fmr_device;
 	keys[1].fmr_physical = ((agno + 1) * bperag) - 1;
 	keys[1].fmr_owner = ULLONG_MAX;
 	keys[1].fmr_offset = ULLONG_MAX;
@@ -140,9 +143,12 @@ scan_rtg_rmaps(
 	off_t			bperrg = bytes_per_rtgroup(&ctx->mnt.fsgeom);
 	int			ret;
 
-	keys[0].fmr_device = ctx->fsinfo.fs_rtdev;
+	if (ctx->mnt.fsgeom.rtstart)
+		keys[0].fmr_device = XFS_DEV_RT;
+	else
+		keys[0].fmr_device = ctx->fsinfo.fs_rtdev;
 	keys[0].fmr_physical = (xfs_rtblock_t)rgno * bperrg;
-	keys[1].fmr_device = ctx->fsinfo.fs_rtdev;
+	keys[1].fmr_device = keys[0].fmr_device;
 	keys[1].fmr_physical = ((rgno + 1) * bperrg) - 1;
 	keys[1].fmr_owner = ULLONG_MAX;
 	keys[1].fmr_offset = ULLONG_MAX;
@@ -216,7 +222,8 @@ scan_log_rmaps(
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	scan_dev_rmaps(ctx, ctx->fsinfo.fs_logdev, arg);
+	scan_dev_rmaps(ctx, ctx->mnt.fsgeom.rtstart ? 2 : ctx->fsinfo.fs_logdev,
+			arg);
 }
 
 /*
-- 
2.47.2

