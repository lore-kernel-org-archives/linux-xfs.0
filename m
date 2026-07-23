Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C704D9909;
	Thu, 23 Jul 2026 14:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818280; cv=none; b=EWaI7C1B0Gug3eH54B6kMWEw0FxzmZGdFnYqG7zvbluGGFuJgn2D2G7blQrUUIsz0LY1BqIO3WLRi/291KIPk3DmQSyXcZe2k7+TzdwozisAOMPu3vS7NxDTOJQmZWPTBnmnpSBBgyhd/Ghh1X0WMF1bQVZXQ1zuG5zf8CHYfPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818280; c=relaxed/simple;
	bh=t+lOx7FVVZ0vOuvELJ5ryVjfUdElXNcZLVJbPvVmeXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeTjX6feDyNTsXKNEL9g2VtBV1CBgpRTlFXSaROu96f/UhyatyLFryge6Lc2EztbzGcJR9MeV5jgBWHhIk0tLhkT2PSP5PlFK/8Cz0HbhPvjHoS+U5shbVm4AItfUA2yNyCLzeP1CeQUdX29kJMk8Qcz5oZXYCz0z6iWxSzH+vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AZ5QGUQ7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AZ5QGUQ7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xFTAMT7bZSq/EGqhCEILIyr/Q4pVIKH4YLAX8D9DxqU=; b=AZ5QGUQ7nc6eMsp+Z0YCQLA1jc
	GzshPvOtVBIko0WOtNmaVNuApbDPigKey7+q6FkLgW+jcpEjUYjTo6QTOwBIpDTy1VAQps70GewqU
	Ey8/KLKrfjOq/Z10TDW2qu6UQLB1Oi/yhrd7N88Z/mcA2WIsHnTy3XEx1avD6GuQUAxAcMi8o1Ijl
	y7ojGfUDlJ2cOL8FhObTMjI2FGZg8AqLVXJGeJxCjFcyBWfh5EEXVahTzu9kfC5xWFM52Ar89co0I
	N62whOvLuaZsK5gx+Vj46WG6Od2SSYJ3yskfY3T0aquOVLMiukpjcuHHy7fwmxB3NvjskGhNR1oX2
	G6qOzu3g==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmulY-0000000EXMf-0IQo;
	Thu, 23 Jul 2026 14:51:16 +0000
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
Subject: [PATCH 16/22] xfs: move PI generation into xfs_zone_alloc_and_submit
Date: Thu, 23 Jul 2026 16:49:41 +0200
Message-ID: <20260723145000.116419-17-hch@lst.de>
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

Keep it in one place for all the zoned write bio submissions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c       | 3 ---
 fs/xfs/xfs_file.c       | 2 --
 fs/xfs/xfs_zone_alloc.c | 4 ++++
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b95d74e40b06..0b757b7f35c0 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -22,7 +22,6 @@
 #include "xfs_icache.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
-#include <linux/bio-integrity.h>
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -673,8 +672,6 @@ xfs_zoned_writeback_submit(
 		bio_endio(&ioend->io_bio);
 		return error;
 	}
-	if (wpc->iomap.flags & IOMAP_F_INTEGRITY)
-		fs_bio_integrity_generate(&ioend->io_bio);
 	xfs_zone_alloc_and_submit(ioend, &XFS_ZWPC(wpc)->open_zone);
 	return 0;
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 80dd278e023f..2c19e69b93cd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -731,8 +731,6 @@ xfs_dio_zoned_submit_io(
 	bio->bi_end_io = xfs_end_bio;
 	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
 			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
-	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
-		fs_bio_integrity_generate(bio);
 	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
 }
 
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 7d13fa7ab30a..3fd1069beea0 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_zones.h"
 #include "xfs_trace.h"
 #include "xfs_mru_cache.h"
+#include <linux/bio-integrity.h>
 
 static void
 xfs_open_zone_free_rcu(
@@ -868,6 +869,9 @@ xfs_zone_alloc_and_submit(
 	if (xfs_is_shutdown(mp))
 		goto out_error;
 
+	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
+		fs_bio_integrity_generate(&ioend->io_bio);
+
 	/*
 	 * If we don't have a locally cached zone in this write context, see if
 	 * the inode is still associated with a zone and use that if so.
-- 
2.53.0

