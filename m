Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 01:41:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5N8f3bm027002
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 01:41:05 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA14569 for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 18:42:03 +1000
Date: Mon, 23 Jun 2008 18:44:58 +1000
Subject: REVIEW: Fix CI lookup in leaf-form directories
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Message-ID: <op.uc6088qm3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Along the same lines as the node-form directory patch last week,
the leaf-form is not handling directory buffers properly and
locks up.

Instead of comparing buffer pointers, compare buffer block numbers
and don't keep buffers hanging around.


--- a/fs/xfs/xfs_dir2_leaf.c	2008-06-23 18:35:54.000000000 +1000
+++ b/fs/xfs/xfs_dir2_leaf.c	2008-06-23 18:27:38.214277630 +1000
@@ -1333,7 +1333,7 @@ xfs_dir2_leaf_lookup_int(
  	xfs_mount_t		*mp;		/* filesystem mount point */
  	xfs_dir2_db_t		newdb;		/* new data block number */
  	xfs_trans_t		*tp;		/* transaction pointer */
-	xfs_dabuf_t		*cbp;		/* case match data buffer */
+	xfs_dir2_db_t		cidb;		/* case match data block no. */
  	enum xfs_dacmp		cmp;		/* name compare result */

  	dp = args->dp;
@@ -1358,8 +1358,7 @@ xfs_dir2_leaf_lookup_int(
  	 * Loop over all the entries with the right hash value
  	 * looking to match the name.
  	 */
-	cbp = NULL;
-	for (lep = &leaf->ents[index], dbp = NULL, curdb = -1;
+	for (lep = &leaf->ents[index], dbp = NULL, curdb = -1, cidb = -1;
  				index < be16_to_cpu(leaf->hdr.count) &&
  				be32_to_cpu(lep->hashval) == args->hashval;
  				lep++, index++) {
@@ -1377,7 +1376,7 @@ xfs_dir2_leaf_lookup_int(
  		 * need to pitch the old one and read the new one.
  		 */
  		if (newdb != curdb) {
-			if (dbp != cbp)
+			if (dbp)
  				xfs_da_brelse(tp, dbp);
  			error = xfs_da_read_buf(tp, dp,
  						xfs_dir2_db_to_da(mp, newdb),
@@ -1403,35 +1402,39 @@ xfs_dir2_leaf_lookup_int(
  		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
  			args->cmpresult = cmp;
  			*indexp = index;
-			/*
-			 * case exact match: release the stored CI buffer if it
-			 * exists and return the current buffer.
-			 */
+			/* case exact match: return the current buffer. */
  			if (cmp == XFS_CMP_EXACT) {
-				if (cbp && cbp != dbp)
-					xfs_da_brelse(tp, cbp);
  				*dbpp = dbp;
  				return 0;
  			}
-			cbp = dbp;
+			cidb = curdb;
  		}
  	}
  	ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
  	/*
-	 * Here, we can only be doing a lookup (not a rename or replace).
-	 * If a case-insensitive match was found earlier, release the current
-	 * buffer and return the stored CI matching buffer.
+	 * Here, we can only be doing a lookup (not a rename or remove).
+	 * If a case-insensitive match was found earlier, re-read the
+	 * appropriate data block if required and return it.
  	 */
  	if (args->cmpresult == XFS_CMP_CASE) {
-		if (cbp != dbp)
+		ASSERT(cidb != -1);
+		if (cidb != curdb) {
  			xfs_da_brelse(tp, dbp);
-		*dbpp = cbp;
+			error = xfs_da_read_buf(tp, dp,
+						xfs_dir2_db_to_da(mp, cidb),
+						-1, &dbp, XFS_DATA_FORK);
+			if (error) {
+				xfs_da_brelse(tp, lbp);
+				return error;
+			}
+		}
+		*dbpp = dbp;
  		return 0;
  	}
  	/*
  	 * No match found, return ENOENT.
  	 */
-	ASSERT(cbp == NULL);
+	ASSERT(cidb == -1);
  	if (dbp)
  		xfs_da_brelse(tp, dbp);
  	xfs_da_brelse(tp, lbp);
