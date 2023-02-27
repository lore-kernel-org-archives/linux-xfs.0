Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E946C64ED6
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Feb 2023 06:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjB0GHC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Feb 2023 01:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjB0GGw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2023 01:06:52 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49066F758
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2023 22:06:32 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PQ93N2pW9zrS2G;
        Mon, 27 Feb 2023 14:05:52 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Mon, 27 Feb
 2023 14:06:28 +0800
Date:   Mon, 27 Feb 2023 14:29:52 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>
CC:     <david@fromorbit.com>, <linux-xfs@vger.kernel.org>,
        <houtao1@huawei.com>, <yi.zhang@huawei.com>, <guoxuenan@huawei.com>
Subject: [PATCH v2] xfs: fix hung when transaction commit fail in
 xfs_inactive_ifree
Message-ID: <20230227062952.GA53788@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After running unplug disk test and unmount filesystem, the umount thread
hung all the time.

 crash> dmesg
 sd 0:0:0:0: rejecting I/O to offline device
 XFS (sda): log I/O error -5
 XFS (sda): Corruption of in-memory data (0x8) detected at xfs_defer_finish_noroll+0x12e0/0x1cf0
	(fs/xfs/libxfs/xfs_defer.c:504).  Shutting down filesystem.
 XFS (sda): Please unmount the filesystem and rectify the problem(s)
 XFS (sda): xfs_inactive_ifree: xfs_trans_commit returned error -5
 XFS (sda): Unmounting Filesystem

 crash> bt 3368
 PID: 3368   TASK: ffff88801bcd8040  CPU: 3   COMMAND: "umount"
  #0 [ffffc900086a7ae0] __schedule at ffffffff83d3fd25
  #1 [ffffc900086a7be8] schedule at ffffffff83d414dd
  #2 [ffffc900086a7c10] xfs_ail_push_all_sync at ffffffff8256db24
  #3 [ffffc900086a7d18] xfs_unmount_flush_inodes at ffffffff824ee7e2
  #4 [ffffc900086a7d28] xfs_unmountfs at ffffffff824f2eff
  #5 [ffffc900086a7da8] xfs_fs_put_super at ffffffff82503e69
  #6 [ffffc900086a7de8] generic_shutdown_super at ffffffff81aeb8cd
  #7 [ffffc900086a7e10] kill_block_super at ffffffff81aefcfa
  #8 [ffffc900086a7e30] deactivate_locked_super at ffffffff81aeb2da
  #9 [ffffc900086a7e48] deactivate_super at ffffffff81aeb639
 #10 [ffffc900086a7e68] cleanup_mnt at ffffffff81b6ddd5
 #11 [ffffc900086a7ea0] __cleanup_mnt at ffffffff81b6dfdf
 #12 [ffffc900086a7eb0] task_work_run at ffffffff8126e5cf
 #13 [ffffc900086a7ef8] exit_to_user_mode_prepare at ffffffff813fa136
 #14 [ffffc900086a7f28] syscall_exit_to_user_mode at ffffffff83d25dbb
 #15 [ffffc900086a7f40] do_syscall_64 at ffffffff83d1f8d9
 #16 [ffffc900086a7f50] entry_SYSCALL_64_after_hwframe at ffffffff83e00085

When we free a cluster buffer from xfs_ifree_cluster, all the inodes in
cache are marked XFS_ISTALE. On journal commit dirty stale inodes as are
handled by both buffer and inode log items, inodes marked as XFS_ISTALE
in AIL will be removed from the AIL because the buffer log item will clean
it. If the transaction commit fails in the xfs_inactive_ifree(), inodes
marked as XFS_ISTALE will be left in AIL due to buf log item is not
committed, this will cause the unmount thread above to be blocked all the
time. Abort inodes flushing associated with the buffer that is stale when
buf item release, prevent inode item left in AIL and can not being pushed.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_buf_item.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index df7322ed73fa..825e638d1088 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -659,14 +659,16 @@ xfs_buf_item_release(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_inode_log_item *iip;
+	struct xfs_log_item     *lp, *n;
 	bool			released;
 	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
 	bool			stale = bip->bli_flags & XFS_BLI_STALE;
+	bool			aborted = test_bit(XFS_LI_ABORTED,
+						   &lip->li_flags);
 #if defined(DEBUG) || defined(XFS_WARN)
 	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
 	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
-	bool			aborted = test_bit(XFS_LI_ABORTED,
-						   &lip->li_flags);
 #endif
 
 	trace_xfs_buf_item_release(bip);
@@ -679,6 +681,19 @@ xfs_buf_item_release(
 	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
 	ASSERT(!stale || (bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
 
+	/*
+	 * If it is an inode buffer and item marked as stale, abort flushing
+	 * inodes associated with the buf, prevent inode item left in AIL.
+	 */
+	if (aborted && (bip->bli_flags & XFS_BLI_STALE_INODE)) {
+		list_for_each_entry_safe(lp, n, &bp->b_li_list, li_bio_list) {
+			iip = (struct xfs_inode_log_item *)lp;
+
+			if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE))
+				xfs_iflush_abort(iip->ili_inode);
+		}
+	}
+
 	/*
 	 * Clear the buffer's association with this transaction and
 	 * per-transaction state from the bli, which has been copied above.
-- 
2.31.1

