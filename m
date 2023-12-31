Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01165BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZiY9q4Rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD38C433C8;
	Sun, 31 Dec 2023 20:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055240;
	bh=8RS8CyCipd+oYAfa5kaPVsOPZLQjGk1tj6A8FV8dIGw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZiY9q4RpUpxcN8ZcWPjjf2RHKKPmCpjTJekZKRdZoBt8w6Ojg2vk6SmlSk+GbPhQB
	 eO9LiK6N8h1hA8Nln2BLnkobIk5clQhArMrK7JyBaaF4HAdf5UVOArZulSkZDI+Dma
	 kMoeTyjH4uGqa2pa5LnG7HwI8OicGl9S2Z5sDc3T90838iDK0X8o9g8QjDdYxuGMRL
	 DTPwhQQIWQRPtmHD4MvOsq23ErweIddkmwjCUevQ/0SmDSU8N7bd9tanF3gDw6Rn20
	 4pBsegi+ZgEFsqACb5Jm/9x6NBSF9E3QQ1cV6WkSDYKkO7y3h75xu2qe2FGDRvmAEY
	 mnMAYK+VdVmvw==
Date: Sun, 31 Dec 2023 12:40:40 -0800
Subject: [PATCH 3/3] xfile: implement write caching
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404837645.1754104.3271871045806193458.stgit@frogsfrogsfrogs>
In-Reply-To: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Mapping a page into the kernel's address space is expensive.  Since
the xfile contains an xfs_buf_cache object for xfbtrees and xfbtrees
aren't the only user of xfiles, we could reuse that space for a simple
MRU cache.

When there's enough metadata records being put in an xfarray/xfblob and
the fsck scans aren't IO bound, this cuts the runtime of online fsck by
about 5%.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h   |   44 +++++++
 fs/xfs/scrub/xfile.c   |  307 +++++++++++++++++++++++++++++++-----------------
 fs/xfs/scrub/xfile.h   |   23 +++-
 fs/xfs/xfs_buf_xfile.c |    7 +
 4 files changed, 273 insertions(+), 108 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3aa1ef6a371dd..8d863f4737e90 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -964,10 +964,52 @@ DEFINE_XFILE_EVENT(xfile_pread);
 DEFINE_XFILE_EVENT(xfile_pwrite);
 DEFINE_XFILE_EVENT(xfile_seek_data);
 DEFINE_XFILE_EVENT(xfile_get_page);
-DEFINE_XFILE_EVENT(xfile_put_page);
 DEFINE_XFILE_EVENT(xfile_discard);
 DEFINE_XFILE_EVENT(xfile_prealloc);
 
+DECLARE_EVENT_CLASS(xfile_page_class,
+	TP_PROTO(struct xfile *xf, loff_t pos, struct page *page),
+	TP_ARGS(xf, pos, page),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(unsigned long long, bytes_used)
+		__field(loff_t, pos)
+		__field(loff_t, size)
+		__field(unsigned long long, bytecount)
+		__field(pgoff_t, pgoff)
+	),
+	TP_fast_assign(
+		struct xfile_stat	statbuf;
+		int			ret;
+
+		ret = xfile_stat(xf, &statbuf);
+		if (!ret) {
+			__entry->bytes_used = statbuf.bytes;
+			__entry->size = statbuf.size;
+		} else {
+			__entry->bytes_used = -1;
+			__entry->size = -1;
+		}
+		__entry->ino = file_inode(xf->file)->i_ino;
+		__entry->pos = pos;
+		__entry->bytecount = page_size(page);
+		__entry->pgoff = page_offset(page);
+	),
+	TP_printk("xfino 0x%lx mem_bytes 0x%llx pos 0x%llx bytecount 0x%llx pgoff 0x%lx isize 0x%llx",
+		  __entry->ino,
+		  __entry->bytes_used,
+		  __entry->pos,
+		  __entry->bytecount,
+		  __entry->pgoff,
+		  __entry->size)
+);
+#define DEFINE_XFILE_PAGE_EVENT(name) \
+DEFINE_EVENT(xfile_page_class, name, \
+	TP_PROTO(struct xfile *xf, loff_t pos, struct page *page), \
+	TP_ARGS(xf, pos, page))
+DEFINE_XFILE_PAGE_EVENT(xfile_got_page);
+DEFINE_XFILE_PAGE_EVENT(xfile_put_page);
+
 TRACE_EVENT(xfarray_create,
 	TP_PROTO(struct xfarray *xfa, unsigned long long required_capacity),
 	TP_ARGS(xfa, required_capacity),
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 9ab5d87963be2..ccef7fdcd7d9f 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -64,7 +64,7 @@ xfile_create(
 	struct xfile		*xf;
 	int			error = -ENOMEM;
 
-	xf = kmalloc(sizeof(struct xfile), XCHK_GFP_FLAGS);
+	xf = kzalloc(sizeof(struct xfile), XCHK_GFP_FLAGS);
 	if (!xf)
 		return -ENOMEM;
 
@@ -103,6 +103,129 @@ xfile_create(
 	return error;
 }
 
+/* Evict a cache entry and release the page. */
+static inline int
+xfile_cache_evict(
+	struct xfile		*xf,
+	struct xfile_cache	*entry)
+{
+	int			error;
+
+	if (!entry->xfpage.page)
+		return 0;
+
+	lock_page(entry->xfpage.page);
+	kunmap(entry->kaddr);
+
+	error = xfile_put_page(xf, &entry->xfpage);
+	memset(entry, 0, sizeof(struct xfile_cache));
+	return error;
+}
+
+/*
+ * Grab a page, map it into the kernel address space, and fill out the cache
+ * entry.
+ */
+static int
+xfile_cache_fill(
+	struct xfile		*xf,
+	loff_t			key,
+	struct xfile_cache	*entry)
+{
+	int			error;
+
+	error = xfile_get_page(xf, key, PAGE_SIZE, &entry->xfpage);
+	if (error)
+		return error;
+
+	entry->kaddr = kmap(entry->xfpage.page);
+	unlock_page(entry->xfpage.page);
+	return 0;
+}
+
+/*
+ * Return the kernel address of a cached position in the xfile.  If the cache
+ * misses, the relevant page will be brought into memory, mapped, and returned.
+ * If the cache is disabled, returns NULL.
+ */
+static void *
+xfile_cache_lookup(
+	struct xfile		*xf,
+	loff_t			pos)
+{
+	loff_t			key = round_down(pos, PAGE_SIZE);
+	unsigned int		i;
+	int			ret;
+
+	if (!(xf->flags & XFILE_INTERNAL_CACHE))
+		return NULL;
+
+	/* Is it already in the cache? */
+	for (i = 0; i < XFILE_CACHE_ENTRIES; i++) {
+		if (!xf->cached[i].xfpage.page)
+			continue;
+		if (page_offset(xf->cached[i].xfpage.page) != key)
+			continue;
+
+		goto found;
+	}
+
+	/* Find the least-used slot here so we can evict it. */
+	for (i = 0; i < XFILE_CACHE_ENTRIES; i++) {
+		if (!xf->cached[i].xfpage.page)
+			goto insert;
+	}
+	i = min_t(unsigned int, i, XFILE_CACHE_ENTRIES - 1);
+
+	ret = xfile_cache_evict(xf, &xf->cached[i]);
+	if (ret)
+		return ERR_PTR(ret);
+
+insert:
+	ret = xfile_cache_fill(xf, key, &xf->cached[i]);
+	if (ret)
+		return ERR_PTR(ret);
+
+found:
+	/* Stupid MRU moves this cache entry to the front. */
+	if (i != 0)
+		swap(xf->cached[0], xf->cached[i]);
+
+	return xf->cached[0].kaddr;
+}
+
+/* Drop all cached xfile pages. */
+static void
+xfile_cache_drop(
+	struct xfile		*xf)
+{
+	unsigned int		i;
+
+	if (!(xf->flags & XFILE_INTERNAL_CACHE))
+		return;
+
+	for (i = 0; i < XFILE_CACHE_ENTRIES; i++)
+		xfile_cache_evict(xf, &xf->cached[i]);
+}
+
+/* Enable the internal xfile cache. */
+void
+xfile_cache_enable(
+	struct xfile		*xf)
+{
+	xf->flags |= XFILE_INTERNAL_CACHE;
+	memset(xf->cached, 0, sizeof(struct xfile_cache) * XFILE_CACHE_ENTRIES);
+}
+
+/* Disable the internal xfile cache. */
+void
+xfile_cache_disable(
+	struct xfile		*xf)
+{
+	xfile_cache_drop(xf);
+	xf->flags &= ~XFILE_INTERNAL_CACHE;
+}
+
 /* Close the file and release all resources. */
 void
 xfile_destroy(
@@ -112,11 +235,41 @@ xfile_destroy(
 
 	trace_xfile_destroy(xf);
 
+	xfile_cache_drop(xf);
+
 	lockdep_set_class(&inode->i_rwsem, &inode->i_sb->s_type->i_mutex_key);
 	fput(xf->file);
 	kfree(xf);
 }
 
+/* Get a mapped page in the xfile, do not use internal cache. */
+static void *
+xfile_uncached_get(
+	struct xfile		*xf,
+	loff_t			pos,
+	struct xfile_page	*xfpage)
+{
+	loff_t			key = round_down(pos, PAGE_SIZE);
+	int			error;
+
+	error = xfile_get_page(xf, key, PAGE_SIZE, xfpage);
+	if (error)
+		return ERR_PTR(error);
+
+	return kmap_local_page(xfpage->page);
+}
+
+/* Release a mapped page that was obtained via xfile_uncached_get. */
+static int
+xfile_uncached_put(
+	struct xfile		*xf,
+	struct xfile_page	*xfpage,
+	void			*kaddr)
+{
+	kunmap_local(kaddr);
+	return xfile_put_page(xf, xfpage);
+}
+
 /*
  * Read a memory object directly from the xfile's page cache.  Unlike regular
  * pread, we return -E2BIG and -EFBIG for reads that are too large or at too
@@ -131,8 +284,6 @@ xfile_pread(
 	loff_t			pos)
 {
 	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	struct page		*page = NULL;
 	ssize_t			read = 0;
 	unsigned int		pflags;
 	int			error = 0;
@@ -146,42 +297,32 @@ xfile_pread(
 
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
+		struct xfile_page xfpage;
 		void		*p, *kaddr;
 		unsigned int	len;
+		bool		cached = true;
 
 		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
 
-		/*
-		 * In-kernel reads of a shmem file cause it to allocate a page
-		 * if the mapping shows a hole.  Therefore, if we hit ENOMEM
-		 * we can continue by zeroing the caller's buffer.
-		 */
-		page = shmem_read_mapping_page_gfp(mapping, pos >> PAGE_SHIFT,
-				__GFP_NOWARN);
-		if (IS_ERR(page)) {
-			error = PTR_ERR(page);
-			if (error != -ENOMEM)
+		kaddr = xfile_cache_lookup(xf, pos);
+		if (!kaddr) {
+			cached = false;
+			kaddr = xfile_uncached_get(xf, pos, &xfpage);
+		}
+		if (IS_ERR(kaddr)) {
+			error = PTR_ERR(kaddr);
+			break;
+		}
+
+		p = kaddr + offset_in_page(pos);
+		memcpy(buf, p, len);
+
+		if (!cached) {
+			error = xfile_uncached_put(xf, &xfpage, kaddr);
+			if (error)
 				break;
-
-			memset(buf, 0, len);
-			goto advance;
-		}
-
-		if (PageUptodate(page)) {
-			/*
-			 * xfile pages must never be mapped into userspace, so
-			 * we skip the dcache flush.
-			 */
-			kaddr = kmap_local_page(page);
-			p = kaddr + offset_in_page(pos);
-			memcpy(buf, p, len);
-			kunmap_local(kaddr);
-		} else {
-			memset(buf, 0, len);
 		}
-		put_page(page);
 
-advance:
 		count -= len;
 		pos += len;
 		buf += len;
@@ -208,9 +349,6 @@ xfile_pwrite(
 	loff_t			pos)
 {
 	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	const struct address_space_operations *aops = mapping->a_ops;
-	struct page		*page = NULL;
 	ssize_t			written = 0;
 	unsigned int		pflags;
 	int			error = 0;
@@ -224,52 +362,36 @@ xfile_pwrite(
 
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
-		void		*fsdata = NULL;
+		struct xfile_page xfpage;
 		void		*p, *kaddr;
 		unsigned int	len;
-		int		ret;
+		bool		cached = true;
 
 		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
 
-		/*
-		 * We call write_begin directly here to avoid all the freezer
-		 * protection lock-taking that happens in the normal path.
-		 * shmem doesn't support fs freeze, but lockdep doesn't know
-		 * that and will trip over that.
-		 */
-		error = aops->write_begin(NULL, mapping, pos, len, &page,
-				&fsdata);
-		if (error)
+		kaddr = xfile_cache_lookup(xf, pos);
+		if (!kaddr) {
+			cached = false;
+			kaddr = xfile_uncached_get(xf, pos, &xfpage);
+		}
+		if (IS_ERR(kaddr)) {
+			error = PTR_ERR(kaddr);
 			break;
-
-		/*
-		 * xfile pages must never be mapped into userspace, so we skip
-		 * the dcache flush.  If the page is not uptodate, zero it
-		 * before writing data.
-		 */
-		kaddr = kmap_local_page(page);
-		if (!PageUptodate(page)) {
-			memset(kaddr, 0, PAGE_SIZE);
-			SetPageUptodate(page);
 		}
+
 		p = kaddr + offset_in_page(pos);
 		memcpy(p, buf, len);
-		kunmap_local(kaddr);
 
-		ret = aops->write_end(NULL, mapping, pos, len, len, page,
-				fsdata);
-		if (ret < 0) {
-			error = ret;
-			break;
+		if (!cached) {
+			error = xfile_uncached_put(xf, &xfpage, kaddr);
+			if (error)
+				break;
 		}
 
-		written += ret;
-		if (ret != len)
-			break;
-
-		count -= ret;
-		pos += ret;
-		buf += ret;
+		written += len;
+		count -= len;
+		pos += len;
+		buf += len;
 	}
 	memalloc_nofs_restore(pflags);
 
@@ -286,6 +408,7 @@ xfile_discard(
 	u64			count)
 {
 	trace_xfile_discard(xf, pos, count);
+	xfile_cache_drop(xf);
 	shmem_truncate_range(file_inode(xf->file), pos, pos + count - 1);
 }
 
@@ -297,9 +420,6 @@ xfile_prealloc(
 	u64			count)
 {
 	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	const struct address_space_operations *aops = mapping->a_ops;
-	struct page		*page = NULL;
 	unsigned int		pflags;
 	int			error = 0;
 
@@ -312,47 +432,22 @@ xfile_prealloc(
 
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
-		void		*fsdata = NULL;
+		struct xfile_page xfpage;
+		void		*kaddr;
 		unsigned int	len;
-		int		ret;
 
 		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
 
-		/*
-		 * We call write_begin directly here to avoid all the freezer
-		 * protection lock-taking that happens in the normal path.
-		 * shmem doesn't support fs freeze, but lockdep doesn't know
-		 * that and will trip over that.
-		 */
-		error = aops->write_begin(NULL, mapping, pos, len, &page,
-				&fsdata);
+		kaddr = xfile_uncached_get(xf, pos, &xfpage);
+		if (IS_ERR(kaddr)) {
+			error = PTR_ERR(kaddr);
+			break;
+		}
+
+		error = xfile_uncached_put(xf, &xfpage, kaddr);
 		if (error)
 			break;
 
-		/*
-		 * xfile pages must never be mapped into userspace, so we skip
-		 * the dcache flush.  If the page is not uptodate, zero it to
-		 * ensure we never go lacking for space here.
-		 */
-		if (!PageUptodate(page)) {
-			void	*kaddr = kmap_local_page(page);
-
-			memset(kaddr, 0, PAGE_SIZE);
-			SetPageUptodate(page);
-			kunmap_local(kaddr);
-		}
-
-		ret = aops->write_end(NULL, mapping, pos, len, len, page,
-				fsdata);
-		if (ret < 0) {
-			error = ret;
-			break;
-		}
-		if (ret != len) {
-			error = -EIO;
-			break;
-		}
-
 		count -= len;
 		pos += len;
 	}
@@ -483,7 +578,7 @@ xfile_put_page(
 	unsigned int		pflags;
 	int			ret;
 
-	trace_xfile_put_page(xf, xfpage->pos, PAGE_SIZE);
+	trace_xfile_put_page(xf, xfpage->pos, xfpage->page);
 
 	/* Give back the reference that we took in xfile_get_page. */
 	put_page(xfpage->page);
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index 849f59da6a184..4bb10829f7a07 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -24,11 +24,32 @@ static inline pgoff_t xfile_page_index(const struct xfile_page *xfpage)
 	return xfpage->page->index;
 }
 
+struct xfile_cache {
+	struct xfile_page	xfpage;
+	void			*kaddr;
+};
+
+#define XFILE_CACHE_ENTRIES	(sizeof(struct xfs_buf_cache) / \
+				 sizeof(struct xfile_cache))
+
 struct xfile {
 	struct file		*file;
-	struct xfs_buf_cache	bcache;
+
+	union {
+		struct xfs_buf_cache	bcache;
+		struct xfile_cache	cached[XFILE_CACHE_ENTRIES];
+	};
+
+	/* XFILE_* flags */
+	unsigned int		flags;
 };
 
+/* Use the internal cache for faster access. */
+#define XFILE_INTERNAL_CACHE	(1U << 0)
+
+void xfile_cache_enable(struct xfile *xf);
+void xfile_cache_disable(struct xfile *xf);
+
 int xfile_create(const char *description, loff_t isize, struct xfile **xfilep);
 void xfile_destroy(struct xfile *xf);
 
diff --git a/fs/xfs/xfs_buf_xfile.c b/fs/xfs/xfs_buf_xfile.c
index 58469a91e72bc..cc670e8bafc4a 100644
--- a/fs/xfs/xfs_buf_xfile.c
+++ b/fs/xfs/xfs_buf_xfile.c
@@ -49,6 +49,13 @@ xfile_alloc_buftarg(
 	if (error)
 		return error;
 
+	/*
+	 * We're hooking the xfile up to the buffer cache, so disable its
+	 * internal page caching because all callers should be using xfs_buf
+	 * functions.
+	 */
+	xfile_cache_disable(xfile);
+
 	error = xfs_buf_cache_init(&xfile->bcache);
 	if (error)
 		goto out_xfile;

