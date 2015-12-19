Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 11E8E7FFF
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:59:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6BC1CAC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:40 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ACdutHJw6Ms1bjHy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:35 -0800 (PST)
Subject: [PATCH 29/76] xfs: bmap btree changes should update rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:59:32 -0800
Message-ID: <20151219085932.12713.26494.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Any update to a file's bmap should make the corresponding change to
the rmapbt.  On a reflink filesystem, this is absolutely required
because a given (file data) physical block can have multiple owners
and the only sane way to find an rmap given a bmap is if there is a
1:1 correspondence.

(At some point we can optimize this for non-reflink filesystems
because regular merge still works there.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |  179 ++++++++++
 fs/xfs/libxfs/xfs_rmap.c       |  698 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h |   60 +++
 fs/xfs/xfs_bmap_util.c         |   12 +
 4 files changed, 941 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index dfc634a..5d1290e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -45,6 +45,7 @@
 #include "xfs_symlink.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_filestream.h"
+#include "xfs_rmap_btree.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -626,6 +627,8 @@ xfs_bmap_cancel(
 	xfs_bmap_free_item_t	*free;	/* free list item */
 	xfs_bmap_free_item_t	*next;
 
+	xfs_rmap_cancel(&flist->xbf_rlist);
+
 	if (flist->xbf_count == 0)
 		return;
 	ASSERT(flist->xbf_first != NULL);
@@ -1848,6 +1851,10 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_combine(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &LEFT, &RIGHT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -1880,6 +1887,10 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_resize(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &LEFT, PREV.br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1911,6 +1922,10 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_move(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &RIGHT, -PREV.br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -1940,6 +1955,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, new);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -1975,6 +1994,10 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_resize(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &LEFT, new->br_blockcount);
+		if (error)
+			goto done;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock));
 		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
@@ -2010,6 +2033,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, new);
+		if (error)
+			goto done;
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
@@ -2058,6 +2085,8 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_move(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &RIGHT, -new->br_blockcount);
 
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock));
@@ -2094,6 +2123,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, new);
+		if (error)
+			goto done;
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
@@ -2163,6 +2196,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, new);
+		if (error)
+			goto done;
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
@@ -2404,6 +2441,10 @@ xfs_bmap_add_extent_unwritten_real(
 				RIGHT.br_blockcount, LEFT.br_state)))
 				goto done;
 		}
+		error = xfs_rmap_combine(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &LEFT, &RIGHT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -2441,6 +2482,10 @@ xfs_bmap_add_extent_unwritten_real(
 				LEFT.br_state)))
 				goto done;
 		}
+		error = xfs_rmap_lcombine(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &LEFT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -2476,6 +2521,10 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
+		error = xfs_rmap_rcombine(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &RIGHT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -2502,6 +2551,11 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
+
+		error = xfs_rmap_resize(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, new, 0);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -2549,6 +2603,14 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_move(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &PREV, new->br_blockcount);
+		if (error)
+			goto done;
+		error = xfs_rmap_resize(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &LEFT, new->br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -2587,6 +2649,14 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_move(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &PREV, new->br_blockcount);
+		if (error)
+			goto done;
+		error = xfs_rmap_insert(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, new);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -2629,6 +2699,14 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
+		error = xfs_rmap_resize(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &PREV, -new->br_blockcount);
+		if (error)
+			goto done;
+		error = xfs_rmap_move(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &RIGHT, -new->br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -2669,6 +2747,14 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_resize(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &PREV, -new->br_blockcount);
+		if (error)
+			goto done;
+		error = xfs_rmap_insert(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, new);
+		if (error)
+			goto done;
 		break;
 
 	case 0:
@@ -2730,6 +2816,19 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_resize(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &PREV, new->br_startoff -
+				PREV.br_startoff - PREV.br_blockcount);
+		if (error)
+			goto done;
+		error = xfs_rmap_insert(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, new);
+		if (error)
+			goto done;
+		error = xfs_rmap_insert(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &r[1]);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
@@ -2933,6 +3032,7 @@ xfs_bmap_add_extent_hole_real(
 	int			rval=0;	/* return value (logging flags) */
 	int			state;	/* state bits, accessed thru macros */
 	struct xfs_mount	*mp;
+	struct xfs_bmbt_irec	prev;	/* fake previous extent entry */
 
 	mp = bma->tp ? bma->tp->t_mountp : NULL;
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
@@ -3040,6 +3140,12 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 		}
+		prev = *new;
+		prev.br_startblock = nullstartblock(0);
+		error = xfs_rmap_combine(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &left, &right, &prev);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_CONTIG:
@@ -3072,6 +3178,10 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_resize(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &left, new->br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_RIGHT_CONTIG:
@@ -3106,6 +3216,10 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_move(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &right, -new->br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case 0:
@@ -3134,6 +3248,10 @@ xfs_bmap_add_extent_hole_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, new);
+		if (error)
+			goto done;
 		break;
 	}
 
@@ -4268,7 +4386,6 @@ xfs_bmapi_delay(
 	return 0;
 }
 
-
 static int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
@@ -4582,6 +4699,7 @@ xfs_bmapi_write(
 	bma.userdata = 0;
 	bma.flist = flist;
 	bma.firstblock = firstblock;
+	bma.rlist = &flist->xbf_rlist;
 
 	while (bno < end && n < *nmap) {
 		inhole = eof || bma.got.br_startoff > bno;
@@ -4840,6 +4958,10 @@ xfs_bmap_del_extent(
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		flags |= XFS_ILOG_CORE;
+		error = xfs_rmap_delete(mp, &flist->xbf_rlist, ip->i_ino,
+				whichfork, &got);
+		if (error)
+			goto done;
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -4867,6 +4989,10 @@ xfs_bmap_del_extent(
 		}
 		xfs_bmbt_set_startblock(ep, del_endblock);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		error = xfs_rmap_move(mp, &flist->xbf_rlist, ip->i_ino,
+				whichfork, &got, del->br_blockcount);
+		if (error)
+			goto done;
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -4893,6 +5019,10 @@ xfs_bmap_del_extent(
 			break;
 		}
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		error = xfs_rmap_resize(mp, &flist->xbf_rlist, ip->i_ino,
+				whichfork, &got, -del->br_blockcount);
+		if (error)
+			goto done;
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -4918,6 +5048,15 @@ xfs_bmap_del_extent(
 		if (!delay) {
 			new.br_startblock = del_endblock;
 			flags |= XFS_ILOG_CORE;
+			error = xfs_rmap_resize(mp, &flist->xbf_rlist,
+					ip->i_ino, whichfork, &got,
+					temp - got.br_blockcount);
+			if (error)
+				goto done;
+			error = xfs_rmap_insert(mp, &flist->xbf_rlist,
+					ip->i_ino, whichfork, &new);
+			if (error)
+				goto done;
 			if (cur) {
 				if ((error = xfs_bmbt_update(cur,
 						got.br_startoff,
@@ -5154,6 +5293,7 @@ xfs_bunmapi(
 			got.br_startoff + got.br_blockcount - 1);
 		if (bno < start)
 			break;
+
 		/*
 		 * Then deal with the (possibly delayed) allocated space
 		 * we found.
@@ -5456,7 +5596,8 @@ xfs_bmse_merge(
 	struct xfs_bmbt_rec_host	*gotp,		/* extent to shift */
 	struct xfs_bmbt_rec_host	*leftp,		/* preceding extent */
 	struct xfs_btree_cur		*cur,
-	int				*logflags)	/* output */
+	int				*logflags,	/* output */
+	struct xfs_rmap_list		*rlist)		/* rmap intent list */
 {
 	struct xfs_bmbt_irec		got;
 	struct xfs_bmbt_irec		left;
@@ -5487,6 +5628,13 @@ xfs_bmse_merge(
 	XFS_IFORK_NEXT_SET(ip, whichfork,
 			   XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 	*logflags |= XFS_ILOG_CORE;
+	error = xfs_rmap_resize(mp, rlist, ip->i_ino, whichfork, &left,
+			blockcount - left.br_blockcount);
+	if (error)
+		return error;
+	error = xfs_rmap_delete(mp, rlist, ip->i_ino, whichfork, &got);
+	if (error)
+		return error;
 	if (!cur) {
 		*logflags |= XFS_ILOG_DEXT;
 		return 0;
@@ -5529,7 +5677,8 @@ xfs_bmse_shift_one(
 	struct xfs_bmbt_rec_host	*gotp,
 	struct xfs_btree_cur		*cur,
 	int				*logflags,
-	enum shift_direction		direction)
+	enum shift_direction		direction,
+	struct xfs_rmap_list		*rlist)
 {
 	struct xfs_ifork		*ifp;
 	struct xfs_mount		*mp;
@@ -5579,7 +5728,7 @@ xfs_bmse_shift_one(
 				       offset_shift_fsb)) {
 			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
 					      *current_ext, gotp, adj_irecp,
-					      cur, logflags);
+					      cur, logflags, rlist);
 		}
 	} else {
 		startoff = got.br_startoff + offset_shift_fsb;
@@ -5616,6 +5765,10 @@ update_current_ext:
 		(*current_ext)--;
 	xfs_bmbt_set_startoff(gotp, startoff);
 	*logflags |= XFS_ILOG_CORE;
+	error = xfs_rmap_slide(mp, rlist, ip->i_ino, whichfork,
+			&got, startoff - got.br_startoff);
+	if (error)
+		return error;
 	if (!cur) {
 		*logflags |= XFS_ILOG_DEXT;
 		return 0;
@@ -5755,9 +5908,11 @@ xfs_bmap_shift_extents(
 	}
 
 	while (nexts++ < num_exts) {
+		xfs_bmbt_get_all(gotp, &got);
+
 		error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
 					   &current_ext, gotp, cur, &logflags,
-					   direction);
+					   direction, &flist->xbf_rlist);
 		if (error)
 			goto del_cursor;
 		/*
@@ -5810,6 +5965,7 @@ xfs_bmap_split_extent_at(
 	int				whichfork = XFS_DATA_FORK;
 	struct xfs_btree_cur		*cur = NULL;
 	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_irec		rgot;
 	struct xfs_bmbt_irec		got;
 	struct xfs_bmbt_irec		new; /* split extent */
 	struct xfs_mount		*mp = ip->i_mount;
@@ -5819,6 +5975,7 @@ xfs_bmap_split_extent_at(
 	int				error = 0;
 	int				logflags = 0;
 	int				i = 0;
+	long				adj;
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -5858,6 +6015,7 @@ xfs_bmap_split_extent_at(
 	if (got.br_startoff >= split_fsb)
 		return 0;
 
+	rgot = got;
 	gotblkcnt = split_fsb - got.br_startoff;
 	new.br_startoff = split_fsb;
 	new.br_startblock = got.br_startblock + gotblkcnt;
@@ -5913,6 +6071,17 @@ xfs_bmap_split_extent_at(
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, del_cursor);
 	}
 
+	/* update rmapbt */
+	adj = -(long)rgot.br_blockcount + gotblkcnt;
+	error = xfs_rmap_resize(mp, &free_list->xbf_rlist, ip->i_ino,
+			whichfork, &rgot, adj);
+	if (error)
+		goto del_cursor;
+	error = xfs_rmap_insert(mp, &free_list->xbf_rlist, ip->i_ino,
+			whichfork, &new);
+	if (error)
+		goto del_cursor;
+
 	/*
 	 * Convert to a btree if necessary.
 	 */
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 6733873..46d87315 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -35,6 +35,7 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
+#include "xfs_bmap.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
@@ -563,3 +564,700 @@ out_error:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 	return error;
 }
+
+/* Encode logical offset for a rmapbt record */
+STATIC uint64_t
+b2r_off(
+	int		whichfork,
+	xfs_fileoff_t	off)
+{
+	uint64_t	x;
+
+	x = off;
+	if (whichfork == XFS_ATTR_FORK)
+		x |= XFS_RMAP_OFF_ATTR;
+	return x;
+}
+
+/* Encode blockcount for a rmapbt record */
+STATIC xfs_extlen_t
+b2r_len(
+	struct xfs_bmbt_irec	*irec)
+{
+	xfs_extlen_t		x;
+
+	x = irec->br_blockcount;
+	if (irec->br_state == XFS_EXT_UNWRITTEN)
+		x |= XFS_RMAP_LEN_UNWRITTEN;
+	return x;
+}
+
+static int
+__xfs_rmap_move(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV,
+	long			start_adj);
+
+static int
+__xfs_rmap_resize(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV,
+	long			size_adj);
+
+/* Combine two adjacent rmap extents */
+static int
+__xfs_rmap_combine(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*LEFT,
+	struct xfs_bmbt_irec	*RIGHT,
+	struct xfs_bmbt_irec	*PREV)
+{
+	int			error;
+
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_combine(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, LEFT, PREV, RIGHT);
+
+	/* Delete right rmap */
+	error = xfs_rmapbt_delete(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, RIGHT->br_startblock),
+			b2r_len(RIGHT), ino,
+			b2r_off(whichfork, RIGHT->br_startoff));
+	if (error)
+		goto done;
+
+	/* Delete prev rmap */
+	if (!isnullstartblock(PREV->br_startblock)) {
+		error = xfs_rmapbt_delete(rcur,
+				XFS_FSB_TO_AGBNO(rcur->bc_mp,
+						PREV->br_startblock),
+				b2r_len(PREV), ino,
+				b2r_off(whichfork, PREV->br_startoff));
+		if (error)
+			goto done;
+	}
+
+	/* Enlarge left rmap */
+	return __xfs_rmap_resize(rcur, ino, whichfork, LEFT,
+			PREV->br_blockcount + RIGHT->br_blockcount);
+done:
+	return error;
+}
+
+/* Extend a left rmap extent */
+static int
+__xfs_rmap_lcombine(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*LEFT,
+	struct xfs_bmbt_irec	*PREV)
+{
+	int			error;
+
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_lcombine(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, LEFT, PREV);
+
+	/* Delete prev rmap */
+	if (!isnullstartblock(PREV->br_startblock)) {
+		error = xfs_rmapbt_delete(rcur,
+				XFS_FSB_TO_AGBNO(rcur->bc_mp,
+						PREV->br_startblock),
+				b2r_len(PREV), ino,
+				b2r_off(whichfork, PREV->br_startoff));
+		if (error)
+			goto done;
+	}
+
+	/* Enlarge left rmap */
+	return __xfs_rmap_resize(rcur, ino, whichfork, LEFT,
+			PREV->br_blockcount);
+done:
+	return error;
+}
+
+/* Extend a right rmap extent */
+static int
+__xfs_rmap_rcombine(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*RIGHT,
+	struct xfs_bmbt_irec	*PREV)
+{
+	int			error;
+
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_rcombine(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, RIGHT, PREV);
+
+	/* Delete prev rmap */
+	if (!isnullstartblock(PREV->br_startblock)) {
+		error = xfs_rmapbt_delete(rcur,
+				XFS_FSB_TO_AGBNO(rcur->bc_mp,
+						PREV->br_startblock),
+				b2r_len(PREV), ino,
+				b2r_off(whichfork, PREV->br_startoff));
+		if (error)
+			goto done;
+	}
+
+	/* Enlarge right rmap */
+	return __xfs_rmap_move(rcur, ino, whichfork, RIGHT,
+			-PREV->br_blockcount);
+done:
+	return error;
+}
+
+/* Insert a rmap extent */
+static int
+__xfs_rmap_insert(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*rec)
+{
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, rec);
+
+	return xfs_rmapbt_insert(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, rec->br_startblock),
+			b2r_len(rec), ino,
+			b2r_off(whichfork, rec->br_startoff));
+}
+
+/* Delete a rmap extent */
+static int
+__xfs_rmap_delete(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*rec)
+{
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, rec);
+
+	return xfs_rmapbt_delete(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, rec->br_startblock),
+			b2r_len(rec), ino,
+			b2r_off(whichfork, rec->br_startoff));
+}
+
+/* Change the start of an rmap */
+static int
+__xfs_rmap_move(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV,
+	long			start_adj)
+{
+	int			error;
+	struct xfs_bmbt_irec	irec;
+
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_move(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, PREV, start_adj);
+
+	/* Delete prev rmap */
+	error = xfs_rmapbt_delete(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
+			b2r_len(PREV), ino,
+			b2r_off(whichfork, PREV->br_startoff));
+	if (error)
+		goto done;
+
+	/* Re-add rmap with new start */
+	irec = *PREV;
+	irec.br_startblock += start_adj;
+	irec.br_startoff += start_adj;
+	irec.br_blockcount -= start_adj;
+	return xfs_rmapbt_insert(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, irec.br_startblock),
+			b2r_len(&irec), ino,
+			b2r_off(whichfork, irec.br_startoff));
+done:
+	return error;
+}
+
+/* Change the logical offset of an rmap */
+static int
+__xfs_rmap_slide(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV,
+	long			start_adj)
+{
+	int			error;
+
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_slide(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, PREV, start_adj);
+
+	/* Delete prev rmap */
+	error = xfs_rmapbt_delete(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
+			b2r_len(PREV), ino,
+			b2r_off(whichfork, PREV->br_startoff));
+	if (error)
+		goto done;
+
+	/* Re-add rmap with new logical offset */
+	return xfs_rmapbt_insert(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
+			b2r_len(PREV), ino,
+			b2r_off(whichfork, PREV->br_startoff + start_adj));
+done:
+	return error;
+}
+
+/* Change the size of an rmap */
+static int
+__xfs_rmap_resize(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV,
+	long			size_adj)
+{
+	int			i;
+	int			error;
+	struct xfs_bmbt_irec	irec;
+	struct xfs_rmap_irec	rrec;
+
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_resize(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, PREV, size_adj);
+
+	error = xfs_rmap_lookup_eq(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
+			b2r_len(PREV), ino,
+			b2r_off(whichfork, PREV->br_startoff), &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+	error = xfs_rmap_get_rec(rcur, &rrec, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+	irec = *PREV;
+	irec.br_blockcount += size_adj;
+	rrec.rm_blockcount = b2r_len(&irec);
+	error = xfs_rmap_update(rcur, &rrec);
+	if (error)
+		goto done;
+done:
+	return error;
+}
+
+/*
+ * Free up any items left in the list.
+ */
+void
+xfs_rmap_cancel(
+	struct xfs_rmap_list	*rlist)	/* list of bmap_free_items */
+{
+	struct xfs_rmap_intent	*free;	/* free list item */
+	struct xfs_rmap_intent	*next;
+
+	if (rlist->rl_count == 0)
+		return;
+	ASSERT(rlist->rl_first != NULL);
+	for (free = rlist->rl_first; free; free = next) {
+		next = free->ri_next;
+		kmem_free(free);
+	}
+	rlist->rl_count = 0;
+	rlist->rl_first = NULL;
+}
+
+static xfs_agnumber_t
+rmap_ag(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_intent	*ri)
+{
+	switch (ri->ri_type) {
+	case XFS_RMAP_COMBINE:
+	case XFS_RMAP_LCOMBINE:
+		return XFS_FSB_TO_AGNO(mp, ri->ri_u.a.left.br_startblock);
+	case XFS_RMAP_RCOMBINE:
+		return XFS_FSB_TO_AGNO(mp, ri->ri_u.a.right.br_startblock);
+	case XFS_RMAP_INSERT:
+	case XFS_RMAP_DELETE:
+	case XFS_RMAP_MOVE:
+	case XFS_RMAP_SLIDE:
+	case XFS_RMAP_RESIZE:
+		return XFS_FSB_TO_AGNO(mp, ri->ri_prev.br_startblock);
+	default:
+		ASSERT(0);
+	}
+	return 0; /* shut up, gcc */
+}
+
+/*
+ * Free up any items left in the extent list, using the given transaction.
+ */
+int
+__xfs_rmap_finish(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_rmap_list	*rlist)
+{
+	struct xfs_rmap_intent	*free;	/* free list item */
+	struct xfs_rmap_intent	*next;
+	struct xfs_btree_cur	*rcur = NULL;
+	struct xfs_buf		*agbp = NULL;
+	int			error = 0;
+	xfs_agnumber_t		agno;
+
+	if (rlist->rl_count == 0)
+		return 0;
+
+	ASSERT(rlist->rl_first != NULL);
+	for (free = rlist->rl_first; free; free = next) {
+		agno = rmap_ag(mp, free);
+		ASSERT(agno != NULLAGNUMBER);
+		if (rcur && agno < rcur->bc_private.a.agno) {
+			error = -EFSCORRUPTED;
+			break;
+		}
+
+		ASSERT(rcur == NULL || agno >= rcur->bc_private.a.agno);
+		if (rcur == NULL || agno > rcur->bc_private.a.agno) {
+			if (rcur) {
+				xfs_btree_del_cursor(rcur, XFS_BTREE_NOERROR);
+				xfs_trans_brelse(tp, agbp);
+			}
+
+			error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+			if (error)
+				break;
+
+			rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+			if (!rcur) {
+				xfs_trans_brelse(tp, agbp);
+				error = -ENOMEM;
+				break;
+			}
+		}
+
+		switch (free->ri_type) {
+		case XFS_RMAP_COMBINE:
+			error = __xfs_rmap_combine(rcur, free->ri_ino,
+					free->ri_whichfork, &free->ri_u.a.left,
+					&free->ri_u.a.right, &free->ri_prev);
+			break;
+		case XFS_RMAP_LCOMBINE:
+			error = __xfs_rmap_lcombine(rcur, free->ri_ino,
+					free->ri_whichfork, &free->ri_u.a.left,
+					&free->ri_prev);
+			break;
+		case XFS_RMAP_RCOMBINE:
+			error = __xfs_rmap_rcombine(rcur, free->ri_ino,
+					free->ri_whichfork, &free->ri_u.a.right,
+					&free->ri_prev);
+			break;
+		case XFS_RMAP_INSERT:
+			error = __xfs_rmap_insert(rcur, free->ri_ino,
+					free->ri_whichfork, &free->ri_prev);
+			break;
+		case XFS_RMAP_DELETE:
+			error = __xfs_rmap_delete(rcur, free->ri_ino,
+					free->ri_whichfork, &free->ri_prev);
+			break;
+		case XFS_RMAP_MOVE:
+			error = __xfs_rmap_move(rcur, free->ri_ino,
+					free->ri_whichfork, &free->ri_prev,
+					free->ri_u.b.adj);
+			break;
+		case XFS_RMAP_SLIDE:
+			error = __xfs_rmap_slide(rcur, free->ri_ino,
+					free->ri_whichfork, &free->ri_prev,
+					free->ri_u.b.adj);
+			break;
+		case XFS_RMAP_RESIZE:
+			error = __xfs_rmap_resize(rcur, free->ri_ino,
+					free->ri_whichfork, &free->ri_prev,
+					free->ri_u.b.adj);
+			break;
+		default:
+			ASSERT(0);
+		}
+
+		if (error)
+			break;
+		next = free->ri_next;
+		kmem_free(free);
+	}
+
+	if (rcur)
+		xfs_btree_del_cursor(rcur, error ? XFS_BTREE_ERROR :
+				XFS_BTREE_NOERROR);
+	if (agbp)
+		xfs_trans_brelse(tp, agbp);
+
+	for (; free; free = next) {
+		next = free->ri_next;
+		kmem_free(free);
+	}
+
+	rlist->rl_count = 0;
+	rlist->rl_first = NULL;
+	return error;
+}
+
+/*
+ * Free up any items left in the intent list.
+ */
+int
+xfs_rmap_finish(
+	struct xfs_mount	*mp,
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	struct xfs_rmap_list	*rlist,
+	int			*committed)
+{
+	int			error;
+
+	*committed = 0;
+	if (rlist->rl_count == 0)
+		return 0;
+
+	error = xfs_trans_roll(tpp, ip);
+	if (error)
+		return error;
+	*committed = 1;
+
+	return __xfs_rmap_finish(mp, *tpp, rlist);
+}
+
+/*
+ * Record a rmap intent; the list is kept sorted first by AG and then by
+ * increasing age.
+ */
+static int
+__xfs_rmap_add(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_list	*rlist,
+	struct xfs_rmap_intent	*ri)
+{
+	struct xfs_rmap_intent	*cur;		/* current (next) element */
+	struct xfs_rmap_intent	*new;
+	struct xfs_rmap_intent	*prev;		/* previous element */
+	xfs_agnumber_t		new_agno, cur_agno;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+
+	new = kmem_zalloc(sizeof(struct xfs_rmap_intent), KM_SLEEP | KM_NOFS);
+	*new = *ri;
+	new_agno = rmap_ag(mp, new);
+	ASSERT(new_agno != NULLAGNUMBER);
+
+	for (prev = NULL, cur = rlist->rl_first;
+	     cur != NULL;
+	     prev = cur, cur = cur->ri_next) {
+		cur_agno = rmap_ag(mp, cur);
+		if (cur_agno > new_agno)
+			break;
+	}
+	if (prev)
+		prev->ri_next = new;
+	else
+		rlist->rl_first = new;
+	new->ri_next = cur;
+	rlist->rl_count++;
+	return 0;
+}
+
+/* Combine two adjacent rmap extents */
+int
+xfs_rmap_combine(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_list	*rlist,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*left,
+	struct xfs_bmbt_irec	*right,
+	struct xfs_bmbt_irec	*prev)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_COMBINE;
+	ri.ri_ino = ino;
+	ri.ri_whichfork = whichfork;
+	ri.ri_prev = *prev;
+	ri.ri_u.a.left = *left;
+	ri.ri_u.a.right = *right;
+
+	return __xfs_rmap_add(mp, rlist, &ri);
+}
+
+/* Extend a left rmap extent */
+int
+xfs_rmap_lcombine(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_list	*rlist,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*LEFT,
+	struct xfs_bmbt_irec	*PREV)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_LCOMBINE;
+	ri.ri_ino = ino;
+	ri.ri_whichfork = whichfork;
+	ri.ri_prev = *PREV;
+	ri.ri_u.a.left = *LEFT;
+
+	return __xfs_rmap_add(mp, rlist, &ri);
+}
+
+/* Extend a right rmap extent */
+int
+xfs_rmap_rcombine(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_list	*rlist,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*RIGHT,
+	struct xfs_bmbt_irec	*PREV)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_RCOMBINE;
+	ri.ri_ino = ino;
+	ri.ri_whichfork = whichfork;
+	ri.ri_prev = *PREV;
+	ri.ri_u.a.right = *RIGHT;
+
+	return __xfs_rmap_add(mp, rlist, &ri);
+}
+
+/* Insert a rmap extent */
+int
+xfs_rmap_insert(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_list	*rlist,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*new)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_INSERT;
+	ri.ri_ino = ino;
+	ri.ri_whichfork = whichfork;
+	ri.ri_prev = *new;
+
+	return __xfs_rmap_add(mp, rlist, &ri);
+}
+
+/* Delete a rmap extent */
+int
+xfs_rmap_delete(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_list	*rlist,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*new)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_DELETE;
+	ri.ri_ino = ino;
+	ri.ri_whichfork = whichfork;
+	ri.ri_prev = *new;
+
+	return __xfs_rmap_add(mp, rlist, &ri);
+}
+
+/* Change the start of an rmap */
+int
+xfs_rmap_move(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_list	*rlist,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV,
+	long			start_adj)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_MOVE;
+	ri.ri_ino = ino;
+	ri.ri_whichfork = whichfork;
+	ri.ri_prev = *PREV;
+	ri.ri_u.b.adj = start_adj;
+
+	return __xfs_rmap_add(mp, rlist, &ri);
+}
+
+/* Change the logical offset of an rmap */
+int
+xfs_rmap_slide(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_list	*rlist,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV,
+	long			start_adj)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_SLIDE;
+	ri.ri_ino = ino;
+	ri.ri_whichfork = whichfork;
+	ri.ri_prev = *PREV;
+	ri.ri_u.b.adj = start_adj;
+
+	return __xfs_rmap_add(mp, rlist, &ri);
+}
+
+/* Change the size of an rmap */
+int
+xfs_rmap_resize(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_list	*rlist,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV,
+	long			size_adj)
+{
+	struct xfs_rmap_intent	ri;
+
+	ri.ri_type = XFS_RMAP_RESIZE;
+	ri.ri_ino = ino;
+	ri.ri_whichfork = whichfork;
+	ri.ri_prev = *PREV;
+	ri.ri_u.b.adj = size_adj;
+
+	return __xfs_rmap_add(mp, rlist, &ri);
+}
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index d7c9722..4fe13f3 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -21,6 +21,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xfs_rmap_list;
 
 /* rmaps only exist on crc enabled filesystems */
 #define XFS_RMAP_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
@@ -68,4 +69,63 @@ int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
 		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
 		  struct xfs_owner_info *oinfo);
 
+/* functions for updating the rmapbt based on bmbt map/unmap operations */
+int xfs_rmap_combine(struct xfs_mount *mp, struct xfs_rmap_list *rlist,
+		xfs_ino_t ino, int whichfork, struct xfs_bmbt_irec *LEFT,
+		struct xfs_bmbt_irec *RIGHT, struct xfs_bmbt_irec *PREV);
+int xfs_rmap_lcombine(struct xfs_mount *mp, struct xfs_rmap_list *rlist,
+		xfs_ino_t ino, int whichfork, struct xfs_bmbt_irec *LEFT,
+		struct xfs_bmbt_irec *PREV);
+int xfs_rmap_rcombine(struct xfs_mount *mp, struct xfs_rmap_list *rlist,
+		xfs_ino_t ino, int whichfork, struct xfs_bmbt_irec *RIGHT,
+		struct xfs_bmbt_irec *PREV);
+int xfs_rmap_insert(struct xfs_mount *mp, struct xfs_rmap_list *rlist,
+		xfs_ino_t ino, int whichfork, struct xfs_bmbt_irec *rec);
+int xfs_rmap_delete(struct xfs_mount *mp, struct xfs_rmap_list *rlist,
+		xfs_ino_t ino, int whichfork, struct xfs_bmbt_irec *rec);
+int xfs_rmap_move(struct xfs_mount *mp, struct xfs_rmap_list *rlist,
+		xfs_ino_t ino, int whichfork, struct xfs_bmbt_irec *PREV,
+		long start_adj);
+int xfs_rmap_slide(struct xfs_mount *mp, struct xfs_rmap_list *rlist,
+		xfs_ino_t ino, int whichfork, struct xfs_bmbt_irec *PREV,
+		long start_adj);
+int xfs_rmap_resize(struct xfs_mount *mp, struct xfs_rmap_list *rlist,
+		xfs_ino_t ino, int whichfork, struct xfs_bmbt_irec *PREV,
+		long size_adj);
+
+enum xfs_rmap_intent_type {
+	XFS_RMAP_COMBINE,
+	XFS_RMAP_LCOMBINE,
+	XFS_RMAP_RCOMBINE,
+	XFS_RMAP_INSERT,
+	XFS_RMAP_DELETE,
+	XFS_RMAP_MOVE,
+	XFS_RMAP_SLIDE,
+	XFS_RMAP_RESIZE,
+};
+
+struct xfs_rmap_intent {
+	struct xfs_rmap_intent			*ri_next;
+	enum xfs_rmap_intent_type		ri_type;
+	xfs_ino_t				ri_ino;
+	int					ri_whichfork;
+	struct xfs_bmbt_irec			ri_prev;
+	union {
+		struct {
+			struct xfs_bmbt_irec	left;
+			struct xfs_bmbt_irec	right;
+		} a;
+		struct {
+			long			adj;
+		} b;
+	} ri_u;
+};
+
+void	xfs_rmap_cancel(struct xfs_rmap_list *rlist);
+int	__xfs_rmap_finish(struct xfs_mount *mp, struct xfs_trans *tp,
+			struct xfs_rmap_list *rlist);
+int	xfs_rmap_finish(struct xfs_mount *mp, struct xfs_trans **tpp,
+			struct xfs_inode *ip, struct xfs_rmap_list *rlist,
+			int *committed);
+
 #endif	/* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b8dfa93..d844997 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -109,10 +109,16 @@ xfs_bmap_finish(
 	struct xfs_bmap_free_item	*next;	/* next item on free list */
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
-	if (flist->xbf_count == 0) {
-		*committed = 0;
+
+	*committed = 0;
+	error = xfs_rmap_finish((*tp)->t_mountp, tp, ip, &flist->xbf_rlist,
+			committed);
+	if (error)
+		return error;
+
+	if (flist->xbf_count == 0)
 		return 0;
-	}
+
 	efi = xfs_trans_get_efi(*tp, flist->xbf_count);
 	for (free = flist->xbf_first; free; free = free->xbfi_next)
 		xfs_trans_log_efi_extent(*tp, efi, free->xbfi_startblock,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
