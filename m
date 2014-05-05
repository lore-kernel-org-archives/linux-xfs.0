Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5DDFE7F75
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 07:32:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4915D30405F
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 05:32:04 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Q0xxTNZBuFjL7JbD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 05:32:02 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s45CW0JH022229
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:01 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s45CVxkC004684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:32:00 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s45CVxNF029317 for <xfs@oss.sgi.com>; Mon, 5 May 2014 12:31:59 GMT
Message-ID: <536784BB.4020308@oracle.com>
Date: Mon, 05 May 2014 20:31:55 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 1/6] xfsprogs: get rid of XFS_IALLOC_INODES macros
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

Get rid of XFS_IALLOC_INODES() macros, use mp->m_ialloc_inos directly.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 include/xfs_ialloc.h |  1 -
 libxfs/xfs_ialloc.c  | 12 ++++++------
 repair/dino_chunks.c | 16 ++++++++--------
 repair/prefetch.c    |  4 ++--
 4 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
index a8f76a5..4689b02 100644
--- a/include/xfs_ialloc.h
+++ b/include/xfs_ialloc.h
@@ -28,7 +28,6 @@ struct xfs_btree_cur;
 /*
  * Allocation parameters for inode allocation.
  */
-#define	XFS_IALLOC_INODES(mp)	(mp)->m_ialloc_inos
 #define	XFS_IALLOC_BLOCKS(mp)	(mp)->m_ialloc_blks
 
 /*
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index c19d84a..108f6f2 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -201,7 +201,7 @@ xfs_ialloc_inode_init(
 		 * they track in the AIL as if they were physically logged.
 		 */
 		if (tp)
-			xfs_icreate_log(tp, agno, agbno, XFS_IALLOC_INODES(mp),
+			xfs_icreate_log(tp, agno, agbno, mp->m_ialloc_inos,
 					mp->m_sb.sb_inodesize, length, gen);
 	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
 		version = 2;
@@ -305,7 +305,7 @@ xfs_ialloc_ag_alloc(
 	 * Locking will ensure that we don't have two callers in here
 	 * at one time.
 	 */
-	newlen = XFS_IALLOC_INODES(args.mp);
+	newlen = args.mp->m_ialloc_inos;
 	if (args.mp->m_maxicount &&
 	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
 		return XFS_ERROR(ENOSPC);
@@ -975,7 +975,7 @@ xfs_dialloc(
 	 * inode.
 	 */
 	if (mp->m_maxicount &&
-	    mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
+	    mp->m_sb.sb_icount + mp->m_ialloc_inos > mp->m_maxicount) {
 		noroom = 1;
 		okalloc = 0;
 	}
@@ -1178,7 +1178,7 @@ xfs_difree(
 	 * When an inode cluster is free, it becomes eligible for removal
 	 */
 	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
-	    (rec.ir_freecount == XFS_IALLOC_INODES(mp))) {
+	    (rec.ir_freecount == mp->m_ialloc_inos)) {
 
 		*delete = 1;
 		*first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
@@ -1188,7 +1188,7 @@ xfs_difree(
 		 * AGI and Superblock inode counts, and mark the disk space
 		 * to be freed when the transaction is committed.
 		 */
-		ilen = XFS_IALLOC_INODES(mp);
+		ilen = mp->m_ialloc_inos;
 		be32_add_cpu(&agi->agi_count, -ilen);
 		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
@@ -1287,7 +1287,7 @@ xfs_imap_lookup(
 
 	/* check that the returned record contains the required inode */
 	if (rec.ir_startino > agino ||
-	    rec.ir_startino + XFS_IALLOC_INODES(mp) <= agino)
+	    rec.ir_startino + mp->m_ialloc_inos <= agino)
 		return EINVAL;
 
 	/* for untrusted inodes check it is allocated first */
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index afb26e0..15aa4f8 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -267,7 +267,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	 * would include the inode passed into us.
 	 */
 	if (XFS_IALLOC_BLOCKS(mp) > 1)  {
-		if (agino > XFS_IALLOC_INODES(mp))
+		if (agino > mp->m_ialloc_inos)
 			start_agbno = agbno - XFS_IALLOC_BLOCKS(mp) + 1;
 		else
 			start_agbno = 1;
@@ -336,7 +336,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			 * of the gap -- is it within the search range?
 			 */
 			if (irec_next_p != NULL &&
-					agino + XFS_IALLOC_INODES(mp) >=
+					agino + mp->m_ialloc_inos >=
 						irec_next_p->ino_startnum)
 				end_agbno = XFS_AGINO_TO_AGBNO(mp,
 						irec_next_p->ino_startnum);
@@ -688,7 +688,7 @@ process_inode_chunk(
 			icnt++;
 			cluster_offset++;
 
-			if (icnt == XFS_IALLOC_INODES(mp) &&
+			if (icnt == mp->m_ialloc_inos &&
 					irec_offset == XFS_INODES_PER_CHUNK)  {
 				/*
 				 * done! - finished up irec and block
@@ -900,7 +900,7 @@ process_inode_chunk(
 		icnt++;
 		cluster_offset++;
 
-		if (icnt == XFS_IALLOC_INODES(mp) &&
+		if (icnt == mp->m_ialloc_inos &&
 				irec_offset == XFS_INODES_PER_CHUNK)  {
 			/*
 			 * done! - finished up irec and block simultaneously
@@ -1002,7 +1002,7 @@ process_aginodes(
 		 * the next block before we call the processing routines.
 		 */
 		num_inos = XFS_INODES_PER_CHUNK;
-		while (num_inos < XFS_IALLOC_INODES(mp) && ino_rec != NULL)  {
+		while (num_inos < mp->m_ialloc_inos && ino_rec != NULL)  {
 			/*
 			 * inodes chunks will always be aligned and sized
 			 * correctly
@@ -1011,7 +1011,7 @@ process_aginodes(
 				num_inos += XFS_INODES_PER_CHUNK;
 		}
 
-		ASSERT(num_inos == XFS_IALLOC_INODES(mp));
+		ASSERT(num_inos == mp->m_ialloc_inos);
 
 		if (pf_args) {
 			sem_post(&pf_args->ra_count);
@@ -1043,7 +1043,7 @@ process_aginodes(
 			 */
 			num_inos = 0;
 			ino_rec = first_ino_rec;
-			while (num_inos < XFS_IALLOC_INODES(mp) &&
+			while (num_inos < mp->m_ialloc_inos &&
 					ino_rec != NULL)  {
 				prev_ino_rec = ino_rec;
 
@@ -1227,7 +1227,7 @@ process_uncertain_aginodes(xfs_mount_t *mp, xfs_agnumber_t agno)
 			 * processing may add more records to the
 			 * uncertain inode lists.
 			 */
-			if (process_inode_chunk(mp, agno, XFS_IALLOC_INODES(mp),
+			if (process_inode_chunk(mp, agno, mp->m_ialloc_inos,
 						nrec, 1, 0, 0, &bogus))  {
 				/* XXX - i/o error, we've got a problem */
 				abort();
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 65fedf5..2cd3d5a 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -711,7 +711,7 @@ pf_queuing_worker(
 		cur_irec = irec;
 
 		num_inos = XFS_INODES_PER_CHUNK;
-		while (num_inos < XFS_IALLOC_INODES(mp) && irec != NULL) {
+		while (num_inos < mp->m_ialloc_inos && irec != NULL) {
 			irec = next_ino_rec(irec);
 			num_inos += XFS_INODES_PER_CHUNK;
 		}
@@ -749,7 +749,7 @@ pf_queuing_worker(
 								 : B_INODE);
 			bno += blks_per_cluster;
 			num_inos += inodes_per_cluster;
-		} while (num_inos < XFS_IALLOC_INODES(mp));
+		} while (num_inos < mp->m_ialloc_inos);
 	}
 
 	pthread_mutex_lock(&args->lock);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
