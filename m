Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35087 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdGUEjh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:39:37 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6L4da1r009653
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:39:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v6L4da7e012792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:39:36 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v6L4dard006494
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:39:36 GMT
Subject: [PATCH 10/22] xfs: scrub inode btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jul 2017 21:39:34 -0700
Message-ID: <150061197454.14732.6179560461009984483.stgit@magnolia>
In-Reply-To: <150061190859.14732.17040548800470377701.stgit@magnolia>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the records of the inode btrees to make sure that the values
make sense given the inode records themselves.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/libxfs/xfs_format.h |    2 
 fs/xfs/libxfs/xfs_fs.h     |    4 -
 fs/xfs/scrub/common.c      |    9 +
 fs/xfs/scrub/common.h      |    3 
 fs/xfs/scrub/ialloc.c      |  347 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h         |    4 -
 7 files changed, 367 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/ialloc.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ce492ee..5197bea 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -144,6 +144,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   alloc.o \
 				   btree.o \
 				   common.o \
+				   ialloc.o \
 				   metabufs.o \
 				   )
 endif
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 23229f0..154c3dd 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -518,7 +518,7 @@ static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
 		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
 }
 
-static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index bb36acf..5120cfd 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -489,7 +489,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_AGI	5	/* AG inode header */
 #define XFS_SCRUB_TYPE_BNOBT	6	/* freesp by block btree */
 #define XFS_SCRUB_TYPE_CNTBT	7	/* freesp by length btree */
-#define XFS_SCRUB_TYPE_MAX	7
+#define XFS_SCRUB_TYPE_INOBT	8	/* inode btree */
+#define XFS_SCRUB_TYPE_FINOBT	9	/* free inode btree */
+#define XFS_SCRUB_TYPE_MAX	9
 
 /* i: repair this metadata */
 #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 86161b5..9a31846 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -716,6 +716,15 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 		.setup	= xfs_scrub_setup_ag_allocbt,
 		.scrub	= xfs_scrub_cntbt,
 	},
+	{ /* inobt */
+		.setup	= xfs_scrub_setup_ag_iallocbt,
+		.scrub	= xfs_scrub_inobt,
+	},
+	{ /* finobt */
+		.setup	= xfs_scrub_setup_ag_iallocbt,
+		.scrub	= xfs_scrub_finobt,
+		.has	= xfs_sb_version_hasfinobt,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index f14abfb..cd89bec 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -210,6 +210,7 @@ SETUP_FN(xfs_scrub_setup_fs);
 SETUP_FN(xfs_scrub_setup_metabufs);
 SETUP_FN(xfs_scrub_setup_ag_header);
 SETUP_FN(xfs_scrub_setup_ag_allocbt);
+SETUP_FN(xfs_scrub_setup_ag_iallocbt);
 #undef SETUP_FN
 
 /* Metadata scrubbers */
@@ -223,6 +224,8 @@ SCRUB_FN(xfs_scrub_agfl);
 SCRUB_FN(xfs_scrub_agi);
 SCRUB_FN(xfs_scrub_bnobt);
 SCRUB_FN(xfs_scrub_cntbt);
+SCRUB_FN(xfs_scrub_inobt);
+SCRUB_FN(xfs_scrub_finobt);
 #undef SCRUB_FN
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
new file mode 100644
index 0000000..ecf1852
--- /dev/null
+++ b/fs/xfs/scrub/ialloc.c
@@ -0,0 +1,347 @@
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
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+
+/*
+ * Set us up to scrub inode btrees.
+ * If we detect a discrepancy between the inobt and the inode,
+ * try again after forcing logged inode cores out to disk.
+ */
+int
+xfs_scrub_setup_ag_iallocbt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	return xfs_scrub_setup_ag_btree(sc, ip, sc->try_harder);
+}
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
+/* Check a particular inode with ir_free. */
+STATIC int
+xfs_scrub_iallocbt_check_cluster_freemask(
+	struct xfs_scrub_btree		*bs,
+	xfs_ino_t			fsino,
+	xfs_agino_t			chunkino,
+	xfs_agino_t			clusterino,
+	struct xfs_inobt_rec_incore	*irec,
+	struct xfs_buf			*bp)
+{
+	struct xfs_dinode		*dip;
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	bool				freemask_ok;
+	bool				inuse;
+	int				error;
+
+	dip = xfs_buf_offset(bp, clusterino * mp->m_sb.sb_inodesize);
+	XFS_SCRUB_BTREC_GOTO(bs,
+			be16_to_cpu(dip->di_magic) == XFS_DINODE_MAGIC,
+			out);
+	XFS_SCRUB_BTREC_GOTO(bs,
+			dip->di_version < 3 || be64_to_cpu(dip->di_ino) ==
+				fsino + clusterino,
+			out);
+	freemask_ok = !!(irec->ir_free & XFS_INOBT_MASK(chunkino + clusterino));
+	error = xfs_icache_inode_is_allocated(mp, bs->cur->bc_tp,
+			fsino + clusterino, &inuse);
+	if (error == -ENOENT) {
+		/* Not cached, just read the disk buffer */
+		freemask_ok ^= !!(dip->di_mode);
+		if (!bs->sc->try_harder && !freemask_ok)
+			return -EDEADLOCK;
+	} else if (error < 0) {
+		/* Inode is only half assembled, don't bother. */
+		freemask_ok = true;
+	} else {
+		/* Inode is all there. */
+		freemask_ok ^= inuse;
+	}
+	XFS_SCRUB_BTREC_CHECK(bs, freemask_ok);
+out:
+	return 0;
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
+	uint16_t			holemask;
+	uint16_t			ir_holemask;
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
+			continue;
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
+			error = xfs_scrub_iallocbt_check_cluster_freemask(bs,
+					fsino, chunkino, clusterino, irec, bp);
+			if (error) {
+				xfs_trans_brelse(bs->cur->bc_tp, bp);
+				return error;
+			}
+		}
+
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
+	uint16_t			holemask;
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
+	XFS_SCRUB_BTREC_CHECK(bs,
+			!(agbno & (xfs_ialloc_cluster_alignment(mp) - 1)));
+	XFS_SCRUB_BTREC_CHECK(bs, !(agbno & (xfs_icluster_size_fsb(mp) - 1)));
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
index 4a9a645..e2c5f99 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3319,7 +3319,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_AGFL,		"AGFL" }, \
 	{ XFS_SCRUB_TYPE_AGI,		"AGI" }, \
 	{ XFS_SCRUB_TYPE_BNOBT,		"bnobt" }, \
-	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }
+	{ XFS_SCRUB_TYPE_CNTBT,		"cntbt" }, \
+	{ XFS_SCRUB_TYPE_INOBT,		"inobt" }, \
+	{ XFS_SCRUB_TYPE_FINOBT,	"finobt" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

