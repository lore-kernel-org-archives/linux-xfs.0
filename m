Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F835422522
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244437; cv=none; b=PwDeLrU8fcNcdX+xOsIGJPz6Cv3l+dGoHWkKkMcb0Rf1zuXeaPPYD0Ofaw/Ks53mg1KuCkp1PZ7rnS2wBJtGIefvL8qywiOGiz3aSglglKmzfSUEF7TT5sJ5Nu1Z28vsW15Af01p7rfMmQk7poialof/sWIHZNNOidxsKxaqYFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244437; c=relaxed/simple;
	bh=IJijeR9/Sjj/qDu8IXTXoDhbsxv34G+2PARq7FYLO8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akfI4axSEzoKZveeOoA63dE1Sh87n7iUKJ/OvvtNMG+C7BvLlBCTl26w8YMXrRZZNUG+gyneA2aqmLJyHyVBhqx7XbuDSkUAkzeplreSz4KZ1+5yc/ZsEp0Iw3WK3V/xeqxdD0M3j9c+gRzrZYpWmnm7g0TTt35YWchVdCybKVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QYoKgDPS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QYoKgDPS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4w6c3iges1YArqTI8XgH9sGyvjytgaOh1tbpFRkgCA8=; b=QYoKgDPS1EDZKeHdCNHhVhCcj3
	f9LrH8a/SwiY5ZfLuZKbPgPV9pUHlHiRzcvJXo/rX0EeuVJPH2y/YFe7khzFYZykMFNoVQbU74LCj
	rCrVm7J2o+1SS/A6tYLSEVuaGkobBWIbNOxxF7A1Yo+WUudgmFEOWPOY7yRZiISG2Fxnve64k2F6A
	PuhjamVMhBHOZ7mnhgvzNILRgvKUgoNg3vVDRpVo39HUShhU4BNvlPjDg/Epy0Pu+p+RKJPkUnrjg
	sQ36Htd5SUNnX4BoT7a7jBmhYuJFUs23KTXdEuVOyAazCQp+wfW9aJT2E3IMlbTgdKcvSFPe5YbiS
	GZV8g64w==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gM8-0000000AfWf-0pQC;
	Thu, 24 Sep 2026 10:07:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 27/32] libfrog: print csum geometry information
Date: Thu, 24 Sep 2026 12:04:17 +0200
Message-ID: <20260924100512.2733748-28-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/fsgeom.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index ad0476741cf5..324ccdc9b84d 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -28,6 +28,22 @@ rtdev_name(
 	return rtname;
 }
 
+static const char *
+csum_name(
+	uint8_t			csum)
+{
+	switch (csum) {
+	case XFS_CSUM_TYPE_NONE:
+		return "none";
+	case XFS_CSUM_TYPE_CRC32C:
+		return "crc32";
+	case XFS_CSUM_TYPE_CRC64:
+		return "crc64c";
+	default:
+		return "invalid";
+	}
+};
+
 void
 xfs_report_geom(
 	struct xfs_fsop_geom	*geo,
@@ -91,7 +107,8 @@ xfs_report_geom(
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
 "         =%-22s rgcount=%-4d rgsize=%u extents\n"
-"         =%-22s zoned=%-6d start=%llu reserved=%llu\n"),
+"         =%-22s zoned=%-6d start=%llu reserved=%llu\n"
+"         =%-22s csum=%-7s csumbsize=%u\n"),
 		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
@@ -108,7 +125,9 @@ xfs_report_geom(
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
 			(unsigned long long)geo->rtextents,
 		"", geo->rgcount, geo->rgextents,
-		"", zoned, geo->rtstart, geo->rtreserved);
+		"", zoned, geo->rtstart, geo->rtreserved,
+		"", csum_name(geo->rtcsum_type), geo->rtcsum_blklog ?
+			(1u << geo->rtcsum_blklog) : 0);
 }
 
 /* Try to obtain the xfs geometry.  On error returns a negative error code. */
-- 
2.53.0

