Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB2Hopr6092936 for <xfs@oss.sgi.com>; Fri, 2 Dec 2011 11:50:51 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9777D1F3F477
	for <xfs@oss.sgi.com>; Fri,  2 Dec 2011 09:47:44 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	0IeiFHzPkVxWukjT for <xfs@oss.sgi.com>;
	Fri, 02 Dec 2011 09:47:44 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RWXD5-0000nf-Ij
	for xfs@oss.sgi.com; Fri, 02 Dec 2011 17:47:43 +0000
Message-Id: <20111202174743.523970893@bombadil.infradead.org>
Date: Fri, 02 Dec 2011 12:46:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/12] repair: move extern declarations to headers
References: <20111202174619.179530033@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-cleanup-externs
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/avl.h
===================================================================
--- xfsprogs-dev.orig/repair/avl.h	2011-12-01 16:17:07.000000000 +0000
+++ xfsprogs-dev/repair/avl.h	2011-12-01 16:18:33.000000000 +0000
@@ -134,6 +134,15 @@ avl_findranges(
 	avlnode_t	        **startp,
 	avlnode_t		**endp);
 
+avlnode_t *
+avl_firstino(
+	avlnode_t		*root);
+
+avlnode_t *
+avl_lastino(
+	avlnode_t		*root);
+
+
 #define AVL_PRECEED	0x1
 #define AVL_SUCCEED	0x2
 
Index: xfsprogs-dev/repair/bmap.h
===================================================================
--- xfsprogs-dev.orig/repair/bmap.h	2011-12-01 16:17:07.000000000 +0000
+++ xfsprogs-dev/repair/bmap.h	2011-12-01 16:18:33.000000000 +0000
@@ -53,6 +53,9 @@ typedef	struct blkmap {
 #define BLKMAP_NEXTS_MAX	INT_MAX
 #endif
 
+extern pthread_key_t dblkmap_key;
+extern pthread_key_t ablkmap_key;
+
 blkmap_t	*blkmap_alloc(xfs_extnum_t nex, int whichfork);
 void		blkmap_free(blkmap_t *blkmap);
 
Index: xfsprogs-dev/repair/incore.h
===================================================================
--- xfsprogs-dev.orig/repair/incore.h	2011-12-01 16:17:07.000000000 +0000
+++ xfsprogs-dev/repair/incore.h	2011-12-01 16:18:33.000000000 +0000
@@ -209,9 +209,12 @@ void		incore_ext_init(xfs_mount_t *);
  * the nodes.
  */
 void		incore_ext_teardown(xfs_mount_t *mp);
-
 void		incore_ino_init(xfs_mount_t *);
 
+int		count_bno_extents(xfs_agnumber_t);
+int		count_bno_extents_blocks(xfs_agnumber_t, uint *);
+int		count_bcnt_extents(xfs_agnumber_t);
+
 /*
  * inode definitions
  */
Index: xfsprogs-dev/repair/incore_ext.c
===================================================================
--- xfsprogs-dev.orig/repair/incore_ext.c	2011-12-01 16:17:31.000000000 +0000
+++ xfsprogs-dev/repair/incore_ext.c	2011-12-01 16:18:33.000000000 +0000
@@ -386,8 +386,6 @@ findfirst_bcnt_extent(xfs_agnumber_t agn
 extent_tree_node_t *
 findbiggest_bcnt_extent(xfs_agnumber_t agno)
 {
-	extern avlnode_t *avl_lastino(avlnode_t *root);
-
 	ASSERT(extent_bcnt_ptrs != NULL);
 	ASSERT(extent_bcnt_ptrs[agno] != NULL);
 
Index: xfsprogs-dev/repair/incore_ino.c
===================================================================
--- xfsprogs-dev.orig/repair/incore_ino.c	2011-12-01 16:17:31.000000000 +0000
+++ xfsprogs-dev/repair/incore_ino.c	2011-12-01 16:18:51.000000000 +0000
@@ -25,8 +25,6 @@
 #include "threads.h"
 #include "err_protos.h"
 
-extern avlnode_t	*avl_firstino(avlnode_t *root);
-
 /*
  * array of inode tree ptrs, one per ag
  */
Index: xfsprogs-dev/repair/init.c
===================================================================
--- xfsprogs-dev.orig/repair/init.c	2011-12-01 16:17:07.000000000 +0000
+++ xfsprogs-dev/repair/init.c	2011-12-01 16:18:33.000000000 +0000
@@ -34,9 +34,6 @@ static pthread_key_t dirbuf_key;
 static pthread_key_t dir_freemap_key;
 static pthread_key_t attr_freemap_key;
 
-extern pthread_key_t dblkmap_key;
-extern pthread_key_t ablkmap_key;
-
 static void
 ts_alloc(pthread_key_t key, unsigned n, size_t size)
 {
Index: xfsprogs-dev/repair/phase4.c
===================================================================
--- xfsprogs-dev.orig/repair/phase4.c	2011-12-01 16:18:23.000000000 +0000
+++ xfsprogs-dev/repair/phase4.c	2011-12-01 16:18:33.000000000 +0000
@@ -196,8 +196,6 @@ phase4(xfs_mount_t *mp)
 	int			ag_hdr_len = 4 * mp->m_sb.sb_sectsize;
 	int			ag_hdr_block;
 	int			bstate;
-	int			count_bcnt_extents(xfs_agnumber_t agno);
-	int			count_bno_extents(xfs_agnumber_t agno);
 
 	ag_hdr_block = howmany(ag_hdr_len, mp->m_sb.sb_blocksize);
 
Index: xfsprogs-dev/repair/phase5.c
===================================================================
--- xfsprogs-dev.orig/repair/phase5.c	2011-12-01 16:18:23.000000000 +0000
+++ xfsprogs-dev/repair/phase5.c	2011-12-01 16:18:33.000000000 +0000
@@ -1404,11 +1404,6 @@ phase5_func(
 	xfs_extlen_t	freeblks2;
 #endif
 	xfs_agblock_t	num_extents;
-	extern int	count_bno_extents(xfs_agnumber_t);
-	extern int	count_bno_extents_blocks(xfs_agnumber_t, uint *);
-#ifdef XR_BLD_FREE_TRACE
-	extern int	count_bcnt_extents(xfs_agnumber_t);
-#endif
 
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);
Index: xfsprogs-dev/repair/protos.h
===================================================================
--- xfsprogs-dev.orig/repair/protos.h	2011-12-01 16:17:07.000000000 +0000
+++ xfsprogs-dev/repair/protos.h	2011-12-01 16:18:33.000000000 +0000
@@ -39,11 +39,23 @@ void	get_sb_geometry(struct fs_geometry
 char	*alloc_ag_buf(int size);
 
 void	print_inode_list(xfs_agnumber_t i);
-char *	err_string(int err_code);
+char	*err_string(int err_code);
 
-extern void *ts_attr_freemap(void);
-extern void *ts_dir_freemap(void);
-extern void *ts_dirbuf(void);
-extern void ts_init(void);
-extern void thread_init(void);
+void	*ts_attr_freemap(void);
+void	*ts_dir_freemap(void);
+void	*ts_dirbuf(void);
+void	ts_init(void);
+void	thread_init(void);
+
+void	phase1(struct xfs_mount *);
+void	phase2(struct xfs_mount *, int);
+void	phase3(struct xfs_mount *);
+void	phase4(struct xfs_mount *);
+void	phase5(struct xfs_mount *);
+void	phase6(struct xfs_mount *);
+void	phase7(struct xfs_mount *);
+
+int	verify_set_agheader(struct xfs_mount *, struct xfs_buf *,
+		struct xfs_sb *, struct xfs_agf *, struct xfs_agi *,
+		xfs_agnumber_t);
 
Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2011-12-01 16:18:23.000000000 +0000
+++ xfsprogs-dev/repair/scan.c	2011-12-01 16:18:33.000000000 +0000
@@ -30,9 +30,6 @@
 #include "progress.h"
 #include "threads.h"
 
-extern int verify_set_agheader(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
-		xfs_agf_t *agf, xfs_agi_t *agi, xfs_agnumber_t i);
-
 static xfs_mount_t	*mp = NULL;
 
 /*
Index: xfsprogs-dev/repair/xfs_repair.c
===================================================================
--- xfsprogs-dev.orig/repair/xfs_repair.c	2011-12-01 16:18:23.000000000 +0000
+++ xfsprogs-dev/repair/xfs_repair.c	2011-12-01 16:18:33.000000000 +0000
@@ -32,14 +32,6 @@
 
 #define	rounddown(x, y)	(((x)/(y))*(y))
 
-extern void	phase1(xfs_mount_t *);
-extern void	phase2(xfs_mount_t *, int);
-extern void	phase3(xfs_mount_t *);
-extern void	phase4(xfs_mount_t *);
-extern void	phase5(xfs_mount_t *);
-extern void	phase6(xfs_mount_t *);
-extern void	phase7(xfs_mount_t *);
-
 #define		XR_MAX_SECT_SIZE	(64 * 1024)
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
