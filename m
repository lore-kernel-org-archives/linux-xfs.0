Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 69ECA7F3F
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 19:08:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C2B5BAC005
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 17:08:02 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aoZP8YFzOdHSg2zF for <xfs@oss.sgi.com>;
	Thu, 22 May 2014 17:08:00 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wncxn-00071s-8s
	for xfs@oss.sgi.com; Fri, 23 May 2014 10:03:55 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wncxn-0005Tk-84
	for xfs@oss.sgi.com; Fri, 23 May 2014 10:03:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/16] xfs: convert m_dirblkfsbs to xfs_da_geometry
Date: Fri, 23 May 2014 10:03:44 +1000
Message-Id: <1400803432-20048-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1400803432-20048-1-git-send-email-david@fromorbit.com>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c         |  3 ++-
 fs/xfs/xfs_da_btree.c     | 24 ++++++++----------------
 fs/xfs/xfs_dir2.c         |  5 ++---
 fs/xfs/xfs_dir2_leaf.c    |  4 ++--
 fs/xfs/xfs_dir2_readdir.c | 16 ++++++++--------
 fs/xfs/xfs_mount.h        |  1 -
 fs/xfs/xfs_symlink.c      |  1 +
 fs/xfs/xfs_trans_resv.c   |  1 +
 fs/xfs/xfs_trans_space.h  |  5 +++--
 9 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 1ff0da6..96175df 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1098,10 +1098,11 @@ xfs_bmap_add_attrfork_local(
 
 	if (S_ISDIR(ip->i_d.di_mode)) {
 		memset(&dargs, 0, sizeof(dargs));
+		dargs.geo = ip->i_mount->m_dir_geo;
 		dargs.dp = ip;
 		dargs.firstblock = firstblock;
 		dargs.flist = flist;
-		dargs.total = ip->i_mount->m_dirblkfsbs;
+		dargs.total = dargs.geo->fsbcount;
 		dargs.whichfork = XFS_DATA_FORK;
 		dargs.trans = tp;
 		return xfs_dir2_sf_to_block(&dargs);
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 8621202..4d0a1e8 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2090,20 +2090,12 @@ xfs_da_grow_inode(
 	xfs_dablk_t		*new_blkno)
 {
 	xfs_fileoff_t		bno;
-	int			count;
 	int			error;
 
 	trace_xfs_da_grow_inode(args);
 
-	if (args->whichfork == XFS_DATA_FORK) {
-		bno = args->geo->leafblk;
-		count = args->dp->i_mount->m_dirblkfsbs;
-	} else {
-		bno = 0;
-		count = 1;
-	}
-
-	error = xfs_da_grow_inode_int(args, &bno, count);
+	bno = args->geo->leafblk;
+	error = xfs_da_grow_inode_int(args, &bno, args->geo->fsbcount);
 	if (!error)
 		*new_blkno = (xfs_dablk_t)bno;
 	return error;
@@ -2170,7 +2162,7 @@ xfs_da3_swap_lastblock(
 	/*
 	 * Read the last block in the btree space.
 	 */
-	last_blkno = (xfs_dablk_t)lastoff - mp->m_dirblkfsbs;
+	last_blkno = (xfs_dablk_t)lastoff - args->geo->fsbcount;
 	error = xfs_da3_node_read(tp, dp, last_blkno, -1, &last_buf, w);
 	if (error)
 		return error;
@@ -2357,10 +2349,7 @@ xfs_da_shrink_inode(
 	w = args->whichfork;
 	tp = args->trans;
 	mp = dp->i_mount;
-	if (w == XFS_DATA_FORK)
-		count = mp->m_dirblkfsbs;
-	else
-		count = 1;
+	count = args->geo->fsbcount;
 	for (;;) {
 		/*
 		 * Remove extents.  If we get ENOSPC for a dir we have to move
@@ -2479,7 +2468,10 @@ xfs_dabuf_map(
 	ASSERT(map && *map);
 	ASSERT(*nmaps == 1);
 
-	nfsb = (whichfork == XFS_DATA_FORK) ? mp->m_dirblkfsbs : 1;
+	if (whichfork == XFS_DATA_FORK)
+		nfsb = mp->m_dir_geo->fsbcount;
+	else
+		nfsb = mp->m_attr_geo->fsbcount;
 
 	/*
 	 * Caller doesn't have a mapping.  -2 means don't complain
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index fc09a11..200c9c4 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -146,7 +146,6 @@ xfs_da_mount(
 
 	/* XXX: these are to be removed as code is converted to use geo */
 	mp->m_dirblksize = mp->m_dir_geo->blksize;
-	mp->m_dirblkfsbs = mp->m_dir_geo->fsbcount;
 	mp->m_dir_node_ents = mp->m_dir_geo->node_ents;
 	mp->m_dir_magicpct = mp->m_dir_geo->magicpct;
 	mp->m_attr_node_ents = mp->m_attr_geo->node_ents;
@@ -620,7 +619,7 @@ xfs_dir2_grow_inode(
 	 * Set lowest possible block in the space requested.
 	 */
 	bno = XFS_B_TO_FSBT(mp, space * XFS_DIR2_SPACE_SIZE);
-	count = mp->m_dirblkfsbs;
+	count = args->geo->fsbcount;
 
 	error = xfs_da_grow_inode_int(args, &bno, count);
 	if (error)
@@ -711,7 +710,7 @@ xfs_dir2_shrink_inode(
 	/*
 	 * Unmap the fsblock(s).
 	 */
-	if ((error = xfs_bunmapi(tp, dp, da, mp->m_dirblkfsbs,
+	if ((error = xfs_bunmapi(tp, dp, da, args->geo->fsbcount,
 			XFS_BMAPI_METADATA, 0, args->firstblock, args->flist,
 			&done))) {
 		/*
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 3eb8b24..a1f1310 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1715,7 +1715,7 @@ xfs_dir2_node_to_leaf(
 	if ((error = xfs_bmap_last_offset(dp, &fo, XFS_DATA_FORK))) {
 		return error;
 	}
-	fo -= mp->m_dirblkfsbs;
+	fo -= args->geo->fsbcount;
 	/*
 	 * If there are freespace blocks other than the first one,
 	 * take this opportunity to remove trailing empty freespace blocks
@@ -1727,7 +1727,7 @@ xfs_dir2_node_to_leaf(
 			return error;
 		}
 		if (rval)
-			fo -= mp->m_dirblkfsbs;
+			fo -= args->geo->fsbcount;
 		else
 			return 0;
 	}
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 0c8c09c..8cb5340 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -314,12 +314,12 @@ xfs_dir2_leaf_readbuf(
 	if (bp) {
 		xfs_trans_brelse(NULL, bp);
 		bp = NULL;
-		mip->map_blocks -= mp->m_dirblkfsbs;
+		mip->map_blocks -= geo->fsbcount;
 		/*
 		 * Loop to get rid of the extents for the
 		 * directory block.
 		 */
-		for (i = mp->m_dirblkfsbs; i > 0; ) {
+		for (i = geo->fsbcount; i > 0; ) {
 			j = min_t(int, map->br_blockcount, i);
 			map->br_blockcount -= j;
 			map->br_startblock += j;
@@ -410,7 +410,7 @@ xfs_dir2_leaf_readbuf(
 	 */
 	mip->curdb = xfs_dir2_da_to_db(geo, map->br_startoff);
 	error = xfs_dir3_data_read(NULL, dp, map->br_startoff,
-			map->br_blockcount >= mp->m_dirblkfsbs ?
+			map->br_blockcount >= geo->fsbcount ?
 			    XFS_FSB_TO_DADDR(mp, map->br_startblock) : -1, &bp);
 
 	/*
@@ -424,7 +424,7 @@ xfs_dir2_leaf_readbuf(
 	 * was previously ra.
 	 */
 	if (mip->ra_current)
-		mip->ra_current -= mp->m_dirblkfsbs;
+		mip->ra_current -= geo->fsbcount;
 
 	/*
 	 * Do we need more readahead?
@@ -432,13 +432,13 @@ xfs_dir2_leaf_readbuf(
 	blk_start_plug(&plug);
 	for (mip->ra_index = mip->ra_offset = i = 0;
 	     mip->ra_want > mip->ra_current && i < mip->map_blocks;
-	     i += mp->m_dirblkfsbs) {
+	     i += geo->fsbcount) {
 		ASSERT(mip->ra_index < mip->map_valid);
 		/*
 		 * Read-ahead a contiguous directory block.
 		 */
 		if (i > mip->ra_current &&
-		    map[mip->ra_index].br_blockcount >= mp->m_dirblkfsbs) {
+		    map[mip->ra_index].br_blockcount >= geo->fsbcount) {
 			xfs_dir3_data_readahead(dp,
 				map[mip->ra_index].br_startoff + mip->ra_offset,
 				XFS_FSB_TO_DADDR(mp,
@@ -461,12 +461,12 @@ xfs_dir2_leaf_readbuf(
 		/*
 		 * Advance offset through the mapping table.
 		 */
-		for (j = 0; j < mp->m_dirblkfsbs; j += length ) {
+		for (j = 0; j < geo->fsbcount; j += length ) {
 			/*
 			 * The rest of this extent but not more than a dir
 			 * block.
 			 */
-			length = min_t(int, mp->m_dirblkfsbs,
+			length = min_t(int, geo->fsbcount,
 					map[mip->ra_index].br_blockcount -
 							mip->ra_offset);
 			mip->ra_offset += length;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 264e210..275fed3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -155,7 +155,6 @@ typedef struct xfs_mount {
 	const struct xfs_dir_ops *m_dir_inode_ops; /* vector of dir inode ops */
 	const struct xfs_dir_ops *m_nondir_inode_ops; /* !dir inode ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
-	int			m_dirblkfsbs;	/* directory block sz--fsbs */
 	uint			m_chsize;	/* size of next field */
 	atomic_t		m_active_trans;	/* number trans frozen */
 #ifdef HAVE_PERCPU_SB
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 0816b40..d69363c 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -27,6 +27,7 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 52b6c3e..63a42a1 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_inode.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_ialloc.h"
diff --git a/fs/xfs/xfs_trans_space.h b/fs/xfs/xfs_trans_space.h
index df4c1f8..bf9c457 100644
--- a/fs/xfs/xfs_trans_space.h
+++ b/fs/xfs/xfs_trans_space.h
@@ -28,7 +28,8 @@
 	(((b + XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp) - 1) / \
 	  XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * \
 	  XFS_EXTENTADD_SPACE_RES(mp,w))
-#define	XFS_DAENTER_1B(mp,w)	((w) == XFS_DATA_FORK ? (mp)->m_dirblkfsbs : 1)
+#define	XFS_DAENTER_1B(mp,w)	\
+	((w) == XFS_DATA_FORK ? (mp)->m_dir_geo->fsbcount : 1)
 #define	XFS_DAENTER_DBS(mp,w)	\
 	(XFS_DA_NODE_MAXDEPTH + (((w) == XFS_DATA_FORK) ? 2 : 0))
 #define	XFS_DAENTER_BLOCKS(mp,w)	\
@@ -55,7 +56,7 @@
  * Space reservation values for various transactions.
  */
 #define	XFS_ADDAFORK_SPACE_RES(mp)	\
-	((mp)->m_dirblkfsbs + XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK))
+	((mp)->m_dir_geo->fsbcount + XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK))
 #define	XFS_ATTRRM_SPACE_RES(mp)	\
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_ATTR_FORK)
 /* This macro is not used - see inline code in xfs_attr_set */
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
