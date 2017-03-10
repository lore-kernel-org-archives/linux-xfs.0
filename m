Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21921 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755050AbdCJXY7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Mar 2017 18:24:59 -0500
Subject: [PATCH 1/9] xfs_repair: rebuild bmbt from rmapbt data
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 10 Mar 2017 15:24:51 -0800
Message-ID: <148918829104.8311.15211853599014518835.stgit@birch.djwong.org>
In-Reply-To: <148918828436.8311.8130426069001200240.stgit@birch.djwong.org>
References: <148918828436.8311.8130426069001200240.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use rmap records to rebuild corrupt inode forks instead of zapping
the whole inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    2 
 repair/Makefile          |    5 -
 repair/dino_chunks.c     |    7 +
 repair/dinode.c          |   41 +++++++
 repair/rebuild.c         |  277 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/rebuild.h         |   26 ++++
 repair/rmap.c            |    2 
 repair/rmap.h            |    1 
 8 files changed, 357 insertions(+), 4 deletions(-)
 create mode 100644 repair/rebuild.c
 create mode 100644 repair/rebuild.h


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index d299b7a..f01fff0 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -146,5 +146,7 @@
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
 #define xfs_refc_block			libxfs_refc_block
 #define xfs_rmap_compare		libxfs_rmap_compare
+#define xfs_bmbt_calc_size		libxfs_bmbt_calc_size
+#define xfs_rmap_query_all		libxfs_rmap_query_all
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/Makefile b/repair/Makefile
index b7e8fd5..9edaf18 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -11,14 +11,15 @@ LTCOMMAND = xfs_repair
 
 HFILES = agheader.h attr_repair.h avl.h avl64.h bmap.h btree.h \
 	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
-	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h
+	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h \
+	rebuild.h
 
 CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
 	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
 	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
 	progress.c prefetch.c rmap.c rt.c sb.c scan.c slab.c threads.c \
-	versions.c xfs_repair.c
+	versions.c rebuild.c xfs_repair.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBUUID) \
 	$(LIBRT) $(LIBPTHREAD) $(LIBBLKID)
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index a3909ac..c479f2c 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -697,6 +697,13 @@ process_inode_chunk(
 		irec_offset += mp->m_sb.sb_inopblock * blks_per_cluster;
 		agbno += blks_per_cluster;
 	}
+	/*
+	 * Allow the buffer to be re-locked by this thread in case
+	 * we want to rebuild an inode fork.
+	 */
+	for (bp_index = 0; bp_index < cluster_count; bp_index++)
+		if (bplist[bp_index])
+			bplist[bp_index]->b_flags |= LIBXFS_B_RECURSIVE_LOCK;
 	agbno = XFS_AGINO_TO_AGBNO(mp, first_irec->ino_startnum);
 
 	/*
diff --git a/repair/dinode.c b/repair/dinode.c
index d664f87..6f71c2f 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -32,6 +32,7 @@
 #include "threads.h"
 #include "slab.h"
 #include "rmap.h"
+#include "rebuild.h"
 
 /*
  * gettext lookups for translations of strings use mutexes internally to
@@ -1915,7 +1916,9 @@ process_inode_data_fork(
 	xfs_ino_t	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	int		err = 0;
 	int		nex;
+	bool		try_rebuild = !rmapbt_suspect;
 
+retry:
 	/*
 	 * extent count on disk is only valid for positive values. The kernel
 	 * uses negative values in memory. hence if we see negative numbers
@@ -1961,8 +1964,25 @@ process_inode_data_fork(
 	if (err)  {
 		do_warn(_("bad data fork in inode %" PRIu64 "\n"), lino);
 		if (!no_modify)  {
+			if (try_rebuild) {
+				do_warn(
+_("rebuilding inode %"PRIu64" data fork\n"),
+					lino);
+				try_rebuild = false;
+				err = rebuild_bmap(mp, lino, XFS_DATA_FORK,
+						be32_to_cpu(dino->di_nextents));
+				if (!err)
+					goto retry;
+				do_warn(
+_("inode %"PRIu64" data fork rebuild failed, error %d\n"),
+					lino, err);
+			}
 			*dirty += clear_dinode(mp, dino, lino);
 			ASSERT(*dirty > 0);
+		} else if (try_rebuild) {
+			do_warn(
+_("would have tried to rebuild inode %"PRIu64" data fork, or else\n"),
+					lino);
 		}
 		return 1;
 	}
@@ -2026,7 +2046,9 @@ process_inode_attr_fork(
 	blkmap_t	*ablkmap = NULL;
 	int		repair = 0;
 	int		err;
+	bool		try_rebuild = !rmapbt_suspect;
 
+retry:
 	if (!XFS_DFORK_Q(dino)) {
 		*anextents = 0;
 		if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS) {
@@ -2085,6 +2107,19 @@ process_inode_attr_fork(
 		do_warn(_("bad attribute fork in inode %" PRIu64), lino);
 
 		if (!no_modify)  {
+			if (try_rebuild) {
+				try_rebuild = false;
+				do_warn(
+_("rebuilding inode %"PRIu64" attr fork\n"),
+					lino);
+				err = rebuild_bmap(mp, lino, XFS_DATA_FORK,
+						be32_to_cpu(dino->di_nextents));
+				if (!err)
+					goto retry;
+				do_warn(
+_("inode %"PRIu64" attr fork rebuild failed, error %d\n"),
+					lino, err);
+			}
 			if (delete_attr_ok)  {
 				do_warn(_(", clearing attr fork\n"));
 				*dirty += clear_dinode_attr(mp, dino, lino);
@@ -2094,7 +2129,11 @@ process_inode_attr_fork(
 				*dirty += clear_dinode(mp, dino, lino);
 			}
 			ASSERT(*dirty > 0);
-		} else  {
+		} else if (try_rebuild) {
+			do_warn(
+_("would have tried to rebuild inode %"PRIu64" attr fork or cleared it\n"),
+					lino);
+		} else {
 			do_warn(_(", would clear attr fork\n"));
 		}
 
diff --git a/repair/rebuild.c b/repair/rebuild.c
new file mode 100644
index 0000000..bd5d6a8
--- /dev/null
+++ b/repair/rebuild.c
@@ -0,0 +1,277 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include <libxfs.h>
+#include "btree.h"
+#include "err_protos.h"
+#include "libxlog.h"
+#include "incore.h"
+#include "globals.h"
+#include "dinode.h"
+#include "slab.h"
+#include "rmap.h"
+
+/* Borrowed routines from xfs_scrub.c */
+
+struct xfs_repair_bmap_extent {
+	struct xfs_rmap_irec		rmap;
+	xfs_agnumber_t			agno;
+};
+
+struct xfs_repair_bmap {
+	struct xfs_slab			*extslab;
+	xfs_ino_t			ino;
+	xfs_rfsblock_t			bmbt_blocks;
+	int				whichfork;
+};
+
+/* Record extents that belong to this inode's fork. */
+STATIC int
+xfs_repair_bmap_extent_fn(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_repair_bmap		*rb = priv;
+	struct xfs_repair_bmap_extent	rbe;
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != rb->ino)
+		return 0;
+	else if (rb->whichfork == XFS_DATA_FORK &&
+		 (rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+	else if (rb->whichfork == XFS_ATTR_FORK &&
+		 !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+	else if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
+		rb->bmbt_blocks += rec->rm_blockcount;
+		return 0;
+	}
+
+	rbe.rmap = *rec;
+	rbe.agno = cur->bc_private.a.agno;
+	return slab_add(rb->extslab, &rbe);
+}
+
+/* Compare two bmap extents. */
+static int
+xfs_repair_bmap_extent_cmp(
+	const void				*a,
+	const void				*b)
+{
+	const struct xfs_repair_bmap_extent	*ap = a;
+	const struct xfs_repair_bmap_extent	*bp = b;
+
+	if (ap->rmap.rm_offset > bp->rmap.rm_offset)
+		return 1;
+	else if (ap->rmap.rm_offset < bp->rmap.rm_offset)
+		return -1;
+	return 0;
+}
+
+/* Repair an inode fork. */
+STATIC int
+xfs_repair_bmap(
+	struct xfs_inode		*ip,
+	struct xfs_trans		**tpp,
+	int				whichfork)
+{
+	struct xfs_repair_bmap		rb = {0};
+	struct xfs_bmbt_irec		bmap;
+	struct xfs_defer_ops		dfops;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_buf			*agf_bp = NULL;
+	struct xfs_repair_bmap_extent	*rbe;
+	struct xfs_btree_cur		*cur;
+	struct xfs_slab_cursor		*scur = NULL;
+	xfs_fsblock_t			firstfsb;
+	xfs_agnumber_t			agno;
+	xfs_extlen_t			extlen;
+	int				baseflags;
+	int				flags;
+	int				nimaps;
+	int				error = 0;
+
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
+
+	/* Don't know how to repair the other fork formats. */
+	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)
+		return ENOTTY;
+
+	/* Only files, symlinks, and directories get to have data forks. */
+	if (whichfork == XFS_DATA_FORK && !S_ISREG(VFS_I(ip)->i_mode) &&
+	    !S_ISDIR(VFS_I(ip)->i_mode) && !S_ISLNK(VFS_I(ip)->i_mode))
+		return EINVAL;
+
+	/* If we somehow have delalloc extents, forget it. */
+	if (whichfork == XFS_DATA_FORK && ip->i_delayed_blks)
+		return EBUSY;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return EOPNOTSUPP;
+
+	/* Don't know how to rebuild realtime data forks. */
+	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK)
+		return EOPNOTSUPP;
+
+	/* Collect all reverse mappings for this fork's extents. */
+	init_slab(&rb.extslab, sizeof(*rbe));
+	rb.ino = ip->i_ino;
+	rb.whichfork = whichfork;
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = -libxfs_alloc_read_agf(mp, *tpp, agno, 0, &agf_bp);
+		if (error)
+			goto out;
+		cur = libxfs_rmapbt_init_cursor(mp, *tpp, agf_bp, agno);
+		error = -libxfs_rmap_query_all(cur, xfs_repair_bmap_extent_fn, &rb);
+		libxfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
+				XFS_BTREE_NOERROR);
+		if (error)
+			goto out;
+	}
+
+	/* Blow out the in-core fork and zero the on-disk fork. */
+	libxfs_trans_ijoin(*tpp, ip, 0);
+	if (XFS_IFORK_PTR(ip, whichfork) != NULL)
+		libxfs_idestroy_fork(ip, whichfork);
+	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+	XFS_IFORK_NEXT_SET(ip, whichfork, 0);
+
+	/* Reinitialize the on-disk fork. */
+	if (whichfork == XFS_DATA_FORK) {
+		memset(&ip->i_df, 0, sizeof(struct xfs_ifork));
+		ip->i_df.if_flags |= XFS_IFEXTENTS;
+	} else if (whichfork == XFS_ATTR_FORK) {
+		if (slab_count(rb.extslab) == 0)
+			ip->i_afp = NULL;
+		else {
+			ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
+			ip->i_afp->if_flags |= XFS_IFEXTENTS;
+		}
+	}
+	libxfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+	error = -libxfs_trans_roll(tpp, ip);
+	if (error)
+		goto out;
+
+	baseflags = XFS_BMAPI_REMAP | XFS_BMAPI_NORMAP;
+	if (whichfork == XFS_ATTR_FORK)
+		baseflags |= XFS_BMAPI_ATTRFORK;
+
+	/* "Remap" the extents into the fork. */
+	init_slab_cursor(rb.extslab, xfs_repair_bmap_extent_cmp, &scur);
+	rbe = pop_slab_cursor(scur);
+	while (rbe != NULL) {
+		/* Form the "new" mapping... */
+		bmap.br_startblock = XFS_AGB_TO_FSB(mp, rbe->agno,
+				rbe->rmap.rm_startblock);
+		bmap.br_startoff = rbe->rmap.rm_offset;
+		flags = 0;
+		if (rbe->rmap.rm_flags & XFS_RMAP_UNWRITTEN)
+			flags = XFS_BMAPI_PREALLOC;
+		while (rbe->rmap.rm_blockcount > 0) {
+			libxfs_defer_init(&dfops, &firstfsb);
+			extlen = min(rbe->rmap.rm_blockcount, MAXEXTLEN);
+			bmap.br_blockcount = extlen;
+
+			/* Drop the block counter... */
+			ip->i_d.di_nblocks -= extlen;
+
+			/* Re-add the extent to the fork. */
+			nimaps = 1;
+			firstfsb = bmap.br_startblock;
+			error = -libxfs_bmapi_write(*tpp, ip,
+					bmap.br_startoff,
+					extlen, baseflags | flags, &firstfsb,
+					extlen, &bmap, &nimaps,
+					&dfops);
+			if (error)
+				goto out;
+
+			bmap.br_startblock += extlen;
+			bmap.br_startoff += extlen;
+			rbe->rmap.rm_blockcount -= extlen;
+			error = -libxfs_defer_finish(tpp, &dfops, ip);
+			if (error)
+				goto out;
+			/* Make sure we roll the transaction. */
+			error = -libxfs_trans_roll(tpp, ip);
+			if (error)
+				goto out;
+		}
+		rbe = pop_slab_cursor(scur);
+	}
+	free_slab_cursor(&scur);
+	free_slab(&rb.extslab);
+
+	/* Decrease nblocks to reflect the freed bmbt blocks. */
+	if (rb.bmbt_blocks) {
+		ip->i_d.di_nblocks -= rb.bmbt_blocks;
+		libxfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+		error = -libxfs_trans_roll(tpp, ip);
+		if (error)
+			goto out;
+	}
+
+	return error;
+out:
+	if (scur)
+		free_slab_cursor(&scur);
+	if (rb.extslab)
+		free_slab(&rb.extslab);
+	return error;
+}
+
+/* Rebuild some inode's bmap. */
+int
+rebuild_bmap(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	int			whichfork,
+	unsigned long		nr_extents)
+{
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
+	unsigned long long	resblks;
+	int			error;
+
+	resblks = libxfs_bmbt_calc_size(mp, nr_extents);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			resblks, 0, 0, &tp);
+	if (error)
+		return error;
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
+	if (error)
+		goto out_trans;
+	error = xfs_repair_bmap(ip, &tp, whichfork);
+	if (error)
+		goto out_irele;
+
+	error = -libxfs_trans_commit(tp);
+	IRELE(ip);
+	return error;
+out_irele:
+	IRELE(ip);
+out_trans:
+	libxfs_trans_cancel(tp);
+	return error;
+}
diff --git a/repair/rebuild.h b/repair/rebuild.h
new file mode 100644
index 0000000..51a44ea
--- /dev/null
+++ b/repair/rebuild.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef REBUILD_H_
+#define REBUILD_H_
+
+int rebuild_bmap(struct xfs_mount *mp, xfs_ino_t ino, int whichfork,
+		 unsigned long nr_extents);
+
+#endif /* REBUILD_H_ */
diff --git a/repair/rmap.c b/repair/rmap.c
index ab6e583..af37829 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -46,7 +46,7 @@ struct xfs_ag_rmap {
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
-static bool rmapbt_suspect;
+bool rmapbt_suspect;
 static bool refcbt_suspect;
 
 static inline int rmap_compare(const void *a, const void *b)
diff --git a/repair/rmap.h b/repair/rmap.h
index 752ece8..c970942 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -21,6 +21,7 @@
 #define RMAP_H_
 
 extern bool collect_rmaps;
+extern bool rmapbt_suspect;
 
 extern bool rmap_needs_work(struct xfs_mount *);
 

