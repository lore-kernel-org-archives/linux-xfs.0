Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:16473 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751658AbdK1Wfo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 17:35:44 -0500
Date: Wed, 29 Nov 2017 09:34:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 4/4] xfs: include an allocfree res for inobt
 modifications
Message-ID: <20171128223445.GH5858@dastard>
References: <20171127202434.43125-1-bfoster@redhat.com>
 <20171127202434.43125-5-bfoster@redhat.com>
 <20171127232719.GC5858@dastard>
 <20171128154922.GE45759@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128154922.GE45759@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 10:49:22AM -0500, Brian Foster wrote:
> On Tue, Nov 28, 2017 at 10:27:19AM +1100, Dave Chinner wrote:
> > On Mon, Nov 27, 2017 at 03:24:34PM -0500, Brian Foster wrote:
> > > Analysis of recent reports of log reservation overruns and code
> > > inspection has uncovered that the reservations associated with inode
> > > operations may not cover the worst case scenarios. In particular,
> > > many cases only include one allocfree res. for a particular
> > > operation even though said operations may also entail AGFL fixups
> > > and inode btree block allocations in addition to the actual inode
> > > chunk allocation. This can easily turn into two or three block
> > > allocations (or frees) per operation.
> > > 
> > > In theory, the only way to define the worst case reservation is to
> > > include an allocfree res for each individual allocation in a
> > > transaction. Since that is impractical (we can perform multiple agfl
> > > fixups per tx and not every allocation is going to result in a full
> > > tree operation), implement a reasonable compromise that addresses
> > > the deficiency in practice without blowing out the size of the
> > > transactions.
> > > 
> > > Refactor the inode transaction reservation code to include one
> > > allocfree res. per inode btree modification to cover allocations
> > > required by the tree itself. This essentially separates the
> > > reservation required to allocate the physical inode chunk from
> > > additional reservation required to perform inobt record
> > > insertion/removal.
> > 
> > I think you missed the most important reason the inobt/finobt
> > modifications need there own allocfree reservation - btree
> > modifications that cause btree blocks to be freed do not use defered
> > ops and so the freeing of blocks occurs directly within the primary
> > transaction. Hence the primary transaction reservation must take
> > this into account ....
> > 
> > > Apply the same logic to the finobt reservation.
> > > This results in killing off the finobt modify condition because we
> > > no longer assume that the broader transaction reservation will cover
> > > finobt block allocations.
> > > 
> > > Suggested-by: Dave Chinner <david@fromorbit.com>
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > 
> > Code looks fine. Comments below are for another follow-on patch.
> > 
> 
> Actually, what do you think of the following variant (compile tested
> only)? This facilites another cleanup patch I just wrote to kill off
> about half of the (now effectively duplicate) xfs_calc_create_*()
> helpers because the finobt and inode chunk res. helpers only include the
> associated reservation based on the associated feature bits.

Yup, makes a lot of sense to do that.

FWIW, because we've got so many alloc vs free type reservations,
would it make more sense to do something like:

#define _ALLOC	true
#define _FREE	false

And use those in the callers rather than true/false?

i.e. this code remains the same in that it takes an "bool alloc"
flag as a parameter:

> +STATIC uint
> +xfs_calc_inode_chunk_res(
> +	struct xfs_mount	*mp,
> +	bool			alloc)
> +{
> +	uint			res, size = 0;
> +
> +	res = xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> +			       XFS_FSB_TO_B(mp, 1));
> +	if (alloc) {
> +		/* icreate tx uses ordered buffers */
> +		if (xfs_sb_version_hascrc(&mp->m_sb))
> +			return res;
> +		size = XFS_FSB_TO_B(mp, 1);
> +	}
> +
> +	res += xfs_calc_buf_res(mp->m_ialloc_blks, size);
> +	return res;
> +}

but makes the callers  look like:

>  STATIC uint
> @@ -396,9 +430,7 @@ xfs_calc_create_resv_alloc(
>  {
>  	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
>  		mp->m_sb.sb_sectsize +
> -		xfs_calc_buf_res(mp->m_ialloc_blks, XFS_FSB_TO_B(mp, 1)) +
> -		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> -				 XFS_FSB_TO_B(mp, 1)) +
> +		xfs_calc_inode_chunk_res(mp, true) +

		xfs_calc_inode_chunk_res(mp, _ALLOC) +
		.....

and

> @@ -511,7 +542,7 @@ xfs_calc_ifree_reservation(
>  		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
>  		xfs_calc_iunlink_remove_reservation(mp) +
>  		xfs_calc_buf_res(1, 0) +
> -		xfs_calc_buf_res(mp->m_ialloc_blks, 0) +
> +		xfs_calc_inode_chunk_res(mp, false) +

		xfs_calc_inode_chunk_res(mp, _FREE) +
		.....

That would make it very clear what type of reservation we are
acutally expecting to take out in the calculation. i.e. the code
is now clearly self documenting :)

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
