Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 663C38024
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CCE57AC001
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OasYQfYRuUPdW3X8 for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:34 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RS-0004I5-K9
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RS-0002JC-Iv
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/49] xfsprogs: port inode create transaction changes
Date: Fri, 19 Jul 2013 16:44:37 +1000
Message-Id: <1374216324-8781-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Bring across the relevant parts of the new inode create transaction
sufficient to keep kernel/user code in sync and implement the
infrastructure needed to make it work in xfsprogs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h           |   1 +
 include/xfs_ialloc.h       |   8 +++
 include/xfs_icreate_item.h |   3 ++
 libxfs/xfs.h               |   5 ++
 libxfs/xfs_ialloc.c        |  87 +++++++++++++++++++++++++--------
 libxfs/xfs_trans.c         | 118 +++++++++++++++++++++++++++++----------------
 6 files changed, 160 insertions(+), 62 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index f11ad52..bd74ca5 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -57,6 +57,7 @@
 #include <xfs/xfs_bmap.h>
 #include <xfs/xfs_trace.h>
 #include <xfs/xfs_symlink.h>
+#include <xfs/xfs_icreate_item.h>
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
index c8da3df..68c0732 100644
--- a/include/xfs_ialloc.h
+++ b/include/xfs_ialloc.h
@@ -150,6 +150,14 @@ int xfs_inobt_lookup(struct xfs_btree_cur *cur, xfs_agino_t ino,
 int xfs_inobt_get_rec(struct xfs_btree_cur *cur,
 		xfs_inobt_rec_incore_t *rec, int *stat);
 
+/*
+ * Inode chunk initialisation routine
+ */
+int xfs_ialloc_inode_init(struct xfs_mount *mp, struct xfs_trans *tp,
+			  struct list_head *buffer_list,
+			  xfs_agnumber_t agno, xfs_agblock_t agbno,
+			  xfs_agblock_t length, unsigned int gen);
+
 extern const struct xfs_buf_ops xfs_agi_buf_ops;
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/include/xfs_icreate_item.h b/include/xfs_icreate_item.h
index 88ba8aa..70dc03c 100644
--- a/include/xfs_icreate_item.h
+++ b/include/xfs_icreate_item.h
@@ -36,6 +36,8 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+#ifdef __KERNEL__
+
 /* in memory log item structure */
 struct xfs_icreate_item {
 	struct xfs_log_item	ic_item;
@@ -48,5 +50,6 @@ void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
 			xfs_agblock_t agbno, unsigned int count,
 			unsigned int inode_size, xfs_agblock_t length,
 			unsigned int generation);
+#endif /* __KERNEL__ */
 
 #endif	/* XFS_ICREATE_ITEM_H */
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index aa71ecc..15e82d7 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -176,6 +176,7 @@ roundup_pow_of_two(uint v)
 #define XBF_TRYLOCK			XFS_BUF_TRYLOCK
 #define XBF_DONT_BLOCK			0
 #define XBF_UNMAPPED			0
+#define XBF_DONE			0
 #define XFS_BUF_GETERROR(bp)		0
 #define XFS_BUF_DONE(bp)		((bp)->b_flags |= LIBXFS_B_UPTODATE)
 #define XFS_BUF_ISDONE(bp)		((bp)->b_flags & LIBXFS_B_UPTODATE)
@@ -194,6 +195,7 @@ roundup_pow_of_two(uint v)
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len,f)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
+#define xfs_buf_delwri_queue(bp, bl)	libxfs_writebuf((bp), 0)
 
 #define XBRW_READ			LIBXFS_BREAD
 #define XBRW_WRITE			LIBXFS_BWRITE
@@ -252,6 +254,7 @@ roundup_pow_of_two(uint v)
 
 #define xfs_trans_get_block_res(tp)	1
 #define xfs_trans_set_sync(tp)		((void) 0)
+#define xfs_trans_ordered_buf(tp, bp)	((void) 0)
 #define	xfs_trans_agblocks_delta(tp, d)
 #define	xfs_trans_agflist_delta(tp, d)
 #define	xfs_trans_agbtree_delta(tp, d)
@@ -325,6 +328,8 @@ do { \
 #define uuid_copy(s,d)		platform_uuid_copy((s),(d))
 #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
 
+#define xfs_icreate_log(tp, agno, agbno, cnt, isize, len, gen) ((void) 0)
+
 /*
  * Prototypes for kernel static functions that are aren't in their
  * associated header files
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 76fdcea..48916dd 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -129,12 +129,16 @@ xfs_check_agi_freecount(
 #endif
 
 /*
- * Initialise a new set of inodes.
+ * Initialise a new set of inodes. When called without a transaction context
+ * (e.g. from recovery) we initiate a delayed write of the inode buffers rather
+ * than logging them (which in a transaction context puts them into the AIL
+ * for writeback rather than the xfsbufd queue).
  */
-STATIC int
+int
 xfs_ialloc_inode_init(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	struct list_head	*buffer_list,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		agbno,
 	xfs_agblock_t		length,
@@ -165,22 +169,40 @@ xfs_ialloc_inode_init(
 	}
 
 	/*
-	 * Figure out what version number to use in the inodes we create.
-	 * If the superblock version has caught up to the one that supports
-	 * the new inode format, then use the new inode version.  Otherwise
-	 * use the old version so that old kernels will continue to be
-	 * able to use the file system.
+	 * Figure out what version number to use in the inodes we create.  If
+	 * the superblock version has caught up to the one that supports the new
+	 * inode format, then use the new inode version.  Otherwise use the old
+	 * version so that old kernels will continue to be able to use the file
+	 * system.
 	 *
 	 * For v3 inodes, we also need to write the inode number into the inode,
 	 * so calculate the first inode number of the chunk here as
-	 * XFS_OFFBNO_TO_AGINO() only works on filesystem block boundaries, not
-	 * cluster boundaries and so cannot be used in the cluster buffer loop
-	 * below.
+	 * XFS_OFFBNO_TO_AGINO() only works within a filesystem block, not
+	 * across multiple filesystem blocks (such as a cluster) and so cannot
+	 * be used in the cluster buffer loop below.
+	 *
+	 * Further, because we are writing the inode directly into the buffer
+	 * and calculating a CRC on the entire inode, we have ot log the entire
+	 * inode so that the entire range the CRC covers is present in the log.
+	 * That means for v3 inode we log the entire buffer rather than just the
+	 * inode cores.
 	 */
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		version = 3;
 		ino = XFS_AGINO_TO_INO(mp, agno,
 				       XFS_OFFBNO_TO_AGINO(mp, agbno, 0));
+
+		/*
+		 * log the initialisation that is about to take place as an
+		 * logical operation. This means the transaction does not
+		 * need to log the physical changes to the inode buffers as log
+		 * recovery will know what initialisation is actually needed.
+		 * Hence we only need to log the buffers as "ordered" buffers so
+		 * they track in the AIL as if they were physically logged.
+		 */
+		if (tp)
+			xfs_icreate_log(tp, agno, agbno, XFS_IALLOC_INODES(mp),
+					mp->m_sb.sb_inodesize, length, gen);
 	} else if (xfs_sb_version_hasnlink(&mp->m_sb))
 		version = 2;
 	else
@@ -196,15 +218,10 @@ xfs_ialloc_inode_init(
 					 XBF_UNMAPPED);
 		if (!fbuf)
 			return ENOMEM;
-		/*
-		 * Initialize all inodes in this buffer and then log them.
-		 *
-		 * XXX: It would be much better if we had just one transaction
-		 *	to log a whole cluster of inodes instead of all the
-		 *	individual transactions causing a lot of log traffic.
-		 */
+
+		/* Initialize the inode buffers and log them appropriately. */
 		fbuf->b_ops = &xfs_inode_buf_ops;
-		xfs_buf_zero(fbuf, 0, ninodes << mp->m_sb.sb_inodelog);
+		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
 		for (i = 0; i < ninodes; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
 			uint	isize = xfs_dinode_size(version);
@@ -220,11 +237,39 @@ xfs_ialloc_inode_init(
 				ino++;
 				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
 				xfs_dinode_calc_crc(mp, free);
+			} else if (tp) {
+				/* just log the inode core */
+				xfs_trans_log_buf(tp, fbuf, ioffset,
+						  ioffset + isize - 1);
 			}
+		}
 
-			xfs_trans_log_buf(tp, fbuf, ioffset, ioffset + isize - 1);
+		if (tp) {
+			/*
+			 * Mark the buffer as an inode allocation buffer so it
+			 * sticks in AIL at the point of this allocation
+			 * transaction. This ensures the they are on disk before
+			 * the tail of the log can be moved past this
+			 * transaction (i.e. by preventing relogging from moving
+			 * it forward in the log).
+			 */
+			xfs_trans_inode_alloc_buf(tp, fbuf);
+			if (version == 3) {
+				/*
+				 * Mark the buffer as ordered so that they are
+				 * not physically logged in the transaction but
+				 * still tracked in the AIL as part of the
+				 * transaction and pin the log appropriately.
+				 */
+				xfs_trans_ordered_buf(tp, fbuf);
+				xfs_trans_log_buf(tp, fbuf, 0,
+						  BBTOB(fbuf->b_length) - 1);
+			}
+		} else {
+			fbuf->b_flags |= XBF_DONE;
+			xfs_buf_delwri_queue(fbuf, buffer_list);
+			xfs_buf_relse(fbuf);
 		}
-		xfs_trans_inode_alloc_buf(tp, fbuf);
 	}
 	return 0;
 }
@@ -372,7 +417,7 @@ xfs_ialloc_ag_alloc(
 	 * rather than a linear progression to prevent the next generation
 	 * number from being easily guessable.
 	 */
-	error = xfs_ialloc_inode_init(args.mp, tp, agno, args.agbno,
+	error = xfs_ialloc_inode_init(args.mp, tp, NULL, agno, args.agbno,
 			args.len, prandom_u32());
 
 	if (error)
diff --git a/libxfs/xfs_trans.c b/libxfs/xfs_trans.c
index bdd0ebc..95fb630 100644
--- a/libxfs/xfs_trans.c
+++ b/libxfs/xfs_trans.c
@@ -208,71 +208,93 @@ xfs_calc_remove_reservation(
 }
 
 /*
- * For symlink we can modify:
+ * For create, break it in to the two cases that the transaction
+ * covers. We start with the modify case - allocation done by modification
+ * of the state of existing inodes - and the allocation case.
+ */
+
+/*
+ * For create we can modify:
  *    the parent directory inode: inode size
  *    the new inode: inode size
- *    the inode btree entry: 1 block
+ *    the inode btree entry: block size
+ *    the superblock for the nlink flag: sector size
  *    the directory btree: (max depth + v2) * dir block size
  *    the directory inode's bmap btree: (max depth + v2) * block size
- *    the blocks for the symlink: 1 kB
- * Or in the first xact we allocate some inodes giving:
+ */
+STATIC uint
+xfs_calc_create_resv_modify(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
+		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		(uint)XFS_FSB_TO_B(mp, 1) +
+		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+}
+
+/*
+ * For create we can allocate some inodes giving:
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the superblock for the nlink flag: sector size
  *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
  *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
  */
 STATIC uint
-xfs_calc_symlink_reservation(
+xfs_calc_create_resv_alloc(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		mp->m_sb.sb_sectsize +
+		xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp), XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+STATIC uint
+__xfs_calc_create_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
-		     xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(1, 1024)),
-		    (xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp),
-				      XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(mp->m_in_maxlevels,
-				      XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
+		MAX(xfs_calc_create_resv_alloc(mp),
+		    xfs_calc_create_resv_modify(mp));
 }
 
 /*
- * For create we can modify:
- *    the parent directory inode: inode size
- *    the new inode: inode size
- *    the inode btree entry: block size
- *    the superblock for the nlink flag: sector size
- *    the directory btree: (max depth + v2) * dir block size
- *    the directory inode's bmap btree: (max depth + v2) * block size
- * Or in the first xact we allocate some inodes giving:
+ * For icreate we can allocate some inodes giving:
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
  *    the superblock for the nlink flag: sector size
- *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
  */
 STATIC uint
-xfs_calc_create_reservation(
+xfs_calc_icreate_resv_alloc(
 	struct xfs_mount	*mp)
 {
+	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
+		mp->m_sb.sb_sectsize +
+		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
+				 XFS_FSB_TO_B(mp, 1));
+}
+
+STATIC uint
+xfs_calc_icreate_reservation(xfs_mount_t *mp)
+{
 	return XFS_DQUOT_LOGRES(mp) +
-		MAX((xfs_calc_buf_res(2, mp->m_sb.sb_inodesize) +
-		     xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		     XFS_FSB_TO_B(mp, 1) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		     mp->m_sb.sb_sectsize +
-		     xfs_calc_buf_res(XFS_IALLOC_BLOCKS(mp),
-				      XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(mp->m_in_maxlevels,
-				      XFS_FSB_TO_B(mp, 1)) +
-		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
+		MAX(xfs_calc_icreate_resv_alloc(mp),
+		    xfs_calc_create_resv_modify(mp));
+}
+
+STATIC uint
+xfs_calc_create_reservation(
+	struct xfs_mount	*mp)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return xfs_calc_icreate_reservation(mp);
+	return __xfs_calc_create_reservation(mp);
+
 }
 
 /*
@@ -285,6 +307,20 @@ xfs_calc_mkdir_reservation(
 	return xfs_calc_create_reservation(mp);
 }
 
+
+/*
+ * Making a new symplink is the same as creating a new file, but
+ * with the added blocks for remote symlink data which can be up to 1kB in
+ * length (MAXPATHLEN).
+ */
+STATIC uint
+xfs_calc_symlink_reservation(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_create_reservation(mp) +
+	       xfs_calc_buf_res(1, MAXPATHLEN);
+}
+
 /*
  * In freeing an inode we can modify:
  *    the inode being freed: inode size
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
