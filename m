Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41438 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbfHIALS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 20:11:18 -0400
Date: Fri, 9 Aug 2019 10:10:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 22/24] xfs: track reclaimable inodes using a LRU list
Message-ID: <20190809001005.GW7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-23-david@fromorbit.com>
 <20190808163653.GB24551@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808163653.GB24551@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Thu, Aug 08, 2019 at 12:36:53PM -0400, Brian Foster wrote:
> On Thu, Aug 01, 2019 at 12:17:50PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we don't do IO from the inode reclaim code, there is no
> > need to optimise inode scanning order for optimal IO
> > characteristics. The AIL takes care of that for us, so now reclaim
> > can focus on selecting the best inodes to reclaim.
> > 
> > Hence we can change the inode reclaim algorithm to a real LRU and
> > remove the need to use the radix tree to track and walk inodes under
> > reclaim. This frees up a radix tree bit and simplifies the code that
> > marks inodes are reclaim candidates. It also simplifies the reclaim
> > code - we don't need batching anymore and all the reclaim logic
> > can be added to the LRU isolation callback.
> > 
> > Further, we get node aware reclaim at the xfs_inode level, which
> > should help the per-node reclaim code free relevant inodes faster.
> > 
> > We can re-use the VFS inode lru pointers - once the inode has been
> > reclaimed from the VFS, we can use these pointers ourselves. Hence
> > we don't need to grow the inode to change the way we index
> > reclaimable inodes.
> > 
> > Start by adding the list_lru tracking in parallel with the existing
> > reclaim code. This makes it easier to see the LRU infrastructure
> > separate to the reclaim algorithm changes. Especially the locking
> > order, which is ip->i_flags_lock -> list_lru lock.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_icache.c | 31 +++++++------------------------
> >  fs/xfs/xfs_icache.h |  1 -
> >  fs/xfs/xfs_mount.h  |  1 +
> >  fs/xfs/xfs_super.c  | 31 ++++++++++++++++++++++++-------
> >  4 files changed, 32 insertions(+), 32 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index a59d3a21be5c..b5c4c1b6fd19 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> ...
> > @@ -1801,7 +1817,8 @@ xfs_fs_nr_cached_objects(
> >  	/* Paranoia: catch incorrect calls during mount setup or teardown */
> >  	if (WARN_ON_ONCE(!sb->s_fs_info))
> >  		return 0;
> > -	return xfs_reclaim_inodes_count(XFS_M(sb));
> > +
> > +	return list_lru_shrink_count(&XFS_M(sb)->m_inode_lru, sc);
> 
> Do we not need locking here,

No locking is needed - we have no global lock that protects the
list_lru that we could use to serialise the count - that would
completely destroy the scalability advantages the list_lru provide.
As it is, shrinker counts have always been inherently racy and so we
don't really care for accuracy anywhere in the shrinker code. Hence
there is no need to attempt to be accurate here, just like didn't
attempt to be accurate for the per AG reclaimable inode count
aggregation that this replaces.

> or are we just skipping it because this
> apparently maintains a count field and accuracy isn't critical? If the
> latter, a one liner comment would be useful.

I don't think it needs comments as they would be stating the
obvious.  We don't have comments explaining this in any other
shrinker - it's jsut assumed that anyone working with shrinkers
already knows that the counts are not required to be exactly
accurate...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
