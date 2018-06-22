Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50074 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbeFVGsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:48:02 -0400
Date: Thu, 21 Jun 2018 23:47:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/8] xfs: don't allow insert-range to shift extents past
 the maximum offset
Message-ID: <20180622064733.GQ4838@magnolia>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960588873.26246.17582272219031862067.stgit@magnolia>
 <20180622063934.GD27254@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180622063934.GD27254@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, zlang@redhat.com

On Thu, Jun 21, 2018 at 11:39:34PM -0700, Christoph Hellwig wrote:
> > +#define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
> 
> Please move this next to BMBT_STARTOFF_BITLEN.
> 
> For brownie points also use this new defined instead of
> XFS_IEXT_STARTOFF_MASK in the extent tree code.

Separate cleanup patch, but ok.

> 
> > +/* Make sure we won't be right-shifting an extent past the maximum bound. */
> > +int
> > +xfs_bmap_can_insert_extents(
> > +	struct xfs_inode	*ip,
> > +	xfs_fileoff_t		off,
> > +	xfs_fileoff_t		shift)
> > +{
> > +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +	struct xfs_bmbt_irec	got;
> > +	struct xfs_iext_cursor	icur;
> > +	xfs_fileoff_t		new_off;
> > +	int			error = 0;
> > +
> > +	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> > +		return -EIO;
> > +
> > +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +
> > +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > +		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> > +		if (error)
> > +			goto out;
> > +	}
> > +
> > +	xfs_iext_last(ifp, &icur);
> > +	if (!xfs_iext_get_extent(ifp, &icur, &got) || off > got.br_startoff)
> > +		goto out;
> 
> This largely duplicates xfs_bmap_last_extent.  The function body could
> probably be written as:
> 
> {
> 	struct xfs_bmbt_irec	got;
> 	int			error = 0;
> 
> 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> 
> 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> 		return -EIO;
> 
> 	xfs_ilock(ip, XFS_ILOCK_EXCL);
> 	error = xfs_bmap_last_extent(NULL, ip, XFS_DATA_FORK, &got,
> 			&is_empty)
> 	if (!error && !is_empty && got.br_startoff >= off &&
> 	    got.br_startoff + shift) & BMBT_STARTOFF_MASK < got.br_startoff)
> 		error = -EINVAL;
> 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 
> 	return error;

I'll give this a test run over night.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
