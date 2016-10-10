Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752464AbcJJNiT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 09:38:19 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/9] xfs: handle "raw" delayed extents xfs_reflink_trim_around_shared
Date: Mon, 10 Oct 2016 15:37:59 +0200
Message-Id: <1476106685-29048-4-git-send-email-hch@lst.de>
In-Reply-To: <1476106685-29048-1-git-send-email-hch@lst.de>
References: <1476106685-29048-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

Delalloc extents in the extent list contain the number of reserved
indirect blocks in their startblock value and don't use the magic
DELAYSTARTBLOCK constant.  Ensure that xfs_reflink_trim_around_shared
handles them properly by checking for isnullstartblock().

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5965e94..46c824c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -182,7 +182,8 @@ xfs_reflink_trim_around_shared(
 	if (!xfs_is_reflink_inode(ip) ||
 	    ISUNWRITTEN(irec) ||
 	    irec->br_startblock == HOLESTARTBLOCK ||
-	    irec->br_startblock == DELAYSTARTBLOCK) {
+	    irec->br_startblock == DELAYSTARTBLOCK ||
+	    isnullstartblock(irec->br_startblock)) {
 		*shared = false;
 		return 0;
 	}
-- 
2.10.1.382.ga23ca1b

