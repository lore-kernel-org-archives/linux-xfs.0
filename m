Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41841 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751365AbeDEViq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 17:38:46 -0400
Date: Fri, 6 Apr 2018 07:38:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Message-ID: <20180405213844.GE23861@dastard>
References: <f403043cbe8414177d0568e81405@google.com>
 <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, darrick.wong@oracle.com, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Thu, Apr 05, 2018 at 08:54:50PM +0200, Dmitry Vyukov wrote:
> On Tue, Apr 3, 2018 at 6:38 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Apr 02, 2018 at 07:01:02PM -0700, syzbot wrote:
> >> Hello,
> >>
> >> syzbot hit the following crash on upstream commit
> >> 86bbbebac1933e6e95e8234c4f7d220c5ddd38bc (Mon Apr 2 18:47:07 2018 +0000)
> >> Merge branch 'ras-core-for-linus' of
> >> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> >> syzbot dashboard link:
> >> https://syzkaller.appspot.com/bug?extid=84a67953651a971809ba
> >>
> >> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=5719304272084992
> >> syzkaller reproducer:
> >> https://syzkaller.appspot.com/x/repro.syz?id=5767783983874048
> >
> > What a mess. A hand built, hopelessly broken filesystem image made
> > up of hex dumps, written into a mmap()d region of memory, then
> > copied into a tmpfs file and mounted with the loop device.
> >
> > Engineers that can debug broken filesystems don't grow on trees.  If
> > we are to have any hope of understanding what the hell this test is
> > doing, the bot needs to supply us with a copy of the built
> > filesystem image the test uses. We need to be able to point forensic
> > tools at the image to decode all the structures into human readable
> > format - if we are forced to do that by hand or jump through hoops
> > to create our own filesystem image than I'm certainly not going to
> > waste time looking at these reports...
> 
> Hi Dave,
> 
> Here is the image:
> https://drive.google.com/file/d/1jzhGGe5SBJcqfsjxCLHoh4Kazke1oTfC/view
> (took me about a minute to extract from test by replacing memfd_create
> with open and running the program).

Says the expert who knows exactly how it's all put together. It took
me a couple of hours just to understand WTF the syzbot reproducer
was actually doing....

> Then do the following to trigger the bug:
> losetup /dev/loop0 xfs.repro
> mkdir xfs
> mount -t xfs -o nouuid,prjquota,noikeep,quota /dev/loop0 xfs
> 
> To answer your more general question: syzbot is not a system to test
> solely file systems, it finds bugs in hundreds of kernel subsystems.
> Generating image for file systems, media files for sound and
> FaceDancer programs that crash host when  FaceDancer device is plugged
> into USB is not feasible. And in the end it's not even clear what

I don't care how syzbot generates the filesystem image it uses.

> kernel subsystem is at fault and even if it somehow figures out that
> it's a filesystem, it's unclear that it's exactly an image that
> provokes the bug. syzbot provides C reproducers which is a reasonable

It doesn't matter *what subsystem breaks*. If syzbot is generating a
filesystem image and then mounting it, it needs to provide that
filesystem image to to people who end up having to debug the
problem. It's a basic "corrupt filesystem" bug triage step.

> Some bugs are so involved that only an
> expert in a particular subsystem can figure out what happens there.

And that's clearly the case here, whether you like it or not.

You want us to do things that make syzbot more useful as a tool but
you don't want to do things that make syzbot a useful tool for us.
It's a two way street....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
