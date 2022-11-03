Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF95C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 08:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiKCIWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 04:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiKCIVu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 04:21:50 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FB563DB
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 01:21:48 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N2xYf4HP3z15MKs;
        Thu,  3 Nov 2022 16:21:42 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500019.china.huawei.com
 (7.221.188.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 16:21:46 +0800
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     <djwong@kernel.org>, <dchinner@redhat.com>
CC:     <linux-xfs@vger.kernel.org>, <guoxuenan@huawei.com>,
        <houtao1@huawei.com>, <jack.qiu@huawei.com>, <fangwei1@huawei.com>,
        <yi.zhang@huawei.com>, <zhengbin13@huawei.com>,
        <leo.lilong@huawei.com>, <zengheng4@huawei.com>
Subject: [PATCH 1/2] xfs: wait xlog ioend workqueue drained before tearing down AIL
Date:   Thu, 3 Nov 2022 16:36:31 +0800
Message-ID: <20221103083632.150458-2-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221103083632.150458-1-guoxuenan@huawei.com>
References: <20221103083632.150458-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix uaf in xfs_trans_ail_delete during xlog force shutdown.
In commit cd6f79d1fb32 ("xfs: run callbacks before waking waiters in
xlog_state_shutdown_callbacks") changed the order of running callbacks
and wait for iclog completion to avoid unmount path untimely destroy AIL.
But which seems not enough to ensue this, adding mdelay in
`xfs_buf_item_unpin` can prove that.

The reproduction is as follows. To ensure destroy AIL safely,
we should wait all xlog ioend workers done and sync the AIL.

==================================================================
BUG: KASAN: use-after-free in xfs_trans_ail_delete+0x240/0x2a0
Read of size 8 at addr ffff888023169400 by task kworker/1:1H/43

CPU: 1 PID: 43 Comm: kworker/1:1H Tainted: G        W
6.1.0-rc1-00002-gc28266863c4a #137
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: xfs-log/sda xlog_ioend_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x4d/0x66
 print_report+0x171/0x4a6
 kasan_report+0xb3/0x130
 xfs_trans_ail_delete+0x240/0x2a0
 xfs_buf_item_done+0x7b/0xa0
 xfs_buf_ioend+0x1e9/0x11f0
 xfs_buf_item_unpin+0x4c8/0x860
 xfs_trans_committed_bulk+0x4c2/0x7c0
 xlog_cil_committed+0xab6/0xfb0
 xlog_cil_process_committed+0x117/0x1e0
 xlog_state_shutdown_callbacks+0x208/0x440
 xlog_force_shutdown+0x1b3/0x3a0
 xlog_ioend_work+0xef/0x1d0
 process_one_work+0x6f9/0xf70
 worker_thread+0x578/0xf30
 kthread+0x28c/0x330
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 9606:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 __kasan_kmalloc+0x7a/0x90
 __kmalloc+0x59/0x140
 kmem_alloc+0xb2/0x2f0
 xfs_trans_ail_init+0x20/0x320
 xfs_log_mount+0x37e/0x690
 xfs_mountfs+0xe36/0x1b40
 xfs_fs_fill_super+0xc5c/0x1a70
 get_tree_bdev+0x3c5/0x6c0
 vfs_get_tree+0x85/0x250
 path_mount+0xec3/0x1830
 do_mount+0xef/0x110
 __x64_sys_mount+0x150/0x1f0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 9662:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x40
 __kasan_slab_free+0x105/0x1a0
 __kmem_cache_free+0x99/0x2d0
 kvfree+0x3a/0x40
 xfs_log_unmount+0x60/0xf0
 xfs_unmountfs+0xf3/0x1d0
 xfs_fs_put_super+0x78/0x300
 generic_shutdown_super+0x151/0x400
 kill_block_super+0x9a/0xe0
 deactivate_locked_super+0x82/0xe0
 deactivate_super+0x91/0xb0
 cleanup_mnt+0x32a/0x4a0
 task_work_run+0x15f/0x240
 exit_to_user_mode_prepare+0x188/0x190
 syscall_exit_to_user_mode+0x12/0x30
 do_syscall_64+0x42/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888023169400
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 0 bytes inside of
 128-byte region [ffff888023169400, ffff888023169480)

The buggy address belongs to the physical page:
page:ffffea00008c5a00 refcount:1 mapcount:0 mapping:0000000000000000
index:0xffff888023168f80 pfn:0x23168
head:ffffea00008c5a00 order:1 compound_mapcount:0 compound_pincount:0
flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 001fffff80010200 ffffea00006b3988 ffffea0000577a88 ffff88800f842ac0
raw: ffff888023168f80 0000000000150007 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888023169300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888023169380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888023169400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888023169480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888023169500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
Disabling lock debugging due to kernel taint

Fixes: cd6f79d1fb32 ("xfs: run callbacks before waking waiters in xlog_state_shutdown_callbacks")
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 fs/xfs/xfs_trans_ail.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index f51df7d94ef7..1054adb29907 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -929,6 +929,9 @@ xfs_trans_ail_destroy(
 {
 	struct xfs_ail	*ailp = mp->m_ail;
 
+	drain_workqueue(mp->m_log->l_ioend_workqueue);
+	xfs_ail_push_all_sync(ailp);
+
 	kthread_stop(ailp->ail_task);
 	kmem_free(ailp);
 }
-- 
2.31.1

