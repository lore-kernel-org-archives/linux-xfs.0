Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54654 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751928AbdIVLgB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Sep 2017 07:36:01 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9186A7F3E5
        for <linux-xfs@vger.kernel.org>; Fri, 22 Sep 2017 11:36:01 +0000 (UTC)
Received: from odin.brq.redhat.com (unknown [10.43.17.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17B3D5D9CB
        for <linux-xfs@vger.kernel.org>; Fri, 22 Sep 2017 11:36:00 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: Capture state of the right inode in xfs_iflush_done
Date: Fri, 22 Sep 2017 13:35:55 +0200
Message-Id: <20170922113555.17711-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

My previous patch: d3a304b6292168b83b45d624784f973fdc1ca674 check for
XFS_LI_FAILED flag xfs_iflush done, so the failed item can be properly
resubmitted.

In the loop scanning other inodes being completed, it should check the
current item for the XFS_LI_FAILED, and not the initial one.

The state of the initial inode is checked after the loop ends

Kudos to Eric for catching this.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_inode_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6d0f74ec31e8..015e8ee793a3 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -745,7 +745,7 @@ xfs_iflush_done(
 		 */
 		iip = INODE_ITEM(blip);
 		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
-		    lip->li_flags & XFS_LI_FAILED)
+		    blip->li_flags & XFS_LI_FAILED)
 			need_ail++;
 
 		blip = next;
-- 
2.13.5

