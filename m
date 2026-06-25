Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B653DE441;
	Thu, 25 Jun 2026 12:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389300; cv=none; b=YP0wEyYsf1hcNwrVtnRtvGr1ojtnYeqWrhUEn1uIwtSYQnFoh/AoL1LtlTS7VTgVgR4WgeIJud7PQ0Lc3WMQPJ4cqZ0HID2H+zBJDnCqqR9lYoqBDiq+E0WzArU8p3Y/vnPWdcubaGRI3zO8tKYGXVuii33h+SzGH6qMPxCxjRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389300; c=relaxed/simple;
	bh=GZb/e9URDjJV1JUuVTysXpihblFa3Au7pQhJG+4vl00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nn88+QF7vzLKtTzf8SUPXpxckBSOcpZlKgMCsa/LgNywLKrss4aXz4q3jgIY9tMh2MFcHjxqHRluZmdbC6wwtgw/m5rdVKK/8nmLrMT8Yk2dARKGvSYHTeCWH7PNqRxHKTDlqNt7Z0Y8den5PKDNTvNw73fXD6NYPWBRsYmdOSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ntjp8PE7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ntjp8PE7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yGAtGrWVu1QATEaU/d3luexBJzA18wibuRcTuaPYFso=; b=Ntjp8PE7ZEpaJ/gCj60+v6Wys8
	SXrEc2pCrFBBMSsOQhf9wcG8kd7OfqJxfSwnc8Uf+CzJk6dbKlScXBuo++xQVDcBA4V/3g0XwYobi
	H0qln9Wo93pEQJ4lmsq8VzCXd5vjDsmGVaBozM0OTFVlAkZbw4fTKkMoc+cvbTtOM03fXNHHN+UD0
	eSJxL7ke7hW52OiXumFTXGKJJUwZLIqSiBw81CA5olj5rXpQYhi/Dd6Zf2AAo8F8bku5zsuUbIF8g
	ED6HaOeqjaU0LICBUFvULPRvA9D65O1Vn4ccMp+YpPMhCBOvBAWottyn3L03IAzzjSq+Qi6nbBzHO
	OEPEASUA==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcisR-000000099iL-26k0;
	Thu, 25 Jun 2026 12:08:15 +0000
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
Subject: [PATCH 1/2] iomap: consolidate bio submission
Date: Thu, 25 Jun 2026 14:07:56 +0200
Message-ID: <20260625120803.2462291-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260625120803.2462291-1-hch@lst.de>
References: <20260625120803.2462291-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a iomap_bio_submit_read_endio helper factored out of
iomap_bio_submit_read to that all ->submit_read implementations for
iomap_read_ops that use iomap_bio_read_folio_range can shared the
logic.

Right now that logic is mostly trivial, but already has a bug for XFS
because the XFS version is too trivial:  file system integrity validation
needs a workqueue context and thus can't happen from the default iomap
bi_end_io I/O handler.  Unfortunately the iomap refactoring just before
fs integrity landed moved code around here and the call go misplaced,
meaning it never got called.  The PI information still is verified by
the block layer, but the offloading is less efficient (and the future
userspace interface can't get at it).

Fixes: 0b10a370529c ("iomap: support T10 protection information")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/exfat/iomap.c      |  5 +----
 fs/iomap/bio.c        | 13 ++++++++++---
 fs/ntfs/aops.c        |  6 ++----
 fs/ntfs3/inode.c      |  5 +----
 fs/xfs/xfs_aops.c     |  3 +--
 include/linux/iomap.h |  2 ++
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index 1aac38e63fe6..190fc6471f84 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -253,10 +253,7 @@ static void exfat_iomap_read_end_io(struct bio *bio)
 static void exfat_iomap_bio_submit_read(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx)
 {
-	struct bio *bio = ctx->read_ctx;
-
-	bio->bi_end_io = exfat_iomap_read_end_io;
-	submit_bio(bio);
+	iomap_bio_submit_read_endio(iter, ctx, exfat_iomap_read_end_io);
 }
 
 const struct iomap_read_ops exfat_iomap_bio_read_ops = {
diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 4504f4633f17..0f31e35567b4 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -78,15 +78,23 @@ u32 iomap_finish_ioend_buffered_read(struct iomap_ioend *ioend)
 	return __iomap_read_end_io(&ioend->io_bio, ioend->io_error);
 }
 
-static void iomap_bio_submit_read(const struct iomap_iter *iter,
-		struct iomap_read_folio_ctx *ctx)
+void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx, bio_end_io_t end_io)
 {
 	struct bio *bio = ctx->read_ctx;
 
+	bio->bi_end_io = end_io;
 	if (iter->iomap.flags & IOMAP_F_INTEGRITY)
 		fs_bio_integrity_alloc(bio);
 	submit_bio(bio);
 }
+EXPORT_SYMBOL_GPL(iomap_bio_submit_read_endio);
+
+static void iomap_bio_submit_read(const struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx)
+{
+	return iomap_bio_submit_read_endio(iter, ctx, iomap_read_end_io);
+}
 
 static struct bio_set *iomap_read_bio_set(struct iomap_read_folio_ctx *ctx)
 {
@@ -127,7 +135,6 @@ static void iomap_read_alloc_bio(const struct iomap_iter *iter,
 	if (ctx->rac)
 		bio->bi_opf |= REQ_RAHEAD;
 	bio->bi_iter.bi_sector = iomap_sector(iomap, iter->pos);
-	bio->bi_end_io = iomap_read_end_io;
 	bio_add_folio_nofail(bio, folio, plen,
 			offset_in_folio(folio, iter->pos));
 	ctx->read_ctx = bio;
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 1fbf832ad165..f2bb56506046 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -38,11 +38,9 @@ static void ntfs_iomap_read_end_io(struct bio *bio)
 }
 
 static void ntfs_iomap_bio_submit_read(const struct iomap_iter *iter,
-	struct iomap_read_folio_ctx *ctx)
+		struct iomap_read_folio_ctx *ctx)
 {
-	struct bio *bio = ctx->read_ctx;
-	bio->bi_end_io = ntfs_iomap_read_end_io;
-	submit_bio(bio);
+	iomap_bio_submit_read_endio(iter, ctx, ntfs_iomap_read_end_io);
 }
 
 static const struct iomap_read_ops ntfs_iomap_bio_read_ops = {
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 42af1abe17f8..f9600aba1548 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -609,10 +609,7 @@ static void ntfs_iomap_read_end_io(struct bio *bio)
 static void ntfs_iomap_bio_submit_read(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx)
 {
-	struct bio *bio = ctx->read_ctx;
-
-	bio->bi_end_io = ntfs_iomap_read_end_io;
-	submit_bio(bio);
+	iomap_bio_submit_read_endio(iter, ctx, ntfs_iomap_read_end_io);
 }
 
 static const struct iomap_read_ops ntfs_iomap_bio_read_ops = {
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2a0c54256e93..51293b6f331f 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -764,8 +764,7 @@ xfs_bio_submit_read(
 
 	/* defer read completions to the ioend workqueue */
 	iomap_init_ioend(iter->inode, bio, ctx->read_ctx_file_offset, 0);
-	bio->bi_end_io = xfs_end_bio;
-	submit_bio(bio);
+	iomap_bio_submit_read_endio(iter, ctx, xfs_end_bio);
 }
 
 static const struct iomap_read_ops xfs_iomap_read_ops = {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3582ed1fe236..56b43d594e6e 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -622,6 +622,8 @@ extern struct bio_set iomap_ioend_bioset;
 #ifdef CONFIG_BLOCK
 int iomap_bio_read_folio_range(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, size_t plen);
+void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx, bio_end_io_t end_io);
 
 extern const struct iomap_read_ops iomap_bio_read_ops;
 
-- 
2.53.0

