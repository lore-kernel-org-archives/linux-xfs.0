Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39303 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751371AbeEBICJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 04:02:09 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fDmi8-0002X2-AL
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 18:02:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fDmi8-0003BC-8T
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 18:02:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/10] xfs: add some more debug checks to buffer log item reuse
Date: Wed,  2 May 2018 18:01:56 +1000
Message-Id: <20180502080157.11386-10-david@fromorbit.com>
In-Reply-To: <20180502080157.11386-1-david@fromorbit.com>
References: <20180502080157.11386-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Just to make sure the item isn't associated with another
transaction when we try to reuse it.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 53c07a7a14fb..3656f7cb18ad 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -722,8 +722,11 @@ xfs_buf_item_init(
 	 * nothing to do here so return.
 	 */
 	ASSERT(bp->b_target->bt_mount == mp);
-	if (bip != NULL) {
+	if (bip) {
 		ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
+		ASSERT(!test_bit(XFS_LI_TRANS, &bip->bli_item.li_flags));
+		ASSERT(!bp->b_transp);
+		ASSERT(bip->bli_buf == bp);
 		return 0;
 	}
 
-- 
2.17.0

