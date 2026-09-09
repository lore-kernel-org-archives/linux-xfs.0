Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593FA376A06;
	Wed,  9 Sep 2026 06:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934257; cv=none; b=sZ3pPEn0LXQd/jFdJMISFCGqfzMUAfG+0ZIXoWCp98OCRSC392k9ENzv7sF+dMtysx2sIYeWXLA6i2M9gqDs9ALoYzFWXIzKgRrUSf+jgi2gHZwrChRS0fpMI8LuD3nWI5rG74EyFgFX7UrNACdIZ66Fvltx1q7suX07i2d6XeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934257; c=relaxed/simple;
	bh=8n9g/Q3fzH/AVROxfeqK3uFc4/xB/YC7Dc0Npt3uS1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZ3jlb/MrIoq5p0LLKADIPDNRjYIE+r4p84wxNJEJUEW0buOpkE1UzynlLJw+ynQP5hpIXCVHPTOYrBSqU2pOb0tIpGmif2/jFl7+rwCIZnOpwx21kCWWlFvbqAlPAQx11uYIAcCDqaW9rjj/JDk0jZ1JLr5BSFL4/ZApNIoRIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=APVQCRrf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="APVQCRrf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mBfMekdYh9Ze04ZQDVwYHco4YHYETGeQ27CubZPTigc=; b=APVQCRrfsRjDfhu9iAKoYBKVtp
	S5YWH6nsfBoHRvX8EjpZQIZypK02upPENhhGv13KaHtz3YLEW3K5omLIK/mBrWFCCOAvwa/y8Pmks
	TP4jbkCfKRphWKuxIu42eycB7JI3MYHbGMKCI4t4tG9TWlFyT7KhE4TLAR1PbpRff7RzyA0pd8pwe
	UnL2vKCgq7YlcRuG4ShQSuCaYXimtg+DGZMvUOiJ5Gx7qAtFaNNvg6opd6sHn9fwteqJV3CEau+qC
	ZzhdzJdi28X0iImm46PtzqS8V5s0HtHnb8ptuwEWAHR30aWCYBjByLdqB6hO4y+bB4zMo9yfb8XuI
	Fj4TWnpA==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BWI-0000000AqnN-2Eme;
	Wed, 09 Sep 2026 06:10:55 +0000
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
Subject: [PATCH 14/16] xfs: add error injection for lazy bounce buffering
Date: Wed,  9 Sep 2026 09:09:03 +0300
Message-ID: <20260909060924.1102037-15-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909060924.1102037-1-hch@lst.de>
References: <20260909060924.1102037-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add an error injection knob to exercise the lazy bounce buffering
code path, i.e. to inject direct I/O re-read using the bounce buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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
index 4fba8558d8d2..e70be5b86f0b 100644
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
@@ -107,7 +109,8 @@ xfs_end_io_read(
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

