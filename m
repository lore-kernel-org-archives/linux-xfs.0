Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 83CBE7F9A
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:56:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 75C0C8F8052
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:58 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 0IuPr6aKcphDF21n (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:56 -0800 (PST)
Subject: [PATCH 04/76] libxfs: use a convenience variable instead of
	open-coding the fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:56:49 -0800
Message-ID: <20151219085648.12713.21030.stgit@birch.djwong.org>
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

Use a convenience variable instead of open-coding the inode fork.
This isn't really needed for now, but will become important when we
add the copy-on-write fork later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2386377..817c994 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1708,9 +1708,10 @@ xfs_bmap_add_extent_delay_real(
 	xfs_filblks_t		temp2=0;/* value for da_new calculations */
 	int			tmp_rval;	/* partial logging flags */
 	struct xfs_mount	*mp;
+	int			whichfork = XFS_DATA_FORK;
 
 	mp  = bma->tp ? bma->tp->t_mountp : NULL;
-	ifp = XFS_IFORK_PTR(bma->ip, XFS_DATA_FORK);
+	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 
 	ASSERT(bma->idx >= 0);
 	ASSERT(bma->idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
@@ -1769,7 +1770,7 @@ xfs_bmap_add_extent_delay_real(
 	 * Don't set contiguous if the combined extent would be too large.
 	 * Also check for all-three-contiguous being too large.
 	 */
-	if (bma->idx < bma->ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
+	if (bma->idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t) - 1) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, bma->idx + 1), &RIGHT);
 
@@ -2000,10 +2001,10 @@ xfs_bmap_add_extent_delay_real(
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
@@ -2084,10 +2085,10 @@ xfs_bmap_add_extent_delay_real(
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
@@ -2153,10 +2154,10 @@ xfs_bmap_add_extent_delay_real(
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
@@ -2199,13 +2200,13 @@ xfs_bmap_add_extent_delay_real(
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
@@ -2226,7 +2227,7 @@ xfs_bmap_add_extent_delay_real(
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
