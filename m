Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:42159 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752243AbcJGJ5x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 05:57:53 -0400
Date: Fri, 7 Oct 2016 20:57:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
Message-ID: <20161007095749.GI9806@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com>
 <20161005153014.GC26977@htj.duckdns.org>
 <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com>
 <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com>
 <20161005200522.GE19539@ZenIV.linux.org.uk>
 <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com>
 <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com>
 <1149670394.870034.1475770286233.JavaMail.zimbra@redhat.com>
 <CA+55aFz28kQUAYoSFzvEpq5MkYHNcKx2KWP-kpruuyWe7AEY2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz28kQUAYoSFzvEpq5MkYHNcKx2KWP-kpruuyWe7AEY2Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CAI Qian <caiqian@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, tj <tj@kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Oct 06, 2016 at 10:00:08AM -0700, Linus Torvalds wrote:
> On Thu, Oct 6, 2016 at 9:11 AM, CAI Qian <caiqian@redhat.com> wrote:
> >
> >>
> >> Wait. There is also a lockep happened before the xfs internal error as well.
> > Some other lockdep this time,
> 
> This one looks just bogus.
> 
> > [ 4872.569797]  Possible unsafe locking scenario:
> > [ 4872.569797]
> > [ 4872.576401]        CPU0
> > [ 4872.579127]        ----
> > [ 4872.581854]   lock(&xfs_nondir_ilock_class);
> > [ 4872.586637]   <Interrupt>
> > [ 4872.589558]     lock(&xfs_nondir_ilock_class);
> 
> I'm not seeing that .lock taken in interrupt context.

It's a memory allocation vs reclaim context warning, not a lock
warning. That overloads the lock vs interrupt lockdep mechanism, so
if lockdep sees a context violation it is reported as an "interrupt
context" lock problem.

The allocation context in question is in a function that can be
called from both inside and outside a transaction context. When
outside a transaction, it's a GFP_KERNEL allocation, when inside
it's a GFP_NOFS context.  However, both allocation contexts hold the
inode ilock over the allocation.

the inode shrinker (reclaim context) also happens to take the inode
ilock, and that's what lockdep is complaining about. i.e. it thinks
that this path ilock -> alloc(GFP_KERNEL) -> reclaim -> ilock can
deadlock. But it can't - the ilock held at the upper side is a
referenced inode and can't be seen by reclaim, and the ilocks taken
by reclaim are inodes that can't be seen or referenced by the VFS.

i.e. There's no depedencies between the ilocks on either side of
memory allocation, but there's no way of telling lockdep that short
of giving the inodes in reclaim a different lock class. We used to
do that, but that was a nasty hack and prevented lockdep from
verifying locking orders used on inodes and objects in reclaim
matched the locking orders of referenced inodes...

We've historically shut these false positives up by simply making
all the allocations in these dual context paths GFP_NOFS. However, I
recently got told not to do that by someone on the mm side because
it exacerbated deficiencies in memory reclaim when too many
allocations use GFP_NOFS.

So it's not "fixed" and instead I'm ignoring it.  If you spend any
amount of time running lockdep on XFS you'll get as sick and tired
of playing this whack-a-lockdep-false-positive game as I am.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
