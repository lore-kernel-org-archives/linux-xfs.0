Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC7046A5E8;
	Thu, 24 Sep 2026 10:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244129; cv=none; b=n2oSCFqz07XbrFOpcP5b6A4PBZ0AgPzcmElZe+ctWR+Wp405r8Q25R+azchr7PXUtBNWRmwoPsXNuWM77HGo3QNOvEcQ1KtVy4TeeDXiFW+EZXbEc3OSSkxp1TPO2aartybkwHttaGtfcjFk69pjhHzMVJCY+41Z/X8D3KvNmB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244129; c=relaxed/simple;
	bh=2abOQD4A34jmQFI321PSsYPVk7Ei9ogAmDQ3MjsfZQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3y6uuYEOYMSt4Ipd5Zsg0PxEAAlSxUN6e/0zp053bF8JY9gWX0r65mi9gWno9qTx3pkr9GAT2pSldPGY86W0/UBK1BRmeGsyBbF1lOyJVtnkCemBiAj1jGTDj1Kd0zhHeIkNH0EkPII9C9o1T29arG3S4sW/Z2kK/6gc5VhNBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zcqsvEXx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zcqsvEXx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YxVCvQYak92KjMPtYk0kym7IKmzayQT8ori4nhMarlc=; b=zcqsvEXxEsbaXg31cEb5TfLuhL
	l3+noXFFVGSkmNl+CRmz5z44SrtPGXaV11nE6RZcXO8G8QOvO4jLfDPb46DsLGcO91TWZQlORWsYx
	lPCTI32UwONKMUmSTO/0UfSKgyXuJsYHzrZyP5igm+Azda88hUj6shGDKz1MJaX2AvfawsVeQ6pOD
	avBZ9b31Oe429v9oYjgsr+KrhuNvFJQBlOt6uLeE3nWi1xRvyqVO/sl+uHXp/ZRS8ZzNnvrpCzeIk
	8dG74T04XmOrG7p2naFUjAtzHY6r0kGGO71DcpqOYKtXJi1S01nnY0qnt+Fhj2e2SIUPVwnTjfeGM
	C8kUjM3A==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gH9-0000000Aee8-1PQ0;
	Thu, 24 Sep 2026 10:01:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 15/21] xfs: add support for writing with data checksums
Date: Thu, 24 Sep 2026 11:59:47 +0200
Message-ID: <20260924100032.2733101-16-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All write to checksummed files need to use ioends so that the checksum
can be verified from process context.

The ioend submission path allocates the csum buffer and attaches it to
the ioend before generating the checksum from the file data.  The I/O
completion then logs the checksums into the buffers for the LBAs that
were written.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c       |  7 +++---
 fs/xfs/xfs_ioend.c      | 38 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioend.h      |  2 ++
 fs/xfs/xfs_iomap.c      | 49 ++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_iomap.h      |  4 +++-
 fs/xfs/xfs_reflink.c    |  2 +-
 fs/xfs/xfs_zone_alloc.c |  5 +++++
 7 files changed, 97 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5b25f33527c0..a38191760f81 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1073,7 +1073,8 @@ xfs_file_buffered_write(
 
 	trace_xfs_file_buffered_write(iocb, from);
 	ret = iomap_file_buffered_write(iocb, from,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
+			&xfs_buffered_write_iomap_ops,
+			xfs_get_iomap_write_ops(ip),
 			NULL);
 
 	/*
@@ -1154,8 +1155,8 @@ xfs_file_buffered_write_zoned(
 retry:
 	trace_xfs_file_buffered_write(iocb, from);
 	ret = iomap_file_buffered_write(iocb, from,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
-			&ac);
+			&xfs_buffered_write_iomap_ops,
+			xfs_get_iomap_write_ops(ip), &ac);
 	if (ret == -ENOSPC && !cleared_space) {
 		/*
 		 * Kick off writeback to convert delalloc space and release the
diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index 7570a1b915c0..7b9c82e3c449 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -235,6 +235,37 @@ xfs_ioend_submit_read(
 	submit_bio(bio);
 }
 
+int
+xfs_ioend_submit_read_sync(
+	struct bio		*bio,
+	struct inode		*inode,
+	loff_t			file_offset,
+	u16			ioend_flags)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct iomap_ioend	*ioend;
+	struct bvec_iter	saved_iter;
+	int			error;
+
+	ASSERT(!(ioend_flags & IOMAP_IOEND_DIRECT));
+
+	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
+	if (xfs_is_rtcsum_inode(ip) && !xfs_rtcsum_prepare_read(ioend))
+		return blk_status_to_errno(bio->bi_status);
+	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
+		fs_bio_integrity_alloc(bio);
+	saved_iter = bio->bi_iter;
+	error = submit_bio_wait(bio);
+	if (bio_integrity(bio)) {
+		if (!error)
+			error = fs_bio_integrity_verify(bio, &saved_iter);
+		fs_bio_integrity_free(bio);
+	}
+	if (xfs_is_rtcsum_inode(ip))
+		error = xfs_rtcsum_verify_ioend(ioend, error);
+	return error;
+}
+
 static void
 xfs_end_ioend_write_zoned(
 	struct iomap_ioend	*ioend)
@@ -261,6 +292,13 @@ xfs_end_ioend_write_zoned(
 		goto done;
 	}
 
+	if (xfs_is_rtcsum_inode(ip)) {
+		error = xfs_rtcsum_log(oz, ioend->io_sector, ioend->io_size,
+				ioend->io_csum);
+		if (error)
+			goto done;
+	}
+
 	error = xfs_zoned_end_io(ip, ioend->io_offset, ioend->io_size,
 			ioend->io_sector, oz, NULLFSBLOCK);
 	if (error)
diff --git a/fs/xfs/xfs_ioend.h b/fs/xfs/xfs_ioend.h
index 7c2a1ea3e6ed..f01aa208c61f 100644
--- a/fs/xfs/xfs_ioend.h
+++ b/fs/xfs/xfs_ioend.h
@@ -14,5 +14,7 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
 void xfs_end_bio(struct bio *bio);
 void xfs_ioend_submit_read(struct inode *inode, struct bio *bio,
 		loff_t file_offset, u16 ioend_flags);
+int xfs_ioend_submit_read_sync(struct bio *bio, struct inode *inode,
+		loff_t file_offset, u16 ioend_flags);
 
 #endif /* __XFS_IOEND_H */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0e4396e52809..75d02a32a36a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -33,6 +33,7 @@
 #include "xfs_icache.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_rtcsum.h"
+#include "xfs_ioend.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -93,10 +94,45 @@ xfs_iomap_valid(
 	return true;
 }
 
-const struct iomap_write_ops xfs_iomap_write_ops = {
+static const struct iomap_write_ops xfs_iomap_write_ops = {
 	.iomap_valid		= xfs_iomap_valid,
 };
 
+static int
+xfs_csum_read_folio_range(
+	const struct iomap_iter	*iter,
+	struct folio		*folio,
+	loff_t			pos,
+	size_t			len)
+{
+	const struct iomap	*srcmap = iomap_iter_srcmap(iter);
+	unsigned int		ioend_flags = iomap_ioend_flags(&iter->iomap);
+	struct bio		*bio;
+	int			error;
+
+	bio = bio_alloc_bioset(srcmap->bdev, 1, REQ_OP_READ, GFP_NOFS,
+			&iomap_ioend_bioset);
+	bio->bi_iter.bi_sector = iomap_sector(srcmap, pos);
+	bio_add_folio_nofail(bio, folio, len, offset_in_folio(folio, pos));
+	error = xfs_ioend_submit_read_sync(bio, iter->inode, pos, ioend_flags);
+	bio_put(bio);
+	return error;
+}
+
+static const struct iomap_write_ops xfs_iomap_csum_write_ops = {
+	.iomap_valid		= xfs_iomap_valid,
+	.read_folio_range	= xfs_csum_read_folio_range,
+};
+
+const struct iomap_write_ops *
+xfs_get_iomap_write_ops(
+	struct xfs_inode	*ip)
+{
+	if (xfs_is_rtcsum_inode(ip))
+		return &xfs_iomap_csum_write_ops;
+	return &xfs_iomap_write_ops;
+}
+
 int
 xfs_bmbt_to_iomap(
 	struct xfs_inode	*ip,
@@ -1617,6 +1653,9 @@ xfs_zoned_fill_srcmap(
 	 * There is a data fork mapping, only map until the end of it.
 	 */
 	xfs_trim_extent(&smap, offset_fsb, *end_fsb - offset_fsb);
+	if (xfs_is_rtcsum_inode(ip))
+		smap.br_blockcount = min(smap.br_blockcount,
+			xfs_rtcsum_max_len(ip->i_mount, smap.br_startblock));
 	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
 	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
 			xfs_iomap_inode_sequence(ip, 0));
@@ -2415,8 +2454,8 @@ xfs_zero_range(
 		return dax_zero_range(inode, pos, len, did_zero,
 				      &xfs_dax_write_iomap_ops);
 	return iomap_zero_range(inode, pos, len, did_zero,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
-			ac);
+			&xfs_buffered_write_iomap_ops,
+			xfs_get_iomap_write_ops(ip), ac);
 }
 
 int
@@ -2432,6 +2471,6 @@ xfs_truncate_page(
 		return dax_truncate_page(inode, pos, did_zero,
 					&xfs_dax_write_iomap_ops);
 	return iomap_truncate_page(inode, pos, did_zero,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
-			ac);
+			&xfs_buffered_write_iomap_ops,
+			xfs_get_iomap_write_ops(ip), ac);
 }
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index f2520a9b3a13..bb35e58d31ee 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -43,6 +43,7 @@ xfs_iomap_set_anon_write(
 	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
 	if (bdev_has_integrity_csum(iomap->bdev))
 		iomap->flags |= IOMAP_F_INTEGRITY;
+	iomap->csum_shift = ip->i_mount->m_rtcsum_shift;
 }
 
 static inline xfs_filblks_t
@@ -69,6 +70,8 @@ int xfs_read_iomap_begin(struct inode *inode, loff_t offset,
 		loff_t length, unsigned flags, struct iomap *iomap,
 		struct iomap *srcmap);
 
+const struct iomap_write_ops *xfs_get_iomap_write_ops(struct xfs_inode *ip);
+
 extern const struct iomap_ops xfs_buffered_write_iomap_ops;
 extern const struct iomap_ops xfs_direct_write_iomap_ops;
 extern const struct iomap_ops xfs_zoned_direct_write_iomap_ops;
@@ -77,6 +80,5 @@ extern const struct iomap_ops xfs_seek_iomap_ops;
 extern const struct iomap_ops xfs_xattr_iomap_ops;
 extern const struct iomap_ops xfs_dax_write_iomap_ops;
 extern const struct iomap_ops xfs_atomic_write_cow_iomap_ops;
-extern const struct iomap_write_ops xfs_iomap_write_ops;
 
 #endif /* __XFS_IOMAP_H__*/
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 480136136635..6edbe12777ac 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1918,7 +1918,7 @@ xfs_reflink_unshare(
 	else
 		error = iomap_file_unshare(inode, offset, len,
 				&xfs_buffered_write_iomap_ops,
-				&xfs_iomap_write_ops);
+				xfs_get_iomap_write_ops(ip));
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 9d9a713684b9..71cd35352e2e 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -27,6 +27,7 @@
 #include "xfs_trace.h"
 #include "xfs_mru_cache.h"
 #include "xfs_rtcsum.h"
+#include "xfs_rtcsum.h"
 #include <linux/bio-integrity.h>
 
 static void
@@ -934,6 +935,10 @@ xfs_zone_alloc_and_submit(
 
 	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
 		fs_bio_integrity_generate(&ioend->io_bio);
+	if (xfs_is_rtcsum_inode(ip)) {
+		xfs_csum_generate(mp, &ioend->io_bio,
+				iomap_csum_alloc(ioend, mp->m_rtcsum_shift));
+	}
 
 	/*
 	 * If we don't have a locally cached zone in this write context, see if
-- 
2.53.0

