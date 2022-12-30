Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF369C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbiLaBih (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbiLaBi2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:38:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81C513DD9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:38:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6969FB81DD1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1127CC433D2;
        Sat, 31 Dec 2022 01:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450704;
        bh=VtDAbW7ZXm4yKWf0iQYeGSFXT7TmULNofpFUey594pM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nsni2XjSKSdo4Aunnz0VQ5fv9L6i4pzL4963Xk4XOE20yNpZdSEP4OxvWqYoSb+xR
         56fkFXJIKoQF4ifbAYoqKrmm0GOihPJoLzwMxi9GUoQ6s7A/vfKwH5rO6yGj7uBWrK
         ot0scXWX+6gT7w3nLxtfWH6gTaIrHUxDBjqgTPz0rtLoc07cqzpF8OZFEhnuol6fYW
         hecMSH03mjrSRFQD6WoGGdRnMgyZmkEl6SofJyZHnqXtPNxzaib/5vk9L5lpssYx1h
         e+jRaMc63OOzFA/h4ctlZGFPWa/y1srUNUXsozNfc5wWtry5DD0RAeqqk1zdKL7BwZ
         9gbWer/d1R6IA==
Subject: [PATCH 06/38] xfs: add realtime rmap btree operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:16 -0800
Message-ID: <167243869686.715303.6967085140781527270.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Implement the generic btree operations needed to manipulate rtrmap
btree blocks. This is different from the regular rmapbt in that we
allocate space from the filesystem at large, and are neither
constrained to the free space nor any particular AG.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c        |  113 ++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h        |    5 +
 fs/xfs/libxfs/xfs_imeta.c        |    6 +
 fs/xfs/libxfs/xfs_rtrmap_btree.c |  271 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 395 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4f1f03b207d3..fe742567a7dd 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -33,6 +33,10 @@
 #include "xfs_btree_mem.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_rmap.h"
+#include "xfs_quota.h"
+#include "xfs_imeta.h"
 
 /*
  * Btree magic numbers.
@@ -5589,3 +5593,112 @@ xfs_btree_goto_left_edge(
 
 	return 0;
 }
+
+/* Allocate a block for an inode-rooted metadata btree. */
+int
+xfs_btree_alloc_imeta_block(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*start,
+	union xfs_btree_ptr		*new,
+	int				*stat)
+{
+	struct xfs_alloc_arg		args = {
+		.mp			= cur->bc_mp,
+		.tp			= cur->bc_tp
+	};
+	struct xfs_inode		*ip = cur->bc_ino.ip;
+	struct xfs_trans		*tp = cur->bc_tp;
+	int				error;
+
+	ASSERT(!XFS_NOT_DQATTACHED(cur->bc_mp, ip));
+
+	args.fsbno = tp->t_firstblock;
+	args.resv = XFS_AG_RESV_IMETA;
+	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, cur->bc_ino.whichfork);
+
+	if (args.fsbno == NULLFSBLOCK) {
+		args.fsbno = be64_to_cpu(start->l);
+		args.type = XFS_ALLOCTYPE_START_BNO;
+		/*
+		 * Make sure there is sufficient room left in the AG to
+		 * complete a full tree split for an extent insert.  If
+		 * we are converting the middle part of an extent then
+		 * we may need space for two tree splits.
+		 *
+		 * We are relying on the caller to make the correct block
+		 * reservation for this operation to succeed.  If the
+		 * reservation amount is insufficient then we may fail a
+		 * block allocation here and corrupt the filesystem.
+		 */
+		args.minleft = tp->t_blk_res;
+	} else if (tp->t_flags & XFS_TRANS_LOWMODE) {
+		args.type = XFS_ALLOCTYPE_START_BNO;
+	} else {
+		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	}
+
+	args.minlen = args.maxlen = args.prod = 1;
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto error0;
+
+	if (args.fsbno == NULLFSBLOCK && args.minleft) {
+		/*
+		 * Could not find an AG with enough free space to satisfy
+		 * a full btree split.  Try again without minleft and if
+		 * successful activate the lowspace algorithm.
+		 */
+		args.fsbno = 0;
+		args.type = XFS_ALLOCTYPE_FIRST_AG;
+		args.minleft = 0;
+		error = xfs_alloc_vextent(&args);
+		if (error)
+			goto error0;
+		tp->t_flags |= XFS_TRANS_LOWMODE;
+	}
+	if (args.fsbno == NULLFSBLOCK) {
+		*stat = 0;
+		return 0;
+	}
+	ASSERT(args.len == 1);
+
+	xfs_imeta_resv_alloc_extent(ip, &args);
+	cur->bc_ino.allocated++;
+
+	new->l = cpu_to_be64(args.fsbno);
+	*stat = 1;
+	return 0;
+
+ error0:
+	return error;
+}
+
+/* Free a block from an inode-rooted metadata btree. */
+int
+xfs_btree_free_imeta_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	struct xfs_owner_info	oinfo;
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_inode	*ip = cur->bc_ino.ip;
+	struct xfs_trans	*tp = cur->bc_tp;
+	struct xfs_perag	*pag;
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	int			error;
+
+	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
+	pag = xfs_perag_get(mp, agno);
+	error = __xfs_free_extent(tp, pag, agbno, 1, &oinfo, XFS_AG_RESV_IMETA,
+			false);
+	xfs_perag_put(pag);
+	if (error)
+		return error;
+
+	xfs_imeta_resv_free_extent(ip, tp, 1);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index ddaad83d4ff9..5a733767649b 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -761,4 +761,9 @@ void xfs_btree_destroy_cur_caches(void);
 
 int xfs_btree_goto_left_edge(struct xfs_btree_cur *cur);
 
+int xfs_btree_alloc_imeta_block(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *start, union xfs_btree_ptr *newp,
+		int *stat);
+int xfs_btree_free_imeta_block(struct xfs_btree_cur *cur, struct xfs_buf *bp);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 5bfb1eabf21d..1065144911b3 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -1303,6 +1303,9 @@ xfs_imeta_resv_alloc_extent(
 		xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_FDBLOCKS, -len);
 
 	ip->i_nblocks += args->len;
+	xfs_trans_mod_dquot_byino(args->tp, ip, XFS_TRANS_DQ_BCOUNT, args->len);
+
+	xfs_trans_log_inode(args->tp, ip, XFS_ILOG_CORE);
 }
 
 /* Free a block to the metadata file's reservation. */
@@ -1318,6 +1321,7 @@ xfs_imeta_resv_free_extent(
 	trace_xfs_imeta_resv_free_extent(ip, len);
 
 	ip->i_nblocks -= len;
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -len);
 
 	/*
 	 * Add the freed blocks back into the inode's delalloc reservation
@@ -1338,6 +1342,8 @@ xfs_imeta_resv_free_extent(
 	 */
 	if (len)
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, len);
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
 /* Release a metadata file's space reservation. */
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 7f6ba2efdaf2..551d575713db 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -18,12 +18,14 @@
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
+#include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
 #include "xfs_rtgroup.h"
+#include "xfs_bmap.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -52,6 +54,182 @@ xfs_rtrmapbt_dup_cursor(
 	return new;
 }
 
+STATIC int
+xfs_rtrmapbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	if (level == cur->bc_nlevels - 1) {
+		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
+
+		return xfs_rtrmapbt_maxrecs(cur->bc_mp, ifp->if_broot_bytes,
+				level == 0) / 2;
+	}
+
+	return cur->bc_mp->m_rtrmap_mnr[level != 0];
+}
+
+STATIC int
+xfs_rtrmapbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	if (level == cur->bc_nlevels - 1) {
+		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
+
+		return xfs_rtrmapbt_maxrecs(cur->bc_mp, ifp->if_broot_bytes,
+				level == 0);
+	}
+
+	return cur->bc_mp->m_rtrmap_mxr[level != 0];
+}
+
+/*
+ * Convert the ondisk record's offset field into the ondisk key's offset field.
+ * Fork and bmbt are significant parts of the rmap record key, but written
+ * status is merely a record attribute.
+ */
+static inline __be64 ondisk_rec_offset_to_key(const union xfs_btree_rec *rec)
+{
+	return rec->rmap.rm_offset & ~cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN);
+}
+
+STATIC void
+xfs_rtrmapbt_init_key_from_rec(
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
+{
+	key->rmap.rm_startblock = rec->rmap.rm_startblock;
+	key->rmap.rm_owner = rec->rmap.rm_owner;
+	key->rmap.rm_offset = ondisk_rec_offset_to_key(rec);
+}
+
+STATIC void
+xfs_rtrmapbt_init_high_key_from_rec(
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
+{
+	uint64_t			off;
+	int				adj;
+
+	adj = be32_to_cpu(rec->rmap.rm_blockcount) - 1;
+
+	key->rmap.rm_startblock = rec->rmap.rm_startblock;
+	be32_add_cpu(&key->rmap.rm_startblock, adj);
+	key->rmap.rm_owner = rec->rmap.rm_owner;
+	key->rmap.rm_offset = ondisk_rec_offset_to_key(rec);
+	if (XFS_RMAP_NON_INODE_OWNER(be64_to_cpu(rec->rmap.rm_owner)) ||
+	    XFS_RMAP_IS_BMBT_BLOCK(be64_to_cpu(rec->rmap.rm_offset)))
+		return;
+	off = be64_to_cpu(key->rmap.rm_offset);
+	off = (XFS_RMAP_OFF(off) + adj) | (off & ~XFS_RMAP_OFF_MASK);
+	key->rmap.rm_offset = cpu_to_be64(off);
+}
+
+STATIC void
+xfs_rtrmapbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	rec->rmap.rm_startblock = cpu_to_be32(cur->bc_rec.r.rm_startblock);
+	rec->rmap.rm_blockcount = cpu_to_be32(cur->bc_rec.r.rm_blockcount);
+	rec->rmap.rm_owner = cpu_to_be64(cur->bc_rec.r.rm_owner);
+	rec->rmap.rm_offset = cpu_to_be64(
+			xfs_rmap_irec_offset_pack(&cur->bc_rec.r));
+}
+
+STATIC void
+xfs_rtrmapbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	ptr->l = 0;
+}
+
+/*
+ * Mask the appropriate parts of the ondisk key field for a key comparison.
+ * Fork and bmbt are significant parts of the rmap record key, but written
+ * status is merely a record attribute.
+ */
+static inline uint64_t offset_keymask(uint64_t offset)
+{
+	return offset & ~XFS_RMAP_OFF_UNWRITTEN;
+}
+
+STATIC int64_t
+xfs_rtrmapbt_key_diff(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
+{
+	struct xfs_rmap_irec		*rec = &cur->bc_rec.r;
+	const struct xfs_rmap_key	*kp = &key->rmap;
+	__u64				x, y;
+	int64_t				d;
+
+	d = (int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
+	if (d)
+		return d;
+
+	x = be64_to_cpu(kp->rm_owner);
+	y = rec->rm_owner;
+	if (x > y)
+		return 1;
+	else if (y > x)
+		return -1;
+
+	x = offset_keymask(be64_to_cpu(kp->rm_offset));
+	y = offset_keymask(xfs_rmap_irec_offset_pack(rec));
+	if (x > y)
+		return 1;
+	else if (y > x)
+		return -1;
+	return 0;
+}
+
+STATIC int64_t
+xfs_rtrmapbt_diff_two_keys(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2,
+	const union xfs_btree_key	*mask)
+{
+	const struct xfs_rmap_key	*kp1 = &k1->rmap;
+	const struct xfs_rmap_key	*kp2 = &k2->rmap;
+	int64_t				d;
+	__u64				x, y;
+
+	/* Doesn't make sense to mask off the physical space part */
+	ASSERT(!mask || mask->rmap.rm_startblock);
+
+	d = (int64_t)be32_to_cpu(kp1->rm_startblock) -
+		     be32_to_cpu(kp2->rm_startblock);
+	if (d)
+		return d;
+
+	if (!mask || mask->rmap.rm_owner) {
+		x = be64_to_cpu(kp1->rm_owner);
+		y = be64_to_cpu(kp2->rm_owner);
+		if (x > y)
+			return 1;
+		else if (y > x)
+			return -1;
+	}
+
+	if (!mask || mask->rmap.rm_offset) {
+		/* Doesn't make sense to allow offset but not owner */
+		ASSERT(!mask || mask->rmap.rm_owner);
+
+		x = offset_keymask(be64_to_cpu(kp1->rm_offset));
+		y = offset_keymask(be64_to_cpu(kp2->rm_offset));
+		if (x > y)
+			return 1;
+		else if (y > x)
+			return -1;
+	}
+
+	return 0;
+}
+
 static xfs_failaddr_t
 xfs_rtrmapbt_verify(
 	struct xfs_buf		*bp)
@@ -118,6 +296,86 @@ const struct xfs_buf_ops xfs_rtrmapbt_buf_ops = {
 	.verify_struct		= xfs_rtrmapbt_verify,
 };
 
+STATIC int
+xfs_rtrmapbt_keys_inorder(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
+{
+	uint32_t			x;
+	uint32_t			y;
+	uint64_t			a;
+	uint64_t			b;
+
+	x = be32_to_cpu(k1->rmap.rm_startblock);
+	y = be32_to_cpu(k2->rmap.rm_startblock);
+	if (x < y)
+		return 1;
+	else if (x > y)
+		return 0;
+	a = be64_to_cpu(k1->rmap.rm_owner);
+	b = be64_to_cpu(k2->rmap.rm_owner);
+	if (a < b)
+		return 1;
+	else if (a > b)
+		return 0;
+	a = offset_keymask(be64_to_cpu(k1->rmap.rm_offset));
+	b = offset_keymask(be64_to_cpu(k2->rmap.rm_offset));
+	if (a <= b)
+		return 1;
+	return 0;
+}
+
+STATIC int
+xfs_rtrmapbt_recs_inorder(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*r1,
+	const union xfs_btree_rec	*r2)
+{
+	uint32_t			x;
+	uint32_t			y;
+	uint64_t			a;
+	uint64_t			b;
+
+	x = be32_to_cpu(r1->rmap.rm_startblock);
+	y = be32_to_cpu(r2->rmap.rm_startblock);
+	if (x < y)
+		return 1;
+	else if (x > y)
+		return 0;
+	a = be64_to_cpu(r1->rmap.rm_owner);
+	b = be64_to_cpu(r2->rmap.rm_owner);
+	if (a < b)
+		return 1;
+	else if (a > b)
+		return 0;
+	a = offset_keymask(be64_to_cpu(r1->rmap.rm_offset));
+	b = offset_keymask(be64_to_cpu(r2->rmap.rm_offset));
+	if (a <= b)
+		return 1;
+	return 0;
+}
+
+STATIC enum xbtree_key_contig
+xfs_rtrmapbt_keys_contiguous(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
+{
+	ASSERT(!mask || mask->rmap.rm_startblock);
+
+	/*
+	 * We only support checking contiguity of the physical space component.
+	 * If any callers ever need more specificity than that, they'll have to
+	 * implement it here.
+	 */
+	ASSERT(!mask || (!mask->rmap.rm_owner && !mask->rmap.rm_offset));
+
+	return xbtree_key_contig(be32_to_cpu(key1->rmap.rm_startblock),
+				 be32_to_cpu(key2->rmap.rm_startblock));
+}
+
 const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
@@ -126,7 +384,20 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 				  XFS_BTREE_IROOT_RECORDS,
 
 	.dup_cursor		= xfs_rtrmapbt_dup_cursor,
+	.alloc_block		= xfs_btree_alloc_imeta_block,
+	.free_block		= xfs_btree_free_imeta_block,
+	.get_minrecs		= xfs_rtrmapbt_get_minrecs,
+	.get_maxrecs		= xfs_rtrmapbt_get_maxrecs,
+	.init_key_from_rec	= xfs_rtrmapbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rtrmapbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_rtrmapbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_rtrmapbt_init_ptr_from_cur,
+	.key_diff		= xfs_rtrmapbt_key_diff,
 	.buf_ops		= &xfs_rtrmapbt_buf_ops,
+	.diff_two_keys		= xfs_rtrmapbt_diff_two_keys,
+	.keys_inorder		= xfs_rtrmapbt_keys_inorder,
+	.recs_inorder		= xfs_rtrmapbt_recs_inorder,
+	.keys_contiguous	= xfs_rtrmapbt_keys_contiguous,
 };
 
 /* Initialize a new rt rmap btree cursor. */

