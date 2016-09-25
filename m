Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39490 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757484AbcIYTaE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Sep 2016 15:30:04 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: fix xfs_reflink_allocate_cow_range
Date: Sun, 25 Sep 2016 12:30:02 -0700
Message-Id: <1474831802-25530-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

The current version of xfs_reflink_allocate_cow_range may stumble over
invalid entries in the extent array given that it drops the ilock but
still expects the index to be stable.  Simple fixing it to a new lookup
for every iteration still isn't correct given that xfs_bmapi_allocate
will trigger a BUG_ON() if hitting a hole, and there is nothing
preventing a xfs_bunmapi_cow call removing extents once we dropped the
ilock either.

The right long term implementation would be to not do a detour through
a delayed allocation for direct I/O and just got straight to and on-disk
allocation.  Given how late it is in the merge window this patch instead
duplicates the inner loop of xfs_bmapi_allocate into a helper for
xfs_reflink_allocate_cow_range so that it can be done under the same
ilock criticical section as our COW fork delayed allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c    |   4 --
 fs/xfs/xfs_reflink.c | 134 +++++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_reflink.h |   4 +-
 fs/xfs/xfs_trace.h   |   1 -
 4 files changed, 90 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aee0c4c..349f328 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -675,10 +675,6 @@ xfs_file_dio_aio_write(
 
 	/* If this is a block-aligned directio CoW, remap immediately. */
 	if (xfs_is_reflink_inode(ip) && !unaligned_io) {
-		ret = xfs_reflink_reserve_cow_range(ip, iocb->ki_pos, count);
-		if (ret)
-			goto out;
-
 		ret = xfs_reflink_allocate_cow_range(ip, iocb->ki_pos, count);
 		if (ret)
 			goto out;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 09e0e27..c18692c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -253,7 +253,8 @@ static int
 __xfs_reflink_reserve_cow(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		*offset_fsb,
-	xfs_fileoff_t		end_fsb)
+	xfs_fileoff_t		end_fsb,
+	bool			*skipped)
 {
 	struct xfs_bmbt_irec	got, prev, imap;
 	xfs_fileoff_t		orig_end_fsb;
@@ -287,8 +288,10 @@ __xfs_reflink_reserve_cow(
 	end_fsb = orig_end_fsb = imap.br_startoff + imap.br_blockcount;
 
 	/* Not shared?  Just report the (potentially capped) extent. */
-	if (!shared)
+	if (!shared) {
+		*skipped = true;
 		goto done;
+	}
 
 	/*
 	 * Fork all the shared blocks from our write offset until the end of
@@ -337,6 +340,7 @@ xfs_reflink_reserve_cow_range(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb, end_fsb;
+	bool			skipped = false;
 	int			error;
 
 	trace_xfs_reflink_reserve_cow_range(ip, offset, count);
@@ -346,7 +350,8 @@ xfs_reflink_reserve_cow_range(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	while (offset_fsb < end_fsb) {
-		error = __xfs_reflink_reserve_cow(ip, &offset_fsb, end_fsb);
+		error = __xfs_reflink_reserve_cow(ip, &offset_fsb, end_fsb,
+				&skipped);
 		if (error) {
 			trace_xfs_reflink_reserve_cow_range_error(ip, error,
 				_RET_IP_);
@@ -358,63 +363,100 @@ xfs_reflink_reserve_cow_range(
 	return error;
 }
 
-/*
- * Allocate blocks to all CoW reservations within a byte range of a file.
- */
-int
-xfs_reflink_allocate_cow_range(
+static int
+__xfs_reflink_allocate_cow(
 	struct xfs_inode	*ip,
-	xfs_off_t		pos,
-	xfs_off_t		len)
+	xfs_fileoff_t		*offset_fsb,
+	xfs_fileoff_t		end_fsb)
 {
-	struct xfs_ifork	*ifp;
-	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_bmbt_irec	imap;
-	int			error = 0;
-	xfs_fileoff_t		start_lblk;
-	xfs_fileoff_t		end_lblk;
-	xfs_extnum_t		idx;
+	struct xfs_defer_ops	dfops;
+	struct xfs_trans	*tp;
+	xfs_fsblock_t		first_block;
+	xfs_fileoff_t		next_fsb;
+	int			nimaps = 1, error;
+	bool			skipped = false;
 
-	if (!xfs_is_reflink_inode(ip))
-		return 0;
+	xfs_defer_init(&dfops, &first_block);
 
-	trace_xfs_reflink_allocate_cow_range(ip, len, pos);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
+			XFS_TRANS_RESERVE, &tp);
+	if (error)
+		return error;
 
-	start_lblk = XFS_B_TO_FSBT(ip->i_mount, pos);
-	end_lblk = XFS_B_TO_FSB(ip->i_mount, pos + len);
-	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	gotp = xfs_iext_bno_to_ext(ifp, start_lblk, &idx);
-	while (gotp) {
-		xfs_bmbt_get_all(gotp, &imap);
+	next_fsb = *offset_fsb;
+	error = __xfs_reflink_reserve_cow(ip, &next_fsb, end_fsb, &skipped);
+	if (error)
+		goto out_trans_cancel;
 
-		if (imap.br_startoff >= end_lblk)
-			break;
-		if (!isnullstartblock(imap.br_startblock))
-			goto advloop;
-		xfs_trim_extent(&imap, start_lblk, end_lblk - start_lblk);
-		trace_xfs_reflink_allocate_cow_extent(ip, &imap);
-
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		error = xfs_iomap_write_allocate(ip, XFS_COW_FORK,
-				XFS_FSB_TO_B(ip->i_mount, imap.br_startoff +
-						imap.br_blockcount - 1), &imap);
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		if (error)
-			break;
-advloop:
-		/* Roll on... */
-		idx++;
-		if (idx >= ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
-			break;
-		gotp = xfs_iext_get_ext(ifp, idx);
+	if (skipped) {
+		*offset_fsb = next_fsb;
+		goto out_trans_cancel;
 	}
 
+	xfs_trans_ijoin(tp, ip, 0);
+	error = xfs_bmapi_write(tp, ip, *offset_fsb, next_fsb - *offset_fsb,
+			XFS_BMAPI_COWFORK, &first_block,
+			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK),
+			&imap, &nimaps, &dfops);
+	if (error)
+		goto out_trans_cancel;
+
+	/* We might not have been able to map the whole delalloc extent */
+	*offset_fsb = min(*offset_fsb + imap.br_blockcount, next_fsb);
+
+	error = xfs_defer_finish(&tp, &dfops, NULL);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_trans_commit(tp);
+
+out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+out_trans_cancel:
+	xfs_defer_cancel(&dfops);
+	xfs_trans_cancel(tp);
+	goto out_unlock;
+}
 
+/*
+ * Allocate blocks to all CoW reservations within a byte range of a file.
+ */
+int
+xfs_reflink_allocate_cow_range(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		count)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
+	int			error;
+
+	ASSERT(xfs_is_reflink_inode(ip));
+
+	trace_xfs_reflink_allocate_cow_range(ip, offset, count);
+
+	/*
+	 * Make sure that the dquots are there.
+	 */
+	error = xfs_qm_dqattach(ip, 0);
 	if (error)
-		trace_xfs_reflink_allocate_cow_range_error(ip, error, _RET_IP_);
+		return error;
+
+	while (offset_fsb < end_fsb) {
+		error = __xfs_reflink_allocate_cow(ip, &offset_fsb, end_fsb);
+		if (error) {
+			trace_xfs_reflink_allocate_cow_range_error(ip, error,
+					_RET_IP_);
+			break;
+		}
+	}
+
 	return error;
 }
 
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 0e19ec6..859ca50 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -28,8 +28,8 @@ extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 
 extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip,
 		xfs_off_t offset, xfs_off_t count);
-extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip, xfs_off_t pos,
-		xfs_off_t len);
+extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip,
+		xfs_off_t offset, xfs_off_t count);
 extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
 		struct xfs_bmbt_irec *imap, bool *need_alloc);
 extern int xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c8fb91c..26113b9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3320,7 +3320,6 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_enospc);
 
 DEFINE_RW_EVENT(xfs_reflink_reserve_cow_range);
 DEFINE_RW_EVENT(xfs_reflink_allocate_cow_range);
-DEFINE_INODE_IREC_EVENT(xfs_reflink_allocate_cow_extent);
 
 DEFINE_INODE_IREC_EVENT(xfs_reflink_bounce_dio_write);
 DEFINE_IOMAP_EVENT(xfs_reflink_find_cow_mapping);
-- 
2.1.4

