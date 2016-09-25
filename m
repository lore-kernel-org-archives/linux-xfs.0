Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030206AbcIYDVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Sep 2016 23:21:34 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] xfs_reflink_allocate_cow_range
Date: Sat, 24 Sep 2016 20:21:31 -0700
Message-Id: <1474773692-26752-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Conflicts:
	fs/xfs/xfs_reflink.c
---
 fs/xfs/xfs_reflink.c | 98 +++++++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_reflink.h |  4 +--
 fs/xfs/xfs_trace.h   |  1 -
 3 files changed, 61 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 09e0e27..82a7da3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -364,57 +364,77 @@ xfs_reflink_reserve_cow_range(
 int
 xfs_reflink_allocate_cow_range(
 	struct xfs_inode	*ip,
-	xfs_off_t		pos,
-	xfs_off_t		len)
+	xfs_off_t		offset,
+	xfs_off_t		count)
 {
-	struct xfs_ifork	*ifp;
-	struct xfs_bmbt_rec_host	*gotp;
-	struct xfs_bmbt_irec	imap;
-	int			error = 0;
-	xfs_fileoff_t		start_lblk;
-	xfs_fileoff_t		end_lblk;
-	xfs_extnum_t		idx;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
+	int			error;
 
-	if (!xfs_is_reflink_inode(ip))
-		return 0;
+	ASSERT(xfs_is_reflink_inode(ip));
 
-	trace_xfs_reflink_allocate_cow_range(ip, len, pos);
+//	trace_xfs_reflink_allocate_cow_range(ip, offset, count);
+//	trace_xfs_reflink_allocate_cow_range_error(ip, error, _RET_IP_);
 
-	start_lblk = XFS_B_TO_FSBT(ip->i_mount, pos);
-	end_lblk = XFS_B_TO_FSB(ip->i_mount, pos + len);
-	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	/*
+	 * Make sure that the dquots are there.
+	 */
+	error = xfs_qm_dqattach(ip, 0);
+	if (error)
+		return error;
 
-	gotp = xfs_iext_bno_to_ext(ifp, start_lblk, &idx);
-	while (gotp) {
-		xfs_bmbt_get_all(gotp, &imap);
+	while (offset_fsb < end_fsb) {
+		struct xfs_bmbt_irec	imap;
+		struct xfs_defer_ops	dfops;
+		struct xfs_trans	*tp;
+		xfs_fsblock_t		first_block;
+		int			nimaps = 1, nres;
 
-		if (imap.br_startoff >= end_lblk)
-			break;
-		if (!isnullstartblock(imap.br_startblock))
-			goto advloop;
-		xfs_trim_extent(&imap, start_lblk, end_lblk - start_lblk);
-		trace_xfs_reflink_allocate_cow_extent(ip, &imap);
+		/*
+		 * We have already reserved space for the extent and any
+		 * indirect blocks when creating the delalloc extent,
+		 * there is no need to reserve space in this transaction
+		 * again.
+		 */
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0,
+				0, XFS_TRANS_RESERVE, &tp);
+		if (error)
+			return error;
 
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		error = xfs_iomap_write_allocate(ip, XFS_COW_FORK,
-				XFS_FSB_TO_B(ip->i_mount, imap.br_startoff +
-						imap.br_blockcount - 1), &imap);
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, 0);
+
+		xfs_defer_init(&dfops, &first_block);
+
+		// XXX: bmap_read
+
+		error = xfs_bmapi_write(tp, ip, offset_fsb,
+				end_fsb - offset_fsb, XFS_BMAPI_COWFORK,
+				&first_block,
+				XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK),
+				&imap, &nimaps, &dfops);
 		if (error)
-			break;
-advloop:
-		/* Roll on... */
-		idx++;
-		if (idx >= ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
-			break;
-		gotp = xfs_iext_get_ext(ifp, idx);
+			goto trans_cancel;
+
+		error = xfs_defer_finish(&tp, &dfops, NULL);
+		if (error)
+			goto trans_cancel;
+
+		error = xfs_trans_commit(tp);
+		if (error)
+			goto error0;
+
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+		offset_fsb = imap.br_startoff + imap.br_blockcount;
 	}
 
+trans_cancel:
+	xfs_defer_cancel(&dfops);
+	xfs_trans_cancel(tp);
+error0:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-	if (error)
-		trace_xfs_reflink_allocate_cow_range_error(ip, error, _RET_IP_);
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

