Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAAE2DC34E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769530032; cv=none; b=SNkenFSWetU+Q2H/zwumgKwF4+NclTn8ZXCXjANqb1tAkvP3/09o4Z46wZAjuXf9Db+fpJuWXPbuljUZkM+eTAm+C5Z0wqphHbLVWP8m+ETUQlCqS+fTCUXe/ogDl4mSLMMVMvNvoCCdzcWCv3RXMLPd5l/4U5NKrsFRpUqB6HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769530032; c=relaxed/simple;
	bh=Y1Y+L3RJttrwrXIgJwY6hxqAdfsAhi1Ql5blO8L4sBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9eUrcwNZuZTN9XZLEQCGL0w+TF2IkslZqjvNS4CvSOs6SMyFsqdoa8Sa/Iu0ESskcvNMbVUcxaVTDByfkN/6GSxlQ5OeNfWWbCrLGa/M1Ahk1eMDtQ37VajHt7I90PbNnv2NtNxW90sWw/zdQTl5QmSRTJE9HHfpwlYmwf44/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1WBbv097; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1WBbv097"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Awi/uSl8RGfxfBYm8W7753RRtmOCLrLvWB76jAN6BQk=; b=1WBbv097WxqchEB0KcGuuS8w+A
	TjYT7xJLafxDZVHoX5GyfcHT+TVSbAmnAqiBKTvTPHw0Kzn0s0axw+HZ6em2bJCyKdPS9CHRvR34U
	it+y7+orjhJmcUFioUeKskX0zzoqKIZBeBj/JZASL9LiicDRrTAI3lSiupGQmcA4TSR2uz3h7LWSU
	RZMK1C5p5U6c6UyaY+HbzU4bzxmdvECyJU6JSHIl2d84jjr6LVLNEyNJhUJ0qe/xOjGu6HmIhJKeP
	9H7TSRuDl2J88TMZHkp0Ky+XDzh6hLKHLsgcN2Z++iXzkU4fgj6ltuhOJIipYX/9vOtmvDjf4OQN5
	P0D8dggQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vklaw-0000000Ebp1-186V;
	Tue, 27 Jan 2026 16:07:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/10] xfs: add zone reset error injection
Date: Tue, 27 Jan 2026 17:05:49 +0100
Message-ID: <20260127160619.330250-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260127160619.330250-1-hch@lst.de>
References: <20260127160619.330250-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a new errortag to test that zone reset errors are handled correctly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_errortag.h |  6 ++++--
 fs/xfs/xfs_zone_gc.c         | 13 +++++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index b7d98471684b..6de207fed2d8 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -74,7 +74,8 @@
 #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
 #define XFS_ERRTAG_FORCE_ZERO_RANGE			46
-#define XFS_ERRTAG_MAX					47
+#define XFS_ERRTAG_ZONE_RESET				47
+#define XFS_ERRTAG_MAX					48
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -135,7 +136,8 @@ XFS_ERRTAG(WB_DELAY_MS,		wb_delay_ms,		3000) \
 XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
 XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
 XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
-XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4)
+XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4) \
+XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)
 #endif /* XFS_ERRTAG */
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 4023448e85d1..570102184904 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -16,6 +16,8 @@
 #include "xfs_rmap.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_errortag.h"
+#include "xfs_error.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_zone_priv.h"
 #include "xfs_zones.h"
@@ -898,9 +900,17 @@ xfs_submit_zone_reset_bio(
 	struct xfs_rtgroup	*rtg,
 	struct bio		*bio)
 {
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
 	trace_xfs_zone_reset(rtg);
 
 	ASSERT(rtg_rmap(rtg)->i_used_blocks == 0);
+
+	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_ZONE_RESET)) {
+		bio_io_error(bio);
+		return;
+	}
+
 	bio->bi_iter.bi_sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
 	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
 		/*
@@ -913,8 +923,7 @@ xfs_submit_zone_reset_bio(
 		}
 		bio->bi_opf &= ~REQ_OP_ZONE_RESET;
 		bio->bi_opf |= REQ_OP_DISCARD;
-		bio->bi_iter.bi_size =
-			XFS_FSB_TO_B(rtg_mount(rtg), rtg_blocks(rtg));
+		bio->bi_iter.bi_size = XFS_FSB_TO_B(mp, rtg_blocks(rtg));
 	}
 
 	submit_bio(bio);
-- 
2.47.3

