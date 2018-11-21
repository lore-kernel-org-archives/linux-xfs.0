Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4351 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390436AbeKVJgf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 04:36:35 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gPbTV-0003nk-G6
        for linux-xfs@vger.kernel.org; Thu, 22 Nov 2018 10:00:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gPbTV-0008FL-F5
        for linux-xfs@vger.kernel.org; Thu, 22 Nov 2018 10:00:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: remove xfs_lookup_t enum because tracing
Date: Thu, 22 Nov 2018 09:59:57 +1100
Message-Id: <20181121225958.30947-3-david@fromorbit.com>
In-Reply-To: <20181121225958.30947-1-david@fromorbit.com>
References: <20181121225958.30947-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

__print_symbolic does crazy things and stringifies the tables
that are used to map values to strings. Hence if we use enums
for the values, it just doesn't work because XFS_LOOKUP_EQi != 0,
it's a string.

Convert to macros and remove the xfs_lookup_t enum as it's not
useful anymore.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.c  | 2 +-
 fs/xfs/libxfs/xfs_btree.h  | 8 ++++----
 fs/xfs/libxfs/xfs_ialloc.c | 2 +-
 fs/xfs/libxfs/xfs_ialloc.h | 2 +-
 fs/xfs/libxfs/xfs_types.h  | 4 ----
 fs/xfs/xfs_trace.h         | 6 +++---
 6 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 34c6d7bd4d18..85b70893781c 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1864,7 +1864,7 @@ xfs_lookup_get_search_key(
 int					/* error */
 xfs_btree_lookup(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
-	xfs_lookup_t		dir,	/* <=, ==, or >= */
+	unsigned		dir,	/* <=, ==, or >= */
 	int			*stat)	/* success/failure */
 {
 	struct xfs_btree_block	*block;	/* current btree block */
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index e3b3e9dce5da..802088f48ef4 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -51,9 +51,9 @@ union xfs_btree_rec {
 /*
  * This nonsense is to make -wlint happy.
  */
-#define	XFS_LOOKUP_EQ	((xfs_lookup_t)XFS_LOOKUP_EQi)
-#define	XFS_LOOKUP_LE	((xfs_lookup_t)XFS_LOOKUP_LEi)
-#define	XFS_LOOKUP_GE	((xfs_lookup_t)XFS_LOOKUP_GEi)
+#define	XFS_LOOKUP_EQ	0
+#define	XFS_LOOKUP_LE	1
+#define	XFS_LOOKUP_GE	2
 
 #define	XFS_BTNUM_BNO	((xfs_btnum_t)XFS_BTNUM_BNOi)
 #define	XFS_BTNUM_CNT	((xfs_btnum_t)XFS_BTNUM_CNTi)
@@ -402,7 +402,7 @@ xfs_btree_init_block_int(
  */
 int xfs_btree_increment(struct xfs_btree_cur *, int, int *);
 int xfs_btree_decrement(struct xfs_btree_cur *, int, int *);
-int xfs_btree_lookup(struct xfs_btree_cur *, xfs_lookup_t, int *);
+int xfs_btree_lookup(struct xfs_btree_cur *, unsigned, int *);
 int xfs_btree_update(struct xfs_btree_cur *, union xfs_btree_rec *);
 int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
 int xfs_btree_insert(struct xfs_btree_cur *, int *);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a8f6db735d5d..5555fb64b7bf 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -52,7 +52,7 @@ int					/* error */
 xfs_inobt_lookup(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agino_t		ino,	/* starting inode of chunk */
-	xfs_lookup_t		dir,	/* <=, >=, == */
+	unsigned		dir,	/* <=, >=, == */
 	int			*stat)	/* success/failure */
 {
 	cur->bc_rec.i.ir_startino = ino;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index e936b7cc9389..f0557038297f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -135,7 +135,7 @@ xfs_ialloc_pagi_init(
  * Lookup a record by ino in the btree given by cur.
  */
 int xfs_inobt_lookup(struct xfs_btree_cur *cur, xfs_agino_t ino,
-		xfs_lookup_t dir, int *stat);
+		unsigned dir, int *stat);
 
 /*
  * Get the data from the pointed-to record.
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b9e6c89284c3..a73cd80c2439 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -100,10 +100,6 @@ typedef void *		xfs_failaddr_t;
  */
 #define MAXNAMELEN	256
 
-typedef enum {
-	XFS_LOOKUP_EQi, XFS_LOOKUP_LEi, XFS_LOOKUP_GEi
-} xfs_lookup_t;
-
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8a6532aae779..145412e91a70 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2616,13 +2616,13 @@ DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 	{ XFS_LOOKUP_GE,	"ge" }
 DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_lookup_t dir),
+		 xfs_agblock_t agbno, unsigned dir),
 	TP_ARGS(mp, agno, agbno, dir),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
-		__field(xfs_lookup_t, dir)
+		__field(unsigned, dir)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
@@ -2641,7 +2641,7 @@ DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
 #define DEFINE_AG_BTREE_LOOKUP_EVENT(name) \
 DEFINE_EVENT(xfs_ag_btree_lookup_class, name, \
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_lookup_t dir), \
+		 xfs_agblock_t agbno, unsigned dir), \
 	TP_ARGS(mp, agno, agbno, dir))
 
 /* single-rcext tracepoint class */
-- 
2.19.1
