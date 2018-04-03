Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:61046 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750814AbeDCEi5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Apr 2018 00:38:57 -0400
Date: Tue, 3 Apr 2018 14:38:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: WARNING: bad unlock balance in xfs_iunlock
Message-ID: <20180403043854.GL1150@dastard>
References: <f403043cbe8414177d0568e81405@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f403043cbe8414177d0568e81405@google.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: syzbot <syzbot+84a67953651a971809ba@syzkaller.appspotmail.com>
Cc: darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Mon, Apr 02, 2018 at 07:01:02PM -0700, syzbot wrote:
> Hello,
> 
> syzbot hit the following crash on upstream commit
> 86bbbebac1933e6e95e8234c4f7d220c5ddd38bc (Mon Apr 2 18:47:07 2018 +0000)
> Merge branch 'ras-core-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> syzbot dashboard link:
> https://syzkaller.appspot.com/bug?extid=84a67953651a971809ba
> 
> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=5719304272084992
> syzkaller reproducer:
> https://syzkaller.appspot.com/x/repro.syz?id=5767783983874048

What a mess. A hand built, hopelessly broken filesystem image made
up of hex dumps, written into a mmap()d region of memory, then
copied into a tmpfs file and mounted with the loop device.

Engineers that can debug broken filesystems don't grow on trees.  If
we are to have any hope of understanding what the hell this test is
doing, the bot needs to supply us with a copy of the built
filesystem image the test uses. We need to be able to point forensic
tools at the image to decode all the structures into human readable
format - if we are forced to do that by hand or jump through hoops
to create our own filesystem image than I'm certainly not going to
waste time looking at these reports...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
