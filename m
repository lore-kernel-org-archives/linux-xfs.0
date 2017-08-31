Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751760AbdHaQFA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 12:05:00 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22187C04D288
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 16:05:00 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 072BA92D1F
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 16:05:00 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix unused variable warning in xfs_buf_item_unlock()
Date: Thu, 31 Aug 2017 12:04:58 -0400
Message-Id: <20170831160458.24886-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The ordered variable generates an unused warning on !DEBUG builds.
Separate the initialization of the associated variables from the
declarations to quiet gcc.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index ef2c137..f5d25f5 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -567,10 +567,15 @@ xfs_buf_item_unlock(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			aborted = !!(lip->li_flags & XFS_LI_ABORTED);
-	bool			hold = !!(bip->bli_flags & XFS_BLI_HOLD);
-	bool			dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
-	bool			ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
+	bool			aborted;
+	bool			hold;
+	bool			dirty;
+	bool			ordered;
+
+	aborted = !!(lip->li_flags & XFS_LI_ABORTED);
+	hold = !!(bip->bli_flags & XFS_BLI_HOLD);
+	dirty = !!(bip->bli_flags & XFS_BLI_DIRTY);
+	ordered = !!(bip->bli_flags & XFS_BLI_ORDERED);
 
 	/* Clear the buffer's association with this transaction. */
 	bp->b_transp = NULL;
-- 
2.9.5

