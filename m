Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40708 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbeKFNbe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 08:31:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA63x1oq023723
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:21 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2nh33ttufb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 04:08:21 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA648K4r012424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:20 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA648KbW010874
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:20 GMT
Subject: [PATCH 2/8] xfs: calculate inode cluster geometry once during inobt
 scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Nov 2018 20:08:18 -0800
Message-ID: <154147729891.32496.12191035015614129432.stgit@magnolia>
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

Hoist all the inode cluster geometry information into struct
xchk_iallocbt instead of recomputing them over and over.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |   42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 76ae8338a42e..3c12a0fe3b38 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -45,8 +45,18 @@ xchk_setup_ag_iallocbt(
 /* Inode btree scrubber. */
 
 struct xchk_iallocbt {
+	/* owner info for inode blocks */
+	struct xfs_owner_info	oinfo;
+
 	/* Number of inodes we see while scanning inobt. */
 	unsigned long long	inodes;
+
+	/* Blocks and inodes per inode cluster. */
+	unsigned int		blocks_per_cluster;
+	unsigned int		inodes_per_cluster;
+
+	/* Block alignment of inode clusters. */
+	unsigned int		cluster_align;
 };
 
 /*
@@ -189,32 +199,30 @@ xchk_iallocbt_check_cluster_freemask(
 STATIC int
 xchk_iallocbt_check_freemask(
 	struct xchk_btree		*bs,
+	struct xchk_iallocbt		*iabt,
 	struct xfs_inobt_rec_incore	*irec)
 {
-	struct xfs_owner_info		oinfo;
 	struct xfs_imap			imap;
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_dinode		*dip;
 	struct xfs_buf			*bp;
 	xfs_ino_t			fsino;
-	xfs_agino_t			nr_inodes;
+	unsigned int			nr_inodes;
 	xfs_agino_t			agino;
 	xfs_agino_t			chunkino;
 	xfs_agino_t			clusterino;
 	xfs_agblock_t			agbno;
-	int				blks_per_cluster;
 	uint16_t			holemask;
 	uint16_t			ir_holemask;
 	int				error = 0;
 
 	/* Make sure the freemask matches the inode records. */
-	blks_per_cluster = xfs_icluster_size_fsb(mp);
-	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
-	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INODES);
+	nr_inodes = min_t(unsigned int, iabt->inodes_per_cluster,
+			XFS_INODES_PER_CHUNK);
 
 	for (agino = irec->ir_startino;
 	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
-	     agino += blks_per_cluster * mp->m_sb.sb_inopblock) {
+	     agino += iabt->blocks_per_cluster * mp->m_sb.sb_inopblock) {
 		fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
 		chunkino = agino - irec->ir_startino;
 		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
@@ -235,17 +243,17 @@ xchk_iallocbt_check_freemask(
 		/* If any part of this is a hole, skip it. */
 		if (ir_holemask) {
 			xchk_xref_is_not_owned_by(bs->sc, agbno,
-					blks_per_cluster, &oinfo);
+					iabt->blocks_per_cluster, &iabt->oinfo);
 			continue;
 		}
 
-		xchk_xref_is_owned_by(bs->sc, agbno, blks_per_cluster,
-				&oinfo);
+		xchk_xref_is_owned_by(bs->sc, agbno, iabt->blocks_per_cluster,
+				&iabt->oinfo);
 
 		/* Grab the inode cluster buffer. */
 		imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno,
 				agbno);
-		imap.im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
+		imap.im_len = XFS_FSB_TO_BB(mp, iabt->blocks_per_cluster);
 		imap.im_boffset = 0;
 
 		error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap,
@@ -311,8 +319,8 @@ xchk_iallocbt_rec(
 
 	/* Make sure this record is aligned to cluster and inoalignmnt size. */
 	agbno = XFS_AGINO_TO_AGBNO(mp, irec.ir_startino);
-	if ((agbno & (xfs_ialloc_cluster_alignment(mp) - 1)) ||
-	    (agbno & (xfs_icluster_size_fsb(mp) - 1)))
+	if ((agbno & (iabt->cluster_align - 1)) ||
+	    (agbno & (iabt->blocks_per_cluster - 1)))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	iabt->inodes += irec.ir_count;
@@ -353,7 +361,7 @@ xchk_iallocbt_rec(
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 check_freemask:
-	error = xchk_iallocbt_check_freemask(bs, &irec);
+	error = xchk_iallocbt_check_freemask(bs, iabt, &irec);
 	if (error)
 		goto out;
 
@@ -440,9 +448,15 @@ xchk_iallocbt(
 	struct xfs_owner_info	oinfo;
 	struct xchk_iallocbt	iabt = {
 		.inodes		= 0,
+		.cluster_align	= xfs_ialloc_cluster_alignment(sc->mp),
+		.blocks_per_cluster = xfs_icluster_size_fsb(sc->mp),
 	};
 	int			error;
 
+	xfs_rmap_ag_owner(&iabt.oinfo, XFS_RMAP_OWN_INODES);
+	iabt.inodes_per_cluster = XFS_OFFBNO_TO_AGINO(sc->mp,
+			iabt.blocks_per_cluster, 0);
+
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
 	error = xchk_btree(sc, cur, xchk_iallocbt_rec, &oinfo, &iabt);
