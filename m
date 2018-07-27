Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48920 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbeG0XiG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Jul 2018 19:38:06 -0400
Date: Fri, 27 Jul 2018 15:13:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: verify icount in superblock write
Message-ID: <20180727221355.GN30972@magnolia>
References: <153262651940.8934.17525988748289196893.stgit@magnolia>
 <153262652554.8934.816888163232208002.stgit@magnolia>
 <20180726232028.GC2234@dastard>
 <20180727000715.GJ30972@magnolia>
 <20180727104439.GA21835@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180727104439.GA21835@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, billodo@redhat.com

On Fri, Jul 27, 2018 at 06:44:40AM -0400, Brian Foster wrote:
> On Thu, Jul 26, 2018 at 05:07:15PM -0700, Darrick J. Wong wrote:
> > On Fri, Jul 27, 2018 at 09:20:28AM +1000, Dave Chinner wrote:
> > > On Thu, Jul 26, 2018 at 10:35:25AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Add a helper predicate to check the inode count for sanity, then use it
> > > > in the superblock write verifier to inspect sb_icount.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_sb.c    |    1 +
> > > >  fs/xfs/libxfs/xfs_types.c |   34 ++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_types.h |    1 +
> > > >  3 files changed, 36 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > > index b2c683588519..1659016875f9 100644
> > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > @@ -714,6 +714,7 @@ xfs_sb_write_verify(
> > > >  	 * cases.
> > > >  	 */
> > > >  	if (sb.sb_fdblocks > sb.sb_dblocks ||
> > > > +	    !xfs_verify_icount(mp, sb.sb_icount) ||
> > > >  	    sb.sb_ifree > sb.sb_icount) {
> > > >  		xfs_notice(mp, "SB summary counter sanity check failed");
> > > >  		error = -EFSCORRUPTED;
> > > > diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> > > > index 2e2a243cef2e..2e9c0c25ccb6 100644
> > > > --- a/fs/xfs/libxfs/xfs_types.c
> > > > +++ b/fs/xfs/libxfs/xfs_types.c
> > > > @@ -171,3 +171,37 @@ xfs_verify_rtbno(
> > > >  {
> > > >  	return rtbno < mp->m_sb.sb_rblocks;
> > > >  }
> > > > +
> > > > +/* Calculate the range of valid icount values. */
> > > > +static void
> > > > +xfs_icount_range(
> > > > +	struct xfs_mount	*mp,
> > > > +	unsigned long long	*min,
> > > > +	unsigned long long	*max)
> > > > +{
> > > > +	unsigned long long	nr_inos = 0;
> > > > +	xfs_agnumber_t		agno;
> > > > +
> > > > +	/* root, rtbitmap, rtsum all live in the first chunk */
> > > > +	*min = XFS_INODES_PER_CHUNK;
> > > > +
> > > > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > > > +		xfs_agino_t	first, last;
> > > > +
> > > > +		xfs_agino_range(mp, agno, &first, &last);
> > > > +		nr_inos += first - last + 1;
> 
> Shouldn't this be last - first?

Oops, yes, will fix that.

> > > > +	}
> > > > +	*max = nr_inos;
> > > > +}
> > > 
> > > And the effect of the inode32 mount option on the valid icount range?
> > 
> > Heh, I wondered about that.  The premise of inode32 is that we will
> > never allocate an inode with a number exceeding 2^32, correct?  Do we
> > ever write anything to that fs to say "this fs must never have inode
> > numbers > 2^32"?  i.e. something that permanently restricts it to
> > 32-bit inode numbers and counts?  I don't think I see any such device.
> > 
> > What's supposed to happen if I create a > 1TB fs, put a bunch of files
> > on it such that some of them end up with inode numbers exceeding 2^32,
> > unmount it, and then mount it again with inode32?  Do we detect this and
> > refuse the mount because we can't honor the inode32 constraints?
> > 
> > Similarly, what if I create a filesystem with more than 4 billion files
> > on it, then unmount and remount with inode32?  Do we actually detect
> > this situation and refuse to mount because we know the counter is
> > already larger than 2^32?  If we allow the mount today, should we start
> > failing superblock writes because sb_icount is greater than 2^32?
> > 
> 
> I thought an inode32 mount should allow reading existing inode64 inodes
> without an issue. As noted above, it just prevents the allocation of
> further inodes beyond 1TB.
> 
> > In other words, I'm not sure inode32 can have any effect on the icount
> > *max if we don't refuse the mount if the fs already has 64-bit inodes.
> > 
> 
> This patch looks like it doesn't consider inode32. It just ensures that
> the icount falls into a valid range based on the ag geometry, which
> seems broad enough to cover all cases... hm?

Correct.

> That aside.. since these values shouldn't change often I'm wondering if
> it's worth calculating the global min/max once at mount time (we'd have
> to recalc on growfs) rather than in the sb verifier path... It looks
> like we already have a bunch of such misc min/max counters in xfs_mount.

<shrug> I suppose so, but otoh I doubt this function has a lot of
overhead.  I'll look into it for the next version.

--D

> Brian
> 
> > --D
> > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
