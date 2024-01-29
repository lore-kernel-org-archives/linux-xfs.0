Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C628A153508
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538941; cv=none; b=bIwlMBt7OK+4+Sio1pM4MQ+V97SWKtftsS/rOhsUTGPBGPTRZH2fs/zcwRs7j5Zk532M50kuS5Us9Vdi9AnXCa1iMza26PCOjksbh2evUYbxAaBWj4VAeKppV9f9RQKoFeTkn5unAvSR7O7y1coaKrMaUjcuioqbjxLEKVNZTTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538941; c=relaxed/simple;
	bh=+7qKOw6CRhV4MnOzRXGcH9nP4Sj56KrWviI+iNxw2+g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OghW7sZjYOTnnj/dRPuna7LAhcBFVZCR9hO6GEm3etdC8+Wdj71idJzOeGRV83Clxc9b9IDPqVZIoUubJCEDI3fEtscKhyx+cfR41LNQd44zdN8UXcVeINPxpXj3UHf7a4l5+AT1F1Ton8aoEmMmVrsQIDSaGclUVZLIW8JKOXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kj9jwzgH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kj9jwzgH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UlrBswDRelEXcgNVOaWvSi/EUS+jJGBmCPE4n+9PxvU=; b=kj9jwzgH1z5ubr1AKZwgByeVZE
	1MJdXgQc+Z1jipsrPKvENHUkhLNswtsHRbMvdEjgBgdsyj6kFGcATJ+0Ut4CeZSiBq2moNq9RvjJ9
	XHdgnlhYeuphXSTOOoWyigtHMgl+zpptq2gwMJsssrp07nlMbqVAPeVE08ULq8s8qvsS+5bMdkDst
	WK2283IsgCT01lZRMZMrCtVEQa1yIQU9RbVwSB4SedBRXyeGkpjHFvhQcst/oObBCqbM1jqeaO9Sm
	k/qwjh3L8CnnUgW16ac7jG1r/3EV7AjcxKPMzapb4uskp7l5Y9iCjcU8hGxY5lndaJdZdxIBBIapA
	LT0WHEPQ==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjZ-0000000D6Fi-2zlr;
	Mon, 29 Jan 2024 14:35:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/20] xfs: remove the xfile_pread/pwrite APIs
Date: Mon, 29 Jan 2024 15:34:51 +0100
Message-Id: <20240129143502.189370-10-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129143502.189370-1-hch@lst.de>
References: <20240129143502.189370-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All current and pending xfile users use the xfile_obj_load
and xfile_obj_store API, so make those the actual implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 .../xfs/xfs-online-fsck-design.rst            | 23 +++-----
 fs/xfs/scrub/rtsummary.c                      |  6 +--
 fs/xfs/scrub/trace.h                          |  4 +-
 fs/xfs/scrub/xfarray.c                        | 18 +++----
 fs/xfs/scrub/xfile.c                          | 54 +++++++++----------
 fs/xfs/scrub/xfile.h                          | 32 +----------
 6 files changed, 48 insertions(+), 89 deletions(-)

diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 352516feef6ffe..216c99ce511f7c 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -1915,19 +1915,13 @@ four of those five higher level data structures.
 The fifth use case is discussed in the :ref:`realtime summary <rtsummary>` case
 study.
 
-The most general storage interface supported by the xfile enables the reading
-and writing of arbitrary quantities of data at arbitrary offsets in the xfile.
-This capability is provided by ``xfile_pread`` and ``xfile_pwrite`` functions,
-which behave similarly to their userspace counterparts.
 XFS is very record-based, which suggests that the ability to load and store
 complete records is important.
-To support these cases, a pair of ``xfile_obj_load`` and ``xfile_obj_store``
-functions are provided to read and persist objects into an xfile.
-They are internally the same as pread and pwrite, except that they treat any
-error as an out of memory error.
-For online repair, squashing error conditions in this manner is an acceptable
-behavior because the only reaction is to abort the operation back to userspace.
-All five xfile usecases can be serviced by these four functions.
+To support these cases, a pair of ``xfile_load`` and ``xfile_store``
+functions are provided to read and persist objects into an xfile that treat any
+error as an out of memory error.  For online repair, squashing error conditions
+in this manner is an acceptable behavior because the only reaction is to abort
+the operation back to userspace.
 
 However, no discussion of file access idioms is complete without answering the
 question, "But what about mmap?"
@@ -1939,10 +1933,9 @@ tmpfs can only push a pagecache folio to the swap cache if the folio is neither
 pinned nor locked, which means the xfile must not pin too many folios.
 
 Short term direct access to xfile contents is done by locking the pagecache
-folio and mapping it into kernel address space.
-Programmatic access (e.g. pread and pwrite) uses this mechanism.
-Folio locks are not supposed to be held for long periods of time, so long
-term direct access to xfile contents is done by bumping the folio refcount,
+folio and mapping it into kernel address space.  Object load and store uses this
+mechanism.  Folio locks are not supposed to be held for long periods of time, so
+long term direct access to xfile contents is done by bumping the folio refcount,
 mapping it into kernel address space, and dropping the folio lock.
 These long term users *must* be responsive to memory reclaim by hooking into
 the shrinker infrastructure to know when to release folios.
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index fabd0ed9dfa676..30b5a3952513f8 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -118,7 +118,7 @@ xfsum_load(
 	xfs_rtsumoff_t		sumoff,
 	union xfs_suminfo_raw	*rawinfo)
 {
-	return xfile_obj_load(sc->xfile, rawinfo,
+	return xfile_load(sc->xfile, rawinfo,
 			sizeof(union xfs_suminfo_raw),
 			sumoff << XFS_WORDLOG);
 }
@@ -129,7 +129,7 @@ xfsum_store(
 	xfs_rtsumoff_t		sumoff,
 	const union xfs_suminfo_raw rawinfo)
 {
-	return xfile_obj_store(sc->xfile, &rawinfo,
+	return xfile_store(sc->xfile, &rawinfo,
 			sizeof(union xfs_suminfo_raw),
 			sumoff << XFS_WORDLOG);
 }
@@ -141,7 +141,7 @@ xfsum_copyout(
 	union xfs_suminfo_raw	*rawinfo,
 	unsigned int		nr_words)
 {
-	return xfile_obj_load(sc->xfile, rawinfo, nr_words << XFS_WORDLOG,
+	return xfile_load(sc->xfile, rawinfo, nr_words << XFS_WORDLOG,
 			sumoff << XFS_WORDLOG);
 }
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 260b8fe0a80296..0327cab606b070 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -903,8 +903,8 @@ DECLARE_EVENT_CLASS(xfile_class,
 DEFINE_EVENT(xfile_class, name, \
 	TP_PROTO(struct xfile *xf, loff_t pos, unsigned long long bytecount), \
 	TP_ARGS(xf, pos, bytecount))
-DEFINE_XFILE_EVENT(xfile_pread);
-DEFINE_XFILE_EVENT(xfile_pwrite);
+DEFINE_XFILE_EVENT(xfile_load);
+DEFINE_XFILE_EVENT(xfile_store);
 DEFINE_XFILE_EVENT(xfile_seek_data);
 DEFINE_XFILE_EVENT(xfile_get_page);
 DEFINE_XFILE_EVENT(xfile_put_page);
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index f0f532c10a5acc..95ac14bceeadd6 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -136,7 +136,7 @@ xfarray_load(
 	if (idx >= array->nr)
 		return -ENODATA;
 
-	return xfile_obj_load(array->xfile, ptr, array->obj_size,
+	return xfile_load(array->xfile, ptr, array->obj_size,
 			xfarray_pos(array, idx));
 }
 
@@ -152,7 +152,7 @@ xfarray_is_unset(
 	if (array->unset_slots == 0)
 		return false;
 
-	error = xfile_obj_load(array->xfile, temp, array->obj_size, pos);
+	error = xfile_load(array->xfile, temp, array->obj_size, pos);
 	if (!error && xfarray_element_is_null(array, temp))
 		return true;
 
@@ -184,7 +184,7 @@ xfarray_unset(
 		return 0;
 
 	memset(temp, 0, array->obj_size);
-	error = xfile_obj_store(array->xfile, temp, array->obj_size, pos);
+	error = xfile_store(array->xfile, temp, array->obj_size, pos);
 	if (error)
 		return error;
 
@@ -209,7 +209,7 @@ xfarray_store(
 
 	ASSERT(!xfarray_element_is_null(array, ptr));
 
-	ret = xfile_obj_store(array->xfile, ptr, array->obj_size,
+	ret = xfile_store(array->xfile, ptr, array->obj_size,
 			xfarray_pos(array, idx));
 	if (ret)
 		return ret;
@@ -245,12 +245,12 @@ xfarray_store_anywhere(
 	for (pos = 0;
 	     pos < endpos && array->unset_slots > 0;
 	     pos += array->obj_size) {
-		error = xfile_obj_load(array->xfile, temp, array->obj_size,
+		error = xfile_load(array->xfile, temp, array->obj_size,
 				pos);
 		if (error || !xfarray_element_is_null(array, temp))
 			continue;
 
-		error = xfile_obj_store(array->xfile, ptr, array->obj_size,
+		error = xfile_store(array->xfile, ptr, array->obj_size,
 				pos);
 		if (error)
 			return error;
@@ -552,7 +552,7 @@ xfarray_isort(
 	trace_xfarray_isort(si, lo, hi);
 
 	xfarray_sort_bump_loads(si);
-	error = xfile_obj_load(si->array->xfile, scratch, len, lo_pos);
+	error = xfile_load(si->array->xfile, scratch, len, lo_pos);
 	if (error)
 		return error;
 
@@ -560,7 +560,7 @@ xfarray_isort(
 	sort(scratch, hi - lo + 1, si->array->obj_size, si->cmp_fn, NULL);
 
 	xfarray_sort_bump_stores(si);
-	return xfile_obj_store(si->array->xfile, scratch, len, lo_pos);
+	return xfile_store(si->array->xfile, scratch, len, lo_pos);
 }
 
 /* Grab a page for sorting records. */
@@ -858,7 +858,7 @@ xfarray_sort_load_cached(
 		if (xfarray_sort_terminated(si, &error))
 			return error;
 
-		return xfile_obj_load(si->array->xfile, ptr,
+		return xfile_load(si->array->xfile, ptr,
 				si->array->obj_size, idx_pos);
 	}
 
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 87654cdd5ac6f9..d65681372a7458 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -118,13 +118,11 @@ xfile_destroy(
 }
 
 /*
- * Read a memory object directly from the xfile's page cache.  Unlike regular
- * pread, we return -E2BIG and -EFBIG for reads that are too large or at too
- * high an offset, instead of truncating the read.  Otherwise, we return
- * bytes read or an error code, like regular pread.
+ * Load an object.  Since we're treating this file as "memory", any error or
+ * short IO is treated as a failure to allocate memory.
  */
-ssize_t
-xfile_pread(
+int
+xfile_load(
 	struct xfile		*xf,
 	void			*buf,
 	size_t			count,
@@ -133,16 +131,15 @@ xfile_pread(
 	struct inode		*inode = file_inode(xf->file);
 	struct address_space	*mapping = inode->i_mapping;
 	struct page		*page = NULL;
-	ssize_t			read = 0;
 	unsigned int		pflags;
 	int			error = 0;
 
 	if (count > MAX_RW_COUNT)
-		return -E2BIG;
+		return -ENOMEM;
 	if (inode->i_sb->s_maxbytes - pos < count)
-		return -EFBIG;
+		return -ENOMEM;
 
-	trace_xfile_pread(xf, pos, count);
+	trace_xfile_load(xf, pos, count);
 
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
@@ -160,8 +157,10 @@ xfile_pread(
 				__GFP_NOWARN);
 		if (IS_ERR(page)) {
 			error = PTR_ERR(page);
-			if (error != -ENOMEM)
+			if (error != -ENOMEM) {
+				error = -ENOMEM;
 				break;
+			}
 
 			memset(buf, 0, len);
 			goto advance;
@@ -185,23 +184,18 @@ xfile_pread(
 		count -= len;
 		pos += len;
 		buf += len;
-		read += len;
 	}
 	memalloc_nofs_restore(pflags);
 
-	if (read > 0)
-		return read;
 	return error;
 }
 
 /*
- * Write a memory object directly to the xfile's page cache.  Unlike regular
- * pwrite, we return -E2BIG and -EFBIG for writes that are too large or at too
- * high an offset, instead of truncating the write.  Otherwise, we return
- * bytes written or an error code, like regular pwrite.
+ * Store an object.  Since we're treating this file as "memory", any error or
+ * short IO is treated as a failure to allocate memory.
  */
-ssize_t
-xfile_pwrite(
+int
+xfile_store(
 	struct xfile		*xf,
 	const void		*buf,
 	size_t			count,
@@ -211,16 +205,15 @@ xfile_pwrite(
 	struct address_space	*mapping = inode->i_mapping;
 	const struct address_space_operations *aops = mapping->a_ops;
 	struct page		*page = NULL;
-	ssize_t			written = 0;
 	unsigned int		pflags;
 	int			error = 0;
 
 	if (count > MAX_RW_COUNT)
-		return -E2BIG;
+		return -ENOMEM;
 	if (inode->i_sb->s_maxbytes - pos < count)
-		return -EFBIG;
+		return -ENOMEM;
 
-	trace_xfile_pwrite(xf, pos, count);
+	trace_xfile_store(xf, pos, count);
 
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
@@ -239,8 +232,10 @@ xfile_pwrite(
 		 */
 		error = aops->write_begin(NULL, mapping, pos, len, &page,
 				&fsdata);
-		if (error)
+		if (error) {
+			error = -ENOMEM;
 			break;
+		}
 
 		/*
 		 * xfile pages must never be mapped into userspace, so we skip
@@ -259,13 +254,14 @@ xfile_pwrite(
 		ret = aops->write_end(NULL, mapping, pos, len, len, page,
 				fsdata);
 		if (ret < 0) {
-			error = ret;
+			error = -ENOMEM;
 			break;
 		}
 
-		written += ret;
-		if (ret != len)
+		if (ret != len) {
+			error = -ENOMEM;
 			break;
+		}
 
 		count -= ret;
 		pos += ret;
@@ -273,8 +269,6 @@ xfile_pwrite(
 	}
 	memalloc_nofs_restore(pflags);
 
-	if (written > 0)
-		return written;
 	return error;
 }
 
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index c602d11560d8ee..465b10f492b66d 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -29,38 +29,10 @@ struct xfile {
 int xfile_create(const char *description, loff_t isize, struct xfile **xfilep);
 void xfile_destroy(struct xfile *xf);
 
-ssize_t xfile_pread(struct xfile *xf, void *buf, size_t count, loff_t pos);
-ssize_t xfile_pwrite(struct xfile *xf, const void *buf, size_t count,
+int xfile_load(struct xfile *xf, void *buf, size_t count, loff_t pos);
+int xfile_store(struct xfile *xf, const void *buf, size_t count,
 		loff_t pos);
 
-/*
- * Load an object.  Since we're treating this file as "memory", any error or
- * short IO is treated as a failure to allocate memory.
- */
-static inline int
-xfile_obj_load(struct xfile *xf, void *buf, size_t count, loff_t pos)
-{
-	ssize_t	ret = xfile_pread(xf, buf, count, pos);
-
-	if (ret < 0 || ret != count)
-		return -ENOMEM;
-	return 0;
-}
-
-/*
- * Store an object.  Since we're treating this file as "memory", any error or
- * short IO is treated as a failure to allocate memory.
- */
-static inline int
-xfile_obj_store(struct xfile *xf, const void *buf, size_t count, loff_t pos)
-{
-	ssize_t	ret = xfile_pwrite(xf, buf, count, pos);
-
-	if (ret < 0 || ret != count)
-		return -ENOMEM;
-	return 0;
-}
-
 loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
 
 int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
-- 
2.39.2

