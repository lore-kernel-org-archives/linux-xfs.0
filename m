Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41370 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752242AbdC0IuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:50:25 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/27] xfs: update ctime and mtime on clone destinatation inodes
Date: Mon, 27 Mar 2017 10:49:10 +0200
Message-Id: <20170327084922.11691-16-hch@lst.de>
In-Reply-To: <20170327084922.11691-1-hch@lst.de>
References: <20170327084922.11691-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit c5ecb42342852892f978572ddc6dca703460f25a upstream.

We're changing both metadata and data, so we need to update the
timestamps for clone operations.  Dedupe on the other hand does
not change file data, and only changes invisible metadata so the
timestamps should not be updated.

This follows existing btrfs behavior.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: remove redundant is_dedupe test]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 539a612a02e5..36c07b12189e 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -985,13 +985,14 @@ STATIC int
 xfs_reflink_update_dest(
 	struct xfs_inode	*dest,
 	xfs_off_t		newlen,
-	xfs_extlen_t		cowextsize)
+	xfs_extlen_t		cowextsize,
+	bool			is_dedupe)
 {
 	struct xfs_mount	*mp = dest->i_mount;
 	struct xfs_trans	*tp;
 	int			error;
 
-	if (newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0)
+	if (is_dedupe && newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0)
 		return 0;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
@@ -1012,6 +1013,10 @@ xfs_reflink_update_dest(
 		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 	}
 
+	if (!is_dedupe) {
+		xfs_trans_ichgtime(tp, dest,
+				   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	}
 	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
 
 	error = xfs_trans_commit(tp);
@@ -1528,7 +1533,8 @@ xfs_reflink_remap_range(
 	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
 		cowextsize = src->i_d.di_cowextsize;
 
-	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize);
+	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
+			is_dedupe);
 
 out_unlock:
 	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
-- 
2.11.0

