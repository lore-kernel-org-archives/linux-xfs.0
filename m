Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C82AEB64DD
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Jul 2023 02:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjGVCTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 22:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjGVCTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 22:19:55 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC8335AB
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 19:19:53 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4R799c6f3rz4f3q3y
        for <linux-xfs@vger.kernel.org>; Sat, 22 Jul 2023 10:19:48 +0800 (CST)
Received: from localhost (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgA30JPEPLtkgGQWOg--.53087S3;
        Sat, 22 Jul 2023 10:19:49 +0800 (CST)
Date:   Sat, 22 Jul 2023 10:16:57 +0800
From:   Long Li <leo.lilong@huaweicloud.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 3/3] xfs: make sure done item committed before cancel
 intents
Message-ID: <20230722021657.GA4108904@ceph-admin>
References: <20230715063647.2094989-1-leo.lilong@huawei.com>
 <20230715063647.2094989-4-leo.lilong@huawei.com>
 <20230719021914.GF11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230719021914.GF11352@frogsfrogsfrogs>
X-CM-TRANSID: gCh0CgA30JPEPLtkgGQWOg--.53087S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuw1Duw1kWry8XF4fZrWUurg_yoWfGF18pr
        ZakFZ7Cr4ktFy8JrsrtFW5JFyxJFWjya1Dtr1vgr1xX3WrAw4YyFyUKFy0gryDWrW09ay2
        vr93JFWDXw15W3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgCb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
        6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
        CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
        0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr
        1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
        vfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: hohrhzxlor0w46kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2023 at 07:19:14PM -0700, Darrick J. Wong wrote:
> On Sat, Jul 15, 2023 at 02:36:47PM +0800, Long Li wrote:
> > KASAN report a uaf when recover intents fails:
> > 
> >  ==================================================================
> >  BUG: KASAN: slab-use-after-free in xfs_cui_release+0xb7/0xc0
> >  Read of size 4 at addr ffff888012575e60 by task kworker/u8:3/103
> >  CPU: 3 PID: 103 Comm: kworker/u8:3 Not tainted 6.4.0-rc7-next-20230619-00003-g94543a53f9a4-dirty #166
> >  Workqueue: xfs-cil/sda xlog_cil_push_work
> >  Call Trace:
> >   <TASK>
> >   dump_stack_lvl+0x50/0x70
> >   print_report+0xc2/0x600
> >   kasan_report+0xb6/0xe0
> >   xfs_cui_release+0xb7/0xc0
> >   xfs_cud_item_release+0x3c/0x90
> >   xfs_trans_committed_bulk+0x2d5/0x7f0
> >   xlog_cil_committed+0xaba/0xf20
> >   xlog_cil_push_work+0x1a60/0x2360
> >   process_one_work+0x78e/0x1140
> >   worker_thread+0x58b/0xf60
> >   kthread+0x2cd/0x3c0
> >   ret_from_fork+0x1f/0x30
> >   </TASK>
> > 
> >  Allocated by task 531:
> >   kasan_save_stack+0x22/0x40
> >   kasan_set_track+0x25/0x30
> >   __kasan_slab_alloc+0x55/0x60
> >   kmem_cache_alloc+0x195/0x5f0
> >   xfs_cui_init+0x198/0x1d0
> >   xlog_recover_cui_commit_pass2+0x133/0x5f0
> >   xlog_recover_items_pass2+0x107/0x230
> >   xlog_recover_commit_trans+0x3e7/0x9c0
> >   xlog_recovery_process_trans+0x140/0x1d0
> >   xlog_recover_process_ophdr+0x1a0/0x3d0
> >   xlog_recover_process_data+0x108/0x2d0
> >   xlog_recover_process+0x1f6/0x280
> >   xlog_do_recovery_pass+0x609/0xdb0
> >   xlog_do_log_recovery+0x84/0xe0
> >   xlog_do_recover+0x7d/0x470
> >   xlog_recover+0x25f/0x490
> >   xfs_log_mount+0x2dd/0x6f0
> >   xfs_mountfs+0x11ce/0x1e70
> >   xfs_fs_fill_super+0x10ec/0x1b20
> >   get_tree_bdev+0x3c8/0x730
> >   vfs_get_tree+0x89/0x2c0
> >   path_mount+0xecf/0x1800
> >   do_mount+0xf3/0x110
> >   __x64_sys_mount+0x154/0x1f0
> >   do_syscall_64+0x39/0x80
> >   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > 
> >  Freed by task 531:
> >   kasan_save_stack+0x22/0x40
> >   kasan_set_track+0x25/0x30
> >   kasan_save_free_info+0x2b/0x40
> >   __kasan_slab_free+0x114/0x1b0
> >   kmem_cache_free+0xf8/0x510
> >   xfs_cui_item_free+0x95/0xb0
> >   xfs_cui_release+0x86/0xc0
> >   xlog_recover_cancel_intents.isra.0+0xf8/0x210
> >   xlog_recover_finish+0x7e7/0x980
> >   xfs_log_mount_finish+0x2bb/0x4a0
> >   xfs_mountfs+0x14bf/0x1e70
> >   xfs_fs_fill_super+0x10ec/0x1b20
> >   get_tree_bdev+0x3c8/0x730
> >   vfs_get_tree+0x89/0x2c0
> >   path_mount+0xecf/0x1800
> >   do_mount+0xf3/0x110
> >   __x64_sys_mount+0x154/0x1f0
> >   do_syscall_64+0x39/0x80
> >   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > 
> >  The buggy address belongs to the object at ffff888012575dc8
> >   which belongs to the cache xfs_cui_item of size 432
> >  The buggy address is located 152 bytes inside of
> >   freed 432-byte region [ffff888012575dc8, ffff888012575f78)
> > 
> >  The buggy address belongs to the physical page:
> >  page:ffffea0000495d00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888012576208 pfn:0x12574
> >  head:ffffea0000495d00 order:2 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> >  flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
> >  page_type: 0xffffffff()
> >  raw: 001fffff80010200 ffff888012092f40 ffff888014570150 ffff888014570150
> >  raw: ffff888012576208 00000000001e0010 00000001ffffffff 0000000000000000
> >  page dumped because: kasan: bad access detected
> > 
> >  Memory state around the buggy address:
> >   ffff888012575d00: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
> >   ffff888012575d80: fc fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb
> >  >ffff888012575e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >                                                         ^
> >   ffff888012575e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >   ffff888012575f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc
> >  ==================================================================
> > 
> > If process intents fails, intent items left in AIL will be delete
> > from AIL and freed in error handling, even intent items that have been
> > recovered and created done items. After this, uaf will be triggered when
> > done item commited, because at this point the released intent item will
> > be accessed.
> > 
> > xlog_recover_finish                     xlog_cil_push_work
> > ----------------------------            ---------------------------
> > xlog_recover_process_intents
> >   xfs_cui_item_recover//cui_refcount == 1
> >     xfs_trans_get_cud
> >     xfs_trans_commit
> >       <add cud item to cil>
> >   xfs_cui_item_recover
> >     <error occurred and return>
> > xlog_recover_cancel_intents
> >   xfs_cui_release     //cui_refcount == 0
> >     xfs_cui_item_free //free cui
> >   <release other intent items>
> > xlog_force_shutdown   //shutdown
> >                                <...>
> >                                         <push items in cil>
> >                                         xlog_cil_committed
> >                                           xfs_cud_item_release
> >                                             xfs_cui_release // UAF
> > 
> > Fix it by move log force forward to make sure done items committed before
> > cancel intents.
> > 
> > Fixes: 2e76f188fd90 ("xfs: cancel intents immediately if process_intents fails")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_log_recover.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index fdaa0ffe029b..c37031e64db5 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -3444,6 +3444,13 @@ xlog_recover_finish(
> >  	int	error;
> >  
> >  	error = xlog_recover_process_intents(log);
> > +	/*
> > +	 * Sync the log to get all the intents that have done item out of
> 
> "...that have intent done items out of the AIL."
> 
> > +	 * the AIL.  This isn't absolutely necessary, but it helps in case
> > +	 * the unlink transactions would have problems pushing the intents
> > +	 * out of the way.
> > +	 */
> > +	xfs_log_force(log->l_mp, XFS_LOG_SYNC);
> 
> Hmm.  Why doesn't the shutdown force the (now dead) dead log items out
> of memory?
> 
> 	/*
> 	 * Flush all the completed transactions to disk before marking the log
> 	 * being shut down. We need to do this first as shutting down the log
> 	 * before the force will prevent the log force from flushing the iclogs
> 	 * to disk.
> 	 *
> 	 * When we are in recovery, there are no transactions to flush, and
> 	 * we don't want to touch the log because we don't want to perturb the
> 	 * current head/tail for future recovery attempts. Hence we need to
> 	 * avoid a log force in this case.
> 	 *
> 	 * If we are shutting down due to a log IO error, then we must avoid
> 	 * trying to write the log as that may just result in more IO errors and
> 	 * an endless shutdown/force loop.
> 	 */
> 	if (!log_error && !xlog_in_recovery(log))
> 		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
> 
> Oh.  We're in recovery, but we've passed the part where we've finished
> with the log/inode/dquot items that we read from the disk.  IOWs, now
> we've gotten to the part of recovery where we're actually standing up
> new transactions to finish the work that was in the intents ... with new
> incore intents.
> 
> I wonder, does the problem go away if you (hackishly)
> clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate); before the
> xlog_force_shutdown?

I used the patch below and tested it to confirm that the uaf problem
goes away.

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 82c81d20459d..5d9f84ce2b9b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3452,9 +3452,10 @@ xlog_recover_finish(
 		 * (inode reclaim does this) before we get around to
 		 * xfs_log_mount_cancel.
 		 */
+		clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
+		xlog_force_shutdown(log, SHUTDOWN_CORRUPT_INCORE);
 		xlog_recover_cancel_intents(log);
 		xfs_alert(log->l_mp, "Failed to recover intents");
-		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 		return error;
 	}
 
I'm wondering if a shutdown with SHUTDOWN_CORRUPT_INCORE is appropriate,
even though there is no log io error at this point.

Best regards
Long Li

> 
> --D
> 
> >  	if (error) {
> >  		/*
> >  		 * Cancel all the unprocessed intent items now so that we don't
> > @@ -3458,13 +3465,6 @@ xlog_recover_finish(
> >  		return error;
> >  	}
> >  
> > -	/*
> > -	 * Sync the log to get all the intents out of the AIL.  This isn't
> > -	 * absolutely necessary, but it helps in case the unlink transactions
> > -	 * would have problems pushing the intents out of the way.
> > -	 */
> > -	xfs_log_force(log->l_mp, XFS_LOG_SYNC);
> > -
> >  	/*
> >  	 * Now that we've recovered the log and all the intents, we can clear
> >  	 * the log incompat feature bits in the superblock because there's no
> > -- 
> > 2.31.1
> > 

