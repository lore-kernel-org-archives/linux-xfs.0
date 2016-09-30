Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42992 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbcI3HbJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:31:09 -0400
Date: Fri, 30 Sep 2016 00:31:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/63] xfs: map an inode's offset to an exact physical
 block
Message-ID: <20160930073107.GC13587@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520487612.29434.3808077462465308754.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520487612.29434.3808077462465308754.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

> + * For a remap operation, just "allocate" an extent at the address that the
> + * caller passed in, and ensure that the AGFL is the right size.  The caller
> + * will then map the "allocated" extent into the file somewhere.
> + */
> +STATIC int
> +xfs_bmap_remap_alloc(
> +	struct xfs_bmalloca	*ap)
> +{
> +	struct xfs_trans	*tp = ap->tp;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	xfs_agblock_t		bno;
> +	struct xfs_alloc_arg	args;
> +	int			error;
> +
> +	/*
> +	 * validate that the block number is legal - the enables us to detect
> +	 * and handle a silent filesystem corruption rather than crashing.
> +	 */
> +	memset(&args, 0, sizeof(struct xfs_alloc_arg));
> +	args.tp = ap->tp;
> +	args.mp = ap->tp->t_mountp;
> +	bno = *ap->firstblock;
> +	args.agno = XFS_FSB_TO_AGNO(mp, bno);
> +	ASSERT(args.agno < mp->m_sb.sb_agcount);
> +	args.agbno = XFS_FSB_TO_AGBNO(mp, bno);
> +	ASSERT(args.agbno < mp->m_sb.sb_agblocks);

Shouldn't this return -EFSCORRUPED instead?  Otherwise the comment
above isn't really true.

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
