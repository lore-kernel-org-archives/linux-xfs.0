Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 804407F59
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 14:34:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5DD9AC008
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 12:34:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6tUcqX3n1CEcNwFf for <xfs@oss.sgi.com>;
	Wed, 09 Sep 2015 12:34:16 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 12/13] xfs_repair: move common dir2 and attr_repair code to
	da_util.c
Date: Wed,  9 Sep 2015 14:34:10 -0500
Message-Id: <1441827251-13128-13-git-send-email-sandeen@sandeen.net>
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

Now that dir2.c and attr_repair.c are functionally identical,
move the duplicate code into a new file da_util.c, with da_util.h
as a header file for the common functions.

Last step will be to fix up comments and printfs' to be appropriate
for code that checks both dirs and attrs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/Makefile      |    6 +-
 repair/attr_repair.c |  617 +-------------------------------------------
 repair/da_util.c     |  701 ++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/da_util.h     |   82 ++++++
 repair/dir2.c        |  649 +---------------------------------------------
 repair/dir2.h        |   49 ----
 6 files changed, 801 insertions(+), 1303 deletions(-)
 create mode 100644 repair/da_util.c
 create mode 100644 repair/da_util.h

diff --git a/repair/Makefile b/repair/Makefile
index 6d84ade..251722b 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -10,11 +10,11 @@ LSRCFILES = README
 LTCOMMAND = xfs_repair
 
 HFILES = agheader.h attr_repair.h avl.h avl64.h bmap.h btree.h \
-	dinode.h dir2.h err_protos.h globals.h incore.h protos.h rt.h \
-	progress.h scan.h versions.h prefetch.h threads.h
+	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
+	rt.h progress.h scan.h versions.h prefetch.h threads.h
 
 CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
-	dino_chunks.c dinode.c dir2.c globals.c incore.c \
+	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
 	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
 	progress.c prefetch.c rt.c sb.c scan.c threads.c \
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 0804a22..0d3b7a5 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -24,6 +24,7 @@
 #include "bmap.h"
 #include "protos.h"
 #include "dir2.h"
+#include "da_util.h"
 
 static int xfs_acl_valid(struct xfs_mount *mp, struct xfs_acl *daclp);
 static int xfs_mac_valid(xfs_mac_label_t *lp);
@@ -39,43 +40,6 @@ static int xfs_mac_valid(xfs_mac_label_t *lp);
 typedef unsigned char	da_freemap_t;
 
 /*
- * the cursor gets passed up and down the da btree processing
- * routines.  The interior block processing routines use the
- * cursor to determine if the pointers to and from the preceding
- * and succeeding sibling blocks are ok and whether the values in
- * the current block are consistent with the entries in the parent
- * nodes.  When a block is traversed, a parent-verification routine
- * is called to verify if the next logical entry in the next level up
- * is consistent with the greatest hashval in the next block of the
- * current level.  The verification routine is itself recursive and
- * calls itself if it has to traverse an interior block to get
- * the next logical entry.  The routine recurses upwards through
- * the tree until it finds a block where it can simply step to
- * the next entry.  The hashval in that entry should be equal to
- * the hashval being passed to it (the greatest hashval in the block
- * that the entry points to).  If that isn't true, then the tree
- * is blown and we need to trash it, salvage and trash it, or fix it.
- * Currently, we just trash it.
- */
-typedef struct da_level_state  {
-	xfs_buf_t	*bp;		/* block bp */
-	xfs_dablk_t	bno;		/* file block number */
-	xfs_dahash_t	hashval;	/* last verified hashval */
-	int		index;		/* current index in block */
-	int		dirty;		/* is buffer dirty ? (1 == yes) */
-} da_level_state_t;
-
-typedef struct da_bt_cursor  {
-	int			active;	/* highest level in tree (# levels-1) */
-	xfs_ino_t		ino;
-	xfs_dablk_t		greatest_bno;
-	xfs_dinode_t		*dip;
-	da_level_state_t	level[XFS_DA_NODE_MAXDEPTH];
-	struct blkmap		*blkmap;
-} da_bt_cursor_t;
-
-
-/*
  * Allocate a freespace map for directory or attr leaf blocks (1 bit per byte)
  * 1 == used, 0 == free.
  */
@@ -127,577 +91,6 @@ set_da_freemap(xfs_mount_t *mp, da_freemap_t *map, int start, int stop)
 }
 
 /*
- * walk tree from root to the left-most leaf block reading in
- * blocks and setting up cursor.  passes back file block number of the
- * left-most leaf block if successful (bno).  returns 1 if successful,
- * 0 if unsuccessful.
- */
-static int
-traverse_int_dablock(xfs_mount_t	*mp,
-		da_bt_cursor_t		*da_cursor,
-		xfs_dablk_t		*rbno,
-		int			whichfork)
-{
-	bmap_ext_t		*bmp;
-	xfs_dablk_t		bno;
-	int			i;
-	int			nex;
-	xfs_da_intnode_t	*node;
-	bmap_ext_t		lbmp;
-	xfs_fsblock_t		fsbno;
-	xfs_buf_t		*bp;
-	struct xfs_da_geometry	*geo;
-	struct xfs_da_node_entry *btree;
-	struct xfs_da3_icnode_hdr nodehdr;
-
-	geo = mp->m_attr_geo;
-
-	/*
-	 * traverse down left-side of tree until we hit the
-	 * left-most leaf block setting up the btree cursor along
-	 * the way.
-	 */
-	bno = 0;
-	i = -1;
-	node = NULL;
-	da_cursor->active = 0;
-
-	do {
-		/*
-		 * read in each block along the way and set up cursor
-		 */
-		nex = blkmap_getn(da_cursor->blkmap, bno,
-				geo->fsbcount, &bmp, &lbmp);
-
-		if (nex == 0)
-			goto error_out;
-
-		bp = da_read_buf(mp, nex, bmp, &xfs_da3_node_buf_ops);
-		if (bmp != &lbmp)
-			free(bmp);
-
-		if (!bp) {
-			do_warn(
-	_("can't read block %u (fsbno %" PRIu64 ") for attrbute fork of inode %" PRIu64 "\n"),
-					bno, fsbno, da_cursor->ino);
-			goto error_out;
-		}
-
-		node = bp->b_addr;
-		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
-
-		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
-		    nodehdr.magic != XFS_DA3_NODE_MAGIC) {
-			do_warn(_("bad dir/attr magic number in inode %" PRIu64 ", "
-				  "file bno = %u, fsbno = %" PRIu64 "\n"),
-				da_cursor->ino, bno, fsbno);
-			libxfs_putbuf(bp);
-			goto error_out;
-		}
-
-		/* corrupt node; rebuild the dir. */
-		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
-			libxfs_putbuf(bp);
-			do_warn(
-_("corrupt tree block %u for directory inode %" PRIu64 "\n"),
-				bno, da_cursor->ino);
-			goto error_out;
-		}
-
-		btree = M_DIROPS(mp)->node_tree_p(node);
-		if (nodehdr.count > geo->node_ents) {
-			do_warn(_("bad record count in inode %" PRIu64 ", "
-				  "count = %d, max = %d\n"),
-				da_cursor->ino, nodehdr.count, geo->node_ents);
-			libxfs_putbuf(bp);
-			goto error_out;
-		}
-
-		/*
-		 * maintain level counter
-		 */
-		if (i == -1) {
-			i = da_cursor->active = nodehdr.level;
-			if (i < 1 || i >= XFS_DA_NODE_MAXDEPTH) {
-				do_warn(
-_("bad header depth for directory inode %" PRIu64 "\n"),
-					da_cursor->ino);
-				libxfs_putbuf(bp);
-				i = -1;
-				goto error_out;
-			}
-		} else {
-			if (nodehdr.level == i - 1) {
-				i--;
-			} else {
-				do_warn(_("bad attribute fork btree "
-					  "for inode %" PRIu64 "\n"),
-					da_cursor->ino);
-				libxfs_putbuf(bp);
-				goto error_out;
-			}
-		}
-
-		da_cursor->level[i].hashval = be32_to_cpu(btree[0].hashval);
-		da_cursor->level[i].bp = bp;
-		da_cursor->level[i].bno = bno;
-		da_cursor->level[i].index = 0;
-
-		/*
-		 * set up new bno for next level down
-		 */
-		bno = be32_to_cpu(btree[0].before);
-	} while (node != NULL && i > 1);
-
-	/*
-	 * now return block number and get out
-	 */
-	*rbno = da_cursor->level[0].bno = bno;
-	return(1);
-
-error_out:
-	while (i > 1 && i <= da_cursor->active) {
-		libxfs_putbuf(da_cursor->level[i].bp);
-		i++;
-	}
-
-	return(0);
-}
-
-/*
- * blow out buffer for this level and all the rest above as well
- * if error == 0, we are not expecting to encounter any unreleased
- * buffers (e.g. if we do, it's a mistake).  if error == 1, we're
- * in an error-handling case so unreleased buffers may exist.
- */
-static void
-release_da_cursor_int(xfs_mount_t	*mp,
-			da_bt_cursor_t	*cursor,
-			int		prev_level,
-			int		error)
-{
-	int	level = prev_level + 1;
-
-	if (cursor->level[level].bp != NULL)  {
-		if (!error)  {
-			do_warn(_("release_da_cursor_int got unexpected "
-				  "non-null bp, dabno = %u\n"),
-				cursor->level[level].bno);
-		}
-		ASSERT(error != 0);
-
-		libxfs_putbuf(cursor->level[level].bp);
-		cursor->level[level].bp = NULL;
-	}
-
-	if (level < cursor->active)
-		release_da_cursor_int(mp, cursor, level, error);
-
-	return;
-}
-
-static void
-release_da_cursor(xfs_mount_t	*mp,
-		da_bt_cursor_t	*cursor,
-		int		prev_level)
-{
-	release_da_cursor_int(mp, cursor, prev_level, 0);
-}
-
-static void
-err_release_da_cursor(xfs_mount_t	*mp,
-			da_bt_cursor_t	*cursor,
-			int		prev_level)
-{
-	release_da_cursor_int(mp, cursor, prev_level, 1);
-}
-
-/*
- * make sure that all entries in all blocks along the right side of
- * of the tree are used and hashval's are consistent.  level is the
- * level of the descendent block.  returns 0 if good (even if it had
- * to be fixed up), and 1 if bad.  The right edge of the tree is
- * technically a block boundary.  this routine should be used then
- * instead of verify_da_path().
- */
-static int
-verify_final_da_path(xfs_mount_t	*mp,
-		da_bt_cursor_t		*cursor,
-		const int		p_level)
-{
-	xfs_da_intnode_t	*node;
-	xfs_dahash_t		hashval;
-	int			bad = 0;
-	int			entry;
-	int			this_level = p_level + 1;
-	struct xfs_da_node_entry *btree;
-	struct xfs_da3_icnode_hdr nodehdr;
-
-#ifdef XR_DIR_TRACE
-	fprintf(stderr, "in verify_final_da_path, this_level = %d\n",
-		this_level);
-#endif
-	/*
-	 * the index should point to the next "unprocessed" entry
-	 * in the block which should be the final (rightmost) entry
-	 */
-	entry = cursor->level[this_level].index;
-	node = cursor->level[this_level].bp->b_addr;
-	btree = M_DIROPS(mp)->node_tree_p(node);
-	M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
-
-	/*
-	 * check internal block consistency on this level -- ensure
-	 * that all entries are used, encountered and expected hashvals
-	 * match, etc.
-	 */
-	if (entry != nodehdr.count - 1) {
-		do_warn(_("directory/attribute block used/count "
-			  "inconsistency - %d/%hu\n"),
-			entry, nodehdr.count);
-		bad++;
-	}
-	/*
-	 * hash values monotonically increasing ???
-	 */
-	if (cursor->level[this_level].hashval >= 
-				be32_to_cpu(btree[entry].hashval)) {
-		do_warn(_("directory/attribute block hashvalue inconsistency, "
-			  "expected > %u / saw %u\n"),
-			cursor->level[this_level].hashval,
-			be32_to_cpu(btree[entry].hashval));
-		bad++;
-	}
-	if (nodehdr.forw != 0) {
-		do_warn(_("bad directory/attribute forward block pointer, "
-			  "expected 0, saw %u\n"),
-			nodehdr.forw);
-		bad++;
-	}
-	if (bad) {
-		do_warn(_("bad directory block in dir ino %" PRIu64 "\n"),
-			cursor->ino);
-		return(1);
-	}
-	/*
-	 * keep track of greatest block # -- that gets
-	 * us the length of the directory
-	 */
-	if (cursor->level[this_level].bno > cursor->greatest_bno)
-		cursor->greatest_bno = cursor->level[this_level].bno;
-
-	/*
-	 * ok, now check descendant block number against this level
-	 */
-	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
-#ifdef XR_DIR_TRACE
-		fprintf(stderr, "bad directory btree pointer, child bno should "
-				"be %d, block bno is %d, hashval is %u\n",
-			be16_to_cpu(btree[entry].before),
-			cursor->level[p_level].bno,
-			cursor->level[p_level].hashval);
-		fprintf(stderr, "verify_final_da_path returns 1 (bad) #1a\n");
-#endif
-		return(1);
-	}
-
-	if (cursor->level[p_level].hashval != be32_to_cpu(btree[entry].hashval)) {
-		if (!no_modify) {
-			do_warn(_("correcting bad hashval in non-leaf "
-				  "dir/attr block\n\tin (level %d) in "
-				  "inode %" PRIu64 ".\n"),
-				this_level, cursor->ino);
-			btree[entry].hashval = cpu_to_be32(
-						cursor->level[p_level].hashval);
-			cursor->level[this_level].dirty++;
-		} else {
-			do_warn(_("would correct bad hashval in non-leaf "
-				  "dir/attr block\n\tin (level %d) in "
-				  "inode %" PRIu64 ".\n"),
-				this_level, cursor->ino);
-		}
-	}
-
-	/*
-	 * Note: squirrel hashval away _before_ releasing the
-	 * buffer, preventing a use-after-free problem.
-	 */
-	hashval = be32_to_cpu(btree[entry].hashval);
-
-	/*
-	 * release/write buffer
-	 */
-	ASSERT(cursor->level[this_level].dirty == 0 ||
-		(cursor->level[this_level].dirty && !no_modify));
-
-	if (cursor->level[this_level].dirty && !no_modify)
-		libxfs_writebuf(cursor->level[this_level].bp, 0);
-	else
-		libxfs_putbuf(cursor->level[this_level].bp);
-
-	cursor->level[this_level].bp = NULL;
-
-	/*
-	 * bail out if this is the root block (top of tree)
-	 */
-	if (this_level >= cursor->active) {
-#ifdef XR_DIR_TRACE
-		fprintf(stderr, "verify_final_da_path returns 0 (ok)\n");
-#endif
-		return(0);
-	}
-	/*
-	 * set hashvalue to correctly reflect the now-validated
-	 * last entry in this block and continue upwards validation
-	 */
-	cursor->level[this_level].hashval = hashval;
-	return(verify_final_da_path(mp, cursor, this_level));
-}
-
-/*
- * Verifies the path from a descendant block up to the root.
- * Should be called when the descendant level traversal hits
- * a block boundary before crossing the boundary (reading in a new
- * block).
- *
- * the directory/attr btrees work differently to the other fs btrees.
- * each interior block contains records that are <hashval, bno>
- * pairs.  The bno is a file bno, not a filesystem bno.  The last
- * hashvalue in the block <bno> will be <hashval>.  BUT unlike
- * the freespace btrees, the *last* value in each block gets
- * propagated up the tree instead of the first value in each block.
- * that is, the interior records point to child blocks and the *greatest*
- * hash value contained by the child block is the one the block above
- * uses as the key for the child block.
- *
- * level is the level of the descendent block.  returns 0 if good,
- * and 1 if bad.  The descendant block may be a leaf block.
- *
- * the invariant here is that the values in the cursor for the
- * levels beneath this level (this_level) and the cursor index
- * for this level *must* be valid.
- *
- * that is, the hashval/bno info is accurate for all
- * DESCENDANTS and match what the node[index] information
- * for the current index in the cursor for this level.
- *
- * the index values in the cursor for the descendant level
- * are allowed to be off by one as they will reflect the
- * next entry at those levels to be processed.
- *
- * the hashvalue for the current level can't be set until
- * we hit the last entry in the block so, it's garbage
- * until set by this routine.
- *
- * bno and bp for the current block/level are always valid
- * since they have to be set so we can get a buffer for the
- * block.
- */
-static int
-verify_da_path(xfs_mount_t	*mp,
-	da_bt_cursor_t		*cursor,
-	const int		p_level)
-{
-	xfs_da_intnode_t	*node;
-	xfs_da_intnode_t	*newnode;
-	xfs_fsblock_t		fsbno;
-	xfs_dablk_t		dabno;
-	xfs_buf_t		*bp;
-	int			bad;
-	int			entry;
-	int			this_level = p_level + 1;
-	bmap_ext_t		*bmp;
-	int			nex;
-	bmap_ext_t		lbmp;
-	struct xfs_da_geometry	*geo;
-	struct xfs_da_node_entry *btree;
-	struct xfs_da3_icnode_hdr nodehdr;
-
-	geo = mp->m_attr_geo;
-
-	/*
-	 * index is currently set to point to the entry that
-	 * should be processed now in this level.
-	 */
-	entry = cursor->level[this_level].index;
-	node = cursor->level[this_level].bp->b_addr;
-	btree = M_DIROPS(mp)->node_tree_p(node);
-	M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
-
-	/*
-	 * if this block is out of entries, validate this
-	 * block and move on to the next block.
-	 * and update cursor value for said level
-	 */
-	if (entry >= nodehdr.count) {
-		/*
-		 * update the hash value for this level before
-		 * validating it.  bno value should be ok since
-		 * it was set when the block was first read in.
-		 */
-		cursor->level[this_level].hashval =
-				be32_to_cpu(btree[entry - 1].hashval);
-
-		/*
-		 * keep track of greatest block # -- that gets
-		 * us the length of the directory
-		 */
-		if (cursor->level[this_level].bno > cursor->greatest_bno)
-			cursor->greatest_bno = cursor->level[this_level].bno;
-
-		/*
-		 * validate the path for the current used-up block
-		 * before we trash it
-		 */
-		if (verify_da_path(mp, cursor, this_level))
-			return(1);
-		/*
-		 * ok, now get the next buffer and check sibling pointers
-		 */
-		dabno = nodehdr.forw;
-		ASSERT(dabno != 0);
-		nex = blkmap_getn(cursor->blkmap, dabno, geo->fsbcount,
-			&bmp, &lbmp);
-		if (nex == 0) {
-			do_warn(
-_("can't get map info for block %u of directory inode %" PRIu64 "\n"),
-				dabno, cursor->ino);
-			return(1);
-		}
-
-		fsbno = bmp[0].startblock;
-
-		bp = da_read_buf(mp, nex, bmp, &xfs_da3_node_buf_ops);
-		if (bmp != &lbmp)
-			free(bmp);
-
-		if (!bp) {
-			do_warn(
-	_("can't read block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
-				dabno, fsbno, cursor->ino);
-			return(1);
-		}
-
-		newnode = bp->b_addr;
-		btree = M_DIROPS(mp)->node_tree_p(newnode);
-		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, newnode);
-
-		/*
-		 * verify magic number and back pointer, sanity-check
-		 * entry count, verify level
-		 */
-		bad = 0;
-		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
-		    nodehdr.magic != XFS_DA3_NODE_MAGIC) {
-			do_warn(
-	_("bad magic number %x in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
-				nodehdr.magic,
-				dabno, fsbno, cursor->ino);
-			bad++;
-		}
-		if (nodehdr.back != cursor->level[this_level].bno) {
-			do_warn(
-	_("bad back pointer in block %u (%"PRIu64 ") for directory inode %" PRIu64 "\n"),
-				dabno, fsbno, cursor->ino);
-			bad++;
-		}
-		if (nodehdr.count > geo->node_ents) {
-			do_warn(
-	_("entry count %d too large in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
-				nodehdr.count,
-				dabno, fsbno, cursor->ino);
-			bad++;
-		}
-		if (nodehdr.level != this_level) {
-			do_warn(
-	_("bad level %d in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
-				nodehdr.level,
-				dabno, fsbno, cursor->ino);
-			bad++;
-		}
-		if (bad) {
-#ifdef XR_DIR_TRACE
-			fprintf(stderr, "verify_da_path returns 1 (bad) #4\n");
-#endif
-			libxfs_putbuf(bp);
-			return(1);
-		}
-
-		/*
-		 * update cursor, write out the *current* level if
-		 * required.  don't write out the descendant level
-		 */
-		ASSERT(cursor->level[this_level].dirty == 0 ||
-			(cursor->level[this_level].dirty && !no_modify));
-
-		/*
-		 * If block looks ok but CRC didn't match, make sure to
-		 * recompute it.
-		 */
-		if (!no_modify &&
-		    cursor->level[this_level].bp->b_error == -EFSBADCRC)
-			cursor->level[this_level].dirty = 1;
-
-		if (cursor->level[this_level].dirty && !no_modify)
-			libxfs_writebuf(cursor->level[this_level].bp, 0);
-		else
-			libxfs_putbuf(cursor->level[this_level].bp);
-
-		/* switch cursor to point at the new buffer we just read */
-		cursor->level[this_level].bp = bp;
-		cursor->level[this_level].dirty = 0;
-		cursor->level[this_level].bno = dabno;
-		cursor->level[this_level].hashval =
-					be32_to_cpu(btree[0].hashval);
-		entry = cursor->level[this_level].index = 0;
-	}
-	/*
-	 * ditto for block numbers
-	 */
-	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
-#ifdef XR_DIR_TRACE
-		fprintf(stderr, "bad directory btree pointer, child bno "
-			"should be %d, block bno is %d, hashval is %u\n",
-			be32_to_cpu(btree[entry].before),
-			cursor->level[p_level].bno,
-			cursor->level[p_level].hashval);
-		fprintf(stderr, "verify_da_path returns 1 (bad) #1a\n");
-#endif
-		return(1);
-	}
-	/*
-	 * ok, now validate last hashvalue in the descendant
-	 * block against the hashval in the current entry
-	 */
-	if (cursor->level[p_level].hashval !=
-				be32_to_cpu(btree[entry].hashval)) {
-		if (!no_modify) {
-			do_warn(_("correcting bad hashval in interior "
-				  "dir/attr block\n\tin (level %d) in "
-				  "inode %" PRIu64 ".\n"),
-				this_level, cursor->ino);
-			btree[entry].hashval = cpu_to_be32(
-						cursor->level[p_level].hashval);
-			cursor->level[this_level].dirty++;
-		} else {
-			do_warn(_("would correct bad hashval in interior "
-				  "dir/attr block\n\tin (level %d) in "
-				  "inode %" PRIu64 ".\n"),
-				this_level, cursor->ino);
-		}
-	}
-	/*
-	 * increment index for this level to point to next entry
-	 * (which should point to the next descendant block)
-	 */
-	cursor->level[this_level].index++;
-#ifdef XR_DIR_TRACE
-	fprintf(stderr, "verify_da_path returns 0 (ok)\n");
-#endif
-	return(0);
-}
-
-/*
  * For attribute repair, there are 3 formats to worry about. First, is
  * shortform attributes which reside in the inode. Second is the leaf
  * form, and lastly the btree. Much of this models after the directory
@@ -1435,9 +828,11 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		prev_bno = da_bno;
 		da_bno = leafhdr.forw;
 
-		if (da_bno != 0 && verify_da_path(mp, da_cursor, 0))  {
-			libxfs_putbuf(bp);
-			goto error_out;
+		if (da_bno != 0) {
+			if (verify_da_path(mp, da_cursor, 0, XFS_ATTR_FORK)) {
+				libxfs_putbuf(bp);
+				goto error_out;
+			}
 		}
 
 		current_hashval = greatest_hashval;
diff --git a/repair/da_util.c b/repair/da_util.c
new file mode 100644
index 0000000..e5d5535
--- /dev/null
+++ b/repair/da_util.c
@@ -0,0 +1,701 @@
+/*
+ * Copyright (c) 2015 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.
+ */
+
+/* Various utilities for repair of directory and attribute metadata */
+
+#include "libxfs.h"
+#include "globals.h"
+#include "err_protos.h"
+#include "bmap.h"
+#include "da_util.h"
+
+/*
+ * takes a name and length (name need not be null-terminated)
+ * and returns 1 if the name contains a '/' or a \0, returns 0
+ * otherwise
+ */
+int
+namecheck(char *name, int length)
+{
+	char *c;
+	int i;
+
+	ASSERT(length < MAXNAMELEN);
+
+	for (c = name, i = 0; i < length; i++, c++) {
+		if (*c == '/' || *c == '\0')
+			return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * the cursor gets passed up and down the da btree processing
+ * routines.  The interior block processing routines use the
+ * cursor to determine if the pointers to and from the preceding
+ * and succeeding sibling blocks are ok and whether the values in
+ * the current block are consistent with the entries in the parent
+ * nodes.  When a block is traversed, a parent-verification routine
+ * is called to verify if the next logical entry in the next level up
+ * is consistent with the greatest hashval in the next block of the
+ * current level.  The verification routine is itself recursive and
+ * calls itself if it has to traverse an interior block to get
+ * the next logical entry.  The routine recurses upwards through
+ * the tree until it finds a block where it can simply step to
+ * the next entry.  The hashval in that entry should be equal to
+ * the hashval being passed to it (the greatest hashval in the block
+ * that the entry points to).  If that isn't true, then the tree
+ * is blown and we need to trash it, salvage and trash it, or fix it.
+ * Currently, we just trash it.
+ */
+
+/*
+ * Multibuffer handling.
+ * V2 directory blocks can be noncontiguous, needing multiple buffers.
+ */
+struct xfs_buf *
+da_read_buf(
+	xfs_mount_t	*mp,
+	int		nex,
+	bmap_ext_t	*bmp,
+	const struct xfs_buf_ops *ops)
+{
+#define MAP_ARRAY_SZ 4
+	struct xfs_buf_map map_array[MAP_ARRAY_SZ];
+	struct xfs_buf_map *map;
+	struct xfs_buf	*bp;
+	int		i;
+
+	if (nex > MAP_ARRAY_SZ) {
+		map = calloc(nex, sizeof(*map));
+		if (map == NULL) {
+			do_error(_("couldn't malloc dir2 buffer list\n"));
+			exit(1);
+		}
+	} else {
+		/* common case avoids calloc/free */
+		map = map_array;
+	}
+	for (i = 0; i < nex; i++) {
+		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, bmp[i].startblock);
+		map[i].bm_len = XFS_FSB_TO_BB(mp, bmp[i].blockcount);
+	}
+	bp = libxfs_readbuf_map(mp->m_dev, map, nex, 0, ops);
+	if (map != map_array)
+		free(map);
+	return bp;
+}
+
+/*
+ * walk tree from root to the left-most leaf block reading in
+ * blocks and setting up cursor.  passes back file block number of the
+ * left-most leaf block if successful (bno).  returns 1 if successful,
+ * 0 if unsuccessful.
+ */
+int
+traverse_int_dablock(
+	xfs_mount_t		*mp,
+	da_bt_cursor_t		*da_cursor,
+	xfs_dablk_t		*rbno,
+	int			whichfork)
+{
+	bmap_ext_t		*bmp;
+	xfs_dablk_t		bno;
+	struct xfs_buf		*bp;
+	int			i;
+	int			nex;
+	xfs_da_intnode_t	*node;
+	bmap_ext_t		lbmp;
+	struct xfs_da_geometry	*geo;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
+
+	if (whichfork == XFS_DATA_FORK) {
+		geo = mp->m_dir_geo;
+		bno = geo->leafblk;
+	} else {
+		geo = mp->m_attr_geo;
+		bno = 0;
+	}
+
+	/*
+	 * traverse down left-side of tree until we hit the
+	 * left-most leaf block setting up the btree cursor along
+	 * the way.
+	 */
+	i = -1;
+	node = NULL;
+	da_cursor->active = 0;
+
+	do {
+		/*
+		 * read in each block along the way and set up cursor
+		 */
+		nex = blkmap_getn(da_cursor->blkmap, bno,
+				geo->fsbcount, &bmp, &lbmp);
+
+		if (nex == 0)
+			goto error_out;
+
+		bp = da_read_buf(mp, nex, bmp, &xfs_da3_node_buf_ops);
+		if (bmp != &lbmp)
+			free(bmp);
+
+		if (!bp) {
+			do_warn(
+_("can't read block %u for directory inode %" PRIu64 "\n"),
+				bno, da_cursor->ino);
+			goto error_out;
+		}
+
+		node = bp->b_addr;
+		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
+
+		if (whichfork == XFS_DATA_FORK &&
+		    (nodehdr.magic == XFS_DIR2_LEAFN_MAGIC ||
+		    nodehdr.magic == XFS_DIR3_LEAFN_MAGIC)) {
+			if (i != -1) {
+				do_warn(
+_("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
+					da_cursor->ino, bno);
+			}
+			*rbno = 0;
+			libxfs_putbuf(bp);
+			return 1;
+		}
+
+		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
+		    nodehdr.magic != XFS_DA3_NODE_MAGIC) {
+			do_warn(
+_("bad dir magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
+					nodehdr.magic,
+					da_cursor->ino, bno);
+			libxfs_putbuf(bp);
+			goto error_out;
+		}
+
+		/* corrupt node; rebuild the dir. */
+		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
+			libxfs_putbuf(bp);
+			do_warn(
+_("corrupt tree block %u for directory inode %" PRIu64 "\n"),
+				bno, da_cursor->ino);
+			goto error_out;
+		}
+
+		btree = M_DIROPS(mp)->node_tree_p(node);
+		if (nodehdr.count > geo->node_ents) {
+			do_warn(
+_("bad record count in inode %" PRIu64 ", count = %d, max = %d\n"),
+				da_cursor->ino, nodehdr.count, geo->node_ents);
+			libxfs_putbuf(bp);
+			goto error_out;
+		}
+
+		/*
+		 * maintain level counter
+		 */
+		if (i == -1) {
+			i = da_cursor->active = nodehdr.level;
+			if (i < 1 || i >= XFS_DA_NODE_MAXDEPTH) {
+				do_warn(
+_("bad header depth for directory inode %" PRIu64 "\n"),
+					da_cursor->ino);
+				libxfs_putbuf(bp);
+				i = -1;
+				goto error_out;
+			}
+		} else {
+			if (nodehdr.level == i - 1) {
+				i--;
+			} else {
+				do_warn(
+_("bad directory btree for directory inode %" PRIu64 "\n"),
+					da_cursor->ino);
+				libxfs_putbuf(bp);
+				goto error_out;
+			}
+		}
+
+		da_cursor->level[i].hashval = be32_to_cpu(btree[0].hashval);
+		da_cursor->level[i].bp = bp;
+		da_cursor->level[i].bno = bno;
+		da_cursor->level[i].index = 0;
+
+		/*
+		 * set up new bno for next level down
+		 */
+		bno = be32_to_cpu(btree[0].before);
+	} while (node != NULL && i > 1);
+
+	/*
+	 * now return block number and get out
+	 */
+	*rbno = da_cursor->level[0].bno = bno;
+	return 1;
+
+error_out:
+	while (i > 1 && i <= da_cursor->active) {
+		libxfs_putbuf(da_cursor->level[i].bp);
+		i++;
+	}
+
+	return 0;
+}
+
+/*
+ * blow out buffer for this level and all the rest above as well
+ * if error == 0, we are not expecting to encounter any unreleased
+ * buffers (e.g. if we do, it's a mistake).  if error == 1, we're
+ * in an error-handling case so unreleased buffers may exist.
+ */
+static void
+release_da_cursor_int(
+	xfs_mount_t	*mp,
+	da_bt_cursor_t	*cursor,
+	int		prev_level,
+	int		error)
+{
+	int		level = prev_level + 1;
+
+	if (cursor->level[level].bp != NULL)  {
+		if (!error)  {
+			do_warn(_("release_da_cursor_int got unexpected "
+				  "non-null bp, dabno = %u\n"),
+				cursor->level[level].bno);
+		}
+		ASSERT(error != 0);
+
+		libxfs_putbuf(cursor->level[level].bp);
+		cursor->level[level].bp = NULL;
+	}
+
+	if (level < cursor->active)
+		release_da_cursor_int(mp, cursor, level, error);
+
+	return;
+}
+
+void
+release_da_cursor(
+	xfs_mount_t	*mp,
+	da_bt_cursor_t	*cursor,
+	int		prev_level)
+{
+	release_da_cursor_int(mp, cursor, prev_level, 0);
+}
+
+void
+err_release_da_cursor(
+	xfs_mount_t	*mp,
+	da_bt_cursor_t	*cursor,
+	int		prev_level)
+{
+	release_da_cursor_int(mp, cursor, prev_level, 1);
+}
+
+/*
+ * make sure that all entries in all blocks along the right side of
+ * of the tree are used and hashval's are consistent.  level is the
+ * level of the descendent block.  returns 0 if good (even if it had
+ * to be fixed up), and 1 if bad.  The right edge of the tree is
+ * technically a block boundary.  This routine should be used then
+ * instead of verify_da_path().
+ */
+int
+verify_final_da_path(
+	xfs_mount_t		*mp,
+	da_bt_cursor_t		*cursor,
+	const int		p_level)
+{
+	xfs_da_intnode_t	*node;
+	xfs_dahash_t		hashval;
+	int			bad = 0;
+	int			entry;
+	int			this_level = p_level + 1;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
+
+#ifdef XR_DIR_TRACE
+	fprintf(stderr, "in verify_final_da_path, this_level = %d\n",
+		this_level);
+#endif
+
+	/*
+	 * the index should point to the next "unprocessed" entry
+	 * in the block which should be the final (rightmost) entry
+	 */
+	entry = cursor->level[this_level].index;
+	node = cursor->level[this_level].bp->b_addr;
+	btree = M_DIROPS(mp)->node_tree_p(node);
+	M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
+
+	/*
+	 * check internal block consistency on this level -- ensure
+	 * that all entries are used, encountered and expected hashvals
+	 * match, etc.
+	 */
+	if (entry != nodehdr.count - 1) {
+		do_warn(
+		_("directory block used/count inconsistency - %d/%hu\n"),
+			entry, nodehdr.count);
+		bad++;
+	}
+	/*
+	 * hash values monotonically increasing ???
+	 */
+	if (cursor->level[this_level].hashval >=
+				be32_to_cpu(btree[entry].hashval)) {
+		do_warn(_("directory/attribute block hashvalue inconsistency, "
+			  "expected > %u / saw %u\n"),
+			cursor->level[this_level].hashval,
+			be32_to_cpu(btree[entry].hashval));
+		bad++;
+	}
+	if (nodehdr.forw != 0) {
+		do_warn(_("bad directory/attribute forward block pointer, "
+			  "expected 0, saw %u\n"),
+			nodehdr.forw);
+		bad++;
+	}
+	if (bad) {
+		do_warn(_("bad directory block in inode %" PRIu64 "\n"), cursor->ino);
+		return 1;
+	}
+	/*
+	 * keep track of greatest block # -- that gets
+	 * us the length of the directory
+	 */
+	if (cursor->level[this_level].bno > cursor->greatest_bno)
+		cursor->greatest_bno = cursor->level[this_level].bno;
+
+	/*
+	 * ok, now check descendant block number against this level
+	 */
+	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
+#ifdef XR_DIR_TRACE
+		fprintf(stderr, "bad directory btree pointer, child bno should "
+				"be %d, block bno is %d, hashval is %u\n",
+			be16_to_cpu(btree[entry].before),
+			cursor->level[p_level].bno,
+			cursor->level[p_level].hashval);
+		fprintf(stderr, "verify_final_da_path returns 1 (bad) #1a\n");
+#endif
+		return 1;
+	}
+
+	if (cursor->level[p_level].hashval !=
+				be32_to_cpu(btree[entry].hashval)) {
+		if (!no_modify) {
+			do_warn(
+_("correcting bad hashval in non-leaf dir block\n"
+ "\tin (level %d) in inode %" PRIu64 ".\n"),
+				this_level, cursor->ino);
+			btree[entry].hashval = cpu_to_be32(
+						cursor->level[p_level].hashval);
+			cursor->level[this_level].dirty++;
+		} else {
+			do_warn(
+_("would correct bad hashval in non-leaf dir block\n"
+ "\tin (level %d) in inode %" PRIu64 ".\n"),
+				this_level, cursor->ino);
+		}
+	}
+
+	/*
+	 * Note: squirrel hashval away _before_ releasing the
+	 * buffer, preventing a use-after-free problem.
+	 */
+	hashval = be32_to_cpu(btree[entry].hashval);
+
+	/*
+	 * release/write buffer
+	 */
+	ASSERT(cursor->level[this_level].dirty == 0 ||
+		(cursor->level[this_level].dirty && !no_modify));
+
+	if (cursor->level[this_level].dirty && !no_modify)
+		libxfs_writebuf(cursor->level[this_level].bp, 0);
+	else
+		libxfs_putbuf(cursor->level[this_level].bp);
+
+	cursor->level[this_level].bp = NULL;
+
+	/*
+	 * bail out if this is the root block (top of tree)
+	 */
+	if (this_level >= cursor->active) {
+#ifdef XR_DIR_TRACE
+		fprintf(stderr, "verify_final_da_path returns 0 (ok)\n");
+#endif
+		return 0;
+	}
+	/*
+	 * set hashvalue to correctly reflect the now-validated
+	 * last entry in this block and continue upwards validation
+	 */
+	cursor->level[this_level].hashval = hashval;
+
+	return verify_final_da_path(mp, cursor, this_level);
+}
+
+/*
+ * Verifies the path from a descendant block up to the root.
+ * Should be called when the descendant level traversal hits
+ * a block boundary before crossing the boundary (reading in a new
+ * block).
+ *
+ * the directory/attr btrees work differently to the other fs btrees.
+ * each interior block contains records that are <hashval, bno>
+ * pairs.  The bno is a file bno, not a filesystem bno.  The last
+ * hashvalue in the block <bno> will be <hashval>.  BUT unlike
+ * the freespace btrees, the *last* value in each block gets
+ * propagated up the tree instead of the first value in each block.
+ * that is, the interior records point to child blocks and the *greatest*
+ * hash value contained by the child block is the one the block above
+ * uses as the key for the child block.
+ *
+ * level is the level of the descendent block.  returns 0 if good,
+ * and 1 if bad.  The descendant block may be a leaf block.
+ *
+ * the invariant here is that the values in the cursor for the
+ * levels beneath this level (this_level) and the cursor index
+ * for this level *must* be valid.
+ *
+ * that is, the hashval/bno info is accurate for all
+ * DESCENDANTS and match what the node[index] information
+ * for the current index in the cursor for this level.
+ *
+ * the index values in the cursor for the descendant level
+ * are allowed to be off by one as they will reflect the
+ * next entry at those levels to be processed.
+ *
+ * the hashvalue for the current level can't be set until
+ * we hit the last entry in the block so, it's garbage
+ * until set by this routine.
+ *
+ * bno and bp for the current block/level are always valid
+ * since they have to be set so we can get a buffer for the
+ * block.
+ */
+int
+verify_da_path(
+	xfs_mount_t		*mp,
+	da_bt_cursor_t		*cursor,
+	const int		p_level,
+	int			whichfork)
+{
+	xfs_da_intnode_t	*node;
+	xfs_da_intnode_t	*newnode;
+	xfs_dablk_t		dabno;
+	struct xfs_buf		*bp;
+	int			bad;
+	int			entry;
+	int			this_level = p_level + 1;
+	bmap_ext_t		*bmp;
+	int			nex;
+	bmap_ext_t		lbmp;
+	struct xfs_da_geometry	*geo;
+	struct xfs_da_node_entry *btree;
+	struct xfs_da3_icnode_hdr nodehdr;
+
+	if (whichfork == XFS_DATA_FORK)
+		geo = mp->m_dir_geo;
+	else
+		geo = mp->m_attr_geo;
+
+	/*
+	 * index is currently set to point to the entry that
+	 * should be processed now in this level.
+	 */
+	entry = cursor->level[this_level].index;
+	node = cursor->level[this_level].bp->b_addr;
+	btree = M_DIROPS(mp)->node_tree_p(node);
+	M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
+
+	/*
+	 * if this block is out of entries, validate this
+	 * block and move on to the next block.
+	 * and update cursor value for said level
+	 */
+	if (entry >= nodehdr.count) {
+		/*
+		 * update the hash value for this level before
+		 * validating it.  bno value should be ok since
+		 * it was set when the block was first read in.
+		 */
+		cursor->level[this_level].hashval =
+				be32_to_cpu(btree[entry - 1].hashval);
+
+		/*
+		 * keep track of greatest block # -- that gets
+		 * us the length of the directory
+		 */
+		if (cursor->level[this_level].bno > cursor->greatest_bno)
+			cursor->greatest_bno = cursor->level[this_level].bno;
+
+		/*
+		 * validate the path for the current used-up block
+		 * before we trash it
+		 */
+		if (verify_da_path(mp, cursor, this_level, whichfork))
+			return 1;
+		/*
+		 * ok, now get the next buffer and check sibling pointers
+		 */
+		dabno = nodehdr.forw;
+		ASSERT(dabno != 0);
+		nex = blkmap_getn(cursor->blkmap, dabno, geo->fsbcount,
+			&bmp, &lbmp);
+		if (nex == 0) {
+			do_warn(
+_("can't get map info for block %u of directory inode %" PRIu64 "\n"),
+				dabno, cursor->ino);
+			return 1;
+		}
+
+		bp = da_read_buf(mp, nex, bmp, &xfs_da3_node_buf_ops);
+		if (bmp != &lbmp)
+			free(bmp);
+
+		if (!bp) {
+			do_warn(
+_("can't read block %u for directory inode %" PRIu64 "\n"),
+				dabno, cursor->ino);
+			return 1;
+		}
+
+		newnode = bp->b_addr;
+		btree = M_DIROPS(mp)->node_tree_p(newnode);
+		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, newnode);
+
+		/*
+		 * verify magic number and back pointer, sanity-check
+		 * entry count, verify level
+		 */
+		bad = 0;
+		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
+		    nodehdr.magic != XFS_DA3_NODE_MAGIC) {
+			do_warn(
+_("bad magic number %x in block %u for directory inode %" PRIu64 "\n"),
+				nodehdr.magic,
+				dabno, cursor->ino);
+			bad++;
+		}
+		if (nodehdr.back != cursor->level[this_level].bno) {
+			do_warn(
+_("bad back pointer in block %u for directory inode %" PRIu64 "\n"),
+				dabno, cursor->ino);
+			bad++;
+		}
+		if (nodehdr.count > geo->node_ents) {
+			do_warn(
+_("entry count %d too large in block %u for directory inode %" PRIu64 "\n"),
+				nodehdr.count,
+				dabno, cursor->ino);
+			bad++;
+		}
+		if (nodehdr.level != this_level) {
+			do_warn(
+_("bad level %d in block %u for directory inode %" PRIu64 "\n"),
+				nodehdr.level,
+				dabno, cursor->ino);
+			bad++;
+		}
+		if (bad) {
+#ifdef XR_DIR_TRACE
+			fprintf(stderr, "verify_da_path returns 1 (bad) #4\n");
+#endif
+			libxfs_putbuf(bp);
+			return 1;
+		}
+
+		/*
+		 * update cursor, write out the *current* level if
+		 * required.  don't write out the descendant level
+		 */
+		ASSERT(cursor->level[this_level].dirty == 0 ||
+			(cursor->level[this_level].dirty && !no_modify));
+
+		/*
+		 * If block looks ok but CRC didn't match, make sure to
+		 * recompute it.
+		 */
+		if (!no_modify &&
+		    cursor->level[this_level].bp->b_error == -EFSBADCRC)
+			cursor->level[this_level].dirty = 1;
+
+		if (cursor->level[this_level].dirty && !no_modify)
+			libxfs_writebuf(cursor->level[this_level].bp, 0);
+		else
+			libxfs_putbuf(cursor->level[this_level].bp);
+
+		/* switch cursor to point at the new buffer we just read */
+		cursor->level[this_level].bp = bp;
+		cursor->level[this_level].dirty = 0;
+		cursor->level[this_level].bno = dabno;
+		cursor->level[this_level].hashval =
+					be32_to_cpu(btree[0].hashval);
+
+		entry = cursor->level[this_level].index = 0;
+	}
+	/*
+	 * ditto for block numbers
+	 */
+	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
+#ifdef XR_DIR_TRACE
+		fprintf(stderr, "bad directory btree pointer, child bno "
+			"should be %d, block bno is %d, hashval is %u\n",
+			be32_to_cpu(btree[entry].before),
+			cursor->level[p_level].bno,
+			cursor->level[p_level].hashval);
+		fprintf(stderr, "verify_da_path returns 1 (bad) #1a\n");
+#endif
+		return 1;
+	}
+	/*
+	 * ok, now validate last hashvalue in the descendant
+	 * block against the hashval in the current entry
+	 */
+	if (cursor->level[p_level].hashval !=
+				be32_to_cpu(btree[entry].hashval)) {
+		if (!no_modify) {
+			do_warn(
+_("correcting bad hashval in interior dir block\n"
+  "\tin (level %d) in inode %" PRIu64 ".\n"),
+				this_level, cursor->ino);
+			btree[entry].hashval = cpu_to_be32(
+						cursor->level[p_level].hashval);
+			cursor->level[this_level].dirty++;
+		} else {
+			do_warn(
+_("would correct bad hashval in interior dir block\n"
+  "\tin (level %d) in inode %" PRIu64 ".\n"),
+				this_level, cursor->ino);
+		}
+	}
+	/*
+	 * increment index for this level to point to next entry
+	 * (which should point to the next descendant block)
+	 */
+	cursor->level[this_level].index++;
+#ifdef XR_DIR_TRACE
+	fprintf(stderr, "verify_da_path returns 0 (ok)\n");
+#endif
+	return 0;
+}
diff --git a/repair/da_util.h b/repair/da_util.h
new file mode 100644
index 0000000..7971d63
--- /dev/null
+++ b/repair/da_util.h
@@ -0,0 +1,82 @@
+/*
+ * Copyright (c) 2015 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef _XR_DA_UTIL_H
+#define	_XR_DA_UTIL_H
+
+struct da_level_state  {
+	xfs_buf_t	*bp;		/* block bp */
+	xfs_dablk_t	bno;		/* file block number */
+	xfs_dahash_t	hashval;	/* last verified hashval */
+	int		index;		/* current index in block */
+	int		dirty;		/* is buffer dirty ? (1 == yes) */
+};
+
+typedef struct da_bt_cursor {
+	int			active;	/* highest level in tree (# levels-1) */
+	xfs_ino_t		ino;
+	xfs_dablk_t		greatest_bno;
+	xfs_dinode_t		*dip;
+	struct da_level_state	level[XFS_DA_NODE_MAXDEPTH];
+	struct blkmap		*blkmap;
+} da_bt_cursor_t;
+
+int
+namecheck(
+	char		*name,
+	int		length);
+
+struct xfs_buf *
+da_read_buf(
+	xfs_mount_t	*mp,
+	int		nex,
+	bmap_ext_t	*bmp,
+	const struct xfs_buf_ops *ops);
+
+void
+release_da_cursor(
+	xfs_mount_t	*mp,
+	da_bt_cursor_t	*cursor,
+	int		prev_level);
+
+void
+err_release_da_cursor(
+	xfs_mount_t	*mp,
+	da_bt_cursor_t	*cursor,
+	int		prev_level);
+
+int
+traverse_int_dablock(
+	xfs_mount_t	*mp,
+	da_bt_cursor_t	*da_cursor,
+	xfs_dablk_t	*rbno,
+	int		whichfork);
+
+int
+verify_da_path(
+	xfs_mount_t	*mp,
+	da_bt_cursor_t	*cursor,
+	const int	p_level,
+	int		whichfork);
+
+int
+verify_final_da_path(
+	xfs_mount_t	*mp,
+	da_bt_cursor_t	*cursor,
+	const int	p_level);
+#endif	/* _XR_DA_UTIL_H */
diff --git a/repair/dir2.c b/repair/dir2.c
index 7b47a9e..492b3e7 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -24,6 +24,7 @@
 #include "dinode.h"
 #include "dir2.h"
 #include "bmap.h"
+#include "da_util.h"
 #include "prefetch.h"
 #include "progress.h"
 
@@ -68,638 +69,6 @@ dir2_is_badino(
 }
 
 /*
- * takes a name and length (name need not be null-terminated)
- * and returns 1 if the name contains a '/' or a \0, returns 0
- * otherwise
- */
-int
-namecheck(char *name, int length)
-{
-	char *c;
-	int i;
-
-	ASSERT(length < MAXNAMELEN);
-
-	for (c = name, i = 0; i < length; i++, c++)  {
-		if (*c == '/' || *c == '\0')
-			return(1);
-	}
-
-	return(0);
-}
-
-/*
- * Multibuffer handling.
- * V2 directory blocks can be noncontiguous, needing multiple buffers.
- */
-struct xfs_buf *
-da_read_buf(
-	xfs_mount_t	*mp,
-	int		nex,
-	bmap_ext_t	*bmp,
-	const struct xfs_buf_ops *ops)
-{
-#define MAP_ARRAY_SZ 4
-	struct xfs_buf_map map_array[MAP_ARRAY_SZ];
-	struct xfs_buf_map *map;
-	struct xfs_buf	*bp;
-	int		i;
-
-	if (nex > MAP_ARRAY_SZ) {
-		map = calloc(nex, sizeof(*map));
-		if (map == NULL) {
-			do_error(_("couldn't malloc dir2 buffer list\n"));
-			exit(1);
-		}
-	} else {
-		/* common case avoids calloc/free */
-		map = map_array;
-	}
-	for (i = 0; i < nex; i++) {
-		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, bmp[i].startblock);
-		map[i].bm_len = XFS_FSB_TO_BB(mp, bmp[i].blockcount);
-	}
-	bp = libxfs_readbuf_map(mp->m_dev, map, nex, 0, ops);
-	if (map != map_array)
-		free(map);
-	return bp;
-}
-
-/*
- * walk tree from root to the left-most leaf block reading in
- * blocks and setting up cursor.  passes back file block number of the
- * left-most leaf block if successful (bno).  returns 1 if successful,
- * 0 if unsuccessful.
- */
-static int
-traverse_int_dir2block(xfs_mount_t	*mp,
-		dir2_bt_cursor_t	*da_cursor,
-		xfs_dablk_t		*rbno)
-{
-	bmap_ext_t		*bmp;
-	xfs_dablk_t		bno;
-	struct xfs_buf		*bp;
-	int			i;
-	int			nex;
-	xfs_da_intnode_t	*node;
-	bmap_ext_t		lbmp;
-	struct xfs_da_geometry	*geo;
-	struct xfs_da_node_entry *btree;
-	struct xfs_da3_icnode_hdr nodehdr;
-
-	geo = mp->m_dir_geo;
-
-	/*
-	 * traverse down left-side of tree until we hit the
-	 * left-most leaf block setting up the btree cursor along
-	 * the way.
-	 */
-	bno = mp->m_dir_geo->leafblk;
-	i = -1;
-	node = NULL;
-	da_cursor->active = 0;
-
-	do {
-		/*
-		 * read in each block along the way and set up cursor
-		 */
-		nex = blkmap_getn(da_cursor->blkmap, bno,
-				geo->fsbcount, &bmp, &lbmp);
-
-		if (nex == 0)
-			goto error_out;
-
-		bp = da_read_buf(mp, nex, bmp, &xfs_da3_node_buf_ops);
-		if (bmp != &lbmp)
-			free(bmp);
-		if (!bp) {
-			do_warn(
-_("can't read block %u for directory inode %" PRIu64 "\n"),
-				bno, da_cursor->ino);
-			goto error_out;
-		}
-
-		node = bp->b_addr;
-		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
-
-		if (nodehdr.magic == XFS_DIR2_LEAFN_MAGIC ||
-		    nodehdr.magic == XFS_DIR3_LEAFN_MAGIC) {
-			if ( i != -1 ) {
-				do_warn(
-_("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
-					da_cursor->ino, bno);
-			}
-			*rbno = 0;
-			libxfs_putbuf(bp);
-			return(1);
-		}
-
-		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
-		    nodehdr.magic != XFS_DA3_NODE_MAGIC) {
-			libxfs_putbuf(bp);
-			do_warn(
-_("bad dir magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
-					nodehdr.magic,
-					da_cursor->ino, bno);
-			goto error_out;
-		}
-		/* corrupt node; rebuild the dir. */
-		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
-			libxfs_putbuf(bp);
-			do_warn(
-_("corrupt tree block %u for directory inode %" PRIu64 "\n"),
-				bno, da_cursor->ino);
-			goto error_out;
-		}
-		btree = M_DIROPS(mp)->node_tree_p(node);
-		if (nodehdr.count > geo->node_ents) {
-			do_warn(
-_("bad record count in inode %" PRIu64 ", count = %d, max = %d\n"),
-				da_cursor->ino, nodehdr.count, geo->node_ents);
-			libxfs_putbuf(bp);
-			goto error_out;
-		}
-		/*
-		 * maintain level counter
-		 */
-		if (i == -1) {
-			i = da_cursor->active = nodehdr.level;
-			if (i < 1 || i >= XFS_DA_NODE_MAXDEPTH) {
-				do_warn(
-_("bad header depth for directory inode %" PRIu64 "\n"),
-					da_cursor->ino);
-				libxfs_putbuf(bp);
-				i = -1;
-				goto error_out;
-			}
-		} else {
-			if (nodehdr.level == i - 1) {
-				i--;
-			} else {
-				do_warn(
-_("bad directory btree for directory inode %" PRIu64 "\n"),
-					da_cursor->ino);
-				libxfs_putbuf(bp);
-				goto error_out;
-			}
-		}
-
-		da_cursor->level[i].hashval = be32_to_cpu(btree[0].hashval);
-		da_cursor->level[i].bp = bp;
-		da_cursor->level[i].bno = bno;
-		da_cursor->level[i].index = 0;
-
-		/*
-		 * set up new bno for next level down
-		 */
-		bno = be32_to_cpu(btree[0].before);
-	} while (node != NULL && i > 1);
-
-	/*
-	 * now return block number and get out
-	 */
-	*rbno = da_cursor->level[0].bno = bno;
-	return(1);
-
-error_out:
-	while (i > 1 && i <= da_cursor->active) {
-		libxfs_putbuf(da_cursor->level[i].bp);
-		i++;
-	}
-
-	return(0);
-}
-
-/*
- * blow out buffer for this level and all the rest above as well
- * if error == 0, we are not expecting to encounter any unreleased
- * buffers (e.g. if we do, it's a mistake).  if error == 1, we're
- * in an error-handling case so unreleased buffers may exist.
- */
-static void
-release_dir2_cursor_int(xfs_mount_t		*mp,
-			dir2_bt_cursor_t	*cursor,
-			int			prev_level,
-			int			error)
-{
-	int	level = prev_level + 1;
-
-	if (cursor->level[level].bp != NULL)  {
-		if (!error)  {
-			do_warn(_("release_dir2_cursor_int got unexpected "
-				  "non-null bp, dabno = %u\n"),
-				cursor->level[level].bno);
-		}
-		ASSERT(error != 0);
-
-		libxfs_putbuf(cursor->level[level].bp);
-		cursor->level[level].bp = NULL;
-	}
-
-	if (level < cursor->active)
-		release_dir2_cursor_int(mp, cursor, level, error);
-
-	return;
-}
-
-static void
-release_dir2_cursor(xfs_mount_t		*mp,
-		dir2_bt_cursor_t	*cursor,
-		int			prev_level)
-{
-	release_dir2_cursor_int(mp, cursor, prev_level, 0);
-}
-
-static void
-err_release_dir2_cursor(xfs_mount_t		*mp,
-			dir2_bt_cursor_t	*cursor,
-			int			prev_level)
-{
-	release_dir2_cursor_int(mp, cursor, prev_level, 1);
-}
-
-/*
- * make sure that all entries in all blocks along the right side of
- * of the tree are used and hashval's are consistent.  level is the
- * level of the descendent block.  returns 0 if good (even if it had
- * to be fixed up), and 1 if bad.  The right edge of the tree is
- * technically a block boundary.  This routine should be used then
- * instead of verify_dir2_path().
- */
-static int
-verify_final_dir2_path(xfs_mount_t	*mp,
-		dir2_bt_cursor_t	*cursor,
-		const int		p_level)
-{
-	xfs_da_intnode_t	*node;
-	xfs_dahash_t		hashval;
-	int			bad = 0;
-	int			entry;
-	int			this_level = p_level + 1;
-	struct xfs_da_node_entry *btree;
-	struct xfs_da3_icnode_hdr nodehdr;
-
-#ifdef XR_DIR_TRACE
-	fprintf(stderr, "in verify_final_dir2_path, this_level = %d\n",
-		this_level);
-#endif
-
-	/*
-	 * the index should point to the next "unprocessed" entry
-	 * in the block which should be the final (rightmost) entry
-	 */
-	entry = cursor->level[this_level].index;
-	node = cursor->level[this_level].bp->b_addr;
-	btree = M_DIROPS(mp)->node_tree_p(node);
-	M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
-
-	/*
-	 * check internal block consistency on this level -- ensure
-	 * that all entries are used, encountered and expected hashvals
-	 * match, etc.
-	 */
-	if (entry != nodehdr.count - 1) {
-		do_warn(
-		_("directory block used/count inconsistency - %d / %hu\n"),
-			entry, nodehdr.count);
-		bad++;
-	}
-	/*
-	 * hash values monotonically increasing ???
-	 */
-	if (cursor->level[this_level].hashval >=
-				be32_to_cpu(btree[entry].hashval)) {
-		do_warn(_("directory/attribute block hashvalue inconsistency, "
-			  "expected > %u / saw %u\n"),
-			cursor->level[this_level].hashval,
-			be32_to_cpu(btree[entry].hashval));
-		bad++;
-	}
-	if (nodehdr.forw != 0) {
-		do_warn(_("bad directory/attribute forward block pointer, "
-			  "expected 0, saw %u\n"),
-			nodehdr.forw);
-		bad++;
-	}
-	if (bad) {
-		do_warn(_("bad directory block in inode %" PRIu64 "\n"), cursor->ino);
-		return(1);
-	}
-	/*
-	 * keep track of greatest block # -- that gets
-	 * us the length of the directory
-	 */
-	if (cursor->level[this_level].bno > cursor->greatest_bno)
-		cursor->greatest_bno = cursor->level[this_level].bno;
-
-	/*
-	 * ok, now check descendant block number against this level
-	 */
-	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
-#ifdef XR_DIR_TRACE
-		fprintf(stderr, "bad directory btree pointer, child bno should "
-				"be %d, block bno is %d, hashval is %u\n",
-			be16_to_cpu(btree[entry].before),
-			cursor->level[p_level].bno,
-			cursor->level[p_level].hashval);
-		fprintf(stderr, "verify_final_dir2_path returns 1 (bad) #1a\n");
-#endif
-		return(1);
-	}
-
-	if (cursor->level[p_level].hashval !=
-				be32_to_cpu(btree[entry].hashval)) {
-		if (!no_modify) {
-			do_warn(
-_("correcting bad hashval in non-leaf dir block\n"
-  "\tin (level %d) in inode %" PRIu64 ".\n"),
-				this_level, cursor->ino);
-			btree[entry].hashval = cpu_to_be32(
-						cursor->level[p_level].hashval);
-			cursor->level[this_level].dirty++;
-		} else {
-			do_warn(
-_("would correct bad hashval in non-leaf dir block\n"
-  "\tin (level %d) in inode %" PRIu64 ".\n"),
-				this_level, cursor->ino);
-		}
-	}
-
-	/*
-	 * Note: squirrel hashval away _before_ releasing the
-	 * buffer, preventing a use-after-free problem.
-	 */
-	hashval = be32_to_cpu(btree[entry].hashval);
-
-	/*
-	 * release/write buffer
-	 */
-	ASSERT(cursor->level[this_level].dirty == 0 ||
-		(cursor->level[this_level].dirty && !no_modify));
-
-	if (cursor->level[this_level].dirty && !no_modify)
-		libxfs_writebuf(cursor->level[this_level].bp, 0);
-	else
-		libxfs_putbuf(cursor->level[this_level].bp);
-
-	cursor->level[this_level].bp = NULL;
-
-	/*
-	 * bail out if this is the root block (top of tree)
-	 */
-	if (this_level >= cursor->active) {
-#ifdef XR_DIR_TRACE
-		fprintf(stderr, "verify_final_dir2_path returns 0 (ok)\n");
-#endif
-		return(0);
-	}
-	/*
-	 * set hashvalue to correctly reflect the now-validated
-	 * last entry in this block and continue upwards validation
-	 */
-	cursor->level[this_level].hashval = hashval;
-
-	return(verify_final_dir2_path(mp, cursor, this_level));
-}
-
-/*
- * Verifies the path from a descendant block up to the root.
- * Should be called when the descendant level traversal hits
- * a block boundary before crossing the boundary (reading in a new
- * block).
- *
- * the directory/attr btrees work differently to the other fs btrees.
- * each interior block contains records that are <hashval, bno>
- * pairs.  The bno is a file bno, not a filesystem bno.  The last
- * hashvalue in the block <bno> will be <hashval>.  BUT unlike
- * the freespace btrees, the *last* value in each block gets
- * propagated up the tree instead of the first value in each block.
- * that is, the interior records point to child blocks and the *greatest*
- * hash value contained by the child block is the one the block above
- * uses as the key for the child block.
- *
- * level is the level of the descendent block.  returns 0 if good,
- * and 1 if bad.  The descendant block may be a leaf block.
- *
- * the invariant here is that the values in the cursor for the
- * levels beneath this level (this_level) and the cursor index
- * for this level *must* be valid.
- *
- * that is, the hashval/bno info is accurate for all
- * DESCENDANTS and match what the node[index] information
- * for the current index in the cursor for this level.
- *
- * the index values in the cursor for the descendant level
- * are allowed to be off by one as they will reflect the
- * next entry at those levels to be processed.
- *
- * the hashvalue for the current level can't be set until
- * we hit the last entry in the block so, it's garbage
- * until set by this routine.
- *
- * bno and bp for the current block/level are always valid
- * since they have to be set so we can get a buffer for the
- * block.
- */
-static int
-verify_dir2_path(xfs_mount_t	*mp,
-	dir2_bt_cursor_t	*cursor,
-	const int		p_level)
-{
-	xfs_da_intnode_t	*node;
-	xfs_da_intnode_t	*newnode;
-	xfs_dablk_t		dabno;
-	struct xfs_buf		*bp;
-	int			bad;
-	int			entry;
-	int			this_level = p_level + 1;
-	bmap_ext_t		*bmp;
-	int			nex;
-	bmap_ext_t		lbmp;
-	struct xfs_da_geometry	*geo;
-	struct xfs_da_node_entry *btree;
-	struct xfs_da3_icnode_hdr nodehdr;
-
-	geo = mp->m_dir_geo;
-
-	/*
-	 * index is currently set to point to the entry that
-	 * should be processed now in this level.
-	 */
-	entry = cursor->level[this_level].index;
-	node = cursor->level[this_level].bp->b_addr;
-	btree = M_DIROPS(mp)->node_tree_p(node);
-	M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, node);
-
-	/*
-	 * if this block is out of entries, validate this
-	 * block and move on to the next block.
-	 * and update cursor value for said level
-	 */
-	if (entry >= nodehdr.count) {
-		/*
-		 * update the hash value for this level before
-		 * validating it.  bno value should be ok since
-		 * it was set when the block was first read in.
-		 */
-		cursor->level[this_level].hashval =
-			be32_to_cpu(btree[entry - 1].hashval);
-
-		/*
-		 * keep track of greatest block # -- that gets
-		 * us the length of the directory
-		 */
-		if (cursor->level[this_level].bno > cursor->greatest_bno)
-			cursor->greatest_bno = cursor->level[this_level].bno;
-
-		/*
-		 * validate the path for the current used-up block
-		 * before we trash it
-		 */
-		if (verify_dir2_path(mp, cursor, this_level))
-			return(1);
-		/*
-		 * ok, now get the next buffer and check sibling pointers
-		 */
-		dabno = nodehdr.forw;
-		ASSERT(dabno != 0);
-		nex = blkmap_getn(cursor->blkmap, dabno, geo->fsbcount,
-			&bmp, &lbmp);
-		if (nex == 0) {
-			do_warn(
-_("can't get map info for block %u of directory inode %" PRIu64 "\n"),
-				dabno, cursor->ino);
-			return(1);
-		}
-
-		bp = da_read_buf(mp, nex, bmp, &xfs_da3_node_buf_ops);
-		if (bmp != &lbmp)
-			free(bmp);
-
-		if (!bp) {
-			do_warn(
-_("can't read block %u for directory inode %" PRIu64 "\n"),
-				dabno, cursor->ino);
-			return(1);
-		}
-
-		newnode = bp->b_addr;
-		btree = M_DIROPS(mp)->node_tree_p(newnode);
-		M_DIROPS(mp)->node_hdr_from_disk(&nodehdr, newnode);
-		/*
-		 * verify magic number and back pointer, sanity-check
-		 * entry count, verify level
-		 */
-		bad = 0;
-		if (nodehdr.magic != XFS_DA_NODE_MAGIC &&
-		    nodehdr.magic != XFS_DA3_NODE_MAGIC) {
-			do_warn(
-_("bad magic number %x in block %u for directory inode %" PRIu64 "\n"),
-				nodehdr.magic,
-				dabno, cursor->ino);
-			bad++;
-		}
-		if (nodehdr.back != cursor->level[this_level].bno) {
-			do_warn(
-_("bad back pointer in block %u for directory inode %" PRIu64 "\n"),
-				dabno, cursor->ino);
-			bad++;
-		}
-		if (nodehdr.count > geo->node_ents) {
-			do_warn(
-_("entry count %d too large in block %u for directory inode %" PRIu64 "\n"),
-				nodehdr.count,
-				dabno, cursor->ino);
-			bad++;
-		}
-		if (nodehdr.level != this_level) {
-			do_warn(
-_("bad level %d in block %u for directory inode %" PRIu64 "\n"),
-				nodehdr.level,
-				dabno, cursor->ino);
-			bad++;
-		}
-		if (bad) {
-#ifdef XR_DIR_TRACE
-			fprintf(stderr, "verify_dir2_path returns 1 (bad) #4\n");
-#endif
-			libxfs_putbuf(bp);
-			return(1);
-		}
-		/*
-		 * update cursor, write out the *current* level if
-		 * required.  don't write out the descendant level
-		 */
-		ASSERT(cursor->level[this_level].dirty == 0 ||
-			(cursor->level[this_level].dirty && !no_modify));
-		/*
-		 * If block looks ok but CRC didn't match, make sure to
-		 * recompute it.
-		 */
-		if (!no_modify &&
-		    cursor->level[this_level].bp->b_error == -EFSBADCRC)
-			cursor->level[this_level].dirty = 1;
-		if (cursor->level[this_level].dirty && !no_modify)
-			libxfs_writebuf(cursor->level[this_level].bp, 0);
-		else
-			libxfs_putbuf(cursor->level[this_level].bp);
-
-		/* switch cursor to point at the new buffer we just read */
-		cursor->level[this_level].bp = bp;
-		cursor->level[this_level].dirty = 0;
-		cursor->level[this_level].bno = dabno;
-		cursor->level[this_level].hashval =
-			be32_to_cpu(btree[0].hashval);
-
-		entry = cursor->level[this_level].index = 0;
-	}
-	/*
-	 * ditto for block numbers
-	 */
-	if (cursor->level[p_level].bno != be32_to_cpu(btree[entry].before)) {
-#ifdef XR_DIR_TRACE
-		fprintf(stderr, "bad directory btree pointer, child bno "
-			"should be %d, block bno is %d, hashval is %u\n",
-			be32_to_cpu(btree[entry].before),
-			cursor->level[p_level].bno,
-			cursor->level[p_level].hashval);
-		fprintf(stderr, "verify_dir2_path returns 1 (bad) #1a\n");
-#endif
-		return(1);
-	}
-	/*
-	 * ok, now validate last hashvalue in the descendant
-	 * block against the hashval in the current entry
-	 */
-	if (cursor->level[p_level].hashval !=
-				be32_to_cpu(btree[entry].hashval)) {
-		if (!no_modify) {
-			do_warn(
-_("correcting bad hashval in interior dir block\n"
-  "\tin (level %d) in inode %" PRIu64 ".\n"),
-				this_level, cursor->ino);
-			btree[entry].hashval = cpu_to_be32(
-					cursor->level[p_level].hashval);
-			cursor->level[this_level].dirty++;
-		} else {
-			do_warn(
-_("would correct bad hashval in interior dir block\n"
-  "\tin (level %d) in inode %" PRIu64 ".\n"),
-				this_level, cursor->ino);
-		}
-	}
-	/*
-	 * increment index for this level to point to next entry
-	 * (which should point to the next descendant block)
-	 */
-	cursor->level[this_level].index++;
-#ifdef XR_DIR_TRACE
-       fprintf(stderr, "verify_dir2_path returns 0 (ok)\n");
-#endif
-	return(0);
-}
-
-/*
  * Fix up a shortform directory which was in long form (i8count set)
  * and is now in short form (i8count clear).
  * Return pointer to the end of the data when done.
@@ -1697,7 +1066,7 @@ _("bad stale count in block %u of directory inode %" PRIu64 "\n"),
 static int
 process_leaf_level_dir2(
 	xfs_mount_t		*mp,
-	dir2_bt_cursor_t	*da_cursor,
+	da_bt_cursor_t		*da_cursor,
 	int			*repair)
 {
 	bmap_ext_t		*bmp;
@@ -1791,7 +1160,7 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 		prev_bno = da_bno;
 		da_bno = leafhdr.forw;
 		if (da_bno != 0) {
-			if (verify_dir2_path(mp, da_cursor, 0)) {
+			if (verify_da_path(mp, da_cursor, 0, XFS_DATA_FORK)) {
 				libxfs_putbuf(bp);
 				goto error_out;
 			}
@@ -1810,7 +1179,7 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 		} else
 			libxfs_putbuf(bp);
 	} while (da_bno != 0);
-	if (verify_final_dir2_path(mp, da_cursor, 0)) {
+	if (verify_final_da_path(mp, da_cursor, 0)) {
 		/*
 		 * Verify the final path up (right-hand-side) if still ok.
 		 */
@@ -1820,14 +1189,14 @@ _("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 	/*
 	 * Redundant but just for testing.
 	 */
-	release_dir2_cursor(mp, da_cursor, 0);
+	release_da_cursor(mp, da_cursor, 0);
 	return 0;
 
 error_out:
 	/*
 	 * Release all buffers holding interior btree blocks.
 	 */
-	err_release_dir2_cursor(mp, da_cursor, 0);
+	err_release_da_cursor(mp, da_cursor, 0);
 	if (bmp && (bmp != &lbmp))
 		free(bmp);
 	return 1;
@@ -1846,7 +1215,7 @@ process_node_dir2(
 	int		*repair)
 {
 	xfs_dablk_t		bno;
-	dir2_bt_cursor_t	da_cursor;
+	da_bt_cursor_t		da_cursor;
 
 	/*
 	 * Try again -- traverse down left-side of tree until we hit the
@@ -1862,14 +1231,14 @@ process_node_dir2(
 	/*
 	 * Now process interior node.
 	 */
-	if (traverse_int_dir2block(mp, &da_cursor, &bno) == 0)
+	if (traverse_int_dablock(mp, &da_cursor, &bno, XFS_DATA_FORK) == 0)
 		return 1;
 
 	/*
 	 * Skip directories with a root marked XFS_DIR2_LEAFN_MAGIC
 	 */
 	if (bno == 0) {
-		release_dir2_cursor(mp, &da_cursor, 0);
+		release_da_cursor(mp, &da_cursor, 0);
 		return 0;
 	} else {
 		/*
diff --git a/repair/dir2.h b/repair/dir2.h
index 186633f..e4d4eeb 100644
--- a/repair/dir2.h
+++ b/repair/dir2.h
@@ -22,50 +22,6 @@
 struct blkmap;
 struct bmap_ext;
 
-/*
- * the cursor gets passed up and down the da btree processing
- * routines.  The interior block processing routines use the
- * cursor to determine if the pointers to and from the preceding
- * and succeeding sibling blocks are ok and whether the values in
- * the current block are consistent with the entries in the parent
- * nodes.  When a block is traversed, a parent-verification routine
- * is called to verify if the next logical entry in the next level up
- * is consistent with the greatest hashval in the next block of the
- * current level.  The verification routine is itself recursive and
- * calls itself if it has to traverse an interior block to get
- * the next logical entry.  The routine recurses upwards through
- * the tree until it finds a block where it can simply step to
- * the next entry.  The hashval in that entry should be equal to
- * the hashval being passed to it (the greatest hashval in the block
- * that the entry points to).  If that isn't true, then the tree
- * is blown and we need to trash it, salvage and trash it, or fix it.
- * Currently, we just trash it.
- */
-typedef struct dir2_level_state  {
-	xfs_buf_t	*bp;		/* block bp */
-	xfs_dablk_t	bno;		/* file block number */
-	xfs_dahash_t	hashval;	/* last verified hashval */
-	int		index;		/* current index in block */
-	int		dirty;		/* is buffer dirty ? (1 == yes) */
-} dir2_level_state_t;
-
-typedef struct dir2_bt_cursor  {
-	int			active;	/* highest level in tree (# levels-1) */
-	xfs_ino_t		ino;
-	xfs_dablk_t		greatest_bno;
-	xfs_dinode_t		*dip;
-	dir2_level_state_t	level[XFS_DA_NODE_MAXDEPTH];
-	struct blkmap		*blkmap;
-} dir2_bt_cursor_t;
-
-#include "bmap.h"	/* Goes away in later refactoring */
-struct xfs_buf *
-da_read_buf(
-	xfs_mount_t	*mp,
-	int		nex,
-	bmap_ext_t	*bmp,
-	const struct xfs_buf_ops *ops);
-
 int
 process_dir2(
 	xfs_mount_t	*mp,
@@ -87,9 +43,4 @@ int
 dir2_is_badino(
 	xfs_ino_t	ino);
 
-int
-namecheck(
-	char		*name,
-	int		length);
-
 #endif	/* _XR_DIR2_H */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
