Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9D771B50
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425178; cv=none; b=ot1QCZlu7FmELoxdvfzbUV6Ymh1dKBEibpr08IvyyEWikzowt6nP2nIuXHoFlt4bPBF2UcmJGUpNXDI8vIoT3iGWGUJCjG7aT1xrDjjLIl2KR7Ua44xEBgLkvjCmkIBGi/BMZOqQkqBBPm+frifAHKyDSlIwxsZ7o40ngwS35wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425178; c=relaxed/simple;
	bh=qbUXAiOz+FDEB1KoGBNu2cKHT2J7DWhCMotrH6fkky4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OD8POkFD7Pt8WDUC5V7ELub6bVH9yWkhosXlWO0KPwwqkh+xnHnCnsHZJiLu0LOnqU8hj8qngrSpa4c5PZW4wjw6MjJysdpCO2PTBFlKIgPAme1ulYBYPlFXj2qtf/tVyXVq2fqkMnHu4c+9swcmmuVzbkcXSGx1GlHwChITY0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QsOOKDPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QsOOKDPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BC2C433C7;
	Tue, 26 Mar 2024 03:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425177;
	bh=qbUXAiOz+FDEB1KoGBNu2cKHT2J7DWhCMotrH6fkky4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QsOOKDPt7WCJTO2LyfbAuz70J2FKnsLr5MhYAtASfrRAs8u7gOOof78imiJemqWEw
	 INfJdIoh/03M9oKpQsS3RrIthZmfzSBHHd0Zje27bo9ayqjyG8/eRpYYQrqRoun+aP
	 sDPqpz290dlnTGGiu+tMyIWWBCJjZ4RTTdCjC5BO8E2XmrwWiunasus6A+blXSTjWs
	 ncMSeWcUcSS5d4cvUN7i0qnmRp8FZrxCiWjr3jl8eSnRGqTUI5mnhVxRynfx2KeH+U
	 HnaQQv+5zXnstUEp7r8WDZ6EuU4YrxkHYhnxn7Z3+Ii6/9bsDztLMfUiSghXVBaa3w
	 UVM8SekCbRD8Q==
Date: Mon, 25 Mar 2024 20:52:57 -0700
Subject: [PATCH 094/110] xfs: support in-memory btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132733.2215168.1215845331783138642.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: a095686a2383526d7315197e2419d84ee8470217

Adapt the generic btree cursor code to be able to create a btree whose
buffers come from a (presumably in-memory) buftarg with a header block
that's specific to in-memory btrees.  We'll connect this to other parts
of online scrub in the next patches.

Note that in-memory btrees always have a block size matching the system
memory page size for efficiency reasons.  There are also a few things we
need to do to finalize a btree update; that's covered in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h         |    2 
 include/xfs_mount.h      |    5 +
 include/xfs_trace.h      |    7 +
 libxfs/Makefile          |    2 
 libxfs/buf_mem.c         |   13 ++
 libxfs/buf_mem.h         |    2 
 libxfs/libxfs_api_defs.h |    1 
 libxfs/libxfs_io.h       |   10 ++
 libxfs/libxfs_priv.h     |    3 +
 libxfs/xfs_btree.c       |  257 +++++++++++++++++++++++++++++++++++++++-------
 libxfs/xfs_btree.h       |    7 +
 libxfs/xfs_btree_mem.c   |  227 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_btree_mem.h   |   72 +++++++++++++
 13 files changed, 571 insertions(+), 37 deletions(-)
 create mode 100644 libxfs/xfs_btree_mem.c
 create mode 100644 libxfs/xfs_btree_mem.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 60d3b7968775..563c40e5745e 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -9,6 +9,8 @@
 
 /* For userspace XFS_RT is always defined */
 #define CONFIG_XFS_RT
+/* Ditto in-memory btrees */
+#define CONFIG_XFS_BTREE_IN_MEM
 
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 98d5b199de8c..9c492b8f5e4c 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -301,4 +301,9 @@ struct xfs_defer_drain { /* empty */ };
 static inline void xfs_perag_intent_hold(struct xfs_perag *pag) {}
 static inline void xfs_perag_intent_rele(struct xfs_perag *pag) {}
 
+static inline void libxfs_buftarg_drain(struct xfs_buftarg *btp)
+{
+	cache_purge(btp->bcache);
+}
+
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index df25dc2a9d62..6c8eeff1e62a 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -6,6 +6,13 @@
 #ifndef __TRACE_H__
 #define __TRACE_H__
 
+#define trace_xfbtree_init(...)			((void) 0)
+#define trace_xfbtree_create_root_buf(...)	((void) 0)
+#define trace_xfbtree_alloc_block(...)		((void) 0)
+#define trace_xfbtree_free_block(...)		((void) 0)
+#define trace_xfbtree_trans_cancel_buf(...)	((void) 0)
+#define trace_xfbtree_trans_commit_buf(...)	((void) 0)
+
 #define trace_xfs_agfl_reset(a,b,c,d)		((void) 0)
 #define trace_xfs_agfl_free_defer(a,b,c,d,e)	((void) 0)
 #define trace_xfs_alloc_cur_check(...)		((void) 0)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 8f501fc39f7e..1e6e549fe8eb 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -37,6 +37,7 @@ HFILES = \
 	xfs_bmap.h \
 	xfs_bmap_btree.h \
 	xfs_btree.h \
+	xfs_btree_mem.h \
 	xfs_btree_staging.h \
 	xfs_attr_remote.h \
 	xfs_cksum.h \
@@ -81,6 +82,7 @@ CFILES = buf_mem.c \
 	xfs_bmap.c \
 	xfs_bmap_btree.c \
 	xfs_btree.c \
+	xfs_btree_mem.c \
 	xfs_btree_staging.c \
 	xfs_da_btree.c \
 	xfs_defer.c \
diff --git a/libxfs/buf_mem.c b/libxfs/buf_mem.c
index 7c8fa1d2cdcd..769cce23f3f3 100644
--- a/libxfs/buf_mem.c
+++ b/libxfs/buf_mem.c
@@ -233,3 +233,16 @@ xmbuf_unmap_page(
 	munmap(bp->b_addr, BBTOB(bp->b_length));
 	bp->b_addr = NULL;
 }
+
+/* Is this a valid daddr within the buftarg? */
+bool
+xmbuf_verify_daddr(
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		daddr)
+{
+	struct xfile		*xf = btp->bt_xfile;
+
+	ASSERT(xfs_buftarg_is_mem(btp));
+
+	return daddr < (xf->partition_bytes >> BBSHIFT);
+}
diff --git a/libxfs/buf_mem.h b/libxfs/buf_mem.h
index d2be2c4240b6..d40f9f9df8f1 100644
--- a/libxfs/buf_mem.h
+++ b/libxfs/buf_mem.h
@@ -23,4 +23,6 @@ void xmbuf_free(struct xfs_buftarg *btp);
 int xmbuf_map_page(struct xfs_buf *bp);
 void xmbuf_unmap_page(struct xfs_buf *bp);
 
+bool xmbuf_verify_daddr(struct xfs_buftarg *btp, xfs_daddr_t daddr);
+
 #endif /* __XFS_BUF_MEM_H__ */
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 0e72944bc9aa..fe8a0dc40269 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -76,6 +76,7 @@
 #define xfs_buf_read_uncached		libxfs_buf_read_uncached
 #define xfs_buf_relse			libxfs_buf_relse
 #define xfs_buf_unlock			libxfs_buf_unlock
+#define xfs_buftarg_drain		libxfs_buftarg_drain
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index ae3c4a9484c7..82d86f1d1b37 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -282,4 +282,14 @@ xfs_buf_delwri_queue_here(struct xfs_buf *bp, struct list_head *buffer_list)
 int xfs_buf_delwri_submit(struct list_head *buffer_list);
 void xfs_buf_delwri_cancel(struct list_head *list);
 
+xfs_daddr_t xfs_buftarg_nr_sectors(struct xfs_buftarg *btp);
+
+static inline bool
+xfs_buftarg_verify_daddr(
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		daddr)
+{
+	return daddr < xfs_buftarg_nr_sectors(btp);
+}
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index aee85c155abf..865b8d0f4e1a 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -38,6 +38,7 @@
 #define __LIBXFS_INTERNAL_XFS_H__
 
 #define CONFIG_XFS_RT
+#define CONFIG_XFS_BTREE_IN_MEM
 
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
@@ -391,7 +392,9 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 
 /* no readahead, need to avoid set-but-unused var warnings. */
 #define xfs_buf_readahead(a,d,c,ops)		({	\
+	void *__a = a;					\
 	xfs_daddr_t __d = d;				\
+	__a = __a;					\
 	__d = __d; /* no set-but-unused warning */	\
 })
 #define xfs_buf_readahead_map(a,b,c,ops)	((void) 0)	/* no readahead */
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 5fd966a63371..a91441b46847 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -25,6 +25,9 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_health.h"
+#include "xfile.h"
+#include "buf_mem.h"
+#include "xfs_btree_mem.h"
 
 /*
  * Btree magic numbers.
@@ -72,6 +75,25 @@ xfs_btree_check_fsblock_siblings(
 	return NULL;
 }
 
+static inline xfs_failaddr_t
+xfs_btree_check_memblock_siblings(
+	struct xfs_buftarg	*btp,
+	xfbno_t			bno,
+	__be64			dsibling)
+{
+	xfbno_t			sibling;
+
+	if (dsibling == cpu_to_be64(NULLFSBLOCK))
+		return NULL;
+
+	sibling = be64_to_cpu(dsibling);
+	if (sibling == bno)
+		return __this_address;
+	if (!xmbuf_verify_daddr(btp, xfbno_to_daddr(sibling)))
+		return __this_address;
+	return NULL;
+}
+
 static inline xfs_failaddr_t
 xfs_btree_check_agblock_siblings(
 	struct xfs_perag	*pag,
@@ -161,6 +183,34 @@ __xfs_btree_check_fsblock(
 	return fa;
 }
 
+/*
+ * Check an in-memory btree block header.  Return the address of the failing
+ * check, or NULL if everything is ok.
+ */
+static xfs_failaddr_t
+__xfs_btree_check_memblock(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buftarg	*btp = cur->bc_mem.xfbtree->target;
+	xfs_failaddr_t		fa;
+	xfbno_t			bno;
+
+	fa = __xfs_btree_check_lblock_hdr(cur, block, level, bp);
+	if (fa)
+		return fa;
+
+	bno = xfs_daddr_to_xfbno(xfs_buf_daddr(bp));
+	fa = xfs_btree_check_memblock_siblings(btp, bno,
+			block->bb_u.l.bb_leftsib);
+	if (!fa)
+		fa = xfs_btree_check_memblock_siblings(btp, bno,
+				block->bb_u.l.bb_rightsib);
+	return fa;
+}
+
 /*
  * Check a short btree block header.  Return the address of the failing check,
  * or NULL if everything is ok.
@@ -213,9 +263,17 @@ __xfs_btree_check_block(
 	int			level,
 	struct xfs_buf		*bp)
 {
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_AG)
+	switch (cur->bc_ops->type) {
+	case XFS_BTREE_TYPE_MEM:
+		return __xfs_btree_check_memblock(cur, block, level, bp);
+	case XFS_BTREE_TYPE_AG:
 		return __xfs_btree_check_agblock(cur, block, level, bp);
-	return __xfs_btree_check_fsblock(cur, block, level, bp);
+	case XFS_BTREE_TYPE_INODE:
+		return __xfs_btree_check_fsblock(cur, block, level, bp);
+	default:
+		ASSERT(0);
+		return __this_address;
+	}
 }
 
 static inline unsigned int xfs_btree_block_errtag(struct xfs_btree_cur *cur)
@@ -259,14 +317,22 @@ __xfs_btree_check_ptr(
 	if (level <= 0)
 		return -EFSCORRUPTED;
 
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
+	switch (cur->bc_ops->type) {
+	case XFS_BTREE_TYPE_MEM:
+		if (!xfbtree_verify_bno(cur->bc_mem.xfbtree,
+				be64_to_cpu((&ptr->l)[index])))
+			return -EFSCORRUPTED;
+		break;
+	case XFS_BTREE_TYPE_INODE:
 		if (!xfs_verify_fsbno(cur->bc_mp,
 				be64_to_cpu((&ptr->l)[index])))
 			return -EFSCORRUPTED;
-	} else {
+		break;
+	case XFS_BTREE_TYPE_AG:
 		if (!xfs_verify_agbno(cur->bc_ag.pag,
 				be32_to_cpu((&ptr->s)[index])))
 			return -EFSCORRUPTED;
+		break;
 	}
 
 	return 0;
@@ -287,17 +353,26 @@ xfs_btree_check_ptr(
 
 	error = __xfs_btree_check_ptr(cur, ptr, index, level);
 	if (error) {
-		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
+		switch (cur->bc_ops->type) {
+		case XFS_BTREE_TYPE_MEM:
+			xfs_err(cur->bc_mp,
+"In-memory: Corrupt %sbt flags 0x%x pointer at level %d index %d fa %pS.",
+				cur->bc_ops->name, cur->bc_flags, level, index,
+				__this_address);
+			break;
+		case XFS_BTREE_TYPE_INODE:
 			xfs_err(cur->bc_mp,
 "Inode %llu fork %d: Corrupt %sbt pointer at level %d index %d.",
 				cur->bc_ino.ip->i_ino,
 				cur->bc_ino.whichfork, cur->bc_ops->name,
 				level, index);
-		} else {
+			break;
+		case XFS_BTREE_TYPE_AG:
 			xfs_err(cur->bc_mp,
 "AG %u: Corrupt %sbt pointer at level %d index %d.",
 				cur->bc_ag.pag->pag_agno, cur->bc_ops->name,
 				level, index);
+			break;
 		}
 		xfs_btree_mark_sick(cur);
 	}
@@ -454,11 +529,35 @@ xfs_btree_del_cursor(
 	case XFS_BTREE_TYPE_INODE:
 		/* nothing to do */
 		break;
+	case XFS_BTREE_TYPE_MEM:
+		if (cur->bc_mem.pag)
+			xfs_perag_put(cur->bc_mem.pag);
+		break;
 	}
 
 	kmem_cache_free(cur->bc_cache, cur);
 }
 
+/* Return the buffer target for this btree's buffer. */
+static inline struct xfs_buftarg *
+xfs_btree_buftarg(
+	struct xfs_btree_cur	*cur)
+{
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_MEM)
+		return cur->bc_mem.xfbtree->target;
+	return cur->bc_mp->m_ddev_targp;
+}
+
+/* Return the block size (in units of 512b sectors) for this btree. */
+static inline unsigned int
+xfs_btree_bbsize(
+	struct xfs_btree_cur	*cur)
+{
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_MEM)
+		return XFBNO_BBSIZE;
+	return cur->bc_mp->m_bsize;
+}
+
 /*
  * Duplicate the btree cursor.
  * Allocate a new one, copy the record, re-get the buffers.
@@ -502,10 +601,11 @@ xfs_btree_dup_cursor(
 		new->bc_levels[i].ra = cur->bc_levels[i].ra;
 		bp = cur->bc_levels[i].bp;
 		if (bp) {
-			error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-						   xfs_buf_daddr(bp), mp->m_bsize,
-						   0, &bp,
-						   cur->bc_ops->buf_ops);
+			error = xfs_trans_read_buf(mp, tp,
+					xfs_btree_buftarg(cur),
+					xfs_buf_daddr(bp),
+					xfs_btree_bbsize(cur), 0, &bp,
+					cur->bc_ops->buf_ops);
 			if (xfs_metadata_is_sick(error))
 				xfs_btree_mark_sick(new);
 			if (error) {
@@ -882,6 +982,32 @@ xfs_btree_readahead_fsblock(
 	return rval;
 }
 
+STATIC int
+xfs_btree_readahead_memblock(
+	struct xfs_btree_cur	*cur,
+	int			lr,
+	struct xfs_btree_block	*block)
+{
+	struct xfs_buftarg	*btp = cur->bc_mem.xfbtree->target;
+	xfbno_t			left = be64_to_cpu(block->bb_u.l.bb_leftsib);
+	xfbno_t			right = be64_to_cpu(block->bb_u.l.bb_rightsib);
+	int			rval = 0;
+
+	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLFSBLOCK) {
+		xfs_buf_readahead(btp, xfbno_to_daddr(left), XFBNO_BBSIZE,
+				cur->bc_ops->buf_ops);
+		rval++;
+	}
+
+	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLFSBLOCK) {
+		xfs_buf_readahead(btp, xfbno_to_daddr(right), XFBNO_BBSIZE,
+				cur->bc_ops->buf_ops);
+		rval++;
+	}
+
+	return rval;
+}
+
 STATIC int
 xfs_btree_readahead_agblock(
 	struct xfs_btree_cur	*cur,
@@ -936,9 +1062,17 @@ xfs_btree_readahead(
 	cur->bc_levels[lev].ra |= lr;
 	block = XFS_BUF_TO_BLOCK(cur->bc_levels[lev].bp);
 
-	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
+	switch (cur->bc_ops->type) {
+	case XFS_BTREE_TYPE_AG:
+		return xfs_btree_readahead_agblock(cur, lr, block);
+	case XFS_BTREE_TYPE_INODE:
 		return xfs_btree_readahead_fsblock(cur, lr, block);
-	return xfs_btree_readahead_agblock(cur, lr, block);
+	case XFS_BTREE_TYPE_MEM:
+		return xfs_btree_readahead_memblock(cur, lr, block);
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 STATIC int
@@ -947,23 +1081,24 @@ xfs_btree_ptr_to_daddr(
 	const union xfs_btree_ptr	*ptr,
 	xfs_daddr_t			*daddr)
 {
-	xfs_fsblock_t		fsbno;
-	xfs_agblock_t		agbno;
 	int			error;
 
 	error = xfs_btree_check_ptr(cur, ptr, 0, 1);
 	if (error)
 		return error;
 
-	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
-		fsbno = be64_to_cpu(ptr->l);
-		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, fsbno);
-	} else {
-		agbno = be32_to_cpu(ptr->s);
+	switch (cur->bc_ops->type) {
+	case XFS_BTREE_TYPE_AG:
 		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-				agbno);
+				be32_to_cpu(ptr->s));
+		break;
+	case XFS_BTREE_TYPE_INODE:
+		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, be64_to_cpu(ptr->l));
+		break;
+	case XFS_BTREE_TYPE_MEM:
+		*daddr = xfbno_to_daddr(be64_to_cpu(ptr->l));
+		break;
 	}
-
 	return 0;
 }
 
@@ -983,8 +1118,9 @@ xfs_btree_readahead_ptr(
 
 	if (xfs_btree_ptr_to_daddr(cur, ptr, &daddr))
 		return;
-	xfs_buf_readahead(cur->bc_mp->m_ddev_targp, daddr,
-			  cur->bc_mp->m_bsize * count, cur->bc_ops->buf_ops);
+	xfs_buf_readahead(xfs_btree_buftarg(cur), daddr,
+			xfs_btree_bbsize(cur) * count,
+			cur->bc_ops->buf_ops);
 }
 
 /*
@@ -1169,9 +1305,17 @@ static inline __u64
 xfs_btree_owner(
 	struct xfs_btree_cur    *cur)
 {
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
+	switch (cur->bc_ops->type) {
+	case XFS_BTREE_TYPE_MEM:
+		return cur->bc_mem.xfbtree->owner;
+	case XFS_BTREE_TYPE_INODE:
 		return cur->bc_ino.ip->i_ino;
-	return cur->bc_ag.pag->pag_agno;
+	case XFS_BTREE_TYPE_AG:
+		return cur->bc_ag.pag->pag_agno;
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 void
@@ -1215,12 +1359,18 @@ xfs_btree_buf_to_ptr(
 	struct xfs_buf		*bp,
 	union xfs_btree_ptr	*ptr)
 {
-	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
-		ptr->l = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp,
-					xfs_buf_daddr(bp)));
-	else {
+	switch (cur->bc_ops->type) {
+	case XFS_BTREE_TYPE_AG:
 		ptr->s = cpu_to_be32(xfs_daddr_to_agbno(cur->bc_mp,
 					xfs_buf_daddr(bp)));
+		break;
+	case XFS_BTREE_TYPE_INODE:
+		ptr->l = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp,
+					xfs_buf_daddr(bp)));
+		break;
+	case XFS_BTREE_TYPE_MEM:
+		ptr->l = cpu_to_be64(xfs_daddr_to_xfbno(xfs_buf_daddr(bp)));
+		break;
 	}
 }
 
@@ -1239,15 +1389,14 @@ xfs_btree_get_buf_block(
 	struct xfs_btree_block		**block,
 	struct xfs_buf			**bpp)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_daddr_t		d;
-	int			error;
+	xfs_daddr_t			d;
+	int				error;
 
 	error = xfs_btree_ptr_to_daddr(cur, ptr, &d);
 	if (error)
 		return error;
-	error = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d, mp->m_bsize,
-			0, bpp);
+	error = xfs_trans_get_buf(cur->bc_tp, xfs_btree_buftarg(cur), d,
+			xfs_btree_bbsize(cur), 0, bpp);
 	if (error)
 		return error;
 
@@ -1278,9 +1427,9 @@ xfs_btree_read_buf_block(
 	error = xfs_btree_ptr_to_daddr(cur, ptr, &d);
 	if (error)
 		return error;
-	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
-				   mp->m_bsize, flags, bpp,
-				   cur->bc_ops->buf_ops);
+	error = xfs_trans_read_buf(mp, cur->bc_tp, xfs_btree_buftarg(cur), d,
+			xfs_btree_bbsize(cur), flags, bpp,
+			cur->bc_ops->buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_btree_mark_sick(cur);
 	if (error)
@@ -4579,6 +4728,8 @@ xfs_btree_fsblock_verify(
 	xfs_fsblock_t		fsb;
 	xfs_failaddr_t		fa;
 
+	ASSERT(!xfs_buftarg_is_mem(bp->b_target));
+
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
@@ -4593,6 +4744,36 @@ xfs_btree_fsblock_verify(
 	return fa;
 }
 
+/* Verify an in-memory btree block. */
+xfs_failaddr_t
+xfs_btree_memblock_verify(
+	struct xfs_buf		*bp,
+	unsigned int		max_recs)
+{
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_buftarg	*btp = bp->b_target;
+	xfs_failaddr_t		fa;
+	xfbno_t			bno;
+
+	ASSERT(xfs_buftarg_is_mem(bp->b_target));
+
+	/* numrecs verification */
+	if (be16_to_cpu(block->bb_numrecs) > max_recs)
+		return __this_address;
+
+	/* sibling pointer verification */
+	bno = xfs_daddr_to_xfbno(xfs_buf_daddr(bp));
+	fa = xfs_btree_check_memblock_siblings(btp, bno,
+			block->bb_u.l.bb_leftsib);
+	if (fa)
+		return fa;
+	fa = xfs_btree_check_memblock_siblings(btp, bno,
+			block->bb_u.l.bb_rightsib);
+	if (fa)
+		return fa;
+
+	return NULL;
+}
 /**
  * xfs_btree_agblock_v5hdr_verify() -- verify the v5 fields of a short-format
  *				      btree block
@@ -4634,6 +4815,8 @@ xfs_btree_agblock_verify(
 	xfs_agblock_t		agbno;
 	xfs_failaddr_t		fa;
 
+	ASSERT(!xfs_buftarg_is_mem(bp->b_target));
+
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index bacd67cc8ced..f93374278aa1 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -112,6 +112,7 @@ static inline enum xbtree_key_contig xbtree_key_contig(uint64_t x, uint64_t y)
 enum xfs_btree_type {
 	XFS_BTREE_TYPE_AG,
 	XFS_BTREE_TYPE_INODE,
+	XFS_BTREE_TYPE_MEM,
 };
 
 struct xfs_btree_ops {
@@ -281,6 +282,10 @@ struct xfs_btree_cur
 			struct xfs_buf		*agbp;
 			struct xbtree_afakeroot	*afake;	/* for staging cursor */
 		} bc_ag;
+		struct {
+			struct xfbtree		*xfbtree;
+			struct xfs_perag	*pag;
+		} bc_mem;
 	};
 
 	/* per-format private data */
@@ -455,6 +460,8 @@ xfs_failaddr_t xfs_btree_fsblock_v5hdr_verify(struct xfs_buf *bp,
 		uint64_t owner);
 xfs_failaddr_t xfs_btree_fsblock_verify(struct xfs_buf *bp,
 		unsigned int max_recs);
+xfs_failaddr_t xfs_btree_memblock_verify(struct xfs_buf *bp,
+		unsigned int max_recs);
 
 unsigned int xfs_btree_compute_maxlevels(const unsigned int *limits,
 		unsigned long long records);
diff --git a/libxfs/xfs_btree_mem.c b/libxfs/xfs_btree_mem.c
new file mode 100644
index 000000000000..31835e065652
--- /dev/null
+++ b/libxfs/xfs_btree_mem.c
@@ -0,0 +1,227 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_trans.h"
+#include "xfs_btree.h"
+#include "xfile.h"
+#include "buf_mem.h"
+#include "xfs_btree_mem.h"
+#include "xfs_ag.h"
+#include "xfs_trace.h"
+
+/* Set the root of an in-memory btree. */
+void
+xfbtree_set_root(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	int				inc)
+{
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_MEM);
+
+	cur->bc_mem.xfbtree->root = *ptr;
+	cur->bc_mem.xfbtree->nlevels += inc;
+}
+
+/* Initialize a pointer from the in-memory btree header. */
+void
+xfbtree_init_ptr_from_cur(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_ptr		*ptr)
+{
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_MEM);
+
+	*ptr = cur->bc_mem.xfbtree->root;
+}
+
+/* Duplicate an in-memory btree cursor. */
+struct xfs_btree_cur *
+xfbtree_dup_cursor(
+	struct xfs_btree_cur		*cur)
+{
+	struct xfs_btree_cur		*ncur;
+
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_MEM);
+
+	ncur = xfs_btree_alloc_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ops,
+			cur->bc_maxlevels, cur->bc_cache);
+	ncur->bc_flags = cur->bc_flags;
+	ncur->bc_nlevels = cur->bc_nlevels;
+	ncur->bc_mem.xfbtree = cur->bc_mem.xfbtree;
+
+	if (cur->bc_mem.pag)
+		ncur->bc_mem.pag = xfs_perag_hold(cur->bc_mem.pag);
+
+	return ncur;
+}
+
+/* Close the btree xfile and release all resources. */
+void
+xfbtree_destroy(
+	struct xfbtree		*xfbt)
+{
+	xfs_buftarg_drain(xfbt->target);
+}
+
+/* Compute the number of bytes available for records. */
+static inline unsigned int
+xfbtree_rec_bytes(
+	struct xfs_mount		*mp,
+	const struct xfs_btree_ops	*ops)
+{
+	return XMBUF_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+}
+
+/* Initialize an empty leaf block as the btree root. */
+STATIC int
+xfbtree_init_leaf_block(
+	struct xfs_mount		*mp,
+	struct xfbtree			*xfbt,
+	const struct xfs_btree_ops	*ops)
+{
+	struct xfs_buf			*bp;
+	xfbno_t				bno = xfbt->highest_bno++;
+	int				error;
+
+	error = xfs_buf_get(xfbt->target, xfbno_to_daddr(bno), XFBNO_BBSIZE,
+			&bp);
+	if (error)
+		return error;
+
+	trace_xfbtree_create_root_buf(xfbt, bp);
+
+	bp->b_ops = ops->buf_ops;
+	xfs_btree_init_buf(mp, bp, ops, 0, 0, xfbt->owner);
+	xfs_buf_relse(bp);
+
+	xfbt->root.l = cpu_to_be64(bno);
+	return 0;
+}
+
+/*
+ * Create an in-memory btree root that can be used with the given xmbuf.
+ * Callers must set xfbt->owner.
+ */
+int
+xfbtree_init(
+	struct xfs_mount		*mp,
+	struct xfbtree			*xfbt,
+	struct xfs_buftarg		*btp,
+	const struct xfs_btree_ops	*ops)
+{
+	unsigned int			blocklen = xfbtree_rec_bytes(mp, ops);
+	unsigned int			keyptr_len;
+	int				error;
+
+	/* Requires a long-format CRC-format btree */
+	if (!xfs_has_crc(mp)) {
+		ASSERT(xfs_has_crc(mp));
+		return -EINVAL;
+	}
+	if (ops->ptr_len != XFS_BTREE_LONG_PTR_LEN) {
+		ASSERT(ops->ptr_len == XFS_BTREE_LONG_PTR_LEN);
+		return -EINVAL;
+	}
+
+	memset(xfbt, 0, sizeof(*xfbt));
+	xfbt->target = btp;
+
+	/* Set up min/maxrecs for this btree. */
+	keyptr_len = ops->key_len + sizeof(__be64);
+	xfbt->maxrecs[0] = blocklen / ops->rec_len;
+	xfbt->maxrecs[1] = blocklen / keyptr_len;
+	xfbt->minrecs[0] = xfbt->maxrecs[0] / 2;
+	xfbt->minrecs[1] = xfbt->maxrecs[1] / 2;
+	xfbt->highest_bno = 0;
+	xfbt->nlevels = 1;
+
+	/* Initialize the empty btree. */
+	error = xfbtree_init_leaf_block(mp, xfbt, ops);
+	if (error)
+		goto err_freesp;
+
+	trace_xfbtree_init(mp, xfbt, ops);
+
+	return 0;
+
+err_freesp:
+	xfs_buftarg_drain(xfbt->target);
+	return error;
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
+	xfbno_t				bno = xfbt->highest_bno++;
+
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_MEM);
+
+	trace_xfbtree_alloc_block(xfbt, cur, bno);
+
+	/* Fail if the block address exceeds the maximum for the buftarg. */
+	if (!xfbtree_verify_bno(xfbt, bno)) {
+		ASSERT(xfbtree_verify_bno(xfbt, bno));
+		*stat = 0;
+		return 0;
+	}
+
+	new->l = cpu_to_be64(bno);
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
+	xfs_daddr_t		daddr = xfs_buf_daddr(bp);
+	xfbno_t			bno = xfs_daddr_to_xfbno(daddr);
+
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_MEM);
+
+	trace_xfbtree_free_block(xfbt, cur, bno);
+
+	if (bno + 1 == xfbt->highest_bno)
+		xfbt->highest_bno--;
+
+	return 0;
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
diff --git a/libxfs/xfs_btree_mem.h b/libxfs/xfs_btree_mem.h
new file mode 100644
index 000000000000..ecc2ceac3ed4
--- /dev/null
+++ b/libxfs/xfs_btree_mem.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_BTREE_MEM_H__
+#define __XFS_BTREE_MEM_H__
+
+typedef uint64_t xfbno_t;
+
+#define XFBNO_BLOCKSIZE			(XMBUF_BLOCKSIZE)
+#define XFBNO_BBSHIFT			(XMBUF_BLOCKSHIFT - BBSHIFT)
+#define XFBNO_BBSIZE			(XFBNO_BLOCKSIZE >> BBSHIFT)
+
+static inline xfs_daddr_t xfbno_to_daddr(xfbno_t blkno)
+{
+	return blkno << XFBNO_BBSHIFT;
+}
+
+static inline xfbno_t xfs_daddr_to_xfbno(xfs_daddr_t daddr)
+{
+	return daddr >> XFBNO_BBSHIFT;
+}
+
+struct xfbtree {
+	/* buffer cache target for this in-memory btree */
+	struct xfs_buftarg		*target;
+
+	/* Highest block number that has been written to. */
+	xfbno_t				highest_bno;
+
+	/* Owner of this btree. */
+	unsigned long long		owner;
+
+	/* Btree header */
+	union xfs_btree_ptr		root;
+	unsigned int			nlevels;
+
+	/* Minimum and maximum records per block. */
+	unsigned int			maxrecs[2];
+	unsigned int			minrecs[2];
+};
+
+#ifdef CONFIG_XFS_BTREE_IN_MEM
+static inline bool xfbtree_verify_bno(struct xfbtree *xfbt, xfbno_t bno)
+{
+	return xmbuf_verify_daddr(xfbt->target, xfbno_to_daddr(bno));
+}
+
+void xfbtree_set_root(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *ptr, int inc);
+void xfbtree_init_ptr_from_cur(struct xfs_btree_cur *cur,
+		union xfs_btree_ptr *ptr);
+struct xfs_btree_cur *xfbtree_dup_cursor(struct xfs_btree_cur *cur);
+
+int xfbtree_get_minrecs(struct xfs_btree_cur *cur, int level);
+int xfbtree_get_maxrecs(struct xfs_btree_cur *cur, int level);
+
+int xfbtree_alloc_block(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *start, union xfs_btree_ptr *ptr,
+		int *stat);
+int xfbtree_free_block(struct xfs_btree_cur *cur, struct xfs_buf *bp);
+
+/* Callers must set xfbt->target and xfbt->owner before calling this */
+int xfbtree_init(struct xfs_mount *mp, struct xfbtree *xfbt,
+		struct xfs_buftarg *btp, const struct xfs_btree_ops *ops);
+void xfbtree_destroy(struct xfbtree *xfbt);
+#else
+# define xfbtree_verify_bno(...)	(false)
+#endif /* CONFIG_XFS_BTREE_IN_MEM */
+
+#endif /* __XFS_BTREE_MEM_H__ */

