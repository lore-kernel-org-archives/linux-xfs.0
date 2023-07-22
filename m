Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDC4EB64DD
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Jul 2023 03:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjGVDAc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 23:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjGVDAc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 23:00:32 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080CF10F4
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 20:00:29 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R7B2p51QPzVjYP;
        Sat, 22 Jul 2023 10:58:58 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 22 Jul 2023 11:00:25 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>, <david@fromorbit.com>
CC:     <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <leo.lilong@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH v2] xfs: fix a UAF when inode item push
Date:   Sat, 22 Jul 2023 10:57:21 +0800
Message-ID: <20230722025721.312909-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

KASAN reported a UAF bug while fault injection test:

  ==================================================================
  BUG: KASAN: use-after-free in xfs_inode_item_push+0x2db/0x2f0
  Read of size 8 at addr ffff888022f74788 by task xfsaild/sda/479

  CPU: 0 PID: 479 Comm: xfsaild/sda Not tainted 6.2.0-rc7-00003-ga8a43e2eb5f6 #89
  Call Trace:
   <TASK>
   dump_stack_lvl+0x51/0x6a
   print_report+0x171/0x4a6
   kasan_report+0xb7/0x130
   xfs_inode_item_push+0x2db/0x2f0
   xfsaild+0x729/0x1f70
   kthread+0x290/0x340
   ret_from_fork+0x1f/0x30
   </TASK>

  Allocated by task 494:
   kasan_save_stack+0x22/0x40
   kasan_set_track+0x25/0x30
   __kasan_slab_alloc+0x58/0x70
   kmem_cache_alloc+0x197/0x5d0
   xfs_inode_item_init+0x62/0x170
   xfs_trans_ijoin+0x15e/0x240
   xfs_init_new_inode+0x573/0x1820
   xfs_create+0x6a1/0x1020
   xfs_generic_create+0x544/0x5d0
   vfs_mkdir+0x5d0/0x980
   do_mkdirat+0x14e/0x220
   __x64_sys_mkdir+0x6a/0x80
   do_syscall_64+0x39/0x80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

  Freed by task 14:
   kasan_save_stack+0x22/0x40
   kasan_set_track+0x25/0x30
   kasan_save_free_info+0x2e/0x40
   __kasan_slab_free+0x114/0x1b0
   kmem_cache_free+0xee/0x4e0
   xfs_inode_free_callback+0x187/0x2a0
   rcu_do_batch+0x317/0xce0
   rcu_core+0x686/0xa90
   __do_softirq+0x1b6/0x626

  The buggy address belongs to the object at ffff888022f74758
   which belongs to the cache xfs_ili of size 200
  The buggy address is located 48 bytes inside of
   200-byte region [ffff888022f74758, ffff888022f74820)

  The buggy address belongs to the physical page:
  page:ffffea00008bdd00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x22f74
  head:ffffea00008bdd00 order:1 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
  flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
  raw: 001fffff80010200 ffff888010ed4040 ffffea00008b2510 ffffea00008bde10
  raw: 0000000000000000 00000000001a001a 00000001ffffffff 0000000000000000
  page dumped because: kasan: bad access detected

  Memory state around the buggy address:
   ffff888022f74680: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
   ffff888022f74700: fc fc fc fc fc fc fc fc fc fc fc fa fb fb fb fb
  >ffff888022f74780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                        ^
   ffff888022f74800: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
   ffff888022f74880: fc fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ==================================================================

When push inode item in xfsaild, it will race with reclaim inodes task.
Consider the following call graph, both tasks deal with the same inode.
During flushing the cluster, it will enter xfs_iflush_abort() in shutdown
conditions, inode's XFS_IFLUSHING flag will be cleared and lip->li_buf set
to null. Concurrently, inode will be reclaimed in shutdown conditions,
there is no need to wait xfs buf lock because of lip->li_buf is null at
this time, inode will be freed via rcu callback if xfsaild task schedule
out during flushing the cluster. so, it is unsafe to reference lip after
flushing the cluster in xfs_inode_item_push().

			<log item is in AIL>
			<filesystem shutdown>
spin_lock(&ailp->ail_lock)
xfs_inode_item_push(lip)
  xfs_buf_trylock(bp)
  spin_unlock(&lip->li_ailp->ail_lock)
  xfs_iflush_cluster(bp)
    if (xfs_is_shutdown())
      xfs_iflush_abort(ip)
	xfs_trans_ail_delete(ip)
	  spin_lock(&ailp->ail_lock)
	  spin_unlock(&ailp->ail_lock)
	xfs_iflush_abort_clean(ip)
      error = -EIO
			<log item removed from AIL>
			<log item li_buf set to null>
    if (error)
      xfs_force_shutdown()
	xlog_shutdown_wait(mp->m_log)
	  might_sleep()
					xfs_reclaim_inode(ip)
					if (shutdown)
					  xfs_iflush_shutdown_abort(ip)
					    if (!bp)
					      xfs_iflush_abort(ip)
					      return
				        __xfs_inode_free(ip)
					   call_rcu(ip, xfs_inode_free_callback)
			......
			<rcu grace period expires>
			<rcu free callbacks run somewhere>
			  xfs_inode_free_callback(ip)
			    kmem_cache_free(ip->i_itemp)
			......
<starts running again>
    xfs_buf_ioend_fail(bp);
      xfs_buf_ioend(bp)
        xfs_buf_relse(bp);
    return error
spin_lock(&lip->li_ailp->ail_lock)
  <UAF on log item>

Fix the race condition by add XFS_ILOCK_SHARED lock for inode in
xfs_inode_item_push(). The XFS_ILOCK_EXCL lock is held when the inode is
reclaimed, so this prevents the uaf from occurring.

Link: https://patchwork.kernel.org/project/xfs/patch/20230211022941.GA1515023@ceph-admin/
Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
Suggested-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
v2:
 - Correct the description of race condition
 - In the v1 solution, the lip will be accessed after
 xfsaild_push_item(), it's still possible to trigger the uaf, so the 
 solution is modified in v2.

 fs/xfs/xfs_inode_item.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 127b2410eb20..c3897c5417f2 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -711,9 +711,14 @@ xfs_inode_item_push(
 	if (xfs_iflags_test(ip, XFS_IFLUSHING))
 		return XFS_ITEM_FLUSHING;
 
-	if (!xfs_buf_trylock(bp))
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
 		return XFS_ITEM_LOCKED;
 
+	if (!xfs_buf_trylock(bp)) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		return XFS_ITEM_LOCKED;
+	}
+
 	spin_unlock(&lip->li_ailp->ail_lock);
 
 	/*
@@ -739,6 +744,7 @@ xfs_inode_item_push(
 	}
 
 	spin_lock(&lip->li_ailp->ail_lock);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return rval;
 }
 
-- 
2.31.1

