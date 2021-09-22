Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13DFC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 05:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A629611C6
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 05:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhIVFcV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Sep 2021 01:32:21 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:52689 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232187AbhIVFcU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Sep 2021 01:32:20 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 621EF82B910;
        Wed, 22 Sep 2021 15:30:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mSuqF-00FIz4-Gk; Wed, 22 Sep 2021 15:30:47 +1000
Date:   Wed, 22 Sep 2021 15:30:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: kernel 5.16 sprint planning
Message-ID: <20210922053047.GS1756565@dread.disaster.area>
References: <20210922030252.GE570642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922030252.GE570642@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=1VOY59-uw8JwzIQ1OJ4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 21, 2021 at 08:02:52PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> Now that the LPC fs track is over, I would like to take nominations for
> which patchsets do people think they'd like to submit for 5.16, as well
> as volunteers to review those submissions.
> 
> I can think of a few things that /could/ be close to ready:
> 
>  - Allison's logged xattrs (submitted for review during 5.15 and Dave
>    started playing around with it)
> 
>  - Dave's logging parallelization patches (submitted during 5.14 but
>    pulled back at the last minute because of unrelated log recovery
>    issues uncovered)
> 
>  - Chandan's large extent counter series, which requires the btree
>    cursor reworking that I sent last week
> 
>  - A patchset from me to reduce sharply the size of transaction
>    reservations when rmap and reflink are enabled.

OK, that'll need perf testing as that will definitely change how
reservations and metadata writeback interact. Smaller log
reservations mean less log pressure and/or more concurrent
transactions in flight for a given log size. That may show up
new scalability bottlenecks or make existing ones worse....

> Would anyone like to add items to this list, or remove items?

I have the intent whiteout series to go with the logged attrs, and
I'm trying to get the next round of perag refcounting for shrink
series sorted out in time, too.

> For each of the items /not/ authored by me, I ask the collaborators on
> each: Do you intend to submit this for consideration for 5.16?  And do
> you have any reviewers in mind?

I'm trying to do final rebase and testing before posting them all
again, been a bit held back by weird test problems and regressions
outside XFS over the past couple of days...

Also, can we get all the patch sets being worked on in a sprint
posted in git trees to make it easy for everyone to pull in and
update code as it gets changed?

> For everyone else: Do you see something you'd like to see land in 5.16?

For future sprints, this seems like it would be a good question to
ask at the time the merge window for the previous cycle opens. Code
that is not proposed/ready for a merge sprint by -rc2 isn't a
candidate for the sprint. Then the sprint runs -rc3 to -rc5, and we
have everything finalised and merged by -rc6 and soaking in for-next
for 1-2 weeks before the merge window opens...

> Would you be willing to pair off with the author(s) to conduct a review?

Sure.

But keep in mind that formal pairing is not the _only_ approach
here, and in some cases won't be the best approach. Not everyone has
the same level of knowledge and/or expertise, and some things
require more review than others.  Sprints don't change the need for
different types of review to be performed, just the time constraints
for performing and addressing them.

Another thing that is clear from the the inode inactivation and
delayed attribute series is that performance and scalability testing
is needed for significant new functionality. This is something that
needs to be done early on in the sprint so we have time to can
address problems during the review sprint. This isn't code review,
but it is certainly analysis that needs to be performed.

Are there things other than code review that we need to focus on
during a sprint? I think testing the code being reviewed is also
a core part of the sprint process, such that we get code tested in a
wider variety of environments before it gets merged...

> -------
> 
> Carlos asked after the FS track today about what kinds of things need
> working on.  I can think of two things needing attention in xfsprogs:
> 
>  - Helping Eric deal with the xfs_perag changes that require mockups.
>    (I might just revisit this, since I already threw a ton of patches at
>    the list.)

I threw patches at it, too, to implement the functionality rather
than just mock it up...

>  - Protofiles: I occasionally get pings both internally and via PM from
>    people wanting to create smallest-possible prepopulated XFS images
>    from a directory tree.  Exploding minimum-sized images aren't a great
>    idea because the log and AGs will be very small, but:
> 
>    Given that we have a bitrotting tool (xfs_estimate) to guesstimate
>    the size of the image, mkfs support for ye olde 4th Ed. Unix
>    protofiles, and I have a script to generate protofiles, should
>    someone clean all that up into a single tool that converts a
>    directory tree into an image?  Preferably one with as large an AG+log
>    as possible?
> 
>    Or should we choose to withdraw all that functionality?

I'm not sure this is materially better than mkfs with appropriate
geometry, then mounting and using rsync to copy the data across.
the xfsprogs protofile copying is inherently single threaded until
we have fully fledged modification concurrency capability in
userspace libxfs....

>    I have a slight greybeard preference for keeping protofiles on the
>    grounds that protofiles have been supported on various Unix mkfs for
>    almost 50 years, and they're actually compatible with the JFS tools
>    and <cough> other things like AIX and HPUX.  But the rest of you can
>    overrule me... ;)

I'm not that sentimental :) If it's not useful or can be implemented
with other standard tools, then we should get rid of it.

> Does anyone have any suggestions beyond that?

For xfsprogs?

Fix the concurrency mess in libxfs
Fix the unnecessary command line parsing library complexity
properly abstract buftargs across both xfsprogs and kernel code
code cleanups in repair, db, etc.
Optimising mkfs defaults for SSDs
port the common part of log recovery to libxfs to replace libxlog
rewrite xfs_logprint to use the new libxfs port
rewrite xfs_logprint to be sane and understandable
build a mkfs config file library for common use cases
Modernise xfs_fsr with an eye to shrink requirements
AIO/io_uring for xfs_fsr
AIO/io_uring for metadump/restore
AIO/io_uring for xfs_copy
Add PSI support for memory usage feed back to libxfs
Implement shrinkers for trimming caches from PSI events
Port fs/xfs/xfs_buf.c to replace the libxfs buffer cache
AIO/io_uring support for libxfs buffer cache
Fix the repair prefetching mess
optimise IO for million AG filesystems
Clean up the repair memory usage/cache sizing/threading heuristics
....

Need more?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
