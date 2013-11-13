Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E083F7F53
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:56:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6B544AC014
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SSLDknxcrk2kV2Tt for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:25 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rADFuPSX015059
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:25 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rADFuOgu020730
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 18/20] xfsprogs/repair: reconstruct the finobt in phase 5
Date: Wed, 13 Nov 2013 10:56:20 -0500
Message-Id: <1384358182-37967-19-git-send-email-bfoster@redhat.com>
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

Support reconstruction of the finobt in phase 5 of xfs_repair. We
create a new cursor for the finobt and write the in-core records
that contain free inodes to the tree. Finally, pass the cursor
along to build_agi() to include the finobt root and level count in
the agi header.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/phase5.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 13 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 9632d2c..e138a6a 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -881,10 +881,11 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
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
@@ -920,13 +921,22 @@ init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
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
@@ -1061,8 +1071,8 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
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
@@ -1096,6 +1106,11 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
 
+	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
+		agi->agi_free_root = cpu_to_be32(finobt_curs->root);
+		agi->agi_free_level = cpu_to_be32(finobt_curs->num_levels);
+	}
+
 	libxfs_writebuf(agi_buf, 0);
 }
 
@@ -1106,7 +1121,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno,
 static void
 build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_status_t *btree_curs, __uint32_t magic,
-		struct agi_stat *agi_stat)
+		struct agi_stat *agi_stat, int finobt)
 {
 	xfs_agnumber_t		i;
 	xfs_agblock_t		j;
@@ -1158,7 +1173,10 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
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
@@ -1210,7 +1228,11 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
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
@@ -1486,9 +1508,12 @@ phase5_func(
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
@@ -1533,8 +1558,13 @@ phase5_func(
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
@@ -1633,17 +1663,31 @@ phase5_func(
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
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
