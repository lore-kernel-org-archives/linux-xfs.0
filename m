Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:42760 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753800AbeDMKDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Apr 2018 06:03:49 -0400
Received: by mail-pg0-f46.google.com with SMTP id e12so1719925pgn.9
        for <linux-xfs@vger.kernel.org>; Fri, 13 Apr 2018 03:03:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180406161053.GF7500@magnolia>
References: <f403043cbe8414177d0568e81405@google.com> <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
 <20180405213844.GE23861@dastard> <20180406161053.GF7500@magnolia>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 13 Apr 2018 12:03:27 +0200
Message-ID: <CACT4Y+aaEOffkFA-B-hMzwzSiQwVpkPrc2udC087a55OTnkS4g@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Theodore Ts'o <tytso@mit.edu>, syzkaller <syzkaller@googlegroups.com>

On Fri, Apr 6, 2018 at 6:10 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Fri, Apr 06, 2018 at 07:38:44AM +1000, Dave Chinner wrote:
>> On Thu, Apr 05, 2018 at 08:54:50PM +0200, Dmitry Vyukov wrote:
>> > On Tue, Apr 3, 2018 at 6:38 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > > On Mon, Apr 02, 2018 at 07:01:02PM -0700, syzbot wrote:
>> > >> Hello,
>> > >>
>> > >> syzbot hit the following crash on upstream commit
>> > >> 86bbbebac1933e6e95e8234c4f7d220c5ddd38bc (Mon Apr 2 18:47:07 2018 +0000)
>> > >> Merge branch 'ras-core-for-linus' of
>> > >> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> > >> syzbot dashboard link:
>> > >> https://syzkaller.appspot.com/bug?extid=84a67953651a971809ba
>> > >>
>> > >> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=5719304272084992
>> > >> syzkaller reproducer:
>> > >> https://syzkaller.appspot.com/x/repro.syz?id=5767783983874048
>> > >
>> > > What a mess. A hand built, hopelessly broken filesystem image made
>> > > up of hex dumps, written into a mmap()d region of memory, then
>> > > copied into a tmpfs file and mounted with the loop device.
>> > >
>> > > Engineers that can debug broken filesystems don't grow on trees.  If
>> > > we are to have any hope of understanding what the hell this test is
>> > > doing, the bot needs to supply us with a copy of the built
>> > > filesystem image the test uses. We need to be able to point forensic
>> > > tools at the image to decode all the structures into human readable
>> > > format - if we are forced to do that by hand or jump through hoops
>> > > to create our own filesystem image than I'm certainly not going to
>> > > waste time looking at these reports...
>> >
>> > Hi Dave,
>> >
>> > Here is the image:
>> > https://drive.google.com/file/d/1jzhGGe5SBJcqfsjxCLHoh4Kazke1oTfC/view
>> > (took me about a minute to extract from test by replacing memfd_create
>> > with open and running the program).
>>
>> Says the expert who knows exactly how it's all put together. It took
>> me a couple of hours just to understand WTF the syzbot reproducer
>> was actually doing....
>>
>> > Then do the following to trigger the bug:
>> > losetup /dev/loop0 xfs.repro
>> > mkdir xfs
>> > mount -t xfs -o nouuid,prjquota,noikeep,quota /dev/loop0 xfs
>> >
>> > To answer your more general question: syzbot is not a system to test
>> > solely file systems, it finds bugs in hundreds of kernel subsystems.
>> > Generating image for file systems, media files for sound and
>> > FaceDancer programs that crash host when  FaceDancer device is plugged
>> > into USB is not feasible. And in the end it's not even clear what
>>
>> I don't care how syzbot generates the filesystem image it uses.
>>
>> > kernel subsystem is at fault and even if it somehow figures out that
>> > it's a filesystem, it's unclear that it's exactly an image that
>> > provokes the bug. syzbot provides C reproducers which is a reasonable
>>
>> It doesn't matter *what subsystem breaks*. If syzbot is generating a
>> filesystem image and then mounting it, it needs to provide that
>> filesystem image to to people who end up having to debug the
>> problem. It's a basic "corrupt filesystem" bug triage step.
>>
>> > Some bugs are so involved that only an
>> > expert in a particular subsystem can figure out what happens there.
>>
>> And that's clearly the case here, whether you like it or not.
>>
>> You want us to do things that make syzbot more useful as a tool but
>> you don't want to do things that make syzbot a useful tool for us.
>> It's a two way street....

Hi Dave, Darrick,

It's not that we don't want to make the system more useful, it's just
that we don't see what reasonably can be done here. The system does
not have notion of images, sound files, USB devices. It feeds data
into system calls, and that's what it provides as reproducers. Also
see the last paragraph.

> ...here's my take on this whole situation:
>
> So far as I can tell, this syzbot daemon grew the ability to fuzz
> filesystems and started emitting bug report after bug report, with
> misleading commit ids that have nothing to do with the complaint.

Please elaborate re commits. It's a basic rule of any good bug report
-- communicate exact state of source code when the bug was hit, i.e.
provide the commit hash.

>  Your
> maintainers (Dave, Eric, and me) have spent a few hours trying to figure
> out what's going on, to some frustration.  The bug reports themselves
> miss the public engagement detail of saying something like "Hey XFS
> engineers, if you'd like to talk to the syzbot engineers they can be
> reached at <googlegroup address>."  Instead it merely says "direct
> questions to <addr>" like this is some press release and the only thing
> on the other end of the line will be some disinterested bureaucracy.
> Or some robot.

This is quite subjective and we hear opinions all possible ways. I
don't think there is one size fits all. E.g. +Ted argued in exactly
the opposite direction: make reports more laconic, formal,
table-formatted with dry information. There is also a tradeoff between
describing each detail in proper, friendly English and being more
laconic. If we increase everything 4x and post a wall of text with
each report, lots of people won't read anything of it just because
it's a wall of text. I am also not a native English speaker, so
providing simple formal text is a safer option than writing something
potentially clumsy.

Having said that, I am collecting proposals for report format
improvements. Here is fortunately slightly better wording for footer
based on your idea:
https://github.com/google/syzkaller/issues/565#issuecomment-380793620

> We're willing to take random user reports of corruption and misbehavior
> and do all the work to turn that into regression tests and patches, but
> that's not the situation here.  You work for a well known engineering
> company which (I assume) has decided that fuzz hardening the commons
> aligns with its goals.  Collective-you (i.e. your company) could realize
> that goal sooner and with a lot less community friction by staffing up
> engineers to join our community to help us triage and fix the things
> reported by syzbot.  It's much /less/ effective to dump a pile of work
> on the people in the community.  We each have our own work-piles and
> most likely different priorities.
>
> Hardening XFS to the sorts of things fuzzers find is important to me
> (and $employer) as well, but the difference here is that I read every
> report that gets generated and start the work to figure out a regression
> test and a code fix.  That is what I send to the list for more public
> participation and to signal that yes, there's a human behind all this
> with some reasonable level of understanding of the problem.

Well, I guess nobody has infinite engineering resources. If we would
have them we would also fix all these bug ourselves and don't bother
you at all. Just as any other company could invest in writing bug
detection tools, fuzzers, deploy them and report bugs, which would
relief us from this.
We have limited resources and do what's possible within these
resources. Unfortunately providing individual handling of each of the
thousands of bugs is not possible within these resources. I know that
what we are doing is useful for kernel overall because lots of
hundreds of bugs get fixed due to this effort. If you, as xfs
maintainers, think that these reports are net negative for xfs and xfs
should not be tested, say so and we will figure out how to make it
happen.

Thanks
