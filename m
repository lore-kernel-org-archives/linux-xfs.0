Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752657AbdC0XOe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 19:14:34 -0400
Date: Tue, 28 Mar 2017 01:14:26 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Suspend fails when xfs is involved?
Message-ID: <20170327231426.GO28800@wotan.suse.de>
References: <20170203010401.GR9134@birch.djwong.org>
 <20170203223127.GC32761@dastard>
 <20170327204607.GA4874@birch.djwong.org>
 <1707526.iy5HQXy0ZS@aspire.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1707526.iy5HQXy0ZS@aspire.rjw.lan>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.com>, Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>, linux-pm@vger.kernel.org

On Tue, Mar 28, 2017 at 12:30:40AM +0200, Rafael J. Wysocki wrote:
> On Monday, March 27, 2017 01:46:07 PM Darrick J. Wong wrote:
> > [cc linux-pm since this intersects with suspend...]
> > > 
> > > That's inode writeback when the underlying inode buffer has been
> > > reclaimed before the dirty cached inode has been written. So the
> > > xfsaild is doing read/modify/write cycles to write back dirty
> > > inodes. i.e. you're running in active memory reclaim conditions
> > > prior to suspend...
> > 
> > So I wrote up a patch that removes WQ_FREEZABLE from the xfs_buf thread,
> > and since then I haven't had any problems suspending my laptop.  Last
> > week at LSF I inquired about whether it was proper to be freezing IO
> > helper threads as part of suspend, and was told in response "Are you
> > convinced that use of WQ_FREEZABLE is even correct?"  TBH I can't see
> > why you'd want to freeze IO helper workqueues at all.
> > 
> > So, I'm going to email that patch out as an RFC and if anyone wants to
> > follow up the discussion, let's do it there.
> 
> Yes, please!

Do we any respective xfstests for this sort of stuff ? FWIW I've been
starting to try to draw up some tests on some other fs lookup stuff and
had to cook up scripts using resume on qemu, to do that, in case its
helpful use:

QEMU_CTRL="/dev/pts/7"
echo system_wakeup | socat - $QEMU_CTRL,raw,echo=0,crnl

Sadly, the above only works *sometimes*, so you have to smack qemu
a few times with it seems.

> > I get it, suspend really
> > should just fsfreeze, but the question I really want to know is, why
> > does XFS freeze its own threads?  They seem to go to sleep just fine
> > after we're done doing all the IO we want.
> 
> That, quite frankly, is what I would expect.

Do we have a deterministic requirement for how long this IO wait should / can
last for ? FWIW if we have tasks we *know* need to complete prior to suspend
we can do these with the pm ops. If something not done on pm ops is blocking
already though do we want a limit ? Why did XFS start freezing its own threads
to begin with ?

> > > > ISTR Dave or someone grumbling about this being some artifact of the log
> > > > trying to read in some buffer or other as part of flushing the log prior
> > > > to suspend, but the io completion ends up tied to a workqueue that's
> > > > already been put to sleep, so xfs gets stuck forever.
> > > 
> > > Yup, suspend is just completely fucked, has been for more than 10
> > > years. It needs to freeze filesystems so they are quiesced sanely,
> > > not left to run while random parts of the kernel infrastructure they
> > > rely on are shut down behind the filesystem's back.
> > > 
> > > > Look familiar to anyone before I try to debug this tomorrow?
> > > 
> > > See this as a recent starting point.
> > > 
> > > https://lwn.net/Articles/705269/
> > 
> > I wonder if they've done any work on freezing filesystems...
> 
> Not that I know of.

https://git.kernel.org/pub/scm/linux/kernel/git/jikos/jikos.git/commit/?h=might-rebase/get-rid-of-kthread-freezer&id=394aa67810abefde6d79ea96a90e5d41a7df99f4

freeze_all_supers() ?

  Luis
