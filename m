Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56218 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932945AbeFKNdx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jun 2018 09:33:53 -0400
Date: Mon, 11 Jun 2018 09:33:45 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Bugs involving maliciously crafted file system
Message-ID: <20180611133345.GE5020@thunk.org>
References: <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain>
 <20180523074425.GM14384@magnolia>
 <20180523162015.GA3684@sol.localdomain>
 <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
 <20180523234114.GA3434@thunk.org>
 <CACT4Y+YEpThQj=63F8CSHeWSZxbWJ1cTDB7ZvM8OYR921uXT2g@mail.gmail.com>
 <20180526202436.GC4613@thunk.org>
 <CACT4Y+YK9LzYuVSruimbgxSAoCt_UYbHwzhvDGCqZ7FuQLcUUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YK9LzYuVSruimbgxSAoCt_UYbHwzhvDGCqZ7FuQLcUUA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller <syzkaller@googlegroups.com>

On Mon, Jun 11, 2018 at 03:07:24PM +0200, Dmitry Vyukov wrote:
> 
> These can't be weaponized to execute code, but if a BUG_ON is
> triggerable over a network, or from VM guest, then it's likely more
> critical than a local code execution. That's why I am saying that
> automated evaluation is infeasible.

I can't imagine situations where a BUG_ON would be more critical than
local code execution.  You can leverage local code execution to ah
remote privilege escalation attack; and local code execution can (with
less effort) be translated to a system crash.  Hence, local code
execution is always more critical than a BUG_ON.

> Anyway, bug type (UAF, BUG, task hung) is available in the bug title
> on dashboard and on mailing lists, so you can just search/sort bugs on
> the dashboard. What other interface you want on top of this?

I also want to be able to search and filter based on subsystem, and
whether or not there is a reproducer.  Sometimes you can't even figure
out the subsytem from the limited string shown on the dashboard,
because the original string didn't include the subsystem to begin
with, or the the subsytem name was truncated and not included on the
dashboard.

> On a related note, perhaps kernel community needs to finally start
> using bugzilla for real, like with priorities, assignees, up-to-date
> statuses, no stale bugs, etc. All of this is available in bug tracking
> systems for decades...

I do use bugzilla and in fact if syzbot would automatically file a
bugzilla.kernel.org report for things that are in the ext4 subsystem,
that would be really helpful.

As far as no stale bugs, etc., many companies (including Google)
aren't capable of doing that with their own internal bug tracking
systems, because management doesn't give them enough time to track and
fix all stale bugs.  You seem to be assuming/demanding things of the
kernel community that are at least partially constrained by resource
availability --- and since you've used constrained resources as a
reason why Syzbot can't be extended as we've requested to reduce
developer toil and leverage our available resources, it would perhaps
be respectful if you also accepted that resource constraints also
exist in other areas, such as how much we can keep a fully groomed bug
tracking system.

Regards,

						- Ted
