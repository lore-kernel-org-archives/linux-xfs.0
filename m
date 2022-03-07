Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3967C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 05:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbiCGFdx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 00:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbiCGFdw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 00:33:52 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F6663BFBB
        for <linux-xfs@vger.kernel.org>; Sun,  6 Mar 2022 21:32:58 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CEE5F10E1B03;
        Mon,  7 Mar 2022 16:32:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nR5zM-002U7O-S4; Mon, 07 Mar 2022 16:32:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nR5zM-00Ada2-R5;
        Mon, 07 Mar 2022 16:32:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     willy@infradead.org
Subject: [PATCH 3/3] xfs: xfs_ail_push_all_sync() stalls when racing with updates
Date:   Mon,  7 Mar 2022 16:32:52 +1100
Message-Id: <20220307053252.2534616-4-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220307053252.2534616-1-david@fromorbit.com>
References: <20220307053252.2534616-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6225990a
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=EOO2phA2CyUEHaC7MKsA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_ail_push_all_sync() has a loop like this:

while max_ail_lsn {
	prepare_to_wait(ail_empty)
	target = max_ail_lsn
	wake_up(ail_task);
	schedule()
}

Which is designed to sleep until the AIL is emptied. When
xfs_ail_finish_update() moves the tail of the log, it does:

	if (list_empty(&ailp->ail_head))
		wake_up_all(&ailp->ail_empty);

So it will only wake up the sync push waiter when the AIL goes
empty. If, by the time the push waiter has woken, the AIL has more
in it, it will reset the target, wake the push task and go back to
sleep.

The problem here is that if the AIL is having items added to it
when xfs_ail_push_all_sync() is called, then they may get inserted
into the AIL at a LSN higher than the target LSN. At this point,
xfsaild_push() will see that the target is X, the item LSNs are
(X+N) and skip over them, hence never pushing the out.

The result of this the AIL will not get emptied by the AIL push
thread, hence xfs_ail_finish_update() will never see the AIL being
empty even if it moves the tail. Hence xfs_ail_push_all_sync() never
gets woken and hence cannot update the push target to capture the
items beyond the current target on the LSN.

This is a TOCTOU type of issue so the way to avoid it is to not
use the push target at all for sync pushes. We know that a sync push
is being requested by the fact the ail_empty wait queue is active,
hence the xfsaild can just set the target to max_ail_lsn on every
push that we see the wait queue active. Hence we no longer will
leave items on the AIL that are beyond the LSN sampled at the start
of a sync push.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 2a8c8dc54c95..1b52952097c1 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -448,10 +448,22 @@ xfsaild_push(
 
 	spin_lock(&ailp->ail_lock);
 
-	/* barrier matches the ail_target update in xfs_ail_push() */
-	smp_rmb();
-	target = ailp->ail_target;
-	ailp->ail_target_prev = target;
+	/*
+	 * If we have a sync push waiter, we always have to push till the AIL is
+	 * empty. Update the target to point to the end of the AIL so that
+	 * capture updates that occur after the sync push waiter has gone to
+	 * sleep.
+	 */
+	if (waitqueue_active(&ailp->ail_empty)) {
+		lip = xfs_ail_max(ailp);
+		if (lip)
+			target = lip->li_lsn;
+	} else {
+		/* barrier matches the ail_target update in xfs_ail_push() */
+		smp_rmb();
+		target = ailp->ail_target;
+		ailp->ail_target_prev = target;
+	}
 
 	/* we're done if the AIL is empty or our push has reached the end */
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);
@@ -724,7 +736,6 @@ xfs_ail_push_all_sync(
 	spin_lock(&ailp->ail_lock);
 	while ((lip = xfs_ail_max(ailp)) != NULL) {
 		prepare_to_wait(&ailp->ail_empty, &wait, TASK_UNINTERRUPTIBLE);
-		ailp->ail_target = lip->li_lsn;
 		wake_up_process(ailp->ail_task);
 		spin_unlock(&ailp->ail_lock);
 		schedule();
-- 
2.33.0

