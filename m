Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5F13629E12
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E190DAC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:45 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wlbG63fLdZWof1n7 for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:43 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpANr-00030w-Sf
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:39 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANq-00007R-UC
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 49/60] xfs: make struct xfs_perag kernel only
Date: Wed, 19 Jun 2013 14:50:57 +1000
Message-Id: <1371617468-32559-50-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_acl.c            |    1 +
 fs/xfs/xfs_ag.h             |   53 -------------------------------------------
 fs/xfs/xfs_mount.h          |   52 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_symlink_remote.c |    1 +
 4 files changed, 54 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index b9b9740..1ec23d0 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -20,6 +20,7 @@
 #include "xfs_attr.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
+#include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 317aa86..1cb740a 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
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
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e3acebd..7a45a75 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -322,6 +322,58 @@ typedef struct xfs_mod_sb {
 	int64_t		msb_delta;	/* Change to make to specified field */
 } xfs_mod_sb_t;
 
+/*
+ * Per-ag incore structure, copies of information in agf and agi, to improve the
+ * performance of allocation group selection. This is defined for the kernel
+ * only, and hence is defined here instead of in xfs_ag.h. You need the struct
+ * xfs_mount to be defined to look up a xfs_perag anyway (via mp->m_perag_tree),
+ * so this doesn't introduce any strange header file dependencies.
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
+	spinlock_t	pagb_lock;	/* lock for pagb_tree */
+	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
+
+	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
+
+	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
+	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
+	int		pag_ici_reclaimable;	/* reclaimable inodes */
+	struct mutex	pag_ici_reclaim_lock;	/* serialisation point */
+	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
+
+	/* buffer cache index */
+	spinlock_t	pag_buf_lock;	/* lock for pag_buf_tree */
+	struct rb_root	pag_buf_tree;	/* ordered tree of active buffers */
+
+	/* for rcu-safe freeing */
+	struct rcu_head	rcu_head;
+	int		pagb_count;	/* pagb slots in use */
+} xfs_perag_t;
+
 extern int	xfs_log_sbcount(xfs_mount_t *);
 extern __uint64_t xfs_default_resblks(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp);
diff --git a/fs/xfs/xfs_symlink_remote.c b/fs/xfs/xfs_symlink_remote.c
index a369025..a6ea18f 100644
--- a/fs/xfs/xfs_symlink_remote.c
+++ b/fs/xfs/xfs_symlink_remote.c
@@ -20,6 +20,7 @@
 #include "xfs_fs.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
+#include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
