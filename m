Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A416D39E191;
	Wed,  9 Sep 2026 06:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934204; cv=none; b=NzQ0Tml6py9fNeeb796J7QxSI8zbhAhacVr7d+tQv+sAJcTg1sfcwzRRltoPOsA4ejmuu7qoy1W8QxdfJKfiCyTd6yLMwh1xBDr8/1W7F+1SAHBHyRW5oUHscBnS7lVzrFPxUN1T8HcgjOlsXYJtik8v3h02dF1vUNlKZ7+lKWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934204; c=relaxed/simple;
	bh=x9Ul9GWRsmPmv2KCS5BrBcBxcYpQm2Rk60VZo/VSrLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRKIrT0PZNfwWtNxJLi08ImCyUsyZkwppBOBVSn/58RPYXIUETJaiJn01KDp5E8oGOKhoFOi1lL9pnk96nQPX1aS4F6k1AVAoNRbWagX9utCtVzeAm6UeCUj3W3KbGZfc4I2qg3dbHXhQqv7jHaZfRBRfYZVy94Ftc5IrBJY1bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1YvdK8Z2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1YvdK8Z2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FR6GXvgnyP0KtvuW82iojHgvTOIATDbErIs4iGI0X2M=; b=1YvdK8Z2tnyAo8ceVXlOP2GEVI
	hfGAiw0tytFFAjZdZcGEf+gj9nKxK5lWsY9xJFGnIy00FSt4/pbB7YkQ3A5Y2h0h52J+2YkabsiOq
	ULPZvOBEZEPsRFyVQEHrGJLOBNAAHWwzZmCn1urC0dR48hq/SRMFYw5szwaf/VHgh3VfzKpPjqlA3
	j4Iou6uUmGe7YlxjDRRZq1RIUo42kO8WPdMFN628Ar9FjHPkZi+WEekjyJJ1boP/JKjblKx5be1gD
	orFcS/BLzPk0QxBvKUgId8ndqqUVv3bhLhlObgnMy5MBkgxgA4rIS26uriz5GaKwSiTkXUccwiIrM
	9o03PgdA==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BVQ-0000000Aqhd-3Ftx;
	Wed, 09 Sep 2026 06:10:01 +0000
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
Subject: [PATCH 06/16] iomap: add a IOMAP_IOEND_INTEGRITY flag
Date: Wed,  9 Sep 2026 09:08:55 +0300
Message-ID: <20260909060924.1102037-7-hch@lst.de>
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

This will make it easier to share code for the various submit callback
provided by the file system to iomap.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/ioend.c      |  2 +-
 fs/xfs/xfs_aops.c     |  5 +++--
 fs/xfs/xfs_file.c     |  5 +++--
 include/linux/iomap.h | 12 +++++++++++-
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 2d77c11e3c18..573fa89c1632 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -149,7 +149,7 @@ int iomap_ioend_writeback_submit(struct iomap_writepage_ctx *wpc, int error)
 		return error;
 	}
 
-	if (wpc->iomap.flags & IOMAP_F_INTEGRITY)
+	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_generate(&ioend->io_bio);
 	submit_bio(&ioend->io_bio);
 	return 0;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8b6119776fb3..4e862406eee9 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -498,7 +498,7 @@ xfs_zoned_writeback_submit(
 		bio_endio(&ioend->io_bio);
 		return error;
 	}
-	if (wpc->iomap.flags & IOMAP_F_INTEGRITY)
+	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_generate(&ioend->io_bio);
 	xfs_zone_alloc_and_submit(ioend, &XFS_ZWPC(wpc)->open_zone);
 	return 0;
@@ -588,7 +588,8 @@ xfs_bio_submit_read(
 	struct bio			*bio = ctx->read_ctx;
 
 	/* defer read completions to the ioend workqueue */
-	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
+	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset,
+		iomap_ioend_flags(&iter->iomap));
 	iomap_bio_submit_read_endio(iter, ctx, xfs_end_bio);
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 426a67b813a7..4d7a284fcff9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -241,7 +241,8 @@ xfs_dio_read_bounce_submit_io(
 	struct bio		*bio,
 	loff_t			file_offset)
 {
-	iomap_init_ioend(iter->inode, bio, file_offset, IOMAP_IOEND_DIRECT);
+	iomap_init_ioend(iter->inode, bio, file_offset,
+		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
 	bio->bi_end_io = xfs_end_bio;
 	submit_bio(bio);
 }
@@ -732,7 +733,7 @@ xfs_dio_zoned_submit_io(
 
 	bio->bi_end_io = xfs_end_bio;
 	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
-			IOMAP_IOEND_DIRECT);
+		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
 	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 8e09b2d4eda0..1cc9a35fd5cc 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -483,13 +483,20 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_BOUNDARY		(1U << 2)
 /* is direct I/O */
 #define IOMAP_IOEND_DIRECT		(1U << 3)
+/* generate integrity (PI) information */
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+#define IOMAP_IOEND_INTEGRITY		(1U << 4)
+#else
+#define IOMAP_IOEND_INTEGRITY		0
+#endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
  * (IOMAP_IOEND_BOUNDARY also prevents merges, but only one-way)
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
-	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
+	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
+	 IOMAP_IOEND_INTEGRITY)
 
 /* ioend flags directly implied by iomap flags */
 static inline u16 iomap_ioend_flags(const struct iomap *iomap)
@@ -500,6 +507,9 @@ static inline u16 iomap_ioend_flags(const struct iomap *iomap)
 		flags |= IOMAP_IOEND_UNWRITTEN;
 	if (iomap->flags & IOMAP_F_SHARED)
 		flags |= IOMAP_IOEND_SHARED;
+	if (iomap->flags & IOMAP_F_INTEGRITY)
+		flags |= IOMAP_IOEND_INTEGRITY;
+
 	return flags;
 }
 
-- 
2.53.0

