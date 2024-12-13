Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05722AD25
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052919; cv=none; b=mu670qsHSFYfcIZiUXr6aLEJlFdQwHh1NU70W9JajHqT9YZ709dLD9JDiB9HgNcQ+dMe8LHEbOSs4b9AAvj04IKGcfdqdf7KFlGkI6sZnnMEFTEumy3qYNGx117t+PEYF6E+pe9noBKElsa6Y1JHTbhPOvDTYRfVc6ahhxanztU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052919; c=relaxed/simple;
	bh=DnbyVknEHkpEa7j2O2HYhbucDbhzPaQWV7TRZ0C8uOU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g1CXmpiyDEgHG1z54Rqo4Bnc3MWBmKrJX6nfZWk0M/G8n+wg53IvOmz8vsg94aL8xuG1+2o6xlPQP2Kzip9xIgec9Bqvl7D4GUB2xdq+X0lEww2Brr8XIXIE+wR5hBnzerNC5cNtOXSTi6uJdkU3x01XeFlRKfiZN4z/NWp3yc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUvsxyJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUvsxyJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774BFC4CED4;
	Fri, 13 Dec 2024 01:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052919;
	bh=DnbyVknEHkpEa7j2O2HYhbucDbhzPaQWV7TRZ0C8uOU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KUvsxyJXJa1gA/L3mgBNu507BVpty2IyWVj/o7l8WEEOhmJpYuS9YnWMoh+Ze7Cf3
	 32j9n23KvlhhjCJWrw+yHKfpjZQKQ8yxupmJl7tp0nLYSlrqcOZLHyh/SFQasVJ1Mg
	 O0tKTfJrgUoxU1L9Makw7pvJdWwZNq03OJSvigW8PAr0m6c4otfAKx7aeGxNHeSnJq
	 AEpKiaIMXHlswa+wRZUF53sevz2ZpJr4AIjPP+uN2LarTUIazXBn5RRLowUw/VwuiS
	 B/SLbiGqkOy1TtFzc3dAApjosvvE2j3Q3SK5Q7JgKjGHFSIcpaxqhU/wOPz3iMxFl9
	 hndeGPDQ6DBNQ==
Date: Thu, 12 Dec 2024 17:21:59 -0800
Subject: [PATCH 02/11] iomap: allow zeroing of written extents beyond EOF
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125776.1184063.5414430767804356851.stgit@frogsfrogsfrogs>
In-Reply-To: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
References: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In commit eb65540aa9fc82 ("iomap: warn on zero range of a post-eof
folio"), we established that iomap_zero_range cannot dirty folios beyond
EOF because writeback will ignore those dirty folios.

However, XFS can only handle copy on write of entire file allocation
units.  For reflink on a realtime volume where the allocation unit size
is larger than a single fsblock, if EOF is in the middle of an
allocation unit, we must use the pagecache to stage the out of place
write, even if that means having (zeroed) dirty pagecache beyond EOF.

To support this, the writeback call knows how to extend the writeback
range to align with an allocation unit, and it successfully finds the
dirty post-EOF folios.  Therefore, we need to disable this check for
this particular situation.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/gfs2/bmap.c         |    2 +-
 fs/iomap/buffered-io.c |   25 ++++++++++++++++++++-----
 fs/xfs/xfs_iomap.c     |   27 ++++++++++++++++++++++++++-
 include/linux/iomap.h  |    6 +++++-
 4 files changed, 52 insertions(+), 8 deletions(-)


diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 1795c4e8dbf66a..ce9293c916363e 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1300,7 +1300,7 @@ static int gfs2_block_zero_range(struct inode *inode, loff_t from,
 				 unsigned int length)
 {
 	BUG_ON(current->journal_info);
-	return iomap_zero_range(inode, from, length, NULL, &gfs2_iomap_ops);
+	return iomap_zero_range(inode, from, length, NULL, &gfs2_iomap_ops, 0);
 }
 
 #define GFS2_JTRUNC_REVOKES 8192
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 955f19e27e47c5..4e851e9c2a1002 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1350,7 +1350,8 @@ static inline int iomap_zero_iter_flush_and_stale(struct iomap_iter *i)
 	return filemap_write_and_wait_range(mapping, i->pos, end);
 }
 
-static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
+static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
+		unsigned zeroing_flags)
 {
 	loff_t pos = iter->pos;
 	loff_t length = iomap_length(iter);
@@ -1363,6 +1364,18 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		size_t bytes = min_t(u64, SIZE_MAX, length);
 		bool ret;
 
+		/*
+		 * If we've gone past EOF and have a written mapping, and the
+		 * filesystem supports written mappings past EOF, skip the rest
+		 * of the range.  We can't write that back anyway.
+		 */
+		if (pos > iter->inode->i_size &&
+		    (zeroing_flags & IOMAP_ZERO_MAPPED_BEYOND_EOF)) {
+			written += length;
+			length = 0;
+			break;
+		}
+
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (status)
 			return status;
@@ -1395,7 +1408,7 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 
 int
 iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
-		const struct iomap_ops *ops)
+		const struct iomap_ops *ops, unsigned zeroing_flags)
 {
 	struct iomap_iter iter = {
 		.inode		= inode,
@@ -1424,7 +1437,8 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 	    filemap_range_needs_writeback(mapping, pos, pos + plen - 1)) {
 		iter.len = plen;
 		while ((ret = iomap_iter(&iter, ops)) > 0)
-			iter.processed = iomap_zero_iter(&iter, did_zero);
+			iter.processed = iomap_zero_iter(&iter, did_zero,
+							 zeroing_flags);
 
 		iter.len = len - (iter.pos - pos);
 		if (ret || !iter.len)
@@ -1453,7 +1467,8 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 			continue;
 		}
 
-		iter.processed = iomap_zero_iter(&iter, did_zero);
+		iter.processed = iomap_zero_iter(&iter, did_zero,
+						 zeroing_flags);
 	}
 	return ret;
 }
@@ -1469,7 +1484,7 @@ iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 	/* Block boundary? Nothing to do */
 	if (!off)
 		return 0;
-	return iomap_zero_range(inode, pos, blocksize - off, did_zero, ops);
+	return iomap_zero_range(inode, pos, blocksize - off, did_zero, ops, 0);
 }
 EXPORT_SYMBOL_GPL(iomap_truncate_page);
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 50fa3ef89f6c98..b7d0dfd5fd3117 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1490,14 +1490,39 @@ xfs_zero_range(
 	bool			*did_zero)
 {
 	struct inode		*inode = VFS_I(ip);
+	unsigned int		zeroing_flags = 0;
 
 	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
 	if (IS_DAX(inode))
 		return dax_zero_range(inode, pos, len, did_zero,
 				      &xfs_dax_write_iomap_ops);
+
+	/*
+	 * Files with allocation units larger than the fsblock size can share
+	 * zeroed written blocks beyond EOF if the EOF is in the middle of an
+	 * allocation unit because it keeps the refcounting code simple.  We
+	 * therefore permit zeroing of pagecache for these post-EOF written
+	 * extents so that the blocks in the CoW staging extent beyond EOF are
+	 * all initialized to zero.
+	 *
+	 * Alternate designs could be: (a) don't allow sharing of an allocation
+	 * unit that spans EOF because of the unwritten blocks; (b) rewrite the
+	 * reflink code to allow shared unwritten extents in this one corner
+	 * case; or (c) insert zeroed pages into the pagecache to get around
+	 * the checks in iomap_zero_range.
+	 *
+	 * However, this design (allow zeroing of pagecache beyond EOF) was
+	 * chosen because it most closely resembles what we do for allocation
+	 * unit == 1 fsblock.  Note that for these files, we force writeback
+	 * of post-EOF folios to ensure that CoW always happens in units of
+	 * allocation units.
+	 */
+	if (xfs_inode_has_bigrtalloc(ip) && xfs_has_reflink(ip->i_mount))
+		zeroing_flags |= IOMAP_ZERO_MAPPED_BEYOND_EOF;
+
 	return iomap_zero_range(inode, pos, len, did_zero,
-				&xfs_buffered_write_iomap_ops);
+				&xfs_buffered_write_iomap_ops, zeroing_flags);
 }
 
 int
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 5675af6b740c27..31a5aa239aab1d 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -306,7 +306,11 @@ bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
-		bool *did_zero, const struct iomap_ops *ops);
+		bool *did_zero, const struct iomap_ops *ops,
+		unsigned zeroing_flags);
+/* ignore written mappings allowed beyond EOF */
+#define IOMAP_ZERO_MAPPED_BEYOND_EOF	(1U << 0)
+
 int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 		const struct iomap_ops *ops);
 vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf,

