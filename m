Return-Path: <SRS0=ihlG=7Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CD1C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 02:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B812120747
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 02:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgFKC2y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 22:28:54 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58165 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbgFKC2y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jun 2020 22:28:54 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 53C71760B7A;
        Thu, 11 Jun 2020 12:28:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jjCxU-0002QN-7L; Thu, 11 Jun 2020 12:28:48 +1000
Date:   Thu, 11 Jun 2020 12:28:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [RFC PATCH] fix use after free in xlog_wait()
Message-ID: <20200611022848.GQ2040@dread.disaster.area>
References: <20200611013952.2589997-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611013952.2589997-1-yukuai3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=i0EeH86SAAAA:8 a=7-415B0cAAAA:8
        a=lJGGXNzYajzh12HJQzkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 11, 2020 at 09:39:52AM +0800, Yu Kuai wrote:
> I recently got UAF by running generic/019 in qemu:
> 
> ==================================================================
>   BUG: KASAN: use-after-free in __lock_acquire+0x4508/0x68c0
>   Read of size 8 at addr ffff88811327f080 by task fio/11147
....
>    remove_wait_queue+0x1d/0x180
>    xfs_log_commit_cil+0x1d9e/0x2a50
>    __xfs_trans_commit+0x292/0xec0

Ok, so this is waking up from a the CIL context overrunning the hard
size limit....

>    Freed by task 6826:
>    save_stack+0x1b/0x40
>    __kasan_slab_free+0x12c/0x170
>    kfree+0xd6/0x300
>    kvfree+0x42/0x50
>    xlog_cil_committed+0xa9c/0xf30
>    xlog_cil_push_work+0xa8c/0x1250
>    process_one_work+0xa3e/0x17a0
>    worker_thread+0x8e2/0x1050
>    kthread+0x355/0x470
>    ret_from_fork+0x22/0x30

Hmmmm. The CIL push work freed the context which means somethign
went wrong somewhere - we must be in CIL commit error path here...

/me checks generic/019

Oh, it's a repeated shutdown test. Right, so we're getting a
shutdown in the middle of a CIL push when the CIL is hard throttling
callers and the CIL context gets freed before the throttled tasks
can be woken.

Gotcha. Yup, that's a real issue, thanks for reporting it!

> I think the reason is that when 'ctx' is freed in xlog_cil_committed(),
> a previous call to xlog_wait(&ctx->xc_ctx->push_wait, ...) hasn't finished
> yet. Thus when remove_wait_queue() is called, UAF will be triggered
> since 'ctx' was freed:
> 
> thread1		    thread2             thread3
> 
> __xfs_trans_commit
>  xfs_log_commit_cil
>   xlog_wait
>    schedule
>                     xlog_cil_push_work
> 		     wake_up_all
> 		                        xlog_cil_committed
> 					 kmem_free
>    remove_wait_queue
>     spin_lock_irqsave --> UAF

Actually, it's a lot simpler:

thread1			thread2

__xfs_trans_commit
 xfs_log_commit_cil
  xlog_wait
   schedule
			xlog_cil_push_work
			wake_up_all
			<shutdown aborts commit>
			xlog_cil_committed
			kmem_free

   remove_wait_queue
    spin_lock_irqsave --> UAF

> Instead, make sure waitqueue_active(&ctx->push_wait) return false before
> freeing 'ctx'.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  fs/xfs/xfs_log_cil.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b43f0e8f43f2..59b21485b0fc 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -607,7 +607,7 @@ xlog_cil_committed(
>  
>  	if (!list_empty(&ctx->busy_extents))
>  		xlog_discard_busy_extents(mp, ctx);
> -	else
> +	else if (!waitqueue_active(&ctx->push_wait))
>  		kmem_free(ctx);

That will just leak the memory instead, which is no better.

Let me go write a patch to fix this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
