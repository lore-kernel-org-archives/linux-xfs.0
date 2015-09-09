Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B459B7F51
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 14:34:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3335CAC008
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 12:34:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id S25UEHuc8NScqTDv for <xfs@oss.sgi.com>;
	Wed, 09 Sep 2015 12:34:14 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 04/13] xfs_repair: use multibuffer read routines in
	attr_repair.c
Date: Wed,  9 Sep 2015 14:34:02 -0500
Message-Id: <1441827251-13128-5-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
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

verify_da_path and traverse_int_dablock are similar to
verify_dir2_path and traverse_int_dir2block, but one
difference is that the dir2 code reads using the
multibuffer capable da_read_buf() routine, whereas
the attr code doesn't need to, and just calls
libxfs_readbuf.

The multibuffer code falls back just fine when the
geometry indicates that it's not needed, so use that
same code in the attribute routines, and remove
another dir2 / da difference.  We make da_read_buf()
non-static to facilitate this.

Finally, add a local *geo to these routines,
to make the code even more similar at this point.
The geometry will get passed in later in the series.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/attr_repair.c |   49 +++++++++++++++++++++++++++++++++----------------
 repair/dir2.c        |   22 +++++++++++++---------
 repair/dir2.h        |    8 ++++++++
 3 files changed, 54 insertions(+), 25 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index aba0782..fe81df4 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -138,14 +138,20 @@ traverse_int_dablock(xfs_mount_t	*mp,
 		xfs_dablk_t		*rbno,
 		int			whichfork)
 {
+	bmap_ext_t		*bmp;
 	xfs_dablk_t		bno;
 	int			i;
+	int			nex;
 	xfs_da_intnode_t	*node;
+	bmap_ext_t		lbmp;
 	xfs_fsblock_t		fsbno;
 	xfs_buf_t		*bp;
+	struct xfs_da_geometry	*geo;
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
 
+	geo = mp->m_attr_geo;
+
 	/*
 	 * traverse down left-side of tree until we hit the
 	 * left-most leaf block setting up the btree cursor along
@@ -160,13 +166,16 @@ traverse_int_dablock(xfs_mount_t	*mp,
 		/*
 		 * read in each block along the way and set up cursor
 		 */
-		fsbno = blkmap_get(da_cursor->blkmap, bno);
+		nex = blkmap_getn(da_cursor->blkmap, bno,
+				geo->fsbcount, &bmp, &lbmp);
 
-		if (fsbno == NULLFSBLOCK)
+		if (nex == 0)
 			goto error_out;
 
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-				XFS_FSB_TO_BB(mp, 1), 0, &xfs_da3_node_buf_ops);
+		bp = da_read_buf(mp, nex, bmp, &xfs_da3_node_buf_ops);
+		if (bmp != &lbmp)
+			free(bmp);
+
 		if (!bp) {
 			if (whichfork == XFS_DATA_FORK)
 				do_warn(
@@ -192,12 +201,10 @@ traverse_int_dablock(xfs_mount_t	*mp,
 			goto error_out;
 		}
 
-		if (nodehdr.count > mp->m_attr_geo->node_ents)  {
+		if (nodehdr.count > geo->node_ents)  {
 			do_warn(_("bad record count in inode %" PRIu64 ", "
 				  "count = %d, max = %d\n"),
-				da_cursor->ino,
-				nodehdr.count,
-				mp->m_attr_geo->node_ents);
+				da_cursor->ino, nodehdr.count, geo->node_ents);
 			libxfs_putbuf(bp);
 			goto error_out;
 		}
@@ -492,9 +499,15 @@ verify_da_path(xfs_mount_t	*mp,
 	int			bad;
 	int			entry;
 	int			this_level = p_level + 1;
+	bmap_ext_t		*bmp;
+	int			nex;
+	bmap_ext_t		lbmp;
+	struct xfs_da_geometry	*geo;
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
 
+	geo = mp->m_attr_geo;
+
 	/*
 	 * index is currently set to point to the entry that
 	 * should be processed now in this level.
@@ -536,17 +549,21 @@ verify_da_path(xfs_mount_t	*mp,
 		 */
 		dabno = nodehdr.forw;
 		ASSERT(dabno != 0);
-		fsbno = blkmap_get(cursor->blkmap, dabno);
-
-		if (fsbno == NULLFSBLOCK) {
-			do_warn(_("can't get map info for block %u "
-				  "of directory inode %" PRIu64 "\n"),
+		nex = blkmap_getn(cursor->blkmap, dabno, geo->fsbcount,
+			&bmp, &lbmp);
+		if (nex == 0) {
+			do_warn(
+_("can't get map info for block %u of directory inode %" PRIu64 "\n"),
 				dabno, cursor->ino);
 			return(1);
 		}
 
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-				XFS_FSB_TO_BB(mp, 1), 0, &xfs_da3_node_buf_ops);
+		fsbno = bmp[0].startblock;
+
+		bp = da_read_buf(mp, nex, bmp, &xfs_da3_node_buf_ops);
+		if (bmp != &lbmp)
+			free(bmp);
+
 		if (!bp) {
 			do_warn(
 	_("can't read block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
@@ -577,7 +594,7 @@ verify_da_path(xfs_mount_t	*mp,
 				dabno, fsbno, cursor->ino);
 			bad++;
 		}
-		if (nodehdr.count > mp->m_attr_geo->node_ents) {
+		if (nodehdr.count > geo->node_ents) {
 			do_warn(
 	_("entry count %d too large in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
 				nodehdr.count,
diff --git a/repair/dir2.c b/repair/dir2.c
index 54c49eb..44367c6 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -92,7 +92,7 @@ namecheck(char *name, int length)
  * Multibuffer handling.
  * V2 directory blocks can be noncontiguous, needing multiple buffers.
  */
-static struct xfs_buf *
+struct xfs_buf *
 da_read_buf(
 	xfs_mount_t	*mp,
 	int		nex,
@@ -143,9 +143,12 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 	int			nex;
 	xfs_da_intnode_t	*node;
 	bmap_ext_t		lbmp;
+	struct xfs_da_geometry	*geo;
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
 
+	geo = mp->m_dir_geo;
+
 	/*
 	 * traverse down left-side of tree until we hit the
 	 * left-most leaf block setting up the btree cursor along
@@ -161,7 +164,7 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 		 * read in each block along the way and set up cursor
 		 */
 		nex = blkmap_getn(da_cursor->blkmap, bno,
-				mp->m_dir_geo->fsbcount, &bmp, &lbmp);
+				geo->fsbcount, &bmp, &lbmp);
 
 		if (nex == 0)
 			goto error_out;
@@ -207,13 +210,11 @@ _("corrupt tree block %u for directory inode %" PRIu64 "\n"),
 			goto error_out;
 		}
 		btree = M_DIROPS(mp)->node_tree_p(node);
-		if (nodehdr.count > mp->m_dir_geo->node_ents)  {
-			libxfs_putbuf(bp);
+		if (nodehdr.count > geo->node_ents)  {
 			do_warn(
 _("bad record count in inode %" PRIu64 ", count = %d, max = %d\n"),
-				da_cursor->ino,
-				nodehdr.count,
-				mp->m_dir_geo->node_ents);
+				da_cursor->ino, nodehdr.count, geo->node_ents);
+			libxfs_putbuf(bp);
 			goto error_out;
 		}
 		/*
@@ -488,9 +489,12 @@ verify_dir2_path(xfs_mount_t	*mp,
 	bmap_ext_t		*bmp;
 	int			nex;
 	bmap_ext_t		lbmp;
+	struct xfs_da_geometry	*geo;
 	struct xfs_da_node_entry *btree;
 	struct xfs_da3_icnode_hdr nodehdr;
 
+	geo = mp->m_dir_geo;
+
 	/*
 	 * index is currently set to point to the entry that
 	 * should be processed now in this level.
@@ -532,7 +536,7 @@ verify_dir2_path(xfs_mount_t	*mp,
 		 */
 		dabno = nodehdr.forw;
 		ASSERT(dabno != 0);
-		nex = blkmap_getn(cursor->blkmap, dabno, mp->m_dir_geo->fsbcount,
+		nex = blkmap_getn(cursor->blkmap, dabno, geo->fsbcount,
 			&bmp, &lbmp);
 		if (nex == 0) {
 			do_warn(
@@ -574,7 +578,7 @@ _("bad back pointer in block %u for directory inode %" PRIu64 "\n"),
 				dabno, cursor->ino);
 			bad++;
 		}
-		if (nodehdr.count > mp->m_dir_geo->node_ents)  {
+		if (nodehdr.count > geo->node_ents)  {
 			do_warn(
 _("entry count %d too large in block %u for directory inode %" PRIu64 "\n"),
 				nodehdr.count,
diff --git a/repair/dir2.h b/repair/dir2.h
index 3cc1941..186633f 100644
--- a/repair/dir2.h
+++ b/repair/dir2.h
@@ -58,6 +58,14 @@ typedef struct dir2_bt_cursor  {
 	struct blkmap		*blkmap;
 } dir2_bt_cursor_t;
 
+#include "bmap.h"	/* Goes away in later refactoring */
+struct xfs_buf *
+da_read_buf(
+	xfs_mount_t	*mp,
+	int		nex,
+	bmap_ext_t	*bmp,
+	const struct xfs_buf_ops *ops);
+
 int
 process_dir2(
 	xfs_mount_t	*mp,
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
