Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BB5C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2036921848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qMKmMQn0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731432AbfJIQuh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:50:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57752 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731192AbfJIQuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:50:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjjFm003644
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=iN+xiu9lU1MWm9CsInFAtwhpmVlCSQldw36rY6Ak6Og=;
 b=qMKmMQn02bUNM7Zpyk2ZkAE1+HWuvVcaeoY6lA2ymZ6Vqpo3X4B0sJsNlJmWr10ID4HV
 de8B5D6nKkgmPQxYGHVNnnh/EltA0lJ3AI27iUC1M43yqhHmTSlOjNyI+piF6kZM7Kpw
 aUcZytxnbyVTUn+BwLRA45lZ4xs9xEKIqtpnWwQfBlo2Zfdd/l2BCzurJxfooNPDi3gK
 buc8uCowpaJFKw+jgzgbSQIKt2eMVLOUibrcCsURrDDq0RQOwrtAaMXWPEasOuiDP6Dg
 ak/5CGY9wr1ew+UUk1H5h2j07JDoSVilqh7fOgf62YnVngZ95kNLOAbND3eV/5BPdbft 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vek4qp00q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GicrG144843
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vh8k148nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:33 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99GoWBw026987
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:50:31 -0700
Subject: [PATCH 3/4] xfs: repair inode btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:50:30 -0700
Message-ID: <157063983066.2915883.15531447669709004709.stgit@magnolia>
In-Reply-To: <157063980873.2915883.8510302923584220865.stgit@magnolia>
References: <157063980873.2915883.8510302923584220865.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the rmapbt to find inode chunks, query the chunks to compute
hole and free masks, and with that information rebuild the inobt
and finobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/libxfs/xfs_ialloc.c       |   20 +
 fs/xfs/libxfs/xfs_ialloc.h       |    1 
 fs/xfs/libxfs/xfs_ialloc_btree.c |    2 
 fs/xfs/libxfs/xfs_ialloc_btree.h |    2 
 fs/xfs/scrub/common.c            |    1 
 fs/xfs/scrub/ialloc_repair.c     |  771 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c            |   23 +
 fs/xfs/scrub/repair.h            |   16 +
 fs/xfs/scrub/scrub.c             |    6 
 fs/xfs/scrub/scrub.h             |    1 
 fs/xfs/scrub/trace.h             |   68 ++-
 12 files changed, 868 insertions(+), 44 deletions(-)
 create mode 100644 fs/xfs/scrub/ialloc_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ffcebf428ca9..6ca9755f031e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -163,6 +163,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   alloc_repair.o \
 				   array.o \
 				   bitmap.o \
+				   ialloc_repair.o \
 				   repair.o \
 				   xfile.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 588d44613094..d4301d2e9f10 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -95,6 +95,19 @@ xfs_inobt_btrec_to_irec(
 	irec->ir_free = be64_to_cpu(rec->inobt.ir_free);
 }
 
+uint8_t
+xfs_inobt_rec_freecount(
+	const struct xfs_inobt_rec_incore	*irec)
+{
+	uint64_t				realfree;
+
+	if (!xfs_inobt_issparse(irec->ir_holemask))
+		realfree = irec->ir_free;
+	else
+		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);
+	return hweight64(realfree);
+}
+
 /*
  * Get the data from the pointed-to record.
  */
@@ -108,7 +121,6 @@ xfs_inobt_get_rec(
 	xfs_agnumber_t			agno = cur->bc_private.a.agno;
 	union xfs_btree_rec		*rec;
 	int				error;
-	uint64_t			realfree;
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (error || *stat == 0)
@@ -125,11 +137,7 @@ xfs_inobt_get_rec(
 		goto out_bad_rec;
 
 	/* if there are no holes, return the first available offset */
-	if (!xfs_inobt_issparse(irec->ir_holemask))
-		realfree = irec->ir_free;
-	else
-		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);
-	if (hweight64(realfree) != irec->ir_freecount)
+	if (xfs_inobt_rec_freecount(irec) != irec->ir_freecount)
 		goto out_bad_rec;
 
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 323592d563d5..a6f259ae94ed 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -125,6 +125,7 @@ int xfs_inobt_lookup(struct xfs_btree_cur *cur, xfs_agino_t ino,
  */
 int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
 		xfs_inobt_rec_incore_t *rec, int *stat);
+uint8_t xfs_inobt_rec_freecount(const struct xfs_inobt_rec_incore *irec);
 
 /*
  * Inode chunk initialisation routine
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index f61d94daa0a1..4091062a12bf 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -528,7 +528,7 @@ xfs_inobt_maxrecs(
  */
 uint64_t
 xfs_inobt_irec_to_allocmask(
-	struct xfs_inobt_rec_incore	*rec)
+	const struct xfs_inobt_rec_incore *rec)
 {
 	uint64_t			bitmap = 0;
 	uint64_t			inodespbit;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 9265b3e08c69..9d14e9cfee21 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -54,7 +54,7 @@ struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
-uint64_t xfs_inobt_irec_to_allocmask(struct xfs_inobt_rec_incore *);
+uint64_t xfs_inobt_irec_to_allocmask(const struct xfs_inobt_rec_incore *i);
 
 #if defined(DEBUG) || defined(XFS_WARN)
 int xfs_inobt_rec_check_count(struct xfs_mount *,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 4a49a9099477..abe88fa756aa 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -527,6 +527,7 @@ xchk_ag_free(
 	struct xchk_ag		*sa)
 {
 	xchk_ag_btcur_free(sa);
+	xrep_reset_perag_resv(sc);
 	if (sa->agfl_bp) {
 		xfs_trans_brelse(sc->tp, sa->agfl_bp);
 		sa->agfl_bp = NULL;
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
new file mode 100644
index 000000000000..c13c7b7cfb1a
--- /dev/null
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -0,0 +1,771 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
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
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_icache.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
+#include "xfs_error.h"
+#include "xfs_health.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/array.h"
+
+/*
+ * Inode Btree Repair
+ * ==================
+ *
+ * A quick refresher of inode btrees on a v5 filesystem:
+ *
+ * - Inode records are read into memory in units of 'inode clusters'.  However
+ *   many inodes fit in a cluster buffer is the smallest number of inodes that
+ *   can be allocated or freed.  Clusters are never smaller than one fs block
+ *   though they can span multiple blocks.  The size (in fs blocks) is
+ *   computed with xfs_icluster_size_fsb().  The fs block alignment of a
+ *   cluster is computed with xfs_ialloc_cluster_alignment().
+ *
+ * - Each inode btree record can describe a single 'inode chunk'.  The chunk
+ *   size is defined to be 64 inodes.  If sparse inodes are enabled, every
+ *   inobt record must be aligned to the chunk size; if not, every record must
+ *   be aligned to the start of a cluster.  It is possible to construct an XFS
+ *   geometry where one inobt record maps to multiple inode clusters; it is
+ *   also possible to construct a geometry where multiple inobt records map to
+ *   different parts of one inode cluster.
+ *
+ * - If sparse inodes are not enabled, the smallest unit of allocation for
+ *   inode records is enough to contain one inode chunk's worth of inodes.
+ *
+ * - If sparse inodes are enabled, the holemask field will be active.  Each
+ *   bit of the holemask represents 4 potential inodes; if set, the
+ *   corresponding space does *not* contain inodes and must be left alone.
+ *   Clusters cannot be smaller than 4 inodes.  The smallest unit of allocation
+ *   of inode records is one inode cluster.
+ *
+ * So what's the rebuild algorithm?
+ *
+ * Iterate the reverse mapping records looking for OWN_INODES and OWN_INOBT
+ * records.  The OWN_INOBT records are the old inode btree blocks and will be
+ * cleared out after we've rebuilt the tree.  Each possible inode cluster
+ * within an OWN_INODES record will be read in; for each possible inobt record
+ * associated with that cluster, compute the freemask calculated from the
+ * i_mode data in the inode chunk.  For sparse inodes the holemask will be
+ * calculated by creating the properly aligned inobt record and punching out
+ * any chunk that's missing.  Inode allocations and frees grab the AGI first,
+ * so repair protects itself from concurrent access by locking the AGI.
+ *
+ * Once we've reconstructed all the inode records, we can create new inode
+ * btree roots and reload the btrees.  We rebuild both inode trees at the same
+ * time because they have the same rmap owner and it would be more complex to
+ * figure out if the other tree isn't in need of a rebuild and which OWN_INOBT
+ * blocks it owns.  We have all the data we need to build both, so dump
+ * everything and start over.
+ *
+ * We use the prefix 'xrep_ibt' because we rebuild both inode btrees at once.
+ */
+
+struct xrep_ibt {
+	/* Record under construction. */
+	struct xfs_inobt_rec_incore	rie;
+
+	/* new inobt information */
+	struct xrep_newbt	new_inobt_info;
+
+	/* new finobt information */
+	struct xrep_newbt	new_finobt_info;
+
+	/* Old inode btree blocks we found in the rmap. */
+	struct xbitmap		old_iallocbt_blocks;
+
+	/* Reconstructed inode records. */
+	struct xfbma		*inode_records;
+
+	struct xfs_scrub	*sc;
+
+	/* Number of inodes assigned disk space. */
+	unsigned int		icount;
+
+	/* Number of inodes in use. */
+	unsigned int		iused;
+
+	/* Number of finobt records needed. */
+	unsigned int		finobt_recs;
+
+	/* get_data()'s position in the inode record array. */
+	uint64_t		iter;
+};
+
+/*
+ * Is this inode in use?  If the inode is in memory we can tell from i_mode,
+ * otherwise we have to check di_mode in the on-disk buffer.  We only care
+ * that the high (i.e. non-permission) bits of _mode are zero.  This should be
+ * safe because repair keeps all AG headers locked until the end, and process
+ * trying to perform an inode allocation/free must lock the AGI.
+ *
+ * @cluster_ag_base is the inode offset of the cluster within the AG.
+ * @cluster_bp is the cluster buffer.
+ * @cluster_index is the inode offset within the inode cluster.
+ */
+STATIC int
+xrep_ibt_check_ifree(
+	struct xrep_ibt		*ri,
+	xfs_agino_t		cluster_ag_base,
+	struct xfs_buf		*cluster_bp,
+	unsigned int		cluster_index,
+	bool			*inuse)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_dinode	*dip;
+	xfs_ino_t		fsino;
+	xfs_agnumber_t		agno = ri->sc->sa.agno;
+	unsigned int		cluster_buf_base;
+	unsigned int		offset;
+	int			error;
+
+	fsino = XFS_AGINO_TO_INO(mp, agno, cluster_ag_base + cluster_index);
+
+	/* Inode uncached or half assembled, read disk buffer */
+	cluster_buf_base = XFS_INO_TO_OFFSET(mp, cluster_ag_base);
+	offset = (cluster_buf_base + cluster_index) * mp->m_sb.sb_inodesize;
+	if (offset >= BBTOB(cluster_bp->b_length))
+		return -EFSCORRUPTED;
+	dip = xfs_buf_offset(cluster_bp, offset);
+	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC)
+		return -EFSCORRUPTED;
+
+	if (dip->di_version >= 3 && be64_to_cpu(dip->di_ino) != fsino)
+		return -EFSCORRUPTED;
+
+	/* Will the in-core inode tell us if it's in use? */
+	error = xfs_icache_inode_is_allocated(mp, sc->tp, fsino, inuse);
+	if (!error)
+		return 0;
+
+	*inuse = dip->di_mode != 0;
+	return 0;
+}
+
+/* Stash the accumulated inobt record for rebuilding. */
+STATIC int
+xrep_ibt_stash_record(
+	struct xrep_ibt		*ri)
+{
+	int			error;
+
+	ri->rie.ir_freecount = xfs_inobt_rec_freecount(&ri->rie);
+	if (ri->rie.ir_freecount > 0)
+		ri->finobt_recs++;
+
+	trace_xrep_ibt_found(ri->sc->mp, ri->sc->sa.agno, ri->rie.ir_startino,
+			ri->rie.ir_holemask, ri->rie.ir_count,
+			ri->rie.ir_freecount, ri->rie.ir_free);
+
+	error = xfbma_append(ri->inode_records, &ri->rie);
+	if (error)
+		return error;
+	ri->rie.ir_startino = NULLAGINO;
+	return 0;
+}
+
+/*
+ * Given an extent of inodes and an inode cluster buffer, calculate the
+ * location of the corresponding inobt record (creating it if necessary),
+ * then update the parts of the holemask and freemask of that record that
+ * correspond to the inode extent we were given.
+ *
+ * @cluster_ir_startino is the AG inode number of an inobt record that we're
+ * proposing to create for this inode cluster.  If sparse inodes are enabled,
+ * we must round down to a chunk boundary to find the actual sparse record.
+ * @cluster_bp is the buffer of the inode cluster.
+ * @nr_inodes is the number of inodes to check from the cluster.
+ */
+STATIC int
+xrep_ibt_cluster_record(
+	struct xrep_ibt		*ri,
+	xfs_agino_t		cluster_ir_startino,
+	struct xfs_buf		*cluster_bp,
+	unsigned int		nr_inodes)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_mount	*mp = sc->mp;
+	xfs_agino_t		ir_startino;
+	unsigned int		cluster_base;
+	unsigned int		cluster_index;
+	bool			inuse;
+	int			error = 0;
+
+	ir_startino = cluster_ir_startino;
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		ir_startino = rounddown(ir_startino, XFS_INODES_PER_CHUNK);
+	cluster_base = cluster_ir_startino - ir_startino;
+
+	/*
+	 * If the accumulated inobt record doesn't map this cluster, add it to
+	 * the list and reset it.
+	 */
+	if (ri->rie.ir_startino != NULLAGINO &&
+	    ri->rie.ir_startino + XFS_INODES_PER_CHUNK <= ir_startino) {
+		error = xrep_ibt_stash_record(ri);
+		if (error)
+			return error;
+	}
+
+	if (ri->rie.ir_startino == NULLAGINO) {
+		ri->rie.ir_startino = ir_startino;
+		ri->rie.ir_free = XFS_INOBT_ALL_FREE;
+		ri->rie.ir_holemask = 0xFFFF;
+		ri->rie.ir_count = 0;
+	}
+
+	/* Record the whole cluster. */
+	ri->icount += nr_inodes;
+	ri->rie.ir_count += nr_inodes;
+	ri->rie.ir_holemask &= ~xfs_inobt_maskn(
+				cluster_base / XFS_INODES_PER_HOLEMASK_BIT,
+				nr_inodes / XFS_INODES_PER_HOLEMASK_BIT);
+
+	/* Which inodes within this cluster are free? */
+	for (cluster_index = 0; cluster_index < nr_inodes; cluster_index++) {
+		error = xrep_ibt_check_ifree(ri, cluster_ir_startino,
+				cluster_bp, cluster_index, &inuse);
+		if (error)
+			return error;
+		if (!inuse)
+			continue;
+		ri->iused++;
+		ri->rie.ir_free &= ~XFS_INOBT_MASK(cluster_base +
+						   cluster_index);
+	}
+	return 0;
+}
+
+/*
+ * For each inode cluster covering the physical extent recorded by the rmapbt,
+ * we must calculate the properly aligned startino of that cluster, then
+ * iterate each cluster to fill in used and filled masks appropriately.  We
+ * then use the (startino, used, filled) information to construct the
+ * appropriate inode records.
+ */
+STATIC int
+xrep_ibt_process_cluster(
+	struct xrep_ibt		*ri,
+	xfs_agblock_t		cluster_bno)
+{
+	struct xfs_imap		imap;
+	struct xfs_dinode	*dip;
+	struct xfs_buf		*cluster_bp;
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_agino_t		cluster_ag_base;
+	xfs_agino_t		irec_index;
+	unsigned int		nr_inodes;
+	int			error;
+
+	nr_inodes = min_t(unsigned int, igeo->inodes_per_cluster,
+			XFS_INODES_PER_CHUNK);
+
+	/*
+	 * Grab the inode cluster buffer.  This is safe to do with a broken
+	 * inobt because imap_to_bp directly maps the buffer without touching
+	 * either inode btree.
+	 */
+	imap.im_blkno = XFS_AGB_TO_DADDR(mp, sc->sa.agno, cluster_bno);
+	imap.im_len = XFS_FSB_TO_BB(mp, igeo->blocks_per_cluster);
+	imap.im_boffset = 0;
+	error = xfs_imap_to_bp(mp, sc->tp, &imap, &dip, &cluster_bp, 0, 0);
+	if (error)
+		return error;
+
+	/*
+	 * Record the contents of each possible inobt record mapping this
+	 * cluster.
+	 */
+	cluster_ag_base = XFS_AGB_TO_AGINO(mp, cluster_bno);
+	for (irec_index = 0;
+	     irec_index < igeo->inodes_per_cluster;
+	     irec_index += XFS_INODES_PER_CHUNK) {
+		error = xrep_ibt_cluster_record(ri,
+				cluster_ag_base + irec_index, cluster_bp,
+				nr_inodes);
+		if (error)
+			break;
+
+	}
+
+	xfs_trans_brelse(sc->tp, cluster_bp);
+	return error;
+}
+
+/* Record extents that belong to inode btrees. */
+STATIC int
+xrep_ibt_walk_rmap(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv)
+{
+	struct xrep_ibt		*ri = priv;
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_fsblock_t		fsbno;
+	xfs_agblock_t		agbno = rec->rm_startblock;
+	xfs_agblock_t		cluster_base;
+	int			error = 0;
+
+	if (xchk_should_terminate(ri->sc, &error))
+		return error;
+
+	/* Fragment of the old btrees; dispose of them later. */
+	if (rec->rm_owner == XFS_RMAP_OWN_INOBT) {
+		fsbno = XFS_AGB_TO_FSB(mp, ri->sc->sa.agno, agbno);
+		return xbitmap_set(&ri->old_iallocbt_blocks, fsbno,
+				rec->rm_blockcount);
+	}
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != XFS_RMAP_OWN_INODES)
+		return 0;
+
+	/* The entire record must align to the inode cluster size. */
+	if (agbno & (igeo->blocks_per_cluster - 1) ||
+	    (agbno + rec->rm_blockcount) & (igeo->blocks_per_cluster - 1))
+		return -EFSCORRUPTED;
+
+	/*
+	 * The entire record must also adhere to the inode cluster alignment
+	 * size if sparse inodes are not enabled.
+	 */
+	if (!xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	    (agbno & (igeo->cluster_align - 1) ||
+	     (agbno + rec->rm_blockcount) & (igeo->cluster_align - 1)))
+		return -ENAVAIL;
+
+	/*
+	 * On a sparse inode fs, this cluster could be part of a sparse chunk.
+	 * Sparse clusters must be aligned to sparse chunk alignment.
+	 */
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	    (agbno & (mp->m_sb.sb_spino_align - 1) ||
+	     (agbno + rec->rm_blockcount) & (mp->m_sb.sb_spino_align - 1)))
+		return -EREMOTEIO;
+
+	trace_xrep_ibt_walk_rmap(mp, ri->sc->sa.agno, rec->rm_startblock,
+			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
+			rec->rm_flags);
+
+	/*
+	 * Record the free/hole masks for each inode cluster that could be
+	 * mapped by this rmap record.
+	 */
+	for (cluster_base = 0;
+	     cluster_base < rec->rm_blockcount;
+	     cluster_base += igeo->blocks_per_cluster) {
+		error = xrep_ibt_process_cluster(ri, agbno + cluster_base);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Compare two ialloc extents. */
+static int
+xfs_inobt_rec_incore_cmp(
+	const void				*a,
+	const void				*b)
+{
+	const struct xfs_inobt_rec_incore	*ap = a;
+	const struct xfs_inobt_rec_incore	*bp = b;
+
+	if (ap->ir_startino > bp->ir_startino)
+		return 1;
+	else if (ap->ir_startino < bp->ir_startino)
+		return -1;
+	return 0;
+}
+
+/*
+ * Iterate all reverse mappings to find the inodes (OWN_INODES) and the inode
+ * btrees (OWN_INOBT).  Figure out if we have enough free space to reconstruct
+ * the inode btrees.  The caller must clean up the lists if anything goes
+ * wrong.
+ */
+STATIC int
+xrep_ibt_find_inodes(
+	struct xrep_ibt		*ri)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	ri->rie.ir_startino = NULLAGINO;
+
+	/* Collect all reverse mappings for inode blocks. */
+	cur = xfs_rmapbt_init_cursor(mp, sc->tp, sc->sa.agf_bp, sc->sa.agno);
+	error = xfs_rmap_query_all(cur, xrep_ibt_walk_rmap, ri);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		return error;
+
+	/* If we have a record ready to go, add it to the array. */
+	if (ri->rie.ir_startino != NULLAGINO) {
+		error = xrep_ibt_stash_record(ri);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Update the AGI counters. */
+STATIC int
+xrep_ibt_reset_counters(
+	struct xrep_ibt		*ri)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_agi		*agi;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_buf		*bp;
+	unsigned int		freecount;
+
+	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	freecount = ri->icount - ri->iused;
+
+	/* Trigger inode count recalculation */
+	xfs_force_summary_recalc(sc->mp);
+
+	/*
+	 * Mark the pagi information stale and use the accessor function to
+	 * forcibly reload it from the values we just logged.  We still own
+	 * the AGI bp so we can throw away bp.
+	 */
+	ASSERT(pag->pagi_init);
+	pag->pagi_init = 0;
+
+	agi->agi_count = cpu_to_be32(ri->icount);
+	agi->agi_freecount = cpu_to_be32(freecount);
+	xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp,
+			   XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
+
+	return xfs_ialloc_read_agi(sc->mp, sc->tp, sc->sa.agno, &bp);
+}
+
+/* Do we even want this record? */
+static inline bool
+xrep_ibt_rec_wanted(
+	struct xrep_ibt			*ri,
+	struct xfs_btree_cur		*cur,
+	struct xfs_inobt_rec_incore	*irec)
+{
+	/* Ignore null records. */
+	if (xfbma_is_null(ri->inode_records, irec))
+		return false;
+
+	/* finobt only wants inode records with at least 1 free inode. */
+	if (cur->bc_btnum == XFS_BTNUM_FINO &&
+	    xfs_inobt_rec_freecount(irec) == 0)
+		return false;
+
+	return true;
+}
+
+/* Retrieve inobt data for bulk load. */
+STATIC int
+xrep_ibt_get_data(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
+{
+	struct xfs_inobt_rec_incore	*irec = &cur->bc_rec.i;
+	struct xrep_ibt			*ri = priv;
+	int				error;
+
+	do {
+		error = xfbma_get(ri->inode_records, ri->iter++, irec);
+	} while (error == 0 && !xrep_ibt_rec_wanted(ri, cur, irec));
+
+	return error;
+}
+
+/* Feed one of the new inobt blocks to the bulk loader. */
+STATIC int
+xrep_ibt_bload_alloc(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_ibt		*ri = priv;
+
+	if (cur->bc_btnum == XFS_BTNUM_INO)
+		return xrep_newbt_alloc_block(cur, &ri->new_inobt_info, ptr);
+	return xrep_newbt_alloc_block(cur, &ri->new_finobt_info, ptr);
+}
+
+/* Build new inode btrees and dispose of the old one. */
+STATIC int
+xrep_ibt_build_new_trees(
+	struct xrep_ibt		*ri)
+{
+	struct xfs_btree_bload	ino_bload = {
+		.get_data	= xrep_ibt_get_data,
+		.alloc_block	= xrep_ibt_bload_alloc,
+	};
+	struct xfs_btree_bload	fino_bload = {
+		.get_data	= xrep_ibt_get_data,
+		.alloc_block	= xrep_ibt_bload_alloc,
+	};
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_btree_cur	*ino_cur;
+	struct xfs_btree_cur	*fino_cur = NULL;
+	bool			need_finobt;
+	int			error;
+
+	need_finobt = xfs_sb_version_hasfinobt(&sc->mp->m_sb);
+
+	xrep_bload_estimate_slack(sc, &ino_bload);
+	xrep_bload_estimate_slack(sc, &fino_bload);
+
+	/*
+	 * Sort the inode extents by startino or else the btree records will
+	 * be in the wrong order.
+	 */
+	error = xfbma_sort(ri->inode_records, xfs_inobt_rec_incore_cmp);
+	if (error)
+		return error;
+
+	/*
+	 * Create new btrees for staging all the inobt records we collected
+	 * earlier.  These btrees will not be rooted in the AGI until we've
+	 * successfully reloaded the tree.
+	 */
+
+	/* Set up inobt staging cursor. */
+	xrep_newbt_init_ag(&ri->new_inobt_info, sc, &XFS_RMAP_OINFO_INOBT,
+			XFS_AGB_TO_FSB(sc->mp, sc->sa.agno,
+				       XFS_IBT_BLOCK(sc->mp)),
+			XFS_AG_RESV_NONE);
+	ino_cur = xfs_inobt_stage_cursor(sc->mp, sc->tp,
+			&ri->new_inobt_info.afake, sc->sa.agno, XFS_BTNUM_INO);
+	error = xfs_btree_bload_compute_geometry(ino_cur, &ino_bload,
+			xfbma_length(ri->inode_records));
+	xfs_btree_del_cursor(ino_cur, error);
+	if (error)
+		goto err_inobt;
+
+	/* Set up finobt staging cursor. */
+	if (need_finobt) {
+		enum xfs_ag_resv_type	resv = XFS_AG_RESV_METADATA;
+
+		if (sc->mp->m_finobt_nores)
+			resv = XFS_AG_RESV_NONE;
+
+		xrep_newbt_init_ag(&ri->new_finobt_info, sc,
+				&XFS_RMAP_OINFO_INOBT,
+				XFS_AGB_TO_FSB(sc->mp, sc->sa.agno,
+					       XFS_FIBT_BLOCK(sc->mp)),
+				resv);
+		fino_cur = xfs_inobt_stage_cursor(sc->mp, sc->tp,
+				&ri->new_finobt_info.afake, sc->sa.agno,
+				XFS_BTNUM_FINO);
+		error = xfs_btree_bload_compute_geometry(fino_cur, &fino_bload,
+				ri->finobt_recs);
+		xfs_btree_del_cursor(fino_cur, error);
+		if (error)
+			goto err_finobt;
+	}
+
+	/* Reserve all the space we need to build the new btrees. */
+	error = xrep_newbt_reserve_space(&ri->new_inobt_info,
+			ino_bload.nr_blocks);
+	if (error)
+		goto err_finobt;
+
+	if (need_finobt) {
+		error = xrep_newbt_reserve_space(&ri->new_finobt_info,
+				fino_bload.nr_blocks);
+		if (error)
+			goto err_finobt;
+	}
+
+	/* Add all inobt records. */
+	ri->iter = 0;
+	ino_cur = xfs_inobt_stage_cursor(sc->mp, sc->tp,
+			&ri->new_inobt_info.afake, sc->sa.agno, XFS_BTNUM_INO);
+	error = xfs_btree_bload(ino_cur, &ino_bload, ri);
+	if (error)
+		goto err_inocur;
+
+	/* Add all finobt records. */
+	if (need_finobt) {
+		ri->iter = 0;
+		fino_cur = xfs_inobt_stage_cursor(sc->mp, sc->tp,
+				&ri->new_finobt_info.afake, sc->sa.agno,
+				XFS_BTNUM_FINO);
+		error = xfs_btree_bload(fino_cur, &fino_bload, ri);
+		if (error)
+			goto err_finocur;
+	}
+
+	/*
+	 * Re-read the AGI so that the buffer type is set properly.  Since we
+	 * built a new tree without dirtying the AGI, the buffer item may have
+	 * fallen off the buffer.  This ought to succeed since the AGI is held
+	 * across transaction rolls.
+	 */
+	error = xfs_read_agi(sc->mp, sc->tp, sc->sa.agno, &sc->sa.agi_bp);
+	if (error)
+		goto err_finocur;
+
+	/* Install new btree roots. */
+	xfs_inobt_commit_staged_btree(ino_cur, sc->sa.agi_bp);
+	xfs_btree_del_cursor(ino_cur, 0);
+
+	if (fino_cur) {
+		xfs_inobt_commit_staged_btree(fino_cur, sc->sa.agi_bp);
+		xfs_btree_del_cursor(fino_cur, 0);
+	}
+
+	/* Reset the AGI counters now that we've changed the inode roots. */
+	error = xrep_ibt_reset_counters(ri);
+	if (error)
+		goto err_finobt;
+
+	/* Free unused blocks and bitmap. */
+	if (need_finobt)
+		xrep_newbt_destroy(&ri->new_finobt_info, error);
+	xrep_newbt_destroy(&ri->new_inobt_info, error);
+
+	return xrep_roll_ag_trans(sc);
+
+err_finocur:
+	if (need_finobt)
+		xfs_btree_del_cursor(fino_cur, error);
+err_inocur:
+	xfs_btree_del_cursor(ino_cur, error);
+err_finobt:
+	if (need_finobt)
+		xrep_newbt_destroy(&ri->new_finobt_info, error);
+err_inobt:
+	xrep_newbt_destroy(&ri->new_inobt_info, error);
+	return error;
+}
+
+/*
+ * Now that we've logged the roots of the new btrees, invalidate all of the
+ * old blocks and free them.
+ */
+STATIC int
+xrep_ibt_remove_old_trees(
+	struct xrep_ibt		*ri)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	int			error;
+
+	/* Free the old inode btree blocks if they're not in use. */
+	error = xrep_reap_extents(sc, &ri->old_iallocbt_blocks,
+			&XFS_RMAP_OINFO_INOBT, XFS_AG_RESV_NONE);
+	if (error)
+		return error;
+
+	/*
+	 * If the finobt is enabled and has a per-AG reservation, make sure we
+	 * reinitialize the per-AG reservations.
+	 */
+	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb) && !sc->mp->m_finobt_nores)
+		sc->flags |= XREP_RESET_PERAG_RESV;
+
+	return 0;
+}
+
+/* Repair both inode btrees. */
+int
+xrep_iallocbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_ibt		*ri;
+	struct xfs_mount	*mp = sc->mp;
+	int			error = 0;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	ri = kmem_zalloc(sizeof(struct xrep_ibt), KM_NOFS | KM_MAYFAIL);
+	if (!ri)
+		return -ENOMEM;
+	ri->sc = sc;
+
+	xchk_perag_get(sc->mp, &sc->sa);
+
+	/* We rebuild both inode btrees. */
+	sc->sick_mask = XFS_SICK_AG_INOBT | XFS_SICK_AG_FINOBT;
+
+	/* Set up some storage */
+	ri->inode_records = xfbma_init(sizeof(struct xfs_inobt_rec_incore));
+	if (IS_ERR(ri->inode_records)) {
+		error = PTR_ERR(ri->inode_records);
+		goto out_ri;
+	}
+
+	/* Collect the inode data and find the old btree blocks. */
+	xbitmap_init(&ri->old_iallocbt_blocks);
+	error = xrep_ibt_find_inodes(ri);
+	if (error)
+		goto out_bitmap;
+
+	/* Rebuild the inode indexes. */
+	error = xrep_ibt_build_new_trees(ri);
+	if (error)
+		goto out_bitmap;
+
+	/* Kill the old tree. */
+	error = xrep_ibt_remove_old_trees(ri);
+
+out_bitmap:
+	xbitmap_destroy(&ri->old_iallocbt_blocks);
+	xfbma_destroy(ri->inode_records);
+out_ri:
+	kmem_free(ri);
+	return error;
+}
+
+/* Make sure both btrees are ok after we've rebuilt them. */
+int
+xrep_revalidate_iallocbt(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	error = xchk_inobt(sc);
+	if (error)
+		return error;
+
+	if (xfs_sb_version_hasfinobt(&sc->mp->m_sb))
+		return xchk_finobt(sc);
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 49cea124148b..aac868058091 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1258,3 +1258,26 @@ xrep_ino_dqattach(
 
 	return error;
 }
+
+/* Reinitialize the per-AG block reservation for the AG we just fixed. */
+int
+xrep_reset_perag_resv(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (!(sc->flags & XREP_RESET_PERAG_RESV))
+		return 0;
+
+	ASSERT(sc->sa.pag != NULL);
+	ASSERT(sc->ops->type == ST_PERAG);
+	ASSERT(sc->tp);
+
+	sc->flags &= ~XREP_RESET_PERAG_RESV;
+	error = xfs_ag_resv_free(sc->sa.pag);
+	if (error)
+		goto out;
+	error = xfs_ag_resv_init(sc->sa.pag, sc->tp);
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 4d6b9027b527..6719f98eae61 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -54,10 +54,12 @@ int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
 void xrep_force_quotacheck(struct xfs_scrub *sc, uint dqtype);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
+int xrep_reset_perag_resv(struct xfs_scrub *sc);
 
 /* Metadata revalidators */
 
 int xrep_revalidate_allocbt(struct xfs_scrub *sc);
+int xrep_revalidate_iallocbt(struct xfs_scrub *sc);
 
 /* Metadata repairers */
 
@@ -67,6 +69,7 @@ int xrep_agf(struct xfs_scrub *sc);
 int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
 int xrep_allocbt(struct xfs_scrub *sc);
+int xrep_iallocbt(struct xfs_scrub *sc);
 
 struct xrep_newbt_resv {
 	/* Link to list of extents that we've reserved. */
@@ -146,7 +149,19 @@ xrep_calc_ag_resblks(
 	return 0;
 }
 
+static inline int
+xrep_reset_perag_resv(
+	struct xfs_scrub	*sc)
+{
+	if (!(sc->flags & XREP_RESET_PERAG_RESV))
+		return 0;
+
+	ASSERT(0);
+	return -EOPNOTSUPP;
+}
+
 #define xrep_revalidate_allocbt		(NULL)
+#define xrep_revalidate_iallocbt	(NULL)
 
 #define xrep_probe			xrep_notsupported
 #define xrep_superblock			xrep_notsupported
@@ -154,6 +169,7 @@ xrep_calc_ag_resblks(
 #define xrep_agfl			xrep_notsupported
 #define xrep_agi			xrep_notsupported
 #define xrep_allocbt			xrep_notsupported
+#define xrep_iallocbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b42ac8ecdb49..6011823d0d40 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -231,14 +231,16 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_iallocbt,
 		.scrub	= xchk_inobt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_iallocbt,
+		.repair_eval = xrep_revalidate_iallocbt,
 	},
 	[XFS_SCRUB_TYPE_FINOBT] = {	/* finobt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_iallocbt,
 		.scrub	= xchk_finobt,
 		.has	= xfs_sb_version_hasfinobt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_iallocbt,
+		.repair_eval = xrep_revalidate_iallocbt,
 	},
 	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
 		.type	= ST_PERAG,
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 94a30637a127..16ed1d3e1404 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -89,6 +89,7 @@ struct xfs_scrub {
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
 #define XCHK_HAS_QUOTAOFFLOCK	(1 << 1)  /* we hold the quotaoff lock */
 #define XCHK_REAPING_DISABLED	(1 << 2)  /* background block reaping paused */
+#define XREP_RESET_PERAG_RESV	(1 << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
 /* Metadata scrubbers */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 754d1d71261e..e9aed8256680 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -722,7 +722,7 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 xfs_agblock_t agbno, xfs_extlen_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
-DEFINE_REPAIR_RMAP_EVENT(xrep_ialloc_extent_fn);
+DEFINE_REPAIR_RMAP_EVENT(xrep_ibt_walk_rmap);
 DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
 
@@ -749,6 +749,39 @@ TRACE_EVENT(xrep_abt_found,
 		  __entry->blockcount)
 )
 
+TRACE_EVENT(xrep_ibt_found,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agino_t startino, uint16_t holemask, uint8_t count,
+		 uint8_t freecount, uint64_t freemask),
+	TP_ARGS(mp, agno, startino, holemask, count, freecount, freemask),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, startino)
+		__field(uint16_t, holemask)
+		__field(uint8_t, count)
+		__field(uint8_t, freecount)
+		__field(uint64_t, freemask)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startino = startino;
+		__entry->holemask = holemask;
+		__entry->count = count;
+		__entry->freecount = freecount;
+		__entry->freemask = freemask;
+	),
+	TP_printk("dev %d:%d agno %d startino %u holemask 0x%x count %u freecount %u freemask 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->startino,
+		  __entry->holemask,
+		  __entry->count,
+		  __entry->freecount,
+		  __entry->freemask)
+)
+
 TRACE_EVENT(xrep_refcount_extent_fn,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 struct xfs_refcount_irec *irec),
@@ -893,39 +926,6 @@ TRACE_EVENT(xrep_reset_counters,
 		  MAJOR(__entry->dev), MINOR(__entry->dev))
 )
 
-TRACE_EVENT(xrep_ialloc_insert,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agino_t startino, uint16_t holemask, uint8_t count,
-		 uint8_t freecount, uint64_t freemask),
-	TP_ARGS(mp, agno, startino, holemask, count, freecount, freemask),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_agino_t, startino)
-		__field(uint16_t, holemask)
-		__field(uint8_t, count)
-		__field(uint8_t, freecount)
-		__field(uint64_t, freemask)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->startino = startino;
-		__entry->holemask = holemask;
-		__entry->count = count;
-		__entry->freecount = freecount;
-		__entry->freemask = freemask;
-	),
-	TP_printk("dev %d:%d agno %d startino %u holemask 0x%x count %u freecount %u freemask 0x%llx",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
-		  __entry->startino,
-		  __entry->holemask,
-		  __entry->count,
-		  __entry->freecount,
-		  __entry->freemask)
-)
-
 DECLARE_EVENT_CLASS(xrep_newbt_extent_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len,

