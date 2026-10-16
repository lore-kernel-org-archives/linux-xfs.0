Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CB03A1A58;
	Fri, 16 Oct 2026 03:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792121703; cv=none; b=c40L/mfqk66x/89v5rgFPwboFJn8wMXWJf8wJuNvMhmZOlvDqtjWrJ/iz33p8Y1ZIvvNe8lcTsoakOWGaH3t0yKLBzg+XgttNBjxsF6GOI++K+YZqz2APB0Plu4CeQLlW3ZCDh+jwjTeglXhIW5cHgNOEt6ekaTPntBAYANzLC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792121703; c=relaxed/simple;
	bh=ZBDyCsfrGJJ7CeUhJ3bGLxrWyesVx2Ngz1AaSt/ZcgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GV7+peGwITmMDq2y4AAHU4gC/KPEbgdjmcZfxcZnlLKg483dX2/c8raDO42dYM/teUuUwpKTT6ZiWdh/KTAQDabz1prm5z0FHQYN09tIrFj+JwOwnX7rczqTq1Q6TUdULXYkl/G+/YnmAJhSigtuTZbPD8neRawf1xQYKOV/d2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=G40Ip9K0; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="G40Ip9K0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=jD
	ayvfln/LmxGvZbz0jQEEsK7It1kszTqv6nnrCql18=; b=G40Ip9K02GhvJPn3ZU
	M/0KIBYQKEBxfMblGY+3r98Rl7829DQ52kWg8405FiCd+mdcaeaWllrbxIjI7e5o
	V12Q6c35lY3UMJpT0qx3A7w7MAZb5mu54RqXqkAm4CdsXWWQGJRVpDrt37PbiByV
	/5Hxuntg+5+9nuvFtRpMPGGyM=
Received: from czl-pc (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDnU5c7m9Fqw1V+AA--.15038S6;
	Fri, 16 Oct 2026 11:34:22 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v3 4/8] exfat: advance valid_size while zeroing new ranges
Date: Fri, 16 Oct 2026 11:33:45 +0800
Message-ID: <20261016033349.3104509-5-chizhiling@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261016033349.3104509-1-chizhiling@163.com>
References: <20261016033349.3104509-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDnU5c7m9Fqw1V+AA--.15038S6
X-Coremail-Antispam: 1Uf129KBjvJXoWxtFyDuryxXrW7KF17XrWxCrg_yoWxWrW5pr
	W3Cwn5J39rZ3yUWrnaqr15ZFyYk3WfXF4rur95Aa4kZrnrA34akFyUKrWxWFW3t39agw1Y
	va1qyrW8Wr9rG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07je_M3UUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC+B8FomrRmz-iXAAA3h

From: Chi Zhiling <chizhiling@kylinos.cn>

valid_size is currently updated only after the range has been zeroed, so
it lags the folios that were just marked uptodate and dirty.

Advance it from exfat_prepare_valid_range() page by page, under the folio
lock and right after each folio is marked dirty; the same helper advances
zeroed_size and dirties the inode once the range is prepared.

When the gap is already covered by zeroed_size no folio work is needed
and the helper publishes valid_size up to end directly, so callers can
rely on valid_size reaching end on success and exfat_extend_valid_size()
no longer publishes it itself.  Callers guarantee that end lies within
i_size, so valid_size never overtakes i_size here.

exfat_page_mkwrite() is adapted to the new helper: it now calls it
unconditionally, and publishes valid_size and zeroed_size only after
iomap_page_mkwrite() has returned the locked folio instead of up front,
so a failed fault no longer advances valid_size and the publication
happens under the folio lock.

Fixes: 1135704ed22f ("exfat: fix valid_size extension over a shared writable mapping")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/exfat/file.c | 89 +++++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 44 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 49c63364f747..6d4f50795332 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -712,24 +712,30 @@ int exfat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 }
 
 /*
- * exfat_prepare_valid_range - populate and dirty folios covering [start, end)
+ * exfat_prepare_valid_range - populate and dirty folios covering [valid_size, end)
  *
  * Populate missing blocks via the read path, which zero-fills data
  * beyond the current valid_size and skips uptodate blocks.
  * Mark entire folios dirty so the newly valid range is written back.
  *
- * Call before advancing valid_size.
+ * Advance valid_size up to end, publishing it directly when the gap is
+ * already covered by zeroed_size.
  */
-static int exfat_prepare_valid_range(struct inode *inode, loff_t start,
-				    loff_t end)
+static int exfat_prepare_valid_range(struct inode *inode, loff_t end)
 {
 	struct address_space *mapping = inode->i_mapping;
-	loff_t next, pos = start;
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+	loff_t zeroed_size = exfat_get_zeroed_size(ei);
+	loff_t next, pos;
 	struct folio *folio;
 	pgoff_t index;
 
-	if (pos >= end)
+	pos = max(zeroed_size, exfat_get_valid_size(ei));
+	if (pos >= end) {
+		if (exfat_advance_valid_size(ei, end))
+			mark_inode_dirty(inode);
 		return 0;
+	}
 
 	while (pos < end) {
 		index = pos >> PAGE_SHIFT;
@@ -744,12 +750,21 @@ static int exfat_prepare_valid_range(struct inode *inode, loff_t start,
 		folio_lock(folio);
 		if (folio->mapping == mapping) {
 			folio_mark_dirty(folio);
+			exfat_advance_valid_size(ei, next);
 			pos = next;
 		}
 		folio_unlock(folio);
 		folio_put(folio);
 	}
 
+	/*
+	 * Track zeroed_size by block, not page, because writeback stops
+	 * at i_size recording blocks wholly beyond it could skip a
+	 * later required zeroing.
+	 */
+	exfat_advance_zeroed_size(ei, round_up(next, i_blocksize(inode)));
+	mark_inode_dirty(inode);
+
 	return 0;
 }
 
@@ -785,20 +800,14 @@ static int exfat_extend_valid_size(struct inode *inode, loff_t new_valid_size)
 		if (gap_start < new_valid_size)
 			unmap_mapping_range(inode->i_mapping, gap_start,
 					new_valid_size - gap_start, 0);
-		ret = exfat_prepare_valid_range(inode, gap_start, new_valid_size);
-		filemap_invalidate_unlock(inode->i_mapping);
+		ret = exfat_prepare_valid_range(inode, new_valid_size);
 		if (ret) {
-			filemap_invalidate_lock(inode->i_mapping);
 			truncate_setsize(inode, old_valid_size);
 			exfat_truncate(inode);
 			filemap_invalidate_unlock(inode->i_mapping);
 			return ret;
 		}
-
-		exfat_set_valid_size(ei, new_valid_size);
-		exfat_advance_zeroed_size(ei,
-				round_up(new_valid_size, i_blocksize(inode)));
-		mark_inode_dirty(inode);
+		filemap_invalidate_unlock(inode->i_mapping);
 	}
 
 	return ret;
@@ -978,42 +987,22 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 	struct exfat_inode_info *ei = EXFAT_I(inode);
 	vm_fault_t ret;
 	loff_t new_valid_size, mmap_valid_size, fault_page_start;
+	int err;
 
 	if (!inode_trylock(inode))
 		return VM_FAULT_RETRY;
 
-	mmap_valid_size = ((loff_t)vmf->pgoff + 1) << PAGE_SHIFT;
 	fault_page_start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
-	new_valid_size = min(mmap_valid_size, i_size_read(inode));
-
-	if (exfat_get_valid_size(ei) < new_valid_size) {
-		loff_t zeroed_size = exfat_get_zeroed_size(ei);
-
-		if (zeroed_size < fault_page_start) {
-			int err;
-
-			/*
-			 * Zero only the gap below the faulting page. The read
-			 * fault populated its folio and iomap_page_mkwrite()
-			 * will dirty it.
-			 */
-			err = exfat_prepare_valid_range(inode, zeroed_size,
-					fault_page_start);
-			if (err < 0) {
-				inode_unlock(inode);
-				return vmf_fs_error(err);
-			}
-		}
 
-		/*
-		 * Track zeroed_size by block, not page, because writeback stops
-		 * at i_size recording blocks wholly beyond it could skip a
-		 * later required zeroing.
-		 */
-		exfat_advance_zeroed_size(ei,
-				round_up(new_valid_size, i_blocksize(inode)));
-		exfat_set_valid_size(ei, new_valid_size);
-		mark_inode_dirty(inode);
+	/*
+	 * Zero only the gap below the faulting page. The read
+	 * fault populated its folio and iomap_page_mkwrite()
+	 * will dirty it.
+	 */
+	err = exfat_prepare_valid_range(inode, fault_page_start);
+	if (err < 0) {
+		inode_unlock(inode);
+		return vmf_fs_error(err);
 	}
 
 	sb_start_pagefault(inode->i_sb);
@@ -1021,6 +1010,18 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 
 	filemap_invalidate_lock_shared(inode->i_mapping);
 	ret = iomap_page_mkwrite(vmf, &exfat_iomap_ops, NULL);
+
+	if (ret == VM_FAULT_LOCKED) {
+		mmap_valid_size = ((loff_t)vmf->pgoff + 1) << PAGE_SHIFT;
+		new_valid_size = min(mmap_valid_size, i_size_read(inode));
+
+		if (exfat_advance_valid_size(ei, new_valid_size))
+			mark_inode_dirty(inode);
+
+		exfat_advance_zeroed_size(ei,
+				round_up(new_valid_size, i_blocksize(inode)));
+	}
+
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 	sb_end_pagefault(inode->i_sb);
 	inode_unlock(inode);
-- 
2.53.0

