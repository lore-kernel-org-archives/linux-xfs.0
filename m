Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAFEC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiLaAE3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiLaAE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:04:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C83A1E3D6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:04:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB17B61CAD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CF0C433D2;
        Sat, 31 Dec 2022 00:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445065;
        bh=K+aTYTXJNjQ1L18m8S1xD7AgdyuxYy6B+UDbYt9GyYs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LUCi80FCa/9CxKbHhCUlJ9ywhPisJuEifrU8vzns2B1d6eBU6N+a2nAFmV3sIa7Mw
         o10XP4IZll0zHOHP4l+A6pUH0p2RV6NV44PLi5kdYiLaGItpcyk1pbXp9M//n2l/Ez
         EvtN5KaZdNGReFXM+uKcO/AIiw4tXKRS0yGIGZmZ0zkEAKXypIY9tgtI+l84i5SsaY
         OhibOt2g4We8NQAA13NYyn0ViJGOc3LIdXbhBFwOiMki3YQkoPM4rmHAVPmWoOcng+
         nvxF21bAejw5+nCh0Hs68sQNVh0mMCoahhqQl7+SS9PGFHGHXZM6+P/I7apo+DbKkM
         YtxcjegrXbzWg==
Subject: [PATCH 1/3] xfs: map xfile pages directly into xfs_buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:32 -0800
Message-ID: <167243847278.701196.1405986469822536618.stgit@magnolia>
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

Map the xfile pages directly into xfs_buf to reduce memory overhead.
It's silly to use memory to stage changes to shmem pages for ephemeral
btrees that don't care about transactionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_mem.h  |    6 +
 fs/xfs/libxfs/xfs_rmap_btree.c |    1 
 fs/xfs/scrub/rcbag_btree.c     |    1 
 fs/xfs/scrub/xfbtree.c         |   23 ++++-
 fs/xfs/xfs_buf.c               |  202 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_buf.h               |   10 ++
 6 files changed, 236 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_mem.h b/fs/xfs/libxfs/xfs_btree_mem.h
index ee142b972839..8feb104522b5 100644
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
 #ifdef CONFIG_XFS_IN_MEMORY_BTREE
 unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index ebd86c559837..1b88766ac497 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -670,6 +670,7 @@ xfs_rmapbt_mem_create(
 		.btree_ops	= &xfs_rmapbt_mem_ops,
 		.target		= target,
 		.owner		= agno,
+		.flags		= XFBTREE_DIRECT_MAP,
 	};
 
 	return xfbtree_create(mp, &cfg, xfbtreep);
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
index 3aa40149e34d..26cc5a35c378 100644
--- a/fs/xfs/scrub/rcbag_btree.c
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -232,6 +232,7 @@ rcbagbt_mem_create(
 	struct xfbtree_config	cfg = {
 		.btree_ops	= &rcbagbt_mem_ops,
 		.target		= target,
+		.flags		= XFBTREE_DIRECT_MAP,
 	};
 
 	return xfbtree_create(mp, &cfg, xfbtreep);
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index 072e1d8b813e..55d530213d40 100644
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
index b65dab243130..e00682cd8901 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -272,6 +272,61 @@ _xfs_buf_alloc(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_IN_MEMORY_FILE
+/* Free an xfile page that was directly mapped into the buffer cache. */
+static int
+xfs_buf_free_xfpage(
+	struct xfile		*xfile,
+	loff_t			pos,
+	struct page		**pagep)
+{
+	struct xfile_page	xfpage = {
+		.page		= *pagep,
+		.pos		= round_down(pos, PAGE_SIZE),
+	};
+
+	*pagep = NULL;
+	lock_page(xfpage.page);
+
+	return xfile_put_page(xfile, &xfpage);
+}
+
+/* Unmap all the direct-mapped buffer pages. */
+static void
+xfs_buf_free_direct_pages(
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_map	*map;
+	unsigned int		m, p, n;
+	int			error = 0, err2;
+
+	ASSERT(bp->b_target->bt_flags & XFS_BUFTARG_DIRECT_MAP);
+
+	if (xfs_buf_is_vmapped(bp))
+		vm_unmap_ram(bp->b_addr, bp->b_page_count);
+
+	for (m = 0, p = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++) {
+		for (n = 0; n < map->bm_len; n += BTOBB(PAGE_SIZE)) {
+			err2 = xfs_buf_free_xfpage(bp->b_target->bt_xfile,
+					BBTOB(map->bm_bn + n),
+					&bp->b_pages[p++]);
+			if (!error && err2)
+				error = err2;
+		}
+	}
+
+	if (error)
+		xfs_err(bp->b_mount, "%s failed errno %d", __func__, error);
+
+	if (bp->b_pages != bp->b_page_array)
+		kmem_free(bp->b_pages);
+	bp->b_pages = NULL;
+	bp->b_flags &= ~_XBF_DIRECT_MAP;
+}
+#else
+# define xfs_buf_free_direct_pages(b)	((void)0)
+#endif /* CONFIG_XFS_IN_MEMORY_FILE */
+
 static void
 xfs_buf_free_pages(
 	struct xfs_buf	*bp)
@@ -314,7 +369,9 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_lru));
 
-	if (bp->b_flags & _XBF_PAGES)
+	if (bp->b_flags & _XBF_DIRECT_MAP)
+		xfs_buf_free_direct_pages(bp);
+	else if (bp->b_flags & _XBF_PAGES)
 		xfs_buf_free_pages(bp);
 	else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
@@ -411,6 +468,118 @@ xfs_buf_alloc_pages(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_IN_MEMORY_FILE
+/* Grab the xfile page for this part of the xfile. */
+static int
+xfs_buf_get_xfpage(
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
+static int
+xfs_buf_alloc_direct_pages(
+	struct xfs_buf		*bp,
+	xfs_buf_flags_t		flags)
+{
+	struct xfs_buf_map	*map;
+	gfp_t			gfp_mask = __GFP_NOWARN;
+	const unsigned int	page_align_mask = PAGE_SIZE - 1;
+	unsigned int		m, p, n;
+	int			error;
+
+	ASSERT(bp->b_target->bt_flags & XFS_BUFTARG_IN_MEMORY);
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
+	/* Make sure that we have a page list */
+	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
+	if (bp->b_page_count <= XB_PAGES) {
+		bp->b_pages = bp->b_page_array;
+	} else {
+		bp->b_pages = kzalloc(sizeof(struct page *) * bp->b_page_count,
+					gfp_mask);
+		if (!bp->b_pages)
+			return -ENOMEM;
+	}
+
+	/* Map in the xfile pages. */
+	for (m = 0, p = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++) {
+		for (n = 0; n < map->bm_len; n += BTOBB(PAGE_SIZE)) {
+			unsigned int	len;
+
+			len = min_t(unsigned int, BBTOB(map->bm_len - n),
+					PAGE_SIZE);
+
+			error = xfs_buf_get_xfpage(bp->b_target->bt_xfile,
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
+	for (m = 0, p = 0, map = bp->b_maps; m < bp->b_map_count; m++, map++) {
+		for (n = 0; n < map->bm_len; n += BTOBB(PAGE_SIZE)) {
+			if (bp->b_pages[p] == NULL)
+				continue;
+
+			xfs_buf_free_xfpage(bp->b_target->bt_xfile,
+					BBTOB(map->bm_bn + n),
+					&bp->b_pages[p++]);
+		}
+	}
+
+	if (bp->b_pages != bp->b_page_array)
+		kmem_free(bp->b_pages);
+	bp->b_pages = NULL;
+	bp->b_page_count = 0;
+	return error;
+}
+#else
+# define xfs_buf_alloc_direct_pages(b,f)	(-ENOTBLK)
+#endif /* CONFIG_XFS_IN_MEMORY_FILE */
+
 /*
  *	Map buffer into kernel address-space if necessary.
  */
@@ -419,7 +588,8 @@ _xfs_buf_map_pages(
 	struct xfs_buf		*bp,
 	xfs_buf_flags_t		flags)
 {
-	ASSERT(bp->b_flags & _XBF_PAGES);
+	ASSERT(bp->b_flags & (_XBF_PAGES | _XBF_DIRECT_MAP));
+
 	if (bp->b_page_count == 1) {
 		/* A single page buffer is always mappable */
 		bp->b_addr = page_address(bp->b_pages[0]);
@@ -566,7 +736,7 @@ xfs_buf_find_lock(
 	 */
 	if (bp->b_flags & XBF_STALE) {
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
+		bp->b_flags &= _XBF_KMEM | _XBF_PAGES | _XBF_DIRECT_MAP;
 		bp->b_ops = NULL;
 	}
 	return 0;
@@ -625,6 +795,13 @@ xfs_buf_find_insert(
 	if (error)
 		goto out_drop_pag;
 
+	/* Try to map pages directly, or fall back to memory. */
+	if (btp->bt_flags & XFS_BUFTARG_DIRECT_MAP) {
+		error = xfs_buf_alloc_direct_pages(new_bp, flags);
+		if (error && error != -ENOTBLK)
+			goto out_free_buf;
+	}
+
 	/*
 	 * For buffers that fit entirely within a single page, first attempt to
 	 * allocate the memory from the heap to minimise memory usage. If we
@@ -1569,7 +1746,10 @@ xfs_buf_ioapply_in_memory(
 
 	atomic_inc(&bp->b_io_remaining);
 
-	if (bp->b_map_count > 1) {
+	if (bp->b_target->bt_flags & XFS_BUFTARG_DIRECT_MAP) {
+		/* direct mapping means no io necessary */
+		error = 0;
+	} else if (bp->b_map_count > 1) {
 		/* We don't need or support multi-map buffers. */
 		ASSERT(0);
 		error = -EIO;
@@ -1588,6 +1768,20 @@ xfs_buf_ioapply_in_memory(
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
index d74ce9080282..c3ab1c6652dc 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -43,6 +43,7 @@ struct xfile;
 #define _XBF_PAGES	 (1u << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
+#define _XBF_DIRECT_MAP	 (1u << 23)/* pages directly mapped to storage */
 
 /* flags used only as arguments to access routines */
 /*
@@ -72,6 +73,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
+	{ _XBF_DIRECT_MAP,	"DIRECT_MAP" }, \
 	/* The following interface flags should never be set */ \
 	{ XBF_BCACHE_SCAN,	"BCACHE_SCAN" }, \
 	{ XBF_INCORE,		"INCORE" }, \
@@ -135,6 +137,13 @@ typedef struct xfs_buftarg {
 # define XFS_BUFTARG_IN_MEMORY	(0)
 #endif
 
+/* buffer pages are direct-mapped (implies IN_MEMORY) */
+#ifdef CONFIG_XFS_IN_MEMORY_FILE
+# define XFS_BUFTARG_DIRECT_MAP	(1U << 2)
+#else
+# define XFS_BUFTARG_DIRECT_MAP	(0)
+#endif
+
 static inline bool
 xfs_buftarg_in_memory(
 	struct xfs_buftarg	*btp)
@@ -458,5 +467,6 @@ xfs_buftarg_verify_daddr(
 int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
 bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
+bool xfs_buf_check_poisoned(struct xfs_buf *bp);
 
 #endif	/* __XFS_BUF_H__ */

