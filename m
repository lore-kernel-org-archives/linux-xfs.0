Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751595AbdFHPjA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jun 2017 11:39:00 -0400
Date: Thu, 8 Jun 2017 11:38:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: fix spurious spin_is_locked() assert failures on
 non-smp kernels
Message-ID: <20170608153855.GE5244@bfoster.bfoster>
References: <1496840455-65279-1-git-send-email-bfoster@redhat.com>
 <20170608152607.GH4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608152607.GH4530@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 08, 2017 at 08:26:07AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 07, 2017 at 09:00:55AM -0400, Brian Foster wrote:
> > The 0-day kernel test robot reports assertion failures on
> > !CONFIG_SMP kernels due to failed spin_is_locked() checks. As it
> > turns out, spin_is_locked() is hardcoded to return zero on
> > !CONFIG_SMP kernels and so this function cannot be relied on to
> > verify spinlock state in this configuration.
> > 
> > To avoid this problem, replace the associated asserts with lockdep
> > variants that do the right thing regardless of kernel configuration.
> > Drop the one assert that checks for an unlocked lock as there is no
> > suitable lockdep variant for that case. This moves the spinlock
> > checks from XFS debug code to lockdep, but generally provides the
> > same level of protection.
> > 
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Here's another version that uses lockdep calls as suggested by
> > Christoph.
> 
> Looks ok, will test:
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hmm.... do you want me to put this into 4.12?  It's sort of a regression
> introduced in -rc4, but on the other hand this seems to have been broken
> for quite a while for SMP=n && XFS_DEBUG=y and nobody complained...
> 

I don't have a major preference either way. I generally agree that the
issue is old and that the recent patch just widened the scope slightly
such that the 0-day test caught it, so I'm fine with deferring it to
next from a technical perspective.

I'm actually not sure if the 0-day test thing is going to continue to
complain about the issue on subsequent merges or -rc drops, or if it's
just a one time informational thing..? If the former I suppose it might
make sense to drop this into 4.12 to quiet the tests and fix the
"regression." If the latter, perhaps just defer it..?

Thanks for the review..

Brian

> --D
> 
> > 
> > Brian
> > 
> > v2:
> > - Use lockdep asserts instead of config check.
> > - Drop !spin_is_locked() assert from inode initialization.
> > v1: http://www.spinics.net/lists/linux-xfs/msg07463.html
> > 
> >  fs/xfs/xfs_buf.c    | 2 +-
> >  fs/xfs/xfs_icache.c | 5 ++---
> >  2 files changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 07b77b7..16d6a57 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -117,7 +117,7 @@ static inline void
> >  __xfs_buf_ioacct_dec(
> >  	struct xfs_buf	*bp)
> >  {
> > -	ASSERT(spin_is_locked(&bp->b_lock));
> > +	lockdep_assert_held(&bp->b_lock);
> >  
> >  	if (bp->b_state & XFS_BSTATE_IN_FLIGHT) {
> >  		bp->b_state &= ~XFS_BSTATE_IN_FLIGHT;
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index f61c84f8..990210f 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -66,7 +66,6 @@ xfs_inode_alloc(
> >  
> >  	XFS_STATS_INC(mp, vn_active);
> >  	ASSERT(atomic_read(&ip->i_pincount) == 0);
> > -	ASSERT(!spin_is_locked(&ip->i_flags_lock));
> >  	ASSERT(!xfs_isiflocked(ip));
> >  	ASSERT(ip->i_ino == 0);
> >  
> > @@ -190,7 +189,7 @@ xfs_perag_set_reclaim_tag(
> >  {
> >  	struct xfs_mount	*mp = pag->pag_mount;
> >  
> > -	ASSERT(spin_is_locked(&pag->pag_ici_lock));
> > +	lockdep_assert_held(&pag->pag_ici_lock);
> >  	if (pag->pag_ici_reclaimable++)
> >  		return;
> >  
> > @@ -212,7 +211,7 @@ xfs_perag_clear_reclaim_tag(
> >  {
> >  	struct xfs_mount	*mp = pag->pag_mount;
> >  
> > -	ASSERT(spin_is_locked(&pag->pag_ici_lock));
> > +	lockdep_assert_held(&pag->pag_ici_lock);
> >  	if (--pag->pag_ici_reclaimable)
> >  		return;
> >  
> > -- 
> > 2.7.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
