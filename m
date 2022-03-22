Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E31AC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 23:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiCVXwE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 19:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiCVXwD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 19:52:03 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89E426EB2D;
        Tue, 22 Mar 2022 16:50:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 08A0B533B09;
        Wed, 23 Mar 2022 10:50:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nWoGm-008hY6-KY; Wed, 23 Mar 2022 10:50:32 +1100
Date:   Wed, 23 Mar 2022 10:50:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Tejun Heo <tj@kernel.org>,
        Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Message-ID: <20220322235032.GS1544202@dread.disaster.area>
References: <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
 <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
 <2ce1e26c-9050-9a4d-03b1-fb6ad57a5ccf@I-love.SAKURA.ne.jp>
 <Yjn+vpHZzvxiAUaK@slm.duckdns.org>
 <20220322220007.GQ1544202@dread.disaster.area>
 <YjpHjRoq+WtOAmut@slm.duckdns.org>
 <342c3dee-2acc-3983-ab38-7afe6c5ea677@I-love.SAKURA.ne.jp>
 <YjpLfK+glfSPe09Q@slm.duckdns.org>
 <20220322225914.GR1544202@dread.disaster.area>
 <fd10ea3c-fb18-2bb0-d630-4d3cb1f48394@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd10ea3c-fb18-2bb0-d630-4d3cb1f48394@I-love.SAKURA.ne.jp>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623a60ca
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=XEOLygNWQvZj-UsTpHEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 23, 2022 at 08:32:49AM +0900, Tetsuo Handa wrote:
> On 2022/03/23 7:59, Dave Chinner wrote:
> > I don't know what the solution is, but if the fix is "xfs needs to
> > mark a workqueue that has nothing to do with memory reclaim as
> > WQ_MEM_RECLAIM because of the loop device" then we're talking about
> > playing workqueue whack-a-mole across the entire kernel forever
> > more....
....
> And if WQs used by filesystem side do not want to use WQ_MEM_RECLAIM flag, the loop
> module would have to abuse __WQ_LEGACY flag in order to suppress this warning.

I'm not talking about whether filesysetms want to use WQ_MEM_RECLAIM
or not, I'm commenting on the implicit depedency that the loop
device creates that forces the use of WQ_MEM_RECLAIM in all
downstream workqueues. That's what I'm asking about here - how far
does this implicit, undocumented dependency actually reach and how
do we communicate to all developers so that they know about this in
the future when creating new workqueues that might end up under the
loop device?

That's the problem here - unless the developer explicitly considers
and/or remembers this loopback dependency when adding a new
workqueue to a filesystem (or even as far down as network stacks)
then this problem is going to keep happening and we'll just have to
keep driving WQ_MEM_RECLAIM deeper into the stack.

Tejun stated that just marking all workqueues as WQ_MEM_RECLAIM as
being problematic in some situations, and I'm concerned that
resolving implicit dependencies are going to end up in that
situation anyway.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
