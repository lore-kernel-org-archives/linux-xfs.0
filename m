Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BF9C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Apr 2022 02:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiDECzE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 22:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiDECy5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Apr 2022 22:54:57 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2F1D204284
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 19:03:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7574B534462
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 12:03:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nbYXI-00Dt4I-Tu
        for linux-xfs@vger.kernel.org; Tue, 05 Apr 2022 12:03:12 +1000
Date:   Tue, 5 Apr 2022 12:03:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [5.19 cycle] Planning and goals
Message-ID: <20220405020312.GU1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=624ba362
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=p6uJBkLvhlZeFVNXkkcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I'd really like to try getting the merge bottlenecks we've had
recently unstuck, so there are a few patchsets I want to try to get
reviewed, tested and merged for 5.19. Hopefully not too many
surprises will get in the way and so some planning to try to
minimises surprised might be a good thing.  Hence I want to have a
rough plan for the work I'd like to acheive during this 5.19 cycle,
and so that everyone has an idea of what needs to be done to (maybe)
achieve those goals over the next few weeks.

First of all, a rough timeline that I'm working with:

5.18-rc1:	where we are now
5.18-rc2:	Update linux-xfs master branch to 5.19-rc2
5.18-rc4:	At least 2 of the major pending works merged
5.18-rc6:	Last point for new work to be merged
5.18-rc6+:	Bug fixes only will be merged 

I'm assuming a -rc7 kernel will be released, hence this rough
timeline gives us 2 weeks of testing/stabilisation time before 5.19
merge window opens. 

Patchsets for review should be based on either 5.17.0 or the
linux-xfs master branch once it has been updated to 5.19-rc2. If
there are important bug fixes for the 5.18 cycle, I may move the
master branch forwards to a more recent release.

In terms of merge process, I plan to keep each major set of work in
a separate topic branch so that once it has been merged the commit
IDs remain stable. I will then merge the topic branches into the
for-next branch. Hence the for-next tree may still rebase (e.g. if I
need to send fixes for 5.18-rcX), but I hope to keep the individual
commits that make up the for-next branch as stable as possible. Bug
fixes for patchsets will get appended to the topic branches and the
for-next branch rebuilt via a new set of merges.

The major patchsets that I'm hoping to get reviewed and merged this
cycle:

- large extent counts V8 (Chandan)
	- Merge criteria and status:
		- review complete: 95%
		- no regressions when not enabled: 70%
		- no major regressions when enabled: 0%
	- Open questions:
		- Experimental tag for the first couple of cycles?
		  (Darrick says "YES" on #xfs)
	- Needs more QA, but signs are good so far.
	- Almost ready to merge.

- Logged attributes V28 (Allison)
	- I haven't looked at this since V24, so I'm not sure what
	  the current status is. I will do that discovery later in
	  the week.
	- Merge criteria and status:
		- review complete: Not sure
		- no regressions when not enabled: v24 was OK
		- no major regressions when enabled: v24 had issues
	- Open questions:
		- not sure what review will uncover
		- don't know what problems testing will show
		- what other log fixes does it depend on?
		- is there a performance impact when not enabled?

- DAX + reflink V11 (Ruan)
	- Merge criteria and status:
		- review complete: 75%
		- no regressions when not enabled: unknown
		- no major regressions when enabled: unknown
	- Open questions:
		- still a little bit of change around change
		  notification?
		- Not sure when V12 will arrive, hence can't really
		  plan for this right now.
		- external dependencies?

- xlog_write() rework V8
	- Merge criteria and status:
		- review complete: 100%
		- No regressions in testing: 100%
	- Open questions:
		- unchanged since last review/merge attempt,
		  reverted because of problems with other code that
		  was merged with it that isn't in this patchset
		  now. Does it need re-reviewing?
	- Ready to merge.

- Intent Whiteouts V3
	- Merge criteria and status:
		- review complete: 0%
		- No regressions in testing: 100%
	- Open questions:
		- will it get reviewed in time?
		- what bits of the patchset does LARP depend on?
		- Is LARP perf without intent whiteouts acceptible
		  (Experimental tag tends to suggest yes).
	- Functionally complete and tested, just needs review.

Have I missed any of the major outstanding things that are nearly
ready to go?

Do the patchset authors have the time available in the next 2-3
weeks to make enough progress to get their work merged? I'd kinda
like to have the xlog_write() rework and the large extent counts
merged ASAP so we have plenty of time to focus on the more
complex/difficult pieces.  If you don't have time in the next few
weeks, then let me know so I can adjust the plan appropriately for
the cycle.

What does everyone think of the plan?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
