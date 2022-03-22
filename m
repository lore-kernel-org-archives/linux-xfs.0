Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58616C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 22:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbiCVXAt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 19:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238689AbiCVXAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 19:00:48 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D491961A13;
        Tue, 22 Mar 2022 15:59:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5591E10E4FA4;
        Wed, 23 Mar 2022 09:59:16 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nWnT8-008gnZ-Mh; Wed, 23 Mar 2022 09:59:14 +1100
Date:   Wed, 23 Mar 2022 09:59:14 +1100
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
Message-ID: <20220322225914.GR1544202@dread.disaster.area>
References: <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
 <YjkEjYVjLuo8imtn@slm.duckdns.org>
 <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
 <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
 <2ce1e26c-9050-9a4d-03b1-fb6ad57a5ccf@I-love.SAKURA.ne.jp>
 <Yjn+vpHZzvxiAUaK@slm.duckdns.org>
 <20220322220007.GQ1544202@dread.disaster.area>
 <YjpHjRoq+WtOAmut@slm.duckdns.org>
 <342c3dee-2acc-3983-ab38-7afe6c5ea677@I-love.SAKURA.ne.jp>
 <YjpLfK+glfSPe09Q@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjpLfK+glfSPe09Q@slm.duckdns.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623a54c5
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=9Um5K3jbmKErE-20cnsA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 22, 2022 at 12:19:40PM -1000, Tejun Heo wrote:
> On Wed, Mar 23, 2022 at 07:05:56AM +0900, Tetsuo Handa wrote:
> > > Hmmm... yeah, I actually don't know the exact dependency here and the
> > > dependency may not be real - e.g. the conclusion might be that loop is
> > > conflating different uses and needs to split its use of workqueues into two
> > > separate ones. Tetsuo, can you post more details on the warning that you're
> > > seeing?
> > > 
> > 
> > It was reported at https://lore.kernel.org/all/20210322060334.GD32426@xsang-OptiPlex-9020/ .
> 
> Looks like a correct dependency to me. The work item is being flushed from
> good old write path. Dave?

The filesystem buffered write IO path isn't part of memory reclaim -
it's a user IO path and I think most filesystems will treat it that
way.

We've had similar layering problems with the loop IO path implyingi
GFP_NOFS must be used by filesystems allocating memory in the IO
path - we solved that by requiring the loop IO submission context
(loop_process_work()) to set PF_MEMALLOC_NOIO so that it didn't
deadlock anywhere in the underlying filesystems that have no idea
that the loop device has added memory reclaim constraints to the IO
path.

This seems like it's the same layering problem - syscall facing IO
paths are designed for incoming IO from user context, not outgoing
writeback IO from memory reclaim contexts. Memory reclaim contexts
are supposed to use back end filesystem operations like
->writepages() to flush dirty data when necessary.

If the loop device IO mechanism means that every ->write_iter path
needs to be considered as directly in the memory reclaim path, then
that means a huge amount of the kernel needs to be considered as "in
memory reclaim". i.e. it's not just this one XFS workqueue that is
going have this problem - it's any workqueue that can be waited on
by the incoming IO path.

For example, network filesystem might put the network stack directly
in the IO path. Which means if we then put loop on top of that
filesystems, various workqueues in the network stack may now need to
be considered as running under the memory reclaim path because of
the loop block device.

I don't know what the solution is, but if the fix is "xfs needs to
mark a workqueue that has nothing to do with memory reclaim as
WQ_MEM_RECLAIM because of the loop device" then we're talking about
playing workqueue whack-a-mole across the entire kernel forever
more....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
