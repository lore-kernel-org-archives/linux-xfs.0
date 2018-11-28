Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbeK2Kac (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 05:30:32 -0500
Subject: [PATCH 1/9] xfs: count inode blocks correctly in inobt scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Nov 2018 15:27:05 -0800
Message-ID: <154344762508.3835.18425020796453840809.stgit@magnolia>
In-Reply-To: <154344761877.3835.7785580513047409388.stgit@magnolia>
References: <154344761877.3835.7785580513047409388.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

A big block filesystem might require more than one inobt record to cover
all the inodes in the block.  In these cases it is not correct to round
the irec count up to the nearest block because this causes us to
overestimate the number of inode blocks we expect to find.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/ialloc.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 9b5287a0e8ba..882dc56c5c21 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -44,6 +44,11 @@ xchk_setup_ag_iallocbt(
 
 /* Inode btree scrubber. */
 
+struct xchk_iallocbt {
+	/* Number of inodes we see while scanning inobt. */
+	unsigned long long	inodes;
+};
+
 /*
  * If we're checking the finobt, cross-reference with the inobt.
  * Otherwise we're checking the inobt; if there is an finobt, make sure
@@ -266,7 +271,7 @@ xchk_iallocbt_rec(
 	union xfs_btree_rec		*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
-	xfs_filblks_t			*inode_blocks = bs->private;
+	struct xchk_iallocbt		*iabt = bs->private;
 	struct xfs_inobt_rec_incore	irec;
 	uint64_t			holes;
 	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
@@ -304,8 +309,7 @@ xchk_iallocbt_rec(
 	    (agbno & (mp->m_blocks_per_cluster - 1)))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-	*inode_blocks += XFS_B_TO_FSB(mp,
-			irec.ir_count * mp->m_sb.sb_inodesize);
+	iabt->inodes += irec.ir_count;
 
 	/* Handle non-sparse inodes */
 	if (!xfs_inobt_issparse(irec.ir_holemask)) {
@@ -397,9 +401,10 @@ STATIC void
 xchk_iallocbt_xref_rmap_inodes(
 	struct xfs_scrub	*sc,
 	int			which,
-	xfs_filblks_t		inode_blocks)
+	unsigned long long	inodes)
 {
 	xfs_filblks_t		blocks;
+	xfs_filblks_t		inode_blocks;
 	int			error;
 
 	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
@@ -410,6 +415,7 @@ xchk_iallocbt_xref_rmap_inodes(
 			&XFS_RMAP_OINFO_INODES, &blocks);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
+	inode_blocks = XFS_B_TO_FSB(sc->mp, inodes * sc->mp->m_sb.sb_inodesize);
 	if (blocks != inode_blocks)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 }
@@ -421,12 +427,14 @@ xchk_iallocbt(
 	xfs_btnum_t		which)
 {
 	struct xfs_btree_cur	*cur;
-	xfs_filblks_t		inode_blocks = 0;
+	struct xchk_iallocbt	iabt = {
+		.inodes		= 0,
+	};
 	int			error;
 
 	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
 	error = xchk_btree(sc, cur, xchk_iallocbt_rec, &XFS_RMAP_OINFO_INOBT,
-			&inode_blocks);
+			&iabt);
 	if (error)
 		return error;
 
@@ -440,7 +448,7 @@ xchk_iallocbt(
 	 * to inode chunks with free inodes.
 	 */
 	if (which == XFS_BTNUM_INO)
-		xchk_iallocbt_xref_rmap_inodes(sc, which, inode_blocks);
+		xchk_iallocbt_xref_rmap_inodes(sc, which, iabt.inodes);
 
 	return error;
 }
