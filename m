Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20411 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757389AbcLCBkm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:40:42 -0500
Subject: [PATCH 49/55] xfs: rebuild the rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:40:38 -0800
Message-ID: <148072923833.12995.15351600662054473479.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Rebuild the reverse mapping btree from all primary metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount.c |    2 
 fs/xfs/libxfs/xfs_refcount.h |    3 
 fs/xfs/libxfs/xfs_rmap.c     |   28 ++
 fs/xfs/libxfs/xfs_rmap.h     |    1 
 fs/xfs/repair/common.c       |   82 +++++
 fs/xfs/repair/common.h       |    4 
 fs/xfs/repair/rmap.c         |  721 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 839 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index c6c875d..f63cfdb 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -88,7 +88,7 @@ xfs_refcount_lookup_ge(
 }
 
 /* Convert on-disk record to in-core format. */
-static inline void
+void
 xfs_refcount_btrec_to_irec(
 	union xfs_btree_rec		*rec,
 	struct xfs_refcount_irec	*irec)
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 78cb142..5973c56 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -69,5 +69,8 @@ extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
 
 extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+union xfs_btree_rec;
+extern void xfs_refcount_btrec_to_irec(union xfs_btree_rec *rec,
+		struct xfs_refcount_irec *irec);
 
 #endif	/* __XFS_REFCOUNT_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index e61d816..8531cbc 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1977,6 +1977,34 @@ xfs_rmap_map_shared(
 	return error;
 }
 
+/* Insert a raw rmap into the rmapbt. */
+int
+xfs_rmap_map_raw(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rmap)
+{
+	struct xfs_owner_info	oinfo;
+
+	oinfo.oi_owner = rmap->rm_owner;
+	oinfo.oi_offset = rmap->rm_offset;
+	oinfo.oi_flags = 0;
+	if (rmap->rm_flags & XFS_RMAP_ATTR_FORK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
+	if (rmap->rm_flags & XFS_RMAP_BMBT_BLOCK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
+
+	if (rmap->rm_flags || XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
+		return xfs_rmap_map(cur, rmap->rm_startblock,
+				rmap->rm_blockcount,
+				rmap->rm_flags & XFS_RMAP_UNWRITTEN,
+				&oinfo);
+
+	return xfs_rmap_map_shared(cur, rmap->rm_startblock,
+			rmap->rm_blockcount,
+			rmap->rm_flags & XFS_RMAP_UNWRITTEN,
+			&oinfo);
+}
+
 struct xfs_rmap_query_range_info {
 	xfs_rmap_query_range_fn	fn;
 	void				*priv;
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 606efe3..eac90d7 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -225,5 +225,6 @@ int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		xfs_filblks_t len, struct xfs_owner_info *oinfo,
 		bool *has_rmap);
+int xfs_rmap_map_raw(struct xfs_btree_cur *cur, struct xfs_rmap_irec *rmap);
 
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index 630ec8f..9ea9d86 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -644,6 +644,7 @@ xfs_scrub_teardown(
 	int				error)
 {
 	struct xfs_mount		*mp = sc->tp->t_mountp;
+	int				err2;
 
 	xfs_scrub_ag_free(&sc->sa);
 	if (sc->ag_lock.agmask != sc->ag_lock.__agmask)
@@ -654,6 +655,13 @@ xfs_scrub_teardown(
 	else
 		xfs_trans_cancel(sc->tp);
 	sc->tp = NULL;
+
+	if (sc->teardown) {
+		err2 = sc->teardown(sc, ip_in, error);
+		if (!error && err2)
+			error = err2;
+	}
+
 	if (sc->ip != NULL) {
 		xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
 		xfs_iunlock(sc->ip, XFS_IOLOCK_EXCL);
@@ -787,6 +795,78 @@ xfs_scrub_setup_ag_header(
 	return error;
 }
 
+/* Unfreeze the FS. */
+STATIC int
+xfs_scrub_teardown_thaw(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	int				error)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct super_block		*sb = mp->m_super;
+	int				err2;
+
+	/* Re-freeze the last level of filesystem. */
+	down_write(&sb->s_umount);
+	percpu_down_write(sb->s_writers.rw_sem + SB_FREEZE_PAGEFAULT);
+	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
+	up_write(&sb->s_umount);
+	err2 = thaw_super(sb);
+	if (!error && err2)
+		error = err2;
+
+	return error;
+}
+
+/* Set us up with AG headers and btree cursors, and freeze the FS. */
+STATIC int
+xfs_scrub_setup_ag_header_freeze(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct super_block		*sb = mp->m_super;
+	int				error;
+
+	if (!(sm->sm_flags & XFS_SCRUB_FLAG_REPAIR))
+		return xfs_scrub_setup_ag_header(sc, ip, sm, retry_deadlocked);
+
+	/* Freeze out any further writes or page faults. */
+	error = freeze_super(sb);
+	if (error)
+		return error;
+
+	/* Thaw it to the point that we can make transactions. */
+	down_write(&sb->s_umount);
+	percpu_up_write(sb->s_writers.rw_sem + SB_FREEZE_PAGEFAULT);
+	sb->s_writers.frozen = SB_FREEZE_FS;
+	up_write(&sb->s_umount);
+
+	/* Check the AG number and set up the scrub context. */
+	error = xfs_scrub_setup_ag(sc, ip, sm, retry_deadlocked);
+	if (error)
+		return xfs_scrub_teardown_thaw(sc, ip, error);
+
+	/* Lock all the AG header buffers. */
+	sc->teardown = xfs_scrub_teardown_thaw;
+	xfs_scrub_ag_lock_init(mp, &sc->ag_lock);
+	error = xfs_scrub_ag_lock_all(sc);
+	if (error)
+		return error;
+
+	/* Now grab the headers of the AGF we want. */
+	sc->sa.agno = sm->sm_agno;
+	error = xfs_scrub_ag_read_headers(sc, sm->sm_agno, &sc->sa.agi_bp,
+			&sc->sa.agf_bp, &sc->sa.agfl_bp);
+	if (error)
+		return error;
+
+	/* ...and initialize the btree cursors for xref. */
+	return xfs_scrub_ag_btcur_init(sc, &sc->sa);
+}
+
 /*
  * Given an inode and the scrub control structure, return either the
  * inode referenced in the control structure or the inode passed in.
@@ -1010,7 +1090,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag_header, xfs_scrub_cntbt, xfs_repair_allocbt, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_inobt, xfs_repair_iallocbt, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_finobt, xfs_repair_iallocbt, xfs_sb_version_hasfinobt},
-	{xfs_scrub_setup_ag_header, xfs_scrub_rmapbt, NULL, xfs_sb_version_hasrmapbt},
+	{xfs_scrub_setup_ag_header_freeze, xfs_scrub_rmapbt, xfs_repair_rmapbt, xfs_sb_version_hasrmapbt},
 	{xfs_scrub_setup_ag_header, xfs_scrub_refcountbt, NULL, xfs_sb_version_hasreflink},
 	{xfs_scrub_setup_inode_raw, xfs_scrub_inode, NULL, NULL},
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_data, NULL, NULL},
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index ec83c3e..cccf796 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -67,6 +67,9 @@ struct xfs_scrub_context {
 
 	/* State tracking for single-AG operations. */
 	struct xfs_scrub_ag		sa;
+
+	int				(*teardown)(struct xfs_scrub_context *,
+						    struct xfs_inode *, int);
 };
 
 /* Should we end the scrub early? */
@@ -286,5 +289,6 @@ int xfs_repair_agfl(struct xfs_scrub_context *sc);
 int xfs_repair_agi(struct xfs_scrub_context *sc);
 int xfs_repair_allocbt(struct xfs_scrub_context *sc);
 int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
+int xfs_repair_rmapbt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/repair/rmap.c b/fs/xfs/repair/rmap.c
index fa2fa3b..6793834 100644
--- a/fs/xfs/repair/rmap.c
+++ b/fs/xfs/repair/rmap.c
@@ -30,10 +30,18 @@
 #include "xfs_trans.h"
 #include "xfs_trace.h"
 #include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
 #include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
 #include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
 #include "repair/common.h"
 #include "repair/btree.h"
 
@@ -219,3 +227,716 @@ xfs_scrub_rmapbt(
 	return xfs_scrub_btree(sc, sc->sa.rmap_cur, xfs_scrub_rmapbt_helper,
 			&oinfo, NULL);
 }
+
+/* Reverse-mapping repair. */
+
+struct xfs_repair_rmapbt_extent {
+	struct list_head		list;
+	struct xfs_rmap_irec		rmap;
+};
+
+struct xfs_repair_rmapbt {
+	struct list_head		rmaplist;
+	struct list_head		rmap_freelist;
+	struct list_head		bno_freelist;
+	struct xfs_scrub_context	*sc;
+	uint64_t			owner;
+	xfs_extlen_t			btblocks;
+	xfs_agblock_t			next_bno;
+	uint64_t			nr_records;
+};
+
+/* Initialize an rmap. */
+static inline int
+xfs_repair_rmapbt_new_rmap(
+	struct xfs_repair_rmapbt	*rr,
+	xfs_agblock_t			startblock,
+	xfs_extlen_t			blockcount,
+	__uint64_t			owner,
+	__uint64_t			offset,
+	unsigned int			flags)
+{
+	struct xfs_repair_rmapbt_extent	*rre;
+	int				error = 0;
+
+	trace_xfs_repair_rmap_extent_fn(rr->sc->tp->t_mountp, rr->sc->sa.agno,
+			startblock, blockcount, owner, offset, flags);
+
+	if (xfs_scrub_should_terminate(&error))
+		return error;
+
+	rre = kmem_alloc(sizeof(*rre), KM_NOFS);
+	if (!rre)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&rre->list);
+	rre->rmap.rm_startblock = startblock;
+	rre->rmap.rm_blockcount = blockcount;
+	rre->rmap.rm_owner = owner;
+	rre->rmap.rm_offset = offset;
+	rre->rmap.rm_flags = flags;
+	list_add_tail(&rre->list, &rr->rmaplist);
+	rr->nr_records++;
+
+	return 0;
+}
+
+/* Add an AGFL block to the rmap list. */
+STATIC int
+xfs_repair_rmapbt_walk_agfl(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			bno,
+	void				*priv)
+{
+	struct xfs_repair_rmapbt	*rr = priv;
+
+	return xfs_repair_rmapbt_new_rmap(rr, bno, 1, XFS_RMAP_OWN_AG, 0, 0);
+}
+
+/* Add a btree block to the rmap list. */
+STATIC int
+xfs_repair_rmapbt_visit_btblock(
+	struct xfs_btree_cur		*cur,
+	int				level,
+	void				*priv)
+{
+	struct xfs_repair_rmapbt	*rr = priv;
+	struct xfs_buf			*bp;
+	xfs_fsblock_t			fsb;
+
+	xfs_btree_get_block(cur, level, &bp);
+	if (!bp)
+		return 0;
+
+	rr->btblocks++;
+	fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+	return xfs_repair_rmapbt_new_rmap(rr, XFS_FSB_TO_AGBNO(cur->bc_mp, fsb),
+			1, rr->owner, 0, 0);
+}
+
+/* Record inode btree rmaps. */
+STATIC int
+xfs_repair_rmapbt_inodes(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct xfs_inobt_rec_incore	irec;
+	struct xfs_repair_rmapbt	*rr = priv;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_buf			*bp;
+	xfs_fsblock_t			fsb;
+	xfs_agino_t			agino;
+	xfs_agino_t			iperhole;
+	unsigned int			i;
+	int				error;
+
+	/* Record the inobt blocks */
+	for (i = 0; i < cur->bc_nlevels && cur->bc_ptrs[i] == 1; i++) {
+		xfs_btree_get_block(cur, i, &bp);
+		if (!bp)
+			continue;
+		fsb = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+		error = xfs_repair_rmapbt_new_rmap(rr,
+				XFS_FSB_TO_AGBNO(mp, fsb), 1,
+				XFS_RMAP_OWN_INOBT, 0, 0);
+		if (error)
+			return error;
+	}
+
+	xfs_inobt_btrec_to_irec(mp, rec, &irec);
+
+	/* Record a non-sparse inode chunk. */
+	if (irec.ir_holemask == XFS_INOBT_HOLEMASK_FULL)
+		return xfs_repair_rmapbt_new_rmap(rr,
+				XFS_AGINO_TO_AGBNO(mp, irec.ir_startino),
+				XFS_INODES_PER_CHUNK / mp->m_sb.sb_inopblock,
+				XFS_RMAP_OWN_INODES, 0, 0);
+
+	/* Iterate each chunk. */
+	iperhole = max_t(xfs_agino_t, mp->m_sb.sb_inopblock,
+			XFS_INODES_PER_HOLEMASK_BIT);
+	for (i = 0, agino = irec.ir_startino;
+	     i < XFS_INOBT_HOLEMASK_BITS;
+	     i += iperhole / XFS_INODES_PER_HOLEMASK_BIT, agino += iperhole) {
+		/* Skip holes. */
+		if (irec.ir_holemask & (1 << i))
+			continue;
+
+		/* Record the inode chunk otherwise. */
+		error = xfs_repair_rmapbt_new_rmap(rr,
+				XFS_AGINO_TO_AGBNO(mp, agino),
+				iperhole / mp->m_sb.sb_inopblock,
+				XFS_RMAP_OWN_INODES, 0, 0);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Record a CoW staging extent. */
+STATIC int
+xfs_repair_rmapbt_refcount(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct xfs_repair_rmapbt	*rr = priv;
+	struct xfs_refcount_irec	refc;
+
+	xfs_refcount_btrec_to_irec(rec, &refc);
+	if (refc.rc_refcount != 1)
+		return -EFSCORRUPTED;
+
+	return xfs_repair_rmapbt_new_rmap(rr,
+			refc.rc_startblock - XFS_REFC_COW_START,
+			refc.rc_blockcount, XFS_RMAP_OWN_COW, 0, 0);
+}
+
+/* Add a bmbt block to the rmap list. */
+STATIC int
+xfs_repair_rmapbt_visit_bmbt(
+	struct xfs_btree_cur		*cur,
+	int				level,
+	void				*priv)
+{
+	struct xfs_repair_rmapbt	*rr = priv;
+	struct xfs_buf			*bp;
+	xfs_fsblock_t			fsb;
+	unsigned int			flags = XFS_RMAP_BMBT_BLOCK;
+
+	xfs_btree_get_block(cur, level, &bp);
+	if (!bp)
+		return 0;
+
+	fsb = XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
+	if (XFS_FSB_TO_AGNO(cur->bc_mp, fsb) != rr->sc->sa.agno)
+		return 0;
+
+	if (cur->bc_private.b.whichfork == XFS_ATTR_FORK)
+		flags |= XFS_RMAP_ATTR_FORK;
+	return xfs_repair_rmapbt_new_rmap(rr,
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsb), 1,
+			cur->bc_private.b.ip->i_ino, 0, flags);
+}
+
+/* Determine rmap flags from fork and bmbt state. */
+static inline unsigned int
+xfs_repair_rmapbt_bmap_flags(
+	int			whichfork,
+	xfs_exntst_t		state)
+{
+	return  (whichfork == XFS_ATTR_FORK ? XFS_RMAP_ATTR_FORK : 0) |
+		(state == XFS_EXT_UNWRITTEN ? XFS_RMAP_UNWRITTEN : 0);
+}
+
+/* Find all the extents from a given AG in an inode fork. */
+STATIC int
+xfs_repair_rmapbt_scan_ifork(
+	struct xfs_repair_rmapbt	*rr,
+	struct xfs_inode		*ip,
+	int				whichfork)
+{
+	struct xfs_bmbt_irec		rec;
+	struct xfs_mount		*mp = rr->sc->tp->t_mountp;
+	struct xfs_btree_cur		*cur = NULL;
+	xfs_fileoff_t			off;
+	xfs_fileoff_t			endoff;
+	unsigned int			bflags;
+	unsigned int			rflags;
+	int				nmaps;
+	int				fmt;
+	int				error;
+
+	/* Do we even have data mapping extents? */
+	fmt = XFS_IFORK_FORMAT(ip, whichfork);
+	switch (fmt) {
+	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_EXTENTS:
+		break;
+	default:
+		return 0;
+	}
+	if (!XFS_IFORK_PTR(ip, whichfork))
+		return 0;
+
+	/* Find all the BMBT blocks in the AG. */
+	if (fmt == XFS_DINODE_FMT_BTREE) {
+		cur = xfs_bmbt_init_cursor(mp, rr->sc->tp, ip, whichfork);
+		error = xfs_btree_visit_blocks(cur,
+				xfs_repair_rmapbt_visit_bmbt, rr);
+		if (error)
+			goto out;
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		cur = NULL;
+	}
+
+	/* We're done if this is an rt inode's data fork. */
+	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip))
+		return 0;
+
+	/* Find the offset of the last extent in the mapping. */
+	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
+	if (error)
+		goto out;
+
+	/* Find all the extents in the AG. */
+	bflags = whichfork == XFS_ATTR_FORK ? XFS_BMAPI_ATTRFORK : 0;
+	off = 0;
+	while (true) {
+		nmaps = 1;
+		error = xfs_bmapi_read(ip, off, endoff - off, &rec,
+				&nmaps, bflags);
+		if (error || nmaps == 0)
+			break;
+		/* Stash non-hole extent. */
+		if (rec.br_startblock != HOLESTARTBLOCK &&
+		    rec.br_startblock != DELAYSTARTBLOCK &&
+		    XFS_FSB_TO_AGNO(mp, rec.br_startblock) == rr->sc->sa.agno) {
+			rflags = xfs_repair_rmapbt_bmap_flags(whichfork,
+					rec.br_state);
+			error = xfs_repair_rmapbt_new_rmap(rr,
+					XFS_FSB_TO_AGBNO(mp, rec.br_startblock),
+					rec.br_blockcount, ip->i_ino,
+					rec.br_startoff, rflags);
+			if (error)
+				goto out;
+		}
+
+		off += rec.br_blockcount;
+	}
+out:
+	if (cur)
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/* Iterate all the inodes in an AG group. */
+STATIC int
+xfs_repair_rmapbt_scan_inobt(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct xfs_inobt_rec_incore	irec;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_inode		*ip = NULL;
+	xfs_ino_t			ino;
+	xfs_agino_t			agino;
+	int				chunkidx;
+	int				error;
+
+	xfs_inobt_btrec_to_irec(mp, rec, &irec);
+
+	for (chunkidx = 0, agino = irec.ir_startino;
+	     chunkidx < XFS_INODES_PER_CHUNK;
+	     chunkidx++, agino++) {
+		/* Skip if this inode is free */
+		if (XFS_INOBT_MASK(chunkidx) & irec.ir_free)
+			continue;
+		ino = XFS_AGINO_TO_INO(mp, cur->bc_private.a.agno, agino);
+		error = xfs_iget(mp, cur->bc_tp, ino, 0, XFS_ILOCK_EXCL, &ip);
+		if (error)
+			break;
+
+		/* Check the data fork. */
+		error = xfs_repair_rmapbt_scan_ifork(priv, ip, XFS_DATA_FORK);
+		if (error)
+			break;
+
+		/* Check the attr fork. */
+		error = xfs_repair_rmapbt_scan_ifork(priv, ip, XFS_ATTR_FORK);
+		if (error)
+			break;
+
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		IRELE(ip);
+		ip = NULL;
+	}
+
+	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		IRELE(ip);
+	}
+	return error;
+}
+
+/* Record extents that aren't in use from gaps in the rmap records. */
+STATIC int
+xfs_repair_rmapbt_record_rmap_freesp(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_repair_rmapbt	*rr = priv;
+	xfs_fsblock_t			fsb;
+	int				error;
+
+	/* Record the free space we find. */
+	if (rec->rm_startblock > rr->next_bno) {
+		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				rr->next_bno);
+		error = xfs_repair_collect_btree_extent(cur->bc_mp,
+				&rr->rmap_freelist, fsb,
+				rec->rm_startblock - rr->next_bno);
+		if (error)
+			return error;
+	}
+	rr->next_bno = max_t(xfs_agblock_t, rr->next_bno,
+			rec->rm_startblock + rec->rm_blockcount);
+	return 0;
+}
+
+/* Record extents that aren't in use from the bnobt records. */
+STATIC int
+xfs_repair_rmapbt_record_bno_freesp(
+	struct xfs_btree_cur		*cur,
+	struct xfs_alloc_rec_incore	*rec,
+	void				*priv)
+{
+	struct xfs_repair_rmapbt	*rr = priv;
+	xfs_fsblock_t			fsb;
+
+	/* Record the free space we find. */
+	fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+			rec->ar_startblock);
+	return xfs_repair_collect_btree_extent(cur->bc_mp, &rr->bno_freelist,
+			fsb, rec->ar_blockcount);
+}
+
+/* Compare two rmapbt extents. */
+static int
+xfs_repair_rmapbt_extent_cmp(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_repair_rmapbt_extent	*ap;
+	struct xfs_repair_rmapbt_extent	*bp;
+	__u64				oa;
+	__u64				ob;
+
+	ap = container_of(a, struct xfs_repair_rmapbt_extent, list);
+	bp = container_of(b, struct xfs_repair_rmapbt_extent, list);
+	oa = xfs_rmap_irec_offset_pack(&ap->rmap);
+	ob = xfs_rmap_irec_offset_pack(&bp->rmap);
+
+	if (ap->rmap.rm_startblock > bp->rmap.rm_startblock)
+		return 1;
+	else if (ap->rmap.rm_startblock < bp->rmap.rm_startblock)
+		return -1;
+	else if (ap->rmap.rm_owner > bp->rmap.rm_owner)
+		return 1;
+	else if (ap->rmap.rm_owner < bp->rmap.rm_owner)
+		return -1;
+	else if (oa > ob)
+		return 1;
+	else if (oa < ob)
+		return -1;
+	return 0;
+}
+
+#define RMAP(type, startblock, blockcount) xfs_repair_rmapbt_new_rmap( \
+		&rr, (startblock), (blockcount), \
+		XFS_RMAP_OWN_##type, 0, 0)
+/* Repair the rmap btree for some AG. */
+int
+xfs_repair_rmapbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_repair_rmapbt	rr;
+	struct xfs_owner_info		oinfo;
+	struct xfs_repair_rmapbt_extent	*rre;
+	struct xfs_repair_rmapbt_extent	*n;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_btree_cur		*cur = NULL;
+	struct xfs_buf			*bp = NULL;
+	struct xfs_agf			*agf;
+	struct xfs_agi			*agi;
+	struct xfs_perag		*pag;
+	xfs_fsblock_t			btfsb;
+	xfs_agnumber_t			ag;
+	xfs_agblock_t			agend;
+	xfs_extlen_t			freesp_btblocks;
+	int				error;
+
+	INIT_LIST_HEAD(&rr.rmaplist);
+	INIT_LIST_HEAD(&rr.rmap_freelist);
+	INIT_LIST_HEAD(&rr.bno_freelist);
+	rr.sc = sc;
+	rr.nr_records = 0;
+
+	/* Collect rmaps for all AG headers. */
+	error = RMAP(FS, XFS_SB_BLOCK(mp), 1);
+	if (error)
+		goto out;
+	rre = list_last_entry(&rr.rmaplist, struct xfs_repair_rmapbt_extent,
+			list);
+
+	if (rre->rmap.rm_startblock != XFS_AGF_BLOCK(mp)) {
+		error = RMAP(FS, XFS_AGF_BLOCK(mp), 1);
+		if (error)
+			goto out;
+		rre = list_last_entry(&rr.rmaplist,
+				struct xfs_repair_rmapbt_extent, list);
+	}
+
+	if (rre->rmap.rm_startblock != XFS_AGI_BLOCK(mp)) {
+		error = RMAP(FS, XFS_AGI_BLOCK(mp), 1);
+		if (error)
+			goto out;
+		rre = list_last_entry(&rr.rmaplist,
+				struct xfs_repair_rmapbt_extent, list);
+	}
+
+	if (rre->rmap.rm_startblock != XFS_AGFL_BLOCK(mp)) {
+		error = RMAP(FS, XFS_AGFL_BLOCK(mp), 1);
+		if (error)
+			goto out;
+	}
+
+	error = xfs_scrub_walk_agfl(sc, xfs_repair_rmapbt_walk_agfl, &rr);
+	if (error)
+		goto out;
+
+	/* Collect rmap for the log if it's in this AG. */
+	if (mp->m_sb.sb_logstart &&
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == sc->sa.agno) {
+		error = RMAP(LOG, XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart),
+				mp->m_sb.sb_logblocks);
+		if (error)
+			goto out;
+	}
+
+	/* Collect rmaps for the free space btrees. */
+	rr.owner = XFS_RMAP_OWN_AG;
+	rr.btblocks = 0;
+	cur = xfs_allocbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno,
+			XFS_BTNUM_BNO);
+	error = xfs_btree_visit_blocks(cur, xfs_repair_rmapbt_visit_btblock,
+			&rr);
+	if (error)
+		goto out;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	cur = NULL;
+
+	/* Collect rmaps for the cntbt. */
+	cur = xfs_allocbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno,
+			XFS_BTNUM_CNT);
+	error = xfs_btree_visit_blocks(cur, xfs_repair_rmapbt_visit_btblock,
+			&rr);
+	if (error)
+		goto out;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	cur = NULL;
+	freesp_btblocks = rr.btblocks;
+
+	/* Collect rmaps for the inode btree. */
+	cur = xfs_inobt_init_cursor(mp, sc->tp, sc->sa.agi_bp, sc->sa.agno,
+			XFS_BTNUM_INO);
+	error = xfs_btree_query_all(cur, xfs_repair_rmapbt_inodes, &rr);
+	if (error)
+		goto out;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	/* If there are no inodes, we have to include the inobt root. */
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	if (agi->agi_count == cpu_to_be32(0)) {
+		error = xfs_repair_rmapbt_new_rmap(&rr,
+				be32_to_cpu(agi->agi_root), 1,
+				XFS_RMAP_OWN_INOBT, 0, 0);
+		if (error)
+			goto out;
+	}
+
+	/* Collect rmaps for the free inode btree. */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		rr.owner = XFS_RMAP_OWN_INOBT;
+		cur = xfs_inobt_init_cursor(mp, sc->tp, sc->sa.agi_bp,
+				sc->sa.agno, XFS_BTNUM_FINO);
+		error = xfs_btree_visit_blocks(cur,
+				xfs_repair_rmapbt_visit_btblock, &rr);
+		if (error)
+			goto out;
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		cur = NULL;
+	}
+
+	/* Collect rmaps for the refcount btree. */
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		union xfs_btree_irec		low;
+		union xfs_btree_irec		high;
+
+		rr.owner = XFS_RMAP_OWN_REFC;
+		cur = xfs_refcountbt_init_cursor(mp, sc->tp, sc->sa.agf_bp,
+				sc->sa.agno, NULL);
+		error = xfs_btree_visit_blocks(cur,
+				xfs_repair_rmapbt_visit_btblock, &rr);
+		if (error)
+			goto out;
+
+		/* Collect rmaps for CoW staging extents. */
+		memset(&low, 0, sizeof(low));
+		low.rc.rc_startblock = XFS_REFC_COW_START;
+		memset(&high, 0xFF, sizeof(high));
+		error = xfs_btree_query_range(cur, &low, &high,
+				xfs_repair_rmapbt_refcount, &rr);
+		if (error)
+			goto out;
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		cur = NULL;
+	}
+
+	/* Iterate all AGs for inodes. */
+	for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
+		ASSERT(xfs_scrub_ag_can_lock(sc, ag));
+		error = xfs_ialloc_read_agi(mp, sc->tp, ag, &bp);
+		if (error)
+			goto out;
+		cur = xfs_inobt_init_cursor(mp, sc->tp, bp, ag, XFS_BTNUM_INO);
+		error = xfs_btree_query_all(cur, xfs_repair_rmapbt_scan_inobt,
+				&rr);
+		if (error)
+			goto out;
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		cur = NULL;
+		xfs_trans_brelse(sc->tp, bp);
+		bp = NULL;
+	}
+
+	/* Do we actually have enough space to do this? */
+	pag = xfs_perag_get(mp, sc->sa.agno);
+	if (!xfs_repair_ag_has_space(pag,
+			xfs_rmapbt_calc_size(mp, rr.nr_records),
+			XFS_AG_RESV_AGFL)) {
+		xfs_perag_put(pag);
+		error = -ENOSPC;
+		goto out;
+	}
+
+	/* Initialize a new rmapbt root. */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_UNKNOWN);
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	error = xfs_repair_alloc_ag_block(sc, &oinfo, &btfsb, XFS_AG_RESV_AGFL);
+	if (error) {
+		xfs_perag_put(pag);
+		goto out;
+	}
+	error = xfs_repair_init_btblock(sc, btfsb, &bp, XFS_RMAP_CRC_MAGIC,
+			&xfs_rmapbt_buf_ops);
+	if (error) {
+		xfs_perag_put(pag);
+		goto out;
+	}
+	agf->agf_roots[XFS_BTNUM_RMAPi] = cpu_to_be32(XFS_FSB_TO_AGBNO(mp,
+			btfsb));
+	agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
+	agf->agf_rmap_blocks = cpu_to_be32(1);
+
+	/* Reset the perag info. */
+	pag->pagf_btreeblks = freesp_btblocks - 2;
+	pag->pagf_levels[XFS_BTNUM_RMAPi] =
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
+
+	/* Now reset the AGF counters. */
+	agf->agf_btreeblks = cpu_to_be32(pag->pagf_btreeblks);
+	xfs_perag_put(pag);
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, XFS_AGF_ROOTS |
+			XFS_AGF_LEVELS | XFS_AGF_RMAP_BLOCKS |
+			XFS_AGF_BTREEBLKS);
+	bp = NULL;
+	error = xfs_repair_roll_ag_trans(sc);
+	if (error)
+		goto out;
+
+	/* Insert all the metadata rmaps. */
+	list_sort(NULL, &rr.rmaplist, xfs_repair_rmapbt_extent_cmp);
+	list_for_each_entry_safe(rre, n, &rr.rmaplist, list) {
+		/*
+		 * Ensure the freelist is full, but don't let it shrink.
+		 * The rmapbt isn't fully set up yet, which means that
+		 * the current AGFL blocks might not be reflected in the
+		 * rmapbt, which is a problem if we want to unmap blocks
+		 * from the AGFL.
+		 */
+		error = xfs_repair_fix_freelist(sc, false);
+		if (error)
+			goto out;
+
+		/* Add the rmap. */
+		cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp,
+				sc->sa.agno);
+		error = xfs_rmap_map_raw(cur, &rre->rmap);
+		if (error)
+			goto out;
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		cur = NULL;
+
+		error = xfs_repair_roll_ag_trans(sc);
+		if (error)
+			goto out;
+
+		list_del(&rre->list);
+		kmem_free(rre);
+	}
+
+	/* Compute free space from the new rmapbt. */
+	rr.next_bno = 0;
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xfs_repair_rmapbt_record_rmap_freesp,
+			&rr);
+	if (error)
+		goto out;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	cur = NULL;
+
+	/* Insert a record for space between the last rmap and EOAG. */
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	agend = be32_to_cpu(agf->agf_length);
+	if (rr.next_bno < agend) {
+		btfsb = XFS_AGB_TO_FSB(mp, sc->sa.agno, rr.next_bno);
+		error = xfs_repair_collect_btree_extent(mp, &rr.rmap_freelist,
+				btfsb, agend - rr.next_bno);
+		if (error)
+			goto out;
+	}
+
+	/* Compute free space from the existing bnobt. */
+	cur = xfs_allocbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno,
+			XFS_BTNUM_BNO);
+	error = xfs_alloc_query_all(cur, xfs_repair_rmapbt_record_bno_freesp,
+			&rr);
+	if (error)
+		goto out;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	cur = NULL;
+
+	/*
+	 * Free the "free" blocks that the new rmapbt knows about but
+	 * the old bnobt doesn't.  These are the old rmapbt blocks.
+	 */
+	error = xfs_repair_subtract_extents(mp, &rr.rmap_freelist,
+			&rr.bno_freelist);
+	if (error)
+		goto out;
+	xfs_repair_cancel_btree_extents(sc, &rr.bno_freelist);
+	error = xfs_repair_reap_btree_extents(sc, &rr.rmap_freelist, &oinfo,
+			XFS_AG_RESV_AGFL);
+	if (error)
+		goto out;
+
+	return 0;
+out:
+	if (cur)
+		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	if (bp)
+		xfs_trans_brelse(sc->tp, bp);
+	xfs_repair_cancel_btree_extents(sc, &rr.bno_freelist);
+	xfs_repair_cancel_btree_extents(sc, &rr.rmap_freelist);
+	list_for_each_entry_safe(rre, n, &rr.rmaplist, list) {
+		list_del(&rre->list);
+		kmem_free(rre);
+	}
+	return error;
+}
+#undef RMAP

