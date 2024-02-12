Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BBE3D56B
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 17:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757208; cv=none; b=no1qGiypaG39YqHwRJvkDU3dVNXjBFqZULieTyh9uphLS/aEAijhkQ8U8Xs0kDd4X+5zBFq6DCrbAy5Z8bEkNUbNOWQgDb3FvukWUrSle86uoaYVJhnMgyj0JPFjOlEmYj3ur7wE11Z+onl8kay8em6wS8TIC2+O1SrtzXATs+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757208; c=relaxed/simple;
	bh=gqPwTi/iI7+V5Msjzc3RNk/M6KJnaDdjZn8/50/WjMg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D4L2+w94z27Cm5EhkaqRrNTGe5UmawedvOTlHdgIsb5G5OiKVQutSfsKS6qrsMkykYtXtY2VWFQD+aJMGf6ELjz+z85Dzwsz4G7lRUi36gmZsyjtr4/Md51RGjIvUYA1/YLjcuxZuPDha8b8jlSnQQdob44Pu7APAt1sVFcmyKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EZTHfbw0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EZTHfbw0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+rOTZjO78lnXVnaORi03L3fAP8ZzltwHyB9rd8lOsoc=;
	b=EZTHfbw0AMEAA/2lc6A/YacCG+8J+loqiMdZnBTbD1NGWwg9fLgOf505mBzXugh0TZJ39H
	WzVQ1+mDF+sQMpJtRFqEuFrAPu4k6ehe+8Cytr3JkXP7i6FSd4wAROyJerd6MJnmeTJBQK
	CBPBXzNFWNBUmWKxC23NJJf8yvqm8Ag=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-VNT0T-TNO2y8VkI1bVY8Tw-1; Mon, 12 Feb 2024 12:00:03 -0500
X-MC-Unique: VNT0T-TNO2y8VkI1bVY8Tw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-55ffcfed2ffso4899181a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 09:00:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757201; x=1708362001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+rOTZjO78lnXVnaORi03L3fAP8ZzltwHyB9rd8lOsoc=;
        b=vn2OBeZ99Zk8AvzCeibKGik//Muq4MrLmcTyJKHVu/loRup8HvZmo33GYqSU1zOHAJ
         yItSEFSqmxHDOgmtjNXr62xjavMzUGhRi3JclqTX7dG7yh0xfWxcLzBsd+O+6EvGTaod
         evut87YgWnYCgE4J3MiQkshOk1paiA24QX8sSPhM/YxpqrojIiT4Xg3E89rvvGhFjy2W
         3uBz8W5XqxASZSvzBUigrkYwI181phYO9/39fjiAdZB1v3zWNJ3QtgT4WidDVMHOOrcR
         /YfM78CY32eQBRlcF4LZona0tLbxTwSJIAmGbctTfEmN2v5Bqtemg2upv99+ZxAsFnoV
         MTLw==
X-Forwarded-Encrypted: i=1; AJvYcCUjQ978067/guVAMiSBGvuQZVdfbhoYvHBYqnOOBo3kCk1zT4Le+DfycrbSP7p/jTdoyibtmLJRxn2XCAb7c8T0imil6W7rvDgg
X-Gm-Message-State: AOJu0YyaIfcwmfeGrIziml+YNr448PSdLy3bxBAGZuv4o/bUcpy/rXj7
	TmHp6r2+DB5h3X9qhj0mPJl06FEEncqWv1brTWJvNIBz8fRw4VQICS/DmwXHc5K17mK3Ex5N9Hz
	GAL89j67D6ycw7Hjg9XmWuO5xUBN2dFL1mbEkX06XGBLT/pomJCBze9sC
X-Received: by 2002:a05:6402:6c7:b0:561:4562:6187 with SMTP id n7-20020a05640206c700b0056145626187mr57889edy.12.1707757201524;
        Mon, 12 Feb 2024 09:00:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZ8SZf79gVOrdJ0iUSk5/4gUmg7Ux3jY3Tr4bex34FhvPUTKw5RxYr3uZN3CEUwPMXFTSt5A==
X-Received: by 2002:a05:6402:6c7:b0:561:4562:6187 with SMTP id n7-20020a05640206c700b0056145626187mr57879edy.12.1707757201244;
        Mon, 12 Feb 2024 09:00:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWWYxbCTfNPhC0MnK6pSKt2cSwVhRAaS3e2KP3aw2uflsIVje+1GJjjdpw1Ig3E9PdGGN3xcnyzSIGbQi6Ld7Vw7/pwcSGBLovUV3Gsw73FuhBNk3sBabFRUGUtqRXi/HM03r4G0P3glfUTEWBtovChrPYze1thK5fK4HG0pUWKYR8emz6T1cgk+Yup/uB5RtWotrKbp+A39jZvpTJRh/Jh2oiAPy1Ab+1GXQ8fOeDEaY95/4U+
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.08.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 09:00:00 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 10/25] iomap: integrate fsverity verification into iomap's read path
Date: Mon, 12 Feb 2024 17:58:07 +0100
Message-Id: <20240212165821.1901300-11-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240212165821.1901300-1-aalbersh@redhat.com>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds fsverity verification into iomap's read path. After
BIO's io operation is complete the data are verified against
fsverity's Merkle tree. Verification work is done in a separate
workqueue.

Even though fsverity can create its own workqueue, this patch allows
filesystems to pass any workqueue for fs-verity verification work
items. This is handy for XFS as fsverity's high priority global
workqueue isn't the best fit (potential livelock, global
cross-filesystem queue).

The read path ioend iomap_read_ioend are stored side by side with
BIOs if FS_VERITY is enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/erofs/data.c        |   4 +-
 fs/gfs2/aops.c         |   4 +-
 fs/iomap/buffered-io.c | 102 ++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_aops.c      |   4 +-
 fs/zonefs/file.c       |   4 +-
 include/linux/iomap.h  |   6 ++-
 6 files changed, 103 insertions(+), 21 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index c98aeda8abb2..462917830b50 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -356,12 +356,12 @@ int erofs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
  */
 static int erofs_read_folio(struct file *file, struct folio *folio)
 {
-	return iomap_read_folio(folio, &erofs_iomap_ops);
+	return iomap_read_folio(folio, &erofs_iomap_ops, NULL);
 }
 
 static void erofs_readahead(struct readahead_control *rac)
 {
-	return iomap_readahead(rac, &erofs_iomap_ops);
+	return iomap_readahead(rac, &erofs_iomap_ops, NULL);
 }
 
 static sector_t erofs_bmap(struct address_space *mapping, sector_t block)
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 974aca9c8ea8..ede423796125 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -452,7 +452,7 @@ static int gfs2_read_folio(struct file *file, struct folio *folio)
 
 	if (!gfs2_is_jdata(ip) ||
 	    (i_blocksize(inode) == PAGE_SIZE && !folio_buffers(folio))) {
-		error = iomap_read_folio(folio, &gfs2_iomap_ops);
+		error = iomap_read_folio(folio, &gfs2_iomap_ops, NULL);
 	} else if (gfs2_is_stuffed(ip)) {
 		error = stuffed_read_folio(ip, folio);
 	} else {
@@ -527,7 +527,7 @@ static void gfs2_readahead(struct readahead_control *rac)
 	else if (gfs2_is_jdata(ip))
 		mpage_readahead(rac, gfs2_block_map);
 	else
-		iomap_readahead(rac, &gfs2_iomap_ops);
+		iomap_readahead(rac, &gfs2_iomap_ops, NULL);
 }
 
 /**
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 093c4515b22a..719c3dec9652 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/compiler.h>
 #include <linux/fs.h>
+#include <linux/fsverity.h>
 #include <linux/iomap.h>
 #include <linux/pagemap.h>
 #include <linux/uio.h>
@@ -289,6 +290,7 @@ struct iomap_readpage_ctx {
 	bool			cur_folio_in_bio;
 	struct bio		*bio;
 	struct readahead_control *rac;
+	struct workqueue_struct	*wq;
 };
 
 /**
@@ -330,6 +332,57 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
 		pos >= i_size_read(iter->inode);
 }
 
+#ifdef CONFIG_FS_VERITY
+struct iomap_fsverity_bio {
+	struct work_struct	work;
+	struct bio		bio;
+};
+static struct bio_set iomap_fsverity_bioset;
+
+static void
+iomap_read_fsverify_end_io_work(struct work_struct *work)
+{
+	struct iomap_fsverity_bio *fbio =
+		container_of(work, struct iomap_fsverity_bio, work);
+
+	fsverity_verify_bio(&fbio->bio);
+	iomap_read_end_io(&fbio->bio);
+}
+
+static void
+iomap_read_fsverity_end_io(struct bio *bio)
+{
+	struct iomap_fsverity_bio *fbio =
+		container_of(bio, struct iomap_fsverity_bio, bio);
+
+	INIT_WORK(&fbio->work, iomap_read_fsverify_end_io_work);
+	queue_work(bio->bi_private, &fbio->work);
+}
+#endif /* CONFIG_FS_VERITY */
+
+static struct bio *iomap_read_bio_alloc(struct inode *inode,
+		struct block_device *bdev, int nr_vecs, gfp_t gfp,
+		struct workqueue_struct *wq)
+{
+	struct bio *bio;
+
+#ifdef CONFIG_FS_VERITY
+	if (fsverity_active(inode)) {
+		bio = bio_alloc_bioset(bdev, nr_vecs, REQ_OP_READ, gfp,
+					&iomap_fsverity_bioset);
+		if (bio) {
+			bio->bi_private = wq;
+			bio->bi_end_io = iomap_read_fsverity_end_io;
+		}
+		return bio;
+	}
+#endif
+	bio = bio_alloc(bdev, nr_vecs, REQ_OP_READ, gfp);
+	if (bio)
+		bio->bi_end_io = iomap_read_end_io;
+	return bio;
+}
+
 static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 		struct iomap_readpage_ctx *ctx, loff_t offset)
 {
@@ -353,6 +406,12 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 
 	if (iomap_block_needs_zeroing(iter, pos)) {
 		folio_zero_range(folio, poff, plen);
+		if (fsverity_active(iter->inode) &&
+		    !fsverity_verify_blocks(folio, plen, poff)) {
+			folio_set_error(folio);
+			goto done;
+		}
+
 		iomap_set_range_uptodate(folio, poff, plen);
 		goto done;
 	}
@@ -370,28 +429,29 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 	    !bio_add_folio(ctx->bio, folio, plen, poff)) {
 		gfp_t gfp = mapping_gfp_constraint(folio->mapping, GFP_KERNEL);
 		gfp_t orig_gfp = gfp;
-		unsigned int nr_vecs = DIV_ROUND_UP(length, PAGE_SIZE);
 
 		if (ctx->bio)
 			submit_bio(ctx->bio);
 
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
-		ctx->bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs),
-				     REQ_OP_READ, gfp);
+
+		ctx->bio = iomap_read_bio_alloc(iter->inode, iomap->bdev,
+				bio_max_segs(DIV_ROUND_UP(length, PAGE_SIZE)),
+				gfp, ctx->wq);
+
 		/*
 		 * If the bio_alloc fails, try it again for a single page to
 		 * avoid having to deal with partial page reads.  This emulates
 		 * what do_mpage_read_folio does.
 		 */
 		if (!ctx->bio) {
-			ctx->bio = bio_alloc(iomap->bdev, 1, REQ_OP_READ,
-					     orig_gfp);
+			ctx->bio = iomap_read_bio_alloc(iter->inode,
+					iomap->bdev, 1, orig_gfp, ctx->wq);
 		}
 		if (ctx->rac)
 			ctx->bio->bi_opf |= REQ_RAHEAD;
 		ctx->bio->bi_iter.bi_sector = sector;
-		ctx->bio->bi_end_io = iomap_read_end_io;
 		bio_add_folio_nofail(ctx->bio, folio, plen, poff);
 	}
 
@@ -405,7 +465,8 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 	return pos - orig_pos + plen;
 }
 
-int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
+int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops,
+		struct workqueue_struct *wq)
 {
 	struct iomap_iter iter = {
 		.inode		= folio->mapping->host,
@@ -414,6 +475,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 	};
 	struct iomap_readpage_ctx ctx = {
 		.cur_folio	= folio,
+		.wq		= wq,
 	};
 	int ret;
 
@@ -471,6 +533,7 @@ static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
  * iomap_readahead - Attempt to read pages from a file.
  * @rac: Describes the pages to be read.
  * @ops: The operations vector for the filesystem.
+ * @wq: Workqueue for post-I/O processing (only need for fsverity)
  *
  * This function is for filesystems to call to implement their readahead
  * address_space operation.
@@ -482,7 +545,8 @@ static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
  * function is called with memalloc_nofs set, so allocations will not cause
  * the filesystem to be reentered.
  */
-void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
+void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops,
+		struct workqueue_struct *wq)
 {
 	struct iomap_iter iter = {
 		.inode	= rac->mapping->host,
@@ -491,6 +555,7 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
 	};
 	struct iomap_readpage_ctx ctx = {
 		.rac	= rac,
+		.wq	= wq,
 	};
 
 	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
@@ -1996,10 +2061,25 @@ iomap_writepages(struct address_space *mapping, struct writeback_control *wbc,
 }
 EXPORT_SYMBOL_GPL(iomap_writepages);
 
+#define IOMAP_POOL_SIZE		(4 * (PAGE_SIZE / SECTOR_SIZE))
+
 static int __init iomap_init(void)
 {
-	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
-			   offsetof(struct iomap_ioend, io_inline_bio),
-			   BIOSET_NEED_BVECS);
+	int error;
+
+	error = bioset_init(&iomap_ioend_bioset, IOMAP_POOL_SIZE,
+			    offsetof(struct iomap_ioend, io_inline_bio),
+			    BIOSET_NEED_BVECS);
+#ifdef CONFIG_FS_VERITY
+	if (error)
+		return error;
+
+	error = bioset_init(&iomap_fsverity_bioset, IOMAP_POOL_SIZE,
+			    offsetof(struct iomap_fsverity_bio, bio),
+			    BIOSET_NEED_BVECS);
+	if (error)
+		bioset_exit(&iomap_ioend_bioset);
+#endif
+	return error;
 }
 fs_initcall(iomap_init);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 813f85156b0c..7a6627404160 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -553,14 +553,14 @@ xfs_vm_read_folio(
 	struct file		*unused,
 	struct folio		*folio)
 {
-	return iomap_read_folio(folio, &xfs_read_iomap_ops);
+	return iomap_read_folio(folio, &xfs_read_iomap_ops, NULL);
 }
 
 STATIC void
 xfs_vm_readahead(
 	struct readahead_control	*rac)
 {
-	iomap_readahead(rac, &xfs_read_iomap_ops);
+	iomap_readahead(rac, &xfs_read_iomap_ops, NULL);
 }
 
 static int
diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 6ab2318a9c8e..d7a166bf15ac 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -112,12 +112,12 @@ static const struct iomap_ops zonefs_write_iomap_ops = {
 
 static int zonefs_read_folio(struct file *unused, struct folio *folio)
 {
-	return iomap_read_folio(folio, &zonefs_read_iomap_ops);
+	return iomap_read_folio(folio, &zonefs_read_iomap_ops, NULL);
 }
 
 static void zonefs_readahead(struct readahead_control *rac)
 {
-	iomap_readahead(rac, &zonefs_read_iomap_ops);
+	iomap_readahead(rac, &zonefs_read_iomap_ops, NULL);
 }
 
 /*
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 96dd0acbba44..c7522eb3a8ea 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -262,8 +262,10 @@ int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
 		struct iomap *iomap, loff_t pos, loff_t length, ssize_t written,
 		int (*punch)(struct inode *inode, loff_t pos, loff_t length));
 
-int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops);
-void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
+int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops,
+		struct workqueue_struct *wq);
+void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops,
+		struct workqueue_struct *wq);
 bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);
 struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len);
 bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
-- 
2.42.0

