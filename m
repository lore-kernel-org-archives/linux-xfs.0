Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15960C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 05:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbiEKFSe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 May 2022 01:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbiEKFSd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 May 2022 01:18:33 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6840C231CBA
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 22:18:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5CBA510E6A78;
        Wed, 11 May 2022 15:18:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1noek1-00AZR7-10; Wed, 11 May 2022 15:18:29 +1000
Date:   Wed, 11 May 2022 15:18:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Highly reflinked and fragmented considered harmful?
Message-ID: <20220511051829.GH1098723@dread.disaster.area>
References: <20220510051057.GY27195@magnolia>
 <20220510063051.GA215522@onthe.net.au>
 <20220510081632.GS1098723@dread.disaster.area>
 <20220510191918.GD27195@magnolia>
 <20220510215411.GT1098723@dread.disaster.area>
 <20220511003708.GA27195@magnolia>
 <20220511013654.GC1098723@dread.disaster.area>
 <20220511021657.GA333471@onthe.net.au>
 <20220511025235.GG1098723@dread.disaster.area>
 <20220511035813.GA342362@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511035813.GA342362@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=627b4727
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=2VJgV-_3Ko9OsoYCn-0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 01:58:13PM +1000, Chris Dunlop wrote:
> On Wed, May 11, 2022 at 12:52:35PM +1000, Dave Chinner wrote:
> > On Wed, May 11, 2022 at 12:16:57PM +1000, Chris Dunlop wrote:
> > > Out of interest, would this work also reduce the time spent mounting
> > > in my case? I.e. would a lot of the work from my recovery mount be
> > > punted off to a background thread?
> > 
> > No. log recovery will punt the remaining inodegc work to background
> > threads so it might get slightly parallelised, but we have a hard
> > barrier between completing log recovery work and completing the
> > mount process at the moment. Hence we wait for inodegc to complete
> > before log recovery is marked as complete.
> > 
> > In theory we could allow background inodegc to bleed into active
> > duty once log recovery has processed all the unlinked lists, but
> > that's a change of behaviour that would require a careful audit of
> > the last part of the mount path to ensure that it is safe to be
> > running concurrent background operations whilst complete mount state
> > updates.
> > 
> > This hasn't been on my radar at all up until now, but I'll have a
> > think about it next time I look at those bits of recovery. I suspect
> > that probably won't be far away - I have a set of unlinked inode
> > list optimisations that rework the log recovery infrastructure near
> > the top of my current work queue, so I will be in that general
> > vicinity over the next few weeks...
> 
> I'll keep an eye out.
> 
> > Regardless, the inodegc work is going to be slow on your system no
> > matter what we do because of the underlying storage layout. What we
> > need to do is try to remove all the places where stuff can get
> > blocked on inodegc completion, but that is somewhat complex because
> > we still need to be able to throttle queue depths in various
> > situations.
> 
> That reminds of a something I've been wondering about for obvious reasons:
> for workloads where metadata operations are dominant, do you have any
> ponderings on allowing AGs to be put on fast storage whilst the bulk data is
> on molasses storage?

If you're willing to give up reflink and pretty much all the
allocation optimisations for storage locality that make spinning
disks perform OK, then you can do this right now with a realtime
device as the user data store. You still have AGs, but they will
contain metadata only - your bulk data storage device is the
realtime device.

This has downsides. You give up reflink. You give up rmap. You give
up allocation concurrency. You give up btree indexed free space,
which means giving up the ability to find optimal free spaces.
Allocation algorithms are optimised for deterministic, bound
overhead behaviour (the "realtime" aspect of the RT device) so you
give up smart, context aware allocation algorithms. the list goes
on.

reflink and rmap support for the realtime device are in the pipeline
(not likely to be added in the near term), but solutions for any of
the other issues are not. They are intrinsic behaviours that result
from the realtime device architecture.

However, there's no real way to separate data in AGs from metadata
in AGs - they share the same address space and there's no simple way
to keep them separate and map different parts of the AG to different
storage devices. that would require a fair chunk of slicing and
dicing at the DM level, and then we have a whole net set of problems
to deal with when AGs run out of metadata space because reflink
and/or rmap metadata explosions...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
