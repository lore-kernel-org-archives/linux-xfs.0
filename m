Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5F6C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jS//iJEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737CAC433C8;
	Sun, 31 Dec 2023 22:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060998;
	bh=1i4mDTwegCFzepFi7sI/8Dsk14+h7k0DnEfjG10HNLM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jS//iJEQuXKJ1BWvgPiGWuIETRngjSAEag7/80jRWNA6CkyYBdZmAS0xCb5HxnGUR
	 bDSTQFbQNjVpm6ZjwANjbAsqP/lZUtXktJz6Cqi7DKzOSqR1m6Y3VyZDyoUgN5pYmx
	 oadE8Vv54fRcbTf8Az5XKIo5XhE2t8ijfAJX1F9zuQASQRZ3Xjx7WBnh2uMZCukwxp
	 JirPalUNBIoA9n4SrrX/HSUSm50XhaBquiwyN/Vl4kN3A1fROLksHgvkt/qnnew6Kn
	 VCWsDLtU4IGCKVWigiwD1JsDCNhlVZgZyE2R/VyE6/xbit96Qe/wXfhSTFiyXfj4lO
	 6wI0RZQAxbxBQ==
Date: Sun, 31 Dec 2023 14:16:37 -0800
Subject: [PATCH 08/10] xfs: support in-memory btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992889.1794490.16352604943192308455.stgit@frogsfrogsfrogs>
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

Adapt the generic btree cursor code to be able to create a btree whose
buffers come from a (presumably in-memory) buftarg with a header block
that's specific to in-memory btrees.  We'll connect this to other parts
of online scrub in the next patches.

Note that in-memory btrees always have a block size matching the system
memory page size for efficiency reasons.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h       |    1 
 libxfs/Makefile        |    3 
 libxfs/init.c          |    2 
 libxfs/libxfs_io.h     |   10 +
 libxfs/libxfs_priv.h   |    1 
 libxfs/rdwr.c          |   29 ++++
 libxfs/xfbtree.c       |  343 ++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfbtree.h       |   36 +++++
 libxfs/xfile.c         |   18 +++
 libxfs/xfile.h         |   50 +++++++
 libxfs/xfs_btree.c     |  151 +++++++++++++++++----
 libxfs/xfs_btree.h     |   17 ++
 libxfs/xfs_btree_mem.h |   87 ++++++++++++
 13 files changed, 720 insertions(+), 28 deletions(-)
 create mode 100644 libxfs/xfbtree.c
 create mode 100644 libxfs/xfbtree.h
 create mode 100644 libxfs/xfs_btree_mem.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 5251475cf15..43fb5425796 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -8,6 +8,7 @@
 #define __LIBXFS_H__
 
 #define CONFIG_XFS_RT
+#define CONFIG_XFS_BTREE_IN_XFILE
 
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 68b366072da..8e6b2dfdfe1 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -26,6 +26,7 @@ HFILES = \
 	libxfs_priv.h \
 	linux-err.h \
 	topology.h \
+	xfbtree.h \
 	xfile.h \
 	xfs_ag_resv.h \
 	xfs_alloc.h \
@@ -36,6 +37,7 @@ HFILES = \
 	xfs_bmap.h \
 	xfs_bmap_btree.h \
 	xfs_btree.h \
+	xfs_btree_mem.h \
 	xfs_btree_staging.h \
 	xfs_attr_remote.h \
 	xfs_cksum.h \
@@ -67,6 +69,7 @@ CFILES = cache.c \
 	topology.c \
 	trans.c \
 	util.c \
+	xfbtree.c \
 	xfile.c \
 	xfs_ag.c \
 	xfs_ag_resv.c \
diff --git a/libxfs/init.c b/libxfs/init.c
index c776a9b07f5..6d088125f5d 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -22,6 +22,7 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "libfrog/platform.h"
+#include "xfile.h"
 
 #include "xfs_format.h"
 #include "xfs_da_format.h"
@@ -253,6 +254,7 @@ int
 libxfs_init(struct libxfs_init *a)
 {
 	xfs_check_ondisk_structs();
+	xfile_libinit();
 	rcu_init();
 	rcu_register_thread();
 	radix_tree_init();
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index a20e78338dd..8a99955ee73 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -263,4 +263,14 @@ xfs_buf_delwri_queue_here(struct xfs_buf *bp, struct list_head *buffer_list)
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
index 9310752a9b2..e3d9b70cc17 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -38,6 +38,7 @@
 #define __LIBXFS_INTERNAL_XFS_H__
 
 #define CONFIG_XFS_RT
+#define CONFIG_XFS_BTREE_IN_XFILE
 
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 645c4b7838d..f352225f23d 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1547,3 +1547,32 @@ __xfs_buf_mark_corrupt(
 	xfs_buf_corruption_error(bp, fa);
 	xfs_buf_stale(bp);
 }
+
+/* Return the number of sectors for a buffer target. */
+xfs_daddr_t
+xfs_buftarg_nr_sectors(
+	struct xfs_buftarg	*btp)
+{
+	struct stat		sb;
+	int			fd = btp->bt_bdev_fd;
+	int			ret;
+
+	if (btp->flags & XFS_BUFTARG_XFILE)
+		return xfile_size(btp->bt_xfile) >> BBSHIFT;
+
+	ret = fstat(fd, &sb);
+	if (ret)
+		return 0;
+
+	if (S_ISBLK(sb.st_mode)) {
+		uint64_t	sz;
+
+		ret = ioctl(fd, BLKGETSIZE64, &sz);
+		if (ret)
+			return 0;
+
+		return sz >> BBSHIFT;
+	}
+
+	return sb.st_size >> BBSHIFT;
+}
diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
new file mode 100644
index 00000000000..79585dd3a23
--- /dev/null
+++ b/libxfs/xfbtree.c
@@ -0,0 +1,343 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "libxfs.h"
+#include "xfile.h"
+#include "xfbtree.h"
+#include "xfs_btree_mem.h"
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
diff --git a/libxfs/xfbtree.h b/libxfs/xfbtree.h
new file mode 100644
index 00000000000..292bade32d2
--- /dev/null
+++ b/libxfs/xfbtree.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBXFS_XFBTREE_H__
+#define __LIBXFS_XFBTREE_H__
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
+/* in-memory btree header is always block 0 in the backing store */
+#define XFS_BTREE_MEM_HEAD_DADDR	0
+
+/* xfile-backed in-memory btrees */
+
+struct xfbtree {
+	struct xfs_buftarg		*target;
+
+	/* Owner of this btree. */
+	unsigned long long		owner;
+};
+
+#endif /* CONFIG_XFS_BTREE_IN_XFILE */
+
+#endif /* __LIBXFS_XFBTREE_H__ */
diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index 57694d33498..d6eefadae69 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -6,6 +6,7 @@
 #include "libxfs_priv.h"
 #include "libxfs.h"
 #include "libxfs/xfile.h"
+#include "libfrog/util.h"
 #ifdef HAVE_MEMFD_NOEXEC_SEAL
 # include <linux/memfd.h>
 #endif
@@ -29,6 +30,23 @@
  * management; file locks are not taken.
  */
 
+/* Figure out the xfile block size here */
+unsigned int		XFB_BLOCKSIZE;
+unsigned int		XFB_BSHIFT;
+
+void
+xfile_libinit(void)
+{
+	long		ret = sysconf(_SC_PAGESIZE);
+
+	/* If we don't find a power-of-two page size, go with 4k. */
+	if (ret < 0 || !is_power_of_2(ret))
+		ret = 4096;
+
+	XFB_BLOCKSIZE = ret;
+	XFB_BSHIFT = libxfs_highbit32(XFB_BLOCKSIZE);
+}
+
 /*
  * Open a memory-backed fd to back an xfile.  We require close-on-exec here,
  * because these memfd files function as windowed RAM and hence should never
diff --git a/libxfs/xfile.h b/libxfs/xfile.h
index 4218c17e8bf..e762e392caa 100644
--- a/libxfs/xfile.h
+++ b/libxfs/xfile.h
@@ -10,6 +10,8 @@ struct xfile {
 	int		fd;
 };
 
+void xfile_libinit(void);
+
 int xfile_create(const char *description, struct xfile **xfilep);
 void xfile_destroy(struct xfile *xf);
 
@@ -53,4 +55,52 @@ int xfile_stat(struct xfile *xf, struct xfile_stat *statbuf);
 unsigned long long xfile_bytes(struct xfile *xf);
 int xfile_dump(struct xfile *xf);
 
+static inline loff_t xfile_size(struct xfile *xf)
+{
+	struct xfile_stat	xs;
+	int			ret;
+
+	ret = xfile_stat(xf, &xs);
+	if (ret)
+		return 0;
+
+	return xs.size;
+}
+
+/* file block (aka system page size) to basic block conversions. */
+typedef unsigned long long	xfileoff_t;
+extern unsigned int		XFB_BLOCKSIZE;
+extern unsigned int		XFB_BSHIFT;
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
+
 #endif /* __LIBXFS_XFILE_H__ */
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index d47847db3db..14f0f017759 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -25,6 +25,9 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_health.h"
+#include "xfile.h"
+#include "xfbtree.h"
+#include "xfs_btree_mem.h"
 
 /*
  * Btree magic numbers.
@@ -79,6 +82,9 @@ xfs_btree_check_lblock_siblings(
 	if (level >= 0) {
 		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
 			return __this_address;
+	} else if (cur && (cur->bc_flags & XFS_BTREE_IN_XFILE)) {
+		if (!xfbtree_verify_xfileoff(cur, sibling))
+			return __this_address;
 	} else {
 		if (!xfs_verify_fsbno(mp, sibling))
 			return __this_address;
@@ -106,6 +112,9 @@ xfs_btree_check_sblock_siblings(
 	if (level >= 0) {
 		if (!xfs_btree_check_sptr(cur, sibling, level + 1))
 			return __this_address;
+	} else if (cur && (cur->bc_flags & XFS_BTREE_IN_XFILE)) {
+		if (!xfbtree_verify_xfileoff(cur, sibling))
+			return __this_address;
 	} else {
 		if (!xfs_verify_agbno(pag, sibling))
 			return __this_address;
@@ -148,7 +157,9 @@ __xfs_btree_check_lblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
-	if (bp)
+	if ((cur->bc_flags & XFS_BTREE_IN_XFILE) && bp)
+		fsb = xfbtree_buf_to_xfoff(cur, bp);
+	else if (bp)
 		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
 	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
@@ -215,8 +226,12 @@ __xfs_btree_check_sblock(
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
@@ -273,6 +288,8 @@ xfs_btree_check_lptr(
 {
 	if (level <= 0)
 		return false;
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return xfbtree_verify_xfileoff(cur, fsbno);
 	return xfs_verify_fsbno(cur->bc_mp, fsbno);
 }
 
@@ -285,6 +302,8 @@ xfs_btree_check_sptr(
 {
 	if (level <= 0)
 		return false;
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return xfbtree_verify_xfileoff(cur, agbno);
 	return xfs_verify_agbno(cur->bc_ag.pag, agbno);
 }
 
@@ -299,6 +318,9 @@ xfs_btree_check_ptr(
 	int				index,
 	int				level)
 {
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return xfbtree_check_ptr(cur, ptr, index, level);
+
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		if (xfs_btree_check_lptr(cur, be64_to_cpu((&ptr->l)[index]),
 				level))
@@ -455,11 +477,36 @@ xfs_btree_del_cursor(
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
@@ -497,10 +544,11 @@ xfs_btree_dup_cursor(
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
@@ -941,6 +989,9 @@ xfs_btree_readahead_lblock(
 	xfs_fsblock_t		left = be64_to_cpu(block->bb_u.l.bb_leftsib);
 	xfs_fsblock_t		right = be64_to_cpu(block->bb_u.l.bb_rightsib);
 
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return 0;
+
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLFSBLOCK) {
 		xfs_btree_reada_bufl(cur->bc_mp, left, 1,
 				     cur->bc_ops->buf_ops);
@@ -966,6 +1017,8 @@ xfs_btree_readahead_sblock(
 	xfs_agblock_t		left = be32_to_cpu(block->bb_u.s.bb_leftsib);
 	xfs_agblock_t		right = be32_to_cpu(block->bb_u.s.bb_rightsib);
 
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
+		return 0;
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
 		xfs_btree_reada_bufs(cur->bc_mp, cur->bc_ag.pag->pag_agno,
@@ -1027,6 +1080,11 @@ xfs_btree_ptr_to_daddr(
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
@@ -1055,8 +1113,9 @@ xfs_btree_readahead_ptr(
 
 	if (xfs_btree_ptr_to_daddr(cur, ptr, &daddr))
 		return;
-	xfs_buf_readahead(cur->bc_mp->m_ddev_targp, daddr,
-			  cur->bc_mp->m_bsize * count, cur->bc_ops->buf_ops);
+	xfs_buf_readahead(xfs_btree_buftarg(cur), daddr,
+			xfs_btree_bbsize(cur) * count,
+			cur->bc_ops->buf_ops);
 }
 
 /*
@@ -1230,7 +1289,9 @@ xfs_btree_init_block_cur(
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
@@ -1270,6 +1331,11 @@ xfs_btree_buf_to_ptr(
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
@@ -1314,15 +1380,14 @@ xfs_btree_get_buf_block(
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
 
@@ -1353,9 +1418,9 @@ xfs_btree_read_buf_block(
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
@@ -1795,6 +1860,37 @@ xfs_btree_decrement(
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
@@ -1833,11 +1929,7 @@ xfs_btree_lookup_get_block(
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
@@ -4383,7 +4475,7 @@ xfs_btree_visit_block(
 {
 	struct xfs_btree_block		*block;
 	struct xfs_buf			*bp;
-	union xfs_btree_ptr		rptr;
+	union xfs_btree_ptr		rptr, bufptr;
 	int				error;
 
 	/* do right sibling readahead */
@@ -4406,15 +4498,14 @@ xfs_btree_visit_block(
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
@@ -4596,6 +4687,8 @@ xfs_btree_lblock_verify(
 	xfs_fsblock_t		fsb;
 	xfs_failaddr_t		fa;
 
+	ASSERT(!(bp->b_target->bt_flags & XFS_BUFTARG_XFILE));
+
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
@@ -4651,6 +4744,8 @@ xfs_btree_sblock_verify(
 	xfs_agblock_t		agbno;
 	xfs_failaddr_t		fa;
 
+	ASSERT(!(bp->b_target->bt_flags & XFS_BUFTARG_XFILE));
+
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index d906324e25c..3e6bdbc5070 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
 
diff --git a/libxfs/xfs_btree_mem.h b/libxfs/xfs_btree_mem.h
new file mode 100644
index 00000000000..2c42ca85c58
--- /dev/null
+++ b/libxfs/xfs_btree_mem.h
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

