Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8069BC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 05:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 617E22078A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 05:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgHKFxZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 01:53:25 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:60338 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726397AbgHKFxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Aug 2020 01:53:25 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 85F9F10526F;
        Tue, 11 Aug 2020 15:53:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5NDs-00022M-PM; Tue, 11 Aug 2020 15:53:20 +1000
Date:   Tue, 11 Aug 2020 15:53:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
Message-ID: <20200811055320.GN2114@dread.disaster.area>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
 <20200811020052.GM2114@dread.disaster.area>
 <d7c9ea39-136d-bc1b-7282-097a784e336b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7c9ea39-136d-bc1b-7282-097a784e336b@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=n1yUEEuMochTUF6OLcgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 10, 2020 at 08:19:57PM -0600, Jens Axboe wrote:
> > IOWs, there does not appear to be a filesystem or page cache issue
> > here at all - it's just an unhandled short read.
> 
> Right, the page cache is consistent, nothing wrong on that side. This is
> purely a fio issue with messing up the short read.
> 
> It'd be nice to do better on the short reads, maybe wait for the entire
> range to be ready instead of just triggering on the first page.
> Something to look into.
> 
> > Jens, if strace worked on io_uring, I wouldn't have wasted 2 and
> > half days tracking this down. It would have taken 5 minutes with
> > strace and it would have been totally obvious. I'd suggest this
> > needs addressing as a matter of priority over everything else for
> > io_uring....
> 
> Sorry, you should have pinged me earlier.

I pinged you as early as I would ping anyone else when it's apparent
I'm probably not looking at a filesystem issue.

The problem is here that io_uring is completely unfamiliar code to
most of the fileystem developers that are going to have to diagnose
problems like this in the field.  That's why I spent the time on it
- nobody else in my team or the upstream people I work with day to
day has even looked at this code or has a clue of how it works.

We need to have people who know how this precarious stack of cards
actually works, otherwise we're completely screwed when a user has a
similar sort of issue.  And right now, all I see are big red flags.

This exercise has lead me to realise that that we really don't
have *any* tools that can be used to diagnose io_uring problems at
all. That's something that clearly needs to be fixed, because fo
some reason this crazy io_uring stuff has suddenly become the
responsibility of distro filesystem people are being asked to
maintain and debug...

So saying "you should have pinged me earlier" is a hugely naive
response. It completely ignores the fact that people are going to
have to triage issues like this on a regular basis. And you don't
scale to having every single user ping you to help debug io_uring
problems they are seeing. IOWs, "you should have pinged me" is not a
solution, nor does it absolve you of the responsibility for making
your subsystem debuggable by the expected user and application
devleoper base.

> In lieu of strace, we could
> expand the io_uring issue event to include a bigger dump of exactly what
> is in the command being issued instead of just the opcode.

I didn't find anything even remotely useful in the handful of trace
points in the io_uring code.....

> There's
> already info in there enabling someone to tie the complete and submit
> events together, so it could have been deduced that we never retried a
> short IO on the application side.  But it should not be that hard to dig
> out,

... and now you're assuming that the person trying to debug their
application knows exactly how the whole io_uring thing works inside
the kernel so they can make sense of the tracepoint information.
There's no documentation for the interface, there's no design doc
that describes how the async engine is supposed to work, what
constraints it places on code paths that need to be able to run
async, etc.  If you aren't deep in the guts of io_uring all the
time, then working out what the tracepoints are documenting is no
easy task.

> I agree we need to make it easier to debug these kinds of things.
> Definitely on the list!

As I said, I think it should be at the top of your list.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
