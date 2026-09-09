Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF2518DB35;
	Wed,  9 Sep 2026 06:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788934234; cv=none; b=LHp+AOnKTh3cb7BI25dkb+tYT4A4ODTRfLQcEvhoXd8W17JPeYBQZo4jKdzIeZzeIQ9I5sikocn2OubnxI9RXNzGaM9kJyLRTG5DlDapqQ0L9e1869Cvgnuk9weyg+38WX2hA/q2bjjUf/c04xshdtHmIf29r5i3PoqwdFvQBq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788934234; c=relaxed/simple;
	bh=DaYmASv95meRPb2QMPtAf1vd4hlcCTIwElFnavq4SVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rp8KaSbAuIr29SY9IaVI1PlKdMeTHC+zDJ+FC8Mh40FxjNVQ8mUXfIbKwnx4trmmhXNMtwoWwuE3hRFugHbIVvfBY7QJnqUpldAxW44uwzdNn+/GNHiCBZmHSjOhWn7irwK941HXzNBJ/YCuyOI+Ngc2vUA03/qNb10HnfI5T6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=viiU8F+a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="viiU8F+a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oYg5+cIvQbtmQRrwiUxm7gOfJANmcb4lV8fpYo0gA/U=; b=viiU8F+ajEHLZdvAar+D+PosWb
	NYDVSrt2e+aKJDfNSw6Zoh7S1Q32+3hshI1BpBPNNDtj31oZkylt8IB31xNC1o90vdobl/BvCmUYt
	0DjammrJYoZAQ2ztMQoSw5MJO2XfbcyyIYEs8/4YS/E+Hg3s3Lf9MmtgbaO5mmNgyTGwnqKoAunZE
	kEOAIg2DtceoZwMdBivPGY1N1D1Epq2BAgt8IpH0Efps+d+DQvZPEZ3TqYi/dkeHyVZ9cCo9Lvumx
	MAVw4gHh2pY5DECetEgijGeMQGnIt9PZ8hOc10GfpdSAc2B050Lol/ZdC/HjOBHVSzptJpMDpLQw9
	h6U5ak5w==;
Received: from [62.74.3.53] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4BVs-0000000Aqk4-0LkA;
	Wed, 09 Sep 2026 06:10:28 +0000
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
Subject: [PATCH 09/16] block,iomap: fix protection information verification with initial bvec offset
Date: Wed,  9 Sep 2026 09:08:58 +0300
Message-ID: <20260909060924.1102037-10-hch@lst.de>
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

When reconstructing a bvec_iter from an ioend for protection information
verification, iomap currently ignores the offset into the initial
bio_vec.

This can't happen for buffered I/O or direct I/O to user addresses, but
is exercised by splice on O_DIRECT file descriptors or when using the
loop driver in direct I/O mode.

Fortunately the only file system PI user (XFS) currently always bounce
buffers, so this can't actually be triggered yet.  But we'll want to make
the bounce buffering conditional soon, for which this needs to be fixed.

Store the initial offset in struct iomap_ioend, and pass a
pre-constructed bvec_iter to fs_bio_integrity_verify.  For the
synchronous read case the fix is even simpler as this path can
simply stash away the original bvec_iter.

Fixes: 0bde8a12b554 ("block: add fs_bio_integrity helpers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 block/bio-integrity-fs.c      | 13 +++++--------
 fs/iomap/bio.c                |  4 +++-
 fs/iomap/ioend.c              | 14 ++++++++++----
 include/linux/bio-integrity.h |  3 +--
 include/linux/iomap.h         |  8 ++++++++
 5 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index 4f67b34bf289..c8e91ada8ca6 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -54,14 +54,10 @@ void fs_bio_integrity_generate(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(fs_bio_integrity_generate);
 
-int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
+int fs_bio_integrity_verify(struct bio *bio, struct bvec_iter *data_iter)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	struct bvec_iter data_iter = {
-		.bi_sector	= sector,
-		.bi_size	= size,
-	};
 
 	if (!bip || !(bip->bip_flags & BIP_CHECK_FLAGS))
 		return 0;
@@ -73,9 +69,10 @@ int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
 	 * bio.  Requires the submitter to remember the sector and the size.
 	 */
 	memset(&bip->bip_iter, 0, sizeof(bip->bip_iter));
-	bip->bip_iter.bi_sector = sector;
-	bip->bip_iter.bi_size = bio_integrity_bytes(bi, size >> SECTOR_SHIFT);
-	return blk_status_to_errno(bio_integrity_verify(bio, &data_iter));
+	bip->bip_iter.bi_sector = data_iter->bi_sector;
+	bip->bip_iter.bi_size =
+		bio_integrity_bytes(bi, data_iter->bi_size >> SECTOR_SHIFT);
+	return blk_status_to_errno(bio_integrity_verify(bio, data_iter));
 }
 
 static int __init fs_bio_integrity_init(void)
diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 48100c614431..d46c2f8ea18c 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -169,6 +169,7 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	sector_t sector = iomap_sector(srcmap, pos);
+	struct bvec_iter saved_iter;
 	struct bio_vec bvec;
 	struct bio bio;
 	int error;
@@ -178,10 +179,11 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 	bio_add_folio_nofail(&bio, folio, len, offset_in_folio(folio, pos));
 	if (srcmap->flags & IOMAP_F_INTEGRITY)
 		fs_bio_integrity_alloc(&bio);
+	saved_iter = bio.bi_iter;
 	error = submit_bio_wait(&bio);
 	if (bio_integrity(&bio)) {
 		if (!error)
-			error = fs_bio_integrity_verify(&bio, sector, len);
+			error = fs_bio_integrity_verify(&bio, &saved_iter);
 		fs_bio_integrity_free(&bio);
 	}
 	bio_uninit(&bio);
diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 573fa89c1632..332dbfb2230f 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -25,6 +25,7 @@ struct iomap_ioend *iomap_init_ioend(struct inode *inode,
 	ioend->io_parent = NULL;
 	INIT_LIST_HEAD(&ioend->io_list);
 	ioend->io_flags = ioend_flags;
+	ioend->io_bvec_offset = bio->bi_iter.bi_offset;
 	ioend->io_inode = inode;
 	ioend->io_offset = file_offset;
 	ioend->io_size = bio->bi_iter.bi_size;
@@ -308,6 +309,13 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 }
 EXPORT_SYMBOL_GPL(iomap_add_to_ioend);
 
+static int iomap_ioend_integrity_verify(struct iomap_ioend *ioend)
+{
+	struct bvec_iter data_iter = BVEC_ITER_IOEND(ioend);
+
+	return fs_bio_integrity_verify(&ioend->io_bio, &data_iter);
+}
+
 static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
 {
 	if (ioend->io_parent) {
@@ -325,10 +333,8 @@ static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
 
 	if (!ioend->io_error &&
 	    bio_integrity(&ioend->io_bio) &&
-	    bio_op(&ioend->io_bio) == REQ_OP_READ) {
-		ioend->io_error = fs_bio_integrity_verify(&ioend->io_bio,
-			ioend->io_sector, ioend->io_size);
-	}
+	    bio_op(&ioend->io_bio) == REQ_OP_READ)
+		ioend->io_error = iomap_ioend_integrity_verify(ioend);
 
 	if (ioend->io_flags & IOMAP_IOEND_DIRECT)
 		return iomap_finish_ioend_direct(ioend);
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 0ea2a8bf7efb..a954c97be0b3 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -151,7 +151,6 @@ void bio_integrity_setup_default(struct bio *bio);
 unsigned int fs_bio_integrity_alloc(struct bio *bio);
 void fs_bio_integrity_free(struct bio *bio);
 void fs_bio_integrity_generate(struct bio *bio);
-int fs_bio_integrity_verify(struct bio *bio, sector_t sector,
-		unsigned int size);
+int fs_bio_integrity_verify(struct bio *bio, struct bvec_iter *data_iter);
 
 #endif /* _LINUX_BIO_INTEGRITY_H */
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 1cc9a35fd5cc..bffdc217ad85 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -522,6 +522,7 @@ static inline u16 iomap_ioend_flags(const struct iomap *iomap)
 struct iomap_ioend {
 	struct list_head	io_list;	/* next ioend in chain */
 	u16			io_flags;	/* IOMAP_IOEND_* */
+	u32			io_bvec_offset;	/* offset into first bvec */
 	struct inode		*io_inode;	/* file being written to */
 	size_t			io_size;	/* size of the extent */
 	atomic_t		io_remaining;	/* completetion defer count */
@@ -539,6 +540,13 @@ static inline struct iomap_ioend *iomap_ioend_from_bio(struct bio *bio)
 	return container_of(bio, struct iomap_ioend, io_bio);
 }
 
+#define BVEC_ITER_IOEND(_ioend)				\
+{							\
+	.bi_sector	= (_ioend)->io_sector,		\
+	.bi_size	= (_ioend)->io_size,		\
+	.bi_offset	= (_ioend)->io_bvec_offset,	\
+}
+
 struct iomap_writeback_ops {
 	/*
 	 * Performs writeback on the passed in range
-- 
2.53.0

