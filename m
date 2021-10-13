Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04BCC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 23:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DC0F610FE
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 23:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhJMXvG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 19:51:06 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:60639 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229575AbhJMXvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 19:51:06 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id B54D6108D7A;
        Thu, 14 Oct 2021 10:48:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1manzW-005wfR-3L; Thu, 14 Oct 2021 10:48:58 +1100
Date:   Thu, 14 Oct 2021 10:48:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 14/15] xfs: compute absolute maximum nlevels for each
 btree type
Message-ID: <20211013234858.GL2361455@dread.disaster.area>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408163084.4151249.13133029541413030318.stgit@magnolia>
 <20211013075743.GG2361455@dread.disaster.area>
 <20211013213633.GZ24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013213633.GZ24307@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6167706c
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=7-415B0cAAAA:8
        a=rcWMbKoAV3iLCNj4lk0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 02:36:33PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 13, 2021 at 06:57:43PM +1100, Dave Chinner wrote:
> > On Tue, Oct 12, 2021 at 04:33:50PM -0700, Darrick J. Wong wrote:
> > > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > > @@ -582,6 +582,19 @@ xfs_allocbt_maxrecs(
> > >  	return blocklen / (sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
> > >  }
> > >  
> > > +/* Compute the max possible height of the maximally sized free space btree. */
> > > +unsigned int
> > > +xfs_allocbt_absolute_maxlevels(void)
> > > +{
> > > +	unsigned int		minrecs[2];
> > > +
> > > +	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_alloc_rec_t),
> > > +			sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
> > > +
> > > +	return xfs_btree_compute_maxlevels(minrecs,
> > > +			(XFS_MAX_AG_BLOCKS + 1) / 2);
> > > +}
> > 
> > Hmmmm. This is kinds messy. I'd prefer we share code with the
> > xfs_allocbt_maxrecs() function that do this. Not sure "absolute" is
> > the right word, either. It's more a function of the on-disk format
> > maximum, not an "absolute" thing.
> 
> <nod> I'm not passionate about the name one way or the other.
> 
> > I mean, we know that the worst case is going to be for each btree
> > type - we don't need to pass in XFS_BTREE_CRC_BLOCKS or
> > XFS_BTREE_LONG_PTRS to generic code for it to branch multiple times
> > to be generic.
> 
> Yeah, that function was a conditional mess.  I like...
> 
> > Instead:
> > 
> > static inline int
> > xfs_allocbt_block_maxrecs(
> >         int                     blocklen,
> >         int                     leaf)
> > {
> >         if (leaf)
> >                 return blocklen / sizeof(xfs_alloc_rec_t);
> >         return blocklen / (sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
> > }
> > 
> > /*
> >  * Calculate number of records in an alloc btree block.
> >  */
> > int
> > xfs_allocbt_maxrecs(
> >         struct xfs_mount        *mp,
> >         int                     blocklen,
> >         int                     leaf)
> > {
> >         blocklen -= XFS_ALLOC_BLOCK_LEN(mp);
> > 	return xfs_allobt_block_maxrecs(blocklen, leaf);
> > }
> > 
> > xfs_allocbt_maxlevels_ondisk()
> > {
> > 	unsigned int		minrecs[2];
> > 
> > 	minrecs[0] = xfs_allocbt_block_maxrecs(
> > 			XFS_MIN_BLOCKSIZE - XFS_BTREE_SBLOCK_LEN, true) / 2;
> > 	minrecs[1] = xfs_allocbt_block_maxrecs(
> > 			XFS_MIN_BLOCKSIZE - XFS_BTREE_SBLOCK_LEN, false) / 2;
> 
> ...this a lot better since one doesn't have to switch back and forth
> between source files to figure out how the computation works.
> 
> However, I want to propose a possibly pedantic addition to the blocksize
> computation for btrees.  We want to compute the maximum btree height
> that we're ever going to see, which means that we are modeling a btree
> with the minimum possible fanout factor.  That means the smallest btree
> nodes possible, and half full.
> 
> min V5 blocksize: 1024 bytes
> V5 btree short header: 56 bytes
> min V5 btree record area: 968 bytes
> 
> min V4 blocksize: 512 bytes
> V4 btree short header: 16 bytes
> min V4 btree record area: 496 bytes
> 
> In other words, the bit above for the allocbt ought to be:
> 
> 	blocklen = min(XFS_MIN_BLOCKSIZE - XFS_BTREE_SBLOCK_LEN,
> 		       XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_SBLOCK_CRC_LEN);
> 
> Which is very pedantic, since the whole expression /always/ evalulates
> to 496.  IIRC the kernel has enough macro soup to resolve that into a
> constant expression so it shouldn't cost us anything.

Yup, good idea, I'm happy with that - now the code documents the
on-disk format calculation exactly in a single location. :)

> > > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > > @@ -2793,6 +2793,7 @@ xfs_ialloc_setup_geometry(
> > >  	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
> > >  	igeo->inobt_maxlevels = xfs_btree_compute_maxlevels(igeo->inobt_mnr,
> > >  			inodes);
> > > +	ASSERT(igeo->inobt_maxlevels <= xfs_inobt_absolute_maxlevels());
> > >  
> > >  	/*
> > >  	 * Set the maximum inode count for this filesystem, being careful not
> > > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > index 3a5a24648b87..2e3dd1d798bd 100644
> > > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > @@ -542,6 +542,25 @@ xfs_inobt_maxrecs(
> > >  	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
> > >  }
> > >  
> > > +/* Compute the max possible height of the maximally sized inode btree. */
> > > +unsigned int
> > > +xfs_inobt_absolute_maxlevels(void)
> > > +{
> > > +	unsigned int		minrecs[2];
> > > +	unsigned long long	max_ag_inodes;
> > > +
> > > +	/*
> > > +	 * For the absolute maximum, pretend that we can fill an entire AG
> > > +	 * completely full of inodes except for the AG headers.
> > > +	 */
> > > +	max_ag_inodes = (XFS_MAX_AG_BYTES - (4 * BBSIZE)) / XFS_DINODE_MIN_SIZE;
> > > +
> > > +	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_inobt_rec_t),
> > > +			sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
> > > +
> > > +	return xfs_btree_compute_maxlevels(minrecs, max_ag_inodes);
> > > +}
> > 
> > We've got two different inobt max levels on disk. The inobt which has v4
> > limits, whilst the finobt that has v5 limits...
> 
> <nod> I'll make it return the larger of the two heights, though the
> inode btree is always going to win due to its smaller minimum block size.

Yup, I expect so, but it would be good to make it explicit :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
