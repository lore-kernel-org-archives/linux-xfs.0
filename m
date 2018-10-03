Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:38472 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726188AbeJDFts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 01:49:48 -0400
Date: Thu, 4 Oct 2018 08:59:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Message-ID: <20181003225917.GR18567@dastard>
References: <20180907015155.32559-1-david@fromorbit.com>
 <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
 <20181001010931.GO31060@dastard>
 <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
 <20181001223244.GH18567@dastard>
 <CAOQ4uxhTJcEtUJkwO5UCyF1sCFQ=bPo0ragy5255aM30C9Z1Zw@mail.gmail.com>
 <20181002063952.GN18567@dastard>
 <CAJfpegvcmKiaU-oPfXk0ub6tdBKhDRcUKTkLd5_rAagv05R-EA@mail.gmail.com>
 <20181002231421.GQ18567@dastard>
 <CAOQ4uxhrEm4uMhsw5G+_Bv87-zPenJ9gwvDJvCPSmRkQAWiszQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhrEm4uMhsw5G+_Bv87-zPenJ9gwvDJvCPSmRkQAWiszQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

On Wed, Oct 03, 2018 at 06:45:13AM +0300, Amir Goldstein wrote:
> On Wed, Oct 3, 2018 at 2:14 AM Dave Chinner <david@fromorbit.com> wrote:
> [...]
> > > Seems like freezing any of the layers if overlay itself is not frozen
> > > is not a good idea.
> >
> > That's something we can't directly control. e.g. lower filesystem is
> > on a DM volume. DM can freeze the lower fileystem through the block
> > device when a dm command is run. It may well be that the admins that
> > set up the storage and filesystem layer have no idea that there are
> > now overlay users on top of the filesystem they originally set up.
> > Indeed, the admins may not even know that dm operations freeze
> > filesystems because it happens completely transparently to them.
> >
> 
> I don't think we should be binding the stacked filesystem issues with
> the stacked block over fs issues.

It's the same problem.  Hacking a one-off solution to hide a specific
overlay symptom does not address the root problem. And, besides, if
you stack like this:

overlay
  lower_fs
    loopback dev
      loop img fs

And freeze the loop img fs, overlay can still get stuck in it's
shrinker because the the lower_fs gets stuck doing IO on the frozen
loop img fs.

i.e. it's the same issue - kswapd will get stuck doing reclaim from
the overlay shrinker.

> The latter is more complex to solve
> generally and has by design non limited stack depth. The former has
> limited stack depth (2) and each sb knows its own stack depth, which
> is already used in overlay to annotate lockdep correctly.
> 
> If vfs stores a reverse tree of stacked fs dependencies, then individual
> sb freeze can be solved.

Don't make me mention bind mounts... :/

> Drawing the fire away from overlayfs.. I personally find the behavior that
> a process that only has files open for read could block when filesystem is
> frozen somewhat unexpected to users (even if I can expect it).

Filesystem reads have always been able to modify the file (e.g.
atime updates). Not to mention filesystem reads require memory
allocation, and that means any GFP_KERNEL direct reclaim can get
stuck on a frozen filesystem if that filesystem hasn't properly
cleared out it's dangerous reclaimable objects when freezing.

> I wonder out loud if it wouldn't be friendlier for any filesystem to defer
> "garbage collection" (e.g. truncate deleted inode blocks) to thawing time,

https://marc.info/?l=linux-xfs&m=153022904909523&w=2

Been on the list of "nice to have" unlink optimisations for XFS
since 2008.

But it's a performance optimisation and precursor for offlining AGs
for online repair, not something we've ever considered as needed for
correctness or to prevent deadlocks.

> just as those operations are already run on mount (post crash) anyway.

That's a completely different context - log recovery is much more
constrained in the amount of work it needs to do and has much more
freedom for handling errors (i.e. it can just leak bad unlinked
inodes). Runtime deferral of post-unlink, post-reference inode
reclaim is a *lot* more complex than processing pending unlinks in
log recovery.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
