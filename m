Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D3521CC55
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585169; cv=none; b=urUVWqSXrfMsLleiJqF8dnJ5ZpjehWJ2f9CrC7XrC3twjGlcdW6I8vW6QbyQ3QDc2v6+xgNkc85OUSyyc6/DGDD5p6Fud3p5oBUAJqbwm8KiYo59YfkysWmu+f6L/X+LNrGVQ3q8CEzUXLonRBO/+5ArwltSQOeht2iTLQYEL2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585169; c=relaxed/simple;
	bh=uDEWTpg8mnnXSaZ8lPWrNBaeeMxNu+OBzp2ApgjOJI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZssALh2TBzUkHlH7kvEkZC7gi01HEyZRXRcG6KzBVNjoFDKh2a+vJn78uQTqNmdwlzP34jWS1NeEN9dAuYRGX12nmoJIcQRpO6pV4KajpuIW4N9y+SVTRkkd2KvnUeeBZUtJO66PEAd74sQqO1WuQrHIKnoFZWyTPljFBNYouc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XFUFPAIh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XFUFPAIh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=v06ItEd1Mw+PxR1dqggrrq/dp6p5p0vbfp95BtmKUx8=; b=XFUFPAIhbqY6eahjEnv8/fuaHz
	c/c5xfFZU/LF7EoHsMtnhYIq6nxgEvCpuyMiTrbjbX7TeE+R/b4j3lVBbPPSX+FbJF3glZ17dbfAf
	S+6pliAefyVqxbcODQh2CxeXUX28XUzj6M022/W/OBVm2xj7x/0iJzO9WXkAiBRkjhIr6Bti4LZJn
	GQN85HJjRb9KTGsW9OnSmReUyE/g30n1zlRWERxEUZuGSk2G9zx3aR6efCuS1MeKNdfhMY1Oaf6d7
	Aoqv6P6FIdFzz6cpqd2oyLMrVyRUuLOXou4LYvi2fZ6utFZ6kzcHl0crBqqbZcwfp9nWLDlwZcnTr
	KvPkvYXg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnJiJ-00000004PMf-1tka;
	Wed, 26 Feb 2025 15:52:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/12] xfs: cleanup mapping tmpfs folios into the buffer cache
Date: Wed, 26 Feb 2025 07:51:39 -0800
Message-ID: <20250226155245.513494-12-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226155245.513494-1-hch@lst.de>
References: <20250226155245.513494-1-hch@lst.de>
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
---
 fs/xfs/xfs_buf.c     |  6 ++----
 fs/xfs/xfs_buf_mem.c | 34 ++++++++++------------------------
 fs/xfs/xfs_buf_mem.h |  6 ++----
 3 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index fb127589c6b4..0393dd302cf6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -264,9 +264,7 @@ xfs_buf_free(
 	if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
 		mm_account_reclaimed_pages(DIV_ROUND_UP(size, PAGE_SHIFT));
 
-	if (xfs_buftarg_is_mem(bp->b_target))
-		xmbuf_unmap_page(bp);
-	else if (is_vmalloc_addr(bp->b_addr))
+	if (is_vmalloc_addr(bp->b_addr))
 		vfree(bp->b_addr);
 	else if (bp->b_flags & _XBF_KMEM)
 		kfree(bp->b_addr);
@@ -334,7 +332,7 @@ xfs_buf_alloc_backing_mem(
 	struct folio	*folio;
 
 	if (xfs_buftarg_is_mem(bp->b_target))
-		return xmbuf_map_page(bp);
+		return xmbuf_map_backing_mem(bp);
 
 	/* Assure zeroed buffer for non-read cases. */
 	if (!(flags & XBF_READ))
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index e2f6c5524771..c4872a4d7a71 100644
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

