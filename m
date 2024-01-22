Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4BB3E48B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 19:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705952369; cv=none; b=rmZNRyGc3/cpu48NeWVjT5afYXZqRXA8ufHT+Ncd+8GwCCdnRMKxlwG3oAJwrD2EBFSFhxCV2y4WnpOiVY9q2z5y6b3ELa+T582M4tNJQ8WvM3rWMT6pG4NBSb+YzRVdM0k/SQYKDt5VlRIUVvyILRMzLut5IU1OZcHf8njW6cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705952369; c=relaxed/simple;
	bh=8eg7GVkvPDPSXp73xvWozZprS1VZIu5lOicQZsSmzTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MqqehWHQfqT3ILLceW+2UhOFhveIaUC4R0iUmRKcADSAduB1rGila6gXLBN8XZktkBB22iTu8LLfcI95Ro46PrWcBtbiiUtqXGggqz4Z+tPdlH4ev8I7BVScv3C/T9oLjDjbbYWGcwInDrCka1X+7JtrWUF+XFrFj6jQ0phQrhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sigG9rC7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sigG9rC7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BWnyOND06H7uD/JhBZSyS3iIUsmEvQx4tAMGfBsAeo4=; b=sigG9rC7HBAWytb2mHV9VhzhRL
	GuLM+Jxmgw/DDVal6nDOcOxk6TfmPymD91FWQ5Ym5mU9fr7jMeKsdWDdTLYwA/CJvsofgS65CcTpR
	CMLfjVNet6Z+iAC0JaBQoCzFWU2R5wU3NUfefS6TkmlEgT4k/4lAzbXSW1QnzL0e9JQPY5r2eCvs+
	M+Ljh/BbyJf64b2CoINHw+nmQHurszyW5POf9XpjHQq7LkndrM1ZhisYDhM/Kx3bclQE9s/3KBAYN
	2/7hO+O4ygXtAGfwm2ACOmgXocM/T4QrW2iJbOyxpHE6rFxahWgKlhRt7G41BszKj6+/AAsBcmb08
	e4OJSD2A==;
Received: from [2001:4bb8:198:a22c:146a:86ef:5806:b115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rS08k-00DkTt-20;
	Mon, 22 Jan 2024 19:39:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: kill XBF_UNMAPPED
Date: Mon, 22 Jan 2024 20:39:13 +0100
Message-Id: <20240122193916.1803448-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122193916.1803448-1-hch@lst.de>
References: <20240122193916.1803448-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Unmapped buffer access is a pain, so kill it.  Note that this means
we now pay the vmap overhead even for inode cluster buffers, but
that will be fixed by switching to large folios.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.c    |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c |  2 +-
 fs/xfs/scrub/inode_repair.c   |  2 +-
 fs/xfs/xfs_buf.c              | 45 +----------------------------------
 fs/xfs/xfs_buf.h              | 16 +++++++++----
 fs/xfs/xfs_buf_item_recover.c |  7 +-----
 fs/xfs/xfs_inode.c            |  2 +-
 7 files changed, 17 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 2361a22035b0c0..b7aaade726f2ee 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -358,7 +358,7 @@ xfs_ialloc_inode_init(
 				(j * M_IGEO(mp)->blocks_per_cluster));
 		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 				mp->m_bsize * M_IGEO(mp)->blocks_per_cluster,
-				XBF_UNMAPPED, &fbuf);
+				0, &fbuf);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 137a65bda95dc1..e649e0261552be 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -133,7 +133,7 @@ xfs_imap_to_bp(
 	struct xfs_buf		**bpp)
 {
 	return xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
-				   imap->im_len, XBF_UNMAPPED, bpp,
+				   imap->im_len, 0, bpp,
 				   &xfs_inode_buf_ops);
 }
 
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 0ca62d59f84ad1..faae6460acea44 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1095,7 +1095,7 @@ xrep_dinode_core(
 
 	/* Read the inode cluster buffer. */
 	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
-			ri->imap.im_blkno, ri->imap.im_len, XBF_UNMAPPED, &bp,
+			ri->imap.im_blkno, ri->imap.im_len, 0, &bp,
 			NULL);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ec4bd7a24d88c9..792759afdc73be 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -228,7 +228,7 @@ _xfs_buf_alloc(
 	 * We don't want certain flags to appear in b_flags unless they are
 	 * specifically set by later operations on the buffer.
 	 */
-	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
+	flags &= ~(XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
 
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
@@ -421,8 +421,6 @@ _xfs_buf_map_pages(
 	if (bp->b_page_count == 1) {
 		/* A single page buffer is always mappable */
 		bp->b_addr = page_address(bp->b_pages[0]);
-	} else if (flags & XBF_UNMAPPED) {
-		bp->b_addr = NULL;
 	} else {
 		int retried = 0;
 		unsigned nofs_flag;
@@ -1705,47 +1703,6 @@ __xfs_buf_submit(
 	return error;
 }
 
-void *
-xfs_buf_offset(
-	struct xfs_buf		*bp,
-	size_t			offset)
-{
-	struct page		*page;
-
-	if (bp->b_addr)
-		return bp->b_addr + offset;
-
-	page = bp->b_pages[offset >> PAGE_SHIFT];
-	return page_address(page) + (offset & (PAGE_SIZE-1));
-}
-
-void
-xfs_buf_zero(
-	struct xfs_buf		*bp,
-	size_t			boff,
-	size_t			bsize)
-{
-	size_t			bend;
-
-	bend = boff + bsize;
-	while (boff < bend) {
-		struct page	*page;
-		int		page_index, page_offset, csize;
-
-		page_index = (boff + bp->b_offset) >> PAGE_SHIFT;
-		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
-		page = bp->b_pages[page_index];
-		csize = min_t(size_t, PAGE_SIZE - page_offset,
-				      BBTOB(bp->b_length) - boff);
-
-		ASSERT((csize + page_offset) <= PAGE_SIZE);
-
-		memset(page_address(page) + page_offset, 0, csize);
-
-		boff += csize;
-	}
-}
-
 /*
  * Log a message about and stale a buffer that a caller has decided is corrupt.
  *
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b470de08a46ca8..379d58c4cb9a27 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -51,7 +51,6 @@ struct xfs_buf;
 #define XBF_LIVESCAN	 (1u << 28)
 #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
 #define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
-#define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
 
 
 typedef unsigned int xfs_buf_flags_t;
@@ -74,8 +73,7 @@ typedef unsigned int xfs_buf_flags_t;
 	/* The following interface flags should never be set */ \
 	{ XBF_LIVESCAN,		"LIVESCAN" }, \
 	{ XBF_INCORE,		"INCORE" }, \
-	{ XBF_TRYLOCK,		"TRYLOCK" }, \
-	{ XBF_UNMAPPED,		"UNMAPPED" }
+	{ XBF_TRYLOCK,		"TRYLOCK" }
 
 /*
  * Internal state flags.
@@ -308,12 +306,20 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
 extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa);
 void xfs_buf_ioend_fail(struct xfs_buf *);
-void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
 void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
 /* Buffer Utility Routines */
-extern void *xfs_buf_offset(struct xfs_buf *, size_t);
+static inline void *xfs_buf_offset(struct xfs_buf *bp, size_t offset)
+{
+	return bp->b_addr + offset;
+}
+
+static inline void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize)
+{
+	memset(bp->b_addr + boff, 0, bsize);
+}
+
 extern void xfs_buf_stale(struct xfs_buf *bp);
 
 /* Delayed Write Buffer Routines */
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 43167f543afc33..3b1e2dab3ababc 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -891,7 +891,6 @@ xlog_recover_buf_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
 	int				error;
-	uint				buf_flags;
 	xfs_lsn_t			lsn;
 
 	/*
@@ -911,12 +910,8 @@ xlog_recover_buf_commit_pass2(
 
 	trace_xfs_log_recover_buf_recover(log, buf_f);
 
-	buf_flags = 0;
-	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
-		buf_flags |= XBF_UNMAPPED;
-
 	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
-			  buf_flags, &bp, NULL);
+			  0, &bp, NULL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1fd94958aa97aa..db52cd086c4ada 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2301,7 +2301,7 @@ xfs_ifree_cluster(
 		 */
 		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
 				mp->m_bsize * igeo->blocks_per_cluster,
-				XBF_UNMAPPED, &bp);
+				0, &bp);
 		if (error)
 			return error;
 
-- 
2.39.2

