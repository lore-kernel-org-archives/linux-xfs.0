Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 018D67F75
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 07:32:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE4CF8F8039
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 05:32:21 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id u03acjT1dAoeFtms (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 05:32:20 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s45CWJ7J022720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:19 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id
	s45CWIAk014949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:18 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s45CWInK009388 for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:18 GMT
Message-ID: <536784CD.60900@oracle.com>
Date: Mon, 05 May 2014 20:32:13 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 3/6] xfsprogs: get rid of XFS_IALLOC_BLOCKS macros
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Get rid of XFS_IALLOC_BLOCKS() macros, use mp->m_ialloc_blks directly.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 db/check.c                |  2 +-
 db/frag.c                 |  2 +-
 db/metadump.c             |  2 +-
 include/xfs_ialloc.h      |  5 -----
 include/xfs_trans_space.h |  2 +-
 libxfs/xfs_ialloc.c       |  8 ++++----
 libxfs/xfs_trans_resv.c   |  8 ++++----
 mkfs/proto.c              |  2 +-
 repair/dino_chunks.c      | 24 ++++++++++++------------
 repair/prefetch.c         |  2 +-
 repair/xfs_repair.c       |  4 ++--
 11 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/db/check.c b/db/check.c
index 4fd9fd0..df98cc6 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4223,7 +4223,7 @@ scanfunc_ino(
 			set_cur(&typtab[TYP_INODE],
 				XFS_AGB_TO_DADDR(mp, seqno,
 						 XFS_AGINO_TO_AGBNO(mp, agino)),
-				(int)XFS_FSB_TO_BB(mp, XFS_IALLOC_BLOCKS(mp)),
+				(int)XFS_FSB_TO_BB(mp, mp->m_ialloc_blks),
 				DB_RING_IGN, NULL);
 			if (iocur_top->data == NULL) {
 				if (!sflag)
diff --git a/db/frag.c b/db/frag.c
index 2eb33d8..38b77e0 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -484,7 +484,7 @@ scanfunc_ino(
 			set_cur(&typtab[TYP_INODE],
 				XFS_AGB_TO_DADDR(mp, seqno,
 						 XFS_AGINO_TO_AGBNO(mp, agino)),
-				XFS_FSB_TO_BB(mp, XFS_IALLOC_BLOCKS(mp)),
+				XFS_FSB_TO_BB(mp, mp->m_ialloc_blks),
 				DB_RING_IGN, NULL);
 			if (iocur_top->data == NULL) {
 				dbprintf(_("can't read inode block %u/%u\n"),
diff --git a/db/metadump.c b/db/metadump.c
index 09bb85a..bae08cd 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1848,7 +1848,7 @@ copy_inode_chunk(
 
 	push_cur();
 	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, agbno),
-			XFS_FSB_TO_BB(mp, XFS_IALLOC_BLOCKS(mp)),
+			XFS_FSB_TO_BB(mp, mp->m_ialloc_blks),
 			DB_RING_IGN, NULL);
 	if (iocur_top->data == NULL) {
 		print_warning("cannot read inode block %u/%u", agno, agbno);
diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
index 4026933..0498f20 100644
--- a/include/xfs_ialloc.h
+++ b/include/xfs_ialloc.h
@@ -26,11 +26,6 @@ struct xfs_trans;
 struct xfs_btree_cur;
 
 /*
- * Allocation parameters for inode allocation.
- */
-#define	XFS_IALLOC_BLOCKS(mp)	(mp)->m_ialloc_blks
-
-/*
  * Move inodes in clusters of this size.
  */
 #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
diff --git a/include/xfs_trans_space.h b/include/xfs_trans_space.h
index 7d2c920..af5dbe0 100644
--- a/include/xfs_trans_space.h
+++ b/include/xfs_trans_space.h
@@ -47,7 +47,7 @@
 #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
-	(XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels - 1)
+	((mp)->m_ialloc_blks + (mp)->m_in_maxlevels - 1)
 
 /*
  * Space reservation values for various transactions.
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index bd47971..a3a1c75 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -309,7 +309,7 @@ xfs_ialloc_ag_alloc(
 	if (args.mp->m_maxicount &&
 	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
 		return XFS_ERROR(ENOSPC);
-	args.minlen = args.maxlen = XFS_IALLOC_BLOCKS(args.mp);
+	args.minlen = args.maxlen = args.mp->m_ialloc_blks;
 	/*
 	 * First try to allocate inodes contiguous with the last-allocated
 	 * chunk of inodes.  If the filesystem is striped, this will fill
@@ -319,7 +319,7 @@ xfs_ialloc_ag_alloc(
 	newino = be32_to_cpu(agi->agi_newino);
 	agno = be32_to_cpu(agi->agi_seqno);
 	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
-			XFS_IALLOC_BLOCKS(args.mp);
+			args.mp->m_ialloc_blks;
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
 		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
@@ -561,7 +561,7 @@ xfs_ialloc_ag_select(
 		 * Is there enough free space for the file plus a block of
 		 * inodes? (if we need to allocate some)?
 		 */
-		ineed = XFS_IALLOC_BLOCKS(mp);
+		ineed = mp->m_ialloc_blks;
 		longest = pag->pagf_longest;
 		if (!longest)
 			longest = pag->pagf_flcount > 0;
@@ -1206,7 +1206,7 @@ xfs_difree(
 
 		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp,
 				agno, XFS_INO_TO_AGBNO(mp,rec.ir_startino)),
-				XFS_IALLOC_BLOCKS(mp), flist, mp);
+				mp->m_ialloc_blks, flist, mp);
 	} else {
 		*delete = 0;
 
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index ba9c7b0..93261f1 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -157,7 +157,7 @@ xfs_calc_itruncate_reservation(
 		    xfs_calc_buf_res(5, 0) +
 		    xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
 				     XFS_FSB_TO_B(mp, 1)) +
-		    xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
+		    xfs_calc_buf_res(2 + mp->m_ialloc_blks +
 				     mp->m_in_maxlevels, 0)));
 }
 
@@ -265,7 +265,7 @@ xfs_calc_create_resv_modify(
  * For create we can allocate some inodes giving:
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
  *    the superblock for the nlink flag: sector size
- *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
+ *    the inode blocks allocated: mp->m_ialloc_blks * blocksize
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
  */
@@ -275,7 +275,7 @@ xfs_calc_create_resv_alloc(
 {
 	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		mp->m_sb.sb_sectsize +
-		xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp), XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(mp->m_ialloc_blks, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
@@ -371,7 +371,7 @@ xfs_calc_ifree_reservation(
 		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
 		    mp->m_inode_cluster_size) +
 		xfs_calc_buf_res(1, 0) +
-		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
+		xfs_calc_buf_res(2 + mp->m_ialloc_blks +
 				 mp->m_in_maxlevels, 0) +
 		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
 				 XFS_FSB_TO_B(mp, 1));
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 5a47e27..2689f75 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -39,7 +39,7 @@ static long filesize(int fd);
  * (basically no fragmentation).
  */
 #define	MKFS_BLOCKRES_INODE	\
-	((uint)(XFS_IALLOC_BLOCKS(mp) + ((mp)->m_in_maxlevels - 1)))
+	((uint)(mp->m_ialloc_blks + ((mp)->m_in_maxlevels - 1)))
 #define	MKFS_BLOCKRES(rb)	\
 	((uint)(MKFS_BLOCKRES_INODE + XFS_DA_NODE_MAXDEPTH + \
 	(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1) + (rb)))
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 2c2fd79..1bf1fca 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -117,7 +117,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	agbno = XFS_INO_TO_AGBNO(mp, ino);
 	*start_ino = NULLFSINO;
 
-	ASSERT(XFS_IALLOC_BLOCKS(mp) > 0);
+	ASSERT(mp->m_ialloc_blks > 0);
 
 	if (agno == mp->m_sb.sb_agcount - 1)
 		max_agbno = mp->m_sb.sb_dblocks -
@@ -135,7 +135,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	 * check for the easy case, inodes per block >= XFS_INODES_PER_CHUNK
 	 * (multiple chunks per block)
 	 */
-	if (XFS_IALLOC_BLOCKS(mp) == 1)  {
+	if (mp->m_ialloc_blks == 1)  {
 		if (agbno > max_agbno)
 			return 0;
 		if (check_aginode_block(mp, agno, agino) == 0)
@@ -208,7 +208,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		 */
 		start_agbno = rounddown(XFS_INO_TO_AGBNO(mp, ino),
 					fs_ino_alignment);
-		end_agbno = start_agbno + XFS_IALLOC_BLOCKS(mp);
+		end_agbno = start_agbno + mp->m_ialloc_blks;
 
 		/*
 		 * if this fs has aligned inodes but the end of the
@@ -266,14 +266,14 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	 * a discovered inode chunk completely within that range
 	 * would include the inode passed into us.
 	 */
-	if (XFS_IALLOC_BLOCKS(mp) > 1)  {
+	if (mp->m_ialloc_blks > 1)  {
 		if (agino > mp->m_ialloc_inos)
-			start_agbno = agbno - XFS_IALLOC_BLOCKS(mp) + 1;
+			start_agbno = agbno - mp->m_ialloc_blks + 1;
 		else
 			start_agbno = 1;
 	}
 
-	end_agbno = agbno + XFS_IALLOC_BLOCKS(mp);
+	end_agbno = agbno + mp->m_ialloc_blks;
 
 	if (end_agbno > max_agbno)
 		end_agbno = max_agbno;
@@ -328,7 +328,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 
 			start_agbno = XFS_AGINO_TO_AGBNO(mp,
 						irec_p->ino_startnum) +
-						XFS_IALLOC_BLOCKS(mp);
+						mp->m_ialloc_blks;
 
 			/*
 			 * we know that the inode we're trying to verify isn't
@@ -351,7 +351,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	 * the inode in question and that the space between them
 	 * is too small for a legal inode chunk
 	 */
-	if (end_agbno - start_agbno < XFS_IALLOC_BLOCKS(mp))
+	if (end_agbno - start_agbno < mp->m_ialloc_blks)
 		return(0);
 
 	/*
@@ -395,7 +395,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 
 	num_blks = chunk_stop_agbno - chunk_start_agbno;
 
-	if (num_blks < XFS_IALLOC_BLOCKS(mp) || ino_cnt == 0)
+	if (num_blks < mp->m_ialloc_blks || ino_cnt == 0)
 		return(0);
 
 	/*
@@ -411,8 +411,8 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	 * the chunk
 	 */
 
-	if (num_blks % XFS_IALLOC_BLOCKS(mp) != 0)  {
-		num_blks = rounddown(num_blks, XFS_IALLOC_BLOCKS(mp));
+	if (num_blks % mp->m_ialloc_blks != 0)  {
+		num_blks = rounddown(num_blks, mp->m_ialloc_blks);
 		chunk_stop_agbno = chunk_start_agbno + num_blks;
 	}
 
@@ -596,7 +596,7 @@ process_inode_chunk(
 	ASSERT(XFS_AGINO_TO_OFFSET(mp, first_irec->ino_startnum) == 0);
 
 	*bogus = 0;
-	ASSERT(XFS_IALLOC_BLOCKS(mp) > 0);
+	ASSERT(mp->m_ialloc_blks > 0);
 
 	blks_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
 	if (blks_per_cluster == 0)
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 25ceb34..e3dfd08 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -846,7 +846,7 @@ start_inode_prefetch(
 	max_queue = libxfs_bcache->c_maxcount / thread_count / 8;
 	if (mp->m_inode_cluster_size > mp->m_sb.sb_blocksize)
 		max_queue = max_queue * (mp->m_inode_cluster_size >>
-				mp->m_sb.sb_blocklog) / XFS_IALLOC_BLOCKS(mp);
+				mp->m_sb.sb_blocklog) / mp->m_ialloc_blks;
 
 	sem_init(&args->ra_count, 0, max_queue);
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index b6d070b..5515de8 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -441,9 +441,9 @@ calc_mkfs(xfs_mount_t *mp)
 		first_prealloc_ino = XFS_OFFBNO_TO_AGINO(mp, fino_bno, 0);
 	}
 
-	ASSERT(XFS_IALLOC_BLOCKS(mp) > 0);
+	ASSERT(mp->m_ialloc_blks > 0);
 
-	if (XFS_IALLOC_BLOCKS(mp) > 1)
+	if (mp->m_ialloc_blks > 1)
 		last_prealloc_ino = first_prealloc_ino + XFS_INODES_PER_CHUNK;
 	else
 		last_prealloc_ino = XFS_OFFBNO_TO_AGINO(mp, fino_bno + 1, 0);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
