Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35312 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968285AbdD0Q4y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 12:56:54 -0400
Date: Thu, 27 Apr 2017 09:56:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] xfs: reserve enough blocks to handle btree splits
 when remapping
Message-ID: <20170427165622.GG23371@birch.djwong.org>
References: <20170425015837.GS23371@birch.djwong.org>
 <20170427072303.GA29468@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170427072303.GA29468@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

On Thu, Apr 27, 2017 at 12:23:03AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 24, 2017 at 06:58:37PM -0700, Darrick J. Wong wrote:
> > In xfs_reflink_end_cow, we erroneously reserve only enough blocks to
> > handle adding 1 extent.  This is problematic if we fragment free space,
> > have to do CoW, and then have to perform multiple bmap btree expansions.
> > Furthermore, the BUI recovery routine doesn't reserve /any/ blocks to
> > handle btree splits, so log recovery fails after our first error causes
> > the filesystem to go down.
> > 
> > Therefore, refactor the transaction block reservation macros until we
> > have a macro that works for our deferred (re)mapping activities, and fix
> > both problems by using that macro.
> > 
> > With 1k blocks we can hit this fairly often in g/187 if the scratch fs
> > is big enough.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v3: don't use the swap-extents-with-rmap block reservation for cow
> > remapping; we should already have sufficient per-ag reservation
> > v2: avoid 64-bit division when calculating block reservation
> > ---
> >  fs/xfs/libxfs/xfs_trans_space.h |   13 +++++++------
> >  fs/xfs/xfs_bmap_item.c          |    7 ++++++-
> >  fs/xfs/xfs_reflink.c            |   12 ++++++++++--
> >  3 files changed, 23 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> > index 7917f6e..0044e14 100644
> > --- a/fs/xfs/libxfs/xfs_trans_space.h
> > +++ b/fs/xfs/libxfs/xfs_trans_space.h
> > @@ -23,6 +23,11 @@
> >   */
> >  #define XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)    \
> >  		(((mp)->m_rmap_mxr[0]) - ((mp)->m_rmap_mnr[0]))
> > +#define XFS_RMAPADD_SPACE_RES(mp) ((mp)->m_rmap_maxlevels)
> > +#define XFS_NRMAPADD_SPACE_RES(mp,b,w)\
> > +	(((b + XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp) - 1) / \
> > +	  XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) * \
> > +	  XFS_RMAPADD_SPACE_RES(mp))
> 
> Comments, please!  (I know the existing defintions don't have any,
> but that's bad enough to start with..)

Ok.

> >  	xfs_fsblock_t			firstfsb;
> > +	unsigned int			resblks;
> >  
> >  	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
> >  
> > @@ -447,7 +450,9 @@ xfs_bui_recover(
> >  		return -EIO;
> >  	}
> >  
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> > +	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks, 0,
> > +			0, &tp);
> 
> Do we really need that resblks variable?

No.

> >  	if (error)
> >  		return error;
> >  	budp = xfs_trans_get_bud(tp, buip);
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index c0f3754..aab156a 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -705,8 +705,16 @@ xfs_reflink_end_cow(
> >  	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
> >  	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
> >  
> > -	/* Start a rolling transaction to switch the mappings */
> > -	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> > +	/*
> > +	 * Start a rolling transaction to switch the mappings.  We're
> > +	 * unlikely ever to have to remap 16T worth of single-block
> > +	 * extents, so just cap the worst case extent count to 2^32-1.
> > +	 * Stick a warning in just in case, and avoid 64-bit division.
> > +	 */
> > +	WARN_ON(end_fsb - offset_fsb + 1 > UINT_MAX);
> > +	resblks = min_t(xfs_fileoff_t, UINT_MAX, end_fsb - offset_fsb + 1);
> 
> I don't like unlikely statements.  What prevents us from doing so?
> I think the way Linux limits writes to 32-bits using MAX_RW_COUNT
> does, but then the language should be more assertive here.  I think
> we should also shut down the fs here if the assert fails - otherwise
> we'll leave a partially converted region around.

In the long run, I should just rewrite this to loop around if we are
asked to do too much at once.

> A BUILD_BUG_ON on MAX_RW_COUNT might also be useful to make the whole
> scheme even safer.

Yeah, we could do that too.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
