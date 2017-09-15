Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48076 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdIOOy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2017 10:54:29 -0400
Received: from [8.25.222.2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dss0i-0003Im-NK
        for linux-xfs@vger.kernel.org; Fri, 15 Sep 2017 14:54:28 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/18] xfs: refactor xfs_bmap_add_extent_unwritten_real
Date: Fri, 15 Sep 2017 07:54:21 -0700
Message-Id: <20170915145426.26194-14-hch@lst.de>
In-Reply-To: <20170915145426.26194-1-hch@lst.de>
References: <20170915145426.26194-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use xfs_iext_get_extent to find, and xfs_iext_update_extent to update
entries in the in-core extent list.  This isolates the function from
the detailed layout of the extent list, and generally makes the code
a lot more readable.

Also get rid of the oldext and newext variables as using the extent
records is a lot more descriptive.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 208 +++++++++++++++++++++++------------------------
 1 file changed, 104 insertions(+), 104 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8606a775c94b..8bc3ee7d9edb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2170,18 +2170,16 @@ xfs_bmap_add_extent_unwritten_real(
 	int			*logflagsp) /* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
-	xfs_bmbt_rec_host_t	*ep;	/* extent entry for idx */
 	int			error;	/* error return value */
 	int			i;	/* temp state */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
 	xfs_fileoff_t		new_endoff;	/* end offset of new entry */
-	xfs_exntst_t		newext;	/* new extent state */
-	xfs_exntst_t		oldext;	/* old extent state */
 	xfs_bmbt_irec_t		r[3];	/* neighbor extent entries */
 					/* left is 0, right is 1, prev is 2 */
 	int			rval=0;	/* return value (logging flags) */
 	int			state = 0;/* state bits, accessed thru macros */
 	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmbt_irec	old;
 
 	*logflagsp = 0;
 
@@ -2204,12 +2202,8 @@ xfs_bmap_add_extent_unwritten_real(
 	 * Set up a bunch of variables to make the tests simpler.
 	 */
 	error = 0;
-	ep = xfs_iext_get_ext(ifp, *idx);
-	xfs_bmbt_get_all(ep, &PREV);
-	newext = new->br_state;
-	oldext = (newext == XFS_EXT_UNWRITTEN) ?
-		XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
-	ASSERT(PREV.br_state == oldext);
+	xfs_iext_get_extent(ifp, *idx, &PREV);
+	ASSERT(new->br_state != PREV.br_state);
 	new_endoff = new->br_startoff + new->br_blockcount;
 	ASSERT(PREV.br_startoff <= new->br_startoff);
 	ASSERT(PREV.br_startoff + PREV.br_blockcount >= new_endoff);
@@ -2238,7 +2232,7 @@ xfs_bmap_add_extent_unwritten_real(
 	if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
 	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
 	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
-	    LEFT.br_state == newext &&
+	    LEFT.br_state == new->br_state &&
 	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
@@ -2257,7 +2251,7 @@ xfs_bmap_add_extent_unwritten_real(
 	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
 	    new_endoff == RIGHT.br_startoff &&
 	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
-	    newext == RIGHT.br_state &&
+	    new->br_state == RIGHT.br_state &&
 	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
 	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
 		       BMAP_RIGHT_FILLING)) !=
@@ -2281,9 +2275,8 @@ xfs_bmap_add_extent_unwritten_real(
 		--*idx;
 
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
-			LEFT.br_blockcount + PREV.br_blockcount +
-			RIGHT.br_blockcount);
+		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
+		xfs_iext_update_extent(ifp, *idx, &LEFT);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		xfs_iext_remove(ip, *idx + 1, 2, state);
@@ -2310,10 +2303,10 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
-				LEFT.br_startblock,
-				LEFT.br_blockcount + PREV.br_blockcount +
-				RIGHT.br_blockcount, LEFT.br_state)))
+			error = xfs_bmbt_update(cur, LEFT.br_startoff,
+					LEFT.br_startblock, LEFT.br_blockcount,
+					LEFT.br_state);
+			if (error)
 				goto done;
 		}
 		break;
@@ -2326,8 +2319,8 @@ xfs_bmap_add_extent_unwritten_real(
 		--*idx;
 
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx),
-			LEFT.br_blockcount + PREV.br_blockcount);
+		LEFT.br_blockcount += PREV.br_blockcount;
+		xfs_iext_update_extent(ifp, *idx, &LEFT);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		xfs_iext_remove(ip, *idx + 1, 1, state);
@@ -2348,10 +2341,10 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
-				LEFT.br_startblock,
-				LEFT.br_blockcount + PREV.br_blockcount,
-				LEFT.br_state)))
+			error = xfs_bmbt_update(cur, LEFT.br_startoff,
+					LEFT.br_startblock, LEFT.br_blockcount,
+					LEFT.br_state);
+			if (error)
 				goto done;
 		}
 		break;
@@ -2362,10 +2355,11 @@ xfs_bmap_add_extent_unwritten_real(
 		 * The right neighbor is contiguous, the left is not.
 		 */
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(ep,
-			PREV.br_blockcount + RIGHT.br_blockcount);
-		xfs_bmbt_set_state(ep, newext);
+		PREV.br_blockcount += RIGHT.br_blockcount;
+		PREV.br_state = new->br_state;
+		xfs_iext_update_extent(ifp, *idx, &PREV);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+
 		xfs_iext_remove(ip, *idx + 1, 1, state);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
@@ -2384,10 +2378,10 @@ xfs_bmap_add_extent_unwritten_real(
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			if ((error = xfs_bmbt_update(cur, new->br_startoff,
-				new->br_startblock,
-				new->br_blockcount + RIGHT.br_blockcount,
-				newext)))
+			error = xfs_bmbt_update(cur, PREV.br_startoff,
+					PREV.br_startblock, PREV.br_blockcount,
+					PREV.br_state);
+			if (error)
 				goto done;
 		}
 		break;
@@ -2399,7 +2393,8 @@ xfs_bmap_add_extent_unwritten_real(
 		 * the new one.
 		 */
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_state(ep, newext);
+		PREV.br_state = new->br_state;
+		xfs_iext_update_extent(ifp, *idx, &PREV);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		if (cur == NULL)
@@ -2411,9 +2406,10 @@ xfs_bmap_add_extent_unwritten_real(
 					&i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			if ((error = xfs_bmbt_update(cur, new->br_startoff,
-				new->br_startblock, new->br_blockcount,
-				newext)))
+			error = xfs_bmbt_update(cur, PREV.br_startoff,
+					PREV.br_startblock, PREV.br_blockcount,
+					PREV.br_state);
+			if (error)
 				goto done;
 		}
 		break;
@@ -2424,17 +2420,16 @@ xfs_bmap_add_extent_unwritten_real(
 		 * The left neighbor is contiguous.
 		 */
 		trace_xfs_bmap_pre_update(ip, *idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx - 1),
-			LEFT.br_blockcount + new->br_blockcount);
-		xfs_bmbt_set_startoff(ep,
-			PREV.br_startoff + new->br_blockcount);
+		LEFT.br_blockcount += new->br_blockcount;
+		xfs_iext_update_extent(ifp, *idx - 1, &LEFT);
 		trace_xfs_bmap_post_update(ip, *idx - 1, state, _THIS_IP_);
 
+		old = PREV;
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_startblock(ep,
-			new->br_startblock + new->br_blockcount);
-		xfs_bmbt_set_blockcount(ep,
-			PREV.br_blockcount - new->br_blockcount);
+		PREV.br_startoff += new->br_blockcount;
+		PREV.br_startblock += new->br_blockcount;
+		PREV.br_blockcount -= new->br_blockcount;
+		xfs_iext_update_extent(ifp, *idx, &PREV);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		--*idx;
@@ -2443,23 +2438,23 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
-					PREV.br_startblock, PREV.br_blockcount,
-					&i)))
+			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
+					old.br_startblock, old.br_blockcount,
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			if ((error = xfs_bmbt_update(cur,
-				PREV.br_startoff + new->br_blockcount,
-				PREV.br_startblock + new->br_blockcount,
-				PREV.br_blockcount - new->br_blockcount,
-				oldext)))
+			error = xfs_bmbt_update(cur, PREV.br_startoff,
+					PREV.br_startblock, PREV.br_blockcount,
+					PREV.br_state);
+			if (error)
 				goto done;
-			if ((error = xfs_btree_decrement(cur, 0, &i)))
+			error = xfs_btree_decrement(cur, 0, &i);
+			if (error)
 				goto done;
 			error = xfs_bmbt_update(cur, LEFT.br_startoff,
-				LEFT.br_startblock,
-				LEFT.br_blockcount + new->br_blockcount,
-				LEFT.br_state);
+					LEFT.br_startblock, LEFT.br_blockcount,
+					LEFT.br_state);
 			if (error)
 				goto done;
 		}
@@ -2470,13 +2465,12 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is not contiguous.
 		 */
+		old = PREV;
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		ASSERT(ep && xfs_bmbt_get_state(ep) == oldext);
-		xfs_bmbt_set_startoff(ep, new_endoff);
-		xfs_bmbt_set_blockcount(ep,
-			PREV.br_blockcount - new->br_blockcount);
-		xfs_bmbt_set_startblock(ep,
-			new->br_startblock + new->br_blockcount);
+		PREV.br_startoff += new->br_blockcount;
+		PREV.br_startblock += new->br_blockcount;
+		PREV.br_blockcount -= new->br_blockcount;
+		xfs_iext_update_extent(ifp, *idx, &PREV);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		xfs_iext_insert(ip, *idx, 1, new, state);
@@ -2486,16 +2480,16 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
-					PREV.br_startblock, PREV.br_blockcount,
-					&i)))
+			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
+					old.br_startblock, old.br_blockcount,
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			if ((error = xfs_bmbt_update(cur,
-				PREV.br_startoff + new->br_blockcount,
-				PREV.br_startblock + new->br_blockcount,
-				PREV.br_blockcount - new->br_blockcount,
-				oldext)))
+			error = xfs_bmbt_update(cur, PREV.br_startoff,
+					PREV.br_startblock, PREV.br_blockcount,
+					PREV.br_state);
+			if (error)
 				goto done;
 			cur->bc_rec.b = *new;
 			if ((error = xfs_btree_insert(cur, &i)))
@@ -2509,39 +2503,43 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is contiguous with the new allocation.
 		 */
+		old = PREV;
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(ep,
-			PREV.br_blockcount - new->br_blockcount);
+		PREV.br_blockcount -= new->br_blockcount;
+		xfs_iext_update_extent(ifp, *idx, &PREV);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		++*idx;
 
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx),
-			new->br_startoff, new->br_startblock,
-			new->br_blockcount + RIGHT.br_blockcount, newext);
+		RIGHT.br_startoff = new->br_startoff;
+		RIGHT.br_startblock = new->br_startblock;
+		RIGHT.br_blockcount += new->br_blockcount;
+		xfs_iext_update_extent(ifp, *idx, &RIGHT);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		if (cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
-					PREV.br_startblock,
-					PREV.br_blockcount, &i)))
+			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
+					old.br_startblock, old.br_blockcount,
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			if ((error = xfs_bmbt_update(cur, PREV.br_startoff,
-				PREV.br_startblock,
-				PREV.br_blockcount - new->br_blockcount,
-				oldext)))
+			error = xfs_bmbt_update(cur, PREV.br_startoff,
+					PREV.br_startblock, PREV.br_blockcount,
+					PREV.br_state);
+			if (error)
 				goto done;
-			if ((error = xfs_btree_increment(cur, 0, &i)))
+			error = xfs_btree_increment(cur, 0, &i);
+			if (error)
 				goto done;
-			if ((error = xfs_bmbt_update(cur, new->br_startoff,
-				new->br_startblock,
-				new->br_blockcount + RIGHT.br_blockcount,
-				newext)))
+			error = xfs_bmbt_update(cur, RIGHT.br_startoff,
+					RIGHT.br_startblock,
+					RIGHT.br_blockcount, RIGHT.br_state);
+			if (error)
 				goto done;
 		}
 		break;
@@ -2551,9 +2549,10 @@ xfs_bmap_add_extent_unwritten_real(
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is not contiguous.
 		 */
+		old = PREV;
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(ep,
-			PREV.br_blockcount - new->br_blockcount);
+		PREV.br_blockcount -= new->br_blockcount;
+		xfs_iext_update_extent(ifp, *idx, &PREV);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		++*idx;
@@ -2565,15 +2564,16 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
-					PREV.br_startblock, PREV.br_blockcount,
-					&i)))
+			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
+					old.br_startblock, old.br_blockcount,
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-			if ((error = xfs_bmbt_update(cur, PREV.br_startoff,
-				PREV.br_startblock,
-				PREV.br_blockcount - new->br_blockcount,
-				oldext)))
+			error = xfs_bmbt_update(cur, PREV.br_startoff,
+					PREV.br_startblock, PREV.br_blockcount,
+					PREV.br_state);
+			if (error)
 				goto done;
 			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
 					new->br_startblock, new->br_blockcount,
@@ -2593,17 +2593,18 @@ xfs_bmap_add_extent_unwritten_real(
 		 * newext.  Contiguity is impossible here.
 		 * One extent becomes three extents.
 		 */
+		old = PREV;
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(ep,
-			new->br_startoff - PREV.br_startoff);
+		PREV.br_blockcount = new->br_startoff - PREV.br_startoff;
+		xfs_iext_update_extent(ifp, *idx, &PREV);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		r[0] = *new;
 		r[1].br_startoff = new_endoff;
 		r[1].br_blockcount =
-			PREV.br_startoff + PREV.br_blockcount - new_endoff;
+			old.br_startoff + old.br_blockcount - new_endoff;
 		r[1].br_startblock = new->br_startblock + new->br_blockcount;
-		r[1].br_state = oldext;
+		r[1].br_state = PREV.br_state;
 
 		++*idx;
 		xfs_iext_insert(ip, *idx, 2, &r[0], state);
@@ -2614,9 +2615,10 @@ xfs_bmap_add_extent_unwritten_real(
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
 			rval = XFS_ILOG_CORE;
-			if ((error = xfs_bmbt_lookup_eq(cur, PREV.br_startoff,
-					PREV.br_startblock, PREV.br_blockcount,
-					&i)))
+			error = xfs_bmbt_lookup_eq(cur, old.br_startoff,
+					old.br_startblock, old.br_blockcount,
+					&i);
+			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			/* new right extent - oldext */
@@ -2626,8 +2628,6 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			/* new left extent - oldext */
 			cur->bc_rec.b = PREV;
-			cur->bc_rec.b.br_blockcount =
-				new->br_startoff - PREV.br_startoff;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-- 
2.14.1

