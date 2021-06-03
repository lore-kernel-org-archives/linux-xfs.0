Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C43CC47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 102C6613D8
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFCWpi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:45:38 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:41023 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229610AbhFCWpi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 18:45:38 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id C37F41AFBF9;
        Fri,  4 Jun 2021 08:43:36 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1low3r-008e6X-1r; Fri, 04 Jun 2021 08:43:35 +1000
Date:   Fri, 4 Jun 2021 08:43:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/39 v5] xfs: CIL and log optimisations
Message-ID: <20210603224335.GT664593@dread.disaster.area>
References: <20210603052240.171998-1-david@fromorbit.com>
 <20210603170513.GH26402@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603170513.GH26402@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=AU4K_jjmL_ufvn0EDyEA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 10:05:13AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 03, 2021 at 03:22:01PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > This is an update of the consolidated log scalability patchset I've been working
> > on. Version 4 was posted here:
> > 
> > https://lore.kernel.org/linux-xfs/20210519121317.585244-1-david@fromorbit.com/
> > 
> > This version contains the changes Darrick requested during review. The only
> > patch remaining without at least one RVB tag is patch 30.
> > 
> > Performance improvements are largely documented in the change logs of the
> > individual patches. Headline numbers are an increase in transaction rate from
> > 700k commits/s to 1.7M commits/s, and a reduction in fua/flush operations by
> > 2-3 orders of magnitude on metadata heavy workloads that don't use fsync.
> > 
> > Summary of series:
> > 
> > Patches		Modifications
> > -------		-------------
> > 1-7:		log write FUA/FLUSH optimisations
> > 8:		bug fix
> > 9-11:		Async CIL pushes
> > 12-25:		xlog_write() rework
> > 26-39:		CIL commit scalability
> 
> From this latest posting, I see that the first nine patches all have
> multiple reviews.  Some of patches 10-19 have review tags split between
> Brian and Christoph, but neither have added them all the way through.
> I think I'm the only one who has supplied RVB tags for all forty.
> 
> So my question is: at what point would you like me to pull the segments
> of this patchset into upstream?  "The maintainer reviewed everything" is
> of course our usual standard, but this touches a /lot/ of core logging
> code, and logging isn't one of my stronger areas of familiarity.
> 
> I think 1-8 look fine for 5.14.  Do you want me to wait for Brian and/or
> Christoph (or really, any third pair of eyes) to finish working their
> way through 9-11 and 12-25 before merging them?

Quite frankly, I don't think waiting longer for more review is going
to do much to improve the code further. It's largely unchanged since
the last merge cycle went by when I was already waiting for reviews
and it was considered "not enough time to review in this cycle".
It's got enough reviews now to pass the merge bar, and the only way
we are going to shake any remaining problems with this code out is
to merge it and get it out to a wider testing base....

Indeed, if it is merged now it is going to sit another 3 months in
for-next+rc kernels before it is released to users, so I don't think
having it sit for another 3 months only in my test tree before it
gets wider testing benefits anyone. All it does is slow me down and
start pushing me towards having an entirely unmanageable review
backlog like you already have, Darrick.

Given that our rate-of-merge limitations are largely caused by a
lack of review bandwidth, putting off merging code that has already
met the review bar so it can have "more review" seems like a big
step backwards in terms of working through our review backlog. We
need to review and merge stuff faster, not block more stuff by
trying to make review capture every possible problem before we merge
the code.

So, yeah, if I were maintainer and I saw every patch had a RVB on
it, I'd be merging it straight away. But I'm not the maintainer, so
I'll do whatever you want...

I've fixed the little issues with the last posting, and it ran
through fstests just fine last night, so I'm just about ready to
send you a pull request for this series.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
