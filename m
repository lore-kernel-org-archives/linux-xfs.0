Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F267A1B80A
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275829; cv=none; b=PNboxek+bsZpbLv+qY/DE3fQxT4c8FvPDG1wNDO3e/rcAdd7tP/F46Az1ZYnX2go9pQa8HDhZbS9mc0DP8PcAd6pxOEhKyKwZ/uJoirnOSzJYbRYsN3L91knJ3XHAbEvYx9jCBESJj3B0KT3wwaqQF5rKVOq/iMfhSHYdJv7iJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275829; c=relaxed/simple;
	bh=U4EtbZ7atWvCDwK5SLg3mf7/Xv/ZBnHVB3RAt0YPcMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=APTfxX/UBif9fMurYgxmyCKhEJGISW9sppDxv70UruatEBv6ql45JwTesBtSSnSF5dvg2x/eOlM8eaYcIdXt1/OPWspThIhzhkYk4mVadxkuZvGLP+Uz/a/UJ2sMB+tTiRNbrvD8pZwwtIickM7VPG3FwAo+3iwXv2ddAmD7yKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=teotdbtZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="teotdbtZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=R65vFoRwXEcbpDPh9sk2joksz0b+qXxKQPYH8JdojnY=; b=teotdbtZ3zhU9LE56kgDgixM/1
	A5j31X1bYN9n/qobJsPEBAw4kLlLRWVtxijErFpO6jCBuoVtZBvUwayCJiojz+r492ZmlmOcizxWF
	QtXk0ir5sPVD+4CTcmisar6jYiNoFIn25ypY7OQW9mmelkhur/mabcYPDlgTRESfUxj0Hzt/4HKY8
	my8EkmTVdLD6/qfP+RMzHHazrgZvm4hO/ZaqWx0C+CWnJZcXDPYfISHMmPQKvHKIPCgWXVMcjDit2
	18yAaKw/KY5FNOkQbQQZBbmEYEZxUAJQXbbMZeLrylPm42i2swKTgNJZr2calu6A0O8b4WhGPBgRJ
	s3YzbtvQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMHq-00000004Czt-0kpA;
	Fri, 26 Jan 2024 13:30:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 20/21] xfs: convert xfarray_pagesort to deal with large folios
Date: Fri, 26 Jan 2024 14:29:02 +0100
Message-Id: <20240126132903.2700077-21-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>
References: <20240126132903.2700077-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: "Darrick J. Wong" <djwong@kernel.org>

Convert xfarray_pagesort to handle large folios by introducing a new
xfile_get_folio routine that can return a folio of arbitrary size, and
using heapsort on the full folio.  This also corrects an off-by-one bug
in the calculation of len in xfarray_pagesort that was papered over by
xfarray_want_pagesort.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/trace.h   |  43 ++++++++-
 fs/xfs/scrub/xfarray.c | 201 +++++++++++++++++++----------------------
 fs/xfs/scrub/xfarray.h |  10 +-
 3 files changed, 143 insertions(+), 111 deletions(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c61fa7a95ef522..3a1a827828dcb9 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -956,7 +956,7 @@ TRACE_EVENT(xfarray_isort,
 		  __entry->hi - __entry->lo)
 );
 
-TRACE_EVENT(xfarray_pagesort,
+TRACE_EVENT(xfarray_foliosort,
 	TP_PROTO(struct xfarray_sortinfo *si, uint64_t lo, uint64_t hi),
 	TP_ARGS(si, lo, hi),
 	TP_STRUCT__entry(
@@ -1027,6 +1027,47 @@ TRACE_EVENT(xfarray_sort,
 		  __entry->bytes)
 );
 
+TRACE_EVENT(xfarray_sort_scan,
+	TP_PROTO(struct xfarray_sortinfo *si, unsigned long long idx),
+	TP_ARGS(si, idx),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(unsigned long long, nr)
+		__field(size_t, obj_size)
+		__field(unsigned long long, idx)
+		__field(unsigned long long, folio_pos)
+		__field(unsigned long, folio_bytes)
+		__field(unsigned long long, first_idx)
+		__field(unsigned long long, last_idx)
+	),
+	TP_fast_assign(
+		__entry->nr = si->array->nr;
+		__entry->obj_size = si->array->obj_size;
+		__entry->ino = file_inode(si->array->xfile->file)->i_ino;
+		__entry->idx = idx;
+		if (si->folio) {
+			__entry->folio_pos = folio_pos(si->folio);
+			__entry->folio_bytes = folio_size(si->folio);
+			__entry->first_idx = si->first_folio_idx;
+			__entry->last_idx = si->last_folio_idx;
+		} else {
+			__entry->folio_pos = 0;
+			__entry->folio_bytes = 0;
+			__entry->first_idx = 0;
+			__entry->last_idx = 0;
+		}
+	),
+	TP_printk("xfino 0x%lx nr %llu objsz %zu idx %llu folio_pos 0x%llx folio_bytes 0x%lx first_idx %llu last_idx %llu",
+		  __entry->ino,
+		  __entry->nr,
+		  __entry->obj_size,
+		  __entry->idx,
+		  __entry->folio_pos,
+		  __entry->folio_bytes,
+		  __entry->first_idx,
+		  __entry->last_idx)
+);
+
 TRACE_EVENT(xfarray_sort_stats,
 	TP_PROTO(struct xfarray_sortinfo *si, int error),
 	TP_ARGS(si, error),
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 379e1db22269c7..17c982a4821d47 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -563,70 +563,42 @@ xfarray_isort(
 	return xfile_store(si->array->xfile, scratch, len, lo_pos);
 }
 
-/* Grab a page for sorting records. */
-static inline int
-xfarray_sort_get_page(
-	struct xfarray_sortinfo	*si,
-	loff_t			pos,
-	uint64_t		len)
-{
-	return xfile_get_page(si->array->xfile, pos, len, &si->xfpage);
-}
-
-/* Release a page we grabbed for sorting records. */
-static inline int
-xfarray_sort_put_page(
-	struct xfarray_sortinfo	*si)
-{
-	if (!xfile_page_cached(&si->xfpage))
-		return 0;
-	return xfile_put_page(si->array->xfile, &si->xfpage);
-}
-
-/* Decide if these records are eligible for in-page sorting. */
-static inline bool
-xfarray_want_pagesort(
-	struct xfarray_sortinfo	*si,
-	xfarray_idx_t		lo,
-	xfarray_idx_t		hi)
-{
-	pgoff_t			lo_page;
-	pgoff_t			hi_page;
-	loff_t			end_pos;
-
-	/* We can only map one page at a time. */
-	lo_page = xfarray_pos(si->array, lo) >> PAGE_SHIFT;
-	end_pos = xfarray_pos(si->array, hi) + si->array->obj_size - 1;
-	hi_page = end_pos >> PAGE_SHIFT;
-
-	return lo_page == hi_page;
-}
-
-/* Sort a bunch of records that all live in the same memory page. */
+/*
+ * Sort the records from lo to hi (inclusive) if they are all backed by the
+ * same memory folio.  Returns 1 if it sorted, 0 if it did not, or a negative
+ * errno.
+ */
 STATIC int
-xfarray_pagesort(
+xfarray_foliosort(
 	struct xfarray_sortinfo	*si,
 	xfarray_idx_t		lo,
 	xfarray_idx_t		hi)
 {
+	struct folio		*folio;
 	void			*startp;
 	loff_t			lo_pos = xfarray_pos(si->array, lo);
-	uint64_t		len = xfarray_pos(si->array, hi - lo);
-	int			error = 0;
+	uint64_t		len = xfarray_pos(si->array, hi - lo + 1);
 
-	trace_xfarray_pagesort(si, lo, hi);
+	/* No single folio could back this many records. */
+	if (len > XFILE_MAX_FOLIO_SIZE)
+		return 0;
 
 	xfarray_sort_bump_loads(si);
-	error = xfarray_sort_get_page(si, lo_pos, len);
-	if (error)
-		return error;
+	folio = xfile_get_folio(si->array->xfile, lo_pos, len, XFILE_ALLOC);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+	if (!folio)
+		return 0;
+
+	trace_xfarray_foliosort(si, lo, hi);
 
 	xfarray_sort_bump_heapsorts(si);
-	startp = page_address(si->xfpage.page) + offset_in_page(lo_pos);
+	startp = folio_address(folio) + offset_in_folio(folio, lo_pos);
 	sort(startp, hi - lo + 1, si->array->obj_size, si->cmp_fn, NULL);
 
 	xfarray_sort_bump_stores(si);
-	return xfarray_sort_put_page(si);
+	xfile_put_folio(si->array->xfile, folio);
+	return 1;
 }
 
 /* Return a pointer to the xfarray pivot record within the sortinfo struct. */
@@ -814,63 +786,78 @@ xfarray_qsort_push(
 	return 0;
 }
 
+static inline void
+xfarray_sort_scan_done(
+	struct xfarray_sortinfo	*si)
+{
+	if (si->folio)
+		xfile_put_folio(si->array->xfile, si->folio);
+	si->folio = NULL;
+}
+
 /*
- * Load an element from the array into the first scratchpad and cache the page,
- * if possible.
+ * Cache the folio backing the start of the given array element.  If the array
+ * element is contained entirely within the folio, return a pointer to the
+ * cached folio.  Otherwise, load the element into the scratchpad and return a
+ * pointer to the scratchpad.
  */
 static inline int
-xfarray_sort_load_cached(
+xfarray_sort_scan(
 	struct xfarray_sortinfo	*si,
 	xfarray_idx_t		idx,
-	void			*ptr)
+	void			**ptrp)
 {
 	loff_t			idx_pos = xfarray_pos(si->array, idx);
-	pgoff_t			startpage;
-	pgoff_t			endpage;
 	int			error = 0;
 
-	/*
-	 * If this load would split a page, release the cached page, if any,
-	 * and perform a traditional read.
-	 */
-	startpage = idx_pos >> PAGE_SHIFT;
-	endpage = (idx_pos + si->array->obj_size - 1) >> PAGE_SHIFT;
-	if (startpage != endpage) {
-		error = xfarray_sort_put_page(si);
-		if (error)
-			return error;
+	if (xfarray_sort_terminated(si, &error))
+		return error;
 
-		if (xfarray_sort_terminated(si, &error))
-			return error;
+	trace_xfarray_sort_scan(si, idx);
 
-		return xfile_load(si->array->xfile, ptr,
-				si->array->obj_size, idx_pos);
-	}
+	/* If the cached folio doesn't cover this index, release it. */
+	if (si->folio &&
+	    (idx < si->first_folio_idx || idx > si->last_folio_idx))
+		xfarray_sort_scan_done(si);
 
-	/* If the cached page is not the one we want, release it. */
-	if (xfile_page_cached(&si->xfpage) &&
-	    xfile_page_index(&si->xfpage) != startpage) {
-		error = xfarray_sort_put_page(si);
-		if (error)
-			return error;
+	/* Grab the first folio that backs this array element. */
+	if (!si->folio) {
+		loff_t		next_pos;
+
+		si->folio = xfile_get_folio(si->array->xfile, idx_pos,
+				si->array->obj_size, XFILE_ALLOC);
+		if (IS_ERR(si->folio))
+			return PTR_ERR(si->folio);
+
+		si->first_folio_idx = xfarray_idx(si->array,
+				folio_pos(si->folio) + si->array->obj_size - 1);
+
+		next_pos = folio_pos(si->folio) + folio_size(si->folio);
+		si->last_folio_idx = xfarray_idx(si->array, next_pos - 1);
+		if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
+			si->last_folio_idx--;
+
+		trace_xfarray_sort_scan(si, idx);
 	}
 
 	/*
-	 * If we don't have a cached page (and we know the load is contained
-	 * in a single page) then grab it.
+	 * If this folio still doesn't cover the desired element, it must cross
+	 * a folio boundary.  Read into the scratchpad and we're done.
 	 */
-	if (!xfile_page_cached(&si->xfpage)) {
-		if (xfarray_sort_terminated(si, &error))
-			return error;
+	if (idx < si->first_folio_idx || idx > si->last_folio_idx) {
+		void		*temp = xfarray_scratch(si->array);
 
-		error = xfarray_sort_get_page(si, startpage << PAGE_SHIFT,
-				PAGE_SIZE);
+		error = xfile_load(si->array->xfile, temp, si->array->obj_size,
+				idx_pos);
 		if (error)
 			return error;
+
+		*ptrp = temp;
+		return 0;
 	}
 
-	memcpy(ptr, page_address(si->xfpage.page) + offset_in_page(idx_pos),
-			si->array->obj_size);
+	/* Otherwise return a pointer to the array element in the folio. */
+	*ptrp = folio_address(si->folio) + offset_in_folio(si->folio, idx_pos);
 	return 0;
 }
 
@@ -937,6 +924,8 @@ xfarray_sort(
 	pivot = xfarray_sortinfo_pivot(si);
 
 	while (si->stack_depth >= 0) {
+		int		ret;
+
 		lo = si_lo[si->stack_depth];
 		hi = si_hi[si->stack_depth];
 
@@ -949,13 +938,13 @@ xfarray_sort(
 		}
 
 		/*
-		 * If directly mapping the page and sorting can solve our
+		 * If directly mapping the folio and sorting can solve our
 		 * problems, we're done.
 		 */
-		if (xfarray_want_pagesort(si, lo, hi)) {
-			error = xfarray_pagesort(si, lo, hi);
-			if (error)
-				goto out_free;
+		ret = xfarray_foliosort(si, lo, hi);
+		if (ret < 0)
+			goto out_free;
+		if (ret == 1) {
 			si->stack_depth--;
 			continue;
 		}
@@ -980,25 +969,24 @@ xfarray_sort(
 		 * than the pivot is on the right side of the range.
 		 */
 		while (lo < hi) {
+			void	*p;
+
 			/*
 			 * Decrement hi until it finds an a[hi] less than the
 			 * pivot value.
 			 */
-			error = xfarray_sort_load_cached(si, hi, scratch);
+			error = xfarray_sort_scan(si, hi, &p);
 			if (error)
 				goto out_free;
-			while (xfarray_sort_cmp(si, scratch, pivot) >= 0 &&
-								lo < hi) {
+			while (xfarray_sort_cmp(si, p, pivot) >= 0 && lo < hi) {
 				hi--;
-				error = xfarray_sort_load_cached(si, hi,
-						scratch);
+				error = xfarray_sort_scan(si, hi, &p);
 				if (error)
 					goto out_free;
 			}
-			error = xfarray_sort_put_page(si);
-			if (error)
-				goto out_free;
-
+			if (p != scratch)
+				memcpy(scratch, p, si->array->obj_size);
+			xfarray_sort_scan_done(si);
 			if (xfarray_sort_terminated(si, &error))
 				goto out_free;
 
@@ -1013,21 +1001,18 @@ xfarray_sort(
 			 * Increment lo until it finds an a[lo] greater than
 			 * the pivot value.
 			 */
-			error = xfarray_sort_load_cached(si, lo, scratch);
+			error = xfarray_sort_scan(si, lo, &p);
 			if (error)
 				goto out_free;
-			while (xfarray_sort_cmp(si, scratch, pivot) <= 0 &&
-								lo < hi) {
+			while (xfarray_sort_cmp(si, p, pivot) <= 0 && lo < hi) {
 				lo++;
-				error = xfarray_sort_load_cached(si, lo,
-						scratch);
+				error = xfarray_sort_scan(si, lo, &p);
 				if (error)
 					goto out_free;
 			}
-			error = xfarray_sort_put_page(si);
-			if (error)
-				goto out_free;
-
+			if (p != scratch)
+				memcpy(scratch, p, si->array->obj_size);
+			xfarray_sort_scan_done(si);
 			if (xfarray_sort_terminated(si, &error))
 				goto out_free;
 
diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index 6f2862054e194d..ec643cc9fc1432 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -105,8 +105,14 @@ struct xfarray_sortinfo {
 	/* XFARRAY_SORT_* flags; see below. */
 	unsigned int		flags;
 
-	/* Cache a page here for faster access. */
-	struct xfile_page	xfpage;
+	/* Cache a folio here for faster scanning for pivots */
+	struct folio		*folio;
+
+	/* First array index in folio that is completely readable */
+	xfarray_idx_t		first_folio_idx;
+
+	/* Last array index in folio that is completely readable */
+	xfarray_idx_t		last_folio_idx;
 
 #ifdef DEBUG
 	/* Performance statistics. */
-- 
2.39.2

