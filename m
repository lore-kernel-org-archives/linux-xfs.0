Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82HwIFf034412 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:58:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9640441E04A
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3XWEVUcA6owepWaI for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:42 -0700 (PDT)
Message-Id: <20090902175842.081792481@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 13/14] repair: optimize duplicate extent tracking
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-dup_extents-btree
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
Cc: Barry Naujok <bnaujok@sgi.com>

Switch the duplicate extent tracking from an avl tree to our new btree
implementation.  Modify search_dup_extent to find overlapping extents
with differening start blocks instead of having the caller walk every
possible start block.


Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/dinode.c
===================================================================
--- xfsprogs-dev.orig/repair/dinode.c	2009-08-21 15:11:16.000000000 +0000
+++ xfsprogs-dev/repair/dinode.c	2009-08-21 15:11:29.000000000 +0000
@@ -735,18 +735,14 @@ process_bmbt_reclist_int(
 			 * checking each entry without setting the
 			 * block bitmap
 			 */
-			for (b = irec.br_startblock;
-			     agbno < ebno;
-			     b++, agbno++)  {
-				if (search_dup_extent(mp, agno, agbno)) {
-					do_warn(_("%s fork in ino %llu claims "
-						"dup extent, off - %llu, "
-						"start - %llu, cnt %llu\n"),
-						forkname, ino, irec.br_startoff,
-						irec.br_startblock,
-						irec.br_blockcount);
-					goto done;
-				}
+			if (search_dup_extent(agno, agbno, ebno)) {
+				do_warn(_("%s fork in ino %llu claims "
+					"dup extent, off - %llu, "
+					"start - %llu, cnt %llu\n"),
+					forkname, ino, irec.br_startoff,
+					irec.br_startblock,
+					irec.br_blockcount);
+				goto done;
 			}
 			*tot += irec.br_blockcount;
 			continue;
Index: xfsprogs-dev/repair/incore.h
===================================================================
--- xfsprogs-dev.orig/repair/incore.h	2009-08-21 15:11:16.000000000 +0000
+++ xfsprogs-dev/repair/incore.h	2009-08-21 15:11:29.000000000 +0000
@@ -20,6 +20,8 @@
 #define XFS_REPAIR_INCORE_H
 
 #include "avl.h"
+
+
 /*
  * contains definition information.  implementation (code)
  * is spread out in separate files.
@@ -179,23 +181,11 @@ get_bcnt_extent(xfs_agnumber_t agno, xfs
 /*
  * duplicate extent tree functions
  */
-void		add_dup_extent(xfs_agnumber_t agno,
-				xfs_agblock_t startblock,
-				xfs_extlen_t blockcount);
-
-extern avltree_desc_t   **extent_tree_ptrs;
-/* ARGSUSED */
-static inline int
-search_dup_extent(xfs_mount_t *mp, xfs_agnumber_t agno, xfs_agblock_t agbno)
-{
-	ASSERT(agno < glob_agcount);
-
-	if (avl_findrange(extent_tree_ptrs[agno], agbno) != NULL)
-		return(1);
-
-	return(0);
-}
 
+int		add_dup_extent(xfs_agnumber_t agno, xfs_agblock_t startblock,
+			xfs_extlen_t blockcount);
+int		search_dup_extent(xfs_agnumber_t agno,
+			xfs_agblock_t start_agbno, xfs_agblock_t end_agbno);
 void		add_rt_dup_extent(xfs_drtbno_t	startblock,
 				xfs_extlen_t	blockcount);
 
Index: xfsprogs-dev/repair/incore_ext.c
===================================================================
--- xfsprogs-dev.orig/repair/incore_ext.c	2009-08-21 15:11:16.000000000 +0000
+++ xfsprogs-dev/repair/incore_ext.c	2009-08-21 15:24:07.000000000 +0000
@@ -18,6 +18,7 @@
 
 #include <libxfs.h>
 #include "avl.h"
+#include "btree.h"
 #include "globals.h"
 #include "incore.h"
 #include "agheader.h"
@@ -72,8 +73,8 @@ static rt_ext_flist_t rt_ext_flist;
 
 static avl64tree_desc_t	*rt_ext_tree_ptr;	/* dup extent tree for rt */
 
-avltree_desc_t	**extent_tree_ptrs;		/* array of extent tree ptrs */
-						/* one per ag for dups */
+static struct btree_root **dup_extent_trees;	/* per ag dup extent trees */
+
 static avltree_desc_t	**extent_bno_ptrs;	/*
 						 * array of extent tree ptrs
 						 * one per ag for free extents
@@ -100,6 +101,48 @@ static pthread_mutex_t	rt_ext_tree_lock;
 static pthread_mutex_t	rt_ext_flist_lock;
 
 /*
+ * duplicate extent tree functions
+ */
+
+void
+release_dup_extent_tree(
+	xfs_agnumber_t		agno)
+{
+	btree_clear(dup_extent_trees[agno]);
+}
+
+int
+add_dup_extent(
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		startblock,
+	xfs_extlen_t		blockcount)
+{
+#ifdef XR_DUP_TRACE
+	fprintf(stderr, "Adding dup extent - %d/%d %d\n", agno, startblock,
+		blockcount);
+#endif
+	return btree_insert(dup_extent_trees[agno], startblock,
+				(void *)(uintptr_t)(startblock + blockcount));
+}
+
+int
+search_dup_extent(
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		start_agbno,
+	xfs_agblock_t		end_agbno)
+{
+	unsigned long	bno;
+
+	if (!btree_find(dup_extent_trees[agno], start_agbno, &bno))
+		return 0;	/* this really shouldn't happen */
+	if (bno < end_agbno)
+		return 1;
+	return (uintptr_t)btree_peek_prev(dup_extent_trees[agno], NULL) >
+								start_agbno;
+}
+
+
+/*
  * extent tree stuff is avl trees of duplicate extents,
  * sorted in order by block number.  there is one tree per ag.
  */
@@ -211,14 +254,6 @@ release_extent_tree(avltree_desc_t *tree
  * top-level (visible) routines
  */
 void
-release_dup_extent_tree(xfs_agnumber_t agno)
-{
-	release_extent_tree(extent_tree_ptrs[agno]);
-
-	return;
-}
-
-void
 release_agbno_extent_tree(xfs_agnumber_t agno)
 {
 	release_extent_tree(extent_bno_ptrs[agno]);
@@ -522,93 +557,6 @@ get_bcnt_extent(xfs_agnumber_t agno, xfs
 	return(ext);
 }
 
-/*
- * the next 2 routines manage the trees of duplicate extents -- 1 tree
- * per AG
- */
-void
-add_dup_extent(xfs_agnumber_t agno, xfs_agblock_t startblock,
-		xfs_extlen_t blockcount)
-{
-	extent_tree_node_t *first, *last, *ext, *next_ext;
-	xfs_agblock_t new_startblock;
-	xfs_extlen_t new_blockcount;
-
-	ASSERT(agno < glob_agcount);
-
-#ifdef XR_DUP_TRACE
-	fprintf(stderr, "Adding dup extent - %d/%d %d\n", agno, startblock, blockcount);
-#endif
-	avl_findranges(extent_tree_ptrs[agno], startblock - 1,
-		startblock + blockcount + 1,
-		(avlnode_t **) &first, (avlnode_t **) &last);
-	/*
-	 * find adjacent and overlapping extent blocks
-	 */
-	if (first == NULL && last == NULL)  {
-		/* nothing, just make and insert new extent */
-
-		ext = mk_extent_tree_nodes(startblock, blockcount, XR_E_MULT);
-
-		if (avl_insert(extent_tree_ptrs[agno],
-				(avlnode_t *) ext) == NULL)  {
-			do_error(_("duplicate extent range\n"));
-		}
-
-		return;
-	}
-
-	ASSERT(first != NULL && last != NULL);
-
-	/*
-	 * find the new composite range, delete old extent nodes
-	 * as we go
-	 */
-	new_startblock = startblock;
-	new_blockcount = blockcount;
-
-	for (ext = first;
-		ext != (extent_tree_node_t *) last->avl_node.avl_nextino;
-		ext = next_ext)  {
-		/*
-		 * preserve the next inorder node
-		 */
-		next_ext = (extent_tree_node_t *) ext->avl_node.avl_nextino;
-		/*
-		 * just bail if the new extent is contained within an old one
-		 */
-		if (ext->ex_startblock <= startblock &&
-				ext->ex_blockcount >= blockcount)
-			return;
-		/*
-		 * now check for overlaps and adjacent extents
-		 */
-		if (ext->ex_startblock + ext->ex_blockcount >= startblock
-			|| ext->ex_startblock <= startblock + blockcount)  {
-
-			if (ext->ex_startblock < new_startblock)
-				new_startblock = ext->ex_startblock;
-
-			if (ext->ex_startblock + ext->ex_blockcount >
-					new_startblock + new_blockcount)
-				new_blockcount = ext->ex_startblock +
-							ext->ex_blockcount -
-							new_startblock;
-
-			avl_delete(extent_tree_ptrs[agno], (avlnode_t *) ext);
-			continue;
-		}
-	}
-
-	ext = mk_extent_tree_nodes(new_startblock, new_blockcount, XR_E_MULT);
-
-	if (avl_insert(extent_tree_ptrs[agno], (avlnode_t *) ext) == NULL)  {
-		do_error(_("duplicate extent range\n"));
-	}
-
-	return;
-}
-
 static __psunsigned_t
 avl_ext_start(avlnode_t *node)
 {
@@ -901,10 +849,9 @@ incore_ext_init(xfs_mount_t *mp)
 	pthread_mutex_init(&rt_ext_tree_lock, NULL);
 	pthread_mutex_init(&rt_ext_flist_lock, NULL);
 
-	if ((extent_tree_ptrs = malloc(agcount *
-					sizeof(avltree_desc_t *))) == NULL)
-		do_error(
-	_("couldn't malloc dup extent tree descriptor table\n"));
+	dup_extent_trees = calloc(agcount, sizeof(struct btree_root *));
+	if (!dup_extent_trees)
+		do_error(_("couldn't malloc dup extent tree descriptor table\n"));
 
 	if ((extent_bno_ptrs = malloc(agcount *
 					sizeof(avltree_desc_t *))) == NULL)
@@ -917,10 +864,6 @@ incore_ext_init(xfs_mount_t *mp)
 	_("couldn't malloc free by-bcnt extent tree descriptor table\n"));
 
 	for (i = 0; i < agcount; i++)  {
-		if ((extent_tree_ptrs[i] =
-				malloc(sizeof(avltree_desc_t))) == NULL)
-			do_error(
-			_("couldn't malloc dup extent tree descriptor\n"));
 		if ((extent_bno_ptrs[i] =
 				malloc(sizeof(avltree_desc_t))) == NULL)
 			do_error(
@@ -932,7 +875,7 @@ incore_ext_init(xfs_mount_t *mp)
 	}
 
 	for (i = 0; i < agcount; i++)  {
-		avl_init_tree(extent_tree_ptrs[i], &avl_extent_tree_ops);
+		btree_init(&dup_extent_trees[i]);
 		avl_init_tree(extent_bno_ptrs[i], &avl_extent_tree_ops);
 		avl_init_tree(extent_bcnt_ptrs[i], &avl_extent_bcnt_tree_ops);
 	}
@@ -959,18 +902,18 @@ incore_ext_teardown(xfs_mount_t *mp)
 	free_allocations(ba_list);
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
-		free(extent_tree_ptrs[i]);
+		btree_destroy(dup_extent_trees[i]);
 		free(extent_bno_ptrs[i]);
 		free(extent_bcnt_ptrs[i]);
 	}
 
+	free(dup_extent_trees);
 	free(extent_bcnt_ptrs);
 	free(extent_bno_ptrs);
-	free(extent_tree_ptrs);
 
-	extent_bcnt_ptrs = extent_bno_ptrs = extent_tree_ptrs = NULL;
-
-	return;
+	dup_extent_trees = NULL;
+	extent_bcnt_ptrs = NULL;
+	extent_bno_ptrs = NULL;
 }
 
 int
Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2009-08-21 15:11:16.000000000 +0000
+++ xfsprogs-dev/repair/scan.c	2009-08-21 15:23:51.000000000 +0000
@@ -286,8 +286,9 @@ _("bad back (left) sibling pointer (saw 
 		 * filesystem
 		 */
 		if (type != XR_INO_RTDATA || whichfork != XFS_DATA_FORK)  {
-			if (search_dup_extent(mp, XFS_FSB_TO_AGNO(mp, bno),
-					XFS_FSB_TO_AGBNO(mp, bno)))
+			if (search_dup_extent(XFS_FSB_TO_AGNO(mp, bno),
+					XFS_FSB_TO_AGBNO(mp, bno),
+					XFS_FSB_TO_AGBNO(mp, bno) + 1))
 				return(1);
 		} else  {
 			if (search_rt_dup_extent(mp, bno))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
