Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7346D652
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817506; cv=none; b=kyXSaDoC0c8+r0wVuqS0LIA0+CN610iIBEOcHHWTkXBKgs3szbjGqcimH6DMEjGDHuI1sF9/4k1Zf7o3y5girixQFVMdAOtjIYn5oUdZt1eokCtFR/Yekfsro0heJ+fd3REzBZEowZUOqQoJ9oq5xXqn0ICBP9zEgEnfUy7BI3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817506; c=relaxed/simple;
	bh=QfpiFDdAoir5uMYfSxs94NlunklEw+n36Ua+RjKh15Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sD3YDTL4dsCBcDZe3CowycsO+H0May8dm/5WUaDZMeAln0aKpgy3Z7YvYI1iiMiA3rLXDBtk/BferbLlfWfTLfXn7w8U4CDUYcOAku4rExGUJmOCeYEXXd3f+nyDdBSn5j+Y7q8CYS45Ii93KbYCJ4X+ngo+1roL4zvcwJ9gVb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JffkLGhf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JffkLGhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3839BC433F1;
	Thu,  1 Feb 2024 19:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817506;
	bh=QfpiFDdAoir5uMYfSxs94NlunklEw+n36Ua+RjKh15Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JffkLGhfLw+B5iahxN0sZNWctXGopDUdDIVrJHpm0dDdFHXXFKiAPbjjmH3ciwp6j
	 wP31QCcfWhM4J/jhvSk4igFMgrgTqHUBEyo3l1RU6SZigHxzlBqKR84Lyfw9SEQk53
	 qUXNP5XSZ6MbjGpH7qB66EvohPunRJfMs/7/rugewFbjN6HGV8L4P4nZwB3RLPncZI
	 1dgJOfrWj7pTHsRa8XajUu6PTwfucmXV0iGMMtfV7xmu295DArabUImw7Q7KfYbAQQ
	 /uRl07d6MLiYUeugOe0UuzIzz39BlV4H5ty+Q/RAgVHyHqjufIYyAsIKKO0hfXLxoE
	 T7AtDb9cIDrQA==
Date: Thu, 01 Feb 2024 11:58:25 -0800
Subject: [PATCH 4/5] xfs: support in-memory btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170681337024.1608400.6539701966034810832.stgit@frogsfrogsfrogs>
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

Adapt the generic btree cursor code to be able to create a btree whose
buffers come from a (presumably in-memory) buftarg with a header block
that's specific to in-memory btrees.  We'll connect this to other parts
of online scrub in the next patches.

Note that in-memory btrees always have a block size matching the system
memory page size for efficiency reasons.  There are also a few things we
need to do to finalize a btree update; that's covered in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |    5 
 fs/xfs/Kconfig                                     |    4 
 fs/xfs/Makefile                                    |    1 
 fs/xfs/libxfs/xfs_btree.c                          |  256 +++++++++++++++++---
 fs/xfs/libxfs/xfs_btree.h                          |    7 +
 fs/xfs/libxfs/xfs_btree_mem.c                      |  228 ++++++++++++++++++
 fs/xfs/libxfs/xfs_btree_mem.h                      |   72 ++++++
 fs/xfs/scrub/scrub.c                               |    5 
 fs/xfs/scrub/scrub.h                               |    3 
 fs/xfs/xfs_buf_mem.c                               |   13 +
 fs/xfs/xfs_buf_mem.h                               |    2 
 fs/xfs/xfs_health.c                                |    3 
 fs/xfs/xfs_trace.c                                 |    1 
 fs/xfs/xfs_trace.h                                 |  117 +++++++++
 14 files changed, 675 insertions(+), 42 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_btree_mem.c
 create mode 100644 fs/xfs/libxfs/xfs_btree_mem.h


diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index d03480266e9b1..6333697ba3e82 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -2270,13 +2270,12 @@ follows:
    pointing to the xfile.
 
 3. Pass the buffer cache target, buffer ops, and other information to
-   ``xfbtree_create`` to write an initial tree header and root block to the
-   xfile.
+   ``xfbtree_init`` to initialize the passed in ``struct xfbtree`` and write an
+   initial root block to the xfile.
    Each btree type should define a wrapper that passes necessary arguments to
    the creation function.
    For example, rmap btrees define ``xfs_rmapbt_mem_create`` to take care of
    all the necessary details for callers.
-   A ``struct xfbtree`` object will be returned.
 
 4. Pass the xfbtree object to the btree cursor creation function for the
    btree type.
diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 7017ea0fb4cd3..d41edd30388b7 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -131,6 +131,9 @@ config XFS_LIVE_HOOKS
 config XFS_MEMORY_BUFS
 	bool
 
+config XFS_BTREE_IN_MEM
+	bool
+
 config XFS_ONLINE_SCRUB
 	bool "XFS online metadata check support"
 	default n
@@ -173,6 +176,7 @@ config XFS_ONLINE_REPAIR
 	bool "XFS online metadata repair support"
 	default n
 	depends on XFS_FS && XFS_ONLINE_SCRUB
+	select XFS_BTREE_IN_MEM
 	help
 	  If you say Y here you will be able to repair metadata on a
 	  mounted XFS filesystem.  This feature is intended to reduce
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 78d816ffd99a3..caa50b5b5468e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -139,6 +139,7 @@ endif
 xfs-$(CONFIG_XFS_DRAIN_INTENTS)	+= xfs_drain.o
 xfs-$(CONFIG_XFS_LIVE_HOOKS)	+= xfs_hooks.o
 xfs-$(CONFIG_XFS_MEMORY_BUFS)	+= xfs_buf_mem.o
+xfs-$(CONFIG_XFS_BTREE_IN_MEM)	+= libxfs/xfs_btree_mem.o
 
 # online scrub/repair
 ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index aa60a46b8eecc..d29547572a688 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -28,6 +28,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_health.h"
+#include "xfs_buf_mem.h"
+#include "xfs_btree_mem.h"
 
 /*
  * Btree magic numbers.
@@ -75,6 +77,25 @@ xfs_btree_check_fsblock_siblings(
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
@@ -164,6 +185,34 @@ __xfs_btree_check_fsblock(
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
@@ -216,9 +265,17 @@ __xfs_btree_check_block(
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
@@ -262,14 +319,22 @@ __xfs_btree_check_ptr(
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
@@ -290,17 +355,26 @@ xfs_btree_check_ptr(
 
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
@@ -457,11 +531,35 @@ xfs_btree_del_cursor(
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
@@ -505,10 +603,11 @@ xfs_btree_dup_cursor(
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
@@ -885,6 +984,32 @@ xfs_btree_readahead_fsblock(
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
@@ -939,9 +1064,17 @@ xfs_btree_readahead(
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
@@ -950,23 +1083,24 @@ xfs_btree_ptr_to_daddr(
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
 
@@ -986,8 +1120,9 @@ xfs_btree_readahead_ptr(
 
 	if (xfs_btree_ptr_to_daddr(cur, ptr, &daddr))
 		return;
-	xfs_buf_readahead(cur->bc_mp->m_ddev_targp, daddr,
-			  cur->bc_mp->m_bsize * count, cur->bc_ops->buf_ops);
+	xfs_buf_readahead(xfs_btree_buftarg(cur), daddr,
+			xfs_btree_bbsize(cur) * count,
+			cur->bc_ops->buf_ops);
 }
 
 /*
@@ -1172,9 +1307,17 @@ static inline __u64
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
@@ -1218,12 +1361,18 @@ xfs_btree_buf_to_ptr(
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
 
@@ -1242,15 +1391,14 @@ xfs_btree_get_buf_block(
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
 
@@ -1281,9 +1429,9 @@ xfs_btree_read_buf_block(
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
@@ -4582,6 +4730,8 @@ xfs_btree_fsblock_verify(
 	xfs_fsblock_t		fsb;
 	xfs_failaddr_t		fa;
 
+	ASSERT(!xfs_buftarg_is_mem(bp->b_target));
+
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
@@ -4596,6 +4746,36 @@ xfs_btree_fsblock_verify(
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
@@ -4637,6 +4817,8 @@ xfs_btree_agblock_verify(
 	xfs_agblock_t		agbno;
 	xfs_failaddr_t		fa;
 
+	ASSERT(!xfs_buftarg_is_mem(bp->b_target));
+
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 790eccb771866..dd77b231c1d59 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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
diff --git a/fs/xfs/libxfs/xfs_btree_mem.c b/fs/xfs/libxfs/xfs_btree_mem.c
new file mode 100644
index 0000000000000..cb156e9363a5d
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -0,0 +1,228 @@
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
+#include "xfs_buf_mem.h"
+#include "xfs_btree_mem.h"
+#include "xfs_ag.h"
+#include "xfs_buf_item.h"
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
diff --git a/fs/xfs/libxfs/xfs_btree_mem.h b/fs/xfs/libxfs/xfs_btree_mem.h
new file mode 100644
index 0000000000000..ecc2ceac3ed4f
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_btree_mem.h
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
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index aeac9cae4ad4c..6828e72824fb5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -15,6 +15,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_scrub.h"
+#include "xfs_buf_mem.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -190,6 +191,10 @@ xchk_teardown(
 		sc->flags &= ~XCHK_HAVE_FREEZE_PROT;
 		mnt_drop_write_file(sc->file);
 	}
+	if (sc->xmbtp) {
+		xmbuf_free(sc->xmbtp);
+		sc->xmbtp = NULL;
+	}
 	if (sc->xfile) {
 		xfile_destroy(sc->xfile);
 		sc->xfile = NULL;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index f99a3c21d02ea..1247284c17a09 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -99,6 +99,9 @@ struct xfs_scrub {
 	/* xfile used by the scrubbers; freed at teardown. */
 	struct xfile			*xfile;
 
+	/* buffer target for in-memory btrees; also freed at teardown. */
+	struct xfs_buftarg		*xmbtp;
+
 	/* Lock flags for @ip. */
 	uint				ilock_flags;
 
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index be71ba1a3d7b0..73caa2ea8b18f 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -187,3 +187,16 @@ xmbuf_unmap_page(
 	bp->b_pages = NULL;
 	bp->b_page_count = 0;
 }
+
+/* Is this a valid daddr within the buftarg? */
+bool
+xmbuf_verify_daddr(
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		daddr)
+{
+	struct inode		*inode = file_inode(btp->bt_file);
+
+	ASSERT(xfs_buftarg_is_mem(btp));
+
+	return daddr < (inode->i_sb->s_maxbytes >> BBSHIFT);
+}
diff --git a/fs/xfs/xfs_buf_mem.h b/fs/xfs/xfs_buf_mem.h
index 945f4b610998f..dfb3029113ff7 100644
--- a/fs/xfs/xfs_buf_mem.h
+++ b/fs/xfs/xfs_buf_mem.h
@@ -21,10 +21,12 @@ void xmbuf_free(struct xfs_buftarg *btp);
 
 int xmbuf_map_page(struct xfs_buf *bp);
 void xmbuf_unmap_page(struct xfs_buf *bp);
+bool xmbuf_verify_daddr(struct xfs_buftarg *btp, xfs_daddr_t daddr);
 #else
 # define xfs_buftarg_is_mem(...)	(false)
 # define xmbuf_map_page(...)		(-ENOMEM)
 # define xmbuf_unmap_page(...)		((void)0)
+# define xmbuf_verify_daddr(...)	(false)
 #endif /* CONFIG_XFS_MEMORY_BUFS */
 
 #endif /* __XFS_BUF_MEM_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 9729dc56c6c9a..6ca48a2962b93 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -511,6 +511,9 @@ xfs_btree_mark_sick(
 	struct xfs_btree_cur		*cur)
 {
 	switch (cur->bc_ops->type) {
+	case XFS_BTREE_TYPE_MEM:
+		/* no health state tracking for ephemeral btrees */
+		return;
 	case XFS_BTREE_TYPE_AG:
 		ASSERT(cur->bc_ops->sick_mask);
 		xfs_ag_mark_sick(cur->bc_ag.pag, cur->bc_ops->sick_mask);
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index ae5be6b589f0e..3f253884fe5b1 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -37,6 +37,7 @@
 #include <linux/iomap.h>
 #include "xfs_iomap.h"
 #include "xfs_buf_mem.h"
+#include "xfs_btree_mem.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 771008abdc367..17116cc53b0fe 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -79,6 +79,8 @@ union xfs_btree_ptr;
 struct xfs_dqtrx;
 struct xfs_icwalk;
 struct xfs_perag;
+struct xfbtree;
+struct xfs_btree_ops;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -2499,12 +2501,19 @@ TRACE_EVENT(xfs_btree_alloc_block,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
+		switch (cur->bc_ops->type) {
+		case XFS_BTREE_TYPE_INODE:
 			__entry->agno = 0;
 			__entry->ino = cur->bc_ino.ip->i_ino;
-		} else {
+			break;
+		case XFS_BTREE_TYPE_AG:
 			__entry->agno = cur->bc_ag.pag->pag_agno;
 			__entry->ino = 0;
+			break;
+		case XFS_BTREE_TYPE_MEM:
+			__entry->agno = 0;
+			__entry->ino = 0;
+			break;
 		}
 		__assign_str(name, cur->bc_ops->name);
 		__entry->error = error;
@@ -4584,6 +4593,110 @@ TRACE_EVENT(xmbuf_free,
 );
 #endif /* CONFIG_XFS_MEMORY_BUFS */
 
+#ifdef CONFIG_XFS_BTREE_IN_MEM
+TRACE_EVENT(xfbtree_init,
+	TP_PROTO(struct xfs_mount *mp, struct xfbtree *xfbt,
+		 const struct xfs_btree_ops *ops),
+	TP_ARGS(mp, xfbt, ops),
+	TP_STRUCT__entry(
+		__field(const void *, btree_ops)
+		__field(unsigned long, xfino)
+		__field(unsigned int, leaf_mxr)
+		__field(unsigned int, leaf_mnr)
+		__field(unsigned int, node_mxr)
+		__field(unsigned int, node_mnr)
+		__field(unsigned long long, owner)
+	),
+	TP_fast_assign(
+		__entry->btree_ops = ops;
+		__entry->xfino = file_inode(xfbt->target->bt_file)->i_ino;
+		__entry->leaf_mxr = xfbt->maxrecs[0];
+		__entry->node_mxr = xfbt->maxrecs[1];
+		__entry->leaf_mnr = xfbt->minrecs[0];
+		__entry->node_mnr = xfbt->minrecs[1];
+		__entry->owner = xfbt->owner;
+	),
+	TP_printk("xfino 0x%lx btree_ops %pS owner 0x%llx leaf_mxr %u leaf_mnr %u node_mxr %u node_mnr %u",
+		  __entry->xfino,
+		  __entry->btree_ops,
+		  __entry->owner,
+		  __entry->leaf_mxr,
+		  __entry->leaf_mnr,
+		  __entry->node_mxr,
+		  __entry->node_mnr)
+);
+
+DECLARE_EVENT_CLASS(xfbtree_buf_class,
+	TP_PROTO(struct xfbtree *xfbt, struct xfs_buf *bp),
+	TP_ARGS(xfbt, bp),
+	TP_STRUCT__entry(
+		__field(unsigned long, xfino)
+		__field(xfs_daddr_t, bno)
+		__field(int, nblks)
+		__field(int, hold)
+		__field(int, pincount)
+		__field(unsigned int, lockval)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->xfino = file_inode(xfbt->target->bt_file)->i_ino;
+		__entry->bno = xfs_buf_daddr(bp);
+		__entry->nblks = bp->b_length;
+		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->pincount = atomic_read(&bp->b_pin_count);
+		__entry->lockval = bp->b_sema.count;
+		__entry->flags = bp->b_flags;
+	),
+	TP_printk("xfino 0x%lx daddr 0x%llx bbcount 0x%x hold %d pincount %d lock %d flags %s",
+		  __entry->xfino,
+		  (unsigned long long)__entry->bno,
+		  __entry->nblks,
+		  __entry->hold,
+		  __entry->pincount,
+		  __entry->lockval,
+		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS))
+)
+
+#define DEFINE_XFBTREE_BUF_EVENT(name) \
+DEFINE_EVENT(xfbtree_buf_class, name, \
+	TP_PROTO(struct xfbtree *xfbt, struct xfs_buf *bp), \
+	TP_ARGS(xfbt, bp))
+DEFINE_XFBTREE_BUF_EVENT(xfbtree_create_root_buf);
+DEFINE_XFBTREE_BUF_EVENT(xfbtree_trans_commit_buf);
+DEFINE_XFBTREE_BUF_EVENT(xfbtree_trans_cancel_buf);
+
+DECLARE_EVENT_CLASS(xfbtree_freesp_class,
+	TP_PROTO(struct xfbtree *xfbt, struct xfs_btree_cur *cur,
+		 xfs_fileoff_t fileoff),
+	TP_ARGS(xfbt, cur, fileoff),
+	TP_STRUCT__entry(
+		__field(unsigned long, xfino)
+		__string(btname, cur->bc_ops->name)
+		__field(int, nlevels)
+		__field(xfs_fileoff_t, fileoff)
+	),
+	TP_fast_assign(
+		__entry->xfino = file_inode(xfbt->target->bt_file)->i_ino;
+		__assign_str(btname, cur->bc_ops->name);
+		__entry->nlevels = cur->bc_nlevels;
+		__entry->fileoff = fileoff;
+	),
+	TP_printk("xfino 0x%lx %sbt nlevels %d fileoff 0x%llx",
+		  __entry->xfino,
+		  __get_str(btname),
+		  __entry->nlevels,
+		  (unsigned long long)__entry->fileoff)
+)
+
+#define DEFINE_XFBTREE_FREESP_EVENT(name) \
+DEFINE_EVENT(xfbtree_freesp_class, name, \
+	TP_PROTO(struct xfbtree *xfbt, struct xfs_btree_cur *cur, \
+		 xfs_fileoff_t fileoff), \
+	TP_ARGS(xfbt, cur, fileoff))
+DEFINE_XFBTREE_FREESP_EVENT(xfbtree_alloc_block);
+DEFINE_XFBTREE_FREESP_EVENT(xfbtree_free_block);
+#endif /* CONFIG_XFS_BTREE_IN_MEM */
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

