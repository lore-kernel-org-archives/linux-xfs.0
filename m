Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n24MZeEv108266 for <xfs@oss.sgi.com>; Wed, 4 Mar 2009 16:35:41 -0600
Received: from smtp802.mail.ird.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id CE5CD170C03
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2009 14:35:12 -0800 (PST)
Received: from smtp802.mail.ird.yahoo.com (smtp802.mail.ird.yahoo.com
	[217.146.188.62]) by cuda.sgi.com with SMTP id 6acgGB1fZHzNpb2B
	for <xfs@oss.sgi.com>; Wed, 04 Mar 2009 14:35:12 -0800 (PST)
From: Malcolm Parsons <malcolm.parsons@gmail.com>
Subject: [PATCH] Fix various typos in xfs.
Date: Wed,  4 Mar 2009 22:35:09 +0000
Message-Id: <1236206109-13655-2-git-send-email-malcolm.parsons@gmail.com>
In-Reply-To: <1236206109-13655-1-git-send-email-malcolm.parsons@gmail.com>
References: <1236206109-13655-1-git-send-email-malcolm.parsons@gmail.com>
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
Cc: Malcolm Parsons <malcolm.parsons@gmail.com>

Signed-off-by: Malcolm Parsons <malcolm.parsons@gmail.com>
---
 fs/xfs/xfs_bmap.c         |    6 +++---
 fs/xfs/xfs_bmap.h         |    2 +-
 fs/xfs/xfs_btree.c        |    4 ++--
 fs/xfs/xfs_btree.h        |    2 +-
 fs/xfs/xfs_da_btree.h     |    2 +-
 fs/xfs/xfs_dir2_data.h    |    2 +-
 fs/xfs/xfs_dir2_node.c    |    2 +-
 fs/xfs/xfs_fsops.c        |    2 +-
 fs/xfs/xfs_ialloc.c       |    2 +-
 fs/xfs/xfs_ialloc_btree.c |    2 +-
 fs/xfs/xfs_inode.h        |    2 +-
 fs/xfs/xfs_iomap.h        |    2 +-
 fs/xfs/xfs_itable.c       |    2 +-
 fs/xfs/xfs_log.c          |   10 +++++-----
 fs/xfs/xfs_mount.c        |    8 ++++----
 fs/xfs/xfs_mount.h        |    4 ++--
 fs/xfs/xfs_rtalloc.h      |    4 ++--
 fs/xfs/xfs_trans.h        |   12 ++++++------
 fs/xfs/xfs_trans_ail.c    |    4 ++--
 fs/xfs/xfs_trans_item.c   |    2 +-
 fs/xfs/xfs_utils.c        |    2 +-
 fs/xfs/xfs_vnodeops.c     |    2 +-
 22 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index c852cd6..138d1b5 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2479,7 +2479,7 @@ xfs_bmap_adjacent(
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, ap->firstblock);
 	/*
 	 * If allocating at eof, and there's a previous real block,
-	 * try to use it's last block as our starting point.
+	 * try to use its last block as our starting point.
 	 */
 	if (ap->eof && ap->prevp->br_startoff != NULLFILEOFF &&
 	    !isnullstartblock(ap->prevp->br_startblock) &&
@@ -4804,7 +4804,7 @@ xfs_bmapi(
 	xfs_extlen_t	minlen;		/* min allocation size */
 	xfs_mount_t	*mp;		/* xfs mount structure */
 	int		n;		/* current extent index */
-	int		nallocs;	/* number of extents alloc\'d */
+	int		nallocs;	/* number of extents alloc'd */
 	xfs_extnum_t	nextents;	/* number of extents in file */
 	xfs_fileoff_t	obno;		/* old block number (offset) */
 	xfs_bmbt_irec_t	prev;		/* previous file extent record */
@@ -6494,7 +6494,7 @@ xfs_bmap_count_tree(
 	block = XFS_BUF_TO_BLOCK(bp);
 
 	if (--level) {
-		/* Not at node above leafs, count this level of nodes */
+		/* Not at node above leaves, count this level of nodes */
 		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
 		while (nextbno != NULLFSBLOCK) {
 			if ((error = xfs_btree_read_bufl(mp, tp, nextbno,
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index be2979d..589d3da 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -125,7 +125,7 @@ typedef struct xfs_bmalloca {
 	struct xfs_bmbt_irec	*gotp;	/* extent after, or delayed */
 	xfs_extlen_t		alen;	/* i/o length asked/allocated */
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
-	xfs_extlen_t		minlen;	/* mininum allocation size (blocks) */
+	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
 	xfs_extlen_t		minleft; /* amount must be left after alloc */
 	char			eof;	/* set if allocating past last extent */
 	char			wasdel;	/* replacing a delayed allocation */
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index e73c332..e9df995 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -1883,7 +1883,7 @@ xfs_btree_lshift(
 
 	/*
 	 * We add one entry to the left side and remove one for the right side.
-	 * Accout for it here, the changes will be updated on disk and logged
+	 * Account for it here, the changes will be updated on disk and logged
 	 * later.
 	 */
 	lrecs++;
@@ -3535,7 +3535,7 @@ xfs_btree_delrec(
 	XFS_BTREE_STATS_INC(cur, join);
 
 	/*
-	 * Fix up the the number of records and right block pointer in the
+	 * Fix up the number of records and right block pointer in the
 	 * surviving block, and log it.
 	 */
 	xfs_btree_set_numrecs(left, lrecs + rrecs);
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index 789fffd..4f852b7 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -41,7 +41,7 @@ extern kmem_zone_t	*xfs_btree_cur_zone;
 /*
  * Generic btree header.
  *
- * This is a comination of the actual format used on disk for short and long
+ * This is a combination of the actual format used on disk for short and long
  * format btrees.  The first three fields are shared by both format, but
  * the pointers are different and should be used with care.
  *
diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 9d5a7e8..fd63f3c 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -185,7 +185,7 @@ typedef struct xfs_da_state {
 	unsigned char		inleaf;		/* insert into 1->lf, 0->splf */
 	unsigned char		extravalid;	/* T/F: extrablk is in use */
 	unsigned char		extraafter;	/* T/F: extrablk is after new */
-	xfs_da_state_blk_t	extrablk;	/* for double-splits on leafs */
+	xfs_da_state_blk_t	extrablk;	/* for double-splits on leaves */
 						/* for dirv2 extrablk is data */
 } xfs_da_state_t;
 
diff --git a/fs/xfs/xfs_dir2_data.h b/fs/xfs/xfs_dir2_data.h
index b816e02..efbc290 100644
--- a/fs/xfs/xfs_dir2_data.h
+++ b/fs/xfs/xfs_dir2_data.h
@@ -38,7 +38,7 @@ struct xfs_trans;
 
 /*
  * Directory address space divided into sections,
- * spaces separated by 32gb.
+ * spaces separated by 32GB.
  */
 #define	XFS_DIR2_SPACE_SIZE	(1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
 #define	XFS_DIR2_DATA_SPACE	0
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index fa6c3a5..5a81ccd 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1104,7 +1104,7 @@ xfs_dir2_leafn_remove(
 	}
 	xfs_dir2_leafn_check(dp, bp);
 	/*
-	 * Return indication of whether this leaf block is emtpy enough
+	 * Return indication of whether this leaf block is empty enough
 	 * to justify trying to join it with a neighbor.
 	 */
 	*rval =
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 680d0e0..8379e3b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -576,7 +576,7 @@ out:
 	if (fdblks_delta) {
 		/*
 		 * If we are putting blocks back here, m_resblks_avail is
-		 * already at it's max so this will put it in the free pool.
+		 * already at its max so this will put it in the free pool.
 		 *
 		 * If we need space, we'll either succeed in getting it
 		 * from the free block count or we'll get an enospc. If
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 62d1cea..3120a3a 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -349,7 +349,7 @@ xfs_ialloc_ag_alloc(
 		 * Initialize all inodes in this buffer and then log them.
 		 *
 		 * XXX: It would be much better if we had just one transaction to
-		 *      log a whole cluster of inodes instead of all the indivdual
+		 *      log a whole cluster of inodes instead of all the individual
 		 *      transactions causing a lot of log traffic.
 		 */
 		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index 99f2408..c282a9a 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -164,7 +164,7 @@ xfs_inobt_init_rec_from_cur(
 }
 
 /*
- * intial value of ptr for lookup
+ * initial value of ptr for lookup
  */
 STATIC void
 xfs_inobt_init_ptr_from_cur(
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1f175fa..f879c1b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -122,7 +122,7 @@ typedef struct xfs_ictimestamp {
 
 /*
  * NOTE:  This structure must be kept identical to struct xfs_dinode
- * 	  in xfs_dinode.h except for the endianess annotations.
+ * 	  in xfs_dinode.h except for the endianness annotations.
  */
 typedef struct xfs_icdinode {
 	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index ee1a0c1..a1cc132 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -63,7 +63,7 @@ typedef enum {
  */
 
 typedef struct xfs_iomap {
-	xfs_daddr_t		iomap_bn;	/* first 512b blk of mapping */
+	xfs_daddr_t		iomap_bn;	/* first 512B blk of mapping */
 	xfs_buftarg_t		*iomap_target;
 	xfs_off_t		iomap_offset;	/* offset of mapping, bytes */
 	xfs_off_t		iomap_bsize;	/* size of mapping, bytes */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index cf98a80..808799d 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -579,7 +579,7 @@ xfs_bulkstat(
 				 * first inode of the cluster.
 				 *
 				 * Careful with clustidx.   There can be
-				 * multple clusters per chunk, a single
+				 * multiple clusters per chunk, a single
 				 * cluster per chunk or a cluster that has
 				 * inodes represented from several different
 				 * chunks (if blocksize is large).
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c8f3008..2f1b518 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1111,7 +1111,7 @@ xlog_bdstrat_cb(struct xfs_buf *bp)
 /*
  * Return size of each in-core log record buffer.
  *
- * All machines get 8 x 32KB buffers by default, unless tuned otherwise.
+ * All machines get 8 x 32kB buffers by default, unless tuned otherwise.
  *
  * If the filesystem blocksize is too large, we may need to choose a
  * larger size since the directory code currently logs entire blocks.
@@ -1141,8 +1141,8 @@ xlog_get_iclog_buffer_size(xfs_mount_t	*mp,
 		}
 
 		if (xfs_sb_version_haslogv2(&mp->m_sb)) {
-			/* # headers = size / 32K
-			 * one header holds cycles from 32K of data
+			/* # headers = size / 32k
+			 * one header holds cycles from 32k of data
 			 */
 
 			xhdrs = mp->m_logbsize / XLOG_HEADER_CYCLE_SIZE;
@@ -1158,7 +1158,7 @@ xlog_get_iclog_buffer_size(xfs_mount_t	*mp,
 		goto done;
 	}
 
-	/* All machines use 32KB buffers by default. */
+	/* All machines use 32kB buffers by default. */
 	log->l_iclog_size = XLOG_BIG_RECORD_BSIZE;
 	log->l_iclog_size_log = XLOG_BIG_RECORD_BSHIFT;
 
@@ -3192,7 +3192,7 @@ xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
  */
 
 /*
- * Free a used ticket when it's refcount falls to zero.
+ * Free a used ticket when its refcount falls to zero.
  */
 void
 xfs_log_ticket_put(
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 664961e..b31a520 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -645,7 +645,7 @@ xfs_initialize_perag_data(xfs_mount_t *mp, xfs_agnumber_t agcount)
 	for (index = 0; index < agcount; index++) {
 		/*
 		 * read the agf, then the agi. This gets us
-		 * all the inforamtion we need and populates the
+		 * all the information we need and populates the
 		 * per-ag structures for us.
 		 */
 		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
@@ -1226,7 +1226,7 @@ xfs_unmountfs(
 
 	/*
 	 * We can potentially deadlock here if we have an inode cluster
-	 * that has been freed has it's buffer still pinned in memory because
+	 * that has been freed has its buffer still pinned in memory because
 	 * the transaction is still sitting in a iclog. The stale inodes
 	 * on that buffer will have their flush locks held until the
 	 * transaction hits the disk and the callbacks run. the inode
@@ -1258,7 +1258,7 @@ xfs_unmountfs(
 	 * Unreserve any blocks we have so that when we unmount we don't account
 	 * the reserved free space as used. This is really only necessary for
 	 * lazy superblock counting because it trusts the incore superblock
-	 * counters to be aboslutely correct on clean unmount.
+	 * counters to be absolutely correct on clean unmount.
 	 *
 	 * We don't bother correcting this elsewhere for lazy superblock
 	 * counting because on mount of an unclean filesystem we reconstruct the
@@ -1860,7 +1860,7 @@ xfs_mount_log_sb(
  * we disable the per-cpu counter and go through the slow path.
  *
  * The slow path is the current xfs_mod_incore_sb() function.  This means that
- * when we disable a per-cpu counter, we need to drain it's resources back to
+ * when we disable a per-cpu counter, we need to drain its resources back to
  * the global superblock. We do this after disabling the counter to prevent
  * more threads from queueing up on the counter.
  *
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1438dd4..0ceecb2 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -385,8 +385,8 @@ typedef struct xfs_mount {
  * Synchronous read and write sizes.  This should be
  * better for NFSv2 wsync filesystems.
  */
-#define	XFS_WSYNC_READIO_LOG	15	/* 32K */
-#define	XFS_WSYNC_WRITEIO_LOG	14	/* 16K */
+#define	XFS_WSYNC_READIO_LOG	15	/* 32k */
+#define	XFS_WSYNC_WRITEIO_LOG	14	/* 16k */
 
 /*
  * Allow large block sizes to be reported to userspace programs if the
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 3bac681..b2d67ad 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -23,8 +23,8 @@ struct xfs_trans;
 
 /* Min and max rt extent sizes, specified in bytes */
 #define	XFS_MAX_RTEXTSIZE	(1024 * 1024 * 1024)	/* 1GB */
-#define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64KB */
-#define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4KB */
+#define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
+#define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
 
 /*
  * Constants for bit manipulations.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 166f728..775249a 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -292,7 +292,7 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
  * In a write transaction we can allocate a maximum of 2
  * extents.  This gives:
  *    the inode getting the new extents: inode size
- *    the inode\'s bmap btree: max depth * block size
+ *    the inode's bmap btree: max depth * block size
  *    the agfs of the ags from which the extents are allocated: 2 * sector
  *    the superblock free block counter: sector size
  *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
@@ -321,7 +321,7 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
 /*
  * In truncating a file we free up to two extents at once.  We can modify:
  *    the inode being truncated: inode size
- *    the inode\'s bmap btree: (max depth + 1) * block size
+ *    the inode's bmap btree: (max depth + 1) * block size
  * And the bmap_finish transaction can free the blocks and bmap blocks:
  *    the agf for each of the ags: 4 * sector size
  *    the agfl for each of the ags: 4 * sector size
@@ -431,8 +431,8 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
  *    the new inode: inode size
  *    the inode btree entry: 1 block
  *    the directory btree: (max depth + v2) * dir block size
- *    the directory inode\'s bmap btree: (max depth + v2) * block size
- *    the blocks for the symlink: 1 KB
+ *    the directory inode's bmap btree: (max depth + v2) * block size
+ *    the blocks for the symlink: 1 kB
  * Or in the first xact we allocate some inodes giving:
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
  *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
@@ -463,7 +463,7 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
  *    the inode btree entry: block size
  *    the superblock for the nlink flag: sector size
  *    the directory btree: (max depth + v2) * dir block size
- *    the directory inode\'s bmap btree: (max depth + v2) * block size
+ *    the directory inode's bmap btree: (max depth + v2) * block size
  * Or in the first xact we allocate some inodes giving:
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
  *    the superblock for the nlink flag: sector size
@@ -637,7 +637,7 @@ xfs_lic_desc_to_chunk(xfs_log_item_desc_t *dp)
 /*
  * Removing the attribute fork of a file
  *    the inode being truncated: inode size
- *    the inode\'s bmap btree: max depth * block size
+ *    the inode's bmap btree: max depth * block size
  * And the bmap_finish transaction can free the blocks and bmap blocks:
  *    the agf for each of the ags: 4 * sector size
  *    the agfl for each of the ags: 4 * sector size
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 2d47f10..f31271c 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -79,7 +79,7 @@ xfs_trans_ail_tail(
  * the push is run asynchronously in a separate thread, so we return the tail
  * of the log right now instead of the tail after the push. This means we will
  * either continue right away, or we will sleep waiting on the async thread to
- * do it's work.
+ * do its work.
  *
  * We do this unlocked - we only need to know whether there is anything in the
  * AIL at the time we are called. We don't need to access the contents of
@@ -160,7 +160,7 @@ xfs_trans_ail_cursor_next(
 /*
  * Now that the traversal is complete, we need to remove the cursor
  * from the list of traversing cursors. Avoid removing the embedded
- * push cursor, but use the fact it is alway present to make the
+ * push cursor, but use the fact it is always present to make the
  * list deletion simple.
  */
 void
diff --git a/fs/xfs/xfs_trans_item.c b/fs/xfs/xfs_trans_item.c
index e110bf5..eb3fc57 100644
--- a/fs/xfs/xfs_trans_item.c
+++ b/fs/xfs/xfs_trans_item.c
@@ -22,7 +22,7 @@
 #include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
-/* XXX: from here down needed until struct xfs_trans has it's own ailp */
+/* XXX: from here down needed until struct xfs_trans has its own ailp */
 #include "xfs_bit.h"
 #include "xfs_buf_item.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
index fcc2285..79b9e5e 100644
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -374,7 +374,7 @@ xfs_truncate_file(
 
 	/*
 	 * Follow the normal truncate locking protocol.  Since we
-	 * hold the inode in the transaction, we know that it's number
+	 * hold the inode in the transaction, we know that its number
 	 * of references will stay constant.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 59de049..fa935ff 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2862,7 +2862,7 @@ xfs_free_file_space(
 
 	/*
 	 * Need to zero the stuff we're not freeing, on disk.
-	 * If its a realtime file & can't use unwritten extents then we
+	 * If it's a realtime file & can't use unwritten extents then we
 	 * actually need to zero the extent edges.  Otherwise xfs_bunmapi
 	 * will take care of it for us.
 	 */
-- 
1.5.6.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
