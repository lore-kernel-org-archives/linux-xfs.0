Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E295A4E2
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802043; cv=none; b=THp/C2WvzdyEBugLqpEtuU9WrPRfnr6RpMxWB8qiJDwia2brdJbdass3GxEekZxAD94hrEjeCha2yT6O4ox+kDzce3C+RgpjOkmxJg4/4MWvtq3z8zSMKetOMV/xwj2raJk5RDqeq3kmcwKX/d+Lb+9HC7AOC60tZehhdCdaS0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802043; c=relaxed/simple;
	bh=A2Nrfwua7+cNBWQVaQR6jtsuuUnf9MhvWwmtQAKZ3Rg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOdBpwV2TLUkCi8oM0tBNzPHu5TNQqvQll20UyrbP7MiRUSUS5OZxo4s8K12Tni0IpFPCH5cDR1ZL94Kfj8oJOMVBZ+8yGfFRsDJfZVe3pPXn0gb7r+YtoG4sbzFb/f5GYrqG1UqEjWLKWcYcBCpwLYaL03Gc7AnaB0LXoHqs7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=U0e/9Cqk; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="U0e/9Cqk"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dd10a37d68so39845345ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802041; x=1711406841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=APcnTkHQ03YqcCdyFoISln9yFj9fCyhuIawEfJ4QG8I=;
        b=U0e/9CqkhOc61UVpKy6rKL5P0BxiH8zCoXEv3tnK8SjdJDFsLtFV0T0qg+8MK7Xunw
         b5v6TQy3VpMDrNmq8aSVkSSW2qSwv9lKdp/NE4kuGXfoPw+/OXL1VjjY36s8FnQXc1mC
         7OTq9lrKH7wTAnos/JKj7SRlSxTnzYCH567k+VHcWiYCkoKGeF4oenlXd0epgMADmUTC
         1CVSNW3XjXfZFz8Jzz56/0ePeij/zktEwGqoNJkxVf/coTt7Lfwp+B6XrOJ21hzBPi3F
         U/UZi5AFjD7SIFppfuk1D+m3MtWsAZ+W/SjSzECQGrI/2J1AGrrsJVwaaIHWVF1b++6B
         15Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802041; x=1711406841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=APcnTkHQ03YqcCdyFoISln9yFj9fCyhuIawEfJ4QG8I=;
        b=jNnR3SFc0lVLcy4zjdvkS4qzmc5ndtgjahyTycIiy4VVHlRLZplqPZaqjV358abPcy
         NxfUWxFrSZrnGZSrZEDzTI0UpBChG+x1mMVrhi/UdVlND/Wz+r0yqtr9KQPalDQ6JgGE
         OVPs3qOtWdc35XP6+qhSFiv6WUfTZsc43MFmDW6bCN80nQTHvpo0vK2aak77diqb5H8S
         HJUxu+PEsRGnMT2S9M506BDUKFx3RVrYwKGl415FTR8ZEMbQ5/atgj6WXzFgXAUwbenp
         G+12OQJ/ER0t0qHvQvw4JvOa3q3DyToUWuh1ow3/ouL9zgLQJ4wjeIcw2Cr0pwOhtcMG
         QEtg==
X-Gm-Message-State: AOJu0YxPy/HZzaEnsYXi4YDYRF574rrf6CUlZs5mJQ6uuXfdHB9czgMK
	ZtwGZhFsEgwlkZ3HlR2qfjsphhPSV+f97fKfD1KiTYuIcXH24ixdbcLBvPahDWzXQPmPmQMvlns
	2
X-Google-Smtp-Source: AGHT+IF+BQE8i5gnOt5Xenwt8rlAVpes0YMv+dj6l0BWI2kHlZyaxxfKLTQKjUXQaplghcYzQ8EwUQ==
X-Received: by 2002:a17:902:ce81:b0:1dc:7bc:cb49 with SMTP id f1-20020a170902ce8100b001dc07bccb49mr16598713plg.60.1710802040656;
        Mon, 18 Mar 2024 15:47:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902a50600b001e0449adfaesm68613plq.191.2024.03.18.15.47.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:47:19 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLlF-003o0L-30
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLlF-0000000E82q-1rJp
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Date: Tue, 19 Mar 2024 09:45:54 +1100
Message-ID: <20240318224715.3367463-4-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240318224715.3367463-1-david@fromorbit.com>
References: <20240318224715.3367463-1-david@fromorbit.com>
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
 fs/xfs/xfs_buf.c | 141 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 110 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 832226385154..7d9303497763 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -80,6 +80,10 @@ xfs_buf_is_vmapped(
 	return bp->b_addr && bp->b_folio_count > 1;
 }
 
+/*
+ * See comment above xfs_buf_alloc_folios() about the constraints placed on
+ * allocating vmapped buffers.
+ */
 static inline int
 xfs_buf_vmap_len(
 	struct xfs_buf	*bp)
@@ -352,14 +356,63 @@ xfs_buf_alloc_kmem(
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
+	int		order = get_order(length);
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
@@ -371,7 +424,15 @@ xfs_buf_alloc_folios(
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
@@ -383,9 +444,6 @@ xfs_buf_alloc_folios(
 	}
 	bp->b_flags |= _XBF_FOLIOS;
 
-	/* Assure zeroed buffer for non-read cases. */
-	if (!(flags & XBF_READ))
-		gfp_mask |= __GFP_ZERO;
 
 	/*
 	 * Bulk filling of pages can take multiple calls. Not filling the entire
@@ -426,7 +484,7 @@ _xfs_buf_map_folios(
 {
 	ASSERT(bp->b_flags & _XBF_FOLIOS);
 	if (bp->b_folio_count == 1) {
-		/* A single page buffer is always mappable */
+		/* A single folio buffer is always mappable */
 		bp->b_addr = folio_address(bp->b_folios[0]);
 	} else if (flags & XBF_UNMAPPED) {
 		bp->b_addr = NULL;
@@ -1525,20 +1583,28 @@ xfs_buf_ioapply_map(
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
@@ -1551,28 +1617,28 @@ xfs_buf_ioapply_map(
 
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
@@ -1788,6 +1854,13 @@ xfs_buf_offset(
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
@@ -1803,18 +1876,24 @@ xfs_buf_zero(
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

