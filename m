Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E9BC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Apr 2022 18:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbiDJSX1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 14:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiDJSX1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 14:23:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8454822534
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 11:21:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46883B80E58
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056D5C385AA;
        Sun, 10 Apr 2022 18:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649614873;
        bh=qBu/dthDllTqe5Gd/UBYUW5GeAkaFisnqSbQDY4AEtM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IzcbbCKlAujgzU3Ag8qOhaukHzBiGXKuLficYGAMLMvMFWGiDkshaIWNynNw4vCaG
         0017rEZwFXFJ8k1pQ4ovhPMJC74Yt8aklSOAk9zJ86m5NVHmzUpNK0Cyo8cgeTuyam
         bbVx5+j/Yi7wrvm0SmsHOBY2q1N314xZfM96vaqdIlnOTY2+H/YjgygVICW/ojBoGp
         T0gJg+mGTR23TnOczgH0dFvBzbTI95l0Bw+cnxiJF5C3Y7vZ3p+fCHFv1lWnz2KB9E
         FyQzLzseBXCtW/6TG20XgPtVYDfK0ltY7nFcvS5o15HnB6SJBxP2c569RdFfUt90zk
         REHr6IjL7608A==
Date:   Sun, 10 Apr 2022 11:21:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [5.19 cycle] Planning and goals
Message-ID: <20220410182112.GA14125@magnolia>
References: <20220405020312.GU1544202@dread.disaster.area>
 <20220407031106.GB27690@magnolia>
 <20220407054939.GJ1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407054939.GJ1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 07, 2022 at 03:49:39PM +1000, Dave Chinner wrote:
> On Wed, Apr 06, 2022 at 08:11:06PM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 05, 2022 at 12:03:12PM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > I'd really like to try getting the merge bottlenecks we've had
> > > recently unstuck, so there are a few patchsets I want to try to get
> > > reviewed, tested and merged for 5.19. Hopefully not too many
> > > surprises will get in the way and so some planning to try to
> > > minimises surprised might be a good thing.  Hence I want to have a
> > > rough plan for the work I'd like to acheive during this 5.19 cycle,
> > > and so that everyone has an idea of what needs to be done to (maybe)
> > > achieve those goals over the next few weeks.
> > > 
> > > First of all, a rough timeline that I'm working with:
> > > 
> > > 5.18-rc1:	where we are now
> > > 5.18-rc2:	Update linux-xfs master branch to 5.19-rc2
> > 
> > Presumably you meant 5.18-rc2 here?
> > 
> > > 5.18-rc4:	At least 2 of the major pending works merged
> > > 5.18-rc6:	Last point for new work to be merged
> > > 5.18-rc6+:	Bug fixes only will be merged 
> > > 
> > > I'm assuming a -rc7 kernel will be released, hence this rough
> > > timeline gives us 2 weeks of testing/stabilisation time before 5.19
> > > merge window opens. 
> > > 
> > > Patchsets for review should be based on either 5.17.0 or the
> > > linux-xfs master branch once it has been updated to 5.19-rc2. If
> > 
> > ...and here?
> 
> Yes, I meant 5.18-rc2.
> 
> > > - Logged attributes V28 (Allison)
> > > 	- I haven't looked at this since V24, so I'm not sure what
> > > 	  the current status is. I will do that discovery later in
> > > 	  the week.
> > > 	- Merge criteria and status:
> > > 		- review complete: Not sure
> > > 		- no regressions when not enabled: v24 was OK
> > > 		- no major regressions when enabled: v24 had issues
> > > 	- Open questions:
> > > 		- not sure what review will uncover
> > > 		- don't know what problems testing will show
> > > 		- what other log fixes does it depend on?
> > > 		- is there a performance impact when not enabled?
> > 
> > Hm.  Last time I went through this I was mostly satisfied except for (a)
> > all of the subtle rules about who owns and frees the attr name/value
> > buffers, and (b) all that stuff with the alignment/sizing asserts
> > tripping on fsstress loop tests.
> > 
> > I /think/ Allison's fixed (a), and I think Dave had a patch or two for
> > (b)?
> 
> Yup, I think the patches in the intent whiteout series fix the
> issues with the log iovecs that came up.
> 
> > Oh one more thing:
> > 
> > ISTR one of the problems is that the VFS allocates an onstack
> > buffer for the xattr name.  The buffer is char[], so the start of it
> > isn't necessarily aligned to what the logging code wants; and the end of
> > it (since it's 255 bytes long) almost assuredly isn't.
> 
> Not sure that is a problem - we're copying them into log iovecs in
> the shadow buffer - the iovecs in the shadow buffer have alignment
> constraints because xlog_write() needing 4 byte alignment of ophdrs,
> but the source buffer they get memcpy()d from has no alignment
> restrictions.
> 
> I still need check that the code hasn't changed since v24 when I
> looked at this in detail, but I think the VFS buffer is fine.
> 
> > > - DAX + reflink V11 (Ruan)
> > > 	- Merge criteria and status:
> > > 		- review complete: 75%
> > > 		- no regressions when not enabled: unknown
> > > 		- no major regressions when enabled: unknown
> > > 	- Open questions:
> > > 		- still a little bit of change around change
> > > 		  notification?
> > > 		- Not sure when V12 will arrive, hence can't really
> > > 		  plan for this right now.
> > > 		- external dependencies?
> > 
> > I thought the XFS part of this patchset looked like it was in good
> > enough shape to merge, but the actual infrastructure stuff (AKA messing
> > with mm/ and dax code) hasn't gotten a review.  I don't really have the
> > depth to know if the changes proposed are good or bad.
> 
> Most of the patches have RVBs when I checked a couple of days ago.
> There's a couple that still need work. I'm mostly relying on Dan and
> Christoph to finish the reviews of this, hopefully it won't take
> more than one more round...
> 
> > > - xlog_write() rework V8
> > > 	- Merge criteria and status:
> > > 		- review complete: 100%
> > > 		- No regressions in testing: 100%
> > > 	- Open questions:
> > > 		- unchanged since last review/merge attempt,
> > > 		  reverted because of problems with other code that
> > > 		  was merged with it that isn't in this patchset
> > > 		  now. Does it need re-reviewing?
> > 
> > I suggest you rebase to something recent (5.17.0 + xfs-5.18-merge-4?)
> > and send it to the list for a quick once-over before merging that.
> > IIRC I understood it well enough to have been ok with putting it in.
> 
> When I last posted it (March 9) it was rebased against 5.17-rc4:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git/log/?h=xlog-write-rework-3
> https://lore.kernel.org/linux-xfs/20220309052937.2696447-1-david@fromorbit.com/
> 
> And it I think there's only been a line or two change for rebasing
> to the current for-next branch. 
> 
> I have a current base on 5.17+for-next, so if you need a newer
> version to check over I can send that out easily enough...

Ah, ok, that rework-3 branch looks fine to me.

> > > 	- Ready to merge.
> > > 
> > > - Intent Whiteouts V3
> > > 	- Merge criteria and status:
> > > 		- review complete: 0%
> > > 		- No regressions in testing: 100%
> > > 	- Open questions:
> > > 		- will it get reviewed in time?
> > > 		- what bits of the patchset does LARP depend on?
> > > 		- Is LARP perf without intent whiteouts acceptible
> > > 		  (Experimental tag tends to suggest yes).
> > > 	- Functionally complete and tested, just needs review.
> > 
> > <shrug> No opinions, having never seen this before(?)
> 
> First RFC was 7 months ago:
> 
> https://lore.kernel.org/linux-xfs/20210902095927.911100-1-david@fromorbit.com/
> 
> I mentioned it here in the 5.16 cycle planning discussion:
> 
> https://lore.kernel.org/linux-xfs/20210922053047.GS1756565@dread.disaster.area/
> 
> I posted v3 on 5.17-rc4 and xlog-write-rewrite back on about 3
> weeks ago now:
> 
> https://lore.kernel.org/linux-xfs/20220314220631.3093283-1-david@fromorbit.com/
> 
> and like the xlog-write rework it is largely unchanged by a rebase
> to 5.17.0+for-next.

Ok, I'll have a second look tomorrow (Monday).

> > > Have I missed any of the major outstanding things that are nearly
> > > ready to go?
> > 
> > At this point my rmap/reflink performance speedups series are ready for
> > review,
> 
> OK, what's the timeframe for you getting them out for review? Today,
> next week, -rc4?

I'll send them as soon as the frextents bugfix series clears review.

> > but I think the xlog and nrext64 are more than enough for a
> > single cycle.
> 
> Except we've already done most of the work needed to merge them and
> we aren't even at -rc2. That leaves another 4 weeks of time to
> review, test and merge other work before we hit the -rc6 cutoff.
> The plan I've outlined is based on what I think *I* can acheive in
> the cycle, but I have no doubt that some of it will not get done
> because that's the way these things always go. SO I've aimed high,
> knowing that we're more likely to hit the middle of the target
> range...
> 
> That said, if the code is reviewed, ready to merge and passes initial
> regression tests, then I'll merge it regardless of how much else
> I've already got queued up.

Ok.

> > > Do the patchset authors have the time available in the next 2-3
> > > weeks to make enough progress to get their work merged? I'd kinda
> > > like to have the xlog_write() rework and the large extent counts
> > > merged ASAP so we have plenty of time to focus on the more
> > > complex/difficult pieces.  If you don't have time in the next few
> > > weeks, then let me know so I can adjust the plan appropriately for
> > > the cycle.
> > > 
> > > What does everyone think of the plan?
> > 
> > I like that you're making the plan explicit.  I'd wanted to talk about
> > doing this back at LPC 2021, but nobody from RH registered... :(
> 
> Lead by example - you need to don't ask for permission or build
> consensus for doing something you think needs to be done. We don't
> need to discuss whether we should have a planning discussion, just
> publish the plan and that will naturally lead to a discussion of
> the plan.

Yeah, it's funny -- 20 years ago me would have done exactly this.

> Speaking as the "merge shepherd" for this release, what I want from
> this discussion is feedback that points out things I've missed, for
> the authors of patchsets that I've flagged as merge candidates to
> tell me if they are able to do the work needed in the next 4-6 weeks
> to get their work merged, for people to voice their concerns about
> aspects of the plan, etc.

<nod> I hope you've gotten enough info to proceed, then?

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
