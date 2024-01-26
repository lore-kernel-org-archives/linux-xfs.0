Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA40E1B97B
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275821; cv=none; b=P1SGtK+mIbQyAxazuGzIN9rZMLco7RTphFxT5q2i2yp3yeXv2oDTR1sWV7m60WV5V+hGXX5dVOe0jv3wi5DTpqEu6JGyolrB7P+IyywpQergPvGvOO7JMFBO11ltHgazcdfC6XAgjszpeYDzg4+aJz72dwHSlYsvdOQQ16W8JZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275821; c=relaxed/simple;
	bh=nn2g3CLyOMA9NdOnG5VXZrNGOmE3H2Qtg+3uUdS7a0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hysjsu2frnJbAmvSdJLFFaSJ1H9eRNinXnfKrRiZYEkh/y73Lf/vXaPFGLrAuHJbUKiW8keuniKg/8Cv3UELdzbKb+FssuXDV07PFBDgZO6jEZcRp/ozXVvWQHFNndShfAwWXzE94og6CiXenu2VWAbrJpSE3X94j6aEQ0qnHLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qIB7chEq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qIB7chEq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=X21Ew2yPXjed2nTt3K1ULzd8XdBx85Zv7/geftx1aII=; b=qIB7chEqXgv/83F5fXU4aGvZaF
	cd1gr+xzZw1byceF6Z11y2RibY9b3sEMHeiM85ZZzIL5byv2cYYlZdM05BTpxcd61Rcu8tqNYNs/i
	ojQ0/qtmksiPtgScHRplfmQi7MD/YEpH5s7CiBjxVuhxk3Wbgw93TfJq6FDsFZ3uJI3IJHD7EvKzC
	cDbJA8pcexmkTiJBDFHKdiCXdiG/X9HRYys7MiXf0ydJ5RIsL5QhMTac1wg71uQ50ggIgC0LfBqn/
	JELRJFtYSrnVxj22jJsPkF+yhbtPR2G5f7TJ/kJd/GUsZBwSLe0wsjDhiFUNJTmhLu1OaHRE7VfXO
	90Sx2HDw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMHi-00000004Cw5-0efr;
	Fri, 26 Jan 2024 13:30:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 17/21] xfs: add file_{get,put}_folio
Date: Fri, 26 Jan 2024 14:28:59 +0100
Message-Id: <20240126132903.2700077-18-hch@lst.de>
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

Add helper similar to file_{get,set}_page, but which deal with folios
and don't allocate new folio unless explicitly asked to, which map
to shmem_get_folio instead of calling into the aops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index 2d802c20a8ddfe..1c1db4ae1ba6ee 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -365,3 +365,77 @@ xfile_put_page(
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
+	if (xfile_has_lost_data(inode, folio)) {
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

