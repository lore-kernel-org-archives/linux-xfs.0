Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17193 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932181AbcI1C4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:56:47 -0400
Subject: [PATCH 29/63] xfs: support bmapping delalloc extents in the CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:56:43 -0700
Message-ID: <147503140356.30303.12828947594015143895.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Allow the creation of delayed allocation extents in the CoW fork.  In
a subsequent patch we'll wire up iomap_begin to actually do this via
reflink helper functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   12 ++++++++----
 fs/xfs/libxfs/xfs_bmap.h |    7 ++++---
 fs/xfs/xfs_iomap.c       |    2 +-
 fs/xfs/xfs_trace.h       |    6 +++---
 4 files changed, 16 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3388058..5749618 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2760,6 +2760,7 @@ xfs_bmap_add_extent_unwritten_real(
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
 
@@ -4146,6 +4149,7 @@ xfs_bmapi_read(
 int
 xfs_bmapi_reserve_delalloc(
 	struct xfs_inode	*ip,
+	int			whichfork,
 	xfs_fileoff_t		aoff,
 	xfs_filblks_t		len,
 	struct xfs_bmbt_irec	*got,
@@ -4154,7 +4158,7 @@ xfs_bmapi_reserve_delalloc(
 	int			eof)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
 	char			rt = XFS_IS_REALTIME_INODE(ip);
@@ -4213,7 +4217,7 @@ xfs_bmapi_reserve_delalloc(
 	got->br_startblock = nullstartblock(indlen);
 	got->br_blockcount = alen;
 	got->br_state = XFS_EXT_NORM;
-	xfs_bmap_add_extent_hole_delay(ip, lastx, got);
+	xfs_bmap_add_extent_hole_delay(ip, whichfork, lastx, got);
 
 	/*
 	 * Update our extent pointer, given that xfs_bmap_add_extent_hole_delay
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index adb64fb..75b1a1f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -234,9 +234,10 @@ struct xfs_bmbt_rec_host *
 	xfs_bmap_search_extents(struct xfs_inode *ip, xfs_fileoff_t bno,
 		int fork, int *eofp, xfs_extnum_t *lastxp,
 		struct xfs_bmbt_irec *gotp, struct xfs_bmbt_irec *prevp);
-int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, xfs_fileoff_t aoff,
-		xfs_filblks_t len, struct xfs_bmbt_irec *got,
-		struct xfs_bmbt_irec *prev, xfs_extnum_t *lastx, int eof);
+int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
+		xfs_fileoff_t aoff, xfs_filblks_t len,
+		struct xfs_bmbt_irec *got, struct xfs_bmbt_irec *prev,
+		xfs_extnum_t *lastx, int eof);
 
 /* The XFS_BMAP_EXTENT_* in xfs_log_format.h must match these. */
 enum xfs_bmap_intent_type {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c08253e..59c7beb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -609,7 +609,7 @@ xfs_file_iomap_begin_delay(
 	}
 
 retry:
-	error = xfs_bmapi_reserve_delalloc(ip, offset_fsb,
+	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
 			end_fsb - offset_fsb, &got,
 			&prev, &idx, eof);
 	switch (error) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0ec3fbe..4fdfa82 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3327,16 +3327,17 @@ DEFINE_INODE_ERROR_EVENT(xfs_reflink_dirty_page_error);
 
 /* copy on write */
 DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_alloc);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_found);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
 
 DEFINE_RW_EVENT(xfs_reflink_reserve_cow_range);
-DEFINE_INODE_IREC_EVENT(xfs_reflink_reserve_cow_extent);
 DEFINE_RW_EVENT(xfs_reflink_allocate_cow_range);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_allocate_cow_extent);
 
 DEFINE_INODE_IREC_EVENT(xfs_reflink_bounce_dio_write);
 DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_irec);
-DEFINE_SIMPLE_IO_EVENT(xfs_iomap_cow_delay);
 
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
@@ -3344,7 +3345,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_piece);
 
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_reserve_cow_range_error);
-DEFINE_INODE_ERROR_EVENT(xfs_reflink_reserve_cow_extent_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_allocate_cow_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_cow_error);

