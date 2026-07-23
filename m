Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C58642AFA4;
	Thu, 23 Jul 2026 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818304; cv=none; b=GDZcvJ5aCgJXnEXd3kmEh7u4b0RhfvQwXBoeVSmVg1SmoEUffDMh3hkYd5Fkeb+bc4KoMjU8AEDflzs63JnUr24FscCItJFFvB6C2VGhBAGCWWk7tHQ9DREEtufP9K/4r77WmDeb7HiPf2QAGnzz42andEGRG/y0HFDj8VVFPcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818304; c=relaxed/simple;
	bh=TrbcABh730O/6aVRms7qvNehJn7IJZpbWIf32L6fHb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnhygJdnGWMihfmdxmS4xihSA8/xJLhtlIlye8dSug48u5+P96aaIGcXGsXsmc6h3HU1fjfluo06NMCtPrjSEEuFu8cDiQjJx8TubsGPtp6+f3JqynskLrFauXfNR270l2HUXKLt79Nzu1CtYjMVA6NPAlhRX6wW3GFy7qBnMnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TCqGM7/A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TCqGM7/A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UQHZIgfPewq4RznA/pWJf+pJLqK+vpN3/sQdUIe1f50=; b=TCqGM7/AszsUPM5f+JS3hP/EKV
	CmIpUS0l06f7kX96bJWS7gtx7G1EFI37hYZDFHpw+cXiMN+U4uT4tn6ZegVAx0iLX7Ih6SHJO8778
	cOtzeeXIXB2Z6UmNNCmoglG75bfpWQOxIlQmks0bcnIXTAE4BlrBlmmQeUAIbWRl969Gyj47SAjp5
	dZuCY20vQuaDuA86IFVscpTLq7oicPwD+gu1j0yH0RxsjmMR3Kbb0QnV4qLTF6bNqsN4FIUzYgg8o
	mIA1eMIqVd8bdjkNEBTv51cYuz8uamhwBfXr0EaOU+XV1pjPJcrx4TuKLvZIMROcUxFRHkNT6eXK1
	73p3gk2g==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmulx-0000000EXOn-27oK;
	Thu, 23 Jul 2026 14:51:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 21/22] xfs: add error injection for lazy bounce buffering
Date: Thu, 23 Jul 2026 16:49:46 +0200
Message-ID: <20260723145000.116419-22-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723145000.116419-1-hch@lst.de>
References: <20260723145000.116419-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add an error injection know to exercise the lazy bounce buffering
code path, i.e. to inject direct I/O re-read using the bounce buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_errortag.h | 6 ++++--
 fs/xfs/xfs_ioend.c           | 5 ++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 6de207fed2d8..2dc441da0333 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -75,7 +75,8 @@
 #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
 #define XFS_ERRTAG_FORCE_ZERO_RANGE			46
 #define XFS_ERRTAG_ZONE_RESET				47
-#define XFS_ERRTAG_MAX					48
+#define XFS_ERRTAG_BOUNCE_REREAD			48
+#define XFS_ERRTAG_MAX					49
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -137,7 +138,8 @@ XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
 XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
 XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
 XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4) \
-XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)
+XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)  \
+XFS_ERRTAG(BOUNCE_REREAD,	bounce_reread,		XFS_RANDOM_DEFAULT)
 #endif /* XFS_ERRTAG */
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 94a81fb679ed..641f0d881b07 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -16,6 +16,8 @@
 #include "xfs_reflink.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_ioend.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
 #include <linux/bio-integrity.h>
 
 static void
@@ -103,7 +105,8 @@ xfs_end_io_read(
 			 * but right now we can't distinguish them from other
 			 * (i.e, reftag) errors.
 			 */
-			if (error) {
+			if (error ||
+			    XFS_TEST_ERROR(mp, XFS_ERRTAG_BOUNCE_REREAD)) {
 				xfs_read_bounce_and_resubmit(ioend);
 				return;
 			}
-- 
2.53.0

