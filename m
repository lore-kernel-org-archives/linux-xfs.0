Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65890C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQ3Y5mHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2932DC433C7;
	Sun, 31 Dec 2023 22:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061014;
	bh=7wjWmEA3jsndhKmATqYIsVu88d5ggmmFL78mdg4lkcg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sQ3Y5mHuRfn8QOwmeB5VQRe0UrAEXHxA9MSqj+CuhWNLYRnjScyvuz2ZjGJPHAKpA
	 maBJA88xGmnj6Xaw+Yqg3CJQEdpXbMHtyeSqR+jfb4x87k2sDp3gidhE2wLSxvQkLS
	 /BQig5PsEcb1rrxR1cUVquCdu66MTmnQTnvHg4PIFnKxq114tJaRWL2GonqhW74OxX
	 D0gxCQx8pLDyGTsMfn4EtZHKVOmh1kT7REqoZyITJl0OaIdeqOo0Ie2TIObEofd0cZ
	 TJw4hYzy9y8jNJ/JUZx7aBCcDa3lJBEB25phbZYTbZnVRaWYetPg4O5DT58Nav0Qsd
	 l6zSl7b42ChPA==
Date: Sun, 31 Dec 2023 14:16:53 -0800
Subject: [PATCH 09/10] xfs: connect in-memory btrees to xfiles
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992903.1794490.9767263138314303775.stgit@frogsfrogsfrogs>
In-Reply-To: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
References: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
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

Add to our stubbed-out in-memory btrees the ability to connect them with
an actual in-memory backing file (aka xfiles) and the necessary pieces
to track free space in the xfile and flush dirty xfbtree buffers on
demand, which we'll need for online repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h    |   10 +
 include/xfs_trace.h    |    8 +
 include/xfs_trans.h    |    1 
 libfrog/bitmap.c       |   64 ++++++-
 libfrog/bitmap.h       |    3 
 libxfs/init.c          |   56 ++++++
 libxfs/trans.c         |   40 ++++
 libxfs/xfbtree.c       |  459 ++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfbtree.h       |   27 +++
 libxfs/xfile.c         |   16 ++
 libxfs/xfile.h         |    2 
 libxfs/xfs_btree_mem.h |   41 ++++
 12 files changed, 716 insertions(+), 11 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 98d5b199de8..80e40e7c60e 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -301,4 +301,14 @@ struct xfs_defer_drain { /* empty */ };
 static inline void xfs_perag_intent_hold(struct xfs_perag *pag) {}
 static inline void xfs_perag_intent_rele(struct xfs_perag *pag) {}
 
+static inline void libxfs_buftarg_drain(struct xfs_buftarg *btp)
+{
+	cache_purge(btp->bcache);
+}
+void libxfs_buftarg_free(struct xfs_buftarg *btp);
+
+int xfile_alloc_buftarg(struct xfs_mount *mp, const char *descr,
+		struct xfs_buftarg **btpp);
+void xfile_free_buftarg(struct xfs_buftarg *btp);
+
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index e7cbd0d9d41..57661f36d7c 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -6,6 +6,13 @@
 #ifndef __TRACE_H__
 #define __TRACE_H__
 
+#define trace_xfbtree_create(...)		((void) 0)
+#define trace_xfbtree_create_root_buf(...)	((void) 0)
+#define trace_xfbtree_alloc_block(...)		((void) 0)
+#define trace_xfbtree_free_block(...)		((void) 0)
+#define trace_xfbtree_trans_cancel_buf(...)	((void) 0)
+#define trace_xfbtree_trans_commit_buf(...)	((void) 0)
+
 #define trace_xfs_agfl_reset(a,b,c,d)		((void) 0)
 #define trace_xfs_agfl_free_defer(a,b,c,d,e)	((void) 0)
 #define trace_xfs_alloc_cur_check(a,b,c,d,e,f)	((void) 0)
@@ -204,6 +211,7 @@
 #define trace_xfs_trans_cancel(a,b)		((void) 0)
 #define trace_xfs_trans_brelse(a)		((void) 0)
 #define trace_xfs_trans_binval(a)		((void) 0)
+#define trace_xfs_trans_bdetach(a)		((void) 0)
 #define trace_xfs_trans_bjoin(a)		((void) 0)
 #define trace_xfs_trans_bhold(a)		((void) 0)
 #define trace_xfs_trans_bhold_release(a)	((void) 0)
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index ac82c3bc480..b7f01ff073c 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -114,6 +114,7 @@ int	libxfs_trans_roll_inode (struct xfs_trans **, struct xfs_inode *);
 void	libxfs_trans_brelse(struct xfs_trans *, struct xfs_buf *);
 void	libxfs_trans_binval(struct xfs_trans *, struct xfs_buf *);
 void	libxfs_trans_bjoin(struct xfs_trans *, struct xfs_buf *);
+void	libxfs_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
 void	libxfs_trans_bhold(struct xfs_trans *, struct xfs_buf *);
 void	libxfs_trans_bhold_release(struct xfs_trans *, struct xfs_buf *);
 void	libxfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index 5af5ab8dd6b..e1f3a5e1c84 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -233,10 +233,9 @@ bitmap_set(
 	return res;
 }
 
-#if 0	/* Unused, provided for completeness. */
 /* Clear a region of bits. */
-int
-bitmap_clear(
+static int
+__bitmap_clear(
 	struct bitmap		*bmap,
 	uint64_t		start,
 	uint64_t		len)
@@ -251,8 +250,8 @@ bitmap_clear(
 	uint64_t		new_length;
 	struct avl64node	*node;
 	int			stat;
+	int			ret = 0;
 
-	pthread_mutex_lock(&bmap->bt_lock);
 	/* Find any existing nodes over that range. */
 	avl64_findranges(bmap->bt_tree, start, start + len, &firstn, &lastn);
 
@@ -312,10 +311,24 @@ bitmap_clear(
 	}
 
 out:
-	pthread_mutex_unlock(&bmap->bt_lock);
 	return ret;
 }
-#endif
+
+/* Clear a region of bits. */
+int
+bitmap_clear(
+	struct bitmap		*bmap,
+	uint64_t		start,
+	uint64_t		length)
+{
+	int			res;
+
+	pthread_mutex_lock(&bmap->bt_lock);
+	res = __bitmap_clear(bmap, start, length);
+	pthread_mutex_unlock(&bmap->bt_lock);
+
+	return res;
+}
 
 /* Iterate the set regions of this bitmap. */
 int
@@ -438,3 +451,42 @@ bitmap_dump(
 	printf("BITMAP DUMP DONE\n");
 }
 #endif
+
+/*
+ * Find the first set bit in this bitmap, clear it, and return the index of
+ * that bit in @valp.  Returns -ENODATA if no bits were set, or the usual
+ * negative errno.
+ */
+int
+bitmap_take_first_set(
+	struct bitmap		*bmap,
+	uint64_t		start,
+	uint64_t		last,
+	uint64_t		*valp)
+{
+	struct avl64node	*firstn;
+	struct avl64node	*lastn;
+	struct bitmap_node	*ext;
+	uint64_t		val;
+	int			error;
+
+	pthread_mutex_lock(&bmap->bt_lock);
+
+	avl64_findranges(bmap->bt_tree, start, last + 1, &firstn, &lastn);
+
+	if (firstn == NULL && lastn == NULL) {
+		error = -ENODATA;
+		goto out;
+	}
+
+	ext = container_of(firstn, struct bitmap_node, btn_node);
+	val = ext->btn_start;
+	error = __bitmap_clear(bmap, val, 1);
+	if (error)
+		goto out;
+
+	*valp = val;
+out:
+	pthread_mutex_unlock(&bmap->bt_lock);
+	return error;
+}
diff --git a/libfrog/bitmap.h b/libfrog/bitmap.h
index 043b77eece6..896ae01f8f4 100644
--- a/libfrog/bitmap.h
+++ b/libfrog/bitmap.h
@@ -14,6 +14,7 @@ struct bitmap {
 int bitmap_alloc(struct bitmap **bmap);
 void bitmap_free(struct bitmap **bmap);
 int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
+int bitmap_clear(struct bitmap *bmap, uint64_t start, uint64_t length);
 int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
 		void *arg);
 int bitmap_iterate_range(struct bitmap *bmap, uint64_t start, uint64_t length,
@@ -22,5 +23,7 @@ bool bitmap_test(struct bitmap *bmap, uint64_t start,
 		uint64_t len);
 bool bitmap_empty(struct bitmap *bmap);
 void bitmap_dump(struct bitmap *bmap);
+int bitmap_take_first_set(struct bitmap *bmap, uint64_t start, uint64_t last,
+		uint64_t *valp);
 
 #endif /* __LIBFROG_BITMAP_H__ */
diff --git a/libxfs/init.c b/libxfs/init.c
index 6d088125f5d..72650447f1b 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -478,6 +478,60 @@ libxfs_buftarg_alloc(
 	return btp;
 }
 
+/* Allocate a buffer cache target for a memory-backed file. */
+int
+xfile_alloc_buftarg(
+	struct xfs_mount	*mp,
+	const char		*descr,
+	struct xfs_buftarg	**btpp)
+{
+	struct xfs_buftarg	*btp;
+	struct xfile		*xfile;
+	int			error;
+
+	error = xfile_create(descr, &xfile);
+	if (error)
+		return error;
+
+	btp = malloc(sizeof(*btp));
+	if (!btp) {
+		error = -ENOMEM;
+		goto out_xfile;
+	}
+
+	btp->bt_mount = mp;
+	btp->bt_xfile = xfile;
+	btp->flags = XFS_BUFTARG_XFILE;
+	btp->writes_left = 0;
+	pthread_mutex_init(&btp->lock, NULL);
+
+	/*
+	 * Keep the bucket count small because the only anticipated caller is
+	 * per-AG in-memory btrees, for which we don't need to scale to handle
+	 * an entire filesystem.
+	 */
+	btp->bcache = cache_init(0, 63, &libxfs_bcache_operations);
+
+	*btpp = btp;
+	return 0;
+out_xfile:
+	xfile_destroy(xfile);
+	return error;
+}
+
+/* Free a buffer cache target for a memory-backed file. */
+void
+xfile_free_buftarg(
+	struct xfs_buftarg	*btp)
+{
+	struct xfile		*xfile = btp->bt_xfile;
+
+	ASSERT(btp->flags & XFS_BUFTARG_XFILE);
+
+	libxfs_buftarg_free(btp);
+	xfile_destroy(xfile);
+}
+
 enum libxfs_write_failure_nums {
 	WF_DATA = 0,
 	WF_LOG,
@@ -881,7 +935,7 @@ libxfs_flush_mount(
 	return error;
 }
 
-static void
+void
 libxfs_buftarg_free(
 	struct xfs_buftarg	*btp)
 {
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 8143a6a99f6..7fec2caff49 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -614,6 +614,46 @@ libxfs_trans_brelse(
 	libxfs_buf_relse(bp);
 }
 
+/*
+ * Forcibly detach a buffer previously joined to the transaction.  The caller
+ * will retain its locked reference to the buffer after this function returns.
+ * The buffer must be completely clean and must not be held to the transaction.
+ */
+void
+libxfs_trans_bdetach(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
+	ASSERT(tp != NULL);
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
+
+	trace_xfs_trans_bdetach(bip);
+
+	/*
+	 * Erase all recursion count, since we're removing this buffer from the
+	 * transaction.
+	 */
+	bip->bli_recur = 0;
+
+	/*
+	 * The buffer must be completely clean.  Specifically, it had better
+	 * not be dirty, stale, logged, ordered, or held to the transaction.
+	 */
+	ASSERT(!test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags));
+	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY));
+	ASSERT(!(bip->bli_flags & XFS_BLI_HOLD));
+	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED));
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
+
+	/* Unlink the log item from the transaction and drop the log item. */
+	xfs_trans_del_item(&bip->bli_item);
+	xfs_buf_item_put(bip);
+	bp->b_transp = NULL;
+}
+
 /*
  * Mark the buffer as not needing to be unlocked when the buf item's
  * iop_unlock() routine is called.  The buffer must already be locked
diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
index 79585dd3a23..3cca7b5494c 100644
--- a/libxfs/xfbtree.c
+++ b/libxfs/xfbtree.c
@@ -8,6 +8,7 @@
 #include "xfile.h"
 #include "xfbtree.h"
 #include "xfs_btree_mem.h"
+#include "libfrog/bitmap.h"
 
 /* btree ops functions for in-memory btrees. */
 
@@ -133,9 +134,18 @@ xfbtree_check_ptr(
 	else
 		bt_xfoff = be32_to_cpu(ptr->s);
 
-	if (!xfbtree_verify_xfileoff(cur, bt_xfoff))
+	if (!xfbtree_verify_xfileoff(cur, bt_xfoff)) {
 		fa = __this_address;
+		goto done;
+	}
 
+	/* Can't point to the head or anything before it */
+	if (bt_xfoff < XFBTREE_INIT_LEAF_BLOCK) {
+		fa = __this_address;
+		goto done;
+	}
+
+done:
 	if (fa) {
 		xfs_err(cur->bc_mp,
 "In-memory: Corrupt btree %d flags 0x%x pointer at level %d index %d fa %pS.",
@@ -341,3 +351,450 @@ xfbtree_sblock_verify(
 
 	return NULL;
 }
+
+/* Close the btree xfile and release all resources. */
+void
+xfbtree_destroy(
+	struct xfbtree		*xfbt)
+{
+	bitmap_free(&xfbt->freespace);
+	kmem_free(xfbt->freespace);
+	libxfs_buftarg_drain(xfbt->target);
+	kmem_free(xfbt);
+}
+
+/* Compute the number of bytes available for records. */
+static inline unsigned int
+xfbtree_rec_bytes(
+	struct xfs_mount		*mp,
+	const struct xfbtree_config	*cfg)
+{
+	unsigned int			blocklen = xfo_to_b(1);
+
+	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS) {
+		if (xfs_has_crc(mp))
+			return blocklen - XFS_BTREE_LBLOCK_CRC_LEN;
+
+		return blocklen - XFS_BTREE_LBLOCK_LEN;
+	}
+
+	if (xfs_has_crc(mp))
+		return blocklen - XFS_BTREE_SBLOCK_CRC_LEN;
+
+	return blocklen - XFS_BTREE_SBLOCK_LEN;
+}
+
+/* Initialize an empty leaf block as the btree root. */
+STATIC int
+xfbtree_init_leaf_block(
+	struct xfs_mount		*mp,
+	struct xfbtree			*xfbt,
+	const struct xfbtree_config	*cfg)
+{
+	struct xfs_buf			*bp;
+	xfs_daddr_t			daddr;
+	int				error;
+	unsigned int			bc_flags = 0;
+
+	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS)
+		bc_flags |= XFS_BTREE_LONG_PTRS;
+
+	daddr = xfo_to_daddr(XFBTREE_INIT_LEAF_BLOCK);
+	error = xfs_buf_get(xfbt->target, daddr, xfbtree_bbsize(), &bp);
+	if (error)
+		return error;
+
+	trace_xfbtree_create_root_buf(xfbt, bp);
+
+	bp->b_ops = cfg->btree_ops->buf_ops;
+	xfs_btree_init_block_int(mp, bp->b_addr, daddr, cfg->btnum, 0, 0,
+			cfg->owner, bc_flags);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		return error;
+
+	xfbt->xf_used++;
+	return 0;
+}
+
+/* Initialize the in-memory btree header block. */
+STATIC int
+xfbtree_init_head(
+	struct xfbtree		*xfbt)
+{
+	struct xfs_buf		*bp;
+	xfs_daddr_t		daddr;
+	int			error;
+
+	daddr = xfo_to_daddr(XFBTREE_HEAD_BLOCK);
+	error = xfs_buf_get(xfbt->target, daddr, xfbtree_bbsize(), &bp);
+	if (error)
+		return error;
+
+	xfs_btree_mem_head_init(bp, xfbt->owner, XFBTREE_INIT_LEAF_BLOCK);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		return error;
+
+	xfbt->xf_used++;
+	return 0;
+}
+
+/* Create an xfile btree backing thing that can be used for in-memory btrees. */
+int
+xfbtree_create(
+	struct xfs_mount		*mp,
+	const struct xfbtree_config	*cfg,
+	struct xfbtree			**xfbtreep)
+{
+	struct xfbtree			*xfbt;
+	unsigned int			blocklen = xfbtree_rec_bytes(mp, cfg);
+	unsigned int			keyptr_len = cfg->btree_ops->key_len;
+	int				error;
+
+	/* Requires an xfile-backed buftarg. */
+	if (!(cfg->target->flags & XFS_BUFTARG_XFILE)) {
+		ASSERT(cfg->target->flags & XFS_BUFTARG_XFILE);
+		return -EINVAL;
+	}
+
+	xfbt = kmem_zalloc(sizeof(struct xfbtree), KM_NOFS | KM_MAYFAIL);
+	if (!xfbt)
+		return -ENOMEM;
+
+	/* Assign our memory file and the free space bitmap. */
+	xfbt->target = cfg->target;
+	error = bitmap_alloc(&xfbt->freespace);
+	if (error)
+		goto err_buftarg;
+
+	/* Set up min/maxrecs for this btree. */
+	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS)
+		keyptr_len += sizeof(__be64);
+	else
+		keyptr_len += sizeof(__be32);
+	xfbt->maxrecs[0] = blocklen / cfg->btree_ops->rec_len;
+	xfbt->maxrecs[1] = blocklen / keyptr_len;
+	xfbt->minrecs[0] = xfbt->maxrecs[0] / 2;
+	xfbt->minrecs[1] = xfbt->maxrecs[1] / 2;
+	xfbt->owner = cfg->owner;
+
+	/* Initialize the empty btree. */
+	error = xfbtree_init_leaf_block(mp, xfbt, cfg);
+	if (error)
+		goto err_freesp;
+
+	error = xfbtree_init_head(xfbt);
+	if (error)
+		goto err_freesp;
+
+	trace_xfbtree_create(mp, cfg, xfbt);
+
+	*xfbtreep = xfbt;
+	return 0;
+
+err_freesp:
+	bitmap_free(&xfbt->freespace);
+	kmem_free(xfbt->freespace);
+err_buftarg:
+	libxfs_buftarg_drain(xfbt->target);
+	kmem_free(xfbt);
+	return error;
+}
+
+/* Read the in-memory btree head. */
+int
+xfbtree_head_read_buf(
+	struct xfbtree		*xfbt,
+	struct xfs_trans	*tp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_buftarg	*btp = xfbt->target;
+	struct xfs_mount	*mp = btp->bt_mount;
+	struct xfs_btree_mem_head *mhead;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		daddr;
+	int			error;
+
+	daddr = xfo_to_daddr(XFBTREE_HEAD_BLOCK);
+	error = xfs_trans_read_buf(mp, tp, btp, daddr, xfbtree_bbsize(), 0,
+			&bp, &xfs_btree_mem_head_buf_ops);
+	if (error)
+		return error;
+
+	mhead = bp->b_addr;
+	if (be64_to_cpu(mhead->mh_owner) != xfbt->owner) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+		xfs_trans_brelse(tp, bp);
+		return -EFSCORRUPTED;
+	}
+
+	*bpp = bp;
+	return 0;
+}
+
+static inline struct xfile *xfbtree_xfile(struct xfbtree *xfbt)
+{
+	return xfbt->target->bt_xfile;
+}
+
+/* Allocate a block to our in-memory btree. */
+int
+xfbtree_alloc_block(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*start,
+	union xfs_btree_ptr		*new,
+	int				*stat)
+{
+	struct xfbtree			*xfbt = cur->bc_mem.xfbtree;
+	uint64_t			bt_xfoff;
+	loff_t				pos;
+	int				error;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
+
+	/*
+	 * Find the first free block in the free space bitmap and take it.  If
+	 * none are found, seek to end of the file.
+	 */
+	error = bitmap_take_first_set(xfbt->freespace, 0, -1ULL, &bt_xfoff);
+	if (error == -ENODATA) {
+		bt_xfoff = xfbt->xf_used;
+		xfbt->xf_used++;
+	} else if (error) {
+		return error;
+	}
+
+	trace_xfbtree_alloc_block(xfbt, cur, bt_xfoff);
+
+	/* Fail if the block address exceeds the maximum for short pointers. */
+	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && bt_xfoff >= INT_MAX) {
+		*stat = 0;
+		return 0;
+	}
+
+	/* Make sure we actually can write to the block before we return it. */
+	pos = xfo_to_b(bt_xfoff);
+	error = xfile_prealloc(xfbtree_xfile(xfbt), pos, xfo_to_b(1));
+	if (error)
+		return error;
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		new->l = cpu_to_be64(bt_xfoff);
+	else
+		new->s = cpu_to_be32(bt_xfoff);
+
+	*stat = 1;
+	return 0;
+}
+
+/* Free a block from our in-memory btree. */
+int
+xfbtree_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	struct xfbtree		*xfbt = cur->bc_mem.xfbtree;
+	xfileoff_t		bt_xfoff, bt_xflen;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
+
+	bt_xfoff = xfs_daddr_to_xfot(xfs_buf_daddr(bp));
+	bt_xflen = xfs_daddr_to_xfot(bp->b_length);
+
+	trace_xfbtree_free_block(xfbt, cur, bt_xfoff);
+
+	return bitmap_set(xfbt->freespace, bt_xfoff, bt_xflen);
+}
+
+/* Return the minimum number of records for a btree block. */
+int
+xfbtree_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	struct xfbtree		*xfbt = cur->bc_mem.xfbtree;
+
+	return xfbt->minrecs[level != 0];
+}
+
+/* Return the maximum number of records for a btree block. */
+int
+xfbtree_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	struct xfbtree		*xfbt = cur->bc_mem.xfbtree;
+
+	return xfbt->maxrecs[level != 0];
+}
+
+/* If this log item is a buffer item that came from the xfbtree, return it. */
+static inline struct xfs_buf *
+xfbtree_buf_match(
+	struct xfbtree			*xfbt,
+	const struct xfs_log_item	*lip)
+{
+	const struct xfs_buf_log_item	*bli;
+	struct xfs_buf			*bp;
+
+	if (lip->li_type != XFS_LI_BUF)
+		return NULL;
+
+	bli = container_of(lip, struct xfs_buf_log_item, bli_item);
+	bp = bli->bli_buf;
+	if (bp->b_target != xfbt->target)
+		return NULL;
+
+	return bp;
+}
+
+/*
+ * Detach this (probably dirty) xfbtree buffer from the transaction by any
+ * means necessary.  Returns true if the buffer needs to be written.
+ */
+STATIC bool
+xfbtree_trans_bdetach(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bli = bp->b_log_item;
+	bool			dirty;
+
+	ASSERT(bli != NULL);
+
+	dirty = bli->bli_flags & (XFS_BLI_DIRTY | XFS_BLI_ORDERED);
+
+	bli->bli_flags &= ~(XFS_BLI_DIRTY | XFS_BLI_ORDERED |
+			    XFS_BLI_STALE);
+	clear_bit(XFS_LI_DIRTY, &bli->bli_item.li_flags);
+
+	while (bp->b_log_item != NULL)
+		libxfs_trans_bdetach(tp, bp);
+
+	return dirty;
+}
+
+/*
+ * Commit changes to the incore btree immediately by writing all dirty xfbtree
+ * buffers to the backing xfile.  This detaches all xfbtree buffers from the
+ * transaction, even on failure.  The buffer locks are dropped between the
+ * delwri queue and submit, so the caller must synchronize btree access.
+ *
+ * Normally we'd let the buffers commit with the transaction and get written to
+ * the xfile via the log, but online repair stages ephemeral btrees in memory
+ * and uses the btree_staging functions to write new btrees to disk atomically.
+ * The in-memory btree (and its backing store) are discarded at the end of the
+ * repair phase, which means that xfbtree buffers cannot commit with the rest
+ * of a transaction.
+ *
+ * In other words, online repair only needs the transaction to collect buffer
+ * pointers and to avoid buffer deadlocks, not to guarantee consistency of
+ * updates.
+ */
+int
+xfbtree_trans_commit(
+	struct xfbtree		*xfbt,
+	struct xfs_trans	*tp)
+{
+	LIST_HEAD(buffer_list);
+	struct xfs_log_item	*lip, *n;
+	bool			corrupt = false;
+	bool			tp_dirty = false;
+
+	/*
+	 * For each xfbtree buffer attached to the transaction, write the dirty
+	 * buffers to the xfile and release them.
+	 */
+	list_for_each_entry_safe(lip, n, &tp->t_items, li_trans) {
+		struct xfs_buf	*bp = xfbtree_buf_match(xfbt, lip);
+		bool		dirty;
+
+		if (!bp) {
+			if (test_bit(XFS_LI_DIRTY, &lip->li_flags))
+				tp_dirty |= true;
+			continue;
+		}
+
+		trace_xfbtree_trans_commit_buf(xfbt, bp);
+
+		dirty = xfbtree_trans_bdetach(tp, bp);
+		if (dirty && !corrupt) {
+			xfs_failaddr_t	fa = bp->b_ops->verify_struct(bp);
+
+			/*
+			 * Because this btree is ephemeral, validate the buffer
+			 * structure before delwri_submit so that we can return
+			 * corruption errors to the caller without shutting
+			 * down the filesystem.
+			 *
+			 * If the buffer fails verification, log the failure
+			 * but continue walking the transaction items so that
+			 * we remove all ephemeral btree buffers.
+			 */
+			if (fa) {
+				corrupt = true;
+				xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+			} else {
+				xfs_buf_delwri_queue_here(bp, &buffer_list);
+			}
+		}
+
+		xfs_buf_relse(bp);
+	}
+
+	/*
+	 * Reset the transaction's dirty flag to reflect the dirty state of the
+	 * log items that are still attached.
+	 */
+	tp->t_flags = (tp->t_flags & ~XFS_TRANS_DIRTY) |
+			(tp_dirty ? XFS_TRANS_DIRTY : 0);
+
+	if (corrupt) {
+		xfs_buf_delwri_cancel(&buffer_list);
+		return -EFSCORRUPTED;
+	}
+
+	if (list_empty(&buffer_list))
+		return 0;
+
+	return xfs_buf_delwri_submit(&buffer_list);
+}
+
+/*
+ * Cancel changes to the incore btree by detaching all the xfbtree buffers.
+ * Changes are not written to the backing store.  This is needed for online
+ * repair btrees, which are by nature ephemeral.
+ */
+void
+xfbtree_trans_cancel(
+	struct xfbtree		*xfbt,
+	struct xfs_trans	*tp)
+{
+	struct xfs_log_item	*lip, *n;
+	bool			tp_dirty = false;
+
+	list_for_each_entry_safe(lip, n, &tp->t_items, li_trans) {
+		struct xfs_buf	*bp = xfbtree_buf_match(xfbt, lip);
+
+		if (!bp) {
+			if (test_bit(XFS_LI_DIRTY, &lip->li_flags))
+				tp_dirty |= true;
+			continue;
+		}
+
+		trace_xfbtree_trans_cancel_buf(xfbt, bp);
+
+		xfbtree_trans_bdetach(tp, bp);
+		xfs_buf_relse(bp);
+	}
+
+	/*
+	 * Reset the transaction's dirty flag to reflect the dirty state of the
+	 * log items that are still attached.
+	 */
+	tp->t_flags = (tp->t_flags & ~XFS_TRANS_DIRTY) |
+			(tp_dirty ? XFS_TRANS_DIRTY : 0);
+}
diff --git a/libxfs/xfbtree.h b/libxfs/xfbtree.h
index 292bade32d2..ac6d499afe5 100644
--- a/libxfs/xfbtree.h
+++ b/libxfs/xfbtree.h
@@ -19,18 +19,39 @@ struct xfs_btree_mem_head {
 
 #define XFS_BTREE_MEM_HEAD_MAGIC	0x4341544D	/* "CATM" */
 
-/* in-memory btree header is always block 0 in the backing store */
-#define XFS_BTREE_MEM_HEAD_DADDR	0
-
 /* xfile-backed in-memory btrees */
 
 struct xfbtree {
+	/* buffer cache target for the xfile backing this in-memory btree */
 	struct xfs_buftarg		*target;
 
+	/* Bitmap of free space from pos to used */
+	struct bitmap			*freespace;
+
+	/* Number of xfile blocks actually used by this xfbtree. */
+	xfileoff_t			xf_used;
+
 	/* Owner of this btree. */
 	unsigned long long		owner;
+
+	/* Minimum and maximum records per block. */
+	unsigned int			maxrecs[2];
+	unsigned int			minrecs[2];
 };
 
+/* The head of the in-memory btree is always at block 0 */
+#define XFBTREE_HEAD_BLOCK		0
+
+/* in-memory btrees are always created with an empty leaf block at block 1 */
+#define XFBTREE_INIT_LEAF_BLOCK		1
+
+int xfbtree_head_read_buf(struct xfbtree *xfbt, struct xfs_trans *tp,
+		struct xfs_buf **bpp);
+
+void xfbtree_destroy(struct xfbtree *xfbt);
+int xfbtree_trans_commit(struct xfbtree *xfbt, struct xfs_trans *tp);
+void xfbtree_trans_cancel(struct xfbtree *xfbt, struct xfs_trans *tp);
+
 #endif /* CONFIG_XFS_BTREE_IN_XFILE */
 
 #endif /* __LIBXFS_XFBTREE_H__ */
diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index d6eefadae69..b7199091f05 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -281,3 +281,19 @@ xfile_dump(
 
 	return execvp("od", argv);
 }
+
+/* Ensure that there is storage backing the given range. */
+int
+xfile_prealloc(
+	struct xfile	*xf,
+	loff_t		pos,
+	uint64_t	count)
+{
+	int		error;
+
+	count = min(count, xfile_maxbytes(xf) - pos);
+	error = fallocate(xf->fd, 0, pos, count);
+	if (error)
+		return -errno;
+	return 0;
+}
diff --git a/libxfs/xfile.h b/libxfs/xfile.h
index e762e392caa..0d15351d697 100644
--- a/libxfs/xfile.h
+++ b/libxfs/xfile.h
@@ -46,6 +46,8 @@ xfile_obj_store(struct xfile *xf, const void *buf, size_t count, loff_t pos)
 	return 0;
 }
 
+int xfile_prealloc(struct xfile *xf, loff_t pos, uint64_t count);
+
 struct xfile_stat {
 	loff_t			size;
 	unsigned long long	bytes;
diff --git a/libxfs/xfs_btree_mem.h b/libxfs/xfs_btree_mem.h
index 2c42ca85c58..29f97c50304 100644
--- a/libxfs/xfs_btree_mem.h
+++ b/libxfs/xfs_btree_mem.h
@@ -8,6 +8,26 @@
 
 struct xfbtree;
 
+struct xfbtree_config {
+	/* Buffer ops for the btree root block */
+	const struct xfs_btree_ops	*btree_ops;
+
+	/* Buffer target for the xfile backing this btree. */
+	struct xfs_buftarg		*target;
+
+	/* Owner of this btree. */
+	unsigned long long		owner;
+
+	/* Btree type number */
+	xfs_btnum_t			btnum;
+
+	/* XFBTREE_CREATE_* flags */
+	unsigned int			flags;
+};
+
+/* btree has long pointers */
+#define XFBTREE_CREATE_LONG_PTRS	(1U << 0)
+
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
 unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
 
@@ -35,6 +55,16 @@ xfs_failaddr_t xfbtree_lblock_verify(struct xfs_buf *bp, unsigned int max_recs);
 xfs_failaddr_t xfbtree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
 unsigned long long xfbtree_buf_to_xfoff(struct xfs_btree_cur *cur,
 		struct xfs_buf *bp);
+
+int xfbtree_get_minrecs(struct xfs_btree_cur *cur, int level);
+int xfbtree_get_maxrecs(struct xfs_btree_cur *cur, int level);
+
+int xfbtree_create(struct xfs_mount *mp, const struct xfbtree_config *cfg,
+		struct xfbtree **xfbtreep);
+int xfbtree_alloc_block(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *start, union xfs_btree_ptr *ptr,
+		int *stat);
+int xfbtree_free_block(struct xfs_btree_cur *cur, struct xfs_buf *bp);
 #else
 static inline unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp)
 {
@@ -77,11 +107,22 @@ static inline unsigned int xfbtree_bbsize(void)
 #define xfbtree_set_root			NULL
 #define xfbtree_init_ptr_from_cur		NULL
 #define xfbtree_dup_cursor			NULL
+#define xfbtree_get_minrecs			NULL
+#define xfbtree_get_maxrecs			NULL
+#define xfbtree_alloc_block			NULL
+#define xfbtree_free_block			NULL
 #define xfbtree_verify_xfileoff(cur, xfoff)	(false)
 #define xfbtree_check_block_owner(cur, block)	NULL
 #define xfbtree_owner(cur)			(0ULL)
 #define xfbtree_buf_to_xfoff(cur, bp)		(-1)
 
+static inline int
+xfbtree_create(struct xfs_mount *mp, const struct xfbtree_config *cfg,
+		struct xfbtree **xfbtreep)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_XFS_BTREE_IN_XFILE */
 
 #endif /* __XFS_BTREE_MEM_H__ */

