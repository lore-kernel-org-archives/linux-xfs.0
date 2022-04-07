Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703E7C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 03:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbiDGDNP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 23:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239971AbiDGDNJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 23:13:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C219C21F749
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 20:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BB6961AEF
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 03:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63AAC385A1;
        Thu,  7 Apr 2022 03:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649301066;
        bh=qiQtnxzs8xay6KKRupVj/KKyJUCez7o7UbQcmJx2dYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ndu4ZN+qgLqAK6LlJZSlSz6aTn8fsCBWkv4Otts5LfCUW/EGqWRRzeDytK5puCO1t
         rE2ifk5P8ePu5s/6plkPZpx/6+Wf36JRf7yc49VRJA0KZz47ioYuEJFHfljOGDu3KZ
         SRj1Y4gEq/6rmbkurCj4TdrSFowF6BxuMUsGc929oiUhZz1KqdNdzxVIcmt2pPZmxI
         re8rzwhI8qg3ue1cErVWWKYtyIjrbB/cBmGRKwTdpByDx3+SWl58W86yr2uL9/h0UA
         dvJ+I0l20kqjrtsxQIyLWMz4dX21bgyKdqMB35TnxoHDpkT0xioD9GLPn4/ake9yFe
         dd/gnqwAfk1kw==
Date:   Wed, 6 Apr 2022 20:11:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [5.19 cycle] Planning and goals
Message-ID: <20220407031106.GB27690@magnolia>
References: <20220405020312.GU1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405020312.GU1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 05, 2022 at 12:03:12PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> I'd really like to try getting the merge bottlenecks we've had
> recently unstuck, so there are a few patchsets I want to try to get
> reviewed, tested and merged for 5.19. Hopefully not too many
> surprises will get in the way and so some planning to try to
> minimises surprised might be a good thing.  Hence I want to have a
> rough plan for the work I'd like to acheive during this 5.19 cycle,
> and so that everyone has an idea of what needs to be done to (maybe)
> achieve those goals over the next few weeks.
> 
> First of all, a rough timeline that I'm working with:
> 
> 5.18-rc1:	where we are now
> 5.18-rc2:	Update linux-xfs master branch to 5.19-rc2

Presumably you meant 5.18-rc2 here?

> 5.18-rc4:	At least 2 of the major pending works merged
> 5.18-rc6:	Last point for new work to be merged
> 5.18-rc6+:	Bug fixes only will be merged 
> 
> I'm assuming a -rc7 kernel will be released, hence this rough
> timeline gives us 2 weeks of testing/stabilisation time before 5.19
> merge window opens. 
> 
> Patchsets for review should be based on either 5.17.0 or the
> linux-xfs master branch once it has been updated to 5.19-rc2. If

...and here?

> there are important bug fixes for the 5.18 cycle, I may move the
> master branch forwards to a more recent release.
>
> In terms of merge process, I plan to keep each major set of work in
> a separate topic branch so that once it has been merged the commit
> IDs remain stable. I will then merge the topic branches into the
> for-next branch. Hence the for-next tree may still rebase (e.g. if I
> need to send fixes for 5.18-rcX), but I hope to keep the individual
> commits that make up the for-next branch as stable as possible. Bug
> fixes for patchsets will get appended to the topic branches and the
> for-next branch rebuilt via a new set of merges.

Hmm, that's a way to do it that I hadn't previously considered.

> The major patchsets that I'm hoping to get reviewed and merged this
> cycle:
> 
> - large extent counts V8 (Chandan)
> 	- Merge criteria and status:
> 		- review complete: 95%
> 		- no regressions when not enabled: 70%
> 		- no major regressions when enabled: 0%
> 	- Open questions:
> 		- Experimental tag for the first couple of cycles?
> 		  (Darrick says "YES" on #xfs)
> 	- Needs more QA, but signs are good so far.
> 	- Almost ready to merge.

I think this one is mostly ready to go, with the few nits fixed that you
and I have already posted about.

> - Logged attributes V28 (Allison)
> 	- I haven't looked at this since V24, so I'm not sure what
> 	  the current status is. I will do that discovery later in
> 	  the week.
> 	- Merge criteria and status:
> 		- review complete: Not sure
> 		- no regressions when not enabled: v24 was OK
> 		- no major regressions when enabled: v24 had issues
> 	- Open questions:
> 		- not sure what review will uncover
> 		- don't know what problems testing will show
> 		- what other log fixes does it depend on?
> 		- is there a performance impact when not enabled?

Hm.  Last time I went through this I was mostly satisfied except for (a)
all of the subtle rules about who owns and frees the attr name/value
buffers, and (b) all that stuff with the alignment/sizing asserts
tripping on fsstress loop tests.

I /think/ Allison's fixed (a), and I think Dave had a patch or two for
(b)?

Oh one more thing:

ISTR one of the problems is that the VFS allocates an onstack
buffer for the xattr name.  The buffer is char[], so the start of it
isn't necessarily aligned to what the logging code wants; and the end of
it (since it's 255 bytes long) almost assuredly isn't.

> - DAX + reflink V11 (Ruan)
> 	- Merge criteria and status:
> 		- review complete: 75%
> 		- no regressions when not enabled: unknown
> 		- no major regressions when enabled: unknown
> 	- Open questions:
> 		- still a little bit of change around change
> 		  notification?
> 		- Not sure when V12 will arrive, hence can't really
> 		  plan for this right now.
> 		- external dependencies?

I thought the XFS part of this patchset looked like it was in good
enough shape to merge, but the actual infrastructure stuff (AKA messing
with mm/ and dax code) hasn't gotten a review.  I don't really have the
depth to know if the changes proposed are good or bad.

> - xlog_write() rework V8
> 	- Merge criteria and status:
> 		- review complete: 100%
> 		- No regressions in testing: 100%
> 	- Open questions:
> 		- unchanged since last review/merge attempt,
> 		  reverted because of problems with other code that
> 		  was merged with it that isn't in this patchset
> 		  now. Does it need re-reviewing?

I suggest you rebase to something recent (5.17.0 + xfs-5.18-merge-4?)
and send it to the list for a quick once-over before merging that.
IIRC I understood it well enough to have been ok with putting it in.

That said, if you push a branch somewhere I'll give it a spin on my
testfrastructure to see if anything else falls off.

> 	- Ready to merge.
> 
> - Intent Whiteouts V3
> 	- Merge criteria and status:
> 		- review complete: 0%
> 		- No regressions in testing: 100%
> 	- Open questions:
> 		- will it get reviewed in time?
> 		- what bits of the patchset does LARP depend on?
> 		- Is LARP perf without intent whiteouts acceptible
> 		  (Experimental tag tends to suggest yes).
> 	- Functionally complete and tested, just needs review.

<shrug> No opinions, having never seen this before(?)

> Have I missed any of the major outstanding things that are nearly
> ready to go?

At this point my rmap/reflink performance speedups series are ready for
review, but I think the xlog and nrext64 are more than enough for a
single cycle.

> Do the patchset authors have the time available in the next 2-3
> weeks to make enough progress to get their work merged? I'd kinda
> like to have the xlog_write() rework and the large extent counts
> merged ASAP so we have plenty of time to focus on the more
> complex/difficult pieces.  If you don't have time in the next few
> weeks, then let me know so I can adjust the plan appropriately for
> the cycle.
> 
> What does everyone think of the plan?

I like that you're making the plan explicit.  I'd wanted to talk about
doing this back at LPC 2021, but nobody from RH registered... :(

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
