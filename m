Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039333218C
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 22:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616544; cv=none; b=O7Ge4LKN0O6cCya18GyT0JjkNjyDrD8SSqXVeN5yTLtP6B4o2ZTVjS78FdWHlzlTmcTwuJywM0zUWKVY7gT2/cYQmlil1o3DM96uo8m1NQ7QpRwtwXDlMueq9BHkz2ru2rUELU0MmN/JlgmJXFmsDjyqGSR4o2NEQbkDe8hhJ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616544; c=relaxed/simple;
	bh=fglI7NZLaK53wxq60litmrlh03vEYEzbBQ9XqKhiAjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8lgsWbnEbAbBFOgSEgEI3GuvxT50HGVlGUkPmvea4H+2PDYv+4sKlcojVuo+zBjhHkpPKpfCB1RNE2OT9/ONHLldIkcLPEngoVdIswZV72A6AetlkdYr87HQQ7Aq68+Qzo+KaPzERuMOJofkSmxKWtehLTzaDOJTnzZFyaDAgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ZknSSSDX; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ZknSSSDX"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6d9f94b9186so215628b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 14:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705616542; x=1706221342; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fO+mBN2GDAFsDbZRgLX551gORnQ6e1TTPyY8dgTZaZk=;
        b=ZknSSSDXvW2yX1N+C1Sl/vubROfZFsNhoVnOuwsnKH2f3+k9EzMokfaXCr6nnx1Wgp
         kg8307rOkgXM4J+d5Sydw79xVd4KMXIG5eJtLdm26BTE02ExXeo7PUucdho/bYDtMi6+
         UL+dfTKAfDmXJJO/G65RGT3eKXeFefpMdrr6iVhzcK6xBDDf7PF8qyr3VZBhsYldyLU5
         SoVjZ1NpbviFRFP4NRUFpAXS22+2kX6Jz8lEwvhxqYmCyGm/8jU3ptbU8QXriRJKw9x5
         l4AClv9lPLefyC1HdAQ0oh70dTxWo4kAoInZoSdT2zADxquZxN5BcAFTYeIfMpoWpWxi
         84Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705616542; x=1706221342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fO+mBN2GDAFsDbZRgLX551gORnQ6e1TTPyY8dgTZaZk=;
        b=MS6XK6Z3qTJdg2TK1Zt8IrNruLSjowQ/dICuNlHVLj2spf1C7kXPTIR9bgzI2OgbVa
         93eBlRk1fYjbdREhSNqM/36krrtjD1PBoQXHZr/a5JeB64O4ygDF8k7fu4GyE6exN1zL
         V2Yfyt8eKPueyOS9FD4Klm0lwV8nAWj6mqDGvXar512uAntvOV5WThmWq7YiYpOmMcTx
         zeIHjUmI530BQtpZQ1vbnUeGquBAgqDHGUxDULhivID0kouyzxG0zoLRCBESiR6UJA57
         jkaH0+OdshEejCA8WEXJ4AnvCkL0z1U0aK9zGV9mMYgp2rvinr7h1Gr/G1YmD8anHzAI
         4HyQ==
X-Gm-Message-State: AOJu0YzoZtsChnOUrvDcnMyYe3qPOcnWQfEoP/XkC/+3HtDuR9G8ZhNu
	IoGT2mCw422KMUpaQIJVagsdcdSjAiQSo2K4Sdk39Wgnq0h1vnpNvl1Zvv7j1CxeqmR0LPpBT+F
	o
X-Google-Smtp-Source: AGHT+IFxnt3+P3qfd/Or7vfgHgHJT56Si91E5SB2dSZzMTOU7Zs7rV/RsmUryc8DgCT+nt/t5oxBsQ==
X-Received: by 2002:a05:6a20:ae1c:b0:19b:4580:e9c6 with SMTP id dp28-20020a056a20ae1c00b0019b4580e9c6mr1220797pzb.65.1705616542306;
        Thu, 18 Jan 2024 14:22:22 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id s13-20020a056a00194d00b006db13a02921sm3764329pfk.183.2024.01.18.14.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jan 2024 14:22:22 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rQamB-00CCGW-1A;
	Fri, 19 Jan 2024 09:22:18 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rQamA-0000000HMlw-3ZYk;
	Fri, 19 Jan 2024 09:22:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] xfs: convert buffer cache to use high order folios
Date: Fri, 19 Jan 2024 09:19:41 +1100
Message-ID: <20240118222216.4131379-4-david@fromorbit.com>
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

Now that we have the buffer cache using the folio API, we can extend
the use of folios to allocate high order folios for multi-page
buffers rather than an array of single pages that are then vmapped
into a contiguous range.

This creates two types of buffers: single folio buffers that can
have arbitrary order, and multi-folio buffers made up of many single
page folios that get vmapped. The latter is essentially the existing
code, so there are no logic changes to handle this case.

There are a few places where we iterate the folios on a buffer.
These need to be converted to handle the high order folio case.
Luckily, this only occurs when bp->b_folio_count == 1, and the code
for handling this case is just a simple application of the folio API
to the operations that need to be performed.

The code that allocates buffers will optimistically attempt a high
order folio allocation as a fast path. If this high order allocation
fails, then we fall back to the existing multi-folio allocation
code. This now forms the slow allocation path, and hopefully will be
largely unused in normal conditions.

This should improve performance of large buffer operations (e.g.
large directory block sizes) as we should now mostly avoid the
expense of vmapping large buffers (and the vmap lock contention that
can occur) as well as avoid the runtime pressure that frequently
accessing kernel vmapped pages put on the TLBs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 150 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 119 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15907e92d0d3..df363f17ea1a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -74,6 +74,10 @@ xfs_buf_is_vmapped(
 	return bp->b_addr && bp->b_folio_count > 1;
 }
 
+/*
+ * See comment above xfs_buf_alloc_folios() about the constraints placed on
+ * allocating vmapped buffers.
+ */
 static inline int
 xfs_buf_vmap_len(
 	struct xfs_buf	*bp)
@@ -344,14 +348,72 @@ xfs_buf_alloc_kmem(
 		bp->b_addr = NULL;
 		return -ENOMEM;
 	}
-	bp->b_offset = offset_in_page(bp->b_addr);
 	bp->b_folios = bp->b_folio_array;
 	bp->b_folios[0] = kmem_to_folio(bp->b_addr);
+	bp->b_offset = offset_in_folio(bp->b_folios[0], bp->b_addr);
 	bp->b_folio_count = 1;
 	bp->b_flags |= _XBF_KMEM;
 	return 0;
 }
 
+/*
+ * Allocating a high order folio makes the assumption that buffers are a
+ * power-of-2 size so that ilog2() returns the exact order needed to fit
+ * the contents of the buffer. Buffer lengths are mostly a power of two,
+ * so this is not an unreasonable approach to take by default.
+ *
+ * The exception here are user xattr data buffers, which can be arbitrarily
+ * sized up to 64kB plus structure metadata. In that case, round up the order.
+ */
+static bool
+xfs_buf_alloc_folio(
+	struct xfs_buf	*bp,
+	gfp_t		gfp_mask)
+{
+	int		length = BBTOB(bp->b_length);
+	int		order;
+
+	order = ilog2(length);
+	if ((1 << order) < length)
+		order = ilog2(length - 1) + 1;
+
+	if (order <= PAGE_SHIFT)
+		order = 0;
+	else
+		order -= PAGE_SHIFT;
+
+	bp->b_folio_array[0] = folio_alloc(gfp_mask, order);
+	if (!bp->b_folio_array[0])
+		return false;
+
+	bp->b_folios = bp->b_folio_array;
+	bp->b_folio_count = 1;
+	bp->b_flags |= _XBF_FOLIOS;
+	return true;
+}
+
+/*
+ * When we allocate folios for a buffer, we end up with one of two types of
+ * buffer.
+ *
+ * The first type is a single folio buffer - this may be a high order
+ * folio or just a single page sized folio, but either way they get treated the
+ * same way by the rest of the code - the buffer memory spans a single
+ * contiguous memory region that we don't have to map and unmap to access the
+ * data directly.
+ *
+ * The second type of buffer is the multi-folio buffer. These are *always* made
+ * up of single page folios so that they can be fed to vmap_ram() to return a
+ * contiguous memory region we can access the data through, or mark it as
+ * XBF_UNMAPPED and access the data directly through individual folio_address()
+ * calls.
+ *
+ * We don't use high order folios for this second type of buffer (yet) because
+ * having variable size folios makes offset-to-folio indexing and iteration of
+ * the data range more complex than if they are fixed size. This case should now
+ * be the slow path, though, so unless we regularly fail to allocate high order
+ * folios, there should be little need to optimise this path.
+ */
 static int
 xfs_buf_alloc_folios(
 	struct xfs_buf	*bp,
@@ -363,7 +425,15 @@ xfs_buf_alloc_folios(
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
 
-	/* Make sure that we have a page list */
+	/* Assure zeroed buffer for non-read cases. */
+	if (!(flags & XBF_READ))
+		gfp_mask |= __GFP_ZERO;
+
+	/* Optimistically attempt a single high order folio allocation. */
+	if (xfs_buf_alloc_folio(bp, gfp_mask))
+		return 0;
+
+	/* Fall back to allocating an array of single page folios. */
 	bp->b_folio_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
 	if (bp->b_folio_count <= XB_FOLIOS) {
 		bp->b_folios = bp->b_folio_array;
@@ -375,9 +445,6 @@ xfs_buf_alloc_folios(
 	}
 	bp->b_flags |= _XBF_FOLIOS;
 
-	/* Assure zeroed buffer for non-read cases. */
-	if (!(flags & XBF_READ))
-		gfp_mask |= __GFP_ZERO;
 
 	/*
 	 * Bulk filling of pages can take multiple calls. Not filling the entire
@@ -418,7 +485,7 @@ _xfs_buf_map_folios(
 {
 	ASSERT(bp->b_flags & _XBF_FOLIOS);
 	if (bp->b_folio_count == 1) {
-		/* A single page buffer is always mappable */
+		/* A single folio buffer is always mappable */
 		bp->b_addr = folio_address(bp->b_folios[0]);
 	} else if (flags & XBF_UNMAPPED) {
 		bp->b_addr = NULL;
@@ -1465,20 +1532,28 @@ xfs_buf_ioapply_map(
 	int		*count,
 	blk_opf_t	op)
 {
-	int		page_index;
-	unsigned int	total_nr_pages = bp->b_folio_count;
-	int		nr_pages;
+	int		folio_index;
+	unsigned int	total_nr_folios = bp->b_folio_count;
+	int		nr_folios;
 	struct bio	*bio;
 	sector_t	sector =  bp->b_maps[map].bm_bn;
 	int		size;
 	int		offset;
 
-	/* skip the pages in the buffer before the start offset */
-	page_index = 0;
+	/*
+	 * If the start offset if larger than a single page, we need to be
+	 * careful. We might have a high order folio, in which case the indexing
+	 * is from the start of the buffer. However, if we have more than one
+	 * folio single page folio in the buffer, we need to skip the folios in
+	 * the buffer before the start offset.
+	 */
+	folio_index = 0;
 	offset = *buf_offset;
-	while (offset >= PAGE_SIZE) {
-		page_index++;
-		offset -= PAGE_SIZE;
+	if (bp->b_folio_count > 1) {
+		while (offset >= PAGE_SIZE) {
+			folio_index++;
+			offset -= PAGE_SIZE;
+		}
 	}
 
 	/*
@@ -1491,28 +1566,28 @@ xfs_buf_ioapply_map(
 
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
-	nr_pages = bio_max_segs(total_nr_pages);
+	nr_folios = bio_max_segs(total_nr_folios);
 
-	bio = bio_alloc(bp->b_target->bt_bdev, nr_pages, op, GFP_NOIO);
+	bio = bio_alloc(bp->b_target->bt_bdev, nr_folios, op, GFP_NOIO);
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
 
-	for (; size && nr_pages; nr_pages--, page_index++) {
-		int	rbytes, nbytes = PAGE_SIZE - offset;
+	for (; size && nr_folios; nr_folios--, folio_index++) {
+		struct folio	*folio = bp->b_folios[folio_index];
+		int		nbytes = folio_size(folio) - offset;
 
 		if (nbytes > size)
 			nbytes = size;
 
-		rbytes = bio_add_folio(bio, bp->b_folios[page_index], nbytes,
-				      offset);
-		if (rbytes < nbytes)
+		if (!bio_add_folio(bio, folio, nbytes,
+				offset_in_folio(folio, offset)))
 			break;
 
 		offset = 0;
 		sector += BTOBB(nbytes);
 		size -= nbytes;
-		total_nr_pages--;
+		total_nr_folios--;
 	}
 
 	if (likely(bio->bi_iter.bi_size)) {
@@ -1722,6 +1797,13 @@ xfs_buf_offset(
 	if (bp->b_addr)
 		return bp->b_addr + offset;
 
+	/* Single folio buffers may use large folios. */
+	if (bp->b_folio_count == 1) {
+		folio = bp->b_folios[0];
+		return folio_address(folio) + offset_in_folio(folio, offset);
+	}
+
+	/* Multi-folio buffers always use PAGE_SIZE folios */
 	folio = bp->b_folios[offset >> PAGE_SHIFT];
 	return folio_address(folio) + (offset & (PAGE_SIZE-1));
 }
@@ -1737,18 +1819,24 @@ xfs_buf_zero(
 	bend = boff + bsize;
 	while (boff < bend) {
 		struct folio	*folio;
-		int		page_index, page_offset, csize;
+		int		folio_index, folio_offset, csize;
 
-		page_index = (boff + bp->b_offset) >> PAGE_SHIFT;
-		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
-		folio = bp->b_folios[page_index];
-		csize = min_t(size_t, PAGE_SIZE - page_offset,
+		/* Single folio buffers may use large folios. */
+		if (bp->b_folio_count == 1) {
+			folio = bp->b_folios[0];
+			folio_offset = offset_in_folio(folio,
+						bp->b_offset + boff);
+		} else {
+			folio_index = (boff + bp->b_offset) >> PAGE_SHIFT;
+			folio_offset = (boff + bp->b_offset) & ~PAGE_MASK;
+			folio = bp->b_folios[folio_index];
+		}
+
+		csize = min_t(size_t, folio_size(folio) - folio_offset,
 				      BBTOB(bp->b_length) - boff);
+		ASSERT((csize + folio_offset) <= folio_size(folio));
 
-		ASSERT((csize + page_offset) <= PAGE_SIZE);
-
-		memset(folio_address(folio) + page_offset, 0, csize);
-
+		memset(folio_address(folio) + folio_offset, 0, csize);
 		boff += csize;
 	}
 }
-- 
2.43.0

