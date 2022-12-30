Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CED7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbiLaAE7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiLaAE6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:04:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D64414D14
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:04:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A03461CBF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FDDC433D2;
        Sat, 31 Dec 2022 00:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445096;
        bh=+/YL6vFJnEyoIlS41mwWPV3lsD0JtISHIOtv5rbALHE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Q3XvG3+DByAcj+3KLVqEhMk78v2zblM+yimZC+wxmR/yOWj+rUCqpr31buVRBZTDX
         pzRcOxGlxgoSCEA1sX8D/NwI2X1L7ceClJY6exxfEgTqjon7QV+cqmD23Qy/RTic0c
         liBffjWgktwyCybEsB1rC7gInsIvHhDeCl0pMRLouzXGwgTkn0SosrBLCRNLu1BQrN
         OiISeIkhLnzsYjJ7otVzr214YhC80bw7IzMgO1kgfX2qpRBieCk89So3mfQ88IIgxF
         vM+kxOK6T/KTKA77iULocYESbk5BLwtD4+DSPx2M+IFTXuZITR2+92P62+BYbErRfV
         ajOwtKVKMGjrQ==
Subject: [PATCH 3/3] xfile: implement write caching
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:33 -0800
Message-ID: <167243847307.701196.8297419746332926172.stgit@magnolia>
In-Reply-To: <167243847260.701196.16973261353833975727.stgit@magnolia>
References: <167243847260.701196.16973261353833975727.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |   44 ++++++++-
 fs/xfs/scrub/xfile.c |  254 +++++++++++++++++++++++++++++---------------------
 fs/xfs/scrub/xfile.h |   15 +++
 fs/xfs/xfs_buf.c     |    1 
 4 files changed, 207 insertions(+), 107 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index f7e30c6eb1d1..3652ac4a3eff 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -872,10 +872,52 @@ DEFINE_XFILE_EVENT(xfile_pread);
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
index b1cbf80f55d7..529266e86e41 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -66,7 +66,7 @@ xfile_create(
 	struct xfile		*xf;
 	int			error = -ENOMEM;
 
-	xf = kmalloc(sizeof(struct xfile), XCHK_GFP_FLAGS);
+	xf = kzalloc(sizeof(struct xfile), XCHK_GFP_FLAGS);
 	if (!xf)
 		return -ENOMEM;
 
@@ -110,6 +110,117 @@ xfile_create(
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
+/* Return the kernel address of a cached position in the xfile. */
+static void *
+xfile_cache_lookup(
+	struct xfile		*xf,
+	loff_t			pos)
+{
+	loff_t			key = round_down(pos, PAGE_SIZE);
+	unsigned int		i;
+	int			ret;
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
+/* Release the cached page corresponding to a given kernel address. */
+static int
+xfile_cache_rele(
+	struct xfile		*xf,
+	void			*kaddr)
+{
+	unsigned int		i;
+
+	for (i = 0; i < XFILE_CACHE_ENTRIES; i++) {
+		if (xf->cached[i].kaddr == kaddr)
+			return xfile_cache_evict(xf, &xf->cached[i]);
+	}
+
+	return 0;
+}
+
+/* Drop all cached xfile pages. */
+static void
+xfile_cache_drop(
+	struct xfile		*xf)
+{
+	unsigned int		i;
+
+	for (i = 0; i < XFILE_CACHE_ENTRIES; i++)
+		xfile_cache_evict(xf, &xf->cached[i]);
+}
+
 /* Close the file and release all resources. */
 void
 xfile_destroy(
@@ -119,6 +230,8 @@ xfile_destroy(
 
 	trace_xfile_destroy(xf);
 
+	xfile_cache_drop(xf);
+
 	lockdep_set_class(&inode->i_rwsem, &inode->i_sb->s_type->i_mutex_key);
 	fput(xf->file);
 	kfree(xf);
@@ -138,8 +251,6 @@ xfile_pread(
 	loff_t			pos)
 {
 	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	struct page		*page = NULL;
 	ssize_t			read = 0;
 	unsigned int		pflags;
 	int			error = 0;
@@ -158,37 +269,21 @@ xfile_pread(
 
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
+		if (IS_ERR(kaddr)) {
+			error = PTR_ERR(kaddr);
+			break;
+		}
+
+		p = kaddr + offset_in_page(pos);
+		memcpy(buf, p, len);
+
+		if (xf->flags & XFILE_UNCACHED) {
+			error = xfile_cache_rele(xf, kaddr);
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
@@ -215,9 +310,6 @@ xfile_pwrite(
 	loff_t			pos)
 {
 	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	const struct address_space_operations *aops = mapping->a_ops;
-	struct page		*page = NULL;
 	ssize_t			written = 0;
 	unsigned int		pflags;
 	int			error = 0;
@@ -231,52 +323,30 @@ xfile_pwrite(
 
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
-		void		*fsdata = NULL;
 		void		*p, *kaddr;
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
-		if (error)
+		kaddr = xfile_cache_lookup(xf, pos);
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
+		if (xf->flags & XFILE_UNCACHED) {
+			error = xfile_cache_rele(xf, kaddr);
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
 
@@ -293,6 +363,7 @@ xfile_discard(
 	u64			count)
 {
 	trace_xfile_discard(xf, pos, count);
+	xfile_cache_drop(xf);
 	shmem_truncate_range(file_inode(xf->file), pos, pos + count - 1);
 }
 
@@ -304,9 +375,6 @@ xfile_prealloc(
 	u64			count)
 {
 	struct inode		*inode = file_inode(xf->file);
-	struct address_space	*mapping = inode->i_mapping;
-	const struct address_space_operations *aops = mapping->a_ops;
-	struct page		*page = NULL;
 	unsigned int		pflags;
 	int			error = 0;
 
@@ -319,47 +387,21 @@ xfile_prealloc(
 
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
-		void		*fsdata = NULL;
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
+		kaddr = xfile_cache_lookup(xf, pos);
+		if (IS_ERR(kaddr)) {
+			error = PTR_ERR(kaddr);
+			break;
+		}
+
+		error = xfile_cache_rele(xf, kaddr);
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
@@ -490,7 +532,7 @@ xfile_put_page(
 	unsigned int		pflags;
 	int			ret;
 
-	trace_xfile_put_page(xf, xfpage->pos, PAGE_SIZE);
+	trace_xfile_put_page(xf, xfpage->pos, xfpage->page);
 
 	/* Give back the reference that we took in xfile_get_page. */
 	put_page(xfpage->page);
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index bf80bb796e83..9a065bd9ffe2 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -24,10 +24,25 @@ static inline pgoff_t xfile_page_index(const struct xfile_page *xfpage)
 	return xfpage->page->index;
 }
 
+struct xfile_cache {
+	struct xfile_page	xfpage;
+	void			*kaddr;
+};
+
+#define XFILE_CACHE_ENTRIES	4
+
 struct xfile {
 	struct file		*file;
+
+	/* XFILE_* flags */
+	unsigned int		flags;
+
+	struct xfile_cache	cached[XFILE_CACHE_ENTRIES];
 };
 
+/* Do not cache pages for faster access. */
+#define XFILE_UNCACHED		(1U << 0)
+
 int xfile_create(struct xfs_mount *mp, const char *description, loff_t isize,
 		struct xfile **xfilep);
 void xfile_destroy(struct xfile *xf);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index db3344a36f14..c5fcbd54e840 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2387,6 +2387,7 @@ xfs_alloc_memory_buftarg(
 	if (!btp)
 		return -ENOMEM;
 
+	xfile->flags |= XFILE_UNCACHED;
 	btp->bt_xfile = xfile;
 	btp->bt_dev = (dev_t)-1U;
 

