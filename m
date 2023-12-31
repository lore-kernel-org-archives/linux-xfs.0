Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E23BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPcqZasB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A70EC433C8;
	Sun, 31 Dec 2023 20:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053739;
	bh=lHE6OaWYGF6hygoBgTAo6DXLYYJqEXedpoCcF0JMh9I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MPcqZasBIz9TWfM4sCxxnqbYt8LhwMrHzdc0Cut7VtF+/6YrbIe9kaEA8YsY0AQLj
	 5XfqjMlmjaNR+27jtksLj7KPEgdGluYqN+8+aMMeaR83DWuOunAMLg3y1Ray7RrLeW
	 dOlZ6cYr43y2NV0pnJqY4phfQQn92IrTRFFmdA+jXrlhWYCzwS99xhCFK4zxcMCH4+
	 fXeccUEMQ+YKQTYp1zOYt4OZp5v1N9JILb9EpxGTGN6t6gK9EThBrWuWvE9sf9owAN
	 0F/8ktUSi+7CsbKgDCY6gTiRUOfobYQdqVkOd5dx7JlAXxE2my5ELDqA736QJ74gMs
	 lCvxtB/YxYE8w==
Date: Sun, 31 Dec 2023 12:15:38 -0800
Subject: [PATCH 8/9] xfs: support in-memory btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170404829708.1748854.10994305200199735396.stgit@frogsfrogsfrogs>
In-Reply-To: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
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

Adapt the generic btree cursor code to be able to create a btree whose
buffers come from a (presumably in-memory) buftarg with a header block
that's specific to in-memory btrees.  We'll connect this to other parts
of online scrub in the next patches.

Note that in-memory btrees always have a block size matching the system
memory page size for efficiency reasons.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig                |    4 
 fs/xfs/Makefile               |    1 
 fs/xfs/libxfs/xfs_btree.c     |  151 ++++++++++++++----
 fs/xfs/libxfs/xfs_btree.h     |   17 ++
 fs/xfs/libxfs/xfs_btree_mem.h |   87 ++++++++++
 fs/xfs/scrub/xfbtree.c        |  352 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfbtree.h        |   34 ++++
 fs/xfs/scrub/xfile.h          |   46 +++++
 fs/xfs/xfs_buf.c              |   10 +
 fs/xfs/xfs_buf.h              |   10 +
 fs/xfs/xfs_buf_xfile.c        |    8 +
 fs/xfs/xfs_buf_xfile.h        |    2 
 fs/xfs/xfs_health.c           |    3 
 fs/xfs/xfs_trace.c            |    3 
 fs/xfs/xfs_trace.h            |    5 -
 15 files changed, 704 insertions(+), 29 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_btree_mem.h
 create mode 100644 fs/xfs/scrub/xfbtree.c
 create mode 100644 fs/xfs/scrub/xfbtree.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 7c016a8788456..0ed89b2381936 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -131,6 +131,9 @@ config XFS_LIVE_HOOKS
 config XFS_IN_MEMORY_FILE
 	bool
 
+config XFS_BTREE_IN_XFILE
+	bool
+
 config XFS_ONLINE_SCRUB
 	bool "XFS online metadata check support"
 	default n
@@ -204,6 +207,7 @@ config XFS_ONLINE_REPAIR
 	bool "XFS online metadata repair support"
 	default n
 	depends on XFS_FS && XFS_ONLINE_SCRUB
+	select XFS_BTREE_IN_XFILE
 	help
 	  If you say Y here you will be able to repair metadata on a
 	  mounted XFS filesystem.  This feature is intended to reduce
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7eb7c521c4a84..6dea286d7f194 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -201,6 +201,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   reap.o \
 				   refcount_repair.o \
 				   repair.o \
+				   xfbtree.o \
 				   )
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index fbed51b4462e8..dbd048bc1e8e0 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -28,6 +28,9 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_health.h"
+#include "scrub/xfile.h"
+#include "scrub/xfbtree.h"
+#include "xfs_btree_mem.h"
 
 /*
  * Btree magic numbers.
@@ -82,6 +85,9 @@ xfs_btree_check_lblock_siblings(
 	if (level >= 0) {
 		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
 			return __this_address;
+	} else if (cur && (cur->bc_flags & XFS_BTREE_IN_XFILE)) {
+		if (!xfbtree_verify_xfileoff(cur, sibling))
+			return __this_address;
 	} else {
 		if (!xfs_verify_fsbno(mp, sibling))
 			return __this_address;
@@ -109,6 +115,9 @@ xfs_btree_check_sblock_siblings(
 	if (level >= 0) {
 		if (!xfs_btree_check_sptr(cur, sibling, level + 1))
 			return __this_address;
+	} else if (cur && (cur->bc_flags & XFS_BTREE_IN_XFILE)) {
+		if (!xfbtree_verify_xfileoff(cur, sibling))
+			return __this_address;
 	} else {
 		if (!xfs_verify_agbno(pag, sibling))
 			return __this_address;
@@ -151,7 +160,9 @@ __xfs_btree_check_lblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
-	if (bp)
+	if ((cur->bc_flags & XFS_BTREE_IN_XFILE) && bp)
+		fsb = xfbtree_buf_to_xfoff(cur, bp);
+	else if (bp)
 		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
 	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
@@ -218,8 +229,12 @@ __xfs_btree_check_sblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
-	if (bp)
+	if ((cur->bc_flags & XFS_BTREE_IN_XFILE) && bp) {
+		pag = NULL;
+		agbno = xfbtree_buf_to_xfoff(cur, bp);
+	} else if (bp) {
 		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
+	}
 
 	fa = xfs_btree_check_sblock_siblings(pag, cur, level, agbno,
 			block->bb_u.s.bb_leftsib);
@@ -276,6 +291,8 @@ xfs_btree_check_lptr(
 {
 	if (level <= 0)
 		return false;
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return xfbtree_verify_xfileoff(cur, fsbno);
 	return xfs_verify_fsbno(cur->bc_mp, fsbno);
 }
 
@@ -288,6 +305,8 @@ xfs_btree_check_sptr(
 {
 	if (level <= 0)
 		return false;
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return xfbtree_verify_xfileoff(cur, agbno);
 	return xfs_verify_agbno(cur->bc_ag.pag, agbno);
 }
 
@@ -302,6 +321,9 @@ xfs_btree_check_ptr(
 	int				index,
 	int				level)
 {
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return xfbtree_check_ptr(cur, ptr, index, level);
+
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		if (xfs_btree_check_lptr(cur, be64_to_cpu((&ptr->l)[index]),
 				level))
@@ -458,11 +480,36 @@ xfs_btree_del_cursor(
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
-	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
+	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
+	    !(cur->bc_flags & XFS_BTREE_IN_XFILE) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE) {
+		if (cur->bc_mem.pag)
+			xfs_perag_put(cur->bc_mem.pag);
+	}
 	kmem_cache_free(cur->bc_cache, cur);
 }
 
+/* Return the buffer target for this btree's buffer. */
+static inline struct xfs_buftarg *
+xfs_btree_buftarg(
+	struct xfs_btree_cur	*cur)
+{
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return xfbtree_target(cur->bc_mem.xfbtree);
+	return cur->bc_mp->m_ddev_targp;
+}
+
+/* Return the block size (in units of 512b sectors) for this btree. */
+static inline unsigned int
+xfs_btree_bbsize(
+	struct xfs_btree_cur	*cur)
+{
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return xfbtree_bbsize();
+	return cur->bc_mp->m_bsize;
+}
+
 /*
  * Duplicate the btree cursor.
  * Allocate a new one, copy the record, re-get the buffers.
@@ -500,10 +547,11 @@ xfs_btree_dup_cursor(
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
@@ -944,6 +992,9 @@ xfs_btree_readahead_lblock(
 	xfs_fsblock_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
 	xfs_fsblock_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
 
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return 0;
+
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLFSBLOCK) {
 		xfs_btree_reada_bufl(cur->bc_mp, left, 1,
 				     cur->bc_ops->buf_ops);
@@ -969,6 +1020,8 @@ xfs_btree_readahead_sblock(
 	xfs_agblock_t		left = be32_to_cpu(block->bb_u.s.bb_leftsib);
 	xfs_agblock_t		right = be32_to_cpu(block->bb_u.s.bb_rightsib);
 
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return 0;
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
 		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.pag->pag_agno,
@@ -1030,6 +1083,11 @@ xfs_btree_ptr_to_daddr(
 	if (error)
 		return error;
 
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE) {
+		*daddr = xfbtree_ptr_to_daddr(cur, ptr);
+		return 0;
+	}
+
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		fsbno = be64_to_cpu(ptr->l);
 		*daddr = XFS_FSB_TO_DADDR(cur->bc_mp, fsbno);
@@ -1058,8 +1116,9 @@ xfs_btree_readahead_ptr(
 
 	if (xfs_btree_ptr_to_daddr(cur, ptr, &daddr))
 		return;
-	xfs_buf_readahead(cur->bc_mp->m_ddev_targp, daddr,
-			  cur->bc_mp->m_bsize * count, cur->bc_ops->buf_ops);
+	xfs_buf_readahead(xfs_btree_buftarg(cur), daddr,
+			xfs_btree_bbsize(cur) * count,
+			cur->bc_ops->buf_ops);
 }
 
 /*
@@ -1233,7 +1292,9 @@ xfs_btree_init_block_cur(
 	 * change in future, but is safe for current users of the generic btree
 	 * code.
 	 */
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		owner = xfbtree_owner(cur);
+	else if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		owner = cur->bc_ino.ip->i_ino;
 	else
 		owner = cur->bc_ag.pag->pag_agno;
@@ -1273,6 +1334,11 @@ xfs_btree_buf_to_ptr(
 	struct xfs_buf		*bp,
 	union xfs_btree_ptr	*ptr)
 {
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE) {
+		xfbtree_buf_to_ptr(cur, bp, ptr);
+		return;
+	}
+
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		ptr->l = cpu_to_be64(XFS_DADDR_TO_FSB(cur->bc_mp,
 					xfs_buf_daddr(bp)));
@@ -1317,15 +1383,14 @@ xfs_btree_get_buf_block(
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
 
@@ -1356,9 +1421,9 @@ xfs_btree_read_buf_block(
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
@@ -1798,6 +1863,37 @@ xfs_btree_decrement(
 	return error;
 }
 
+/*
+ * Check the btree block owner now that we have the context to know who the
+ * real owner is.
+ */
+static inline xfs_failaddr_t
+xfs_btree_check_block_owner(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block)
+{
+	if (!xfs_has_crc(cur->bc_mp))
+		return NULL;
+
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return xfbtree_check_block_owner(cur, block);
+
+	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS)) {
+		if (be32_to_cpu(block->bb_u.s.bb_owner) !=
+						cur->bc_ag.pag->pag_agno)
+			return __this_address;
+		return NULL;
+	}
+
+	if (cur->bc_ino.flags & XFS_BTCUR_BMBT_INVALID_OWNER)
+		return NULL;
+
+	if (be64_to_cpu(block->bb_u.l.bb_owner) != cur->bc_ino.ip->i_ino)
+		return __this_address;
+
+	return NULL;
+}
+
 int
 xfs_btree_lookup_get_block(
 	struct xfs_btree_cur		*cur,	/* btree cursor */
@@ -1836,11 +1932,7 @@ xfs_btree_lookup_get_block(
 		return error;
 
 	/* Check the inode owner since the verifiers don't. */
-	if (xfs_has_crc(cur->bc_mp) &&
-	    !(cur->bc_ino.flags & XFS_BTCUR_BMBT_INVALID_OWNER) &&
-	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
-	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
-			cur->bc_ino.ip->i_ino)
+	if (xfs_btree_check_block_owner(cur, *blkp) != NULL)
 		goto out_bad;
 
 	/* Did we get the level we were looking for? */
@@ -4386,7 +4478,7 @@ xfs_btree_visit_block(
 {
 	struct xfs_btree_block		*block;
 	struct xfs_buf			*bp;
-	union xfs_btree_ptr		rptr;
+	union xfs_btree_ptr		rptr, bufptr;
 	int				error;
 
 	/* do right sibling readahead */
@@ -4409,15 +4501,14 @@ xfs_btree_visit_block(
 	 * return the same block without checking if the right sibling points
 	 * back to us and creates a cyclic reference in the btree.
 	 */
+	xfs_btree_buf_to_ptr(cur, bp, &bufptr);
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
-							xfs_buf_daddr(bp))) {
+		if (rptr.l == bufptr.l) {
 			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
 		}
 	} else {
-		if (be32_to_cpu(rptr.s) == xfs_daddr_to_agbno(cur->bc_mp,
-							xfs_buf_daddr(bp))) {
+		if (rptr.s == bufptr.s) {
 			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
 		}
@@ -4599,6 +4690,8 @@ xfs_btree_lblock_verify(
 	xfs_fsblock_t		fsb;
 	xfs_failaddr_t		fa;
 
+	ASSERT(!(bp->b_target->bt_flags & XFS_BUFTARG_XFILE));
+
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
@@ -4654,6 +4747,8 @@ xfs_btree_sblock_verify(
 	xfs_agblock_t		agbno;
 	xfs_failaddr_t		fa;
 
+	ASSERT(!(bp->b_target->bt_flags & XFS_BUFTARG_XFILE));
+
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index d906324e25c86..3e6bdbc507039 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -248,6 +248,15 @@ struct xfs_btree_cur_ino {
 #define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
 };
 
+/* In-memory btree information */
+struct xfbtree;
+
+struct xfs_btree_cur_mem {
+	struct xfbtree			*xfbtree;
+	struct xfs_buf			*head_bp;
+	struct xfs_perag		*pag;
+};
+
 struct xfs_btree_level {
 	/* buffer pointer */
 	struct xfs_buf		*bp;
@@ -287,6 +296,7 @@ struct xfs_btree_cur
 	union {
 		struct xfs_btree_cur_ag	bc_ag;
 		struct xfs_btree_cur_ino bc_ino;
+		struct xfs_btree_cur_mem bc_mem;
 	};
 
 	/* Must be at the end of the struct! */
@@ -317,6 +327,13 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
  */
 #define XFS_BTREE_STAGING		(1<<5)
 
+/* btree stored in memory; not compatible with ROOT_IN_INODE */
+#ifdef CONFIG_XFS_BTREE_IN_XFILE
+# define XFS_BTREE_IN_XFILE		(1<<7)
+#else
+# define XFS_BTREE_IN_XFILE		(0)
+#endif
+
 #define	XFS_BTREE_NOERROR	0
 #define	XFS_BTREE_ERROR		1
 
diff --git a/fs/xfs/libxfs/xfs_btree_mem.h b/fs/xfs/libxfs/xfs_btree_mem.h
new file mode 100644
index 0000000000000..2c42ca85c58fb
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_btree_mem.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_BTREE_MEM_H__
+#define __XFS_BTREE_MEM_H__
+
+struct xfbtree;
+
+#ifdef CONFIG_XFS_BTREE_IN_XFILE
+unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
+
+struct xfs_buftarg *xfbtree_target(struct xfbtree *xfbtree);
+int xfbtree_check_ptr(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *ptr, int index, int level);
+xfs_daddr_t xfbtree_ptr_to_daddr(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *ptr);
+void xfbtree_buf_to_ptr(struct xfs_btree_cur *cur, struct xfs_buf *bp,
+		union xfs_btree_ptr *ptr);
+
+unsigned int xfbtree_bbsize(void);
+
+void xfbtree_set_root(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *ptr, int inc);
+void xfbtree_init_ptr_from_cur(struct xfs_btree_cur *cur,
+		union xfs_btree_ptr *ptr);
+struct xfs_btree_cur *xfbtree_dup_cursor(struct xfs_btree_cur *cur);
+bool xfbtree_verify_xfileoff(struct xfs_btree_cur *cur,
+		unsigned long long xfoff);
+xfs_failaddr_t xfbtree_check_block_owner(struct xfs_btree_cur *cur,
+		struct xfs_btree_block *block);
+unsigned long long xfbtree_owner(struct xfs_btree_cur *cur);
+xfs_failaddr_t xfbtree_lblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+xfs_failaddr_t xfbtree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+unsigned long long xfbtree_buf_to_xfoff(struct xfs_btree_cur *cur,
+		struct xfs_buf *bp);
+#else
+static inline unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp)
+{
+	return 0;
+}
+
+static inline struct xfs_buftarg *
+xfbtree_target(struct xfbtree *xfbtree)
+{
+	return NULL;
+}
+
+static inline int
+xfbtree_check_ptr(struct xfs_btree_cur *cur, const union xfs_btree_ptr *ptr,
+		  int index, int level)
+{
+	return 0;
+}
+
+static inline xfs_daddr_t
+xfbtree_ptr_to_daddr(struct xfs_btree_cur *cur, const union xfs_btree_ptr *ptr)
+{
+	return 0;
+}
+
+static inline void
+xfbtree_buf_to_ptr(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	union xfs_btree_ptr	*ptr)
+{
+	memset(ptr, 0xFF, sizeof(*ptr));
+}
+
+static inline unsigned int xfbtree_bbsize(void)
+{
+	return 0;
+}
+
+#define xfbtree_set_root			NULL
+#define xfbtree_init_ptr_from_cur		NULL
+#define xfbtree_dup_cursor			NULL
+#define xfbtree_verify_xfileoff(cur, xfoff)	(false)
+#define xfbtree_check_block_owner(cur, block)	NULL
+#define xfbtree_owner(cur)			(0ULL)
+#define xfbtree_buf_to_xfoff(cur, bp)		(-1)
+
+#endif /* CONFIG_XFS_BTREE_IN_XFILE */
+
+#endif /* __XFS_BTREE_MEM_H__ */
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
new file mode 100644
index 0000000000000..b7b5aa52b40b4
--- /dev/null
+++ b/fs/xfs/scrub/xfbtree.c
@@ -0,0 +1,352 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_trans.h"
+#include "xfs_btree.h"
+#include "xfs_error.h"
+#include "xfs_btree_mem.h"
+#include "xfs_ag.h"
+#include "scrub/xfile.h"
+#include "scrub/xfbtree.h"
+
+/* btree ops functions for in-memory btrees. */
+
+static xfs_failaddr_t
+xfs_btree_mem_head_verify(
+	struct xfs_buf			*bp)
+{
+	struct xfs_btree_mem_head	*mhead = bp->b_addr;
+	struct xfs_mount		*mp = bp->b_mount;
+
+	if (!xfs_verify_magic(bp, mhead->mh_magic))
+		return __this_address;
+	if (be32_to_cpu(mhead->mh_nlevels) == 0)
+		return __this_address;
+	if (!uuid_equal(&mhead->mh_uuid, &mp->m_sb.sb_meta_uuid))
+		return __this_address;
+
+	return NULL;
+}
+
+static void
+xfs_btree_mem_head_read_verify(
+	struct xfs_buf		*bp)
+{
+	xfs_failaddr_t		fa = xfs_btree_mem_head_verify(bp);
+
+	if (fa)
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+}
+
+static void
+xfs_btree_mem_head_write_verify(
+	struct xfs_buf		*bp)
+{
+	xfs_failaddr_t		fa = xfs_btree_mem_head_verify(bp);
+
+	if (fa)
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+}
+
+static const struct xfs_buf_ops xfs_btree_mem_head_buf_ops = {
+	.name			= "xfs_btree_mem_head",
+	.magic			= { cpu_to_be32(XFS_BTREE_MEM_HEAD_MAGIC),
+				    cpu_to_be32(XFS_BTREE_MEM_HEAD_MAGIC) },
+	.verify_read		= xfs_btree_mem_head_read_verify,
+	.verify_write		= xfs_btree_mem_head_write_verify,
+	.verify_struct		= xfs_btree_mem_head_verify,
+};
+
+/* Initialize the header block for an in-memory btree. */
+static inline void
+xfs_btree_mem_head_init(
+	struct xfs_buf			*head_bp,
+	unsigned long long		owner,
+	xfileoff_t			leaf_xfoff)
+{
+	struct xfs_btree_mem_head	*mhead = head_bp->b_addr;
+	struct xfs_mount		*mp = head_bp->b_mount;
+
+	mhead->mh_magic = cpu_to_be32(XFS_BTREE_MEM_HEAD_MAGIC);
+	mhead->mh_nlevels = cpu_to_be32(1);
+	mhead->mh_owner = cpu_to_be64(owner);
+	mhead->mh_root = cpu_to_be64(leaf_xfoff);
+	uuid_copy(&mhead->mh_uuid, &mp->m_sb.sb_meta_uuid);
+
+	head_bp->b_ops = &xfs_btree_mem_head_buf_ops;
+}
+
+/* Return tree height from the in-memory btree head. */
+unsigned int
+xfs_btree_mem_head_nlevels(
+	struct xfs_buf			*head_bp)
+{
+	struct xfs_btree_mem_head	*mhead = head_bp->b_addr;
+
+	return be32_to_cpu(mhead->mh_nlevels);
+}
+
+/* Extract the buftarg target for this xfile btree. */
+struct xfs_buftarg *
+xfbtree_target(struct xfbtree *xfbtree)
+{
+	return xfbtree->target;
+}
+
+/* Is this daddr (sector offset) contained within the buffer target? */
+static inline bool
+xfbtree_verify_buftarg_xfileoff(
+	struct xfs_buftarg	*btp,
+	xfileoff_t		xfoff)
+{
+	xfs_daddr_t		xfoff_daddr = xfo_to_daddr(xfoff);
+
+	return xfs_buftarg_verify_daddr(btp, xfoff_daddr);
+}
+
+/* Is this btree xfile offset contained within the xfile? */
+bool
+xfbtree_verify_xfileoff(
+	struct xfs_btree_cur	*cur,
+	unsigned long long	xfoff)
+{
+	struct xfs_buftarg	*btp = xfbtree_target(cur->bc_mem.xfbtree);
+
+	return xfbtree_verify_buftarg_xfileoff(btp, xfoff);
+}
+
+/* Check if a btree pointer is reasonable. */
+int
+xfbtree_check_ptr(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	int				index,
+	int				level)
+{
+	xfileoff_t			bt_xfoff;
+	xfs_failaddr_t			fa = NULL;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		bt_xfoff = be64_to_cpu(ptr->l);
+	else
+		bt_xfoff = be32_to_cpu(ptr->s);
+
+	if (!xfbtree_verify_xfileoff(cur, bt_xfoff))
+		fa = __this_address;
+
+	if (fa) {
+		xfs_err(cur->bc_mp,
+"In-memory: Corrupt btree %d flags 0x%x pointer at level %d index %d fa %pS.",
+				cur->bc_btnum, cur->bc_flags, level, index,
+				fa);
+		return -EFSCORRUPTED;
+	}
+	return 0;
+}
+
+/* Convert a btree pointer to a daddr */
+xfs_daddr_t
+xfbtree_ptr_to_daddr(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr)
+{
+	xfileoff_t			bt_xfoff;
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		bt_xfoff = be64_to_cpu(ptr->l);
+	else
+		bt_xfoff = be32_to_cpu(ptr->s);
+	return xfo_to_daddr(bt_xfoff);
+}
+
+/* Set the pointer to point to this buffer. */
+void
+xfbtree_buf_to_ptr(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp,
+	union xfs_btree_ptr	*ptr)
+{
+	xfileoff_t		xfoff = xfs_daddr_to_xfo(xfs_buf_daddr(bp));
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		ptr->l = cpu_to_be64(xfoff);
+	else
+		ptr->s = cpu_to_be32(xfoff);
+}
+
+/* Return the in-memory btree block size, in units of 512 bytes. */
+unsigned int xfbtree_bbsize(void)
+{
+	return xfo_to_daddr(1);
+}
+
+/* Set the root of an in-memory btree. */
+void
+xfbtree_set_root(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*ptr,
+	int				inc)
+{
+	struct xfs_buf			*head_bp = cur->bc_mem.head_bp;
+	struct xfs_btree_mem_head	*mhead = head_bp->b_addr;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		mhead->mh_root = ptr->l;
+	} else {
+		uint32_t		root = be32_to_cpu(ptr->s);
+
+		mhead->mh_root = cpu_to_be64(root);
+	}
+	be32_add_cpu(&mhead->mh_nlevels, inc);
+	xfs_trans_log_buf(cur->bc_tp, head_bp, 0, sizeof(*mhead) - 1);
+}
+
+/* Initialize a pointer from the in-memory btree header. */
+void
+xfbtree_init_ptr_from_cur(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_ptr		*ptr)
+{
+	struct xfs_buf			*head_bp = cur->bc_mem.head_bp;
+	struct xfs_btree_mem_head	*mhead = head_bp->b_addr;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		ptr->l = mhead->mh_root;
+	} else {
+		uint64_t		root = be64_to_cpu(mhead->mh_root);
+
+		ptr->s = cpu_to_be32(root);
+	}
+}
+
+/* Duplicate an in-memory btree cursor. */
+struct xfs_btree_cur *
+xfbtree_dup_cursor(
+	struct xfs_btree_cur		*cur)
+{
+	struct xfs_btree_cur		*ncur;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
+
+	ncur = xfs_btree_alloc_cursor(cur->bc_mp, cur->bc_tp, cur->bc_btnum,
+			cur->bc_maxlevels, cur->bc_cache);
+	ncur->bc_flags = cur->bc_flags;
+	ncur->bc_nlevels = cur->bc_nlevels;
+	ncur->bc_statoff = cur->bc_statoff;
+	ncur->bc_ops = cur->bc_ops;
+	memcpy(&ncur->bc_mem, &cur->bc_mem, sizeof(cur->bc_mem));
+
+	if (cur->bc_mem.pag)
+		ncur->bc_mem.pag = xfs_perag_hold(cur->bc_mem.pag);
+
+	return ncur;
+}
+
+/* Check the owner of an in-memory btree block. */
+xfs_failaddr_t
+xfbtree_check_block_owner(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block)
+{
+	struct xfbtree		*xfbt = cur->bc_mem.xfbtree;
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (be64_to_cpu(block->bb_u.l.bb_owner) != xfbt->owner)
+			return __this_address;
+
+		return NULL;
+	}
+
+	if (be32_to_cpu(block->bb_u.s.bb_owner) != xfbt->owner)
+		return __this_address;
+
+	return NULL;
+}
+
+/* Return the owner of this in-memory btree. */
+unsigned long long
+xfbtree_owner(
+	struct xfs_btree_cur	*cur)
+{
+	return cur->bc_mem.xfbtree->owner;
+}
+
+/* Return the xfile offset (in blocks) of a btree buffer. */
+unsigned long long
+xfbtree_buf_to_xfoff(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
+
+	return xfs_daddr_to_xfo(xfs_buf_daddr(bp));
+}
+
+/* Verify a long-format btree block. */
+xfs_failaddr_t
+xfbtree_lblock_verify(
+	struct xfs_buf		*bp,
+	unsigned int		max_recs)
+{
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_buftarg	*btp = bp->b_target;
+
+	/* numrecs verification */
+	if (be16_to_cpu(block->bb_numrecs) > max_recs)
+		return __this_address;
+
+	/* sibling pointer verification */
+	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
+	    !xfbtree_verify_buftarg_xfileoff(btp,
+				be64_to_cpu(block->bb_u.l.bb_leftsib)))
+		return __this_address;
+
+	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
+	    !xfbtree_verify_buftarg_xfileoff(btp,
+				be64_to_cpu(block->bb_u.l.bb_rightsib)))
+		return __this_address;
+
+	return NULL;
+}
+
+/* Verify a short-format btree block. */
+xfs_failaddr_t
+xfbtree_sblock_verify(
+	struct xfs_buf		*bp,
+	unsigned int		max_recs)
+{
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_buftarg	*btp = bp->b_target;
+
+	/* numrecs verification */
+	if (be16_to_cpu(block->bb_numrecs) > max_recs)
+		return __this_address;
+
+	/* sibling pointer verification */
+	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
+	    !xfbtree_verify_buftarg_xfileoff(btp,
+				be32_to_cpu(block->bb_u.s.bb_leftsib)))
+		return __this_address;
+
+	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
+	    !xfbtree_verify_buftarg_xfileoff(btp,
+				be32_to_cpu(block->bb_u.s.bb_rightsib)))
+		return __this_address;
+
+	return NULL;
+}
diff --git a/fs/xfs/scrub/xfbtree.h b/fs/xfs/scrub/xfbtree.h
new file mode 100644
index 0000000000000..b8d2f628e6b7c
--- /dev/null
+++ b/fs/xfs/scrub/xfbtree.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef XFS_SCRUB_XFBTREE_H__
+#define XFS_SCRUB_XFBTREE_H__
+
+#ifdef CONFIG_XFS_BTREE_IN_XFILE
+
+/* Root block for an in-memory btree. */
+struct xfs_btree_mem_head {
+	__be32				mh_magic;
+	__be32				mh_nlevels;
+	__be64				mh_owner;
+	__be64				mh_root;
+	uuid_t				mh_uuid;
+};
+
+#define XFS_BTREE_MEM_HEAD_MAGIC	0x4341544D	/* "CATM" */
+
+/* xfile-backed in-memory btrees */
+
+struct xfbtree {
+	/* buffer cache target for this in-memory btree */
+	struct xfs_buftarg		*target;
+
+	/* Owner of this btree. */
+	unsigned long long		owner;
+};
+
+#endif /* CONFIG_XFS_BTREE_IN_XFILE */
+
+#endif /* XFS_SCRUB_XFBTREE_H__ */
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index d7661ee909495..8bdea8788a8a7 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -78,6 +78,47 @@ int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
 int xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
 
 int xfile_dump(struct xfile *xf);
+
+static inline loff_t xfile_size(struct xfile *xf)
+{
+	return i_size_read(file_inode(xf->file));
+}
+
+/* file block (aka system page size) to basic block conversions. */
+typedef unsigned long long	xfileoff_t;
+#define XFB_BLOCKSIZE		(PAGE_SIZE)
+#define XFB_BSHIFT		(PAGE_SHIFT)
+#define XFB_SHIFT		(XFB_BSHIFT - BBSHIFT)
+
+static inline loff_t xfo_to_b(xfileoff_t xfoff)
+{
+	return xfoff << XFB_BSHIFT;
+}
+
+static inline xfileoff_t b_to_xfo(loff_t pos)
+{
+	return (pos + (XFB_BLOCKSIZE - 1)) >> XFB_BSHIFT;
+}
+
+static inline xfileoff_t b_to_xfot(loff_t pos)
+{
+	return pos >> XFB_BSHIFT;
+}
+
+static inline xfs_daddr_t xfo_to_daddr(xfileoff_t xfoff)
+{
+	return xfoff << XFB_SHIFT;
+}
+
+static inline xfileoff_t xfs_daddr_to_xfo(xfs_daddr_t bb)
+{
+	return (bb + (xfo_to_daddr(1) - 1)) >> XFB_SHIFT;
+}
+
+static inline xfileoff_t xfs_daddr_to_xfot(xfs_daddr_t bb)
+{
+	return bb >> XFB_SHIFT;
+}
 #else
 static inline int
 xfile_obj_load(struct xfile *xf, void *buf, size_t count, loff_t offset)
@@ -90,6 +131,11 @@ xfile_obj_store(struct xfile *xf, const void *buf, size_t count, loff_t offset)
 {
 	return -EIO;
 }
+
+static inline loff_t xfile_size(struct xfile *xf)
+{
+	return 0;
+}
 #endif /* CONFIG_XFS_IN_MEMORY_FILE */
 
 #endif /* __XFS_SCRUB_XFILE_H__ */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9ce08a4823851..a61ad61cb9136 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2497,3 +2497,13 @@ xfs_verify_magic16(
 		return false;
 	return dmagic == bp->b_ops->magic16[idx];
 }
+
+/* Return the number of sectors for a buffer target. */
+xfs_daddr_t
+xfs_buftarg_nr_sectors(
+	struct xfs_buftarg	*btp)
+{
+	if (btp->bt_flags & XFS_BUFTARG_XFILE)
+		return xfile_buftarg_nr_sectors(btp);
+	return bdev_nr_sectors(btp->bt_bdev);
+}
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index a86c0b8e5a85e..5a6cf3d5a9f53 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -440,6 +440,16 @@ xfs_buftarg_zeroout(
 			flags);
 }
 
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
 int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
 bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
diff --git a/fs/xfs/xfs_buf_xfile.c b/fs/xfs/xfs_buf_xfile.c
index 15cbe3df7aa01..51c5c692156b1 100644
--- a/fs/xfs/xfs_buf_xfile.c
+++ b/fs/xfs/xfs_buf_xfile.c
@@ -87,3 +87,11 @@ xfile_free_buftarg(
 	xfs_buf_cache_destroy(&xfile->bcache);
 	xfile_destroy(xfile);
 }
+
+/* Sector count for this xfile buftarg. */
+xfs_daddr_t
+xfile_buftarg_nr_sectors(
+	struct xfs_buftarg	*btp)
+{
+	return xfile_size(btp->bt_xfile) >> SECTOR_SHIFT;
+}
diff --git a/fs/xfs/xfs_buf_xfile.h b/fs/xfs/xfs_buf_xfile.h
index 69d7846215468..c8d78d01ea5df 100644
--- a/fs/xfs/xfs_buf_xfile.h
+++ b/fs/xfs/xfs_buf_xfile.h
@@ -11,8 +11,10 @@ int xfile_buf_ioapply(struct xfs_buf *bp);
 int xfile_alloc_buftarg(struct xfs_mount *mp, const char *descr,
 		struct xfs_buftarg **btpp);
 void xfile_free_buftarg(struct xfs_buftarg *btp);
+xfs_daddr_t xfile_buftarg_nr_sectors(struct xfs_buftarg *btp);
 #else
 # define xfile_buf_ioapply(bp)			(-EOPNOTSUPP)
+# define xfile_buftarg_nr_sectors(btp)		(0)
 #endif /* CONFIG_XFS_IN_MEMORY_FILE */
 
 #endif /* __XFS_BUF_XFILE_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 2be1ac83f4c41..bd884c154cf37 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -512,6 +512,9 @@ xfs_btree_mark_sick(
 {
 	unsigned int			mask;
 
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return;
+
 	switch (cur->bc_btnum) {
 	case XFS_BTNUM_BMAP:
 		xfs_bmap_mark_sick(cur->bc_ino.ip, cur->bc_ino.whichfork);
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 8a5dc1538aa82..2d49310fb9128 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -36,6 +36,9 @@
 #include "xfs_error.h"
 #include <linux/iomap.h>
 #include "xfs_iomap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfbtree.h"
+#include "xfs_btree_mem.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3c6c8a8dfae8e..4a2615db742aa 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2507,7 +2507,10 @@ TRACE_EVENT(xfs_btree_alloc_block,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		if (cur->bc_flags & XFS_BTREE_IN_XFILE) {
+			__entry->agno = 0;
+			__entry->ino = 0;
+		} else if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
 			__entry->agno = 0;
 			__entry->ino = cur->bc_ino.ip->i_ino;
 		} else {

