Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55192 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1432474AbdDZAFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Apr 2017 20:05:53 -0400
Date: Wed, 26 Apr 2017 10:04:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Reviewing determinism of xfs_reclaim_inodes_ag()
Message-ID: <20170426000426.GK12369@dastard>
References: <20170425082503.GN28800@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170425082503.GN28800@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>, Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.com>

[Luis, FYI - lots of stray whitespace in this email - I've trimmed
it from my reply...]

On Tue, Apr 25, 2017 at 10:25:03AM +0200, Luis R. Rodriguez wrote:
> I've been staring at xfs_reclaim_inodes_ag() for a bit now to determine
> if and how its deterministic it is. Fortunately the code makes it relatively
> clear it chugs on 32 xfs_inodes at at a time before cond_resched()'ing. I was
> concerned originally if we cond_resched() even if we goto restart but it seems
> we do.
> 
> While reviewing this however I ran into the following question based on a
> comment on the routine. Is such a thing as the below change needed ?
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 3531f8f72fa5..05f3c79b4f11 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1157,7 +1157,9 @@ xfs_reclaim_inodes_ag(
>  			for (i = 0; i < nr_found; i++) {
>  				struct xfs_inode *ip = batch[i];
>  
> -				if (done || xfs_reclaim_inode_grab(ip, flags))
> +				if (done ||
> +				    XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno ||
> +				    xfs_reclaim_inode_grab(ip, flags))
>  					batch[i] = NULL;

If a new check is required here, it belongs in
xfs_reclaim_inode_grab(), not as separate logic in the if statement
here as it needs to be serialised with other checks the grab does.

As it is, the grab code first checks for a zero ip->ino, which will
catch all cases where the inode is still in the RCU grace period and
a lookup has raced. If the inode is not under reclaim (i.e the inode
number is non-zero) then the grab code checks and sets XFS_IRECLAIM
under a spinlock, thereby prevent all further inode cache
lookup+grab operations from succeeding until reclaim completes and
the RCU grace period expires and frees the inode. i.e. if the
XFS_IRECLAIM flag is already set, then the inode is skipped
regardless of the inode number because it's already on it's way to
being freed by RCU.

Hence, IMO, adding this check here doesn't change lookup/reclaim
processing correctness.

> This is what the code looks like before but pay special attention to the
> comment and a race with RCU:
> 
>                                 if (done || xfs_reclaim_inode_grab(ip, flags))
>                                         batch[i] = NULL;
>
>                                 /*
>                                  * Update the index for the next lookup.
>                                  * Catch overflows into the next AG range
>                                  * which can occur if we have inodes in the
>                                  * last block of the AG and we are
>                                  * currently pointing to the last inode.
>                                  *
>                                  * Because we may see inodes that are from
>                                  * the wrong AG due to RCU freeing and
>                                  * reallocation, only update the index if
>                                  * it lies in this AG. It was a race that
>                                  * lead us to see this inode, so another
>                                  * lookup from
>                                  * the same index will not find it again.
>                                  */
>                                 if (XFS_INO_TO_AGNO(mp, ip->i_ino) !=
>                                                                 pag->pag_agno)
>                                         continue;

It's stale code left over from development of the RCU freeing of
inodes where .....

> I checked with Jan Kara and he believes the current code is correct but that
> its the comment that that may be misleading. As per Jan the race is between
> getting an inode reclaimed and grabbing it. Ie, XFS frees the inodes by RCU.
> However it doesn't actually *reuse* the inode until RCU period passes
> (unlike inodes allocated from slab with SLAB_RCU can be). So it can happen

..... I initially tried using SLAB_DESTROY_BY_RCU which meant the
RCU grace period did not prevent reallocation of inodes that had
been freed. Hence this check was (once) necessary to prevent the
reclaim index going whacky on a reallocated inode.

However, I dropped the SLAB_DESTROY_BY_RCU behaviour because I
couldn't get it to work reliably and race free, and there was no
measurable improvement in performance just using call_rcu() t delay
the freeing of individual inodes to the end of the RCU grace period.

In hindsight, I forgot to remove the second comment hunk and the
check that was eventually committed as 1a3e8f3da09c ("xfs: convert
inode cache lookups to use RCU locking"). It also appears the commit
message was not updated, too. It says:

    To avoid the read vs write contention, change the cache to use
    RCU locking on the read side. To avoid needing to RCU free every
    single inode, use the built in slab RCU freeing mechanism. This
    requires us to be able to detect lookups of freed inodes, [...]

So, really, the comment+check you're confused about can simply be
removed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
