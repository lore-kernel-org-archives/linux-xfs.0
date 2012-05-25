Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4P7Ip5G044190 for <xfs@oss.sgi.com>; Fri, 25 May 2012 02:18:51 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id jhyQcahwjCvnZNiR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 00:18:49 -0700 (PDT)
From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 5/6] build: use standard type uintptr_t
Date: Fri, 25 May 2012 09:18:42 +0200
Message-Id: <1337930323-575-6-git-send-email-jengelh@inai.de>
In-Reply-To: <1337930323-575-1-git-send-email-jengelh@inai.de>
References: <1337930323-575-1-git-send-email-jengelh@inai.de>
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
Cc: jengelh@inai.de

Same as prior commit, but for __psunsigned_t.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/platform_defs.h.in |   18 ------------------
 include/xfs_btree.h        |   12 ++++++------
 libxfs/xfs_alloc_btree.c   |   22 +++++++++++-----------
 libxfs/xfs_bmap_btree.c    |   22 +++++++++++-----------
 libxfs/xfs_ialloc_btree.c  |   22 +++++++++++-----------
 repair/avl.c               |   36 ++++++++++++++++++------------------
 repair/avl.h               |   18 +++++++++---------
 repair/incore_ext.c        |   27 +++++++++++++--------------
 repair/incore_ino.c        |   10 +++++-----
 9 files changed, 84 insertions(+), 103 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index d05e492..9101cca 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -84,24 +84,6 @@ typedef struct filldir		filldir_t;
 
 #undef HAVE_INTPTR_T
 
-/* Check if __psunsigned_t is set to something meaningful */
-#undef HAVE___PSUNSIGNED_T
-#ifndef HAVE___PSUNSIGNED_T
-# if (SIZEOF_CHAR_P * CHAR_BIT) == 32
-typedef unsigned int __psunsigned_t;
-# elif (SIZEOF_CHAR_P * CHAR_BIT) == 64
-#  if BITS_PER_LONG == 64
-typedef long __psunsigned_t;
-#  else
-/* This is a very strange architecture, which has 64 bit pointers but */
-/* not 64 bit longs.  So, just punt here and assume long long is OK.  */
-typedef unsigned long long __psunsigned_t;
-#  endif
-# else
-#  error Unknown pointer size
-# endif
-#endif
-
 /* Define if you want gettext (I18N) support */
 #undef ENABLE_GETTEXT
 #ifdef ENABLE_GETTEXT
diff --git a/include/xfs_btree.h b/include/xfs_btree.h
index 82fafc6..43b1641 100644
--- a/include/xfs_btree.h
+++ b/include/xfs_btree.h
@@ -203,12 +203,12 @@ struct xfs_btree_ops {
 	/* btree tracing */
 #ifdef XFS_BTREE_TRACE
 	void		(*trace_enter)(struct xfs_btree_cur *, const char *,
-				       char *, int, int, __psunsigned_t,
-				       __psunsigned_t, __psunsigned_t,
-				       __psunsigned_t, __psunsigned_t,
-				       __psunsigned_t, __psunsigned_t,
-				       __psunsigned_t, __psunsigned_t,
-				       __psunsigned_t, __psunsigned_t);
+				       char *, int, int, uintptr_t,
+				       uintptr_t, uintptr_t,
+				       uintptr_t, uintptr_t,
+				       uintptr_t, uintptr_t,
+				       uintptr_t, uintptr_t,
+				       uintptr_t, uintptr_t);
 	void		(*trace_cursor)(struct xfs_btree_cur *, __uint32_t *,
 					__uint64_t *, __uint64_t *);
 	void		(*trace_key)(struct xfs_btree_cur *,
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index b292cce..c250bab 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -309,17 +309,17 @@ xfs_allocbt_trace_enter(
 	char			*s,
 	int			type,
 	int			line,
-	__psunsigned_t		a0,
-	__psunsigned_t		a1,
-	__psunsigned_t		a2,
-	__psunsigned_t		a3,
-	__psunsigned_t		a4,
-	__psunsigned_t		a5,
-	__psunsigned_t		a6,
-	__psunsigned_t		a7,
-	__psunsigned_t		a8,
-	__psunsigned_t		a9,
-	__psunsigned_t		a10)
+	uintptr_t		a0,
+	uintptr_t		a1,
+	uintptr_t		a2,
+	uintptr_t		a3,
+	uintptr_t		a4,
+	uintptr_t		a5,
+	uintptr_t		a6,
+	uintptr_t		a7,
+	uintptr_t		a8,
+	uintptr_t		a9,
+	uintptr_t		a10)
 {
 	ktrace_enter(xfs_allocbt_trace_buf, (void *)(intptr_t)type,
 		(void *)func, (void *)s, NULL, (void *)cur,
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index c24cc2a..fad8416 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -720,17 +720,17 @@ xfs_bmbt_trace_enter(
 	char			*s,
 	int			type,
 	int			line,
-	__psunsigned_t		a0,
-	__psunsigned_t		a1,
-	__psunsigned_t		a2,
-	__psunsigned_t		a3,
-	__psunsigned_t		a4,
-	__psunsigned_t		a5,
-	__psunsigned_t		a6,
-	__psunsigned_t		a7,
-	__psunsigned_t		a8,
-	__psunsigned_t		a9,
-	__psunsigned_t		a10)
+	uintptr_t		a0,
+	uintptr_t		a1,
+	uintptr_t		a2,
+	uintptr_t		a3,
+	uintptr_t		a4,
+	uintptr_t		a5,
+	uintptr_t		a6,
+	uintptr_t		a7,
+	uintptr_t		a8,
+	uintptr_t		a9,
+	uintptr_t		a10)
 {
 	struct xfs_inode	*ip = cur->bc_private.b.ip;
 	int			whichfork = cur->bc_private.b.whichfork;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 5c54f75..43611a0 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -195,17 +195,17 @@ xfs_inobt_trace_enter(
 	char			*s,
 	int			type,
 	int			line,
-	__psunsigned_t		a0,
-	__psunsigned_t		a1,
-	__psunsigned_t		a2,
-	__psunsigned_t		a3,
-	__psunsigned_t		a4,
-	__psunsigned_t		a5,
-	__psunsigned_t		a6,
-	__psunsigned_t		a7,
-	__psunsigned_t		a8,
-	__psunsigned_t		a9,
-	__psunsigned_t		a10)
+	uintptr_t		a0,
+	uintptr_t		a1,
+	uintptr_t		a2,
+	uintptr_t		a3,
+	uintptr_t		a4,
+	uintptr_t		a5,
+	uintptr_t		a6,
+	uintptr_t		a7,
+	uintptr_t		a8,
+	uintptr_t		a9,
+	uintptr_t		a10)
 {
 	ktrace_enter(xfs_inobt_trace_buf, (void *)(intptr_t)type,
 		(void *)func, (void *)s, NULL, (void *)cur,
diff --git a/repair/avl.c b/repair/avl.c
index eabecc3..88f4c44 100644
--- a/repair/avl.c
+++ b/repair/avl.c
@@ -69,8 +69,8 @@ avl_checktree(
 	register avlnode_t *root)
 {
 	register avlnode_t *nlast, *nnext, *np;
-	__psunsigned_t offset = 0;
-	__psunsigned_t end;
+	uintptr_t offset = 0;
+	uintptr_t end;
 
 	nlast = nnext = root;
 
@@ -589,8 +589,8 @@ attach:
 avlnode_t *
 avl_findanyrange(
 	register avltree_desc_t *tree,
-	register __psunsigned_t start,
-	register __psunsigned_t end,
+	register uintptr_t start,
+	register uintptr_t end,
 	int	checklen)
 {
 	register avlnode_t *np = tree->avl_root;
@@ -660,10 +660,10 @@ avl_findanyrange(
 avlnode_t *
 avl_find(
 	register avltree_desc_t *tree,
-	register __psunsigned_t value)
+	register uintptr_t value)
 {
 	register avlnode_t *np = tree->avl_root;
-	register __psunsigned_t nvalue;
+	register uintptr_t nvalue;
 
 	while (np) {
 		nvalue = AVL_START(tree, np);
@@ -887,8 +887,8 @@ static
 avlnode_t *
 avl_insert_find_growth(
 		register avltree_desc_t *tree,
-		register __psunsigned_t start,	/* range start at start, */
-		register __psunsigned_t end,	/* exclusive */
+		register uintptr_t start,	/* range start at start, */
+		register uintptr_t end,	/* exclusive */
 		register int   *growthp)	/* OUT */
 {
 	avlnode_t *root = tree->avl_root;
@@ -941,7 +941,7 @@ avl_insert_grow(
 	register int growth)
 {
 	register avlnode_t *nnext;
-	register __psunsigned_t start = AVL_START(tree, newnode);
+	register uintptr_t start = AVL_START(tree, newnode);
 
 	if (growth == AVL_BACK) {
 
@@ -983,8 +983,8 @@ avl_insert(
 	register avlnode_t *newnode)
 {
 	register avlnode_t *np;
-	register __psunsigned_t start = AVL_START(tree, newnode);
-	register __psunsigned_t end = AVL_END(tree, newnode);
+	register uintptr_t start = AVL_START(tree, newnode);
+	register uintptr_t end = AVL_END(tree, newnode);
 	int growth;
 
 	ASSERT(newnode);
@@ -1138,16 +1138,16 @@ avlops_t avl_debug_ops = {
 	avl_debug_end,
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_debug_start(avlnode_t *node)
 {
-	return (__psunsigned_t)(struct avl_debug_node *)node->avl_start;
+	return (uintptr_t)(struct avl_debug_node *)node->avl_start;
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_debug_end(avlnode_t *node)
 {
-	return (__psunsigned_t)
+	return (uintptr_t)
 		((struct avl_debug_node *)node->avl_start +
 		 (struct avl_debug_node *)node->avl_size);
 }
@@ -1283,7 +1283,7 @@ main()
 avlnode_t *
 avl_findadjacent(
 	register avltree_desc_t *tree,
-	register __psunsigned_t value,
+	register uintptr_t	value,
 	register int		dir)
 {
 	register avlnode_t *np = tree->avl_root;
@@ -1357,8 +1357,8 @@ avl_findadjacent(
 void
 avl_findranges(
 	register avltree_desc_t *tree,
-	register __psunsigned_t start,
-	register __psunsigned_t end,
+	register uintptr_t	start,
+	register uintptr_t	end,
 	avlnode_t	        **startp,
 	avlnode_t		**endp)
 {
diff --git a/repair/avl.h b/repair/avl.h
index 2fad1ec..3b27915 100644
--- a/repair/avl.h
+++ b/repair/avl.h
@@ -31,8 +31,8 @@ typedef struct	avlnode {
  * avl-tree operations
  */
 typedef struct avlops {
-	__psunsigned_t	(*avl_start)(avlnode_t *);
-	__psunsigned_t	(*avl_end)(avlnode_t *);
+	uintptr_t (*avl_start)(avlnode_t *);
+	uintptr_t (*avl_end)(avlnode_t *);
 } avlops_t;
 
 #define	AVL_START(tree, n)	(*(tree)->avl_ops->avl_start)(n)
@@ -87,7 +87,7 @@ avl_init_tree(
 static inline avlnode_t *
 avl_findrange(
 	avltree_desc_t *tree,
-	__psunsigned_t value)
+	uintptr_t value)
 {
 	register avlnode_t *np = tree->avl_root;
 
@@ -110,27 +110,27 @@ avl_findrange(
 avlnode_t *
 avl_find(
 	avltree_desc_t *tree,
-	__psunsigned_t value);
+	uintptr_t value);
 
 avlnode_t *
 avl_findanyrange(
 	avltree_desc_t *tree,
-	__psunsigned_t start,
-	__psunsigned_t end,
+	uintptr_t start,
+	uintptr_t end,
 	int     checklen);
 
 
 avlnode_t *
 avl_findadjacent(
 	avltree_desc_t *tree,
-	__psunsigned_t value,
+	uintptr_t value,
 	int		dir);
 
 void
 avl_findranges(
 	register avltree_desc_t *tree,
-	register __psunsigned_t start,
-	register __psunsigned_t end,
+	register uintptr_t start,
+	register uintptr_t end,
 	avlnode_t	        **startp,
 	avlnode_t		**endp);
 
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index a7d61e0..ff498b6 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -498,43 +498,42 @@ get_bcnt_extent(xfs_agnumber_t agno, xfs_agblock_t startblock,
 	return(ext);
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_ext_start(avlnode_t *node)
 {
-	return((__psunsigned_t)
-		((extent_tree_node_t *) node)->ex_startblock);
+	return (uintptr_t) ((extent_tree_node_t *)node)->ex_startblock;
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_ext_end(avlnode_t *node)
 {
-	return((__psunsigned_t) (
+	return (uintptr_t) (
 		((extent_tree_node_t *) node)->ex_startblock +
-		((extent_tree_node_t *) node)->ex_blockcount));
+		((extent_tree_node_t *) node)->ex_blockcount);
 }
 
 /*
  * convert size to an address for the AVL tree code -- the bigger the size,
  * the lower the address so the biggest extent will be first in the tree
  */
-static __psunsigned_t
+static uintptr_t
 avl_ext_bcnt_start(avlnode_t *node)
 {
 /*
-	return((__psunsigned_t) (BCNT_ADDR(((extent_tree_node_t *)
-						node)->ex_blockcount)));
+	return (uintptr_t) (BCNT_ADDR(((extent_tree_node_t *)
+						node)->ex_blockcount));
 */
-	return((__psunsigned_t) ((extent_tree_node_t *)node)->ex_blockcount);
+	return (uintptr_t) ((extent_tree_node_t *)node)->ex_blockcount;
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_ext_bcnt_end(avlnode_t *node)
 {
 /*
-	return((__psunsigned_t) (BCNT_ADDR(((extent_tree_node_t *)
-						node)->ex_blockcount)));
+	return (uintptr_t) (BCNT_ADDR(((extent_tree_node_t *)
+						node)->ex_blockcount));
 */
-	return((__psunsigned_t) ((extent_tree_node_t *)node)->ex_blockcount);
+	return (uintptr_t) ((extent_tree_node_t *)node)->ex_blockcount;
 }
 
 avlops_t avl_extent_bcnt_tree_ops = {
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 2a40727..55d4b4b 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -747,18 +747,18 @@ add_ino_ex_data(xfs_mount_t *mp)
 	full_ino_ex_data = 1;
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_ino_start(avlnode_t *node)
 {
-	return((__psunsigned_t) ((ino_tree_node_t *) node)->ino_startnum);
+	return (uintptr_t) ((ino_tree_node_t *)node)->ino_startnum;
 }
 
-static __psunsigned_t
+static uintptr_t
 avl_ino_end(avlnode_t *node)
 {
-	return((__psunsigned_t) (
+	return (uintptr_t) (
 		((ino_tree_node_t *) node)->ino_startnum +
-		XFS_INODES_PER_CHUNK));
+		XFS_INODES_PER_CHUNK);
 }
 
 avlops_t avl_ino_tree_ops = {
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
