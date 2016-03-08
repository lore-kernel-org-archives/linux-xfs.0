Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD66829E3F
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 22:17:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 807268F804B
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 20:17:20 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pWEUVbZJTgi128Kt for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2016 20:17:13 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ad94T-0004AS-6W
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:33 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ad94G-0007vG-Ky
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/16] xfs: piggyback rmapbt update intents in the bmap free
	structure
Date: Tue,  8 Mar 2016 15:16:18 +1100
Message-Id: <1457410578-30233-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1457410578-30233-1-git-send-email-david@fromorbit.com>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Extend the xfs_bmap_free structure to track a list of rmapbt update
intents. Record the changes being made in the new rmapbt intent list
and add hooks to process the changes to xfs_bmap_finish().

Subsequent patches will implement the rmapbt updates recorded in
the intents, allowing us to re-order the rmapbt changes to avoid
deadlocks (e.g. AG ordering rules) and sanely log the changes
without blowing out transaction reservation sizes.

This patch is derived from a couple of original patches from
Darrick, split and merged by me, with a minor change to use
list_head for the linked list.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 179 +++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.h       |  16 ++-
 fs/xfs/libxfs/xfs_rmap.c       | 228 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h |  57 +++++++++++
 fs/xfs/xfs_bmap_util.c         |   6 ++
 5 files changed, 479 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f8d33c5..3ee3b8c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -45,6 +45,7 @@
 #include "xfs_symlink.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_filestream.h"
+#include "xfs_rmap_btree.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -648,6 +649,8 @@ xfs_bmap_cancel(
 	xfs_bmap_free_item_t	*free;	/* free list item */
 	xfs_bmap_free_item_t	*next;
 
+	xfs_rmap_cancel(&flist->xbf_rlist);
+
 	if (flist->xbf_count == 0)
 		return;
 	ASSERT(flist->xbf_first != NULL);
@@ -1869,6 +1872,10 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_combine(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &LEFT, &RIGHT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -1901,6 +1908,10 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_resize(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &LEFT, PREV.br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1932,6 +1943,10 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_move(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &RIGHT, -PREV.br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -1961,6 +1976,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, new);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -1996,6 +2015,10 @@ xfs_bmap_add_extent_delay_real(
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
@@ -2031,6 +2054,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, new);
+		if (error)
+			goto done;
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
@@ -2079,6 +2106,8 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_move(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &RIGHT, -new->br_blockcount);
 
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock));
@@ -2115,6 +2144,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, new);
+		if (error)
+			goto done;
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
@@ -2184,6 +2217,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, new);
+		if (error)
+			goto done;
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
@@ -2425,6 +2462,10 @@ xfs_bmap_add_extent_unwritten_real(
 				RIGHT.br_blockcount, LEFT.br_state)))
 				goto done;
 		}
+		error = xfs_rmap_combine(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &LEFT, &RIGHT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -2462,6 +2503,10 @@ xfs_bmap_add_extent_unwritten_real(
 				LEFT.br_state)))
 				goto done;
 		}
+		error = xfs_rmap_lcombine(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &LEFT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -2497,6 +2542,10 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
+		error = xfs_rmap_rcombine(mp, &flist->xbf_rlist, ip->i_ino,
+				XFS_DATA_FORK, &RIGHT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -2523,6 +2572,11 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2570,6 +2624,14 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2608,6 +2670,14 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2650,6 +2720,14 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2690,6 +2768,14 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2751,6 +2837,19 @@ xfs_bmap_add_extent_unwritten_real(
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
@@ -2954,6 +3053,7 @@ xfs_bmap_add_extent_hole_real(
 	int			rval=0;	/* return value (logging flags) */
 	int			state;	/* state bits, accessed thru macros */
 	struct xfs_mount	*mp;
+	struct xfs_bmbt_irec	prev;	/* fake previous extent entry */
 
 	mp = bma->ip->i_mount;
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
@@ -3061,6 +3161,12 @@ xfs_bmap_add_extent_hole_real(
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
@@ -3093,6 +3199,10 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_resize(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &left, new->br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_RIGHT_CONTIG:
@@ -3127,6 +3237,10 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_move(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, &right, -new->br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case 0:
@@ -3155,6 +3269,10 @@ xfs_bmap_add_extent_hole_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(mp, bma->rlist, bma->ip->i_ino,
+				whichfork, new);
+		if (error)
+			goto done;
 		break;
 	}
 
@@ -4289,7 +4407,6 @@ xfs_bmapi_delay(
 	return 0;
 }
 
-
 static int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
@@ -4603,6 +4720,7 @@ xfs_bmapi_write(
 	bma.userdata = 0;
 	bma.flist = flist;
 	bma.firstblock = firstblock;
+	bma.rlist = &flist->xbf_rlist;
 
 	while (bno < end && n < *nmap) {
 		inhole = eof || bma.got.br_startoff > bno;
@@ -4861,6 +4979,10 @@ xfs_bmap_del_extent(
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
@@ -4888,6 +5010,10 @@ xfs_bmap_del_extent(
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
@@ -4914,6 +5040,10 @@ xfs_bmap_del_extent(
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
@@ -4939,6 +5069,15 @@ xfs_bmap_del_extent(
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
@@ -5175,6 +5314,7 @@ xfs_bunmapi(
 			got.br_startoff + got.br_blockcount - 1);
 		if (bno < start)
 			break;
+
 		/*
 		 * Then deal with the (possibly delayed) allocated space
 		 * we found.
@@ -5477,7 +5617,8 @@ xfs_bmse_merge(
 	struct xfs_bmbt_rec_host	*gotp,		/* extent to shift */
 	struct xfs_bmbt_rec_host	*leftp,		/* preceding extent */
 	struct xfs_btree_cur		*cur,
-	int				*logflags)	/* output */
+	int				*logflags,	/* output */
+	struct xfs_rmap_list		*rlist)		/* rmap intent list */
 {
 	struct xfs_bmbt_irec		got;
 	struct xfs_bmbt_irec		left;
@@ -5508,6 +5649,13 @@ xfs_bmse_merge(
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
@@ -5550,7 +5698,8 @@ xfs_bmse_shift_one(
 	struct xfs_bmbt_rec_host	*gotp,
 	struct xfs_btree_cur		*cur,
 	int				*logflags,
-	enum shift_direction		direction)
+	enum shift_direction		direction,
+	struct xfs_rmap_list		*rlist)
 {
 	struct xfs_ifork		*ifp;
 	struct xfs_mount		*mp;
@@ -5600,7 +5749,7 @@ xfs_bmse_shift_one(
 				       offset_shift_fsb)) {
 			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
 					      *current_ext, gotp, adj_irecp,
-					      cur, logflags);
+					      cur, logflags, rlist);
 		}
 	} else {
 		startoff = got.br_startoff + offset_shift_fsb;
@@ -5637,6 +5786,10 @@ update_current_ext:
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
@@ -5776,9 +5929,11 @@ xfs_bmap_shift_extents(
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
@@ -5831,6 +5986,7 @@ xfs_bmap_split_extent_at(
 	int				whichfork = XFS_DATA_FORK;
 	struct xfs_btree_cur		*cur = NULL;
 	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_irec		rgot;
 	struct xfs_bmbt_irec		got;
 	struct xfs_bmbt_irec		new; /* split extent */
 	struct xfs_mount		*mp = ip->i_mount;
@@ -5840,6 +5996,7 @@ xfs_bmap_split_extent_at(
 	int				error = 0;
 	int				logflags = 0;
 	int				i = 0;
+	long				adj;
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -5879,6 +6036,7 @@ xfs_bmap_split_extent_at(
 	if (got.br_startoff >= split_fsb)
 		return 0;
 
+	rgot = got;
 	gotblkcnt = split_fsb - got.br_startoff;
 	new.br_startoff = split_fsb;
 	new.br_startblock = got.br_startblock + gotblkcnt;
@@ -5934,6 +6092,17 @@ xfs_bmap_split_extent_at(
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
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 06dbe08..38cd9b5 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -56,6 +56,7 @@ struct xfs_bmalloca {
 	bool			conv;	/* overwriting unwritten extents */
 	char			userdata;/* userdata mask */
 	int			flags;
+	struct xfs_rmap_list	*rlist;
 };
 
 /*
@@ -70,6 +71,11 @@ typedef struct xfs_bmap_free_item
 	struct xfs_bmap_free_item *xbfi_next;	/* link to next entry */
 } xfs_bmap_free_item_t;
 
+struct xfs_rmap_list {
+	struct list_head	rl_list;
+	int			rl_count;
+};
+
 /*
  * Header for free extent list.
  *
@@ -89,6 +95,7 @@ typedef	struct xfs_bmap_free
 	xfs_bmap_free_item_t	*xbf_first;	/* list of to-be-free extents */
 	int			xbf_count;	/* count of items on list */
 	int			xbf_low;	/* alloc in low mode */
+	struct xfs_rmap_list	xbf_rlist;	/* rmap intent list */
 } xfs_bmap_free_t;
 
 #define	XFS_BMAP_MAX_NMAP	4
@@ -142,8 +149,13 @@ static inline int xfs_bmapi_aflag(int w)
 
 static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 {
-	((flp)->xbf_first = NULL, (flp)->xbf_count = 0, \
-		(flp)->xbf_low = 0, *(fbp) = NULLFSBLOCK);
+	flp->xbf_first = NULL;
+	flp->xbf_count = 0;
+	flp->xbf_low = 0;
+	*fbp = NULLFSBLOCK;
+
+	INIT_LIST_HEAD(&flp->xbf_rlist.rl_list);
+	flp->xbf_rlist.rl_count = 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 479cb73..a7130c5 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -35,6 +35,7 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
+#include "xfs_bmap.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
@@ -542,3 +543,230 @@ out_error:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 	return error;
 }
+
+
+/*
+ * Free up any items left in the list.
+ */
+void
+xfs_rmap_cancel(
+	struct xfs_rmap_list	*rlist)	/* list of bmap_free_items */
+{
+	if (list_empty(&rlist->rl_list))
+		return;
+	while (!list_empty(&rlist->rl_list)) {
+		struct xfs_rmap_intent *free;
+
+		free = list_first_entry(&rlist->rl_list, struct xfs_rmap_intent,
+					ri_list);
+		list_del(&free->ri_list);
+		kmem_free(free);
+	}
+	rlist->rl_count = 0;
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
+	struct xfs_rmap_list	*rlist)
+{
+	/* Not yet implemented, just cancel until implemented */
+	xfs_rmap_cancel(rlist);
+	return 0;
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
+	struct xfs_rmap_intent	*new;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+
+	new = kmem_zalloc(sizeof(struct xfs_rmap_intent), KM_SLEEP | KM_NOFS);
+	*new = *ri;
+	INIT_LIST_HEAD(&new->ri_list);
+
+	/* XXX: ordering will be needed */
+	list_add(&new->ri_list, &rlist->rl_list);
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
index d7c9722..599fa3a 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -21,6 +21,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xfs_rmap_list;
 
 /* rmaps only exist on crc enabled filesystems */
 #define XFS_RMAP_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
@@ -68,4 +69,60 @@ int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
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
+	struct list_head			ri_list;
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
+int	xfs_rmap_finish(struct xfs_mount *mp, struct xfs_trans **tpp,
+			struct xfs_inode *ip, struct xfs_rmap_list *rlist);
+
 #endif	/* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 834639d..a9cf94e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -40,6 +40,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_log.h"
+#include "xfs_rmap_btree.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -109,6 +110,11 @@ xfs_bmap_finish(
 	struct xfs_bmap_free_item	*next;	/* next item on free list */
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	error = xfs_rmap_finish((*tp)->t_mountp, tp, ip, &flist->xbf_rlist);
+	if (error)
+		return error;
+
 	if (flist->xbf_count == 0)
 		return 0;
 
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
