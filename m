Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6124C001E0
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jul 2023 12:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbjGaMu1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jul 2023 08:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjGaMu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2023 08:50:26 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E2910E9
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jul 2023 05:50:24 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RDyjt3BBWz1GDFm;
        Mon, 31 Jul 2023 20:49:22 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 20:50:21 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>, <david@fromorbit.com>
CC:     <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <leo.lilong@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH v3 3/3] xfs: fix intent item uaf when recover intents fail
Date:   Mon, 31 Jul 2023 20:46:19 +0800
Message-ID: <20230731124619.3925403-4-leo.lilong@huawei.com>
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

KASAN report a uaf when recover intents fail:

 ==================================================================
 BUG: KASAN: slab-use-after-free in xfs_cui_release+0xb7/0xc0
 Read of size 4 at addr ffff888012575e60 by task kworker/u8:3/103
 CPU: 3 PID: 103 Comm: kworker/u8:3 Not tainted 6.4.0-rc7-next-20230619-00003-g94543a53f9a4-dirty #166
 Workqueue: xfs-cil/sda xlog_cil_push_work
 Call Trace:
  <TASK>
  dump_stack_lvl+0x50/0x70
  print_report+0xc2/0x600
  kasan_report+0xb6/0xe0
  xfs_cui_release+0xb7/0xc0
  xfs_cud_item_release+0x3c/0x90
  xfs_trans_committed_bulk+0x2d5/0x7f0
  xlog_cil_committed+0xaba/0xf20
  xlog_cil_push_work+0x1a60/0x2360
  process_one_work+0x78e/0x1140
  worker_thread+0x58b/0xf60
  kthread+0x2cd/0x3c0
  ret_from_fork+0x1f/0x30
  </TASK>

 Allocated by task 531:
  kasan_save_stack+0x22/0x40
  kasan_set_track+0x25/0x30
  __kasan_slab_alloc+0x55/0x60
  kmem_cache_alloc+0x195/0x5f0
  xfs_cui_init+0x198/0x1d0
  xlog_recover_cui_commit_pass2+0x133/0x5f0
  xlog_recover_items_pass2+0x107/0x230
  xlog_recover_commit_trans+0x3e7/0x9c0
  xlog_recovery_process_trans+0x140/0x1d0
  xlog_recover_process_ophdr+0x1a0/0x3d0
  xlog_recover_process_data+0x108/0x2d0
  xlog_recover_process+0x1f6/0x280
  xlog_do_recovery_pass+0x609/0xdb0
  xlog_do_log_recovery+0x84/0xe0
  xlog_do_recover+0x7d/0x470
  xlog_recover+0x25f/0x490
  xfs_log_mount+0x2dd/0x6f0
  xfs_mountfs+0x11ce/0x1e70
  xfs_fs_fill_super+0x10ec/0x1b20
  get_tree_bdev+0x3c8/0x730
  vfs_get_tree+0x89/0x2c0
  path_mount+0xecf/0x1800
  do_mount+0xf3/0x110
  __x64_sys_mount+0x154/0x1f0
  do_syscall_64+0x39/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

 Freed by task 531:
  kasan_save_stack+0x22/0x40
  kasan_set_track+0x25/0x30
  kasan_save_free_info+0x2b/0x40
  __kasan_slab_free+0x114/0x1b0
  kmem_cache_free+0xf8/0x510
  xfs_cui_item_free+0x95/0xb0
  xfs_cui_release+0x86/0xc0
  xlog_recover_cancel_intents.isra.0+0xf8/0x210
  xlog_recover_finish+0x7e7/0x980
  xfs_log_mount_finish+0x2bb/0x4a0
  xfs_mountfs+0x14bf/0x1e70
  xfs_fs_fill_super+0x10ec/0x1b20
  get_tree_bdev+0x3c8/0x730
  vfs_get_tree+0x89/0x2c0
  path_mount+0xecf/0x1800
  do_mount+0xf3/0x110
  __x64_sys_mount+0x154/0x1f0
  do_syscall_64+0x39/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

 The buggy address belongs to the object at ffff888012575dc8
  which belongs to the cache xfs_cui_item of size 432
 The buggy address is located 152 bytes inside of
  freed 432-byte region [ffff888012575dc8, ffff888012575f78)

 The buggy address belongs to the physical page:
 page:ffffea0000495d00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888012576208 pfn:0x12574
 head:ffffea0000495d00 order:2 entire_mapcount:0 nr_pages_mapped:0 pincount:0
 flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
 page_type: 0xffffffff()
 raw: 001fffff80010200 ffff888012092f40 ffff888014570150 ffff888014570150
 raw: ffff888012576208 00000000001e0010 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff888012575d00: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
  ffff888012575d80: fc fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb
 >ffff888012575e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                        ^
  ffff888012575e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888012575f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc
 ==================================================================

If process intents fails, intent items left in AIL will be delete
from AIL and freed in error handling, even intent items that have been
recovered and created done items. After this, uaf will be triggered when
done item committed, because at this point the released intent item will
be accessed.

xlog_recover_finish                     xlog_cil_push_work
----------------------------            ---------------------------
xlog_recover_process_intents
  xfs_cui_item_recover//cui_refcount == 1
    xfs_trans_get_cud
    xfs_trans_commit
      <add cud item to cil>
  xfs_cui_item_recover
    <error occurred and return>
xlog_recover_cancel_intents
  xfs_cui_release     //cui_refcount == 0
    xfs_cui_item_free //free cui
  <release other intent items>
xlog_force_shutdown   //shutdown
                               <...>
                                        <push items in cil>
                                        xlog_cil_committed
                                          xfs_cud_item_release
                                            xfs_cui_release // UAF

Intent log items are created with a reference count of 2, one for the
creator, and one for the intent done object. Log recovery explicitly
drops the creator reference after it is inserted into the AIL, but it
then processes the log item as if it also owns the intent-done reference.

The code in ->iop_recovery should assume that it passes the reference
to the done intent, we can remove the intent item from the AIL after
creating the done-intent, but if that code fails before creating the
done-intent then it needs to release the intent reference by log recovery
itself.

That way when we go to cancel the intent, the only intents we find in
the AIL are the ones we know have not been processed yet and hence we
can safely drop both the creator and the intent done reference from
xlog_recover_cancel_intents().

Hence if we remove the intent from the list of intents that need to
be recovered after we have done the initial recovery, we acheive two
things:

1. the tail of the log can be moved forward with the commit of the
done intent or new intent to continue the operation, and

2. We avoid the problem of trying to determine how many reference
counts we need to drop from intent recovery cancelling because we
never come across intents we've actually attempted recovery on.

Fixes: 2e76f188fd90 ("xfs: cancel intents immediately if process_intents fails")
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_attr_item.c     | 1 +
 fs/xfs/xfs_bmap_item.c     | 1 +
 fs/xfs/xfs_extfree_item.c  | 1 +
 fs/xfs/xfs_refcount_item.c | 1 +
 fs/xfs/xfs_rmap_item.c     | 1 +
 5 files changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2788a6f2edcd..b74ba5303a96 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -625,6 +625,7 @@ xfs_attri_item_recover(
 
 	args->trans = tp;
 	done_item = xfs_trans_get_attrd(tp, attrip);
+	xfs_trans_ail_delete(lip, 0);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 7551c3ec4ea5..8ce3d336cd31 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -521,6 +521,7 @@ xfs_bui_item_recover(
 		goto err_rele;
 
 	budp = xfs_trans_get_bud(tp, buip);
+	xfs_trans_ail_delete(lip, 0);
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f1a5ecf099aa..1e0a9b82aa8c 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -687,6 +687,7 @@ xfs_efi_item_recover(
 	if (error)
 		return error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
+	xfs_trans_ail_delete(lip, 0);
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		struct xfs_extent_free_item	fake = {
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index edd8587658d5..45f4e04134ff 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -520,6 +520,7 @@ xfs_cui_item_recover(
 		return error;
 
 	cudp = xfs_trans_get_cud(tp, cuip);
+	xfs_trans_ail_delete(lip, 0);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
 		struct xfs_refcount_intent	fake = { };
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 520c7ebdfed8..5a54a5135c33 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -535,6 +535,7 @@ xfs_rui_item_recover(
 	if (error)
 		return error;
 	rudp = xfs_trans_get_rud(tp, ruip);
+	xfs_trans_ail_delete(lip, 0);
 
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
 		struct xfs_rmap_intent	fake = { };
-- 
2.31.1

