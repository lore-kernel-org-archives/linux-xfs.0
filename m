Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24784 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751436AbdFGB0w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2017 21:26:52 -0400
Date: Tue, 6 Jun 2017 18:26:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 09/13] xfs: separate function to check if reflink flag
 needed
Message-ID: <20170607012645.GC4530@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643869528.23065.5474019120391564972.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149643869528.23065.5474019120391564972.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

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
index e25c995..ab2270a 100644
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
+xfs_reflink_inode_has_shared_extents(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	bool				*has_shared)
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
+	*has_shared = false;
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
+			*has_shared = true;
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
+	bool			needs_flag;
+	int			error = 0;
+
+	ASSERT(xfs_is_reflink_inode(ip));
+
+	error = xfs_reflink_inode_has_shared_extents(*tpp, ip, &needs_flag);
+	if (error || needs_flag)
+		return error;
+
 	/*
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index b8cc5c3..701487b 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -47,6 +47,8 @@ extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
 extern int xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, u64 len, bool is_dedupe);
+extern int xfs_reflink_inode_has_shared_extents(struct xfs_trans *tp,
+		struct xfs_inode *ip, bool *has_shared);
 extern int xfs_reflink_clear_inode_flag(struct xfs_inode *ip,
 		struct xfs_trans **tpp);
 extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
