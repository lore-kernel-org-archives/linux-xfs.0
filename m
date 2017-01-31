Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46771 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752915AbdAaAXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2017 19:23:50 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0V0Nn3n011193
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v0V0Nm0S005431
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:49 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v0V0Nmjd027408
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2017 00:23:48 GMT
Subject: [PATCH 6/7] xfs: allow unwritten extents in the CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 30 Jan 2017 16:23:47 -0800
Message-ID: <148582222694.12293.16267279056432234212.stgit@birch.djwong.org>
In-Reply-To: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In the data fork, we only allow extents to perform the following state
transitions:

delay -> real <-> unwritten

There's no way to move directly from a delalloc reservation to an
/unwritten/ allocated extent.  However, for the CoW fork we want to be
able to do the following to each extent:

delalloc -> unwritten -> written -> remapped to data fork

This will help us to avoid a race in the speculative CoW preallocation
code between a first thread that is allocating a CoW extent and a second
thread that is remapping part of a file after a write.  In order to do
this, however, we need two things: first, we have to be able to
transition from da to unwritten, and second the function that converts
between real and unwritten has to be made aware of the cow fork.  Do
both of those things.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   68 ++++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 443cb10..7c14c11 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1862,6 +1862,7 @@ xfs_bmap_add_extent_delay_real(
 		 */
 		trace_xfs_bmap_pre_update(bma->ip, bma->idx, state, _THIS_IP_);
 		xfs_bmbt_set_startblock(ep, new->br_startblock);
+		xfs_bmbt_set_state(ep, new->br_state);
 		trace_xfs_bmap_post_update(bma->ip, bma->idx, state, _THIS_IP_);
 
 		(*nextents)++;
@@ -2200,6 +2201,7 @@ STATIC int				/* error */
 xfs_bmap_add_extent_unwritten_real(
 	struct xfs_trans	*tp,
 	xfs_inode_t		*ip,	/* incore inode pointer */
+	int			whichfork,
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
@@ -2224,7 +2226,9 @@ xfs_bmap_add_extent_unwritten_real(
 	*logflagsp = 0;
 
 	cur = *curp;
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
 
 	ASSERT(*idx >= 0);
 	ASSERT(*idx <= xfs_iext_count(ifp));
@@ -2283,7 +2287,7 @@ xfs_bmap_add_extent_unwritten_real(
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (*idx < xfs_iext_count(&ip->i_df) - 1) {
+	if (*idx < xfs_iext_count(ifp) - 1) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx + 1), &RIGHT);
 		if (isnullstartblock(RIGHT.br_startblock))
@@ -2323,7 +2327,8 @@ xfs_bmap_add_extent_unwritten_real(
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		xfs_iext_remove(ip, *idx + 1, 2, state);
-		ip->i_d.di_nextents -= 2;
+		XFS_IFORK_NEXT_SET(ip, whichfork,
+				XFS_IFORK_NEXTENTS(ip, whichfork) - 2);
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2366,7 +2371,8 @@ xfs_bmap_add_extent_unwritten_real(
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		xfs_iext_remove(ip, *idx + 1, 1, state);
-		ip->i_d.di_nextents--;
+		XFS_IFORK_NEXT_SET(ip, whichfork,
+				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2401,7 +2407,8 @@ xfs_bmap_add_extent_unwritten_real(
 		xfs_bmbt_set_state(ep, newext);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		xfs_iext_remove(ip, *idx + 1, 1, state);
-		ip->i_d.di_nextents--;
+		XFS_IFORK_NEXT_SET(ip, whichfork,
+				XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2513,7 +2520,8 @@ xfs_bmap_add_extent_unwritten_real(
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		xfs_iext_insert(ip, *idx, 1, new, state);
-		ip->i_d.di_nextents++;
+		XFS_IFORK_NEXT_SET(ip, whichfork,
+				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2591,7 +2599,8 @@ xfs_bmap_add_extent_unwritten_real(
 		++*idx;
 		xfs_iext_insert(ip, *idx, 1, new, state);
 
-		ip->i_d.di_nextents++;
+		XFS_IFORK_NEXT_SET(ip, whichfork,
+				XFS_IFORK_NEXTENTS(ip, whichfork) + 1);
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2639,7 +2648,8 @@ xfs_bmap_add_extent_unwritten_real(
 		++*idx;
 		xfs_iext_insert(ip, *idx, 2, &r[0], state);
 
-		ip->i_d.di_nextents += 2;
+		XFS_IFORK_NEXT_SET(ip, whichfork,
+				XFS_IFORK_NEXTENTS(ip, whichfork) + 2);
 		if (cur == NULL)
 			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
 		else {
@@ -2693,17 +2703,17 @@ xfs_bmap_add_extent_unwritten_real(
 	}
 
 	/* update reverse mappings */
-	error = xfs_rmap_convert_extent(mp, dfops, ip, XFS_DATA_FORK, new);
+	error = xfs_rmap_convert_extent(mp, dfops, ip, whichfork, new);
 	if (error)
 		goto done;
 
 	/* convert to a btree if necessary */
-	if (xfs_bmap_needs_btree(ip, XFS_DATA_FORK)) {
+	if (xfs_bmap_needs_btree(ip, whichfork)) {
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(cur == NULL);
 		error = xfs_bmap_extents_to_btree(tp, ip, first, dfops, &cur,
-				0, &tmp_logflags, XFS_DATA_FORK);
+				0, &tmp_logflags, whichfork);
 		*logflagsp |= tmp_logflags;
 		if (error)
 			goto done;
@@ -2715,7 +2725,7 @@ xfs_bmap_add_extent_unwritten_real(
 		*curp = cur;
 	}
 
-	xfs_bmap_check_leaf_extents(*curp, ip, XFS_DATA_FORK);
+	xfs_bmap_check_leaf_extents(*curp, ip, whichfork);
 done:
 	*logflagsp |= rval;
 	return error;
@@ -4366,10 +4376,16 @@ xfs_bmapi_allocate(
 	bma->got.br_state = XFS_EXT_NORM;
 
 	/*
-	 * A wasdelay extent has been initialized, so shouldn't be flagged
-	 * as unwritten.
+	 * In the data fork, a wasdelay extent has been initialized, so
+	 * shouldn't be flagged as unwritten.
+	 *
+	 * For the cow fork, however, we convert delalloc reservations
+	 * (extents allocated for speculative preallocation) to
+	 * allocated unwritten extents, and only convert the unwritten
+	 * extents to real extents when we're about to write the data.
 	 */
-	if (!bma->wasdel && (bma->flags & XFS_BMAPI_PREALLOC) &&
+	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
+	    (bma->flags & XFS_BMAPI_PREALLOC) &&
 	    xfs_sb_version_hasextflgbit(&mp->m_sb))
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
@@ -4420,8 +4436,6 @@ xfs_bmapi_convert_unwritten(
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT))
 		return 0;
 
-	ASSERT(whichfork != XFS_COW_FORK);
-
 	/*
 	 * Modify (by adding) the state flag, if writing.
 	 */
@@ -4446,8 +4460,8 @@ xfs_bmapi_convert_unwritten(
 			return error;
 	}
 
-	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, &bma->idx,
-			&bma->cur, mval, bma->firstblock, bma->dfops,
+	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, whichfork,
+			&bma->idx, &bma->cur, mval, bma->firstblock, bma->dfops,
 			&tmp_logflags);
 	/*
 	 * Log the inode core unconditionally in the unwritten extent conversion
@@ -4538,8 +4552,6 @@ xfs_bmapi_write(
 	ASSERT(!(flags & XFS_BMAPI_REMAP) || whichfork == XFS_DATA_FORK);
 	ASSERT(!(flags & XFS_BMAPI_PREALLOC) || !(flags & XFS_BMAPI_REMAP));
 	ASSERT(!(flags & XFS_BMAPI_CONVERT) || !(flags & XFS_BMAPI_REMAP));
-	ASSERT(!(flags & XFS_BMAPI_PREALLOC) || whichfork != XFS_COW_FORK);
-	ASSERT(!(flags & XFS_BMAPI_CONVERT) || whichfork != XFS_COW_FORK);
 
 	/* zeroing is for currently only for data extents, not metadata */
 	ASSERT((flags & (XFS_BMAPI_METADATA | XFS_BMAPI_ZERO)) !=
@@ -5554,8 +5566,8 @@ __xfs_bunmapi(
 			}
 			del.br_state = XFS_EXT_UNWRITTEN;
 			error = xfs_bmap_add_extent_unwritten_real(tp, ip,
-					&lastx, &cur, &del, firstblock, dfops,
-					&logflags);
+					whichfork, &lastx, &cur, &del,
+					firstblock, dfops, &logflags);
 			if (error)
 				goto error0;
 			goto nodelete;
@@ -5608,8 +5620,9 @@ __xfs_bunmapi(
 				prev.br_state = XFS_EXT_UNWRITTEN;
 				lastx--;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
-						ip, &lastx, &cur, &prev,
-						firstblock, dfops, &logflags);
+						ip, whichfork, &lastx, &cur,
+						&prev, firstblock, dfops,
+						&logflags);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5617,8 +5630,9 @@ __xfs_bunmapi(
 				ASSERT(del.br_state == XFS_EXT_NORM);
 				del.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
-						ip, &lastx, &cur, &del,
-						firstblock, dfops, &logflags);
+						ip, whichfork, &lastx, &cur,
+						&del, firstblock, dfops,
+						&logflags);
 				if (error)
 					goto error0;
 				goto nodelete;

