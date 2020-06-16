Return-Path: <SRS0=cXLJ=75=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403D3C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 02:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2027E20756
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 02:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgFPCjB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Jun 2020 22:39:01 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:59286 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbgFPCjB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jun 2020 22:39:01 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 8CF88761207;
        Tue, 16 Jun 2020 12:38:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jl1V2-0002F3-Dd; Tue, 16 Jun 2020 12:38:56 +1000
Date:   Tue, 16 Jun 2020 12:38:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "yukuai (C)" <yukuai3@huawei.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH] xfs: fix use-after-free on CIL context on shutdown
Message-ID: <20200616023856.GD2005@dread.disaster.area>
References: <20200611013952.2589997-1-yukuai3@huawei.com>
 <20200611022848.GQ2040@dread.disaster.area>
 <20200611024503.GR2040@dread.disaster.area>
 <9d13cb34-5625-ed84-71f5-ad48204589a1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d13cb34-5625-ed84-71f5-ad48204589a1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=4gZMuf7uG7p2KhJwSLEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 16, 2020 at 09:16:09AM +0800, yukuai (C) wrote:
> On 2020/6/11 10:45, Dave Chinner wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xlog_wait() on the CIL context can reference a freed context if the
> > waiter doesn't get scheduled before the CIL context is freed. This
> > can happen when a task is on the hard throttle and the CIL push
> > aborts due to a shutdown. This was detected by generic/019:
> > 
> > thread 1			thread 2
> > 
> > __xfs_trans_commit
> >   xfs_log_commit_cil
> >    <CIL size over hard throttle limit>
> >    xlog_wait
> >     schedule
> > 				xlog_cil_push_work
> > 				wake_up_all
> > 				<shutdown aborts commit>
> > 				xlog_cil_committed
> > 				kmem_free
> > 
> >     remove_wait_queue
> >      spin_lock_irqsave --> UAF
> > 
> > Fix it by moving the wait queue to the CIL rather than keeping it in
> > in the CIL context that gets freed on push completion. Because the
> > wait queue is now independent of the CIL context and we might have
> > multiple contexts in flight at once, only wake the waiters on the
> > push throttle when the context we are pushing is over the hard
> > throttle size threshold.
> 
> Hi, Dave,
> 
> How do you think about the following fix:
> 
> 1. use autoremove_wake_func(), and remove remove_wait_queue() to
> avoid UAF.
> 2. add finish_wait().
> 
> @@ -576,12 +576,13 @@ xlog_wait(
>                 __releases(lock)
>  {
>         DECLARE_WAITQUEUE(wait, current);
> +       wait.func = autoremove_wake_function;
> 
>         add_wait_queue_exclusive(wq, &wait);
>         __set_current_state(TASK_UNINTERRUPTIBLE);
>         spin_unlock(lock);
>         schedule();
> -       remove_wait_queue(wq, &wait);
> +       finish_wait(wq, &wait);
>  }

Yes, that would address this specific symptom of the problem, but it
doesn't fix the problem root cause: that the wq can be freed while
this function sleeps. IMO, this sort of change leaves a trap for
future modifications - all the code calling xlog_wait() assumes the
embedded wq the task is sleeping on still exists after waiting so we
really should be fixing the problem the incorrect existence
guarantee in the CIL code that you tripped over.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
