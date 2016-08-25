Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 48CE67DC2
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:35:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0CE6B8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:35:46 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id sJRI7qYJ1fANIKo7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:35:44 -0700 (PDT)
Subject: [PATCH 34/71] xfs: support bmapping delalloc extents in the CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:35:40 -0700
Message-ID: <147216814006.867.6404376654574855233.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

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
index f745d7e..6f2a080 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2760,6 +2760,7 @@ done:
 STATIC void
 xfs_bmap_add_extent_hole_delay(
 	xfs_inode_t		*ip,	/* incore inode pointer */
+	int			whichfork,
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_bmbt_irec_t		*new)	/* new data to add to file extents */
 {
@@ -2771,8 +2772,10 @@ xfs_bmap_add_extent_hole_delay(
 	int			state;  /* state bits, accessed thru macros */
 	xfs_filblks_t		temp=0;	/* temp for indirect calculations */
 
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	ifp = XFS_IFORK_PTR(ip, whichfork);
 	state = 0;
+	if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
 	ASSERT(isnullstartblock(new->br_startblock));
 
 	/*
@@ -2790,7 +2793,7 @@ xfs_bmap_add_extent_hole_delay(
 	 * Check and set flags if the current (right) segment exists.
 	 * If it doesn't exist, we're converting the hole at end-of-file.
 	 */
-	if (*idx < ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
+	if (*idx < ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)) {
 		state |= BMAP_RIGHT_VALID;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &right);
 
@@ -4141,6 +4144,7 @@ xfs_bmapi_read(
 STATIC int
 xfs_bmapi_reserve_delalloc(
 	struct xfs_inode	*ip,
+	int			whichfork,
 	xfs_fileoff_t		aoff,
 	xfs_filblks_t		len,
 	struct xfs_bmbt_irec	*got,
@@ -4149,7 +4153,7 @@ xfs_bmapi_reserve_delalloc(
 	int			eof)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
 	char			rt = XFS_IS_REALTIME_INODE(ip);
@@ -4208,7 +4212,7 @@ xfs_bmapi_reserve_delalloc(
 	got->br_startblock = nullstartblock(indlen);
 	got->br_blockcount = alen;
 	got->br_state = XFS_EXT_NORM;
-	xfs_bmap_add_extent_hole_delay(ip, lastx, got);
+	xfs_bmap_add_extent_hole_delay(ip, whichfork, lastx, got);
 
 	/*
 	 * Update our extent pointer, given that xfs_bmap_add_extent_hole_delay
@@ -4240,6 +4244,7 @@ out_unreserve_quota:
 int
 xfs_bmapi_delay(
 	struct xfs_inode	*ip,	/* incore inode */
+	int			whichfork, /* data or cow fork? */
 	xfs_fileoff_t		bno,	/* starting file offs. mapped */
 	xfs_filblks_t		len,	/* length to map in file */
 	struct xfs_bmbt_irec	*mval,	/* output: map values */
@@ -4247,7 +4252,7 @@ xfs_bmapi_delay(
 	int			flags)	/* XFS_BMAPI_... */
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_bmbt_irec	got;	/* current file extent record */
 	struct xfs_bmbt_irec	prev;	/* previous file extent record */
 	xfs_fileoff_t		obno;	/* old block number (offset) */
@@ -4257,14 +4262,15 @@ xfs_bmapi_delay(
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
@@ -4275,19 +4281,20 @@ xfs_bmapi_delay(
 
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
index e686a1b..9f2c7ec 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -208,7 +208,7 @@ int	xfs_bmap_read_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
-int	xfs_bmapi_delay(struct xfs_inode *ip, xfs_fileoff_t bno,
+int	xfs_bmapi_delay(struct xfs_inode *ip, int whichfork, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2af0dda..1835f3e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -561,12 +561,13 @@ check_writeio:
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
@@ -592,10 +593,14 @@ xfs_iomap_write_delay(
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
@@ -627,8 +632,8 @@ retry:
 	ASSERT(last_fsb > offset_fsb);
 
 	nimaps = XFS_WRITE_IMAPS;
-	error = xfs_bmapi_delay(ip, offset_fsb, last_fsb - offset_fsb,
-				imap, &nimaps, XFS_BMAPI_ENTIRE);
+	error = xfs_bmapi_delay(ip, whichfork, offset_fsb,
+			last_fsb - offset_fsb, imap, &nimaps, XFS_BMAPI_ENTIRE);
 	switch (error) {
 	case 0:
 	case -ENOSPC:
@@ -666,6 +671,31 @@ retry:
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
index fb8aca3..0fd6df3 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -30,6 +30,8 @@ int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
 int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
 			struct xfs_bmbt_irec *);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
+int xfs_iomap_cow_delay(struct xfs_inode *, xfs_off_t, size_t,
+			struct xfs_bmbt_irec *);
 
 void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
 		struct xfs_bmbt_irec *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
