Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85EF8C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 02:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239344AbiEKCxf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 22:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236712AbiEKCxS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 22:53:18 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F7942608E5
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 19:52:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 561BA534630;
        Wed, 11 May 2022 12:52:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nocSp-00AWx5-89; Wed, 11 May 2022 12:52:35 +1000
Date:   Wed, 11 May 2022 12:52:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220511025235.GG1098723@dread.disaster.area>
References: <20220509230918.GP1098723@dread.disaster.area>
 <CAOQ4uxgf6AHzLM-mGte_L-A+piSZTRsbdLMBT3hZFNhk-yfxZQ@mail.gmail.com>
 <20220510051057.GY27195@magnolia>
 <20220510063051.GA215522@onthe.net.au>
 <20220510081632.GS1098723@dread.disaster.area>
 <20220510191918.GD27195@magnolia>
 <20220510215411.GT1098723@dread.disaster.area>
 <20220511003708.GA27195@magnolia>
 <20220511013654.GC1098723@dread.disaster.area>
 <20220511021657.GA333471@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511021657.GA333471@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=627b24f4
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=TkyDigZ1AagS9JCLRRkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 12:16:57PM +1000, Chris Dunlop wrote:
> On Wed, May 11, 2022 at 11:36:54AM +1000, Dave Chinner wrote:
> > I think that's the thing that some people have missed in in this
> > thread - I've know for a while now the scope of problems blocking
> > flushes from statfs() can cause - any issue with background
> > inodegc not making progress can deadlock the filesystem. I've lost
> > count of the number of times I had inodegc go wrong or crash and the
> > only possible recovery was to power cycle because nothing could be
> > executed from the command line.
> > 
> > That's because statfs() appears to be used in some commonly used
> > library function and so many utility programs on the system will get
> > stuck and be unable to run when inodegc dies, deadlocks, or takes a
> > real long time to make progress.
> > 
> > Hence I didn't need to do any analysis of Chris' system to know
> > exactly what was going on - I've seen it many, many times myself and
> > have work in progress that avoids those issues with inodegc work
> > that never completes.
> > 
> > IOWs, everything is understood, fixes are already written, and
> > there's no actual threat of data loss or corruption from this issue.
> > It's just lots of stuff getting stuck behind a long running
> > operation...
> 
> Your patches are stuck behind other long running priorities, or the patches
> address an issue of stuff getting stuck? Or, of course, both? ;-)

I was refering to the way your system got blocked up - lots of
stuff stuck behind a long running operation. :)

As for priorities, the queue/flushing fixes are part of a body of
work in progress that I benched for 3 months when agreeing to take
over maintenance of the kernel code for the current dev cycle. My
priorities over recent weeks have been to get everyone else's work
reviewed, tested, improved, and merged, not focusing on progressing
my own projects.

As such, I wasn't considering changing inoedegc queuing in the next
merge window at all - it would just be a part of the larger body of
work when it was ready.

Your problems have made it apparent that we really need those
problems fixed ASAP (i.e. the next merge cycle) hence the priority
bump....

> Out of interest, would this work also reduce the time spent mounting in my
> case? I.e. would a lot of the work from my recovery mount be punted off to a
> background thread?

No. log recovery will punt the remaining inodegc work to background
threads so it might get slightly parallelised, but we have a hard
barrier between completing log recovery work and completing the
mount process at the moment. Hence we wait for inodegc to complete
before log recovery is marked as complete.

In theory we could allow background inodegc to bleed into active
duty once log recovery has processed all the unlinked lists, but
that's a change of behaviour that would require a careful audit of
the last part of the mount path to ensure that it is safe to be
running concurrent background operations whilst complete mount state
updates.

This hasn't been on my radar at all up until now, but I'll have a
think about it next time I look at those bits of recovery. I suspect
that probably won't be far away - I have a set of unlinked inode
list optimisations that rework the log recovery infrastructure near
the top of my current work queue, so I will be in that general
vicinity over the next few weeks...

Regardless, the inodegc work is going to be slow on your system no
matter what we do because of the underlying storage layout. What we
need to do is try to remove all the places where stuff can get
blocked on inodegc completion, but that is somewhat complex because
we still need to be able to throttle queue depths in various
situations.

As always, there is plenty of scope for improvement - the question
is working out which improvements are the ones we actually need
first...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
