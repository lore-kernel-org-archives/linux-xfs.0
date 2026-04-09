Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3128A3B47DB;
	Thu,  9 Apr 2026 16:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775750614; cv=none; b=dqmv2UtBfl5XyDvdIvCPK+8PxARdyqiNQkDbh2RP1zaHPvByLa1Yyy8Wx1z7pDkfW8rnOdR7Gq+DJ3hWVn9Ir5EqLEAeVXFjtu23UefseOCG7BOVUWv+ZW+OM9HDSQWCP4vx4B9DIifckBj+JDWdZyfpU0BhJADryzbXX2fYo5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775750614; c=relaxed/simple;
	bh=ByBeUIRk8+6qFNCyS9+C7GRM+5T+nfMbiaYgb/LOXHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsCvSqxBAeJJlSl/qY3yV6mdnQJbJaKnKI+FgP2kHUhi4pwKjdDgHVNicJqEYf0AJvUEfGsV/kVRdQticcwpfZxosarfAnF0YL/QDyS/VGBMrXdAKbzg9pfy+DWMMmyX0cyD4xFMN2wcGdU4sSH6W2HamRS6EslYViOWgvQb7cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QdjZ/VSk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QdjZ/VSk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VvqBjVaLShKCXG7WWzYTX1RSgzJgwlKF9xtSdLh7RDw=; b=QdjZ/VSk1Lr8Knl8La52m77EqR
	W99JcWVJKKtZPRUVq9lvZRMYpNT2JiS9nykTpLebCSoCgpM1BlYgjfSdCbJAI7bmN5Tx+OD+LyfM4
	Q2bZ/sVToD5Pz7toQ40a01KiG5sUggOZe/hhxBtXx9VLJjNCAV6DrGdLd/4mOuGluUkaxaUbpcUey
	HcdUXZQrHVLJMR0W0MSttn6CKtt62Xdw2JclqhceTRLmVw5nMMz5+L9lcAbSAY403Aa0yMyZ4qS5/
	7XxbhL+BQ3496mz6W1ct4SvfK//pAdrJn2ez/2pXI513zByhbUyGkXK2qmJfVDlf4WEOT2QepO9aa
	Hd5KjA8g==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArqr-0000000At5K-3D8x;
	Thu, 09 Apr 2026 16:03:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] FOLD: block: change the defer in task context interface to be procedural
Date: Thu,  9 Apr 2026 18:02:17 +0200
Message-ID: <20260409160243.1008358-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Replace the bio-flag based interface with an explicit
bio_complete_in_task() API.  The advantage is that this can also be
called from inside the ->bi_end_io callback and thus dynamically.
This will be important to use it for fserror reporting.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c                 |  7 +++----
 fs/buffer.c                 |  5 ++++-
 fs/iomap/ioend.c            | 11 ++++++++---
 include/linux/bio.h         | 17 +++++++++++++++++
 include/linux/blk_types.h   |  1 -
 include/linux/buffer_head.h |  2 ++
 include/linux/iomap.h       |  6 +++++-
 7 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 550eb770bfa6..88d191455762 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1753,7 +1753,7 @@ static void bio_complete_work_fn(struct work_struct *w)
 	} while (1);
 }
 
-static void bio_queue_completion(struct bio *bio)
+void __bio_complete_in_task(struct bio *bio)
 {
 	struct bio_complete_batch *batch = this_cpu_ptr(&bio_complete_batch);
 
@@ -1761,6 +1761,7 @@ static void bio_queue_completion(struct bio *bio)
 		mod_delayed_work_on(batch->cpu, bio_complete_wq,
 				    &batch->work, 1);
 }
+EXPORT_SYMBOL_GPL(__bio_complete_in_task);
 
 static inline bool bio_remaining_done(struct bio *bio)
 {
@@ -1836,9 +1837,7 @@ void bio_endio(struct bio *bio)
 	}
 #endif
 
-	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
-		bio_queue_completion(bio);
-	else if (bio->bi_end_io)
+	if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
 EXPORT_SYMBOL(bio_endio);
diff --git a/fs/buffer.c b/fs/buffer.c
index 289ab33fe3fd..b5de776c8491 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2673,6 +2673,9 @@ static void end_bio_bh_io_sync(struct bio *bio)
 {
 	struct buffer_head *bh = bio->bi_private;
 
+	if (buffer_dropbehind(bh) && bio_complete_in_task(bio))
+		return;
+
 	if (unlikely(bio_flagged(bio, BIO_QUIET)))
 		set_bit(BH_Quiet, &bh->b_state);
 
@@ -2725,7 +2728,7 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
 		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
 
 	if (folio_test_dropbehind(bh->b_folio))
-		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+		set_buffer_dropbehind(bh);
 
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_write_hint = write_hint;
diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 892dbfc77ae9..a32ece8a3ee3 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -117,6 +117,12 @@ static void ioend_writeback_end_bio(struct bio *bio)
 {
 	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
 
+	/* Page cache invalidation cannot be done in irq context. */
+	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE) {
+		if (bio_complete_in_task(bio))
+			return;
+	}
+
 	ioend->io_error = blk_status_to_errno(bio->bi_status);
 	if (ioend->io_error) {
 		iomap_fail_ioend_buffered(ioend);
@@ -237,6 +243,8 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
+	if (folio_test_dropbehind(folio))
+		ioend_flags |= IOMAP_IOEND_DONTCACHE;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
 		ioend_flags |= IOMAP_IOEND_BOUNDARY;
 
@@ -253,9 +261,6 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
 		goto new_ioend;
 
-	if (folio_test_dropbehind(folio))
-		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
-
 	/*
 	 * Clamp io_offset and io_size to the incore EOF so that ondisk
 	 * file size updates in the ioend completion are byte-accurate.
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 0b6744557b42..45c311e5ff71 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -375,6 +375,23 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
 
 void submit_bio(struct bio *bio);
 
+void __bio_complete_in_task(struct bio *bio);
+
+/**
+ * bio_complete_in_task - ensure a bio is complete in preemptible task context
+ * @bio: bio to complete
+ *
+ * If called from non-task context, offload the bio completion to worker thread
+ * and return %true.  Else return %false and do nothing.
+ */
+static inline bool bio_complete_in_task(struct bio *bio)
+{
+	if (in_task())
+		return false;
+	__bio_complete_in_task(bio);
+	return true;
+}
+
 extern void bio_endio(struct bio *);
 
 static inline void bio_io_error(struct bio *bio)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 0b55159d110d..8419f42de14f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -326,7 +326,6 @@ enum {
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
-	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
 	BIO_FLAG_LAST
 };
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 4ce50882d621..bd7df5883cc8 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -35,6 +35,7 @@ enum bh_state_bits {
 	BH_Prio,	/* Buffer should be submitted with REQ_PRIO */
 	BH_Defer_Completion, /* Defer AIO completion to workqueue */
 	BH_Migrate,     /* Buffer is being migrated (norefs) */
+	BH_Dropbehind,	/* drop pages on IO completion */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
@@ -136,6 +137,7 @@ BUFFER_FNS(Unwritten, unwritten)
 BUFFER_FNS(Meta, meta)
 BUFFER_FNS(Prio, prio)
 BUFFER_FNS(Defer_Completion, defer_completion)
+BUFFER_FNS(Dropbehind, dropbehind)
 
 static __always_inline void set_buffer_uptodate(struct buffer_head *bh)
 {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bf49ba71dd42..2c5685adf3a9 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -399,12 +399,16 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_BOUNDARY		(1U << 2)
 /* is direct I/O */
 #define IOMAP_IOEND_DIRECT		(1U << 3)
+/* is DONTCACHE I/O */
+#define IOMAP_IOEND_DONTCACHE		(1U << 4)
+
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
  * (IOMAP_IOEND_BOUNDARY also prevents merges, but only one-way)
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
-	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
+	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
+	 IOMAP_IOEND_DONTCACHE)
 
 /*
  * Structure for writeback I/O completions.
-- 
2.47.3

