Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13875025E
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 07:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710833831; cv=none; b=m9XqU/fZLaGSDQv8RLLk+xVb/Mb0Wbe/Sl0g94zLs/b+iN8MiHkrfLcacgIYIkHyNHCUtS8fgrr8ZTDdC5PN4SSAu2C33l6/ZQhjzm6aeCwc/S7Bb/vf9kmS9wUP5SwfJLJGXZ7pFw87hICf8pmRqOLFuaCkasghMJqhdLug3uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710833831; c=relaxed/simple;
	bh=IJBuGFz7948K1Cb+QLUmhSm9/QvGSwymK6TEpr+y1M4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S86Hh82TQUVamJ7HYAWzhzIpLu409PkuyiaEJgUF+1xq+v+wAVDRmZPzthvtqobGzpyt8J55hLFA7+baKKu4EtzNLHFYgAJvUMvTbzhMeBBH6haqLJniDDeD6607i+CX1u04RxxNAMGC2SL1Qu30Q3MwKDKOtwU9xDQdi/en7Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=21tLSq1Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="21tLSq1Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pNyqtHFuPYM5zikJpqlAn16a0rw7DXWHPDlu78VNWQI=; b=21tLSq1ZM5VjVwiLGhSM0YlYEN
	KE6yMVBzJzlpM/7ehNMYEx+gGMFm/jCeYF/kb/Amx9rRCnOjAHhCuSGW7ZlaevE/8vC0kvPsyzLfu
	eciMi8EVZgLRIIyR+IAWeUBj/+LQIsEmTTkiW3rWuimccmZF9eGE7TEsVHm/vzmRNSwEVODY2bq2Z
	nTFfd4WsVtVp9fSb19eknKsHYwjzLr+yt5j3/bBpZ5wnF+XyTp6NDy+eelFbHgzejwC8muSkI4wLd
	KtCc8AqklnpF/ELPszcELOXYKyjodp6/oCcCnqVzsl5ueqEGdFONUeWoYuSc3A1Jf1Rmfh/baYB3O
	M6YVoRpg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmU21-0000000BjOM-20nM;
	Tue, 19 Mar 2024 07:37:09 +0000
Date: Tue, 19 Mar 2024 00:37:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: rename bp->b_folio_count
Message-ID: <ZflApWnBkHDmo4HJ@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-10-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318224715.3367463-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 19, 2024 at 09:46:00AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The count is used purely to allocate the correct number of bvecs for
> submitting IO. Rename it to b_bvec_count.

Well, I think we should just kill it as it simplies is the rounded
up length in PAGE_SIZE units.  The patch below passes a quick xfstests
run and is on top of this series:

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2a6796c48454f7..8ecf88b5504c18 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -67,27 +67,17 @@ static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
 }
 
 /*
- * Return true if the buffer is vmapped.
- *
- * b_addr is always set, so we have to look at bp->b_bvec_count to determine if
- * the buffer was vmalloc()d or not.
+ * See comment above xfs_buf_alloc_folios() about the constraints placed on
+ * allocating vmapped buffers.
  */
-static inline int
-xfs_buf_is_vmapped(
-	struct xfs_buf	*bp)
+static inline unsigned int xfs_buf_vmap_len(struct xfs_buf *bp)
 {
-	return bp->b_bvec_count > 1;
+	return roundup(BBTOB(bp->b_length), PAGE_SIZE);
 }
 
-/*
- * See comment above xfs_buf_alloc_folios() about the constraints placed on
- * allocating vmapped buffers.
- */
-static inline int
-xfs_buf_vmap_len(
-	struct xfs_buf	*bp)
+static inline unsigned int xfs_buf_nr_pages(struct xfs_buf *bp)
 {
-	return (bp->b_bvec_count * PAGE_SIZE);
+	return DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
 }
 
 /*
@@ -304,13 +294,15 @@ xfs_buf_free(
 		goto free;
 	}
 
-	if (!(bp->b_flags & _XBF_KMEM))
-		mm_account_reclaimed_pages(bp->b_bvec_count);
-
-	if (bp->b_flags & _XBF_FOLIOS)
-		__folio_put(kmem_to_folio(bp->b_addr));
-	else
+	if (bp->b_flags & _XBF_FOLIOS) {
+		/* XXX: should this pass xfs_buf_nr_pages()? */
+		mm_account_reclaimed_pages(1);
+		folio_put(kmem_to_folio(bp->b_addr));
+	} else {
+		if (!(bp->b_flags & _XBF_KMEM))
+			mm_account_reclaimed_pages(xfs_buf_nr_pages(bp));
 		kvfree(bp->b_addr);
+	}
 
 	bp->b_flags &= _XBF_KMEM | _XBF_FOLIOS;
 
@@ -341,7 +333,6 @@ xfs_buf_alloc_kmem(
 		bp->b_addr = NULL;
 		return -ENOMEM;
 	}
-	bp->b_bvec_count = 1;
 	bp->b_flags |= _XBF_KMEM;
 	return 0;
 }
@@ -369,7 +360,6 @@ xfs_buf_alloc_folio(
 		return false;
 
 	bp->b_addr = folio_address(folio);
-	bp->b_bvec_count = 1;
 	bp->b_flags |= _XBF_FOLIOS;
 	return true;
 }
@@ -441,7 +431,6 @@ xfs_buf_alloc_folios(
 			count);
 		return -ENOMEM;
 	}
-	bp->b_bvec_count = count;
 
 	return 0;
 }
@@ -1470,7 +1459,9 @@ xfs_buf_bio_end_io(
 		cmpxchg(&bp->b_io_error, 0, error);
 	}
 
-	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
+	if (!bp->b_error &&
+	    (bp->b_flags & XBF_READ) &&
+	    is_vmalloc_addr(bp->b_addr))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
 
 	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
@@ -1485,6 +1476,7 @@ xfs_buf_ioapply_map(
 	unsigned int	*buf_offset,
 	blk_opf_t	op)
 {
+	unsigned int	nr_vecs = 1;
 	struct bio	*bio;
 	int		size;
 
@@ -1494,7 +1486,9 @@ xfs_buf_ioapply_map(
 
 	atomic_inc(&bp->b_io_remaining);
 
-	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_bvec_count, op, GFP_NOIO);
+	if (is_vmalloc_addr(bp->b_addr))
+		nr_vecs = xfs_buf_nr_pages(bp);
+	bio = bio_alloc(bp->b_target->bt_bdev, nr_vecs, op, GFP_NOIO);
 	bio->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
@@ -1511,7 +1505,7 @@ xfs_buf_ioapply_map(
 		*buf_offset += len;
 	} while (size);
 
-	if (xfs_buf_is_vmapped(bp))
+	if (is_vmalloc_addr(bp->b_addr))
 		flush_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
 	submit_bio(bio);
 }
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 32688525890bec..ad92d11f4ae173 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -195,7 +195,6 @@ struct xfs_buf {
 	int			b_map_count;
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
-	unsigned int		b_bvec_count;	/* bvecs needed for IO */
 	int			b_error;	/* error code on I/O */
 
 	/*
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index 30d53ddd6e6980..f082b1a64fc950 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -169,7 +169,6 @@ xmbuf_map_folio(
 	unlock_page(page);
 
 	bp->b_addr = page_address(page);
-	bp->b_bvec_count = 1;
 	return 0;
 }
 
@@ -182,7 +181,6 @@ xmbuf_unmap_folio(
 
 	folio_put(kmem_to_folio(bp->b_addr));
 	bp->b_addr = NULL;
-	bp->b_bvec_count = 0;
 }
 
 /* Is this a valid daddr within the buftarg? */
