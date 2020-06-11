Return-Path: <SRS0=ihlG=7Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B025EC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 05:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FB272072F
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 05:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgFKFFy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 01:05:54 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33257 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725300AbgFKFFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jun 2020 01:05:53 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 248853A4A35;
        Thu, 11 Jun 2020 15:05:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jjFPQ-0003LT-A8; Thu, 11 Jun 2020 15:05:48 +1000
Date:   Thu, 11 Jun 2020 15:05:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "yukuai (C)" <yukuai3@huawei.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [RFC PATCH] fix use after free in xlog_wait()
Message-ID: <20200611050548.GS2040@dread.disaster.area>
References: <20200611013952.2589997-1-yukuai3@huawei.com>
 <20200611022848.GQ2040@dread.disaster.area>
 <c07ba74e-81a4-2060-db82-8d11c6400be8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c07ba74e-81a4-2060-db82-8d11c6400be8@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=7-415B0cAAAA:8
        a=k4-4d9lsxiVGclVBZOAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 11, 2020 at 11:01:38AM +0800, yukuai (C) wrote:
> On 2020/6/11 10:28, Dave Chinner wrote
> > Actually, it's a lot simpler:
> > 
> > thread1			thread2
> > 
> > __xfs_trans_commit
> >   xfs_log_commit_cil
> >    xlog_wait
> >     schedule
> > 			xlog_cil_push_work
> > 			wake_up_all
> > 			<shutdown aborts commit>
> > 			xlog_cil_committed
> > 			kmem_free
> > 
> >     remove_wait_queue
> >      spin_lock_irqsave --> UAF
> > 
> 
> It's ture in this case, however, I got another result when I
> tried to reporduce it, which seems 'ctx' can be freed in a
> different path:

Yup, it's effectively the same thing because of the nature of the IO
failures (generated at submit time) and scheduler behaviour of
workqueues. THis means the IO completion that processes the error is
is queued to a workqueue on the same CPU. When thread 2 finishes
running (it hasn't seen an error yet) the completion work will get
get scheduled ahead of thread1 (cpu bound kernel task vs unbound
user task).  The completion work then runs the shutdown because it
saw a log IO error and because it's the commit record bio it runs
the journal checkpoint completion to abort all the items attached to
it and free the CIL context. Then thread 1 runs again.

The only difference between the two cases is which IO of the CIL
commit the request was failed on....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
