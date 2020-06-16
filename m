Return-Path: <SRS0=cXLJ=75=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA61C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 01:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D60D2071A
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Jun 2020 01:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgFPBQW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Jun 2020 21:16:22 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34716 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726492AbgFPBQV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Jun 2020 21:16:21 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0FEEB6D1F326FCDB99DB;
        Tue, 16 Jun 2020 09:16:18 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.204) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 16 Jun 2020
 09:16:10 +0800
Subject: Re: [PATCH] xfs: fix use-after-free on CIL context on shutdown
To:     Dave Chinner <david@fromorbit.com>
CC:     <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>
References: <20200611013952.2589997-1-yukuai3@huawei.com>
 <20200611022848.GQ2040@dread.disaster.area>
 <20200611024503.GR2040@dread.disaster.area>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <9d13cb34-5625-ed84-71f5-ad48204589a1@huawei.com>
Date:   Tue, 16 Jun 2020 09:16:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200611024503.GR2040@dread.disaster.area>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.204]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/6/11 10:45, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> xlog_wait() on the CIL context can reference a freed context if the
> waiter doesn't get scheduled before the CIL context is freed. This
> can happen when a task is on the hard throttle and the CIL push
> aborts due to a shutdown. This was detected by generic/019:
> 
> thread 1			thread 2
> 
> __xfs_trans_commit
>   xfs_log_commit_cil
>    <CIL size over hard throttle limit>
>    xlog_wait
>     schedule
> 				xlog_cil_push_work
> 				wake_up_all
> 				<shutdown aborts commit>
> 				xlog_cil_committed
> 				kmem_free
> 
>     remove_wait_queue
>      spin_lock_irqsave --> UAF
> 
> Fix it by moving the wait queue to the CIL rather than keeping it in
> in the CIL context that gets freed on push completion. Because the
> wait queue is now independent of the CIL context and we might have
> multiple contexts in flight at once, only wake the waiters on the
> push throttle when the context we are pushing is over the hard
> throttle size threshold.

Hi, Dave,

How do you think about the following fix:

1. use autoremove_wake_func(), and remove remove_wait_queue() to
avoid UAF.
2. add finish_wait().

@@ -576,12 +576,13 @@ xlog_wait(
                 __releases(lock)
  {
         DECLARE_WAITQUEUE(wait, current);
+       wait.func = autoremove_wake_function;

         add_wait_queue_exclusive(wq, &wait);
         __set_current_state(TASK_UNINTERRUPTIBLE);
         spin_unlock(lock);
         schedule();
-       remove_wait_queue(wq, &wait);
+       finish_wait(wq, &wait);
  }

Best regards!
Yu Kuai

