Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5309A32197
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 22:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616545; cv=none; b=Q9kzf38cZ6bS5oDaqPCFAiGKf11ipW+XWbEC/Y9AGodb/eIxlbGhBOkmbq7yUBYogkv/XITXGuGoHW9zHCu4mgsLjUDtkb/SYGXhURvGQgb/eTb0j+w5vnFPb1lToIn9Vb6gZJeAUxMMkZ8KG3btKdafutqy0wSkGgD6U0qAh0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616545; c=relaxed/simple;
	bh=2dxpv6wiGYOCfMutbg+D8S26vtoJopdHo/FKlTF2V70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgOfsfmEybpZ0d2p8hOTzL8JYrA2mRnNe5bDz8IT8+5ENDMu5pq6sedxaIEY5v65PakAlPRdGG6rij7ngHOi9aw5YAxKB9LDNGKjb4l49nvR5xuShnyHzINXpciLM/wLp7+1pryfFzstMa5dViSrJ0MsJScGYHq427HD8wWIZTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=PkrvDltm; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="PkrvDltm"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1d480c6342dso896855ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 14:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705616542; x=1706221342; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOQkNaBecqrKeof8epQC7tBtDt+f9sgqsspBN6V4LXw=;
        b=PkrvDltmdEYAUppjOXecctAgINbs7W4T6+q9JbtaWzc/eiH5I8adCCfhwG0DqgVJrx
         PlLUYYqw5XhjvLjThKVzrMqXOe60/QxzbjdVRSpOCEfXI0oF0h6xwUbYcWWqnR1okvzI
         OU5/kTACMgUK+BuczRaPqHvpH437UN6jhCTDvSaIZFbihhEArzP1+DmHwKzsSfPSsLhM
         gPwb8qWNCv8I2xjW/PKn0h3EMnTxIwbjYCSoK/fs+qZfQZYCv0BQFcF1AEWkNBVQ7N+s
         WPrg7DNHTI75kkqqxNcnG/DuNBv8pKMsI12P4xPh2UYHFFI8lQWJ/BUBpSFDIV6FbiME
         yEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705616542; x=1706221342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xOQkNaBecqrKeof8epQC7tBtDt+f9sgqsspBN6V4LXw=;
        b=mp1OaNZ7sAf3tPM5EcDWhXK5APAtlFW/c0mWB2ZXgAlqcqv5BPsxrAZlsfic026Nl1
         nyE9QekvOwuhoSJMwh2avCQCXKN4NnovHx4Y/JUcb12qNDJGuk8HG8TD85LxrS5fRSYO
         Zc4lTja6tcj6CRMpedEVdiIedTcXOJLdFnvNSDvVEWIPq2MKuNcWcMAFFwwu9z8GKdJ5
         1Ps4AdelNa5FUCrFODJt6mDfLZ05EIZt1SP8ea1Cy0hFj4Qs9awSM8ixmF9Xa14QK+CB
         GmZoqQDfHpYoH46pheV/sgFilg2X6pO8wuCQou9TFrxvbVCnGJKyLS7Yl3hGugCLkuXE
         nb0w==
X-Gm-Message-State: AOJu0YyYajCEp/qxPHSpfgqRWvU3EAaOSZ3hnZwJbp3FHfkdx1zMK6n0
	mndGtZ5sGDLL0uvp9UwPv8B85l/p6BIKNsYRIEif3GcpFW6xyBqRBSkTS1FzrfYMZHs/xDJzeyh
	o
X-Google-Smtp-Source: AGHT+IHiaXm1EWAGasNNOOfrGx0XW1ck6lQq+G178B7PjIkwrsJeX+rv69F7epMmGMSQOU5IySypvg==
X-Received: by 2002:a17:902:bc8b:b0:1d5:8bf4:c7b2 with SMTP id bb11-20020a170902bc8b00b001d58bf4c7b2mr1474681plb.88.1705616542573;
        Thu, 18 Jan 2024 14:22:22 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id ji15-20020a170903324f00b001d7164acf5csm601148plb.120.2024.01.18.14.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jan 2024 14:22:22 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rQamB-00CCGQ-11;
	Fri, 19 Jan 2024 09:22:18 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rQamA-0000000HMlq-3FAD;
	Fri, 19 Jan 2024 09:22:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] xfs: use folios in the buffer cache
Date: Fri, 19 Jan 2024 09:19:40 +1100
Message-ID: <20240118222216.4131379-3-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118222216.4131379-1-david@fromorbit.com>
References: <20240118222216.4131379-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

Convert the use of struct pages to struct folio everywhere. This
is just direct API conversion, no actual logic of code changes
should result.

Note: this conversion currently assumes only single page folios are
allocated, and because some of the MM interfaces we use take
pointers to arrays of struct pages, the address of single page
folios and struct pages are the same. e.g alloc_pages_bulk_array(),
vm_map_ram(), etc.


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c      | 127 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf.h      |  14 ++---
 fs/xfs/xfs_buf_item.c |   2 +-
 fs/xfs/xfs_linux.h    |   8 +++
 4 files changed, 80 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 08f2fbc04db5..15907e92d0d3 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -60,25 +60,25 @@ xfs_buf_submit(
 	return __xfs_buf_submit(bp, !(bp->b_flags & XBF_ASYNC));
 }
 
+/*
+ * Return true if the buffer is vmapped.
+ *
+ * b_addr is null if the buffer is not mapped, but the code is clever enough to
+ * know it doesn't have to map a single folio, so the check has to be both for
+ * b_addr and bp->b_folio_count > 1.
+ */
 static inline int
 xfs_buf_is_vmapped(
 	struct xfs_buf	*bp)
 {
-	/*
-	 * Return true if the buffer is vmapped.
-	 *
-	 * b_addr is null if the buffer is not mapped, but the code is clever
-	 * enough to know it doesn't have to map a single page, so the check has
-	 * to be both for b_addr and bp->b_page_count > 1.
-	 */
-	return bp->b_addr && bp->b_page_count > 1;
+	return bp->b_addr && bp->b_folio_count > 1;
 }
 
 static inline int
 xfs_buf_vmap_len(
 	struct xfs_buf	*bp)
 {
-	return (bp->b_page_count * PAGE_SIZE);
+	return (bp->b_folio_count * PAGE_SIZE);
 }
 
 /*
@@ -197,7 +197,7 @@ xfs_buf_get_maps(
 }
 
 /*
- *	Frees b_pages if it was allocated.
+ *	Frees b_maps if it was allocated.
  */
 static void
 xfs_buf_free_maps(
@@ -273,26 +273,26 @@ _xfs_buf_alloc(
 }
 
 static void
-xfs_buf_free_pages(
+xfs_buf_free_folios(
 	struct xfs_buf	*bp)
 {
 	uint		i;
 
-	ASSERT(bp->b_flags & _XBF_PAGES);
+	ASSERT(bp->b_flags & _XBF_FOLIOS);
 
 	if (xfs_buf_is_vmapped(bp))
-		vm_unmap_ram(bp->b_addr, bp->b_page_count);
+		vm_unmap_ram(bp->b_addr, bp->b_folio_count);
 
-	for (i = 0; i < bp->b_page_count; i++) {
-		if (bp->b_pages[i])
-			__free_page(bp->b_pages[i]);
+	for (i = 0; i < bp->b_folio_count; i++) {
+		if (bp->b_folios[i])
+			__folio_put(bp->b_folios[i]);
 	}
-	mm_account_reclaimed_pages(bp->b_page_count);
+	mm_account_reclaimed_pages(bp->b_folio_count);
 
-	if (bp->b_pages != bp->b_page_array)
-		kfree(bp->b_pages);
-	bp->b_pages = NULL;
-	bp->b_flags &= ~_XBF_PAGES;
+	if (bp->b_folios != bp->b_folio_array)
+		kfree(bp->b_folios);
+	bp->b_folios = NULL;
+	bp->b_flags &= ~_XBF_FOLIOS;
 }
 
 static void
@@ -313,8 +313,8 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_lru));
 
-	if (bp->b_flags & _XBF_PAGES)
-		xfs_buf_free_pages(bp);
+	if (bp->b_flags & _XBF_FOLIOS)
+		xfs_buf_free_folios(bp);
 	else if (bp->b_flags & _XBF_KMEM)
 		kfree(bp->b_addr);
 
@@ -345,15 +345,15 @@ xfs_buf_alloc_kmem(
 		return -ENOMEM;
 	}
 	bp->b_offset = offset_in_page(bp->b_addr);
-	bp->b_pages = bp->b_page_array;
-	bp->b_pages[0] = kmem_to_page(bp->b_addr);
-	bp->b_page_count = 1;
+	bp->b_folios = bp->b_folio_array;
+	bp->b_folios[0] = kmem_to_folio(bp->b_addr);
+	bp->b_folio_count = 1;
 	bp->b_flags |= _XBF_KMEM;
 	return 0;
 }
 
 static int
-xfs_buf_alloc_pages(
+xfs_buf_alloc_folios(
 	struct xfs_buf	*bp,
 	xfs_buf_flags_t	flags)
 {
@@ -364,16 +364,16 @@ xfs_buf_alloc_pages(
 		gfp_mask |= __GFP_NORETRY;
 
 	/* Make sure that we have a page list */
-	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
-	if (bp->b_page_count <= XB_PAGES) {
-		bp->b_pages = bp->b_page_array;
+	bp->b_folio_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
+	if (bp->b_folio_count <= XB_FOLIOS) {
+		bp->b_folios = bp->b_folio_array;
 	} else {
-		bp->b_pages = kzalloc(sizeof(struct page *) * bp->b_page_count,
+		bp->b_folios = kzalloc(sizeof(struct folio *) * bp->b_folio_count,
 					gfp_mask);
-		if (!bp->b_pages)
+		if (!bp->b_folios)
 			return -ENOMEM;
 	}
-	bp->b_flags |= _XBF_PAGES;
+	bp->b_flags |= _XBF_FOLIOS;
 
 	/* Assure zeroed buffer for non-read cases. */
 	if (!(flags & XBF_READ))
@@ -387,9 +387,9 @@ xfs_buf_alloc_pages(
 	for (;;) {
 		long	last = filled;
 
-		filled = alloc_pages_bulk_array(gfp_mask, bp->b_page_count,
-						bp->b_pages);
-		if (filled == bp->b_page_count) {
+		filled = alloc_pages_bulk_array(gfp_mask, bp->b_folio_count,
+						(struct page **)bp->b_folios);
+		if (filled == bp->b_folio_count) {
 			XFS_STATS_INC(bp->b_mount, xb_page_found);
 			break;
 		}
@@ -398,7 +398,7 @@ xfs_buf_alloc_pages(
 			continue;
 
 		if (flags & XBF_READ_AHEAD) {
-			xfs_buf_free_pages(bp);
+			xfs_buf_free_folios(bp);
 			return -ENOMEM;
 		}
 
@@ -412,14 +412,14 @@ xfs_buf_alloc_pages(
  *	Map buffer into kernel address-space if necessary.
  */
 STATIC int
-_xfs_buf_map_pages(
+_xfs_buf_map_folios(
 	struct xfs_buf		*bp,
 	xfs_buf_flags_t		flags)
 {
-	ASSERT(bp->b_flags & _XBF_PAGES);
-	if (bp->b_page_count == 1) {
+	ASSERT(bp->b_flags & _XBF_FOLIOS);
+	if (bp->b_folio_count == 1) {
 		/* A single page buffer is always mappable */
-		bp->b_addr = page_address(bp->b_pages[0]);
+		bp->b_addr = folio_address(bp->b_folios[0]);
 	} else if (flags & XBF_UNMAPPED) {
 		bp->b_addr = NULL;
 	} else {
@@ -443,8 +443,8 @@ _xfs_buf_map_pages(
 		 */
 		nofs_flag = memalloc_nofs_save();
 		do {
-			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
-						-1);
+			bp->b_addr = vm_map_ram((struct page **)bp->b_folios,
+					bp->b_folio_count, -1);
 			if (bp->b_addr)
 				break;
 			vm_unmap_aliases();
@@ -571,7 +571,7 @@ xfs_buf_find_lock(
 			return -ENOENT;
 		}
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
+		bp->b_flags &= _XBF_KMEM | _XBF_FOLIOS;
 		bp->b_ops = NULL;
 	}
 	return 0;
@@ -629,14 +629,15 @@ xfs_buf_find_insert(
 		goto out_drop_pag;
 
 	/*
-	 * For buffers that fit entirely within a single page, first attempt to
-	 * allocate the memory from the heap to minimise memory usage. If we
-	 * can't get heap memory for these small buffers, we fall back to using
-	 * the page allocator.
+	 * For buffers that fit entirely within a single page folio, first
+	 * attempt to allocate the memory from the heap to minimise memory
+	 * usage. If we can't get heap memory for these small buffers, we fall
+	 * back to using the page allocator.
 	 */
+
 	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
 	    xfs_buf_alloc_kmem(new_bp, flags) < 0) {
-		error = xfs_buf_alloc_pages(new_bp, flags);
+		error = xfs_buf_alloc_folios(new_bp, flags);
 		if (error)
 			goto out_free_buf;
 	}
@@ -728,11 +729,11 @@ xfs_buf_get_map(
 
 	/* We do not hold a perag reference anymore. */
 	if (!bp->b_addr) {
-		error = _xfs_buf_map_pages(bp, flags);
+		error = _xfs_buf_map_folios(bp, flags);
 		if (unlikely(error)) {
 			xfs_warn_ratelimited(btp->bt_mount,
-				"%s: failed to map %u pages", __func__,
-				bp->b_page_count);
+				"%s: failed to map %u folios", __func__,
+				bp->b_folio_count);
 			xfs_buf_relse(bp);
 			return error;
 		}
@@ -963,14 +964,14 @@ xfs_buf_get_uncached(
 	if (error)
 		return error;
 
-	error = xfs_buf_alloc_pages(bp, flags);
+	error = xfs_buf_alloc_folios(bp, flags);
 	if (error)
 		goto fail_free_buf;
 
-	error = _xfs_buf_map_pages(bp, 0);
+	error = _xfs_buf_map_folios(bp, 0);
 	if (unlikely(error)) {
 		xfs_warn(target->bt_mount,
-			"%s: failed to map pages", __func__);
+			"%s: failed to map folios", __func__);
 		goto fail_free_buf;
 	}
 
@@ -1465,7 +1466,7 @@ xfs_buf_ioapply_map(
 	blk_opf_t	op)
 {
 	int		page_index;
-	unsigned int	total_nr_pages = bp->b_page_count;
+	unsigned int	total_nr_pages = bp->b_folio_count;
 	int		nr_pages;
 	struct bio	*bio;
 	sector_t	sector =  bp->b_maps[map].bm_bn;
@@ -1503,7 +1504,7 @@ xfs_buf_ioapply_map(
 		if (nbytes > size)
 			nbytes = size;
 
-		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
+		rbytes = bio_add_folio(bio, bp->b_folios[page_index], nbytes,
 				      offset);
 		if (rbytes < nbytes)
 			break;
@@ -1716,13 +1717,13 @@ xfs_buf_offset(
 	struct xfs_buf		*bp,
 	size_t			offset)
 {
-	struct page		*page;
+	struct folio		*folio;
 
 	if (bp->b_addr)
 		return bp->b_addr + offset;
 
-	page = bp->b_pages[offset >> PAGE_SHIFT];
-	return page_address(page) + (offset & (PAGE_SIZE-1));
+	folio = bp->b_folios[offset >> PAGE_SHIFT];
+	return folio_address(folio) + (offset & (PAGE_SIZE-1));
 }
 
 void
@@ -1735,18 +1736,18 @@ xfs_buf_zero(
 
 	bend = boff + bsize;
 	while (boff < bend) {
-		struct page	*page;
+		struct folio	*folio;
 		int		page_index, page_offset, csize;
 
 		page_index = (boff + bp->b_offset) >> PAGE_SHIFT;
 		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
-		page = bp->b_pages[page_index];
+		folio = bp->b_folios[page_index];
 		csize = min_t(size_t, PAGE_SIZE - page_offset,
 				      BBTOB(bp->b_length) - boff);
 
 		ASSERT((csize + page_offset) <= PAGE_SIZE);
 
-		memset(page_address(page) + page_offset, 0, csize);
+		memset(folio_address(folio) + page_offset, 0, csize);
 
 		boff += csize;
 	}
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b470de08a46c..1e7298ff3fa5 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -29,7 +29,7 @@ struct xfs_buf;
 #define XBF_READ_AHEAD	 (1u << 2) /* asynchronous read-ahead */
 #define XBF_NO_IOACCT	 (1u << 3) /* bypass I/O accounting (non-LRU bufs) */
 #define XBF_ASYNC	 (1u << 4) /* initiator will not wait for completion */
-#define XBF_DONE	 (1u << 5) /* all pages in the buffer uptodate */
+#define XBF_DONE	 (1u << 5) /* all folios in the buffer uptodate */
 #define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
 #define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
 
@@ -39,7 +39,7 @@ struct xfs_buf;
 #define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
 
 /* flags used only internally */
-#define _XBF_PAGES	 (1u << 20)/* backed by refcounted pages */
+#define _XBF_FOLIOS	 (1u << 20)/* backed by refcounted folios */
 #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
 
@@ -68,7 +68,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_INODES,		"INODES" }, \
 	{ _XBF_DQUOTS,		"DQUOTS" }, \
 	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
-	{ _XBF_PAGES,		"PAGES" }, \
+	{ _XBF_FOLIOS,		"FOLIOS" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	/* The following interface flags should never be set */ \
@@ -116,7 +116,7 @@ typedef struct xfs_buftarg {
 	struct ratelimit_state	bt_ioerror_rl;
 } xfs_buftarg_t;
 
-#define XB_PAGES	2
+#define XB_FOLIOS	2
 
 struct xfs_buf_map {
 	xfs_daddr_t		bm_bn;	/* block number for I/O */
@@ -180,14 +180,14 @@ struct xfs_buf {
 	struct xfs_buf_log_item	*b_log_item;
 	struct list_head	b_li_list;	/* Log items list head */
 	struct xfs_trans	*b_transp;
-	struct page		**b_pages;	/* array of page pointers */
-	struct page		*b_page_array[XB_PAGES]; /* inline pages */
+	struct folio		**b_folios;	/* array of folio pointers */
+	struct folio		*b_folio_array[XB_FOLIOS]; /* inline folios */
 	struct xfs_buf_map	*b_maps;	/* compound buffer map */
 	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
 	int			b_map_count;
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
-	unsigned int		b_page_count;	/* size of page array */
+	unsigned int		b_folio_count;	/* size of folio array */
 	unsigned int		b_offset;	/* page offset of b_addr,
 						   only for _XBF_KMEM buffers */
 	int			b_error;	/* error code on I/O */
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 83a81cb52d8e..d1407cee48d9 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -69,7 +69,7 @@ xfs_buf_item_straddle(
 {
 	void			*first, *last;
 
-	if (bp->b_page_count == 1 || !(bp->b_flags & XBF_UNMAPPED))
+	if (bp->b_folio_count == 1 || !(bp->b_flags & XBF_UNMAPPED))
 		return false;
 
 	first = xfs_buf_offset(bp, offset + (first_bit << XFS_BLF_SHIFT));
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index caccb7f76690..804389b8e802 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -279,4 +279,12 @@ kmem_to_page(void *addr)
 	return virt_to_page(addr);
 }
 
+static inline struct folio *
+kmem_to_folio(void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		return page_folio(vmalloc_to_page(addr));
+	return virt_to_folio(addr);
+}
+
 #endif /* __XFS_LINUX__ */
-- 
2.43.0

