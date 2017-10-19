Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52600 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754239AbdJSOXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:23:20 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/16] xfs: Capture state of the right inode in xfs_iflush_done
Date: Thu, 19 Oct 2017 16:22:50 +0200
Message-Id: <20171019142259.20082-8-hch@lst.de>
In-Reply-To: <20171019142259.20082-1-hch@lst.de>
References: <20171019142259.20082-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Carlos Maiolino <cmaiolino@redhat.com>

commit 842f6e9f786226c58fcbd5ef80eadca72fdfe652 upstream.

My previous patch: d3a304b6292168b83b45d624784f973fdc1ca674 check for
XFS_LI_FAILED flag xfs_iflush done, so the failed item can be properly
resubmitted.

In the loop scanning other inodes being completed, it should check the
current item for the XFS_LI_FAILED, and not the initial one.

The state of the initial inode is checked after the loop ends

Kudos to Eric for catching this.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 94915747042c..3e49a41ca960 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -745,7 +745,7 @@ xfs_iflush_done(
 		 */
 		iip = INODE_ITEM(blip);
 		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
-		    lip->li_flags & XFS_LI_FAILED)
+		    (blip->li_flags & XFS_LI_FAILED))
 			need_ail++;
 
 		blip = next;
-- 
2.14.2

