Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:13464 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750897AbeEBICH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 04:02:07 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fDmi8-0002Wg-53
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 18:02:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fDmi8-0003B0-3g
        for linux-xfs@vger.kernel.org; Wed, 02 May 2018 18:02:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/10] xfs: don't assert fail with AIL lock held
Date: Wed,  2 May 2018 18:01:52 +1000
Message-Id: <20180502080157.11386-6-david@fromorbit.com>
In-Reply-To: <20180502080157.11386-1-david@fromorbit.com>
References: <20180502080157.11386-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Been hitting AIL ordering assert failures recently, but been unable
to trace them down because the system immediately hangs up onteh
spinlock that was held when this assert fires:

XFS: Assertion failed: XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0, file: fs/xfs/xfs_trans_ail.c, line: 52

Move the assertions outside of the spinlock so the corpse can
be dissected.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 50611d2bcbc2..58a2cf6fd4d9 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -32,13 +32,19 @@
 #ifdef DEBUG
 /*
  * Check that the list is sorted as it should be.
+ *
+ * Called with the ail lock held, but we don't want to assert fail with it
+ * held otherwise we'll lock everything up and won't be able to debug the
+ * cause. Hence jump through hoops to drop teh lock before assert failing.
+ * Asserts may not be fatal, so pick teh lock back up and continue onwards.
  */
 STATIC void
 xfs_ail_check(
-	struct xfs_ail	*ailp,
-	xfs_log_item_t	*lip)
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	*lip)
 {
-	xfs_log_item_t	*prev_lip;
+	struct xfs_log_item	*prev_lip;
+	struct xfs_log_item	*next_lip;
 
 	if (list_empty(&ailp->ail_head))
 		return;
@@ -46,15 +52,29 @@ xfs_ail_check(
 	/*
 	 * Check the next and previous entries are valid.
 	 */
-	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
-	prev_lip = list_entry(lip->li_ail.prev, xfs_log_item_t, li_ail);
-	if (&prev_lip->li_ail != &ailp->ail_head)
-		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
+	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
+		spin_unlock(&ailp->ail_lock);
+		ASSERT(0);
+		spin_lock(&ailp->ail_lock);
+	}
 
-	prev_lip = list_entry(lip->li_ail.next, xfs_log_item_t, li_ail);
-	if (&prev_lip->li_ail != &ailp->ail_head)
-		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) >= 0);
+	prev_lip = list_entry(lip->li_ail.prev, xfs_log_item_t, li_ail);
+	if (&prev_lip->li_ail != &ailp->ail_head) {
+		if (XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) > 0) {
+			spin_unlock(&ailp->ail_lock);
+			ASSERT(0);
+			spin_lock(&ailp->ail_lock);
+		}
+	}
 
+	next_lip = list_entry(lip->li_ail.next, xfs_log_item_t, li_ail);
+	if (&next_lip->li_ail != &ailp->ail_head) {
+		if (XFS_LSN_CMP(next_lip->li_lsn, lip->li_lsn) < 0) {
+			spin_unlock(&ailp->ail_lock);
+			ASSERT(0);
+			spin_lock(&ailp->ail_lock);
+		}
+	}
 
 }
 #else /* !DEBUG */
-- 
2.17.0

