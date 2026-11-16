Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819566;
	b=kA54Ua8fDIanpTcf4dRapu0k76wFeqzJ3IcMCHTYznitcR1tRMJ0o4kJvUZAC3LRraw7
	 OtfCFFSlmSTbQgCD2Ddex0pR8yTHyU0VIfj76rGP1jvlb9ItnpbsPjK/deEKC7yaUGgph
	 TkWU/Oq/L2qCe+Ur0lW7bj2h7GP2A0xRze61zcBP1M6TNs/K1JPKq7VabeXiM6Rw0CiSU
	 BkIXclwQzGPIqHIW4MNGykk6+hryzEOu9H8KC6kvQc4X7SJGDIGsDo+wVo7jPdjvhmV8R
	 BpF1xqmNPqcag0VpLv5iQZIKlFVmmzRDgDJYG+livHqpAJ8BrOnPVpxgpafN0ZhKvCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819566;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=cgVZ0qhTW0hpCxtMrLHOvh6uMzwmNvKrZIMWicWujVk=;
	b=fryOULwNiHZh1J5x0Ur6yMvf6Ff56n/Is+i0D4Aejro2TSIHlBQgk7aAI5OMxIo0P/fF
	 N5DgvhszNjnn7/RBSSfA0m0DK/yiMSZxpjnqpp/xrQTCpqlmowwKlmfstA0FxX3Qw3Lq5
	 0kxx4G79uzND/saEndAvr9+uLnDSELrMUisrLjpdtVO1bf/IV0lsVmfpJGVIExIdCLIbG
	 NEfOq6ukXOg1zcOslTQjoP+yC7Z5lbszhzoKRqGBsxRrGUvTzxxcfaUEkRYe7/s5oowIa
	 xHEVeLGy8NA1/hrHA7kL/LV+VRGR6/OJkBUx5zEJMUBt8BPeoNd0m4p5iUalUS8d1cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=qVVVexZ4;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E249606A885;
	Mon, 16 Nov 2026 08:59:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E249606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=qVVVexZ4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=cg
	VZ0qhTW0hpCxtMrLHOvh6uMzwmNvKrZIMWicWujVk=; b=qVVVexZ4IUK9Cn6X6B
	EF7Hh9OzaaCc8XAh7kGZ+QehfQSbld/qTpbc5197+xuKPCN1OFnyKYhCzvck8OMY
	kvbWe7imrE61U35pdHPLsIs+Z3MXBN/TGMLfPBIzOmiPRSmdmvCMod8owjs8I6ZL
	qRLWeSiFNJHZWIP0RgPe1oOAg=
Received: from czl-pc (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wAH5iLPxfpqqlTnHw--.59228S7;
	Mon, 16 Nov 2026 16:59:00 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v4 5/5] exfat: coordinate direct writes with mmap faults
Date: Mon, 16 Nov 2026 16:57:52 +0800
Message-ID: <20261116085752.3908082-6-chizhiling@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116085752.3908082-1-chizhiling@163.com>
References: <20261116085752.3908082-1-chizhiling@163.com>
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
X-CM-TRANSID:_____wAH5iLPxfpqqlTnHw--.59228S7
X-Coremail-Antispam: 1Uf129KBjvAXoWfCryxurWDXryDAFyUXw4rGrg_yoW5XFW8Jo
	Wrtan2qr4rKr95ArWUKw17JF9rXa9rCw1fCr45WFZFvFy7t3Z0ya17Jw43Xa1xXrn0ka1D
	Z34xta1rGrWjyFs5n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU2R6wDUUUU
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3BQAnWr6xdTMdQAA3t

From: Namjae Jeon <linkinjeon@kernel.org>

Direct writes can update valid_size before their data I/O completes. An mmap
write fault can also initialize and dirty the invalid VDL gap while a direct
write is in flight, writing zeroes over its data.

Prepare and write back the invalid range through the destination boundary
folio before direct I/O, without advancing valid_size. Update i_size and
valid_size after completed writes, and trim excess clusters after errors or
short writes. Hold invalidate_lock through DIO completion, post-write
invalidation, gap initialization, and rollback to coordinate with mmap
faults. Allocate gap clusters through the normal exFAT bitmap and FAT paths,
and account for short allocations and ENOSPC after partial progress.

Record the on-disk length in i_size and clamp valid_size to that length.
Remove inode_trylock() from page_mkwrite, since VM_FAULT_RETRY from this
callback can be ignored. Snapshot valid_size for direct reads so cache-only
VDL changes cannot make disk-invalid data appear valid.

For writes entirely within a VDL snapshot, use the caller's kiocb and
IOMAP_DIO_OVERWRITE_ONLY mappings. These non-allocating mappings allow native
AIO overwrites to run concurrently. VDL-extending writes wait for earlier DIO
and use synchronous completion. Mark overwrite mappings dirty for O_DSYNC
when earlier cached writes may have advanced VDL without persisting the
directory entry.

Return -EAGAIN for IOCB_NOWAIT writes, including buffered writes, because gap
initialization can block. Check alignment before buffered fallback. Complete
submitted BIOs after ENOSPC following partial progress, then report a short
write or I/O error.

Fixes: 867b9c96dc83 ("exfat: add iomap direct I/O support")
Fixes: 6630ea49103c ("exfat: move extend valid_size into ->page_mkwrite()")
Co-developed-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/exfat/fatent.c |   6 +-
 fs/exfat/file.c   | 303 +++++++++++++++++++++++++++++++++++++---------
 fs/exfat/inode.c  |  19 +--
 fs/exfat/iomap.c  | 172 ++++++++++++++++++--------
 fs/exfat/iomap.h  |   9 +-
 5 files changed, 385 insertions(+), 124 deletions(-)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index 9f4607fced7f..ebeecbe45e61 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -456,8 +456,10 @@ int exfat_alloc_cluster(struct inode *inode, unsigned int num_alloc,
 	}
 
 	if (num_alloc > total_cnt - sbi->used_clusters) {
-		ret = -ENOSPC;
-		goto unlock;
+		/* A contiguous mapping can use a shorter allocation. */
+		if (!contig || sbi->used_clusters == total_cnt)
+			goto unlock;
+		num_alloc = total_cnt - sbi->used_clusters;
 	}
 
 	hint_clu = p_chain->dir;
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 0d1eeeeffa76..9dfd99ad9265 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2012-2013 Samsung Electronics Co., Ltd.
  */
 
-#include <linux/slab.h>
 #include <linux/compat.h>
 #include <linux/cred.h>
 #include <linux/buffer_head.h>
@@ -18,6 +17,7 @@
 #include <linux/iomap.h>
 #include <linux/pagemap.h>
 #include <linux/rmap.h>
+#include <linux/uio.h>
 
 #include "exfat_raw.h"
 #include "exfat_fs.h"
@@ -32,23 +32,19 @@
  * This ensures that the folio is marked RO and the post-EOF range is
  * zeroed before readers or writeback can observe the updated i_size.
  */
-static void exfat_pagecache_isize_extended(struct inode *inode, loff_t from,
-					   loff_t to)
+static struct folio *exfat_prepare_isize_extended(struct inode *inode,
+						   loff_t from, loff_t to)
 {
 	struct folio *folio;
 
-	if (!(from & (PAGE_SIZE - 1))) {
-		i_size_write(inode, to);
-		return;
-	}
+	if (!(from & (PAGE_SIZE - 1)))
+		return NULL;
 
 	folio = filemap_lock_folio(inode->i_mapping, from >> PAGE_SHIFT);
 
 	/* Folio not cached? Nothing to do */
-	if (IS_ERR(folio)) {
-		i_size_write(inode, to);
-		return;
-	}
+	if (IS_ERR(folio))
+		return NULL;
 
 	/*
 	 * See folio_clear_dirty_for_io() for details why folio_mark_dirty()
@@ -71,14 +67,28 @@ static void exfat_pagecache_isize_extended(struct inode *inode, loff_t from,
 		folio_zero_segment(folio, offset, end);
 	}
 
+	return folio;
+}
+
+static void exfat_unlock_isize_folio(struct folio *folio)
+{
+	if (!folio)
+		return;
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
+static void exfat_pagecache_isize_extended(struct inode *inode, loff_t from,
+					   loff_t to)
+{
+	struct folio *folio = exfat_prepare_isize_extended(inode, from, to);
+
 	/*
 	 * Publish the new size after zeroing the tail. Uptodate folios can
 	 * be read without taking the folio lock.
 	 */
 	i_size_write(inode, to);
-
-	folio_unlock(folio);
-	folio_put(folio);
+	exfat_unlock_isize_folio(folio);
 }
 
 static int __exfat_cont_expand(struct inode *inode, loff_t size)
@@ -723,17 +733,16 @@ int exfat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 }
 
 /*
- * exfat_prepare_valid_range - populate and dirty folios covering [start, end)
+ * exfat_prepare_range - populate and dirty folios covering [start, end)
  *
  * Populate missing blocks via the read path, which zero-fills data
  * beyond the current valid_size and skips uptodate blocks.
- * Mark entire folios dirty so the newly valid range is written back.
+ * Mark entire folios dirty so the prepared range is written back.
  *
- * Increase valid_size for each newly initialized range before unlocking
- * its folio.
+ * If requested, increase valid_size for each range before unlocking its folio.
  */
-static int exfat_prepare_valid_range(struct inode *inode, loff_t start,
-				    loff_t end)
+static int exfat_prepare_range(struct inode *inode, loff_t start, loff_t end,
+			       bool publish)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct exfat_inode_info *ei = EXFAT_I(inode);
@@ -757,11 +766,12 @@ static int exfat_prepare_valid_range(struct inode *inode, loff_t start,
 			next = min(folio_next_pos(folio), end);
 			if (next > exfat_get_valid_size(ei)) {
 				folio_mark_dirty(folio);
-				if (exfat_advance_valid_size(ei, next))
+				if (publish && exfat_advance_valid_size(ei, next))
 					mark_inode_dirty(inode);
 			}
-			exfat_advance_zeroed_size(ei,
-						  round_up(next, i_blocksize(inode)));
+			if (publish)
+				exfat_advance_zeroed_size(ei,
+							  round_up(next, i_blocksize(inode)));
 			pos = next;
 		}
 		folio_unlock(folio);
@@ -805,7 +815,7 @@ static int exfat_extend_valid_size(struct inode *inode, loff_t new_valid_size)
 		if (gap_start < new_valid_size)
 			unmap_mapping_range(inode->i_mapping, gap_start,
 					new_valid_size - gap_start, 0);
-		ret = exfat_prepare_valid_range(inode, gap_start, new_valid_size);
+		ret = exfat_prepare_range(inode, gap_start, new_valid_size, true);
 		if (ret) {
 			/* Preserve initialized data, including stores through mmap. */
 			loff_t size = max(old_size, exfat_get_valid_size(ei));
@@ -829,6 +839,105 @@ static int exfat_extend_valid_size(struct inode *inode, loff_t new_valid_size)
 	return ret;
 }
 
+/*
+ * A later mmap fault can initialize the gap up to its folio. Prepare and
+ * write back through the DIO range and its boundary folio so that gap
+ * initialization in a later folio does not dirty the DIO range.
+ * i_rwsem serializes preparation, allowing later overwrites to reuse the
+ * prepared range without dirtying folios containing in-flight DIO.
+ */
+static int exfat_prepare_dio_range(struct inode *inode, loff_t end)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+	loff_t valid, start, size;
+	int ret = 0;
+
+	filemap_invalidate_lock(mapping);
+	size = i_size_read(inode);
+	valid = exfat_get_valid_size(ei);
+	start = max(valid, exfat_get_zeroed_size(ei));
+	end = max(valid, min(end, size));
+	end = min_t(u64, round_up((u64)end, mapping_max_folio_size(mapping)),
+		    size);
+	if (start < end) {
+		unmap_mapping_range(mapping, start, end - start, 0);
+		ret = exfat_prepare_range(inode, start, end, false);
+		if (!ret)
+			ret = filemap_write_and_wait_range(mapping, start, end - 1);
+		if (!ret)
+			exfat_advance_zeroed_size(ei,
+						  round_up(end, i_blocksize(inode)));
+	}
+	filemap_invalidate_unlock(mapping);
+	return ret;
+}
+
+static int exfat_file_write_dio_end_io(struct kiocb *iocb, ssize_t size,
+		int error, unsigned int flags)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	struct exfat_sb_info *sbi = EXFAT_SB(inode->i_sb);
+	struct exfat_dio *dio = container_of(iocb, struct exfat_dio, iocb);
+	struct folio *folio = NULL;
+	loff_t end = dio->start + size;
+	bool dirtied = false;
+
+	if (error || !size)
+		return error;
+
+	if (i_size_read(inode) < end)
+		folio = exfat_prepare_isize_extended(inode, i_size_read(inode),
+						     end);
+
+	mutex_lock(&sbi->s_lock);
+	if (i_size_read(inode) < end) {
+		i_size_write(inode, end);
+		dirtied = true;
+	}
+
+	if (dio->start <= exfat_get_valid_size(EXFAT_I(inode)) &&
+	    exfat_advance_valid_size(EXFAT_I(inode), end))
+		dirtied = true;
+	if (dirtied)
+		mark_inode_dirty(inode);
+	dio->completed = size;
+
+	mutex_unlock(&sbi->s_lock);
+	exfat_unlock_isize_folio(folio);
+	return 0;
+}
+
+static const struct iomap_dio_ops exfat_write_dio_ops = {
+	.end_io		= exfat_file_write_dio_end_io,
+};
+
+/*
+ * Run after iomap's post-write invalidation, so gap folios cannot be
+ * mistaken for stale cache pages by the direct I/O completion.
+ */
+static int exfat_finish_dio_gap(struct exfat_dio *dio)
+{
+	struct inode *inode = file_inode(dio->iocb.ki_filp);
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+	loff_t start = max(exfat_get_valid_size(ei), exfat_get_zeroed_size(ei));
+	int ret;
+
+	if (exfat_get_valid_size(ei) >= dio->start)
+		return 0;
+	if (start < dio->start) {
+		unmap_mapping_range(inode->i_mapping, start, dio->start - start, 0);
+		ret = iomap_zero_range(inode, start, dio->start - start, NULL,
+				       &exfat_write_iomap_ops,
+				       &exfat_dio_gap_write_ops, dio);
+		if (ret)
+			return ret;
+	}
+	if (exfat_advance_valid_size(ei, dio->start + dio->completed))
+		mark_inode_dirty(inode);
+	return 0;
+}
+
 /*
  * The clusters for a write are allocated before the data is copied. Free the
  * ones that a failed or short write has left beyond the end of the file.
@@ -845,20 +954,23 @@ static void exfat_write_failed(struct inode *inode)
 static ssize_t exfat_fallback_buffered_write(struct kiocb *iocb,
 		struct iov_iter *from)
 {
+	struct iov_iter source = *from;
+	struct kiocb buffered;
 	loff_t offset = iocb->ki_pos, end;
 	ssize_t written;
 	int ret;
 
-	iocb->ki_flags &= ~IOCB_DIRECT;
+	kiocb_clone(&buffered, iocb, iocb->ki_filp);
+	buffered.ki_flags &= ~IOCB_DIRECT;
 
 	inode_dio_wait(file_inode(iocb->ki_filp));
 
-	written = iomap_file_buffered_write(iocb, from, &exfat_write_iomap_ops,
+	written = iomap_file_buffered_write(&buffered, &source, &exfat_write_iomap_ops,
 			&exfat_iomap_write_ops, NULL);
-	if (written < 0)
+	if (written <= 0)
 		return written;
 
-	end = iocb->ki_pos + written - 1;
+	end = buffered.ki_pos - 1;
 	ret = filemap_write_and_wait_range(iocb->ki_filp->f_mapping,
 			offset, end);
 	if (ret)
@@ -868,30 +980,109 @@ static ssize_t exfat_fallback_buffered_write(struct kiocb *iocb,
 			offset >> PAGE_SHIFT,
 			end >> PAGE_SHIFT);
 
+	/* Report progress only after the buffered data has been flushed. */
+	iocb->ki_pos = buffered.ki_pos;
+	iov_iter_advance(from, written);
 	return written;
 }
 
 static ssize_t exfat_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
+	struct inode *inode = file_inode(iocb->ki_filp);
+	struct block_device *bdev = inode->i_sb->s_bdev;
+	struct exfat_dio dio = { };
+	struct iov_iter source = *from;
+	struct iomap_dio *iomap_dio;
+	loff_t old_size = i_size_read(inode);
+	loff_t valid_size = exfat_get_valid_size(EXFAT_I(inode));
+	loff_t end = iocb->ki_pos + iov_iter_count(from);
 	ssize_t ret;
+	int error;
 
-	ret = iomap_dio_rw(iocb, from, &exfat_write_iomap_ops,
-			&exfat_write_dio_ops, 0, NULL, 0);
-	if (ret == -ENOTBLK)
-		ret = 0;
-	else if (ret < 0)
+	/* VDL extension must wait for outstanding overwrites. */
+	if (end > valid_size)
+		inode_dio_wait(inode);
+	ret = exfat_prepare_dio_range(inode, end);
+	if (ret)
 		return ret;
 
-	if (iov_iter_count(from)) {
-		ssize_t written;
+	if (end <= valid_size) {
+		/* Use existing mappings and allow asynchronous completion. */
+		ret = iomap_dio_rw(iocb, from, &exfat_iomap_ops, NULL,
+				   IOMAP_DIO_OVERWRITE_ONLY, &valid_size, 0);
+		if (ret != -ENOTBLK)
+			return ret;
+		goto buffered;
+	}
+
+	kiocb_clone(&dio.iocb, iocb, iocb->ki_filp);
+	dio.start = iocb->ki_pos;
+	/* User page faults can take invalidate_lock via page_mkwrite. */
+	iomap_dio = __iomap_dio_rw(&dio.iocb, &source,
+				   &exfat_write_iomap_ops,
+				   &exfat_write_dio_ops,
+				   0, &dio, 0);
 
-		written = exfat_fallback_buffered_write(iocb, from);
-		if (written < 0)
-			return written;
-		ret += written;
+	/* Serialize size updates, post-invalidation and gap completion. */
+	filemap_invalidate_lock(inode->i_mapping);
+	if (IS_ERR_OR_NULL(iomap_dio))
+		ret = PTR_ERR_OR_ZERO(iomap_dio);
+	else
+		ret = iomap_dio_complete(iomap_dio);
+	if (dio.completed) {
+		error = exfat_finish_dio_gap(&dio);
+		if (error) {
+			exfat_err(inode->i_sb,
+				  "write: fail to initialize direct I/O gap (%d)",
+				  error);
+			if (ret >= 0)
+				ret = error;
+		}
+	}
+	if (ret < 0) {
+		struct exfat_inode_info *ei = EXFAT_I(inode);
+		loff_t size = max(old_size, exfat_get_valid_size(ei));
+		loff_t initialized = max(exfat_get_valid_size(ei), dio.start);
+
+		if (size < i_size_read(inode)) {
+			truncate_setsize(inode, size);
+			exfat_truncate(inode);
+		}
+		/* Failed DIO may have changed the prepared invalid tail. */
+		if (exfat_get_zeroed_size(ei) > initialized)
+			exfat_set_zeroed_size(ei, initialized);
+	}
+	if (exfat_bytes_to_cluster(EXFAT_SB(inode->i_sb),
+				   exfat_ondisk_size(inode)) >
+	    exfat_bytes_to_cluster_round_up(EXFAT_SB(inode->i_sb),
+					    i_size_read(inode)))
+		exfat_truncate(inode);
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	if (ret > 0) {
+		iocb->ki_pos = dio.iocb.ki_pos;
+		iov_iter_advance(from, ret);
+		return ret;
 	}
+	if (ret < 0 && ret != -ENOTBLK)
+		return ret;
 
-	return ret;
+buffered:
+	/* Invalidation can fail before iomap checks alignment. */
+	if (((iocb->ki_pos | iov_iter_count(from)) &
+	     (bdev_logical_block_size(bdev) - 1)) ||
+	    (iov_iter_alignment(from) & bdev_dma_alignment(bdev)))
+		return -EINVAL;
+	if (user_backed_iter(from) && !from->nofault &&
+	    fault_in_iov_iter_readable(from, 1))
+		return -EFAULT;
+	if (iocb->ki_pos > exfat_get_valid_size(EXFAT_I(inode))) {
+		ret = exfat_extend_valid_size(inode, iocb->ki_pos);
+		if (ret)
+			return ret;
+	}
+
+	return exfat_fallback_buffered_write(iocb, from);
 }
 
 static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
@@ -906,6 +1097,10 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
 		return -EIO;
 
+	/* Gap initialization and source faults require blocking operations. */
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EAGAIN;
+
 	inode_lock(inode);
 
 	ret = generic_write_checks(iocb, iter);
@@ -925,15 +1120,16 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 	valid_size = exfat_get_valid_size(ei);
 	if (pos > valid_size) {
-		ret = exfat_extend_valid_size(inode, pos);
-		if (ret < 0 && ret != -ENOSPC) {
-			exfat_err(inode->i_sb,
-				"write: fail to zero from %llu to %llu(%zd)",
-				valid_size, pos, ret);
+		if (!(iocb->ki_flags & IOCB_DIRECT)) {
+			ret = exfat_extend_valid_size(inode, pos);
+			if (ret < 0 && ret != -ENOSPC) {
+				exfat_err(inode->i_sb,
+					"write: fail to zero from %llu to %llu(%zd)",
+					valid_size, pos, ret);
+			}
+			if (ret < 0)
+				goto unlock;
 		}
-		if (ret < 0)
-			goto unlock;
-
 		pos = valid_size;
 	}
 
@@ -982,9 +1178,12 @@ static ssize_t exfat_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	inode_lock_shared(inode);
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
+		/* Snapshot before writeback or destination faults can advance VDL. */
+		loff_t valid_size = exfat_get_valid_size(EXFAT_I(inode));
+
 		file_accessed(iocb->ki_filp);
 		ret = iomap_dio_rw(iocb, iter, &exfat_iomap_ops, NULL, 0,
-				NULL, 0);
+				   &valid_size, 0);
 		if (ret >= 0 && iov_iter_count(iter) &&
 		    iocb->ki_pos < i_size_read(inode))
 			ret = filemap_read(iocb, iter, ret);
@@ -1011,9 +1210,6 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
 		return VM_FAULT_SIGBUS;
 
-	if (!inode_trylock(inode))
-		return VM_FAULT_RETRY;
-
 	sb_start_pagefault(inode->i_sb);
 	error = file_update_time(vmf->vma->vm_file);
 	if (error) {
@@ -1029,7 +1225,7 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 
 	/* The faulting folio is already populated; initialize only its gap. */
 	gap_start = max(exfat_get_valid_size(ei), exfat_get_zeroed_size(ei));
-	error = exfat_prepare_valid_range(inode, gap_start, fault_start);
+	error = exfat_prepare_range(inode, gap_start, fault_start, true);
 	if (error) {
 		ret = vmf_fs_error(error);
 		goto out_unlock;
@@ -1048,7 +1244,6 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 	filemap_invalidate_unlock_shared(mapping);
 out_pagefault:
 	sb_end_pagefault(inode->i_sb);
-	inode_unlock(inode);
 
 	return ret;
 }
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 4bea9e9deb94..7071f603b57b 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -73,25 +73,16 @@ int __exfat_write_inode(struct inode *inode, int sync)
 			     &ep->dentry.file.access_date,
 			     NULL);
 
-	/*
-	 * During a DIO write, valid_size is updated eagerly in iomap_end (so
-	 * that concurrent buffered reads see IOMAP_MAPPED) while i_size is
-	 * updated asynchronously in end_io.  The FAT chain was already
-	 * extended to cover ceil(valid_size/cluster_size) clusters.  Use the
-	 * maximum so the on-disk size field always covers the FAT chain,
-	 * preventing fsck from reporting "more clusters are allocated".
-	 */
-	on_disk_size = max_t(unsigned long long, i_size_read(inode),
-			valid_size);
+	/* Direct writes publish the completed size in their end_io handler. */
+	on_disk_size = i_size_read(inode);
 
 	if (ei->start_clu == EXFAT_EOF_CLUSTER)
 		on_disk_size = 0;
 	/*
-	 * valid_size on disk must reflect only confirmed data (up to i_size)
-	 * and must not exceed on_disk_size.
+	 * Truncate can publish a smaller i_size before lowering valid_size.
+	 * Never record a valid_size greater than the recorded file size.
 	 */
-	on_disk_valid_size = min_t(unsigned long long, valid_size,
-			i_size_read(inode));
+	on_disk_valid_size = min_t(unsigned long long, valid_size, on_disk_size);
 	if (ei->start_clu == EXFAT_EOF_CLUSTER)
 		on_disk_valid_size = 0;
 
diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index 7eb31a6091b3..1b3ba1b8829a 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -13,32 +13,6 @@
 #include "exfat_fs.h"
 #include "iomap.h"
 
-/*
- * exfat_file_write_dio_end_io - Direct I/O write completion handler
- *
- * Updates i_size if the write extended the file. Called from the dio layer
- * after I/O completion.
- */
-static int exfat_file_write_dio_end_io(struct kiocb *iocb, ssize_t size,
-		int error, unsigned int flags)
-{
-	struct inode *inode = file_inode(iocb->ki_filp);
-
-	if (error)
-		return error;
-
-	if (size && i_size_read(inode) < iocb->ki_pos + size) {
-		i_size_write(inode, iocb->ki_pos + size);
-		mark_inode_dirty(inode);
-	}
-
-	return 0;
-}
-
-const struct iomap_dio_ops exfat_write_dio_ops = {
-	.end_io		= exfat_file_write_dio_end_io,
-};
-
 static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, bool may_alloc,
 		loff_t valid_size)
@@ -50,6 +24,9 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 	int err;
 	bool balloc = false;
 
+	if ((flags & IOMAP_OVERWRITE_ONLY) && offset + length > valid_size)
+		return -EAGAIN;
+
 	iomap->validity_cookie = valid_size;
 
 	if (!may_alloc) {
@@ -75,6 +52,27 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 	iomap->bdev = inode->i_sb->s_bdev;
 	iomap->offset = offset;
 
+	if (may_alloc && flags & IOMAP_DIRECT) {
+		unsigned int allocated = exfat_bytes_to_cluster(sbi,
+							exfat_ondisk_size(inode));
+		unsigned int first = exfat_bytes_to_cluster(sbi, offset);
+
+		/* Allocate the gap before mapping a write beyond the last cluster. */
+		while (allocated < first) {
+			unsigned int count = first - allocated, clu;
+
+			err = exfat_map_cluster(inode, allocated, &clu, &count,
+						true, NULL);
+			if (err)
+				goto out;
+			if (WARN_ON_ONCE(!count)) {
+				err = -EIO;
+				goto out;
+			}
+			allocated += count;
+		}
+	}
+
 	err = exfat_map_cluster(inode, exfat_bytes_to_cluster(sbi, offset),
 			&cluster, &num_clusters, may_alloc, &balloc);
 	if (err == -ENOSPC && !(flags & IOMAP_DIRECT)) {
@@ -99,7 +97,11 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 	iomap->type = IOMAP_MAPPED;
 	iomap->flags = IOMAP_F_MERGED;
 
-	if (may_alloc || flags & IOMAP_ZERO) {
+	/* Cached VDL update may still need to be persisted for O_DSYNC. */
+	if (flags & IOMAP_OVERWRITE_ONLY)
+		iomap->flags |= IOMAP_F_DIRTY;
+
+	if (may_alloc || flags & (IOMAP_ZERO | IOMAP_OVERWRITE_ONLY)) {
 		if (balloc)
 			iomap->flags |= IOMAP_F_NEW;
 	} else {
@@ -143,22 +145,40 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 	return err;
 }
 
-static int exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
-		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+static int exfat_iomap_next(const struct iomap_iter *iter,
+			   struct iomap *iomap, struct iomap *srcmap)
 {
-	return __exfat_iomap_begin(inode, offset, length, flags, iomap, false,
-				exfat_get_valid_size(EXFAT_I(inode)));
+	const loff_t *dio_valid_size = iter->private;
+	loff_t valid_size;
+	int ret;
+
+	if (iomap->length) {
+		ret = iomap_iter_continue(iter, iomap, srcmap, 0);
+		if (ret <= 0)
+			return ret;
+	}
+	if (iter->flags & IOMAP_DIRECT)
+		valid_size = *dio_valid_size;
+	else
+		valid_size = exfat_get_valid_size(EXFAT_I(iter->inode));
+	ret = __exfat_iomap_begin(iter->inode, iter->pos, iter->len,
+				 iter->flags, iomap, false, valid_size);
+	return ret ?: 1;
 }
 
 static int exfat_write_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
-	return __exfat_iomap_begin(inode, offset, length, flags, iomap, true,
-				exfat_get_valid_size(EXFAT_I(inode)));
+	int ret;
+
+	ret = __exfat_iomap_begin(inode, offset, length, flags, iomap, true,
+				  exfat_get_valid_size(EXFAT_I(inode)));
+	if (!ret && (flags & IOMAP_DIRECT) &&
+	    offset + iomap->length > iomap->validity_cookie)
+		iomap->flags |= IOMAP_F_DIRTY;
+	return ret;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(exfat_iomap_next, exfat_iomap_begin);
-
 const struct iomap_ops exfat_iomap_ops = {
 	.iomap_next = exfat_iomap_next,
 };
@@ -186,36 +206,40 @@ static const struct iomap_ops exfat_swap_iomap_ops = {
 #endif
 
 /*
- * exfat_write_iomap_end - Update the state after write
- *
- * Extends ->valid_size to cover the newly written range.
- * Marks the inode dirty if metadata was changed.
+ * exfat_write_iomap_end - Record buffered file size changes
  */
 static int exfat_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 		ssize_t written, unsigned int flags, struct iomap *iomap)
 {
-	struct exfat_inode_info *ei = EXFAT_I(inode);
-	bool dirtied = false;
-	loff_t end;
-
 	if (!written)
 		return 0;
 
-	end = pos + written;
-
-	if (exfat_advance_valid_size(ei, end))
-		dirtied = true;
-
-	exfat_advance_zeroed_size(ei, end);
-
-	if (dirtied || iomap->flags & IOMAP_F_SIZE_CHANGED)
+	if (iomap->flags & IOMAP_F_SIZE_CHANGED)
 		mark_inode_dirty(inode);
 
 	return written;
 }
 
-static DEFINE_IOMAP_ITER_NEXT_END(exfat_write_iomap_next,
-		exfat_write_iomap_begin, exfat_write_iomap_end);
+static int exfat_write_iomap_next(const struct iomap_iter *iter,
+				  struct iomap *iomap, struct iomap *srcmap)
+{
+	int ret;
+
+	ret = iomap_iter_next(iter, iomap, srcmap, exfat_write_iomap_begin,
+			      exfat_write_iomap_end);
+	if (ret == -ENOSPC && (iter->flags & IOMAP_DIRECT)) {
+		const struct exfat_dio *dio = iter->private;
+
+		/*
+		 * ENOTBLK makes iomap wait for the submitted bios and report
+		 * a short write only if they succeeded.
+		 */
+		if (iter->pos > dio->start)
+			return -ENOTBLK;
+	}
+
+	return ret;
+}
 
 const struct iomap_ops exfat_write_iomap_ops = {
 	.iomap_next	= exfat_write_iomap_next,
@@ -298,6 +322,48 @@ const struct iomap_write_ops exfat_iomap_write_ops = {
 	.read_folio_range = exfat_iomap_read_folio_range,
 };
 
+/*
+ * Gap zeroing follows the direct write. Keep completed data intact when the
+ * gap and the write share a filesystem block.
+ */
+static int exfat_dio_gap_read_folio_range(const struct iomap_iter *iter,
+		struct folio *folio, loff_t pos, size_t len)
+{
+	const struct exfat_dio *dio = iter->private;
+	loff_t valid = iter->iomap.validity_cookie;
+	loff_t end = pos + len;
+	loff_t start, stop;
+	int error;
+
+	if (pos < valid || end > dio->start) {
+		error = iomap_bio_read_folio_range_sync(iter, folio, pos, len);
+		if (error)
+			return error;
+	} else {
+		folio_zero_range(folio, offset_in_folio(folio, pos), len);
+		return 0;
+	}
+
+	start = max(pos, valid);
+	stop = min(end, dio->start);
+	if (start < stop)
+		folio_zero_segment(folio, offset_in_folio(folio, start),
+				   offset_in_folio(folio, pos) + stop - pos);
+
+	start = max(pos, dio->start + dio->completed);
+	if (start < end)
+		folio_zero_segment(folio, offset_in_folio(folio, start),
+				   offset_in_folio(folio, pos) + len);
+	return 0;
+}
+
+const struct iomap_write_ops exfat_dio_gap_write_ops = {
+	.get_folio	= exfat_iomap_get_folio,
+	.put_folio	= exfat_iomap_put_folio,
+	.iomap_valid	= exfat_iomap_valid,
+	.read_folio_range = exfat_dio_gap_read_folio_range,
+};
+
 /*
  * exfat_writeback_range - Map folio during writeback
  *
diff --git a/fs/exfat/iomap.h b/fs/exfat/iomap.h
index 39c93f8cd790..f8f018f87230 100644
--- a/fs/exfat/iomap.h
+++ b/fs/exfat/iomap.h
@@ -6,10 +6,17 @@
 #ifndef _LINUX_EXFAT_IOMAP_H
 #define _LINUX_EXFAT_IOMAP_H
 
-extern const struct iomap_dio_ops exfat_write_dio_ops;
+/* One synchronous attempt for a direct write extending valid_size. */
+struct exfat_dio {
+	struct kiocb iocb;
+	loff_t start;
+	loff_t completed;
+};
+
 extern const struct iomap_ops exfat_iomap_ops;
 extern const struct iomap_ops exfat_write_iomap_ops;
 extern const struct iomap_write_ops exfat_iomap_write_ops;
+extern const struct iomap_write_ops exfat_dio_gap_write_ops;
 extern const struct iomap_writeback_ops exfat_writeback_ops;
 extern const struct iomap_read_ops exfat_iomap_bio_read_ops;
 
-- 
2.53.0

