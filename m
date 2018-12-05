Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60084 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbeLECKp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 21:10:45 -0500
Date: Tue, 4 Dec 2018 18:10:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: 4.21/5.0 merge window plans
Message-ID: <20181205021038.GJ24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>

Oooof.  Hi everyone.

Dave and I have spent most of the last two months using fsx & fsstress
to try to flush as many corruption and clone/dedupe/copyrange API bugs
out of the kernel and XFS as we can find.  The good news is that my
test farm VMs have hit 14+ billion fsxops without any failures (they're
still running towards a target of 18 billion) so we're cautiously
optimistic that things have settled down.

Unfortunately, we're both exhausted from this effort; -rc6 is nearly
upon us and I've had less time than I like for merge window review; and
Kinder Gentler Linus has provided direction that we all should have a
holiday season without the stress of a merge window or prepping for one.

With that in mind, I declare 4.21/5.0 to be another fixes only cycle.
I really hope it will be quieter than 4.19 and 4.20 were, which frankly
were a disaster (various block layer problems and the aforementioned vfs
api mess, not xfs itself).

The big things left on my plate for 4.21/5.0 are:

- Christoph's always_cow series
- Dave's big copy_file_range rework
- The two xfs-5.0 scrub and ftrace series I already sent

That's about all I plan to look at for the next two weeks.  FWIW if I
already reviewed your patch and it's not in for-next, it'll appear in my
xfs-4.21-merge tree in a week or so.

For 2019, I would like to start training people to be maintainers by
having them handle -rc1 -> -rc7 parts of the kernel cycle in the hopes
that we'll be able to start group maintainership. :)

(FWIW I consider 'maintainership' to be assembling git trees, running
testing, and persuading people to review things, so anyone wishing to
step forward to do more review would also be welcome.)

Thoughts?  Reactions?

--Darrick
