Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A39D3D2FF5;
	Thu,  9 Apr 2026 13:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740469; cv=none; b=qdbUZJeZzKBIlK+tBkxgeELREgp1pi8dzL8PijNX7JqhvdDeY34P1tprR1eiwamR354KSeoVsBaybkPudgzY1TUz+5Piof0FSn3Mis+QRjjH4E+wOo3NLUc1rnURCZJO/7GZGKLjDW/qABzeKAEY2nfmHnUCz5kn7d3UKBNh4qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740469; c=relaxed/simple;
	bh=z/3roTCD1Ne1/qpsmQCo6JII54WvnylPhblXVUf/ZIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcUvPIgztDoUo7O2/TH2FEyfC+DHVXjEfC8v7UDL/y5+XwH2Iz1GxjwByiK38btpHSDzGlKGYjzdya13ZZGPn2eeiHVss1qGnLAx2Dadvq+YMaLWkbOapHVzZ+JegcbCIognR3rQ2UWphEhpu8Vmt8SEpRqKGO5h3qypqqpBqEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWYkfxeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWYkfxeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69009C4CEF7;
	Thu,  9 Apr 2026 13:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775740468;
	bh=z/3roTCD1Ne1/qpsmQCo6JII54WvnylPhblXVUf/ZIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWYkfxebSDFijB/s5osKTHfcyTX6KwztlsAsQrvuvGmJ+ELPb8Cihz5OuTRo8GVOF
	 BUcRspYP0yicqYH0COcIk3stEbuTRuiR1DbRXdYklbzLb7ZDzVmeufucJxNRnZXeMr
	 hPxwrnsAnCEkePbuQP6p5CQrzOLwtkQkFPRNmetac5p41kqEFBxT+ddPCh79y87cfE
	 y/4MvqeId+1chQ7nFy3AoezodhnGPG4LiXCxUZBWbqsfLvbvC2uI4o/XG1Ra5g44BQ
	 q7ESd1Dlr9o6k75PjnvCs76zXWlYVX2FpeAETqwp41nsE/Qgc5aKdhsqHqOMTl+h25
	 IEbo4KxB58CYA==
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
Subject: [PATCH v7 06/22] fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
Date: Thu,  9 Apr 2026 15:13:38 +0200
Message-ID: <20260409131404.1545834-7-aalbersh@kernel.org>
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

This is the same function to read from pageache. XFS will also need
this, so move this to core fsverity.

Note that f2fs and ext4 functions diverged a bit, as ext4 operated over
folios and f2fs operated over pages. The common one will operate over
folios.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/ext4/verity.c         | 32 +++-----------------------------
 fs/f2fs/verity.c         | 30 +-----------------------------
 fs/verity/pagecache.c    | 33 +++++++++++++++++++++++++++++++++
 include/linux/fsverity.h |  2 ++
 4 files changed, 39 insertions(+), 58 deletions(-)

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 347945ac23a4..ac5c133f5529 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -34,32 +34,6 @@ static inline loff_t ext4_verity_metadata_pos(const struct inode *inode)
 	return round_up(inode->i_size, 65536);
 }
 
-/*
- * Read some verity metadata from the inode.  __vfs_read() can't be used because
- * we need to read beyond i_size.
- */
-static int pagecache_read(struct inode *inode, void *buf, size_t count,
-			  loff_t pos)
-{
-	while (count) {
-		struct folio *folio;
-		size_t n;
-
-		folio = read_mapping_folio(inode->i_mapping, pos >> PAGE_SHIFT,
-					 NULL);
-		if (IS_ERR(folio))
-			return PTR_ERR(folio);
-
-		n = memcpy_from_file_folio(buf, folio, pos, count);
-		folio_put(folio);
-
-		buf += n;
-		pos += n;
-		count -= n;
-	}
-	return 0;
-}
-
 /*
  * Write some verity metadata to the inode for FS_IOC_ENABLE_VERITY.
  * kernel_write() can't be used because the file descriptor is readonly.
@@ -311,8 +285,8 @@ static int ext4_get_verity_descriptor_location(struct inode *inode,
 		goto bad;
 	desc_size_pos -= sizeof(desc_size_disk);
 
-	err = pagecache_read(inode, &desc_size_disk, sizeof(desc_size_disk),
-			     desc_size_pos);
+	err = fsverity_pagecache_read(inode, &desc_size_disk,
+				      sizeof(desc_size_disk), desc_size_pos);
 	if (err)
 		return err;
 	desc_size = le32_to_cpu(desc_size_disk);
@@ -352,7 +326,7 @@ static int ext4_get_verity_descriptor(struct inode *inode, void *buf,
 	if (buf_size) {
 		if (desc_size > buf_size)
 			return -ERANGE;
-		err = pagecache_read(inode, buf, desc_size, desc_pos);
+		err = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
 		if (err)
 			return err;
 	}
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index b3b3e71604ac..5ea0a9b40443 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -36,34 +36,6 @@ static inline loff_t f2fs_verity_metadata_pos(const struct inode *inode)
 	return round_up(inode->i_size, 65536);
 }
 
-/*
- * Read some verity metadata from the inode.  __vfs_read() can't be used because
- * we need to read beyond i_size.
- */
-static int pagecache_read(struct inode *inode, void *buf, size_t count,
-			  loff_t pos)
-{
-	while (count) {
-		size_t n = min_t(size_t, count,
-				 PAGE_SIZE - offset_in_page(pos));
-		struct page *page;
-
-		page = read_mapping_page(inode->i_mapping, pos >> PAGE_SHIFT,
-					 NULL);
-		if (IS_ERR(page))
-			return PTR_ERR(page);
-
-		memcpy_from_page(buf, page, offset_in_page(pos), n);
-
-		put_page(page);
-
-		buf += n;
-		pos += n;
-		count -= n;
-	}
-	return 0;
-}
-
 /*
  * Write some verity metadata to the inode for FS_IOC_ENABLE_VERITY.
  * kernel_write() can't be used because the file descriptor is readonly.
@@ -248,7 +220,7 @@ static int f2fs_get_verity_descriptor(struct inode *inode, void *buf,
 	if (buf_size) {
 		if (size > buf_size)
 			return -ERANGE;
-		res = pagecache_read(inode, buf, size, pos);
+		res = fsverity_pagecache_read(inode, buf, size, pos);
 		if (res)
 			return res;
 	}
diff --git a/fs/verity/pagecache.c b/fs/verity/pagecache.c
index 99f5f53eea98..9d82e6b74ba1 100644
--- a/fs/verity/pagecache.c
+++ b/fs/verity/pagecache.c
@@ -78,3 +78,36 @@ void fsverity_fill_zerohash(struct folio *folio, size_t offset, size_t len,
 				vi->tree_params.digest_size);
 }
 EXPORT_SYMBOL_GPL(fsverity_fill_zerohash);
+
+/**
+ * fsverity_pagecache_read() - read page and copy data to buffer
+ * @inode:	copy from this inode's address space
+ * @buf:	buffer to copy to
+ * @count:	number of bytes to copy
+ * @pos:	position of the folio to copy from
+ *
+ * Read some verity metadata from the inode.  __vfs_read() can't be used because
+ * we need to read beyond i_size.
+ */
+int fsverity_pagecache_read(struct inode *inode, void *buf, size_t count,
+			  loff_t pos)
+{
+	while (count) {
+		struct folio *folio;
+		size_t n;
+
+		folio = read_mapping_folio(inode->i_mapping, pos >> PAGE_SHIFT,
+					 NULL);
+		if (IS_ERR(folio))
+			return PTR_ERR(folio);
+
+		n = memcpy_from_file_folio(buf, folio, pos, count);
+		folio_put(folio);
+
+		buf += n;
+		pos += n;
+		count -= n;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fsverity_pagecache_read);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index a5645ec07aa8..a2ae5cc649ad 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -328,5 +328,7 @@ void fsverity_cleanup_inode(struct inode *inode);
 struct page *generic_read_merkle_tree_page(struct inode *inode, pgoff_t index);
 void generic_readahead_merkle_tree(struct inode *inode, pgoff_t index,
 				   unsigned long nr_pages);
+int fsverity_pagecache_read(struct inode *inode, void *buf, size_t count,
+			    loff_t pos);
 
 #endif	/* _LINUX_FSVERITY_H */
-- 
2.51.2

