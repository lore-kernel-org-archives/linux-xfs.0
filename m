Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F0585626
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817585; cv=none; b=nnQg17ZpaAe7hLu91bbQCtUZQVCuaq0xFcThzO4Nhm0BWDj8cAeIJh2+cCj1D70PSgDqlLUaDuf529wqtpjObQFf5mb5trNRTbQuPB3oFsrO/jJRkLCi/NkxbRTkkfMkpWTALlhy13QVkD4oR/OW96kT0Ov8qDUCb57BUgmhzEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817585; c=relaxed/simple;
	bh=L8VTWBflfc9woQGR4awo3EIryt2mel0w+oXnMAofAko=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e3Ryo2QptFRQstPsSEre7fGnBPBQWGUMi4QGGUrbRJbOobTLHRlAe5wiejPNAHoMGj2hKeuCgj2wsGz0OLpXN0a7PkRjVwD+A6NIDHNstp2v70KoUR4Vc+Q/TlIiv7juquMnWYHLnutnWKua5dznUn9QMfq7FF9uBhM6bkQRiW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4bJoJ29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4bJoJ29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58302C433F1;
	Thu,  1 Feb 2024 19:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817584;
	bh=L8VTWBflfc9woQGR4awo3EIryt2mel0w+oXnMAofAko=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a4bJoJ291lLlH9OPUFCwDpwgXjbDpewNlgmK7wvBIgM+3UmjZF0WDBgx1CdLCK0GQ
	 yeQiyVcMWC/3KuZVwq966vjSqjEpup16wVOXS1M4lUn2+0Lr70p1uJUAVtlR/RYWOW
	 iOChr5xd72XU6DCnQyrRHCoo0RPV7HBQkFmrd4ppD9oGM+noFb+6QeJ9Rd5f8C4gPD
	 WOJiYWO/b7EcL/CdEt1Jpco710eghe+0RQ12SWpW6PWJsioLvyX+NdHmRauiv2U3Gn
	 ICIj1brDNP7wMA5yRcgVNHZHB8PQkFeQ9+xnL119tHw67T2Ja10Uj41l9t4j+onl37
	 tKIaMWWjxHnLg==
Date: Thu, 01 Feb 2024 11:59:43 -0800
Subject: [PATCH 4/5] xfs: create a shadow rmap btree during rmap repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681337491.1608576.3822702932308825535.stgit@frogsfrogsfrogs>
In-Reply-To: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
References: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
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

Create an in-memory btree of rmap records instead of an array.  This
enables us to do live record collection instead of freezing the fs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c       |   37 ++++--
 fs/xfs/libxfs/xfs_rmap_btree.c |  150 +++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_rmap_btree.h |    6 +
 fs/xfs/libxfs/xfs_shared.h     |   10 ++
 fs/xfs/scrub/repair.c          |   18 +++
 fs/xfs/scrub/repair.h          |    2 
 fs/xfs/scrub/rmap_repair.c     |  234 ++++++++++++++++++++++++++++------------
 fs/xfs/xfs_stats.c             |    3 -
 fs/xfs/xfs_stats.h             |    1 
 9 files changed, 377 insertions(+), 84 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 4e105207fc7ed..43000bf54982b 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -269,6 +269,16 @@ xfs_rmap_check_irec(
 	return NULL;
 }
 
+static inline xfs_failaddr_t
+xfs_rmap_check_btrec(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*irec)
+{
+	if (xfs_btree_is_mem_rmap(cur->bc_ops))
+		return xfs_rmap_check_irec(cur->bc_mem.pag, irec);
+	return xfs_rmap_check_irec(cur->bc_ag.pag, irec);
+}
+
 static inline int
 xfs_rmap_complain_bad_rec(
 	struct xfs_btree_cur		*cur,
@@ -277,9 +287,13 @@ xfs_rmap_complain_bad_rec(
 {
 	struct xfs_mount		*mp = cur->bc_mp;
 
-	xfs_warn(mp,
-		"Reverse Mapping BTree record corruption in AG %d detected at %pS!",
-		cur->bc_ag.pag->pag_agno, fa);
+	if (xfs_btree_is_mem_rmap(cur->bc_ops))
+		xfs_warn(mp,
+ "In-Memory Reverse Mapping BTree record corruption detected at %pS!", fa);
+	else
+		xfs_warn(mp,
+ "Reverse Mapping BTree record corruption in AG %d detected at %pS!",
+			cur->bc_ag.pag->pag_agno, fa);
 	xfs_warn(mp,
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
@@ -307,7 +321,7 @@ xfs_rmap_get_rec(
 
 	fa = xfs_rmap_btrec_to_irec(rec, irec);
 	if (!fa)
-		fa = xfs_rmap_check_irec(cur->bc_ag.pag, irec);
+		fa = xfs_rmap_check_btrec(cur, irec);
 	if (fa)
 		return xfs_rmap_complain_bad_rec(cur, fa, irec);
 
@@ -2404,15 +2418,12 @@ xfs_rmap_map_raw(
 {
 	struct xfs_owner_info	oinfo;
 
-	oinfo.oi_owner = rmap->rm_owner;
-	oinfo.oi_offset = rmap->rm_offset;
-	oinfo.oi_flags = 0;
-	if (rmap->rm_flags & XFS_RMAP_ATTR_FORK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
-	if (rmap->rm_flags & XFS_RMAP_BMBT_BLOCK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
+	xfs_owner_info_pack(&oinfo, rmap->rm_owner, rmap->rm_offset,
+			rmap->rm_flags);
 
-	if (rmap->rm_flags || XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
+	if ((rmap->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			       XFS_RMAP_UNWRITTEN)) ||
+	    XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
 		return xfs_rmap_map(cur, rmap->rm_startblock,
 				rmap->rm_blockcount,
 				rmap->rm_flags & XFS_RMAP_UNWRITTEN,
@@ -2442,7 +2453,7 @@ xfs_rmap_query_range_helper(
 
 	fa = xfs_rmap_btrec_to_irec(rec, &irec);
 	if (!fa)
-		fa = xfs_rmap_check_irec(cur->bc_ag.pag, &irec);
+		fa = xfs_rmap_check_btrec(cur, &irec);
 	if (fa)
 		return xfs_rmap_complain_bad_rec(cur, fa, &irec);
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 815e34e295dd6..9e759efa81ccd 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -22,6 +22,8 @@
 #include "xfs_extent_busy.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfs_buf_mem.h"
+#include "xfs_btree_mem.h"
 
 static struct kmem_cache	*xfs_rmapbt_cur_cache;
 
@@ -541,6 +543,151 @@ xfs_rmapbt_init_cursor(
 	return cur;
 }
 
+#ifdef CONFIG_XFS_BTREE_IN_MEM
+static inline unsigned int
+xfs_rmapbt_mem_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rmap_rec);
+	return blocklen /
+		(2 * sizeof(struct xfs_rmap_key) + sizeof(__be64));
+}
+
+/*
+ * Validate an in-memory rmap btree block.  Callers are allowed to generate an
+ * in-memory btree even if the ondisk feature is not enabled.
+ */
+static xfs_failaddr_t
+xfs_rmapbt_mem_verify(
+	struct xfs_buf		*bp)
+{
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
+	if (level >= xfs_rmapbt_maxlevels_ondisk())
+		return __this_address;
+
+	maxrecs = xfs_rmapbt_mem_block_maxrecs(
+			XFBNO_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN, level == 0);
+	return xfs_btree_memblock_verify(bp, maxrecs);
+}
+
+static void
+xfs_rmapbt_mem_rw_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa = xfs_rmapbt_mem_verify(bp);
+
+	if (fa)
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+}
+
+/* skip crc checks on in-memory btrees to save time */
+static const struct xfs_buf_ops xfs_rmapbt_mem_buf_ops = {
+	.name			= "xfs_rmapbt_mem",
+	.magic			= { 0, cpu_to_be32(XFS_RMAP_CRC_MAGIC) },
+	.verify_read		= xfs_rmapbt_mem_rw_verify,
+	.verify_write		= xfs_rmapbt_mem_rw_verify,
+	.verify_struct		= xfs_rmapbt_mem_verify,
+};
+
+const struct xfs_btree_ops xfs_rmapbt_mem_ops = {
+	.name			= "mem_rmap",
+	.type			= XFS_BTREE_TYPE_MEM,
+	.geom_flags		= XFS_BTGEO_OVERLAPPING,
+
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	/* Overlapping btree; 2 keys per pointer. */
+	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.ptr_len		= XFS_BTREE_LONG_PTR_LEN,
+
+	.lru_refs		= XFS_RMAP_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_rmap_mem_2),
+
+	.dup_cursor		= xfbtree_dup_cursor,
+	.set_root		= xfbtree_set_root,
+	.alloc_block		= xfbtree_alloc_block,
+	.free_block		= xfbtree_free_block,
+	.get_minrecs		= xfbtree_get_minrecs,
+	.get_maxrecs		= xfbtree_get_maxrecs,
+	.init_key_from_rec	= xfs_rmapbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rmapbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
+	.key_diff		= xfs_rmapbt_key_diff,
+	.buf_ops		= &xfs_rmapbt_mem_buf_ops,
+	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
+	.keys_inorder		= xfs_rmapbt_keys_inorder,
+	.recs_inorder		= xfs_rmapbt_recs_inorder,
+	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
+};
+
+/* Create a cursor for an in-memory btree. */
+struct xfs_btree_cur *
+xfs_rmapbt_mem_cursor(
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	struct xfbtree		*xfbt)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rmapbt_mem_ops,
+			xfs_rmapbt_maxlevels_ondisk(), xfs_rmapbt_cur_cache);
+	cur->bc_mem.xfbtree = xfbt;
+	cur->bc_nlevels = xfbt->nlevels;
+
+	cur->bc_mem.pag = xfs_perag_hold(pag);
+	return cur;
+}
+
+/* Create an in-memory rmap btree. */
+int
+xfs_rmapbt_mem_init(
+	struct xfs_mount	*mp,
+	struct xfbtree		*xfbt,
+	struct xfs_buftarg	*btp,
+	xfs_agnumber_t		agno)
+{
+	xfbt->owner = agno;
+	return xfbtree_init(mp, xfbt, btp, &xfs_rmapbt_mem_ops);
+}
+
+/* Compute the max possible height for reverse mapping btrees in memory. */
+static unsigned int
+xfs_rmapbt_mem_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFBNO_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+
+	minrecs[0] = xfs_rmapbt_mem_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_rmapbt_mem_block_maxrecs(blocklen, false) / 2;
+
+	/*
+	 * How tall can an in-memory rmap btree become if we filled the entire
+	 * AG with rmap records?
+	 */
+	return xfs_btree_compute_maxlevels(minrecs,
+			XFS_MAX_AG_BYTES / sizeof(struct xfs_rmap_rec));
+}
+#else
+# define xfs_rmapbt_mem_maxlevels()	(0)
+#endif /* CONFIG_XFS_BTREE_IN_MEM */
+
 /*
  * Install a new reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
@@ -611,7 +758,8 @@ xfs_rmapbt_maxlevels_ondisk(void)
 	 * like if it consumes almost all the blocks in the AG due to maximal
 	 * sharing factor.
 	 */
-	return xfs_btree_space_to_height(minrecs, XFS_MAX_CRC_AG_BLOCKS);
+	return max(xfs_btree_space_to_height(minrecs, XFS_MAX_CRC_AG_BLOCKS),
+		   xfs_rmapbt_mem_maxlevels());
 }
 
 /* Compute the maximum height of an rmap btree. */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 27536d7e14aac..eb90d89e80866 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -10,6 +10,7 @@ struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
 struct xbtree_afakeroot;
+struct xfbtree;
 
 /* rmaps only exist on crc enabled filesystems */
 #define XFS_RMAP_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
@@ -62,4 +63,9 @@ unsigned int xfs_rmapbt_maxlevels_ondisk(void);
 int __init xfs_rmapbt_init_cur_cache(void);
 void xfs_rmapbt_destroy_cur_cache(void);
 
+struct xfs_btree_cur *xfs_rmapbt_mem_cursor(struct xfs_perag *pag,
+		struct xfs_trans *tp, struct xfbtree *xfbtree);
+int xfs_rmapbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
+		struct xfs_buftarg *btp, xfs_agnumber_t agno);
+
 #endif /* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 6b8bc276d4616..cab49e7116ec5 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -51,6 +51,7 @@ extern const struct xfs_btree_ops xfs_finobt_ops;
 extern const struct xfs_btree_ops xfs_bmbt_ops;
 extern const struct xfs_btree_ops xfs_refcountbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_ops;
+extern const struct xfs_btree_ops xfs_rmapbt_mem_ops;
 
 static inline bool xfs_btree_is_bno(const struct xfs_btree_ops *ops)
 {
@@ -87,6 +88,15 @@ static inline bool xfs_btree_is_rmap(const struct xfs_btree_ops *ops)
 	return ops == &xfs_rmapbt_ops;
 }
 
+#ifdef CONFIG_XFS_BTREE_IN_MEM
+static inline bool xfs_btree_is_mem_rmap(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_rmapbt_mem_ops;
+}
+#else
+# define xfs_btree_is_mem_rmap(...)	(false)
+#endif
+
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
 int	xfs_log_calc_minimum_size(struct xfs_mount *);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 0c56dafd9ae49..2645abddad782 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -31,12 +31,14 @@
 #include "xfs_error.h"
 #include "xfs_reflink.h"
 #include "xfs_health.h"
+#include "xfs_buf_mem.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/bitmap.h"
 #include "scrub/stats.h"
+#include "scrub/xfile.h"
 
 /*
  * Attempt to repair some metadata, if the metadata is corrupt and userspace
@@ -1147,3 +1149,19 @@ xrep_metadata_inode_forks(
 
 	return 0;
 }
+
+/*
+ * Set up an in-memory buffer cache so that we can use the xfbtree.  Allocating
+ * a shmem file might take loks, so we cannot be in transaction context.  Park
+ * our resources in the scrub context and let the teardown function take care
+ * of them at the right time.
+ */
+int
+xrep_setup_xfbtree(
+	struct xfs_scrub	*sc,
+	const char		*descr)
+{
+	ASSERT(sc->tp == NULL);
+
+	return xmbuf_alloc(sc->mp, descr, &sc->xmbtp);
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index c01e56799bd1d..059b510273654 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -81,6 +81,8 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
 # define xrep_ino_dqattach(sc)			(0)
 #endif /* CONFIG_XFS_QUOTA */
 
+int xrep_setup_xfbtree(struct xfs_scrub *sc, const char *descr);
+
 int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
 		xfs_extnum_t nextents);
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 120efb49bbfe0..6efca28e461d0 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -12,6 +12,8 @@
 #include "xfs_defer.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
+#include "xfs_buf_mem.h"
+#include "xfs_btree_mem.h"
 #include "xfs_bit.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
@@ -121,33 +123,25 @@
  * We use the 'xrep_rmap' prefix for all the rmap functions.
  */
 
-/*
- * Packed rmap record.  The ATTR/BMBT/UNWRITTEN flags are hidden in the upper
- * bits of offset, just like the on-disk record.
- */
-struct xrep_rmap_extent {
-	xfs_agblock_t	startblock;
-	xfs_extlen_t	blockcount;
-	uint64_t	owner;
-	uint64_t	offset;
-} __packed;
-
 /* Context for collecting rmaps */
 struct xrep_rmap {
 	/* new rmapbt information */
 	struct xrep_newbt	new_btree;
 
 	/* rmap records generated from primary metadata */
-	struct xfarray		*rmap_records;
+	struct xfbtree		rmap_btree;
 
 	struct xfs_scrub	*sc;
 
-	/* get_records()'s position in the rmap record array. */
-	xfarray_idx_t		array_cur;
+	/* in-memory btree cursor for the xfs_btree_bload iteration */
+	struct xfs_btree_cur	*mcur;
 
 	/* inode scan cursor */
 	struct xchk_iscan	iscan;
 
+	/* Number of non-freespace records found. */
+	unsigned long long	nr_records;
+
 	/* bnobt/cntbt contribution to btreeblks */
 	xfs_agblock_t		freesp_btblocks;
 
@@ -161,6 +155,14 @@ xrep_setup_ag_rmapbt(
 	struct xfs_scrub	*sc)
 {
 	struct xrep_rmap	*rr;
+	char			*descr;
+	int			error;
+
+	descr = xchk_xfile_ag_descr(sc, "reverse mapping records");
+	error = xrep_setup_xfbtree(sc, descr);
+	kfree(descr);
+	if (error)
+		return error;
 
 	rr = kzalloc(sizeof(struct xrep_rmap), XCHK_GFP_FLAGS);
 	if (!rr)
@@ -204,11 +206,6 @@ xrep_rmap_stash(
 	uint64_t		offset,
 	unsigned int		flags)
 {
-	struct xrep_rmap_extent	rre = {
-		.startblock	= startblock,
-		.blockcount	= blockcount,
-		.owner		= owner,
-	};
 	struct xfs_rmap_irec	rmap = {
 		.rm_startblock	= startblock,
 		.rm_blockcount	= blockcount,
@@ -217,6 +214,7 @@ xrep_rmap_stash(
 		.rm_flags	= flags,
 	};
 	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_btree_cur	*mcur;
 	int			error = 0;
 
 	if (xchk_should_terminate(sc, &error))
@@ -224,8 +222,17 @@ xrep_rmap_stash(
 
 	trace_xrep_rmap_found(sc->mp, sc->sa.pag->pag_agno, &rmap);
 
-	rre.offset = xfs_rmap_irec_offset_pack(&rmap);
-	return xfarray_append(rr->rmap_records, &rre);
+	mcur = xfs_rmapbt_mem_cursor(sc->sa.pag, sc->tp, &rr->rmap_btree);
+	error = xfs_rmap_map_raw(mcur, &rmap);
+	xfs_btree_del_cursor(mcur, error);
+	if (error)
+		goto out_cancel;
+
+	return xfbtree_trans_commit(&rr->rmap_btree, sc->tp);
+
+out_cancel:
+	xfbtree_trans_cancel(&rr->rmap_btree, sc->tp);
+	return error;
 }
 
 struct xrep_rmap_stash_run {
@@ -804,6 +811,24 @@ xrep_rmap_find_log_rmaps(
 			sc->mp->m_sb.sb_logblocks, XFS_RMAP_OWN_LOG, 0, 0);
 }
 
+/* Check and count all the records that we gathered. */
+STATIC int
+xrep_rmap_check_record(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_rmap		*rr = priv;
+	int				error;
+
+	error = xrep_rmap_check_mapping(rr->sc, rec);
+	if (error)
+		return error;
+
+	rr->nr_records++;
+	return 0;
+}
+
 /*
  * Generate all the reverse-mappings for this AG, a list of the old rmapbt
  * blocks, and the new btreeblks count.  Figure out if we have enough free
@@ -817,6 +842,7 @@ xrep_rmap_find_rmaps(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xchk_ag		*sa = &sc->sa;
 	struct xfs_inode	*ip;
+	struct xfs_btree_cur	*mcur;
 	int			error;
 
 	/* Find all the per-AG metadata. */
@@ -884,7 +910,29 @@ xrep_rmap_find_rmaps(
 	error = xchk_setup_fs(sc);
 	if (error)
 		return error;
-	return xchk_perag_drain_and_lock(sc);
+	error = xchk_perag_drain_and_lock(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Now that we have everything locked again, we need to count the
+	 * number of rmap records stashed in the btree.  This should reflect
+	 * all actively-owned space in the filesystem.  At the same time, check
+	 * all our records before we start building a new btree, which requires
+	 * a bnobt cursor.
+	 */
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, &rr->rmap_btree);
+	sc->sa.bno_cur = xfs_bnobt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.pag);
+
+	rr->nr_records = 0;
+	error = xfs_rmap_query_all(mcur, xrep_rmap_check_record, rr);
+
+	xfs_btree_del_cursor(sc->sa.bno_cur, error);
+	sc->sa.bno_cur = NULL;
+	xfs_btree_del_cursor(mcur, error);
+
+	return error;
 }
 
 /* Section (II): Reserving space for new rmapbt and setting free space bitmap */
@@ -917,7 +965,6 @@ STATIC int
 xrep_rmap_try_reserve(
 	struct xrep_rmap	*rr,
 	struct xfs_btree_cur	*rmap_cur,
-	uint64_t		nr_records,
 	struct xagb_bitmap	*freesp_blocks,
 	uint64_t		*blocks_reserved,
 	bool			*done)
@@ -1001,7 +1048,7 @@ xrep_rmap_try_reserve(
 
 	/* Compute how many blocks we'll need for all the rmaps. */
 	error = xfs_btree_bload_compute_geometry(rmap_cur,
-			&rr->new_btree.bload, nr_records + freesp_records);
+			&rr->new_btree.bload, rr->nr_records + freesp_records);
 	if (error)
 		return error;
 
@@ -1020,16 +1067,13 @@ xrep_rmap_reserve_space(
 	struct xfs_btree_cur	*rmap_cur)
 {
 	struct xagb_bitmap	freesp_blocks;	/* AGBIT */
-	uint64_t		nr_records;	/* NR */
 	uint64_t		blocks_reserved = 0;
 	bool			done = false;
 	int			error;
 
-	nr_records = xfarray_length(rr->rmap_records);
-
 	/* Compute how many blocks we'll need for the rmaps collected so far. */
 	error = xfs_btree_bload_compute_geometry(rmap_cur,
-			&rr->new_btree.bload, nr_records);
+			&rr->new_btree.bload, rr->nr_records);
 	if (error)
 		return error;
 
@@ -1046,8 +1090,8 @@ xrep_rmap_reserve_space(
 	 * Finish when we don't need more blocks.
 	 */
 	do {
-		error = xrep_rmap_try_reserve(rr, rmap_cur, nr_records,
-				&freesp_blocks, &blocks_reserved, &done);
+		error = xrep_rmap_try_reserve(rr, rmap_cur, &freesp_blocks,
+				&blocks_reserved, &done);
 		if (error)
 			goto out_bitmap;
 	} while (!done);
@@ -1108,28 +1152,25 @@ xrep_rmap_get_records(
 	unsigned int		nr_wanted,
 	void			*priv)
 {
-	struct xrep_rmap_extent	rec;
-	struct xfs_rmap_irec	*irec = &cur->bc_rec.r;
 	struct xrep_rmap	*rr = priv;
 	union xfs_btree_rec	*block_rec;
 	unsigned int		loaded;
 	int			error;
 
 	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
-		error = xfarray_load_next(rr->rmap_records, &rr->array_cur,
-				&rec);
+		int		stat = 0;
+
+		error = xfs_btree_increment(rr->mcur, 0, &stat);
 		if (error)
 			return error;
-
-		irec->rm_startblock = rec.startblock;
-		irec->rm_blockcount = rec.blockcount;
-		irec->rm_owner = rec.owner;
-		if (xfs_rmap_irec_offset_unpack(rec.offset, irec) != NULL)
+		if (!stat)
 			return -EFSCORRUPTED;
 
-		error = xrep_rmap_check_mapping(rr->sc, irec);
+		error = xfs_rmap_get_rec(rr->mcur, &cur->bc_rec.r, &stat);
 		if (error)
 			return error;
+		if (!stat)
+			return -EFSCORRUPTED;
 
 		block_rec = xfs_btree_rec_addr(cur, idx, block);
 		cur->bc_ops->init_rec_from_cur(cur, block_rec);
@@ -1189,6 +1230,29 @@ xrep_rmap_alloc_vextent(
 	return xfs_alloc_vextent_near_bno(args, alloc_hint);
 }
 
+
+/* Count the records in this btree. */
+STATIC int
+xrep_rmap_count_records(
+	struct xfs_btree_cur	*cur,
+	unsigned long long	*nr)
+{
+	int			running = 1;
+	int			error;
+
+	*nr = 0;
+
+	error = xfs_btree_goto_left_edge(cur);
+	if (error)
+		return error;
+
+	while (running && !(error = xfs_btree_increment(cur, 0, &running))) {
+		if (running)
+			(*nr)++;
+	}
+
+	return error;
+}
 /*
  * Use the collected rmap information to stage a new rmap btree.  If this is
  * successful we'll return with the new btree root information logged to the
@@ -1238,6 +1302,17 @@ xrep_rmap_build_new_tree(
 	if (error)
 		goto err_cur;
 
+	/*
+	 * Count the rmapbt records again, because the space reservation
+	 * for the rmapbt itself probably added more records to the btree.
+	 */
+	rr->mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL,
+			&rr->rmap_btree);
+
+	error = xrep_rmap_count_records(rr->mcur, &rr->nr_records);
+	if (error)
+		goto err_mcur;
+
 	/*
 	 * Due to btree slack factors, it's possible for a new btree to be one
 	 * level taller than the old btree.  Update the incore btree height so
@@ -1246,13 +1321,16 @@ xrep_rmap_build_new_tree(
 	 */
 	pag->pagf_repair_rmap_level = rr->new_btree.bload.btree_height;
 
+	/*
+	 * Move the cursor to the left edge of the tree so that the first
+	 * increment in ->get_records positions us at the first record.
+	 */
+	error = xfs_btree_goto_left_edge(rr->mcur);
+	if (error)
+		goto err_level;
+
 	/* Add all observed rmap records. */
-	rr->array_cur = XFARRAY_CURSOR_INIT;
-	sc->sa.bno_cur = xfs_bnobt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
-			sc->sa.pag);
 	error = xfs_btree_bload(rmap_cur, &rr->new_btree.bload, rr);
-	xfs_btree_del_cursor(sc->sa.bno_cur, error);
-	sc->sa.bno_cur = NULL;
 	if (error)
 		goto err_level;
 
@@ -1262,6 +1340,14 @@ xrep_rmap_build_new_tree(
 	 */
 	xfs_rmapbt_commit_staged_btree(rmap_cur, sc->tp, sc->sa.agf_bp);
 	xfs_btree_del_cursor(rmap_cur, 0);
+	xfs_btree_del_cursor(rr->mcur, 0);
+	rr->mcur = NULL;
+
+	/*
+	 * Now that we've written the new btree to disk, we don't need to keep
+	 * updating the in-memory btree.  Abort the scan to stop live updates.
+	 */
+	xchk_iscan_abort(&rr->iscan);
 
 	/*
 	 * The newly committed rmap recordset includes mappings for the blocks
@@ -1285,6 +1371,8 @@ xrep_rmap_build_new_tree(
 
 err_level:
 	pag->pagf_repair_rmap_level = 0;
+err_mcur:
+	xfs_btree_del_cursor(rr->mcur, error);
 err_cur:
 	xfs_btree_del_cursor(rmap_cur, error);
 err_newbt:
@@ -1312,6 +1400,28 @@ xrep_rmap_find_freesp(
 			rec->ar_blockcount);
 }
 
+/* Record the free space we find, as part of cleaning out the btree. */
+STATIC int
+xrep_rmap_find_gaps(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_rmap_find_gaps	*rfg = priv;
+	int				error;
+
+	if (rec->rm_startblock > rfg->next_agbno) {
+		error = xagb_bitmap_set(&rfg->rmap_gaps, rfg->next_agbno,
+				rec->rm_startblock - rfg->next_agbno);
+		if (error)
+			return error;
+	}
+
+	rfg->next_agbno = max_t(xfs_agblock_t, rfg->next_agbno,
+				rec->rm_startblock + rec->rm_blockcount);
+	return 0;
+}
+
 /*
  * Reap the old rmapbt blocks.  Now that the rmapbt is fully rebuilt, we make
  * a list of gaps in the rmap records and a list of the extents mentioned in
@@ -1328,30 +1438,19 @@ xrep_rmap_remove_old_tree(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_btree_cur	*mcur;
 	xfs_agblock_t		agend;
-	xfarray_idx_t		array_cur;
 	int			error;
 
 	xagb_bitmap_init(&rfg.rmap_gaps);
 
 	/* Compute free space from the new rmapbt. */
-	foreach_xfarray_idx(rr->rmap_records, array_cur) {
-		struct xrep_rmap_extent	rec;
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, NULL, &rr->rmap_btree);
 
-		error = xfarray_load(rr->rmap_records, array_cur, &rec);
-		if (error)
-			goto out_bitmap;
-
-		/* Record the free space we find. */
-		if (rec.startblock > rfg.next_agbno) {
-			error = xagb_bitmap_set(&rfg.rmap_gaps, rfg.next_agbno,
-					rec.startblock - rfg.next_agbno);
-			if (error)
-				goto out_bitmap;
-		}
-		rfg.next_agbno = max_t(xfs_agblock_t, rfg.next_agbno,
-					rec.startblock + rec.blockcount);
-	}
+	error = xfs_rmap_query_all(mcur, xrep_rmap_find_gaps, &rfg);
+	xfs_btree_del_cursor(mcur, error);
+	if (error)
+		goto out_bitmap;
 
 	/* Insert a record for space between the last rmap and EOAG. */
 	agend = be32_to_cpu(agf->agf_length);
@@ -1402,14 +1501,11 @@ xrep_rmap_setup_scan(
 	struct xrep_rmap	*rr)
 {
 	struct xfs_scrub	*sc = rr->sc;
-	char			*descr;
 	int			error;
 
-	/* Set up some storage */
-	descr = xchk_xfile_ag_descr(sc, "reverse mapping records");
-	error = xfarray_create(descr, 0, sizeof(struct xrep_rmap_extent),
-			&rr->rmap_records);
-	kfree(descr);
+	/* Set up in-memory rmap btree */
+	error = xfs_rmapbt_mem_init(sc->mp, &rr->rmap_btree, sc->xmbtp,
+			sc->sa.pag->pag_agno);
 	if (error)
 		return error;
 
@@ -1424,7 +1520,7 @@ xrep_rmap_teardown(
 	struct xrep_rmap	*rr)
 {
 	xchk_iscan_teardown(&rr->iscan);
-	xfarray_destroy(rr->rmap_records);
+	xfbtree_destroy(&rr->rmap_btree);
 }
 
 /* Repair the rmap btree for some AG. */
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 90a77cd3ebade..5c6773628d69d 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -50,7 +50,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "ibt2",		xfsstats_offset(xs_fibt_2)	},
 		{ "fibt2",		xfsstats_offset(xs_rmap_2)	},
 		{ "rmapbt",		xfsstats_offset(xs_refcbt_2)	},
-		{ "refcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
+		{ "refcntbt",		xfsstats_offset(xs_rmap_mem_2)	},
+		{ "rmapbt_mem",		xfsstats_offset(xs_qm_dqreclaims)},
 		/* we print both series of quota information together */
 		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
 	};
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 43ffba74f045e..3b50419d8bb90 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -125,6 +125,7 @@ struct __xfsstats {
 	uint32_t		xs_fibt_2[__XBTS_MAX];
 	uint32_t		xs_rmap_2[__XBTS_MAX];
 	uint32_t		xs_refcbt_2[__XBTS_MAX];
+	uint32_t		xs_rmap_mem_2[__XBTS_MAX];
 	uint32_t		xs_qm_dqreclaims;
 	uint32_t		xs_qm_dqreclaim_misses;
 	uint32_t		xs_qm_dquot_dups;

