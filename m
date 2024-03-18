Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3A45B67F
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802046; cv=none; b=AwDGIxN9AG+Mz3Gu+cmna7M2jdYHMysP5QVRdJtb5IGjPqqCCEtqmSV8bFHqSVVgeb4r12jIYNiRqP9OZ4HP481Qq1SwJGtuGXgKY7CxE4fez0u+oAQW+leikJgVJu/+xn2xfU6LBF4NejkYOCmREvgnbyLTcy5ymEbl/lqljIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802046; c=relaxed/simple;
	bh=gYvZ4VTyvR3Cet8F4IcLQ2wPy0s4YFPJ/WGozXb/sJA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jslh7tHiZ2QADH6CzyK3ouPcC/fKUHkCQ/3iBN49RveOTvFukXcLSjHTYAu0VTl8K3HS+vqTC9vA2IZOce1EOSZHjhHGXo2XTAGh3Y5eFrNKN9MEAMua++61ymtmclGUGXyZCjidOUP/DDi+xfFNFh2aNYhW9ptG1Uok/3Ticjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=DfClY/Ok; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="DfClY/Ok"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3c3880cd471so1033804b6e.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802043; x=1711406843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wsXcgC1rC1spo4+ayjNMuIUIXQ6miuqb4Yy0Qx/qbwA=;
        b=DfClY/OkgY8RiofupmJSXQqmvRegdqCRLI5NmJfj0tkuo4ANbEPFZZ0dmAUkeu26hY
         BroGlAsDNpP8cqkOb8bAtAJ73IyZIxgvv4OQbW8TitYY+QGeAH7e12w9Z5IdQokbTq+8
         XUow8Vob6W6ZC3W6jsNXiHIzpvdgfauIv3KN3IqHMKmWcb5HqwjvqbH6ah6tM1dPgVPV
         33p2hfX3gwkGWpu1mlItBU+UpSXpHcB/KtdcBluCk3cXFn4235fElbpwfVOQFuRDowNV
         bXqtArZ/VtzJu0q3nZaoxg20yYJ3Wo5gbDwvCRXRe2MO1xb8M05uuiPHxKNGf89Nur7F
         guHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802043; x=1711406843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wsXcgC1rC1spo4+ayjNMuIUIXQ6miuqb4Yy0Qx/qbwA=;
        b=CziGhfnf8w0iNlTfpasnsIoloFf/YTiGLHjdcDg5Na6TeNd0C+XYZSdkBPajZHlxKZ
         /0DUm5OQmXOsh+qPws0JZznxSUfC+L8fGCv3mNmT2D2CSbY6o4haH/2Ty+dFxE/XMjTY
         z16EhMEvn4esHpakeCJTfGqNW2sVzmhrV++ACgdovVbux3RPK7f+SpgAPwkqJQQvRhsn
         P6pwqDuTqIJMIa9KV/+sQbuZU6xR/6uL7Bb5wgP1tPbeMkJEDkxQOAyKqIDSIDGSDpW/
         XUI3EdR4gLATwKgPQO4OpCoTNXDBdAiOA2RIOu8Fz6xM9Oid+s54MQc8IA6jWtYkA+2c
         L5oQ==
X-Gm-Message-State: AOJu0Yx1QqLIxBD20SHmu3BE2zjQ7yW7EP9IsRl+KocuDLSFKsvc500q
	4w0xZ73XVHecA7AMgWlkGEIvdLV2+5alSDoVWlu+lMGHA12dPivVn+PfJM1LobsDmMwY1S0Dazh
	X
X-Google-Smtp-Source: AGHT+IECX3q/k9o3eFzUAkkw6viY5VZwsP9uQRKMLvH+htNtxkJwjcRjyfoOvu4wVTgiXwtB4cM4zw==
X-Received: by 2002:a05:6808:17a6:b0:3c3:923c:4262 with SMTP id bg38-20020a05680817a600b003c3923c4262mr1682655oib.17.1710802043298;
        Mon, 18 Mar 2024 15:47:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id b24-20020aa78718000000b006e68954b9c7sm8441406pfo.44.2024.03.18.15.47.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:47:20 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLlG-003o0j-0R
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLlF-0000000E83G-2i0m
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: use vmalloc for multi-folio buffers
Date: Tue, 19 Mar 2024 09:45:59 +1100
Message-ID: <20240318224715.3367463-9-david@fromorbit.com>
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

Instead of allocating the folios manually using the bulk page
allocator and then using vm_map_page just use vmalloc to allocate
the entire buffer - vmalloc will use the bulk allocator internally
if it fits.

With this the b_folios array can go away as well as nothing uses it.

[dchinner: port to folio based buffers.]

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c     | 164 ++++++++++++-------------------------------
 fs/xfs/xfs_buf.h     |   2 -
 fs/xfs/xfs_buf_mem.c |   9 +--
 3 files changed, 45 insertions(+), 130 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 303945554415..6d6bad80722e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -282,29 +282,6 @@ _xfs_buf_alloc(
 	return 0;
 }
 
-static void
-xfs_buf_free_folios(
-	struct xfs_buf	*bp)
-{
-	uint		i;
-
-	ASSERT(bp->b_flags & _XBF_FOLIOS);
-
-	if (xfs_buf_is_vmapped(bp))
-		vm_unmap_ram(bp->b_addr, bp->b_folio_count);
-
-	for (i = 0; i < bp->b_folio_count; i++) {
-		if (bp->b_folios[i])
-			__folio_put(bp->b_folios[i]);
-	}
-	mm_account_reclaimed_pages(bp->b_folio_count);
-
-	if (bp->b_folios != bp->b_folio_array)
-		kfree(bp->b_folios);
-	bp->b_folios = NULL;
-	bp->b_flags &= ~_XBF_FOLIOS;
-}
-
 static void
 xfs_buf_free_callback(
 	struct callback_head	*cb)
@@ -323,13 +300,22 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_lru));
 
-	if (xfs_buftarg_is_mem(bp->b_target))
+	if (xfs_buftarg_is_mem(bp->b_target)) {
 		xmbuf_unmap_folio(bp);
-	else if (bp->b_flags & _XBF_FOLIOS)
-		xfs_buf_free_folios(bp);
-	else if (bp->b_flags & _XBF_KMEM)
-		kfree(bp->b_addr);
+		goto free;
+	}
 
+	if (!(bp->b_flags & _XBF_KMEM))
+		mm_account_reclaimed_pages(bp->b_folio_count);
+
+	if (bp->b_flags & _XBF_FOLIOS)
+		__folio_put(kmem_to_folio(bp->b_addr));
+	else
+		kvfree(bp->b_addr);
+
+	bp->b_flags &= _XBF_KMEM | _XBF_FOLIOS;
+
+free:
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
 }
 
@@ -356,8 +342,6 @@ xfs_buf_alloc_kmem(
 		bp->b_addr = NULL;
 		return -ENOMEM;
 	}
-	bp->b_folios = bp->b_folio_array;
-	bp->b_folios[0] = kmem_to_folio(bp->b_addr);
 	bp->b_folio_count = 1;
 	bp->b_flags |= _XBF_KMEM;
 	return 0;
@@ -377,14 +361,15 @@ xfs_buf_alloc_folio(
 	struct xfs_buf	*bp,
 	gfp_t		gfp_mask)
 {
+	struct folio	*folio;
 	int		length = BBTOB(bp->b_length);
 	int		order = get_order(length);
 
-	bp->b_folio_array[0] = folio_alloc(gfp_mask, order);
-	if (!bp->b_folio_array[0])
+	folio = folio_alloc(gfp_mask, order);
+	if (!folio)
 		return false;
 
-	bp->b_folios = bp->b_folio_array;
+	bp->b_addr = folio_address(folio);
 	bp->b_folio_count = 1;
 	bp->b_flags |= _XBF_FOLIOS;
 	return true;
@@ -400,15 +385,11 @@ xfs_buf_alloc_folio(
  * contiguous memory region that we don't have to map and unmap to access the
  * data directly.
  *
- * The second type of buffer is the multi-folio buffer. These are *always* made
- * up of single page folios so that they can be fed to vmap_ram() to return a
- * contiguous memory region we can access the data through.
- *
- * We don't use high order folios for this second type of buffer (yet) because
- * having variable size folios makes offset-to-folio indexing and iteration of
- * the data range more complex than if they are fixed size. This case should now
- * be the slow path, though, so unless we regularly fail to allocate high order
- * folios, there should be little need to optimise this path.
+ * The second type of buffer is the vmalloc()d buffer. This provides the buffer
+ * with the required contiguous memory region but backed by discontiguous
+ * physical pages. vmalloc() typically doesn't fail, but it can and so we may
+ * need to wrap the allocation in a loop to prevent low memory failures and
+ * shutdowns.
  */
 static int
 xfs_buf_alloc_folios(
@@ -416,7 +397,7 @@ xfs_buf_alloc_folios(
 	xfs_buf_flags_t	flags)
 {
 	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
-	long		filled = 0;
+	unsigned	nofs_flag;
 
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
@@ -425,89 +406,32 @@ xfs_buf_alloc_folios(
 	if (!(flags & XBF_READ))
 		gfp_mask |= __GFP_ZERO;
 
-	/* Optimistically attempt a single high order folio allocation. */
-	if (xfs_buf_alloc_folio(bp, gfp_mask))
-		return 0;
-
 	/* Fall back to allocating an array of single page folios. */
 	bp->b_folio_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
-	if (bp->b_folio_count <= XB_FOLIOS) {
-		bp->b_folios = bp->b_folio_array;
-	} else {
-		bp->b_folios = kzalloc(sizeof(struct folio *) * bp->b_folio_count,
-					gfp_mask);
-		if (!bp->b_folios)
-			return -ENOMEM;
-	}
-	bp->b_flags |= _XBF_FOLIOS;
 
+	/* Optimistically attempt a single high order folio allocation. */
+	if (xfs_buf_alloc_folio(bp, gfp_mask))
+		return 0;
+
+	/* We are done if an order-0 allocation has already failed. */
+	if (bp->b_folio_count == 1)
+		return -ENOMEM;
 
 	/*
-	 * Bulk filling of pages can take multiple calls. Not filling the entire
-	 * array is not an allocation failure, so don't back off if we get at
-	 * least one extra page.
+	 * XXX(dgc): I think dquot reclaim is the only place we can get
+	 * to this function from memory reclaim context now. If we fix
+	 * that like we've fixed inode reclaim to avoid writeback from
+	 * reclaim, this nofs wrapping can go away.
 	 */
-	for (;;) {
-		long	last = filled;
-
-		filled = alloc_pages_bulk_array(gfp_mask, bp->b_folio_count,
-						(struct page **)bp->b_folios);
-		if (filled == bp->b_folio_count) {
-			XFS_STATS_INC(bp->b_mount, xb_page_found);
-			break;
-		}
-
-		if (filled != last)
-			continue;
-
-		if (flags & XBF_READ_AHEAD) {
-			xfs_buf_free_folios(bp);
-			return -ENOMEM;
-		}
-
-		XFS_STATS_INC(bp->b_mount, xb_page_retries);
-		memalloc_retry_wait(gfp_mask);
-	}
-
-	if (bp->b_folio_count == 1) {
-		/* A single folio buffer is always mappable */
-		bp->b_addr = folio_address(bp->b_folios[0]);
-	} else {
-		int retried = 0;
-		unsigned nofs_flag;
-
-		/*
-		 * vm_map_ram() will allocate auxiliary structures (e.g.
-		 * pagetables) with GFP_KERNEL, yet we often under a scoped nofs
-		 * context here. Mixing GFP_KERNEL with GFP_NOFS allocations
-		 * from the same call site that can be run from both above and
-		 * below memory reclaim causes lockdep false positives. Hence we
-		 * always need to force this allocation to nofs context because
-		 * we can't pass __GFP_NOLOCKDEP down to auxillary structures to
-		 * prevent false positive lockdep reports.
-		 *
-		 * XXX(dgc): I think dquot reclaim is the only place we can get
-		 * to this function from memory reclaim context now. If we fix
-		 * that like we've fixed inode reclaim to avoid writeback from
-		 * reclaim, this nofs wrapping can go away.
-		 */
-		nofs_flag = memalloc_nofs_save();
-		do {
-			bp->b_addr = vm_map_ram((struct page **)bp->b_folios,
-					bp->b_folio_count, -1);
-			if (bp->b_addr)
-				break;
-			vm_unmap_aliases();
-		} while (retried++ <= 1);
-		memalloc_nofs_restore(nofs_flag);
-
-		if (!bp->b_addr) {
-			xfs_warn_ratelimited(bp->b_mount,
-				"%s: failed to map %u folios", __func__,
-				bp->b_folio_count);
-			xfs_buf_free_folios(bp);
-			return -ENOMEM;
-		}
+	nofs_flag = memalloc_nofs_save();
+	bp->b_addr = __vmalloc(BBTOB(bp->b_length), gfp_mask);
+	memalloc_nofs_restore(nofs_flag);
+
+	if (!bp->b_addr) {
+		xfs_warn_ratelimited(bp->b_mount,
+			"%s: failed to allocate %u folios", __func__,
+			bp->b_folio_count);
+		return -ENOMEM;
 	}
 
 	return 0;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 4d515407713b..68c24947ca1a 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -190,8 +190,6 @@ struct xfs_buf {
 	struct xfs_buf_log_item	*b_log_item;
 	struct list_head	b_li_list;	/* Log items list head */
 	struct xfs_trans	*b_transp;
-	struct folio		**b_folios;	/* array of folio pointers */
-	struct folio		*b_folio_array[XB_FOLIOS]; /* inline folios */
 	struct xfs_buf_map	*b_maps;	/* compound buffer map */
 	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
 	int			b_map_count;
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index 26734c64c10e..336e7c8effb7 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -169,8 +169,6 @@ xmbuf_map_folio(
 	unlock_page(page);
 
 	bp->b_addr = page_address(page);
-	bp->b_folios = bp->b_folio_array;
-	bp->b_folios[0] = folio;
 	bp->b_folio_count = 1;
 	return 0;
 }
@@ -180,15 +178,10 @@ void
 xmbuf_unmap_folio(
 	struct xfs_buf		*bp)
 {
-	struct folio		*folio = bp->b_folios[0];
-
 	ASSERT(xfs_buftarg_is_mem(bp->b_target));
 
-	folio_put(folio);
-
+	folio_put(kmem_to_folio(bp->b_addr));
 	bp->b_addr = NULL;
-	bp->b_folios[0] = NULL;
-	bp->b_folios = NULL;
 	bp->b_folio_count = 0;
 }
 
-- 
2.43.0

