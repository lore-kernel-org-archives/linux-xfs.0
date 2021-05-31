Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5142CC47082
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2974061003
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhEaWnS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 18:43:18 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58125 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232042AbhEaWnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 18:43:18 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 887CC1AFA70;
        Tue,  1 Jun 2021 08:41:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lnqbF-007UQq-Tn; Tue, 01 Jun 2021 08:41:33 +1000
Date:   Tue, 1 Jun 2021 08:41:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6] xfs: bunmapi needs updating for deferred freeing
Message-ID: <20210531224133.GS664593@dread.disaster.area>
References: <20210527045202.1155628-1-david@fromorbit.com>
 <87fsy3uspu.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsy3uspu.fsf@garuda>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=oU_AC-n_DPvekzVGeTwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 31, 2021 at 03:32:05PM +0530, Chandan Babu R wrote:
> On 27 May 2021 at 10:21, Dave Chinner wrote:
> > Hi folks,
> >
> > I pulled on a loose thread when I started looking into the 64kB
> > directory block size assert failure I was seeing while trying to
> > test the bulk page allocation changes.
> >
> > I posted the first patch in the series separately - it fixed the
> > immediate assert failure (5.13-rc1 regression) I was seeing, but in
> > fixing that it only then dropped back to the previous assert failure
> > that g/538 was triggering with 64kb directory block sizes. This can
> > only be reproduced on 5.12, because that's when the error injection
> > that g/538 uses was added. So I went looking deeper.
> >
> > It turns out that xfs_bunmapi() has some code in it to avoid locking
> > AGFs in the wrong order and this is what was triggering. Many of the
> > xfs_bunmapi() callers can not/do not handle partial unmaps that
> > return success, and that's what the directory code is tripping over
> > trying to free badly fragmented directory blocks.
> >
> > This AGF locking order constraint was added to xfs_bunmapu in 2017
> > to avoid a deadlock in g/299. Sad thing is that shortly after this,
> > we converted xfs-bunmapi to use deferred freeing, so it never
> > actually locks AGFs anymore. But the deadlock avoiding landmine
> > remained. And xfs_bmap_finish() went away, too, and we now only ever
> > put one extent in any EFI we log for deferred freeing.
> 
> I did come across a scenario (when executing xfs/538 with 1k fs block size and
> 64k directory block size) where an EFI item contained three extents:
> 
> - Two of those extents belonged to the file whose extents were being freed.
> - One more extent was added by xfs_bmap_btree_to_extents().
>   The corresponding call trace was,
>     CPU: 3 PID: 1367 Comm: fsstress Not tainted 5.12.0-rc8-next-20210419-chandan #125
>     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
>     Call Trace:
>      dump_stack+0x64/0x7c
>      xfs_defer_add.cold+0x1d/0x22
>      xfs_bmap_btree_to_extents+0x1f6/0x470
>      __xfs_bunmapi+0x50a/0xe60
>      ? xfs_trans_alloc_inode+0xbb/0x180
>      xfs_bunmapi+0x15/0x30
>      xfs_free_file_space+0x241/0x2c0
>      xfs_file_fallocate+0x1ca/0x430
>      ? __cond_resched+0x16/0x40
>      ? inode_security+0x22/0x60
>      ? selinux_file_permission+0xe2/0x120
>      vfs_fallocate+0x146/0x2e0
>      ioctl_preallocate+0x8f/0xc0
>      __x64_sys_ioctl+0x62/0xb0
>      do_syscall_64+0x40/0x80
>      entry_SYSCALL_64_after_hwframe+0x44/0xae

That's not a directory operation that tripped over. :/

> > That means we now only free one extent per transaction via deferred
> > freeing,
> 
> With three instances of xfs_extent_free_items associated with one instance of
> xfs_defer_pending, xfs_defer_finish_noroll() would,
> 1. Create an EFI item containing information about the three extents to be
>    freed.
>    - The extents in xfs_defer_pending->dfp_work list are sorted based on AG
>      number.
> 2. Roll the transaction.
> 3. The new transaction would,
>    - Create an EFD item to hold information about the three extents to be
>      freed.
>    - Free the three extents in a single transaction.

Yeah, so I missed that xfs_defer_add() will combine like types into
the the same list if they are consecutively logged. I was looking at
intent creation being limited to one intent per deferred operation,
but missed the aggregation at queuing time.

But this is largely irrelevant to the operation of bunmapi, because
it's just queuing extents to be freed, not running the transactions
that free them...

> > and there are no limitations on what order xfs_bunmapi()
> > can unmap extents.
> 
> I think the sorting of extent items mentioned above is the reason that AG
> locks are obtained in increasing AGNO order while freeing extents.

Nope, now that I look at it, the EFI intent creation sorts the
queued extents to be freed into ascending AG order, so they'll
always be freed in an order that allows for correct AG locking order
in the freeing transaction. IOWs, we still don't need AG ordering
anywhere in the bunmapi path, because AG ordering is done at the
intent level where ordering might matter...

> > 64kB directories on a 1kB block size filesystem already unmap 64
> > extents in a single loop, so there's no real limitation here.
> 
> I think, in the worst case, we can free atmost
> XFS_EFI_MAX_FAST_EXTENTS (i.e. 16) extents in a single transaction
> assuming that they were all added in a sequence without any
> non-XFS_DEFER_OPS_TYPE_FREE deferred objects added in between.

Yup. Seems that way, but there's not deadlock issue with doing this
because of the sorting. That's an issue for transaction reservations
for EFI processing, but these days that is not something that
bunmapi has to care about.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
