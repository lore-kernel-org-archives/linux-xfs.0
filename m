Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2400C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 01:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiEKBhA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 21:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiEKBg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 21:36:59 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B72E56208
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 18:36:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 48FE110E6A2D;
        Wed, 11 May 2022 11:36:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nobHb-00AVlc-06; Wed, 11 May 2022 11:36:55 +1000
Date:   Wed, 11 May 2022 11:36:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chris Dunlop <chris@onthe.net.au>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220511013654.GC1098723@dread.disaster.area>
References: <20220509024659.GA62606@onthe.net.au>
 <20220509230918.GP1098723@dread.disaster.area>
 <CAOQ4uxgf6AHzLM-mGte_L-A+piSZTRsbdLMBT3hZFNhk-yfxZQ@mail.gmail.com>
 <20220510051057.GY27195@magnolia>
 <20220510063051.GA215522@onthe.net.au>
 <20220510081632.GS1098723@dread.disaster.area>
 <20220510191918.GD27195@magnolia>
 <20220510215411.GT1098723@dread.disaster.area>
 <20220511003708.GA27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511003708.GA27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=627b1339
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=iFpKcpqHwzTDbUVbHOIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 05:37:08PM -0700, Darrick J. Wong wrote:
> On Wed, May 11, 2022 at 07:54:11AM +1000, Dave Chinner wrote:
> > On Tue, May 10, 2022 at 12:19:18PM -0700, Darrick J. Wong wrote:
> > > On Tue, May 10, 2022 at 06:16:32PM +1000, Dave Chinner wrote:
> > > > I think we should just accept that statfs() can never really report
> > > > exactly accurate space usagei to userspace and get rid of the flush.
> > > 
> > > What about all the code that flushes gc work when we hit ENOSPC/EDQUOT?
> > > Do we let those threads stall too because the fs is out of resources and
> > > they can just wait?  Or would that also be better off with a flush
> > > timeout and userspace can just eat the ENOSPC/EDQUOT after 30 seconds?
> > 
> > 1. Not an immediate problem we need to solve.
> > 2. flush at enospc/edquot is best effort, so doesn't need to block
> >    waiting on inodegc. the enospc/edquot flush will get repeated
> >    soon enough, so that will take into account progress made by
> >    long running inodegc ops.
> > 3. we leave pending work on the per-cpu queues under the
> >    flush/throttle thresholds indefinitely.
> > 4. to be accurate, statfs() needs to flush #3.
> 
> Yes, that's the state of things currently...
> 
> > 5. While working on the rework of inode reclaimation, I converted the
> >    inodegc queues to use delayed works to ensure work starts on
> >    per-cpu queues within 10ms of queueing to avoid #3 causing
> >    problems.
> > 6. I added a non-blocking async flush mechanism that works by
> >    modifying the queue timer to 0 to trigger immedate work
> >    scheduling for anything that hasn't been run.
> 
> *OH*, you've already built those two things?  Well that makes this
> /much/ easier.  I think all we'd need to fix #4 is an xfs_inodegc_push()
> function that statfs/enospc/edquot can call to do xfs_inodegc_queue_all
> and return immediately.

*nod*.

I think that's the thing that some people have missed in in this
thread - I've know for a while now the scope of problems blocking
flushes from statfs() can cause - any issue with background
inodegc not making progress can deadlock the filesystem. I've lost
count of the number of times I had inodegc go wrong or crash and the
only possible recovery was to power cycle because nothing could be
executed from the command line.

That's because statfs() appears to be used in some commonly used
library function and so many utility programs on the system will get
stuck and be unable to run when inodegc dies, deadlocks, or takes a
real long time to make progress.

Hence I didn't need to do any analysis of Chris' system to know
exactly what was going on - I've seen it many, many times myself and
have work in progress that avoids those issues with inodegc work
that never completes.

IOWs, everything is understood, fixes are already written, and
there's no actual threat of data loss or corruption from this issue.
It's just lots of stuff getting stuck behind a long running
operation...

All this report means is that I have to bump the priority of that
work, separate it out into it's own series and make sure it's ready
for the next cycle.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
