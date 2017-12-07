Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38388 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752523AbdLGS6L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Dec 2017 13:58:11 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B97CF61474
        for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2017 18:58:11 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 884F461292
        for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2017 18:58:11 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 4/4] xfs: defer agfl frees on inobt allocs during chunk removal
Date: Thu,  7 Dec 2017 13:58:10 -0500
Message-Id: <20171207185810.48757-5-bfoster@redhat.com>
In-Reply-To: <20171207185810.48757-1-bfoster@redhat.com>
References: <20171207185810.48757-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Defer AGFL frees during inode btree ([f]inobt) block allocations and
frees that occur when removing inode chunks. The inode btrees do not
use the AGFL and instead make allocator calls directly from the
context of the tree update. This can chew up log reservation in the
transaction if multiple AGFL block frees are required.

Update the inobt cursor initialization function to receive an
optional dfops pointer and carry it to ->[alloc|free]_block()
context. From there, pass the dfops along to the allocator
appropriately. Update xfs_difree_inobt() to pass dfops from the
context where an inode chunk is freed and associated record removed
from the inobt. All other inobt cursor users pass a NULL dfops and
thus do not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c       | 16 ++++++++--------
 fs/xfs/libxfs/xfs_ialloc_btree.c | 11 +++++++----
 fs/xfs/libxfs/xfs_ialloc_btree.h |  4 ++--
 fs/xfs/scrub/common.c            |  8 ++++----
 fs/xfs/xfs_itable.c              |  4 ++--
 5 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index de3f04a98656..4345ba9b691a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -183,7 +183,7 @@ xfs_inobt_insert(
 	int			i;
 	int			error;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
+	cur = xfs_inobt_init_cursor(mp, tp, NULL, agbp, agno, btnum);
 
 	for (thisino = newino;
 	     thisino < newino + newlen;
@@ -532,7 +532,7 @@ xfs_inobt_insert_sprec(
 	int				i;
 	struct xfs_inobt_rec_incore	rec;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
+	cur = xfs_inobt_init_cursor(mp, tp, NULL, agbp, agno, btnum);
 
 	/* the new record is pre-aligned so we know where to look */
 	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
@@ -1141,7 +1141,7 @@ xfs_dialloc_ag_inobt(
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(mp, tp, NULL, agbp, agno, XFS_BTNUM_INO);
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1570,7 +1570,7 @@ xfs_dialloc_ag(
 	if (!pagino)
 		pagino = be32_to_cpu(agi->agi_newino);
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
+	cur = xfs_inobt_init_cursor(mp, tp, NULL, agbp, agno, XFS_BTNUM_FINO);
 
 	error = xfs_check_agi_freecount(cur, agi);
 	if (error)
@@ -1613,7 +1613,7 @@ xfs_dialloc_ag(
 	 * the original freecount. If all is well, make the equivalent update to
 	 * the inobt using the finobt record and offset information.
 	 */
-	icur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
+	icur = xfs_inobt_init_cursor(mp, tp, NULL, agbp, agno, XFS_BTNUM_INO);
 
 	error = xfs_check_agi_freecount(icur, agi);
 	if (error)
@@ -1921,7 +1921,7 @@ xfs_difree_inobt(
 	/*
 	 * Initialize the cursor.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(mp, tp, dfops, agbp, agno, XFS_BTNUM_INO);
 
 	error = xfs_check_agi_freecount(cur, agi);
 	if (error)
@@ -2042,7 +2042,7 @@ xfs_difree_finobt(
 	int				error;
 	int				i;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
+	cur = xfs_inobt_init_cursor(mp, tp, NULL, agbp, agno, XFS_BTNUM_FINO);
 
 	error = xfs_inobt_lookup(cur, ibtrec->ir_startino, XFS_LOOKUP_EQ, &i);
 	if (error)
@@ -2235,7 +2235,7 @@ xfs_imap_lookup(
 	 * we have a record, we need to ensure it contains the inode number
 	 * we are looking up.
 	 */
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
+	cur = xfs_inobt_init_cursor(mp, tp, NULL, agbp, agno, XFS_BTNUM_INO);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 	if (!error) {
 		if (i)
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index b899f02e5c5e..4c996521b031 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -48,8 +48,8 @@ xfs_inobt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
 	return xfs_inobt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.a.agbp, cur->bc_private.a.agno,
-			cur->bc_btnum);
+			cur->bc_private.a.dfops, cur->bc_private.a.agbp,
+			cur->bc_private.a.agno, cur->bc_btnum);
 }
 
 STATIC void
@@ -105,6 +105,7 @@ __xfs_inobt_alloc_block(
 	args.prod = 1;
 	args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	args.resv = resv;
+	args.dfops = cur->bc_private.a.dfops;
 
 	error = xfs_alloc_vextent(&args);
 	if (error) {
@@ -155,7 +156,7 @@ xfs_inobt_free_block(
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	return xfs_free_extent(cur->bc_tp,
 			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
-			&oinfo, XFS_AG_RESV_NONE, NULL);
+			&oinfo, XFS_AG_RESV_NONE, cur->bc_private.a.dfops);
 }
 
 STATIC int
@@ -393,6 +394,7 @@ struct xfs_btree_cur *				/* new inode btree cursor */
 xfs_inobt_init_cursor(
 	struct xfs_mount	*mp,		/* file system mount point */
 	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_defer_ops	*dfops,		/* deferred ops */
 	struct xfs_buf		*agbp,		/* buffer for agi structure */
 	xfs_agnumber_t		agno,		/* allocation group number */
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
@@ -420,6 +422,7 @@ xfs_inobt_init_cursor(
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
+	cur->bc_private.a.dfops = dfops;
 	cur->bc_private.a.agbp = agbp;
 	cur->bc_private.a.agno = agno;
 
@@ -552,7 +555,7 @@ xfs_inobt_count_blocks(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno, btnum);
+	cur = xfs_inobt_init_cursor(mp, NULL, NULL, agbp, agno, btnum);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	xfs_buf_relse(agbp);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index aa81e2e63f3f..0194351c09c8 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -58,8 +58,8 @@ struct xfs_mount;
 		 ((index) - 1) * sizeof(xfs_inobt_ptr_t)))
 
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
-		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t,
-		xfs_btnum_t);
+		struct xfs_trans *, struct xfs_defer_ops *, struct xfs_buf *,
+		xfs_agnumber_t, xfs_btnum_t);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index ac95fe911d96..44f96c835836 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -358,16 +358,16 @@ xfs_scrub_ag_btcur_init(
 
 	/* Set up a inobt cursor for cross-referencing. */
 	if (sa->agi_bp) {
-		sa->ino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
-					agno, XFS_BTNUM_INO);
+		sa->ino_cur = xfs_inobt_init_cursor(mp, sc->tp, NULL,
+					sa->agi_bp, agno, XFS_BTNUM_INO);
 		if (!sa->ino_cur)
 			goto err;
 	}
 
 	/* Set up a finobt cursor for cross-referencing. */
 	if (sa->agi_bp && xfs_sb_version_hasfinobt(&mp->m_sb)) {
-		sa->fino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
-				agno, XFS_BTNUM_FINO);
+		sa->fino_cur = xfs_inobt_init_cursor(mp, sc->tp, NULL,
+				sa->agi_bp, agno, XFS_BTNUM_FINO);
 		if (!sa->fino_cur)
 			goto err;
 	}
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index d58310514423..39b16eb84e51 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -398,7 +398,7 @@ xfs_bulkstat(
 		/*
 		 * Allocate and initialize a btree cursor for ialloc btree.
 		 */
-		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
+		cur = xfs_inobt_init_cursor(mp, NULL, NULL, agbp, agno,
 					    XFS_BTNUM_INO);
 		if (agino > 0) {
 			/*
@@ -582,7 +582,7 @@ xfs_inumbers(
 			if (error)
 				break;
 
-			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
+			cur = xfs_inobt_init_cursor(mp, NULL, NULL, agbp, agno,
 						    XFS_BTNUM_INO);
 			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE,
 						 &stat);
-- 
2.13.6

