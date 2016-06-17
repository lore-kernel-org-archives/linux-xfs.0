Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 81661830C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:40:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 403638F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:40:53 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id vcTAgRql7uEUq41S (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:40:51 -0700 (PDT)
Subject: [PATCH 094/145] xfs: support bmapping delalloc extents in the CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:40:42 -0700
Message-ID: <146612764201.16048.17050341682992352093.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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

Allow the creation of delayed allocation extents in the CoW fork.
In a subsequent patch we'll wire up write_begin and page_mkwrite to
actually do this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_bmap.c |   29 ++++++++++++++++++-----------
 libxfs/xfs_bmap.h |    2 +-
 2 files changed, 19 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 2ec3385..acb3011 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -2752,6 +2752,7 @@ done:
 STATIC void
 xfs_bmap_add_extent_hole_delay(
 	xfs_inode_t		*ip,	/* incore inode pointer */
+	int			whichfork,
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new)	/* new data to add to file extents */
 {
@@ -2763,8 +2764,10 @@ xfs_bmap_add_extent_hole_delay(
 	int			state;  /* state bits, accessed thru macros */
 	xfs_filblks_t		temp=0;	/* temp for indirect calculations */
 
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	ifp = XFS_IFORK_PTR(ip, whichfork);
 	state = 0;
+	if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
 	ASSERT(isnullstartblock(new->br_startblock));
 
 	/*
@@ -2782,7 +2785,7 @@ xfs_bmap_add_extent_hole_delay(
 	 * Check and set flags if the current (right) segment exists.
 	 * If it doesn't exist, we're converting the hole at end-of-file.
 	 */
-	if (*idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+	if (*idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &right);
 
@@ -4132,6 +4135,7 @@ xfs_bmapi_read(
 STATIC int
 xfs_bmapi_reserve_delalloc(
 	struct xfs_inode	*ip,
+	int			whichfork,
 	xfs_fileoff_t		aoff,
 	xfs_filblks_t		len,
 	struct xfs_bmbt_irec	*got,
@@ -4140,7 +4144,7 @@ xfs_bmapi_reserve_delalloc(
 	int			eof)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
 	char			rt = XFS_IS_REALTIME_INODE(ip);
@@ -4199,7 +4203,7 @@ xfs_bmapi_reserve_delalloc(
 	got->br_startblock = nullstartblock(indlen);
 	got->br_blockcount = alen;
 	got->br_state = XFS_EXT_NORM;
-	xfs_bmap_add_extent_hole_delay(ip, lastx, got);
+	xfs_bmap_add_extent_hole_delay(ip, whichfork, lastx, got);
 
 	/*
 	 * Update our extent pointer, given that xfs_bmap_add_extent_hole_delay
@@ -4231,6 +4235,7 @@ out_unreserve_quota:
 int
 xfs_bmapi_delay(
 	struct xfs_inode	*ip,	/* incore inode */
+	int			whichfork, /* data or cow fork? */
 	xfs_fileoff_t		bno,	/* starting file offs. mapped */
 	xfs_filblks_t		len,	/* length to map in file */
 	struct xfs_bmbt_irec	*mval,	/* output: map values */
@@ -4238,7 +4243,7 @@ xfs_bmapi_delay(
 	int			flags)	/* XFS_BMAPI_... */
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_bmbt_irec	got;	/* current file extent record */
 	struct xfs_bmbt_irec	prev;	/* previous file extent record */
 	xfs_fileoff_t		obno;	/* old block number (offset) */
@@ -4248,14 +4253,15 @@ xfs_bmapi_delay(
 	int			n = 0;	/* current extent index */
 	int			error = 0;
 
+	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK);
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
 	ASSERT(!(flags & ~XFS_BMAPI_ENTIRE));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
+	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
 	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_delay", XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
@@ -4266,19 +4272,20 @@ xfs_bmapi_delay(
 
 	XFS_STATS_INC(mp, xs_blk_mapw);
 
-	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+	if (whichfork == XFS_DATA_FORK && !(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(NULL, ip, whichfork);
 		if (error)
 			return error;
 	}
 
-	xfs_bmap_search_extents(ip, bno, XFS_DATA_FORK, &eof, &lastx, &got, &prev);
+	xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got, &prev);
 	end = bno + len;
 	obno = bno;
 
 	while (bno < end && n < *nmap) {
 		if (eof || got.br_startoff > bno) {
-			error = xfs_bmapi_reserve_delalloc(ip, bno, len, &got,
+			error = xfs_bmapi_reserve_delalloc(ip, whichfork,
+							   bno, len, &got,
 							   &prev, &lastx, eof);
 			if (error) {
 				if (n == 0) {
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index a8ef1c6..d90f88e 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -205,7 +205,7 @@ int	xfs_bmap_read_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
-int	xfs_bmapi_delay(struct xfs_inode *ip, xfs_fileoff_t bno,
+int	xfs_bmapi_delay(struct xfs_inode *ip, int whichfork, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
