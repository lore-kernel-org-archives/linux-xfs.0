Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 46A047F37
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 01:39:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1FAD18F8035
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 23:39:08 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WIqvx0xZcopehx9p for <xfs@oss.sgi.com>;
	Mon, 22 Apr 2013 23:39:06 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UUWsU-0004LD-68
	for xfs@oss.sgi.com; Tue, 23 Apr 2013 16:38:58 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UUWsU-0006GX-34
	for xfs@oss.sgi.com; Tue, 23 Apr 2013 16:38:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: introduce CONFIG_XFS_WARN
Date: Tue, 23 Apr 2013 16:38:58 +1000
Message-Id: <1366699138-24055-1-git-send-email-david@fromorbit.com>
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

Running a CONFIG_XFS_DEBUG kernel in production environments is not
the best idea as it introduces significant overhead, can change
the behaviour of algorithms (such as allocation) to improve test
coverage, and (most importantly) panic the machine on non-fatal
errors.

There are many cases where all we want to do is run a
kernel with more bounds checking enabled, such as is provided by the
ASSERT() statements throughout the code, but without all the
potential overhead and drawbacks.

This patch converts all the ASSERT statements to evaluate as
WARN_ON(1) statements and hence if they fail dump a warning and a
stack trace to the log. This has minimal overhead and does not
change any algorithms, and will allow us to find strange "out of
bounds" problems more easily on production machines.

There are a few places where assert statements contain debug only
code. These are converted to be debug-or-warn only code so that we
still get all the assert checks in the code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Kconfig            |   13 +++++++++++++
 fs/xfs/mrlock.h           |   12 ++++++------
 fs/xfs/xfs.h              |    5 +++++
 fs/xfs/xfs_alloc_btree.c  |    4 ++--
 fs/xfs/xfs_bmap_btree.c   |    4 ++--
 fs/xfs/xfs_btree.h        |    2 +-
 fs/xfs/xfs_dir2_node.c    |    4 ++--
 fs/xfs/xfs_ialloc_btree.c |    4 ++--
 fs/xfs/xfs_inode.c        |    2 +-
 fs/xfs/xfs_linux.h        |   24 ++++++++++++++++++------
 fs/xfs/xfs_message.c      |    8 ++++++++
 fs/xfs/xfs_message.h      |    1 +
 fs/xfs/xfs_trans.h        |    2 +-
 13 files changed, 62 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index cc33aaf..399e8ce 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -69,6 +69,19 @@ config XFS_RT
 
 	  If unsure, say N.
 
+config XFS_WARN
+	bool "XFS Verbose Warnings"
+	depends on XFS_FS && !XFS_DEBUG
+	help
+	  Say Y here to get an XFS build with many additional warnings.
+	  It converts ASSERT checks to WARN, so will log any out-of-bounds
+	  conditions that occur that would otherwise be missed. It is much
+	  lighter weight than XFS_DEBUG and does not modify algorithms and will
+	  not cause the kernel to panic on non-fatal errors.
+
+	  However, similar to XFS_DEBUG, it is only advisable to use this if you
+	  are debugging a particular problem.
+
 config XFS_DEBUG
 	bool "XFS Debugging support"
 	depends on XFS_FS
diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
index ff6a198..e3c92d1 100644
--- a/fs/xfs/mrlock.h
+++ b/fs/xfs/mrlock.h
@@ -22,12 +22,12 @@
 
 typedef struct {
 	struct rw_semaphore	mr_lock;
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	int			mr_writer;
 #endif
 } mrlock_t;
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 #define mrinit(mrp, name)	\
 	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
 #else
@@ -46,7 +46,7 @@ static inline void mraccess_nested(mrlock_t *mrp, int subclass)
 static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
 {
 	down_write_nested(&mrp->mr_lock, subclass);
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	mrp->mr_writer = 1;
 #endif
 }
@@ -60,7 +60,7 @@ static inline int mrtryupdate(mrlock_t *mrp)
 {
 	if (!down_write_trylock(&mrp->mr_lock))
 		return 0;
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	mrp->mr_writer = 1;
 #endif
 	return 1;
@@ -68,7 +68,7 @@ static inline int mrtryupdate(mrlock_t *mrp)
 
 static inline void mrunlock_excl(mrlock_t *mrp)
 {
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	mrp->mr_writer = 0;
 #endif
 	up_write(&mrp->mr_lock);
@@ -81,7 +81,7 @@ static inline void mrunlock_shared(mrlock_t *mrp)
 
 static inline void mrdemote(mrlock_t *mrp)
 {
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	mrp->mr_writer = 0;
 #endif
 	downgrade_write(&mrp->mr_lock);
diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index d8b11b7..a742c47 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -24,6 +24,11 @@
 #define XFS_BUF_LOCK_TRACKING 1
 #endif
 
+#ifdef CONFIG_XFS_WARN
+#define XFS_WARN 1
+#endif
+
+
 #include "xfs_linux.h"
 
 #endif	/* __XFS_H__ */
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index b1ddef6..cbcd34b 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -348,7 +348,7 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 };
 
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_allocbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -404,7 +404,7 @@ static const struct xfs_btree_ops xfs_allocbt_ops = {
 	.init_ptr_from_cur	= xfs_allocbt_init_ptr_from_cur,
 	.key_diff		= xfs_allocbt_key_diff,
 	.buf_ops		= &xfs_allocbt_buf_ops,
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_allocbt_keys_inorder,
 	.recs_inorder		= xfs_allocbt_recs_inorder,
 #endif
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 061b45c..5eaaa4b 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -769,7 +769,7 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 };
 
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_bmbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -809,7 +809,7 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
 	.buf_ops		= &xfs_bmbt_buf_ops,
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
 #endif
diff --git a/fs/xfs/xfs_btree.h b/fs/xfs/xfs_btree.h
index f932897..6302e9a 100644
--- a/fs/xfs/xfs_btree.h
+++ b/fs/xfs/xfs_btree.h
@@ -190,7 +190,7 @@ struct xfs_btree_ops {
 
 	const struct xfs_buf_ops	*buf_ops;
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	/* check that k1 is lower than k2 */
 	int	(*keys_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_key *k1,
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 5980f9b..33177c3 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -811,7 +811,7 @@ xfs_dir2_leafn_rebalance(
 	xfs_dir2_leaf_t		*leaf1;		/* first leaf structure */
 	xfs_dir2_leaf_t		*leaf2;		/* second leaf structure */
 	int			mid;		/* midpoint leaf index */
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	int			oldstale;	/* old count of stale leaves */
 #endif
 	int			oldsum;		/* old total leaf count */
@@ -831,7 +831,7 @@ xfs_dir2_leafn_rebalance(
 	leaf1 = blk1->bp->b_addr;
 	leaf2 = blk2->bp->b_addr;
 	oldsum = be16_to_cpu(leaf1->hdr.count) + be16_to_cpu(leaf2->hdr.count);
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	oldstale = be16_to_cpu(leaf1->hdr.stale) + be16_to_cpu(leaf2->hdr.stale);
 #endif
 	mid = oldsum >> 1;
diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
index bec344b..7b9c7be 100644
--- a/fs/xfs/xfs_ialloc_btree.c
+++ b/fs/xfs/xfs_ialloc_btree.c
@@ -235,7 +235,7 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.verify_write = xfs_inobt_write_verify,
 };
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_inobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -273,7 +273,7 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_inobt_buf_ops,
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
 #endif
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4f20165..4630d47 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -286,7 +286,7 @@ xfs_ilock_demote(
 	trace_xfs_ilock_demote(ip, lock_flags, _RET_IP_);
 }
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 int
 xfs_isilocked(
 	xfs_inode_t		*ip,
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 14e59d9..800f896 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -293,22 +293,34 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
 #define ASSERT_ALWAYS(expr)	\
 	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
-#ifndef DEBUG
-#define ASSERT(expr)	((void)0)
+#ifdef DEBUG
+#define ASSERT(expr)	\
+	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
 #ifndef STATIC
-# define STATIC static noinline
+# define STATIC noinline
 #endif
 
-#else /* DEBUG */
+#else	/* !DEBUG */
+
+#ifdef XFS_WARN
 
 #define ASSERT(expr)	\
-	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+	(unlikely(expr) ? (void)0 : asswarn(#expr, __FILE__, __LINE__))
 
 #ifndef STATIC
-# define STATIC noinline
+# define STATIC static noinline
+#endif
+
+#else	/* !DEBUG && !XFS_WARN */
+
+#define ASSERT(expr)	((void)0)
+
+#ifndef STATIC
+# define STATIC static noinline
 #endif
 
+#endif /* XFS_WARN */
 #endif /* DEBUG */
 
 #endif /* __XFS_LINUX__ */
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 331cd9f..9163dc1 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -93,6 +93,14 @@ xfs_alert_tag(
 }
 
 void
+asswarn(char *expr, char *file, int line)
+{
+	xfs_warn(NULL, "Assertion failed: %s, file: %s, line: %d",
+		expr, file, line);
+	WARN_ON(1);
+}
+
+void
 assfail(char *expr, char *file, int line)
 {
 	xfs_emerg(NULL, "Assertion failed: %s, file: %s, line: %d",
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 76c8198..8540115 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -57,6 +57,7 @@ do {									\
 	xfs_printk_ratelimited(xfs_debug, dev, fmt, ##__VA_ARGS__)
 
 extern void assfail(char *expr, char *f, int l);
+extern void asswarn(char *expr, char *f, int l);
 
 extern void xfs_hex_dump(void *p, int length);
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index cd29f61..d3e0679 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -405,7 +405,7 @@ typedef struct xfs_trans {
 	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
 	int64_t			t_frextents_delta;/* superblock freextents chg*/
 	int64_t			t_res_frextents_delta; /* on-disk only chg */
-#ifdef DEBUG
+#if defined(DEBUG) || defined(XFS_WARN)
 	int64_t			t_ag_freeblks_delta; /* debugging counter */
 	int64_t			t_ag_flist_delta; /* debugging counter */
 	int64_t			t_ag_btree_delta; /* debugging counter */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
