Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:41640 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755651AbeFOJce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 05:32:34 -0400
Received: by mail-pf0-f194.google.com with SMTP id a11-v6so4600646pff.8
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jun 2018 02:32:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180611133345.GE5020@thunk.org>
References: <20180522123107.GC3751@bfoster.bfoster> <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain> <20180523074425.GM14384@magnolia>
 <20180523162015.GA3684@sol.localdomain> <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
 <20180523234114.GA3434@thunk.org> <CACT4Y+YEpThQj=63F8CSHeWSZxbWJ1cTDB7ZvM8OYR921uXT2g@mail.gmail.com>
 <20180526202436.GC4613@thunk.org> <CACT4Y+YK9LzYuVSruimbgxSAoCt_UYbHwzhvDGCqZ7FuQLcUUA@mail.gmail.com>
 <20180611133345.GE5020@thunk.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 15 Jun 2018 11:32:13 +0200
Message-ID: <CACT4Y+bxcHSCsYR5uGFbvaJvRAkoA3-z3=B_1DQ+rvks4Q5KpQ@mail.gmail.com>
Subject: Re: Bugs involving maliciously crafted file system
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Dmitry Vyukov <dvyukov@google.com>, Eric Sandeen <sandeen@sandeen.net>, Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller <syzkaller@googlegroups.com>

On Mon, Jun 11, 2018 at 3:33 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 11, 2018 at 03:07:24PM +0200, Dmitry Vyukov wrote:
>>
>> These can't be weaponized to execute code, but if a BUG_ON is
>> triggerable over a network, or from VM guest, then it's likely more
>> critical than a local code execution. That's why I am saying that
>> automated evaluation is infeasible.
>
> I can't imagine situations where a BUG_ON would be more critical than
> local code execution.  You can leverage local code execution to ah
> remote privilege escalation attack; and local code execution can (with
> less effort) be translated to a system crash.  Hence, local code
> execution is always more critical than a BUG_ON.


Well, if one could bring all of Google servers remotely, lots of
people would consider this as more critical as _anything_ local.


>> Anyway, bug type (UAF, BUG, task hung) is available in the bug title
>> on dashboard and on mailing lists, so you can just search/sort bugs on
>> the dashboard. What other interface you want on top of this?
>
> I also want to be able to search and filter based on subsystem, and
> whether or not there is a reproducer.  Sometimes you can't even figure
> out the subsytem from the limited string shown on the dashboard,
> because the original string didn't include the subsystem to begin
> with, or the the subsytem name was truncated and not included on the
> dashboard.

How is this problem solved in kernel development for all other bug reports?

>> On a related note, perhaps kernel community needs to finally start
>> using bugzilla for real, like with priorities, assignees, up-to-date
>> statuses, no stale bugs, etc. All of this is available in bug tracking
>> systems for decades...
>
> I do use bugzilla and in fact if syzbot would automatically file a
> bugzilla.kernel.org report for things that are in the ext4 subsystem,
> that would be really helpful.
>
> As far as no stale bugs, etc., many companies (including Google)
> aren't capable of doing that with their own internal bug tracking
> systems, because management doesn't give them enough time to track and
> fix all stale bugs.  You seem to be assuming/demanding things of the
> kernel community that are at least partially constrained by resource
> availability --- and since you've used constrained resources as a
> reason why Syzbot can't be extended as we've requested to reduce
> developer toil and leverage our available resources, it would perhaps
> be respectful if you also accepted that resource constraints also
> exist in other areas, such as how much we can keep a fully groomed bug
> tracking system.

I mentioned this only because you asked for this.
Whatever tracking system and style we go with, bug states need to
maintained and bugs need to be nursed. If we extend syzbot dashboard
with more traditional bug tracking system capabilities, but then
nobody cares to maintain order, it also won't be useful and nobody
will be able to easily select the current tasks to work on.
So that's a prerequisite for what you are asking for.

Well, you use bugzilla, but somebody else uses something else. This
fragmentation is kernel development practices does not allow to build
further automation on top. We can't do a personal solution for each
developer. For now the greatest common divisor seems to be freeform
emails on mailing lists...

A good example is "I submitted 7 kernel bugs to bugzilla, but nobody
answered me" email thread from today:
https://groups.google.com/forum/#!topic/syzkaller/OnbMQbbE4gQ
