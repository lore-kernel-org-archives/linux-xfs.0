Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A943EFFB9
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 12:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885594; cv=none; b=i6yH8e+4JV6/Dxsu89SetqrQIRoOyxmNQLMVXgQpQUUzALfff2VK4KOAhjy98UBFr3/+R5lpB0e/43B98UPirLT789q6+4FopX/zVljutA3Vt3l657kImZy4vaars4MXINM7NQThm8RTidltURrJ4YMVOO2JwDK3JtbNliSaJas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885594; c=relaxed/simple;
	bh=DQjeNgmQjOVSlt3/oZ+Eq8thrD4ElQ1pwa95zaZ1GLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apMr59ucbkX5ikMPx3YmDusWqFFwEyEFr71U+tm4+lP8G6Xcw05iNi00u3p9W2Bhiiv/tUBILsLujrhJHa2QJY+PVgfRne+7AosOaLIlolXOareuPHvMkHVXn0nb/+6DeRZ2PJmtuyvR/50wBLdjZ8NUoltSZiLXm3Hh+lyu3R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AFlWtu5H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AFlWtu5H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lok8bu2leu65dXBPpZXQo2bR/iAB392A2ohchHWTQo0=; b=AFlWtu5HZHYpxnRU44TzadV5Mw
	aGJgO45RO4mli2mQH/1otPUfmJocNsklaC9BLfGtkhgmkUh+tYY8sya2SMF2IxC/02WGklV7erf8P
	oAynxvUgoiN50E72fheZVJ8F2FcUwiPICSawL+7GYhJLTHUWi9YCvapi99LAUYZOpLihUbIE1FxuF
	zOXvAhZNhYWeWZ3mLps8IXWCzmH57JREMNQTFs1GEcrTrzzwsZmyu2nmiEItJ/F+Iw1v7DjHO6yWo
	ktJjaKMJ2VUnzvvdlptfMA4Vcqvfoht64MH+5fp5HDJxfJ1wXRToLI8kLMIwS83iVaKlMpqTXKE3T
	R194KxWQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSDY8-000000047D3-0H9Q;
	Wed, 27 May 2026 12:39:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: factor rtgroup geom write pointer reporting into a helper
Date: Wed, 27 May 2026 14:39:29 +0200
Message-ID: <20260527123941.2319377-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527123941.2319377-1-hch@lst.de>
References: <20260527123941.2319377-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Sticks out a bit better if we add a separate helper for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 737afcb5652a..96af6b62ce39 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -409,6 +409,26 @@ xfs_ioc_ag_geometry(
 	return 0;
 }
 
+static void
+xfs_rtgroup_report_write_pointer(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rtgroup_geometry *rgeo)
+{
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	if (rtg->rtg_open_zone) {
+		rgeo->rg_writepointer = rtg->rtg_open_zone->oz_allocated;
+	} else {
+		xfs_rgblock_t	highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
+
+		if (highest_rgbno == NULLRGBLOCK)
+			rgeo->rg_writepointer = 0;
+		else
+			rgeo->rg_writepointer = highest_rgbno + 1;
+	}
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+	rgeo->rg_flags |= XFS_RTGROUP_GEOM_WRITEPOINTER;
+}
+
 STATIC int
 xfs_ioc_rtgroup_geometry(
 	struct xfs_mount	*mp,
@@ -416,7 +436,6 @@ xfs_ioc_rtgroup_geometry(
 {
 	struct xfs_rtgroup	*rtg;
 	struct xfs_rtgroup_geometry rgeo;
-	xfs_rgblock_t		highest_rgbno;
 	int			error;
 
 	if (copy_from_user(&rgeo, arg, sizeof(rgeo)))
@@ -435,21 +454,8 @@ xfs_ioc_rtgroup_geometry(
 	error = xfs_rtgroup_get_geometry(rtg, &rgeo);
 	if (error)
 		goto out_put_rtg;
-
-	if (xfs_has_zoned(mp)) {
-		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
-		if (rtg->rtg_open_zone) {
-			rgeo.rg_writepointer = rtg->rtg_open_zone->oz_allocated;
-		} else {
-			highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
-			if (highest_rgbno == NULLRGBLOCK)
-				rgeo.rg_writepointer = 0;
-			else
-				rgeo.rg_writepointer = highest_rgbno + 1;
-		}
-		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
-		rgeo.rg_flags |= XFS_RTGROUP_GEOM_WRITEPOINTER;
-	}
+	if (xfs_has_zoned(mp))
+		xfs_rtgroup_report_write_pointer(rtg, &rgeo);
 
 	if (copy_to_user(arg, &rgeo, sizeof(rgeo)))
 		error = -EFAULT;
-- 
2.53.0

