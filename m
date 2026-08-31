Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FB93ADBA2;
	Mon, 31 Aug 2026 06:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158512; cv=none; b=hHiHbdTIFfmWeahsHy1UaXnQWIxYr9vleW/JUEJRhGiDR8kxU7XN3wRCUNcUEp//EOJwz1oKsVhM6Ur2GlP/kQiAPVOfR3CNSk3uUSJD/6q1KsaQ8xvRsIU5U3UcX7nKZST07zxj0Ot3LV+Bp4ATHtz3aCO5O0gTuj5MX3jUiQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158512; c=relaxed/simple;
	bh=Mr102PszvmucpVvUa85Lc0Quy9g1rE8NfS/Lw/zl4wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMNrZ5K10QvxdS9/WV/ua2TQAeE0lavPamB97EhjozFmWbhc+vA655GwvH2HlziMKnrOKH8BWeFEciY+B5at9BfbRdqHievB5hIuOcT9isbAkv5i2liriQQdvkhu5eH/qql+iDHK5E3E6gZsD+G8JUyKTAoEXtjTgGc9Za5HtYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GStLM/rn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GStLM/rn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jrDnnWkm0JvO/3bn8QsNhKMU5xl18Xrr0nbb8+l/Tb0=; b=GStLM/rnz6DikuJoaCZ6AtgVyw
	34qeaflYovvwc5NrDmPHq+PXaEEdyRS3KBVHVfwVu/EqdXxh8dM6uJjVTsQItyroWHA5ksQwF4bpK
	PMdbshBUrv+okf93jWG3qO/NTYeEspi6BhM3hu1eLUmzaYXEnTEDPwXK4XDBxiJvdU+9xtYDo7VSR
	bWxU4LTkFvCMirGC67gYM9fwSFroCanL5kJyV53QqHIAnyM3YmVhWm1mOqk6I4S0LXXonJTW/Tq8I
	xpIrh+wIBJkO1lkfNENJxwKw56/6Ay11RHdkMhuIKx9z0dW5ZWhAcNAafwdqWblXDsIg4BN0Igu0a
	KDldifLQ==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0viH-00000008d02-15Nk;
	Mon, 31 Aug 2026 06:41:49 +0000
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
Subject: [PATCH 15/17] xfs: add error injection for lazy bounce buffering
Date: Mon, 31 Aug 2026 09:40:03 +0300
Message-ID: <20260831064010.2574896-16-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831064010.2574896-1-hch@lst.de>
References: <20260831064010.2574896-1-hch@lst.de>
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
index c21cbd7b0a6d..17f7fbaef14f 100644
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
@@ -106,7 +108,8 @@ xfs_end_io_read(
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

