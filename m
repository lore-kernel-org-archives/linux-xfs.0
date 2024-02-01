Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ED385297
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817476; cv=none; b=mA1T2NNAbU8HdbseTm1bhrTfz7vQeF2kHWjyVqFMCePCW1qYFL5aH258DEZRuILH+VwBoSNySJlAkmb+gSB5uJThJLa5du5MUrlO03C1XmbMLO8ZipFBm+fmznVpKDOxD3+1Frv/aIycKUWEX2aMzMg1oDcDNsfU48Oz92QSdus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817476; c=relaxed/simple;
	bh=vYuQBbiax2dF6YF2e/1c4iBKEI8Glf+1oziTuXaxe98=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XUZhVaBtQoSnkuaxs5tfMKSCu8fyU+lTDFvyhohOQYoQZ4LN5GNNkrnL8YV4o2PNRUUqyfAwAPCIcSdTWBPD6B067JWFHT7rZZ1WNCwaQC10H+qMcOACfK2BskBOLrxumac6GIL+gSbIMpDROUgLtbRZyk1PV6iBBf/Lp434Vy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PVc4PcJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PVc4PcJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BBCC433F1;
	Thu,  1 Feb 2024 19:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817475;
	bh=vYuQBbiax2dF6YF2e/1c4iBKEI8Glf+1oziTuXaxe98=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PVc4PcJeilulVVMkci+WvF9pAKH8PTFfomKYmT3Yzs8Btnr8Q8PScoF/xvdsBRdQd
	 Nrl423o7Jw0vd4Z5hHpJSjMr4qIkn6mw4oQxeregZeqgguQbGvYbVg7MzAfgK9acc7
	 z0cfmlW6vo0NhpTdj3ihvqI42x2EmomsbZVubr0bwIdcjS9XULYYJA0gOmI5vKyvr4
	 FafWq7MdqJWR2VIblUKNSWYUX5tui6tgz2En58R9cKKmSFgP62MA9H5UT+6XW2mN/e
	 QyfcmKLa8KMTkJo3WJrCFbisb+cdurL7qUP1ciri/id9s6ku7uyJyC1PZl6V0oQdtp
	 JrAs8oEcR3vIw==
Date: Thu, 01 Feb 2024 11:57:54 -0800
Subject: [PATCH 2/5] xfs: support in-memory buffer cache targets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170681336991.1608400.653884475555695110.stgit@frogsfrogsfrogs>
In-Reply-To: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
References: <170681336944.1608400.1205655215836749591.stgit@frogsfrogsfrogs>
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

Allow the buffer cache to target in-memory files by making it possible
to have a buftarg that maps pages from private shmem files.  As the
prevous patch alludes, the in-memory buftarg contains its own cache,
points to a shmem file, and does not point to a block_device.

The next few patches will make it possible to construct an xfs_btree in
pageable memory by using this buftarg.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig       |    4 +
 fs/xfs/Makefile      |    1 
 fs/xfs/xfs_buf.c     |  132 +++++++++++++++++++++++------------
 fs/xfs/xfs_buf.h     |    9 ++
 fs/xfs/xfs_buf_mem.c |  189 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf_mem.h |   30 ++++++++
 fs/xfs/xfs_trace.c   |    1 
 fs/xfs/xfs_trace.h   |   49 +++++++++++++
 8 files changed, 369 insertions(+), 46 deletions(-)
 create mode 100644 fs/xfs/xfs_buf_mem.c
 create mode 100644 fs/xfs/xfs_buf_mem.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index fa7eb3e2a2484..7017ea0fb4cd3 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -128,6 +128,9 @@ config XFS_LIVE_HOOKS
 	bool
 	select JUMP_LABEL if HAVE_ARCH_JUMP_LABEL
 
+config XFS_MEMORY_BUFS
+	bool
+
 config XFS_ONLINE_SCRUB
 	bool "XFS online metadata check support"
 	default n
@@ -135,6 +138,7 @@ config XFS_ONLINE_SCRUB
 	depends on TMPFS && SHMEM
 	select XFS_LIVE_HOOKS
 	select XFS_DRAIN_INTENTS
+	select XFS_MEMORY_BUFS
 	help
 	  If you say Y here you will be able to check metadata on a
 	  mounted XFS filesystem.  This feature is intended to reduce
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a6a455ac5a38b..78d816ffd99a3 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -138,6 +138,7 @@ endif
 
 xfs-$(CONFIG_XFS_DRAIN_INTENTS)	+= xfs_drain.o
 xfs-$(CONFIG_XFS_LIVE_HOOKS)	+= xfs_hooks.o
+xfs-$(CONFIG_XFS_MEMORY_BUFS)	+= xfs_buf_mem.o
 
 # online scrub/repair
 ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index dff7f5e573999..1f681a889d6ed 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -21,6 +21,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_ag.h"
+#include "xfs_buf_mem.h"
 
 struct kmem_cache *xfs_buf_cache;
 
@@ -317,7 +318,9 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_lru));
 
-	if (bp->b_flags & _XBF_PAGES)
+	if (xfs_buftarg_is_mem(bp->b_target))
+		xmbuf_unmap_page(bp);
+	else if (bp->b_flags & _XBF_PAGES)
 		xfs_buf_free_pages(bp);
 	else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
@@ -628,18 +631,20 @@ xfs_buf_find_insert(
 	if (error)
 		goto out_drop_pag;
 
-	/*
-	 * For buffers that fit entirely within a single page, first attempt to
-	 * allocate the memory from the heap to minimise memory usage. If we
-	 * can't get heap memory for these small buffers, we fall back to using
-	 * the page allocator.
-	 */
-	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
-	    xfs_buf_alloc_kmem(new_bp, flags) < 0) {
+	if (xfs_buftarg_is_mem(new_bp->b_target)) {
+		error = xmbuf_map_page(new_bp);
+	} else if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
+		   xfs_buf_alloc_kmem(new_bp, flags) < 0) {
+		/*
+		 * For buffers that fit entirely within a single page, first
+		 * attempt to allocate the memory from the heap to minimise
+		 * memory usage. If we can't get heap memory for these small
+		 * buffers, we fall back to using the page allocator.
+		 */
 		error = xfs_buf_alloc_pages(new_bp, flags);
-		if (error)
-			goto out_free_buf;
 	}
+	if (error)
+		goto out_free_buf;
 
 	spin_lock(&bch->bc_lock);
 	bp = rhashtable_lookup_get_insert_fast(&bch->bc_hash,
@@ -682,6 +687,8 @@ xfs_buftarg_get_pag(
 {
 	struct xfs_mount		*mp = btp->bt_mount;
 
+	if (xfs_buftarg_is_mem(btp))
+		return NULL;
 	return xfs_perag_get(mp, xfs_daddr_to_agno(mp, map->bm_bn));
 }
 
@@ -690,7 +697,9 @@ xfs_buftarg_buf_cache(
 	struct xfs_buftarg		*btp,
 	struct xfs_perag		*pag)
 {
-	return &pag->pag_bcache;
+	if (pag)
+		return &pag->pag_bcache;
+	return btp->bt_cache;
 }
 
 /*
@@ -920,6 +929,13 @@ xfs_buf_readahead_map(
 {
 	struct xfs_buf		*bp;
 
+	/*
+	 * Currently we don't have a good means or justification for performing
+	 * xmbuf_map_page asynchronously, so we don't do readahead.
+	 */
+	if (xfs_buftarg_is_mem(target))
+		return;
+
 	xfs_buf_read_map(target, map, nmaps,
 		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
 		     __this_address);
@@ -985,7 +1001,10 @@ xfs_buf_get_uncached(
 	if (error)
 		return error;
 
-	error = xfs_buf_alloc_pages(bp, flags);
+	if (xfs_buftarg_is_mem(bp->b_target))
+		error = xmbuf_map_page(bp);
+	else
+		error = xfs_buf_alloc_pages(bp, flags);
 	if (error)
 		goto fail_free_buf;
 
@@ -1627,6 +1646,12 @@ _xfs_buf_ioapply(
 	/* we only use the buffer cache for meta-data */
 	op |= REQ_META;
 
+	/* in-memory targets are directly mapped, no IO required. */
+	if (xfs_buftarg_is_mem(bp->b_target)) {
+		xfs_buf_ioend(bp);
+		return;
+	}
+
 	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
 	 * into the buffer and the desired IO size before we start -
@@ -1982,19 +2007,24 @@ xfs_buftarg_shrink_count(
 }
 
 void
-xfs_free_buftarg(
+xfs_destroy_buftarg(
 	struct xfs_buftarg	*btp)
 {
 	shrinker_free(btp->bt_shrinker);
 	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
 	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
+}
 
+void
+xfs_free_buftarg(
+	struct xfs_buftarg	*btp)
+{
+	xfs_destroy_buftarg(btp);
 	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
 	/* the main block device is closed by kill_block_super */
 	if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
 		bdev_release(btp->bt_bdev_handle);
-
 	kfree(btp);
 }
 
@@ -2017,6 +2047,45 @@ xfs_setsize_buftarg(
 	return 0;
 }
 
+int
+xfs_init_buftarg(
+	struct xfs_buftarg		*btp,
+	size_t				logical_sectorsize,
+	const char			*descr)
+{
+	/* Set up device logical sector size mask */
+	btp->bt_logical_sectorsize = logical_sectorsize;
+	btp->bt_logical_sectormask = logical_sectorsize - 1;
+
+	/*
+	 * Buffer IO error rate limiting. Limit it to no more than 10 messages
+	 * per 30 seconds so as to not spam logs too much on repeated errors.
+	 */
+	ratelimit_state_init(&btp->bt_ioerror_rl, 30 * HZ,
+			     DEFAULT_RATELIMIT_BURST);
+
+	if (list_lru_init(&btp->bt_lru))
+		return -ENOMEM;
+	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
+		goto out_destroy_lru;
+
+	btp->bt_shrinker =
+		shrinker_alloc(SHRINKER_NUMA_AWARE, "xfs-buf:%s", descr);
+	if (!btp->bt_shrinker)
+		goto out_destroy_io_count;
+	btp->bt_shrinker->count_objects = xfs_buftarg_shrink_count;
+	btp->bt_shrinker->scan_objects = xfs_buftarg_shrink_scan;
+	btp->bt_shrinker->private_data = btp;
+	shrinker_register(btp->bt_shrinker);
+	return 0;
+
+out_destroy_io_count:
+	percpu_counter_destroy(&btp->bt_io_count);
+out_destroy_lru:
+	list_lru_destroy(&btp->bt_lru);
+	return -ENOMEM;
+}
+
 struct xfs_buftarg *
 xfs_alloc_buftarg(
 	struct xfs_mount	*mp,
@@ -2044,41 +2113,12 @@ xfs_alloc_buftarg(
 	 */
 	if (xfs_setsize_buftarg(btp, bdev_logical_block_size(btp->bt_bdev)))
 		goto error_free;
-
-	/* Set up device logical sector size mask */
-	btp->bt_logical_sectorsize = bdev_logical_block_size(btp->bt_bdev);
-	btp->bt_logical_sectormask = bdev_logical_block_size(btp->bt_bdev) - 1;
-
-	/*
-	 * Buffer IO error rate limiting. Limit it to no more than 10 messages
-	 * per 30 seconds so as to not spam logs too much on repeated errors.
-	 */
-	ratelimit_state_init(&btp->bt_ioerror_rl, 30 * HZ,
-			     DEFAULT_RATELIMIT_BURST);
-
-	if (list_lru_init(&btp->bt_lru))
+	if (xfs_init_buftarg(btp, bdev_logical_block_size(btp->bt_bdev),
+			mp->m_super->s_id))
 		goto error_free;
 
-	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
-		goto error_lru;
-
-	btp->bt_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE, "xfs-buf:%s",
-					  mp->m_super->s_id);
-	if (!btp->bt_shrinker)
-		goto error_pcpu;
-
-	btp->bt_shrinker->count_objects = xfs_buftarg_shrink_count;
-	btp->bt_shrinker->scan_objects = xfs_buftarg_shrink_scan;
-	btp->bt_shrinker->private_data = btp;
-
-	shrinker_register(btp->bt_shrinker);
-
 	return btp;
 
-error_pcpu:
-	percpu_counter_destroy(&btp->bt_io_count);
-error_lru:
-	list_lru_destroy(&btp->bt_lru);
 error_free:
 	kfree(btp);
 	return NULL;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 7b01df6dcd504..73249abca968e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -109,6 +109,7 @@ struct xfs_buftarg {
 	struct bdev_handle	*bt_bdev_handle;
 	struct block_device	*bt_bdev;
 	struct dax_device	*bt_daxdev;
+	struct file		*bt_file;
 	u64			bt_dax_part_off;
 	struct xfs_mount	*bt_mount;
 	unsigned int		bt_meta_sectorsize;
@@ -122,6 +123,9 @@ struct xfs_buftarg {
 
 	struct percpu_counter	bt_io_count;
 	struct ratelimit_state	bt_ioerror_rl;
+
+	/* built-in cache, if we're not using the perag one */
+	struct xfs_buf_cache	bt_cache[];
 };
 
 #define XB_PAGES	2
@@ -387,4 +391,9 @@ int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
 bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
 
+/* for xfs_buf_mem.c only: */
+int xfs_init_buftarg(struct xfs_buftarg *btp, size_t logical_sectorsize,
+		const char *descr);
+void xfs_destroy_buftarg(struct xfs_buftarg *btp);
+
 #endif	/* __XFS_BUF_H__ */
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
new file mode 100644
index 0000000000000..be71ba1a3d7b0
--- /dev/null
+++ b/fs/xfs/xfs_buf_mem.c
@@ -0,0 +1,189 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_buf.h"
+#include "xfs_buf_mem.h"
+#include "xfs_trace.h"
+#include <linux/shmem_fs.h>
+
+/*
+ * Buffer Cache for In-Memory Files
+ * ================================
+ *
+ * Online fsck wants to create ephemeral ordered recordsets.  The existing
+ * btree infrastructure can do this, but we need the buffer cache to target
+ * memory instead of block devices.
+ *
+ * When CONFIG_TMPFS=y, shmemfs is enough of a filesystem to meet those
+ * requirements.  Therefore, the xmbuf mechanism uses an unlinked shmem file to
+ * store our staging data.  This file is not installed in the file descriptor
+ * table so that user programs cannot access the data, which means that the
+ * xmbuf must be freed with xmbuf_destroy.
+ *
+ * xmbufs assume that the caller will handle all required concurrency
+ * management; standard vfs locks (freezer and inode) are not taken.  Reads
+ * and writes are satisfied directly from the page cache.
+ *
+ * The only supported block size is PAGE_SIZE, and we cannot use highmem.
+ */
+
+/*
+ * shmem files used to back an in-memory buffer cache must not be exposed to
+ * userspace.  Upper layers must coordinate access to the one handle returned
+ * by the constructor, so establish a separate lock class for xmbufs to avoid
+ * confusing lockdep.
+ */
+static struct lock_class_key xmbuf_i_mutex_key;
+
+/*
+ * Allocate a buffer cache target for a memory-backed file and set up the
+ * buffer target.
+ */
+int
+xmbuf_alloc(
+	struct xfs_mount	*mp,
+	const char		*descr,
+	struct xfs_buftarg	**btpp)
+{
+	struct file		*file;
+	struct inode		*inode;
+	struct xfs_buftarg	*btp;
+	int			error;
+
+	btp = kzalloc(struct_size(btp, bt_cache, 1), GFP_KERNEL);
+	if (!btp)
+		return -ENOMEM;
+
+	file = shmem_kernel_file_setup(descr, 0, 0);
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
+		goto out_free_btp;
+	}
+	inode = file_inode(file);
+
+	/* private file, private locking */
+	lockdep_set_class(&inode->i_rwsem, &xmbuf_i_mutex_key);
+
+	/*
+	 * We don't want to bother with kmapping data during repair, so don't
+	 * allow highmem pages to back this mapping.
+	 */
+	mapping_set_gfp_mask(inode->i_mapping, GFP_KERNEL);
+
+	/* ensure all writes are below EOF to avoid pagecache zeroing */
+	i_size_write(inode, inode->i_sb->s_maxbytes);
+
+	trace_xmbuf_create(btp);
+
+	error = xfs_buf_cache_init(btp->bt_cache);
+	if (error)
+		goto out_file;
+
+	/* Initialize buffer target */
+	btp->bt_mount = mp;
+	btp->bt_dev = (dev_t)-1U;
+	btp->bt_bdev = NULL; /* in-memory buftargs have no bdev */
+	btp->bt_file = file;
+	btp->bt_meta_sectorsize = XMBUF_BLOCKSIZE;
+	btp->bt_meta_sectormask = XMBUF_BLOCKSIZE - 1;
+
+	error = xfs_init_buftarg(btp, XMBUF_BLOCKSIZE, descr);
+	if (error)
+		goto out_bcache;
+
+	*btpp = btp;
+	return 0;
+
+out_bcache:
+	xfs_buf_cache_destroy(btp->bt_cache);
+out_file:
+	fput(file);
+out_free_btp:
+	kfree(btp);
+	return error;
+}
+
+/* Free a buffer cache target for a memory-backed buffer cache. */
+void
+xmbuf_free(
+	struct xfs_buftarg	*btp)
+{
+	ASSERT(xfs_buftarg_is_mem(btp));
+	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
+
+	trace_xmbuf_free(btp);
+
+	xfs_destroy_buftarg(btp);
+	xfs_buf_cache_destroy(btp->bt_cache);
+	fput(btp->bt_file);
+	kfree(btp);
+}
+
+/* Directly map a shmem page into the buffer cache. */
+int
+xmbuf_map_page(
+	struct xfs_buf		*bp)
+{
+	struct inode		*inode = file_inode(bp->b_target->bt_file);
+	struct folio		*folio = NULL;
+	struct page		*page;
+	loff_t                  pos = BBTOB(xfs_buf_daddr(bp));
+	int			error;
+
+	ASSERT(xfs_buftarg_is_mem(bp->b_target));
+
+	if (bp->b_map_count != 1)
+		return -ENOMEM;
+	if (BBTOB(bp->b_length) != XMBUF_BLOCKSIZE)
+		return -ENOMEM;
+	if (offset_in_page(pos) != 0) {
+		ASSERT(offset_in_page(pos));
+		return -ENOMEM;
+	}
+
+	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio, SGP_CACHE);
+	if (error)
+		return error;
+
+	if (filemap_check_wb_err(inode->i_mapping, 0)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return -EIO;
+	}
+
+	page = folio_file_page(folio, pos >> PAGE_SHIFT);
+
+	/*
+	 * Mark the page dirty so that it won't be reclaimed once we drop the
+	 * (potentially last) reference in xmbuf_unmap_page.
+	 */
+	set_page_dirty(page);
+	unlock_page(page);
+
+	bp->b_addr = page_address(page);
+	bp->b_pages = bp->b_page_array;
+	bp->b_pages[0] = page;
+	bp->b_page_count = 1;
+	return 0;
+}
+
+/* Unmap a shmem page that was mapped into the buffer cache. */
+void
+xmbuf_unmap_page(
+	struct xfs_buf		*bp)
+{
+	struct page		*page = bp->b_pages[0];
+
+	ASSERT(xfs_buftarg_is_mem(bp->b_target));
+
+	put_page(page);
+
+	bp->b_addr = NULL;
+	bp->b_pages[0] = NULL;
+	bp->b_pages = NULL;
+	bp->b_page_count = 0;
+}
diff --git a/fs/xfs/xfs_buf_mem.h b/fs/xfs/xfs_buf_mem.h
new file mode 100644
index 0000000000000..945f4b610998f
--- /dev/null
+++ b/fs/xfs/xfs_buf_mem.h
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_BUF_MEM_H__
+#define __XFS_BUF_MEM_H__
+
+#define XMBUF_BLOCKSIZE			(PAGE_SIZE)
+#define XMBUF_BLOCKSHIFT		(PAGE_SHIFT)
+
+#ifdef CONFIG_XFS_MEMORY_BUFS
+static inline bool xfs_buftarg_is_mem(const struct xfs_buftarg *btp)
+{
+	return btp->bt_bdev == NULL;
+}
+
+int xmbuf_alloc(struct xfs_mount *mp, const char *descr,
+		struct xfs_buftarg **btpp);
+void xmbuf_free(struct xfs_buftarg *btp);
+
+int xmbuf_map_page(struct xfs_buf *bp);
+void xmbuf_unmap_page(struct xfs_buf *bp);
+#else
+# define xfs_buftarg_is_mem(...)	(false)
+# define xmbuf_map_page(...)		(-ENOMEM)
+# define xmbuf_unmap_page(...)		((void)0)
+#endif /* CONFIG_XFS_MEMORY_BUFS */
+
+#endif /* __XFS_BUF_MEM_H__ */
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 8a5dc1538aa82..ae5be6b589f0e 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -36,6 +36,7 @@
 #include "xfs_error.h"
 #include <linux/iomap.h>
 #include "xfs_iomap.h"
+#include "xfs_buf_mem.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 630eb641d497e..771008abdc367 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4535,6 +4535,55 @@ DEFINE_PERAG_INTENTS_EVENT(xfs_perag_wait_intents);
 
 #endif /* CONFIG_XFS_DRAIN_INTENTS */
 
+#ifdef CONFIG_XFS_MEMORY_BUFS
+TRACE_EVENT(xmbuf_create,
+	TP_PROTO(struct xfs_buftarg *btp),
+	TP_ARGS(btp),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, ino)
+		__array(char, pathname, 256)
+	),
+	TP_fast_assign(
+		char		pathname[257];
+		char		*path;
+		struct file	*file = btp->bt_file;
+
+		__entry->ino = file_inode(file)->i_ino;
+		memset(pathname, 0, sizeof(pathname));
+		path = file_path(file, pathname, sizeof(pathname) - 1);
+		if (IS_ERR(path))
+			path = "(unknown)";
+		strncpy(__entry->pathname, path, sizeof(__entry->pathname));
+	),
+	TP_printk("xmino 0x%lx path '%s'",
+		  __entry->ino,
+		  __entry->pathname)
+);
+
+TRACE_EVENT(xmbuf_free,
+	TP_PROTO(struct xfs_buftarg *btp),
+	TP_ARGS(btp),
+	TP_STRUCT__entry(
+		__field(unsigned long, ino)
+		__field(unsigned long long, bytes)
+		__field(loff_t, size)
+	),
+	TP_fast_assign(
+		struct file	*file = btp->bt_file;
+		struct inode	*inode = file_inode(file);
+
+		__entry->size = i_size_read(inode);
+		__entry->bytes = (inode->i_blocks << SECTOR_SHIFT) + inode->i_bytes;
+		__entry->ino = inode->i_ino;
+	),
+	TP_printk("xmino 0x%lx mem_bytes 0x%llx isize 0x%llx",
+		  __entry->ino,
+		  __entry->bytes,
+		  __entry->size)
+);
+#endif /* CONFIG_XFS_MEMORY_BUFS */
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

