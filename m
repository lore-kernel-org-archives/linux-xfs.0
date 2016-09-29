Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753336AbcI2NA5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Sep 2016 09:00:57 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6A768285B2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2016 13:00:56 +0000 (UTC)
Received: from zion.usersys.redhat.com (vpn-54-24.rdu2.redhat.com [10.10.54.24])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u8TD0sYO028084
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2016 09:00:55 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] [RFC] Release buffer locks in case of IO error
Date: Thu, 29 Sep 2016 15:00:50 +0200
Message-Id: <1475154050-28771-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I have been working in a bug still regarding xfs fail_at_unmount configuration,
where, even though the configuration is enable, an unmount attempt will still
hang if the AIL buf items are locked as a result of a previous failed attempt to
flush these items.

Currently, if there is a failure while trying to flush inode buffers to disk,
these items are kept in AIL with FLUSHING status and with the locks held, making
them unable to be retried. Either during unmount, where they will be retried and
'failed', or if using a thin provisioned device, the pool is actually extended, to
accomodate these not-yet-flushed items, instead of retrying to flush such items,
xfs is unable to retry them, once they are already locked.

Brian came with a suggestion about how to fix it, releasing the locks in case we
had a failed write attempt.

I know there are some other persons also involved in this problem, so I think
it's a good idea to send Brian's patch here and get some more comments about it.

I'm keeping Brian's signed-off once he wrote the whole patch.


Signed-off-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_inode_item.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 892c2ac..cce0373 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -517,7 +517,26 @@ xfs_inode_item_push(
 	 * the AIL.
 	 */
 	if (!xfs_iflock_nowait(ip)) {
-		rval = XFS_ITEM_FLUSHING;
+		int error;
+		struct xfs_dinode *dip;
+
+		error = xfs_imap_to_bp(ip->i_mount, NULL, &ip->i_imap, &dip,
+				       &bp, XBF_TRYLOCK, 0);
+		if (error) {
+			rval = XFS_ITEM_FLUSHING;
+			goto out_unlock;
+		}
+
+		if (!(bp->b_flags & XBF_WRITE_FAIL)) {
+			rval = XFS_ITEM_FLUSHING;
+			xfs_buf_relse(bp);
+			goto out_unlock;
+		}
+
+		if (!xfs_buf_delwri_queue(bp, buffer_list))
+			rval = XFS_ITEM_FLUSHING;
+
+		xfs_buf_relse(bp);
 		goto out_unlock;
 	}
 
-- 
2.7.4

