Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11188 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725724AbeJCGAL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Oct 2018 02:00:11 -0400
Date: Wed, 3 Oct 2018 09:14:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Message-ID: <20181002231421.GQ18567@dastard>
References: <20180907015155.32559-1-david@fromorbit.com>
 <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
 <20181001010931.GO31060@dastard>
 <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
 <20181001223244.GH18567@dastard>
 <CAOQ4uxhTJcEtUJkwO5UCyF1sCFQ=bPo0ragy5255aM30C9Z1Zw@mail.gmail.com>
 <20181002063952.GN18567@dastard>
 <CAJfpegvcmKiaU-oPfXk0ub6tdBKhDRcUKTkLd5_rAagv05R-EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvcmKiaU-oPfXk0ub6tdBKhDRcUKTkLd5_rAagv05R-EA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

On Tue, Oct 02, 2018 at 09:33:30AM +0200, Miklos Szeredi wrote:
> On Tue, Oct 2, 2018 at 8:39 AM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > Have a look at shrink_dcache_sb() and shrink_dcache_for_umount() and
> > what they imply about the dentries that take references to an inode
> > on a different superblock. Then look at generic_shutdown_super() -
> > pay attention to what happens if there are still allocated inodes
> > after all the superblock dentries have been pruned and inodes
> > evicted. i.e. this will trigger if some other superblock holds
> > references to them:
> >
> >                 if (!list_empty(&sb->s_inodes)) {
> >                         printk("VFS: Busy inodes after unmount of %s. "
> >                            "Self-destruct in 5 seconds.  Have a nice day...\n",
> >                            sb->s_id);
> >                 }
> >
> 
> Overlay holds references to the underlying sb's (through a set of
> internal mounts), so that's not going to happen.

Ok, so that example is not going to trigger. That doesn't mean it
isn't a problem, though....

> > If overlay puts unlinked dentries on it's LRU where the superblock
> > shrinker may clean them up and release the final reference to
> > unlinked inodes, then whatever calls the shrinker will get blocked.
> > If kswapd does the shrinking, then the whole system can lock up
> > because kswapd can't make progress until the filesystem is unfrozen.
> > And if the process that does that unfreezing needs memory....
> 
> Seems like freezing any of the layers if overlay itself is not frozen
> is not a good idea.

That's something we can't directly control. e.g. lower filesystem is
on a DM volume. DM can freeze the lower fileystem through the block
device when a dm command is run. It may well be that the admins that
set up the storage and filesystem layer have no idea that there are
now overlay users on top of the filesystem they originally set up.
Indeed, the admins may not even know that dm operations freeze
filesystems because it happens completely transparently to them.

> Preventing unlink (or modification generally) on the underlying layers
> if part of an overlay is also doable, but it would likely run into
> such backward compat issues that no one would be happy.   So I don't
> think that's now the way to go.   We could have done that initially,
> but it turns out allowing modification of the underlying layers can be
> useful at times.

Which means we're stuck with a fundamental "overlay can
panic/deadlock machines" problem, yes?

> > I can think of several other similar ways that we can probably be
> > screwed by cross-superblock references and memory reclaim
> > interactions. I can't think of any way to avoid them except for
> > not getting into that mess in the first place.
> 
> The freezer interaction can be solved by letting the freezer know
> about the dependencies of filesystems.

What freezer is that - the userspace application that calls the
freeze ioctl()?

> So if an underlying layer
> needs to be frozen, then all stacks containing that underlying layer
> would need to be frozen first.  I guess any of the other bad
> interactions would be solvable in a similar manner.

We've talked about this in the context for fixing the hibernation
mess - freezing multiple layers requires determining the
dependencies between filesystem layers, and it has to work both
up and down the dependency tree. And that tree has to include block
devices, because things like loopback devices and locally mounted
network devices form part of that dependency tree.

Doing that as a global "freeze everything" operation can be solved
by reverse walking the superblock list (as it's in sb instantiation
order), but we have no obvious way of solving this dependency
problem for any random superblock in the system. If you have a
solution to this, I'm all ears :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
