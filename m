Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E74047FB7
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E31B18F8037
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	p1amCXzNtWW75pua for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4y-0003DA-Sf
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:12 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4o-0000Gh-OY
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 41/50] xfs: make struct xfs_perag kernel only
Date: Wed, 19 Jun 2013 15:36:04 +1000
Message-Id: <1371620173-712-42-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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

The struct xfs_perag has many kernel-only definitions in it,
requiring a __KERNEL__ guard so userspace can use it to. Move it to
xfs_mount.h so that it it kernel-only, and let userspace redefine
it's own version of the structure containing only what it needs.
This gets rid of another __KERNEL__ check in the XFS header files.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/libxfs.h |   31 +++++++++++++++++++++++++++++++
 include/xfs_ag.h |   53 -----------------------------------------------------
 2 files changed, 31 insertions(+), 53 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index c09ccad..4fb1762 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -217,6 +217,37 @@ typedef struct xfs_mount {
 	xfs_dablk_t		m_dirfreeblk;	/* blockno of dirfreeindex v2 */
 } xfs_mount_t;
 
+/*
+ * Per-ag incore structure, copies of information in agf and agi,
+ * to improve the performance of allocation group selection.
+ */
+typedef struct xfs_perag {
+	struct xfs_mount *pag_mount;	/* owner filesystem */
+	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
+	atomic_t	pag_ref;	/* perag reference count */
+	char		pagf_init;	/* this agf's entry is initialized */
+	char		pagi_init;	/* this agi's entry is initialized */
+	char		pagf_metadata;	/* the agf is preferred to be metadata */
+	char		pagi_inodeok;	/* The agi is ok for inodes */
+	__uint8_t	pagf_levels[XFS_BTNUM_AGF];
+					/* # of levels in bno & cnt btree */
+	__uint32_t	pagf_flcount;	/* count of blocks in freelist */
+	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
+	xfs_extlen_t	pagf_longest;	/* longest free space */
+	__uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
+	xfs_agino_t	pagi_freecount;	/* number of free inodes */
+	xfs_agino_t	pagi_count;	/* number of allocated inodes */
+
+	/*
+	 * Inode allocation search lookup optimisation.
+	 * If the pagino matches, the search for new inodes
+	 * doesn't need to search the near ones again straight away
+	 */
+	xfs_agino_t	pagl_pagino;
+	xfs_agino_t	pagl_leftrec;
+	xfs_agino_t	pagl_rightrec;
+	int		pagb_count;	/* pagb slots in use */
+} xfs_perag_t;
 
 #define LIBXFS_MOUNT_ROOTINOS		0x0001
 #define LIBXFS_MOUNT_DEBUGGER		0x0002
diff --git a/include/xfs_ag.h b/include/xfs_ag.h
index 317aa86..1cb740a 100644
--- a/include/xfs_ag.h
+++ b/include/xfs_ag.h
@@ -227,59 +227,6 @@ typedef struct xfs_agfl {
 } xfs_agfl_t;
 
 /*
- * Per-ag incore structure, copies of information in agf and agi,
- * to improve the performance of allocation group selection.
- */
-#define XFS_PAGB_NUM_SLOTS	128
-
-typedef struct xfs_perag {
-	struct xfs_mount *pag_mount;	/* owner filesystem */
-	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
-	atomic_t	pag_ref;	/* perag reference count */
-	char		pagf_init;	/* this agf's entry is initialized */
-	char		pagi_init;	/* this agi's entry is initialized */
-	char		pagf_metadata;	/* the agf is preferred to be metadata */
-	char		pagi_inodeok;	/* The agi is ok for inodes */
-	__uint8_t	pagf_levels[XFS_BTNUM_AGF];
-					/* # of levels in bno & cnt btree */
-	__uint32_t	pagf_flcount;	/* count of blocks in freelist */
-	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
-	xfs_extlen_t	pagf_longest;	/* longest free space */
-	__uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
-	xfs_agino_t	pagi_freecount;	/* number of free inodes */
-	xfs_agino_t	pagi_count;	/* number of allocated inodes */
-
-	/*
-	 * Inode allocation search lookup optimisation.
-	 * If the pagino matches, the search for new inodes
-	 * doesn't need to search the near ones again straight away
-	 */
-	xfs_agino_t	pagl_pagino;
-	xfs_agino_t	pagl_leftrec;
-	xfs_agino_t	pagl_rightrec;
-#ifdef __KERNEL__
-	spinlock_t	pagb_lock;	/* lock for pagb_tree */
-	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
-
-	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
-
-	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
-	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
-	int		pag_ici_reclaimable;	/* reclaimable inodes */
-	struct mutex	pag_ici_reclaim_lock;	/* serialisation point */
-	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
-
-	/* buffer cache index */
-	spinlock_t	pag_buf_lock;	/* lock for pag_buf_tree */
-	struct rb_root	pag_buf_tree;	/* ordered tree of active buffers */
-
-	/* for rcu-safe freeing */
-	struct rcu_head	rcu_head;
-#endif
-	int		pagb_count;	/* pagb slots in use */
-} xfs_perag_t;
-
-/*
  * tags for inode radix tree
  */
 #define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
