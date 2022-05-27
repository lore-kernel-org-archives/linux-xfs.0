Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE804C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 23:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348483AbiE0XmI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 19:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244886AbiE0XmI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 19:42:08 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C21DE39687;
        Fri, 27 May 2022 16:42:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D651E10EAD77;
        Sat, 28 May 2022 09:42:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nujak-00HCpQ-Ds; Sat, 28 May 2022 09:42:02 +1000
Date:   Sat, 28 May 2022 09:42:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
Message-ID: <20220527234202.GF3923443@dread.disaster.area>
References: <20220525111715.2769700-1-amir73il@gmail.com>
 <YpBqfdmwQ675m72G@infradead.org>
 <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com>
 <20220527090838.GD3923443@dread.disaster.area>
 <CAOQ4uxgc9Zu0rvTY3oOqycGG+MoYEL3-+qghm9_qEn67D8OukA@mail.gmail.com>
 <YpDw3uVFB7LjPquX@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpDw3uVFB7LjPquX@bombadil.infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=629161cd
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=zxJDezhdzid2LMDuc1kA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 27, 2022 at 08:40:14AM -0700, Luis Chamberlain wrote:
> On Fri, May 27, 2022 at 03:24:02PM +0300, Amir Goldstein wrote:
> > On Fri, May 27, 2022 at 12:08 PM Dave Chinner <david@fromorbit.com> wrote:
> > > Backport candidate: yes. Severe: absolutely not.
> > In the future, if you are writing a cover letter for an improvement
> > series or internal pull request and you know there is a backport
> > candidate inside, if you happen to remember to mention it, it would
> > be of great help to me.

That's what "fixes" and "cc: stable" tags in the commit itself are
for, not the cover letter.

> Amir, since you wrote a tool enhancement to scrape for possible
> candidates, *if* we defined some sort of meta-data to describe
> this sort of stuff on the cover letter:
> 
> Backport candidate: yes. Severe: absolutely not
> 
> It would be useful when scraping. Therefore, leaving the effort
> to try to backport / feasibility to others. This would be different
> than a stable Cc tag, as those have a high degree of certainty.
> 
> How about something like:
> 
> Backport-candidate: yes
> Impact: low

No.

This placing the responsibility/burden on upstream developers to
classify everything they do that *might* get backported regardless
of the context the change is being made under. Stable maintainers
have the benefit of hindsight, user bug reports, etc and can make
much better determinations of whether any particular change should
be backported.

Indeed, a single user reporting a bug doesn't make the fix an
automatic backport candidate. The fix might be too complex to
backport, it might have serious dependency requirements, it might be
specific to a really niche configuration or workload, the user might
be running their own custom kernel and does their own backports, it
might be impossible for anyone but the person fixing the bug to
validate that the fix works correctly and it might take days or
weeks of effort to perform that validation, etc.

IOWs, there are many reasons that bug fixes may not be considered
backport candidates at the time they are fixed and committed. If
circumstances change 6 months later and only then it becomes clear
that we need to backport the fix, then that is not a problem the
upstream process can solve. Upstream has not done anything wrong
here, nor could they have known that the initial classification of
"rare, whacky, almost no exposure anywhere" might be completely
wrong because of something else they did not know about at the
time...

IMO, placing the responsibility on upstream developers to accurately
identify and classify every possible commit that might be a backport
candidate for the benefit of stable kernel maintainers is completely
upside down.

Identifying the fixes for problems that that stable kernel users are
hitting is the responsibility of the stable kernel maintainers. A
stable kernel maintainer is not just a role of "do backports and
test kernels". The stable kernel maintainer must also provide front
line user support so they are aware of the bugs those users are
hitting that *haven't already been identified* as affecting users of
those kernels. Stable kernel maintainers are *always* going to miss
bug fixes or changes that happen upstream that unintentionally fix
or mitigate problems that occur in older kernels.

Hence stable maintainers need to start from the position of "users
will always hit stuff we haven't fixed", not start from the position
of "upstream developers should tell us what we should fix". Many of
the upstream bug fixes come from user bug reports on stable kernels,
not from users on bleeding edge upstream kernels. Stable kernel
maintainers need to be triaging these bug reports and determining if
the problem is fixed upstream and the commit that fixes it, or if it
hasn't been fixed working with upstream to get the bugs fixed and
then backported.

If the upstream developer knows that it is a regression fix or a new
bug that likely needs to be backported, then we already have
"Fixes:" and "cc: stable" for communicating "please backport this"
back down the stack. Anything more is just asking us to make wild
guesses about an unknown future.

Cheers,

-Dave.
-- 
Dave Chinner
david@fromorbit.com
