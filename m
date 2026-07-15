Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4051396B9A
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 14:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127131; cv=none; b=fAF/VfVSt0lYbtSZWLe3vBSh7s5y7MW3bXsrilkTksaWozurXgi0zcNfRCgmyeCzvKIctgKbuB7E0L6iObioIg9/Pc/67InSZqq3Riej/HpSukpBfSCv5JCTaObjWhIFffLcV3/IOa6QEgyivlt4NuwfzyOXeUQyI6eD2mWZp8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127131; c=relaxed/simple;
	bh=9zjichjmdMUCkZ8mI3qdZIIwtqZ1k9O+z6bBptzyrBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7ucHEzPDj2BLzadzzdCxYIjRzavMkMMezt5BJBY6WjNKgn87Pwamxnw7SpRq2eswo1+PXVjSTKzDI9lDsiiFOcFfpxgzEeat5AbS+d20QTdFNSkdWUKsWopifzSAlOzwn2ZQoLZ3rXoEQQ7vzv8Odk25QpGPKMf5gVrHogbJ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3tmC8MWg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3tmC8MWg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OZ38AGYYI2sDPwPuufUnB4/xFG3zhMDHLEIWccIspVI=; b=3tmC8MWgccV+HDeWSB+OtsN9WU
	02RauSB1clZcUq3dI7ztZm4hye41e4cEuXuG6DScJCjSuZhrIHqHQsFfx3A1R/IVj+5lEuDQSrijp
	0lRWPs6BsqLhwi5CM1VfC8RuWmctKPBstLwdccbNIE74gN2RyB8WSma4c2LDZl+US00axgX41CG/8
	dFEz2vtEGeRejHZSlnzE9W85jjz/tuPNT0eXGKe8d/12lcMCOJHkxNZprZsCqVGYormWls0fCj4t+
	A8TPPlhMqT6yGEBSlCKlJgz2weJC7wCLcqezOYu8rCO06Y1s0sggMSPWQegIwfNQGyfyTcQ/fNdjH
	Fpuqoi7A==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0y1-0000000FDWc-02rd;
	Wed, 15 Jul 2026 14:52:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/12] xfs: hide b_flags manipulation from code outside of xfs_buf.c
Date: Wed, 15 Jul 2026 16:50:59 +0200
Message-ID: <20260715145147.95654-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715145147.95654-1-hch@lst.de>
References: <20260715145147.95654-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add helpers for the remaining buffer flags manipulation not done in the
core buffer cache code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree_staging.c |  7 +++----
 fs/xfs/libxfs/xfs_ialloc.c        |  2 +-
 fs/xfs/xfs_buf.c                  | 16 ++++++++++++++++
 fs/xfs/xfs_buf.h                  |  4 +++-
 fs/xfs/xfs_fsops.c                |  2 +-
 fs/xfs/xfs_inode.c                |  4 ++--
 fs/xfs/xfs_trans_buf.c            |  7 +++----
 7 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index c3c7ea54895a..7314dab4bcfb 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -248,11 +248,10 @@ xfs_btree_bload_drop_buf(
 		return 0;
 
 	/*
-	 * Mark this buffer XBF_DONE (i.e. uptodate) so that a subsequent
-	 * xfs_buf_read will not pointlessly reread the contents from the disk.
+	 * Mark this buffer uptodate so that a subsequent xfs_buf_read will
+	 * not pointlessly reread the contents from the disk.
 	 */
-	bp->b_flags |= XBF_DONE;
-
+	xfs_buf_set_uptodate(bp);
 	xfs_buf_delwri_queue_here(bp, buffers_list);
 	xfs_buf_relse(bp);
 	*bpp = NULL;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ffcdd1f691fd..58dac4d505ba 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -413,7 +413,7 @@ xfs_ialloc_inode_init(
 				xfs_trans_ordered_buf(tp, fbuf);
 			}
 		} else {
-			fbuf->b_flags |= XBF_DONE;
+			xfs_buf_set_uptodate(fbuf);
 			xfs_buf_delwri_queue(fbuf, buffer_list);
 			xfs_buf_relse(fbuf);
 		}
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d0146d4fb3d3..33e904d838f4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -55,6 +55,13 @@ static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
 	return bp->b_rhash_key == XFS_BUF_DADDR_NULL;
 }
 
+void
+xfs_buf_set_uptodate(
+	struct xfs_buf	*bp)
+{
+	bp->b_flags |= XBF_DONE;
+}
+
 /*
  * When we mark a buffer stale, we remove the buffer from the LRU and clear the
  * b_lru_ref count so that the buffer is freed immediately when the buffer
@@ -85,6 +92,15 @@ xfs_buf_stale(
 	spin_unlock(&bp->b_lockref.lock);
 }
 
+void
+xfs_buf_clear_stale(
+	struct xfs_buf	*bp)
+{
+	ASSERT(bp->b_flags & XBF_STALE);
+
+	bp->b_flags &= ~XBF_STALE;
+}
+
 static void
 xfs_buf_free_callback(
 	struct callback_head	*cb)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index e440f97cf3e1..a4729253b56f 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -301,7 +301,9 @@ static inline void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize)
 	memset(bp->b_addr + boff, 0, bsize);
 }
 
-extern void xfs_buf_stale(struct xfs_buf *bp);
+void xfs_buf_set_uptodate(struct xfs_buf *bp);
+void xfs_buf_stale(struct xfs_buf *bp);
+void xfs_buf_clear_stale(struct xfs_buf *bp);
 
 /* Delayed Write Buffer Routines */
 extern void xfs_buf_delwri_cancel(struct list_head *);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 67624a804a7f..21114bb6d4ff 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -501,7 +501,7 @@ xfs_do_force_shutdown(
 		return;
 	}
 	if (mp->m_sb_bp)
-		mp->m_sb_bp->b_flags |= XBF_DONE;
+		xfs_buf_set_uptodate(mp->m_sb_bp);
 
 	if (flags & SHUTDOWN_FORCE_UMOUNT)
 		xfs_alert(mp, "User initiated shutdown received.");
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 15279d22a894..030a7c8f2c12 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1753,7 +1753,7 @@ xfs_ifree_cluster(
 		 * attachment may occur in xfs_inode_item_precommit() after we
 		 * have marked this buffer stale.  If this buffer was not in
 		 * memory before xfs_ifree_cluster() started, it will not be
-		 * marked XBF_DONE and this will cause problems later in
+		 * marked uptodate and this will cause problems later in
 		 * xfs_inode_item_precommit() when we trip over a (stale, !done)
 		 * buffer to attached to the transaction.
 		 *
@@ -1766,7 +1766,7 @@ xfs_ifree_cluster(
 		 * fail. We can acheive this by adding a write verifier to the
 		 * buffer.
 		 */
-		bp->b_flags |= XBF_DONE;
+		xfs_buf_set_uptodate(bp);
 		bp->b_ops = &xfs_inode_buf_ops;
 
 		/*
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 7e17b93fe9ad..1e025848811a 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -140,7 +140,7 @@ xfs_trans_get_buf_map(
 		ASSERT(xfs_buf_islocked(bp));
 		if (xfs_is_shutdown(tp->t_mountp)) {
 			xfs_buf_stale(bp);
-			bp->b_flags |= XBF_DONE;
+			xfs_buf_set_uptodate(bp);
 		}
 
 		ASSERT(bp->b_transp == tp);
@@ -482,7 +482,7 @@ xfs_trans_dirty_buf(
 	 * item from the AIL and free it when the buffer is flushed
 	 * to disk.
 	 */
-	bp->b_flags |= XBF_DONE;
+	xfs_buf_set_uptodate(bp);
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
@@ -494,8 +494,7 @@ xfs_trans_dirty_buf(
 	 */
 	if (bip->bli_flags & XFS_BLI_STALE) {
 		bip->bli_flags &= ~XFS_BLI_STALE;
-		ASSERT(bp->b_flags & XBF_STALE);
-		bp->b_flags &= ~XBF_STALE;
+		xfs_buf_clear_stale(bp);
 		bip->__bli_format.blf_flags &= ~XFS_BLF_CANCEL;
 	}
 	bip->bli_flags |= XFS_BLI_DIRTY | XFS_BLI_LOGGED;
-- 
2.53.0

