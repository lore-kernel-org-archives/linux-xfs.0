Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24FBC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 22:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiCVWBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 18:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiCVWBk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 18:01:40 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0D85DE9F;
        Tue, 22 Mar 2022 15:00:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B6CFA5339C5;
        Wed, 23 Mar 2022 09:00:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nWmXv-008fmY-6S; Wed, 23 Mar 2022 09:00:07 +1100
Date:   Wed, 23 Mar 2022 09:00:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Message-ID: <20220322220007.GQ1544202@dread.disaster.area>
References: <5542ef88-dcc9-0db5-7f01-ad5779d9bc07@I-love.SAKURA.ne.jp>
 <YjS+Jr6QudSKMSGy@slm.duckdns.org>
 <61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp>
 <YjiuGnLVjj0Ouxtd@slm.duckdns.org>
 <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
 <YjkEjYVjLuo8imtn@slm.duckdns.org>
 <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
 <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
 <2ce1e26c-9050-9a4d-03b1-fb6ad57a5ccf@I-love.SAKURA.ne.jp>
 <Yjn+vpHZzvxiAUaK@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yjn+vpHZzvxiAUaK@slm.duckdns.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=623a46ec
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=EANVev_lTrBuq7RzdLAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 22, 2022 at 06:52:14AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Tue, Mar 22, 2022 at 09:09:53AM +0900, Tetsuo Handa wrote:
> > > The legacy flushing warning is telling us that those workqueues can be
> > 
> > s/can be/must be/ ?
> 
> Well, one thing that we can but don't want to do is converting all
> create_workqueue() users to alloc_workqueue() with MEM_RECLAIM, which is
> wasteful but won't break anything. We know for sure that the workqueues
> which trigger the legacy warning are participating in memory reclaim and
> thus need MEM_RECLAIM. So, yeah, the warning tells us that they need
> MEM_RECLAIM and should be converted.
> 
> > ? Current /* internal: create*_workqueue() */ tells me nothing.
> 
> It's trying to say that it shouldn't be used outside workqueue proper and
> the warning message is supposed to trigger the conversion. But, yeah, a
> stronger comment can help.
> 
> > My question is: I want to add WQ_MEM_RECLAIM flag to the WQ used by loop module
> > because this WQ is involved upon writeback operation. But unless I add both
> > __WQ_LEGACY | WQ_MEM_RECLAIM flags to the WQ used by loop module, we will hit
> > 
> > 	WARN_ONCE(worker && ((worker->current_pwq->wq->flags &
> > 			      (WQ_MEM_RECLAIM | __WQ_LEGACY)) == WQ_MEM_RECLAIM),
> > 
> > warning because e.g. xfs-sync WQ used by xfs module is not using WQ_MEM_RECLAIM flag.
> > 
> > 	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s",
> > 				XFS_WQFLAGS(WQ_FREEZABLE), 0, mp->m_super->s_id);
> > 
> > You are suggesting that the correct approach is to add WQ_MEM_RECLAIM flag to WQs
> > used by filesystems when adding WQ_MEM_RECLAIM flag to the WQ used by loop module
> > introduces possibility of hitting
> > 
> > 	WARN_ONCE(worker && ((worker->current_pwq->wq->flags &
> > 			      (WQ_MEM_RECLAIM | __WQ_LEGACY)) == WQ_MEM_RECLAIM),
> > 
> > warning (instead of either adding __WQ_LEGACY | WQ_MEM_RECLAIM flags to the WQ used
> > by loop module or giving up WQ_MEM_RECLAIM flag for the WQ used by loop module),
> > correct?
> 
> Yeah, you detected multiple issues at the same time. xfs sync is
> participating in memory reclaim

No it isn't. What makes you think it is part of memory reclaim?

The xfs-sync workqueue exists solely to perform async flushes of
dirty data at ENOSPC via sync_inodes_sb() because we can't call
sync_inodes_sb directly in the context that hit ENOSPC due to locks
and transaction contexts held. The paths that need this are
buffered writes and file create (on disk inode allocation), neither
of which are in the the memory reclaim path, either.

So this work has nothing to do with memory reclaim, and as such it's
not tagged with WQ_MEM_RECLAIM.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
