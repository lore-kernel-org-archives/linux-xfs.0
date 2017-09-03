Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58362 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751702AbdICHad (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 03:30:33 -0400
Received: from [91.114.64.3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1doPMW-0007EH-JM
        for linux-xfs@vger.kernel.org; Sun, 03 Sep 2017 07:30:33 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/17] xfs: refactor xfs_bmap_add_extent_delay_real
Date: Sun,  3 Sep 2017 09:29:50 +0200
Message-Id: <20170903072956.3175-12-hch@lst.de>
In-Reply-To: <20170903072956.3175-1-hch@lst.de>
References: <20170903072956.3175-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use xfs_iext_get_extent to find, and xfs_iext_update_extent to update
entries in the in-core extent list.  This isolates the function from
the detailed layout of the extent list, and generally makes the code
a lot more readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 138 +++++++++++++++++++++++++----------------------
 1 file changed, 74 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 05d4778ce528..edea670a3f74 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1588,7 +1588,6 @@ xfs_bmap_add_extent_delay_real(
 {
 	struct xfs_bmbt_irec	*new = &bma->got;
 	int			diff;	/* temp value */
-	xfs_bmbt_rec_host_t	*ep;	/* extent entry for idx */
 	int			error;	/* error return value */
 	int			i;	/* temp state */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
@@ -1604,6 +1603,7 @@ xfs_bmap_add_extent_delay_real(
 	int			tmp_rval;	/* partial logging flags */
 	struct xfs_mount	*mp;
 	xfs_extnum_t		*nextents;
+	struct xfs_bmbt_irec	old;
 
 	mp = bma->ip->i_mount;
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
@@ -1629,8 +1629,7 @@ xfs_bmap_add_extent_delay_real(
 	/*
 	 * Set up a bunch of variables to make the tests simpler.
 	 */
-	ep = xfs_iext_get_ext(ifp, bma->idx);
-	xfs_bmbt_get_all(ep, &PREV);
+	xfs_iext_get_extent(ifp, bma->idx, &PREV);
 	new_endoff = new->br_startoff + new->br_blockcount;
 	ASSERT(PREV.br_startoff <= new->br_startoff);
 	ASSERT(PREV.br_startoff + PREV.br_blockcount >= new_endoff);
@@ -1706,9 +1705,8 @@ xfs_bmap_add_extent_delay_real(
 		 */
 		bma->idx--;
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx),
-			LEFT.br_blockcount + PREV.br_blockcount +
-			RIGHT.br_blockcount);
+		LEFT.br_blockcount += PREV.br_blockcount + RIGHT.br_blockcount;
+		xfs_iext_update_extent(ifp, bma->idx, &LEFT);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
 		xfs_iext_remove(bma->ip, bma->idx + 1, 2, state);
@@ -1733,9 +1731,7 @@ xfs_bmap_add_extent_delay_real(
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
 					LEFT.br_startblock,
-					LEFT.br_blockcount +
-					PREV.br_blockcount +
-					RIGHT.br_blockcount, LEFT.br_state);
+					LEFT.br_blockcount, LEFT.br_state);
 			if (error)
 				goto done;
 		}
@@ -1748,9 +1744,10 @@ xfs_bmap_add_extent_delay_real(
 		 */
 		bma->idx--;
 
+		old = LEFT;
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx),
-			LEFT.br_blockcount + PREV.br_blockcount);
+		LEFT.br_blockcount += PREV.br_blockcount;
+		xfs_iext_update_extent(ifp, bma->idx, &LEFT);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
 		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
@@ -1758,16 +1755,15 @@ xfs_bmap_add_extent_delay_real(
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(bma->cur, LEFT.br_startoff,
-					LEFT.br_startblock, LEFT.br_blockcount,
+			error = xfs_bmbt_lookup_eq(bma->cur, old.br_startoff,
+					old.br_startblock, old.br_blockcount,
 					&i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
 					LEFT.br_startblock,
-					LEFT.br_blockcount +
-					PREV.br_blockcount, LEFT.br_state);
+					LEFT.br_blockcount, LEFT.br_state);
 			if (error)
 				goto done;
 		}
@@ -1779,9 +1775,9 @@ xfs_bmap_add_extent_delay_real(
 		 * The right neighbor is contiguous, the left is not.
 		 */
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
-		xfs_bmbt_set_startblock(ep, new->br_startblock);
-		xfs_bmbt_set_blockcount(ep,
-			PREV.br_blockcount + RIGHT.br_blockcount);
+		PREV.br_startblock = new->br_startblock;
+		PREV.br_blockcount += RIGHT.br_blockcount;
+		xfs_iext_update_extent(ifp, bma->idx, &PREV);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
 		xfs_iext_remove(bma->ip, bma->idx + 1, 1, state);
@@ -1796,9 +1792,8 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, PREV.br_startoff,
-					new->br_startblock,
-					PREV.br_blockcount +
-					RIGHT.br_blockcount, PREV.br_state);
+					PREV.br_startblock,
+					PREV.br_blockcount, PREV.br_state);
 			if (error)
 				goto done;
 		}
@@ -1811,8 +1806,9 @@ xfs_bmap_add_extent_delay_real(
 		 * the new one.
 		 */
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
-		xfs_bmbt_set_startblock(ep, new->br_startblock);
-		xfs_bmbt_set_state(ep, new->br_state);
+		PREV.br_startblock = new->br_startblock;
+		PREV.br_state = new->br_state;
+		xfs_iext_update_extent(ifp, bma->idx, &PREV);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
 		(*nextents)++;
@@ -1839,37 +1835,39 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is contiguous.
 		 */
+		old = LEFT;
+
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx - 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, bma->idx - 1),
-			LEFT.br_blockcount + new->br_blockcount);
-		xfs_bmbt_set_startoff(ep,
-			PREV.br_startoff + new->br_blockcount);
+		LEFT.br_blockcount += new->br_blockcount;
+		xfs_iext_update_extent(ifp, bma->idx - 1, &LEFT);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx - 1, state, _THIS_IP_);
 
-		temp = PREV.br_blockcount - new->br_blockcount;
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(ep, temp);
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
 			rval = 0;
-			error = xfs_bmbt_lookup_eq(bma->cur, LEFT.br_startoff,
-					LEFT.br_startblock, LEFT.br_blockcount,
+			error = xfs_bmbt_lookup_eq(bma->cur, old.br_startoff,
+					old.br_startblock, old.br_blockcount,
 					&i);
 			if (error)
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, LEFT.br_startoff,
-					LEFT.br_startblock,
-					LEFT.br_blockcount +
-					new->br_blockcount,
+					LEFT.br_startblock, LEFT.br_blockcount,
 					LEFT.br_state);
 			if (error)
 				goto done;
 		}
+
+		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock));
-		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
+
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
+		PREV.br_startoff += new->br_blockcount;
+		PREV.br_blockcount = temp;
+		PREV.br_startblock = nullstartblock(da_new);
+		xfs_iext_update_extent(ifp, bma->idx, &PREV);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
 		bma->idx--;
@@ -1880,10 +1878,6 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is not contiguous.
 		 */
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
-		xfs_bmbt_set_startoff(ep, new_endoff);
-		temp = PREV.br_blockcount - new->br_blockcount;
-		xfs_bmbt_set_blockcount(ep, temp);
 		xfs_iext_insert(bma->ip, bma->idx, 1, new, state);
 		(*nextents)++;
 		if (bma->cur == NULL)
@@ -1911,12 +1905,19 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+
+		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
 			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
-		ep = xfs_iext_get_ext(ifp, bma->idx + 1);
-		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
+
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
+		PREV.br_startoff = new_endoff;
+		PREV.br_blockcount = temp;
+		PREV.br_startblock = nullstartblock(da_new);
+		xfs_iext_update_extent(ifp, bma->idx + 1, &PREV);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
+
 		break;
 
 	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1924,14 +1925,13 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the last part of a previous delayed allocation.
 		 * The right neighbor is contiguous with the new allocation.
 		 */
-		temp = PREV.br_blockcount - new->br_blockcount;
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(ep, temp);
-		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, bma->idx + 1),
-			new->br_startoff, new->br_startblock,
-			new->br_blockcount + RIGHT.br_blockcount,
-			RIGHT.br_state);
+		RIGHT.br_startoff = new->br_startoff;
+		RIGHT.br_startblock = new->br_startblock;
+		RIGHT.br_blockcount += new->br_blockcount;
+		xfs_iext_update_extent(ifp, bma->idx + 1, &RIGHT);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx + 1, state, _THIS_IP_);
+
 		if (bma->cur == NULL)
 			rval = XFS_ILOG_DEXT;
 		else {
@@ -1943,18 +1943,20 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 			error = xfs_bmbt_update(bma->cur, new->br_startoff,
-					new->br_startblock,
-					new->br_blockcount +
-					RIGHT.br_blockcount,
-					RIGHT.br_state);
+					new->br_startblock, new->br_blockcount,
+					new->br_state);
 			if (error)
 				goto done;
 		}
 
+		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock));
+
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
-		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
+		PREV.br_blockcount = temp;
+		PREV.br_startblock = nullstartblock(da_new);
+		xfs_iext_update_extent(ifp, bma->idx, &PREV);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
 		bma->idx++;
@@ -1965,9 +1967,6 @@ xfs_bmap_add_extent_delay_real(
 		 * Filling in the last part of a previous delayed allocation.
 		 * The right neighbor is not contiguous.
 		 */
-		temp = PREV.br_blockcount - new->br_blockcount;
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(ep, temp);
 		xfs_iext_insert(bma->ip, bma->idx + 1, 1, new, state);
 		(*nextents)++;
 		if (bma->cur == NULL)
@@ -1995,11 +1994,16 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+
+		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
 			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
-		ep = xfs_iext_get_ext(ifp, bma->idx);
-		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
+
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
+		PREV.br_startblock = nullstartblock(da_new);
+		PREV.br_blockcount = temp;
+		xfs_iext_update_extent(ifp, bma->idx, &PREV);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
 		bma->idx++;
@@ -2028,14 +2032,16 @@ xfs_bmap_add_extent_delay_real(
 		 */
 		temp = new->br_startoff - PREV.br_startoff;
 		temp2 = PREV.br_startoff + PREV.br_blockcount - new_endoff;
-		trace_xfs_bmap_pre_update(bma->ip, bma->idx, 0, _THIS_IP_);
-		xfs_bmbt_set_blockcount(ep, temp);	/* truncate PREV */
+
+		/* left is the new middle */
 		LEFT = *new;
+
 		RIGHT.br_state = PREV.br_state;
 		RIGHT.br_startblock = nullstartblock(
 				(int)xfs_bmap_worst_indlen(bma->ip, temp2));
 		RIGHT.br_startoff = new_endoff;
 		RIGHT.br_blockcount = temp2;
+
 		/* insert LEFT (r[0]) and RIGHT (r[1]) at the same time */
 		xfs_iext_insert(bma->ip, bma->idx + 1, 2, &LEFT, state);
 		(*nextents)++;
@@ -2078,12 +2084,16 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 
-		ep = xfs_iext_get_ext(ifp, bma->idx);
-		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+		trace_xfs_bmap_pre_update(bma->ip, bma->idx, 0, _THIS_IP_);
+		PREV.br_startblock = nullstartblock(temp);
+		PREV.br_blockcount = temp;	/* truncate PREV */
+		xfs_iext_update_extent(ifp, bma->idx, &PREV);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
+
+		/* update to the final reservation: */
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx + 2, state, _THIS_IP_);
-		xfs_bmbt_set_startblock(xfs_iext_get_ext(ifp, bma->idx + 2),
-			nullstartblock((int)temp2));
+		RIGHT.br_startblock = nullstartblock(temp2);
+		xfs_iext_update_extent(ifp, bma->idx + 2, &RIGHT);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx + 2, state, _THIS_IP_);
 
 		bma->idx++;
-- 
2.11.0

