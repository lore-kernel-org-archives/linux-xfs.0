Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631F55A78C
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802044; cv=none; b=eSsqmS/pM4SNhe54aEi6yD+QIABe1cNMo9sKwrGv157u0dzimTzkbRNUfHTkTVX3S7rF5j235h7Gzb3IT8IaHhkK7yXFQC4aAOQpdeJIGsVoXDidhRLB+cH6Nz+P1ZsN9sz+ExikESwmI5n2IW1JzdKWTTagRYWIWoRE4N+ZSEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802044; c=relaxed/simple;
	bh=QYKcDyqSFTxsT+u37xzUVAocz3DoBgpC1nCIlTbFaKE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezy/QdIEyZLNpoEB/XwuhP5QZvCnV9pkhf7y/a+QoAmDZc6JXDG3bYL8yRfdooJDDXJgd9APpy7ip/4NbuvR6D6+398MpeeY18yxSAHooK34rSxDh1o/HPqi7XfDJ1nFyG9q0mYrJaJ27RRlYJ+knlnY9pMWL4SrYNbzYBx58F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EB1HG7fF; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EB1HG7fF"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e00d1e13acso9687185ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802042; x=1711406842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dgsz5I8PwGGXzkECh6oIIfjGCMAjq28gu6g/QePKAyU=;
        b=EB1HG7fFSdDuMXgFoE1HG2jQDyIgB8Xh20cMH3S8Jv7GJEWoZtJgZH0cTUdLR9we42
         GBk0EAv8aDVGsF/XGFB46nQGIUaaR721KjUgCXgezDeDM7QALGAyXRsRGqkN7GZfxauS
         WjS//WwekNoVNmMpIfwW26+u6/ZcWcpknbs7f3ty9jcSYrUWHnRhto2meoPxQNxgKKuk
         oRt/hwUxeCGHe1SfuvVeHn2oTbwpmaLpXoFAcFHe2z7ujzXKUzfV8Kqm0s1waa8K1Pa9
         4NCrj1nVH9PAjuKF4bhqcYY9GTJpiMN8K/rMAcWQ2pjq3BiK/D3ZD9fnncB5pJtCUxii
         CZ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802042; x=1711406842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dgsz5I8PwGGXzkECh6oIIfjGCMAjq28gu6g/QePKAyU=;
        b=YnM0P5OtET7Bp0w2PfBQqfIpBaihC5ULO6htt5wccLMGclKR35M1uA5VwGAU6UbDjI
         FtapbSdEBGVnzU6/pJfAUjQwu2cp8ZJteW67YabJkJXAo8UAE/4aj14E8RIzoEwBaQ0n
         GfMDUFufZFYMlzF4ACeD+fmY58HOZuzfw6Jk+fhP6gXXX6zsv4JkJY+f3FdxreYXlho1
         E+xoZ1A521XfW0Ds3EX2iYqIOm/IlWlv3t68CJ6VT/s6S1UH60imkkF4ZEhPYQwhw4Gb
         tAVk3URtDBrEKD4SIj+pEqvFai4cjndHane7XtBfRmR+t/LBO3Y849Pfdfshh5X37DiT
         ekfg==
X-Gm-Message-State: AOJu0YwR18f5thvG8ReevRMqtMue4UddayTGqNi/EAcNNsSQn1OjXwsZ
	nMvMN8sD3ukzKzX4D81WPAJDq8yBIuHvvJ/XWnlDXbYR5tDCltUrjUSsgv16Nue2Hzz6rQyuiCf
	p
X-Google-Smtp-Source: AGHT+IHfjm0RFUtHMWUUsskez4jFH4t24T/Rru8ZOZ1cBo3zCzfPtOPMc6DzyEJRZ8BQXyrhHZEhZg==
X-Received: by 2002:a17:902:9692:b0:1e0:1a5e:32bc with SMTP id n18-20020a170902969200b001e01a5e32bcmr1080370plp.24.1710802041483;
        Mon, 18 Mar 2024 15:47:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id j18-20020a170902c3d200b001ddce57bdbfsm9839596plj.308.2024.03.18.15.47.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:47:20 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLlG-003o0n-0f
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLlF-0000000E83L-2smO
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 9/9] xfs: rename bp->b_folio_count
Date: Tue, 19 Mar 2024 09:46:00 +1100
Message-ID: <20240318224715.3367463-10-david@fromorbit.com>
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

The count is used purely to allocate the correct number of bvecs for
submitting IO. Rename it to b_bvec_count.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c     | 38 +++++++++++++++++++++-----------------
 fs/xfs/xfs_buf.h     |  2 +-
 fs/xfs/xfs_buf_mem.c |  4 ++--
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6d6bad80722e..2a6796c48454 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -69,15 +69,14 @@ static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
 /*
  * Return true if the buffer is vmapped.
  *
- * b_addr is null if the buffer is not mapped, but the code is clever enough to
- * know it doesn't have to map a single folio, so the check has to be both for
- * b_addr and bp->b_folio_count > 1.
+ * b_addr is always set, so we have to look at bp->b_bvec_count to determine if
+ * the buffer was vmalloc()d or not.
  */
 static inline int
 xfs_buf_is_vmapped(
 	struct xfs_buf	*bp)
 {
-	return bp->b_addr && bp->b_folio_count > 1;
+	return bp->b_bvec_count > 1;
 }
 
 /*
@@ -88,7 +87,7 @@ static inline int
 xfs_buf_vmap_len(
 	struct xfs_buf	*bp)
 {
-	return (bp->b_folio_count * PAGE_SIZE);
+	return (bp->b_bvec_count * PAGE_SIZE);
 }
 
 /*
@@ -306,7 +305,7 @@ xfs_buf_free(
 	}
 
 	if (!(bp->b_flags & _XBF_KMEM))
-		mm_account_reclaimed_pages(bp->b_folio_count);
+		mm_account_reclaimed_pages(bp->b_bvec_count);
 
 	if (bp->b_flags & _XBF_FOLIOS)
 		__folio_put(kmem_to_folio(bp->b_addr));
@@ -342,7 +341,7 @@ xfs_buf_alloc_kmem(
 		bp->b_addr = NULL;
 		return -ENOMEM;
 	}
-	bp->b_folio_count = 1;
+	bp->b_bvec_count = 1;
 	bp->b_flags |= _XBF_KMEM;
 	return 0;
 }
@@ -370,7 +369,7 @@ xfs_buf_alloc_folio(
 		return false;
 
 	bp->b_addr = folio_address(folio);
-	bp->b_folio_count = 1;
+	bp->b_bvec_count = 1;
 	bp->b_flags |= _XBF_FOLIOS;
 	return true;
 }
@@ -398,6 +397,7 @@ xfs_buf_alloc_folios(
 {
 	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
 	unsigned	nofs_flag;
+	unsigned int	count;
 
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
@@ -407,16 +407,24 @@ xfs_buf_alloc_folios(
 		gfp_mask |= __GFP_ZERO;
 
 	/* Fall back to allocating an array of single page folios. */
-	bp->b_folio_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
+	count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
 
 	/* Optimistically attempt a single high order folio allocation. */
 	if (xfs_buf_alloc_folio(bp, gfp_mask))
 		return 0;
 
 	/* We are done if an order-0 allocation has already failed. */
-	if (bp->b_folio_count == 1)
+	if (count == 1)
 		return -ENOMEM;
 
+	/*
+	 * Largest buffer we allocate should fit entirely in a single bio,
+	 * so warn and fail if somebody asks for a buffer larger than can
+	 * be supported.
+	 */
+	if (WARN_ON_ONCE(count > BIO_MAX_VECS))
+		return -EIO;
+
 	/*
 	 * XXX(dgc): I think dquot reclaim is the only place we can get
 	 * to this function from memory reclaim context now. If we fix
@@ -430,9 +438,10 @@ xfs_buf_alloc_folios(
 	if (!bp->b_addr) {
 		xfs_warn_ratelimited(bp->b_mount,
 			"%s: failed to allocate %u folios", __func__,
-			bp->b_folio_count);
+			count);
 		return -ENOMEM;
 	}
+	bp->b_bvec_count = count;
 
 	return 0;
 }
@@ -1483,14 +1492,9 @@ xfs_buf_ioapply_map(
 	size = min_t(unsigned int, BBTOB(bp->b_maps[map].bm_len),
 			BBTOB(bp->b_length) - *buf_offset);
 
-	if (WARN_ON_ONCE(bp->b_folio_count > BIO_MAX_VECS)) {
-		xfs_buf_ioerror(bp, -EIO);
-		return;
-	}
-
 	atomic_inc(&bp->b_io_remaining);
 
-	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_folio_count, op, GFP_NOIO);
+	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_bvec_count, op, GFP_NOIO);
 	bio->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 68c24947ca1a..32688525890b 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -195,7 +195,7 @@ struct xfs_buf {
 	int			b_map_count;
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
-	unsigned int		b_folio_count;	/* size of folio array */
+	unsigned int		b_bvec_count;	/* bvecs needed for IO */
 	int			b_error;	/* error code on I/O */
 
 	/*
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index 336e7c8effb7..30d53ddd6e69 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -169,7 +169,7 @@ xmbuf_map_folio(
 	unlock_page(page);
 
 	bp->b_addr = page_address(page);
-	bp->b_folio_count = 1;
+	bp->b_bvec_count = 1;
 	return 0;
 }
 
@@ -182,7 +182,7 @@ xmbuf_unmap_folio(
 
 	folio_put(kmem_to_folio(bp->b_addr));
 	bp->b_addr = NULL;
-	bp->b_folio_count = 0;
+	bp->b_bvec_count = 0;
 }
 
 /* Is this a valid daddr within the buftarg? */
-- 
2.43.0

