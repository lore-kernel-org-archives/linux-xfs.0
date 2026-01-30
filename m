Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFB334B404
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 05:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750451; cv=none; b=Wx47gxLAMvzmjQ3o/orQh8VO936X/QjEtv4noErXgvTJspTVuntX3UjbWoRbUjx8qkmUutxMGWqZXPZIXEmr7Ba1QscWRb+QEY6ppbA7KZd7/rZyfw+skj1+WOMvXVmViNY2OUbz6/gPsISUnnI69ve9iRO1MZIJ1zfSNPe/9jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750451; c=relaxed/simple;
	bh=VbwilhP6Gv7K0uNO049xJVclu+p7oabL/b6EBV82Bo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpAkDlwf6DA8WWtzW19MD/Ky19dBSDGibpqIkXQltETRKCXTLCrxiKXpydMHWJdLTzW7sdi1eUBuDteW/pskLITpESoY8aXvMUf/slZ6zmMG8BjvXVkAEayAGjtFYRC5uXt09/sO4zTSWyrvzwZ31maUD4UKzalnCq7M+iu5upY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OY2mdTOV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OY2mdTOV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kyzsyTa3SKj6hOMI8UOFVu65y2w7gRcKfLR0Ar6kbAc=; b=OY2mdTOVUJJmkvjHhfyFOnBsFw
	4OzS8m3Ueht0pkhPijl7DJntGSGCybrb8P6F29aos8zEQ0+qwnoSjVkk8vJ3BBiCFkQFyBVp3HF2a
	Zn5uIvdlAMvPmrriFDjPr7FB3ag8viOc8VHulYc8xShHQa++FIMX9Toqmu2yeJOvNuMPp7ZCvdnsE
	qLk4IB0b6iojKw5iFD56wrYUULvnBte99YVtKxJFhRhnfdqPVc16PgoR+J5+FIvFz9sUXh8pQDOXm
	Vt8BSbroGGaXJeIMaS0KatYqYyEmBwwsPbOpKxIEDUFeeOP5q5w6bE47qmXvsL4pvzLTIfPQzey6j
	tbONOyPg==;
Received: from [185.190.48.89] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlgw5-000000013JK-2Trd;
	Fri, 30 Jan 2026 05:20:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 09/11] xfs: add zone reset error injection
Date: Fri, 30 Jan 2026 06:19:24 +0100
Message-ID: <20260130052012.171568-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130052012.171568-1-hch@lst.de>
References: <20260130052012.171568-1-hch@lst.de>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

