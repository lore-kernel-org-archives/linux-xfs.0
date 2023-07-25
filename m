Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5227EC001E0
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jul 2023 12:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbjGYM23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jul 2023 08:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjGYM22 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2023 08:28:28 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31D61992
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 05:28:26 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4R9GXP64nYz4f400W
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 20:28:21 +0800 (CST)
Received: from localhost (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgBn0LPkv79k3ZAdOw--.46119S3;
        Tue, 25 Jul 2023 20:28:22 +0800 (CST)
Date:   Tue, 25 Jul 2023 20:25:25 +0800
From:   Long Li <leo.lilong@huaweicloud.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Long Li <leo.lilong@huawei.com>, djwong@kernel.org,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com
Subject: Re: [PATCH v2 3/3] xfs: make sure done item committed before cancel
 intents
Message-ID: <20230725122525.GA3607472@ceph-admin>
References: <20230715063647.2094989-1-leo.lilong@huawei.com>
 <20230715063647.2094989-4-leo.lilong@huawei.com>
 <ZLeFpQWSUVmYNJXJ@dread.disaster.area>
 <20230722011909.GA4061995@ceph-admin>
 <ZL3ObF23wET/rT7x@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZL3ObF23wET/rT7x@dread.disaster.area>
X-CM-TRANSID: gCh0CgBn0LPkv79k3ZAdOw--.46119S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuFyDWr4rZF15tFWkuFyfJFb_yoW7Xw47pr
        WfKa47KF4kJ3WxtrZ3t3W8Ja4Yyr43tr15ury5trn7ZF95Cr1a9rW3KFW8uF98uFWvga1j
        vr1jqrZrZ34DW3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgmb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
        Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
        AY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
        cVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMI
        IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2
        KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: hohrhzxlor0w46kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 11:05:48AM +1000, Dave Chinner wrote:
> On Sat, Jul 22, 2023 at 09:19:09AM +0800, Long Li wrote:
> > On Wed, Jul 19, 2023 at 04:41:41PM +1000, Dave Chinner wrote:
> > > On Sat, Jul 15, 2023 at 02:36:47PM +0800, Long Li wrote:
> > > > KASAN report a uaf when recover intents fails:
> > > ....
> > > > 
> > > > If process intents fails, intent items left in AIL will be delete
> > > > from AIL and freed in error handling, even intent items that have been
> > > > recovered and created done items. After this, uaf will be triggered when
> > > > done item commited, because at this point the released intent item will
> > > > be accessed.
> > > > 
> > > > xlog_recover_finish                     xlog_cil_push_work
> > > > ----------------------------            ---------------------------
> > > > xlog_recover_process_intents
> > > >   xfs_cui_item_recover//cui_refcount == 1
> > > >     xfs_trans_get_cud
> > > >     xfs_trans_commit
> > > >       <add cud item to cil>
> > > >   xfs_cui_item_recover
> > > >     <error occurred and return>
> > > > xlog_recover_cancel_intents
> > > >   xfs_cui_release     //cui_refcount == 0
> > > >     xfs_cui_item_free //free cui
> > > >   <release other intent items>
> > > > xlog_force_shutdown   //shutdown
> > > >                                <...>
> > > >                                         <push items in cil>
> > > >                                         xlog_cil_committed
> > > >                                           xfs_cud_item_release
> > > >                                             xfs_cui_release // UAF
> > > 
> > > Huh. The log stores items in the AIL without holding a reference to
> > > them, then on shutdown takes the intent done reference away because
> > > it assumes the intent has not been processed as it is still in the
> > > AIL.
> > > 
> > > Ok, that's broken.
> > > 
> > > > Fix it by move log force forward to make sure done items committed before
> > > > cancel intents.
> > > 
> > > That doesn't fix the fact we have a reference counted object that is
> > > being accessed by code that doesn't actually own a reference to the
> > > object.  Intent log items are created with a reference count of 2 -
> > > one for the creator, and one for the intent done object.
> > > 
> > > Look at xlog_recover_cui_commit_pass2():
> > > 
> > >         /*
> > >          * Insert the intent into the AIL directly and drop one reference so
> > >          * that finishing or canceling the work will drop the other.
> > >          */
> > >         xfs_trans_ail_insert(log->l_ailp, &cuip->cui_item, lsn);
> > >         xfs_cui_release(cuip);
> > >         return 0;
> > > }
> > > 
> > > Log recovery explicitly drops the creator reference after it is
> > > inserted into the AIL, but it then processes the log item as if it
> > > also owns the intent-done reference. The moment we call
> > > ->iop_recover(), the intent-done reference should be owned by the
> > > log item.
> > 
> > Hi, Dave
> > 
> > Thanks for the reply. Yes, your analysis seems reasonable, it helped me a
> > lot to understand the intent lifecycle.
> > 
> > > 
> > > The recovery of the BUI, RUI and EFI all do the same thing. I
> > > suspect that these references should actually be held by log
> > > recovery until it is done processing the item, at which point it
> > > should be removed from the AIL by xlog_recover_process_intents().
> > 
> > Why do we need to remove the intent from the AIL at this point,
> 
> Because we've processed the recovery of it - it is either completely
> done or we have a new intent in the CIL ready to continue operation.
> Either way, the next write to the journal will remove the item from
> the AIL when it completes.
> 
> Intents don't need to be in the AIL, though - we can cancel them
> in memory (see the intent whiteout code) and so when we process the
> done item from journal IO completion the last reference goes away
> and they won't be in the AIL at this point in time.
> 
> IOWs, the intent freeing code doesn't care if the intent is in the
> AIL or not, it does the right thing either way.
> 
> Hence if we remove the intent from the list of intents that need to
> be recovered after we have done the initial recovery, we acheive two
> things:
> 
> 1. the tail of the log can be moved forward with the commit of the
> done intent or new intent to continue the operation, and
> 
> 2. We avoid the problem of trying to determine how many reference
> counts we need to drop from intent recovery cancelling because we
> never come across intents we've actually attempted recovery on.
> 
> > shouldn't
> > it be removed from the AIL when the done intent is committed? Or is there
> > any way to ensure that the intents are removed from the AIL when they are
> > processed.
> 
> THe reference counting ensures the right thing is done when the last
> reference goes away. If it is in the AIL, it will get removed, if it
> is not in the AIL, then AIL removal is a no-op and nothign bad
> happens.

Thank you for your detailed answer, it was great, I understand
what you mean.

The intent item stays in the AIL until the done item is committed,
which prevents the tail lsn from moving forward. After the transaction
is alloced in ->iop_recover(), we don't need to stop tail lsn from
moving forward because there is no other thread committing the
transaction at this point, the intent item will not be overwritten
until the done intent is written to the log, so we can just remove
the intent item from the AIL.

I think we can remove the intent item from the AIL as soon as the
done item is created, since the reference count has already been
passed to the done item. Eventually the problem can be fixed.

This is my understanding.

Thanks
Long Li

