Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56368 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfEUDrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 23:47:12 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/7] libxfs: fix argument to xfs_trans_add_item
Date: Mon, 20 May 2019 22:47:04 -0500
Message-Id: <1558410427-1837-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The hack of casting an inode_log_item or buf_log_item to a
xfs_log_item_t is pretty gross; yes it's the first member in the
structure, but yuk.  Pass in the correct structure member.

This was fixed in the kernel with commit e98c414f9
("xfs: simplify log item descriptor tracking")

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 libxfs/trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/trans.c b/libxfs/trans.c
index dc924fa..c7a1d52 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -346,7 +346,7 @@ libxfs_trans_ijoin(
 	ASSERT(iip->ili_lock_flags == 0);
 	iip->ili_lock_flags = lock_flags;
 
-	xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
+	xfs_trans_add_item(tp, &iip->ili_item);
 }
 
 void
@@ -570,7 +570,7 @@ _libxfs_trans_bjoin(
 	 * Attach the item to the transaction so we can find it in
 	 * xfs_trans_get_buf() and friends.
 	 */
-	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
+	xfs_trans_add_item(tp, &bip->bli_item);
 	bp->b_transp = tp;
 
 }
-- 
1.8.3.1
