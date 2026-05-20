Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321083E314D;
	Wed, 20 May 2026 12:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779280671; cv=none; b=Nsv3cYlVt1tacweeZedbQAwhmXujzZoelxEVnX0ZPyeS08dj+qLfmL7V3e3Le2WT+sdfqK2VuyGxFym/2x7K/gx3PWu7XZ1SQGCWNMIi67glpGC8ls8evDtwdn1u9DNzwqjSHF/2bepDegK9anVFR2ax4u8zqPGa78uqCgCX+84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779280671; c=relaxed/simple;
	bh=hmdOLaItS0sgTBX3BOx+azLS5uxrUqYyX9EAI3HLov0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qo+LOWIrDJbckbvMDWHmb/1Sg0d6LtzT7cfYI8dOFTn29KF+G1tc5evLDJMp+9whQTD9/I7vrjohDrYzDXZxrEOqdFxDhgEmd6Q0W8QPcsRIFyxnZRPix24jtqZ5J0iXtztxWa/i7nOHKj67DUOYJkLZHcbmQxfOblbJL3cUhRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5KfCmdn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5KfCmdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC061F00893;
	Wed, 20 May 2026 12:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280665;
	bh=uqGYC+Xo07Bo0DJjsb5FX+IUzhDkmJjiRFqdavyiqa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5KfCmdnueXDSjLY2n7tnUTZ5GkpTt4I5+5loqKbKcpUIwvZrydEXbFZZ1EJcua04
	 F0tIOmir1Hp+8Ejv08xw8HDIAyk2eKKz5DtDSrYzdLMMT6FoE6eu7gO8YvX3MYLo06
	 ks2DK5LhhUYTVoTTf7PIJID7IFGn1VI8O7zZcvKiLb/altk3coTBw4II+fRSWtCRqc
	 hWYAjRdJsqq2tsQBftskCZ6+ISRUnGAkpl6ehYhBMLHaCG5bqTR2fweLnl2PA3xgz2
	 DIThsVxfmwRLcKvSS1EOHt9OxbxW2NVwbXRVGbZqACS7poXiIuL+nOQrihCJcVCT0y
	 NsLfKK5aZP4pA==
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
Subject: [PATCH v10 07/22] iomap: introduce IOMAP_F_FSVERITY and teach writeback to handle fsverity
Date: Wed, 20 May 2026 14:37:05 +0200
Message-ID: <20260520123722.405752-8-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260520123722.405752-1-aalbersh@kernel.org>
References: <20260520123722.405752-1-aalbersh@kernel.org>
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
index d7b648421a70..3e0976bdb3ef 100644
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
@@ -1797,13 +1815,20 @@ static int iomap_writeback_range(struct iomap_writepage_ctx *wpc,
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
@@ -1869,7 +1894,7 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 
 	trace_iomap_writeback_folio(inode, pos, folio_size(folio));
 
-	if (!iomap_writeback_handle_eof(folio, inode, &end_pos))
+	if (!iomap_writeback_handle_eof(folio, wpc, &end_pos))
 		return 0;
 	WARN_ON_ONCE(end_pos <= pos);
 
diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index 097773c6db80..e4dd25b27656 100644
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
index 2c5685adf3a9..ad1e39cde5e0 100644
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

