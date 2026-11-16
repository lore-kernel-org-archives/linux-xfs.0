Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819567;
	b=ZYemYRidajH0U5TmxC4/7R62lcTS015zhKr2znasbmuSQ4XNsyV8xP4eSyJjSF97SWbi
	 6DcDMFEXi8gSs7nNOT1Hq2Oz1XuM3dkxUQV+eMwkJdcuI+sdtAloV4KXtftHfvKMKngYQ
	 +Vb8Op1iY1sxc2sUqPwi/1Rfi3hajYcL4rU5wOnVb3GX45Qwl9aoqsF5hgvi2vu8P6to8
	 JrnNfKDmsdVGdzl6auT1TK42hbYS/TImGFIQXgQ/AcH5RCzKD5+eA0CBijh1AIpsh/jA6
	 BRUfQ99Sk6vS1v9GYixrY6gAUM1084yU0MG//gZuAE3W65r5d8I6IScYOp3ZF34wy3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819567;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=fM+astTCtUZ1blZW6li4JOL3Im4ie5grykLoPD7Shmk=;
	b=Xl28iAwCU/76HAeuGAE3itkPiknN2isH2ClnJLHY8aFBcREqruoTkxRfPYtjTSk+Fqz4
	 JqXZs5HX5pY94HZ74r14Yf5dmhM6kdaUWnKIc1JcGyITiesPzMjnixtCvGwTi6ONhRxu8
	 c3jaVYWesXsZQgjZYQN2abTaAmm4syTb4mljporL/iY2oF1MN40QdzS6cxkXx0gMSGf+w
	 3Q0dDd7/tshO7lPYyHHLCiLuv8nHtsu64HpPXshqGFWq5fQsmi7YxvXMlOZJa+opkh6Zg
	 JQGNIPu+42xJMiv/Dsm7DxtGVYce3ioF+xLRLU9yVe2daf7zZOkTqvnCurFmG8BUHAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=VK2y4GM7;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ECB606A888;
	Mon, 16 Nov 2026 08:59:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68ECB606A888
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=VK2y4GM7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=fM
	+astTCtUZ1blZW6li4JOL3Im4ie5grykLoPD7Shmk=; b=VK2y4GM7L3M3sqFub1
	pgztJMCleC/7d7iiBeJvas0yyTwX0lyNniR/KdetOgETaZd134OSyG9JIN3ZyQ31
	85gFgkl9GQx71LysSkzc3ecdCd1pLh5BpzKriYi5N8utPnDH3jZdhJASYQ9qSfrt
	BOaTH8jPMRrHOpabT8CbLp+eE=
Received: from czl-pc (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wAH5iLPxfpqqlTnHw--.59228S5;
	Mon, 16 Nov 2026 16:58:59 +0800 (CST)
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
Subject: [PATCH v4 3/5] exfat: zero invalid VDL tails in buffered and direct reads
Date: Mon, 16 Nov 2026 16:57:50 +0800
Message-ID: <20261116085752.3908082-4-chizhiling@163.com>
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
X-CM-TRANSID:_____wAH5iLPxfpqqlTnHw--.59228S5
X-Coremail-Antispam: 1Uf129KBjvAXoW3tryDXw43Ww4xAF1UJF1UKFg_yoW8Gr15uo
	WftanIqr4Fkr9rAFWUGr1aqFy7Wa1Du34xGFs09rs0vF17t3WDAwsxJw43Za13Xr1qya1D
	A39rta18GrWjyF48n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU3k9NUUUUU
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9xP+nGr6xdOT5gAA31

From: Chi Zhiling <chizhiling@kylinos.cn>

Reading the block that contains VDL also reads bytes beyond that
boundary. Zero those bytes before the range becomes uptodate, including
when a short user copy leaves part of a write untouched.

Use the same VDL snapshot for mapping lookup and validity checks. After
locking the folio, retry a stale mapping and zero invalid bytes from
read_folio_range before iomap marks the range uptodate. Use
iomap_bio_read_folio_range_sync() for the synchronous read and preserve
the mapping snapshot until asynchronous reads complete as well.

Track initialized block tails under the folio lock and clamp that state
on truncate. Remove the earlier zeroing from iomap_begin and stop using
IOMAP_F_ZERO_TAIL.

Clip direct mappings to the exact VDL boundary. Return -ENOTBLK from
the mapping callback for an unaligned VDL tail and finish a short direct
read with filemap_read(), rather than prechecking VDL in read_iter.
Use the same iomap operations for buffered and direct reads.

Fixes: 9e5711b9cfe3 ("exfat: zero invalid tail on partial overwrites")
Fixes: 867b9c96dc83 ("exfat: add iomap direct I/O support")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Co-developed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/exfat/exfat_fs.h |   2 +-
 fs/exfat/file.c     |   7 +-
 fs/exfat/iomap.c    | 188 +++++++++++++++++++++++++++-----------------
 3 files changed, 120 insertions(+), 77 deletions(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index eee573d1697c..9c43022743ed 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -303,7 +303,7 @@ struct exfat_inode_info {
 	 * concurrent update can never regress the value or tear on 32-bit.
 	 */
 	atomic64_t valid_size;
-	/* block-aligned size zeroed in the page cache (>= valid_size) */
+	/* Initialized cache prefix, including block tails; may lag after DIO. */
 	atomic64_t zeroed_size;
 	/* hash by i_location */
 	struct hlist_node i_hash_fat;
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 13778c72c978..47e95b14d570 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -301,10 +301,10 @@ int __exfat_truncate(struct inode *inode)
 		ei->start_clu = EXFAT_EOF_CLUSTER;
 	}
 
-	if (i_size_read(inode) < exfat_get_valid_size(ei)) {
+	if (i_size_read(inode) < exfat_get_valid_size(ei))
 		exfat_set_valid_size(ei, i_size_read(inode));
+	if (i_size_read(inode) < exfat_get_zeroed_size(ei))
 		exfat_set_zeroed_size(ei, i_size_read(inode));
-	}
 
 	if (ei->type == TYPE_FILE)
 		ei->attr |= EXFAT_ATTR_ARCHIVE;
@@ -974,6 +974,9 @@ static ssize_t exfat_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		file_accessed(iocb->ki_filp);
 		ret = iomap_dio_rw(iocb, iter, &exfat_iomap_ops, NULL, 0,
 				NULL, 0);
+		if (ret >= 0 && iov_iter_count(iter) &&
+		    iocb->ki_pos < i_size_read(inode))
+			ret = filemap_read(iocb, iter, ret);
 	} else {
 		ret = generic_file_read_iter(iocb, iter);
 	}
diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index 0a37ed9b7330..7eb31a6091b3 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -7,6 +7,7 @@
 
 #include <linux/iomap.h>
 #include <linux/pagemap.h>
+#include <linux/slab.h>
 
 #include "exfat_raw.h"
 #include "exfat_fs.h"
@@ -39,17 +40,18 @@ const struct iomap_dio_ops exfat_write_dio_ops = {
 };
 
 static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
-		unsigned int flags, struct iomap *iomap, bool may_alloc)
+		unsigned int flags, struct iomap *iomap, bool may_alloc,
+		loff_t valid_size)
 {
 	struct super_block *sb = inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
-	struct exfat_inode_info *ei = EXFAT_I(inode);
 	unsigned int cluster, num_clusters;
 	loff_t cluster_offset, cluster_length;
-	loff_t valid_size = exfat_get_valid_size(ei);
 	int err;
 	bool balloc = false;
 
+	iomap->validity_cookie = valid_size;
+
 	if (!may_alloc) {
 		/* Completely beyond EOF. Treat as hole */
 		if (i_size_read(inode) <= offset) {
@@ -100,17 +102,6 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 	if (may_alloc || flags & IOMAP_ZERO) {
 		if (balloc)
 			iomap->flags |= IOMAP_F_NEW;
-		else if (iomap->offset + iomap->length >= valid_size) {
-			/*
-			 * This is a write that starts at or extends beyond
-			 * the current valid_size. The region between the old
-			 * valid_size and the end of this write needs to be
-			 * zeroed in the page cache to prevent stale data
-			 * exposure (see IOMAP_F_ZERO_TAIL handling in
-			 * __iomap_write_begin()).
-			 */
-			iomap->flags |= IOMAP_F_ZERO_TAIL;
-		}
 	} else {
 		/*
 		 * valid_size is tracked in byte granularity and
@@ -129,23 +120,24 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 		if (offset >= valid_size) {
 			iomap->type = flags & IOMAP_REPORT ?
 				IOMAP_HOLE : IOMAP_UNWRITTEN;
+		} else if ((flags & IOMAP_DIRECT) &&
+			   offset + iomap->length >= valid_size &&
+			   !IS_ALIGNED(valid_size, i_blocksize(inode))) {
+			err = -ENOTBLK;
 		} else if (offset + iomap->length > valid_size) {
-			if (flags & IOMAP_REPORT) {
-				/*
-				 * For SEEK_HOLE/SEEK_DATA, clip the length
-				 * to the exact byte boundary (valid_size).
-				 * This ensures the caller gets the precise
-				 * hole position in byte units.
-				 */
+			/*
+			 * Keep SEEK_HOLE/SEEK_DATA and direct I/O mappings
+			 * at the exact valid_size boundary.
+			 */
+			if (flags & (IOMAP_REPORT | IOMAP_DIRECT))
 				iomap->length = valid_size - iomap->offset;
-			} else
+			else
 				iomap->length = round_up(valid_size,
 							 i_blocksize(inode)) -
 								iomap->offset;
 		}
 	}
 
-	iomap->flags |= IOMAP_F_MERGED;
 out:
 	mutex_unlock(&sbi->s_lock);
 	return err;
@@ -154,33 +146,15 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 static int exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
-	return __exfat_iomap_begin(inode, offset, length, flags, iomap, false);
+	return __exfat_iomap_begin(inode, offset, length, flags, iomap, false,
+				exfat_get_valid_size(EXFAT_I(inode)));
 }
 
 static int exfat_write_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
-	struct exfat_inode_info *ei = EXFAT_I(inode);
-	loff_t valid_size = exfat_get_valid_size(ei);
-	loff_t end;
-	int err;
-
-	err = __exfat_iomap_begin(inode, offset, length, flags, iomap, true);
-	if (err || flags & (IOMAP_DIRECT | IOMAP_FAULT) ||
-	    iomap->flags & IOMAP_F_NEW)
-		return err;
-
-	end = iomap->offset + iomap->length;
-	if (end >= valid_size ||
-	    round_up(end, i_blocksize(inode)) <= valid_size)
-		return 0;
-
-	/*
-	 * Zero the invalid bytes from valid_size to the end of the block
-	 * to prevent stale data from being exposed through the page cache.
-	 */
-	return iomap_truncate_page(inode, valid_size, NULL, &exfat_iomap_ops,
-				   NULL, NULL);
+	return __exfat_iomap_begin(inode, offset, length, flags, iomap, true,
+				exfat_get_valid_size(EXFAT_I(inode)));
 }
 
 static DEFINE_IOMAP_ITER_NEXT(exfat_iomap_next, exfat_iomap_begin);
@@ -199,7 +173,8 @@ static int exfat_swap_iomap_begin(struct inode *inode, loff_t offset,
 	 * ranges. Do not report the VDL tail as a hole.
 	 */
 	return __exfat_iomap_begin(inode, offset, length,
-			flags & ~IOMAP_REPORT, iomap, false);
+				flags & ~IOMAP_REPORT, iomap, false,
+				exfat_get_valid_size(EXFAT_I(inode)));
 }
 
 static DEFINE_IOMAP_ITER_NEXT(exfat_swap_iomap_next,
@@ -231,12 +206,6 @@ static int exfat_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	if (exfat_advance_valid_size(ei, end))
 		dirtied = true;
 
-	/*
-	 * IOMAP_F_ZERO_TAIL zeroes the remainder of the last block. Track that
-	 * block as zeroed so later valid_size extensions do not zero it again.
-	 */
-	if (iomap->flags & IOMAP_F_ZERO_TAIL)
-		end = round_up(end, i_blocksize(inode));
 	exfat_advance_zeroed_size(ei, end);
 
 	if (dirtied || iomap->flags & IOMAP_F_SIZE_CHANGED)
@@ -252,6 +221,60 @@ const struct iomap_ops exfat_write_iomap_ops = {
 	.iomap_next	= exfat_write_iomap_next,
 };
 
+static void exfat_zero_invalid_range(struct folio *folio, loff_t pos,
+				     size_t len, loff_t valid_size)
+{
+	loff_t start = max(pos, valid_size);
+
+	if (start < pos + len)
+		folio_zero_segment(folio, offset_in_folio(folio, start),
+				   offset_in_folio(folio, pos) + len);
+}
+
+static struct folio *exfat_iomap_get_folio(struct iomap_iter *iter, loff_t pos,
+					   unsigned int len)
+{
+	struct folio *folio = iomap_get_folio(iter, pos, len);
+
+	if (!IS_ERR(folio))
+		iter->iomap.private = folio;
+	return folio;
+}
+
+static bool exfat_iomap_valid(struct inode *inode, const struct iomap *iomap)
+{
+	struct folio *folio = iomap->private;
+	loff_t valid_size = exfat_get_valid_size(EXFAT_I(inode));
+	loff_t old_valid_size = iomap->validity_cookie;
+
+	if (valid_size == old_valid_size)
+		return true;
+	if (!folio)
+		return false;
+
+	return old_valid_size >= folio_next_pos(folio) ||
+		valid_size <= folio_pos(folio);
+}
+
+/* Called after iomap_valid(), with the destination folio still locked. */
+static int exfat_iomap_read_folio_range(const struct iomap_iter *iter,
+					struct folio *folio, loff_t pos, size_t len)
+{
+	loff_t valid_size = iter->iomap.validity_cookie;
+	int error = 0;
+
+	if (pos < valid_size)
+		error = iomap_bio_read_folio_range_sync(iter, folio, pos, len);
+
+	/*
+	 * Sanitize all invalid bytes before iomap marks this range uptodate,
+	 * including bytes that a short user copy may leave untouched.
+	 */
+	if (!error)
+		exfat_zero_invalid_range(folio, pos, len, valid_size);
+	return error;
+}
+
 static void exfat_iomap_put_folio(struct inode *inode, loff_t pos,
 				  unsigned int copied, struct folio *folio)
 {
@@ -260,6 +283,8 @@ static void exfat_iomap_put_folio(struct inode *inode, loff_t pos,
 
 		if (exfat_advance_valid_size(ei, pos + copied))
 			mark_inode_dirty(inode);
+		exfat_advance_zeroed_size(ei,
+					  round_up(pos + copied, i_blocksize(inode)));
 	}
 
 	folio_unlock(folio);
@@ -267,7 +292,10 @@ static void exfat_iomap_put_folio(struct inode *inode, loff_t pos,
 }
 
 const struct iomap_write_ops exfat_iomap_write_ops = {
+	.get_folio	= exfat_iomap_get_folio,
 	.put_folio	= exfat_iomap_put_folio,
+	.iomap_valid	= exfat_iomap_valid,
+	.read_folio_range = exfat_iomap_read_folio_range,
 };
 
 /*
@@ -289,7 +317,8 @@ static ssize_t exfat_writeback_range(struct iomap_writepage_ctx *wpc,
 		int error;
 
 		error = __exfat_iomap_begin(inode, offset, len,
-				0, &wpc->iomap, false);
+				0, &wpc->iomap, false,
+				exfat_get_valid_size(EXFAT_I(inode)));
 		if (error)
 			return error;
 	}
@@ -302,41 +331,52 @@ const struct iomap_writeback_ops exfat_writeback_ops = {
 	.writeback_submit	= iomap_ioend_writeback_submit,
 };
 
-/**
- * exfat_iomap_read_end_io - iomap read bio completion handler for exFAT
- * @bio: bio that has completed reading
- *
- * exfat_iomap_begin() rounds up MAPPED extents to the block boundary of
- * valid_size. This ensures that any subsequent blocks are treated as
- * IOMAP_UNWRITTEN, but it also causes the "straddle block" containing
- * valid_size to be read from disk. The disk data beyond valid_size in
- * this block is stale and must be zeroed to prevent data leakage.
- */
-static void exfat_iomap_read_end_io(struct bio *bio)
+struct exfat_iomap_read_ctx {
+	loff_t valid_size;
+};
+
+static void exfat_iomap_finish_read(struct bio *bio, loff_t valid_size, int error)
 {
-	int error = blk_status_to_errno(bio->bi_status);
 	struct folio_iter iter;
 
 	bio_for_each_folio_all(iter, bio) {
 		struct folio *folio = iter.folio;
-		struct exfat_inode_info *ei = EXFAT_I(folio->mapping->host);
-		s64 valid_size;
-		loff_t pos = folio_pos(folio);
-
-		valid_size = exfat_get_valid_size(ei);
-		if (pos + iter.offset < valid_size &&
-		    pos + iter.offset + iter.length > valid_size)
-			folio_zero_segment(folio, offset_in_folio(folio, valid_size),
-					   iter.offset + iter.length);
 
+		exfat_zero_invalid_range(folio, folio_pos(folio) + iter.offset,
+					 iter.length, valid_size);
 		iomap_finish_folio_read(folio, iter.offset, iter.length, error);
 	}
 	bio_put(bio);
 }
 
+static void exfat_iomap_read_end_io(struct bio *bio)
+{
+	struct exfat_iomap_read_ctx *ctx = bio->bi_private;
+	loff_t valid_size = ctx->valid_size;
+
+	kfree(ctx);
+	exfat_iomap_finish_read(bio, valid_size,
+				blk_status_to_errno(bio->bi_status));
+}
+
 static void exfat_iomap_bio_submit_read(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx)
 {
+	struct bio *bio = ctx->read_ctx;
+	struct exfat_iomap_read_ctx *read_ctx;
+
+	/* The completion must use the boundary that produced this mapping. */
+	read_ctx = kmalloc_obj(*read_ctx, GFP_NOFS);
+	if (!read_ctx) {
+		int error;
+
+		ctx->read_ctx = NULL;
+		error = submit_bio_wait(bio);
+		exfat_iomap_finish_read(bio, iter->iomap.validity_cookie, error);
+		return;
+	}
+	read_ctx->valid_size = iter->iomap.validity_cookie;
+	bio->bi_private = read_ctx;
 	iomap_bio_submit_read_endio(iter, ctx, exfat_iomap_read_end_io);
 }
 
-- 
2.53.0

