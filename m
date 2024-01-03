Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D9A1804D
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xUQFbdpu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=a2KU587OgqnObeCrGx0UU79uRQUUDAR8Cm6RFnFUOy8=; b=xUQFbdpubXfChe2Qx//ZD9lJ2P
	EeE0mcPqXp7XRhtFCs6ZAOL8/8PWfHGYYgHcgtGj+Fzgd7HuppaPAOICSanP3ICu3IBf8Gn46EDny
	vGtFDb4Jy5MWKnEPxQ5kfgpaNUvbPb4L/bHgjwkRmLkpTtVAPe7HS616Um4nVtGpQJdFYLmlUOkFD
	sbrY6co1D9btX06ldeHVaa0UyRZpOKdqP9J6HUa9NcP1TkCuYbPtpjOMShI8iUa3ET+CpxW8nxBKp
	nqXL4biGZR1oLOM2VZ3wLYrL0lr5RSL1190L0axmtIKXgaAQv0Gu83LaKNOR7W79v+U/uXOFXbGD/
	MtlAnNtQ==;
Received: from [89.144.222.185] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwpl-00A6wM-1M;
	Wed, 03 Jan 2024 08:42:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 13/15] xfs: don't unconditionally allocate a new page in xfile_get_page
Date: Wed,  3 Jan 2024 08:41:24 +0000
Message-Id: <20240103084126.513354-14-hch@lst.de>
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

Pass a flags argument to xfile_get_page, and only allocate a new page
if the XFILE_ALLOC flag is passed.  This allows to also use
xfile_get_page for pure readers that do not want to allocate a new
page or dirty the existing one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfarray.c |  2 +-
 fs/xfs/scrub/xfile.c   | 14 ++++++++++----
 fs/xfs/scrub/xfile.h   |  4 +++-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 4f396462186793..8543067d46366d 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -572,7 +572,7 @@ xfarray_sort_get_page(
 {
 	struct page		*page;
 
-	page = xfile_get_page(si->array->xfile, pos, len);
+	page = xfile_get_page(si->array->xfile, pos, len, XFILE_ALLOC);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 	si->page = page;
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 715c4d10b67c14..3ed7fb82a4497b 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -274,7 +274,8 @@ struct page *
 xfile_get_page(
 	struct xfile		*xf,
 	loff_t			pos,
-	unsigned int		len)
+	unsigned int		len,
+	unsigned int		flags)
 {
 	struct inode		*inode = file_inode(xf->file);
 	struct folio		*folio = NULL;
@@ -293,15 +294,19 @@ xfile_get_page(
 	 * Increase the file size first so that shmem_get_folio(..., SGP_CACHE),
 	 * actually allocates a folio instead of erroring out.
 	 */
-	if (pos + len > i_size_read(inode))
+	if ((flags & XFILE_ALLOC) && pos + len > i_size_read(inode))
 		i_size_write(inode, pos + len);
 
 	pflags = memalloc_nofs_save();
-	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio, SGP_CACHE);
+	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
+			(flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ);
 	memalloc_nofs_restore(pflags);
 	if (error)
 		return ERR_PTR(error);
 
+	if (!folio)
+		return NULL;
+
 	page = folio_file_page(folio, pos >> PAGE_SHIFT);
 	if (PageHWPoison(page)) {
 		folio_put(folio);
@@ -312,7 +317,8 @@ xfile_get_page(
 	 * Mark the page dirty so that it won't be reclaimed once we drop the
 	 * (potentially last) reference in xfile_put_page.
 	 */
-	set_page_dirty(page);
+	if (flags & XFILE_ALLOC)
+		set_page_dirty(page);
 	return page;
 }
 
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index 993368b37b4b7c..f0403ea869e4d0 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -19,7 +19,9 @@ int xfile_obj_store(struct xfile *xf, const void *buf, size_t count,
 
 loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
 
-struct page *xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len);
+#define XFILE_ALLOC		(1 << 0) /* allocate page if not present */
+struct page *xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
+		unsigned int flags);
 void xfile_put_page(struct xfile *xf, struct page *page);
 
 #endif /* __XFS_SCRUB_XFILE_H__ */
-- 
2.39.2

