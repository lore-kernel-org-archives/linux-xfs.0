Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Mar 2008 15:31:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2UMUqVT028308
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2008 15:30:55 -0700
Date: Mon, 31 Mar 2008 08:31:02 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC PATCH] freeze feature ver 1.0
Message-ID: <20080330223102.GE103491721@sgi.com>
References: <20080328180145t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328180145t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: David Chinner <dgc@sgi.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Mar 28, 2008 at 06:01:45PM +0900, Takashi Sato wrote:
> Hi,
> 
> David Chinner wrote:
> > Can you please split this into two patches - one which introduces the
> > generic functionality *without* the timeout stuff, and a second patch
> > that introduces the timeouts.
> 
> OK.
> I will send the split patches in subsequent mails. 
>  
> > I think this timeout stuff is dangerous - it adds significant
> > complexity and really does not protect against anything that can't
> > be done in userspace.  i.e. If your system is running well enough
> > for the timer to fire and unfreeze the filesystem, it's running well
> > enough for you to do "freeze X; sleep Y; unfreeze X".  
> 
> If the process is terminated at "sleep Y" by an unexpected
> accident (e.g. signals),  the filesystem will be left frozen.

At which point you run "unfreeze /mnt/fs" and unfreeze it.

If you've got a script that fails in the middle of an operation that
freezes the filesystem, then the error handling of that script
needs to unfreeze the filesystem. The kernel does not need to do
this.

> So, I think the timeout is needed to unfreeze more definitely.

No, it can be handled by userspace perfectly well.

> > FWIW, there is nothing to guarantee that the filesystem has finished
> > freezing when the timeout fires (it's not uncommon to see
> > freeze_bdev() taking *minutes*) and unfreezing in the middle of a
> > freeze operation will cause problems - either for the filesystem
> > in the middle of a freeze operation, or for whatever is freezing the
> > filesystem to get a consistent image.....
> 
> Do you mention the freeze_bdev()'s hang?

If freeze_bdev() hangs, then you've got a buggy filesystem and far
more problems to worry about than undoing the freeze. It's likely
you're going to need a reboot to unwedge then hung filesystem.....

> The salvage target of my timeout is freeze process's accident as below.
> - It is killed before calling the unfreeze ioctl

Can be fixed from userspace.

> - It causes a deadlock by accessing the frozen filesystem

Application bug. Undeadlock it by running "unfreeze /mnt/fs"....

FWIW, DM is quite capable of freezing the filesystem, snapshotting
it and then unfreezing it without hanging, crashing or having nasty
stuff in general happen. We've used 'xfs_freeze -f /mnt/fs;
do_something; xfs_freeze -u /mnt/fs' for years without having
problems with freeze hanging, application deadlocks, etc.....

... And if something has gone wrong during the freeze, it is far,
far better to leave the filesystem stuck in a frozen state than to
unfreeze it and allow it to be damaged further. If you get stuck or
a script gets killed in the middle of execution, then an admin needs
to look at the problem immediately. Just timing out and unfreezing
is about the worst thing you can do because it allows problems
(corruptions, errors, etc) to be propagated and potentially make
things worse before an admin can intervene and fix things up....

Basically, I don't want to have to deal with the "snapshot
image corrupt" bug reports that will come from user
misuse/misunderstanding of the "freeze timeout". It's hard enough
tracking down these sorts of problems without throwing in the
"freeze timed out before completion" possibility that guarantees
a non-consistent snapshot image.....

/me points to the ASSERT_ALWAYS() in xfs_attr_quiesce() that ensures
we get bug reports when the filesystem is still being actively
modified when the freeze "completes".

> So the delayed work for the timeout is set after all of freeze operations
> in freeze_bdev() in my patches.
> I think the filesystem dependent code (write_super_lockfs operation)
> should be implemented not to cause a hang.

And that should already be the case. If write_super_lockfs() hangs,
then you've got a filesystem bug ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
