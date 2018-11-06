Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33014 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbeKFNcC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 08:32:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA63wuUX030162
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:49 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2nh3mpjt2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 04:08:49 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA648mAH001962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:48 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA648m5m011477
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:48 GMT
Subject: [PATCH 6/8] xfs: clean up the inode cluster checking in the inobt
 scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Nov 2018 20:08:46 -0800
Message-ID: <154147732686.32496.17362148568991301258.stgit@magnolia>
In-Reply-To: <154147728649.32496.4515247239602322709.stgit@magnolia>
References: <154147728649.32496.4515247239602322709.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The code to check inobt records against inode clusters is a mess of
poorly named variables and unnecessary parameters.  Clean the
unnecessary inode number parameters out of _check_cluster_freemask in
favor of computing them inside the function instead of making the caller
do it.  In xchk_iallocbt_check_cluster, rename the variables to make it
more obvious just what chunk_ino and cluster_ino represent.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |  130 ++++++++++++++++++++++++++++++-------------------
 fs/xfs/scrub/trace.h  |   45 +++++++++++++++++
 2 files changed, 125 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 12158ed8ad29..645b248faa80 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -147,41 +147,63 @@ xchk_iallocbt_freecount(
 	return hweight64(freemask);
 }
 
-/* Check a particular inode with ir_free. */
+/*
+ * Given the number of an inode within an inode cluster, check that the inode's
+ * allocation status matches ir_free in the inobt record.
+ *
+ * @chunk_ioff is the inode offset of the cluster within the @irec.
+ * @irec is the inobt record.
+ * @bp is the cluster buffer.
+ * @loop_ioff is the inode offset within the inode cluster.
+ */
 STATIC int
-xchk_iallocbt_check_cluster_freemask(
+xchk_iallocbt_check_cluster_ifree(
 	struct xchk_btree		*bs,
-	xfs_ino_t			fsino,
-	xfs_agino_t			chunkino,
-	xfs_agino_t			clusterino,
 	struct xfs_inobt_rec_incore	*irec,
-	struct xfs_buf			*bp)
+	unsigned int			chunk_ioff,
+	struct xfs_buf			*bp,
+	unsigned int			loop_ioff)
 {
-	struct xfs_dinode		*dip;
 	struct xfs_mount		*mp = bs->cur->bc_mp;
-	bool				inode_is_free = false;
+	struct xfs_dinode		*dip;
+	xfs_ino_t			fsino;
+	xfs_agino_t			agino;
+	unsigned int			offset;
+	bool				irec_free;
+	bool				ino_inuse;
 	bool				freemask_ok;
-	bool				inuse;
-	int				error = 0;
+	int				error;
 
 	if (xchk_should_terminate(bs->sc, &error))
 		return error;
 
-	dip = xfs_buf_offset(bp, clusterino * mp->m_sb.sb_inodesize);
+	/*
+	 * Given an inobt record, an offset of a cluster within the record,
+	 * and an offset of an inode within a cluster, compute which fs inode
+	 * we're talking about and the offset of the inode record within the
+	 * inode buffer.
+	 */
+	agino = irec->ir_startino + chunk_ioff + loop_ioff;
+	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
+	offset = loop_ioff * mp->m_sb.sb_inodesize;
+	if (offset >= BBTOB(bp->b_length)) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		goto out;
+	}
+	dip = xfs_buf_offset(bp, offset);
+	irec_free = (irec->ir_free & XFS_INOBT_MASK(chunk_ioff + loop_ioff));
+
 	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC ||
-	    (dip->di_version >= 3 &&
-	     be64_to_cpu(dip->di_ino) != fsino + clusterino)) {
+	    (dip->di_version >= 3 && be64_to_cpu(dip->di_ino) != fsino)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		goto out;
 	}
 
-	if (irec->ir_free & XFS_INOBT_MASK(chunkino + clusterino))
-		inode_is_free = true;
-	error = xfs_icache_inode_is_allocated(mp, bs->cur->bc_tp,
-			fsino + clusterino, &inuse);
+	error = xfs_icache_inode_is_allocated(mp, bs->cur->bc_tp, fsino,
+			&ino_inuse);
 	if (error == -ENODATA) {
 		/* Not cached, just read the disk buffer */
-		freemask_ok = inode_is_free ^ !!(dip->di_mode);
+		freemask_ok = irec_free ^ !!(dip->di_mode);
 		if (!bs->sc->try_harder && !freemask_ok)
 			return -EDEADLOCK;
 	} else if (error < 0) {
@@ -193,7 +215,7 @@ xchk_iallocbt_check_cluster_freemask(
 		goto out;
 	} else {
 		/* Inode is all there. */
-		freemask_ok = inode_is_free ^ inuse;
+		freemask_ok = irec_free ^ ino_inuse;
 	}
 	if (!freemask_ok)
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
@@ -201,44 +223,57 @@ xchk_iallocbt_check_cluster_freemask(
 	return 0;
 }
 
-/* Check an inode cluster. */
+/*
+ * Check that the holemask and freemask of a hypothetical inode cluster match
+ * what's actually on disk.  If sparse inodes are enabled, the cluster does
+ * not actually have to map to inodes if the corresponding holemask bit is set.
+ *
+ * @chunk_ioff is the inode offset of the cluster within the @irec.
+ */
 STATIC int
 xchk_iallocbt_check_cluster(
 	struct xchk_btree		*bs,
 	struct xchk_iallocbt		*iabt,
 	struct xfs_inobt_rec_incore	*irec,
-	xfs_agino_t			agino)
+	unsigned int			chunk_ioff)
 {
 	struct xfs_imap			imap;
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_dinode		*dip;
 	struct xfs_buf			*bp;
-	xfs_ino_t			fsino;
 	unsigned int			nr_inodes;
-	xfs_agino_t			chunkino;
-	xfs_agino_t			clusterino;
+	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
 	xfs_agblock_t			agbno;
-	uint16_t			holemask;
+	unsigned int			loop_ioff;
+	uint16_t			cluster_mask = 0;
 	uint16_t			ir_holemask;
 	int				error = 0;
 
-	/* Make sure the freemask matches the inode records. */
 	nr_inodes = min_t(unsigned int, iabt->inodes_per_cluster,
 			XFS_INODES_PER_CHUNK);
 
-	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
-	chunkino = agino - irec->ir_startino;
-	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+	/* Map this inode cluster */
+	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino + chunk_ioff);
 
-	/* Compute the holemask mask for this cluster. */
-	for (clusterino = 0, holemask = 0; clusterino < nr_inodes;
-	     clusterino += XFS_INODES_PER_HOLEMASK_BIT)
-		holemask |= XFS_INOBT_MASK((chunkino + clusterino) /
+	/* Compute a bitmask for this cluster that can be used for holemask. */
+	for (loop_ioff = 0;
+	     loop_ioff < nr_inodes;
+	     loop_ioff += XFS_INODES_PER_HOLEMASK_BIT)
+		cluster_mask |= XFS_INOBT_MASK((chunk_ioff + loop_ioff) /
 				XFS_INODES_PER_HOLEMASK_BIT);
 
+	ir_holemask = (irec->ir_holemask & cluster_mask);
+	imap.im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	imap.im_len = XFS_FSB_TO_BB(mp, iabt->blocks_per_cluster);
+	imap.im_boffset = 0;
+
+	trace_xchk_iallocbt_check_cluster(mp, agno, irec->ir_startino,
+			imap.im_blkno, imap.im_len, chunk_ioff, nr_inodes,
+			cluster_mask, ir_holemask,
+			XFS_INO_TO_OFFSET(mp, irec->ir_startino + chunk_ioff));
+
 	/* The whole cluster must be a hole or not a hole. */
-	ir_holemask = (irec->ir_holemask & holemask);
-	if (ir_holemask != holemask && ir_holemask != 0) {
+	if (ir_holemask != cluster_mask && ir_holemask != 0) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		return 0;
 	}
@@ -254,18 +289,14 @@ xchk_iallocbt_check_cluster(
 			&iabt->oinfo);
 
 	/* Grab the inode cluster buffer. */
-	imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno, agbno);
-	imap.im_len = XFS_FSB_TO_BB(mp, iabt->blocks_per_cluster);
-	imap.im_boffset = 0;
-
 	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &dip, &bp, 0, 0);
 	if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0, &error))
-		return 0;
+		return error;
 
-	/* Which inodes are free? */
-	for (clusterino = 0; clusterino < nr_inodes; clusterino++) {
-		error = xchk_iallocbt_check_cluster_freemask(bs, fsino,
-				chunkino, clusterino, irec, bp);
+	/* Check free status of each inode within this cluster. */
+	for (loop_ioff = 0; loop_ioff < nr_inodes; loop_ioff++) {
+		error = xchk_iallocbt_check_cluster_ifree(bs, irec, chunk_ioff,
+				bp, loop_ioff);
 		if (error)
 			break;
 	}
@@ -281,14 +312,13 @@ xchk_iallocbt_check_freemask(
 	struct xchk_iallocbt		*iabt,
 	struct xfs_inobt_rec_incore	*irec)
 {
-	struct xfs_mount		*mp = bs->cur->bc_mp;
-	xfs_agino_t			agino;
+	unsigned int			chunk_ioff;
 	int				error = 0;
 
-	for (agino = irec->ir_startino;
-	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
-	     agino += iabt->blocks_per_cluster * mp->m_sb.sb_inopblock) {
-		error = xchk_iallocbt_check_cluster(bs, iabt, irec, agino);
+	for (chunk_ioff = 0;
+	     chunk_ioff < XFS_INODES_PER_CHUNK;
+	     chunk_ioff += iabt->inodes_per_cluster) {
+		error = xchk_iallocbt_check_cluster(bs, iabt, irec, chunk_ioff);
 		if (error)
 			break;
 	}
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 4e20f0e48232..f1c144c6dcc5 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -480,6 +480,51 @@ TRACE_EVENT(xchk_xref_error,
 		  __entry->ret_ip)
 );
 
+TRACE_EVENT(xchk_iallocbt_check_cluster,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agino_t startino, xfs_daddr_t map_daddr,
+		 unsigned short map_len, unsigned int chunk_ino,
+		 unsigned int nr_inodes, uint16_t cluster_mask,
+		 uint16_t holemask, unsigned int cluster_ino),
+	TP_ARGS(mp, agno, startino, map_daddr, map_len, chunk_ino, nr_inodes,
+		cluster_mask, holemask, cluster_ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, startino)
+		__field(xfs_daddr_t, map_daddr)
+		__field(unsigned short, map_len)
+		__field(unsigned int, chunk_ino)
+		__field(unsigned int, nr_inodes)
+		__field(unsigned int, cluster_ino)
+		__field(uint16_t, cluster_mask)
+		__field(uint16_t, holemask)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startino = startino;
+		__entry->map_daddr = map_daddr;
+		__entry->map_len = map_len;
+		__entry->chunk_ino = chunk_ino;
+		__entry->nr_inodes = nr_inodes;
+		__entry->cluster_mask = cluster_mask;
+		__entry->holemask = holemask;
+		__entry->cluster_ino = cluster_ino;
+	),
+	TP_printk("dev %d:%d agno %d startino %u daddr 0x%llx len %d chunkino %u nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->startino,
+		  __entry->map_daddr,
+		  __entry->map_len,
+		  __entry->chunk_ino,
+		  __entry->nr_inodes,
+		  __entry->cluster_mask,
+		  __entry->holemask,
+		  __entry->cluster_ino)
+)
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
