Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1EFC43217
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Nov 2022 23:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiK1XAX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 18:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiK1XAB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 18:00:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DF22F02F
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 15:00:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 892C3CE1057
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 22:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF870C433C1;
        Mon, 28 Nov 2022 22:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669676396;
        bh=SJrKWrrkDb5gZivD5IM5p2FnWvi8RhVOKHhrXTUJJGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N8B8z/1vdps5EWnBiyFjwjUeSVMINN/AwN/0dVyO/cGW5/yC+FMdhgEiLE/X0D4Qq
         tT3wBHBlkqj2jidPHRkntI1WcyusJKi9oTRZLsRxeJBv6X1fJ/qFJNPPcSKbwPF+/4
         RwsfCRhq6OqyjrvxXefxHErcM/vg7eN+9JBm2zkb8Pyb1I4o3kFdSTqpVf1ylLo+/5
         734lQDaHJA+5iDHa07gngivOMBVjXdT/Ffv3X8gaUFpepzkEa72Ud1ilQLMwTZx2Bc
         9jTTki1d8nQVftzp66Qk905IzjVyaqy8tej27G8Rr1+F7NUPBI9faGw7hTX/f6Llv1
         h4APqj1pDAwWw==
Date:   Mon, 28 Nov 2022 14:59:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        jack.qiu@huawei.com, fangwei1@huawei.com, yi.zhang@huawei.com,
        zhengbin13@huawei.com, leo.lilong@huawei.com, zengheng4@huawei.com
Subject: Re: [PATCH v5 2/2] xfs: fix super block buf log item UAF during
 force shutdown
Message-ID: <Y4U9bJofLqVWdGFs@magnolia>
References: <20221118121143.267895-1-guoxuenan@huawei.com>
 <20221118121143.267895-3-guoxuenan@huawei.com>
 <Y3u//R0qc9MHQAtQ@magnolia>
 <acd05d3a-9df0-9e64-6846-f24626b80e74@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acd05d3a-9df0-9e64-6846-f24626b80e74@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2022 at 10:11:52AM +0800, Guo Xuenan wrote:
> Hi Darrick:
> 
> On 2022/11/22 2:14, Darrick J. Wong wrote:
> > On Fri, Nov 18, 2022 at 08:11:43PM +0800, Guo Xuenan wrote:
> > > xfs log io error will trigger xlog shut down, and end_io worker call
> > > xlog_state_shutdown_callbacks to unpin and release the buf log item.
> > > The race condition is that when there are some thread doing transaction
> > > commit and happened not to be intercepted by xlog_is_shutdown, then,
> > > these log item will be insert into CIL, when unpin and release these
> > > buf log item, UAF will occur. BTW, add delay before `xlog_cil_commit`
> > > can increase recurrence probability.
> > > 
> > > The following call graph actually encountered this bad situation.
> > > fsstress                    io end worker kworker/0:1H-216
> > >                              xlog_ioend_work
> > >                                ->xlog_force_shutdown
> > >                                  ->xlog_state_shutdown_callbacks
> > >                                    ->xlog_cil_process_committed
> > >                                      ->xlog_cil_committed
> > >                                        ->xfs_trans_committed_bulk
> > > ->xfs_trans_apply_sb_deltas             ->li_ops->iop_unpin(lip, 1);
> > >    ->xfs_trans_getsb
> > >      ->_xfs_trans_bjoin
> > >        ->xfs_buf_item_init
> > >          ->if (bip) { return 0;} //relog
> > > ->xlog_cil_commit
> > >    ->xlog_cil_insert_items //insert into CIL
> > >                                             ->xfs_buf_ioend_fail(bp);
> > >                                               ->xfs_buf_ioend
> > >                                                 ->xfs_buf_item_done
> > >                                                   ->xfs_buf_item_relse
> > >                                                     ->xfs_buf_item_free
> > > 
> > > when cil push worker gather percpu cil and insert super block buf log item
> > > into ctx->log_items then uaf occurs.
> > > 
> > > ==================================================================
> > > BUG: KASAN: use-after-free in xlog_cil_push_work+0x1c8f/0x22f0
> > > Write of size 8 at addr ffff88801800f3f0 by task kworker/u4:4/105
> > > 
> > > CPU: 0 PID: 105 Comm: kworker/u4:4 Tainted: G W
> > > 6.1.0-rc1-00001-g274115149b42 #136
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > > 1.13.0-1ubuntu1.1 04/01/2014
> > > Workqueue: xfs-cil/sda xlog_cil_push_work
> > > Call Trace:
> > >   <TASK>
> > >   dump_stack_lvl+0x4d/0x66
> > >   print_report+0x171/0x4a6
> > >   kasan_report+0xb3/0x130
> > >   xlog_cil_push_work+0x1c8f/0x22f0
> > >   process_one_work+0x6f9/0xf70
> > >   worker_thread+0x578/0xf30
> > >   kthread+0x28c/0x330
> > >   ret_from_fork+0x1f/0x30
> > >   </TASK>
> > > 
> > > Allocated by task 2145:
> > >   kasan_save_stack+0x1e/0x40
> > >   kasan_set_track+0x21/0x30
> > >   __kasan_slab_alloc+0x54/0x60
> > >   kmem_cache_alloc+0x14a/0x510
> > >   xfs_buf_item_init+0x160/0x6d0
> > >   _xfs_trans_bjoin+0x7f/0x2e0
> > >   xfs_trans_getsb+0xb6/0x3f0
> > >   xfs_trans_apply_sb_deltas+0x1f/0x8c0
> > >   __xfs_trans_commit+0xa25/0xe10
> > >   xfs_symlink+0xe23/0x1660
> > >   xfs_vn_symlink+0x157/0x280
> > >   vfs_symlink+0x491/0x790
> > >   do_symlinkat+0x128/0x220
> > >   __x64_sys_symlink+0x7a/0x90
> > >   do_syscall_64+0x35/0x80
> > >   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > 
> > > Freed by task 216:
> > >   kasan_save_stack+0x1e/0x40
> > >   kasan_set_track+0x21/0x30
> > >   kasan_save_free_info+0x2a/0x40
> > >   __kasan_slab_free+0x105/0x1a0
> > >   kmem_cache_free+0xb6/0x460
> > >   xfs_buf_ioend+0x1e9/0x11f0
> > >   xfs_buf_item_unpin+0x3d6/0x840
> > >   xfs_trans_committed_bulk+0x4c2/0x7c0
> > >   xlog_cil_committed+0xab6/0xfb0
> > >   xlog_cil_process_committed+0x117/0x1e0
> > >   xlog_state_shutdown_callbacks+0x208/0x440
> > >   xlog_force_shutdown+0x1b3/0x3a0
> > >   xlog_ioend_work+0xef/0x1d0
> > >   process_one_work+0x6f9/0xf70
> > >   worker_thread+0x578/0xf30
> > >   kthread+0x28c/0x330
> > >   ret_from_fork+0x1f/0x30
> > > 
> > > The buggy address belongs to the object at ffff88801800f388
> > >   which belongs to the cache xfs_buf_item of size 272
> > > The buggy address is located 104 bytes inside of
> > >   272-byte region [ffff88801800f388, ffff88801800f498)
> > > 
> > > The buggy address belongs to the physical page:
> > > page:ffffea0000600380 refcount:1 mapcount:0 mapping:0000000000000000
> > > index:0xffff88801800f208 pfn:0x1800e
> > > head:ffffea0000600380 order:1 compound_mapcount:0 compound_pincount:0
> > > flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
> > > raw: 001fffff80010200 ffffea0000699788 ffff88801319db50 ffff88800fb50640
> > > raw: ffff88801800f208 000000000015000a 00000001ffffffff 0000000000000000
> > > page dumped because: kasan: bad access detected
> > > 
> > > Memory state around the buggy address:
> > >   ffff88801800f280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >   ffff88801800f300: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > > ffff88801800f380: fc fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >                                                               ^
> > >   ffff88801800f400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >   ffff88801800f480: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > ==================================================================
> > > Disabling lock debugging due to kernel taint
> > > 
> > > Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> > > ---
> > >   fs/xfs/xfs_buf_item.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > > index 522d450a94b1..df7322ed73fa 100644
> > > --- a/fs/xfs/xfs_buf_item.c
> > > +++ b/fs/xfs/xfs_buf_item.c
> > > @@ -1018,6 +1018,8 @@ xfs_buf_item_relse(
> > >   	trace_xfs_buf_item_relse(bp, _RET_IP_);
> > >   	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
> > > +	if (atomic_read(&bip->bli_refcount))
> > > +		return;
> > ...and the answers to the questions posed here[1] and here[2] are...?
> > 
> > [1] https://lore.kernel.org/linux-xfs/Y3aLWgGStNPEo2z4@magnolia/
> > [2] https://lore.kernel.org/linux-xfs/20221103214408.GI3600936@dread.disaster.area/
> I have replied [1] [2] at the old thread, but I found that I didn't find my
> reply
> in the xfs mailing list.Sorry for bothering you, if you've recieved it. I
> will reply
> here again, since I find my email replay to PATCH v5 display on the
> website,but I did
> not find my replay to [1] [2]. (I'm so sorry if I bothered you.)

AH, that's what happened.  I'm not sure what's up with huawei vs. vger,
but I guess something's screwed up with your corporate mail that makes
sending patches a big pain.

(...and it's not limited to huawei, most major US companies seem to have
rolled out the brave new world of email systems where listservs are
broken and nobody cares because Microsoft and Google sell teamware.)

> > Q1. Odd switch from ^^^^^^^^^^^^^ spaces to tabs here.
> 
> For better alignment I have changed all of them to spaces in PATCHv5.

Ok, I'll look for them on the list then.

> > Q2. Why are we still inserting things into the CIL of a dead log?
> 
> Because,dead log condition is set before xlog_cil_commit.
> Current code as follows:
> __xfs_trans_commit(
>     struct xfs_trans *tp,
>     bool  regrant)
> {    ...
> 
>     if (xlog_is_shutdown(log)) {  <= HERE is the dead log condition.
>         error = -EIO;
>         goto out_unreserve;
>     }
> 
>     ASSERT(tp->t_ticket != NULL);
> 
>     /*
>      * If we need to update the superblock, then do it now.
>      */
>     if (tp->t_flags & XFS_TRANS_SB_DIRTY)
>         xfs_trans_apply_sb_deltas(tp);
>     xfs_trans_apply_dquot_deltas(tp);
>     //----HERE--to reporduce the problem, add delay here, so it will------
>     + if (xlog_is_shutdown(log))
>     +     mdelay(1000);
>     xlog_cil_commit(log, tp, &commit_seq, regrant);
>     ...
> }
> In my opinion,due to concurrentcy of transaction commit and the status
> change of xlog,
> I think xlog_is_shutdown can not suddenly prevent /all/ log items from
> inserting into
> CIL list.

Ah, ok.  Thanks for pointing out that race condition more clearly.

> > Q3.If we're releasing the buf item, shouldn't this be an
> atomic_dec_and_test or something?
> 
> I have do some test，I am sure it should not. because which will lead to
> bli_refcount < 0
> and ASSERT(atomic_read(&bip->bli_refcount) > 0) will be trigger.
> The reason is that function xfs_buf_item_unpin have decreased the refcount,
> so we should not
> 
> decrease it again in xfs_buf_item_relse.
> 
> As Dave said here[2],"xfs_buf_item_relse only called at end of BLI life
> cycle, so dosen't check
> the reference count,when in fact it clearly isn't."
> (In [2] Dave have same question as Q2, I also replied, seem sent email
> failed, really sorry)

Ok, I'll run both through the nightly tests tonight.

--D

> Thanks
> Xuenan
> > --D
> > 
> > >   	bp->b_log_item = NULL;
> > >   	xfs_buf_rele(bp);
> > >   	xfs_buf_item_free(bip);
> > > -- 
> > > 2.31.1
> > > 
> > .
> 
> -- 
> Guo Xuenan [OS Kernel Lab]
> -----------------------------
> Email: guoxuenan@huawei.com
> 
