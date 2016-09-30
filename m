Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34227 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932348AbcI3RbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 13:31:03 -0400
Date: Fri, 30 Sep 2016 10:30:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 21/63] xfs: map an inode's offset to an exact physical
 block
Message-ID: <20160930173034.GM14092@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520487612.29434.3808077462465308754.stgit@birch.djwong.org>
 <20160930073107.GC13587@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160930073107.GC13587@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Sep 30, 2016 at 12:31:07AM -0700, Christoph Hellwig wrote:
> > + * For a remap operation, just "allocate" an extent at the address that the
> > + * caller passed in, and ensure that the AGFL is the right size.  The caller
> > + * will then map the "allocated" extent into the file somewhere.
> > + */
> > +STATIC int
> > +xfs_bmap_remap_alloc(
> > +	struct xfs_bmalloca	*ap)
> > +{
> > +	struct xfs_trans	*tp = ap->tp;
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	xfs_agblock_t		bno;
> > +	struct xfs_alloc_arg	args;
> > +	int			error;
> > +
> > +	/*
> > +	 * validate that the block number is legal - the enables us to detect
> > +	 * and handle a silent filesystem corruption rather than crashing.
> > +	 */
> > +	memset(&args, 0, sizeof(struct xfs_alloc_arg));
> > +	args.tp = ap->tp;
> > +	args.mp = ap->tp->t_mountp;
> > +	bno = *ap->firstblock;
> > +	args.agno = XFS_FSB_TO_AGNO(mp, bno);
> > +	ASSERT(args.agno < mp->m_sb.sb_agcount);
> > +	args.agbno = XFS_FSB_TO_AGBNO(mp, bno);
> > +	ASSERT(args.agbno < mp->m_sb.sb_agblocks);
> 
> Shouldn't this return -EFSCORRUPED instead?  Otherwise the comment
> above isn't really true.

Hmm, yes.  I'll fix that up.

--D

> 
> Otherwise this looks fine to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
