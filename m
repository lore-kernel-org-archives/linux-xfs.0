Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A543D4116;
	Thu,  9 Apr 2026 13:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740472; cv=none; b=ewiQF4BXwuT0lh1gkmQ0OIgyXb/2GEu3qIoVqNPQOEYPHrBKC27uyPOT9U+bxcVK3A3YEfrX79YBwUYbT6Ak+ey69hEJcOKc+LSOCmxFgmS75g2V37S+Ehs4FyuF/I3Ip+Rqu2ZJkX9HcZxfkxmwg/G+1PjTKrKGZ/MpsOltIeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740472; c=relaxed/simple;
	bh=Eaaq0hH8g1nljZhSJeNsb1Z/i9y2O7ArKbTh9ZdwoXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otU56RUInJD9VYFT4pmB1VEVYMy13vCVo6u4vcxJJGfDN49FJ5zSPJCnrM6WhtbKvvyC4V5MzEG63sRq6zscaZ2Gl8JYsAxKGphvEoGZSbOjZsEg5F8V974/lMKbFMh9X8Inr3syRKj32EE8+x2/9KnHv30JYLQyCY4fdspebuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eq2+JrG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eq2+JrG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57344C19424;
	Thu,  9 Apr 2026 13:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740471;
	bh=Eaaq0hH8g1nljZhSJeNsb1Z/i9y2O7ArKbTh9ZdwoXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eq2+JrG+XNJ1FAJb9o2aCpLb1MP0+xtnR+BJ6pAXQODqN5G4Toz7xqwiRWi2BLzog
	 mS4MS8EEZh7jjwPvJ4Uo4hj62TcjmtXwbpmtzAg0IewqJiBjBrlW5rcAMxNgTNV+hv
	 WhpL25xyM3zVz/Qx0RZs+ZVbfeagScDs8g696oQfRT8/0xuWaZJMGoIyKztKM/ZKkj
	 sY3fpzBHwXubgFGRXAFQrk+nczQrxjDdlg91QrGMoOAcc9LF4B8zjBJvf/DQf4QauK
	 UtymxPF99l9ruSPxjtVDprQZ+2gv2dOcvN3Na5eL3Wrka6/sBx5wq5Ohrpn/+lEuW2
	 hF13gBN6InBcg==
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
	djwong@kernel.org
Subject: [PATCH v7 07/22] iomap: introduce IOMAP_F_FSVERITY and teach writeback to handle fsverity
Date: Thu,  9 Apr 2026 15:13:39 +0200
Message-ID: <20260409131404.1545834-8-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260409131404.1545834-1-aalbersh@kernel.org>
References: <20260409131404.1545834-1-aalbersh@kernel.org>
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

