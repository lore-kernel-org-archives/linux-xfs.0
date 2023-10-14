Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C98D3CDB465
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Oct 2023 09:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbjJNJIS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Oct 2023 05:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjJNJIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Oct 2023 05:08:17 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE12BF
        for <linux-xfs@vger.kernel.org>; Sat, 14 Oct 2023 02:08:14 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4S6yFw41TTz4f3kFp
        for <linux-xfs@vger.kernel.org>; Sat, 14 Oct 2023 17:08:04 +0800 (CST)
Received: from localhost (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgAXrt14WiplZnG6Cw--.28914S3;
        Sat, 14 Oct 2023 17:08:09 +0800 (CST)
Date:   Sat, 14 Oct 2023 17:13:04 +0800
From:   Long Li <leo.lilong@huaweicloud.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v3 3/3] xfs: fix intent item uaf when recover intents fail
Message-ID: <20231014091304.GA2867616@ceph-admin>
References: <20230731124619.3925403-1-leo.lilong@huawei.com>
 <20230731124619.3925403-4-leo.lilong@huawei.com>
 <20230824043425.GJ11263@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230824043425.GJ11263@frogsfrogsfrogs>
X-CM-TRANSID: gCh0CgAXrt14WiplZnG6Cw--.28914S3
X-Coremail-Antispam: 1UD129KBjvAXoW3Aw4DWr1ftF4DCFyUur48Zwb_yoW8XF4Duo
        WI93Z3Cr4IkrnxGF1Fkrn3J3sxGr1rG3ZrJF4UKw4jkF93WF1UZa4UXw43X3yayFWrGas3
        Aa4UKayrXFyDXrZ5n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUU5H7kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
        8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7
        CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
        rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
        IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
        bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
        AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
        42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s
        1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnI
        WIevJa73UjIFyTuYvjxUrR6zUUUUU
X-CM-SenderInfo: hohrhzxlor0w46kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 23, 2023 at 09:34:25PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 31, 2023 at 08:46:19PM +0800, Long Li wrote:
> > KASAN report a uaf when recover intents fail:
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
> > done item committed, because at this point the released intent item will
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
> > Intent log items are created with a reference count of 2, one for the
> > creator, and one for the intent done object. Log recovery explicitly
> > drops the creator reference after it is inserted into the AIL, but it
> > then processes the log item as if it also owns the intent-done reference.
> > 
> > The code in ->iop_recovery should assume that it passes the reference
> > to the done intent, we can remove the intent item from the AIL after
> > creating the done-intent, but if that code fails before creating the
> > done-intent then it needs to release the intent reference by log recovery
> > itself.
> > 
> > That way when we go to cancel the intent, the only intents we find in
> > the AIL are the ones we know have not been processed yet and hence we
> > can safely drop both the creator and the intent done reference from
> > xlog_recover_cancel_intents().
> > 
> > Hence if we remove the intent from the list of intents that need to
> > be recovered after we have done the initial recovery, we acheive two
> > things:
> > 
> > 1. the tail of the log can be moved forward with the commit of the
> > done intent or new intent to continue the operation, and
> > 
> > 2. We avoid the problem of trying to determine how many reference
> > counts we need to drop from intent recovery cancelling because we
> > never come across intents we've actually attempted recovery on.
> > 
> > Fixes: 2e76f188fd90 ("xfs: cancel intents immediately if process_intents fails")
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_attr_item.c     | 1 +
> >  fs/xfs/xfs_bmap_item.c     | 1 +
> >  fs/xfs/xfs_extfree_item.c  | 1 +
> >  fs/xfs/xfs_refcount_item.c | 1 +
> >  fs/xfs/xfs_rmap_item.c     | 1 +
> >  5 files changed, 5 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 2788a6f2edcd..b74ba5303a96 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -625,6 +625,7 @@ xfs_attri_item_recover(
> >  
> >  	args->trans = tp;
> >  	done_item = xfs_trans_get_attrd(tp, attrip);
> > +	xfs_trans_ail_delete(lip, 0);

Hi Darrick, 

Thanks for your reply, I apologize for taking so long to reply, I've been
thinking about this problem for a long time. 
> 
> We haven't committed the intent-done item here, how is it safe to remove
> the recovered intent item from the AIL?  Can the log tail move forward
> (over the original intent) but then recovery fails such that the intent
> done item never gets written to the head of the log, and the whole thing
> just disappears from history?

Yes, argee with you, deleting the intent item directly from AIL will cause
the tail lsn to move forward, which will cause problems. So it looks like
removing the intent item from the AIL is not a good option at this time.

> 
> Or, why doesn't the loop body of xlog_recover_process_intents do this:
> 
> 		spin_unlock(&ailp->ail_lock);
> 		ops = lip->li_ops;
> 		error = ops->iop_recover(lip, &capture_list);
> 		if (error) {
> 			/*
> 			 * If iop_recover fails, assume it didn't manage to
> 			 * commit a done item that's attached to lip.
> 			 */
> 			ops->iop_release(lip);
> 		}
> 		spin_lock(&ailp->ail_lock);
> 
> Oh, maybe I should reorient myself with normal operations.
> 
> In the regular runtime code, we create the intent item with 2 refcount,
> and we attach it to the xfs_defer_pending.dfp_intent.  When the AIL
> processes the intent item, it unpins the log item, which releases 1 of
> the refcount for the intent item.
> 
> If we finish the xfs_defer_pending item, the defer ops mechanism creates
> the intent-done item (also with 2 refcount) and effectively transfer the
> 1 remaining refcount of the intent item to the intent-done item.  When
> the intent done item commits, the cil releases the intent done item.
> The intent-done item now has refcount 1 and releases the intent item,
> which is now freed.
> 
> If the defer ops chain gets cancelled before the intent-done item is
> created, the defer ops mechanism itself will abort the intent item.
> This drops the 1 refcount that would have been given to the intent-done
> item; the log drops the other refcount.
> 
> So that's the runtime code.  What about log recovery?
> 
> I guess _process_intents is single-stepping its way through the
> recovered intents in the AIL.  The log item is already committed so
> that's why we drop the recovered item's refcount when we add it to the
> AIL.  Hence we need to be able to handle two failure cases: (a) the case
> where ->iop_recover fails before creating the intent-done item; and (b)
> it fails after creating the intent-done item.
> 
> (b) can be easy because the recovered intent item is released when the
> intent-done item is released.
> 
> (a) is also easy because _process_intents still owns the recovered
> intent item, which means it's still in the AIL, which means that
> _cancel_intents will release it.
> 
> **However**, you don't want (a) to happen if (b) is also going to
> happen.  So that's why it makes sense to delete the recovered intent
> item from the AIL as soon as the intent done item has been added to the
> transaction.

Yes, this is the cause of the problem. _process_intents processes the log
item as if it owns the intent item reference, but when the intent-done
item is created, the reference count is passed to the intent-done item
in ->iop_recovery, Thus _cancel_intents can only release the intent item
for which log recovery holds the reference count.

In the current code, we can't tell if the reference count of an intent
item is held by an intent-done item or not, otherwise we could just
release the intent item whose reference count is held by the log recovery.

We should assume that once the intent-done item is created, the
intent-done item holds the reference count of the intent item, which is
reduced by one when the intent-done item is released. I think it is
possible to add a flag to the intent item to mark if the reference count
of the intent item is held by the intent-done item. 

Example:

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fdaa0ffe029b..6d138aea2e8b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2619,9 +2619,12 @@ xlog_recover_cancel_intents(
 		if (!xlog_item_is_intent(lip))
 			break;
 
-		spin_unlock(&ailp->ail_lock);
-		lip->li_ops->iop_release(lip);
-		spin_lock(&ailp->ail_lock);
+		if (!test_bit(XFS_LI_DONE, &lip->li_flags)) {
+			spin_unlock(&ailp->ail_lock);
+			lip->li_ops->iop_release(lip);
+			spin_lock(&ailp->ail_lock);
+		}
+
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index edd8587658d5..d59bc95712b5 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -206,6 +206,7 @@ xfs_cud_item_release(
 {
 	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
 
+	clear_bit(XFS_LI_DONE, &lip->li_flags);
 	xfs_cui_release(cudp->cud_cuip);
 	kmem_free(cudp->cud_item.li_lv_shadow);
 	kmem_cache_free(xfs_cud_cache, cudp);
@@ -237,6 +238,7 @@ xfs_trans_get_cud(
 	cudp = kmem_cache_zalloc(xfs_cud_cache, GFP_KERNEL | __GFP_NOFAIL);
 	xfs_log_item_init(tp->t_mountp, &cudp->cud_item, XFS_LI_CUD,
 			  &xfs_cud_item_ops);
+	set_bit(XFS_LI_DONE, &cuip->cui_item.li_flags);
 	cudp->cud_cuip = cuip;
 	cudp->cud_format.cud_cui_id = cuip->cui_format.cui_id;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6e3646d524ce..c77cb837ea88 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -58,13 +58,15 @@ struct xfs_log_item {
 #define	XFS_LI_FAILED	2
 #define	XFS_LI_DIRTY	3
 #define	XFS_LI_WHITEOUT	4
+#define	XFS_LI_DONE	5
 
 #define XFS_LI_FLAGS \
 	{ (1u << XFS_LI_IN_AIL),	"IN_AIL" }, \
 	{ (1u << XFS_LI_ABORTED),	"ABORTED" }, \
 	{ (1u << XFS_LI_FAILED),	"FAILED" }, \
 	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
-	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }
+	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }, \
+	{ (1u << XFS_LI_DONE),		"DONE" }
 
 struct xfs_item_ops {
 	unsigned flags;
-- 

Look forward to your advice. :)

Best Regards
Long Li

> 
> How does the following comment strike you?
> 
> 	/*
> 	 * Transfer the sole remaining refcount of the recovered intent
> 	 * item from the AIL list to a newly created intent-done item.
> 	 */
> 	budp = xfs_trans_get_bud(tp, buip);
> 	xfs_trans_ail_delete(lip, 0);
> 
> <-- still not sure he totally gets what's going on here.
> 
> --D
> 
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, ip, 0);
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 7551c3ec4ea5..8ce3d336cd31 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -521,6 +521,7 @@ xfs_bui_item_recover(
> >  		goto err_rele;
> >  
> >  	budp = xfs_trans_get_bud(tp, buip);
> > +	xfs_trans_ail_delete(lip, 0);
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > index f1a5ecf099aa..1e0a9b82aa8c 100644
> > --- a/fs/xfs/xfs_extfree_item.c
> > +++ b/fs/xfs/xfs_extfree_item.c
> > @@ -687,6 +687,7 @@ xfs_efi_item_recover(
> >  	if (error)
> >  		return error;
> >  	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
> > +	xfs_trans_ail_delete(lip, 0);
> >  
> >  	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> >  		struct xfs_extent_free_item	fake = {
> > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > index edd8587658d5..45f4e04134ff 100644
> > --- a/fs/xfs/xfs_refcount_item.c
> > +++ b/fs/xfs/xfs_refcount_item.c
> > @@ -520,6 +520,7 @@ xfs_cui_item_recover(
> >  		return error;
> >  
> >  	cudp = xfs_trans_get_cud(tp, cuip);
> > +	xfs_trans_ail_delete(lip, 0);
> >  
> >  	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
> >  		struct xfs_refcount_intent	fake = { };
> > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > index 520c7ebdfed8..5a54a5135c33 100644
> > --- a/fs/xfs/xfs_rmap_item.c
> > +++ b/fs/xfs/xfs_rmap_item.c
> > @@ -535,6 +535,7 @@ xfs_rui_item_recover(
> >  	if (error)
> >  		return error;
> >  	rudp = xfs_trans_get_rud(tp, ruip);
> > +	xfs_trans_ail_delete(lip, 0);
> >  
> >  	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
> >  		struct xfs_rmap_intent	fake = { };
> > -- 
> > 2.31.1
> > 

