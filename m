Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 23:04:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2K64GE6027161
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 23:04:18 -0700
Message-ID: <47E2000B.9030208@sgi.com>
Date: Thu, 20 Mar 2008 17:11:23 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: REVIEW: xfs_bmap_check_leaf_extents() can reference unmapped memory
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

While investigating the extent corruption bug I ran into this bug in
debug only code.  xfs_bmap_check_leaf_extents() loops through the leaf
blocks of the extent btree checking that every extent is entirely
before the next extent.  It also compares the last extent in the previous
block to the first extent in the current block when the previous block
has been released and potentially unmapped.  So take a copy of the last
extent instead of a pointer.  Also move the last extent check out of the
loop because we only need to do it once.

Lachlan


--- fs/xfs/xfs_bmap.c_1.386	2008-03-17 13:37:32.000000000 +1100
+++ fs/xfs/xfs_bmap.c	2008-03-19 14:55:41.000000000 +1100
@@ -6194,7 +6194,7 @@ xfs_bmap_check_leaf_extents(
  	xfs_mount_t		*mp;	/* file system mount structure */
  	__be64			*pp;	/* pointer to block address */
  	xfs_bmbt_rec_t		*ep;	/* pointer to current extent */
-	xfs_bmbt_rec_t		*lastp; /* pointer to previous extent */
+	xfs_bmbt_rec_t		last;   /* last extent in previous block */
  	xfs_bmbt_rec_t		*nextp;	/* pointer to next extent */
  	int			bp_release = 0;

@@ -6264,7 +6264,6 @@ xfs_bmap_check_leaf_extents(
  	/*
  	 * Loop over all leaf nodes checking that all extents are in the right order.
  	 */
-	lastp = NULL;
  	for (;;) {
  		xfs_fsblock_t	nextbno;
  		xfs_extnum_t	num_recs;
@@ -6285,18 +6284,18 @@ xfs_bmap_check_leaf_extents(
  		 */

  		ep = XFS_BTREE_REC_ADDR(xfs_bmbt, block, 1);
+		if (i) {
+			xfs_btree_check_rec(XFS_BTNUM_BMAP, (void *)&last,
+				(void *)ep);
+		}
  		for (j = 1; j < num_recs; j++) {
  			nextp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, j + 1);
-			if (lastp) {
-				xfs_btree_check_rec(XFS_BTNUM_BMAP,
-					(void *)lastp, (void *)ep);
-			}
  			xfs_btree_check_rec(XFS_BTNUM_BMAP, (void *)ep,
  				(void *)(nextp));
-			lastp = ep;
  			ep = nextp;
  		}

+		last = *ep;
  		i += num_recs;
  		if (bp_release) {
  			bp_release = 0;
