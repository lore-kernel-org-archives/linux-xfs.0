Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42304 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbfAHUdE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 15:33:04 -0500
Subject: [PATCH 4/7] xfs: hoist inode cluster checks out of loop
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 Jan 2019 12:33:00 -0800
Message-ID: <154697958005.2494.13065416070471145235.stgit@magnolia>
In-Reply-To: <154697955494.2494.5221420762912855354.stgit@magnolia>
References: <154697955494.2494.5221420762912855354.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Hoist the inode cluster checks out of the inobt record check loop into
a separate function in preparation for refactoring of that loop.  No
functional changes here; that's in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/ialloc.c |  119 +++++++++++++++++++++++++++----------------------
 1 file changed, 65 insertions(+), 54 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index b8bfa93fd1a4..0ce793d92995 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -188,19 +188,19 @@ xchk_iallocbt_check_cluster_freemask(
 	return 0;
 }
 
-/* Make sure the free mask is consistent with what the inodes think. */
+/* Check an inode cluster. */
 STATIC int
-xchk_iallocbt_check_freemask(
+xchk_iallocbt_check_cluster(
 	struct xchk_btree		*bs,
-	struct xfs_inobt_rec_incore	*irec)
+	struct xfs_inobt_rec_incore	*irec,
+	xfs_agino_t			agino)
 {
 	struct xfs_imap			imap;
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_dinode		*dip;
 	struct xfs_buf			*bp;
 	xfs_ino_t			fsino;
-	xfs_agino_t			nr_inodes;
-	xfs_agino_t			agino;
+	unsigned int			nr_inodes;
 	xfs_agino_t			chunkino;
 	xfs_agino_t			clusterino;
 	xfs_agblock_t			agbno;
@@ -212,60 +212,71 @@ xchk_iallocbt_check_freemask(
 	nr_inodes = min_t(unsigned int, XFS_INODES_PER_CHUNK,
 			mp->m_inodes_per_cluster);
 
-	for (agino = irec->ir_startino;
-	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
-	     agino += mp->m_inodes_per_cluster) {
-		fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
-		chunkino = agino - irec->ir_startino;
-		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-
-		/* Compute the holemask mask for this cluster. */
-		for (clusterino = 0, holemask = 0; clusterino < nr_inodes;
-		     clusterino += XFS_INODES_PER_HOLEMASK_BIT)
-			holemask |= XFS_INOBT_MASK((chunkino + clusterino) /
-					XFS_INODES_PER_HOLEMASK_BIT);
-
-		/* The whole cluster must be a hole or not a hole. */
-		ir_holemask = (irec->ir_holemask & holemask);
-		if (ir_holemask != holemask && ir_holemask != 0) {
-			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-			continue;
-		}
+	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
+	chunkino = agino - irec->ir_startino;
+	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
 
-		/* If any part of this is a hole, skip it. */
-		if (ir_holemask) {
-			xchk_xref_is_not_owned_by(bs->sc, agbno,
-					mp->m_blocks_per_cluster,
-					&XFS_RMAP_OINFO_INODES);
-			continue;
-		}
+	/* Compute the holemask mask for this cluster. */
+	for (clusterino = 0, holemask = 0; clusterino < nr_inodes;
+	     clusterino += XFS_INODES_PER_HOLEMASK_BIT)
+		holemask |= XFS_INOBT_MASK((chunkino + clusterino) /
+				XFS_INODES_PER_HOLEMASK_BIT);
+
+	/* The whole cluster must be a hole or not a hole. */
+	ir_holemask = (irec->ir_holemask & holemask);
+	if (ir_holemask != holemask && ir_holemask != 0) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return 0;
+	}
 
-		xchk_xref_is_owned_by(bs->sc, agbno, mp->m_blocks_per_cluster,
+	/* If any part of this is a hole, skip it. */
+	if (ir_holemask) {
+		xchk_xref_is_not_owned_by(bs->sc, agbno,
+				mp->m_blocks_per_cluster,
 				&XFS_RMAP_OINFO_INODES);
+		return 0;
+	}
 
-		/* Grab the inode cluster buffer. */
-		imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno,
-				agbno);
-		imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
-		imap.im_boffset = 0;
-
-		error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap,
-				&dip, &bp, 0, 0);
-		if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0,
-				&error))
-			continue;
-
-		/* Which inodes are free? */
-		for (clusterino = 0; clusterino < nr_inodes; clusterino++) {
-			error = xchk_iallocbt_check_cluster_freemask(bs,
-					fsino, chunkino, clusterino, irec, bp);
-			if (error) {
-				xfs_trans_brelse(bs->cur->bc_tp, bp);
-				return error;
-			}
-		}
+	xchk_xref_is_owned_by(bs->sc, agbno, mp->m_blocks_per_cluster,
+			&XFS_RMAP_OINFO_INODES);
+
+	/* Grab the inode cluster buffer. */
+	imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno, agbno);
+	imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
+	imap.im_boffset = 0;
 
-		xfs_trans_brelse(bs->cur->bc_tp, bp);
+	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &dip, &bp, 0, 0);
+	if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0, &error))
+		return 0;
+
+	/* Which inodes are free? */
+	for (clusterino = 0; clusterino < nr_inodes; clusterino++) {
+		error = xchk_iallocbt_check_cluster_freemask(bs, fsino,
+				chunkino, clusterino, irec, bp);
+		if (error)
+			break;
+	}
+
+	xfs_trans_brelse(bs->cur->bc_tp, bp);
+	return error;
+}
+
+/* Make sure the free mask is consistent with what the inodes think. */
+STATIC int
+xchk_iallocbt_check_freemask(
+	struct xchk_btree		*bs,
+	struct xfs_inobt_rec_incore	*irec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	xfs_agino_t			agino;
+	int				error = 0;
+
+	for (agino = irec->ir_startino;
+	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
+	     agino += mp->m_inodes_per_cluster) {
+		error = xchk_iallocbt_check_cluster(bs, irec, agino);
+		if (error)
+			break;
 	}
 
 	return error;
