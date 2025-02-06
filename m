Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7955622541B
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824392; cv=none; b=BZkgVm4xESsDolz/ORBJIfTmHyb6KkWj5ZcfSohuYzEdN5WpJFakzjlN9kneNzNQPSti7Yd1eVpiBA9/sknOLp09A93OkvFOBJVeh0o/bBwjRMZi8K4nsG9gZn3XuLy7z1ajz8UNgCUQHXb1FK31jR653Q4NEo9TlsC+jhOzeg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824392; c=relaxed/simple;
	bh=Bgv9PmaFctrv54RYp8+ZnlGBM6WvJA5PKCiwSPe271s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urMh7K1qilPseVbzgzd2D+/gWpRTi7M2/uf6Zku3UeKw//sUXu9QwJnfXD+MU1xoW4TQS/CTGGH16Xj9ct0pXxlhg5KvkT9JVi5NBWPc1PTvkXhfxjbEVjRNfG7wNtxRoF78Z0oXsYEoUDS92L02Z7kK/1Yx7L0UiVr/bZtKoPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jUabJ0W9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jUabJ0W9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=d90tZDQZunAfP7nbDPvAFxb0FitpJ+K0+hEu/hyS1eQ=; b=jUabJ0W91/zFvHq9JLin2LvDPr
	Eusz0j9nguHK2oA2hojKf36KwvExLeOTpbgVEUQuGOATm42q7OFF+M8r4mnznGmkylab/gG3KHXgy
	Xt5VpZdHvTX5FLRbXd/FrE1aRWkJAdolOxc1vJACWpYvmpKWbTl2T3UEYLpghio0iaET21iyiOzwF
	cgapLQ75E9Q84xwyqSjwiTzQzeAuVKZmuKafI4wVhUPXWtAK/eK80f3mWu5k651FX6KVDdySBzwx1
	gziEIgo1clE4215HkH2swsQau9Wup+mBTj/f78a2llsLBZBr5n5LlxGs39SCY7clUSg1HHAql/PQh
	NvE0oKlw==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvef-00000005QZo-1Ikh;
	Thu, 06 Feb 2025 06:46:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 26/43] xfs: implement direct writes to zoned RT devices
Date: Thu,  6 Feb 2025 07:44:42 +0100
Message-ID: <20250206064511.2323878-27-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Direct writes to zoned RT devices are extremely simple.  After taking the
block reservation before acquiring the iolock, the iomap direct I/O calls
into ->iomap_begin which will return a "fake" iomap for the entire
requested range.  The actual block allocation is then done from the
submit_io handler using code shared with the buffered I/O path.

The iomap_dio_ops set the bio_set to the (iomap) ioend one and initialize
the embedded ioend, which allows reusing the existing ioend based buffered
I/O completion path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c  |  6 ++--
 fs/xfs/xfs_aops.h  |  3 +-
 fs/xfs/xfs_file.c  | 80 +++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_iomap.c | 53 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.h |  1 +
 5 files changed, 132 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index ba57e7171a4b..69b8c2d1937d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -157,7 +157,9 @@ xfs_end_ioend(
 	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
 
-	if (!error && xfs_ioend_is_append(ioend))
+	if (!error &&
+	    !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
+	    xfs_ioend_is_append(ioend))
 		error = xfs_setfilesize(ip, offset, size);
 done:
 	if (is_zoned)
@@ -204,7 +206,7 @@ xfs_end_io(
 	}
 }
 
-static void
+void
 xfs_end_bio(
 	struct bio		*bio)
 {
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index e0bd68419764..5a7a0f1a0b49 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -9,6 +9,7 @@
 extern const struct address_space_operations xfs_address_space_operations;
 extern const struct address_space_operations xfs_dax_aops;
 
-int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
+int xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
+void xfs_end_bio(struct bio *bio);
 
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 301c2551761d..3373705552aa 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -25,6 +25,7 @@
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
 #include "xfs_file.h"
+#include "xfs_aops.h"
 #include "xfs_zone_alloc.h"
 
 #include <linux/dax.h>
@@ -548,6 +549,9 @@ xfs_dio_write_end_io(
 	loff_t			offset = iocb->ki_pos;
 	unsigned int		nofs_flag;
 
+	ASSERT(!xfs_is_zoned_inode(ip) ||
+	       !(flags & (IOMAP_DIO_UNWRITTEN | IOMAP_DIO_COW)));
+
 	trace_xfs_end_io_direct_write(ip, offset, size);
 
 	if (xfs_is_shutdown(ip->i_mount))
@@ -627,14 +631,51 @@ static const struct iomap_dio_ops xfs_dio_write_ops = {
 	.end_io		= xfs_dio_write_end_io,
 };
 
+static void
+xfs_dio_zoned_submit_io(
+	const struct iomap_iter	*iter,
+	struct bio		*bio,
+	loff_t			file_offset)
+{
+	struct xfs_mount	*mp = XFS_I(iter->inode)->i_mount;
+	struct xfs_zone_alloc_ctx *ac = iter->private;
+	xfs_filblks_t		count_fsb;
+	struct iomap_ioend	*ioend;
+
+	count_fsb = XFS_B_TO_FSB(mp, bio->bi_iter.bi_size);
+	if (count_fsb > ac->reserved_blocks) {
+		xfs_err(mp,
+"allocation (%lld) larger than reservation (%lld).",
+			count_fsb, ac->reserved_blocks);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		bio_io_error(bio);
+		return;
+	}
+	ac->reserved_blocks -= count_fsb;
+
+	bio->bi_end_io = xfs_end_bio;
+	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
+			IOMAP_IOEND_DIRECT);
+	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
+}
+
+static const struct iomap_dio_ops xfs_dio_zoned_write_ops = {
+	.bio_set	= &iomap_ioend_bioset,
+	.submit_io	= xfs_dio_zoned_submit_io,
+	.end_io		= xfs_dio_write_end_io,
+};
+
 /*
- * Handle block aligned direct I/O writes
+ * Handle block aligned direct I/O writes.
  */
 static noinline ssize_t
 xfs_file_dio_write_aligned(
 	struct xfs_inode	*ip,
 	struct kiocb		*iocb,
-	struct iov_iter		*from)
+	struct iov_iter		*from,
+	const struct iomap_ops	*ops,
+	const struct iomap_dio_ops *dops,
+	struct xfs_zone_alloc_ctx *ac)
 {
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	ssize_t			ret;
@@ -642,7 +683,7 @@ xfs_file_dio_write_aligned(
 	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
-	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
+	ret = xfs_file_write_checks(iocb, from, &iolock, ac);
 	if (ret)
 		goto out_unlock;
 
@@ -656,11 +697,31 @@ xfs_file_dio_write_aligned(
 		iolock = XFS_IOLOCK_SHARED;
 	}
 	trace_xfs_file_direct_write(iocb, from);
-	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
-			   &xfs_dio_write_ops, 0, NULL, 0);
+	ret = iomap_dio_rw(iocb, from, ops, dops, 0, ac, 0);
 out_unlock:
-	if (iolock)
-		xfs_iunlock(ip, iolock);
+	xfs_iunlock(ip, iolock);
+	return ret;
+}
+
+/*
+ * Handle block aligned direct I/O writes to zoned devices.
+ */
+static noinline ssize_t
+xfs_file_dio_write_zoned(
+	struct xfs_inode	*ip,
+	struct kiocb		*iocb,
+	struct iov_iter		*from)
+{
+	struct xfs_zone_alloc_ctx ac = { };
+	ssize_t			ret;
+
+	ret = xfs_zoned_write_space_reserve(ip, iocb, from, 0, &ac);
+	if (ret < 0)
+		return ret;
+	ret = xfs_file_dio_write_aligned(ip, iocb, from,
+			&xfs_zoned_direct_write_iomap_ops,
+			&xfs_dio_zoned_write_ops, &ac);
+	xfs_zoned_space_unreserve(ip, &ac);
 	return ret;
 }
 
@@ -777,7 +838,10 @@ xfs_file_dio_write(
 	    (xfs_is_always_cow_inode(ip) &&
 	     (iov_iter_alignment(from) & ip->i_mount->m_blockmask)))
 		return xfs_file_dio_write_unaligned(ip, iocb, from);
-	return xfs_file_dio_write_aligned(ip, iocb, from);
+	if (xfs_is_zoned_inode(ip))
+		return xfs_file_dio_write_zoned(ip, iocb, from);
+	return xfs_file_dio_write_aligned(ip, iocb, from,
+			&xfs_direct_write_iomap_ops, &xfs_dio_write_ops, NULL);
 }
 
 static noinline ssize_t
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0e64a0ce1622..30e257f683bb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -965,6 +965,59 @@ const struct iomap_ops xfs_direct_write_iomap_ops = {
 	.iomap_begin		= xfs_direct_write_iomap_begin,
 };
 
+#ifdef CONFIG_XFS_RT
+/*
+ * This is really simple.  The space has already been reserved before taking the
+ * IOLOCK, the actual block allocation is done just before submitting the bio
+ * and only recorded in the extent map on I/O completion.
+ */
+static int
+xfs_zoned_direct_write_iomap_begin(
+	struct inode		*inode,
+	loff_t			offset,
+	loff_t			length,
+	unsigned		flags,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error;
+
+	ASSERT(!(flags & IOMAP_OVERWRITE_ONLY));
+
+	/*
+	 * Needs to be pushed down into the allocator so that only writes into
+	 * a single zone can be supported.
+	 */
+	if (flags & IOMAP_NOWAIT)
+		return -EAGAIN;
+
+	/*
+	 * Ensure the extent list is in memory in so that we don't have to do
+	 * read it from the I/O completion handler.
+	 */
+	if (xfs_need_iread_extents(&ip->i_df)) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		if (error)
+			return error;
+	}
+
+	iomap->type = IOMAP_MAPPED;
+	iomap->flags = IOMAP_F_DIRTY;
+	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
+	iomap->offset = offset;
+	iomap->length = length;
+	iomap->flags = IOMAP_F_ANON_WRITE;
+	return 0;
+}
+
+const struct iomap_ops xfs_zoned_direct_write_iomap_ops = {
+	.iomap_begin		= xfs_zoned_direct_write_iomap_begin,
+};
+#endif /* CONFIG_XFS_RT */
+
 static int
 xfs_dax_write_iomap_end(
 	struct inode		*inode,
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index bc8a00cad854..d330c4a581b1 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -51,6 +51,7 @@ xfs_aligned_fsb_count(
 
 extern const struct iomap_ops xfs_buffered_write_iomap_ops;
 extern const struct iomap_ops xfs_direct_write_iomap_ops;
+extern const struct iomap_ops xfs_zoned_direct_write_iomap_ops;
 extern const struct iomap_ops xfs_read_iomap_ops;
 extern const struct iomap_ops xfs_seek_iomap_ops;
 extern const struct iomap_ops xfs_xattr_iomap_ops;
-- 
2.45.2

