Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82HwIhD034411 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:58:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7320341E03E
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HlfjgbUQXbxSolHH for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:42 -0700 (PDT)
Message-Id: <20090902175841.875447973@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/14] repair: switch block usage bitmap to a btree
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-bmap_extents-btree
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

Using a btree representing the extents is much more space efficient than
using a bitmap tracking every single block.  In addition it also allows
for more optimal algorithms checking range overlaps instead of walking
every block in various places.

Also move the RT tracking bitmap into incore.c instead of leaving it
a as macros - this keeps the implementation contained.


Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/dino_chunks.c
===================================================================
--- xfsprogs-dev.orig/repair/dino_chunks.c	2009-09-02 14:51:09.449268859 -0300
+++ xfsprogs-dev/repair/dino_chunks.c	2009-09-02 14:51:18.593298964 -0300
@@ -118,6 +118,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	int		i;
 	int		j;
 	int		state;
+	xfs_extlen_t	blen;
 
 	agno = XFS_INO_TO_AGNO(mp, ino);
 	agino = XFS_INO_TO_AGINO(mp, ino);
@@ -433,9 +434,10 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	 * entry or an iunlinked pointer
 	 */
 	pthread_mutex_lock(&ag_locks[agno]);
-	for (j = 0, cur_agbno = chunk_start_agbno;
-			cur_agbno < chunk_stop_agbno; cur_agbno++)  {
-		state = get_bmap(agno, cur_agbno);
+	for (cur_agbno = chunk_start_agbno;
+	     cur_agbno < chunk_stop_agbno;
+	     cur_agbno += blen)  {
+		state = get_bmap_ext(agno, cur_agbno, chunk_stop_agbno, &blen);
 		switch (state) {
 		case XR_E_MULT:
 		case XR_E_INUSE:
@@ -444,9 +446,9 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			do_warn(
 		_("inode block %d/%d multiply claimed, (state %d)\n"),
 				agno, cur_agbno, state);
-			set_bmap(agno, cur_agbno, XR_E_MULT);
-			j = 1;
-			break;
+			set_bmap_ext(agno, cur_agbno, blen, XR_E_MULT);
+			pthread_mutex_unlock(&ag_locks[agno]);
+			return 0;
 		case XR_E_INO:
 			do_error(
 		_("uncertain inode block overlap, agbno = %d, ino = %llu\n"),
@@ -455,11 +457,6 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		default:
 			break;
 		}
-
-		if (j) {
-			pthread_mutex_unlock(&ag_locks[agno]);
-			return(0);
-		}
 	}
 	pthread_mutex_unlock(&ag_locks[agno]);
 
@@ -487,8 +484,9 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	pthread_mutex_lock(&ag_locks[agno]);
 
 	for (cur_agbno = chunk_start_agbno;
-			cur_agbno < chunk_stop_agbno; cur_agbno++)  {
-		state = get_bmap(agno, cur_agbno);
+	     cur_agbno < chunk_stop_agbno;
+	     cur_agbno += blen)  {
+		state = get_bmap_ext(agno, cur_agbno, chunk_stop_agbno, &blen);
 		switch (state) {
 		case XR_E_INO:
 			do_error(
@@ -498,7 +496,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
-			set_bmap(agno, cur_agbno, XR_E_INO);
+			set_bmap_ext(agno, cur_agbno, blen, XR_E_INO);
 			break;
 		case XR_E_MULT:
 		case XR_E_INUSE:
@@ -512,7 +510,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			do_warn(
 		_("inode block %d/%d bad state, (state %d)\n"),
 				agno, cur_agbno, state);
-			set_bmap(agno, cur_agbno, XR_E_INO);
+			set_bmap_ext(agno, cur_agbno, blen, XR_E_INO);
 			break;
 		}
 	}
Index: xfsprogs-dev/repair/dinode.c
===================================================================
--- xfsprogs-dev.orig/repair/dinode.c	2009-09-02 14:51:09.457268829 -0300
+++ xfsprogs-dev/repair/dinode.c	2009-09-02 14:51:18.593298964 -0300
@@ -524,6 +524,7 @@ process_rt_rec(
 
 	/*
 	 * set the appropriate number of extents
+	 * this iterates block by block, this can be optimised using extents
 	 */
 	for (b = irec->br_startblock; b < irec->br_startblock +
 			irec->br_blockcount; b += mp->m_sb.sb_rextsize)  {
@@ -614,9 +615,10 @@ process_bmbt_reclist_int(
 	char			*forkname;
 	int			i;
 	int			state;
-	xfs_dfsbno_t		e;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
+	xfs_agblock_t		ebno;
+	xfs_extlen_t		blen;
 	xfs_agnumber_t		locked_agno = -1;
 	int			error = 1;
 
@@ -718,7 +720,7 @@ process_bmbt_reclist_int(
 		 */
 		agno = XFS_FSB_TO_AGNO(mp, irec.br_startblock);
 		agbno = XFS_FSB_TO_AGBNO(mp, irec.br_startblock);
-		e = irec.br_startblock + irec.br_blockcount;
+		ebno = agbno + irec.br_blockcount;
 		if (agno != locked_agno) {
 			if (locked_agno != -1)
 				pthread_mutex_unlock(&ag_locks[locked_agno]);
@@ -733,7 +735,9 @@ process_bmbt_reclist_int(
 			 * checking each entry without setting the
 			 * block bitmap
 			 */
-			for (b = irec.br_startblock; b < e; b++, agbno++)  {
+			for (b = irec.br_startblock;
+			     agbno < ebno;
+			     b++, agbno++)  {
 				if (search_dup_extent(mp, agno, agbno)) {
 					do_warn(_("%s fork in ino %llu claims "
 						"dup extent, off - %llu, "
@@ -748,22 +752,10 @@ process_bmbt_reclist_int(
 			continue;
 		}
 
-		for (b = irec.br_startblock; b < e; b++, agbno++)  {
-			/*
-			 * Process in chunks of 16 (XR_BB_UNIT/XR_BB)
-			 * for common XR_E_UNKNOWN to XR_E_INUSE transition
-			 */
-			if (((agbno & XR_BB_MASK) == 0) && ((irec.br_startblock + irec.br_blockcount - b) >= (XR_BB_UNIT/XR_BB))) {
-				if (ba_bmap[agno][agbno>>XR_BB] == XR_E_UNKNOWN_LL) {
-					ba_bmap[agno][agbno>>XR_BB] = XR_E_INUSE_LL;
-					agbno += (XR_BB_UNIT/XR_BB) - 1;
-					b += (XR_BB_UNIT/XR_BB) - 1;
-					continue;
-				}
-
-			}
-
-			state = get_bmap(agno, agbno);
+		for (b = irec.br_startblock;
+		     agbno < ebno;
+		     b += blen, agbno += blen) {
+			state = get_bmap_ext(agno, agbno, ebno, &blen);
 			switch (state)  {
 			case XR_E_FREE:
 			case XR_E_FREE1:
@@ -772,7 +764,7 @@ process_bmbt_reclist_int(
 					forkname, ino, (__uint64_t) b);
 				/* fall through ... */
 			case XR_E_UNKNOWN:
-				set_bmap(agno, agbno, XR_E_INUSE);
+				set_bmap_ext(agno, agbno, blen, XR_E_INUSE);
 				break;
 
 			case XR_E_BAD_STATE:
@@ -788,7 +780,7 @@ process_bmbt_reclist_int(
 
 			case XR_E_INUSE:
 			case XR_E_MULT:
-				set_bmap(agno, agbno, XR_E_MULT);
+				set_bmap_ext(agno, agbno, blen, XR_E_MULT);
 				do_warn(_("%s fork in %s inode %llu claims "
 					"used block %llu\n"),
 					forkname, ftype, ino, (__uint64_t) b);
Index: xfsprogs-dev/repair/globals.h
===================================================================
--- xfsprogs-dev.orig/repair/globals.h	2009-09-02 14:51:09.461268919 -0300
+++ xfsprogs-dev/repair/globals.h	2009-09-02 14:51:18.597292070 -0300
@@ -156,11 +156,6 @@ EXTERN int		chunks_pblock;	/* # of 64-in
 EXTERN int		max_symlink_blocks;
 EXTERN __int64_t	fs_max_file_offset;
 
-/* block allocation bitmaps */
-
-EXTERN __uint64_t	**ba_bmap;	/* see incore.h */
-EXTERN __uint64_t	*rt_ba_bmap;	/* see incore.h */
-
 /* realtime info */
 
 EXTERN xfs_rtword_t	*btmcompute;
Index: xfsprogs-dev/repair/phase2.c
===================================================================
--- xfsprogs-dev.orig/repair/phase2.c	2009-09-02 14:51:09.465298621 -0300
+++ xfsprogs-dev/repair/phase2.c	2009-09-02 14:51:18.605297206 -0300
@@ -109,7 +109,6 @@ void
 phase2(xfs_mount_t *mp)
 {
 	xfs_agnumber_t		i;
-	xfs_agblock_t		b;
 	int			j;
 	ino_tree_node_t		*ino_rec;
 
@@ -169,11 +168,8 @@ phase2(xfs_mount_t *mp)
 		/*
 		 * also mark blocks
 		 */
-		for (b = 0; b < mp->m_ialloc_blks; b++)  {
-			set_bmap(0,
-				b + XFS_INO_TO_AGBNO(mp, mp->m_sb.sb_rootino),
-				XR_E_INO);
-		}
+		set_bmap_ext(0, XFS_INO_TO_AGBNO(mp, mp->m_sb.sb_rootino),
+			     mp->m_ialloc_blks, XR_E_INO);
 	} else  {
 		do_log(_("        - found root inode chunk\n"));
 
Index: xfsprogs-dev/repair/phase4.c
===================================================================
--- xfsprogs-dev.orig/repair/phase4.c	2009-09-02 14:51:09.533268366 -0300
+++ xfsprogs-dev/repair/phase4.c	2009-09-02 14:51:18.609296598 -0300
@@ -192,8 +192,7 @@ phase4(xfs_mount_t *mp)
 	xfs_agnumber_t		i;
 	xfs_agblock_t		j;
 	xfs_agblock_t		ag_end;
-	xfs_agblock_t		extent_start;
-	xfs_extlen_t		extent_len;
+	xfs_extlen_t		blen;
 	int			ag_hdr_len = 4 * mp->m_sb.sb_sectsize;
 	int			ag_hdr_block;
 	int			bstate;
@@ -226,29 +225,13 @@ phase4(xfs_mount_t *mp)
 		ag_end = (i < mp->m_sb.sb_agcount - 1) ? mp->m_sb.sb_agblocks :
 			mp->m_sb.sb_dblocks -
 				(xfs_drfsbno_t) mp->m_sb.sb_agblocks * i;
-		extent_start = extent_len = 0;
+
 		/*
 		 * set up duplicate extent list for this ag
 		 */
-		for (j = ag_hdr_block; j < ag_end; j++)  {
-
-			/* Process in chunks of 16 (XR_BB_UNIT/XR_BB) */
-			if ((extent_start == 0) && ((j & XR_BB_MASK) == 0)) {
-				switch(ba_bmap[i][j>>XR_BB]) {
-				case XR_E_UNKNOWN_LL:
-				case XR_E_FREE1_LL:
-				case XR_E_FREE_LL:
-				case XR_E_INUSE_LL:
-				case XR_E_INUSE_FS_LL:
-				case XR_E_INO_LL:
-				case XR_E_FS_MAP_LL:
-					j += (XR_BB_UNIT/XR_BB) - 1;
-					continue;
-				}
-			}
-
-			bstate = get_bmap(i, j);
-			switch (bstate)  {
+		for (j = ag_hdr_block; j < ag_end; j += blen)  {
+			bstate = get_bmap_ext(i, j, ag_end, &blen);
+			switch (bstate) {
 			case XR_E_BAD_STATE:
 			default:
 				do_warn(
@@ -262,37 +245,13 @@ phase4(xfs_mount_t *mp)
 			case XR_E_INUSE_FS:
 			case XR_E_INO:
 			case XR_E_FS_MAP:
-				if (extent_start == 0)
-					continue;
-				else  {
-					/*
-					 * add extent and reset extent state
-					 */
-					add_dup_extent(i, extent_start,
-							extent_len);
-					extent_start = 0;
-					extent_len = 0;
-				}
 				break;
 			case XR_E_MULT:
-				if (extent_start == 0)  {
-					extent_start = j;
-					extent_len = 1;
-				} else if (extent_len == MAXEXTLEN)  {
-					add_dup_extent(i, extent_start,
-							extent_len);
-					extent_start = j;
-					extent_len = 1;
-				} else
-					extent_len++;
+				add_dup_extent(i, j, blen);
 				break;
 			}
 		}
-		/*
-		 * catch tail-case, extent hitting the end of the ag
-		 */
-		if (extent_start != 0)
-			add_dup_extent(i, extent_start, extent_len);
+
 		PROG_RPT_INC(prog_rpt_done[i], 1);
 	}
 	print_final_rpt();
Index: xfsprogs-dev/repair/phase5.c
===================================================================
--- xfsprogs-dev.orig/repair/phase5.c	2009-09-02 14:51:09.561269620 -0300
+++ xfsprogs-dev/repair/phase5.c	2009-09-02 14:51:18.613269588 -0300
@@ -88,10 +88,8 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_ag
 	xfs_agblock_t		agbno;
 	xfs_agblock_t		ag_end;
 	uint			free_blocks;
-#ifdef XR_BLD_FREE_TRACE
-	int			old_state;
-	int			state = XR_E_BAD_STATE;
-#endif
+	xfs_extlen_t		blen;
+	int			bstate;
 
 	/*
 	 * scan the bitmap for the ag looking for continuous
@@ -120,30 +118,10 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_ag
 	 * ok, now find the number of extents, keep track of the
 	 * largest extent.
 	 */
-	for (agbno = 0; agbno < ag_end; agbno++)  {
-#if 0
-		old_state = state;
-		state = get_bmap(agno, agbno);
-		if (state != old_state)  {
-			fprintf(stderr, "agbno %u - new state is %d\n",
-					agbno, state);
-		}
-#endif
-		/* Process in chunks of 16 (XR_BB_UNIT/XR_BB) */
-		if ((in_extent == 0) && ((agbno & XR_BB_MASK) == 0)) {
-			/* testing >= XR_E_INUSE */
-			switch (ba_bmap[agno][agbno>>XR_BB]) {
-			case XR_E_INUSE_LL:
-			case XR_E_INUSE_FS_LL:
-			case XR_E_INO_LL:
-			case XR_E_FS_MAP_LL:
-				agbno += (XR_BB_UNIT/XR_BB) - 1;
-				continue;
-			}
-
-		}
-		if (get_bmap(agno, agbno) < XR_E_INUSE)  {
-			free_blocks++;
+	for (agbno = 0; agbno < ag_end; agbno += blen) {
+		bstate = get_bmap_ext(agno, agbno, ag_end, &blen);
+		if (bstate < XR_E_INUSE)  {
+			free_blocks += blen;
 			if (in_extent == 0)  {
 				/*
 				 * found the start of a free extent
@@ -151,9 +129,9 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_ag
 				in_extent = 1;
 				num_extents++;
 				extent_start = agbno;
-				extent_len = 1;
+				extent_len = blen;
 			} else  {
-				extent_len++;
+				extent_len += blen;
 			}
 		} else   {
 			if (in_extent)  {
Index: xfsprogs-dev/repair/incore.c
===================================================================
--- xfsprogs-dev.orig/repair/incore.c	2009-09-02 14:51:09.565269570 -0300
+++ xfsprogs-dev/repair/incore.c	2009-09-02 14:51:29.072772399 -0300
@@ -18,6 +18,7 @@
 
 #include <libxfs.h>
 #include "avl.h"
+#include "btree.h"
 #include "globals.h"
 #include "incore.h"
 #include "agheader.h"
@@ -52,14 +53,192 @@ free_allocations(ba_rec_t *list)
 	return;
 }
 
+/*
+ * The following manages the in-core bitmap of the entire filesystem
+ * using extents in a btree.
+ *
+ * The btree items will point to one of the state values below,
+ * rather than storing the value itself in the pointer.
+ */
+static int states[16] =
+	{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
+
+static struct btree_root	**ag_bmap;
+
+static void
+update_bmap(
+	struct btree_root	*bmap,
+	unsigned long		offset,
+	xfs_extlen_t		blen,
+	void			*new_state)
+{
+	unsigned long		end = offset + blen;
+	int			*cur_state;
+	unsigned long		cur_key;
+	int			*next_state;
+	unsigned long		next_key;
+	int			*prev_state;
+
+	cur_state = btree_find(bmap, offset, &cur_key);
+	if (!cur_state)
+		return;
+
+	if (offset == cur_key) {
+		/* if the start is the same as the "item" extent */
+		if (cur_state == new_state)
+			return;
+
+		/*
+		 * Note: this may be NULL if we are updating the map for
+		 * the superblock.
+		 */
+		prev_state = btree_peek_prev(bmap, NULL);
+
+		next_state = btree_peek_next(bmap, &next_key);
+		if (next_key > end) {
+			/* different end */
+			if (new_state == prev_state) {
+				/* #1: prev has same state, move offset up */
+				btree_update_key(bmap, offset, end);
+				return;
+			}
+
+			/* #4: insert new extent after, update current value */
+			btree_update_value(bmap, offset, new_state);
+			btree_insert(bmap, end, cur_state);
+			return;
+		}
+
+		/* same end (and same start) */
+		if (new_state == next_state) {
+			/* next has same state */
+			if (new_state == prev_state) {
+				/* #3: merge prev & next */
+				btree_delete(bmap, offset);
+				btree_delete(bmap, end);
+				return;
+			}
+
+			/* #8: merge next */
+			btree_update_value(bmap, offset, new_state);
+			btree_delete(bmap, end);
+			return;
+		}
+
+		/* same start, same end, next has different state */
+		if (new_state == prev_state) {
+			/* #5: prev has same state */
+			btree_delete(bmap, offset);
+			return;
+		}
+
+		/* #6: update value only */
+		btree_update_value(bmap, offset, new_state);
+		return;
+	}
+
+	/* different start, offset is in the middle of "cur" */
+	prev_state = btree_peek_prev(bmap, NULL);
+	ASSERT(prev_state != NULL);
+	if (prev_state == new_state)
+		return;
+
+	if (end == cur_key) {
+		/* end is at the same point as the current extent */
+		if (new_state == cur_state) {
+			/* #7: move next extent down */
+			btree_update_key(bmap, end, offset);
+			return;
+		}
+
+		/* #9: different start, same end, add new extent */
+		btree_insert(bmap, offset, new_state);
+		return;
+	}
+
+	/* #2: insert an extent into the middle of another extent */
+	btree_insert(bmap, offset, new_state);
+	btree_insert(bmap, end, prev_state);
+}
+
+void
+set_bmap_ext(
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		blen,
+	int			state)
+{
+	update_bmap(ag_bmap[agno], agbno, blen, &states[state]);
+}
+
+int
+get_bmap_ext(
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		maxbno,
+	xfs_extlen_t		*blen)
+{
+	int			*statep;
+	unsigned long		key;
+
+	statep = btree_find(ag_bmap[agno], agbno, &key);
+	if (!statep)
+		return -1;
+
+	if (key == agbno) {
+		if (blen) {
+			if (!btree_peek_next(ag_bmap[agno], &key))
+				return -1;
+			*blen = MIN(maxbno, key) - agbno;
+		}
+		return *statep;
+	}
+
+	statep = btree_peek_prev(ag_bmap[agno], NULL);
+	if (!statep)
+		return -1;
+	if (blen)
+		*blen = MIN(maxbno, key) - agbno;
+
+	return *statep;
+}
 
+static uint64_t		*rt_bmap;
 static size_t		rt_bmap_size;
 
+/* block records fit into __uint64_t's units */
+#define XR_BB_UNIT	64			/* number of bits/unit */
+#define XR_BB		4			/* bits per block record */
+#define XR_BB_NUM	(XR_BB_UNIT/XR_BB)	/* number of records per unit */
+#define XR_BB_MASK	0xF			/* block record mask */
+
+/*
+ * these work in real-time extents (e.g. fsbno == rt extent number)
+ */
+int
+get_rtbmap(
+	xfs_drtbno_t	bno)
+{
+	return (*(rt_bmap + bno /  XR_BB_NUM) >>
+		((bno % XR_BB_NUM) * XR_BB)) & XR_BB_MASK;
+}
+
+void
+set_rtbmap(
+	xfs_drtbno_t	bno,
+	int		state)
+{
+	*(rt_bmap + bno / XR_BB_NUM) =
+	 ((*(rt_bmap + bno / XR_BB_NUM) &
+	  (~((__uint64_t) XR_BB_MASK << ((bno % XR_BB_NUM) * XR_BB)))) |
+	 (((__uint64_t) state) << ((bno % XR_BB_NUM) * XR_BB)));
+}
+
 static void
 reset_rt_bmap(void)
 {
-	if (rt_ba_bmap)
-		memset(rt_ba_bmap, 0x22, rt_bmap_size);	/* XR_E_FREE */
+	if (rt_bmap)
+		memset(rt_bmap, 0x22, rt_bmap_size);	/* XR_E_FREE */
 }
 
 static void
@@ -72,8 +251,8 @@ init_rt_bmap(
 	rt_bmap_size = roundup(mp->m_sb.sb_rextents / (NBBY / XR_BB),
 			       sizeof(__uint64_t));
 
-	rt_ba_bmap = memalign(sizeof(__uint64_t), rt_bmap_size);
-	if (!rt_ba_bmap) {
+	rt_bmap = memalign(sizeof(__uint64_t), rt_bmap_size);
+	if (!rt_bmap) {
 		do_error(
 		_("couldn't allocate realtime block map, size = %llu\n"),
 			mp->m_sb.sb_rextents);
@@ -84,8 +263,8 @@ init_rt_bmap(
 static void
 free_rt_bmap(xfs_mount_t *mp)
 {
-	free(rt_ba_bmap);
-	rt_ba_bmap = NULL;
+	free(rt_bmap);
+	rt_bmap = NULL;
 }
 
 
@@ -93,28 +272,41 @@ void
 reset_bmaps(xfs_mount_t *mp)
 {
 	xfs_agnumber_t	agno;
+	xfs_agblock_t	ag_size;
 	int		ag_hdr_block;
-	int		i;
 
 	ag_hdr_block = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
+	ag_size = mp->m_sb.sb_agblocks;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)  {
-		memset(ba_bmap[agno], 0,
-		       roundup((mp->m_sb.sb_agblocks + (NBBY / XR_BB) - 1) /
-				(NBBY / XR_BB), sizeof(__uint64_t)));
-		for (i = 0; i < ag_hdr_block; i++)
-			set_bmap(agno, i, XR_E_INUSE_FS);
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		if (agno == mp->m_sb.sb_agcount - 1)
+			ag_size = (xfs_extlen_t)(mp->m_sb.sb_dblocks -
+				   (xfs_drfsbno_t)mp->m_sb.sb_agblocks * agno);
+#ifdef BTREE_STATS
+		if (btree_find(ag_bmap[agno], 0, NULL)) {
+			printf("ag_bmap[%d] btree stats:\n", i);
+			btree_print_stats(ag_bmap[agno], stdout);
+		}
+#endif
+		/*
+		 * We always insert an item for the first block having a
+		 * given state.  So the code below means:
+		 *
+		 *	block 0..ag_hdr_block-1:	XR_E_INUSE_FS
+		 *	ag_hdr_block..ag_size:		XR_E_UNKNOWN
+		 *	ag_size...			XR_E_BAD_STATE
+		 */
+		btree_clear(ag_bmap[agno]);
+		btree_insert(ag_bmap[agno], 0, &states[XR_E_INUSE_FS]);
+		btree_insert(ag_bmap[agno],
+				ag_hdr_block, &states[XR_E_UNKNOWN]);
+		btree_insert(ag_bmap[agno], ag_size, &states[XR_E_BAD_STATE]);
 	}
 
 	if (mp->m_sb.sb_logstart != 0) {
-		xfs_dfsbno_t	logend;
-
-		logend = mp->m_sb.sb_logstart + mp->m_sb.sb_logblocks;
-
-		for (i = mp->m_sb.sb_logstart; i < logend ; i++)  {
-			set_bmap(XFS_FSB_TO_AGNO(mp, i),
-				 XFS_FSB_TO_AGBNO(mp, i), XR_E_INUSE_FS);
-		}
+		set_bmap_ext(XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart),
+			     XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart),
+			     mp->m_sb.sb_logblocks, XR_E_INUSE_FS);
 	}
 
 	reset_rt_bmap();
@@ -123,30 +315,18 @@ reset_bmaps(xfs_mount_t *mp)
 void
 init_bmaps(xfs_mount_t *mp)
 {
-	xfs_agblock_t numblocks = mp->m_sb.sb_agblocks;
-	int agcount = mp->m_sb.sb_agcount;
-	int i;
-	size_t size = 0;
-
-	ba_bmap = calloc(agcount, sizeof(__uint64_t *));
-	if (!ba_bmap)
-		do_error(_("couldn't allocate block map pointers\n"));
+	xfs_agnumber_t i;
 
-	ag_locks = calloc(agcount, sizeof(pthread_mutex_t));
+	ag_bmap = calloc(mp->m_sb.sb_agcount, sizeof(struct btree_root *));
+	if (!ag_bmap)
+		do_error(_("couldn't allocate block map btree roots\n"));
+
+	ag_locks = calloc(mp->m_sb.sb_agcount, sizeof(pthread_mutex_t));
 	if (!ag_locks)
 		do_error(_("couldn't allocate block map locks\n"));
 
-	for (i = 0; i < agcount; i++)  {
-		size = roundup((numblocks+(NBBY/XR_BB)-1) / (NBBY/XR_BB),
-		       		sizeof(__uint64_t));
-
-		ba_bmap[i] = memalign(sizeof(__uint64_t), size);
-		if (!ba_bmap[i]) {
-			do_error(_("couldn't allocate block map, size = %d\n"),
-				numblocks);
-			return;
-		}
-		memset(ba_bmap[i], 0, size);
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
+		btree_init(&ag_bmap[i]);
 		pthread_mutex_init(&ag_locks[i], NULL);
 	}
 
@@ -160,9 +340,9 @@ free_bmaps(xfs_mount_t *mp)
 	xfs_agnumber_t i;
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
-		free(ba_bmap[i]);
-	free(ba_bmap);
-	ba_bmap = NULL;
+		btree_destroy(ag_bmap[i]);
+	free(ag_bmap);
+	ag_bmap = NULL;
 
 	free_rt_bmap(mp);
 }
Index: xfsprogs-dev/repair/incore.h
===================================================================
--- xfsprogs-dev.orig/repair/incore.h	2009-09-02 14:51:09.573269190 -0300
+++ xfsprogs-dev/repair/incore.h	2009-09-02 14:51:18.621298890 -0300
@@ -37,59 +37,32 @@ void			record_allocation(ba_rec_t *addr,
 void			free_allocations(ba_rec_t *list);
 
 /*
- * block bit map defs -- track state of each filesystem block.
- * ba_bmap is an array of bitstrings declared in the globals.h file.
- * the bitstrings are broken up into 64-bit chunks.  one bitstring per AG.
- */
-#define BA_BMAP_SIZE(x)		(howmany(x, 4))
-
-void			init_bmaps(xfs_mount_t *mp);
-void			reset_bmaps(xfs_mount_t *mp);
-void			free_bmaps(xfs_mount_t *mp);
-
-
-/* blocks are numbered from zero */
-
-/* block records fit into __uint64_t's units */
-
-#define XR_BB_UNIT	64			/* number of bits/unit */
-#define XR_BB		4			/* bits per block record */
-#define XR_BB_NUM	(XR_BB_UNIT/XR_BB)	/* number of records per unit */
-#define XR_BB_MASK	0xF			/* block record mask */
-
-/*
- * bitstring ops -- set/get block states, either in filesystem
- * bno's or in agbno's.  turns out that fsbno addressing is
- * more convenient when dealing with bmap extracted addresses
- * and agbno addressing is more convenient when dealing with
- * meta-data extracted addresses.  So the fsbno versions use
- * mtype (which can be one of the block map types above) to
- * set the correct block map while the agbno versions assume
- * you want to use the regular block map.
- */
-
-#define get_bmap(agno, ag_blockno) \
-			((int) (*(ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM) \
-				 >> (((ag_blockno)%XR_BB_NUM)*XR_BB)) \
-				& XR_BB_MASK)
-#define set_bmap(agno, ag_blockno, state) \
-	*(ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM) = \
-		((*(ba_bmap[(agno)] + (ag_blockno)/XR_BB_NUM) & \
-	  (~((__uint64_t) XR_BB_MASK << (((ag_blockno)%XR_BB_NUM)*XR_BB)))) | \
-	 (((__uint64_t) (state)) << (((ag_blockno)%XR_BB_NUM)*XR_BB)))
-
-/*
- * these work in real-time extents (e.g. fsbno == rt extent number)
- */
-#define get_rtbmap(fsbno) \
-			((*(rt_ba_bmap + (fsbno)/XR_BB_NUM) >> \
-			(((fsbno)%XR_BB_NUM)*XR_BB)) & XR_BB_MASK)
-#define set_rtbmap(fsbno, state) \
-	*(rt_ba_bmap + (fsbno)/XR_BB_NUM) = \
-	 ((*(rt_ba_bmap + (fsbno)/XR_BB_NUM) & \
-	  (~((__uint64_t) XR_BB_MASK << (((fsbno)%XR_BB_NUM)*XR_BB)))) | \
-	 (((__uint64_t) (state)) << (((fsbno)%XR_BB_NUM)*XR_BB)))
+ * block map -- track state of each filesystem block.
+ */
+
+void		init_bmaps(xfs_mount_t *mp);
+void		reset_bmaps(xfs_mount_t *mp);
+void		free_bmaps(xfs_mount_t *mp);
+
+void		set_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
+			     xfs_extlen_t blen, int state);
+int		get_bmap_ext(xfs_agnumber_t agno, xfs_agblock_t agbno,
+			     xfs_agblock_t maxbno, xfs_extlen_t *blen);
 
+void		set_rtbmap(xfs_drtbno_t bno, int state);
+int		get_rtbmap(xfs_drtbno_t bno);
+
+static inline void
+set_bmap(xfs_agnumber_t agno, xfs_agblock_t agbno, int state)
+{
+	set_bmap_ext(agno, agbno, 1, state);
+}
+
+static inline int
+get_bmap(xfs_agnumber_t agno, xfs_agblock_t agbno)
+{
+	return get_bmap_ext(agno, agbno, agbno + 1, NULL);
+}
 
 /*
  * extent tree definitions
Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2009-09-02 14:51:09.577269000 -0300
+++ xfsprogs-dev/repair/scan.c	2009-09-02 14:51:18.629269735 -0300
@@ -509,7 +509,7 @@ _("%s freespace btree block claimed (sta
 		rp = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		for (i = 0; i < numrecs; i++) {
 			xfs_agblock_t		b, end;
-			xfs_extlen_t		len;
+			xfs_extlen_t		len, blen;
 
 			b = be32_to_cpu(rp[i].ar_startblock);
 			len = be32_to_cpu(rp[i].ar_blockcount);
@@ -522,8 +522,8 @@ _("%s freespace btree block claimed (sta
 			if (!verify_agbno(mp, agno, end - 1))
 				continue;
 
-			for ( ; b < end; b++)  {
-				state = get_bmap(agno, b);
+			for ( ; b < end; b += blen)  {
+				state = get_bmap_ext(agno, b, end, &blen);
 				switch (state) {
 				case XR_E_UNKNOWN:
 					set_bmap(agno, b, XR_E_FREE1);
@@ -534,13 +534,15 @@ _("%s freespace btree block claimed (sta
 					 * FREE1 blocks later
 					 */
 					if (magic != XFS_ABTB_MAGIC) {
-						set_bmap(agno, b, XR_E_FREE);
+						set_bmap_ext(agno, b, blen,
+							     XR_E_FREE);
 						break;
 					}
 				default:
 					do_warn(
-	_("block (%d,%d) multiply claimed by %s space tree, state - %d\n"),
-						agno, b, name, state);
+	_("block (%d,%d-%d) multiply claimed by %s space tree, state - %d\n"),
+						agno, b, b + blen - 1,
+						name, state);
 					break;
 				}
 			}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
