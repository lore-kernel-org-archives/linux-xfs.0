Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8262A7F5E
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 07:22:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BE4AAC009
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 05:22:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HLc0YYbJoCyIbxhN for
	<xfs@oss.sgi.com>; Wed, 07 May 2014 05:22:02 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s47CM1NJ019346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:01 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s47CM06I028665
	for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 16/20] xfsprogs/repair: pull the build_agi() call up out of
	the inode tree build
Date: Wed,  7 May 2014 08:21:55 -0400
Message-Id: <1399465319-65066-17-git-send-email-bfoster@redhat.com>
In-Reply-To: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
References: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase5.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 2c02e40..4778e08 100644
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
@@ -1050,8 +1059,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
  */
 static void
 build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, xfs_agino_t first_agino,
-		xfs_agino_t count, xfs_agino_t freecount)
+		bt_status_t *btree_curs, struct agi_stat *agi_stat)
 {
 	xfs_buf_t	*agi_buf;
 	xfs_agi_t	*agi;
@@ -1072,11 +1080,11 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
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
@@ -1094,7 +1102,8 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
  */
 static void
 build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, __uint32_t magic)
+		bt_status_t *btree_curs, __uint32_t magic,
+		struct agi_stat *agi_stat)
 {
 	xfs_agnumber_t		i;
 	xfs_agblock_t		j;
@@ -1224,7 +1233,11 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
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
@@ -1481,6 +1494,7 @@ phase5_func(
 #endif
 	xfs_agblock_t	num_extents;
 	__uint32_t	magic;
+	struct agi_stat	agi_stat = {0,};
 
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);
@@ -1612,12 +1626,16 @@ phase5_func(
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
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
