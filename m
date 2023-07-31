Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9955BC001DE
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jul 2023 12:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjGaMuZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jul 2023 08:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjGaMuY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2023 08:50:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDFF10FB
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jul 2023 05:50:22 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RDyjq5YRmzrS4b;
        Mon, 31 Jul 2023 20:49:19 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 20:50:19 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>, <david@fromorbit.com>
CC:     <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <leo.lilong@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH v3 2/3] xfs: abort intent items when recovery intents fail
Date:   Mon, 31 Jul 2023 20:46:18 +0800
Message-ID: <20230731124619.3925403-3-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230731124619.3925403-1-leo.lilong@huawei.com>
References: <20230731124619.3925403-1-leo.lilong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When recovering intents, we capture newly created intent items as part of
committing recovered intent items.  If intent recovery fails at a later
point, we forget to remove those newly created intent items from the AIL
and hang:

    [root@localhost ~]# cat /proc/539/stack
    [<0>] xfs_ail_push_all_sync+0x174/0x230
    [<0>] xfs_unmount_flush_inodes+0x8d/0xd0
    [<0>] xfs_mountfs+0x15f7/0x1e70
    [<0>] xfs_fs_fill_super+0x10ec/0x1b20
    [<0>] get_tree_bdev+0x3c8/0x730
    [<0>] vfs_get_tree+0x89/0x2c0
    [<0>] path_mount+0xecf/0x1800
    [<0>] do_mount+0xf3/0x110
    [<0>] __x64_sys_mount+0x154/0x1f0
    [<0>] do_syscall_64+0x39/0x80
    [<0>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

When newly created intent items fail to commit via transaction, intent
recovery hasn't created done items for these newly created intent items,
so the capture structure is the sole owner of the captured intent items.
We must release them explicitly or else they leak:

unreferenced object 0xffff888016719108 (size 432):
  comm "mount", pid 529, jiffies 4294706839 (age 144.463s)
  hex dump (first 32 bytes):
    08 91 71 16 80 88 ff ff 08 91 71 16 80 88 ff ff  ..q.......q.....
    18 91 71 16 80 88 ff ff 18 91 71 16 80 88 ff ff  ..q.......q.....
  backtrace:
    [<ffffffff8230c68f>] xfs_efi_init+0x18f/0x1d0
    [<ffffffff8230c720>] xfs_extent_free_create_intent+0x50/0x150
    [<ffffffff821b671a>] xfs_defer_create_intents+0x16a/0x340
    [<ffffffff821bac3e>] xfs_defer_ops_capture_and_commit+0x8e/0xad0
    [<ffffffff82322bb9>] xfs_cui_item_recover+0x819/0x980
    [<ffffffff823289b6>] xlog_recover_process_intents+0x246/0xb70
    [<ffffffff8233249a>] xlog_recover_finish+0x8a/0x9a0
    [<ffffffff822eeafb>] xfs_log_mount_finish+0x2bb/0x4a0
    [<ffffffff822c0f4f>] xfs_mountfs+0x14bf/0x1e70
    [<ffffffff822d1f80>] xfs_fs_fill_super+0x10d0/0x1b20
    [<ffffffff81a21fa2>] get_tree_bdev+0x3d2/0x6d0
    [<ffffffff81a1ee09>] vfs_get_tree+0x89/0x2c0
    [<ffffffff81a9f35f>] path_mount+0xecf/0x1800
    [<ffffffff81a9fd83>] do_mount+0xf3/0x110
    [<ffffffff81aa00e4>] __x64_sys_mount+0x154/0x1f0
    [<ffffffff83968739>] do_syscall_64+0x39/0x80

Fix the problem above by abort intent items that don't have a done item
when recovery intents fail.

Fixes: e6fff81e4870 ("xfs: proper replay of deferred ops queued during log recovery")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 5 +++--
 fs/xfs/libxfs/xfs_defer.h | 2 +-
 fs/xfs/xfs_log_recover.c  | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 88388e12f8e7..f71679ce23b9 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -763,12 +763,13 @@ xfs_defer_ops_capture(
 
 /* Release all resources that we used to capture deferred ops. */
 void
-xfs_defer_ops_capture_free(
+xfs_defer_ops_capture_abort(
 	struct xfs_mount		*mp,
 	struct xfs_defer_capture	*dfc)
 {
 	unsigned short			i;
 
+	xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
 
 	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
@@ -809,7 +810,7 @@ xfs_defer_ops_capture_and_commit(
 	/* Commit the transaction and add the capture structure to the list. */
 	error = xfs_trans_commit(tp);
 	if (error) {
-		xfs_defer_ops_capture_free(mp, dfc);
+		xfs_defer_ops_capture_abort(mp, dfc);
 		return error;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..8788ad5f6a73 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -121,7 +121,7 @@ int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
 		struct list_head *capture_list);
 void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
 		struct xfs_defer_resources *dres);
-void xfs_defer_ops_capture_free(struct xfs_mount *mp,
+void xfs_defer_ops_capture_abort(struct xfs_mount *mp,
 		struct xfs_defer_capture *d);
 void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 82c81d20459d..fdaa0ffe029b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2511,7 +2511,7 @@ xlog_abort_defer_ops(
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
 		list_del_init(&dfc->dfc_list);
-		xfs_defer_ops_capture_free(mp, dfc);
+		xfs_defer_ops_capture_abort(mp, dfc);
 	}
 }
 
-- 
2.31.1

