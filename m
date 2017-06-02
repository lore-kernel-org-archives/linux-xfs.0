Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29737 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdFBVY7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 17:24:59 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52LOxmb009990
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v52LOwZo009559
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:59 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v52LOus9031049
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:57 GMT
Subject: [PATCH 09/13] xfs: separate function to check if reflink flag needed
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 14:24:55 -0700
Message-ID: <149643869528.23065.5474019120391564972.stgit@birch.djwong.org>
In-Reply-To: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Separate the "clear reflink flag" function into one function that checks
if the flag is needed, and a second function that checks and clears the
flag.  The inode scrub code will want to check the necessity of the flag
without clearing it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   88 ++++++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_reflink.h |    2 +
 2 files changed, 54 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e25c995..133ee02 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1406,57 +1406,73 @@ xfs_reflink_dirty_extents(
 	return error;
 }
 
-/* Clear the inode reflink flag if there are no shared extents. */
+/* Does this inode need the reflink flag? */
 int
-xfs_reflink_clear_inode_flag(
-	struct xfs_inode	*ip,
-	struct xfs_trans	**tpp)
+xfs_reflink_needs_inode_flag(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	bool				*needs_flag)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		fbno;
-	xfs_filblks_t		end;
-	xfs_agnumber_t		agno;
-	xfs_agblock_t		agbno;
-	xfs_extlen_t		aglen;
-	xfs_agblock_t		rbno;
-	xfs_extlen_t		rlen;
-	struct xfs_bmbt_irec	map;
-	int			nmaps;
-	int			error = 0;
-
-	ASSERT(xfs_is_reflink_inode(ip));
+	struct xfs_bmbt_irec		got;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	xfs_extlen_t			aglen;
+	xfs_agblock_t			rbno;
+	xfs_extlen_t			rlen;
+	xfs_extnum_t			idx;
+	bool				found;
+	int				error;
 
-	fbno = 0;
-	end = XFS_B_TO_FSB(mp, i_size_read(VFS_I(ip)));
-	while (end - fbno > 0) {
-		nmaps = 1;
-		/*
-		 * Look for extents in the file.  Skip holes, delalloc, or
-		 * unwritten extents; they can't be reflinked.
-		 */
-		error = xfs_bmapi_read(ip, fbno, end - fbno, &map, &nmaps, 0);
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
 		if (error)
 			return error;
-		if (nmaps == 0)
-			break;
-		if (!xfs_bmap_is_real_extent(&map))
-			goto next;
+	}
 
-		agno = XFS_FSB_TO_AGNO(mp, map.br_startblock);
-		agbno = XFS_FSB_TO_AGBNO(mp, map.br_startblock);
-		aglen = map.br_blockcount;
+	*needs_flag = false;
+	found = xfs_iext_lookup_extent(ip, ifp, 0, &idx, &got);
+	while (found) {
+		if (isnullstartblock(got.br_startblock) ||
+		    got.br_state != XFS_EXT_NORM)
+			goto next;
+		agno = XFS_FSB_TO_AGNO(mp, got.br_startblock);
+		agbno = XFS_FSB_TO_AGBNO(mp, got.br_startblock);
+		aglen = got.br_blockcount;
 
-		error = xfs_reflink_find_shared(mp, *tpp, agno, agbno, aglen,
+		error = xfs_reflink_find_shared(mp, tp, agno, agbno, aglen,
 				&rbno, &rlen, false);
 		if (error)
 			return error;
 		/* Is there still a shared block here? */
-		if (rbno != NULLAGBLOCK)
+		if (rbno != NULLAGBLOCK) {
+			*needs_flag = true;
 			return 0;
+		}
 next:
-		fbno = map.br_startoff + map.br_blockcount;
+		found = xfs_iext_get_extent(ifp, ++idx, &got);
 	}
 
+	return 0;
+}
+
+/* Clear the inode reflink flag if there are no shared extents. */
+int
+xfs_reflink_clear_inode_flag(
+	struct xfs_inode	*ip,
+	struct xfs_trans	**tpp)
+{
+	bool			needs;
+	int			error = 0;
+
+	ASSERT(xfs_is_reflink_inode(ip));
+
+	error = xfs_reflink_needs_inode_flag(*tpp, ip, &needs);
+	if (error || needs)
+		return error;
+
 	/*
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index b8cc5c3..a26d795 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -47,6 +47,8 @@ extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
 extern int xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, u64 len, bool is_dedupe);
+extern int xfs_reflink_needs_inode_flag(struct xfs_trans *tp,
+		struct xfs_inode *ip, bool *needs_flag);
 extern int xfs_reflink_clear_inode_flag(struct xfs_inode *ip,
 		struct xfs_trans **tpp);
 extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,

