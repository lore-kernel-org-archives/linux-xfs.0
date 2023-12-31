Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B8CBE5F
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfnJOn0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C68FC433C8;
	Sun, 31 Dec 2023 22:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061123;
	bh=PCFqkwVm6VkgcCFQEkjOg25uT8lRA7NZZSCOv6v+tTo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NfnJOn0Wyy36BFVFb8B9C2F0y3VkZTTFTwBoC2pMZNxU46ppTG4c/sW7PNL1hTYd2
	 MFsap4Xh33wt3tG2QngTxZLrVX1wDGG941uAOBq1wO0iRzixe21e+5jzDK9WcJaSRm
	 gjPeORz19U9VsRwXY3iFx3i5gfKnWANlxwhIGkuprivFlBx9LEjwn4IstmFy9nz00o
	 CN+uuY5cj7BDeoOnnKlyV0r7Oxs4552Z2hTc7CEQMbQeJVf8QxfkL1z+93AXz6zsyW
	 +w7CLONO6H0R0gXfv/VdASqUL2VQUHZh4xFwKu5j1iaL6jUP12Ifeq5xI5G74ACaxm
	 /ZGE7ghI6A5zw==
Date: Sun, 31 Dec 2023 14:18:43 -0800
Subject: [PATCH 2/6] xfs_repair: convert regular rmap repair to use in-memory
 btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404993614.1794934.11630064091805563698.stgit@frogsfrogsfrogs>
In-Reply-To: <170404993583.1794934.17692508703738477619.stgit@frogsfrogsfrogs>
References: <170404993583.1794934.17692508703738477619.stgit@frogsfrogsfrogs>
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

Convert the rmap btree repair code to use in-memory rmap btrees to store
the observed reverse mapping records.  This will eliminate the need for
a separate record sorting step, as well as eliminate the need for all
the code that turns multiple consecutive bmap records into a single rmap
record.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/linux.c          |   33 ++++++
 libfrog/platform.h       |    3 +
 libxfs/libxfs_api_defs.h |    9 ++
 libxfs/xfbtree.c         |    8 +
 libxfs/xfbtree.h         |    1 
 repair/agbtree.c         |   18 ++-
 repair/agbtree.h         |    1 
 repair/phase5.c          |    2 
 repair/rmap.c            |  257 +++++++++++++++++++++++++++++++++++++++++++---
 repair/rmap.h            |   16 +++
 repair/xfs_repair.c      |    6 +
 11 files changed, 329 insertions(+), 25 deletions(-)


diff --git a/libfrog/linux.c b/libfrog/linux.c
index 46a5ff39e2e..be174a52396 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -274,3 +274,36 @@ platform_physmem(void)
 	}
 	return (si.totalram >> 10) * si.mem_unit;	/* kilobytes */
 }
+
+char *kvasprintf(const char *fmt, va_list ap)
+{
+	unsigned int first, second;
+	char *p;
+	va_list aq;
+
+	va_copy(aq, ap);
+	first = vsnprintf(NULL, 0, fmt, aq);
+	va_end(aq);
+
+	p = malloc(first + 1);
+	if (!p)
+		return NULL;
+
+	second = vsnprintf(p, first + 1, fmt, ap);
+	if (first != second) /* shut up gcc */
+		assert(first == second);
+
+	return p;
+}
+
+char *kasprintf(const char *fmt, ...)
+{
+	va_list ap;
+	char *p;
+
+	va_start(ap, fmt);
+	p = kvasprintf(fmt, ap);
+	va_end(ap);
+
+	return p;
+}
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 20f9bdf5ce5..003e22bf2d8 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -21,4 +21,7 @@ int platform_nproc(void);
 
 void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
 
+char *kvasprintf(const char *fmt, va_list ap);
+char *kasprintf(const char *fmt, ...);
+
 #endif /* __LIBFROG_PLATFORM_H__ */
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 8495590966f..bafb05a2f23 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -60,8 +60,13 @@
 #define xfs_btree_bload			libxfs_btree_bload
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
+#define xfs_btree_get_block		libxfs_btree_get_block
+#define xfs_btree_goto_left_edge	libxfs_btree_goto_left_edge
+#define xfs_btree_increment		libxfs_btree_increment
 #define xfs_btree_init_block		libxfs_btree_init_block
+#define xfs_btree_mem_head_read_buf	libxfs_btree_mem_head_read_buf
 #define xfs_btree_rec_addr		libxfs_btree_rec_addr
+#define xfs_btree_visit_blocks		libxfs_btree_visit_blocks
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_get_uncached		libxfs_buf_get_uncached
@@ -181,6 +186,8 @@
 #define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
 #define xfs_rmapbt_maxlevels_ondisk	libxfs_rmapbt_maxlevels_ondisk
 #define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
+#define xfs_rmapbt_mem_create		libxfs_rmapbt_mem_create
+#define xfs_rmapbt_mem_cursor		libxfs_rmapbt_mem_cursor
 #define xfs_rmapbt_stage_cursor		libxfs_rmapbt_stage_cursor
 #define xfs_rmap_compare		libxfs_rmap_compare
 #define xfs_rmap_get_rec		libxfs_rmap_get_rec
@@ -189,6 +196,7 @@
 #define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
 #define xfs_rmap_lookup_le		libxfs_rmap_lookup_le
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
+#define xfs_rmap_map_raw		libxfs_rmap_map_raw
 #define xfs_rmap_query_all		libxfs_rmap_query_all
 #define xfs_rmap_query_range		libxfs_rmap_query_range
 
@@ -244,6 +252,7 @@
 
 #define xfs_validate_stripe_geometry	libxfs_validate_stripe_geometry
 #define xfs_verify_agbno		libxfs_verify_agbno
+#define xfs_verify_agbext		libxfs_verify_agbext
 #define xfs_verify_agino		libxfs_verify_agino
 #define xfs_verify_cksum		libxfs_verify_cksum
 #define xfs_verify_dir_ino		libxfs_verify_dir_ino
diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
index c4dd706f4f7..7521566fd15 100644
--- a/libxfs/xfbtree.c
+++ b/libxfs/xfbtree.c
@@ -795,3 +795,11 @@ xfbtree_trans_cancel(
 	tp->t_flags = (tp->t_flags & ~XFS_TRANS_DIRTY) |
 			(tp_dirty ? XFS_TRANS_DIRTY : 0);
 }
+
+/* How many bytes does this xfbtree consume? */
+unsigned long long
+xfbtree_bytes(
+	struct xfbtree	*xfbt)
+{
+	return xfile_bytes(xfbt->target->bt_xfile);
+}
diff --git a/libxfs/xfbtree.h b/libxfs/xfbtree.h
index ac6d499afe5..b7a9c321b3e 100644
--- a/libxfs/xfbtree.h
+++ b/libxfs/xfbtree.h
@@ -51,6 +51,7 @@ int xfbtree_head_read_buf(struct xfbtree *xfbt, struct xfs_trans *tp,
 void xfbtree_destroy(struct xfbtree *xfbt);
 int xfbtree_trans_commit(struct xfbtree *xfbt, struct xfs_trans *tp);
 void xfbtree_trans_cancel(struct xfbtree *xfbt, struct xfs_trans *tp);
+unsigned long long xfbtree_bytes(struct xfbtree *xfbt);
 
 #endif /* CONFIG_XFS_BTREE_IN_XFILE */
 
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 38f3f7b8fea..dccb15f9667 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -104,7 +104,8 @@ reserve_agblocks(
 			do_error(_("could not set up btree reservation: %s\n"),
 				strerror(-error));
 
-		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, len,
+		error = rmap_add_agbtree_mapping(mp, agno,
+				ext_ptr->ex_startblock, len,
 				btr->newbt.oinfo.oi_owner);
 		if (error)
 			do_error(_("could not set up btree rmaps: %s\n"),
@@ -601,14 +602,19 @@ get_rmapbt_records(
 	unsigned int			nr_wanted,
 	void				*priv)
 {
-	struct xfs_rmap_irec		*rec;
 	struct bt_rebuild		*btr = priv;
 	union xfs_btree_rec		*block_rec;
 	unsigned int			loaded;
+	int				ret;
 
 	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
-		rec = pop_slab_cursor(btr->slab_cursor);
-		memcpy(&cur->bc_rec.r, rec, sizeof(struct xfs_rmap_irec));
+		ret = rmap_get_mem_rec(&btr->rmapbt_cursor, &cur->bc_rec.r);
+		if (ret < 0)
+			return ret;
+		if (ret == 0)
+			do_error(
+ _("ran out of records while rebuilding AG %u rmap btree\n"),
+					cur->bc_ag.pag->pag_agno);
 
 		block_rec = libxfs_btree_rec_addr(cur, idx, block);
 		cur->bc_ops->init_rec_from_cur(cur, block_rec);
@@ -656,7 +662,7 @@ build_rmap_tree(
 {
 	int			error;
 
-	error = rmap_init_cursor(agno, &btr->slab_cursor);
+	error = rmap_init_mem_cursor(sc->mp, NULL, agno, &btr->rmapbt_cursor);
 	if (error)
 		do_error(
 _("Insufficient memory to construct rmap cursor.\n"));
@@ -669,7 +675,7 @@ _("Error %d while creating rmap btree for AG %u.\n"), error, agno);
 
 	/* Since we're not writing the AGF yet, no need to commit the cursor */
 	libxfs_btree_del_cursor(btr->cur, 0);
-	free_slab_cursor(&btr->slab_cursor);
+	rmap_free_mem_cursor(NULL, &btr->rmapbt_cursor, 0);
 }
 
 /* rebuild the refcount tree */
diff --git a/repair/agbtree.h b/repair/agbtree.h
index 714d8e68716..7b12b9da74e 100644
--- a/repair/agbtree.h
+++ b/repair/agbtree.h
@@ -20,6 +20,7 @@ struct bt_rebuild {
 	/* Tree-specific data. */
 	union {
 		struct xfs_slab_cursor	*slab_cursor;
+		struct rmap_mem_cur	rmapbt_cursor;
 		struct {
 			struct extent_tree_node	*bno_rec;
 			unsigned int		freeblks;
diff --git a/repair/phase5.c b/repair/phase5.c
index b0e208f95af..d7bacb18b84 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -714,7 +714,7 @@ phase5(xfs_mount_t *mp)
 	 * the superblock counters.
 	 */
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		error = rmap_store_ag_btree_rec(mp, agno);
+		error = rmap_commit_agbtree_mappings(mp, agno);
 		if (error)
 			do_error(
 _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
diff --git a/repair/rmap.c b/repair/rmap.c
index 564e1cbf294..53b8ac6fcf9 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -13,6 +13,9 @@
 #include "slab.h"
 #include "rmap.h"
 #include "libfrog/bitmap.h"
+#include "libfrog/platform.h"
+#include "libxfs/xfile.h"
+#include "libxfs/xfbtree.h"
 
 #undef RMAP_DEBUG
 
@@ -24,6 +27,7 @@
 
 /* per-AG rmap object anchor */
 struct xfs_ag_rmap {
+	struct xfbtree	*ar_xfbtree;		/* rmap observations */
 	struct xfs_slab	*ar_rmaps;		/* rmap observations, p4 */
 	struct xfs_slab	*ar_raw_rmaps;		/* unmerged rmaps */
 	int		ar_flcount;		/* agfl entries from leftover */
@@ -53,6 +57,61 @@ rmap_needs_work(
 	       xfs_has_rmapbt(mp);
 }
 
+/* Destroy an in-memory rmap btree. */
+STATIC void
+rmaps_destroy(
+	struct xfs_mount	*mp,
+	struct xfs_ag_rmap	*ag_rmap)
+{
+	struct xfs_buftarg	*target;
+
+	free_slab(&ag_rmap->ar_refcount_items);
+
+	if (!ag_rmap->ar_xfbtree)
+		return;
+
+	target = ag_rmap->ar_xfbtree->target;
+
+	xfbtree_destroy(ag_rmap->ar_xfbtree);
+	xfile_free_buftarg(target);
+}
+
+/* Initialize the in-memory rmap btree for collecting per-AG rmap records. */
+STATIC void
+rmaps_init_ag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_ag_rmap	*ag_rmap)
+{
+	struct xfs_buftarg	*target;
+	char			*descr;
+	unsigned long long	maxbytes;
+	int			error;
+
+	maxbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_agblocks);
+	descr = kasprintf("xfs_repair (%s): AG %u rmap records",
+			mp->m_fsname, agno);
+	error = -xfile_alloc_buftarg(mp, descr, maxbytes, &target);
+	kfree(descr);
+	if (error)
+		goto nomem;
+
+	error = -libxfs_rmapbt_mem_create(mp, agno, target,
+			&ag_rmap->ar_xfbtree);
+	if (error)
+		goto nomem;
+
+	error = init_slab(&ag_rmap->ar_refcount_items,
+			  sizeof(struct xfs_refcount_irec));
+	if (error)
+		goto nomem;
+
+	return;
+nomem:
+	do_error(
+_("Insufficient memory while allocating realtime reverse mapping btree."));
+}
+
 /*
  * Initialize per-AG reverse map data.
  */
@@ -71,6 +130,8 @@ rmaps_init(
 		do_error(_("couldn't allocate per-AG reverse map roots\n"));
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		rmaps_init_ag(mp, i, &ag_rmaps[i]);
+
 		error = init_slab(&ag_rmaps[i].ar_rmaps,
 				sizeof(struct xfs_rmap_irec));
 		if (error)
@@ -82,11 +143,6 @@ _("Insufficient memory while allocating reverse mapping slabs."));
 			do_error(
 _("Insufficient memory while allocating raw metadata reverse mapping slabs."));
 		ag_rmaps[i].ar_last_rmap.rm_owner = XFS_RMAP_OWN_UNKNOWN;
-		error = init_slab(&ag_rmaps[i].ar_refcount_items,
-				  sizeof(struct xfs_refcount_irec));
-		if (error)
-			do_error(
-_("Insufficient memory while allocating refcount item slabs."));
 	}
 }
 
@@ -105,7 +161,7 @@ rmaps_free(
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		free_slab(&ag_rmaps[i].ar_rmaps);
 		free_slab(&ag_rmaps[i].ar_raw_rmaps);
-		free_slab(&ag_rmaps[i].ar_refcount_items);
+		rmaps_destroy(mp, &ag_rmaps[i]);
 	}
 	free(ag_rmaps);
 	ag_rmaps = NULL;
@@ -136,6 +192,103 @@ rmaps_are_mergeable(
 	return r1->rm_offset + r1->rm_blockcount == r2->rm_offset;
 }
 
+int
+rmap_init_mem_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	struct rmap_mem_cur	*rmcur)
+{
+	struct xfbtree		*xfbt;
+	struct xfs_perag	*pag;
+	int			error;
+
+	xfbt = ag_rmaps[agno].ar_xfbtree;
+	error = -xfbtree_head_read_buf(xfbt, tp, &rmcur->mhead_bp);
+	if (error)
+		return error;
+
+	pag = libxfs_perag_get(mp, agno);
+	rmcur->mcur = libxfs_rmapbt_mem_cursor(pag, tp, rmcur->mhead_bp, xfbt);
+
+	error = -libxfs_btree_goto_left_edge(rmcur->mcur);
+	if (error)
+		rmap_free_mem_cursor(tp, rmcur, error);
+
+	libxfs_perag_put(pag);
+	return error;
+}
+
+void
+rmap_free_mem_cursor(
+	struct xfs_trans	*tp,
+	struct rmap_mem_cur	*rmcur,
+	int			error)
+{
+	libxfs_btree_del_cursor(rmcur->mcur, error);
+	libxfs_trans_brelse(tp, rmcur->mhead_bp);
+	rmcur->mcur = NULL;
+	rmcur->mhead_bp = NULL;
+}
+
+/*
+ * Retrieve the next record from the in-memory rmap btree.  Returns 1 if irec
+ * has been filled out, 0 if there aren't any more records, or a negative errno
+ * value if an error happened.
+ */
+int
+rmap_get_mem_rec(
+	struct rmap_mem_cur	*rmcur,
+	struct xfs_rmap_irec	*irec)
+{
+	int			stat = 0;
+	int			error;
+
+	error = -libxfs_btree_increment(rmcur->mcur, 0, &stat);
+	if (error)
+		return -error;
+	if (!stat)
+		return 0;
+
+	error = -libxfs_rmap_get_rec(rmcur->mcur, irec, &stat);
+	if (error)
+		return -error;
+
+	return stat;
+}
+
+static void
+rmap_add_mem_rec(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_rmap_irec	*rmap)
+{
+	struct rmap_mem_cur	rmcur;
+	struct xfbtree		*xfbt;
+	struct xfs_trans	*tp;
+	int			error;
+
+	xfbt = ag_rmaps[agno].ar_xfbtree;
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		do_error(_("allocating tx for in-memory rmap update\n"));
+
+	error = rmap_init_mem_cursor(mp, tp, agno, &rmcur);
+	if (error)
+		do_error(_("reading in-memory rmap btree head\n"));
+
+	error = -libxfs_rmap_map_raw(rmcur.mcur, rmap);
+	if (error)
+		do_error(_("adding rmap to in-memory btree, err %d\n"), error);
+	rmap_free_mem_cursor(tp, &rmcur, 0);
+
+	error = xfbtree_trans_commit(xfbt, tp);
+	if (error)
+		do_error(_("committing in-memory rmap record\n"));
+
+	libxfs_trans_cancel(tp);
+}
+
 /*
  * Add an observation about a block mapping in an inode's data or attribute
  * fork for later btree reconstruction.
@@ -173,6 +326,9 @@ rmap_add_rec(
 	rmap.rm_blockcount = irec->br_blockcount;
 	if (irec->br_state == XFS_EXT_UNWRITTEN)
 		rmap.rm_flags |= XFS_RMAP_UNWRITTEN;
+
+	rmap_add_mem_rec(mp, agno, &rmap);
+
 	last_rmap = &ag_rmaps[agno].ar_last_rmap;
 	if (last_rmap->rm_owner == XFS_RMAP_OWN_UNKNOWN)
 		*last_rmap = rmap;
@@ -223,6 +379,8 @@ __rmap_add_raw_rec(
 		rmap.rm_flags |= XFS_RMAP_BMBT_BLOCK;
 	rmap.rm_startblock = agbno;
 	rmap.rm_blockcount = len;
+
+	rmap_add_mem_rec(mp, agno, &rmap);
 	return slab_add(ag_rmaps[agno].ar_raw_rmaps, &rmap);
 }
 
@@ -273,6 +431,36 @@ rmap_add_ag_rec(
 	return __rmap_add_raw_rec(mp, agno, agbno, len, owner, false, false);
 }
 
+/*
+ * Add a reverse mapping for a per-AG btree extent.  These are /not/ tracked
+ * in the in-memory rmap btree because they can only be added to the rmap
+ * data after the in-memory btrees have been written to disk.
+ */
+int
+rmap_add_agbtree_mapping(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	uint64_t		owner)
+{
+	struct xfs_rmap_irec	rmap = {
+		.rm_owner	= owner,
+		.rm_startblock	= agbno,
+		.rm_blockcount	= len,
+	};
+	struct xfs_perag	*pag;
+
+	if (!rmap_needs_work(mp))
+		return 0;
+
+	pag = libxfs_perag_get(mp, agno);
+	assert(libxfs_verify_agbext(pag, agbno, len));
+	libxfs_perag_put(pag);
+
+	return slab_add(ag_rmaps[agno].ar_raw_rmaps, &rmap);
+}
+
 /*
  * Merge adjacent raw rmaps and add them to the main rmap list.
  */
@@ -441,7 +629,7 @@ rmap_add_fixed_ag_rec(
  * the rmapbt, after which it is fully regenerated.
  */
 int
-rmap_store_ag_btree_rec(
+rmap_commit_agbtree_mappings(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
@@ -536,7 +724,7 @@ rmap_store_ag_btree_rec(
 	if (error)
 		goto err;
 
-	/* Create cursors to refcount structures */
+	/* Create cursors to rmap structures */
 	error = init_slab_cursor(ag_rmap->ar_rmaps, rmap_compare, &rm_cur);
 	if (error)
 		goto err;
@@ -870,6 +1058,21 @@ compute_refcounts(
 }
 #undef RMAP_END
 
+static int
+count_btree_records(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	void			*data)
+{
+	uint64_t		*nr = data;
+	struct xfs_btree_block	*block;
+	struct xfs_buf		*bp;
+
+	block = libxfs_btree_get_block(cur, level, &bp);
+	*nr += be16_to_cpu(block->bb_numrecs);
+	return 0;
+}
+
 /*
  * Return the number of rmap objects for an AG.
  */
@@ -878,7 +1081,26 @@ rmap_record_count(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
-	return slab_count(ag_rmaps[agno].ar_rmaps);
+	struct rmap_mem_cur	rmcur;
+	uint64_t		nr = 0;
+	int			error;
+
+	if (ag_rmaps[agno].ar_xfbtree == NULL)
+		return 0;
+
+	error = rmap_init_mem_cursor(mp, NULL, agno, &rmcur);
+	if (error)
+		do_error(_("%s while reading in-memory rmap btree\n"),
+				strerror(error));
+
+	error = -libxfs_btree_visit_blocks(rmcur.mcur, count_btree_records,
+			XFS_BTREE_VISIT_RECORDS, &nr);
+	if (error)
+		do_error(_("%s while counting in-memory rmap records\n"),
+				strerror(error));
+
+	rmap_free_mem_cursor(NULL, &rmcur, 0);
+	return nr;
 }
 
 /*
@@ -1544,17 +1766,18 @@ estimate_rmapbt_blocks(
 	if (!rmap_needs_work(mp) || !xfs_has_rmapbt(mp))
 		return 0;
 
+	x = &ag_rmaps[pag->pag_agno];
+	if (!x->ar_xfbtree)
+		return 0;
+
 	/*
 	 * Overestimate the amount of space needed by pretending that every
-	 * record in the incore slab will become rmapbt records.
+	 * byte in the incore tree is used to store rmapbt records.  This
+	 * means we can use SEEK_DATA/HOLE on the xfile, which is faster than
+	 * walking the entire btree.
 	 */
-	x = &ag_rmaps[pag->pag_agno];
-	if (x->ar_rmaps)
-		nr_recs += slab_count(x->ar_rmaps);
-	if (x->ar_raw_rmaps)
-		nr_recs += slab_count(x->ar_raw_rmaps);
-
-	return libxfs_rmapbt_calc_size(mp, nr_recs);
+	nr_recs = xfbtree_bytes(x->ar_xfbtree) / sizeof(struct xfs_rmap_rec);
+	return libxfs_rmapbt_calc_size(pag->pag_mount, nr_recs);
 }
 
 /* Estimate the size of the ondisk refcountbt from the incore data. */
diff --git a/repair/rmap.h b/repair/rmap.h
index 1bc8c127d0e..2abd37d14e5 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -24,7 +24,10 @@ extern int rmap_fold_raw_recs(struct xfs_mount *mp, xfs_agnumber_t agno);
 extern bool rmaps_are_mergeable(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
 
 extern int rmap_add_fixed_ag_rec(struct xfs_mount *, xfs_agnumber_t);
-extern int rmap_store_ag_btree_rec(struct xfs_mount *, xfs_agnumber_t);
+
+int rmap_add_agbtree_mapping(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
+int rmap_commit_agbtree_mappings(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 uint64_t rmap_record_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 extern int rmap_init_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
@@ -52,4 +55,15 @@ extern void rmap_store_agflcount(struct xfs_mount *, xfs_agnumber_t, int);
 xfs_extlen_t estimate_rmapbt_blocks(struct xfs_perag *pag);
 xfs_extlen_t estimate_refcountbt_blocks(struct xfs_perag *pag);
 
+struct rmap_mem_cur {
+	struct xfs_btree_cur	*mcur;
+	struct xfs_buf		*mhead_bp;
+};
+
+int rmap_init_mem_cursor(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_agnumber_t agno, struct rmap_mem_cur *rmcur);
+void rmap_free_mem_cursor(struct xfs_trans *tp, struct rmap_mem_cur *rmcur,
+		int error);
+int rmap_get_mem_rec(struct rmap_mem_cur *rmcur, struct xfs_rmap_irec *irec);
+
 #endif /* RMAP_H_ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 01f92e841f2..ba78dc0b8ea 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -911,6 +911,12 @@ repair_capture_writeback(
 	struct xfs_mount	*mp = bp->b_mount;
 	static pthread_mutex_t	wb_mutex = PTHREAD_MUTEX_INITIALIZER;
 
+	/* We only care about ondisk metadata. */
+	if (bp->b_target != mp->m_ddev_targp &&
+	    bp->b_target != mp->m_logdev_targp &&
+	    bp->b_target != mp->m_rtdev_targp)
+		return;
+
 	/*
 	 * This write hook ignores any buffer that looks like a superblock to
 	 * avoid hook recursion when setting NEEDSREPAIR.  Higher level code

