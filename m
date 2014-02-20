Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BBF4E800C
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 19:01:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 532F9AC003
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 17:01:01 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9M7wWXKb4nvFtEDM for <xfs@oss.sgi.com>;
	Wed, 19 Feb 2014 17:00:58 -0800 (PST)
Date: Thu, 20 Feb 2014 12:00:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 04/11] xfs: update inode allocation/free transaction
	reservations for finobt
Message-ID: <20140220010055.GK4916@dastard>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-5-git-send-email-bfoster@redhat.com>
	<20140211064609.GE13647@dastard> <52FA4E61.9040908@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FA4E61.9040908@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 11, 2014 at 11:22:57AM -0500, Brian Foster wrote:
> On 02/11/2014 01:46 AM, Dave Chinner wrote:
> > On Tue, Feb 04, 2014 at 12:49:35PM -0500, Brian Foster wrote:
> >> Create the xfs_calc_finobt_res() helper to calculate the finobt log
> >> reservation for inode allocation and free. Update
> >> XFS_IALLOC_SPACE_RES() to reserve blocks for the additional finobt
> >> insertion on inode allocation. Create XFS_IFREE_SPACE_RES() to
> >> reserve blocks for the potential finobt record insertion on inode
> >> free (i.e., if an inode chunk was previously fully allocated).
....
> >> + *
> >> + * the free inode btree: max depth * block size
> >> + * the free inode btree entry: block size
> >> + *
> >> + * TODO: is the modify res really necessary? covered by the merge/split res?
> >> + * This seems to be the pattern of ifree, but not create_resv_alloc. Why?
> > 
> > The modify case is for an allocation that only updates an inobt
> > record (i.e. chunk already allocated, free inodes in it). Because
> > we can remove a finobt record when "modifying" the last free inode
> > record in a chunk, "modify" can cause a redcord removal and hence a
> > tree merge. In which case it's no different of any of the other
> > finobt reservations....
> 
> When I made this note, I think I was curious why there was a need to add
> to the reservation in the modify case. If we always made a reservation
> for a btree merge, wouldn't that be enough to cover the basic modify
> case?

The two cases are kept separate because if we ever separate inode
chunk allocation from individual inode allocation from an allocated
chunk, then we need the different reservations. if you go back to
the original RFD series that documented the finobt, it also
discusses this separation and the optimisations in inode management
that such a separation brings.

Hence we should not assume that an inode chunk allocation
reservation covers the reservation of an inode allocation from an
allocated chunk.

> In the code, it looks like we either delete the record or modify
> it. Is there something in the delete case that I'm missing, or are we
> just being conservative here? Nonetheless, I modelled this after the
> ifree requirements, assuming the reservation there was correct.

But  the ifree requirement changed, didn't they? i.e. Because the
first inode freed in a chunk can now trigger allocation.

Basically, we have these cases:

Allocation:

	- allocate chunk, insert inobt rec, insert finobt rec
	- allocate inode, modify inobt rec, modify finobt rec
	- allocate inode, modify inobt rec, remove finobt rec

The first case is obvious in that it needs to allocate blocks
for the inode chunk, but also possibly the inbot and finobt need
allocations too (split).

The second case obvious doesn't allocate any blocks at all,
and tha tis the existing "modify reservation"

The third case is the new "modify reservation" case, where the
removal of a finobt record can cause a merge and hence freeing of a
block. That's the case we need to make sure we have the corerct
reservation for.

In the case of ifree, it is similar:

	- free inode, modify inobt rec, insert finobt rec
	- free inode, modify inobt rec, modify finobt rec
	- free chunk, remove inobt rec, remove finobt rec

And so it is clear that the same new case occurs here. however, the
ifree transaction reservation is not split up like the create
transaction, so it already takes into account allocation/freeing of
blocks and hence didn't need updating.

> >> @@ -267,6 +298,7 @@ xfs_calc_remove_reservation(
> >>   *    the superblock for the nlink flag: sector size
> >>   *    the directory btree: (max depth + v2) * dir block size
> >>   *    the directory inode's bmap btree: (max depth + v2) * block size
> >> + *    the finobt
> >>   */
> >>  STATIC uint
> >>  xfs_calc_create_resv_modify(
> >> @@ -275,7 +307,8 @@ xfs_calc_create_resv_modify(
> >>  	return xfs_calc_inode_res(mp, 2) +
> >>  		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> >>  		(uint)XFS_FSB_TO_B(mp, 1) +
> >> -		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
> >> +		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1)) +
> >> +		xfs_calc_finobt_res(mp, 1);
> >>  }
> > 
> > And this is where is starts to get complex. The modify operation can
> > now cause a finobt merge, when means blocks will be allocated/freed.
> > That means we now need to take into account:
> > 
> >  *    the allocation btrees: 2 trees * (max depth - 1) * block size
> > 
> > and anything else freeing an extent requires.
> > 
> 
> So is the "allocation btrees: 2 trees ..." portion of
> xfs_calc_create_resv_alloc() associated with the allocation of the
> actual inode blocks or potential allocations due to inode btree
> management? I had thought the former, thus didn't include reservations
> for this in the finobt calculation.

This is the log space reservation - so it's a reservation for the
number of blocks in the btree that can be *modified* by the
transaction. So if we have to allocate a block, we can potentially
modify leaf-to-root in both free space trees if they both split or
merge during the allocation. Hence any transaction that can allocate
or free a block needs to reservae this space in the log for the
freespace tree modifications.

We have a separate space reservation - as defined in
xfs_trans_space.h - which is used to define the worst case metadata
block allocation in a given transaction. It is assumed that the log
space reservation covers all those blocks being modified, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
