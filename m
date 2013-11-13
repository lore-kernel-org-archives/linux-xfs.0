Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3E11E7F3F
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:56:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CABBCAC009
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2VtMTF74FXktgxnX for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:25 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rADFuPMf014566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:25 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rADFuOZV020732
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 16/20] xfsprogs/repair: pull the build_agi() call up out of
	the inode tree build
Date: Wed, 13 Nov 2013 10:56:18 -0500
Message-Id: <1384358182-37967-17-git-send-email-bfoster@redhat.com>
In-Reply-To: <1384358182-37967-1-git-send-email-bfoster@redhat.com>
References: <1384358182-37967-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Pull the build_agi() call out of build_ino_tree() in phase 5. This
is to prepare for finobt support, in which build_agi() will require
context from multiple inode tree reconstructions (both the inode
allocation tree and free inode tree, when it exists).

Create the new 'agi_stat' structure to carry the requisite state
from the build_ino_tree() operation to build_agi().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase5.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 10ed1eb..9632d2c 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -74,6 +74,15 @@ typedef struct bt_status  {
 	bt_stat_level_t		level[XFS_BTREE_MAXLEVELS];
 } bt_status_t;
 
+/*
+ * extra metadata for the agi
+ */
+struct agi_stat {
+	xfs_agino_t		first_agino;
+	xfs_agino_t		count;
+	xfs_agino_t		freecount;
+};
+
 static __uint64_t	*sb_icount_ag;		/* allocated inodes per ag */
 static __uint64_t	*sb_ifree_ag;		/* free inodes per ag */
 static __uint64_t	*sb_fdblocks_ag;	/* free data blocks per ag */
@@ -1053,8 +1062,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
  */
 static void
 build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, xfs_agino_t first_agino,
-		xfs_agino_t count, xfs_agino_t freecount)
+		bt_status_t *btree_curs, struct agi_stat *agi_stat)
 {
 	xfs_buf_t	*agi_buf;
 	xfs_agi_t	*agi;
@@ -1075,11 +1083,11 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
 	else
 		agi->agi_length = cpu_to_be32(mp->m_sb.sb_dblocks -
 			(xfs_drfsbno_t) mp->m_sb.sb_agblocks * agno);
-	agi->agi_count = cpu_to_be32(count);
+	agi->agi_count = cpu_to_be32(agi_stat->count);
 	agi->agi_root = cpu_to_be32(btree_curs->root);
 	agi->agi_level = cpu_to_be32(btree_curs->num_levels);
-	agi->agi_freecount = cpu_to_be32(freecount);
-	agi->agi_newino = cpu_to_be32(first_agino);
+	agi->agi_freecount = cpu_to_be32(agi_stat->freecount);
+	agi->agi_newino = cpu_to_be32(agi_stat->first_agino);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
 
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++)  
@@ -1097,7 +1105,8 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
  */
 static void
 build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, __uint32_t magic)
+		bt_status_t *btree_curs, __uint32_t magic,
+		struct agi_stat *agi_stat)
 {
 	xfs_agnumber_t		i;
 	xfs_agblock_t		j;
@@ -1227,7 +1236,11 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		}
 	}
 
-	build_agi(mp, agno, btree_curs, first_agino, count, freecount);
+	if (agi_stat) {
+		agi_stat->first_agino = first_agino;
+		agi_stat->count = count;
+		agi_stat->freecount = freecount;
+	}
 }
 
 /*
@@ -1484,6 +1497,7 @@ phase5_func(
 #endif
 	xfs_agblock_t	num_extents;
 	__uint32_t	magic;
+	struct agi_stat	agi_stat = {0,};
 
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);
@@ -1615,12 +1629,16 @@ phase5_func(
 		build_agf_agfl(mp, agno, &bno_btree_curs,
 				&bcnt_btree_curs, freeblks1, extra_blocks);
 		/*
-		 * build inode allocation tree.  this also build the agi
+		 * build inode allocation tree.
 		 */
 		magic = xfs_sb_version_hascrc(&mp->m_sb) ?
 				XFS_IBT_CRC_MAGIC : XFS_IBT_MAGIC;
-		build_ino_tree(mp, agno, &ino_btree_curs, magic);
+		build_ino_tree(mp, agno, &ino_btree_curs, magic, &agi_stat);
 		write_cursor(&ino_btree_curs);
+
+		/* build the agi */
+		build_agi(mp, agno, &ino_btree_curs, &agi_stat);
+
 		/*
 		 * tear down cursors
 		 */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
