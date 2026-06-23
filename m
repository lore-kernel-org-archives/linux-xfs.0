Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9AF37E317;
	Tue, 23 Jun 2026 13:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222751; cv=none; b=H+RT4fLE+s1V7QYP/4Ot+rcddsJ1Kg+uBFrbPm/GZFW1hnzb7H+5z14RDnI+9YIVvv3OmwYeleHMIbKoaHyGA/bLSIVjYuN6AdoMoJVxb8NW8LKMbmSiUBu3a6KyFLE2uHvEx0FH+5muGM7adIuw0QS2wNS4rWIA54xcHvn3Hfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222751; c=relaxed/simple;
	bh=4iabgZN5CGL3Ex6Eq88zuQhS1dnfWRPVcEEbvk/I6I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O99Xtj7xfayBfgzB3RtBBMkwy2A0oe6fmJVbeL4mQZ4xsVpT1P+mdC5SqEPEKqgsI9666nPCXNs1GXB7SqjH9PI0zTNPiRjEl1R0yxHGKzIQdp2Bxv7pGm/h1NeIpp7Uz0urg14wRp6uPoOaCA1Me1sY6XieN3/r8Pv0DGQqCbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4AYyXdKZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4AYyXdKZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BZtqiiIQedvJG2eJnZoCituw+d7bspysidkPSjAIZJI=; b=4AYyXdKZ48EQyV3nDhD0dclYim
	FYc3iQVhHs4OS22PKdZG76Hy20s+rO0CBpl050BMBzqro4xifdC8tyHCTIon85OhrNpmfpDoQZhBx
	J59XsPa+Uc2u8JnSslTfXw/HhkAD2ehC6koZY2s0omzIP24PLcyiWus5Wp0zBh4tGBfqNeyqqSkJz
	vQTwHrFnmhfUDJ5QQFNBsSqtaq7bIt8dkyGEN8NkNKtT4VIknRJWZIPUb3m3iWznTTGKEZvoS1Mrv
	O2qU/kqEhZc4DH4K4A7ol0F2ce8TJgyorZ58ERl4RzMXNqZn5ANxpGkzbgIi+vnzoqlHUDaXOmygx
	jLxtUgMQ==;
Received: from [2001:4bb8:2f6:ef61:5b2b:8638:3844:9408] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wc1YA-00000006NDF-2Zk8;
	Tue, 23 Jun 2026 13:52:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] iomap: submit read bio after each extent
Date: Tue, 23 Jun 2026 15:51:37 +0200
Message-ID: <20260623135208.1812933-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623135208.1812933-1-hch@lst.de>
References: <20260623135208.1812933-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the iomap buffered read path tries to build up read context
(i.e. bios for the typical block based case) over multiple iomaps as
long as the sector matches.  This does not take into account files
that can map to multiple different devices.  While this could be fixed
by a bdev check in iomap_bio_read_folio_range, the building up of I/O
over iomaps actually was a problem for the not yet merged ext2 iomap
port, as that does want to send out I/O at the end of an indirect
block mapped range.

So instead of adding more checks move over to a model where a bio only
spans a single iomap.  Change ->submit_read to be called after each
iteration, and pass a force argument to indicate that the bio must
be submitted set on the last iteration.  Switch the bio based users
to always submit, while keeping the single submit for fuse.

Fixes: dfeab2e95a75 ("erofs: add multiple device support")
Reported-by: Kelu Ye <yekelu1@huawei.com>
Reported-by: Yifan Zhao <zhaoyifan28@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/exfat/iomap.c       |  4 ++--
 fs/fuse/file.c         |  6 +++++-
 fs/iomap/bio.c         | 11 +++++++----
 fs/iomap/buffered-io.c | 23 +++++++++++++++--------
 fs/ntfs/aops.c         |  4 ++--
 fs/ntfs3/inode.c       |  4 ++--
 fs/xfs/xfs_aops.c      |  5 +++--
 include/linux/iomap.h  |  5 +++--
 8 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index 190fc6471f84..58e25c4e8587 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -251,9 +251,9 @@ static void exfat_iomap_read_end_io(struct bio *bio)
 }
 
 static void exfat_iomap_bio_submit_read(const struct iomap_iter *iter,
-		struct iomap_read_folio_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx, bool force)
 {
-	iomap_bio_submit_read_endio(iter, ctx, exfat_iomap_read_end_io);
+	iomap_bio_submit_read_endio(iter, ctx, force, exfat_iomap_read_end_io);
 }
 
 const struct iomap_read_ops exfat_iomap_bio_read_ops = {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e052a0d44dee..6fa3b1f55c95 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -982,13 +982,17 @@ static int fuse_iomap_read_folio_range_async(const struct iomap_iter *iter,
 }
 
 static void fuse_iomap_submit_read(const struct iomap_iter *iter,
-		struct iomap_read_folio_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx, bool force)
 {
 	struct fuse_fill_read_data *data = ctx->read_ctx;
 
+	if (!force)
+		return;
+
 	if (data->ia)
 		fuse_send_readpages(data->ia, data->file, data->nr_bytes,
 				    data->fc->async_read);
+	ctx->read_ctx = NULL;
 }
 
 static const struct iomap_read_ops fuse_iomap_read_ops = {
diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 0f31e35567b4..f71aaaf60301 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -79,7 +79,8 @@ u32 iomap_finish_ioend_buffered_read(struct iomap_ioend *ioend)
 }
 
 void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
-		struct iomap_read_folio_ctx *ctx, bio_end_io_t end_io)
+		struct iomap_read_folio_ctx *ctx, bool force,
+		bio_end_io_t end_io)
 {
 	struct bio *bio = ctx->read_ctx;
 
@@ -87,13 +88,15 @@ void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
 	if (iter->iomap.flags & IOMAP_F_INTEGRITY)
 		fs_bio_integrity_alloc(bio);
 	submit_bio(bio);
+
+	ctx->read_ctx = NULL;
 }
 EXPORT_SYMBOL_GPL(iomap_bio_submit_read_endio);
 
 static void iomap_bio_submit_read(const struct iomap_iter *iter,
-		struct iomap_read_folio_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx, bool force)
 {
-	return iomap_bio_submit_read_endio(iter, ctx, iomap_read_end_io);
+	return iomap_bio_submit_read_endio(iter, ctx, force, iomap_read_end_io);
 }
 
 static struct bio_set *iomap_read_bio_set(struct iomap_read_folio_ctx *ctx)
@@ -116,7 +119,7 @@ static void iomap_read_alloc_bio(const struct iomap_iter *iter,
 
 	/* Submit the existing range if there was one. */
 	if (ctx->read_ctx)
-		ctx->ops->submit_read(iter, ctx);
+		ctx->ops->submit_read(iter, ctx, true);
 
 	/* Same as readahead_gfp_mask: */
 	if (ctx->rac)
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8d4806dc46d4..06a216d37548 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -524,6 +524,13 @@ static void iomap_read_end(struct folio *folio, size_t bytes_submitted)
 	}
 }
 
+static void iomap_submit_read(struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx, bool force)
+{
+	if (ctx->read_ctx && ctx->ops->submit_read)
+		ctx->ops->submit_read(iter, ctx, force);
+}
+
 static int iomap_read_folio_iter(struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, size_t *bytes_submitted)
 {
@@ -642,12 +649,12 @@ void iomap_read_folio(const struct iomap_ops *ops,
 		fsverity_readahead(ctx->vi, folio->index,
 				   folio_nr_pages(folio));
 
-	while ((ret = iomap_iter(&iter, ops)) > 0)
+	while ((ret = iomap_iter(&iter, ops)) > 0) {
+		iomap_submit_read(&iter, ctx, false);
 		iter.status = iomap_read_folio_iter(&iter, ctx,
 				&bytes_submitted);
-
-	if (ctx->read_ctx && ctx->ops->submit_read)
-		ctx->ops->submit_read(&iter, ctx);
+	}
+	iomap_submit_read(&iter, ctx, true);
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, bytes_submitted);
@@ -718,12 +725,12 @@ void iomap_readahead(const struct iomap_ops *ops,
 		fsverity_readahead(ctx->vi, readahead_index(rac),
 				readahead_count(rac));
 
-	while (iomap_iter(&iter, ops) > 0)
+	while (iomap_iter(&iter, ops) > 0) {
+		iomap_submit_read(&iter, ctx, false);
 		iter.status = iomap_readahead_iter(&iter, ctx,
 					&cur_bytes_submitted);
-
-	if (ctx->read_ctx && ctx->ops->submit_read)
-		ctx->ops->submit_read(&iter, ctx);
+	}
+	iomap_submit_read(&iter, ctx, true);
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, cur_bytes_submitted);
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index f2bb56506046..c32ecc28cb52 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -38,9 +38,9 @@ static void ntfs_iomap_read_end_io(struct bio *bio)
 }
 
 static void ntfs_iomap_bio_submit_read(const struct iomap_iter *iter,
-		struct iomap_read_folio_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx, bool force)
 {
-	iomap_bio_submit_read_endio(iter, ctx, ntfs_iomap_read_end_io);
+	iomap_bio_submit_read_endio(iter, ctx, force, ntfs_iomap_read_end_io);
 }
 
 static const struct iomap_read_ops ntfs_iomap_bio_read_ops = {
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index f9600aba1548..110c9b8208e1 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -607,9 +607,9 @@ static void ntfs_iomap_read_end_io(struct bio *bio)
 }
 
 static void ntfs_iomap_bio_submit_read(const struct iomap_iter *iter,
-		struct iomap_read_folio_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx, bool force)
 {
-	iomap_bio_submit_read_endio(iter, ctx, ntfs_iomap_read_end_io);
+	iomap_bio_submit_read_endio(iter, ctx, force, ntfs_iomap_read_end_io);
 }
 
 static const struct iomap_read_ops ntfs_iomap_bio_read_ops = {
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 51293b6f331f..42ebb2265408 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -758,13 +758,14 @@ xfs_vm_bmap(
 static void
 xfs_bio_submit_read(
 	const struct iomap_iter		*iter,
-	struct iomap_read_folio_ctx	*ctx)
+	struct iomap_read_folio_ctx	*ctx,
+	bool				force)
 {
 	struct bio			*bio = ctx->read_ctx;
 
 	/* defer read completions to the ioend workqueue */
 	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
-	iomap_bio_submit_read_endio(iter, ctx, xfs_end_bio);
+	iomap_bio_submit_read_endio(iter, ctx, force, xfs_end_bio);
 }
 
 static const struct iomap_read_ops xfs_iomap_read_ops = {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 56b43d594e6e..266844b62372 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -528,7 +528,7 @@ struct iomap_read_ops {
 	 * This is optional.
 	 */
 	void (*submit_read)(const struct iomap_iter *iter,
-			struct iomap_read_folio_ctx *ctx);
+			struct iomap_read_folio_ctx *ctx, bool force);
 
 	/*
 	 * Optional, allows filesystem to specify own bio_set, so new bio's
@@ -623,7 +623,8 @@ extern struct bio_set iomap_ioend_bioset;
 int iomap_bio_read_folio_range(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, size_t plen);
 void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
-		struct iomap_read_folio_ctx *ctx, bio_end_io_t end_io);
+		struct iomap_read_folio_ctx *ctx, bool force,
+		bio_end_io_t end_io);
 
 extern const struct iomap_read_ops iomap_bio_read_ops;
 
-- 
2.53.0

