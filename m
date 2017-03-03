Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751310AbdCCOqx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2017 09:46:53 -0500
From: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] xfs: clear XBF_ASYNC if we attach an iodone callback
Date: Fri, 3 Mar 2017 09:46:44 -0500
Message-ID: <1488552404-21379-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, kernel-team@fb.com

While testing nbd disconnects I kept hitting the following hang

Call Trace:
 schedule+0x35/0x80
 xfs_ail_push_all_sync+0xa3/0xe0
 ? prepare_to_wait_event+0x100/0x100
 xfs_unmountfs+0x57/0x190
 xfs_fs_put_super+0x32/0x90
 generic_shutdown_super+0x6f/0xf0
 kill_block_super+0x27/0x70
 deactivate_locked_super+0x3e/0x70
 deactivate_super+0x46/0x60
 cleanup_mnt+0x3f/0x80
 __cleanup_mnt+0x12/0x20
 task_work_run+0x86/0xb0
 exit_to_usermode_loop+0x6d/0x96
 do_syscall_64+0x8b/0xa0
 entry_SYSCALL64_slow_path+0x25/0x25

After some digging around I found that there was a log item on the ail
with a callback of xfs_iflush_done.  A printk confirmed that at the call
to xfs_buf_attach_iodone in xfs_iflush_int had XBF_ASYNC already set,
which means on error we do not call xfs_buf_do_callbacks, which leaves
the log item on the ail list which causes us to hang on unmount.  I
assume the block has XBF_ASYNC set because we did a readahead on it, so
it doesn't really need to have XBF_ASYNC set at this point as we do
actually care about what happens to the buffer once IO is complete.
With this patch my hang no longer happens.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/xfs/xfs_buf_item.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 2975cb2..24fcb67 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1016,6 +1016,11 @@ xfs_buf_attach_iodone(
 
 	ASSERT(bp->b_iodone == NULL ||
 	       bp->b_iodone == xfs_buf_iodone_callbacks);
+	/*
+	 * Somebody now cares about the fate of this buffer, clear XBF_ASYNC so
+	 * that the iodone callback actually gets called.
+	 */
+	bp->b_flags &= ~XBF_ASYNC;
 	bp->b_iodone = xfs_buf_iodone_callbacks;
 }
 
-- 
2.5.5

