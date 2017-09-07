Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5569 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752276AbdIGIAN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 04:00:13 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] xfs: check kthread_should_stop() after the setting of task state
Date: Thu, 7 Sep 2017 16:04:57 +0800
Message-ID: <1504771497-44154-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, bfoster@redhat.com

A umount hang is possible when a race occurs between the umount
process and the xfsaild kthread. The following sequences outline
the race:

    xfsaild: kthread_should_stop()
	     => return false, so xfsaild continue

    umount: set_bit(KTHREAD_SHOULD_STOP, &kthread->flags)
	    => by kthread_stop()
    umount: wake_up_process()
	    => because xfsaild is still running, so 0 is returned

    xfsaild: __set_current_state(TASK_INTERRUPTIBLE)
    xfsaild: schedule()
	    => now, xfsaild will wait indefinitely

    umount: wait_for_completion()
	    => and umount will hang

To fix that, we need to check kthread_should_stop() after we set
the task state, so the xfsaild will either see the stop bit and
exit or the task state is reset to runnable by wake_up_process()
such that it isn't blocked indefinitely and detects the stop bit
at the next iteration.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_trans_ail.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 9056c0f..cd6e185 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -499,11 +499,22 @@ xfsaild(
 	current->flags |= PF_MEMALLOC;
 	set_freezable();
 
-	while (!kthread_should_stop()) {
+	while (1) {
 		if (tout && tout <= 20)
-			__set_current_state(TASK_KILLABLE);
+			set_current_state(TASK_KILLABLE);
 		else
-			__set_current_state(TASK_INTERRUPTIBLE);
+			set_current_state(TASK_INTERRUPTIBLE);
+
+		/*
+		 * Check kthread_should_stop() after we set the task state
+		 * to guarantee that we either see the stop bit and exit or the
+		 * task state is reset to runnable such that it's not blocked
+		 * indefinitely and detects the stop bit at the next iteration.
+		 */
+		if (kthread_should_stop()) {
+			__set_current_state(TASK_RUNNING);
+			break;
+		}
 
 		spin_lock(&ailp->xa_lock);
 
-- 
2.5.0

