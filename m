Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13A618624
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n+GzgA/k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=orc4sDPnUZ3Lccm/B6rTrhsCMlqZK+iu/EE2SUS4e2U=; b=n+GzgA/kQKjoT1o7TFuYb6U+mY
	2r1k5HWS+z8KR+UrIMzGBOw/euuNtFAlFREzn90l7YxOS/oWws//aFDVedH7D/Y05nXAE4Rs0cwe6
	xLRHrU74CmDqVaXe++XJ1uMS5VysD2wTcSMQ5boV4HocrbDxGKcJvwg6Pu/FVxlMVlPQ44izVghn+
	CdJxq1rLrE6kyHh25rlH4D//HAhNUs9xma+lkEclJ7mNGsJHJjjVbg5Fj+EUvaXpzp8bqh7dhxMuW
	522k/yfXroJDfUYjBQXugC/Sobix6H6s8ntMWHEHXSJxhuDlQwqtRCIY3reTFofafVYyCV66yi7AD
	WGB7pOaw==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwpZ-00A6r7-19;
	Wed, 03 Jan 2024 08:42:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/15] xfs: use shmem_get_folio in xfile_get_page
Date: Wed,  3 Jan 2024 08:41:22 +0000
Message-Id: <20240103084126.513354-12-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103084126.513354-1-hch@lst.de>
References: <20240103084126.513354-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Switch to using shmem_get_folio and manually dirtying the page instead
of abusing aops->write_begin and aops->write_end in xfile_get_page.

This simplified the code by not doing indirect calls of not actually
exported interfaces that don't really fit the use case very well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfarray.c | 32 +++++-----------
 fs/xfs/scrub/xfile.c   | 84 +++++++++++++-----------------------------
 fs/xfs/scrub/xfile.h   |  2 +-
 3 files changed, 37 insertions(+), 81 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index c29a240d4e25f4..c6e62c119148a1 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -574,13 +574,12 @@ xfarray_sort_get_page(
 }
 
 /* Release a page we grabbed for sorting records. */
-static inline int
+static inline void
 xfarray_sort_put_page(
 	struct xfarray_sortinfo	*si)
 {
-	if (!xfile_page_cached(&si->xfpage))
-		return 0;
-	return xfile_put_page(si->array->xfile, &si->xfpage);
+	if (xfile_page_cached(&si->xfpage))
+		xfile_put_page(si->array->xfile, &si->xfpage);
 }
 
 /* Decide if these records are eligible for in-page sorting. */
@@ -626,7 +625,8 @@ xfarray_pagesort(
 	sort(startp, hi - lo + 1, si->array->obj_size, si->cmp_fn, NULL);
 
 	xfarray_sort_bump_stores(si);
-	return xfarray_sort_put_page(si);
+	xfarray_sort_put_page(si);
+	return 0;
 }
 
 /* Return a pointer to the xfarray pivot record within the sortinfo struct. */
@@ -836,10 +836,7 @@ xfarray_sort_load_cached(
 	startpage = idx_pos >> PAGE_SHIFT;
 	endpage = (idx_pos + si->array->obj_size - 1) >> PAGE_SHIFT;
 	if (startpage != endpage) {
-		error = xfarray_sort_put_page(si);
-		if (error)
-			return error;
-
+		xfarray_sort_put_page(si);
 		if (xfarray_sort_terminated(si, &error))
 			return error;
 
@@ -849,11 +846,8 @@ xfarray_sort_load_cached(
 
 	/* If the cached page is not the one we want, release it. */
 	if (xfile_page_cached(&si->xfpage) &&
-	    xfile_page_index(&si->xfpage) != startpage) {
-		error = xfarray_sort_put_page(si);
-		if (error)
-			return error;
-	}
+	    xfile_page_index(&si->xfpage) != startpage)
+		xfarray_sort_put_page(si);
 
 	/*
 	 * If we don't have a cached page (and we know the load is contained
@@ -995,10 +989,7 @@ xfarray_sort(
 				if (error)
 					goto out_free;
 			}
-			error = xfarray_sort_put_page(si);
-			if (error)
-				goto out_free;
-
+			xfarray_sort_put_page(si);
 			if (xfarray_sort_terminated(si, &error))
 				goto out_free;
 
@@ -1024,10 +1015,7 @@ xfarray_sort(
 				if (error)
 					goto out_free;
 			}
-			error = xfarray_sort_put_page(si);
-			if (error)
-				goto out_free;
-
+			xfarray_sort_put_page(si);
 			if (xfarray_sort_terminated(si, &error))
 				goto out_free;
 
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index afbd205289e9b0..2b4b0c4e8d2fb6 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -278,11 +278,8 @@ xfile_get_page(
 	struct xfile_page	*xfpage)
 {
 	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	const struct address_space_operations *aops = mapping->a_ops;
-	struct page		*page = NULL;
-	void			*fsdata = NULL;
-	loff_t			key = round_down(pos, PAGE_SIZE);
+	struct folio		*folio = NULL;
+	struct page		*page;
 	unsigned int		pflags;
 	int			error;
 
@@ -293,78 +290,49 @@ xfile_get_page(
 
 	trace_xfile_get_page(xf, pos, len);
 
-	pflags = memalloc_nofs_save();
-
 	/*
-	 * We call write_begin directly here to avoid all the freezer
-	 * protection lock-taking that happens in the normal path.  shmem
-	 * doesn't support fs freeze, but lockdep doesn't know that and will
-	 * trip over that.
+	 * Increase the file size first so that shmem_get_folio(..., SGP_CACHE),
+	 * actually allocates a folio instead of erroring out.
 	 */
-	error = aops->write_begin(NULL, mapping, key, PAGE_SIZE, &page,
-			&fsdata);
-	if (error)
-		goto out_pflags;
-
-	/* We got the page, so make sure we push out EOF. */
-	if (i_size_read(inode) < pos + len)
+	if (pos + len > i_size_read(inode))
 		i_size_write(inode, pos + len);
 
-	/*
-	 * If the page isn't up to date, fill it with zeroes before we hand it
-	 * to the caller and make sure the backing store will hold on to them.
-	 */
-	if (!PageUptodate(page)) {
-		memset(page_address(page), 0, PAGE_SIZE);
-		SetPageUptodate(page);
+	pflags = memalloc_nofs_save();
+	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio, SGP_CACHE);
+	memalloc_nofs_restore(pflags);
+	if (error)
+		return error;
+
+	page = folio_file_page(folio, pos >> PAGE_SHIFT);
+	if (PageHWPoison(page)) {
+		folio_put(folio);
+		return -EIO;
 	}
 
 	/*
-	 * Mark each page dirty so that the contents are written to some
-	 * backing store when we drop this buffer, and take an extra reference
-	 * to prevent the xfile page from being swapped or removed from the
-	 * page cache by reclaim if the caller unlocks the page.
+	 * Mark the page dirty so that it won't be reclaimed once we drop the
+	 * (potentially last) reference in xfile_put_page.
 	 */
 	set_page_dirty(page);
-	get_page(page);
 
 	xfpage->page = page;
-	xfpage->fsdata = fsdata;
-	xfpage->pos = key;
-out_pflags:
-	memalloc_nofs_restore(pflags);
-	return error;
+	xfpage->fsdata = NULL;
+	xfpage->pos = round_down(pos, PAGE_SIZE);
+	return 0;
 }
 
 /*
- * Release the (locked) page for a memory object.  Returns 0 or a negative
- * errno.
+ * Release the (locked) page for a memory object.
  */
-int
+void
 xfile_put_page(
 	struct xfile		*xf,
 	struct xfile_page	*xfpage)
 {
-	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	const struct address_space_operations *aops = mapping->a_ops;
-	unsigned int		pflags;
-	int			ret;
-
-	trace_xfile_put_page(xf, xfpage->pos, PAGE_SIZE);
+	struct page		*page = xfpage->page;
 
-	/* Give back the reference that we took in xfile_get_page. */
-	put_page(xfpage->page);
+	trace_xfile_put_page(xf, page->index << PAGE_SHIFT, PAGE_SIZE);
 
-	pflags = memalloc_nofs_save();
-	ret = aops->write_end(NULL, mapping, xfpage->pos, PAGE_SIZE, PAGE_SIZE,
-			xfpage->page, xfpage->fsdata);
-	memalloc_nofs_restore(pflags);
-	memset(xfpage, 0, sizeof(struct xfile_page));
-
-	if (ret < 0)
-		return ret;
-	if (ret != PAGE_SIZE)
-		return -EIO;
-	return 0;
+	unlock_page(page);
+	put_page(page);
 }
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index f0e11febf216a7..2f46b7d694ce99 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -37,6 +37,6 @@ loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
 
 int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
 		struct xfile_page *xbuf);
-int xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
+void xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
 
 #endif /* __XFS_SCRUB_XFILE_H__ */
-- 
2.39.2

