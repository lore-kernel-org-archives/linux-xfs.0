Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318A8C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 05:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbiDGFvv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 01:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiDGFvt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 01:51:49 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CAC85F96
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 22:49:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6D9B310E5798;
        Thu,  7 Apr 2022 15:49:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ncL1X-00Ejv9-SP; Thu, 07 Apr 2022 15:49:39 +1000
Date:   Thu, 7 Apr 2022 15:49:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [5.19 cycle] Planning and goals
Message-ID: <20220407054939.GJ1544202@dread.disaster.area>
References: <20220405020312.GU1544202@dread.disaster.area>
 <20220407031106.GB27690@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407031106.GB27690@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=624e7b75
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=J8Eq25Ao0zjco5Xj1pAA:9 a=CjuIK1q_8ugA:10 a=C4EVcynWyuAA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 08:11:06PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 05, 2022 at 12:03:12PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > I'd really like to try getting the merge bottlenecks we've had
> > recently unstuck, so there are a few patchsets I want to try to get
> > reviewed, tested and merged for 5.19. Hopefully not too many
> > surprises will get in the way and so some planning to try to
> > minimises surprised might be a good thing.  Hence I want to have a
> > rough plan for the work I'd like to acheive during this 5.19 cycle,
> > and so that everyone has an idea of what needs to be done to (maybe)
> > achieve those goals over the next few weeks.
> > 
> > First of all, a rough timeline that I'm working with:
> > 
> > 5.18-rc1:	where we are now
> > 5.18-rc2:	Update linux-xfs master branch to 5.19-rc2
> 
> Presumably you meant 5.18-rc2 here?
> 
> > 5.18-rc4:	At least 2 of the major pending works merged
> > 5.18-rc6:	Last point for new work to be merged
> > 5.18-rc6+:	Bug fixes only will be merged 
> > 
> > I'm assuming a -rc7 kernel will be released, hence this rough
> > timeline gives us 2 weeks of testing/stabilisation time before 5.19
> > merge window opens. 
> > 
> > Patchsets for review should be based on either 5.17.0 or the
> > linux-xfs master branch once it has been updated to 5.19-rc2. If
> 
> ...and here?

Yes, I meant 5.18-rc2.

> > - Logged attributes V28 (Allison)
> > 	- I haven't looked at this since V24, so I'm not sure what
> > 	  the current status is. I will do that discovery later in
> > 	  the week.
> > 	- Merge criteria and status:
> > 		- review complete: Not sure
> > 		- no regressions when not enabled: v24 was OK
> > 		- no major regressions when enabled: v24 had issues
> > 	- Open questions:
> > 		- not sure what review will uncover
> > 		- don't know what problems testing will show
> > 		- what other log fixes does it depend on?
> > 		- is there a performance impact when not enabled?
> 
> Hm.  Last time I went through this I was mostly satisfied except for (a)
> all of the subtle rules about who owns and frees the attr name/value
> buffers, and (b) all that stuff with the alignment/sizing asserts
> tripping on fsstress loop tests.
> 
> I /think/ Allison's fixed (a), and I think Dave had a patch or two for
> (b)?

Yup, I think the patches in the intent whiteout series fix the
issues with the log iovecs that came up.

> Oh one more thing:
> 
> ISTR one of the problems is that the VFS allocates an onstack
> buffer for the xattr name.  The buffer is char[], so the start of it
> isn't necessarily aligned to what the logging code wants; and the end of
> it (since it's 255 bytes long) almost assuredly isn't.

Not sure that is a problem - we're copying them into log iovecs in
the shadow buffer - the iovecs in the shadow buffer have alignment
constraints because xlog_write() needing 4 byte alignment of ophdrs,
but the source buffer they get memcpy()d from has no alignment
restrictions.

I still need check that the code hasn't changed since v24 when I
looked at this in detail, but I think the VFS buffer is fine.

> > - DAX + reflink V11 (Ruan)
> > 	- Merge criteria and status:
> > 		- review complete: 75%
> > 		- no regressions when not enabled: unknown
> > 		- no major regressions when enabled: unknown
> > 	- Open questions:
> > 		- still a little bit of change around change
> > 		  notification?
> > 		- Not sure when V12 will arrive, hence can't really
> > 		  plan for this right now.
> > 		- external dependencies?
> 
> I thought the XFS part of this patchset looked like it was in good
> enough shape to merge, but the actual infrastructure stuff (AKA messing
> with mm/ and dax code) hasn't gotten a review.  I don't really have the
> depth to know if the changes proposed are good or bad.

Most of the patches have RVBs when I checked a couple of days ago.
There's a couple that still need work. I'm mostly relying on Dan and
Christoph to finish the reviews of this, hopefully it won't take
more than one more round...

> > - xlog_write() rework V8
> > 	- Merge criteria and status:
> > 		- review complete: 100%
> > 		- No regressions in testing: 100%
> > 	- Open questions:
> > 		- unchanged since last review/merge attempt,
> > 		  reverted because of problems with other code that
> > 		  was merged with it that isn't in this patchset
> > 		  now. Does it need re-reviewing?
> 
> I suggest you rebase to something recent (5.17.0 + xfs-5.18-merge-4?)
> and send it to the list for a quick once-over before merging that.
> IIRC I understood it well enough to have been ok with putting it in.

When I last posted it (March 9) it was rebased against 5.17-rc4:

https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git/log/?h=xlog-write-rework-3
https://lore.kernel.org/linux-xfs/20220309052937.2696447-1-david@fromorbit.com/

And it I think there's only been a line or two change for rebasing
to the current for-next branch. 

I have a current base on 5.17+for-next, so if you need a newer
version to check over I can send that out easily enough...

> > 	- Ready to merge.
> > 
> > - Intent Whiteouts V3
> > 	- Merge criteria and status:
> > 		- review complete: 0%
> > 		- No regressions in testing: 100%
> > 	- Open questions:
> > 		- will it get reviewed in time?
> > 		- what bits of the patchset does LARP depend on?
> > 		- Is LARP perf without intent whiteouts acceptible
> > 		  (Experimental tag tends to suggest yes).
> > 	- Functionally complete and tested, just needs review.
> 
> <shrug> No opinions, having never seen this before(?)

First RFC was 7 months ago:

https://lore.kernel.org/linux-xfs/20210902095927.911100-1-david@fromorbit.com/

I mentioned it here in the 5.16 cycle planning discussion:

https://lore.kernel.org/linux-xfs/20210922053047.GS1756565@dread.disaster.area/

I posted v3 on 5.17-rc4 and xlog-write-rewrite back on about 3
weeks ago now:

https://lore.kernel.org/linux-xfs/20220314220631.3093283-1-david@fromorbit.com/

and like the xlog-write rework it is largely unchanged by a rebase
to 5.17.0+for-next.

> > Have I missed any of the major outstanding things that are nearly
> > ready to go?
> 
> At this point my rmap/reflink performance speedups series are ready for
> review,

OK, what's the timeframe for you getting them out for review? Today,
next week, -rc4?

> but I think the xlog and nrext64 are more than enough for a
> single cycle.

Except we've already done most of the work needed to merge them and
we aren't even at -rc2. That leaves another 4 weeks of time to
review, test and merge other work before we hit the -rc6 cutoff.
The plan I've outlined is based on what I think *I* can acheive in
the cycle, but I have no doubt that some of it will not get done
because that's the way these things always go. SO I've aimed high,
knowing that we're more likely to hit the middle of the target
range...

That said, if the code is reviewed, ready to merge and passes initial
regression tests, then I'll merge it regardless of how much else
I've already got queued up.

> > Do the patchset authors have the time available in the next 2-3
> > weeks to make enough progress to get their work merged? I'd kinda
> > like to have the xlog_write() rework and the large extent counts
> > merged ASAP so we have plenty of time to focus on the more
> > complex/difficult pieces.  If you don't have time in the next few
> > weeks, then let me know so I can adjust the plan appropriately for
> > the cycle.
> > 
> > What does everyone think of the plan?
> 
> I like that you're making the plan explicit.  I'd wanted to talk about
> doing this back at LPC 2021, but nobody from RH registered... :(

Lead by example - you need to don't ask for permission or build
consensus for doing something you think needs to be done. We don't
need to discuss whether we should have a planning discussion, just
publish the plan and that will naturally lead to a discussion of
the plan.

Speaking as the "merge shepherd" for this release, what I want from
this discussion is feedback that points out things I've missed, for
the authors of patchsets that I've flagged as merge candidates to
tell me if they are able to do the work needed in the next 4-6 weeks
to get their work merged, for people to voice their concerns about
aspects of the plan, etc.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
