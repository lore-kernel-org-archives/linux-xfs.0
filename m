Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44026 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751933AbeFXTYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:24:41 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJOfD8188599
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:41 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2jt7narhfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:40 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJOeak015089
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:40 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJOeIE031795
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:40 GMT
Subject: [PATCH 11/21] xfs: repair the rmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:24:38 -0700
Message-ID: <152986827881.3155.10096839660329617215.stgit@magnolia>
In-Reply-To: <152986820984.3155.16417868536016544528.stgit@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rebuild the reverse mapping btree from all primary metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/scrub/repair.h      |   11 
 fs/xfs/scrub/rmap.c        |    6 
 fs/xfs/scrub/rmap_repair.c | 1036 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c       |    2 
 5 files changed, 1054 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/rmap_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 837fd4a95f6f..c71c5deef4c9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -167,6 +167,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   alloc_repair.o \
 				   ialloc_repair.o \
 				   repair.o \
+				   rmap_repair.o \
 				   )
 endif
 endif
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 1cdf457e41da..3d9e064147ec 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -96,6 +96,7 @@ int xfs_repair_find_ag_btree_roots(struct xfs_scrub_context *sc,
 void xfs_repair_force_quotacheck(struct xfs_scrub_context *sc, uint dqtype);
 int xfs_repair_ino_dqattach(struct xfs_scrub_context *sc);
 int xfs_repair_grab_all_ag_headers(struct xfs_scrub_context *sc);
+int xfs_repair_rmapbt_setup(struct xfs_scrub_context *sc, struct xfs_inode *ip);
 
 /* Metadata repairers */
 
@@ -106,6 +107,7 @@ int xfs_repair_agfl(struct xfs_scrub_context *sc);
 int xfs_repair_agi(struct xfs_scrub_context *sc);
 int xfs_repair_allocbt(struct xfs_scrub_context *sc);
 int xfs_repair_iallocbt(struct xfs_scrub_context *sc);
+int xfs_repair_rmapbt(struct xfs_scrub_context *sc);
 
 #else
 
@@ -127,6 +129,14 @@ xfs_repair_calc_ag_resblks(
 	return 0;
 }
 
+static inline int xfs_repair_rmapbt_setup(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	/* We don't support rmap repair, but we can still do a scan. */
+	return xfs_scrub_setup_ag_btree(sc, ip, false);
+}
+
 #define xfs_repair_probe		xfs_repair_notsupported
 #define xfs_repair_superblock		xfs_repair_notsupported
 #define xfs_repair_agf			xfs_repair_notsupported
@@ -134,6 +144,7 @@ xfs_repair_calc_ag_resblks(
 #define xfs_repair_agi			xfs_repair_notsupported
 #define xfs_repair_allocbt		xfs_repair_notsupported
 #define xfs_repair_iallocbt		xfs_repair_notsupported
+#define xfs_repair_rmapbt		xfs_repair_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index c6d763236ba7..dd1cccfbb31a 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -24,6 +24,7 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /*
  * Set us up to scrub reverse mapping btrees.
@@ -33,7 +34,10 @@ xfs_scrub_setup_ag_rmapbt(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	return xfs_scrub_setup_ag_btree(sc, ip, false);
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+		return xfs_repair_rmapbt_setup(sc, ip);
+	else
+		return xfs_scrub_setup_ag_btree(sc, ip, false);
 }
 
 /* Reverse-mapping scrubber. */
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
new file mode 100644
index 000000000000..2ade606060c8
--- /dev/null
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -0,0 +1,1036 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * Reverse Mapping Btree Repair
+ * ============================
+ *
+ * This is the most involved of all the AG space btree rebuilds.  Everywhere
+ * else in XFS we lock inodes and then AG data structures, but generating the
+ * list of rmap records requires that we be able to scan both block mapping
+ * btrees of every inode in the filesystem to see if it owns any extents in
+ * this AG.  We can't tolerate any inode updates while we do this, so we
+ * freeze the filesystem to lock everyone else out, and grant ourselves
+ * special privileges to run transactions with regular background reclamation
+ * turned off.
+ *
+ * We also have to be very careful not to allow inode reclaim to start a
+ * transaction because all transactions (other than our own) will block.
+ *
+ * So basically we scan all primary per-AG metadata and all block maps of all
+ * inodes to generate a huge list of reverse map records.  Next we look for
+ * gaps in the rmap records to calculate all the unclaimed free space (1).
+ * Next, we scan all other OWN_AG metadata (bnobt, cntbt, agfl) and subtract
+ * the space used by those btrees from (1), and also subtract the free space
+ * listed in the bnobt from (1).  What's left are the gaps in assigned space
+ * that the new rmapbt knows about but the existing bnobt doesn't; these are
+ * the blocks from the old rmapbt and they can be freed.
+ */
+
+/* Set us up to repair reverse mapping btrees. */
+int
+xfs_repair_rmapbt_setup(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	int				error;
+
+	/*
+	 * Freeze out anything that can lock an inode.  We reconstruct
+	 * the rmapbt by reading inode bmaps with the AGF held, which is
+	 * only safe w.r.t. ABBA deadlocks if we're the only ones locking
+	 * inodes.
+	 */
+	error = xfs_scrub_fs_freeze(sc);
+	if (error)
+		return error;
+
+	/* Check the AG number and set up the scrub context. */
+	error = xfs_scrub_setup_fs(sc, ip);
+	if (error)
+		return error;
+
+	/*
+	 * Lock all the AG header buffers so that we can read all the
+	 * per-AG metadata too.
+	 */
+	error = xfs_repair_grab_all_ag_headers(sc);
+	if (error)
+		return error;
+
+	return xfs_scrub_ag_init(sc, sc->sm->sm_agno, &sc->sa);
+}
+
+struct xfs_repair_rmapbt_extent {
+	struct list_head		list;
+	struct xfs_rmap_irec		rmap;
+};
+
+/* Context for collecting rmaps */
+struct xfs_repair_rmapbt {
+	struct list_head		*rmaplist;
+	struct xfs_scrub_context	*sc;
+	uint64_t			owner;
+	xfs_agblock_t			btblocks;
+	uint64_t			nr_records;
+};
+
+/* Context for calculating old rmapbt blocks */
+struct xfs_repair_rmapbt_freesp {
+	struct xfs_repair_extent_list	rmap_freelist;
+	struct xfs_repair_extent_list	bno_freelist;
+	struct xfs_scrub_context	*sc;
+	xfs_agblock_t			next_bno;
+};
+
+/* Initialize an rmap. */
+static inline int
+xfs_repair_rmapbt_new_rmap(
+	struct xfs_repair_rmapbt	*rr,
+	xfs_agblock_t			startblock,
+	xfs_extlen_t			blockcount,
+	uint64_t			owner,
+	uint64_t			offset,
+	unsigned int			flags)
+{
+	struct xfs_repair_rmapbt_extent	*rre;
+	int				error = 0;
+
+	trace_xfs_repair_rmap_extent_fn(rr->sc->mp, rr->sc->sa.agno,
+			startblock, blockcount, owner, offset, flags);
+
+	if (xfs_scrub_should_terminate(rr->sc, &error))
+		return error;
+
+	rre = kmem_alloc(sizeof(struct xfs_repair_rmapbt_extent), KM_MAYFAIL);
+	if (!rre)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&rre->list);
+	rre->rmap.rm_startblock = startblock;
+	rre->rmap.rm_blockcount = blockcount;
+	rre->rmap.rm_owner = owner;
+	rre->rmap.rm_offset = offset;
+	rre->rmap.rm_flags = flags;
+	list_add_tail(&rre->list, rr->rmaplist);
+	rr->nr_records++;
+
+	return 0;
+}
+
+/* Add an AGFL block to the rmap list. */
+STATIC int
+xfs_repair_rmapbt_walk_agfl(
+	struct xfs_mount		*mp,
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
+STATIC int
+xfs_repair_rmapbt_stash_btree_rmap(
+	struct xfs_scrub_context	*sc,
+	xfs_fsblock_t			fsbno,
+	xfs_fsblock_t			len,
+	void				*priv)
+{
+	return xfs_repair_rmapbt_new_rmap(priv, XFS_FSB_TO_AGBNO(sc->mp, fsbno),
+			len, XFS_RMAP_OWN_INOBT, 0, 0);
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
+	xfs_agino_t			agino;
+	xfs_agino_t			iperhole;
+	unsigned int			i;
+	int				error;
+
+	/* Record the inobt blocks. */
+	error = xfs_repair_collect_btree_cur_blocks(rr->sc, cur,
+			xfs_repair_rmapbt_stash_btree_rmap, rr);
+	if (error)
+		return error;
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
+	struct xfs_iext_cursor		icur;
+	struct xfs_mount		*mp = rr->sc->mp;
+	struct xfs_btree_cur		*cur = NULL;
+	struct xfs_ifork		*ifp;
+	unsigned int			rflags;
+	int				fmt;
+	int				error = 0;
+
+	/* Do we even have data mapping extents? */
+	fmt = XFS_IFORK_FORMAT(ip, whichfork);
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	switch (fmt) {
+	case XFS_DINODE_FMT_BTREE:
+		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+			error = xfs_iread_extents(rr->sc->tp, ip, whichfork);
+			if (error)
+				return error;
+		}
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		break;
+	default:
+		return 0;
+	}
+	if (!ifp)
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
+	/* Find all the extents in the AG. */
+	for_each_xfs_iext(ifp, &icur, &rec) {
+		if (isnullstartblock(rec.br_startblock))
+			continue;
+		/* Stash non-hole extent. */
+		if (XFS_FSB_TO_AGNO(mp, rec.br_startblock) == rr->sc->sa.agno) {
+			rflags = xfs_repair_rmapbt_bmap_flags(whichfork,
+					rec.br_state);
+			error = xfs_repair_rmapbt_new_rmap(rr,
+					XFS_FSB_TO_AGBNO(mp, rec.br_startblock),
+					rec.br_blockcount, ip->i_ino,
+					rec.br_startoff, rflags);
+			if (error)
+				goto out;
+		}
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
+	struct xfs_repair_rmapbt	*rr = priv;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_inode		*ip = NULL;
+	xfs_ino_t			ino;
+	xfs_agino_t			agino;
+	int				chunkidx;
+	int				lock_mode = 0;
+	int				error = 0;
+
+	xfs_inobt_btrec_to_irec(mp, rec, &irec);
+
+	for (chunkidx = 0, agino = irec.ir_startino;
+	     chunkidx < XFS_INODES_PER_CHUNK;
+	     chunkidx++, agino++) {
+		bool	inuse;
+
+		/* Skip if this inode is free */
+		if (XFS_INOBT_MASK(chunkidx) & irec.ir_free)
+			continue;
+		ino = XFS_AGINO_TO_INO(mp, cur->bc_private.a.agno, agino);
+
+		/* Back off and try again if an inode is being reclaimed */
+		error = xfs_icache_inode_is_allocated(mp, cur->bc_tp, ino,
+				&inuse);
+		if (error == -EAGAIN)
+			return -EDEADLOCK;
+
+		/*
+		 * Grab inode for scanning.  We cannot use DONTCACHE here
+		 * because we already have a transaction so the iput must not
+		 * trigger inode reclaim (which might allocate a transaction
+		 * to clean up posteof blocks).
+		 */
+		error = xfs_iget(mp, cur->bc_tp, ino, 0, 0, &ip);
+		if (error)
+			return error;
+		trace_xfs_scrub_iget(ip, __this_address);
+
+		if ((ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
+		     !(ip->i_df.if_flags & XFS_IFEXTENTS)) ||
+		    (ip->i_d.di_aformat == XFS_DINODE_FMT_BTREE &&
+		     !(ip->i_afp->if_flags & XFS_IFEXTENTS)))
+			lock_mode = XFS_ILOCK_EXCL;
+		else
+			lock_mode = XFS_ILOCK_SHARED;
+		if (!xfs_ilock_nowait(ip, lock_mode)) {
+			error = -EBUSY;
+			goto out_rele;
+		}
+
+		/* Check the data fork. */
+		error = xfs_repair_rmapbt_scan_ifork(rr, ip, XFS_DATA_FORK);
+		if (error)
+			goto out_unlock;
+
+		/* Check the attr fork. */
+		error = xfs_repair_rmapbt_scan_ifork(rr, ip, XFS_ATTR_FORK);
+		if (error)
+			goto out_unlock;
+
+		xfs_iunlock(ip, lock_mode);
+		xfs_scrub_iput(rr->sc, ip);
+		ip = NULL;
+	}
+
+	return error;
+out_unlock:
+	xfs_iunlock(ip, lock_mode);
+out_rele:
+	iput(VFS_I(ip));
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
+	struct xfs_repair_rmapbt_freesp	*rrf = priv;
+	xfs_fsblock_t			fsb;
+	int				error;
+
+	/* Record the free space we find. */
+	if (rec->rm_startblock > rrf->next_bno) {
+		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+				rrf->next_bno);
+		error = xfs_repair_collect_btree_extent(rrf->sc,
+				&rrf->rmap_freelist, fsb,
+				rec->rm_startblock - rrf->next_bno);
+		if (error)
+			return error;
+	}
+	rrf->next_bno = max_t(xfs_agblock_t, rrf->next_bno,
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
+	struct xfs_repair_rmapbt_freesp	*rrf = priv;
+	xfs_fsblock_t			fsb;
+
+	/* Record the free space we find. */
+	fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+			rec->ar_startblock);
+	return xfs_repair_collect_btree_extent(rrf->sc, &rrf->bno_freelist,
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
+
+	ap = container_of(a, struct xfs_repair_rmapbt_extent, list);
+	bp = container_of(b, struct xfs_repair_rmapbt_extent, list);
+	return xfs_rmap_compare(&ap->rmap, &bp->rmap);
+}
+
+/* Generate rmaps for the AG headers (AGI/AGF/AGFL) */
+STATIC int
+xfs_repair_rmapbt_generate_agheader_rmaps(
+	struct xfs_repair_rmapbt	*rr)
+{
+	struct xfs_scrub_context	*sc = rr->sc;
+	int				error;
+
+	/* Create a record for the AG sb->agfl. */
+	error = xfs_repair_rmapbt_new_rmap(rr, XFS_SB_BLOCK(sc->mp),
+			XFS_AGFL_BLOCK(sc->mp) - XFS_SB_BLOCK(sc->mp) + 1,
+			XFS_RMAP_OWN_FS, 0, 0);
+	if (error)
+		return error;
+
+	/* Generate rmaps for the blocks in the AGFL. */
+	return xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
+			sc->sa.agfl_bp, xfs_repair_rmapbt_walk_agfl, rr);
+}
+
+/* Generate rmaps for the log, if it's in this AG. */
+STATIC int
+xfs_repair_rmapbt_generate_log_rmaps(
+	struct xfs_repair_rmapbt	*rr)
+{
+	struct xfs_scrub_context	*sc = rr->sc;
+
+	if (sc->mp->m_sb.sb_logstart == 0 ||
+	    XFS_FSB_TO_AGNO(sc->mp, sc->mp->m_sb.sb_logstart) != sc->sa.agno)
+		return 0;
+
+	return xfs_repair_rmapbt_new_rmap(rr,
+			XFS_FSB_TO_AGBNO(sc->mp, sc->mp->m_sb.sb_logstart),
+			sc->mp->m_sb.sb_logblocks, XFS_RMAP_OWN_LOG, 0, 0);
+}
+
+/* Collect rmaps for the blocks containing the free space btrees. */
+STATIC int
+xfs_repair_rmapbt_generate_freesp_rmaps(
+	struct xfs_repair_rmapbt	*rr,
+	xfs_agblock_t			*new_btreeblks)
+{
+	struct xfs_scrub_context	*sc = rr->sc;
+	struct xfs_btree_cur		*cur;
+	int				error;
+
+	rr->owner = XFS_RMAP_OWN_AG;
+	rr->btblocks = 0;
+
+	/* bnobt */
+	cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.agno, XFS_BTNUM_BNO);
+	error = xfs_btree_visit_blocks(cur, xfs_repair_rmapbt_visit_btblock,
+			rr);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	/* cntbt */
+	cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.agno, XFS_BTNUM_CNT);
+	error = xfs_btree_visit_blocks(cur, xfs_repair_rmapbt_visit_btblock,
+			rr);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	/* btreeblks doesn't include the bnobt/cntbt btree roots */
+	*new_btreeblks = rr->btblocks - 2;
+	return 0;
+err:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/* Collect rmaps for the blocks containing inode btrees and the inode chunks. */
+STATIC int
+xfs_repair_rmapbt_generate_inobt_rmaps(
+	struct xfs_repair_rmapbt	*rr)
+{
+	struct xfs_scrub_context	*sc = rr->sc;
+	struct xfs_btree_cur		*cur;
+	int				error;
+
+	rr->owner = XFS_RMAP_OWN_INOBT;
+
+	/*
+	 * Iterate every record in the inobt so we can capture all the inode
+	 * chunks and the blocks in the inobt itself.  Note that if there are
+	 * zero records in the inobt then query_all does nothing and we have
+	 * to account the empty inobt root manually.
+	 */
+	if (sc->sa.pag->pagi_count > 0) {
+		cur = xfs_inobt_init_cursor(sc->mp, sc->tp, sc->sa.agi_bp,
+				sc->sa.agno, XFS_BTNUM_INO);
+		error = xfs_btree_query_all(cur, xfs_repair_rmapbt_inodes, rr);
+		if (error)
+			goto err_cur;
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	} else {
+		struct xfs_agi		*agi;
+
+		agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+		error = xfs_repair_rmapbt_new_rmap(rr,
+				be32_to_cpu(agi->agi_root), 1,
+				XFS_RMAP_OWN_INOBT, 0, 0);
+		if (error)
+			goto err;
+	}
+
+	/* finobt */
+	if (!xfs_sb_version_hasfinobt(&sc->mp->m_sb))
+		return 0;
+
+	cur = xfs_inobt_init_cursor(sc->mp, sc->tp, sc->sa.agi_bp, sc->sa.agno,
+			XFS_BTNUM_FINO);
+	error = xfs_btree_visit_blocks(cur, xfs_repair_rmapbt_visit_btblock,
+			rr);
+	if (error)
+		goto err_cur;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+err_cur:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+err:
+	return error;
+}
+
+/*
+ * Collect rmaps for the blocks containing the refcount btree, and all CoW
+ * staging extents.
+ */
+STATIC int
+xfs_repair_rmapbt_generate_refcountbt_rmaps(
+	struct xfs_repair_rmapbt	*rr)
+{
+	union xfs_btree_irec		low;
+	union xfs_btree_irec		high;
+	struct xfs_scrub_context	*sc = rr->sc;
+	struct xfs_btree_cur		*cur;
+	int				error;
+
+	if (!xfs_sb_version_hasreflink(&sc->mp->m_sb))
+		return 0;
+
+	rr->owner = XFS_RMAP_OWN_REFC;
+
+	/* refcountbt */
+	cur = xfs_refcountbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.agno, NULL);
+	error = xfs_btree_visit_blocks(cur, xfs_repair_rmapbt_visit_btblock,
+			rr);
+	if (error)
+		goto err_cur;
+
+	/* Collect rmaps for CoW staging extents. */
+	memset(&low, 0, sizeof(low));
+	low.rc.rc_startblock = XFS_REFC_COW_START;
+	memset(&high, 0xFF, sizeof(high));
+	error = xfs_btree_query_range(cur, &low, &high,
+			xfs_repair_rmapbt_refcount, rr);
+	if (error)
+		goto err_cur;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+err_cur:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/* Collect rmaps for all block mappings for every inode in this AG. */
+STATIC int
+xfs_repair_rmapbt_generate_aginode_rmaps(
+	struct xfs_repair_rmapbt	*rr,
+	xfs_agnumber_t			agno)
+{
+	struct xfs_scrub_context	*sc = rr->sc;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_btree_cur		*cur;
+	struct xfs_buf			*agi_bp;
+	int				error;
+
+	error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
+	if (error)
+		return error;
+	cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, agno, XFS_BTNUM_INO);
+	error = xfs_btree_query_all(cur, xfs_repair_rmapbt_scan_inobt, rr);
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	xfs_trans_brelse(sc->tp, agi_bp);
+	return error;
+}
+
+/*
+ * Generate all the reverse-mappings for this AG, a list of the old rmapbt
+ * blocks, and the new btreeblks count.  Figure out if we have enough free
+ * space to reconstruct the inode btrees.  The caller must clean up the lists
+ * if anything goes wrong.
+ */
+STATIC int
+xfs_repair_rmapbt_find_rmaps(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*rmap_records,
+	xfs_agblock_t			*new_btreeblks)
+{
+	struct xfs_repair_rmapbt	rr;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	rr.rmaplist = rmap_records;
+	rr.sc = sc;
+	rr.nr_records = 0;
+
+	/* Generate rmaps for AG space metadata */
+	error = xfs_repair_rmapbt_generate_agheader_rmaps(&rr);
+	if (error)
+		return error;
+	error = xfs_repair_rmapbt_generate_log_rmaps(&rr);
+	if (error)
+		return error;
+	error = xfs_repair_rmapbt_generate_freesp_rmaps(&rr, new_btreeblks);
+	if (error)
+		return error;
+	error = xfs_repair_rmapbt_generate_inobt_rmaps(&rr);
+	if (error)
+		return error;
+	error = xfs_repair_rmapbt_generate_refcountbt_rmaps(&rr);
+	if (error)
+		return error;
+
+	/* Iterate all AGs for inodes rmaps. */
+	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
+		error = xfs_repair_rmapbt_generate_aginode_rmaps(&rr, agno);
+		if (error)
+			return error;
+	}
+
+	/* Do we actually have enough space to do this? */
+	if (!xfs_repair_ag_has_space(sc->sa.pag,
+			xfs_rmapbt_calc_size(sc->mp, rr.nr_records),
+			XFS_AG_RESV_RMAPBT))
+		return -ENOSPC;
+
+	return 0;
+}
+
+/* Update the AGF counters. */
+STATIC int
+xfs_repair_rmapbt_reset_counters(
+	struct xfs_scrub_context	*sc,
+	xfs_agblock_t			new_btreeblks,
+	int				*log_flags)
+{
+	struct xfs_agf			*agf;
+	struct xfs_perag		*pag = sc->sa.pag;
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	pag->pagf_btreeblks = new_btreeblks;
+	agf->agf_btreeblks = cpu_to_be32(new_btreeblks);
+	*log_flags |= XFS_AGF_BTREEBLKS;
+
+	return 0;
+}
+
+/* Initialize a new rmapbt root and implant it into the AGF. */
+STATIC int
+xfs_repair_rmapbt_reset_btree(
+	struct xfs_scrub_context	*sc,
+	struct xfs_owner_info		*oinfo,
+	int				*log_flags)
+{
+	struct xfs_buf			*bp;
+	struct xfs_agf			*agf;
+	struct xfs_perag		*pag = sc->sa.pag;
+	xfs_fsblock_t			btfsb;
+	int				error;
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+
+	/* Initialize a new rmapbt root. */
+	error = xfs_repair_alloc_ag_block(sc, oinfo, &btfsb,
+			XFS_AG_RESV_RMAPBT);
+	if (error)
+		return error;
+
+	/* The root block is not a btreeblks block. */
+	be32_add_cpu(&agf->agf_btreeblks, -1);
+	pag->pagf_btreeblks--;
+	*log_flags |= XFS_AGF_BTREEBLKS;
+
+	error = xfs_repair_init_btblock(sc, btfsb, &bp, XFS_BTNUM_RMAP,
+			&xfs_rmapbt_buf_ops);
+	if (error)
+		return error;
+
+	agf->agf_roots[XFS_BTNUM_RMAPi] =
+			cpu_to_be32(XFS_FSB_TO_AGBNO(sc->mp, btfsb));
+	agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
+	agf->agf_rmap_blocks = cpu_to_be32(1);
+	pag->pagf_levels[XFS_BTNUM_RMAPi] = 1;
+	*log_flags |= XFS_AGF_ROOTS | XFS_AGF_LEVELS | XFS_AGF_RMAP_BLOCKS;
+
+	return 0;
+}
+
+/*
+ * Roll and fix the free list while reloading the rmapbt.  Do not shrink the
+ * freelist because the rmapbt is not fully set up yet.
+ */
+STATIC int
+xfs_repair_rmapbt_fix_freelist(
+	struct xfs_scrub_context	*sc)
+{
+	int				error;
+
+	error = xfs_repair_roll_ag_trans(sc);
+	if (error)
+		return error;
+	return xfs_repair_fix_freelist(sc, false);
+}
+
+/* Insert all the rmaps we collected. */
+STATIC int
+xfs_repair_rmapbt_rebuild_tree(
+	struct xfs_scrub_context	*sc,
+	struct list_head		*rmap_records)
+{
+	struct xfs_repair_rmapbt_extent	*rre;
+	struct xfs_repair_rmapbt_extent	*n;
+	struct xfs_btree_cur		*cur;
+	struct xfs_mount		*mp = sc->mp;
+	uint32_t			old_flcount;
+	int				error;
+
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	old_flcount = sc->sa.pag->pagf_flcount;
+
+	list_sort(NULL, rmap_records, xfs_repair_rmapbt_extent_cmp);
+	list_for_each_entry_safe(rre, n, rmap_records, list) {
+		/* Add the rmap. */
+		error = xfs_rmap_map_raw(cur, &rre->rmap);
+		if (error)
+			goto err_cur;
+		list_del(&rre->list);
+		kmem_free(rre);
+
+		/*
+		 * If the flcount changed because the rmap btree changed shape
+		 * then we need to fix the freelist to keep it full enough to
+		 * handle a total btree split.  We'll roll this transaction to
+		 * get it out of the way and then fix the freelist in a fresh
+		 * transaction.
+		 *
+		 * However, two things we must be careful about: (1) fixing
+		 * the freelist changes the rmapbt so drop the rmapbt cursor
+		 * and (2) we can't let the freelist shrink.  The rmapbt isn't
+		 * fully set up yet, which means that the current AGFL blocks
+		 * might not be reflected in the rmapbt, which is a problem if
+		 * we want to unmap blocks from the AGFL.
+		 */
+		if (sc->sa.pag->pagf_flcount == old_flcount)
+			continue;
+		if (list_empty(rmap_records))
+			break;
+
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		error = xfs_repair_rmapbt_fix_freelist(sc);
+		if (error)
+			goto err;
+		old_flcount = sc->sa.pag->pagf_flcount;
+		cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp,
+				sc->sa.agno);
+	}
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	/* Fix the freelist once more, if necessary. */
+	if (sc->sa.pag->pagf_flcount != old_flcount) {
+		error = xfs_repair_rmapbt_fix_freelist(sc);
+		if (error)
+			goto err;
+	}
+	return 0;
+err_cur:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+err:
+	return error;
+}
+
+/* Cancel every rmapbt record. */
+STATIC void
+xfs_repair_rmapbt_cancel_rmaps(
+	struct list_head	*reclist)
+{
+	struct xfs_repair_rmapbt_extent	*rre;
+	struct xfs_repair_rmapbt_extent	*n;
+
+	list_for_each_entry_safe(rre, n, reclist, list) {
+		list_del(&rre->list);
+		kmem_free(rre);
+	}
+}
+
+/*
+ * Reap the old rmapbt blocks.  Now that the rmapbt is fully rebuilt, we make
+ * a list of gaps in the rmap records and a list of the extents mentioned in
+ * the bnobt.  Any block that's in the new rmapbt gap list but not mentioned
+ * in the bnobt is a block from the old rmapbt and can be removed.
+ */
+STATIC int
+xfs_repair_rmapbt_reap_old_blocks(
+	struct xfs_scrub_context	*sc,
+	struct xfs_owner_info		*oinfo)
+{
+	struct xfs_repair_rmapbt_freesp	rrf;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_agf			*agf;
+	struct xfs_btree_cur		*cur;
+	xfs_fsblock_t			btfsb;
+	xfs_agblock_t			agend;
+	int				error;
+
+	xfs_repair_init_extent_list(&rrf.rmap_freelist);
+	xfs_repair_init_extent_list(&rrf.bno_freelist);
+	rrf.next_bno = 0;
+	rrf.sc = sc;
+
+	/* Compute free space from the new rmapbt. */
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xfs_repair_rmapbt_record_rmap_freesp,
+			&rrf);
+	if (error)
+		goto err_cur;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	/* Insert a record for space between the last rmap and EOAG. */
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+	agend = be32_to_cpu(agf->agf_length);
+	if (rrf.next_bno < agend) {
+		btfsb = XFS_AGB_TO_FSB(mp, sc->sa.agno, rrf.next_bno);
+		error = xfs_repair_collect_btree_extent(sc, &rrf.rmap_freelist,
+				btfsb, agend - rrf.next_bno);
+		if (error)
+			goto err;
+	}
+
+	/* Compute free space from the existing bnobt. */
+	cur = xfs_allocbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.agno, XFS_BTNUM_BNO);
+	error = xfs_alloc_query_all(cur, xfs_repair_rmapbt_record_bno_freesp,
+			&rrf);
+	if (error)
+		goto err_lists;
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	/*
+	 * Free the "free" blocks that the new rmapbt knows about but
+	 * the old bnobt doesn't.  These are the old rmapbt blocks.
+	 */
+	error = xfs_repair_subtract_extents(sc, &rrf.rmap_freelist,
+			&rrf.bno_freelist);
+	xfs_repair_cancel_btree_extents(sc, &rrf.bno_freelist);
+	if (error)
+		goto err;
+	error = xfs_repair_invalidate_blocks(sc, &rrf.rmap_freelist);
+	if (error)
+		goto err;
+	return xfs_repair_reap_btree_extents(sc, &rrf.rmap_freelist, oinfo,
+			XFS_AG_RESV_RMAPBT);
+err_lists:
+	xfs_repair_cancel_btree_extents(sc, &rrf.bno_freelist);
+err_cur:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+err:
+	return error;
+}
+
+/* Repair the rmap btree for some AG. */
+int
+xfs_repair_rmapbt(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_owner_info		oinfo;
+	struct list_head		rmap_records;
+	xfs_extlen_t			new_btreeblks;
+	int				log_flags = 0;
+	int				error;
+
+	xfs_scrub_perag_get(sc->mp, &sc->sa);
+
+	/* Collect rmaps for all AG headers. */
+	INIT_LIST_HEAD(&rmap_records);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_UNKNOWN);
+	error = xfs_repair_rmapbt_find_rmaps(sc, &rmap_records, &new_btreeblks);
+	if (error)
+		goto out;
+
+	/*
+	 * Blow out the old rmap btrees.  This is the point at which
+	 * we are no longer able to bail out gracefully.
+	 */
+	error = xfs_repair_rmapbt_reset_counters(sc, new_btreeblks, &log_flags);
+	if (error)
+		goto out;
+	error = xfs_repair_rmapbt_reset_btree(sc, &oinfo, &log_flags);
+	if (error)
+		goto out;
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, log_flags);
+	error = xfs_repair_roll_ag_trans(sc);
+	if (error)
+		goto out;
+
+	/* Now rebuild the rmap information. */
+	error = xfs_repair_rmapbt_rebuild_tree(sc, &rmap_records);
+	if (error)
+		goto out;
+
+	/* Find and destroy the blocks from the old rmapbt. */
+	error = xfs_repair_rmapbt_reap_old_blocks(sc, &oinfo);
+out:
+	xfs_repair_rmapbt_cancel_rmaps(&rmap_records);
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 424f01130f14..3f8036ee3971 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -280,7 +280,7 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_ag_rmapbt,
 		.scrub	= xfs_scrub_rmapbt,
 		.has	= xfs_sb_version_hasrmapbt,
-		.repair	= xfs_repair_notsupported,
+		.repair	= xfs_repair_rmapbt,
 	},
 	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
 		.type	= ST_PERAG,

