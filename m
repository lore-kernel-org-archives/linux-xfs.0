Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F33845C6F8
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 09:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243893; cv=none; b=TDQcfqswoVqwQZJzSIXYbwCDOTzCt/PmGNb/DlKVJkwOGGNyJc3ByQND9AipFgSqwESWuLsHVkuCti3fvW62PGaj3WIzLEgvrnbJ0qEctlZ8KG3vaZvoVKo+RDkq3lxSxtRVJWZgjg/mIaQvRUaIbA9Rl5AGi5CoFzprOoCFj/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243893; c=relaxed/simple;
	bh=vLXAjZKFwAFqO+CHTgXn2YgoOxbjUt8O5+vjM+K0K1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syxnySffhguI7+rKUh9Q+BkXH8UOP5WmfnBZFCuHqAef64Ve8NGZMTL7oKvEr6zDoJCn+EfQokuz6amrgg7hfavBo3RxvUAi+mPEnS2cxL6vytXNlRhqy/HXvYWyiUAxBSF/ApuwIUsnRWq2YxLYnhNSBX06LIRuOWYZCFo2DSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ocZwbcYU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ocZwbcYU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3w5gLoEnvPRyAnA+vv3uOiODQTv2gq42KLFKzIC+2uQ=; b=ocZwbcYUz7sL6eVitU40GUEnhT
	sSLbEjlwRxgwdp/zKVyecau3Rhk1ICXx1EYuonrofL+UouKwXySYjBEOJMgjaE7yonkktV7vEeC1m
	gF46kdxQw+Oxpr8CuCuyOlqT1Ikm13cx6/hXTzB3lu8dcZwUUOEpegoC8ltqs2Xm1WxryesKn7qA2
	w7Ihk/vsFMhcx4gKL3C4R2LlH13s02WakDfq8G85SZXDqx8O0+Hb/LGQTyUMke1P6IDAM1Xk6ENNS
	IgxjTxz2Luf9QHY5TbUBhflGNG3D5oK0M0SK77tMmioV9tLDuFauFON9iTBomssp+fwpkFr1CqII4
	2PRHFvCw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gDE-0000000AeMw-3Ysv;
	Thu, 24 Sep 2026 09:57:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: cleanup xfs_verify_media_error
Date: Thu, 24 Sep 2026 11:57:05 +0200
Message-ID: <20260924095740.2732474-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924095740.2732474-1-hch@lst.de>
References: <20260924095740.2732474-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move all the reporting logic into xfs_verify_report_losses, and pass the
enum xfs_device instead of the group type to it.  This keeps all the
reporting related conditions and translation confined to one place.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_verify_media.c | 46 +++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index 5ead3976d511..8ce3773aa875 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -84,11 +84,14 @@ xfs_verify_report_data_lost(
 	return 0;
 }
 
-/* Walk reverse mappings to look for all file data loss */
-static int
+/*
+ * Report data loss on the physical sectors, and if possible, walk the reverse
+ * mappings to also report the loss to the files mapped to these sectors.
+ */
+static void
 xfs_verify_report_losses(
 	struct xfs_mount	*mp,
-	enum xfs_group_type	type,
+	enum xfs_device		dev,
 	xfs_daddr_t		daddr,
 	u64			bblen)
 {
@@ -97,13 +100,25 @@ xfs_verify_report_losses(
 	xfs_fsblock_t		start_bno, end_bno;
 	uint32_t		start_gno, end_gno;
 	int			error;
+	enum xfs_group_type	type;
+
+	xfs_healthmon_report_media(mp, dev, daddr, bblen);
+	if (!xfs_has_rmapbt(mp))
+		return;
 
-	if (type == XG_TYPE_RTG) {
+	switch (dev) {
+	case XFS_DEV_RT:
 		start_bno = xfs_daddr_to_rtb(mp, daddr);
 		end_bno = xfs_daddr_to_rtb(mp, daddr + bblen - 1);
-	} else {
+		type = XG_TYPE_RTG;
+		break;
+	case XFS_DEV_DATA:
 		start_bno = XFS_DADDR_TO_FSB(mp, daddr);
 		end_bno = XFS_DADDR_TO_FSB(mp, daddr + bblen - 1);
+		type = XG_TYPE_AG;
+		break;
+	default:
+		return;
 	}
 
 	tp = xfs_trans_alloc_empty(mp);
@@ -164,7 +179,6 @@ xfs_verify_report_losses(
 	}
 
 	xfs_trans_cancel(tp);
-	return 0;
 }
 
 /*
@@ -236,25 +250,11 @@ xfs_verify_media_error(
 	case BLK_STS_PROTECTION:
 	case BLK_STS_IOERR:
 	case BLK_STS_MEDIUM:
+		if (me->me_flags & XFS_VERIFY_MEDIA_REPORT)
+			xfs_verify_report_losses(mp, me->me_dev, daddr,
+					bio_bbcount);
 		break;
 	default:
-		return;
-	}
-
-	if (!(me->me_flags & XFS_VERIFY_MEDIA_REPORT))
-		return;
-
-	xfs_healthmon_report_media(mp, me->me_dev, daddr, bio_bbcount);
-
-	if (!xfs_has_rmapbt(mp))
-		return;
-
-	switch (me->me_dev) {
-	case XFS_DEV_DATA:
-		xfs_verify_report_losses(mp, XG_TYPE_AG, daddr, bio_bbcount);
-		break;
-	case XFS_DEV_RT:
-		xfs_verify_report_losses(mp, XG_TYPE_RTG, daddr, bio_bbcount);
 		break;
 	}
 }
-- 
2.53.0

