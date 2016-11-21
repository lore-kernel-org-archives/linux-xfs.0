Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58955 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754386AbcKUQjl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2016 11:39:41 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c8rd6-0001le-21
        for linux-xfs@vger.kernel.org; Mon, 21 Nov 2016 16:39:40 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/14] xfs: use new extent lookup helpers in xfs_reflink_end_cow
Date: Mon, 21 Nov 2016 17:38:54 +0100
Message-Id: <1479746336-10986-13-git-send-email-hch@lst.de>
In-Reply-To: <1479746336-10986-1-git-send-email-hch@lst.de>
References: <1479746336-10986-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_reflink.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4e07da3..56372be 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -614,13 +614,13 @@ xfs_reflink_end_cow(
 	xfs_off_t			count)
 {
 	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	struct xfs_bmbt_irec		got, prev, del;
+	struct xfs_bmbt_irec		got, del;
 	struct xfs_trans		*tp;
 	xfs_fileoff_t			offset_fsb;
 	xfs_fileoff_t			end_fsb;
 	xfs_fsblock_t			firstfsb;
 	struct xfs_defer_ops		dfops;
-	int				error, eof = 0;
+	int				error;
 	unsigned int			resblks;
 	xfs_filblks_t			rlen;
 	xfs_extnum_t			idx;
@@ -644,13 +644,11 @@ xfs_reflink_end_cow(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	xfs_bmap_search_extents(ip, end_fsb - 1, XFS_COW_FORK, &eof, &idx,
-			&got, &prev);
-
 	/* If there is a hole at end_fsb - 1 go to the previous extent */
-	if (eof || got.br_startoff > end_fsb) {
+	if (!xfs_iext_lookup_extent(ip, ifp, end_fsb - 1, &idx, &got) ||
+	    got.br_startoff > end_fsb) {
 		ASSERT(idx > 0);
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, --idx), &got);
+		xfs_iext_get_extent(ifp, --idx, &got);
 	}
 
 	/* Walk backwards until we're out of the I/O range... */
@@ -698,11 +696,9 @@ xfs_reflink_end_cow(
 		error = xfs_defer_finish(&tp, &dfops, ip);
 		if (error)
 			goto out_defer;
-
 next_extent:
-		if (idx < 0)
+		if (!xfs_iext_get_extent(ifp, idx, &got))
 			break;
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &got);
 	}
 
 	error = xfs_trans_commit(tp);
-- 
2.1.4

