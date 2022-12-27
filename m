Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D006C10F1B
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Dec 2022 07:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiL0HgD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Dec 2022 02:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiL0HgC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Dec 2022 02:36:02 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC4ABBB
        for <linux-xfs@vger.kernel.org>; Mon, 26 Dec 2022 23:35:59 -0800 (PST)
Received: from dggpemm500014.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Nh5tk6zYmzqTH9;
        Tue, 27 Dec 2022 15:31:26 +0800 (CST)
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 27 Dec 2022 15:35:57 +0800
Message-ID: <ef8a958d-741f-5bfd-7b2f-db65bf6dc3ac@huawei.com>
Date:   Tue, 27 Dec 2022 15:35:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
From:   Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH V2] xfs: Fix deadlock on xfs_inodegc_worker
To:     Dave Chinner <david@fromorbit.com>, <djwong@kernel.org>
CC:     <guoxuenan@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We are doing a test about deleting a large number of files
when memory is low. A deadlock problem was found.

[ 1240.279183] -> #1 (fs_reclaim){+.+.}-{0:0}:
[ 1240.280450]        lock_acquire+0x197/0x460
[ 1240.281548]        fs_reclaim_acquire.part.0+0x20/0x30
[ 1240.282625]        kmem_cache_alloc+0x2b/0x940
[ 1240.283816]        xfs_trans_alloc+0x8a/0x8b0
[ 1240.284757]        xfs_inactive_ifree+0xe4/0x4e0
[ 1240.285935]        xfs_inactive+0x4e9/0x8a0
[ 1240.286836]        xfs_inodegc_worker+0x160/0x5e0
[ 1240.287969]        process_one_work+0xa19/0x16b0
[ 1240.289030]        worker_thread+0x9e/0x1050
[ 1240.290131]        kthread+0x34f/0x460
[ 1240.290999]        ret_from_fork+0x22/0x30
[ 1240.291905]
[ 1240.291905] -> #0 ((work_completion)(&gc->work)){+.+.}-{0:0}:
[ 1240.293569]        check_prev_add+0x160/0x2490
[ 1240.294473]        __lock_acquire+0x2c4d/0x5160
[ 1240.295544]        lock_acquire+0x197/0x460
[ 1240.296403]        __flush_work+0x6bc/0xa20
[ 1240.297522]        xfs_inode_mark_reclaimable+0x6f0/0xdc0
[ 1240.298649]        destroy_inode+0xc6/0x1b0
[ 1240.299677]        dispose_list+0xe1/0x1d0
[ 1240.300567]        prune_icache_sb+0xec/0x150
[ 1240.301794]        super_cache_scan+0x2c9/0x480
[ 1240.302776]        do_shrink_slab+0x3f0/0xaa0
[ 1240.303671]        shrink_slab+0x170/0x660
[ 1240.304601]        shrink_node+0x7f7/0x1df0
[ 1240.305515]        balance_pgdat+0x766/0xf50
[ 1240.306657]        kswapd+0x5bd/0xd20
[ 1240.307551]        kthread+0x34f/0x460
[ 1240.308346]        ret_from_fork+0x22/0x30
[ 1240.309247]
[ 1240.309247] other info that might help us debug this:
[ 1240.309247]
[ 1240.310944]  Possible unsafe locking scenario:
[ 1240.310944]
[ 1240.312379]        CPU0                    CPU1
[ 1240.313363]        ----                    ----
[ 1240.314433]   lock(fs_reclaim);
[ 1240.315107]                                lock((work_completion)(&gc->work));
[ 1240.316828]                                lock(fs_reclaim);
[ 1240.318088]   lock((work_completion)(&gc->work));
[ 1240.319203]
[ 1240.319203]  *** DEADLOCK ***
...
[ 2438.431081] Workqueue: xfs-inodegc/sda xfs_inodegc_worker
[ 2438.432089] Call Trace:
[ 2438.432562]  __schedule+0xa94/0x1d20
[ 2438.435787]  schedule+0xbf/0x270
[ 2438.436397]  schedule_timeout+0x6f8/0x8b0
[ 2438.445126]  wait_for_completion+0x163/0x260
[ 2438.448610]  __flush_work+0x4c4/0xa40
[ 2438.455011]  xfs_inode_mark_reclaimable+0x6ef/0xda0
[ 2438.456695]  destroy_inode+0xc6/0x1b0
[ 2438.457375]  dispose_list+0xe1/0x1d0
[ 2438.458834]  prune_icache_sb+0xe8/0x150
[ 2438.461181]  super_cache_scan+0x2b3/0x470
[ 2438.461950]  do_shrink_slab+0x3cf/0xa50
[ 2438.462687]  shrink_slab+0x17d/0x660
[ 2438.466392]  shrink_node+0x87e/0x1d40
[ 2438.467894]  do_try_to_free_pages+0x364/0x1300
[ 2438.471188]  try_to_free_pages+0x26c/0x5b0
[ 2438.473567]  __alloc_pages_slowpath.constprop.136+0x7aa/0x2100
[ 2438.482577]  __alloc_pages+0x5db/0x710
[ 2438.485231]  alloc_pages+0x100/0x200
[ 2438.485923]  allocate_slab+0x2c0/0x380
[ 2438.486623]  ___slab_alloc+0x41f/0x690
[ 2438.490254]  __slab_alloc+0x54/0x70
[ 2438.491692]  kmem_cache_alloc+0x23e/0x270
[ 2438.492437]  xfs_trans_alloc+0x88/0x880
[ 2438.493168]  xfs_inactive_ifree+0xe2/0x4e0
[ 2438.496419]  xfs_inactive+0x4eb/0x8b0
[ 2438.497123]  xfs_inodegc_worker+0x16b/0x5e0
[ 2438.497918]  process_one_work+0xbf7/0x1a20
[ 2438.500316]  worker_thread+0x8c/0x1060
[ 2438.504938]  ret_from_fork+0x22/0x30

When the memory is insufficient, xfs_inonodegc_worker will trigger memory
reclamation when memory is allocated, then flush_work() may be called to
wait for the work to complete. This causes a deadlock.

So use memalloc_nofs_save() to avoid triggering memory reclamation in
xfs_inodegc_worker.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
v2:
- use memalloc_nofs_save() to avoid triggering memory reclamation

 fs/xfs/xfs_icache.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f35e2cee5265..ddeaccc04aec 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1853,12 +1853,20 @@ xfs_inodegc_worker(
                                                struct xfs_inodegc, work);
        struct llist_node       *node = llist_del_all(&gc->list);
        struct xfs_inode        *ip, *n;
+       unsigned int            nofs_flag;

        WRITE_ONCE(gc->items, 0);

        if (!node)
                return;

+       /*
+        * We can allocate memory here while doing writeback on behalf of
+        * memory reclaim.  To avoid memory allocation deadlocks set the
+        * task-wide nofs context for the following operations.
+        */
+       nofs_flag = memalloc_nofs_save();
+
        ip = llist_entry(node, struct xfs_inode, i_gclist);
        trace_xfs_inodegc_worker(ip->i_mount, READ_ONCE(gc->shrinker_hits));

@@ -1867,6 +1875,8 @@ xfs_inodegc_worker(
                xfs_iflags_set(ip, XFS_INACTIVATING);
                xfs_inodegc_inactivate(ip);
        }
+
+       memalloc_nofs_restore(nofs_flag);
 }

 /*
--
2.27.0
