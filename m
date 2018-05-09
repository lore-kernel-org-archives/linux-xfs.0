Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:14769 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932475AbeEIAuO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 20:50:14 -0400
Date: Wed, 9 May 2018 10:50:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Message-ID: <20180509005011.GP23861@dastard>
References: <f403043cbe8414177d0568e81405@google.com>
 <20180403043854.GL1150@dastard>
 <CACT4Y+ZadV0xTqhiGTAHmadAnYaSfPKhUy_TFXMza2o_n8+o9w@mail.gmail.com>
 <CACT4Y+aQZ8KbU1C-sJ2PUKn_788SEKQpYGjoLaRDJrP9vXjs-A@mail.gmail.com>
 <20180501225159.GY23861@dastard>
 <CACT4Y+YZYHG=MyujDdTLxO=cn7Yz34vv6WKVjWr3Jvo1YTk0HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YZYHG=MyujDdTLxO=cn7Yz34vv6WKVjWr3Jvo1YTk0HA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>

On Tue, May 08, 2018 at 09:56:01AM +0200, Dmitry Vyukov wrote:
> On Wed, May 2, 2018 at 12:51 AM, Dave Chinner <david@fromorbit.com> wrote:
> >> >>> Hello,
> >> >>>
> >> >>> syzbot hit the following crash on upstream commit
> >> >>> 86bbbebac1933e6e95e8234c4f7d220c5ddd38bc (Mon Apr 2 18:47:07 2018 +0000)
> >> >>> Merge branch 'ras-core-for-linus' of
> >> >>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> >> >>> syzbot dashboard link:
> >> >>> https://syzkaller.appspot.com/bug?extid=84a67953651a971809ba
> >> >>>
> >> >>> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=5719304272084992
> >> >>> syzkaller reproducer:
> >> >>> https://syzkaller.appspot.com/x/repro.syz?id=5767783983874048
> >> >>
> >> >> What a mess. A hand built, hopelessly broken filesystem image made
> >> >> up of hex dumps, written into a mmap()d region of memory, then
> >> >> copied into a tmpfs file and mounted with the loop device.
> >> >>
> >> >> Engineers that can debug broken filesystems don't grow on trees.  If
> >> >> we are to have any hope of understanding what the hell this test is
> >> >> doing, the bot needs to supply us with a copy of the built
> >> >> filesystem image the test uses. We need to be able to point forensic
> >> >> tools at the image to decode all the structures into human readable
> >> >> format - if we are forced to do that by hand or jump through hoops
> >> >> to create our own filesystem image than I'm certainly not going to
> >> >> waste time looking at these reports...
> >> >
> >> > Hi Dave,
> >> >
> >> > Here is the image:
> >> > https://drive.google.com/file/d/1jzhGGe5SBJcqfsjxCLHoh4Kazke1oTfC/view
> >>
> >> Have anybody looked at the bug and the image yet?
> >
> > Yes, I did that a couple of weeks ago. Couldn't reproduce on a TOT
> > kernel here.
> 
> Do you think it is fixed now? What fixed it? The bug was there.

We merge fixes for fuzzing issues all the time. IIRC a big batch of
them from the xfstests fuzzing infrastructure went into 4.17-rc1.

If you want a commit, then do a bisect....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
