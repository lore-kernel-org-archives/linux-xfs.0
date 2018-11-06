Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbeKFNb2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 08:31:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA640A4X031258
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:15 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2nh3mpjt1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 04:08:14 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA648EeA012065
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:14 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA648DqE011390
        for <linux-xfs@vger.kernel.org>; Tue, 6 Nov 2018 04:08:14 GMT
Subject: [PATCH 1/8] xfs: count inode blocks correctly in inobt scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 05 Nov 2018 20:08:12 -0800
Message-ID: <154147729274.32496.16585638036818485278.stgit@magnolia>
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

A big block filesystem might require more than one inobt record to cover
all the inodes in the block.  In these cases it is not correct to round
the irec count up to the nearest block because this causes us to
overestimate the number of inode blocks we expect to find.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 224dba937492..76ae8338a42e 100644
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
@@ -272,7 +277,7 @@ xchk_iallocbt_rec(
 	union xfs_btree_rec		*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
-	xfs_filblks_t			*inode_blocks = bs->private;
+	struct xchk_iallocbt		*iabt = bs->private;
 	struct xfs_inobt_rec_incore	irec;
 	uint64_t			holes;
 	xfs_agnumber_t			agno = bs->cur->bc_private.a.agno;
@@ -310,8 +315,7 @@ xchk_iallocbt_rec(
 	    (agbno & (xfs_icluster_size_fsb(mp) - 1)))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-	*inode_blocks += XFS_B_TO_FSB(mp,
-			irec.ir_count * mp->m_sb.sb_inodesize);
+	iabt->inodes += irec.ir_count;
 
 	/* Handle non-sparse inodes */
 	if (!xfs_inobt_issparse(irec.ir_holemask)) {
@@ -405,10 +409,11 @@ STATIC void
 xchk_iallocbt_xref_rmap_inodes(
 	struct xfs_scrub	*sc,
 	int			which,
-	xfs_filblks_t		inode_blocks)
+	unsigned long long	inodes)
 {
 	struct xfs_owner_info	oinfo;
 	xfs_filblks_t		blocks;
+	xfs_filblks_t		inode_blocks;
 	int			error;
 
 	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
@@ -420,6 +425,7 @@ xchk_iallocbt_xref_rmap_inodes(
 			&blocks);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
+	inode_blocks = XFS_B_TO_FSB(sc->mp, inodes * sc->mp->m_sb.sb_inodesize);
 	if (blocks != inode_blocks)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 }
@@ -432,13 +438,14 @@ xchk_iallocbt(
 {
 	struct xfs_btree_cur	*cur;
 	struct xfs_owner_info	oinfo;
-	xfs_filblks_t		inode_blocks = 0;
+	struct xchk_iallocbt	iabt = {
+		.inodes		= 0,
+	};
 	int			error;
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	cur = which == XFS_BTNUM_INO ? sc->sa.ino_cur : sc->sa.fino_cur;
-	error = xchk_btree(sc, cur, xchk_iallocbt_rec, &oinfo,
-			&inode_blocks);
+	error = xchk_btree(sc, cur, xchk_iallocbt_rec, &oinfo, &iabt);
 	if (error)
 		return error;
 
@@ -452,7 +459,7 @@ xchk_iallocbt(
 	 * to inode chunks with free inodes.
 	 */
 	if (which == XFS_BTNUM_INO)
-		xchk_iallocbt_xref_rmap_inodes(sc, which, inode_blocks);
+		xchk_iallocbt_xref_rmap_inodes(sc, which, iabt.inodes);
 
 	return error;
 }
