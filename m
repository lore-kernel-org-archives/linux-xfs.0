Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6991580D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:05:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5AFE0304059
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:27 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id C8v8VYQDPacZF9b8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:26 -0800 (PST)
Subject: [PATCH 05/53] libxfs: use a convenience variable instead of
	open-coding the fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:05:22 -0800
Message-ID: <20151219090522.14255.54101.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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

Use a convenience variable instead of open-coding the inode fork.
This isn't really needed for now, but will become important when we
add the copy-on-write fork later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 46f8469..aef7cf3 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1714,9 +1714,10 @@ xfs_bmap_add_extent_delay_real(
 	xfs_filblks_t		temp2=0;/* value for da_new calculations */
 	int			tmp_rval;	/* partial logging flags */
 	struct xfs_mount	*mp;
+	int			whichfork = XFS_DATA_FORK;
 
 	mp  = bma->tp ? bma->tp->t_mountp : NULL;
-	ifp = XFS_IFORK_PTR(bma->ip, XFS_DATA_FORK);
+	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 
 	ASSERT(bma->idx >= 0);
 	ASSERT(bma->idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
@@ -1775,7 +1776,7 @@ xfs_bmap_add_extent_delay_real(
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (bma->idx < bma->ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
+	if (bma->idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx + 1), &RIGHT);
 
@@ -2006,10 +2007,10 @@ xfs_bmap_add_extent_delay_real(
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 
-		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
+		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
 					bma->firstblock, bma->flist,
-					&bma->cur, 1, &tmp_rval, XFS_DATA_FORK);
+					&bma->cur, 1, &tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
@@ -2090,10 +2091,10 @@ xfs_bmap_add_extent_delay_real(
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 
-		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
+		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
 				bma->firstblock, bma->flist, &bma->cur, 1,
-				&tmp_rval, XFS_DATA_FORK);
+				&tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
@@ -2159,10 +2160,10 @@ xfs_bmap_add_extent_delay_real(
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
 
-		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
+		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
 					bma->firstblock, bma->flist, &bma->cur,
-					1, &tmp_rval, XFS_DATA_FORK);
+					1, &tmp_rval, whichfork);
 			rval |= tmp_rval;
 			if (error)
 				goto done;
@@ -2205,13 +2206,13 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* convert to a btree if necessary */
-	if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
+	if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
 		int	tmp_logflags;	/* partial log flag return val */
 
 		ASSERT(bma->cur == NULL);
 		error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
 				bma->firstblock, bma->flist, &bma->cur,
-				da_old > 0, &tmp_logflags, XFS_DATA_FORK);
+				da_old > 0, &tmp_logflags, whichfork);
 		bma->logflags |= tmp_logflags;
 		if (error)
 			goto done;
@@ -2232,7 +2233,7 @@ xfs_bmap_add_extent_delay_real(
 	if (bma->cur)
 		bma->cur->bc_private.b.allocated = 0;
 
-	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, XFS_DATA_FORK);
+	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
 done:
 	bma->logflags |= rval;
 	return error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
