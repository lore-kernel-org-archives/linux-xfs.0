Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37766 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750904AbdK1W0k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 17:26:40 -0500
Date: Wed, 29 Nov 2017 09:26:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 4/4] xfs: include an allocfree res for inobt
 modifications
Message-ID: <20171128222637.GG5858@dastard>
References: <20171127202434.43125-1-bfoster@redhat.com>
 <20171127202434.43125-5-bfoster@redhat.com>
 <20171127232719.GC5858@dastard>
 <20171128140459.GD45759@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128140459.GD45759@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 09:04:59AM -0500, Brian Foster wrote:
> On Tue, Nov 28, 2017 at 10:27:19AM +1100, Dave Chinner wrote:
> > On Mon, Nov 27, 2017 at 03:24:34PM -0500, Brian Foster wrote:
> > >  STATIC uint
> > > @@ -415,8 +414,8 @@ __xfs_calc_create_reservation(
> > >   * For icreate we can allocate some inodes giving:
> > >   *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
> > >   *    the superblock for the nlink flag: sector size
> > > - *    the inode btree: max depth * blocksize
> > >   *    the allocation btrees: 2 trees * (max depth - 1) * block size
> > > + *    the inobt (record insertion)
> > >   *    the finobt (record insertion)
> > >   */
> > >  STATIC uint
> > > @@ -425,10 +424,10 @@ xfs_calc_icreate_resv_alloc(
> > >  {
> > >  	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
> > >  		mp->m_sb.sb_sectsize +
> > > -		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
> > >  		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> > >  				 XFS_FSB_TO_B(mp, 1)) +
> > > -		xfs_calc_finobt_res(mp, 0, 0);
> > > +		xfs_calc_inobt_res(mp) +
> > > +		xfs_calc_finobt_res(mp);
> > >  }
> > 
> > 	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
> > 		mp->m_sb.sb_sectsize +
> > 		xfs_calc_inode_chunk_res(mp, false) +
> > 		xfs_calc_inobt_res(mp) +
> > 		xfs_calc_finobt_res(mp);
> > 
> 
> The icreate reservation doesn't currently include m_ialloc_blks at all.
> The helper, as defined above, adds a reservation for associated headers.
> Is that really necessary?  My understanding is that icreate doesn't log
> the inode chunk.

Right, it uses ordered buffers to avoid needing to log them.

> I suppose we could get around that by tweaking the
> parameter to take the size to reserve instead of a bool and pass a dummy
> value (i.e., negative) to avoid logging the chunk at all. A little ugly,
> but I could live with it.

I don't think that having an extra few hundred bytes of overhead in
the reservation is going to be noticable by anyone. I'd just
ignore the problem (as I did when suggesting this).

> > >  STATIC uint
> > > @@ -494,9 +493,14 @@ xfs_calc_symlink_reservation(
> > >   *    the agi hash list and counters: sector size
> > >   *    the on disk inode before ours in the agi hash list: inode cluster size
> > >   *    the inode chunk is marked stale (headers only)
> > > - *    the inode btree: max depth * blocksize
> > > - *    the allocation btrees: 2 trees * (max depth - 1) * block size
> > > + *    the inode btree
> > >   *    the finobt (record insertion, removal or modification)
> > > + *
> > > + * Note that the allocfree res. for the inode chunk itself is not included
> > > + * because the extent free occurs after a transaction roll. We could take the
> > > + * maximum of the pre/post roll operations, but the pre-roll reservation already
> > > + * includes at least one allocfree res. for the inobt and is thus guaranteed to
> > > + * be larger.
> > >   */
> > >  STATIC uint
> > >  xfs_calc_ifree_reservation(
> > > @@ -508,10 +512,8 @@ xfs_calc_ifree_reservation(
> > >  		xfs_calc_iunlink_remove_reservation(mp) +
> > >  		xfs_calc_buf_res(1, 0) +
> > >  		xfs_calc_buf_res(mp->m_ialloc_blks, 0) +
> > > -		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
> > > -		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> > > -				 XFS_FSB_TO_B(mp, 1)) +
> > > -		xfs_calc_finobt_res(mp, 0, 1);
> > > +		xfs_calc_inobt_res(mp) +
> > > +		xfs_calc_finobt_res(mp);
> > >  }
> > 
> > 	.....
> > 		xfs_calc_iunlink_remove_reservation(mp) +
> > 		xfs_calc_buf_res(1, 0) +
> > 		xfs_calc_inode_chunk_res(mp, false) +
> > 		xfs_calc_inobt_res(mp) +
> > 		xfs_calc_finobt_res(mp);
> > 
> 
> This covers the inode chunk invalidation, but also adds the allocfree
> res. for the chunk free where we technically don't need it (because the
> free is deferred, re: the comment above).
> 
> I guess I'm fine with just adding that one, but I'd update the comment
> above to point out that it's technically unecessary. Hm?

*nod*

Though with sparse inodes, we might be freeing multiple extents,
right?  which means we probably need all the allocfree reservations
we can get....

> > This seems to make more sense to me - it's clear what the individual
> > components of the reservation are, and we can ensure that the
> > individual components have the necessary reservation independently
> > of the overall reservations that need them.
> > 
> 
> I agree in principle. I think the underlying helpers (and pushing down
> some of the associated documentation) help clearly declare the intent of
> the reservations, particularly when we include multiple factors of a
> single reservation and/or have situations where we don't technically
> have a definition of worst case, but want to define something logically
> reasonable (like the whole allocfree per inode tree thing).

Yup, that's pretty much what I was thinking.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
