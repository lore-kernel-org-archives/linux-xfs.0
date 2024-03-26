Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969EC12838F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 04:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425632; cv=none; b=YyqgG/XSFFxl10qI9zuCITLXj5QSgplefwjgwrTPVTDDykXgVejYj4EzjC/KsB1t/1bX5nejsjTe3HfEkC9g5W6YUdqM7FFWDlr6pOg6ovDBnnbcCkBiIcB2ss/kYLLbyG7D0oCbWRCtXMjLYHUCXOlv8GqsRFIFbnkbRCPOAsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425632; c=relaxed/simple;
	bh=HXFJUwnEwRgm5QrRDNteq49b4odJN8si35YIF8xSCbg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uo1+6Va7rrtJimj9UTxzZ4avTbQBVyu3R6dd96dLQpuefZcuZwYEeoYpE/eNLuXvOhmSmlZEU9BDzps0dfFBzMt47ZwB0Afg/CPxnBO/Pmu70shbjuy+kCyjeO1udgpOFT2eDc34gLNx+cqsl5Pode9fjx04d9eBdIw7rk13ym8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSesSHcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSesSHcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60550C433F1;
	Tue, 26 Mar 2024 04:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425632;
	bh=HXFJUwnEwRgm5QrRDNteq49b4odJN8si35YIF8xSCbg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RSesSHcmItGse0QRyQuj5iP/hU8j0XvZR8prnr1uzEur7/wif/tkvzhiA4VMQsk3X
	 FhBPwl6aFFpWrfwwQKmFMTp1NyOvl4bDvQm4jI3kDEPtmpY4zk7pBT4aJ2S+47IryS
	 BbPJCMI1sKPXXrN+jSx0SjHQWUpqFUnIV5ilVyabdfW+kUzrAOUkiS6QVD9kVIAoFM
	 njKtM1vobgglR6i2Hms/9d87FEl4tn/DjXP2zALeNQEfWEmgoVwlWr005UybBp0+Y5
	 gjKevsu24o3alti4rM94LZGoYpwRAToD77IXXw9jKOXnwfi/grjduLhufapJ7xiMed
	 Ufy1ZtFIgz0HA==
Date: Mon, 25 Mar 2024 21:00:31 -0700
Subject: [PATCH 1/5] xfs_repair: convert regular rmap repair to use in-memory
 btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142134693.2220026.17221087060563357898.stgit@frogsfrogsfrogs>
In-Reply-To: <171142134672.2220026.18064456796378653896.stgit@frogsfrogsfrogs>
References: <171142134672.2220026.18064456796378653896.stgit@frogsfrogsfrogs>
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
 include/libxfs.h         |    3 +
 libfrog/linux.c          |   33 ++++++
 libfrog/platform.h       |    3 +
 libxfs/buf_mem.h         |    5 +
 libxfs/libxfs_api_defs.h |    9 ++
 repair/agbtree.c         |   18 ++-
 repair/agbtree.h         |    1 
 repair/phase5.c          |    2 
 repair/rmap.c            |  259 ++++++++++++++++++++++++++++++++++++++++++----
 repair/rmap.h            |    9 +-
 repair/xfs_repair.c      |    6 +
 11 files changed, 319 insertions(+), 29 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 79df8bc7c138..fb8efb696220 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -87,6 +87,9 @@ struct iomap;
 #include "xfs_btree_staging.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_symlink_remote.h"
+#include "libxfs/xfile.h"
+#include "libxfs/buf_mem.h"
+#include "xfs_btree_mem.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libfrog/linux.c b/libfrog/linux.c
index 46a5ff39e2eb..be174a523962 100644
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
index 20f9bdf5ce5b..003e22bf2d86 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -21,4 +21,7 @@ int platform_nproc(void);
 
 void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
 
+char *kvasprintf(const char *fmt, va_list ap);
+char *kasprintf(const char *fmt, ...);
+
 #endif /* __LIBFROG_PLATFORM_H__ */
diff --git a/libxfs/buf_mem.h b/libxfs/buf_mem.h
index 3829dd00d7e9..f19bc6fd700b 100644
--- a/libxfs/buf_mem.h
+++ b/libxfs/buf_mem.h
@@ -27,4 +27,9 @@ bool xmbuf_verify_daddr(struct xfs_buftarg *btp, xfs_daddr_t daddr);
 void xmbuf_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
 int xmbuf_finalize(struct xfs_buf *bp);
 
+static inline unsigned long long xmbuf_bytes(struct xfs_buftarg *btp)
+{
+	return xfile_bytes(btp->bt_xfile);
+}
+
 #endif /* __XFS_BUF_MEM_H__ */
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index de37d3050c7e..74bf15172a61 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -64,10 +64,15 @@
 #define xfs_btree_bload			libxfs_btree_bload
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
+#define xfs_btree_get_block		libxfs_btree_get_block
+#define xfs_btree_goto_left_edge	libxfs_btree_goto_left_edge
+#define xfs_btree_increment		libxfs_btree_increment
 #define xfs_btree_init_block		libxfs_btree_init_block
+#define xfs_btree_mem_head_read_buf	libxfs_btree_mem_head_read_buf
 #define xfs_btree_rec_addr		libxfs_btree_rec_addr
 #define xfs_btree_stage_afakeroot	libxfs_btree_stage_afakeroot
 #define xfs_btree_stage_ifakeroot	libxfs_btree_stage_ifakeroot
+#define xfs_btree_visit_blocks		libxfs_btree_visit_blocks
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_get_uncached		libxfs_buf_get_uncached
@@ -191,6 +196,8 @@
 #define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
 #define xfs_rmapbt_maxlevels_ondisk	libxfs_rmapbt_maxlevels_ondisk
 #define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
+#define xfs_rmapbt_mem_init		libxfs_rmapbt_mem_init
+#define xfs_rmapbt_mem_cursor		libxfs_rmapbt_mem_cursor
 #define xfs_rmapbt_stage_cursor		libxfs_rmapbt_stage_cursor
 #define xfs_rmap_compare		libxfs_rmap_compare
 #define xfs_rmap_get_rec		libxfs_rmap_get_rec
@@ -199,6 +206,7 @@
 #define xfs_rmap_irec_offset_unpack	libxfs_rmap_irec_offset_unpack
 #define xfs_rmap_lookup_le		libxfs_rmap_lookup_le
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
+#define xfs_rmap_map_raw		libxfs_rmap_map_raw
 #define xfs_rmap_query_all		libxfs_rmap_query_all
 #define xfs_rmap_query_range		libxfs_rmap_query_range
 
@@ -256,6 +264,7 @@
 
 #define xfs_validate_stripe_geometry	libxfs_validate_stripe_geometry
 #define xfs_verify_agbno		libxfs_verify_agbno
+#define xfs_verify_agbext		libxfs_verify_agbext
 #define xfs_verify_agino		libxfs_verify_agino
 #define xfs_verify_cksum		libxfs_verify_cksum
 #define xfs_verify_dir_ino		libxfs_verify_dir_ino
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 1a3e40cca68c..c8f75f49e6b3 100644
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
@@ -602,14 +603,19 @@ get_rmapbt_records(
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
+		ret = rmap_get_mem_rec(btr->rmapbt_cursor, &cur->bc_rec.r);
+		if (ret < 0)
+			return ret;
+		if (ret == 0)
+			do_error(
+ _("ran out of records while rebuilding AG %u rmap btree\n"),
+					cur->bc_ag.pag->pag_agno);
 
 		block_rec = libxfs_btree_rec_addr(cur, idx, block);
 		cur->bc_ops->init_rec_from_cur(cur, block_rec);
@@ -658,7 +664,7 @@ build_rmap_tree(
 {
 	int			error;
 
-	error = rmap_init_cursor(agno, &btr->slab_cursor);
+	error = rmap_init_mem_cursor(sc->mp, NULL, agno, &btr->rmapbt_cursor);
 	if (error)
 		do_error(
 _("Insufficient memory to construct rmap cursor.\n"));
@@ -671,7 +677,7 @@ _("Error %d while creating rmap btree for AG %u.\n"), error, agno);
 
 	/* Since we're not writing the AGF yet, no need to commit the cursor */
 	libxfs_btree_del_cursor(btr->cur, 0);
-	free_slab_cursor(&btr->slab_cursor);
+	libxfs_btree_del_cursor(btr->rmapbt_cursor, 0);
 }
 
 /* rebuild the refcount tree */
diff --git a/repair/agbtree.h b/repair/agbtree.h
index 714d8e687163..6d2c401a657d 100644
--- a/repair/agbtree.h
+++ b/repair/agbtree.h
@@ -20,6 +20,7 @@ struct bt_rebuild {
 	/* Tree-specific data. */
 	union {
 		struct xfs_slab_cursor	*slab_cursor;
+		struct xfs_btree_cur	*rmapbt_cursor;
 		struct {
 			struct extent_tree_node	*bno_rec;
 			unsigned int		freeblks;
diff --git a/repair/phase5.c b/repair/phase5.c
index b689a4234143..52666ad88233 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -712,7 +712,7 @@ phase5(xfs_mount_t *mp)
 	 * the superblock counters.
 	 */
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		error = rmap_store_ag_btree_rec(mp, agno);
+		error = rmap_commit_agbtree_mappings(mp, agno);
 		if (error)
 			do_error(
 _("unable to add AG %u reverse-mapping data to btree.\n"), agno);
diff --git a/repair/rmap.c b/repair/rmap.c
index 032bf494250a..883d8e21294c 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -13,6 +13,7 @@
 #include "slab.h"
 #include "rmap.h"
 #include "libfrog/bitmap.h"
+#include "libfrog/platform.h"
 
 #undef RMAP_DEBUG
 
@@ -24,12 +25,25 @@
 
 /* per-AG rmap object anchor */
 struct xfs_ag_rmap {
-	struct xfs_slab	*ar_rmaps;		/* rmap observations, p4 */
-	struct xfs_slab	*ar_raw_rmaps;		/* unmerged rmaps */
-	int		ar_flcount;		/* agfl entries from leftover */
-						/* agbt allocations */
-	struct xfs_rmap_irec	ar_last_rmap;	/* last rmap seen */
-	struct xfs_slab	*ar_refcount_items;	/* refcount items, p4-5 */
+	/* root of rmap observations btree */
+	struct xfbtree		ar_xfbtree;
+	/* rmap buffer target for btree */
+	struct xfs_buftarg	*ar_xmbtp;
+
+	/* rmap observations, p4 */
+	struct xfs_slab		*ar_rmaps;
+
+	/* unmerged rmaps */
+	struct xfs_slab		*ar_raw_rmaps;
+
+	/* agfl entries from leftover agbt allocations */
+	int			ar_flcount;
+
+	/* last rmap seen */
+	struct xfs_rmap_irec	ar_last_rmap;
+
+	/* refcount items, p4-5 */
+	struct xfs_slab		*ar_refcount_items;
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
@@ -53,6 +67,61 @@ rmap_needs_work(
 	       xfs_has_rmapbt(mp);
 }
 
+static inline bool rmaps_has_observations(const struct xfs_ag_rmap *ag_rmap)
+{
+	return ag_rmap->ar_xfbtree.target;
+}
+
+/* Destroy an in-memory rmap btree. */
+STATIC void
+rmaps_destroy(
+	struct xfs_mount	*mp,
+	struct xfs_ag_rmap	*ag_rmap)
+{
+	free_slab(&ag_rmap->ar_refcount_items);
+
+	if (!rmaps_has_observations(ag_rmap))
+		return;
+
+	xfbtree_destroy(&ag_rmap->ar_xfbtree);
+	xmbuf_free(ag_rmap->ar_xmbtp);
+}
+
+/* Initialize the in-memory rmap btree for collecting per-AG rmap records. */
+STATIC void
+rmaps_init_ag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_ag_rmap	*ag_rmap)
+{
+	char			*descr;
+	unsigned long long	maxbytes;
+	int			error;
+
+	maxbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_agblocks);
+	descr = kasprintf("xfs_repair (%s): AG %u rmap records",
+			mp->m_fsname, agno);
+	error = -xmbuf_alloc(mp, descr, maxbytes, &ag_rmap->ar_xmbtp);
+	kfree(descr);
+	if (error)
+		goto nomem;
+
+	error = -libxfs_rmapbt_mem_init(mp, &ag_rmap->ar_xfbtree,
+			ag_rmap->ar_xmbtp, agno);
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
@@ -71,6 +140,8 @@ rmaps_init(
 		do_error(_("couldn't allocate per-AG reverse map roots\n"));
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		rmaps_init_ag(mp, i, &ag_rmaps[i]);
+
 		error = init_slab(&ag_rmaps[i].ar_rmaps,
 				sizeof(struct xfs_rmap_irec));
 		if (error)
@@ -82,11 +153,6 @@ _("Insufficient memory while allocating reverse mapping slabs."));
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
 
@@ -105,7 +171,7 @@ rmaps_free(
 	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
 		free_slab(&ag_rmaps[i].ar_rmaps);
 		free_slab(&ag_rmaps[i].ar_raw_rmaps);
-		free_slab(&ag_rmaps[i].ar_refcount_items);
+		rmaps_destroy(mp, &ag_rmaps[i]);
 	}
 	free(ag_rmaps);
 	ag_rmaps = NULL;
@@ -136,6 +202,87 @@ rmaps_are_mergeable(
 	return r1->rm_offset + r1->rm_blockcount == r2->rm_offset;
 }
 
+int
+rmap_init_mem_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	struct xfs_btree_cur	**rmcurp)
+{
+	struct xfbtree		*xfbt;
+	struct xfs_perag	*pag;
+	int			error;
+
+	xfbt = &ag_rmaps[agno].ar_xfbtree;
+	pag = libxfs_perag_get(mp, agno);
+	*rmcurp = libxfs_rmapbt_mem_cursor(pag, tp, xfbt);
+
+	error = -libxfs_btree_goto_left_edge(*rmcurp);
+	if (error)
+		libxfs_btree_del_cursor(*rmcurp, error);
+
+	libxfs_perag_put(pag);
+	return error;
+}
+
+/*
+ * Retrieve the next record from the in-memory rmap btree.  Returns 1 if irec
+ * has been filled out, 0 if there aren't any more records, or a negative errno
+ * value if an error happened.
+ */
+int
+rmap_get_mem_rec(
+	struct xfs_btree_cur	*rmcur,
+	struct xfs_rmap_irec	*irec)
+{
+	int			stat = 0;
+	int			error;
+
+	error = -libxfs_btree_increment(rmcur, 0, &stat);
+	if (error)
+		return -error;
+	if (!stat)
+		return 0;
+
+	error = -libxfs_rmap_get_rec(rmcur, irec, &stat);
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
+	struct xfs_btree_cur	*rmcur;
+	struct xfbtree		*xfbt;
+	struct xfs_trans	*tp;
+	int			error;
+
+	xfbt = &ag_rmaps[agno].ar_xfbtree;
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		do_error(_("allocating tx for in-memory rmap update\n"));
+
+	error = rmap_init_mem_cursor(mp, tp, agno, &rmcur);
+	if (error)
+		do_error(_("reading in-memory rmap btree head\n"));
+
+	error = -libxfs_rmap_map_raw(rmcur, rmap);
+	if (error)
+		do_error(_("adding rmap to in-memory btree, err %d\n"), error);
+	libxfs_btree_del_cursor(rmcur, 0);
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
@@ -173,6 +320,9 @@ rmap_add_rec(
 	rmap.rm_blockcount = irec->br_blockcount;
 	if (irec->br_state == XFS_EXT_UNWRITTEN)
 		rmap.rm_flags |= XFS_RMAP_UNWRITTEN;
+
+	rmap_add_mem_rec(mp, agno, &rmap);
+
 	last_rmap = &ag_rmaps[agno].ar_last_rmap;
 	if (last_rmap->rm_owner == XFS_RMAP_OWN_UNKNOWN)
 		*last_rmap = rmap;
@@ -223,6 +373,8 @@ __rmap_add_raw_rec(
 		rmap.rm_flags |= XFS_RMAP_BMBT_BLOCK;
 	rmap.rm_startblock = agbno;
 	rmap.rm_blockcount = len;
+
+	rmap_add_mem_rec(mp, agno, &rmap);
 	return slab_add(ag_rmaps[agno].ar_raw_rmaps, &rmap);
 }
 
@@ -273,6 +425,36 @@ rmap_add_ag_rec(
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
@@ -441,7 +623,7 @@ rmap_add_fixed_ag_rec(
  * the rmapbt, after which it is fully regenerated.
  */
 int
-rmap_store_ag_btree_rec(
+rmap_commit_agbtree_mappings(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
@@ -536,7 +718,7 @@ rmap_store_ag_btree_rec(
 	if (error)
 		goto err;
 
-	/* Create cursors to refcount structures */
+	/* Create cursors to rmap structures */
 	error = init_slab_cursor(ag_rmap->ar_rmaps, rmap_compare, &rm_cur);
 	if (error)
 		goto err;
@@ -869,6 +1051,21 @@ compute_refcounts(
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
@@ -877,7 +1074,26 @@ rmap_record_count(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
-	return slab_count(ag_rmaps[agno].ar_rmaps);
+	struct xfs_btree_cur	*rmcur;
+	uint64_t		nr = 0;
+	int			error;
+
+	if (!rmaps_has_observations(&ag_rmaps[agno]))
+		return 0;
+
+	error = rmap_init_mem_cursor(mp, NULL, agno, &rmcur);
+	if (error)
+		do_error(_("%s while reading in-memory rmap btree\n"),
+				strerror(error));
+
+	error = -libxfs_btree_visit_blocks(rmcur, count_btree_records,
+			XFS_BTREE_VISIT_RECORDS, &nr);
+	if (error)
+		do_error(_("%s while counting in-memory rmap records\n"),
+				strerror(error));
+
+	libxfs_btree_del_cursor(rmcur, 0);
+	return nr;
 }
 
 /*
@@ -1545,15 +1761,16 @@ estimate_rmapbt_blocks(
 
 	/*
 	 * Overestimate the amount of space needed by pretending that every
-	 * record in the incore slab will become rmapbt records.
+	 * byte in the incore tree is used to store rmapbt records.  This
+	 * means we can use SEEK_DATA/HOLE on the xfile, which is faster than
+	 * walking the entire btree to count records.
 	 */
 	x = &ag_rmaps[pag->pag_agno];
-	if (x->ar_rmaps)
-		nr_recs += slab_count(x->ar_rmaps);
-	if (x->ar_raw_rmaps)
-		nr_recs += slab_count(x->ar_raw_rmaps);
+	if (!rmaps_has_observations(x))
+		return 0;
 
-	return libxfs_rmapbt_calc_size(mp, nr_recs);
+	nr_recs = xmbuf_bytes(x->ar_xmbtp) / sizeof(struct xfs_rmap_rec);
+	return libxfs_rmapbt_calc_size(pag->pag_mount, nr_recs);
 }
 
 /* Estimate the size of the ondisk refcountbt from the incore data. */
diff --git a/repair/rmap.h b/repair/rmap.h
index 1bc8c127d0e5..2de3ec56f234 100644
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
@@ -52,4 +55,8 @@ extern void rmap_store_agflcount(struct xfs_mount *, xfs_agnumber_t, int);
 xfs_extlen_t estimate_rmapbt_blocks(struct xfs_perag *pag);
 xfs_extlen_t estimate_refcountbt_blocks(struct xfs_perag *pag);
 
+int rmap_init_mem_cursor(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_agnumber_t agno, struct xfs_btree_cur **rmcurp);
+int rmap_get_mem_rec(struct xfs_btree_cur *rmcur, struct xfs_rmap_irec *irec);
+
 #endif /* RMAP_H_ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 01f92e841f29..ba78dc0b8eae 100644
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

