Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137DD391
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oye8bE3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B6BC433C7;
	Mon,  1 Jan 2024 00:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067909;
	bh=bl0HxWid64EHvtpfVbZNhBXxoVpMN8OF/HOa+lUcPrc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oye8bE3obYDmyTDsSBO7vfo5bOjivByYmMsBQjCCLv0sQ/xiwfijmzKIjMCHz+N15
	 c2Y5X0dBAO09i45/h2XKq0qlTjU6eMPnrszbIMKNkRYtzEs/FhlRpuBBRuptXtHdUB
	 wrRBn48AtZjjoIkCSxcSr7wkhHAHN96p8uEXvNZuLrvJ5aK7iRVYBM5oeoAGGTAlD7
	 kq/hpBBenn2wKydlaMYfzIBJAeSG4U1gCK7FXHgNRgJWIpMvh0jIQRuriScFsMJOTG
	 vgE/qKF9osCjOQJi211G/j35/ailL62T69FPM3ymRpelKz8nahacyB3QRApdPbkesb
	 DI9Lz3GlR8v5w==
Date: Sun, 31 Dec 2023 16:11:49 +9900
Subject: [PATCH 05/47] xfs: add realtime rmap btree operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015379.1815505.1137986212779447923.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Implement the generic btree operations needed to manipulate rtrmap
btree blocks. This is different from the regular rmapbt in that we
allocate space from the filesystem at large, and are neither
constrained to the free space nor any particular AG.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c        |   70 ++++++++++++
 libxfs/xfs_btree.h        |    5 +
 libxfs/xfs_rtrmap_btree.c |  271 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 346 insertions(+)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index ea0d5d71d03..f599dd17d30 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -30,6 +30,9 @@
 #include "xfs_btree_mem.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_rmap.h"
+#include "xfs_imeta.h"
 
 /*
  * Btree magic numbers.
@@ -5576,3 +5579,70 @@ xfs_btree_goto_left_edge(
 
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
+		.tp			= cur->bc_tp,
+		.resv			= XFS_AG_RESV_IMETA,
+		.minlen			= 1,
+		.maxlen			= 1,
+		.prod			= 1,
+	};
+	struct xfs_inode		*ip = cur->bc_ino.ip;
+	int				error;
+
+	ASSERT(xfs_is_metadir_inode(ip));
+	ASSERT(XFS_IS_DQDETACHED(cur->bc_mp, ip));
+
+	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, cur->bc_ino.whichfork);
+	error = xfs_alloc_vextent_start_ag(&args,
+			XFS_INO_TO_FSB(cur->bc_mp, ip->i_ino));
+	if (error)
+		return error;
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
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+	int			error;
+
+	ASSERT(xfs_is_metadir_inode(ip));
+	ASSERT(XFS_IS_DQDETACHED(cur->bc_mp, ip));
+
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
+	error = xfs_free_extent_later(tp, fsbno, 1, &oinfo, XFS_AG_RESV_IMETA,
+			0);
+	if (error)
+		return error;
+
+	xfs_imeta_resv_free_extent(ip, tp, 1);
+	return 0;
+}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index e6571c9157d..3559cf5d3a6 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -764,4 +764,9 @@ void xfs_btree_destroy_cur_caches(void);
 
 int xfs_btree_goto_left_edge(struct xfs_btree_cur *cur);
 
+int xfs_btree_alloc_imeta_block(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *start, union xfs_btree_ptr *newp,
+		int *stat);
+int xfs_btree_free_imeta_block(struct xfs_btree_cur *cur, struct xfs_buf *bp);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 1b6375af818..a2cb497379f 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -18,10 +18,12 @@
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
+#include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_rtgroup.h"
+#include "xfs_bmap.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -50,6 +52,182 @@ xfs_rtrmapbt_dup_cursor(
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
@@ -116,6 +294,86 @@ const struct xfs_buf_ops xfs_rtrmapbt_buf_ops = {
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
@@ -125,7 +383,20 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
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

