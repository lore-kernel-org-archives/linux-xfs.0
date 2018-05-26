Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58062 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032365AbeEZUYu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 26 May 2018 16:24:50 -0400
Date: Sat, 26 May 2018 16:24:36 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Bugs involving maliciously crafted file system
Message-ID: <20180526202436.GC4613@thunk.org>
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain>
 <20180523074425.GM14384@magnolia>
 <20180523162015.GA3684@sol.localdomain>
 <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
 <20180523234114.GA3434@thunk.org>
 <CACT4Y+YEpThQj=63F8CSHeWSZxbWJ1cTDB7ZvM8OYR921uXT2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YEpThQj=63F8CSHeWSZxbWJ1cTDB7ZvM8OYR921uXT2g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller <syzkaller@googlegroups.com>

On Sat, May 26, 2018 at 07:12:49PM +0200, Dmitry Vyukov wrote:
> 
> I don't see that "some kind of machine learning or expert system
> evaluation" is feasible. At least not in short/mid-term. There are
> innocently-looking bugs that actually turn out to be very bad, and
> there are badly looking at first glance bugs that actually not that
> bad for some complex reasons. Full security assessment is a complex
> task and I think stays "human expert area" for now. One can get some
> coarse estimation by searching for "use-after-free" and
> "out-of-bounds" on the dashboard.

If the kernel intentionally triggers a BUG_ON or a panic (as in file
systems configured with 'tune2fs -e panic') it's pretty obvious that
those errors can't be weaponized to execute code chosen by the
attacker.  Would you agree with that?

The same should be true for "blocked for more than 120 seconds";
again, I claim that those sorts of errors are by definition less
serious than buffer overruns.

So there is at least some kind of automated evaluation that can be
done, even if the general case problem is really hard.

> > Or maybe it would be useful if there was a way where maintainers could
> > be able to annotate bugs with priority and severity levels, and maybe
> > make comments that can be viewed from the Syzbot dashboard UI.
> 
> This looks more realistic. +Tetsuo proposed something similar:
> https://github.com/google/syzkaller/issues/608
> 
> I think to make it useful we need to settle on some small set of
> well-defined tags for bugs that we can show on the dashboard.
> Arbitrary detailed free-form comments can be left on the mailing list
> threads that are always referenced from the dashboard.
> 
> What tags would you use today for existing bugs? One would be
> "security-critical", right?

For me, it's not about tags.  Things missing from the
https://syzkaller.appspot.com/ front page are:

* Whether or not a repro is available
* Which subsystems the bug has been tentatively assigned
* A maintainer assigned priority and severity level

I generally don't use the syzkaller.apptspot.com front page because
it's too hard to find the sorts of thing that I'm looking for ---
namely the most important syzkaller bug that I as an ext4 expert can
work on.

If someone else sends me a well-formed bug report on
bugzilla.kernel.org, with free-standing image file, and a simple .c
reproducer, I can make forward progress much more quickly.  So if I'm
time bound, guess which bug I'm going to pay attention to first?
Especially when Syzkaller makes it hard for me to find the bug again
once it ages out of my inbox?

> Well, we have KASAN, almost have KMSAN and will have KTSAN in future.
> They can detect detect significant portion of bugs that go unnoticed
> otherwise. At least this prevents "bad guys" from also using tooling
> to cheaply harvest exploits. Systematic use of these tools on browsers
> raised exploit costs to $1M+ for a reason.

I'll note that browsers also use processes and capsicum to provide
security boundaries.  This is why David and I have been suggesting
solutions like FUSE or running the mount in a guest VM, which can act
as an isolation layer.  Even if there is a bug in the guest kernel,
the blast radius of the bug can be isolated, hopefully to the point
where it can be completely contained.  It's not an either-or, but a
both-and.

But the much more important thing is that mangement has to be willing
to **fund** bug remediation.  That was true for Chrome; it doesn't
seem to be as true for the Linux Kernel, for whatever reason.

People trying to fix Syzkaller and other fuzzer-found bugs on 20%
time, or on the weekends, or as a background activity during
low-bandwidth meetings, or as an unfunded mandate that doesn't show up
on anyone's quarterly objectives upon which they are graded, is just
not going to scale.

And if that's the reality, it may very well be that if you want
Syzkaller to make more a difference, anything you can do to reduce the
human toil needed to investigate a bug is going to be hugely
important.

And if bug remediation is only going to be funded to a very limited
extent, then it's important that the bugs we work on are the highest
priority ones, since the lower priority ones *will* have to let slide.

Regards,

						- Ted
