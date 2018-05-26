Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35179 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032230AbeEZRNK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 May 2018 13:13:10 -0400
Received: by mail-pl0-f67.google.com with SMTP id i5-v6so4875137plt.2
        for <linux-xfs@vger.kernel.org>; Sat, 26 May 2018 10:13:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180523234114.GA3434@thunk.org>
References: <000000000000457b2d056cbb0044@google.com> <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard> <20180522225208.GB658@sol.localdomain>
 <20180523074425.GM14384@magnolia> <20180523162015.GA3684@sol.localdomain>
 <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net> <20180523234114.GA3434@thunk.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 26 May 2018 19:12:49 +0200
Message-ID: <CACT4Y+YEpThQj=63F8CSHeWSZxbWJ1cTDB7ZvM8OYR921uXT2g@mail.gmail.com>
Subject: Re: Bugs involving maliciously crafted file system
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@sandeen.net>, Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller <syzkaller@googlegroups.com>

On Thu, May 24, 2018 at 1:41 AM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Wed, May 23, 2018 at 01:01:59PM -0500, Eric Sandeen wrote:
>>
>> What I'm personally hung up on are the bugs where the "exploit" involves merely
>> mounting a crafted filesystem that in reality would never (until the heat death
>> of the universe) corrupt itself into that state on its own; it's the "malicious
>> image" case, which is quite different than exposing fundamental bugs like the
>> SB_BORN race or or the user-exploitable ext4 flaw you mentioned in your reply.
>> Those are more insidious and/or things which can be hit by real users in real life.
>
> Well, it *can* be hit in real life.  If you have a system which auto
> mounts USB sticks, then an attacker might be able to weaponize that
> bug by creating a USB stick where mounted and the user opens a
> particular file, the buffer overrun causes code to be executed that
> grabs the user's credentials (e.g., ssh-agent keys, OATH creds, etc.)
> and exfiltrates them to a collection server.
>
> Fedora and Chrome OS might be two such platforms where someone could
> very easily create a weaponized exploit tool where you could insert a
> file system buffer overrun bug, and "hey presto!" it becomes a serious
> zero day vulnerability.
>
> (I recently suggested to a security researcher who was concerned that
> file system developers weren't taking these sorts of things seriously
> enough could do a service to the community by creating a demonstration
> about how these sorts of bugs can be weaponized.  And I suspect it
> could be about just as easily on Chrome OS as Fedora, and that can be
> one way that an argument could be made to management that more
> resources should be applied to this problem.  :-)
>
> Of course, not all bugs triggered by a maliciously crafted file system
> are equally weaponizable.  An errors=panic or a NULL derefrence are
> probably not easily exploitable at all.  A buffer overrun (and I fixed
> two in ext4 in the last two days while being stuck in a T13 standards
> meeting, so I do feel your pain) might be a very different story.
>
> Solutions
> ---------
>
> One of the things I've wanted to get help from the syzbot folks is if
> there was some kind of machine learning or expert system evaluation
> that could be done so malicious image bugs could be binned into
> different categories, based on how easily they can be weaponized.
> That way, when there is a resource shortage situation, humans can be
> more easily guided into detremining which bugs should be prioritized
> and given attention, and which we can defer to when we have more time.

Hi Ted,

I don't see that "some kind of machine learning or expert system
evaluation" is feasible. At least not in short/mid-term. There are
innocently-looking bugs that actually turn out to be very bad, and
there are badly looking at first glance bugs that actually not that
bad for some complex reasons. Full security assessment is a complex
task and I think stays "human expert area" for now. One can get some
coarse estimation by searching for "use-after-free" and
"out-of-bounds" on the dashboard.

Also note that even the most innocent bugs can block ability to
discover deeper and worse bugs during any runtime testing. So
ultimately all need to be fixed if we want correct, stable and secure
kernel. To significant degree it's like compiler warnings: you either
fix them all, or turn them off, there is no middle ground of having
thousands of unfixed warnings and still getting benefit from them.


> Or maybe it would be useful if there was a way where maintainers could
> be able to annotate bugs with priority and severity levels, and maybe
> make comments that can be viewed from the Syzbot dashboard UI.

This looks more realistic. +Tetsuo proposed something similar:
https://github.com/google/syzkaller/issues/608

I think to make it useful we need to settle on some small set of
well-defined tags for bugs that we can show on the dashboard.
Arbitrary detailed free-form comments can be left on the mailing list
threads that are always referenced from the dashboard.

What tags would you use today for existing bugs? One would be
"security-critical", right?



> The other thing that perhaps could be done is to set up a system where
> the USB stick is automounted in a guest VM (using libvirt in Fedora,
> and perhaps Crostini for Chrome OS), and the contents of the file
> system would then get exported from the guest OS to the host OS using
> either NFS or 9P.  (9P2000.u is the solution that was used in
> gVisor[1].)
>
> [1] https://github.com/google/gvisor
>
> It could be that putting this kind of security layer in front to
> automounted USB sticks is less work than playing whack-a-mole fixing a
> lot of security bugs with maliciously crafted file systems.

I don't think that auto mounting or "requires root" is significantly
relevant in this context. If one needs to use a USB stick, or DVD or
just any filesystem that they did not create themselves, there is
pretty much no choice than to mount it, issuing sudo if necessary. If
you did not create it yourself with a trusted program, there is no way
you can be sure in the contents of the thing and there is no way you
can verify every byte of it before mounting. That's exactly the work
for software. Responsibility shifting like "you said sudo so now it's
all on you" is not useful for users. It's like web sites that give you
a hundred page license agreement before you can use it, but now you
clicked Agree so it's all on you, you read and understood every word
of it and if there would be any concern you would not click Agree,
right?
Fixing large legacy code bases is hard. But there is no other way than
persistent testing and fixing one bug at a time. We know that it's
doable because browsers did it over the past 10 years for much larger
set of input formats.



> For sure.  I guess some subset of the crashes could be more carefully
> crafted to be more dangerous, but fuzzers really don't tell us that today,
> in fact the more insidious flaws that don't turn up as a crash or hang likely
> go unnoticed.

Well, we have KASAN, almost have KMSAN and will have KTSAN in future.
They can detect detect significant portion of bugs that go unnoticed
otherwise. At least this prevents "bad guys" from also using tooling
to cheaply harvest exploits. Systematic use of these tools on browsers
raised exploit costs to $1M+ for a reason.
