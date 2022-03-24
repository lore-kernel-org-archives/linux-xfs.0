Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB78C43217
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 00:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241634AbiCXAWl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 20:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242420AbiCXAWk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 20:22:40 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A36A974841
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 17:21:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DD63C533E8A
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 11:21:06 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXBDt-0096Zy-NW
        for linux-xfs@vger.kernel.org; Thu, 24 Mar 2022 11:21:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nXBDt-002z4h-Mk
        for linux-xfs@vger.kernel.org;
        Thu, 24 Mar 2022 11:21:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: shutdown in intent recovery has non-intent items in the AIL
Date:   Thu, 24 Mar 2022 11:20:59 +1100
Message-Id: <20220324002103.710477-3-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324002103.710477-1-david@fromorbit.com>
References: <20220324002103.710477-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=623bb973
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=W2dFxmz-06ihNOqDruYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

generic/388 triggered a failure in RUI recovery due to a corrupted
btree record and the system then locked up hard due to a subsequent
assert failure while holding a spinlock cancelling intents:

 XFS (pmem1): Corruption of in-memory data (0x8) detected at xfs_do_force_shutdown+0x1a/0x20 (fs/xfs/xfs_trans.c:964).  Shutting down filesystem.
 XFS (pmem1): Please unmount the filesystem and rectify the problem(s)
 XFS: Assertion failed: !xlog_item_is_intent(lip), file: fs/xfs/xfs_log_recover.c, line: 2632
 Call Trace:
  <TASK>
  xlog_recover_cancel_intents.isra.0+0xd1/0x120
  xlog_recover_finish+0xb9/0x110
  xfs_log_mount_finish+0x15a/0x1e0
  xfs_mountfs+0x540/0x910
  xfs_fs_fill_super+0x476/0x830
  get_tree_bdev+0x171/0x270
  ? xfs_init_fs_context+0x1e0/0x1e0
  xfs_fs_get_tree+0x15/0x20
  vfs_get_tree+0x24/0xc0
  path_mount+0x304/0xba0
  ? putname+0x55/0x60
  __x64_sys_mount+0x108/0x140
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Essentially, there's dirty metadata in the AIL from intent recovery
transactions, so when we go to cancel the remaining intents we assume
that all objects after the first non-intent log item in the AIL are
not intents.

This is not true. Intent recovery can log new intents to continue
the operations the original intent could not complete in a single
transaction. The new intents are committed before they are deferred,
which means if the CIL commits in the background they will get
inserted into the AIL at the head.

Hence if we shut down the filesystem while processing intent
recovery, the AIL may have new intents active at the current head.
Hence this check:

                /*
                 * We're done when we see something other than an intent.
                 * There should be no intents left in the AIL now.
                 */
                if (!xlog_item_is_intent(lip)) {
#ifdef DEBUG
                        for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
                                ASSERT(!xlog_item_is_intent(lip));
#endif
                        break;
                }

in both xlog_recover_process_intents() and
log_recover_cancel_intents() is simply not valid. It was valid back
when we only had EFI/EFD intents and didn't chain intents, but it
hasn't been valid ever since intent recovery could create and commit
new intents.

Given that crashing the mount task like this pretty much prevents
diagnosing what went wrong that lead to the initial failure that
triggered intent cancellation, just remove the checks altogether.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 50 ++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 96c997ed2ec8..7758a6706b8c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2519,21 +2519,22 @@ xlog_abort_defer_ops(
 		xfs_defer_ops_capture_free(mp, dfc);
 	}
 }
+
 /*
  * When this is called, all of the log intent items which did not have
- * corresponding log done items should be in the AIL.  What we do now
- * is update the data structures associated with each one.
+ * corresponding log done items should be in the AIL.  What we do now is update
+ * the data structures associated with each one.
  *
- * Since we process the log intent items in normal transactions, they
- * will be removed at some point after the commit.  This prevents us
- * from just walking down the list processing each one.  We'll use a
- * flag in the intent item to skip those that we've already processed
- * and use the AIL iteration mechanism's generation count to try to
- * speed this up at least a bit.
+ * Since we process the log intent items in normal transactions, they will be
+ * removed at some point after the commit.  This prevents us from just walking
+ * down the list processing each one.  We'll use a flag in the intent item to
+ * skip those that we've already processed and use the AIL iteration mechanism's
+ * generation count to try to speed this up at least a bit.
  *
- * When we start, we know that the intents are the only things in the
- * AIL.  As we process them, however, other items are added to the
- * AIL.
+ * When we start, we know that the intents are the only things in the AIL. As we
+ * process them, however, other items are added to the AIL. Hence we know we
+ * have started recovery on all the pending intents when we find an non-intent
+ * item in the AIL.
  */
 STATIC int
 xlog_recover_process_intents(
@@ -2556,17 +2557,8 @@ xlog_recover_process_intents(
 	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	     lip != NULL;
 	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
-		/*
-		 * We're done when we see something other than an intent.
-		 * There should be no intents left in the AIL now.
-		 */
-		if (!xlog_item_is_intent(lip)) {
-#ifdef DEBUG
-			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
-				ASSERT(!xlog_item_is_intent(lip));
-#endif
+		if (!xlog_item_is_intent(lip))
 			break;
-		}
 
 		/*
 		 * We should never see a redo item with a LSN higher than
@@ -2607,8 +2599,9 @@ xlog_recover_process_intents(
 }
 
 /*
- * A cancel occurs when the mount has failed and we're bailing out.
- * Release all pending log intent items so they don't pin the AIL.
+ * A cancel occurs when the mount has failed and we're bailing out.  Release all
+ * pending log intent items that we haven't started recovery on so they don't
+ * pin the AIL.
  */
 STATIC void
 xlog_recover_cancel_intents(
@@ -2622,17 +2615,8 @@ xlog_recover_cancel_intents(
 	spin_lock(&ailp->ail_lock);
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	while (lip != NULL) {
-		/*
-		 * We're done when we see something other than an intent.
-		 * There should be no intents left in the AIL now.
-		 */
-		if (!xlog_item_is_intent(lip)) {
-#ifdef DEBUG
-			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
-				ASSERT(!xlog_item_is_intent(lip));
-#endif
+		if (!xlog_item_is_intent(lip))
 			break;
-		}
 
 		spin_unlock(&ailp->ail_lock);
 		lip->li_ops->iop_release(lip);
-- 
2.35.1

