Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110D1200BA
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324102; cv=none; b=Xlhxy9FUPWiK4N/clG7XqGHLtu6L3GabRCCfdVHEukFb7AdG3id0A6BMZ69loBXlVZeIqzBd1eggUAs3lSYdY27qU+39SKP/jzIbl1cycmsH4s0xFNdSnJ49XVlzQhCDSNayeQrjc+Dlzddh+rOCfxNUpybRLWjCA+YTObamclI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324102; c=relaxed/simple;
	bh=qMVNlBybzFnvC72miM98mNTiYFBvX72Ku7cgGE7Fpsk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QdGTkmGsRt9c/7VBL/3BDjEmvYu2fe7rvBKjnkS6EBBTBLOPYLExRBe8TIOAJZMVka9qTRnnnTjTVVBbpbr9bySx3r9MvTf028PbQZurx5fN5DGBuFeV5zIvKUmSc9SyfZhTdGcBMkTz/+14DvQ5TyA22QqpfDaZN9eNBUhtwA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xvt4cAps; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xvt4cAps"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qB3oCZWTiw8s0dhbgJTiQSmqK066xuuSv3N8Ml/12ps=; b=Xvt4cAps3yUB3ZpxPI2FwzBr71
	D9zWDZQhcndLRxLFk/nIX23rHjupxFXz6sX5spx26rtfCfQ0tQxV/mfXJupb6OKPVLyKdtBay3Xv2
	kvP1k4WRCdYISYSKjtu1uIsy1jLE39bOhwbs1FpNpqeO69go0FqVhvEJzTyjaebIR9FksP28UH9cM
	Xs/Itv3B6JcR5NLq+iMUa2F3BIbIa3JfTC23Tga7XM/Y6zO/gN3W5GdhkCxzOYtEGaYArgOMq2R7I
	w0BAN4hy+wGEMKK+7CYademM08iRL+7A8lttU+Xu8GDvPtFJNrSyPVSQMQNGwYM5oWqu4eztAEAjA
	UtRlXxXQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx8U-00000009FQi-3ZFU;
	Mon, 19 Feb 2024 06:28:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 22/22] xfs: remove xfile_{get,put}_page
Date: Mon, 19 Feb 2024 07:27:30 +0100
Message-Id: <20240219062730.3031391-23-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219062730.3031391-1-hch@lst.de>
References: <20240219062730.3031391-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: "Darrick J. Wong" <djwong@kernel.org>

These functions aren't used anymore, so get rid of them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .../xfs/xfs-online-fsck-design.rst            |   2 +-
 fs/xfs/scrub/trace.h                          |   2 -
 fs/xfs/scrub/xfile.c                          | 104 ------------------
 fs/xfs/scrub/xfile.h                          |  20 ----
 4 files changed, 1 insertion(+), 127 deletions(-)

diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 216c99ce511f7c..d03480266e9b18 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -1940,7 +1940,7 @@ mapping it into kernel address space, and dropping the folio lock.
 These long term users *must* be responsive to memory reclaim by hooking into
 the shrinker infrastructure to know when to release folios.
 
-The ``xfile_get_page`` and ``xfile_put_page`` functions are provided to
+The ``xfile_get_folio`` and ``xfile_put_folio`` functions are provided to
 retrieve the (locked) folio that backs part of an xfile and to release it.
 The only code to use these folio lease functions are the xfarray
 :ref:`sorting<xfarray_sort>` algorithms and the :ref:`in-memory
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3a1a827828dcb9..ae6b2385a8cbe5 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -906,8 +906,6 @@ DEFINE_EVENT(xfile_class, name, \
 DEFINE_XFILE_EVENT(xfile_load);
 DEFINE_XFILE_EVENT(xfile_store);
 DEFINE_XFILE_EVENT(xfile_seek_data);
-DEFINE_XFILE_EVENT(xfile_get_page);
-DEFINE_XFILE_EVENT(xfile_put_page);
 DEFINE_XFILE_EVENT(xfile_get_folio);
 DEFINE_XFILE_EVENT(xfile_put_folio);
 
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 0cab9d529365bb..8cdd863db5850a 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -237,110 +237,6 @@ xfile_seek_data(
 	return ret;
 }
 
-/*
- * Grab the (locked) page for a memory object.  The object cannot span a page
- * boundary.  Returns 0 (and a locked page) if successful, -ENOTBLK if we
- * cannot grab the page, or the usual negative errno.
- */
-int
-xfile_get_page(
-	struct xfile		*xf,
-	loff_t			pos,
-	unsigned int		len,
-	struct xfile_page	*xfpage)
-{
-	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	const struct address_space_operations *aops = mapping->a_ops;
-	struct page		*page = NULL;
-	void			*fsdata = NULL;
-	loff_t			key = round_down(pos, PAGE_SIZE);
-	unsigned int		pflags;
-	int			error;
-
-	if (inode->i_sb->s_maxbytes - pos < len)
-		return -ENOMEM;
-	if (len > PAGE_SIZE - offset_in_page(pos))
-		return -ENOTBLK;
-
-	trace_xfile_get_page(xf, pos, len);
-
-	pflags = memalloc_nofs_save();
-
-	/*
-	 * We call write_begin directly here to avoid all the freezer
-	 * protection lock-taking that happens in the normal path.  shmem
-	 * doesn't support fs freeze, but lockdep doesn't know that and will
-	 * trip over that.
-	 */
-	error = aops->write_begin(NULL, mapping, key, PAGE_SIZE, &page,
-			&fsdata);
-	if (error)
-		goto out_pflags;
-
-	/* We got the page, so make sure we push out EOF. */
-	if (i_size_read(inode) < pos + len)
-		i_size_write(inode, pos + len);
-
-	/*
-	 * If the page isn't up to date, fill it with zeroes before we hand it
-	 * to the caller and make sure the backing store will hold on to them.
-	 */
-	if (!PageUptodate(page)) {
-		memset(page_address(page), 0, PAGE_SIZE);
-		SetPageUptodate(page);
-	}
-
-	/*
-	 * Mark each page dirty so that the contents are written to some
-	 * backing store when we drop this buffer, and take an extra reference
-	 * to prevent the xfile page from being swapped or removed from the
-	 * page cache by reclaim if the caller unlocks the page.
-	 */
-	set_page_dirty(page);
-	get_page(page);
-
-	xfpage->page = page;
-	xfpage->fsdata = fsdata;
-	xfpage->pos = key;
-out_pflags:
-	memalloc_nofs_restore(pflags);
-	return error;
-}
-
-/*
- * Release the (locked) page for a memory object.  Returns 0 or a negative
- * errno.
- */
-int
-xfile_put_page(
-	struct xfile		*xf,
-	struct xfile_page	*xfpage)
-{
-	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	const struct address_space_operations *aops = mapping->a_ops;
-	unsigned int		pflags;
-	int			ret;
-
-	trace_xfile_put_page(xf, xfpage->pos, PAGE_SIZE);
-
-	/* Give back the reference that we took in xfile_get_page. */
-	put_page(xfpage->page);
-
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
-}
-
 /*
  * Grab the (locked) folio for a memory object.  The object cannot span a folio
  * boundary.  Returns the locked folio if successful, NULL if there was no
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index afb75e9fbaf265..76d78dba7e3478 100644
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
@@ -35,10 +19,6 @@ int xfile_store(struct xfile *xf, const void *buf, size_t count,
 
 loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
 
-int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
-		struct xfile_page *xbuf);
-int xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
-
 #define XFILE_MAX_FOLIO_SIZE	(PAGE_SIZE << MAX_PAGECACHE_ORDER)
 
 #define XFILE_ALLOC		(1 << 0) /* allocate folio if not present */
-- 
2.39.2

