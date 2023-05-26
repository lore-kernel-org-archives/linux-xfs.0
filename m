Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DFBC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjEZBiO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZBiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:38:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10451E2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:38:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BAE564C39
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC882C433EF;
        Fri, 26 May 2023 01:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065090;
        bh=+F4QLn3CPJgD8pPIAE21dFf8AlPLDFZbird49P2uw5Y=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=akc+9imf6Bs9i1vJ2Hn8FChfDTjuvULVex9YmngkQ5KQZbmjRPG/zC9P47TI7D8UT
         Xe8v7euStMzMbw2g62MdNhnWfO+d2Tad68T0vV+ppu8P1PBtGWMuuov6jN2dcX38YL
         XScFoLJUPEdUnD4LXIIs2AdQI1WDsJdj+4EELebwQuxFNdDKPKYZ8coCGpfCujrRzB
         n10Df2TmwmvQrbPA580P4aCaKRXZ6srYcJHHY/w43ttC1zxFjdTwYCSWBYPryTvYxh
         A+BncZQxm5tnWHDO4UsqDkiEF7N7nBVb8IBXP1q7iKmwikSexe7MGEQ9rp5j+fPX6t
         usn+YvWWrNZug==
Date:   Thu, 25 May 2023 18:38:09 -0700
Subject: [PATCH 1/3] xfs: map xfile pages directly into xfs_buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069026.3738195.6571115717345649102.stgit@frogsfrogsfrogs>
In-Reply-To: <168506069009.3738195.8548151008033051712.stgit@frogsfrogsfrogs>
References: <168506069009.3738195.8548151008033051712.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Map the xfile pages directly into xfs_buf to reduce memory overhead.
It's silly to use memory to stage changes to shmem pages for ephemeral
btrees that don't care about transactionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_mem.h  |    6 ++
 fs/xfs/libxfs/xfs_rmap_btree.c |    1 
 fs/xfs/scrub/rcbag_btree.c     |    1 
 fs/xfs/scrub/xfbtree.c         |   23 +++++-
 fs/xfs/xfs_buf.c               |  110 ++++++++++++++++++++++-------
 fs/xfs/xfs_buf.h               |   16 ++++
 fs/xfs/xfs_buf_xfile.c         |  152 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf_xfile.h         |   11 +++
 8 files changed, 292 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_mem.h b/fs/xfs/libxfs/xfs_btree_mem.h
index 3951ef56e534..68f5f7636678 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.h
+++ b/fs/xfs/libxfs/xfs_btree_mem.h
@@ -17,8 +17,14 @@ struct xfbtree_config {
 
 	/* Owner of this btree. */
 	unsigned long long		owner;
+
+	/* XFBTREE_* flags */
+	unsigned int			flags;
 };
 
+/* buffers should be directly mapped from memory */
+#define XFBTREE_DIRECT_MAP		(1U << 0)
+
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
 unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index a4656dd7c729..3cfa12234c67 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -672,6 +672,7 @@ xfs_rmapbt_mem_create(
 		.btree_ops	= &xfs_rmapbt_mem_ops,
 		.target		= target,
 		.owner		= agno,
+		.flags		= XFBTREE_DIRECT_MAP,
 	};
 
 	return xfbtree_create(mp, &cfg, xfbtreep);
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index ac4cc6ae24c7..1c699a088948 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -233,6 +233,7 @@ rcbagbt_mem_create(
 	struct xfbtree_config	cfg = {
 		.btree_ops	= &rcbagbt_mem_ops,
 		.target		= target,
+		.flags		= XFBTREE_DIRECT_MAP,
 	};
 
 	return xfbtree_create(mp, &cfg, xfbtreep);
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index b9a9ee88dc53..9e9245c65213 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -473,6 +473,9 @@ xfbtree_create(
 
 	/* Assign our memory file and the free space bitmap. */
 	xfbt->target = cfg->target;
+	if (cfg->flags & XFBTREE_DIRECT_MAP)
+		xfbt->target->bt_flags |= XFS_BUFTARG_DIRECT_MAP;
+
 	xfbt->freespace = kmalloc(sizeof(struct xbitmap), XCHK_GFP_FLAGS);
 	if (!xfbt->freespace) {
 		error = -ENOMEM;
@@ -732,7 +735,7 @@ xfbtree_trans_commit(
 
 		dirty = xfbtree_trans_bdetach(tp, bp);
 		if (dirty && !corrupt) {
-			xfs_failaddr_t	fa = bp->b_ops->verify_struct(bp);
+			xfs_failaddr_t	fa;
 
 			/*
 			 * Because this btree is ephemeral, validate the buffer
@@ -740,16 +743,30 @@ xfbtree_trans_commit(
 			 * corruption errors to the caller without shutting
 			 * down the filesystem.
 			 *
+			 * Buffers that are directly mapped to the xfile do not
+			 * need to be queued for IO at all.  Check if the DRAM
+			 * has been poisoned, however.
+			 *
 			 * If the buffer fails verification, log the failure
 			 * but continue walking the transaction items so that
 			 * we remove all ephemeral btree buffers.
 			 */
+			if (xfs_buf_check_poisoned(bp)) {
+				corrupt = true;
+				xfs_verifier_error(bp, -EFSCORRUPTED,
+						__this_address);
+				continue;
+			}
+
+			fa = bp->b_ops->verify_struct(bp);
 			if (fa) {
 				corrupt = true;
 				xfs_verifier_error(bp, -EFSCORRUPTED, fa);
-			} else {
+				continue;
+			}
+
+			if (!(bp->b_flags & _XBF_DIRECT_MAP))
 				xfs_buf_delwri_queue_here(bp, &buffer_list);
-			}
 		}
 
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 524a4434116d..9b14f317396c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -280,19 +280,26 @@ xfs_buf_free_pages(
 
 	ASSERT(bp->b_flags & _XBF_PAGES);
 
-	if (xfs_buf_is_vmapped(bp))
-		vm_unmap_ram(bp->b_addr, bp->b_page_count);
-
 	for (i = 0; i < bp->b_page_count; i++) {
 		if (bp->b_pages[i])
 			__free_page(bp->b_pages[i]);
 	}
 	mm_account_reclaimed_pages(bp->b_page_count);
 
+	xfs_buf_free_page_array(bp);
+}
+
+void
+xfs_buf_free_page_array(
+	struct xfs_buf	*bp)
+{
+	ASSERT(bp->b_flags & _XBF_PAGES);
+
 	if (bp->b_pages != bp->b_page_array)
 		kmem_free(bp->b_pages);
 	bp->b_pages = NULL;
 	bp->b_flags &= ~_XBF_PAGES;
+	bp->b_page_count = 0;
 }
 
 static void
@@ -313,7 +320,12 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_lru));
 
-	if (bp->b_flags & _XBF_PAGES)
+	if (xfs_buf_is_vmapped(bp))
+		vm_unmap_ram(bp->b_addr, bp->b_page_count);
+
+	if (bp->b_flags & _XBF_DIRECT_MAP)
+		xfile_buf_unmap_pages(bp);
+	else if (bp->b_flags & _XBF_PAGES)
 		xfs_buf_free_pages(bp);
 	else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
@@ -352,20 +364,14 @@ xfs_buf_alloc_kmem(
 	return 0;
 }
 
-static int
-xfs_buf_alloc_pages(
+/* Make sure that we have a page list */
+int
+xfs_buf_alloc_page_array(
 	struct xfs_buf	*bp,
-	xfs_buf_flags_t	flags)
+	gfp_t		gfp_mask)
 {
-	gfp_t		gfp_mask = __GFP_NOWARN;
-	long		filled = 0;
+	ASSERT(!(bp->b_flags & _XBF_PAGES));
 
-	if (flags & XBF_READ_AHEAD)
-		gfp_mask |= __GFP_NORETRY;
-	else
-		gfp_mask |= GFP_NOFS;
-
-	/* Make sure that we have a page list */
 	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
 	if (bp->b_page_count <= XB_PAGES) {
 		bp->b_pages = bp->b_page_array;
@@ -375,7 +381,28 @@ xfs_buf_alloc_pages(
 		if (!bp->b_pages)
 			return -ENOMEM;
 	}
+
 	bp->b_flags |= _XBF_PAGES;
+	return 0;
+}
+
+static int
+xfs_buf_alloc_pages(
+	struct xfs_buf	*bp,
+	xfs_buf_flags_t	flags)
+{
+	gfp_t		gfp_mask = __GFP_NOWARN;
+	long		filled = 0;
+	int		error;
+
+	if (flags & XBF_READ_AHEAD)
+		gfp_mask |= __GFP_NORETRY;
+	else
+		gfp_mask |= GFP_NOFS;
+
+	error = xfs_buf_alloc_page_array(bp, gfp_mask);
+	if (error)
+		return error;
 
 	/* Assure zeroed buffer for non-read cases. */
 	if (!(flags & XBF_READ))
@@ -418,7 +445,8 @@ _xfs_buf_map_pages(
 	struct xfs_buf		*bp,
 	xfs_buf_flags_t		flags)
 {
-	ASSERT(bp->b_flags & _XBF_PAGES);
+	ASSERT(bp->b_flags & (_XBF_PAGES | _XBF_DIRECT_MAP));
+
 	if (bp->b_page_count == 1) {
 		/* A single page buffer is always mappable */
 		bp->b_addr = page_address(bp->b_pages[0]);
@@ -565,7 +593,7 @@ xfs_buf_find_lock(
 	 */
 	if (bp->b_flags & XBF_STALE) {
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
+		bp->b_flags &= _XBF_KMEM | _XBF_PAGES | _XBF_DIRECT_MAP;
 		bp->b_ops = NULL;
 	}
 	return 0;
@@ -624,18 +652,36 @@ xfs_buf_find_insert(
 		goto out_drop_pag;
 
 	/*
-	 * For buffers that fit entirely within a single page, first attempt to
-	 * allocate the memory from the heap to minimise memory usage. If we
-	 * can't get heap memory for these small buffers, we fall back to using
-	 * the page allocator.
+	 * If the caller is ok with direct maps to xfile pages, try that.
+	 * ENOTBLK is the magic code to fall back to allocating memory.
 	 */
-	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
-	    xfs_buf_alloc_kmem(new_bp, flags) < 0) {
-		error = xfs_buf_alloc_pages(new_bp, flags);
-		if (error)
+	if (xfile_buftarg_can_direct_map(btp)) {
+		error = xfile_buf_map_pages(new_bp, flags);
+		if (error && error != -ENOTBLK)
 			goto out_free_buf;
+		if (!error)
+			goto insert;
 	}
 
+	/*
+	 * For buffers that fit entirely within a single page, first attempt to
+	 * allocate the memory from the heap to minimise memory usage.
+	 */
+	if (BBTOB(new_bp->b_length) < PAGE_SIZE) {
+		error = xfs_buf_alloc_kmem(new_bp, flags);
+		if (!error)
+			goto insert;
+	}
+
+	/*
+	 * For larger buffers or if we can't get heap memory for these small
+	 * buffers, fall back to using the page allocator.
+	 */
+	error = xfs_buf_alloc_pages(new_bp, flags);
+	if (error)
+		goto out_free_buf;
+
+insert:
 	spin_lock(&bch->bc_lock);
 	bp = rhashtable_lookup_get_insert_fast(&bch->bc_hash,
 			&new_bp->b_rhash_head, xfs_buf_hash_params);
@@ -1580,6 +1626,20 @@ xfs_buf_end_sync_io(
 		xfs_buf_ioend(bp);
 }
 
+bool
+xfs_buf_check_poisoned(
+	struct xfs_buf		*bp)
+{
+	unsigned int		i;
+
+	for (i = 0; i < bp->b_page_count; i++) {
+		if (PageHWPoison(bp->b_pages[i]))
+			return true;
+	}
+
+	return false;
+}
+
 STATIC void
 _xfs_buf_ioapply(
 	struct xfs_buf	*bp)
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 661cd16ff64e..e72e63c0733b 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -43,6 +43,11 @@ struct xfile;
 #define _XBF_PAGES	 (1u << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
+#ifdef CONFIG_XFS_IN_MEMORY_FILE
+# define _XBF_DIRECT_MAP (1u << 23)/* pages directly mapped to storage */
+#else
+# define _XBF_DIRECT_MAP (0)
+#endif
 
 /* flags used only as arguments to access routines */
 /*
@@ -72,6 +77,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
+	{ _XBF_DIRECT_MAP,	"DIRECT_MAP" }, \
 	/* The following interface flags should never be set */ \
 	{ XBF_BCACHE_SCAN,	"BCACHE_SCAN" }, \
 	{ XBF_INCORE,		"INCORE" }, \
@@ -132,8 +138,14 @@ typedef struct xfs_buftarg {
 #ifdef CONFIG_XFS_IN_MEMORY_FILE
 /* in-memory buftarg via bt_xfile */
 # define XFS_BUFTARG_XFILE	(1U << 0)
+/*
+ * Buffer pages are direct-mapped to the xfile; caller does not care about
+ * transactional updates.
+ */
+# define XFS_BUFTARG_DIRECT_MAP	(1U << 1)
 #else
 # define XFS_BUFTARG_XFILE	(0)
+# define XFS_BUFTARG_DIRECT_MAP	(0)
 #endif
 
 #define XB_PAGES	2
@@ -380,6 +392,9 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
 			 cksum_offset);
 }
 
+int xfs_buf_alloc_page_array(struct xfs_buf *bp, gfp_t gfp_mask);
+void xfs_buf_free_page_array(struct xfs_buf *bp);
+
 /*
  *	Handling of buftargs.
  */
@@ -451,5 +466,6 @@ xfs_buftarg_verify_daddr(
 int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
 bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
+bool xfs_buf_check_poisoned(struct xfs_buf *bp);
 
 #endif	/* __XFS_BUF_H__ */
diff --git a/fs/xfs/xfs_buf_xfile.c b/fs/xfs/xfs_buf_xfile.c
index 61cc9b1dbed6..5757e0521a60 100644
--- a/fs/xfs/xfs_buf_xfile.c
+++ b/fs/xfs/xfs_buf_xfile.c
@@ -18,6 +18,11 @@ xfile_buf_ioapply(
 	loff_t			pos = BBTOB(xfs_buf_daddr(bp));
 	size_t			size = BBTOB(bp->b_length);
 
+	if (bp->b_target->bt_flags & XFS_BUFTARG_DIRECT_MAP) {
+		/* direct mapping means no io necessary */
+		return 0;
+	}
+
 	if (bp->b_map_count > 1) {
 		/* We don't need or support multi-map buffers. */
 		ASSERT(0);
@@ -95,3 +100,150 @@ xfile_buftarg_nr_sectors(
 {
 	return xfile_size(btp->bt_xfile) >> SECTOR_SHIFT;
 }
+
+/* Free an xfile page that was directly mapped into the buffer cache. */
+static int
+xfile_buf_put_page(
+	struct xfile		*xfile,
+	loff_t			pos,
+	struct page		*page)
+{
+	struct xfile_page	xfpage = {
+		.page		= page,
+		.pos		= round_down(pos, PAGE_SIZE),
+	};
+
+	lock_page(xfpage.page);
+
+	return xfile_put_page(xfile, &xfpage);
+}
+
+/* Grab the xfile page for this part of the xfile. */
+static int
+xfile_buf_get_page(
+	struct xfile		*xfile,
+	loff_t			pos,
+	unsigned int		len,
+	struct page		**pagep)
+{
+	struct xfile_page	xfpage = { NULL };
+	int			error;
+
+	error = xfile_get_page(xfile, pos, len, &xfpage);
+	if (error)
+		return error;
+
+	/*
+	 * Fall back to regular DRAM buffers if tmpfs gives us fsdata or the
+	 * page pos isn't what we were expecting.
+	 */
+	if (xfpage.fsdata || xfpage.pos != round_down(pos, PAGE_SIZE)) {
+		xfile_put_page(xfile, &xfpage);
+		return -ENOTBLK;
+	}
+
+	/* Unlock the page before we start using them for the buffer cache. */
+	ASSERT(PageUptodate(xfpage.page));
+	unlock_page(xfpage.page);
+
+	*pagep = xfpage.page;
+	return 0;
+}
+
+/*
+ * Try to map storage directly, if the target supports it.  Returns 0 for
+ * success, -ENOTBLK to mean "not supported", or the usual negative errno.
+ */
+int
+xfile_buf_map_pages(
+	struct xfs_buf		*bp,
+	xfs_buf_flags_t		flags)
+{
+	struct xfs_buf_map	*map;
+	gfp_t			gfp_mask = __GFP_NOWARN;
+	const unsigned int	page_align_mask = PAGE_SIZE - 1;
+	unsigned int		m, p, n;
+	int			error;
+
+	ASSERT(xfile_buftarg_can_direct_map(bp->b_target));
+
+	/* For direct-map buffers, each map has to be page aligned. */
+	for (m = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++)
+		if (BBTOB(map->bm_bn | map->bm_len) & page_align_mask)
+			return -ENOTBLK;
+
+	if (flags & XBF_READ_AHEAD)
+		gfp_mask |= __GFP_NORETRY;
+	else
+		gfp_mask |= GFP_NOFS;
+
+	error = xfs_buf_alloc_page_array(bp, gfp_mask);
+	if (error)
+		return error;
+
+	/* Map in the xfile pages. */
+	for (m = 0, p = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++) {
+		for (n = 0; n < map->bm_len; n += BTOBB(PAGE_SIZE)) {
+			unsigned int	len;
+
+			len = min_t(unsigned int, BBTOB(map->bm_len - n),
+					PAGE_SIZE);
+
+			error = xfile_buf_get_page(bp->b_target->bt_xfile,
+					BBTOB(map->bm_bn + n), len,
+					&bp->b_pages[p++]);
+			if (error)
+				goto fail;
+		}
+	}
+
+	bp->b_flags |= _XBF_DIRECT_MAP;
+	return 0;
+
+fail:
+	/*
+	 * Release all the xfile pages and free the page array, we're falling
+	 * back to a DRAM buffer, which could be pages or a slab allocation.
+	 */
+	for (m = 0, p = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++) {
+		for (n = 0; n < map->bm_len; n += BTOBB(PAGE_SIZE)) {
+			if (bp->b_pages[p] == NULL)
+				continue;
+
+			xfile_buf_put_page(bp->b_target->bt_xfile,
+					BBTOB(map->bm_bn + n),
+					bp->b_pages[p++]);
+		}
+	}
+
+	xfs_buf_free_page_array(bp);
+	return error;
+}
+
+/* Unmap all the direct-mapped buffer pages. */
+void
+xfile_buf_unmap_pages(
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_map	*map;
+	unsigned int		m, p, n;
+	int			error = 0, err2;
+
+	ASSERT(xfile_buftarg_can_direct_map(bp->b_target));
+
+	for (m = 0, p = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++) {
+		for (n = 0; n < map->bm_len; n += BTOBB(PAGE_SIZE)) {
+			err2 = xfile_buf_put_page(bp->b_target->bt_xfile,
+					BBTOB(map->bm_bn + n),
+					bp->b_pages[p++]);
+			if (!error && err2)
+				error = err2;
+		}
+	}
+
+	if (error)
+		xfs_err(bp->b_mount, "%s failed errno %d", __func__, error);
+
+	bp->b_flags &= ~_XBF_DIRECT_MAP;
+	xfs_buf_free_page_array(bp);
+}
diff --git a/fs/xfs/xfs_buf_xfile.h b/fs/xfs/xfs_buf_xfile.h
index c3f0bb31a31a..d22c9bfa2bca 100644
--- a/fs/xfs/xfs_buf_xfile.h
+++ b/fs/xfs/xfs_buf_xfile.h
@@ -12,9 +12,20 @@ int xfile_alloc_buftarg(struct xfs_mount *mp, const char *descr,
 		struct xfs_buftarg **btpp);
 void xfile_free_buftarg(struct xfs_buftarg *btp);
 xfs_daddr_t xfile_buftarg_nr_sectors(struct xfs_buftarg *btp);
+int xfile_buf_map_pages(struct xfs_buf *bp, xfs_buf_flags_t flags);
+void xfile_buf_unmap_pages(struct xfs_buf *bp);
+
+static inline bool xfile_buftarg_can_direct_map(const struct xfs_buftarg *btp)
+{
+	return (btp->bt_flags & XFS_BUFTARG_XFILE) &&
+	       (btp->bt_flags & XFS_BUFTARG_DIRECT_MAP);
+}
 #else
 # define xfile_buf_ioapply(bp)			(-EOPNOTSUPP)
 # define xfile_buftarg_nr_sectors(btp)		(0)
+# define xfile_buf_map_pages(b,f)		(-ENOTBLK)
+# define xfile_buf_unmap_pages(bp)		((void)0)
+# define xfile_buftarg_can_direct_map(btp)	(false)
 #endif /* CONFIG_XFS_IN_MEMORY_FILE */
 
 #endif /* __XFS_BUF_XFILE_H__ */

