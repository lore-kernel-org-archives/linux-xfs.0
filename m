Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:47629 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932860AbdC2Usl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 16:48:41 -0400
From: Lucas Stach <dev@lynxeye.de>
Subject: [PATCH] xfs: largely extend aild sleep time if no work has to be done
Date: Wed, 29 Mar 2017 22:42:24 +0200
Message-Id: <20170329204224.6412-1-dev@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

If the AIL has been pushed up to the target LSN, there is no
point in waking up every 50ms to check if there is more work
to do. All functions that move the target LSN forward make sure
to wake aild as appropriate.

Keep the timeout wakeup as a watchdog in case we miss the
wakeup from a target LSN update to guarantee forward progress,
but extend the timeout to 10 seconds.

This keeps the safety net, but also makes laptop users happy
as it gets rid of almost all the wakeups caused by a lightly
loaded FS.

Signed-off-by: Lucas Stach <dev@lynxeye.de>
---
 fs/xfs/xfs_trans_ail.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index d6c9c3e..1eb40dc 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -457,12 +457,21 @@ xfsaild_push(
 	if (xfs_buf_delwri_submit_nowait(&ailp->xa_buf_list))
 		ailp->xa_log_flush++;
 
-	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
+	if (!count) {
 out_done:
 		/*
-		 * We reached the target or the AIL is empty, so wait a bit
-		 * longer for I/O to complete and remove pushed items from the
-		 * AIL before we start the next scan from the start of the AIL.
+		 * If there was nothing to be pushed we can go to sleep longer,
+		 * as this is purely a watchdog timeout. If the target gets
+		 * moved forward we will get scheduled in before hitting this
+		 * timeout.
+		 */
+		tout = 10000;
+		ailp->xa_last_pushed_lsn = 0;
+	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
+		/*
+		 * We reached the target, so wait a bit longer for I/O to
+		 * complete and remove pushed items from the AIL before we
+		 * start the next scan from the start of the AIL.
 		 */
 		tout = 50;
 		ailp->xa_last_pushed_lsn = 0;
-- 
2.9.3

