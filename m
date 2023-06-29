Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78DFC001B0
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 13:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjF2NUL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 09:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjF2NUK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 09:20:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45EA30C4
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 06:20:08 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QsJrP5x55zMpjt;
        Thu, 29 Jun 2023 21:16:53 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 21:20:04 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>, <david@fromorbit.com>
CC:     <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <leo.lilong@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH 2/3] xfs: abort intent items when recovery intents fail
Date:   Thu, 29 Jun 2023 21:17:24 +0800
Message-ID: <20230629131725.945004-3-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230629131725.945004-1-leo.lilong@huawei.com>
References: <20230629131725.945004-1-leo.lilong@huawei.com>
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

When recovery intents, it may capture some deferred ops and commit the new
intent items, if recovery intents fails, there will be no done item drop
the reference to the new intent item. New intent items will left in AIL
and caused mount thread hung all the time as fllows:

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

During intent item recover, if transaction that have deferred ops commmit
fails in xfs_defer_ops_capture_and_commit(), defer capture would not added
to capture list, so matching done items would not commit when finish defer
operations, this will cause intent item leaks:

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
---
 fs/xfs/libxfs/xfs_defer.c | 1 +
 fs/xfs/libxfs/xfs_defer.h | 1 +
 fs/xfs/xfs_log_recover.c  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 7ec6812fa625..b2b46d142281 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -809,6 +809,7 @@ xfs_defer_ops_capture_and_commit(
 	/* Commit the transaction and add the capture structure to the list. */
 	error = xfs_trans_commit(tp);
 	if (error) {
+		xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
 		xfs_defer_ops_capture_free(mp, dfc);
 		return error;
 	}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..c3775014f7ab 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -37,6 +37,7 @@ struct xfs_defer_pending {
 	enum xfs_defer_ops_type		dfp_type;
 };
 
+void xfs_defer_pending_abort(struct xfs_mount *mp, struct list_head *dop_list);
 void xfs_defer_add(struct xfs_trans *tp, enum xfs_defer_ops_type type,
 		struct list_head *h);
 int xfs_defer_finish_noroll(struct xfs_trans **tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 82c81d20459d..924beecf07bb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2511,6 +2511,7 @@ xlog_abort_defer_ops(
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
 		list_del_init(&dfc->dfc_list);
+		xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
 		xfs_defer_ops_capture_free(mp, dfc);
 	}
 }
-- 
2.31.1

