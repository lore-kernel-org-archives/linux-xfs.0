Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF57C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 05:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C2DA206DA
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 05:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgHKFx1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 01:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgHKFx0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Aug 2020 01:53:26 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Tue, 11 Aug 2020 05:53:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208827-201763-J6SuYafpeK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208827-201763@https.bugzilla.kernel.org/>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208827

--- Comment #13 from Dave Chinner (david@fromorbit.com) ---
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
You are receiving this mail because:
You are watching the assignee of the bug.
