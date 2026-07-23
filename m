Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6CB4D2EF6;
	Thu, 23 Jul 2026 14:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818267; cv=none; b=RqaE8utHc3jU6dQfTnz07+bS79vZABds+rN6wl/zmxjmiOhkM7oQDqmkgSEDAMyEgk46wxZk8UopvTVNcZO9zr1poxKb2VFJCZizH86UEzqN/ZtegarCRvlexLVB0N1UeUk0mOBNUO75S+tzo6vGYVn8lTm2KBo/G4FFTSVuGuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818267; c=relaxed/simple;
	bh=a8h4V897GT4IV/+PofgC4rxEy6gH+mTsQLRi51zhf9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ak+F5Mh9Vb6djtt00xaZGfLV3sdpHfMTScZuMMnV7pbLYUgJVGLYnDIjklKhrtHpQE8KG1r3SAZU8+dgIKdj9Pol8+Yd0d4JMf0dzAsVw5r6zAmgraoAwbtGqkOU8qy3pv5zsq6JdFynPRXOuLgE3YE/boitedrGCfkNAuxMZDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BzornNTN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BzornNTN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JlSDtLMOBHXJLeuWwyId8ToxJimcTOSIYwt13V4NPcQ=; b=BzornNTNWI8jlNTelK/NWuBBHx
	xwcqJnwW0S0vtJdx0W3/Jk5+JCeGuY4/1LXXGMpMhvle/fY3yTqb45B21MO5q9TIw+MLiKNnHWLIE
	acmTAEaTCsd0ftoPOMhL4A8KtVBZT5kSwArR08WRvioFVV+HI84scs3ydWSzDkkY2T4ZWMUFpLT3J
	cfwwjnKVlTWZn1CNGFbqCITdjjHYwmdTeJiPpXSIIIPGaX+OppgEFjMPSXw6kKzBNDJEkR/3HlH2b
	cit5ipEuQvobaJhC3zRHjRYBeio9PSFdU6VFe2C39uFd4yhaT2IjcXmLuxCJEzZ3xFsVGobtdNJgi
	c9L6r+YA==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmulH-0000000EXLf-2P4x;
	Thu, 23 Jul 2026 14:50:59 +0000
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
Subject: [PATCH 12/22] iomap: better read bounce buffering support
Date: Thu, 23 Jul 2026 16:49:37 +0200
Message-ID: <20260723145000.116419-13-hch@lst.de>
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

Add helpers to bounce buffer an upper bio into one or more lower bios
using bounce buffers, and to copy the data back on completion.

Compared to the existing IOMAP_DIO_BOUNCE support for read bios, this
has two advantages:  by removing the special bounce bio_vec it allows
to the full and "round" size of a single bio, i.e., 1MiB when using
4k pages.  This is important for good performance on HDD.  Additionally
it allows to bounce buffer a bio from completion conext, and thus
implement a "lazy" bounce buffering scheme, where the data is only
read into a bounce buffer after an initial checksum validation failure,
thus avoiding the bounce buffering I/O for most I/O.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/ioend.c      | 87 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h |  5 +++
 2 files changed, 92 insertions(+)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index d43e6229900c..34f71c8b5ebd 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -515,6 +515,93 @@ struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
 }
 EXPORT_SYMBOL_GPL(iomap_split_ioend);
 
+void iomap_bounce_read(struct iomap_ioend *orig_ioend, unsigned int minsize,
+		void (*submit_ioend)(struct iomap_ioend *ioend))
+{
+	struct inode *inode = orig_ioend->io_inode;
+	struct bio *orig_bio = &orig_ioend->io_bio;
+	loff_t file_offset = orig_ioend->io_offset;
+	sector_t sector = orig_ioend->io_sector;
+	size_t total_len = round_up(orig_ioend->io_size, minsize);
+
+	WARN_ON_ONCE(!(orig_ioend->io_flags & IOMAP_IOEND_DIRECT));
+
+	do {
+		struct iomap_ioend *ioend;
+		struct bio *bio;
+		int error;
+
+		bio = bio_alloc_bioset(orig_bio->bi_bdev,
+				min(total_len / minsize, BIO_MAX_VECS),
+				orig_bio->bi_opf, GFP_KERNEL,
+				&iomap_ioend_split_bioset);
+		error = bio_alloc_bounce_folios(bio, total_len, minsize);
+		if (error) {
+			bio_put(bio);
+			orig_bio->bi_status = errno_to_blk_status(error);
+			break;
+		}
+		bio->bi_ioprio = orig_bio->bi_ioprio;
+		bio->bi_write_hint = orig_bio->bi_write_hint;
+		bio->bi_write_stream = orig_bio->bi_write_stream;
+		bio->bi_iter.bi_sector = sector;
+
+		ioend = iomap_init_ioend(inode, bio, file_offset,
+				orig_ioend->io_flags);
+
+		total_len -= bio->bi_iter.bi_size;
+		file_offset += bio->bi_iter.bi_size;
+		sector += (bio->bi_iter.bi_size >> SECTOR_SHIFT);
+
+		bio->bi_private = orig_bio;
+		bio_inc_remaining(orig_bio);
+		submit_ioend(ioend);
+	} while (total_len > 0);
+
+	bio_endio(&orig_ioend->io_bio);
+}
+EXPORT_SYMBOL_GPL(iomap_bounce_read);
+
+static void iomap_ioend_unbounce(struct iomap_ioend *orig_ioend,
+		struct iomap_ioend *ioend)
+{
+	struct bio *orig_bio = &orig_ioend->io_bio;
+	struct iov_iter to;
+	struct bio_vec *bv;
+	int i;
+
+	iov_iter_bvec(&to, ITER_DEST, orig_bio->bi_io_vec, orig_bio->bi_vcnt,
+			orig_ioend->io_size);
+	to.iov_offset = orig_ioend->io_bvec_offset;
+
+	if (ioend->io_offset != orig_ioend->io_offset) {
+		WARN_ON_ONCE(ioend->io_offset < orig_ioend->io_offset);
+		iov_iter_advance(&to, ioend->io_offset - orig_ioend->io_offset);
+	}
+
+	/* copying to pinned pages should always work */
+	bio_for_each_bvec_all(bv, &ioend->io_bio, i)
+		WARN_ON_ONCE(copy_to_iter(bvec_virt(bv), bv->bv_len, &to) !=
+				bv->bv_len);
+}
+
+void iomap_bounce_read_end_io(struct iomap_ioend *ioend, struct bio *orig_bio,
+		int error)
+{
+	if (error)
+		orig_bio->bi_status = errno_to_blk_status(error);
+	else
+		iomap_ioend_unbounce(iomap_ioend_from_bio(orig_bio), ioend);
+
+	bio_free_folios(&ioend->io_bio);
+	if (bio_integrity(&ioend->io_bio))
+		fs_bio_integrity_free(&ioend->io_bio);
+	bio_put(&ioend->io_bio);
+
+	bio_endio(orig_bio);
+}
+EXPORT_SYMBOL_GPL(iomap_bounce_read_end_io);
+
 static int __init iomap_ioend_init(void)
 {
 	const unsigned int nr_mempool_entries = 4 * (PAGE_SIZE / SECTOR_SIZE);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index e7bee96379df..ff9afdd39682 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -509,6 +509,11 @@ void iomap_finish_folio_write(struct inode *inode, struct folio *folio,
 int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio);
 int iomap_writepages(struct iomap_writepage_ctx *wpc);
 
+void iomap_bounce_read(struct iomap_ioend *orig_ioend, unsigned int minsize,
+		void (*submit_ioend)(struct iomap_ioend *ioend));
+void iomap_bounce_read_end_io(struct iomap_ioend *ioend, struct bio *orig_bio,
+		int error);
+
 struct iomap_read_folio_ctx {
 	const struct iomap_read_ops *ops;
 	struct folio		*cur_folio;
-- 
2.53.0

