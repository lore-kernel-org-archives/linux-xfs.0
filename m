Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jul 2008 20:04:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6V34ZIw016108
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 20:04:35 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77958EE0CCD
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 20:05:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id kDNR1TEjgrCVTS1R for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 20:05:45 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id C1C29AC6275
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 22:05:43 -0500 (CDT)
Message-ID: <48912C07.7060705@sandeen.net>
Date: Wed, 30 Jul 2008 22:05:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] kill the last of the shouting-indirection macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

I think these are the last few macros-defined-to-static-inlines.

Compile-tested only.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

 quota/xfs_dquot.c  |    2 
 xfs_ag.h           |    8 +-
 xfs_alloc_btree.c  |    6 -
 xfs_attr.c         |   26 ++++----
 xfs_bit.h          |    7 --
 xfs_bmap.c         |  166 ++++++++++++++++++++++++++---------------------------
 xfs_bmap.h         |    2 
 xfs_bmap_btree.c   |  104 ++++++++++++++++-----------------
 xfs_bmap_btree.h   |    4 -
 xfs_da_btree.c     |    8 +-
 xfs_ialloc.c       |    4 -
 xfs_ialloc.h       |    2 
 xfs_ialloc_btree.c |    6 -
 xfs_ialloc_btree.h |    1 
 xfs_inode.c        |    6 -
 xfs_inode_item.h   |    9 --
 xfs_iomap.c        |   10 +--
 xfs_itable.c       |    6 -
 xfs_mount.h        |    6 -
 xfs_rename.c       |    2 
 xfs_rtalloc.c      |    2 
 xfs_rw.h           |    1 
 xfs_sb.h           |    2 
 xfs_vnodeops.c     |   20 +++---
 xfsidbg.c          |    4 -
 25 files changed, 196 insertions(+), 218 deletions(-)


Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c
@@ -549,9 +549,9 @@ xfs_bmap_add_extent(
 		xfs_iext_insert(ifp, 0, 1, new);
 		ASSERT(cur == NULL);
 		ifp->if_lastex = 0;
-		if (!ISNULLSTARTBLOCK(new->br_startblock)) {
+		if (!isnullstartblock(new->br_startblock)) {
 			XFS_IFORK_NEXT_SET(ip, whichfork, 1);
-			logflags = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+			logflags = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else
 			logflags = 0;
 		/* DELTA: single new extent */
@@ -567,7 +567,7 @@ xfs_bmap_add_extent(
 	/*
 	 * Any kind of new delayed allocation goes here.
 	 */
-	else if (ISNULLSTARTBLOCK(new->br_startblock)) {
+	else if (isnullstartblock(new->br_startblock)) {
 		if (cur)
 			ASSERT((cur->bc_private.b.flags &
 				XFS_BTCUR_BPRV_WASDEL) == 0);
@@ -598,11 +598,11 @@ xfs_bmap_add_extent(
 		 * in a delayed or unwritten allocation with a real one, or
 		 * converting real back to unwritten.
 		 */
-		if (!ISNULLSTARTBLOCK(new->br_startblock) &&
+		if (!isnullstartblock(new->br_startblock) &&
 		    new->br_startoff + new->br_blockcount > prev.br_startoff) {
 			if (prev.br_state != XFS_EXT_UNWRITTEN &&
-			    ISNULLSTARTBLOCK(prev.br_startblock)) {
-				da_old = STARTBLOCKVAL(prev.br_startblock);
+			    isnullstartblock(prev.br_startblock)) {
+				da_old = startblockval(prev.br_startblock);
 				if (cur)
 					ASSERT(cur->bc_private.b.flags &
 						XFS_BTCUR_BPRV_WASDEL);
@@ -757,7 +757,7 @@ xfs_bmap_add_extent_delay_real(
 	 */
 	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &LEFT);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(LEFT.br_startblock));
+		STATE_SET(LEFT_DELAY, isnullstartblock(LEFT.br_startblock));
 	}
 	STATE_SET(LEFT_CONTIG,
 		STATE_TEST(LEFT_VALID) && !STATE_TEST(LEFT_DELAY) &&
@@ -774,7 +774,7 @@ xfs_bmap_add_extent_delay_real(
 			idx <
 			ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx + 1), &RIGHT);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(RIGHT.br_startblock));
+		STATE_SET(RIGHT_DELAY, isnullstartblock(RIGHT.br_startblock));
 	}
 	STATE_SET(RIGHT_CONTIG,
 		STATE_TEST(RIGHT_VALID) && !STATE_TEST(RIGHT_DELAY) &&
@@ -973,8 +973,8 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock));
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+			startblockval(PREV.br_startblock));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		XFS_BMAP_TRACE_POST_UPDATE("LF|LC", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: The boundary between two in-core extents moved. */
@@ -1021,10 +1021,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock) -
+			startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx + 1);
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		XFS_BMAP_TRACE_POST_UPDATE("LF", ip, idx + 1, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: One in-core extent is split in two. */
@@ -1064,8 +1064,8 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock));
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+			startblockval(PREV.br_startblock));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		XFS_BMAP_TRACE_POST_UPDATE("RF|RC", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: The boundary between two in-core extents moved. */
@@ -1111,10 +1111,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-			STARTBLOCKVAL(PREV.br_startblock) -
+			startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, idx);
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		XFS_BMAP_TRACE_POST_UPDATE("RF", ip, idx, XFS_DATA_FORK);
 		*dnew = temp;
 		/* DELTA: One in-core extent is split in two. */
@@ -1167,7 +1167,7 @@ xfs_bmap_add_extent_delay_real(
 		}
 		temp = xfs_bmap_worst_indlen(ip, temp);
 		temp2 = xfs_bmap_worst_indlen(ip, temp2);
-		diff = (int)(temp + temp2 - STARTBLOCKVAL(PREV.br_startblock) -
+		diff = (int)(temp + temp2 - startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		if (diff > 0 &&
 		    xfs_mod_incore_sb(ip->i_mount, XFS_SBS_FDBLOCKS, -((int64_t)diff), rsvd)) {
@@ -1195,11 +1195,11 @@ xfs_bmap_add_extent_delay_real(
 			}
 		}
 		ep = xfs_iext_get_ext(ifp, idx);
-		xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx, XFS_DATA_FORK);
 		XFS_BMAP_TRACE_PRE_UPDATE("0", ip, idx + 2, XFS_DATA_FORK);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx + 2),
-			NULLSTARTBLOCK((int)temp2));
+			nullstartblock((int)temp2));
 		XFS_BMAP_TRACE_POST_UPDATE("0", ip, idx + 2, XFS_DATA_FORK);
 		*dnew = temp + temp2;
 		/* DELTA: One in-core extent is split in three. */
@@ -1319,7 +1319,7 @@ xfs_bmap_add_extent_unwritten_real(
 	 */
 	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &LEFT);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(LEFT.br_startblock));
+		STATE_SET(LEFT_DELAY, isnullstartblock(LEFT.br_startblock));
 	}
 	STATE_SET(LEFT_CONTIG,
 		STATE_TEST(LEFT_VALID) && !STATE_TEST(LEFT_DELAY) &&
@@ -1336,7 +1336,7 @@ xfs_bmap_add_extent_unwritten_real(
 			idx <
 			ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx + 1), &RIGHT);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(RIGHT.br_startblock));
+		STATE_SET(RIGHT_DELAY, isnullstartblock(RIGHT.br_startblock));
 	}
 	STATE_SET(RIGHT_CONTIG,
 		STATE_TEST(RIGHT_VALID) && !STATE_TEST(RIGHT_DELAY) &&
@@ -1843,13 +1843,13 @@ xfs_bmap_add_extent_hole_delay(
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	ep = xfs_iext_get_ext(ifp, idx);
 	state = 0;
-	ASSERT(ISNULLSTARTBLOCK(new->br_startblock));
+	ASSERT(isnullstartblock(new->br_startblock));
 	/*
 	 * Check and set flags if this segment has a left neighbor
 	 */
 	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &left);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(left.br_startblock));
+		STATE_SET(LEFT_DELAY, isnullstartblock(left.br_startblock));
 	}
 	/*
 	 * Check and set flags if the current (right) segment exists.
@@ -1859,7 +1859,7 @@ xfs_bmap_add_extent_hole_delay(
 			   idx <
 			   ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
 		xfs_bmbt_get_all(ep, &right);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(right.br_startblock));
+		STATE_SET(RIGHT_DELAY, isnullstartblock(right.br_startblock));
 	}
 	/*
 	 * Set contiguity flags on the left and right neighbors.
@@ -1892,12 +1892,12 @@ xfs_bmap_add_extent_hole_delay(
 		XFS_BMAP_TRACE_PRE_UPDATE("LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
-		oldlen = STARTBLOCKVAL(left.br_startblock) +
-			STARTBLOCKVAL(new->br_startblock) +
-			STARTBLOCKVAL(right.br_startblock);
+		oldlen = startblockval(left.br_startblock) +
+			startblockval(new->br_startblock) +
+			startblockval(right.br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
-			NULLSTARTBLOCK((int)newlen));
+			nullstartblock((int)newlen));
 		XFS_BMAP_TRACE_POST_UPDATE("LC|RC", ip, idx - 1,
 			XFS_DATA_FORK);
 		XFS_BMAP_TRACE_DELETE("LC|RC", ip, idx, 1, XFS_DATA_FORK);
@@ -1918,11 +1918,11 @@ xfs_bmap_add_extent_hole_delay(
 		XFS_BMAP_TRACE_PRE_UPDATE("LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1), temp);
-		oldlen = STARTBLOCKVAL(left.br_startblock) +
-			STARTBLOCKVAL(new->br_startblock);
+		oldlen = startblockval(left.br_startblock) +
+			startblockval(new->br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, idx - 1),
-			NULLSTARTBLOCK((int)newlen));
+			nullstartblock((int)newlen));
 		XFS_BMAP_TRACE_POST_UPDATE("LC", ip, idx - 1,
 			XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx - 1;
@@ -1939,11 +1939,11 @@ xfs_bmap_add_extent_hole_delay(
 		 */
 		XFS_BMAP_TRACE_PRE_UPDATE("RC", ip, idx, XFS_DATA_FORK);
 		temp = new->br_blockcount + right.br_blockcount;
-		oldlen = STARTBLOCKVAL(new->br_startblock) +
-			STARTBLOCKVAL(right.br_startblock);
+		oldlen = startblockval(new->br_startblock) +
+			startblockval(right.br_startblock);
 		newlen = xfs_bmap_worst_indlen(ip, temp);
 		xfs_bmbt_set_allf(ep, new->br_startoff,
-			NULLSTARTBLOCK((int)newlen), temp, right.br_state);
+			nullstartblock((int)newlen), temp, right.br_state);
 		XFS_BMAP_TRACE_POST_UPDATE("RC", ip, idx, XFS_DATA_FORK);
 		ip->i_df.if_lastex = idx;
 		/* DELTA: One in-core extent grew into a hole. */
@@ -2039,7 +2039,7 @@ xfs_bmap_add_extent_hole_real(
 	 */
 	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &left);
-		STATE_SET(LEFT_DELAY, ISNULLSTARTBLOCK(left.br_startblock));
+		STATE_SET(LEFT_DELAY, isnullstartblock(left.br_startblock));
 	}
 	/*
 	 * Check and set flags if this segment has a current value.
@@ -2049,7 +2049,7 @@ xfs_bmap_add_extent_hole_real(
 			   idx <
 			   ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
 		xfs_bmbt_get_all(ep, &right);
-		STATE_SET(RIGHT_DELAY, ISNULLSTARTBLOCK(right.br_startblock));
+		STATE_SET(RIGHT_DELAY, isnullstartblock(right.br_startblock));
 	}
 	/*
 	 * We're inserting a real allocation between "left" and "right".
@@ -2097,7 +2097,7 @@ xfs_bmap_add_extent_hole_real(
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		if (cur == NULL) {
-			rval = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2139,7 +2139,7 @@ xfs_bmap_add_extent_hole_real(
 		XFS_BMAP_TRACE_POST_UPDATE("LC", ip, idx - 1, whichfork);
 		ifp->if_lastex = idx - 1;
 		if (cur == NULL) {
-			rval = XFS_ILOG_FEXT(whichfork);
+			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2174,7 +2174,7 @@ xfs_bmap_add_extent_hole_real(
 		XFS_BMAP_TRACE_POST_UPDATE("RC", ip, idx, whichfork);
 		ifp->if_lastex = idx;
 		if (cur == NULL) {
-			rval = XFS_ILOG_FEXT(whichfork);
+			rval = xfs_ilog_fext(whichfork);
 		} else {
 			rval = 0;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2208,7 +2208,7 @@ xfs_bmap_add_extent_hole_real(
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		if (cur == NULL) {
-			rval = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+			rval = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 		} else {
 			rval = XFS_ILOG_CORE;
 			if ((error = xfs_bmbt_lookup_eq(cur,
@@ -2436,7 +2436,7 @@ xfs_bmap_adjacent(
 	 * try to use it's last block as our starting point.
 	 */
 	if (ap->eof && ap->prevp->br_startoff != NULLFILEOFF &&
-	    !ISNULLSTARTBLOCK(ap->prevp->br_startblock) &&
+	    !isnullstartblock(ap->prevp->br_startblock) &&
 	    ISVALID(ap->prevp->br_startblock + ap->prevp->br_blockcount,
 		    ap->prevp->br_startblock)) {
 		ap->rval = ap->prevp->br_startblock + ap->prevp->br_blockcount;
@@ -2465,7 +2465,7 @@ xfs_bmap_adjacent(
 		 * start block based on it.
 		 */
 		if (ap->prevp->br_startoff != NULLFILEOFF &&
-		    !ISNULLSTARTBLOCK(ap->prevp->br_startblock) &&
+		    !isnullstartblock(ap->prevp->br_startblock) &&
 		    (prevbno = ap->prevp->br_startblock +
 			       ap->prevp->br_blockcount) &&
 		    ISVALID(prevbno, ap->prevp->br_startblock)) {
@@ -2506,7 +2506,7 @@ xfs_bmap_adjacent(
 		 * If there's a following (right) block, select a requested
 		 * start block based on it.
 		 */
-		if (!ISNULLSTARTBLOCK(ap->gotp->br_startblock)) {
+		if (!isnullstartblock(ap->gotp->br_startblock)) {
 			/*
 			 * Calculate gap to start of next block.
 			 */
@@ -3036,7 +3036,7 @@ xfs_bmap_btree_to_extents(
 	ASSERT(ifp->if_broot == NULL);
 	ASSERT((ifp->if_flags & XFS_IFBROOT) == 0);
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
-	*logflagsp = XFS_ILOG_CORE | XFS_ILOG_FEXT(whichfork);
+	*logflagsp = XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 	return 0;
 }
 
@@ -3090,8 +3090,8 @@ xfs_bmap_del_extent(
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got.br_startoff + got.br_blockcount;
 	ASSERT(got_endoff >= del_endoff);
-	delay = ISNULLSTARTBLOCK(got.br_startblock);
-	ASSERT(ISNULLSTARTBLOCK(del->br_startblock) == delay);
+	delay = isnullstartblock(got.br_startblock);
+	ASSERT(isnullstartblock(del->br_startblock) == delay);
 	flags = 0;
 	qfield = 0;
 	error = 0;
@@ -3143,7 +3143,7 @@ xfs_bmap_del_extent(
 		}
 		da_old = da_new = 0;
 	} else {
-		da_old = STARTBLOCKVAL(got.br_startblock);
+		da_old = startblockval(got.br_startblock);
 		da_new = 0;
 		nblks = 0;
 		do_fx = 0;
@@ -3167,7 +3167,7 @@ xfs_bmap_del_extent(
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		flags |= XFS_ILOG_CORE;
 		if (!cur) {
-			flags |= XFS_ILOG_FEXT(whichfork);
+			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_bmbt_delete(cur, &i)))
@@ -3187,7 +3187,7 @@ xfs_bmap_del_extent(
 		if (delay) {
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
-			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 			XFS_BMAP_TRACE_POST_UPDATE("2", ip, idx,
 				whichfork);
 			da_new = temp;
@@ -3196,7 +3196,7 @@ xfs_bmap_del_extent(
 		xfs_bmbt_set_startblock(ep, del_endblock);
 		XFS_BMAP_TRACE_POST_UPDATE("2", ip, idx, whichfork);
 		if (!cur) {
-			flags |= XFS_ILOG_FEXT(whichfork);
+			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_bmbt_update(cur, del_endoff, del_endblock,
@@ -3216,7 +3216,7 @@ xfs_bmap_del_extent(
 		if (delay) {
 			temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 				da_old);
-			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 			XFS_BMAP_TRACE_POST_UPDATE("1", ip, idx,
 				whichfork);
 			da_new = temp;
@@ -3224,7 +3224,7 @@ xfs_bmap_del_extent(
 		}
 		XFS_BMAP_TRACE_POST_UPDATE("1", ip, idx, whichfork);
 		if (!cur) {
-			flags |= XFS_ILOG_FEXT(whichfork);
+			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_bmbt_update(cur, got.br_startoff,
@@ -3299,22 +3299,22 @@ xfs_bmap_del_extent(
 				}
 				XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			} else
-				flags |= XFS_ILOG_FEXT(whichfork);
+				flags |= xfs_ilog_fext(whichfork);
 			XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		} else {
 			ASSERT(whichfork == XFS_DATA_FORK);
 			temp = xfs_bmap_worst_indlen(ip, temp);
-			xfs_bmbt_set_startblock(ep, NULLSTARTBLOCK((int)temp));
+			xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
 			temp2 = xfs_bmap_worst_indlen(ip, temp2);
-			new.br_startblock = NULLSTARTBLOCK((int)temp2);
+			new.br_startblock = nullstartblock((int)temp2);
 			da_new = temp + temp2;
 			while (da_new > da_old) {
 				if (temp) {
 					temp--;
 					da_new--;
 					xfs_bmbt_set_startblock(ep,
-						NULLSTARTBLOCK((int)temp));
+						nullstartblock((int)temp));
 				}
 				if (da_new == da_old)
 					break;
@@ -3322,7 +3322,7 @@ xfs_bmap_del_extent(
 					temp2--;
 					da_new--;
 					new.br_startblock =
-						NULLSTARTBLOCK((int)temp2);
+						nullstartblock((int)temp2);
 				}
 			}
 		}
@@ -3498,7 +3498,7 @@ xfs_bmap_extents_to_btree(
 	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
 	for (cnt = i = 0; i < nextents; i++) {
 		ep = xfs_iext_get_ext(ifp, i);
-		if (!ISNULLSTARTBLOCK(xfs_bmbt_get_startblock(ep))) {
+		if (!isnullstartblock(xfs_bmbt_get_startblock(ep))) {
 			arp->l0 = cpu_to_be64(ep->l0);
 			arp->l1 = cpu_to_be64(ep->l1);
 			arp++; cnt++;
@@ -3522,7 +3522,7 @@ xfs_bmap_extents_to_btree(
 	xfs_bmbt_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
 	ASSERT(*curp == NULL);
 	*curp = cur;
-	*logflagsp = XFS_ILOG_CORE | XFS_ILOG_FBROOT(whichfork);
+	*logflagsp = XFS_ILOG_CORE | xfs_ilog_fbroot(whichfork);
 	return 0;
 }
 
@@ -3626,7 +3626,7 @@ xfs_bmap_local_to_extents(
 		ip->i_d.di_nblocks = 1;
 		XFS_TRANS_MOD_DQUOT_BYINO(args.mp, tp, ip,
 			XFS_TRANS_DQ_BCOUNT, 1L);
-		flags |= XFS_ILOG_FEXT(whichfork);
+		flags |= xfs_ilog_fext(whichfork);
 	} else {
 		ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) == 0);
 		xfs_bmap_forkoff_reset(ip->i_mount, ip, whichfork);
@@ -4032,7 +4032,7 @@ xfs_bmap_add_attrfork(
 		XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
-	XFS_BMAP_INIT(&flist, &firstblock);
+	xfs_bmap_init(&flist, &firstblock);
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &flist,
@@ -4112,7 +4112,7 @@ xfs_bmap_add_free(
 	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(len > 0);
 	ASSERT(len <= MAXEXTLEN);
-	ASSERT(!ISNULLSTARTBLOCK(bno));
+	ASSERT(!isnullstartblock(bno));
 	agno = XFS_FSB_TO_AGNO(mp, bno);
 	agbno = XFS_FSB_TO_AGBNO(mp, bno);
 	ASSERT(agno < mp->m_sb.sb_agcount);
@@ -4837,7 +4837,7 @@ xfs_bmapi(
 			got.br_startoff = end;
 		inhole = eof || got.br_startoff > bno;
 		wasdelay = wr && !inhole && !(flags & XFS_BMAPI_DELAY) &&
-			ISNULLSTARTBLOCK(got.br_startblock);
+			isnullstartblock(got.br_startblock);
 		/*
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
@@ -4956,7 +4956,7 @@ xfs_bmapi(
 				}
 
 				ip->i_delayed_blks += alen;
-				abno = NULLSTARTBLOCK(indlen);
+				abno = nullstartblock(indlen);
 			} else {
 				/*
 				 * If first time, allocate and fill in
@@ -5073,8 +5073,8 @@ xfs_bmapi(
 				aoff + alen);
 #ifdef DEBUG
 			if (flags & XFS_BMAPI_DELAY) {
-				ASSERT(ISNULLSTARTBLOCK(got.br_startblock));
-				ASSERT(STARTBLOCKVAL(got.br_startblock) > 0);
+				ASSERT(isnullstartblock(got.br_startblock));
+				ASSERT(startblockval(got.br_startblock) > 0);
 			}
 			ASSERT(got.br_state == XFS_EXT_NORM ||
 			       got.br_state == XFS_EXT_UNWRITTEN);
@@ -5108,7 +5108,7 @@ xfs_bmapi(
 			ASSERT((bno >= obno) || (n == 0));
 			ASSERT(bno < end);
 			mval->br_startoff = bno;
-			if (ISNULLSTARTBLOCK(got.br_startblock)) {
+			if (isnullstartblock(got.br_startblock)) {
 				ASSERT(!wr || (flags & XFS_BMAPI_DELAY));
 				mval->br_startblock = DELAYSTARTBLOCK;
 			} else
@@ -5130,7 +5130,7 @@ xfs_bmapi(
 			ASSERT(mval->br_blockcount <= len);
 		} else {
 			*mval = got;
-			if (ISNULLSTARTBLOCK(mval->br_startblock)) {
+			if (isnullstartblock(mval->br_startblock)) {
 				ASSERT(!wr || (flags & XFS_BMAPI_DELAY));
 				mval->br_startblock = DELAYSTARTBLOCK;
 			}
@@ -5259,12 +5259,12 @@ error0:
 	 * Log everything.  Do this after conversion, there's no point in
 	 * logging the extent records if we've converted to btree format.
 	 */
-	if ((logflags & XFS_ILOG_FEXT(whichfork)) &&
+	if ((logflags & xfs_ilog_fext(whichfork)) &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-		logflags &= ~XFS_ILOG_FEXT(whichfork);
-	else if ((logflags & XFS_ILOG_FBROOT(whichfork)) &&
+		logflags &= ~xfs_ilog_fext(whichfork);
+	else if ((logflags & xfs_ilog_fbroot(whichfork)) &&
 		 XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)
-		logflags &= ~XFS_ILOG_FBROOT(whichfork);
+		logflags &= ~xfs_ilog_fbroot(whichfork);
 	/*
 	 * Log whatever the flags say, even if error.  Otherwise we might miss
 	 * detecting a case where the data is changed, there's an error,
@@ -5341,7 +5341,7 @@ xfs_bmapi_single(
 		*fsb = NULLFSBLOCK;
 		return 0;
 	}
-	ASSERT(!ISNULLSTARTBLOCK(got.br_startblock));
+	ASSERT(!isnullstartblock(got.br_startblock));
 	ASSERT(bno < got.br_startoff + got.br_blockcount);
 	*fsb = got.br_startblock + (bno - got.br_startoff);
 	ifp->if_lastex = lastx;
@@ -5474,7 +5474,7 @@ xfs_bunmapi(
 		 */
 		ASSERT(ep != NULL);
 		del = got;
-		wasdel = ISNULLSTARTBLOCK(del.br_startblock);
+		wasdel = isnullstartblock(del.br_startblock);
 		if (got.br_startoff < start) {
 			del.br_startoff = start;
 			del.br_blockcount -= start - got.br_startoff;
@@ -5569,7 +5569,7 @@ xfs_bunmapi(
 				xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
 						lastx - 1), &prev);
 				ASSERT(prev.br_state == XFS_EXT_NORM);
-				ASSERT(!ISNULLSTARTBLOCK(prev.br_startblock));
+				ASSERT(!isnullstartblock(prev.br_startblock));
 				ASSERT(del.br_startblock ==
 				       prev.br_startblock + prev.br_blockcount);
 				if (prev.br_startoff < start) {
@@ -5597,7 +5597,7 @@ xfs_bunmapi(
 			}
 		}
 		if (wasdel) {
-			ASSERT(STARTBLOCKVAL(del.br_startblock) > 0);
+			ASSERT(startblockval(del.br_startblock) > 0);
 			/* Update realtime/data freespace, unreserve quota */
 			if (isrt) {
 				xfs_filblks_t rtexts;
@@ -5713,12 +5713,12 @@ error0:
 	 * Log everything.  Do this after conversion, there's no point in
 	 * logging the extent records if we've converted to btree format.
 	 */
-	if ((logflags & XFS_ILOG_FEXT(whichfork)) &&
+	if ((logflags & xfs_ilog_fext(whichfork)) &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-		logflags &= ~XFS_ILOG_FEXT(whichfork);
-	else if ((logflags & XFS_ILOG_FBROOT(whichfork)) &&
+		logflags &= ~xfs_ilog_fext(whichfork);
+	else if ((logflags & xfs_ilog_fbroot(whichfork)) &&
 		 XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)
-		logflags &= ~XFS_ILOG_FBROOT(whichfork);
+		logflags &= ~xfs_ilog_fbroot(whichfork);
 	/*
 	 * Log inode even in the error case, if the transaction
 	 * is dirty we'll need to shut down the filesystem.
@@ -5763,7 +5763,7 @@ xfs_getbmapx_fix_eof_hole(
 			out->bmv_length = fixlen;
 		}
 	} else {
-		out->bmv_block = XFS_FSB_TO_DB(ip, startblock);
+		out->bmv_block = xfs_fsb_to_db(ip, startblock);
 	}
 
 	return 1;
@@ -5895,7 +5895,7 @@ xfs_getbmap(
 	if (nex > XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1)
 		nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;
 
-	bmapi_flags = XFS_BMAPI_AFLAG(whichfork) |
+	bmapi_flags = xfs_bmapi_aflag(whichfork) |
 			((sh_unwritten) ? 0 : XFS_BMAPI_IGSTATE);
 
 	/*
@@ -6023,7 +6023,7 @@ xfs_bmap_isaeof(
 	 */
 	*aeof = (off >= s.br_startoff &&
 		 off < s.br_startoff + s.br_blockcount &&
-		 ISNULLSTARTBLOCK(s.br_startblock)) ||
+		 isnullstartblock(s.br_startblock)) ||
 		off >= s.br_startoff + s.br_blockcount;
 	return 0;
 }
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c
@@ -3264,8 +3264,8 @@ xfs_fmtfsblock(xfs_fsblock_t bno, xfs_mo
 
 	if (bno == NULLFSBLOCK)
 		sprintf(rval, "NULLFSBLOCK");
-	else if (ISNULLSTARTBLOCK(bno))
-		sprintf(rval, "NULLSTARTBLOCK(%Ld)", STARTBLOCKVAL(bno));
+	else if (isnullstartblock(bno))
+		sprintf(rval, "nullstartblock(%Ld)", startblockval(bno));
 	else if (mp)
 		sprintf(rval, "%Ld[%x:%x]", (xfs_dfsbno_t)bno,
 			XFS_FSB_TO_AGNO(mp, bno), XFS_FSB_TO_AGBNO(mp, bno));
Index: linux-2.6-xfs/fs/xfs/xfs_ag.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ag.h
+++ linux-2.6-xfs/fs/xfs/xfs_ag.h
@@ -220,7 +220,7 @@ typedef struct xfs_perag
 #define	XFS_FSB_TO_AGNO(mp,fsbno)	\
 	((xfs_agnumber_t)((fsbno) >> (mp)->m_sb.sb_agblklog))
 #define	XFS_FSB_TO_AGBNO(mp,fsbno)	\
-	((xfs_agblock_t)((fsbno) & XFS_MASK32LO((mp)->m_sb.sb_agblklog)))
+	((xfs_agblock_t)((fsbno) & xfs_mask32lo((mp)->m_sb.sb_agblklog)))
 #define	XFS_AGB_TO_DADDR(mp,agno,agbno)	\
 	((xfs_daddr_t)XFS_FSB_TO_BB(mp, \
 		(xfs_fsblock_t)(agno) * (mp)->m_sb.sb_agblocks + (agbno)))
@@ -233,8 +233,8 @@ typedef struct xfs_perag
 #define	XFS_AG_CHECK_DADDR(mp,d,len)	\
 	((len) == 1 ? \
 	    ASSERT((d) == XFS_SB_DADDR || \
-		   XFS_DADDR_TO_AGBNO(mp, d) != XFS_SB_DADDR) : \
-	    ASSERT(XFS_DADDR_TO_AGNO(mp, d) == \
-		   XFS_DADDR_TO_AGNO(mp, (d) + (len) - 1)))
+		   xfs_daddr_to_agbno(mp, d) != XFS_SB_DADDR) : \
+	    ASSERT(xfs_daddr_to_agno(mp, d) == \
+		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
 
 #endif	/* __XFS_AG_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_alloc_btree.c
+++ linux-2.6-xfs/fs/xfs/xfs_alloc_btree.c
@@ -1368,7 +1368,7 @@ xfs_alloc_newroot(
 		/*
 		 * Our block is left, pick up the right block.
 		 */
-		lbno = XFS_DADDR_TO_AGBNO(mp, XFS_BUF_ADDR(lbp));
+		lbno = xfs_daddr_to_agbno(mp, XFS_BUF_ADDR(lbp));
 		rbno = be32_to_cpu(left->bb_rightsib);
 		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
 				cur->bc_private.a.agno, rbno, 0, &rbp,
@@ -1385,7 +1385,7 @@ xfs_alloc_newroot(
 		 */
 		rbp = lbp;
 		right = left;
-		rbno = XFS_DADDR_TO_AGBNO(mp, XFS_BUF_ADDR(rbp));
+		rbno = xfs_daddr_to_agbno(mp, XFS_BUF_ADDR(rbp));
 		lbno = be32_to_cpu(right->bb_leftsib);
 		if ((error = xfs_btree_read_bufs(mp, cur->bc_tp,
 				cur->bc_private.a.agno, lbno, 0, &lbp,
@@ -1688,7 +1688,7 @@ xfs_alloc_split(
 	 * Find the left block number by looking in the buffer.
 	 * Adjust numrecs, sibling pointers.
 	 */
-	lbno = XFS_DADDR_TO_AGBNO(cur->bc_mp, XFS_BUF_ADDR(lbp));
+	lbno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(lbp));
 	be16_add(&left->bb_numrecs, -(be16_to_cpu(right->bb_numrecs)));
 	right->bb_rightsib = left->bb_rightsib;
 	left->bb_rightsib = cpu_to_be32(rbno);
Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c
+++ linux-2.6-xfs/fs/xfs/xfs_attr.c
@@ -374,7 +374,7 @@ xfs_attr_set_int(xfs_inode_t *dp, struct
 		 * It won't fit in the shortform, transform to a leaf block.
 		 * GROT: another possible req'mt for a double-split btree op.
 		 */
-		XFS_BMAP_INIT(args.flist, args.firstblock);
+		xfs_bmap_init(args.flist, args.firstblock);
 		error = xfs_attr_shortform_to_leaf(&args);
 		if (!error) {
 			error = xfs_bmap_finish(&args.trans, args.flist,
@@ -956,7 +956,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *arg
 		 * Commit that transaction so that the node_addname() call
 		 * can manage its own transactions.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_attr_leaf_to_node(args);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
@@ -1057,7 +1057,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *arg
 		 * If the result is small enough, shrink it all into the inode.
 		 */
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error) {
@@ -1135,7 +1135,7 @@ xfs_attr_leaf_removename(xfs_da_args_t *
 	 * If the result is small enough, shrink it all into the inode.
 	 */
 	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
 		/* bp is gone due to xfs_da_shrink_inode */
 		if (!error) {
@@ -1290,7 +1290,7 @@ restart:
 			 * have been a b-tree.
 			 */
 			xfs_da_state_free(state);
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr_leaf_to_node(args);
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
@@ -1331,7 +1331,7 @@ restart:
 		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
 		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da_split(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
@@ -1443,7 +1443,7 @@ restart:
 		 * Check to see if the tree needs to be collapsed.
 		 */
 		if (retval && (state->path.active > 1)) {
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_da_join(state);
 			if (!error) {
 				error = xfs_bmap_finish(&args->trans,
@@ -1579,7 +1579,7 @@ xfs_attr_node_removename(xfs_da_args_t *
 	 * Check to see if the tree needs to be collapsed.
 	 */
 	if (retval && (state->path.active > 1)) {
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_da_join(state);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
@@ -1630,7 +1630,7 @@ xfs_attr_node_removename(xfs_da_args_t *
 						       == XFS_ATTR_LEAF_MAGIC);
 
 		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
-			XFS_BMAP_INIT(args->flist, args->firstblock);
+			xfs_bmap_init(args->flist, args->firstblock);
 			error = xfs_attr_leaf_to_shortform(bp, args, forkoff);
 			/* bp is gone due to xfs_da_shrink_inode */
 			if (!error) {
@@ -2069,7 +2069,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		/*
 		 * Allocate a single extent, up to the size of the value.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi(args->trans, dp, (xfs_fileoff_t)lblkno,
 				  blkcnt,
@@ -2123,7 +2123,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi(NULL, dp, (xfs_fileoff_t)lblkno,
 				  args->rmtblkcnt,
@@ -2188,7 +2188,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi(NULL, args->dp, (xfs_fileoff_t)lblkno,
 					args->rmtblkcnt,
@@ -2229,7 +2229,7 @@ xfs_attr_rmtval_remove(xfs_da_args_t *ar
 	blkcnt = args->rmtblkcnt;
 	done = 0;
 	while (!done) {
-		XFS_BMAP_INIT(args->flist, args->firstblock);
+		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
 				    1, args->firstblock, args->flist,
Index: linux-2.6-xfs/fs/xfs/xfs_bit.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bit.h
+++ linux-2.6-xfs/fs/xfs/xfs_bit.h
@@ -25,22 +25,21 @@
 /*
  * masks with n high/low bits set, 32-bit values & 64-bit values
  */
-#define	XFS_MASK32HI(n)		xfs_mask32hi(n)
 static inline __uint32_t xfs_mask32hi(int n)
 {
 	return (__uint32_t)-1 << (32 - (n));
 }
-#define	XFS_MASK64HI(n)		xfs_mask64hi(n)
+
 static inline __uint64_t xfs_mask64hi(int n)
 {
 	return (__uint64_t)-1 << (64 - (n));
 }
-#define	XFS_MASK32LO(n)		xfs_mask32lo(n)
+
 static inline __uint32_t xfs_mask32lo(int n)
 {
 	return ((__uint32_t)1 << (n)) - 1;
 }
-#define	XFS_MASK64LO(n)		xfs_mask64lo(n)
+
 static inline __uint64_t xfs_mask64lo(int n)
 {
 	return ((__uint64_t)1 << (n)) - 1;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.h
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.h
@@ -95,7 +95,6 @@ typedef	struct xfs_bmap_free
 					/* need write cache flushing and no */
 					/* additional allocation alignments */
 
-#define	XFS_BMAPI_AFLAG(w)	xfs_bmapi_aflag(w)
 static inline int xfs_bmapi_aflag(int w)
 {
 	return (w == XFS_ATTR_FORK ? XFS_BMAPI_ATTRFORK : 0);
@@ -107,7 +106,6 @@ static inline int xfs_bmapi_aflag(int w)
 #define	DELAYSTARTBLOCK		((xfs_fsblock_t)-1LL)
 #define	HOLESTARTBLOCK		((xfs_fsblock_t)-2LL)
 
-#define	XFS_BMAP_INIT(flp,fbp)	xfs_bmap_init(flp,fbp)
 static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 {
 	((flp)->xbf_first = NULL, (flp)->xbf_count = 0, \
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.c
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.c
@@ -949,7 +949,7 @@ xfs_bmbt_killroot(
 	cur->bc_bufs[level - 1] = NULL;
 	be16_add(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork));
 	cur->bc_nlevels--;
 	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 	return 0;
@@ -986,7 +986,7 @@ xfs_bmbt_log_keys(
 
 		ip = cur->bc_private.b.ip;
 		xfs_trans_log_inode(tp, ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+			xfs_ilog_fbroot(cur->bc_private.b.whichfork));
 	}
 	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 }
@@ -1022,7 +1022,7 @@ xfs_bmbt_log_ptrs(
 
 		ip = cur->bc_private.b.ip;
 		xfs_trans_log_inode(tp, ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+			xfs_ilog_fbroot(cur->bc_private.b.whichfork));
 	}
 	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 }
@@ -1827,25 +1827,25 @@ __xfs_bmbt_get_all(
 
 	ext_flag = (int)(l0 >> (64 - BMBT_EXNTFLAG_BITLEN));
 	s->br_startoff = ((xfs_fileoff_t)l0 &
-			   XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+			   xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 #if XFS_BIG_BLKNOS
-	s->br_startblock = (((xfs_fsblock_t)l0 & XFS_MASK64LO(9)) << 43) |
+	s->br_startblock = (((xfs_fsblock_t)l0 & xfs_mask64lo(9)) << 43) |
 			   (((xfs_fsblock_t)l1) >> 21);
 #else
 #ifdef DEBUG
 	{
 		xfs_dfsbno_t	b;
 
-		b = (((xfs_dfsbno_t)l0 & XFS_MASK64LO(9)) << 43) |
+		b = (((xfs_dfsbno_t)l0 & xfs_mask64lo(9)) << 43) |
 		    (((xfs_dfsbno_t)l1) >> 21);
-		ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
+		ASSERT((b >> 32) == 0 || isnulldstartblock(b));
 		s->br_startblock = (xfs_fsblock_t)b;
 	}
 #else	/* !DEBUG */
 	s->br_startblock = (xfs_fsblock_t)(((xfs_dfsbno_t)l1) >> 21);
 #endif	/* DEBUG */
 #endif	/* XFS_BIG_BLKNOS */
-	s->br_blockcount = (xfs_filblks_t)(l1 & XFS_MASK64LO(21));
+	s->br_blockcount = (xfs_filblks_t)(l1 & xfs_mask64lo(21));
 	/* This is xfs_extent_state() in-line */
 	if (ext_flag) {
 		ASSERT(s->br_blockcount != 0);	/* saved for DMIG */
@@ -1895,7 +1895,7 @@ xfs_filblks_t
 xfs_bmbt_get_blockcount(
 	xfs_bmbt_rec_host_t	*r)
 {
-	return (xfs_filblks_t)(r->l1 & XFS_MASK64LO(21));
+	return (xfs_filblks_t)(r->l1 & xfs_mask64lo(21));
 }
 
 /*
@@ -1906,15 +1906,15 @@ xfs_bmbt_get_startblock(
 	xfs_bmbt_rec_host_t	*r)
 {
 #if XFS_BIG_BLKNOS
-	return (((xfs_fsblock_t)r->l0 & XFS_MASK64LO(9)) << 43) |
+	return (((xfs_fsblock_t)r->l0 & xfs_mask64lo(9)) << 43) |
 	       (((xfs_fsblock_t)r->l1) >> 21);
 #else
 #ifdef DEBUG
 	xfs_dfsbno_t	b;
 
-	b = (((xfs_dfsbno_t)r->l0 & XFS_MASK64LO(9)) << 43) |
+	b = (((xfs_dfsbno_t)r->l0 & xfs_mask64lo(9)) << 43) |
 	    (((xfs_dfsbno_t)r->l1) >> 21);
-	ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
+	ASSERT((b >> 32) == 0 || isnulldstartblock(b));
 	return (xfs_fsblock_t)b;
 #else	/* !DEBUG */
 	return (xfs_fsblock_t)(((xfs_dfsbno_t)r->l1) >> 21);
@@ -1930,7 +1930,7 @@ xfs_bmbt_get_startoff(
 	xfs_bmbt_rec_host_t	*r)
 {
 	return ((xfs_fileoff_t)r->l0 &
-		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+		 xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 }
 
 xfs_exntst_t
@@ -1960,7 +1960,7 @@ xfs_filblks_t
 xfs_bmbt_disk_get_blockcount(
 	xfs_bmbt_rec_t	*r)
 {
-	return (xfs_filblks_t)(be64_to_cpu(r->l1) & XFS_MASK64LO(21));
+	return (xfs_filblks_t)(be64_to_cpu(r->l1) & xfs_mask64lo(21));
 }
 
 /*
@@ -1971,7 +1971,7 @@ xfs_bmbt_disk_get_startoff(
 	xfs_bmbt_rec_t	*r)
 {
 	return ((xfs_fileoff_t)be64_to_cpu(r->l0) &
-		 XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
+		 xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
 }
 
 /*
@@ -2146,7 +2146,7 @@ xfs_bmbt_log_block(
 		xfs_trans_log_buf(tp, bp, first, last);
 	} else
 		xfs_trans_log_inode(tp, cur->bc_private.b.ip,
-			XFS_ILOG_FBROOT(cur->bc_private.b.whichfork));
+			xfs_ilog_fbroot(cur->bc_private.b.whichfork));
 	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 }
 
@@ -2312,7 +2312,7 @@ xfs_bmbt_newroot(
 	xfs_bmbt_log_ptrs(cur, bp, 1, be16_to_cpu(cblock->bb_numrecs));
 	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 	*logflags |=
-		XFS_ILOG_CORE | XFS_ILOG_FBROOT(cur->bc_private.b.whichfork);
+		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork);
 	*stat = 1;
 	return 0;
 }
@@ -2331,33 +2331,33 @@ xfs_bmbt_set_allf(
 	int		extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
 
 	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
-	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
-	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
+	ASSERT((startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)) == 0);
+	ASSERT((blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
 
 #if XFS_BIG_BLKNOS
-	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+	ASSERT((startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)) == 0);
 
 	r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 		((xfs_bmbt_rec_base_t)startoff << 9) |
 		((xfs_bmbt_rec_base_t)startblock >> 43);
 	r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
 		((xfs_bmbt_rec_base_t)blockcount &
-		(xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+		(xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(startblock)) {
+	if (isnullstartblock(startblock)) {
 		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			((xfs_bmbt_rec_base_t)startoff << 9) |
-			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
-		r->l1 = XFS_MASK64HI(11) |
+			 (xfs_bmbt_rec_base_t)xfs_mask64lo(9);
+		r->l1 = xfs_mask64hi(11) |
 			  ((xfs_bmbt_rec_base_t)startblock << 21) |
 			  ((xfs_bmbt_rec_base_t)blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			   (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	} else {
 		r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			((xfs_bmbt_rec_base_t)startoff << 9);
 		r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
 			 ((xfs_bmbt_rec_base_t)blockcount &
-			 (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			 (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	}
 #endif	/* XFS_BIG_BLKNOS */
 }
@@ -2389,11 +2389,11 @@ xfs_bmbt_disk_set_allf(
 	int			extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
 
 	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
-	ASSERT((startoff & XFS_MASK64HI(64-BMBT_STARTOFF_BITLEN)) == 0);
-	ASSERT((blockcount & XFS_MASK64HI(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
+	ASSERT((startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)) == 0);
+	ASSERT((blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
 
 #if XFS_BIG_BLKNOS
-	ASSERT((startblock & XFS_MASK64HI(64-BMBT_STARTBLOCK_BITLEN)) == 0);
+	ASSERT((startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)) == 0);
 
 	r->l0 = cpu_to_be64(
 		((xfs_bmbt_rec_base_t)extent_flag << 63) |
@@ -2402,17 +2402,17 @@ xfs_bmbt_disk_set_allf(
 	r->l1 = cpu_to_be64(
 		((xfs_bmbt_rec_base_t)startblock << 21) |
 		 ((xfs_bmbt_rec_base_t)blockcount &
-		  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(startblock)) {
+	if (isnullstartblock(startblock)) {
 		r->l0 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)extent_flag << 63) |
 			 ((xfs_bmbt_rec_base_t)startoff << 9) |
-			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
-		r->l1 = cpu_to_be64(XFS_MASK64HI(11) |
+			  (xfs_bmbt_rec_base_t)xfs_mask64lo(9));
+		r->l1 = cpu_to_be64(xfs_mask64hi(11) |
 			  ((xfs_bmbt_rec_base_t)startblock << 21) |
 			  ((xfs_bmbt_rec_base_t)blockcount &
-			   (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+			   (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
 	} else {
 		r->l0 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)extent_flag << 63) |
@@ -2420,7 +2420,7 @@ xfs_bmbt_disk_set_allf(
 		r->l1 = cpu_to_be64(
 			((xfs_bmbt_rec_base_t)startblock << 21) |
 			 ((xfs_bmbt_rec_base_t)blockcount &
-			  (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)));
+			  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
 	}
 #endif	/* XFS_BIG_BLKNOS */
 }
@@ -2445,9 +2445,9 @@ xfs_bmbt_set_blockcount(
 	xfs_bmbt_rec_host_t *r,
 	xfs_filblks_t	v)
 {
-	ASSERT((v & XFS_MASK64HI(43)) == 0);
-	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64HI(43)) |
-		  (xfs_bmbt_rec_base_t)(v & XFS_MASK64LO(21));
+	ASSERT((v & xfs_mask64hi(43)) == 0);
+	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64hi(43)) |
+		  (xfs_bmbt_rec_base_t)(v & xfs_mask64lo(21));
 }
 
 /*
@@ -2459,21 +2459,21 @@ xfs_bmbt_set_startblock(
 	xfs_fsblock_t	v)
 {
 #if XFS_BIG_BLKNOS
-	ASSERT((v & XFS_MASK64HI(12)) == 0);
-	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t)XFS_MASK64HI(55)) |
+	ASSERT((v & xfs_mask64hi(12)) == 0);
+	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t)xfs_mask64hi(55)) |
 		  (xfs_bmbt_rec_base_t)(v >> 43);
-	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21)) |
+	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21)) |
 		  (xfs_bmbt_rec_base_t)(v << 21);
 #else	/* !XFS_BIG_BLKNOS */
-	if (ISNULLSTARTBLOCK(v)) {
-		r->l0 |= (xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
-		r->l1 = (xfs_bmbt_rec_base_t)XFS_MASK64HI(11) |
+	if (isnullstartblock(v)) {
+		r->l0 |= (xfs_bmbt_rec_base_t)xfs_mask64lo(9);
+		r->l1 = (xfs_bmbt_rec_base_t)xfs_mask64hi(11) |
 			  ((xfs_bmbt_rec_base_t)v << 21) |
-			  (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			  (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	} else {
-		r->l0 &= ~(xfs_bmbt_rec_base_t)XFS_MASK64LO(9);
+		r->l0 &= ~(xfs_bmbt_rec_base_t)xfs_mask64lo(9);
 		r->l1 = ((xfs_bmbt_rec_base_t)v << 21) |
-			  (r->l1 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(21));
+			  (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
 	}
 #endif	/* XFS_BIG_BLKNOS */
 }
@@ -2486,10 +2486,10 @@ xfs_bmbt_set_startoff(
 	xfs_bmbt_rec_host_t *r,
 	xfs_fileoff_t	v)
 {
-	ASSERT((v & XFS_MASK64HI(9)) == 0);
-	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t) XFS_MASK64HI(1)) |
+	ASSERT((v & xfs_mask64hi(9)) == 0);
+	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t) xfs_mask64hi(1)) |
 		((xfs_bmbt_rec_base_t)v << 9) |
-		  (r->l0 & (xfs_bmbt_rec_base_t)XFS_MASK64LO(9));
+		  (r->l0 & (xfs_bmbt_rec_base_t)xfs_mask64lo(9));
 }
 
 /*
@@ -2502,9 +2502,9 @@ xfs_bmbt_set_state(
 {
 	ASSERT(v == XFS_EXT_NORM || v == XFS_EXT_UNWRITTEN);
 	if (v == XFS_EXT_NORM)
-		r->l0 &= XFS_MASK64LO(64 - BMBT_EXNTFLAG_BITLEN);
+		r->l0 &= xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN);
 	else
-		r->l0 |= XFS_MASK64HI(BMBT_EXNTFLAG_BITLEN);
+		r->l0 |= xfs_mask64hi(BMBT_EXNTFLAG_BITLEN);
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap_btree.h
+++ linux-2.6-xfs/fs/xfs/xfs_bmap_btree.h
@@ -75,26 +75,22 @@ typedef struct xfs_bmbt_rec_host {
 #define DSTARTBLOCKMASK		\
 	(((((xfs_dfsbno_t)1) << DSTARTBLOCKMASKBITS) - 1) << STARTBLOCKVALBITS)
 
-#define ISNULLSTARTBLOCK(x)	isnullstartblock(x)
 static inline int isnullstartblock(xfs_fsblock_t x)
 {
 	return ((x) & STARTBLOCKMASK) == STARTBLOCKMASK;
 }
 
-#define ISNULLDSTARTBLOCK(x)	isnulldstartblock(x)
 static inline int isnulldstartblock(xfs_dfsbno_t x)
 {
 	return ((x) & DSTARTBLOCKMASK) == DSTARTBLOCKMASK;
 }
 
-#define NULLSTARTBLOCK(k)	nullstartblock(k)
 static inline xfs_fsblock_t nullstartblock(int k)
 {
 	ASSERT(k < (1 << STARTBLOCKVALBITS));
 	return STARTBLOCKMASK | (k);
 }
 
-#define STARTBLOCKVAL(x)	startblockval(x)
 static inline xfs_filblks_t startblockval(xfs_fsblock_t x)
 {
 	return (xfs_filblks_t)((x) & ~STARTBLOCKMASK);
Index: linux-2.6-xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_da_btree.c
+++ linux-2.6-xfs/fs/xfs/xfs_da_btree.c
@@ -1594,7 +1594,7 @@ xfs_da_grow_inode(xfs_da_args_t *args, x
 	nmap = 1;
 	ASSERT(args->firstblock != NULL);
 	if ((error = xfs_bmapi(tp, dp, bno, count,
-			XFS_BMAPI_AFLAG(w)|XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|
+			xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|XFS_BMAPI_METADATA|
 			XFS_BMAPI_CONTIG,
 			args->firstblock, args->total, &map, &nmap,
 			args->flist, NULL))) {
@@ -1615,7 +1615,7 @@ xfs_da_grow_inode(xfs_da_args_t *args, x
 			nmap = MIN(XFS_BMAP_MAX_NMAP, count);
 			c = (int)(bno + count - b);
 			if ((error = xfs_bmapi(tp, dp, b, c,
-					XFS_BMAPI_AFLAG(w)|XFS_BMAPI_WRITE|
+					xfs_bmapi_aflag(w)|XFS_BMAPI_WRITE|
 					XFS_BMAPI_METADATA,
 					args->firstblock, args->total,
 					&mapp[mapi], &nmap, args->flist,
@@ -1877,7 +1877,7 @@ xfs_da_shrink_inode(xfs_da_args_t *args,
 		 * the last block to the place we want to kill.
 		 */
 		if ((error = xfs_bunmapi(tp, dp, dead_blkno, count,
-				XFS_BMAPI_AFLAG(w)|XFS_BMAPI_METADATA,
+				xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
 				0, args->firstblock, args->flist, NULL,
 				&done)) == ENOSPC) {
 			if (w != XFS_DATA_FORK)
@@ -1982,7 +1982,7 @@ xfs_da_do_buf(
 			if ((error = xfs_bmapi(trans, dp, (xfs_fileoff_t)bno,
 					nfsb,
 					XFS_BMAPI_METADATA |
-						XFS_BMAPI_AFLAG(whichfork),
+						xfs_bmapi_aflag(whichfork),
 					NULL, 0, mapp, &nmap, NULL, NULL)))
 				goto exit0;
 		}
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c
@@ -315,7 +315,7 @@ xfs_ialloc_ag_alloc(
 		 */
 		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
 		for (i = 0; i < ninodes; i++) {
-			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
+			free = xfs_make_iptr(args.mp, fbuf, i);
 			free->di_core.di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 			free->di_core.di_version = version;
 			free->di_core.di_gen = cpu_to_be32(gen);
@@ -898,7 +898,7 @@ nextag:
 			}
 		}
 	}
-	offset = XFS_IALLOC_FIND_FREE(&rec.ir_free);
+	offset = xfs_ialloc_find_free(&rec.ir_free);
 	ASSERT(offset >= 0);
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.h
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.h
@@ -38,7 +38,6 @@ struct xfs_trans;
 /*
  * Make an inode pointer out of the buffer/offset.
  */
-#define	XFS_MAKE_IPTR(mp,b,o)		xfs_make_iptr(mp,b,o)
 static inline struct xfs_dinode *
 xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 {
@@ -49,7 +48,6 @@ xfs_make_iptr(struct xfs_mount *mp, stru
 /*
  * Find a free (set) bit in the inode bitmask.
  */
-#define	XFS_IALLOC_FIND_FREE(fp)	xfs_ialloc_find_free(fp)
 static inline int xfs_ialloc_find_free(xfs_inofree_t *fp)
 {
 	return xfs_lowbit64(*fp);
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.c
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.c
@@ -1252,7 +1252,7 @@ xfs_inobt_newroot(
 		 * Our block is left, pick up the right block.
 		 */
 		lbp = bp;
-		lbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(lbp));
+		lbno = xfs_daddr_to_agbno(args.mp, XFS_BUF_ADDR(lbp));
 		left = block;
 		rbno = be32_to_cpu(left->bb_rightsib);
 		if ((error = xfs_btree_read_bufs(args.mp, args.tp, args.agno,
@@ -1269,7 +1269,7 @@ xfs_inobt_newroot(
 		 * Our block is right, pick up the left block.
 		 */
 		rbp = bp;
-		rbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(rbp));
+		rbno = xfs_daddr_to_agbno(args.mp, XFS_BUF_ADDR(rbp));
 		right = block;
 		lbno = be32_to_cpu(right->bb_leftsib);
 		if ((error = xfs_btree_read_bufs(args.mp, args.tp, args.agno,
@@ -1487,7 +1487,7 @@ xfs_inobt_split(
 	lbp = cur->bc_bufs[level];
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	lbno = XFS_DADDR_TO_AGBNO(args.mp, XFS_BUF_ADDR(lbp));
+	lbno = xfs_daddr_to_agbno(args.mp, XFS_BUF_ADDR(lbp));
 	/*
 	 * Allocate the new block.
 	 * If we can't do it, we're toast.  Give up.
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc_btree.h
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc_btree.h
@@ -37,7 +37,6 @@ typedef	__uint64_t	xfs_inofree_t;
 #define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
 #define	XFS_INOBT_ALL_FREE	((xfs_inofree_t)-1)
 
-#define	XFS_INOBT_MASKN(i,n)		xfs_inobt_maskn(i,n)
 static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
 {
 	return (((n) >= XFS_INODES_PER_CHUNK ? \
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c
@@ -1655,10 +1655,10 @@ xfs_itruncate_finish(
 		 * in this file with garbage in them once recovery
 		 * runs.
 		 */
-		XFS_BMAP_INIT(&free_list, &first_block);
+		xfs_bmap_init(&free_list, &first_block);
 		error = xfs_bunmapi(ntp, ip,
 				    first_unmap_block, unmap_len,
-				    XFS_BMAPI_AFLAG(fork) |
+				    xfs_bmapi_aflag(fork) |
 				      (sync ? 0 : XFS_BMAPI_ASYNC),
 				    XFS_ITRUNC_MAX_EXTENTS,
 				    &first_block, &free_list,
@@ -2778,7 +2778,7 @@ xfs_iextents_copy(
 	for (i = 0; i < nrecs; i++) {
 		xfs_bmbt_rec_host_t *ep = xfs_iext_get_ext(ifp, i);
 		start_block = xfs_bmbt_get_startblock(ep);
-		if (ISNULLSTARTBLOCK(start_block)) {
+		if (isnullstartblock(start_block)) {
 			/*
 			 * It's a delayed allocation extent, so skip it.
 			 */
Index: linux-2.6-xfs/fs/xfs/xfs_inode_item.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode_item.h
+++ linux-2.6-xfs/fs/xfs/xfs_inode_item.h
@@ -147,22 +147,13 @@ typedef struct xfs_inode_log_item {
 	xfs_inode_log_format_t	ili_format;	   /* logged structure */
 } xfs_inode_log_item_t;
 
-
-#define	XFS_ILOG_FDATA(w)	xfs_ilog_fdata(w)
-static inline int xfs_ilog_fdata(int w)
-{
-	return (w == XFS_DATA_FORK ? XFS_ILOG_DDATA : XFS_ILOG_ADATA);
-}
-
 #endif	/* __KERNEL__ */
 
-#define	XFS_ILOG_FBROOT(w)	xfs_ilog_fbroot(w)
 static inline int xfs_ilog_fbroot(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DBROOT : XFS_ILOG_ABROOT);
 }
 
-#define	XFS_ILOG_FEXT(w)	xfs_ilog_fext(w)
 static inline int xfs_ilog_fext(int w)
 {
 	return (w == XFS_DATA_FORK ? XFS_ILOG_DEXT : XFS_ILOG_AEXT);
Index: linux-2.6-xfs/fs/xfs/xfs_iomap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.c
+++ linux-2.6-xfs/fs/xfs/xfs_iomap.c
@@ -155,7 +155,7 @@ xfs_imap_to_bmap(
 			iomapp->iomap_bn = IOMAP_DADDR_NULL;
 			iomapp->iomap_flags |= IOMAP_DELAY;
 		} else {
-			iomapp->iomap_bn = XFS_FSB_TO_DB(ip, start_block);
+			iomapp->iomap_bn = xfs_fsb_to_db(ip, start_block);
 			if (ISUNWRITTEN(imap))
 				iomapp->iomap_flags |= IOMAP_UNWRITTEN;
 		}
@@ -261,7 +261,7 @@ xfs_iomap(
 		xfs_iunlock(ip, lockmode);
 		lockmode = 0;
 
-		if (nimaps && !ISNULLSTARTBLOCK(imap.br_startblock)) {
+		if (nimaps && !isnullstartblock(imap.br_startblock)) {
 			xfs_iomap_map_trace(XFS_IOMAP_WRITE_MAP, ip,
 					offset, count, iomapp, &imap, flags);
 			break;
@@ -498,7 +498,7 @@ xfs_iomap_write_direct(
 	/*
 	 * Issue the xfs_bmapi() call to allocate the blocks
 	 */
-	XFS_BMAP_INIT(&free_list, &firstfsb);
+	xfs_bmap_init(&free_list, &firstfsb);
 	nimaps = 1;
 	error = xfs_bmapi(tp, ip, offset_fsb, count_fsb, bmapi_flag,
 		&firstfsb, 0, &imap, &nimaps, &free_list, NULL);
@@ -765,7 +765,7 @@ xfs_iomap_write_allocate(
 			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 			xfs_trans_ihold(tp, ip);
 
-			XFS_BMAP_INIT(&free_list, &first_block);
+			xfs_bmap_init(&free_list, &first_block);
 
 			/*
 			 * it is possible that the extents have changed since
@@ -925,7 +925,7 @@ xfs_iomap_write_unwritten(
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-		XFS_BMAP_INIT(&free_list, &firstfsb);
+		xfs_bmap_init(&free_list, &firstfsb);
 		nimaps = 1;
 		error = xfs_bmapi(tp, ip, offset_fsb, count_fsb,
 				  XFS_BMAPI_WRITE|XFS_BMAPI_CONVERT, &firstfsb,
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c
@@ -442,7 +442,7 @@ xfs_bulkstat(
 			    (chunkidx = agino - gino + 1) <
 				    XFS_INODES_PER_CHUNK &&
 					/* there are some left allocated */
-			    XFS_INOBT_MASKN(chunkidx,
+			    xfs_inobt_maskn(chunkidx,
 				    XFS_INODES_PER_CHUNK - chunkidx) & ~gfree) {
 				/*
 				 * Grab the chunk record.  Mark all the
@@ -453,7 +453,7 @@ xfs_bulkstat(
 					if (XFS_INOBT_MASK(i) & ~gfree)
 						gcnt++;
 				}
-				gfree |= XFS_INOBT_MASKN(0, chunkidx);
+				gfree |= xfs_inobt_maskn(0, chunkidx);
 				irbp->ir_startino = gino;
 				irbp->ir_freecount = gcnt;
 				irbp->ir_free = gfree;
@@ -524,7 +524,7 @@ xfs_bulkstat(
 				     chunkidx < XFS_INODES_PER_CHUNK;
 				     chunkidx += nicluster,
 				     agbno += nbcluster) {
-					if (XFS_INOBT_MASKN(chunkidx,
+					if (xfs_inobt_maskn(chunkidx,
 							    nicluster) & ~gfree)
 						xfs_btree_reada_bufs(mp, agno,
 							agbno, nbcluster);
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h
@@ -47,9 +47,9 @@ typedef struct xfs_trans_reservations {
 /*
  * Moved here from xfs_ag.h to avoid reordering header files
  */
-#define XFS_DADDR_TO_AGNO(mp,d) \
+#define xfs_daddr_to_agno(mp,d) \
 	((xfs_agnumber_t)(XFS_BB_TO_FSBT(mp, d) / (mp)->m_sb.sb_agblocks))
-#define XFS_DADDR_TO_AGBNO(mp,d) \
+#define xfs_daddr_to_agbno(mp,d) \
 	((xfs_agblock_t)(XFS_BB_TO_FSBT(mp, d) % (mp)->m_sb.sb_agblocks))
 #else
 struct cred;
@@ -452,7 +452,6 @@ void xfs_do_force_shutdown(struct xfs_mo
 /*	XFS_MFSI_CONVERT_SUNIT	*/
 #define XFS_MFSI_QUIET		0x40	/* Be silent if mount errors found */
 
-#define XFS_DADDR_TO_AGNO(mp,d)         xfs_daddr_to_agno(mp,d)
 static inline xfs_agnumber_t
 xfs_daddr_to_agno(struct xfs_mount *mp, xfs_daddr_t d)
 {
@@ -461,7 +460,6 @@ xfs_daddr_to_agno(struct xfs_mount *mp, 
 	return (xfs_agnumber_t) ld;
 }
 
-#define XFS_DADDR_TO_AGBNO(mp,d)        xfs_daddr_to_agbno(mp,d)
 static inline xfs_agblock_t
 xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 {
Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c
@@ -172,7 +172,7 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip,
 				inodes, &num_inodes);
 
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
Index: linux-2.6-xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rtalloc.c
+++ linux-2.6-xfs/fs/xfs/xfs_rtalloc.c
@@ -120,7 +120,7 @@ xfs_growfs_rt_alloc(
 		if ((error = xfs_trans_iget(mp, tp, ino, 0,
 						XFS_ILOCK_EXCL, &ip)))
 			goto error_cancel;
-		XFS_BMAP_INIT(&flist, &firstblock);
+		xfs_bmap_init(&flist, &firstblock);
 		/*
 		 * Allocate blocks to the bitmap file.
 		 */
Index: linux-2.6-xfs/fs/xfs/xfs_rw.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rw.h
+++ linux-2.6-xfs/fs/xfs/xfs_rw.h
@@ -28,7 +28,6 @@ struct xfs_mount;
  * file is a real time file or not, because the bmap code
  * does.
  */
-#define	XFS_FSB_TO_DB(ip,fsb)	xfs_fsb_to_db(ip,fsb)
 static inline xfs_daddr_t
 xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 {
Index: linux-2.6-xfs/fs/xfs/xfs_sb.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_sb.h
+++ linux-2.6-xfs/fs/xfs/xfs_sb.h
@@ -498,7 +498,7 @@ static inline void xfs_sb_version_remove
 
 #define	XFS_HDR_BLOCK(mp,d)	((xfs_agblock_t)XFS_BB_TO_FSBT(mp,d))
 #define	XFS_DADDR_TO_FSB(mp,d)	XFS_AGB_TO_FSB(mp, \
-			XFS_DADDR_TO_AGNO(mp,d), XFS_DADDR_TO_AGBNO(mp,d))
+			xfs_daddr_to_agno(mp,d), xfs_daddr_to_agbno(mp,d))
 #define	XFS_FSB_TO_DADDR(mp,fsbno)	XFS_AGB_TO_DADDR(mp, \
 			XFS_FSB_TO_AGNO(mp,fsbno), XFS_FSB_TO_AGBNO(mp,fsbno))
 
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
@@ -972,7 +972,7 @@ xfs_inactive_symlink_rmt(
 	 * Find the block(s) so we can inval and unmap them.
 	 */
 	done = 0;
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 	nmaps = ARRAY_SIZE(mval);
 	if ((error = xfs_bmapi(tp, ip, 0, XFS_B_TO_FSB(mp, size),
 			XFS_BMAPI_METADATA, &first_block, 0, mval, &nmaps,
@@ -1392,7 +1392,7 @@ xfs_inactive(
 	/*
 	 * Free the inode.
 	 */
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 	error = xfs_ifree(tp, ip, &free_list);
 	if (error) {
 		/*
@@ -1565,7 +1565,7 @@ xfs_create(
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = B_TRUE;
 
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 
 	ASSERT(ip == NULL);
 
@@ -1977,7 +1977,7 @@ xfs_remove(
 		}
 	}
 
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
 					&first_block, &free_list, resblks);
 	if (error) {
@@ -2164,7 +2164,7 @@ xfs_link(
 	if (error)
 		goto error_return;
 
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
 					&first_block, &free_list, resblks);
@@ -2337,7 +2337,7 @@ xfs_mkdir(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	unlock_dp_on_error = B_FALSE;
 
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 
 	error = xfs_dir_createname(tp, dp, dir_name, cdp->i_ino,
 					&first_block, &free_list, resblks ?
@@ -2552,7 +2552,7 @@ xfs_symlink(
 	 * Initialize the bmap freelist prior to calling either
 	 * bmapi or the directory create code.
 	 */
-	XFS_BMAP_INIT(&free_list, &first_block);
+	xfs_bmap_init(&free_list, &first_block);
 
 	/*
 	 * Allocate an inode for the symlink.
@@ -3093,7 +3093,7 @@ retry:
 		/*
 		 * Issue the xfs_bmapi() call to allocate the blocks
 		 */
-		XFS_BMAP_INIT(&free_list, &firstfsb);
+		xfs_bmap_init(&free_list, &firstfsb);
 		error = xfs_bmapi(tp, ip, startoffset_fsb,
 				  allocatesize_fsb, bmapi_flag,
 				  &firstfsb, 0, imapp, &nimaps,
@@ -3193,7 +3193,7 @@ xfs_zero_remaining_bytes(
 		XFS_BUF_UNDONE(bp);
 		XFS_BUF_UNWRITE(bp);
 		XFS_BUF_READ(bp);
-		XFS_BUF_SET_ADDR(bp, XFS_FSB_TO_DB(ip, imap.br_startblock));
+		XFS_BUF_SET_ADDR(bp, xfs_fsb_to_db(ip, imap.br_startblock));
 		xfsbdstrat(mp, bp);
 		error = xfs_iowait(bp);
 		if (error) {
@@ -3398,7 +3398,7 @@ xfs_free_file_space(
 		/*
 		 * issue the bunmapi() call to free the blocks
 		 */
-		XFS_BMAP_INIT(&free_list, &firstfsb);
+		xfs_bmap_init(&free_list, &firstfsb);
 		error = xfs_bunmapi(tp, ip, startoffset_fsb,
 				  endoffset_fsb - startoffset_fsb,
 				  0, 2, &firstfsb, &free_list, NULL, &done);
Index: linux-2.6-xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_dquot.c
+++ linux-2.6-xfs/fs/xfs/quota/xfs_dquot.c
@@ -415,7 +415,7 @@ xfs_qm_dqalloc(
 	/*
 	 * Initialize the bmap freelist prior to calling bmapi code.
 	 */
-	XFS_BMAP_INIT(&flist, &firstblock);
+	xfs_bmap_init(&flist, &firstblock);
 	xfs_ilock(quotip, XFS_ILOCK_EXCL);
 	/*
 	 * Return if this type of quotas is turned off while we didn't
