Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5540 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdIENtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 09:49:23 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: umount XFS hung when stopping the xfsaild kthread
Message-ID: <c869cd34-269b-a13d-5009-390e70aa47ac@huawei.com>
Date: Tue, 5 Sep 2017 21:48:45 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

We recently encounter a XFS umount hang problem. As we can see the following
stacks, the umount process was trying to stop the xfsaild kthread and waiting
for the exit of the xfsaild thread, and the xfsaild thread was waiting for
wake-up.

[<ffffffff810a604a>] kthread_stop+0x4a/0xe0
[<ffffffffa0680317>] xfs_trans_ail_destroy+0x17/0x30 [xfs]
[<ffffffffa067569e>] xfs_log_unmount+0x1e/0x60 [xfs]
[<ffffffffa066ac15>] xfs_unmountfs+0xd5/0x190 [xfs]
[<ffffffffa066da62>] xfs_fs_put_super+0x32/0x90 [xfs]
[<ffffffff811ebad6>] generic_shutdown_super+0x56/0xe0
[<ffffffff811ebf27>] kill_block_super+0x27/0x70
[<ffffffff811ec269>] deactivate_locked_super+0x49/0x60
[<ffffffff811ec866>] deactivate_super+0x46/0x60
[<ffffffff81209995>] mntput_no_expire+0xc5/0x120
[<ffffffff8120aacf>] SyS_umount+0x9f/0x3c0
[<ffffffff81652a09>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

[<ffffffffa067faa7>] xfsaild+0x537/0x5e0 [xfs]
[<ffffffff810a5ddf>] kthread+0xcf/0xe0
[<ffffffff81652958>] ret_from_fork+0x58/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

The kernel version is RHEL7.3 and we are trying to reproduce it (not yet).
I have check the related code and suspect the same problem may also exists in
the mainline.

The following is the possible sequences which may lead to the hang of umount:

xfsaild: kthread_should_stop() // return false, so xfsaild continue

umount: set_bit(KTHREAD_SHOULD_STOP, &kthread->flags) // by kthread_stop()

umount: wake_up_process() // because xfsaild is still running, so 0 is returned

xfsaild: __set_current_state()
xfsaild: schedule() // Now, on one will wake it up

The solution I think is adding an extra kthread_should_stop() before
invoking schedule(). Maybe a smp_mb() is needed too, because we needs to
ensure the read of the stop flag happens after the write of the task status.
Something likes the following patch:

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 9056c0f..6313f67 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -520,6 +520,11 @@ xfsaild(
                if (!xfs_ail_min(ailp) &&
                    ailp->xa_target == ailp->xa_target_prev) {
                        spin_unlock(&ailp->xa_lock);
+
+                       smp_mb();
+                       if (kthread_should_stop())
+                               break;
+
                        freezable_schedule();
                        tout = 0;
                        continue;

Any suggestions ?

Regards,

Tao


