Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3548518624
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ASgrEkYJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=M25YP3MJC0WFFEaqgM6Rn4ZAWOo1a5MeaBp1CQxHNmw=; b=ASgrEkYJahD24JFHCFFv1risR2
	oaQSwrUG1J3jk2Fby1ONeoxdFWtN3P7bJ3MCNz3X366hZyq+TY908FlopxKFeQZs9x0d85VR0xNgy
	864Wa1ycDqTVMx2ogz1UxwnXGcE/9ZwcisG1gvLNIIeTGvTAa1X0NIDNnodkUgYDcr6tl7cPwFXkR
	OBj2j33t21gfgKbk6zEe+l0bGaksdiiccMBjUVUufMd6riDPp9S213QX1HCsouYfmphtDekvsQQts
	6OAHzgyHvMEshN6L2LrR+P7FEJKXV9/CiQVtmZ8PmfX7LxIYzTz7jemrOdPj4UisT/fm/eXauy1qD
	YEeyz9Fg==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwpe-00A6sq-38;
	Wed, 03 Jan 2024 08:42:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 12/15] xfs: remove struct xfile_page
Date: Wed,  3 Jan 2024 08:41:23 +0000
Message-Id: <20240103084126.513354-13-hch@lst.de>
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

Return the shmem page directly from xfile_page_get and pass it back
to xfile_page.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfarray.c | 23 +++++++++++++++--------
 fs/xfs/scrub/xfarray.h |  2 +-
 fs/xfs/scrub/xfile.c   | 27 ++++++++++-----------------
 fs/xfs/scrub/xfile.h   | 21 ++-------------------
 4 files changed, 28 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index c6e62c119148a1..4f396462186793 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -570,7 +570,13 @@ xfarray_sort_get_page(
 	loff_t			pos,
 	uint64_t		len)
 {
-	return xfile_get_page(si->array->xfile, pos, len, &si->xfpage);
+	struct page		*page;
+
+	page = xfile_get_page(si->array->xfile, pos, len);
+	if (IS_ERR(page))
+		return PTR_ERR(page);
+	si->page = page;
+	return 0;
 }
 
 /* Release a page we grabbed for sorting records. */
@@ -578,8 +584,10 @@ static inline void
 xfarray_sort_put_page(
 	struct xfarray_sortinfo	*si)
 {
-	if (xfile_page_cached(&si->xfpage))
-		xfile_put_page(si->array->xfile, &si->xfpage);
+	if (si->page) {
+		xfile_put_page(si->array->xfile, si->page);
+		si->page = NULL;
+	}
 }
 
 /* Decide if these records are eligible for in-page sorting. */
@@ -621,7 +629,7 @@ xfarray_pagesort(
 		return error;
 
 	xfarray_sort_bump_heapsorts(si);
-	startp = page_address(si->xfpage.page) + offset_in_page(lo_pos);
+	startp = page_address(si->page) + offset_in_page(lo_pos);
 	sort(startp, hi - lo + 1, si->array->obj_size, si->cmp_fn, NULL);
 
 	xfarray_sort_bump_stores(si);
@@ -845,15 +853,14 @@ xfarray_sort_load_cached(
 	}
 
 	/* If the cached page is not the one we want, release it. */
-	if (xfile_page_cached(&si->xfpage) &&
-	    xfile_page_index(&si->xfpage) != startpage)
+	if (si->page && si->page->index != startpage)
 		xfarray_sort_put_page(si);
 
 	/*
 	 * If we don't have a cached page (and we know the load is contained
 	 * in a single page) then grab it.
 	 */
-	if (!xfile_page_cached(&si->xfpage)) {
+	if (!si->page) {
 		if (xfarray_sort_terminated(si, &error))
 			return error;
 
@@ -863,7 +870,7 @@ xfarray_sort_load_cached(
 			return error;
 	}
 
-	memcpy(ptr, page_address(si->xfpage.page) + offset_in_page(idx_pos),
+	memcpy(ptr, page_address(si->page) + offset_in_page(idx_pos),
 			si->array->obj_size);
 	return 0;
 }
diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index 6f2862054e194d..5765f2ad30d885 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -106,7 +106,7 @@ struct xfarray_sortinfo {
 	unsigned int		flags;
 
 	/* Cache a page here for faster access. */
-	struct xfile_page	xfpage;
+	struct page		*page;
 
 #ifdef DEBUG
 	/* Performance statistics. */
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 2b4b0c4e8d2fb6..715c4d10b67c14 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -267,15 +267,14 @@ xfile_seek_data(
 
 /*
  * Grab the (locked) page for a memory object.  The object cannot span a page
- * boundary.  Returns 0 (and a locked page) if successful, -ENOTBLK if we
- * cannot grab the page, or the usual negative errno.
+ * boundary.  Returns 0 the locked page if successful, or an ERR_PTR on
+ * failure.
  */
-int
+struct page *
 xfile_get_page(
 	struct xfile		*xf,
 	loff_t			pos,
-	unsigned int		len,
-	struct xfile_page	*xfpage)
+	unsigned int		len)
 {
 	struct inode		*inode = file_inode(xf->file);
 	struct folio		*folio = NULL;
@@ -284,9 +283,9 @@ xfile_get_page(
 	int			error;
 
 	if (inode->i_sb->s_maxbytes - pos < len)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	if (len > PAGE_SIZE - offset_in_page(pos))
-		return -ENOTBLK;
+		return ERR_PTR(-ENOTBLK);
 
 	trace_xfile_get_page(xf, pos, len);
 
@@ -301,12 +300,12 @@ xfile_get_page(
 	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio, SGP_CACHE);
 	memalloc_nofs_restore(pflags);
 	if (error)
-		return error;
+		return ERR_PTR(error);
 
 	page = folio_file_page(folio, pos >> PAGE_SHIFT);
 	if (PageHWPoison(page)) {
 		folio_put(folio);
-		return -EIO;
+		return ERR_PTR(-EIO);
 	}
 
 	/*
@@ -314,11 +313,7 @@ xfile_get_page(
 	 * (potentially last) reference in xfile_put_page.
 	 */
 	set_page_dirty(page);
-
-	xfpage->page = page;
-	xfpage->fsdata = NULL;
-	xfpage->pos = round_down(pos, PAGE_SIZE);
-	return 0;
+	return page;
 }
 
 /*
@@ -327,10 +322,8 @@ xfile_get_page(
 void
 xfile_put_page(
 	struct xfile		*xf,
-	struct xfile_page	*xfpage)
+	struct page		*page)
 {
-	struct page		*page = xfpage->page;
-
 	trace_xfile_put_page(xf, page->index << PAGE_SHIFT, PAGE_SIZE);
 
 	unlock_page(page);
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index 2f46b7d694ce99..993368b37b4b7c 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -6,22 +6,6 @@
 #ifndef __XFS_SCRUB_XFILE_H__
 #define __XFS_SCRUB_XFILE_H__
 
-struct xfile_page {
-	struct page		*page;
-	void			*fsdata;
-	loff_t			pos;
-};
-
-static inline bool xfile_page_cached(const struct xfile_page *xfpage)
-{
-	return xfpage->page != NULL;
-}
-
-static inline pgoff_t xfile_page_index(const struct xfile_page *xfpage)
-{
-	return xfpage->page->index;
-}
-
 struct xfile {
 	struct file		*file;
 };
@@ -35,8 +19,7 @@ int xfile_obj_store(struct xfile *xf, const void *buf, size_t count,
 
 loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
 
-int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
-		struct xfile_page *xbuf);
-void xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
+struct page *xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len);
+void xfile_put_page(struct xfile *xf, struct page *page);
 
 #endif /* __XFS_SCRUB_XFILE_H__ */
-- 
2.39.2

