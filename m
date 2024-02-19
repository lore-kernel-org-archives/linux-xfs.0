Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3C7200AB
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324091; cv=none; b=E1HBV6ORY4vOCBMQq9qGOSE3qJgFudkw+cBG38j+4DfJAWe2oiNoGpgRTUGFGNs+Gh1O72ofHon+/E5kJsPBFWqhg9SDN7IygjoF63iHSrbkzbQ+pnluNw0uHBBYRNHmqZjEMD+Y6LXKSYIg+PxsyF9P4Y3OmuaIoKWeM+C/lZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324091; c=relaxed/simple;
	bh=0+bZzqg0lKcm58nXvKSSFAgrUm87iRxndedhQzOQYkc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fz27E7ixBqPClyqeYe/JqzyP8yWIA01rVgVMLPbOXBU94/Rhesul3vscAnqtB6gUj3rWGwgdZIj2a5/t9CLqqyYkWk1XCJhRU+85+kqnlX5ysEXgfP4kGkKJspZ1nfZyppOfRywgsvrevyz1Lv8sAcWuRKoKT52TH8WxVVinRHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b89o2NlW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b89o2NlW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BY9QXf9JYyzFQugvtu1qyaPY3i+2wGC3CEzX5n8IPFA=; b=b89o2NlWaoioaDR5zmAs4ZFj8r
	9YQxn3xFdPdkmjpth/4Aq/DaMyJnREdJw8lvyo5PULsUUY7WR9gmwtoMTA3arynwHaDyE4BTO0Uvy
	cai2kbr/mkeSX16B/hvUjDTredgAvWEx+sAaqrv/w4U1oAxAEtPbLeamS3QrzLrs0s7mFfeVnVz2p
	jQ/QAGooUSg4oEg6BnXb1iUA3ihNuWCKyM0XX/mn639FB2etByX9cwvriD2ax8Tt7KkzxwJ0V/yI2
	j1cRlvPGphGa95NE+kugmLfhI5Xy1pIF8aeKBBm+xrH3OrzURd1dC2a5M6/9mFylrmNXk//XUNi1o
	o1euaQjA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx8K-00000009FMe-2iEY;
	Mon, 19 Feb 2024 06:28:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 18/22] xfs: add file_{get,put}_folio
Date: Mon, 19 Feb 2024 07:27:26 +0100
Message-Id: <20240219062730.3031391-19-hch@lst.de>
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

Add helper similar to file_{get,set}_page, but which deal with folios
and don't allocate new folio unless explicitly asked to, which map
to shmem_get_folio instead of calling into the aops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/xfs/scrub/trace.h |  2 ++
 fs/xfs/scrub/xfile.c | 74 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfile.h |  7 +++++
 3 files changed, 83 insertions(+)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0327cab606b070..c61fa7a95ef522 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -908,6 +908,8 @@ DEFINE_XFILE_EVENT(xfile_store);
 DEFINE_XFILE_EVENT(xfile_seek_data);
 DEFINE_XFILE_EVENT(xfile_get_page);
 DEFINE_XFILE_EVENT(xfile_put_page);
+DEFINE_XFILE_EVENT(xfile_get_folio);
+DEFINE_XFILE_EVENT(xfile_put_folio);
 
 TRACE_EVENT(xfarray_create,
 	TP_PROTO(struct xfarray *xfa, unsigned long long required_capacity),
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 2229f0b7f9ca49..0cab9d529365bb 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -340,3 +340,77 @@ xfile_put_page(
 		return -EIO;
 	return 0;
 }
+
+/*
+ * Grab the (locked) folio for a memory object.  The object cannot span a folio
+ * boundary.  Returns the locked folio if successful, NULL if there was no
+ * folio or it didn't cover the range requested, or an ERR_PTR on failure.
+ */
+struct folio *
+xfile_get_folio(
+	struct xfile		*xf,
+	loff_t			pos,
+	size_t			len,
+	unsigned int		flags)
+{
+	struct inode		*inode = file_inode(xf->file);
+	struct folio		*folio = NULL;
+	unsigned int		pflags;
+	int			error;
+
+	if (inode->i_sb->s_maxbytes - pos < len)
+		return ERR_PTR(-ENOMEM);
+
+	trace_xfile_get_folio(xf, pos, len);
+
+	/*
+	 * Increase the file size first so that shmem_get_folio(..., SGP_CACHE),
+	 * actually allocates a folio instead of erroring out.
+	 */
+	if ((flags & XFILE_ALLOC) && pos + len > i_size_read(inode))
+		i_size_write(inode, pos + len);
+
+	pflags = memalloc_nofs_save();
+	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
+			(flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ);
+	memalloc_nofs_restore(pflags);
+	if (error)
+		return ERR_PTR(error);
+
+	if (!folio)
+		return NULL;
+
+	if (len > folio_size(folio) - offset_in_folio(folio, pos)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return NULL;
+	}
+
+	if (filemap_check_wb_err(inode->i_mapping, 0)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return ERR_PTR(-EIO);
+	}
+
+	/*
+	 * Mark the folio dirty so that it won't be reclaimed once we drop the
+	 * (potentially last) reference in xfile_put_folio.
+	 */
+	if (flags & XFILE_ALLOC)
+		folio_set_dirty(folio);
+	return folio;
+}
+
+/*
+ * Release the (locked) folio for a memory object.
+ */
+void
+xfile_put_folio(
+	struct xfile		*xf,
+	struct folio		*folio)
+{
+	trace_xfile_put_folio(xf, folio_pos(folio), folio_size(folio));
+
+	folio_unlock(folio);
+	folio_put(folio);
+}
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index 465b10f492b66d..afb75e9fbaf265 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -39,4 +39,11 @@ int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
 		struct xfile_page *xbuf);
 int xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
 
+#define XFILE_MAX_FOLIO_SIZE	(PAGE_SIZE << MAX_PAGECACHE_ORDER)
+
+#define XFILE_ALLOC		(1 << 0) /* allocate folio if not present */
+struct folio *xfile_get_folio(struct xfile *xf, loff_t offset, size_t len,
+		unsigned int flags);
+void xfile_put_folio(struct xfile *xf, struct folio *folio);
+
 #endif /* __XFS_SCRUB_XFILE_H__ */
-- 
2.39.2

