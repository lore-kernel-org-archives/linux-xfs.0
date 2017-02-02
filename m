Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58795 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdBBQZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 11:25:47 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cZKBv-0005zW-0s
        for linux-xfs@vger.kernel.org; Thu, 02 Feb 2017 16:24:59 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: update ctime and mtime on clone destinatation inodes
Date: Thu,  2 Feb 2017 17:24:56 +0100
Message-Id: <20170202162456.20574-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We're changing both metadata and data, so we need to update the
timestamps.   This follows existing btrfs behavior.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d5a2cf2b469b..8877e6f5e35d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -967,9 +967,6 @@ xfs_reflink_update_dest(
 	struct xfs_trans	*tp;
 	int			error;
 
-	if (newlen <= i_size_read(VFS_I(dest)) && cowextsize == 0)
-		return 0;
-
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
 	if (error)
 		goto out_error;
@@ -988,6 +985,7 @@ xfs_reflink_update_dest(
 		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 	}
 
+	xfs_trans_ichgtime(tp, dest, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
 
 	error = xfs_trans_commit(tp);
-- 
2.11.0

