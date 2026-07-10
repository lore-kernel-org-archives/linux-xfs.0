Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0D53C379C;
	Fri, 10 Jul 2026 08:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673618; cv=none; b=qY8CiNOAd0AKjojeRzcVR7U84Dp41nEMUVAp7AsgANCQdQFcasx7Yu7w0J1TXYeyENIGVsJiUhYof/Gq/bwZB4oqrN57DJ9MC9IOwE9Hu5gAaTciBPEVRUkk289+rW7UpcmqQihqYkub4ma12lUoHCBoNOcoQ7BySpXIiMECegE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673618; c=relaxed/simple;
	bh=uU9LZECtunZjMmI4kNqkrZ+7oaDRoulPh+9RwM44jcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNmLS5i6isK/Cm+6bzSHGYHq3u4tQmOOJsnh4EHNcHAY5QuIVNiU+JeQzRWqRlmkeWrbyTKswecS0e6bBDd3xy9BV1osK0IJcPR5GHSG29DLPQWF63GzVNkT+jfzVxw8xZHdwrXcWv9oA9eh4RfCxFaX+zjALXyLt+RZNsv4lMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nzTCksjY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nzTCksjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349D11F00A3A;
	Fri, 10 Jul 2026 08:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673616;
	bh=5kBhEFj3Ic0jQ4W+kZl9S7neY9+Pxt8ASNrS40LLOrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzTCksjYtzifgnE1r5vY50M/BS1a3u+W5RRn7DIwQwL0rz1m/R7Wg3H90qjoajE8U
	 OgMrUnVC0oO6hg4zCORIN3ly0/sAGtr7F5tycFycNafdMIJ+jvmVdHSeGXXf/rAqOj
	 X/h47Wd/LUKedpWFSNpR2CUEeES7ERNa8GY+15bXX7thnb1erm2qJaLyz7y0oEBhl4
	 /BLx7Yom/yYO50gE99RzqsqeoeVI4ESnxgcyY5Beb0NP2zc8qwiAwzD46U/nJegF61
	 7S//9Fct6YOHPGkrjh2a9auH/hjvkWqL9QojUTiem6KgBEsSOYCWkpPXWwuLSt/2h7
	 CpL/m2drE2ByQ==
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
Subject: [PATCH v11 04/20] fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
Date: Fri, 10 Jul 2026 10:52:32 +0200
Message-ID: <20260710085256.3464201-5-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
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
index cc4158fc841d..f3a4617656db 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -37,34 +37,6 @@ static inline loff_t f2fs_verity_metadata_pos(const struct inode *inode)
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
@@ -250,7 +222,7 @@ static int f2fs_get_verity_descriptor(struct inode *inode, void *buf,
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
index 9e7d946676b9..f9433332c274 100644
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
2.54.0

