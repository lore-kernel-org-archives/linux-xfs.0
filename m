Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752394AbdK1OFA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Nov 2017 09:05:00 -0500
Date: Tue, 28 Nov 2017 09:04:59 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 4/4] xfs: include an allocfree res for inobt
 modifications
Message-ID: <20171128140459.GD45759@bfoster.bfoster>
References: <20171127202434.43125-1-bfoster@redhat.com>
 <20171127202434.43125-5-bfoster@redhat.com>
 <20171127232719.GC5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127232719.GC5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 10:27:19AM +1100, Dave Chinner wrote:
> On Mon, Nov 27, 2017 at 03:24:34PM -0500, Brian Foster wrote:
> > Analysis of recent reports of log reservation overruns and code
> > inspection has uncovered that the reservations associated with inode
> > operations may not cover the worst case scenarios. In particular,
> > many cases only include one allocfree res. for a particular
> > operation even though said operations may also entail AGFL fixups
> > and inode btree block allocations in addition to the actual inode
> > chunk allocation. This can easily turn into two or three block
> > allocations (or frees) per operation.
> > 
> > In theory, the only way to define the worst case reservation is to
> > include an allocfree res for each individual allocation in a
> > transaction. Since that is impractical (we can perform multiple agfl
> > fixups per tx and not every allocation is going to result in a full
> > tree operation), implement a reasonable compromise that addresses
> > the deficiency in practice without blowing out the size of the
> > transactions.
> > 
> > Refactor the inode transaction reservation code to include one
> > allocfree res. per inode btree modification to cover allocations
> > required by the tree itself. This essentially separates the
> > reservation required to allocate the physical inode chunk from
> > additional reservation required to perform inobt record
> > insertion/removal.
> 
> I think you missed the most important reason the inobt/finobt
> modifications need there own allocfree reservation - btree
> modifications that cause btree blocks to be freed do not use defered
> ops and so the freeing of blocks occurs directly within the primary
> transaction. Hence the primary transaction reservation must take
> this into account ....
> 

Sort of implied by "to cover allocations by the tree itself," but I'll
update the commit log to be more explicit.

> > Apply the same logic to the finobt reservation.
> > This results in killing off the finobt modify condition because we
> > no longer assume that the broader transaction reservation will cover
> > finobt block allocations.
> > 
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Code looks fine. Comments below are for another follow-on patch.
> 

Ok..

> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > @@ -387,8 +386,8 @@ xfs_calc_create_resv_modify(
> >   *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
> >   *    the superblock for the nlink flag: sector size
> >   *    the inode blocks allocated: mp->m_ialloc_blks * blocksize
> > - *    the inode btree: max depth * blocksize
> >   *    the allocation btrees: 2 trees * (max depth - 1) * block size
> > + *    the inode btree (record insertion)
> >   */
> >  STATIC uint
> >  xfs_calc_create_resv_alloc(
> > @@ -397,9 +396,9 @@ xfs_calc_create_resv_alloc(
> >  	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
> >  		mp->m_sb.sb_sectsize +
> >  		xfs_calc_buf_res(mp->m_ialloc_blks, XFS_FSB_TO_B(mp, 1)) +
> > -		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
> >  		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> > -				 XFS_FSB_TO_B(mp, 1));
> > +				 XFS_FSB_TO_B(mp, 1)) +
> > +		xfs_calc_inobt_res(mp);
> >  }
> 
> Looking at this,  I'm wondering if there should also be a function
> for calculating the inode chunk reservation. Something like:
> 
> static uint
> xfs_calc_inode_chunk_res(
> 	struct xfs-mount	*mp,
> 	bool			chunk_contents_logged)
> {
> 	uint	res;
> 
> 	if (chunk_contents_logged) {
> 		res = xfs_calc_buf_res(mp->m_ialloc_blks,
> 					XFS_FSB_TO_B(mp, 1));
> 	} else {
> 		/* take into account logged headers for freeing */
> 		res = xfs_calc_buf_res(mp->m_ialloc_blks, 0);
> 	}
> 
> 	res += xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> 				XFS_FSB_TO_B(mp, 1));
> 	return res;
> }
> 
> Then xfs_calc_create_resv_alloc() reads like:
> 
> 	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
> 		mp->m_sb.sb_sectsize + 
> 		xfs_calc_inode_chunk_res(mp, true) +
> 		xfs_calc_inobt_res(mp);
> 

Looks reasonable.

> 
> >  
> >  STATIC uint
> > @@ -415,8 +414,8 @@ __xfs_calc_create_reservation(
> >   * For icreate we can allocate some inodes giving:
> >   *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
> >   *    the superblock for the nlink flag: sector size
> > - *    the inode btree: max depth * blocksize
> >   *    the allocation btrees: 2 trees * (max depth - 1) * block size
> > + *    the inobt (record insertion)
> >   *    the finobt (record insertion)
> >   */
> >  STATIC uint
> > @@ -425,10 +424,10 @@ xfs_calc_icreate_resv_alloc(
> >  {
> >  	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
> >  		mp->m_sb.sb_sectsize +
> > -		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
> >  		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> >  				 XFS_FSB_TO_B(mp, 1)) +
> > -		xfs_calc_finobt_res(mp, 0, 0);
> > +		xfs_calc_inobt_res(mp) +
> > +		xfs_calc_finobt_res(mp);
> >  }
> 
> 	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
> 		mp->m_sb.sb_sectsize +
> 		xfs_calc_inode_chunk_res(mp, false) +
> 		xfs_calc_inobt_res(mp) +
> 		xfs_calc_finobt_res(mp);
> 

The icreate reservation doesn't currently include m_ialloc_blks at all.
The helper, as defined above, adds a reservation for associated headers.
Is that really necessary?  My understanding is that icreate doesn't log
the inode chunk. I suppose we could get around that by tweaking the
parameter to take the size to reserve instead of a bool and pass a dummy
value (i.e., negative) to avoid logging the chunk at all. A little ugly,
but I could live with it.

> >  
> >  STATIC uint
> > @@ -494,9 +493,14 @@ xfs_calc_symlink_reservation(
> >   *    the agi hash list and counters: sector size
> >   *    the on disk inode before ours in the agi hash list: inode cluster size
> >   *    the inode chunk is marked stale (headers only)
> > - *    the inode btree: max depth * blocksize
> > - *    the allocation btrees: 2 trees * (max depth - 1) * block size
> > + *    the inode btree
> >   *    the finobt (record insertion, removal or modification)
> > + *
> > + * Note that the allocfree res. for the inode chunk itself is not included
> > + * because the extent free occurs after a transaction roll. We could take the
> > + * maximum of the pre/post roll operations, but the pre-roll reservation already
> > + * includes at least one allocfree res. for the inobt and is thus guaranteed to
> > + * be larger.
> >   */
> >  STATIC uint
> >  xfs_calc_ifree_reservation(
> > @@ -508,10 +512,8 @@ xfs_calc_ifree_reservation(
> >  		xfs_calc_iunlink_remove_reservation(mp) +
> >  		xfs_calc_buf_res(1, 0) +
> >  		xfs_calc_buf_res(mp->m_ialloc_blks, 0) +
> > -		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
> > -		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> > -				 XFS_FSB_TO_B(mp, 1)) +
> > -		xfs_calc_finobt_res(mp, 0, 1);
> > +		xfs_calc_inobt_res(mp) +
> > +		xfs_calc_finobt_res(mp);
> >  }
> 
> 	.....
> 		xfs_calc_iunlink_remove_reservation(mp) +
> 		xfs_calc_buf_res(1, 0) +
> 		xfs_calc_inode_chunk_res(mp, false) +
> 		xfs_calc_inobt_res(mp) +
> 		xfs_calc_finobt_res(mp);
> 

This covers the inode chunk invalidation, but also adds the allocfree
res. for the chunk free where we technically don't need it (because the
free is deferred, re: the comment above).

I guess I'm fine with just adding that one, but I'd update the comment
above to point out that it's technically unecessary. Hm?

> This seems to make more sense to me - it's clear what the individual
> components of the reservation are, and we can ensure that the
> individual components have the necessary reservation independently
> of the overall reservations that need them.
> 

I agree in principle. I think the underlying helpers (and pushing down
some of the associated documentation) help clearly declare the intent of
the reservations, particularly when we include multiple factors of a
single reservation and/or have situations where we don't technically
have a definition of worst case, but want to define something logically
reasonable (like the whole allocfree per inode tree thing).

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
