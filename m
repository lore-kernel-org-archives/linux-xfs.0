Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BCF12FB2C
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 20:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817616; cv=none; b=rkd75sM331MnVKzC+JISjLXhhzfYTX3MOiWwcPh9DHTe3gTesgbqiFFji5R9AQqgQMHcd91WaCckJgyT+HDFfASgdrIYe5NdqhucEh8oeNVBXpLqhR/5ArkR4GBUCZUhxgP0nmevhRSuzcEFyARvQAWkxM1/h/agZsUY3aeoayo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817616; c=relaxed/simple;
	bh=fCy7EF/AfeLDlJJ5SEbjlcekw8kvVVIcK3e31Z2RvkE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fMBcvudYiNeTPrITTMtnIrS59lfjwXxhCwh4YaD6OzfUbCAtjmCEhqDYEKb7vGr7KeDov4ikpnPtWX74r3j4/koRFUZUAGDRJ+J5/gssurNGx6kRWdzQUoXN2dDPahFnbJlSCEJOg4xpDmFFufh50delmizNj3+8+6Ge2/fkNCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iXb2RKLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXb2RKLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAF7C433F1;
	Thu,  1 Feb 2024 20:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817615;
	bh=fCy7EF/AfeLDlJJ5SEbjlcekw8kvVVIcK3e31Z2RvkE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iXb2RKLCZZvJif21F60youE7cq5iAs7pUuqRnVYmUOD5JQ9azgYbuqDebTiXWTiPb
	 Y4MyCbQQfou1lxkrSc++zVaTWJLZFjaGmYV0U34Ae134a5AuttxTbsnTAAIqLpcPkF
	 yvKOEQOUX5lVCbY6i4O/4jdX+xU51coM8ttndJb05X2pQ5gRLQd8rB3C9YjuGcU/Bi
	 r7q9cP2CT4P2XbfSt06dO5Plx6qVgbFSt/lqbe57elf5p3gmpOG0CXLVjkSV1Qh4Hr
	 DKNhu08SGAYzXeYlpPDBRRP1E5BWiYhEaqGN0qKM1i9GVOFwLXcZfEtZXoaaouU7Qc
	 Ycgw3oFAoEi6g==
Date: Thu, 01 Feb 2024 12:00:15 -0800
Subject: [PATCH 1/3] xfs: define an in-memory btree for storing refcount bag
 info during repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681337888.1608752.10921448345076669658.stgit@frogsfrogsfrogs>
In-Reply-To: <170681337865.1608752.14424093781022631293.stgit@frogsfrogsfrogs>
References: <170681337865.1608752.14424093781022631293.stgit@frogsfrogsfrogs>
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

Create a new in-memory btree type so that we can store refcount bag info
in a much more memory-efficient and performant format.  Recall that the
refcount recordset regenerator computes the new recordset from browsing
the rmap records.  Let's say that the rmap records are:

{agbno: 10, length: 40...}
{agbno: 11, length: 3...}
{agbno: 12, length: 20...}
{agbno: 15, length: 1...}

It is convenient to have a data structure that could quickly tell us the
refcount for an arbitrary agbno without wasting memory.  An array or a
list could do that pretty easily.  List suck because of the pointer
overhead.  xfarrays are a lot more compact, but we want to minimize
sparse holes in the xfarray to constrain memory usage.  Maintaining any
kind of record order isn't needed for correctness, so I created the
"rcbag", which is shorthand for an unordered list of (excerpted) reverse
mappings.

So we add the first rmap to the rcbag, and it looks like:

0: {agbno: 10, length: 40}

The refcount for agbno 10 is 1.  Then we move on to block 11, so we add
the second rmap:

0: {agbno: 10, length: 40}
1: {agbno: 11, length: 3}

The refcount for agbno 11 is 2.  We move on to block 12, so we add the
third:

0: {agbno: 10, length: 40}
1: {agbno: 11, length: 3}
2: {agbno: 12, length: 20}

The refcount for agbno 12 and 13 is 3.  We move on to block 14, and
remove the second rmap:

0: {agbno: 10, length: 40}
1: NULL
2: {agbno: 12, length: 20}

The refcount for agbno 14 is 2.  We move on to block 15, and add the
last rmap.  But we don't care where it is and we don't want to expand
the array so we put it in slot 1:

0: {agbno: 10, length: 40}
1: {agbno: 15, length: 1}
2: {agbno: 12, length: 20}

The refcount for block 15 is 3.  Notice how order doesn't matter in this
list?  That's why repair uses an unordered list, or "bag".

That said, adding and removing specific items is now an O(n) operation
because we have no idea where that item might be in the list.  Overall,
the runtime is O(n^2) which is bad.

I realized that I could easily refactor the btree code and reimplement
the refcount bag with an xfbtree.  Adding and removing is now O(log2 n),
so the runtime is at least O(n log2 n), which is much faster.  In the
end, the rcbag becomes a sorted list, but that's merely a detail of the
implementation.  The repair code doesn't care.

(Note: That horrible xfs_db bmap_inflate command can be used to exercise
this sort of rcbag insanity by cranking up refcounts quickly.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/scrub/rcbag_btree.c |  312 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rcbag_btree.h |   74 ++++++++++
 fs/xfs/xfs_stats.c         |    3 
 fs/xfs/xfs_stats.h         |    1 
 5 files changed, 390 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/rcbag_btree.c
 create mode 100644 fs/xfs/scrub/rcbag_btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 8aae7f5565927..b9066cf851c3a 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -199,6 +199,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   inode_repair.o \
 				   newbt.o \
 				   nlinks_repair.o \
+				   rcbag_btree.o \
 				   reap.o \
 				   refcount_repair.o \
 				   repair.o \
diff --git a/fs/xfs/scrub/rcbag_btree.c b/fs/xfs/scrub/rcbag_btree.c
new file mode 100644
index 0000000000000..762960e012a05
--- /dev/null
+++ b/fs/xfs/scrub/rcbag_btree.c
@@ -0,0 +1,312 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_buf_mem.h"
+#include "xfs_btree_mem.h"
+#include "xfs_error.h"
+#include "scrub/rcbag_btree.h"
+#include "scrub/trace.h"
+
+static struct kmem_cache	*rcbagbt_cur_cache;
+
+STATIC void
+rcbagbt_init_key_from_rec(
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
+{
+	struct rcbag_key	*bag_key = (struct rcbag_key *)key;
+	const struct rcbag_rec	*bag_rec = (const struct rcbag_rec *)rec;
+
+	BUILD_BUG_ON(sizeof(struct rcbag_key) > sizeof(union xfs_btree_key));
+	BUILD_BUG_ON(sizeof(struct rcbag_rec) > sizeof(union xfs_btree_rec));
+
+	bag_key->rbg_startblock = bag_rec->rbg_startblock;
+	bag_key->rbg_blockcount = bag_rec->rbg_blockcount;
+}
+
+STATIC void
+rcbagbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	struct rcbag_rec	*bag_rec = (struct rcbag_rec *)rec;
+	struct rcbag_rec	*bag_irec = (struct rcbag_rec *)&cur->bc_rec;
+
+	bag_rec->rbg_startblock = bag_irec->rbg_startblock;
+	bag_rec->rbg_blockcount = bag_irec->rbg_blockcount;
+	bag_rec->rbg_refcount = bag_irec->rbg_refcount;
+}
+
+STATIC int64_t
+rcbagbt_key_diff(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
+{
+	struct rcbag_rec		*rec = (struct rcbag_rec *)&cur->bc_rec;
+	const struct rcbag_key		*kp = (const struct rcbag_key *)key;
+
+	if (kp->rbg_startblock > rec->rbg_startblock)
+		return 1;
+	if (kp->rbg_startblock < rec->rbg_startblock)
+		return -1;
+
+	if (kp->rbg_blockcount > rec->rbg_blockcount)
+		return 1;
+	if (kp->rbg_blockcount < rec->rbg_blockcount)
+		return -1;
+
+	return 0;
+}
+
+STATIC int64_t
+rcbagbt_diff_two_keys(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2,
+	const union xfs_btree_key	*mask)
+{
+	const struct rcbag_key		*kp1 = (const struct rcbag_key *)k1;
+	const struct rcbag_key		*kp2 = (const struct rcbag_key *)k2;
+
+	ASSERT(mask == NULL);
+
+	if (kp1->rbg_startblock > kp2->rbg_startblock)
+		return 1;
+	if (kp1->rbg_startblock < kp2->rbg_startblock)
+		return -1;
+
+	if (kp1->rbg_blockcount > kp2->rbg_blockcount)
+		return 1;
+	if (kp1->rbg_blockcount < kp2->rbg_blockcount)
+		return -1;
+
+	return 0;
+}
+
+STATIC int
+rcbagbt_keys_inorder(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
+{
+	const struct rcbag_key		*kp1 = (const struct rcbag_key *)k1;
+	const struct rcbag_key		*kp2 = (const struct rcbag_key *)k2;
+
+	if (kp1->rbg_startblock > kp2->rbg_startblock)
+		return 0;
+	if (kp1->rbg_startblock < kp2->rbg_startblock)
+		return 1;
+
+	if (kp1->rbg_blockcount > kp2->rbg_blockcount)
+		return 0;
+	if (kp1->rbg_blockcount < kp2->rbg_blockcount)
+		return 1;
+
+	return 0;
+}
+
+STATIC int
+rcbagbt_recs_inorder(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*r1,
+	const union xfs_btree_rec	*r2)
+{
+	const struct rcbag_rec		*rp1 = (const struct rcbag_rec *)r1;
+	const struct rcbag_rec		*rp2 = (const struct rcbag_rec *)r2;
+
+	if (rp1->rbg_startblock > rp2->rbg_startblock)
+		return 0;
+	if (rp1->rbg_startblock < rp2->rbg_startblock)
+		return 1;
+
+	if (rp1->rbg_blockcount > rp2->rbg_blockcount)
+		return 0;
+	if (rp1->rbg_blockcount < rp2->rbg_blockcount)
+		return 1;
+
+	return 0;
+}
+
+static xfs_failaddr_t
+rcbagbt_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
+	unsigned int		level;
+	unsigned int		maxrecs;
+
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	fa = xfs_btree_fsblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (fa)
+		return fa;
+
+	level = be16_to_cpu(block->bb_level);
+	if (level >= rcbagbt_maxlevels_possible())
+		return __this_address;
+
+	maxrecs = rcbagbt_maxrecs(mp, XFBNO_BLOCKSIZE, level == 0);
+	return xfs_btree_memblock_verify(bp, maxrecs);
+}
+
+static void
+rcbagbt_rw_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa = rcbagbt_verify(bp);
+
+	if (fa)
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+}
+
+/* skip crc checks on in-memory btrees to save time */
+static const struct xfs_buf_ops rcbagbt_mem_buf_ops = {
+	.name			= "rcbagbt_mem",
+	.magic			= { 0, cpu_to_be32(RCBAG_MAGIC) },
+	.verify_read		= rcbagbt_rw_verify,
+	.verify_write		= rcbagbt_rw_verify,
+	.verify_struct		= rcbagbt_verify,
+};
+
+static const struct xfs_btree_ops rcbagbt_mem_ops = {
+	.name			= "rcbag",
+	.type			= XFS_BTREE_TYPE_MEM,
+
+	.rec_len		= sizeof(struct rcbag_rec),
+	.key_len		= sizeof(struct rcbag_key),
+	.ptr_len		= XFS_BTREE_LONG_PTR_LEN,
+
+	.lru_refs		= 1,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_rcbag_2),
+
+	.dup_cursor		= xfbtree_dup_cursor,
+	.set_root		= xfbtree_set_root,
+	.alloc_block		= xfbtree_alloc_block,
+	.free_block		= xfbtree_free_block,
+	.get_minrecs		= xfbtree_get_minrecs,
+	.get_maxrecs		= xfbtree_get_maxrecs,
+	.init_key_from_rec	= rcbagbt_init_key_from_rec,
+	.init_rec_from_cur	= rcbagbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
+	.key_diff		= rcbagbt_key_diff,
+	.buf_ops		= &rcbagbt_mem_buf_ops,
+	.diff_two_keys		= rcbagbt_diff_two_keys,
+	.keys_inorder		= rcbagbt_keys_inorder,
+	.recs_inorder		= rcbagbt_recs_inorder,
+};
+
+/* Create a cursor for an in-memory btree. */
+struct xfs_btree_cur *
+rcbagbt_mem_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfbtree		*xfbtree)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_btree_alloc_cursor(mp, tp, &rcbagbt_mem_ops,
+			rcbagbt_maxlevels_possible(), rcbagbt_cur_cache);
+
+	cur->bc_mem.xfbtree = xfbtree;
+	cur->bc_nlevels = xfbtree->nlevels;
+	return cur;
+}
+
+/* Create an in-memory refcount bag btree. */
+int
+rcbagbt_mem_init(
+	struct xfs_mount	*mp,
+	struct xfbtree		*xfbt,
+	struct xfs_buftarg	*btp)
+{
+	xfbt->owner = 0;
+	return xfbtree_init(mp, xfbt, btp, &rcbagbt_mem_ops);
+}
+
+/* Calculate number of records in a refcount bag btree block. */
+static inline unsigned int
+rcbagbt_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	if (leaf)
+		return blocklen / sizeof(struct rcbag_rec);
+	return blocklen /
+		(sizeof(struct rcbag_key) + sizeof(rcbag_ptr_t));
+}
+
+/*
+ * Calculate number of records in an refcount bag btree block.
+ */
+unsigned int
+rcbagbt_maxrecs(
+	struct xfs_mount	*mp,
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	blocklen -= RCBAG_BLOCK_LEN;
+	return rcbagbt_block_maxrecs(blocklen, leaf);
+}
+
+/* Compute the max possible height for refcount bag btrees. */
+unsigned int
+rcbagbt_maxlevels_possible(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFBNO_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+
+	minrecs[0] = rcbagbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = rcbagbt_block_maxrecs(blocklen, false) / 2;
+
+	return xfs_btree_space_to_height(minrecs, ULLONG_MAX);
+}
+
+/* Calculate the refcount bag btree size for some records. */
+unsigned long long
+rcbagbt_calc_size(
+	unsigned long long	nr_records)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFBNO_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+
+	minrecs[0] = rcbagbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = rcbagbt_block_maxrecs(blocklen, false) / 2;
+
+	return xfs_btree_calc_size(minrecs, nr_records);
+}
+
+int __init
+rcbagbt_init_cur_cache(void)
+{
+	rcbagbt_cur_cache = kmem_cache_create("xfs_rcbagbt_cur",
+			xfs_btree_cur_sizeof(rcbagbt_maxlevels_possible()),
+			0, 0, NULL);
+
+	if (!rcbagbt_cur_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void
+rcbagbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(rcbagbt_cur_cache);
+	rcbagbt_cur_cache = NULL;
+}
diff --git a/fs/xfs/scrub/rcbag_btree.h b/fs/xfs/scrub/rcbag_btree.h
new file mode 100644
index 0000000000000..9202f7199b686
--- /dev/null
+++ b/fs/xfs/scrub/rcbag_btree.h
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_RCBAG_BTREE_H__
+#define __XFS_SCRUB_RCBAG_BTREE_H__
+
+#ifdef CONFIG_XFS_BTREE_IN_MEM
+
+struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+
+#define RCBAG_MAGIC	0x74826671	/* 'JRBG' */
+
+struct rcbag_key {
+	uint32_t	rbg_startblock;
+	uint32_t	rbg_blockcount;
+};
+
+struct rcbag_rec {
+	uint32_t	rbg_startblock;
+	uint32_t	rbg_blockcount;
+	uint64_t	rbg_refcount;
+};
+
+typedef __be64 rcbag_ptr_t;
+
+/* reflinks only exist on crc enabled filesystems */
+#define RCBAG_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
+
+/*
+ * Record, key, and pointer address macros for btree blocks.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+#define RCBAG_REC_ADDR(block, index) \
+	((struct rcbag_rec *) \
+		((char *)(block) + RCBAG_BLOCK_LEN + \
+		 (((index) - 1) * sizeof(struct rcbag_rec))))
+
+#define RCBAG_KEY_ADDR(block, index) \
+	((struct rcbag_key *) \
+		((char *)(block) + RCBAG_BLOCK_LEN + \
+		 ((index) - 1) * sizeof(struct rcbag_key)))
+
+#define RCBAG_PTR_ADDR(block, index, maxrecs) \
+	((rcbag_ptr_t *) \
+		((char *)(block) + RCBAG_BLOCK_LEN + \
+		 (maxrecs) * sizeof(struct rcbag_key) + \
+		 ((index) - 1) * sizeof(rcbag_ptr_t)))
+
+unsigned int rcbagbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
+
+unsigned long long rcbagbt_calc_size(unsigned long long nr_records);
+
+unsigned int rcbagbt_maxlevels_possible(void);
+
+int __init rcbagbt_init_cur_cache(void);
+void rcbagbt_destroy_cur_cache(void);
+
+struct xfs_btree_cur *rcbagbt_mem_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xfbtree *xfbtree);
+int rcbagbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
+		struct xfs_buftarg *btp);
+
+#else
+# define rcbagbt_init_cur_cache()		0
+# define rcbagbt_destroy_cur_cache()		((void)0)
+#endif /* CONFIG_XFS_BTREE_IN_MEM */
+
+#endif /* __XFS_SCRUB_RCBAG_BTREE_H__ */
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 5c6773628d69d..ed97d72caa665 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -51,7 +51,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "fibt2",		xfsstats_offset(xs_rmap_2)	},
 		{ "rmapbt",		xfsstats_offset(xs_refcbt_2)	},
 		{ "refcntbt",		xfsstats_offset(xs_rmap_mem_2)	},
-		{ "rmapbt_mem",		xfsstats_offset(xs_qm_dqreclaims)},
+		{ "rmapbt_mem",		xfsstats_offset(xs_rcbag_2)	},
+		{ "rcbagbt",		xfsstats_offset(xs_qm_dqreclaims)},
 		/* we print both series of quota information together */
 		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
 	};
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 3b50419d8bb90..a61fb56ed2e66 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -126,6 +126,7 @@ struct __xfsstats {
 	uint32_t		xs_rmap_2[__XBTS_MAX];
 	uint32_t		xs_refcbt_2[__XBTS_MAX];
 	uint32_t		xs_rmap_mem_2[__XBTS_MAX];
+	uint32_t		xs_rcbag_2[__XBTS_MAX];
 	uint32_t		xs_qm_dqreclaims;
 	uint32_t		xs_qm_dqreclaim_misses;
 	uint32_t		xs_qm_dquot_dups;

