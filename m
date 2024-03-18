Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3FA5A798
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802045; cv=none; b=Js11wbEcex6wXjRPnKE0LapK349dJ9DQb0o1AHy26tG2thojP/mLDWu5E4JWvL9BdAUV6UQFz8OXzbpBwOs+KIvkKfG8OaITe1MZ7OVnYCSYPaZpdMRZwbvimVNWt/SFeZ6BIx2dabi4E9AI+NMDFaEiCKlxQDBLvUnk0EWOcxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802045; c=relaxed/simple;
	bh=SM+zOtg637VlMoOCHC1/uAF4AhAoJR9ut2b/g1I/1fM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkP1GiVyIMQSyyChicZqdvZG43IzEBLXfyQW9a4PGWANYWOTAVIYRdGHJOY0y+E7OwG2vt8L2LBmAhK6iF/rzCDo6jhLrx00WClU83uCjMi/hBAlr0uEr3bBL2k4LObmAbFGwC1SJV3tMmxlFkTpLRZztgd1bKD2RiLOIZ6YlH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=GHKgLxm9; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="GHKgLxm9"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so4051216a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802042; x=1711406842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izLpdGG9zFIbngyCVDnJZ8cYvhbFmPtZFud8nwT1kDc=;
        b=GHKgLxm9BF4XKirWDUSWj5ti7S53gBj0thBHt0d6nPYf5B7uUUzVfuiul6QOwmbkqW
         vIifJXz7Wvtk1P+SvquMRmqrpzJQumGN8diNZYyo6WrYpPysDAdzAMy2YGV7OFYZ3oLm
         Uq4A3kyRzPiH1g5bs8dqCgAhu+kbIAc4IMwKYXXsJtoLD1VoiJ79pFd/67YKSYYZ0Fsp
         78XUh8PV/eK2pTyz6WoifiMshD/91rWBXxrf+pPJY46ZVlat/MYY/8sGQBR7WvF/BmHg
         mw9Bkjj1SjDP/Q+YjWIoXo9LgdIqkiO52HtWr13cYhVC9h2VwBpVMP7lbEOu4wmuuOY1
         hymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802042; x=1711406842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=izLpdGG9zFIbngyCVDnJZ8cYvhbFmPtZFud8nwT1kDc=;
        b=aU50WabPNyk9ajdpCRFRksJXkBRndvIAvp20xtUo18tHCZH68S/kBEfrlmx+kSVnx/
         6Xzvia5swJF1LoPk0+U5k3DbIRjGFj2xwF5fAmMpHXrlG7EPs9gTGkd4GJ2cbk5FAxLL
         YqcBBJ3LBBWocRoLXKhMJs0NLCeI+vngy0TdgMw6niMY/h87CG8zJQfANZvgoLl5Bv+z
         4sEWzVHyJ+pFuLcxZlrYStdeCZyj3OZITRdtfGRXm6VOCy98jwUba/gEdzZd9Nm13CPt
         KdU33ilOqmuwfHhRKmgHIv3izT4XK7HUOY+1RJaRVAA2UUNXLpCs0M8yvUeAoFZV2mgE
         QsDg==
X-Gm-Message-State: AOJu0Yx64vvnwcaY3VCi7jGNemt8CP7LcwoXtn3Jm4X/Yefn7+eJryFc
	T0FoCs2EcnejJrRltBSIeflUftApA40rxuRlsUYyX6HvNbIgg17FKqSzFXutq0B6f5Ps9nFgUY3
	T
X-Google-Smtp-Source: AGHT+IG0a3C96H68UdT+ivqCggFzET1llKH5+1nPDy/Zq46A0hNhE2qG9+EvI7IUXpBDWB2Mya6i6g==
X-Received: by 2002:a17:90b:ecc:b0:29b:9a08:6007 with SMTP id gz12-20020a17090b0ecc00b0029b9a086007mr9319892pjb.46.1710802042162;
        Mon, 18 Mar 2024 15:47:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id sk4-20020a17090b2dc400b0029abb8b1265sm8318378pjb.49.2024.03.18.15.47.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:47:20 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLlG-003o0e-0K
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLlF-0000000E83B-2XNL
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: walk b_addr for buffer I/O
Date: Tue, 19 Mar 2024 09:45:58 +1100
Message-ID: <20240318224715.3367463-8-david@fromorbit.com>
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

From: Christoph Hellwig <hch@lst.de>

Instead of walking the folio array just walk the kernel virtual
address in ->b_addr.  This prepares for using vmalloc for buffers
and removing the b_folio array.

[dchinner: ported to folios-based buffers.]

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 110 +++++++++++++----------------------------------
 fs/xfs/xfs_buf.h |   2 -
 2 files changed, 29 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a77e2d8c8107..303945554415 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -358,7 +358,6 @@ xfs_buf_alloc_kmem(
 	}
 	bp->b_folios = bp->b_folio_array;
 	bp->b_folios[0] = kmem_to_folio(bp->b_addr);
-	bp->b_offset = offset_in_folio(bp->b_folios[0], bp->b_addr);
 	bp->b_folio_count = 1;
 	bp->b_flags |= _XBF_KMEM;
 	return 0;
@@ -1549,87 +1548,44 @@ xfs_buf_bio_end_io(
 static void
 xfs_buf_ioapply_map(
 	struct xfs_buf	*bp,
-	int		map,
-	int		*buf_offset,
-	int		*count,
+	unsigned int	map,
+	unsigned int	*buf_offset,
 	blk_opf_t	op)
 {
-	int		folio_index;
-	unsigned int	total_nr_folios = bp->b_folio_count;
-	int		nr_folios;
 	struct bio	*bio;
-	sector_t	sector =  bp->b_maps[map].bm_bn;
 	int		size;
-	int		offset;
 
-	/*
-	 * If the start offset if larger than a single page, we need to be
-	 * careful. We might have a high order folio, in which case the indexing
-	 * is from the start of the buffer. However, if we have more than one
-	 * folio single page folio in the buffer, we need to skip the folios in
-	 * the buffer before the start offset.
-	 */
-	folio_index = 0;
-	offset = *buf_offset;
-	if (bp->b_folio_count > 1) {
-		while (offset >= PAGE_SIZE) {
-			folio_index++;
-			offset -= PAGE_SIZE;
-		}
+	/* Limit the IO size to the length of the current vector. */
+	size = min_t(unsigned int, BBTOB(bp->b_maps[map].bm_len),
+			BBTOB(bp->b_length) - *buf_offset);
+
+	if (WARN_ON_ONCE(bp->b_folio_count > BIO_MAX_VECS)) {
+		xfs_buf_ioerror(bp, -EIO);
+		return;
 	}
 
-	/*
-	 * Limit the IO size to the length of the current vector, and update the
-	 * remaining IO count for the next time around.
-	 */
-	size = min_t(int, BBTOB(bp->b_maps[map].bm_len), *count);
-	*count -= size;
-	*buf_offset += size;
-
-next_chunk:
 	atomic_inc(&bp->b_io_remaining);
-	nr_folios = bio_max_segs(total_nr_folios);
 
-	bio = bio_alloc(bp->b_target->bt_bdev, nr_folios, op, GFP_NOIO);
-	bio->bi_iter.bi_sector = sector;
+	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_folio_count, op, GFP_NOIO);
+	bio->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
 
-	for (; size && nr_folios; nr_folios--, folio_index++) {
-		struct folio	*folio = bp->b_folios[folio_index];
-		int		nbytes = folio_size(folio) - offset;
-
-		if (nbytes > size)
-			nbytes = size;
-
-		if (!bio_add_folio(bio, folio, nbytes,
-				offset_in_folio(folio, offset)))
-			break;
-
-		offset = 0;
-		sector += BTOBB(nbytes);
-		size -= nbytes;
-		total_nr_folios--;
-	}
-
-	if (likely(bio->bi_iter.bi_size)) {
-		if (xfs_buf_is_vmapped(bp)) {
-			flush_kernel_vmap_range(bp->b_addr,
-						xfs_buf_vmap_len(bp));
-		}
-		submit_bio(bio);
-		if (size)
-			goto next_chunk;
-	} else {
-		/*
-		 * This is guaranteed not to be the last io reference count
-		 * because the caller (xfs_buf_submit) holds a count itself.
-		 */
-		atomic_dec(&bp->b_io_remaining);
-		xfs_buf_ioerror(bp, -EIO);
-		bio_put(bio);
-	}
-
+	do {
+		void		*data = bp->b_addr + *buf_offset;
+		struct folio	*folio = kmem_to_folio(data);
+		unsigned int	off = offset_in_folio(folio, data);
+		unsigned int	len = min_t(unsigned int, size,
+						folio_size(folio) - off);
+
+		bio_add_folio_nofail(bio, folio, len, off);
+		size -= len;
+		*buf_offset += len;
+	} while (size);
+
+	if (xfs_buf_is_vmapped(bp))
+		flush_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
+	submit_bio(bio);
 }
 
 STATIC void
@@ -1638,8 +1594,7 @@ _xfs_buf_ioapply(
 {
 	struct blk_plug	plug;
 	blk_opf_t	op;
-	int		offset;
-	int		size;
+	unsigned int	offset = 0;
 	int		i;
 
 	/*
@@ -1701,16 +1656,9 @@ _xfs_buf_ioapply(
 	 * _xfs_buf_ioapply_vec() will modify them appropriately for each
 	 * subsequent call.
 	 */
-	offset = bp->b_offset;
-	size = BBTOB(bp->b_length);
 	blk_start_plug(&plug);
-	for (i = 0; i < bp->b_map_count; i++) {
-		xfs_buf_ioapply_map(bp, i, &offset, &size, op);
-		if (bp->b_error)
-			break;
-		if (size <= 0)
-			break;	/* all done */
-	}
+	for (i = 0; i < bp->b_map_count; i++)
+		xfs_buf_ioapply_map(bp, i, &offset, op);
 	blk_finish_plug(&plug);
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index aef7015cf9f3..4d515407713b 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -198,8 +198,6 @@ struct xfs_buf {
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	unsigned int		b_folio_count;	/* size of folio array */
-	unsigned int		b_offset;	/* page offset of b_addr,
-						   only for _XBF_KMEM buffers */
 	int			b_error;	/* error code on I/O */
 
 	/*
-- 
2.43.0

