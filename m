Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA71DC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 01:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240003AbiDKBwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 21:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244383AbiDKBwj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 21:52:39 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0040C7F
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:50:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F14C853B539;
        Mon, 11 Apr 2022 11:50:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndjCB-00GFjR-B6; Mon, 11 Apr 2022 11:50:23 +1000
Date:   Mon, 11 Apr 2022 11:50:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [5.19 cycle] Planning and goals
Message-ID: <20220411015023.GV1544202@dread.disaster.area>
References: <20220405020312.GU1544202@dread.disaster.area>
 <20220407031106.GB27690@magnolia>
 <20220407054939.GJ1544202@dread.disaster.area>
 <ff1aa185470226b5dac3b8e914277137a88e97e6.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff1aa185470226b5dac3b8e914277137a88e97e6.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62538961
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=fqqKsbnVYtvG127Tr34A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 07, 2022 at 03:40:08PM -0700, Alli wrote:
> On Thu, 2022-04-07 at 15:49 +1000, Dave Chinner wrote:
> > On Wed, Apr 06, 2022 at 08:11:06PM -0700, Darrick J. Wong wrote:
> > > On Tue, Apr 05, 2022 at 12:03:12PM +1000, Dave Chinner wrote:
> > > > Hi folks,
> > > > 
> > > > I'd really like to try getting the merge bottlenecks we've had
> > > > recently unstuck, so there are a few patchsets I want to try to
> > > > get
> > > > reviewed, tested and merged for 5.19. Hopefully not too many
> > > > surprises will get in the way and so some planning to try to
> > > > minimises surprised might be a good thing.  Hence I want to have
> > > > a
> > > > rough plan for the work I'd like to acheive during this 5.19
> > > > cycle,
> > > > and so that everyone has an idea of what needs to be done to
> > > > (maybe)
> > > > achieve those goals over the next few weeks.
> > > > 
> > > > First of all, a rough timeline that I'm working with:
> > > > 
> > > > 5.18-rc1:	where we are now
> > > > 5.18-rc2:	Update linux-xfs master branch to 5.19-rc2
> > > 
> > > Presumably you meant 5.18-rc2 here?
> > > 
> > > > 5.18-rc4:	At least 2 of the major pending works merged
> > > > 5.18-rc6:	Last point for new work to be merged
> > > > 5.18-rc6+:	Bug fixes only will be merged 
> > > > 
> > > > I'm assuming a -rc7 kernel will be released, hence this rough
> > > > timeline gives us 2 weeks of testing/stabilisation time before
> > > > 5.19
> > > > merge window opens. 
> > > > 
> > > > Patchsets for review should be based on either 5.17.0 or the
> > > > linux-xfs master branch once it has been updated to 5.19-rc2. If
> > > 
> > > ...and here?
> > 
> > Yes, I meant 5.18-rc2.
> > 
> > > > - Logged attributes V28 (Allison)
> > > > 	- I haven't looked at this since V24, so I'm not sure what
> > > > 	  the current status is. I will do that discovery later in
> > > > 	  the week.
> > > > 	- Merge criteria and status:
> > > > 		- review complete: Not sure
> So far each patch in v29 has at least 2 rvbs I think

OK.

> > > > 		- no regressions when not enabled: v24 was OK
> > > > 		- no major regressions when enabled: v24 had issues
> > > > 	- Open questions:
> > > > 		- not sure what review will uncover
> > > > 		- don't know what problems testing will show
> > > > 		- what other log fixes does it depend on?
> If it goes on top of whiteouts, it will need some modifications to
> follow the new log item changes that the whiteout set makes.
> 
> Alternately, if the white out set goes in after the larp set, then it
> will need to apply the new log item changes to xfs_attr_item.c as well

I figured as much, thanks for confirming!

> Looking forward, once we get the kernel patches worked out, we should
> probably port the corresponding patches to xfsprogs before enabling the
> feature.  I have a patch to print the new log item in a dump.

You mean for xfs_logprint? 

> It's not
> very complicated though, I don't think it will take too many reviews to
> get through though.

*nod*

> > > > - Intent Whiteouts V3
> > > > 	- Merge criteria and status:
> > > > 		- review complete: 0%
> I think patch 2 of this set is the same as patch 2 of the larp set.  If
> you agree with the review results, you can just take patch 2 from the
> larp series, and have 2 rvbs for this one

OK. I'll duplicate the rvbs so whichever gets merged first contains
them.

> > > > 		- No regressions in testing: 100%
> > > > 	- Open questions:
> > > > 		- will it get reviewed in time?
> > > > 		- what bits of the patchset does LARP depend on?
> Just from glancing at the sets, I don't think they have merge conflicts
> other than patch 2, which can simply be dropped from one of the sets.
> 
> However, patches 3,4,6,7 of the whiteout set make a series of changes
> to the xfs_*_item.c files.  So similar changes need to be applied to
> the new fs/xfs/xfs_attr_item.c that the larp set introduces 

*nod*

Thanks for the update, Allison.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
