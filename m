Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1B330DEBA;
	Thu, 23 Jul 2026 05:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784782948; cv=none; b=Xw5EJwhZ3/bojuS1VGlQznZr/quf79j0A5EsKfQC1Ry7frPCCZzhfZz6JnG7CjKK9wZCIzjb9jdRroLMM9hH3wjRhcZwb4Gnk1ahwJNPgGkmPVtNZScW8CqXaPvn2a3/IBypBBCx7gKghqC1hVb8o2JYUIY0neuS97hGm1O3X7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784782948; c=relaxed/simple;
	bh=u1pOAKEPlK4K9AP1SKCw73adBbirth9MZ1BKNBF6k1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLf3yyiWAaVNBBk/2+ZND7ExpFWj7tdp6noUMtNHoarmN5qI4rxmjALor9A6b8bmr5qD2okdbTJ+cXEOr6cofbaQaQq7hFi3zcsDHmYmEmphoBqgBNe1MDSeXEk69wOuNfkUMhWIL8KmUwR2KznI3uFSnMkEj2HRTkKd8FtzcHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n8evkUYc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n8evkUYc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cD0hi+Qlp31vE+kHiB7MCFCUAia6EjKEeaZSLZogopw=; b=n8evkUYcRUCu3gXG8Sba4NqSzb
	KRASLu1OgPasjdzwAtaDjHmvLO7pqZJ2LzCKO87lU1ZYQriZF/H9tAGr0Z8jKUa53fbEhxzzlhF1G
	9QnGjkL5UMpB5xp6OoeGUZRDsBtuI/25h6DGQB2b738XbxC4vGvOu1sigGS9hNWzA6zdjQu4r8Ska
	+XGOlUTjiLOeqcORRjPQALPu3iVw9EV1tV97LKuicH9GK4xlWE28XbwaOHgT8qWQoUnUIhXQZXrBj
	bsyMOHqzt2sX+Q3JgsvxtlZ2EE3ZAb8qnuMBJyO6CKQJmQGwV0ZKXxKzw7cacfvuK/VfH/zncIev9
	06wqgu6w==;
Received: from 217-76-162-32.static.highway.a1.net ([217.76.162.32] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmlZd-0000000DRXQ-0GpO;
	Thu, 23 Jul 2026 05:02:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: changfengnan@bytedance.com,
	Joanne Koong <joannelkoong@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Carlos Maiolino <cem@kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/3] iomap: split iomap_iter() logic into iomap_iter_next()
Date: Thu, 23 Jul 2026 07:01:39 +0200
Message-ID: <20260723050201.3381045-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723050201.3381045-1-hch@lst.de>
References: <20260723050201.3381045-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Joanne Koong <joannelkoong@gmail.com>

In preparation for changing iomap to use an in-iter (->iomap_next())
model, move the iomap_iter() logic out into the new iomap_iter_next()
helper function.

iomap_iter_next() is added as an inlined helper so it can be called
directly by ->iomap_next() implementations where the begin()/end()
callbacks can be direct calls.

The DEFINE_IOMAP_ITER_NEXT() and DEFINE_IOMAP_ITER_NEXT_END() macros are
also provided to generate the boilerplate ->iomap_next() wrapper
functions that simply forward to iomap_iter_next() with the appropriate
begin/end callbacks. DEFINE_IOMAP_ITER_NEXT() is for the common case
where there is no end() callback. DEFINE_IOMAP_ITER_NEXT_END() is for
the case where there is an explicit end() callback.

No functional change intended. The only code-level difference is that on
the iomap_end() error path (ret < 0 && !advanced), the old code returned
with iter.status left as the caller's last value whereas the new code
zeroes it, but this is not observable in practice as there are no in-tree
callers that read iter.status after the iteration loop.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 123 +++++++++++++++++++++---------------------
 include/linux/iomap.h | 102 +++++++++++++++++++++++++++++------
 2 files changed, 147 insertions(+), 78 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index e4a29829591a..66ccb87441ab 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -6,15 +6,6 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
-static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
-{
-	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
-		folio_batch_release(iter->fbatch);
-		folio_batch_reinit(iter->fbatch);
-		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
-	}
-}
-
 /* Advance the current iterator position and decrement the remaining length */
 int iomap_iter_advance(struct iomap_iter *iter, u64 count)
 {
@@ -40,51 +31,28 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
 }
 
 /**
- * iomap_iter - iterate over a ranges in a file
- * @iter: iteration structue
- * @ops: iomap ops provided by the file system
+ * iomap_iter_continue - decide whether iteration should continue
+ * @iter: iteration structure
+ * @iomap: the mapping that was just processed
+ * @srcmap: the source mapping that was just processed
  *
- * Iterate over filesystem-provided space mappings for the provided file range.
+ * Helper normally called via iomap_iter_next(). Called after the previous
+ * mapping has been finished to determine whether there is more of the file
+ * range left to process.
  *
- * This function handles cleanup of resources acquired for iteration when the
- * filesystem indicates there are no more space mappings, which means that this
- * function must be called in a loop that continues as long it returns a
- * positive value.  If 0 or a negative value is returned, the caller must not
- * return to the loop body.  Within a loop body, there are two ways to break out
- * of the loop body:  leave @iter.status unchanged, or set it to a negative
- * errno.
+ * Returns 1 if there is more work to do, in which case @iomap and @srcmap are
+ * cleared so the caller can produce the next mapping; zero if the range is
+ * fully consumed; or a negative errno on error. Any folio batch attached to
+ * the mapping is released before returning.
  */
-int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
+int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap, int ret)
 {
-	bool stale = iter->iomap.flags & IOMAP_F_STALE;
-	ssize_t advanced;
-	u64 olen;
-	int ret;
-
-	trace_iomap_iter(iter, ops, _RET_IP_);
-
-	if (!iter->iomap.length)
-		goto begin;
-
-	/*
-	 * Calculate how far the iter was advanced and the original length bytes
-	 * for ->iomap_end().
-	 */
-	advanced = iter->pos - iter->iter_start_pos;
-	olen = iter->len + advanced;
-
-	if (ops->iomap_end) {
-		ret = ops->iomap_end(iter->inode, iter->iter_start_pos,
-				iomap_length_trim(iter, iter->iter_start_pos,
-						  olen),
-				advanced, iter->flags, &iter->iomap);
-		if (ret < 0 && !advanced)
-			return ret;
-	}
+	const bool stale = iomap->flags & IOMAP_F_STALE;
+	const ssize_t advanced = iter->pos - iter->iter_start_pos;
 
-	/* detect old return semantics where this would advance */
-	if (WARN_ON_ONCE(iter->status > 0))
-		iter->status = -EIO;
+	if (ret < 0 && !advanced)
+		return ret;
 
 	/*
 	 * Use iter->len to determine whether to continue onto the next mapping.
@@ -92,25 +60,58 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	 * advanced at all (i.e. no work was done for some reason) unless the
 	 * mapping has been marked stale and needs to be reprocessed.
 	 */
-	if (iter->status < 0)
+	if (WARN_ON_ONCE(iter->status > 0))
+		/* detect old return semantics where this would advance */
+		ret = -EIO;
+	else if (iter->status < 0)
 		ret = iter->status;
 	else if (iter->len == 0 || (!advanced && !stale))
 		ret = 0;
 	else
 		ret = 1;
-	iomap_iter_clean_fbatch(iter);
-	iter->status = 0;
+
+	if (iomap->flags & IOMAP_F_FOLIO_BATCH) {
+		folio_batch_release(iter->fbatch);
+		folio_batch_reinit(iter->fbatch);
+		iomap->flags &= ~IOMAP_F_FOLIO_BATCH;
+	}
+
 	if (ret <= 0)
 		return ret;
 
-	memset(&iter->iomap, 0, sizeof(iter->iomap));
-	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
+	memset(iomap, 0, sizeof(*iomap));
+	memset(srcmap, 0, sizeof(*srcmap));
 
-begin:
-	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
-			       &iter->iomap, &iter->srcmap);
-	if (ret < 0)
-		return ret;
-	iomap_iter_done(iter);
-	return 1;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iomap_iter_continue);
+
+/**
+ * iomap_iter - iterate over ranges in a file
+ * @iter: iteration structure
+ * @ops: iomap ops provided by the filesystem
+ *
+ * Iterate over filesystem-provided space mappings for the provided file range.
+ *
+ * This function handles cleanup of resources acquired for iteration when the
+ * filesystem indicates there are no more space mappings, which means that this
+ * function must be called in a loop that continues as long it returns a
+ * positive value.  If 0 or a negative value is returned, the caller must not
+ * return to the loop body.  Within a loop body, there are two ways to break out
+ * of the loop body:  leave @iter.status unchanged, or set it to a negative
+ * errno.
+ */
+int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
+{
+	int ret;
+
+	trace_iomap_iter(iter, ops, _RET_IP_);
+
+	ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
+			ops->iomap_begin, ops->iomap_end);
+	iter->status = 0;
+	if (ret > 0)
+		iomap_iter_done(iter);
+
+	return ret;
 }
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3582ed1fe236..3df851d0f76b 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -212,24 +212,27 @@ struct iomap_write_ops {
 #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
 #define IOMAP_DONTCACHE		(1 << 10)
 
-struct iomap_ops {
-	/*
-	 * Return the existing mapping at pos, or reserve space starting at
-	 * pos for up to length, as long as we can do it as a single mapping.
-	 * The actual length is returned in iomap->length.
-	 */
-	int (*iomap_begin)(struct inode *inode, loff_t pos, loff_t length,
-			unsigned flags, struct iomap *iomap,
-			struct iomap *srcmap);
+/*
+ * Return the existing mapping at pos, or reserve space starting at pos for up
+ * to length, as long as we can do it as a single mapping.
+ * The actual length is returned in iomap->length.
+ */
+typedef int (*iomap_iter_begin_fn)(struct inode *inode, loff_t pos,
+		loff_t length, unsigned flags, struct iomap *iomap,
+		struct iomap *srcmap);
 
-	/*
-	 * Commit and/or unreserve space previous allocated using iomap_begin.
-	 * Written indicates the length of the successful write operation which
-	 * needs to be commited, while the rest needs to be unreserved.
-	 * Written might be zero if no data was written.
-	 */
-	int (*iomap_end)(struct inode *inode, loff_t pos, loff_t length,
-			ssize_t written, unsigned flags, struct iomap *iomap);
+/*
+ * Commit and/or unreserve space previously allocated by iomap_iter_begin_fn.
+ * Written indicates the length of the successful write operation which needs
+ * to be committed, while the rest needs to be unreserved.
+ * Written might be zero if no data was written.
+ */
+typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t length,
+		ssize_t written, unsigned flags, struct iomap *iomap);
+
+struct iomap_ops {
+	iomap_iter_begin_fn iomap_begin;
+	iomap_iter_end_fn iomap_end;
 };
 
 /**
@@ -317,6 +320,71 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
 	return &i->iomap;
 }
 
+int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap, int ret);
+
+/**
+ * iomap_iter_next - finish the previous mapping and produce the next one
+ * @iter: iteration structure
+ * @iomap: mapping to finish and then repopulate
+ * @srcmap: source mapping to finish and then repopulate
+ * @begin: callback that produces a mapping for the current position
+ * @end: optional callback that finishes the previous mapping, or NULL
+ *
+ * Inline helper that implements the common body of an ->iomap_next()
+ * callback: it finishes the previous mapping via @end (if present), decides
+ * via iomap_iter_continue() whether to keep going, and obtains the next
+ * mapping via @begin.
+ *
+ * This helper is marked __always_inline so that when a caller passes
+ * compile-time-constant @begin and @end callbacks, the compiler can call them
+ * directly, avoiding the indirect-call overhead.
+ *
+ * Returns 1 to continue iterating, 0 once the range is fully consumed, or a
+ * negative errno on error.
+ */
+static __always_inline int iomap_iter_next(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap,
+		iomap_iter_begin_fn begin, iomap_iter_end_fn end)
+{
+	int ret = 0;
+
+	if (iomap->length) {
+		if (end) {
+			/*
+			 * Calculate how far the iter was advanced and the
+			 * original length bytes for end().
+			 */
+			ssize_t advanced = iter->pos - iter->iter_start_pos;
+			loff_t len;
+
+			len = iomap_length_trim(iter, iter->iter_start_pos,
+					iter->len + advanced);
+
+			ret = end(iter->inode, iter->iter_start_pos, len,
+					advanced, iter->flags, iomap);
+		}
+		ret = iomap_iter_continue(iter, iomap, srcmap, ret);
+		if (ret <= 0)
+			return ret;
+	}
+
+	ret = begin(iter->inode, iter->pos, iter->len, iter->flags, iomap,
+			srcmap);
+
+	return ret < 0 ? ret : 1;
+}
+
+#define DEFINE_IOMAP_ITER_NEXT_END(name, begin_fn, end_fn)		\
+int name(const struct iomap_iter *iter, struct iomap *iomap,		\
+		struct iomap *srcmap)					\
+{									\
+	return iomap_iter_next(iter, iomap, srcmap, begin_fn, end_fn);	\
+}
+
+#define DEFINE_IOMAP_ITER_NEXT(name, begin_fn)				\
+	DEFINE_IOMAP_ITER_NEXT_END(name, begin_fn, NULL)
+
 /*
  * Return the file offset for the first unchanged block after a short write.
  *
-- 
2.53.0

