Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45664 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:41:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fbX3100879
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:37 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8jtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:37 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2fbq9008373
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:37 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3I2fbpY024565
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:41:37 GMT
Subject: [PATCH 7/9] xfs: make xfs_bmapi_remapi work with attribute forks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:41:35 -0700
Message-ID: <152401929590.11792.1122266579457634894.stgit@magnolia>
In-Reply-To: <152401924595.11792.16954598133403059881.stgit@magnolia>
References: <152401924595.11792.16954598133403059881.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new flags argument to xfs_bmapi_remapi so that we can pass BMAPI
flags into the function.  This enables us to pass in BMAPI_ATTRFORK so
that we can remap things into the attribute fork.  Eventually the
online repair code will use this to rebuild attribute forks, so make it
non-static.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   28 ++++++++++++++++------------
 fs/xfs/libxfs/xfs_bmap.h |    4 ++++
 2 files changed, 20 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ee07c2d..4365cec 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4512,30 +4512,34 @@ xfs_bmapi_write(
 	return error;
 }
 
-static int
+int
 xfs_bmapi_remap(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		bno,
 	xfs_filblks_t		len,
 	xfs_fsblock_t		startblock,
-	struct xfs_defer_ops	*dfops)
+	struct xfs_defer_ops	*dfops,
+	int			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp;
 	struct xfs_btree_cur	*cur = NULL;
 	xfs_fsblock_t		firstblock = NULLFSBLOCK;
 	struct xfs_bmbt_irec	got;
 	struct xfs_iext_cursor	icur;
+	int			whichfork = xfs_bmapi_whichfork(flags);
 	int			logflags = 0, error;
 
+	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
 	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK)));
 
 	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
+	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
 	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_remap", XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
@@ -4545,7 +4549,7 @@ xfs_bmapi_remap(
 		return -EIO;
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		error = xfs_iread_extents(tp, ip, whichfork);
 		if (error)
 			return error;
 	}
@@ -4560,7 +4564,7 @@ xfs_bmapi_remap(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (ifp->if_flags & XFS_IFBROOT) {
-		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
+		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = firstblock;
 		cur->bc_private.b.dfops = dfops;
 		cur->bc_private.b.flags = 0;
@@ -4571,16 +4575,16 @@ xfs_bmapi_remap(
 	got.br_blockcount = len;
 	got.br_state = XFS_EXT_NORM;
 
-	error = xfs_bmap_add_extent_hole_real(tp, ip, XFS_DATA_FORK, &icur,
-			&cur, &got, &firstblock, dfops, &logflags, 0);
+	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
+			&cur, &got, &firstblock, dfops, &logflags, flags);
 	if (error)
 		goto error0;
 
-	if (xfs_bmap_wants_extents(ip, XFS_DATA_FORK)) {
+	if (xfs_bmap_wants_extents(ip, whichfork)) {
 		int		tmp_logflags = 0;
 
 		error = xfs_bmap_btree_to_extents(tp, ip, cur,
-			&tmp_logflags, XFS_DATA_FORK);
+			&tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 	}
 
@@ -6151,7 +6155,7 @@ xfs_bmap_finish_one(
 	switch (type) {
 	case XFS_BMAP_MAP:
 		error = xfs_bmapi_remap(tp, ip, startoff, *blockcount,
-				startblock, dfops);
+				startblock, dfops, 0);
 		*blockcount = 0;
 		break;
 	case XFS_BMAP_UNMAP:
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 5c9675a..25dd76f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -281,4 +281,8 @@ static inline int xfs_bmap_fork_to_state(int whichfork)
 xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *irec);
 
+int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
+		struct xfs_defer_ops *dfops, int flags);
+
 #endif	/* __XFS_BMAP_H__ */

