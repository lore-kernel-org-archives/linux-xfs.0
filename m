Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5629F80DC
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:02:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 028C3AC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:34 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ZCyASgGQZEBQpxC0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:32 -0800 (PST)
Subject: [PATCH 54/76] xfs: support bmapping delalloc extents in the CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:02:28 -0800
Message-ID: <20151219090228.12713.52842.stgit@birch.djwong.org>
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

Allow the creation of delayed allocation extents in the CoW fork.
In a subsequent patch we'll wire up write_begin and page_mkwrite to
actually do this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   29 +++++++++++++++++-----------
 fs/xfs/libxfs/xfs_bmap.h |    2 +-
 fs/xfs/xfs_iomap.c       |   48 +++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_iomap.h       |    2 ++
 4 files changed, 60 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 53a8ebc..9737353 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2878,6 +2878,7 @@ done:
 STATIC void
 xfs_bmap_add_extent_hole_delay(
 	xfs_inode_t		*ip,	/* incore inode pointer */
+	int			whichfork,
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new)	/* new data to add to file extents */
 {
@@ -2889,8 +2890,10 @@ xfs_bmap_add_extent_hole_delay(
 	int			state;  /* state bits, accessed thru macros */
 	xfs_filblks_t		temp=0;	/* temp for indirect calculations */
 
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	ifp = XFS_IFORK_PTR(ip, whichfork);
 	state = 0;
+	if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
 	ASSERT(isnullstartblock(new->br_startblock));
 
 	/*
@@ -2908,7 +2911,7 @@ xfs_bmap_add_extent_hole_delay(
 	 * Check and set flags if the current (right) segment exists.
 	 * If it doesn't exist, we're converting the hole at end-of-file.
 	 */
-	if (*idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+	if (*idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &right);
 
@@ -4260,6 +4263,7 @@ xfs_bmapi_read(
 STATIC int
 xfs_bmapi_reserve_delalloc(
 	struct xfs_inode	*ip,
+	int			whichfork,
 	xfs_fileoff_t		aoff,
 	xfs_filblks_t		len,
 	struct xfs_bmbt_irec	*got,
@@ -4268,7 +4272,7 @@ xfs_bmapi_reserve_delalloc(
 	int			eof)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
 	char			rt = XFS_IS_REALTIME_INODE(ip);
@@ -4327,7 +4331,7 @@ xfs_bmapi_reserve_delalloc(
 	got->br_startblock = nullstartblock(indlen);
 	got->br_blockcount = alen;
 	got->br_state = XFS_EXT_NORM;
-	xfs_bmap_add_extent_hole_delay(ip, lastx, got);
+	xfs_bmap_add_extent_hole_delay(ip, whichfork, lastx, got);
 
 	/*
 	 * Update our extent pointer, given that xfs_bmap_add_extent_hole_delay
@@ -4359,6 +4363,7 @@ out_unreserve_quota:
 int
 xfs_bmapi_delay(
 	struct xfs_inode	*ip,	/* incore inode */
+	int			whichfork, /* data or cow fork? */
 	xfs_fileoff_t		bno,	/* starting file offs. mapped */
 	xfs_filblks_t		len,	/* length to map in file */
 	struct xfs_bmbt_irec	*mval,	/* output: map values */
@@ -4366,7 +4371,7 @@ xfs_bmapi_delay(
 	int			flags)	/* XFS_BMAPI_... */
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_bmbt_irec	got;	/* current file extent record */
 	struct xfs_bmbt_irec	prev;	/* previous file extent record */
 	xfs_fileoff_t		obno;	/* old block number (offset) */
@@ -4376,14 +4381,15 @@ xfs_bmapi_delay(
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
@@ -4394,19 +4400,20 @@ xfs_bmapi_delay(
 
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
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 2c18ed8a..fb68ac4 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -245,7 +245,7 @@ int	xfs_bmap_read_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
-int	xfs_bmapi_delay(struct xfs_inode *ip, xfs_fileoff_t bno,
+int	xfs_bmapi_delay(struct xfs_inode *ip, int whichfork, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 96dcaeb..53e027c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -565,12 +565,13 @@ check_writeio:
 	return alloc_blocks;
 }
 
-int
-xfs_iomap_write_delay(
+STATIC int
+__xfs_iomap_write_delay(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	size_t		count,
-	xfs_bmbt_irec_t *ret_imap)
+	xfs_bmbt_irec_t *ret_imap,
+	int		whichfork)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
@@ -596,10 +597,14 @@ xfs_iomap_write_delay(
 	extsz = xfs_get_extsz_hint(ip);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
-	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
-				imap, XFS_WRITE_IMAPS, &prealloc);
-	if (error)
-		return error;
+	if (whichfork == XFS_DATA_FORK) {
+		error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
+					imap, XFS_WRITE_IMAPS, &prealloc);
+		if (error)
+			return error;
+	} else {
+		prealloc = 0;
+	}
 
 retry:
 	if (prealloc) {
@@ -631,8 +636,8 @@ retry:
 	ASSERT(last_fsb > offset_fsb);
 
 	nimaps = XFS_WRITE_IMAPS;
-	error = xfs_bmapi_delay(ip, offset_fsb, last_fsb - offset_fsb,
-				imap, &nimaps, XFS_BMAPI_ENTIRE);
+	error = xfs_bmapi_delay(ip, whichfork, offset_fsb,
+			last_fsb - offset_fsb, imap, &nimaps, XFS_BMAPI_ENTIRE);
 	switch (error) {
 	case 0:
 	case -ENOSPC:
@@ -670,6 +675,31 @@ retry:
 	return 0;
 }
 
+int
+xfs_iomap_write_delay(
+	xfs_inode_t	*ip,
+	xfs_off_t	offset,
+	size_t		count,
+	xfs_bmbt_irec_t *ret_imap)
+{
+	return __xfs_iomap_write_delay(ip, offset, count, ret_imap,
+				       XFS_DATA_FORK);
+}
+
+int
+xfs_iomap_cow_delay(
+	xfs_inode_t	*ip,
+	xfs_off_t	offset,
+	size_t		count,
+	xfs_bmbt_irec_t *ret_imap)
+{
+	ASSERT(XFS_IFORK_PTR(ip, XFS_COW_FORK) != NULL);
+	trace_xfs_iomap_cow_delay(ip, offset, count);
+
+	return __xfs_iomap_write_delay(ip, offset, count, ret_imap,
+				       XFS_COW_FORK);
+}
+
 /*
  * Pass in a delayed allocate extent, convert it to real extents;
  * return to the caller the extent we create which maps on top of
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 8688e66..f6a9adf 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -28,5 +28,7 @@ int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
 int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
 			struct xfs_bmbt_irec *);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
+int xfs_iomap_cow_delay(struct xfs_inode *, xfs_off_t, size_t,
+			struct xfs_bmbt_irec *);
 
 #endif /* __XFS_IOMAP_H__*/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
