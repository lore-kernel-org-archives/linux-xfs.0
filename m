Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAONxqLI179266 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 17:59:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F78D18D8CF2
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 16:00:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IS03Bw5ROgDl1H96 for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2009 16:00:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1ND5Ix-00078Z-4s
	for xfs@oss.sgi.com; Wed, 25 Nov 2009 00:00:19 +0000
Date: Tue, 24 Nov 2009 19:00:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: cleanup bmap extent state macros
Message-ID: <20091125000019.GA25432@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Cleanup the extent state macros in the bmap code to use one common set of
flags that we can pass to the tracing code later and remove a lot of the
macro obsfucation.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap.c	2009-11-22 15:48:03.878003749 +0100
+++ linux-2.6/fs/xfs/xfs_bmap.c	2009-11-22 15:51:48.909278905 +0100
@@ -759,26 +759,10 @@ xfs_bmap_add_extent_delay_real(
 	xfs_filblks_t		temp=0;	/* value for dnew calculations */
 	xfs_filblks_t		temp2=0;/* value for dnew calculations */
 	int			tmp_rval;	/* partial logging flags */
-	enum {				/* bit number definitions for state */
-		LEFT_CONTIG,	RIGHT_CONTIG,
-		LEFT_FILLING,	RIGHT_FILLING,
-		LEFT_DELAY,	RIGHT_DELAY,
-		LEFT_VALID,	RIGHT_VALID
-	};
 
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
 #define	PREV		r[2]
-#define	MASK(b)		(1 << (b))
-#define	MASK2(a,b)	(MASK(a) | MASK(b))
-#define	MASK3(a,b,c)	(MASK2(a,b) | MASK(c))
-#define	MASK4(a,b,c,d)	(MASK3(a,b,c) | MASK(d))
-#define	STATE_SET(b,v)	((v) ? (state |= MASK(b)) : (state &= ~MASK(b)))
-#define	STATE_TEST(b)	(state & MASK(b))
-#define	STATE_SET_TEST(b,v)	((v) ? ((state |= MASK(b)), 1) : \
-				       ((state &= ~MASK(b)), 0))
-#define	SWITCH_STATE		\
-	(state & MASK4(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG))
 
 	/*
 	 * Set up a bunch of variables to make the tests simpler.
@@ -790,56 +774,69 @@ xfs_bmap_add_extent_delay_real(
 	new_endoff = new->br_startoff + new->br_blockcount;
 	ASSERT(PREV.br_startoff <= new->br_startoff);
 	ASSERT(PREV.br_startoff + PREV.br_blockcount >= new_endoff);
+
 	/*
 	 * Set flags determining what part of the previous delayed allocation
 	 * extent is being replaced by a real allocation.
 	 */
-	STATE_SET(LEFT_FILLING, PREV.br_startoff == new->br_startoff);
-	STATE_SET(RIGHT_FILLING,
-		PREV.br_startoff + PREV.br_blockcount == new_endoff);
+	if (PREV.br_startoff == new->br_startoff)
+		state |= BMAP_LEFT_FILLING;
+	if (PREV.br_startoff + PREV.br_blockcount == new_endoff)
+		state |= BMAP_RIGHT_FILLING;
+
 	/*
 	 * Check and set flags if this segment has a left neighbor.
 	 * Don't set contiguous if the combined extent would be too large.
 	 */
-	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
+	if (idx > 0) {
+		state |= BMAP_LEFT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &LEFT);
-		STATE_SET(LEFT_DELAY, isnullstartblock(LEFT.br_startblock));
+
+		if (isnullstartblock(LEFT.br_startblock))
+			state |= BMAP_LEFT_DELAY;
 	}
-	STATE_SET(LEFT_CONTIG,
-		STATE_TEST(LEFT_VALID) && !STATE_TEST(LEFT_DELAY) &&
-		LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
-		LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
-		LEFT.br_state == new->br_state &&
-		LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN);
+
+	if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
+	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
+	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
+	    LEFT.br_state == new->br_state &&
+	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+		state |= BMAP_LEFT_CONTIG;
+
 	/*
 	 * Check and set flags if this segment has a right neighbor.
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (STATE_SET_TEST(RIGHT_VALID,
-			idx <
-			ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1)) {
+	if (idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
+		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx + 1), &RIGHT);
-		STATE_SET(RIGHT_DELAY, isnullstartblock(RIGHT.br_startblock));
+
+		if (isnullstartblock(RIGHT.br_startblock))
+			state |= BMAP_RIGHT_DELAY;
 	}
-	STATE_SET(RIGHT_CONTIG,
-		STATE_TEST(RIGHT_VALID) && !STATE_TEST(RIGHT_DELAY) &&
-		new_endoff == RIGHT.br_startoff &&
-		new->br_startblock + new->br_blockcount ==
-		    RIGHT.br_startblock &&
-		new->br_state == RIGHT.br_state &&
-		new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
-		((state & MASK3(LEFT_CONTIG, LEFT_FILLING, RIGHT_FILLING)) !=
-		  MASK3(LEFT_CONTIG, LEFT_FILLING, RIGHT_FILLING) ||
-		 LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-		     <= MAXEXTLEN));
+
+	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
+	    new_endoff == RIGHT.br_startoff &&
+	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
+	    new->br_state == RIGHT.br_state &&
+	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
+		       BMAP_RIGHT_FILLING)) !=
+		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
+		       BMAP_RIGHT_FILLING) ||
+	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
+			<= MAXEXTLEN))
+		state |= BMAP_RIGHT_CONTIG;
+
 	error = 0;
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
 	 */
-	switch (SWITCH_STATE) {
-
-	case MASK4(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
+	switch (state & (BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG |
+			 BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG)) {
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG |
+	     BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left and right neighbors are both contiguous with new.
@@ -885,7 +882,7 @@ xfs_bmap_add_extent_delay_real(
 			RIGHT.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
 		/*
 		 * Filling in all of a previously delayed allocation extent.
 		 * The left neighbor is contiguous, the right is not.
@@ -921,7 +918,7 @@ xfs_bmap_add_extent_delay_real(
 			PREV.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, RIGHT_FILLING, RIGHT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Filling in all of a previously delayed allocation extent.
 		 * The right neighbor is contiguous, the left is not.
@@ -956,7 +953,7 @@ xfs_bmap_add_extent_delay_real(
 			RIGHT.br_blockcount;
 		break;
 
-	case MASK2(LEFT_FILLING, RIGHT_FILLING):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
 		/*
 		 * Filling in all of a previously delayed allocation extent.
 		 * Neither the left nor right neighbors are contiguous with
@@ -987,7 +984,7 @@ xfs_bmap_add_extent_delay_real(
 		temp2 = new->br_blockcount;
 		break;
 
-	case MASK2(LEFT_FILLING, LEFT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
 		/*
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is contiguous.
@@ -1029,7 +1026,7 @@ xfs_bmap_add_extent_delay_real(
 			PREV.br_blockcount;
 		break;
 
-	case MASK(LEFT_FILLING):
+	case BMAP_LEFT_FILLING:
 		/*
 		 * Filling in the first part of a previous delayed allocation.
 		 * The left neighbor is not contiguous.
@@ -1078,7 +1075,7 @@ xfs_bmap_add_extent_delay_real(
 		temp2 = PREV.br_blockcount;
 		break;
 
-	case MASK2(RIGHT_FILLING, RIGHT_CONTIG):
+	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Filling in the last part of a previous delayed allocation.
 		 * The right neighbor is contiguous with the new allocation.
@@ -1120,7 +1117,7 @@ xfs_bmap_add_extent_delay_real(
 			RIGHT.br_blockcount;
 		break;
 
-	case MASK(RIGHT_FILLING):
+	case BMAP_RIGHT_FILLING:
 		/*
 		 * Filling in the last part of a previous delayed allocation.
 		 * The right neighbor is not contiguous.
@@ -1253,13 +1250,13 @@ xfs_bmap_add_extent_delay_real(
 		temp2 = PREV.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK3(RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK2(LEFT_FILLING, RIGHT_CONTIG):
-	case MASK2(RIGHT_FILLING, LEFT_CONTIG):
-	case MASK2(LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK(LEFT_CONTIG):
-	case MASK(RIGHT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_CONTIG:
+	case BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
+	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_LEFT_CONTIG:
+	case BMAP_RIGHT_CONTIG:
 		/*
 		 * These cases are all impossible.
 		 */
@@ -1279,14 +1276,6 @@ done:
 #undef	LEFT
 #undef	RIGHT
 #undef	PREV
-#undef	MASK
-#undef	MASK2
-#undef	MASK3
-#undef	MASK4
-#undef	STATE_SET
-#undef	STATE_TEST
-#undef	STATE_SET_TEST
-#undef	SWITCH_STATE
 }
 
 /*
@@ -1316,27 +1305,10 @@ xfs_bmap_add_extent_unwritten_real(
 	int			state = 0;/* state bits, accessed thru macros */
 	xfs_filblks_t		temp=0;
 	xfs_filblks_t		temp2=0;
-	enum {				/* bit number definitions for state */
-		LEFT_CONTIG,	RIGHT_CONTIG,
-		LEFT_FILLING,	RIGHT_FILLING,
-		LEFT_DELAY,	RIGHT_DELAY,
-		LEFT_VALID,	RIGHT_VALID
-	};
 
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
 #define	PREV		r[2]
-#define	MASK(b)		(1 << (b))
-#define	MASK2(a,b)	(MASK(a) | MASK(b))
-#define	MASK3(a,b,c)	(MASK2(a,b) | MASK(c))
-#define	MASK4(a,b,c,d)	(MASK3(a,b,c) | MASK(d))
-#define	STATE_SET(b,v)	((v) ? (state |= MASK(b)) : (state &= ~MASK(b)))
-#define	STATE_TEST(b)	(state & MASK(b))
-#define	STATE_SET_TEST(b,v)	((v) ? ((state |= MASK(b)), 1) : \
-				       ((state &= ~MASK(b)), 0))
-#define	SWITCH_STATE		\
-	(state & MASK4(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG))
-
 	/*
 	 * Set up a bunch of variables to make the tests simpler.
 	 */
@@ -1352,55 +1324,67 @@ xfs_bmap_add_extent_unwritten_real(
 	new_endoff = new->br_startoff + new->br_blockcount;
 	ASSERT(PREV.br_startoff <= new->br_startoff);
 	ASSERT(PREV.br_startoff + PREV.br_blockcount >= new_endoff);
+
 	/*
 	 * Set flags determining what part of the previous oldext allocation
 	 * extent is being replaced by a newext allocation.
 	 */
-	STATE_SET(LEFT_FILLING, PREV.br_startoff == new->br_startoff);
-	STATE_SET(RIGHT_FILLING,
-		PREV.br_startoff + PREV.br_blockcount == new_endoff);
+	if (PREV.br_startoff == new->br_startoff)
+		state |= BMAP_LEFT_FILLING;
+	if (PREV.br_startoff + PREV.br_blockcount == new_endoff)
+		state |= BMAP_RIGHT_FILLING;
+
 	/*
 	 * Check and set flags if this segment has a left neighbor.
 	 * Don't set contiguous if the combined extent would be too large.
 	 */
-	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
+	if (idx > 0) {
+		state |= BMAP_LEFT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &LEFT);
-		STATE_SET(LEFT_DELAY, isnullstartblock(LEFT.br_startblock));
+
+		if (isnullstartblock(LEFT.br_startblock))
+			state |= BMAP_LEFT_DELAY;
 	}
-	STATE_SET(LEFT_CONTIG,
-		STATE_TEST(LEFT_VALID) && !STATE_TEST(LEFT_DELAY) &&
-		LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
-		LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
-		LEFT.br_state == newext &&
-		LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN);
+
+	if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
+	    LEFT.br_startoff + LEFT.br_blockcount == new->br_startoff &&
+	    LEFT.br_startblock + LEFT.br_blockcount == new->br_startblock &&
+	    LEFT.br_state == newext &&
+	    LEFT.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+		state |= BMAP_LEFT_CONTIG;
+
 	/*
 	 * Check and set flags if this segment has a right neighbor.
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (STATE_SET_TEST(RIGHT_VALID,
-			idx <
-			ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1)) {
+	if (idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
+		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx + 1), &RIGHT);
-		STATE_SET(RIGHT_DELAY, isnullstartblock(RIGHT.br_startblock));
+		if (isnullstartblock(RIGHT.br_startblock))
+			state |= BMAP_RIGHT_DELAY;
 	}
-	STATE_SET(RIGHT_CONTIG,
-		STATE_TEST(RIGHT_VALID) && !STATE_TEST(RIGHT_DELAY) &&
-		new_endoff == RIGHT.br_startoff &&
-		new->br_startblock + new->br_blockcount ==
-		    RIGHT.br_startblock &&
-		newext == RIGHT.br_state &&
-		new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
-		((state & MASK3(LEFT_CONTIG, LEFT_FILLING, RIGHT_FILLING)) !=
-		  MASK3(LEFT_CONTIG, LEFT_FILLING, RIGHT_FILLING) ||
-		 LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
-		     <= MAXEXTLEN));
+
+	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
+	    new_endoff == RIGHT.br_startoff &&
+	    new->br_startblock + new->br_blockcount == RIGHT.br_startblock &&
+	    newext == RIGHT.br_state &&
+	    new->br_blockcount + RIGHT.br_blockcount <= MAXEXTLEN &&
+	    ((state & (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
+		       BMAP_RIGHT_FILLING)) !=
+		      (BMAP_LEFT_CONTIG | BMAP_LEFT_FILLING |
+		       BMAP_RIGHT_FILLING) ||
+	     LEFT.br_blockcount + new->br_blockcount + RIGHT.br_blockcount
+			<= MAXEXTLEN))
+		state |= BMAP_RIGHT_CONTIG;
+
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
 	 */
-	switch (SWITCH_STATE) {
-
-	case MASK4(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
+	switch (state & (BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG |
+			 BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG)) {
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG |
+	     BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Setting all of a previous oldext extent to newext.
 		 * The left and right neighbors are both contiguous with new.
@@ -1450,7 +1434,7 @@ xfs_bmap_add_extent_unwritten_real(
 			RIGHT.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, RIGHT_FILLING, LEFT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
 		/*
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
@@ -1492,7 +1476,7 @@ xfs_bmap_add_extent_unwritten_real(
 			PREV.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, RIGHT_FILLING, RIGHT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Setting all of a previous oldext extent to newext.
 		 * The right neighbor is contiguous, the left is not.
@@ -1535,7 +1519,7 @@ xfs_bmap_add_extent_unwritten_real(
 			RIGHT.br_blockcount;
 		break;
 
-	case MASK2(LEFT_FILLING, RIGHT_FILLING):
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
 		/*
 		 * Setting all of a previous oldext extent to newext.
 		 * Neither the left nor right neighbors are contiguous with
@@ -1566,7 +1550,7 @@ xfs_bmap_add_extent_unwritten_real(
 		temp2 = new->br_blockcount;
 		break;
 
-	case MASK2(LEFT_FILLING, LEFT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
 		/*
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is contiguous.
@@ -1617,7 +1601,7 @@ xfs_bmap_add_extent_unwritten_real(
 			PREV.br_blockcount;
 		break;
 
-	case MASK(LEFT_FILLING):
+	case BMAP_LEFT_FILLING:
 		/*
 		 * Setting the first part of a previous oldext extent to newext.
 		 * The left neighbor is not contiguous.
@@ -1660,7 +1644,7 @@ xfs_bmap_add_extent_unwritten_real(
 		temp2 = PREV.br_blockcount;
 		break;
 
-	case MASK2(RIGHT_FILLING, RIGHT_CONTIG):
+	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
 		/*
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is contiguous with the new allocation.
@@ -1707,7 +1691,7 @@ xfs_bmap_add_extent_unwritten_real(
 			RIGHT.br_blockcount;
 		break;
 
-	case MASK(RIGHT_FILLING):
+	case BMAP_RIGHT_FILLING:
 		/*
 		 * Setting the last part of a previous oldext extent to newext.
 		 * The right neighbor is not contiguous.
@@ -1813,13 +1797,13 @@ xfs_bmap_add_extent_unwritten_real(
 		temp2 = PREV.br_blockcount;
 		break;
 
-	case MASK3(LEFT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK3(RIGHT_FILLING, LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK2(LEFT_FILLING, RIGHT_CONTIG):
-	case MASK2(RIGHT_FILLING, LEFT_CONTIG):
-	case MASK2(LEFT_CONTIG, RIGHT_CONTIG):
-	case MASK(LEFT_CONTIG):
-	case MASK(RIGHT_CONTIG):
+	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_CONTIG:
+	case BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
+	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+	case BMAP_LEFT_CONTIG:
+	case BMAP_RIGHT_CONTIG:
 		/*
 		 * These cases are all impossible.
 		 */
@@ -1839,14 +1823,6 @@ done:
 #undef	LEFT
 #undef	RIGHT
 #undef	PREV
-#undef	MASK
-#undef	MASK2
-#undef	MASK3
-#undef	MASK4
-#undef	STATE_SET
-#undef	STATE_TEST
-#undef	STATE_SET_TEST
-#undef	SWITCH_STATE
 }
 
 /*
@@ -1872,62 +1848,57 @@ xfs_bmap_add_extent_hole_delay(
 	int			state;  /* state bits, accessed thru macros */
 	xfs_filblks_t		temp=0;	/* temp for indirect calculations */
 	xfs_filblks_t		temp2=0;
-	enum {				/* bit number definitions for state */
-		LEFT_CONTIG,	RIGHT_CONTIG,
-		LEFT_DELAY,	RIGHT_DELAY,
-		LEFT_VALID,	RIGHT_VALID
-	};
-
-#define	MASK(b)			(1 << (b))
-#define	MASK2(a,b)		(MASK(a) | MASK(b))
-#define	STATE_SET(b,v)		((v) ? (state |= MASK(b)) : (state &= ~MASK(b)))
-#define	STATE_TEST(b)		(state & MASK(b))
-#define	STATE_SET_TEST(b,v)	((v) ? ((state |= MASK(b)), 1) : \
-				       ((state &= ~MASK(b)), 0))
-#define	SWITCH_STATE		(state & MASK2(LEFT_CONTIG, RIGHT_CONTIG))
 
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	ep = xfs_iext_get_ext(ifp, idx);
 	state = 0;
 	ASSERT(isnullstartblock(new->br_startblock));
+
 	/*
 	 * Check and set flags if this segment has a left neighbor
 	 */
-	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
+	if (idx > 0) {
+		state |= BMAP_LEFT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &left);
-		STATE_SET(LEFT_DELAY, isnullstartblock(left.br_startblock));
+
+		if (isnullstartblock(left.br_startblock))
+			state |= BMAP_LEFT_DELAY;
 	}
+
 	/*
 	 * Check and set flags if the current (right) segment exists.
 	 * If it doesn't exist, we're converting the hole at end-of-file.
 	 */
-	if (STATE_SET_TEST(RIGHT_VALID,
-			   idx <
-			   ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
+	if (idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(ep, &right);
-		STATE_SET(RIGHT_DELAY, isnullstartblock(right.br_startblock));
+
+		if (isnullstartblock(right.br_startblock))
+			state |= BMAP_RIGHT_DELAY;
 	}
+
 	/*
 	 * Set contiguity flags on the left and right neighbors.
 	 * Don't let extents get too large, even if the pieces are contiguous.
 	 */
-	STATE_SET(LEFT_CONTIG,
-		STATE_TEST(LEFT_VALID) && STATE_TEST(LEFT_DELAY) &&
-		left.br_startoff + left.br_blockcount == new->br_startoff &&
-		left.br_blockcount + new->br_blockcount <= MAXEXTLEN);
-	STATE_SET(RIGHT_CONTIG,
-		STATE_TEST(RIGHT_VALID) && STATE_TEST(RIGHT_DELAY) &&
-		new->br_startoff + new->br_blockcount == right.br_startoff &&
-		new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
-		(!STATE_TEST(LEFT_CONTIG) ||
-		 (left.br_blockcount + new->br_blockcount +
-		     right.br_blockcount <= MAXEXTLEN)));
+	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
+	    left.br_startoff + left.br_blockcount == new->br_startoff &&
+	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+		state |= BMAP_LEFT_CONTIG;
+
+	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
+	    new->br_startoff + new->br_blockcount == right.br_startoff &&
+	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    (!(state & BMAP_LEFT_CONTIG) ||
+	     (left.br_blockcount + new->br_blockcount +
+	      right.br_blockcount <= MAXEXTLEN)))
+		state |= BMAP_RIGHT_CONTIG;
+
 	/*
 	 * Switch out based on the contiguity flags.
 	 */
-	switch (SWITCH_STATE) {
-
-	case MASK2(LEFT_CONTIG, RIGHT_CONTIG):
+	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
+	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
 		/*
 		 * New allocation is contiguous with delayed allocations
 		 * on the left and on the right.
@@ -1954,7 +1925,7 @@ xfs_bmap_add_extent_hole_delay(
 		temp = left.br_startoff;
 		break;
 
-	case MASK(LEFT_CONTIG):
+	case BMAP_LEFT_CONTIG:
 		/*
 		 * New allocation is contiguous with a delayed allocation
 		 * on the left.
@@ -1977,7 +1948,7 @@ xfs_bmap_add_extent_hole_delay(
 		temp = left.br_startoff;
 		break;
 
-	case MASK(RIGHT_CONTIG):
+	case BMAP_RIGHT_CONTIG:
 		/*
 		 * New allocation is contiguous with a delayed allocation
 		 * on the right.
@@ -2030,12 +2001,6 @@ xfs_bmap_add_extent_hole_delay(
 	}
 	*logflagsp = 0;
 	return 0;
-#undef	MASK
-#undef	MASK2
-#undef	STATE_SET
-#undef	STATE_TEST
-#undef	STATE_SET_TEST
-#undef	SWITCH_STATE
 }
 
 /*
@@ -2062,69 +2027,60 @@ xfs_bmap_add_extent_hole_real(
 	int			state;	/* state bits, accessed thru macros */
 	xfs_filblks_t		temp=0;
 	xfs_filblks_t		temp2=0;
-	enum {				/* bit number definitions for state */
-		LEFT_CONTIG,	RIGHT_CONTIG,
-		LEFT_DELAY,	RIGHT_DELAY,
-		LEFT_VALID,	RIGHT_VALID
-	};
-
-#define	MASK(b)			(1 << (b))
-#define	MASK2(a,b)		(MASK(a) | MASK(b))
-#define	STATE_SET(b,v)		((v) ? (state |= MASK(b)) : (state &= ~MASK(b)))
-#define	STATE_TEST(b)		(state & MASK(b))
-#define	STATE_SET_TEST(b,v)	((v) ? ((state |= MASK(b)), 1) : \
-				       ((state &= ~MASK(b)), 0))
-#define	SWITCH_STATE		(state & MASK2(LEFT_CONTIG, RIGHT_CONTIG))
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(idx <= ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
 	ep = xfs_iext_get_ext(ifp, idx);
 	state = 0;
+
 	/*
 	 * Check and set flags if this segment has a left neighbor.
 	 */
-	if (STATE_SET_TEST(LEFT_VALID, idx > 0)) {
+	if (idx > 0) {
+		state |= BMAP_LEFT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx - 1), &left);
-		STATE_SET(LEFT_DELAY, isnullstartblock(left.br_startblock));
+		if (isnullstartblock(left.br_startblock))
+			state |= BMAP_LEFT_DELAY;
 	}
+
 	/*
 	 * Check and set flags if this segment has a current value.
 	 * Not true if we're inserting into the "hole" at eof.
 	 */
-	if (STATE_SET_TEST(RIGHT_VALID,
-			   idx <
-			   ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))) {
+	if (idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(ep, &right);
-		STATE_SET(RIGHT_DELAY, isnullstartblock(right.br_startblock));
+		if (isnullstartblock(right.br_startblock))
+			state |= BMAP_RIGHT_DELAY;
 	}
+
 	/*
 	 * We're inserting a real allocation between "left" and "right".
 	 * Set the contiguity flags.  Don't let extents get too large.
 	 */
-	STATE_SET(LEFT_CONTIG,
-		STATE_TEST(LEFT_VALID) && !STATE_TEST(LEFT_DELAY) &&
-		left.br_startoff + left.br_blockcount == new->br_startoff &&
-		left.br_startblock + left.br_blockcount == new->br_startblock &&
-		left.br_state == new->br_state &&
-		left.br_blockcount + new->br_blockcount <= MAXEXTLEN);
-	STATE_SET(RIGHT_CONTIG,
-		STATE_TEST(RIGHT_VALID) && !STATE_TEST(RIGHT_DELAY) &&
-		new->br_startoff + new->br_blockcount == right.br_startoff &&
-		new->br_startblock + new->br_blockcount ==
-		    right.br_startblock &&
-		new->br_state == right.br_state &&
-		new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
-		(!STATE_TEST(LEFT_CONTIG) ||
-		 left.br_blockcount + new->br_blockcount +
-		     right.br_blockcount <= MAXEXTLEN));
+	if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
+	    left.br_startoff + left.br_blockcount == new->br_startoff &&
+	    left.br_startblock + left.br_blockcount == new->br_startblock &&
+	    left.br_state == new->br_state &&
+	    left.br_blockcount + new->br_blockcount <= MAXEXTLEN)
+		state |= BMAP_LEFT_CONTIG;
+
+	if ((state & BMAP_RIGHT_VALID) && !(state & BMAP_RIGHT_DELAY) &&
+	    new->br_startoff + new->br_blockcount == right.br_startoff &&
+	    new->br_startblock + new->br_blockcount == right.br_startblock &&
+	    new->br_state == right.br_state &&
+	    new->br_blockcount + right.br_blockcount <= MAXEXTLEN &&
+	    (!(state & BMAP_LEFT_CONTIG) ||
+	     left.br_blockcount + new->br_blockcount +
+	     right.br_blockcount <= MAXEXTLEN))
+		state |= BMAP_RIGHT_CONTIG;
 
 	error = 0;
 	/*
 	 * Select which case we're in here, and implement it.
 	 */
-	switch (SWITCH_STATE) {
-
-	case MASK2(LEFT_CONTIG, RIGHT_CONTIG):
+	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
+	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
 		/*
 		 * New allocation is contiguous with real allocations on the
 		 * left and on the right.
@@ -2173,7 +2129,7 @@ xfs_bmap_add_extent_hole_real(
 			right.br_blockcount;
 		break;
 
-	case MASK(LEFT_CONTIG):
+	case BMAP_LEFT_CONTIG:
 		/*
 		 * New allocation is contiguous with a real allocation
 		 * on the left.
@@ -2207,7 +2163,7 @@ xfs_bmap_add_extent_hole_real(
 			new->br_blockcount;
 		break;
 
-	case MASK(RIGHT_CONTIG):
+	case BMAP_RIGHT_CONTIG:
 		/*
 		 * New allocation is contiguous with a real allocation
 		 * on the right.
@@ -2283,12 +2239,6 @@ xfs_bmap_add_extent_hole_real(
 done:
 	*logflagsp = rval;
 	return error;
-#undef	MASK
-#undef	MASK2
-#undef	STATE_SET
-#undef	STATE_TEST
-#undef	STATE_SET_TEST
-#undef	SWITCH_STATE
 }
 
 /*
Index: linux-2.6/fs/xfs/xfs_bmap.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap.h	2009-11-22 15:48:03.887004267 +0100
+++ linux-2.6/fs/xfs/xfs_bmap.h	2009-11-22 15:52:02.790175382 +0100
@@ -135,6 +135,18 @@ typedef struct xfs_bmalloca {
 	char			conv;	/* overwriting unwritten extents */
 } xfs_bmalloca_t;
 
+/*
+ * Flags for xfs_bmap_add_extent*.
+ */
+#define BMAP_LEFT_CONTIG	(1 << 0)
+#define BMAP_RIGHT_CONTIG	(1 << 1)
+#define BMAP_LEFT_FILLING	(1 << 2)
+#define BMAP_RIGHT_FILLING	(1 << 3)
+#define BMAP_LEFT_DELAY		(1 << 4)
+#define BMAP_RIGHT_DELAY	(1 << 5)
+#define BMAP_LEFT_VALID		(1 << 6)
+#define BMAP_RIGHT_VALID	(1 << 7)
+
 #if defined(__KERNEL__) && defined(XFS_BMAP_TRACE)
 /*
  * Trace operations for bmap extent tracing

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
