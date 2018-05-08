Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:28698 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753510AbeEHDmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 23:42:09 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fFtVt-0002Kj-30
        for linux-xfs@vger.kernel.org; Tue, 08 May 2018 13:42:05 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fFtVt-0002ht-2A
        for linux-xfs@vger.kernel.org; Tue, 08 May 2018 13:42:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/9] xfs: fix double ijoin in xfs_inactive_symlink_rmt()
Date: Tue,  8 May 2018 13:41:58 +1000
Message-Id: <20180508034202.10136-6-david@fromorbit.com>
In-Reply-To: <20180508034202.10136-1-david@fromorbit.com>
References: <20180508034202.10136-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_inactive_symlink_rmt() does something nasty - it joins an inode
into a transaction it is already joined to. This means the inode can
have multiple log item descriptors attached to the transaction for
it. This breaks teh 1:1 mapping that is supposed to exist
between the log item and log item descriptor.

This results in the log item being processed twice during
transaction commit and CIL formatting, and there are lots of other
potential issues tha arise from double processing of log items in
the transaction commit state machine.

In this case, the inode is already held by the rolling transaction
returned from xfs_defer_finish(), so there's no need to join it
again.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_symlink.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 5b66ac12913c..27870e5cd259 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -488,16 +488,11 @@ xfs_inactive_symlink_rmt(
 	error = xfs_defer_finish(&tp, &dfops);
 	if (error)
 		goto error_bmap_cancel;
-	/*
-	 * The first xact was committed, so add the inode to the new one.
-	 * Mark it dirty so it will be logged and moved forward in the log as
-	 * part of every commit.
-	 */
-	xfs_trans_ijoin(tp, ip, 0);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 	/*
 	 * Commit the transaction containing extent freeing and EFDs.
 	 */
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = xfs_trans_commit(tp);
 	if (error) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-- 
2.17.0

