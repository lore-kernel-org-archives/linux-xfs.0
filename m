Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FA3C54FD0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 21:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7F8D214AF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 21:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgDXVhf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 17:37:35 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55337 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgDXVhf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 17:37:35 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 13E398208DA;
        Sat, 25 Apr 2020 07:37:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jS60n-0008Sv-8L; Sat, 25 Apr 2020 07:37:29 +1000
Date:   Sat, 25 Apr 2020 07:37:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't change to infinate lock to avoid dead lock
Message-ID: <20200424213729.GC2040@dread.disaster.area>
References: <20200423172325.8595-1-wen.gang.wang@oracle.com>
 <20200423230515.GZ27860@dread.disaster.area>
 <ed040889-5f79-e4f5-a203-b7ad8aa701d4@oracle.com>
 <bca65738-3deb-ef43-6dde-1c2402942032@oracle.com>
 <20200424013948.GA2040@dread.disaster.area>
 <676ecd15-d8ea-0e18-6075-3cb11f8c2e15@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <676ecd15-d8ea-0e18-6075-3cb11f8c2e15@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=8nJEP1OIZ-IA:10 a=cl8xLZFz6L8A:10 a=7-415B0cAAAA:8
        a=2WzaQmQUtVig2e3GlIQA:9 a=SM_UlMuye-50hAg1:21 a=AjgQW3NlawUE7f2l:21
        a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 24, 2020 at 09:58:09AM -0700, Wengang Wang wrote:
> On 4/23/20 6:39 PM, Dave Chinner wrote:
> > On Thu, Apr 23, 2020 at 04:19:52PM -0700, Wengang Wang wrote:
> > > On 4/23/20 4:14 PM, Wengang Wang wrote:
> > > > The real case I hit is that the process A is waiting for inode unpin on
> > > > XFS A which is a loop device backed mount.
> > > And actually, there is a dm-thin on top of the loop device..
> > Makes no difference, really, because it's still the loop device
> > that is doing the IO to the underlying filesystem...
> I mentioned IO path here, not the IO its self.  In this case, the IO patch
> includes dm-thin.
> 
> We have to consider it as long as we are not sure if there is GPF_KERNEL (or
> any flags without NOFS, NOIO) allocation happens in dm-thin.
> 
> If dm-thin has GPF_KERNEL allocation and goes into memory direct reclaiming,
> the deadlock forms.

If that happens, then that is a bug in dm-thin, not a bug in XFS.
There are rules to how memory allocation must be done to avoid
deadlocks, and one of those is that block device level IO path
allocations *must* use GFP_NOIO. This prevents reclaim from
recursing into subsystems that might require IO to reclaim memory
and hence self deadlock because the IO layer requires allocation to
succeed to make forwards progress.

That's why we have mempools and GFP_NOIO at the block and device
layers....


> > > > And the backing file is from a different (X)FS B mount. So the IO is
> > > > going through loop device, (direct) writes to (X)FS B.
> > > > 
> > > > The (direct) writes to (X)FS B do memory allocations and then memory
> > > > direct reclaims...
> > THe loop device issues IO to the lower filesystem in
> > memalloc_noio_save() context, which means all memory allocations in
> > it's IO path are done with GFP_NOIO context. Hence those allocations
> > will not recurse into reclaim on -any filesystem- and hence will not
> > deadlock on filesystem reclaim. So what I said originally is correct
> > even when we take filesystems stacked via loop devices into account.
> You are right here. Seems loop device is doing NOFS|NOIO allocations.
> 
> The deadlock happened with a bit lower kernel version which is without loop
> device patch that does NOFS|NOIO allocation.

Right, the loop device used to have an allocation context bug, but
that has been fixed. Either way, this is not an XFS or even a
filesystem layer issue.

> Well, here you are only talking about loop device, it's not enough to say
> it's also safe in case the memory reclaiming happens at higher layer above
> loop device in the IO path.

Yes it is.

Block devices and device drivers are *required* to use GFP_NOIO
context for memory allocations in the IO path. IOWs, any block
device that is doing GFP_KERNEL context allocation violates the
memory allocation rules we have for the IO path.  This architectural
constraint exists exclusively to avoid this entire class of IO-based
memory reclaim recursion deadlocks.

> > Hence I'll ask again: do you have stack traces of the deadlock or a
> > lockdep report? If not, can you please describe the storage setup
> > from top to bottom and lay out exactly where in what layers trigger
> > this deadlock?
> 
> Sharing the callback traces:

<snip>

Yeah, so the loop device is doing GFP_KERNEL allocation in a
GFP_NOIO context. You need to fix the loop device in whatever kernel
you are testing, which you have conveniently never mentioned. I'm
betting this is a vendor kernel that is missing fixes from the
upstream kernel. In which case you need to talk to your OS vendor,
not upstream...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
