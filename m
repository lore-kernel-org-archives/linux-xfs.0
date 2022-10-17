Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190E7C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Oct 2022 22:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiJQWPL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Oct 2022 18:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiJQWO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2022 18:14:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1579A22B25
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 15:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 807736120F
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 22:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DB1C4347C;
        Mon, 17 Oct 2022 22:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666044888;
        bh=+778O6x1Le1bEmlRrsDA1bcwH1WyBB1q6fxHI14GgRA=;
        h=Date:From:To:Cc:Subject:From;
        b=rD+74nJ6Ycanpa2uQdzo5d95msFFXS/ctMKbEagXYEy1EndE1juBEljpK5aUCrufK
         f/Y84zv1RU28xtGSz/XnHbfXiGucIWSOJj+qiq0w93YUo9zX4WhZParZYiegOFPHGv
         0VBcSEeTWwEl/BnFKIJcIuoVBPkPZKHakbydjsyrvRe+WWHl8aC3mAv8TlecbxcUsU
         Jci+3SrAp2sjLEgrT1b3t6nIXdL/aPK9V0BxLP9LAMaa/GJX9i03e/3DoF4h1Mc3y4
         6RhLdiNAqa8tqJrpEVxQEu+XZjKy52gr4Ijo4s/JCqWnR0O/JJnwM+TIFJqdqsGGOn
         g3yVv6Vavc/Bg==
Date:   Mon, 17 Oct 2022 15:14:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: avoid a UAF when log intent item recovery fails
Message-ID: <Y03T2BMdS4membDl@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

KASAN reported a UAF bug when I was running xfs/235:

 BUG: KASAN: use-after-free in xlog_recover_process_intents+0xa77/0xae0 [xfs]
 Read of size 8 at addr ffff88804391b360 by task mount/5680

 CPU: 2 PID: 5680 Comm: mount Not tainted 6.0.0-xfsx #6.0.0 77e7b52a4943a975441e5ac90a5ad7748b7867f6
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x34/0x44
  print_report.cold+0x2cc/0x682
  kasan_report+0xa3/0x120
  xlog_recover_process_intents+0xa77/0xae0 [xfs fb841c7180aad3f8359438576e27867f5795667e]
  xlog_recover_finish+0x7d/0x970 [xfs fb841c7180aad3f8359438576e27867f5795667e]
  xfs_log_mount_finish+0x2d7/0x5d0 [xfs fb841c7180aad3f8359438576e27867f5795667e]
  xfs_mountfs+0x11d4/0x1d10 [xfs fb841c7180aad3f8359438576e27867f5795667e]
  xfs_fs_fill_super+0x13d5/0x1a80 [xfs fb841c7180aad3f8359438576e27867f5795667e]
  get_tree_bdev+0x3da/0x6e0
  vfs_get_tree+0x7d/0x240
  path_mount+0xdd3/0x17d0
  __x64_sys_mount+0x1fa/0x270
  do_syscall_64+0x2b/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
 RIP: 0033:0x7ff5bc069eae
 Code: 48 8b 0d 85 1f 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 52 1f 0f 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffe433fd448 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
 RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff5bc069eae
 RDX: 00005575d7213290 RSI: 00005575d72132d0 RDI: 00005575d72132b0
 RBP: 00005575d7212fd0 R08: 00005575d7213230 R09: 00005575d7213fe0
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 R13: 00005575d7213290 R14: 00005575d72132b0 R15: 00005575d7212fd0
  </TASK>

 Allocated by task 5680:
  kasan_save_stack+0x1e/0x40
  __kasan_slab_alloc+0x66/0x80
  kmem_cache_alloc+0x152/0x320
  xfs_rui_init+0x17a/0x1b0 [xfs]
  xlog_recover_rui_commit_pass2+0xb9/0x2e0 [xfs]
  xlog_recover_items_pass2+0xe9/0x220 [xfs]
  xlog_recover_commit_trans+0x673/0x900 [xfs]
  xlog_recovery_process_trans+0xbe/0x130 [xfs]
  xlog_recover_process_data+0x103/0x2a0 [xfs]
  xlog_do_recovery_pass+0x548/0xc60 [xfs]
  xlog_do_log_recovery+0x62/0xc0 [xfs]
  xlog_do_recover+0x73/0x480 [xfs]
  xlog_recover+0x229/0x460 [xfs]
  xfs_log_mount+0x284/0x640 [xfs]
  xfs_mountfs+0xf8b/0x1d10 [xfs]
  xfs_fs_fill_super+0x13d5/0x1a80 [xfs]
  get_tree_bdev+0x3da/0x6e0
  vfs_get_tree+0x7d/0x240
  path_mount+0xdd3/0x17d0
  __x64_sys_mount+0x1fa/0x270
  do_syscall_64+0x2b/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

 Freed by task 5680:
  kasan_save_stack+0x1e/0x40
  kasan_set_track+0x21/0x30
  kasan_set_free_info+0x20/0x30
  ____kasan_slab_free+0x144/0x1b0
  slab_free_freelist_hook+0xab/0x180
  kmem_cache_free+0x1f1/0x410
  xfs_rud_item_release+0x33/0x80 [xfs]
  xfs_trans_free_items+0xc3/0x220 [xfs]
  xfs_trans_cancel+0x1fa/0x590 [xfs]
  xfs_rui_item_recover+0x913/0xd60 [xfs]
  xlog_recover_process_intents+0x24e/0xae0 [xfs]
  xlog_recover_finish+0x7d/0x970 [xfs]
  xfs_log_mount_finish+0x2d7/0x5d0 [xfs]
  xfs_mountfs+0x11d4/0x1d10 [xfs]
  xfs_fs_fill_super+0x13d5/0x1a80 [xfs]
  get_tree_bdev+0x3da/0x6e0
  vfs_get_tree+0x7d/0x240
  path_mount+0xdd3/0x17d0
  __x64_sys_mount+0x1fa/0x270
  do_syscall_64+0x2b/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

 The buggy address belongs to the object at ffff88804391b300
  which belongs to the cache xfs_rui_item of size 688
 The buggy address is located 96 bytes inside of
  688-byte region [ffff88804391b300, ffff88804391b5b0)

 The buggy address belongs to the physical page:
 page:ffffea00010e4600 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888043919320 pfn:0x43918
 head:ffffea00010e4600 order:2 compound_mapcount:0 compound_pincount:0
 flags: 0x4fff80000010200(slab|head|node=1|zone=1|lastcpupid=0xfff)
 raw: 04fff80000010200 0000000000000000 dead000000000122 ffff88807f0eadc0
 raw: ffff888043919320 0000000080140010 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff88804391b200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88804391b280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 >ffff88804391b300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                        ^
  ffff88804391b380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88804391b400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================

The test fuzzes an rmap btree block and starts writer threads to induce
a filesystem shutdown on the corrupt block.  When the filesystem is
remounted, recovery will try to replay the committed rmap intent item,
but the corruption problem causes the recovery transaction to fail.
Cancelling the transaction frees the RUD, which frees the RUI that we
recovered.

When we return to xlog_recover_process_intents, @lip is now a dangling
pointer, and we cannot use it to find the iop_recover method for the
tracepoint.  Hence we must store the item ops before calling
->iop_recover if we want to give it to the tracepoint so that the trace
data will tell us exactly which intent item failed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_recover.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 17e923b9c5fa..322eb2ee6c55 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2552,6 +2552,8 @@ xlog_recover_process_intents(
 	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	     lip != NULL;
 	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
+		const struct xfs_item_ops	*ops;
+
 		if (!xlog_item_is_intent(lip))
 			break;
 
@@ -2567,13 +2569,17 @@ xlog_recover_process_intents(
 		 * deferred ops, you /must/ attach them to the capture list in
 		 * the recover routine or else those subsequent intents will be
 		 * replayed in the wrong order!
+		 *
+		 * The recovery function can free the log item, so we must not
+		 * access lip after it returns.
 		 */
 		spin_unlock(&ailp->ail_lock);
-		error = lip->li_ops->iop_recover(lip, &capture_list);
+		ops = lip->li_ops;
+		error = ops->iop_recover(lip, &capture_list);
 		spin_lock(&ailp->ail_lock);
 		if (error) {
 			trace_xlog_intent_recovery_failed(log->l_mp, error,
-					lip->li_ops->iop_recover);
+					ops->iop_recover);
 			break;
 		}
 	}
