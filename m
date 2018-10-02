Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24120 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbeJBNVg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 09:21:36 -0400
Date: Tue, 2 Oct 2018 16:39:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Message-ID: <20181002063952.GN18567@dastard>
References: <20180907015155.32559-1-david@fromorbit.com>
 <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
 <20181001010931.GO31060@dastard>
 <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
 <20181001223244.GH18567@dastard>
 <CAOQ4uxhTJcEtUJkwO5UCyF1sCFQ=bPo0ragy5255aM30C9Z1Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhTJcEtUJkwO5UCyF1sCFQ=bPo0ragy5255aM30C9Z1Zw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Miklos Szeredi <miklos@szeredi.hu>

Ove a n Tue, Oct 02, 2018 at 07:02:08AM +0300, Amir Goldstein wrote:
> On Tue, Oct 2, 2018 at 1:32 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Mon, Oct 01, 2018 at 10:56:25AM +0300, Amir Goldstein wrote:
> [...]
> > > So while the statement "it's not a deadlock" may still be true, I am not
> > > yet convinced that the claim that there are no dirty pages to write when
> > > filesystem is frozen is sufficient to back that claim.
> > >
> > > Are you sure there was no deadlock lurking in there while fs is past
> > > SB_FREEZE_FS and kswapd shrinker races with another process
> > > releasing the last reference to an(other) inode?
> >
> > The inodes being released by the shrinkers should be clean, and
> > hence releasing them does not require post-release transactions to
> > be run.
> >
> > It does concern me that the overlay dcache shrinker is dropping the
> > last reference to an XFS inode and it does not get put on the LRU
> > for the correct superblock inode cache shrinker to free it. That
> > implies that the overlay dcache shrinker is dropping the last
> > reference to an unlinked inode.
> 
> Yes, there is nothing that prevents overlayfs (or ecryptfs) to end up
> with the last reference on an underlying unlinked inode.

/me groans

> It will require an action of unlink from underlying layer, which is not
> normal user behavior, but it is possible.

Foot, meet Shotgun.

> > AFAIA, the dcache shrinker should never be freeing the last
> > reference to an unlinked inode - it should always be done from the
> > context that unlinked the inode or the context that closed the final
> > fd on that inode. i.e. a task context, not a shrinker or kswapd. Can
> > you confirm what the state of the inode being dropped in that
> > lockdep trace is?
> >
> 
> Given that the stress tests runs fsstress in parallel (same seed) on
> overlay and underlying lower fs, I would say that it is very likely to
> trip on shrinker putting an overlay dentry/inode holding the last reference
> to an unlinked underlying fs inode.

The shrinker still shouldn't trip on them. Whatever releases the
last reference to an unlinked file should be freeing the inode.

> How concerned are you about this?

Scares the hell outta me.

> Is it inherently hard to deal with
> this situation in XFS?

Nothing to do with the messenger.

Have a look at shrink_dcache_sb() and shrink_dcache_for_umount() and
what they imply about the dentries that take references to an inode
on a different superblock. Then look at generic_shutdown_super() -
pay attention to what happens if there are still allocated inodes
after all the superblock dentries have been pruned and inodes
evicted. i.e. this will trigger if some other superblock holds
references to them:

                if (!list_empty(&sb->s_inodes)) {
                        printk("VFS: Busy inodes after unmount of %s. "
                           "Self-destruct in 5 seconds.  Have a nice day...\n",
                           sb->s_id);
                }

The per-superblock cache infrastructure is built around the
assumption that the dentries referencing an inode all point to the
same superblock as the inode. Hence to free all the external
references to the superblock's inode cache, all we need to do is
prune the superblock's dentry cache. If something else is taking
external references to an inode, then this all breaks down.

The superblock shrinker is based around the same assumptions and so
makes the further assumption that it doesn't interact directly with
any other superblock. i.e. a superblock shrinker will only change
the state of objects the superblock directly owns. This means a
filesystem implementation only has to worry about it's own
shrinker(s) when considering memory reclaim recursion and other
issues like invalidating caches to prevent shrinker actions when
frozen.

If we have cross-superblock object references then it gets very
complicated very quickly. Freeze is a good example, as you
suspected. i.e. if the lower filesystem is frozen but overlay holds
open unlinked files on the lower filesystem, then overlay if going
to get blocked by the lower frozen filesystem when it tries to
release the final inode reference.

If overlay puts unlinked dentries on it's LRU where the superblock
shrinker may clean them up and release the final reference to
unlinked inodes, then whatever calls the shrinker will get blocked.
If kswapd does the shrinking, then the whole system can lock up
because kswapd can't make progress until the filesystem is unfrozen.
And if the process that does that unfreezing needs memory....

I can think of several other similar ways that we can probably be
screwed by cross-superblock references and memory reclaim
interactions. I can't think of any way to avoid them except for
not getting into that mess in the first place.

> pardon my ignorance, but can't memory shrinker
> trigger oom killer indirectly causing to release deleted inodes?
> Not sure in which context those files/inodes get released?

The oom killer doesn't free anything. It marks a process as being
killed, then when that process context gets scehduled it exits,
releasing all the open files it holds and so dropping the last
reference to the dentries in task context, not the OOM kill context.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
