Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DE7360EF5;
	Thu, 23 Jul 2026 14:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818272; cv=none; b=GlDRyNC1KdLVgk43nzKClqykduHhoTmAwlbsHyWpzQ1W5R4Su3Rii4x3jL6AtD+sld3UVwiCee9f80768yPTCoIA6L04KhIWAu8CdS7+PSYaloiAtdM3AzvGUkJnUDm9CGNMN+Dt7tE0MZZxUJCnsdMNa0yESP8IObJC9c2laBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818272; c=relaxed/simple;
	bh=o1yxQrmkk1myVbP/+uKhFDRrXEcWaGwROk8LEKEukgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttQhe6TPaWH9I0iRNyG9gFlpn7bx9Pz39jpxt+Vfz/ASvPyMKuhX1H4R2ZYgYC0ZhC0eVYf7bAdMQwd02dDGZOVJ5mQ/1s0aeAWyznKN7PzEa5GUZwvfsxlLKpsbaSS/AxxBqfw0RnxA7nCEp1vWpXjt0+N3fhgQP2LfbG63qxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BTNCpfwW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BTNCpfwW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xXgBRl/3OPmBg8RumTXyA+J9bLF9SQh5+4M08buRldI=; b=BTNCpfwWf39VcBDp97vEn5IuMZ
	AL0Uzp1AmZSMOenVuT5fjkqi6y8E0uYTwi6SgDdxhe7sRkqqJo5Rn9bLWdFYaxN2lrdyUpzMjaWKF
	2IeDWvKlKAITlmDMP0koE+cbvcQKaQzlB+JneGYug0VkCanZB/b+fbzAzw+vpH/ymQ551RYZCUK4T
	2OCHGIlmf6LI637PoWfb2AfOEfTxnoVYXjrM5/BW44RxDhMr5gyON7U//UxDOnM9t7WCiKKzbtweY
	r8u6dXHtT6n1X5ViNhOT5BvRnUC/rTaX5nkvWfcxU6gKMBcEKfzyyN+Hy5Hja69uvjA2C5+aG1/lo
	QceaCECw==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmulP-0000000EXM1-1fYI;
	Thu, 23 Jul 2026 14:51:07 +0000
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
Subject: [PATCH 14/22] iomap: add a IOMAP_IOEND_INTEGRITY flag
Date: Thu, 23 Jul 2026 16:49:39 +0200
Message-ID: <20260723145000.116419-15-hch@lst.de>
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

This will make it easier to share code for the various submit callback
provided by the file system to iomap.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/ioend.c      |  2 +-
 fs/xfs/xfs_aops.c     |  3 ++-
 fs/xfs/xfs_file.c     |  5 +++--
 include/linux/iomap.h | 11 ++++++++++-
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index b1bca36de430..438be92e131b 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -150,7 +150,7 @@ int iomap_ioend_writeback_submit(struct iomap_writepage_ctx *wpc, int error)
 		return error;
 	}
 
-	if (wpc->iomap.flags & IOMAP_F_INTEGRITY)
+	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_generate(&ioend->io_bio);
 	submit_bio(&ioend->io_bio);
 	return 0;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 51293b6f331f..b95d74e40b06 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -763,7 +763,8 @@ xfs_bio_submit_read(
 	struct bio			*bio = ctx->read_ctx;
 
 	/* defer read completions to the ioend workqueue */
-	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
+	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset,
+		iomap_ioend_flags(&iter->iomap));
 	iomap_bio_submit_read_endio(iter, ctx, xfs_end_bio);
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 845a97c9b063..e94a26f32e65 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -235,7 +235,8 @@ xfs_dio_read_bounce_submit_io(
 	struct bio		*bio,
 	loff_t			file_offset)
 {
-	iomap_init_ioend(iter->inode, bio, file_offset, IOMAP_IOEND_DIRECT);
+	iomap_init_ioend(iter->inode, bio, file_offset,
+		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
 	bio->bi_end_io = xfs_end_bio;
 	submit_bio(bio);
 }
@@ -724,7 +725,7 @@ xfs_dio_zoned_submit_io(
 
 	bio->bi_end_io = xfs_end_bio;
 	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
-			IOMAP_IOEND_DIRECT);
+		iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
 	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 2541ebfabca0..1916a4f28002 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -406,6 +406,12 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_DIRECT		(1U << 3)
 /* is DONTCACHE I/O */
 #define IOMAP_IOEND_DONTCACHE		(1U << 4)
+/* generate integrity (PI) information */
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+#define IOMAP_IOEND_INTEGRITY		(1U << 5)
+#else
+#define IOMAP_IOEND_INTEGRITY		0
+#endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
@@ -413,7 +419,7 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
 	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
-	 IOMAP_IOEND_DONTCACHE)
+	 IOMAP_IOEND_DONTCACHE | IOMAP_IOEND_INTEGRITY)
 
 /* ioend flags directly implied by iomap flags */
 static inline u16 iomap_ioend_flags(const struct iomap *iomap)
@@ -424,6 +430,9 @@ static inline u16 iomap_ioend_flags(const struct iomap *iomap)
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

