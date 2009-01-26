Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7WiUv203699 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:32:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DE56185E8EA
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jiRRjGqMNspH8ahE for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLwv-00032N-PS
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:01 +0000
Message-Id: <20090126073201.697358000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/17] xfs: remove superflous inobt macros
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-inobt-kill-macros
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_ialloc_btree.h has a a cuple of macros that only obsfucate the code
but don't provide any abstraction benefits.  This patches removes those
and cleans up the reamaining defintions up a little.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-01-21 21:03:27.855294780 +0100
+++ xfs/fs/xfs/xfs_ialloc.c	2009-01-24 18:32:57.973428715 +0100
@@ -230,7 +230,7 @@ xfs_ialloc_ag_alloc(
 		args.minalignslop = xfs_ialloc_cluster_alignment(&args) - 1;
 
 		/* Allow space for the inode btree to split. */
-		args.minleft = XFS_IN_MAXLEVELS(args.mp) - 1;
+		args.minleft = args.mp->m_in_maxlevels - 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	} else
@@ -270,7 +270,7 @@ xfs_ialloc_ag_alloc(
 		/*
 		 * Allow space for the inode btree to split.
 		 */
-		args.minleft = XFS_IN_MAXLEVELS(args.mp) - 1;
+		args.minleft = args.mp->m_in_maxlevels - 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
@@ -943,7 +943,7 @@ nextag:
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
 	ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino + offset);
-	XFS_INOBT_CLR_FREE(&rec, offset);
+	rec.ir_free &= ~XFS_INOBT_MASK(offset);
 	rec.ir_freecount--;
 	if ((error = xfs_inobt_update(cur, rec.ir_startino, rec.ir_freecount,
 			rec.ir_free)))
@@ -1105,11 +1105,11 @@ xfs_difree(
 	 */
 	off = agino - rec.ir_startino;
 	ASSERT(off >= 0 && off < XFS_INODES_PER_CHUNK);
-	ASSERT(!XFS_INOBT_IS_FREE(&rec, off));
+	ASSERT(!(rec.ir_free & XFS_INOBT_MASK(off)));
 	/*
 	 * Mark the inode free & increment the count.
 	 */
-	XFS_INOBT_SET_FREE(&rec, off);
+	rec.ir_free |= XFS_INOBT_MASK(off);
 	rec.ir_freecount++;
 
 	/*
Index: xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc_btree.h	2009-01-21 21:03:27.856294768 +0100
+++ xfs/fs/xfs/xfs_ialloc_btree.h	2009-01-24 18:37:45.158596049 +0100
@@ -32,14 +32,14 @@ struct xfs_mount;
 #define	XFS_IBT_MAGIC	0x49414254	/* 'IABT' */
 
 typedef	__uint64_t	xfs_inofree_t;
-#define	XFS_INODES_PER_CHUNK	(NBBY * sizeof(xfs_inofree_t))
+#define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
 #define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
-#define	XFS_INOBT_ALL_FREE	((xfs_inofree_t)-1)
+#define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
+#define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
 
 static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
 {
-	return (((n) >= XFS_INODES_PER_CHUNK ? \
-		(xfs_inofree_t)0 : ((xfs_inofree_t)1 << (n))) - 1) << (i);
+	return ((n >= XFS_INODES_PER_CHUNK ? 0 : XFS_INOBT_MASK(n)) - 1) << i;
 }
 
 /*
@@ -69,20 +69,6 @@ typedef struct xfs_inobt_key {
 typedef __be32 xfs_inobt_ptr_t;
 
 /*
- * Bit manipulations for ir_free.
- */
-#define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
-#define	XFS_INOBT_IS_FREE(rp,i)		\
-		(((rp)->ir_free & XFS_INOBT_MASK(i)) != 0)
-#define	XFS_INOBT_SET_FREE(rp,i)	((rp)->ir_free |= XFS_INOBT_MASK(i))
-#define	XFS_INOBT_CLR_FREE(rp,i)	((rp)->ir_free &= ~XFS_INOBT_MASK(i))
-
-/*
- * Maximum number of inode btree levels.
- */
-#define	XFS_IN_MAXLEVELS(mp)		((mp)->m_in_maxlevels)
-
-/*
  * block numbers in the AG.
  */
 #define	XFS_IBT_BLOCK(mp)		((xfs_agblock_t)(XFS_CNT_BLOCK(mp) + 1))
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2009-01-24 18:13:41.777903750 +0100
+++ xfs/fs/xfs/xfs_mount.h	2009-01-24 18:32:57.980458591 +0100
@@ -273,7 +273,7 @@ typedef struct xfs_mount {
 	uint			m_inobt_mnr[2];	/* min inobt btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
-	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
+	uint			m_in_maxlevels;	/* max inobt btree levels. */
 	struct xfs_perag	*m_perag;	/* per-ag accounting info */
 	struct rw_semaphore	m_peraglock;	/* lock for m_perag (pointer) */
 	struct mutex		m_growlock;	/* growfs mutex */
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2009-01-21 21:03:27.869295167 +0100
+++ xfs/fs/xfs/xfs_trans.h	2009-01-24 18:32:57.981428687 +0100
@@ -343,7 +343,7 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_
 	  (128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4))) + \
 	  (128 * 5) + \
 	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	   (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
+	   (128 * (2 + XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels + \
 	    XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
 
 #define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate)
@@ -449,9 +449,9 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_
 	  (128 * (4 + XFS_DIROP_LOG_COUNT(mp)))), \
 	 (2 * (mp)->m_sb.sb_sectsize + \
 	  XFS_FSB_TO_B((mp), XFS_IALLOC_BLOCKS((mp))) + \
-	  XFS_FSB_TO_B((mp), XFS_IN_MAXLEVELS(mp)) + \
+	  XFS_FSB_TO_B((mp), (mp)->m_in_maxlevels) + \
 	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
+	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels + \
 	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
 
 #define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink)
@@ -481,9 +481,9 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_
 	  (128 * (3 + XFS_DIROP_LOG_COUNT(mp)))), \
 	 (3 * (mp)->m_sb.sb_sectsize + \
 	  XFS_FSB_TO_B((mp), XFS_IALLOC_BLOCKS((mp))) + \
-	  XFS_FSB_TO_B((mp), XFS_IN_MAXLEVELS(mp)) + \
+	  XFS_FSB_TO_B((mp), (mp)->m_in_maxlevels) + \
 	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
+	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels + \
 	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))))
 
 #define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create)
@@ -513,7 +513,7 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_
 	 MAX((__uint16_t)XFS_FSB_TO_B((mp), 1), XFS_INODE_CLUSTER_SIZE(mp)) + \
 	 (128 * 5) + \
 	  XFS_ALLOCFREE_LOG_RES(mp, 1) + \
-	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp) + \
+	  (128 * (2 + XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels + \
 	   XFS_ALLOCFREE_LOG_COUNT(mp, 1))))
 
 
Index: xfs/fs/xfs/xfs_trans_space.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_space.h	2009-01-21 21:03:27.870294945 +0100
+++ xfs/fs/xfs/xfs_trans_space.h	2009-01-24 18:32:57.982461290 +0100
@@ -47,7 +47,7 @@
 #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
-	(XFS_IALLOC_BLOCKS(mp) + XFS_IN_MAXLEVELS(mp)-1)
+	(XFS_IALLOC_BLOCKS(mp) + (mp)->m_in_maxlevels - 1)
 
 /*
  * Space reservation values for various transactions.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
