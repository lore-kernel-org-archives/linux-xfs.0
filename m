Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7950F7F5A
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 07:22:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 49DAC8F8037
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 05:22:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4CxhLacOIfuooofA for
	<xfs@oss.sgi.com>; Wed, 07 May 2014 05:22:02 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s47CM1tA032508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:01 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s47CM0Tb014670
	for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 18/20] xfsprogs/repair: reconstruct the finobt in phase 5
Date: Wed,  7 May 2014 08:21:57 -0400
Message-Id: <1399465319-65066-19-git-send-email-bfoster@redhat.com>
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

Support reconstruction of the finobt in phase 5 of xfs_repair. We
create a new cursor for the finobt and write the in-core records
that contain free inodes to the tree. Finally, pass the cursor
along to build_agi() to include the finobt root and level count in
the agi header.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase5.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 13 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 4778e08..e82eeb7 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -878,10 +878,11 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
  */
 static void
 init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
-		__uint64_t *num_inos, __uint64_t *num_free_inos)
+		__uint64_t *num_inos, __uint64_t *num_free_inos, int finobt)
 {
 	__uint64_t		ninos;
 	__uint64_t		nfinos;
+	__uint64_t		rec_nfinos;
 	ino_tree_node_t		*ino_rec;
 	int			num_recs;
 	int			level;
@@ -917,13 +918,22 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 	 * build up statistics
 	 */
 	for (num_recs = 0; ino_rec != NULL; ino_rec = next_ino_rec(ino_rec))  {
-		ninos += XFS_INODES_PER_CHUNK;
-		num_recs++;
+		rec_nfinos = 0;
 		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
 			ASSERT(is_inode_confirmed(ino_rec, i));
 			if (is_inode_free(ino_rec, i))
-				nfinos++;
+				rec_nfinos++;
 		}
+
+		/*
+		 * finobt only considers records with free inodes
+		 */
+		if (finobt && !rec_nfinos)
+			continue;
+
+		nfinos += rec_nfinos;
+		ninos += XFS_INODES_PER_CHUNK;
+		num_recs++;
 	}
 
 	blocks_allocated = lptr->num_blocks = howmany(num_recs,
@@ -1058,8 +1068,8 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
  * XXX: yet more code that can be shared with mkfs, growfs.
  */
 static void
-build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, struct agi_stat *agi_stat)
+build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
+		bt_status_t *finobt_curs, struct agi_stat *agi_stat)
 {
 	xfs_buf_t	*agi_buf;
 	xfs_agi_t	*agi;
@@ -1093,6 +1103,11 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
 
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		agi->agi_free_root = cpu_to_be32(finobt_curs->root);
+		agi->agi_free_level = cpu_to_be32(finobt_curs->num_levels);
+	}
+
 	libxfs_writebuf(agi_buf, 0);
 }
 
@@ -1103,7 +1118,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
 static void
 build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_status_t *btree_curs, __uint32_t magic,
-		struct agi_stat *agi_stat)
+		struct agi_stat *agi_stat, int finobt)
 {
 	xfs_agnumber_t		i;
 	xfs_agblock_t		j;
@@ -1155,7 +1170,10 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	 * pointers for the parent.  that can recurse up to the root
 	 * if required.  set the sibling pointers for leaf level here.
 	 */
-	ino_rec = findfirst_inode_rec(agno);
+	if (finobt)
+		ino_rec = findfirst_free_inode_rec(agno);
+	else
+		ino_rec = findfirst_inode_rec(agno);
 
 	if (ino_rec != NULL)
 		first_agino = ino_rec->ino_startnum;
@@ -1207,7 +1225,11 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 			bt_rec[j].ir_freecount = cpu_to_be32(inocnt);
 			freecount += inocnt;
 			count += XFS_INODES_PER_CHUNK;
-			ino_rec = next_ino_rec(ino_rec);
+
+			if (finobt)
+				ino_rec = next_free_ino_rec(ino_rec);
+			else
+				ino_rec = next_ino_rec(ino_rec);
 		}
 
 		if (ino_rec != NULL)  {
@@ -1483,9 +1505,12 @@ phase5_func(
 {
 	__uint64_t	num_inos;
 	__uint64_t	num_free_inos;
+	__uint64_t	finobt_num_inos;
+	__uint64_t	finobt_num_free_inos;
 	bt_status_t	bno_btree_curs;
 	bt_status_t	bcnt_btree_curs;
 	bt_status_t	ino_btree_curs;
+	bt_status_t	fino_btree_curs;
 	int		extra_blocks = 0;
 	uint		num_freeblocks;
 	xfs_extlen_t	freeblks1;
@@ -1530,8 +1555,13 @@ phase5_func(
 		 * on-disk btrees (includs pre-allocating all
 		 * required blocks for the trees themselves)
 		 */
-		init_ino_cursor(mp, agno, &ino_btree_curs,
-				&num_inos, &num_free_inos);
+		init_ino_cursor(mp, agno, &ino_btree_curs, &num_inos,
+				&num_free_inos, 0);
+
+		if (xfs_sb_version_hasfinobt(&mp->m_sb))
+			init_ino_cursor(mp, agno, &fino_btree_curs,
+					&finobt_num_inos, &finobt_num_free_inos,
+					1);
 
 		sb_icount_ag[agno] += num_inos;
 		sb_ifree_ag[agno] += num_free_inos;
@@ -1630,17 +1660,31 @@ phase5_func(
 		 */
 		magic = xfs_sb_version_hascrc(&mp->m_sb) ?
 				XFS_IBT_CRC_MAGIC : XFS_IBT_MAGIC;
-		build_ino_tree(mp, agno, &ino_btree_curs, magic, &agi_stat);
+		build_ino_tree(mp, agno, &ino_btree_curs, magic, &agi_stat, 0);
 		write_cursor(&ino_btree_curs);
 
+		/*
+		 * build free inode tree
+		 */
+		if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+			magic = xfs_sb_version_hascrc(&mp->m_sb) ?
+					XFS_FIBT_CRC_MAGIC : XFS_FIBT_MAGIC;
+			build_ino_tree(mp, agno, &fino_btree_curs, magic,
+					NULL, 1);
+			write_cursor(&fino_btree_curs);
+		}
+
 		/* build the agi */
-		build_agi(mp, agno, &ino_btree_curs, &agi_stat);
+		build_agi(mp, agno, &ino_btree_curs, &fino_btree_curs,
+			  &agi_stat);
 
 		/*
 		 * tear down cursors
 		 */
 		finish_cursor(&bno_btree_curs);
 		finish_cursor(&ino_btree_curs);
+		if (xfs_sb_version_hasfinobt(&mp->m_sb))
+			finish_cursor(&fino_btree_curs);
 		finish_cursor(&bcnt_btree_curs);
 		/*
 		 * release the incore per-AG bno/bcnt trees so
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
