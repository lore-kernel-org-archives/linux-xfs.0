Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34673 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932656AbeFKNHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 09:07:46 -0400
Received: by mail-pf0-f193.google.com with SMTP id a63-v6so10218373pfl.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 06:07:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180526202436.GC4613@thunk.org>
References: <000000000000457b2d056cbb0044@google.com> <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard> <20180522225208.GB658@sol.localdomain>
 <20180523074425.GM14384@magnolia> <20180523162015.GA3684@sol.localdomain>
 <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net> <20180523234114.GA3434@thunk.org>
 <CACT4Y+YEpThQj=63F8CSHeWSZxbWJ1cTDB7ZvM8OYR921uXT2g@mail.gmail.com> <20180526202436.GC4613@thunk.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 11 Jun 2018 15:07:24 +0200
Message-ID: <CACT4Y+YK9LzYuVSruimbgxSAoCt_UYbHwzhvDGCqZ7FuQLcUUA@mail.gmail.com>
Subject: Re: Bugs involving maliciously crafted file system
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Dmitry Vyukov <dvyukov@google.com>, Eric Sandeen <sandeen@sandeen.net>, Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller <syzkaller@googlegroups.com>

On Sat, May 26, 2018 at 10:24 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Sat, May 26, 2018 at 07:12:49PM +0200, Dmitry Vyukov wrote:
>>
>> I don't see that "some kind of machine learning or expert system
>> evaluation" is feasible. At least not in short/mid-term. There are
>> innocently-looking bugs that actually turn out to be very bad, and
>> there are badly looking at first glance bugs that actually not that
>> bad for some complex reasons. Full security assessment is a complex
>> task and I think stays "human expert area" for now. One can get some
>> coarse estimation by searching for "use-after-free" and
>> "out-of-bounds" on the dashboard.
>
> If the kernel intentionally triggers a BUG_ON or a panic (as in file
> systems configured with 'tune2fs -e panic') it's pretty obvious that
> those errors can't be weaponized to execute code chosen by the
> attacker.  Would you agree with that?
>
> The same should be true for "blocked for more than 120 seconds";
> again, I claim that those sorts of errors are by definition less
> serious than buffer overruns.
>
> So there is at least some kind of automated evaluation that can be
> done, even if the general case problem is really hard.

These can't be weaponized to execute code, but if a BUG_ON is
triggerable over a network, or from VM guest, then it's likely more
critical than a local code execution. That's why I am saying that
automated evaluation is infeasible.

Anyway, bug type (UAF, BUG, task hung) is available in the bug title
on dashboard and on mailing lists, so you can just search/sort bugs on
the dashboard. What other interface you want on top of this?



>> > Or maybe it would be useful if there was a way where maintainers could
>> > be able to annotate bugs with priority and severity levels, and maybe
>> > make comments that can be viewed from the Syzbot dashboard UI.
>>
>> This looks more realistic. +Tetsuo proposed something similar:
>> https://github.com/google/syzkaller/issues/608
>>
>> I think to make it useful we need to settle on some small set of
>> well-defined tags for bugs that we can show on the dashboard.
>> Arbitrary detailed free-form comments can be left on the mailing list
>> threads that are always referenced from the dashboard.
>>
>> What tags would you use today for existing bugs? One would be
>> "security-critical", right?
>
> For me, it's not about tags.  Things missing from the
> https://syzkaller.appspot.com/ front page are:
>
> * Whether or not a repro is available

This was always available in the Repro column.

> * Which subsystems the bug has been tentatively assigned
> * A maintainer assigned priority and severity level

Let's call this tags collectively (unless you have a better name). P0
or subsystem:ext4 can also be tags.
So  you mean: (1) priority levels (P0, P1, P2), (2) severity levels
(S0, S1, S2) and subsystem, right?

On a related note, perhaps kernel community needs to finally start
using bugzilla for real, like with priorities, assignees, up-to-date
statuses, no stale bugs, etc. All of this is available in bug tracking
systems for decades...
