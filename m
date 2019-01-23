Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbfAWS7a (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Jan 2019 13:59:30 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs_repair: initialize non-leaf finobt blocks with correct magic
Date: Wed, 23 Jan 2019 13:59:29 -0500
Message-Id: <20190123185929.46507-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Lucas Stach <l.stach@pengutronix.de>

The free inode btree construction code in xfs_repair has a bug where
any non-leaf nodes outside of the leftmost block at the associated
level in the tree are incorrectly initialized with the inobt magic
value. Update the prop_ino_cursor() path responsible for growing the
non-leaf portion of the inode btrees to use the btnum of the
specific tree being generated rather than the hardcoded inode btree
type.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reported-by: Lucas Stach <l.stach@pengutronix.de>
Root-caused-by: Lucas Stach <l.stach@pengutronix.de>
---
 repair/phase5.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 85d1f4fb..05333f11 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -983,7 +983,7 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 
 static void
 prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
-	xfs_agino_t startino, int level)
+	xfs_btnum_t btnum, xfs_agino_t startino, int level)
 {
 	struct xfs_btree_block	*bt_hdr;
 	xfs_inobt_key_t		*bt_key;
@@ -1005,7 +1005,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		 * first path up the left side of the tree
 		 * where the agbno's are already set up
 		 */
-		prop_ino_cursor(mp, agno, btree_curs, startino, level);
+		prop_ino_cursor(mp, agno, btree_curs, btnum, startino, level);
 	}
 
 	if (be16_to_cpu(bt_hdr->bb_numrecs) ==
@@ -1041,7 +1041,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
 		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
 		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_INO,
+		libxfs_btree_init_block(mp, lptr->buf_p, btnum,
 					level, 0, agno, 0);
 
 		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
@@ -1049,7 +1049,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		/*
 		 * propagate extent record for first extent in new block up
 		 */
-		prop_ino_cursor(mp, agno, btree_curs, startino, level);
+		prop_ino_cursor(mp, agno, btree_curs, btnum, startino, level);
 	}
 	/*
 	 * add inode info to current block
@@ -1201,7 +1201,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 			lptr->modulo--;
 
 		if (lptr->num_recs_pb > 0)
-			prop_ino_cursor(mp, agno, btree_curs,
+			prop_ino_cursor(mp, agno, btree_curs, btnum,
 					ino_rec->ino_startnum, 0);
 
 		bt_rec = (xfs_inobt_rec_t *)
-- 
2.17.2
