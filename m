Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32930 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbeKFNb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 08:31:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA640jw2031438
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:43 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2nh3mpjt2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 04:08:43 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA648fig001815
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:42 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA648f9I018598
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:41 GMT
Subject: [PATCH 5/8] xfs: hoist inode cluster checks out of loop
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Nov 2018 20:08:40 -0800
Message-ID: <154147732071.32496.10360183009741260995.stgit@magnolia>
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

Hoist the inode cluster checks out of the inobt record check loop into
a separate function in preparation for refactoring of that loop.  No
functional changes here; that's in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |  120 +++++++++++++++++++++++++++----------------------
 1 file changed, 66 insertions(+), 54 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 4fadea892440..12158ed8ad29 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -201,12 +201,13 @@ xchk_iallocbt_check_cluster_freemask(
 	return 0;
 }
 
-/* Make sure the free mask is consistent with what the inodes think. */
+/* Check an inode cluster. */
 STATIC int
-xchk_iallocbt_check_freemask(
+xchk_iallocbt_check_cluster(
 	struct xchk_btree		*bs,
 	struct xchk_iallocbt		*iabt,
-	struct xfs_inobt_rec_incore	*irec)
+	struct xfs_inobt_rec_incore	*irec,
+	xfs_agino_t			agino)
 {
 	struct xfs_imap			imap;
 	struct xfs_mount		*mp = bs->cur->bc_mp;
@@ -214,7 +215,6 @@ xchk_iallocbt_check_freemask(
 	struct xfs_buf			*bp;
 	xfs_ino_t			fsino;
 	unsigned int			nr_inodes;
-	xfs_agino_t			agino;
 	xfs_agino_t			chunkino;
 	xfs_agino_t			clusterino;
 	xfs_agblock_t			agbno;
@@ -226,59 +226,71 @@ xchk_iallocbt_check_freemask(
 	nr_inodes = min_t(unsigned int, iabt->inodes_per_cluster,
 			XFS_INODES_PER_CHUNK);
 
-	for (agino = irec->ir_startino;
-	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
-	     agino += iabt->blocks_per_cluster * mp->m_sb.sb_inopblock) {
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
-					iabt->blocks_per_cluster, &iabt->oinfo);
-			continue;
-		}
+	/* Compute the holemask mask for this cluster. */
+	for (clusterino = 0, holemask = 0; clusterino < nr_inodes;
+	     clusterino += XFS_INODES_PER_HOLEMASK_BIT)
+		holemask |= XFS_INOBT_MASK((chunkino + clusterino) /
+				XFS_INODES_PER_HOLEMASK_BIT);
 
-		xchk_xref_is_owned_by(bs->sc, agbno, iabt->blocks_per_cluster,
-				&iabt->oinfo);
-
-		/* Grab the inode cluster buffer. */
-		imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno,
-				agbno);
-		imap.im_len = XFS_FSB_TO_BB(mp, iabt->blocks_per_cluster);
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
+	/* The whole cluster must be a hole or not a hole. */
+	ir_holemask = (irec->ir_holemask & holemask);
+	if (ir_holemask != holemask && ir_holemask != 0) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return 0;
+	}
+
+	/* If any part of this is a hole, skip it. */
+	if (ir_holemask) {
+		xchk_xref_is_not_owned_by(bs->sc, agbno,
+				iabt->blocks_per_cluster, &iabt->oinfo);
+		return 0;
+	}
+
+	xchk_xref_is_owned_by(bs->sc, agbno, iabt->blocks_per_cluster,
+			&iabt->oinfo);
+
+	/* Grab the inode cluster buffer. */
+	imap.im_blkno = XFS_AGB_TO_DADDR(mp, bs->cur->bc_private.a.agno, agbno);
+	imap.im_len = XFS_FSB_TO_BB(mp, iabt->blocks_per_cluster);
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
+	struct xchk_iallocbt		*iabt,
+	struct xfs_inobt_rec_incore	*irec)
+{
+	struct xfs_mount		*mp = bs->cur->bc_mp;
+	xfs_agino_t			agino;
+	int				error = 0;
+
+	for (agino = irec->ir_startino;
+	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
+	     agino += iabt->blocks_per_cluster * mp->m_sb.sb_inopblock) {
+		error = xchk_iallocbt_check_cluster(bs, iabt, irec, agino);
+		if (error)
+			break;
 	}
 
 	return error;
