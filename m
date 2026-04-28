Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5543D6483;
	Tue, 28 Apr 2026 08:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365256; cv=none; b=rcM07E8iHooCpF3DNipMlBULdhEYNeWwX+Y4ZhSsGFt9YjaNylpYabKdRQnr+LKpRd0nsC+cXz5zvbWSH0qKHwrgzWoQwJO4cHUUZnLGcV5yv2IQ/sbao5HEjuUWy35oS1qVdU8brw6NkMOvsoq+NPJpUFDSYVmkygra+m1Wg8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365256; c=relaxed/simple;
	bh=/SbaSxqoCapi7/7jAyx+81s7Wq+jj6RPYvLhQ5Ccgu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yxwi+B6YwjaXeCrFrN2T8tIUBWfq3S9/O4gd+9LA+wnYfEyWXE9b+JSiZz8+UWo0puZfq/nXW60HQ/KVii2QsbDlv/EJB32cgFPunr+67Agu8U9Dg6Ko/Hf0xM/769y9KjqdTBEpwJC0yXfaeXDo/Efi792jm+owPnIqoajkoGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khIh9f6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khIh9f6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51947C2BCB5;
	Tue, 28 Apr 2026 08:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365255;
	bh=/SbaSxqoCapi7/7jAyx+81s7Wq+jj6RPYvLhQ5Ccgu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khIh9f6WfvdFH7yUkKKgjPF6Jj1mlLb0fA8bMioNjKaey64MGGrmcbyyp6ZGVIXpY
	 wKg5ZPxCVBNIXHZ/WrWOAcTwTWbAE2z7ZOepqXVerJo/tevFO+vZjk6FuRR3Vk4T1x
	 9n4W2IVqDuhi6qCZ5NDm0H5wXK4u9HP8apO/1ujMigXWqfQ2JomqYhsVeepKdPtXHl
	 ABvA1+3k2Wj58YcSTcJPfFhFO8kOclIXO6gWywtU9JhqPQWI6o2m0fRwTs1JYxCH0p
	 oIjBLNBXR3yuG3S5fa8WDk7ldAMxT8LCshv5c+PTl/145FOI+uWvbIQUg7+drfMaVt
	 b3/G+NVulVDaQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v9 07/22] iomap: introduce IOMAP_F_FSVERITY and teach writeback to handle fsverity
Date: Tue, 28 Apr 2026 10:33:13 +0200
Message-ID: <20260428083332.768693-8-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260428083332.768693-1-aalbersh@kernel.org>
References: <20260428083332.768693-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This flag indicates that I/O is for fsverity metadata.

In the write path skip i_size check and i_size updates as metadata is
past EOF. In writeback don't update i_size and continue writeback if
even folio is beyond EOF. In read path don't zero fsverity folios, again
they are past EOF.

The iomap_block_needs_zeroing() is also called from write path. For
folios of larger order we don't want to zero out pages in the folio as
these could contain other merkle tree blocks. For fsverity, filesystem
will request to read PAGE_SIZE memory regions. For data folios, iomap
will zero the rest of the folio for anything which is beyond EOF. We
don't want this for fsverity folios.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 43 +++++++++++++++++++++++++++++++++---------
 fs/iomap/trace.h       |  3 ++-
 include/linux/iomap.h  |  8 ++++++++
 3 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index e4b6886e5c3c..38c9592fba43 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -353,9 +353,26 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 
-	return srcmap->type != IOMAP_MAPPED ||
-		(srcmap->flags & IOMAP_F_NEW) ||
-		pos >= i_size_read(iter->inode);
+	/*
+	 * If this block has not been written, there's nothing to read
+	 */
+	if (srcmap->type != IOMAP_MAPPED)
+		return true;
+
+	/*
+	 * Newly allocated blocks have not been written
+	 */
+	if (srcmap->flags & IOMAP_F_NEW)
+		return true;
+
+	/*
+	 * fsverity metadata is stored past i_size, we need to read it instead
+	 * of zeroing
+	 */
+	if (srcmap->flags & IOMAP_F_FSVERITY)
+		return false;
+
+	return pos >= i_size_read(iter->inode);
 }
 
 /**
@@ -1167,13 +1184,14 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 		 * unlock and release the folio.
 		 */
 		old_size = iter->inode->i_size;
-		if (pos + written > old_size) {
+		if (pos + written > old_size &&
+		    !(iter->iomap.flags & IOMAP_F_FSVERITY)) {
 			i_size_write(iter->inode, pos + written);
 			iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
 		}
 		__iomap_put_folio(iter, write_ops, written, folio);
 
-		if (old_size < pos)
+		if (old_size < pos && !(iter->iomap.flags & IOMAP_F_FSVERITY))
 			pagecache_isize_extended(iter->inode, old_size, pos);
 
 		cond_resched();
@@ -1801,13 +1819,20 @@ static int iomap_writeback_range(struct iomap_writepage_ctx *wpc,
  * Check interaction of the folio with the file end.
  *
  * If the folio is entirely beyond i_size, return false.  If it straddles
- * i_size, adjust end_pos and zero all data beyond i_size.
+ * i_size, adjust end_pos and zero all data beyond i_size. Don't skip fsverity
+ * folios as those are beyond i_size.
  */
-static bool iomap_writeback_handle_eof(struct folio *folio, struct inode *inode,
-		u64 *end_pos)
+static bool iomap_writeback_handle_eof(struct folio *folio,
+		struct iomap_writepage_ctx *wpc, u64 *end_pos)
 {
+	struct inode *inode = wpc->inode;
 	u64 isize = i_size_read(inode);
 
+	if (wpc->iomap.flags & IOMAP_F_FSVERITY) {
+		WARN_ON_ONCE(folio_pos(folio) < isize);
+		return true;
+	}
+
 	if (*end_pos > isize) {
 		size_t poff = offset_in_folio(folio, isize);
 		pgoff_t end_index = isize >> PAGE_SHIFT;
@@ -1873,7 +1898,7 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 
 	trace_iomap_writeback_folio(inode, pos, folio_size(folio));
 
-	if (!iomap_writeback_handle_eof(folio, inode, &end_pos))
+	if (!iomap_writeback_handle_eof(folio, wpc, &end_pos))
 		return 0;
 	WARN_ON_ONCE(end_pos <= pos);
 
diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index 532787277b16..5252051cc137 100644
--- a/fs/iomap/trace.h
+++ b/fs/iomap/trace.h
@@ -118,7 +118,8 @@ DEFINE_RANGE_EVENT(iomap_zero_iter);
 	{ IOMAP_F_ATOMIC_BIO,	"ATOMIC_BIO" }, \
 	{ IOMAP_F_PRIVATE,	"PRIVATE" }, \
 	{ IOMAP_F_SIZE_CHANGED,	"SIZE_CHANGED" }, \
-	{ IOMAP_F_STALE,	"STALE" }
+	{ IOMAP_F_STALE,	"STALE" }, \
+	{ IOMAP_F_FSVERITY,	"FSVERITY" }
 
 
 #define IOMAP_DIO_STRINGS \
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 531f9ebdeeae..4506a99d5285 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -87,6 +87,14 @@ struct vm_fault;
 #define IOMAP_F_INTEGRITY	0
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+/*
+ * Indicates reads and writes of fsverity metadata.
+ *
+ * Fsverity metadata is stored after the regular file data and thus beyond
+ * i_size.
+ */
+#define IOMAP_F_FSVERITY	(1U << 10)
+
 /*
  * Flag reserved for file system specific usage
  */
-- 
2.51.2

