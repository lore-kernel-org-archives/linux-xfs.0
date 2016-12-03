Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19504 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756546AbcLCBhw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:37:52 -0500
Subject: [PATCH 23/55] xfs: support scrubbing inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:37:46 -0800
Message-ID: <148072906638.12995.2832380766228423692.stgit@birch.djwong.org>
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

Check the records of the inode btrees to make sure that the values
make sense given the inode records themselves.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/libxfs/xfs_fs.h           |    4 -
 fs/xfs/libxfs/xfs_ialloc.c       |   41 +++--
 fs/xfs/libxfs/xfs_ialloc.h       |    3 
 fs/xfs/libxfs/xfs_ialloc_btree.c |   32 +++-
 fs/xfs/repair/common.c           |    2 
 fs/xfs/repair/common.h           |    2 
 fs/xfs/repair/ialloc.c           |  292 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h               |    4 -
 9 files changed, 357 insertions(+), 24 deletions(-)
 create mode 100644 fs/xfs/repair/ialloc.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a4246f1..c434fd8 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -107,6 +107,7 @@ xfs-$(CONFIG_XFS_ONLINE_REPAIR)	+= $(addprefix repair/, \
 				   alloc.o \
 				   btree.o \
 				   common.o \
+				   ialloc.o \
 				   )
 
 # low-level transaction/log code
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d640464..00be3ca 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -581,7 +581,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
 #define XFS_SCRUB_TYPE_BNOBT	5	/* freesp by block btree */
 #define XFS_SCRUB_TYPE_CNTBT	6	/* freesp by length btree */
-#define XFS_SCRUB_TYPE_MAX	6
+#define XFS_SCRUB_TYPE_INOBT	7	/* inode btree */
+#define XFS_SCRUB_TYPE_FINOBT	8	/* free inode btree */
+#define XFS_SCRUB_TYPE_MAX	8
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 30967c8..542f6a9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -99,24 +99,14 @@ xfs_inobt_update(
 	return xfs_btree_update(cur, &rec);
 }
 
-/*
- * Get the data from the pointed-to record.
- */
-int					/* error */
-xfs_inobt_get_rec(
-	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_inobt_rec_incore_t	*irec,	/* btree record */
-	int			*stat)	/* output: success/failure */
+void
+xfs_inobt_btrec_to_irec(
+	struct xfs_mount		*mp,
+	union xfs_btree_rec		*rec,
+	struct xfs_inobt_rec_incore	*irec)
 {
-	union xfs_btree_rec	*rec;
-	int			error;
-
-	error = xfs_btree_get_rec(cur, &rec, stat);
-	if (error || *stat == 0)
-		return error;
-
 	irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
-	if (xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb)) {
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb)) {
 		irec->ir_holemask = be16_to_cpu(rec->inobt.ir_u.sp.ir_holemask);
 		irec->ir_count = rec->inobt.ir_u.sp.ir_count;
 		irec->ir_freecount = rec->inobt.ir_u.sp.ir_freecount;
@@ -131,6 +121,25 @@ xfs_inobt_get_rec(
 				be32_to_cpu(rec->inobt.ir_u.f.ir_freecount);
 	}
 	irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+int					/* error */
+xfs_inobt_get_rec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_inobt_rec_incore_t	*irec,	/* btree record */
+	int			*stat)	/* output: success/failure */
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (error || *stat == 0)
+		return error;
+
+	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, irec);
 
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 0bb8966..8e5861d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -168,5 +168,8 @@ int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, struct xfs_buf **bpp);
 
+union xfs_btree_rec;
+void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
+		struct xfs_inobt_rec_incore *irec);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 6c6b959..dbdd532 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -152,6 +152,18 @@ xfs_inobt_init_key_from_rec(
 }
 
 STATIC void
+xfs_inobt_init_high_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	__u32			x;
+
+	x = be32_to_cpu(rec->inobt.ir_startino);
+	x += XFS_INODES_PER_CHUNK - 1;
+	key->inobt.ir_startino = cpu_to_be32(x);
+}
+
+STATIC void
 xfs_inobt_init_rec_from_cur(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec)
@@ -205,6 +217,16 @@ xfs_inobt_key_diff(
 			  cur->bc_rec.i.ir_startino;
 }
 
+STATIC __int64_t
+xfs_inobt_diff_two_keys(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return (__int64_t)be32_to_cpu(k1->inobt.ir_startino) -
+			  be32_to_cpu(k2->inobt.ir_startino);
+}
+
 static int
 xfs_inobt_verify(
 	struct xfs_buf		*bp)
@@ -279,7 +301,6 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.verify_write = xfs_inobt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_inobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -299,7 +320,6 @@ xfs_inobt_recs_inorder(
 	return be32_to_cpu(r1->inobt.ir_startino) + XFS_INODES_PER_CHUNK <=
 		be32_to_cpu(r2->inobt.ir_startino);
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
@@ -312,14 +332,14 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.get_minrecs		= xfs_inobt_get_minrecs,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_inobt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
+	.diff_two_keys		= xfs_inobt_diff_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
-#endif
 };
 
 static const struct xfs_btree_ops xfs_finobt_ops = {
@@ -333,14 +353,14 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 	.get_minrecs		= xfs_inobt_get_minrecs,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_inobt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_inobt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
+	.diff_two_keys		= xfs_inobt_diff_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index 81a60a5..30ed13f 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -703,6 +703,8 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_ag, xfs_scrub_agi, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_bnobt, NULL, NULL},
 	{xfs_scrub_setup_ag_header, xfs_scrub_cntbt, NULL, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_inobt, NULL, NULL},
+	{xfs_scrub_setup_ag_header, xfs_scrub_finobt, NULL, xfs_sb_version_hasfinobt},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index e2f5bf6..7b71cb3 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -200,5 +200,7 @@ int xfs_scrub_agfl(struct xfs_scrub_context *sc);
 int xfs_scrub_agi(struct xfs_scrub_context *sc);
 int xfs_scrub_bnobt(struct xfs_scrub_context *sc);
 int xfs_scrub_cntbt(struct xfs_scrub_context *sc);
+int xfs_scrub_inobt(struct xfs_scrub_context *sc);
+int xfs_scrub_finobt(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/repair/ialloc.c b/fs/xfs/repair/ialloc.c
new file mode 100644
index 0000000..33d9458
--- /dev/null
+++ b/fs/xfs/repair/ialloc.c
@@ -0,0 +1,292 @@
+/*
+ * Copyright (C) 2016-2017 Oracle.  All Rights Reserved.
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
+#include "xfs_trace.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_icache.h"
+#include "xfs_rmap.h"
+#include "repair/common.h"
+#include "repair/btree.h"
+
+/* Inode btree scrubber. */
+
+/* Scrub a chunk of an inobt record. */
+STATIC int
+xfs_scrub_iallocbt_chunk(
+	struct xfs_scrub_btree		*bs,
+	struct xfs_inobt_rec_incore	*irec,
+	xfs_agino_t			agino,
+	xfs_extlen_t			len,
+	bool				*keep_scanning)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_agf			*agf;
+	xfs_agblock_t			eoag;
+	xfs_agblock_t			bno;
+	int				error = 0;
+
+	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
+	eoag = be32_to_cpu(agf->agf_length);
+	bno = XFS_AGINO_TO_AGBNO(mp, agino);
+
+	*keep_scanning = true;
+	XFS_SCRUB_BTREC_CHECK(bs, bno < mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, bno < eoag);
+	XFS_SCRUB_BTREC_CHECK(bs, bno < bno + len);
+	XFS_SCRUB_BTREC_CHECK(bs, (unsigned long long)bno + len <=
+			mp->m_sb.sb_agblocks);
+	XFS_SCRUB_BTREC_CHECK(bs, (unsigned long long)bno + len <=
+			eoag);
+	if (error) {
+		*keep_scanning = false;
+		goto out;
+	}
+
+out:
+	return error;
+}
+
+/* Count the number of free inodes. */
+static unsigned int
+xfs_scrub_iallocbt_freecount(
+	xfs_inofree_t			freemask)
+{
+	int				bits = XFS_INODES_PER_CHUNK;
+	unsigned int			ret = 0;
+
+	while (bits--) {
+		if (freemask & 1)
+			ret++;
+		freemask >>= 1;
+	}
+
+	return ret;
+}
+
+/* Make sure the free mask is consistent with what the inodes think. */
+STATIC int
+xfs_scrub_iallocbt_check_freemask(
+	struct xfs_scrub_btree		*bs,
+	struct xfs_inobt_rec_incore	*irec)
+{
+	struct xfs_owner_info		oinfo;
+	struct xfs_imap			imap;
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_dinode		*dip;
+	struct xfs_buf			*bp;
+	xfs_ino_t			fsino;
+	xfs_agino_t			nr_inodes;
+	xfs_agino_t			agino;
+	xfs_agino_t			chunkino;
+	xfs_agino_t			clusterino;
+	xfs_agblock_t			agbno;
+	int				blks_per_cluster;
+	__uint16_t			holemask;
+	__uint16_t			ir_holemask;
+	int				error = 0;
+
+	/* Make sure the freemask matches the inode records. */
+	blks_per_cluster = xfs_icluster_size_fsb(mp);
+	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+
+	for (agino = irec->ir_startino;
+	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
+	     agino += blks_per_cluster * mp->m_sb.sb_inopblock) {
+		fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
+		chunkino = agino - irec->ir_startino;
+		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+
+		/* Compute the holemask mask for this cluster. */
+		for (clusterino = 0, holemask = 0; clusterino < nr_inodes;
+		     clusterino += XFS_INODES_PER_HOLEMASK_BIT)
+			holemask |= XFS_INOBT_MASK((chunkino + clusterino) /
+					XFS_INODES_PER_HOLEMASK_BIT);
+
+		/* The whole cluster must be a hole or not a hole. */
+		ir_holemask = (irec->ir_holemask & holemask);
+		XFS_SCRUB_BTREC_CHECK(bs, ir_holemask == holemask ||
+				ir_holemask == 0);
+
+		/* If any part of this is a hole, skip it. */
+		if (ir_holemask)
+			goto next_cluster;
+
+		/* Grab the inode cluster buffer. */
+		imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno,
+				agbno);
+		imap.im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
+		imap.im_boffset = 0;
+
+		error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap,
+				&dip, &bp, 0, 0);
+		XFS_SCRUB_BTREC_OP_ERROR_GOTO(bs, &error, next_cluster);
+
+		/* Which inodes are free? */
+		for (clusterino = 0; clusterino < nr_inodes; clusterino++) {
+			dip = xfs_buf_offset(bp, clusterino * mp->m_sb.sb_inodesize);
+			XFS_SCRUB_BTREC_GOTO(bs,
+					be16_to_cpu(dip->di_magic) ==
+					XFS_DINODE_MAGIC, next_cluster_brelse);
+			XFS_SCRUB_BTREC_GOTO(bs,
+					dip->di_version < 3 ||
+					be64_to_cpu(dip->di_ino) ==
+						fsino + clusterino,
+					next_cluster_brelse);
+			XFS_SCRUB_BTREC_CHECK(bs,
+					!!(dip->di_nlink || dip->di_onlink) ^
+					!!(irec->ir_free &
+					XFS_INOBT_MASK(chunkino + clusterino)));
+		}
+next_cluster_brelse:
+		xfs_trans_brelse(bs->cur->bc_tp, bp);
+next_cluster:
+		;
+	}
+
+	return error;
+}
+
+/* Scrub an inobt/finobt record. */
+STATIC int
+xfs_scrub_iallocbt_helper(
+	struct xfs_scrub_btree		*bs,
+	union xfs_btree_rec		*rec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_agi			*agi;
+	struct xfs_inobt_rec_incore	irec;
+	uint64_t			holes;
+	xfs_agino_t			agino;
+	xfs_agblock_t			agbno;
+	xfs_extlen_t			len;
+	bool				keep_scanning;
+	int				holecount;
+	int				i;
+	int				error = 0;
+	int				err2 = 0;
+	unsigned int			real_freecount;
+	__uint16_t			holemask;
+
+	xfs_inobt_btrec_to_irec(mp, rec, &irec);
+
+	XFS_SCRUB_BTREC_CHECK(bs, irec.ir_count <= XFS_INODES_PER_CHUNK);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.ir_freecount <= XFS_INODES_PER_CHUNK);
+	real_freecount = irec.ir_freecount +
+			(XFS_INODES_PER_CHUNK - irec.ir_count);
+	XFS_SCRUB_BTREC_CHECK(bs, real_freecount ==
+			xfs_scrub_iallocbt_freecount(irec.ir_free));
+	agi = XFS_BUF_TO_AGI(bs->sc->sa.agi_bp);
+	agino = irec.ir_startino;
+	agbno = XFS_AGINO_TO_AGBNO(mp, irec.ir_startino);
+	XFS_SCRUB_BTREC_GOTO(bs, agbno < be32_to_cpu(agi->agi_length), out);
+
+	/* Handle non-sparse inodes */
+	if (!xfs_inobt_issparse(irec.ir_holemask)) {
+		len = XFS_B_TO_FSB(mp,
+				XFS_INODES_PER_CHUNK * mp->m_sb.sb_inodesize);
+		XFS_SCRUB_BTREC_CHECK(bs,
+				irec.ir_count == XFS_INODES_PER_CHUNK);
+
+		error = xfs_scrub_iallocbt_chunk(bs, &irec, agino, len,
+				&keep_scanning);
+		if (error)
+			goto out;
+		goto check_freemask;
+	}
+
+	/* Check each chunk of a sparse inode cluster. */
+	holemask = irec.ir_holemask;
+	holecount = 0;
+	len = XFS_B_TO_FSB(mp,
+			XFS_INODES_PER_HOLEMASK_BIT * mp->m_sb.sb_inodesize);
+	holes = ~xfs_inobt_irec_to_allocmask(&irec);
+	XFS_SCRUB_BTREC_CHECK(bs, (holes & irec.ir_free) == holes);
+	XFS_SCRUB_BTREC_CHECK(bs, irec.ir_freecount <= irec.ir_count);
+
+	for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; holemask >>= 1,
+			i++, agino += XFS_INODES_PER_HOLEMASK_BIT) {
+		if (holemask & 1) {
+			holecount += XFS_INODES_PER_HOLEMASK_BIT;
+			continue;
+		}
+
+		err2 = xfs_scrub_iallocbt_chunk(bs, &irec, agino, len,
+				&keep_scanning);
+		if (!error && err2)
+			error = err2;
+		if (!keep_scanning)
+			break;
+	}
+
+	XFS_SCRUB_BTREC_CHECK(bs, holecount <= XFS_INODES_PER_CHUNK);
+	XFS_SCRUB_BTREC_CHECK(bs, holecount + irec.ir_count ==
+			XFS_INODES_PER_CHUNK);
+
+check_freemask:
+	error = xfs_scrub_iallocbt_check_freemask(bs, &irec);
+	if (error)
+		goto out;
+
+out:
+	return error;
+}
+
+/* Scrub the inode btrees for some AG. */
+STATIC int
+xfs_scrub_iallocbt(
+	struct xfs_scrub_context	*sc,
+	xfs_btnum_t			which)
+{
+	struct xfs_btree_cur		*cur;
+	struct xfs_owner_info		oinfo;
+
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
+	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
+	return xfs_scrub_btree(sc, cur, xfs_scrub_iallocbt_helper,
+			&oinfo, NULL);
+}
+
+int
+xfs_scrub_inobt(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_iallocbt(sc, XFS_BTNUM_INO);
+}
+
+int
+xfs_scrub_finobt(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_scrub_iallocbt(sc, XFS_BTNUM_FINO);
+}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d17cee5..a00c6c5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3468,7 +3468,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }, \
 	{ XFS_SCRUB_TYPE_AGI,		"AGI" }, \
 	{ XFS_SCRUB_TYPE_BNOBT,		"bnobt" }, \
-	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }
+	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }, \
+	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
+	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

