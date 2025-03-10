Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A551A9B3B
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 13:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741612808; cv=none; b=mWW7ODS8NhadqJAZlqZldpHWoA+YXv/I8khL3Z4aVrfvwNFuiyhGA0e3if9u4BhultwVXoBKxPMjBSdGoHSRxh0dqdeS2FndfeCp9O7xFMWMHpTeHHCUwtMoiDBgnUeQk/1Ljxe6CG0jZ68e/oDHuVMfxpHtzDMUsLiaEH+9t4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741612808; c=relaxed/simple;
	bh=jRC1kOOg2ULq67vBN3oZau+CH5cG2t+H5Lfs3celpbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rtqfk1Zbo9fPiG0ghnoC2sL1R25W2R6sY/H+llpf8G7hhqLGrzXtjnMZyZHUcw4N8KDp/67Y+1KZHYBqUdFSWp7M2fUFcIvEOnhPC2gwYsXr4xE3hmfHKYDzyLrUMk0nxAjp6osh8+89u6pWRF3Pp7LEtIGmPJteBPoM1UmfvsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AGfndI4c; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AGfndI4c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0ZHL/QeBALwnFXJjUso9XsbKMvAnAvkLNEzFlN9n0Rs=; b=AGfndI4cPY7fry0NNG+oPr+AAk
	ldzEOM+POxUZXIClI22cpZxAgA3uGIVaKwt+9sjIIt7yL2wxpSHt/m23H4lSMZZzW8TY+IPz2cjD6
	JLdGDlHdRIEsLXN7i+y947g9x2iIn3UQBOFU8ZUvRWC35FpMxzZ1aq2w0dBaaJvoTPll6PfZEri+r
	IbPWKEnKyJu+iLDml4gzKU7ZyRRshlksJUhEwUdIJmFVgq402o7sHAzLHs94Ut/Ri9DPkPGcLEJYe
	Tz2UgOdWWmMjZjVChBZerBOzLjYwADxnT+RX6FnJP3OaVe2iOPe/HTkmU8Lpa6eeOeT+wK54+qYhr
	qCjLl10g==;
Received: from [212.185.66.17] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1trd38-00000002lni-284L;
	Mon, 10 Mar 2025 13:20:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/12] xfs: cleanup mapping tmpfs folios into the buffer cache
Date: Mon, 10 Mar 2025 14:19:14 +0100
Message-ID: <20250310131917.552600-12-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250310131917.552600-1-hch@lst.de>
References: <20250310131917.552600-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Directly assign b_addr based on the tmpfs folios without a detour
through pages, reuse the folio_put path used for non-tmpfs buffers
and replace all references to pages in comments with folios.

Partially based on a patch from Dave Chinner <dchinner@redhat.com>.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c     |  6 ++----
 fs/xfs/xfs_buf_mem.c | 34 ++++++++++------------------------
 fs/xfs/xfs_buf_mem.h |  6 ++----
 3 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4aaa588330e4..a7430fcd8301 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -206,9 +206,7 @@ xfs_buf_free(
 	if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
 		mm_account_reclaimed_pages(howmany(size, PAGE_SHIFT));
 
-	if (xfs_buftarg_is_mem(bp->b_target))
-		xmbuf_unmap_page(bp);
-	else if (is_vmalloc_addr(bp->b_addr))
+	if (is_vmalloc_addr(bp->b_addr))
 		vfree(bp->b_addr);
 	else if (bp->b_flags & _XBF_KMEM)
 		kfree(bp->b_addr);
@@ -275,7 +273,7 @@ xfs_buf_alloc_backing_mem(
 	struct folio	*folio;
 
 	if (xfs_buftarg_is_mem(bp->b_target))
-		return xmbuf_map_page(bp);
+		return xmbuf_map_backing_mem(bp);
 
 	/* Assure zeroed buffer for non-read cases. */
 	if (!(flags & XBF_READ))
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index b207754d2ee0..b4ffd80b7cb6 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -74,7 +74,7 @@ xmbuf_alloc(
 
 	/*
 	 * We don't want to bother with kmapping data during repair, so don't
-	 * allow highmem pages to back this mapping.
+	 * allow highmem folios to back this mapping.
 	 */
 	mapping_set_gfp_mask(inode->i_mapping, GFP_KERNEL);
 
@@ -127,14 +127,13 @@ xmbuf_free(
 	kfree(btp);
 }
 
-/* Directly map a shmem page into the buffer cache. */
+/* Directly map a shmem folio into the buffer cache. */
 int
-xmbuf_map_page(
+xmbuf_map_backing_mem(
 	struct xfs_buf		*bp)
 {
 	struct inode		*inode = file_inode(bp->b_target->bt_file);
 	struct folio		*folio = NULL;
-	struct page		*page;
 	loff_t                  pos = BBTOB(xfs_buf_daddr(bp));
 	int			error;
 
@@ -159,30 +158,17 @@ xmbuf_map_page(
 		return -EIO;
 	}
 
-	page = folio_file_page(folio, pos >> PAGE_SHIFT);
-
 	/*
-	 * Mark the page dirty so that it won't be reclaimed once we drop the
-	 * (potentially last) reference in xmbuf_unmap_page.
+	 * Mark the folio dirty so that it won't be reclaimed once we drop the
+	 * (potentially last) reference in xfs_buf_free.
 	 */
-	set_page_dirty(page);
-	unlock_page(page);
+	folio_set_dirty(folio);
+	folio_unlock(folio);
 
-	bp->b_addr = page_address(page);
+	bp->b_addr = folio_address(folio);
 	return 0;
 }
 
-/* Unmap a shmem page that was mapped into the buffer cache. */
-void
-xmbuf_unmap_page(
-	struct xfs_buf		*bp)
-{
-	ASSERT(xfs_buftarg_is_mem(bp->b_target));
-
-	put_page(virt_to_page(bp->b_addr));
-	bp->b_addr = NULL;
-}
-
 /* Is this a valid daddr within the buftarg? */
 bool
 xmbuf_verify_daddr(
@@ -196,7 +182,7 @@ xmbuf_verify_daddr(
 	return daddr < (inode->i_sb->s_maxbytes >> BBSHIFT);
 }
 
-/* Discard the page backing this buffer. */
+/* Discard the folio backing this buffer. */
 static void
 xmbuf_stale(
 	struct xfs_buf		*bp)
@@ -211,7 +197,7 @@ xmbuf_stale(
 }
 
 /*
- * Finalize a buffer -- discard the backing page if it's stale, or run the
+ * Finalize a buffer -- discard the backing folio if it's stale, or run the
  * write verifier to detect problems.
  */
 int
diff --git a/fs/xfs/xfs_buf_mem.h b/fs/xfs/xfs_buf_mem.h
index eed4a7b63232..67d525cc1513 100644
--- a/fs/xfs/xfs_buf_mem.h
+++ b/fs/xfs/xfs_buf_mem.h
@@ -19,16 +19,14 @@ int xmbuf_alloc(struct xfs_mount *mp, const char *descr,
 		struct xfs_buftarg **btpp);
 void xmbuf_free(struct xfs_buftarg *btp);
 
-int xmbuf_map_page(struct xfs_buf *bp);
-void xmbuf_unmap_page(struct xfs_buf *bp);
 bool xmbuf_verify_daddr(struct xfs_buftarg *btp, xfs_daddr_t daddr);
 void xmbuf_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
 int xmbuf_finalize(struct xfs_buf *bp);
 #else
 # define xfs_buftarg_is_mem(...)	(false)
-# define xmbuf_map_page(...)		(-ENOMEM)
-# define xmbuf_unmap_page(...)		((void)0)
 # define xmbuf_verify_daddr(...)	(false)
 #endif /* CONFIG_XFS_MEMORY_BUFS */
 
+int xmbuf_map_backing_mem(struct xfs_buf *bp);
+
 #endif /* __XFS_BUF_MEM_H__ */
-- 
2.45.2

