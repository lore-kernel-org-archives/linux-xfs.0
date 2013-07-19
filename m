Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27CCC7F8D
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:26:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 17BFE8F8033
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:26:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0AqkSYpVy34Ksc4b for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:26:00 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-000489-8K
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-0001zM-6S
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 34/49] xfs: make struct xfs_perag kernel only
Date: Fri, 19 Jul 2013 16:25:05 +1000
Message-Id: <1374215120-7271-35-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_acl.c            |  1 +
 fs/xfs/xfs_ag.h             | 53 ---------------------------------------------
 fs/xfs/xfs_mount.h          | 52 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_symlink_remote.c |  1 +
 4 files changed, 54 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 0c4368a..2f77db8 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -22,6 +22,7 @@
 #include "xfs_attr.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
+#include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_trace.h"
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
index 5488df1..829035f6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -320,6 +320,58 @@ typedef struct xfs_mod_sb {
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
index a318524..01c85e3 100644
--- a/fs/xfs/xfs_symlink_remote.c
+++ b/fs/xfs/xfs_symlink_remote.c
@@ -21,6 +21,7 @@
 #include "xfs_format.h"
 #include "xfs_log.h"
 #include "xfs_trans.h"
+#include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_bmap_btree.h"
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
