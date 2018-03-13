Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932533AbeCMOg3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 10:36:29 -0400
Received: from 77.117.139.172.wireless.dyn.drei.com ([77.117.139.172] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evl2S-0004ce-M2
        for linux-xfs@vger.kernel.org; Tue, 13 Mar 2018 14:36:29 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] xfs: mark xfs_reflink_clear_inode_flag static
Date: Tue, 13 Mar 2018 15:36:00 +0100
Message-Id: <20180313143601.30028-8-hch@lst.de>
In-Reply-To: <20180313143601.30028-1-hch@lst.de>
References: <20180313143601.30028-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 2 +-
 fs/xfs/xfs_reflink.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cdbd342a5249..85d3379a81df 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1552,7 +1552,7 @@ xfs_reflink_inode_has_shared_extents(
 }
 
 /* Clear the inode reflink flag if there are no shared extents. */
-int
+static int
 xfs_reflink_clear_inode_flag(
 	struct xfs_inode	*ip,
 	struct xfs_trans	**tpp)
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 701487bab468..7d6d34a30200 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -49,8 +49,6 @@ extern int xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
 		struct file *file_out, loff_t pos_out, u64 len, bool is_dedupe);
 extern int xfs_reflink_inode_has_shared_extents(struct xfs_trans *tp,
 		struct xfs_inode *ip, bool *has_shared);
-extern int xfs_reflink_clear_inode_flag(struct xfs_inode *ip,
-		struct xfs_trans **tpp);
 extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len);
 
-- 
2.14.2

