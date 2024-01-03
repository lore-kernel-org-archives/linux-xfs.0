Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4831D69B
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 20:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4CPCCEJ0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XJOWyJoBAcRruesnQ8GLqxtzqBx1+pbhlfAIKzpkHds=; b=4CPCCEJ0OXvkcnXYFfskTlKYPb
	1/fc7xPryjG/K58JI5zu6/MHnzHj3qUhj7HOOy2ybjXI3DN2ds7bHCJ2ZsVhIeMMIWRXps7qe3jlI
	8jWmfI3GLfXcqnMRPRNG9WEl2ubJ6ZaQAxEJOVZ4eozWwvpiZqEcnTLST/IaZxTSVRZp+1vzpoJ5t
	LmUo6N0WHdJ9DyLM1JEPLJZOsbIaLGQUto6pwpCI8K9KqRyjCC9QZvch8VNUk10fcrAz7BsJD6qZ/
	/7KXj1yMcpn1agVsbziqSYcEJImAyOr7vnWtOyd14c4ipRPF4DBlK0AHQZcByEJS9YaLsqFG+5/+C
	vFFOb+Kw==;
Received: from [89.144.223.119] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rL80q-00C4So-1d;
	Wed, 03 Jan 2024 20:38:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: remove struct xfboff_bitmap
Date: Wed,  3 Jan 2024 21:38:33 +0100
Message-Id: <20240103203836.608391-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103203836.608391-1-hch@lst.de>
References: <20240103203836.608391-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Just use struct xbitmap64 directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfbtree.c | 41 +++++------------------------------------
 fs/xfs/scrub/xfbtree.h | 14 +++++---------
 2 files changed, 10 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index 3620acc008aa59..63b69aeadc623d 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -24,37 +24,6 @@
 #include "scrub/bitmap.h"
 #include "scrub/trace.h"
 
-/* Bitmaps, but for type-checked for xfileoff_t */
-
-static inline void xfboff_bitmap_init(struct xfboff_bitmap *bitmap)
-{
-	xbitmap64_init(&bitmap->xfoffbitmap);
-}
-
-static inline void xfboff_bitmap_destroy(struct xfboff_bitmap *bitmap)
-{
-	xbitmap64_destroy(&bitmap->xfoffbitmap);
-}
-
-static inline int xfboff_bitmap_set(struct xfboff_bitmap *bitmap,
-		xfs_fileoff_t start, xfs_filblks_t len)
-{
-	return xbitmap64_set(&bitmap->xfoffbitmap, start, len);
-}
-
-static inline int xfboff_bitmap_take_first_set(struct xfboff_bitmap *bitmap,
-		xfileoff_t *valp)
-{
-	uint64_t	val;
-	int		error;
-
-	error = xbitmap64_take_first_set(&bitmap->xfoffbitmap, 0, -1ULL, &val);
-	if (error)
-		return error;
-	*valp = val;
-	return 0;
-}
-
 /* Extract the buftarg target for this xfile btree. */
 struct xfs_buftarg *
 xfbtree_target(struct xfbtree *xfbtree)
@@ -295,7 +264,7 @@ void
 xfbtree_destroy(
 	struct xfbtree		*xfbt)
 {
-	xfboff_bitmap_destroy(&xfbt->freespace);
+	xbitmap64_destroy(&xfbt->freespace);
 	xfs_buftarg_drain(xfbt->target);
 	kfree(xfbt);
 }
@@ -377,7 +346,7 @@ xfbtree_create(
 	if (cfg->flags & XFBTREE_DIRECT_MAP)
 		xfbt->target->bt_flags |= XFS_BUFTARG_DIRECT_MAP;
 
-	xfboff_bitmap_init(&xfbt->freespace);
+	xbitmap64_init(&xfbt->freespace);
 
 	/* Set up min/maxrecs for this btree. */
 	if (cfg->btree_ops->geom_flags & XFS_BTREE_LONG_PTRS)
@@ -402,7 +371,7 @@ xfbtree_create(
 	return 0;
 
 err_freesp:
-	xfboff_bitmap_destroy(&xfbt->freespace);
+	xbitmap64_destroy(&xfbt->freespace);
 	xfs_buftarg_drain(xfbt->target);
 	kfree(xfbt);
 	return error;
@@ -432,7 +401,7 @@ xfbtree_alloc_block(
 	 * Find the first free block in the free space bitmap and take it.  If
 	 * none are found, seek to end of the file.
 	 */
-	error = xfboff_bitmap_take_first_set(&xfbt->freespace, &bt_xfoff);
+	error = xbitmap64_take_first_set(&xfbt->freespace, 0, -1ULL, &bt_xfoff);
 	if (error == -ENODATA) {
 		bt_xfoff = xfbt->highest_offset++;
 		error = 0;
@@ -479,7 +448,7 @@ xfbtree_free_block(
 
 	trace_xfbtree_free_block(xfbt, cur, bt_xfoff);
 
-	return xfboff_bitmap_set(&xfbt->freespace, bt_xfoff, bt_xflen);
+	return xbitmap64_set(&xfbt->freespace, bt_xfoff, bt_xflen);
 }
 
 /* Return the minimum number of records for a btree block. */
diff --git a/fs/xfs/scrub/xfbtree.h b/fs/xfs/scrub/xfbtree.h
index e98f9261464a06..d17be23aca7dbb 100644
--- a/fs/xfs/scrub/xfbtree.h
+++ b/fs/xfs/scrub/xfbtree.h
@@ -12,24 +12,20 @@
 
 /* xfile-backed in-memory btrees */
 
-struct xfboff_bitmap {
-	struct xbitmap64		xfoffbitmap;
-};
-
 struct xfbtree {
 	/* buffer cache target for the xfile backing this in-memory btree */
 	struct xfs_buftarg		*target;
 
-	/* Bitmap of free space from pos to used */
-	struct xfboff_bitmap		freespace;
+	/* Highest xfile offset that has been written to. */
+	xfileoff_t			highest_offset;
+
+	/* Bitmap of free space from pos to highest_offset */
+	struct xbitmap64		freespace;
 
 	/* Fake header block information */
 	union xfs_btree_ptr		root;
 	uint32_t			nlevels;
 
-	/* Highest xfile offset that has been written to. */
-	xfileoff_t			highest_offset;
-
 	/* Owner of this btree. */
 	unsigned long long		owner;
 
-- 
2.39.2

