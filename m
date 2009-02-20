Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1K8rWEv164865 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 02:53:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0136613818C
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:53:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id RAGkdG23r5VL4kdO for
	<xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:53:00 -0800 (PST)
Message-Id: <20090220085230.115970000@bombadil.infradead.org>
Date: Fri, 20 Feb 2009 03:52:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/7] xfs: factor out code to find the longest free extent in
	the AG
References: <20090220085207.663702000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-factor-pag-freelist-check-2
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
Cc: Dave Chinner <dgc@sgi.com>

From: Dave Chinner <dgc@sgi.com>

Signed-off-by: Dave Chinner <dgc@sgi.com>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2009-02-15 19:40:08.270069722 +0100
+++ xfs/fs/xfs/xfs_alloc.c	2009-02-15 22:50:10.763069641 +0100
@@ -1872,6 +1872,25 @@ xfs_alloc_compute_maxlevels(
 }
 
 /*
+ * Find the length of the longest extent in an AG.
+ */
+xfs_extlen_t
+xfs_alloc_min_freelist(
+	struct xfs_mount	*mp,
+	struct xfs_perag	*pag)
+{
+	xfs_extlen_t		need, delta = 0;
+
+	need = XFS_MIN_FREELIST_PAG(pag, mp);
+	if (need > pag->pagf_flcount)
+		delta = need - pag->pagf_flcount;
+
+	if (pag->pagf_longest > delta)
+		return pag->pagf_longest - delta;
+	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
+}
+
+/*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
  */
@@ -1923,15 +1942,12 @@ xfs_alloc_fix_freelist(
 	}
 
 	if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
-		need = XFS_MIN_FREELIST_PAG(pag, mp);
-		delta = need > pag->pagf_flcount ? need - pag->pagf_flcount : 0;
 		/*
 		 * If it looks like there isn't a long enough extent, or enough
 		 * total blocks, reject it.
 		 */
-		longest = (pag->pagf_longest > delta) ?
-			(pag->pagf_longest - delta) :
-			(pag->pagf_flcount > 0 || pag->pagf_longest > 0);
+		need = XFS_MIN_FREELIST_PAG(pag, mp);
+		longest = xfs_alloc_min_freelist(mp, pag);
 		if ((args->minlen + args->alignment + args->minalignslop - 1) >
 				longest ||
 		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2009-02-08 21:51:06.553944398 +0100
+++ xfs/fs/xfs/xfs_alloc.h	2009-02-15 22:47:48.470968077 +0100
@@ -100,6 +100,12 @@ typedef struct xfs_alloc_arg {
 #define XFS_ALLOC_USERDATA		1	/* allocation is for user data*/
 #define XFS_ALLOC_INITIAL_USER_DATA	2	/* special case start of file */
 
+/*
+ * Find the length of the longest extent in an AG.
+ */
+xfs_extlen_t
+xfs_alloc_min_freelist(struct xfs_mount *mp,
+		struct xfs_perag *pag);
 
 #ifdef __KERNEL__
 
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2009-02-15 19:40:08.724068781 +0100
+++ xfs/fs/xfs/xfs_bmap.c	2009-02-15 22:47:48.478974193 +0100
@@ -2712,9 +2712,6 @@ xfs_bmap_btalloc(
 	xfs_agnumber_t	startag;
 	xfs_alloc_arg_t	args;
 	xfs_extlen_t	blen;
-	xfs_extlen_t	delta;
-	xfs_extlen_t	longest;
-	xfs_extlen_t	need;
 	xfs_extlen_t	nextminlen = 0;
 	xfs_perag_t	*pag;
 	int		nullfb;		/* true if ap->firstblock isn't set */
@@ -2796,13 +2793,8 @@ xfs_bmap_btalloc(
 			 * See xfs_alloc_fix_freelist...
 			 */
 			if (pag->pagf_init) {
-				need = XFS_MIN_FREELIST_PAG(pag, mp);
-				delta = need > pag->pagf_flcount ?
-					need - pag->pagf_flcount : 0;
-				longest = (pag->pagf_longest > delta) ?
-					(pag->pagf_longest - delta) :
-					(pag->pagf_flcount > 0 ||
-					 pag->pagf_longest > 0);
+				xfs_extlen_t	longest;
+				longest = xfs_alloc_min_freelist(mp, pag);
 				if (blen < longest)
 					blen = longest;
 			} else
Index: xfs/fs/xfs/xfs_filestream.c
===================================================================
--- xfs.orig/fs/xfs/xfs_filestream.c	2009-02-08 21:51:06.575944685 +0100
+++ xfs/fs/xfs/xfs_filestream.c	2009-02-15 22:47:48.479944079 +0100
@@ -140,7 +140,7 @@ _xfs_filestream_pick_ag(
 	xfs_extlen_t	minlen)
 {
 	int		err, trylock, nscan;
-	xfs_extlen_t	delta, longest, need, free, minfree, maxfree = 0;
+	xfs_extlen_t	longest, free, minfree, maxfree = 0;
 	xfs_agnumber_t	ag, max_ag = NULLAGNUMBER;
 	struct xfs_perag *pag;
 
@@ -186,12 +186,7 @@ _xfs_filestream_pick_ag(
 			goto next_ag;
 		}
 
-		need = XFS_MIN_FREELIST_PAG(pag, mp);
-		delta = need > pag->pagf_flcount ? need - pag->pagf_flcount : 0;
-		longest = (pag->pagf_longest > delta) ?
-		          (pag->pagf_longest - delta) :
-		          (pag->pagf_flcount > 0 || pag->pagf_longest > 0);
-
+		longest = xfs_alloc_min_freelist(mp, pag);
 		if (((minlen && longest >= minlen) ||
 		     (!minlen && pag->pagf_freeblks >= minfree)) &&
 		    (!pag->pagf_metadata || !(flags & XFS_PICK_USERDATA) ||

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
