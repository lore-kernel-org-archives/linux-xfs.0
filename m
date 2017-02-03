Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53539 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752941AbdBCJ5V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2017 04:57:21 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cZacK-0007j3-7s
        for linux-xfs@vger.kernel.org; Fri, 03 Feb 2017 09:57:20 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] xfs: update ctime and mtime on clone destinatation inodes
Date: Fri,  3 Feb 2017 10:57:15 +0100
Message-Id: <20170203095715.7955-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We're changing both metadata and data, so we need to update the
timestamps for clone operations.  Dedupe on the other hand does
not change file data, and only changes invisible metadata so the
timestamps should not be updated.

This follows existing btrfs behavior.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d5a2cf2b469b..199ce0100bc6 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -961,13 +961,15 @@ STATIC int
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
+	if (is_dedupe &&
+	    newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0 && is_dedupe)
 		return 0;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
@@ -988,6 +990,10 @@ xfs_reflink_update_dest(
 		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 	}
 
+	if (!is_dedupe) {
+		xfs_trans_ichgtime(tp, dest,
+				   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	}
 	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
 
 	error = xfs_trans_commit(tp);
@@ -1301,7 +1307,8 @@ xfs_reflink_remap_range(
 	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
 		cowextsize = src->i_d.di_cowextsize;
 
-	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize);
+	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
+			is_dedupe);
 
 out_unlock:
 	xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
-- 
2.11.0

