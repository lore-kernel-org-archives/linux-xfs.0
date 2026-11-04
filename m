Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782823;
	b=WQILxf6XpU9p69an78wGzygV82NDqzNnDYYWdr8zce704zeAkIm5Kl9JV8JZVzhkudlY
	 s7o7g7aKUDp+wghEmvUbcDAhoAWQ7nM0r8abtY49FtWBqYYu0fjkggRY5Uk5caor7+42G
	 ATZH1JMdQoH43xPEaADw14V1rbUsHkLAI1vZari2IzoVH4f2IK5cOKx0vv4qn9dyBcJJh
	 pP6wi0UsvjTtQOInsGL1jCSGXLnNM7VmbaIwzjmAXF0Y8P5GtzghmVCSP1fNo7C6FfIBS
	 FSyAggiYfDjAZ7TcoI/WVRFxvsyt/8zQdu6Fgf+PKWkMmOOgsX/MIS/06hrXyTTP4VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782823;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=4nouYmowO5RIhWlsVmmaBOEY5neoRtzmayerwdNgH5g=;
	b=GbsI8zYsqUmO8zfsCSEEe/m2UVq20/UFEHfjLqs0xU246klWuR1yYeknjnHYh+X8YHGr
	 Ysqh8PDYFkZ7+FTaubqea3qfSuVP3ZlS3VKHBWBOCRbkX3ddQVsi1aHQo6Ka61nAxYtOq
	 U4EZ22uHirsGaaP+WcDtBxmNY3GDqm9rGgT/SmlcKrKZ5f+xoIsMahfny88lhlK+CzyM2
	 dXI0Ns/CreEkNy7JgRkqqv7UsXGUwIEa/iKdoOawQpEVRTpg7LKWX2nP7u6fiqlwRrLrS
	 tzgneRnkUJ84zToNBDuQ/R0u5FEXMwWb/ngAVFQJNs2bQKSh5nLXwzpPXcDCW/wT3iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="NU02TjK/";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F10C606A33E;
	Wed,  4 Nov 2026 09:00:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F10C606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=NU02TjK/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4nouYmowO5RIhWlsVmmaBOEY5neoRtzmayerwdNgH5g=; b=NU02TjK/tjni0H+4R1MgkKMOJU
	3hRwrE+x9bEtCQKM70a1e2cF+QRQHds8kMFJ0sAgen2zFOIFdIXMxa2GltHcaJ3OiuVqETri4CbQX
	1lLB1GM1QNHYsYZ7LdrfnICIypvMl34GEOr+HIkRfjUiSIWhqbP+iJEZZ4Qyn7ArPkfGtoR5Z1wZs
	PS7yaRfO5qVJo1IOOo8BrUD1MQ64ySJ733nFO9QJA+XD4YNaYVLwSxelCDUFL2d84JMMUgG2ECRRi
	Gwu5M/djSNXJOLkhMl0HGox40bIxM9ZygcNCaTZzr2hpUlSwxOb1N2+KyS9dm1QU/beOpTLJr80ib
	7vcA2g2g==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqz-00000004oUD-3Osb;
	Wed, 04 Nov 2026 09:00:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 17/25] xfs: add support for writing with data checksums
Date: Wed,  4 Nov 2026 09:57:21 +0100
Message-ID: <20261104085929.317544-18-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_file.c       |  7 +++---
 fs/xfs/xfs_ioend.c      | 51 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioend.h      |  2 ++
 fs/xfs/xfs_iomap.c      | 49 +++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_iomap.h      |  4 +++-
 fs/xfs/xfs_reflink.c    |  2 +-
 fs/xfs/xfs_zone_alloc.c |  4 ++++
 7 files changed, 109 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 97b0a976058a..c522913309c3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1012,7 +1012,8 @@ xfs_file_buffered_write(
 
 	trace_xfs_file_buffered_write(iocb, from);
 	ret = iomap_file_buffered_write(iocb, from,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
+			&xfs_buffered_write_iomap_ops,
+			xfs_get_iomap_write_ops(ip),
 			NULL);
 
 	/*
@@ -1093,8 +1094,8 @@ xfs_file_buffered_write_zoned(
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
index 1066f262ba98..3a2d18e82822 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -236,6 +236,37 @@ xfs_ioend_submit_read(
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
@@ -262,6 +293,26 @@ xfs_end_ioend_write_zoned(
 		goto done;
 	}
 
+	/*
+	 * Log the checksum updates before remapping the newly written extents
+	 * into the data fork.  We must commit the csum update before the remap
+	 * transaction to satisfy an ordering requirement that any read after a
+	 * write must be able to find the new data and new checksum; or the old
+	 * data and the old checksum.
+	 *
+	 * It's harmless if the system fails after the csum update but before
+	 * the remap because nobody will ever see the newly written extent until
+	 * the next GC cycle.
+         */
+	if (xfs_is_rtcsum_inode(ip)) {
+		error = xfs_rtcsum_log(oz, ioend->io_sector, ioend->io_size,
+				ioend->io_csum);
+		if (error) {
+			xfs_force_shutdown(ip->i_mount, SHUTDOWN_META_IO_ERROR);
+			goto done;
+		}
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
index 80b7c9df7c14..ee45eb1baf3d 100644
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
@@ -1639,6 +1675,9 @@ xfs_zoned_fill_srcmap(
 	 * There is a data fork mapping, only map until the end of it.
 	 */
 	xfs_trim_extent(&smap, offset_fsb, *end_fsb - offset_fsb);
+	if (xfs_is_rtcsum_inode(ip))
+		smap.br_blockcount = min(smap.br_blockcount,
+			xfs_rtcsum_max_len(ip->i_mount, smap.br_startblock));
 	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
 	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
 			xfs_iomap_inode_sequence(ip, 0));
@@ -2437,8 +2476,8 @@ xfs_zero_range(
 		return dax_zero_range(inode, pos, len, did_zero,
 				      &xfs_dax_write_iomap_ops);
 	return iomap_zero_range(inode, pos, len, did_zero,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
-			ac);
+			&xfs_buffered_write_iomap_ops,
+			xfs_get_iomap_write_ops(ip), ac);
 }
 
 int
@@ -2454,6 +2493,6 @@ xfs_truncate_page(
 		return dax_truncate_page(inode, pos, did_zero,
 					&xfs_dax_write_iomap_ops);
 	return iomap_truncate_page(inode, pos, did_zero,
-			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
-			ac);
+			&xfs_buffered_write_iomap_ops,
+			xfs_get_iomap_write_ops(ip), ac);
 }
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 8fc0c6fc8bea..81fff7cad59b 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -44,6 +44,7 @@ xfs_iomap_set_anon_write(
 	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
 	if (bdev_has_integrity_csum(iomap->bdev))
 		iomap->flags |= IOMAP_F_INTEGRITY;
+	iomap->csum_shift = ip->i_mount->m_rtcsum_shift;
 }
 
 static inline xfs_filblks_t
@@ -70,6 +71,8 @@ int xfs_read_iomap_begin(struct inode *inode, loff_t offset,
 		loff_t length, unsigned flags, struct iomap *iomap,
 		struct iomap *srcmap);
 
+const struct iomap_write_ops *xfs_get_iomap_write_ops(struct xfs_inode *ip);
+
 extern const struct iomap_ops xfs_buffered_write_iomap_ops;
 extern const struct iomap_ops xfs_direct_write_iomap_ops;
 extern const struct iomap_ops xfs_zoned_direct_write_iomap_ops;
@@ -78,6 +81,5 @@ extern const struct iomap_ops xfs_seek_iomap_ops;
 extern const struct iomap_ops xfs_xattr_iomap_ops;
 extern const struct iomap_ops xfs_dax_write_iomap_ops;
 extern const struct iomap_ops xfs_atomic_write_cow_iomap_ops;
-extern const struct iomap_write_ops xfs_iomap_write_ops;
 
 #endif /* __XFS_IOMAP_H__*/
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 104542b10d9e..5653aa08ce1c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1923,7 +1923,7 @@ xfs_reflink_unshare(
 	else
 		error = iomap_file_unshare(inode, offset, len,
 				&xfs_buffered_write_iomap_ops,
-				&xfs_iomap_write_ops);
+				xfs_get_iomap_write_ops(ip));
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 0dbc08c58817..5c5f42f3262c 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -964,6 +964,10 @@ xfs_zone_alloc_and_submit(
 
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

