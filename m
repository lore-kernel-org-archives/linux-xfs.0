Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52295 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754218AbeEHDmK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 23:42:10 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fFtVt-0002Kp-59
        for linux-xfs@vger.kernel.org; Tue, 08 May 2018 13:42:05 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fFtVt-0002i3-4A
        for linux-xfs@vger.kernel.org; Tue, 08 May 2018 13:42:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/9] xfs: add some more debug checks to buffer log item reuse
Date: Tue,  8 May 2018 13:42:01 +1000
Message-Id: <20180508034202.10136-9-david@fromorbit.com>
In-Reply-To: <20180508034202.10136-1-david@fromorbit.com>
References: <20180508034202.10136-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Just to make sure the item isn't associated with another
transaction when we try to reuse it.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index df62082f2204..8d6ed045b643 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -745,8 +745,10 @@ xfs_buf_item_init(
 	 * nothing to do here so return.
 	 */
 	ASSERT(bp->b_target->bt_mount == mp);
-	if (bip != NULL) {
+	if (bip) {
 		ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
+		ASSERT(!bp->b_transp);
+		ASSERT(bip->bli_buf == bp);
 		return 0;
 	}
 
-- 
2.17.0

