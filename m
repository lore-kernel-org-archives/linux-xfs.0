Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:23804 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726321AbeJBFMt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 01:12:49 -0400
Date: Tue, 2 Oct 2018 08:32:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Message-ID: <20181001223244.GH18567@dastard>
References: <20180907015155.32559-1-david@fromorbit.com>
 <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
 <20181001010931.GO31060@dastard>
 <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Oct 01, 2018 at 10:56:25AM +0300, Amir Goldstein wrote:
> On Mon, Oct 1, 2018 at 4:09 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Sun, Sep 30, 2018 at 10:56:02AM +0300, Amir Goldstein wrote:
> > > [CC Ted and Jan to see if there are lessons here that apply to ext2 ext4]
> > >
> > > On Fri, Sep 7, 2018 at 6:03 AM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > >
> > > > We've had a few reports of lockdep tripping over memory reclaim
> > > > context vs filesystem freeze "deadlocks". They all have looked
> > > > to be false positives on analysis, but it seems that they are
> > > > being tripped because we take freeze references before we run
> > > > a GFP_KERNEL allocation for the struct xfs_trans.=====
> > > >
> > > > We can avoid this false positive vector just by re-ordering the
> > > > operations in xfs_trans_alloc(). That is. we need allocate the
> > > > structure before we take the freeze reference and enter the GFP_NOFS
> > > > allocation context that follows the xfs_trans around. This prevents
> > > > lockdep from seeing the GFP_KERNEL allocation inside the transaction
> > > > context, and that prevents it from triggering the freeze level vs
> > > > alloc context vs reclaim warnings.
> > > >
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > >
> [...]
> > > I was getting the lockdep warning below reliably with the stress test
> > > overlay/019 (over bas fs xfs with reflink) ever since kernel v4.18.
> > > The warning is tripped on my system after 2 minutes of stress test.
> > >
> > > The possibly interesting part about this particular splat is that, unlike
> > > previously reported traces [1][2], sb_internals is not taken by kswapd
> > > from pagewrite path, which as you wrote is not possible during freeze
> > > level internal. In my splats sb_internals is taken by kswapd from
> > > dcache shrink path.
> >
> > Which is exactly the same case. i.e. a transaction is being run
> > from kswapd's reclaim context. It doesn't matter if it's an extent
> > allocation transaction in the direct page writeback path, or
> > prune_dcache_sb() killing a dentry and dropping the last reference
> > to an unlinked inode triggering a truncate, or indeed prune_icache_sb
> > dropping an inode off the LRU and triggering a truncate of
> > specualtively preallocated blocks beyond EOF.
> >
> > i.e. Lockdep is warning about a transaction being run in kswapd's
> > reclaim context - this is something we are allowed to do (and need
> > to do to make forwards progress) because the kswapd reclaim context
> > is GFP_KERNEL....
> >
> 
> I understand that, but I would still like to ask for a clarification on one
> point. In response to one of the lockdep warning reports [1] you wrote:
> "It's not a deadlock - for anything to deadlock in this path, we have
> to be in the middle of a freeze and have frozen the transaction
> subsystem. Which we cannot do until we've cleaned all the dirty
> cached pages in the filesystem and frozen all new writes. Which means
> kswapd cannot enter this direct writeback path because we can't have
> dirty pages on the filesystem."
> 
> I don't see how this argument holds for the shrinker case.
> That is, if filesystem is already past freezing the transaction subsystem
> and then kswapd comes along and runs the shrinkers.

We've already cleaned all the dirty inodes before we pruned out all
the reclaimable inodes from the cache as part of the freeze process.
Hence the XFS filesystem should not be holding any inodes that need
post-release transactions to be run. i.e. freeze has already cleaned
up anything that shrinkers might trip over.

> So while the statement "it's not a deadlock" may still be true, I am not
> yet convinced that the claim that there are no dirty pages to write when
> filesystem is frozen is sufficient to back that claim.
> 
> Are you sure there was no deadlock lurking in there while fs is past
> SB_FREEZE_FS and kswapd shrinker races with another process
> releasing the last reference to an(other) inode?

The inodes being released by the shrinkers should be clean, and
hence releasing them does not require post-release transactions to
be run.

It does concern me that the overlay dcache shrinker is dropping the
last reference to an XFS inode and it does not get put on the LRU
for the correct superblock inode cache shrinker to free it. That
implies that the overlay dcache shrinker is dropping the last
reference to an unlinked inode.

AFAIA, the dcache shrinker should never be freeing the last
reference to an unlinked inode - it should always be done from the
context that unlinked the inode or the context that closed the final
fd on that inode. i.e. a task context, not a shrinker or kswapd. Can
you confirm what the state of the inode being dropped in that
lockdep trace is?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
