Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74709EB64DD
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Jul 2023 01:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjGVBWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 21:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjGVBWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 21:22:07 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7C32D7E
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 18:22:05 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4R77tv0GY4z4f3nxX
        for <linux-xfs@vger.kernel.org>; Sat, 22 Jul 2023 09:21:59 +0800 (CST)
Received: from localhost (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgD3mp44L7tkt0UTOg--.47034S3;
        Sat, 22 Jul 2023 09:22:01 +0800 (CST)
Date:   Sat, 22 Jul 2023 09:19:09 +0800
From:   Long Li <leo.lilong@huaweicloud.com>
To:     Dave Chinner <david@fromorbit.com>, Long Li <leo.lilong@huawei.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
        houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 3/3] xfs: make sure done item committed before cancel
 intents
Message-ID: <20230722011909.GA4061995@ceph-admin>
References: <20230715063647.2094989-1-leo.lilong@huawei.com>
 <20230715063647.2094989-4-leo.lilong@huawei.com>
 <ZLeFpQWSUVmYNJXJ@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZLeFpQWSUVmYNJXJ@dread.disaster.area>
X-CM-TRANSID: gCh0CgD3mp44L7tkt0UTOg--.47034S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF48ury3Cw4kWFy3JryDtrb_yoW5KrWfpF
        WfGrW7GFs7Ja1xtrZ7Ja18Xa4rAr47tr45Cry5trn7ua4rAr1a9rWagFWFqF9ruFWvqa1j
        vr42qFWDXa45WrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgmb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
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

On Wed, Jul 19, 2023 at 04:41:41PM +1000, Dave Chinner wrote:
> On Sat, Jul 15, 2023 at 02:36:47PM +0800, Long Li wrote:
> > KASAN report a uaf when recover intents fails:
> ....
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
> 
> Huh. The log stores items in the AIL without holding a reference to
> them, then on shutdown takes the intent done reference away because
> it assumes the intent has not been processed as it is still in the
> AIL.
> 
> Ok, that's broken.
> 
> > Fix it by move log force forward to make sure done items committed before
> > cancel intents.
> 
> That doesn't fix the fact we have a reference counted object that is
> being accessed by code that doesn't actually own a reference to the
> object.  Intent log items are created with a reference count of 2 -
> one for the creator, and one for the intent done object.
> 
> Look at xlog_recover_cui_commit_pass2():
> 
>         /*
>          * Insert the intent into the AIL directly and drop one reference so
>          * that finishing or canceling the work will drop the other.
>          */
>         xfs_trans_ail_insert(log->l_ailp, &cuip->cui_item, lsn);
>         xfs_cui_release(cuip);
>         return 0;
> }
> 
> Log recovery explicitly drops the creator reference after it is
> inserted into the AIL, but it then processes the log item as if it
> also owns the intent-done reference. The moment we call
> ->iop_recover(), the intent-done reference should be owned by the
> log item.

Hi, Dave

Thanks for the reply. Yes, your analysis seems reasonable, it helped me a
lot to understand the intent lifecycle.

> 
> The recovery of the BUI, RUI and EFI all do the same thing. I
> suspect that these references should actually be held by log
> recovery until it is done processing the item, at which point it
> should be removed from the AIL by xlog_recover_process_intents().

Why do we need to remove the intent from the AIL at this point, shouldn't
it be removed from the AIL when the done intent is committed? Or is there
any way to ensure that the intents are removed from the AIL when they are
processed.

> 
> The code in ->iop_recovery should assume that it passes the
> reference to the done intent, but if that code fails before creating
> the done-intent then it needs to release the intent reference
> itself.
> 
> That way when we go to cancel the intent, the only intents we find
> in the AIL are the ones we know have not been processed yet and
> hence we can safely drop both the creator and the intent done
> reference from xlog_recover_cancel_intents().

Yes, if the processed intent has been removed from the AIL, then only the
unprocessed intent remains in the current AIL, and it is safe to cancel
the intent.

Best regards
Long Li
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

