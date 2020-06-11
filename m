Return-Path: <SRS0=ihlG=7Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CEA3C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 01:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E0262072F
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 01:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFKBij (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 21:38:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5875 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726163AbgFKBij (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jun 2020 21:38:39 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1F0512A4472B092BA99A;
        Thu, 11 Jun 2020 09:38:37 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Thu, 11 Jun 2020
 09:38:26 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <darrick.wong@oracle.com>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>
Subject: [RFC PATCH] fix use after free in xlog_wait()
Date:   Thu, 11 Jun 2020 09:39:52 +0800
Message-ID: <20200611013952.2589997-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I recently got UAF by running generic/019 in qemu:

==================================================================
  BUG: KASAN: use-after-free in __lock_acquire+0x4508/0x68c0
  Read of size 8 at addr ffff88811327f080 by task fio/11147

  CPU: 6 PID: 11147 Comm: fio Tainted: G        W         5.7.0-next-20200602+ #8
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
  Call Trace:
   dump_stack+0xf6/0x16e
   ? __lock_acquire+0x4508/0x68c0
   ? __lock_acquire+0x4508/0x68c0
   print_address_description.constprop.0+0x1a/0x210
   ? __lock_acquire+0x4508/0x68c0
   kasan_report.cold+0x1f/0x37
   ? lockdep_hardirqs_on_prepare+0x480/0x550
   ? __lock_acquire+0x4508/0x68c0
   __lock_acquire+0x4508/0x68c0
   ? print_usage_bug+0x1f0/0x1f0
   ? finish_task_switch+0x126/0x5e0
   ? lockdep_hardirqs_on_prepare+0x550/0x550
   ? mark_held_locks+0x9e/0xe0
   ? __schedule+0x801/0x1d90
   ? _raw_spin_unlock_irq+0x1f/0x30
   lock_acquire+0x182/0x790
   ? remove_wait_queue+0x1d/0x180
   ? __switch_to_asm+0x42/0x70
   ? lock_release+0x710/0x710
   ? __schedule+0x85c/0x1d90
   ? xfs_log_commit_cil+0x1d8e/0x2a50
   ? __sched_text_start+0x8/0x8
   _raw_spin_lock_irqsave+0x32/0x50
   ? remove_wait_queue+0x1d/0x180
   remove_wait_queue+0x1d/0x180
   xfs_log_commit_cil+0x1d9e/0x2a50
   ? xlog_cil_empty+0x90/0x90
   ? wake_up_q+0x140/0x140
   ? rcu_read_lock_sched_held+0x9c/0xd0
   ? rcu_read_lock_bh_held+0xb0/0xb0
   __xfs_trans_commit+0x292/0xec0
   ? xfs_trans_unreserve_and_mod_sb+0xab0/0xab0
   ? rcu_read_lock_bh_held+0xb0/0xb0
   ? xfs_isilocked+0x87/0x2e0
   ? xfs_trans_log_inode+0x1ad/0x480
   xfs_vn_update_time+0x3eb/0x6d0
   ? xfs_setattr_mode.isra.0+0xa0/0xa0
   ? current_time+0xa8/0x110
   ? timestamp_truncate+0x2f0/0x2f0
   ? xfs_setattr_mode.isra.0+0xa0/0xa0
   update_time+0x70/0xc0
   file_update_time+0x2b7/0x490
   ? update_time+0xc0/0xc0
   ? __sb_start_write+0x197/0x3e0
   __xfs_filemap_fault.constprop.0+0x1b7/0x480
   do_page_mkwrite+0x1ac/0x470
   do_wp_page+0x9e2/0x1b10
   ? do_raw_spin_lock+0x121/0x290
   ? finish_mkwrite_fault+0x4a0/0x4a0
   ? rwlock_bug.part.0+0x90/0x90
   ? handle_mm_fault+0xa81/0x3570
   handle_mm_fault+0x1c65/0x3570
   ? __pmd_alloc+0x4c0/0x4c0
   ? vmacache_find+0x55/0x2a0
   do_user_addr_fault+0x635/0xd42
   exc_page_fault+0xdd/0x5b0
   ? asm_common_interrupt+0x8/0x40
   ? asm_exc_page_fault+0x8/0x30
   asm_exc_page_fault+0x1e/0x30
  RIP: 0033:0x7f40e022336a
  Code: Bad RIP value.
  RSP: 002b:00007ffedefb0218 EFLAGS: 00010206
  RAX: 00007f40b7a5a000 RBX: 0000000002562280 RCX: 00000000025633d0
  RDX: 0000000000000fc0 RSI: 0000000002562420 RDI: 00007f40b7a5a000
  RBP: 00007f40b8620190 R08: 0000000000000000 R09: 00007f40b7a5aff0
  R10: 00007ffedeff8000 R11: 00007f40b7a5aff0 R12: 0000000000000001
  R13: 0000000000001000 R14: 00000000025622a8 R15: 00007f40b8620198

  Allocated by task 6826:
   save_stack+0x1b/0x40
   __kasan_kmalloc.constprop.0+0xc2/0xd0
   kmem_alloc+0x154/0x450
   xlog_cil_push_work+0xff/0x1250
   process_one_work+0xa3e/0x17a0
   worker_thread+0x8e2/0x1050
   kthread+0x355/0x470
   ret_from_fork+0x22/0x30

   Freed by task 6826:
   save_stack+0x1b/0x40
   __kasan_slab_free+0x12c/0x170
   kfree+0xd6/0x300
   kvfree+0x42/0x50
   xlog_cil_committed+0xa9c/0xf30
   xlog_cil_push_work+0xa8c/0x1250
   process_one_work+0xa3e/0x17a0
   worker_thread+0x8e2/0x1050
   kthread+0x355/0x470
   ret_from_fork+0x22/0x30

  The buggy address belongs to the object at ffff88811327f000
   which belongs to the cache kmalloc-256 of size 256
  The buggy address is located 128 bytes inside of
   256-byte region [ffff88811327f000, ffff88811327f100)
  The buggy address belongs to the page:
  page:ffffea00044c9f00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea00044c9f00 order:2 compound_mapcount:0 compound_pincount:0
  flags: 0x200000000010200(slab|head)
  raw: 0200000000010200 dead000000000100 dead000000000122 ffff88811a40e800
  raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
  page dumped because: kasan: bad access detected

  Memory state around the buggy address:
   ffff88811327ef80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffff88811327f000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  >ffff88811327f080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                     ^
   ffff88811327f100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffff88811327f180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ==================================================================

I think the reason is that when 'ctx' is freed in xlog_cil_committed(),
a previous call to xlog_wait(&ctx->xc_ctx->push_wait, ...) hasn't finished
yet. Thus when remove_wait_queue() is called, UAF will be triggered
since 'ctx' was freed:

thread1		    thread2             thread3

__xfs_trans_commit
 xfs_log_commit_cil
  xlog_wait
   schedule
                    xlog_cil_push_work
		     wake_up_all
		                        xlog_cil_committed
					 kmem_free
   remove_wait_queue
    spin_lock_irqsave --> UAF

I tried to fix the problem by using autoremove_wake_function() in
xlog_wait(), however, soft lockup will be triggered this way.

Instead, make sure waitqueue_active(&ctx->push_wait) return false before
freeing 'ctx'.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 fs/xfs/xfs_log_cil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b43f0e8f43f2..59b21485b0fc 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -607,7 +607,7 @@ xlog_cil_committed(
 
 	if (!list_empty(&ctx->busy_extents))
 		xlog_discard_busy_extents(mp, ctx);
-	else
+	else if (!waitqueue_active(&ctx->push_wait))
 		kmem_free(ctx);
 }
 
-- 
2.25.4

