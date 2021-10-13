Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D185BC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 21:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B29EF6117A
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 21:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhJMVii (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 17:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229706AbhJMVii (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Oct 2021 17:38:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BF2E60FDA;
        Wed, 13 Oct 2021 21:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634160994;
        bh=gdPP3S/c08OUcBM3uNGymeJky6v7aLHjowvaTJMnKrU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pn5GpUIBBLyaBJDf2DxcJOKDAfxn6yn4wYRVHM8PkWLEGAeLewkC/dz9AQI88OsHn
         vPm1+oqTPdiSy0ydtxyrLICCvit+y1Dkc2HokLx3ote7Vc9F/0/kvfqVcd3ZGiDZuO
         XoPK7Utbm8xkp/pEwBfxqJzRJucN4Od6Fqej1LJrTiXuZ26oVfW0LWzGv67AZdAIgs
         OQXGJu2gdbv9Tlu7mgixILmbD6+o6qI3xBL9prEDE+LZ9Db5Q/T6vTM416ZsrFlJW8
         VX8tTnUunk86YsewFUxMtkmrmvTmgLly7qRG8GufsOpUKK2/HgTNCOwOPKFwwkS6PP
         QEya14ahs1NFQ==
Date:   Wed, 13 Oct 2021 14:36:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 14/15] xfs: compute absolute maximum nlevels for each
 btree type
Message-ID: <20211013213633.GZ24307@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408163084.4151249.13133029541413030318.stgit@magnolia>
 <20211013075743.GG2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013075743.GG2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 06:57:43PM +1100, Dave Chinner wrote:
> On Tue, Oct 12, 2021 at 04:33:50PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add code for all five btree types so that we can compute the absolute
> > maximum possible btree height for each btree type.  This is a setup for
> > the next patch, which makes every btree type have its own cursor cache.
> > 
> > The functions are exported so that we can have xfs_db report the
> > absolute maximum btree heights for each btree type, rather than making
> > everyone run their own ad-hoc computations.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c          |    1 +
> >  fs/xfs/libxfs/xfs_alloc_btree.c    |   13 +++++++++++
> >  fs/xfs/libxfs/xfs_alloc_btree.h    |    2 ++
> >  fs/xfs/libxfs/xfs_bmap.c           |    1 +
> >  fs/xfs/libxfs/xfs_bmap_btree.c     |   14 ++++++++++++
> >  fs/xfs/libxfs/xfs_bmap_btree.h     |    2 ++
> >  fs/xfs/libxfs/xfs_btree.c          |   41 ++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_btree.h          |    3 +++
> >  fs/xfs/libxfs/xfs_fs.h             |    2 ++
> >  fs/xfs/libxfs/xfs_ialloc.c         |    1 +
> >  fs/xfs/libxfs/xfs_ialloc_btree.c   |   19 +++++++++++++++++
> >  fs/xfs/libxfs/xfs_ialloc_btree.h   |    2 ++
> >  fs/xfs/libxfs/xfs_refcount_btree.c |   20 ++++++++++++++++++
> >  fs/xfs/libxfs/xfs_refcount_btree.h |    2 ++
> >  fs/xfs/libxfs/xfs_rmap_btree.c     |   27 ++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_rmap_btree.h     |    2 ++
> >  16 files changed, 152 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 55c5adc9b54e..7145416a230c 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2198,6 +2198,7 @@ xfs_alloc_compute_maxlevels(
> >  {
> >  	mp->m_ag_maxlevels = xfs_btree_compute_maxlevels(mp->m_alloc_mnr,
> >  			(mp->m_sb.sb_agblocks + 1) / 2);
> > +	ASSERT(mp->m_ag_maxlevels <= xfs_allocbt_absolute_maxlevels());
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > index f14bad21503f..61f6d266b822 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > @@ -582,6 +582,19 @@ xfs_allocbt_maxrecs(
> >  	return blocklen / (sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
> >  }
> >  
> > +/* Compute the max possible height of the maximally sized free space btree. */
> > +unsigned int
> > +xfs_allocbt_absolute_maxlevels(void)
> > +{
> > +	unsigned int		minrecs[2];
> > +
> > +	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_alloc_rec_t),
> > +			sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
> > +
> > +	return xfs_btree_compute_maxlevels(minrecs,
> > +			(XFS_MAX_AG_BLOCKS + 1) / 2);
> > +}
> 
> Hmmmm. This is kinds messy. I'd prefer we share code with the
> xfs_allocbt_maxrecs() function that do this. Not sure "absolute" is
> the right word, either. It's more a function of the on-disk format
> maximum, not an "absolute" thing.

<nod> I'm not passionate about the name one way or the other.

> I mean, we know that the worst case is going to be for each btree
> type - we don't need to pass in XFS_BTREE_CRC_BLOCKS or
> XFS_BTREE_LONG_PTRS to generic code for it to branch multiple times
> to be generic.

Yeah, that function was a conditional mess.  I like...

> Instead:
> 
> static inline int
> xfs_allocbt_block_maxrecs(
>         int                     blocklen,
>         int                     leaf)
> {
>         if (leaf)
>                 return blocklen / sizeof(xfs_alloc_rec_t);
>         return blocklen / (sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
> }
> 
> /*
>  * Calculate number of records in an alloc btree block.
>  */
> int
> xfs_allocbt_maxrecs(
>         struct xfs_mount        *mp,
>         int                     blocklen,
>         int                     leaf)
> {
>         blocklen -= XFS_ALLOC_BLOCK_LEN(mp);
> 	return xfs_allobt_block_maxrecs(blocklen, leaf);
> }
> 
> xfs_allocbt_maxlevels_ondisk()
> {
> 	unsigned int		minrecs[2];
> 
> 	minrecs[0] = xfs_allocbt_block_maxrecs(
> 			XFS_MIN_BLOCKSIZE - XFS_BTREE_SBLOCK_LEN, true) / 2;
> 	minrecs[1] = xfs_allocbt_block_maxrecs(
> 			XFS_MIN_BLOCKSIZE - XFS_BTREE_SBLOCK_LEN, false) / 2;

...this a lot better since one doesn't have to switch back and forth
between source files to figure out how the computation works.

However, I want to propose a possibly pedantic addition to the blocksize
computation for btrees.  We want to compute the maximum btree height
that we're ever going to see, which means that we are modeling a btree
with the minimum possible fanout factor.  That means the smallest btree
nodes possible, and half full.

min V5 blocksize: 1024 bytes
V5 btree short header: 56 bytes
min V5 btree record area: 968 bytes

min V4 blocksize: 512 bytes
V4 btree short header: 16 bytes
min V4 btree record area: 496 bytes

In other words, the bit above for the allocbt ought to be:

	blocklen = min(XFS_MIN_BLOCKSIZE - XFS_BTREE_SBLOCK_LEN,
		       XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_SBLOCK_CRC_LEN);

Which is very pedantic, since the whole expression /always/ evalulates
to 496.  IIRC the kernel has enough macro soup to resolve that into a
constant expression so it shouldn't cost us anything.

> 
> 	return xfs_btree_compute_maxlevels(minrecs,
> 			(XFS_MAX_AG_BLOCKS + 1) / 2);
> }
> 
> All the other btree implementations factor this way, too, allowing
> the minrec values to be calculated clearly and directly in the
> specific btree function...

Yeah, that's a lot clearer.  I'll migrate all the btree types towards
that.

> > +
> >  /* Calculate the freespace btree size for some records. */
> >  xfs_extlen_t
> >  xfs_allocbt_calc_size(
> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
> > index 2f6b816aaf9f..c47d0e285435 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.h
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.h
> > @@ -60,4 +60,6 @@ extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
> >  void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
> >  		struct xfs_trans *tp, struct xfs_buf *agbp);
> >  
> > +unsigned int xfs_allocbt_absolute_maxlevels(void);
> > +
> >  #endif	/* __XFS_ALLOC_BTREE_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 2ae5bf9a74e7..7e70df8d1a9b 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -93,6 +93,7 @@ xfs_bmap_compute_maxlevels(
> >  			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
> >  	}
> >  	mp->m_bm_maxlevels[whichfork] = level;
> > +	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_absolute_maxlevels());
> >  }
> >  
> >  unsigned int
> > diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> > index b90122de0df0..7001aff639d2 100644
> > --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> > +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> > @@ -587,6 +587,20 @@ xfs_bmbt_maxrecs(
> >  	return blocklen / (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t));
> >  }
> >  
> > +/* Compute the max possible height of the maximally sized bmap btree. */
> > +unsigned int
> > +xfs_bmbt_absolute_maxlevels(void)
> > +{
> > +	unsigned int		minrecs[2];
> > +
> > +	xfs_btree_absolute_minrecs(minrecs, XFS_BTREE_LONG_PTRS,
> > +			sizeof(struct xfs_bmbt_rec),
> > +			sizeof(struct xfs_bmbt_key) +
> > +				sizeof(xfs_bmbt_ptr_t));
> > +
> > +	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
> > +}
> 
> 	minrecs[0] = xfs_bmbt_block_maxrecs(
> 			XFS_MIN_BLOCKSIZE - XFS_BTREE_LBLOCK_LEN, true) / 2;
> 	....
> 
> > +
> >  /*
> >   * Calculate number of records in a bmap btree inode root.
> >   */
> > diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> > index 729e3bc569be..e9218e92526b 100644
> > --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> > +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> > @@ -110,4 +110,6 @@ extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
> >  extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
> >  		unsigned long long len);
> >  
> > +unsigned int xfs_bmbt_absolute_maxlevels(void);
> > +
> >  #endif	/* __XFS_BMAP_BTREE_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index b95c817ad90d..bea1bdf9b8b9 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -4964,3 +4964,44 @@ xfs_btree_has_more_records(
> >  	else
> >  		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
> >  }
> > +
> > +/*
> > + * Compute absolute minrecs for leaf and node btree blocks.  Callers should set
> > + * BTREE_LONG_PTRS and BTREE_OVERLAPPING as they would for regular cursors.
> > + * Set BTREE_CRC_BLOCKS if the btree type is supported /only/ on V5 or newer
> > + * filesystems.
> > + */
> > +void
> > +xfs_btree_absolute_minrecs(
> > +	unsigned int		*minrecs,
> > +	unsigned int		bc_flags,
> > +	unsigned int		leaf_recbytes,
> > +	unsigned int		node_recbytes)
> > +{
> > +	unsigned int		min_recbytes;
> > +
> > +	/*
> > +	 * If this btree type is supported on V4, we use the smaller V4 min
> > +	 * block size along with the V4 header size.  If the btree type is only
> > +	 * supported on V5, use the (twice as large) V5 min block size along
> > +	 * with the V5 header size.
> > +	 */
> > +	if (!(bc_flags & XFS_BTREE_CRC_BLOCKS)) {
> > +		if (bc_flags & XFS_BTREE_LONG_PTRS)
> > +			min_recbytes = XFS_MIN_BLOCKSIZE -
> > +							XFS_BTREE_LBLOCK_LEN;
> > +		else
> > +			min_recbytes = XFS_MIN_BLOCKSIZE -
> > +							XFS_BTREE_SBLOCK_LEN;
> > +	} else if (bc_flags & XFS_BTREE_LONG_PTRS) {
> > +		min_recbytes = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
> > +	} else {
> > +		min_recbytes = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_SBLOCK_CRC_LEN;
> > +	}
> > +
> > +	if (bc_flags & XFS_BTREE_OVERLAPPING)
> > +		node_recbytes <<= 1;
> > +
> > +	minrecs[0] = min_recbytes / (2 * leaf_recbytes);
> > +	minrecs[1] = min_recbytes / (2 * node_recbytes);
> > +}
> 
> This can go away.

Done.

> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 20a2828c11ef..acb202839afd 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -601,4 +601,7 @@ xfs_btree_alloc_cursor(
> >  	return cur;
> >  }
> >  
> > +void xfs_btree_absolute_minrecs(unsigned int *minrecs, unsigned int bc_flags,
> > +		unsigned int leaf_recbytes, unsigned int node_recbytes);
> > +
> >  #endif	/* __XFS_BTREE_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index bde2b4c64dbe..c43877c8a279 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -268,6 +268,8 @@ typedef struct xfs_fsop_resblks {
> >   */
> >  #define XFS_MIN_AG_BYTES	(1ULL << 24)	/* 16 MB */
> >  #define XFS_MAX_AG_BYTES	(1ULL << 40)	/* 1 TB */
> > +#define XFS_MAX_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_BLOCKSIZE)
> > +#define XFS_MAX_CRC_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_CRC_BLOCKSIZE)
> >  
> >  /* keep the maximum size under 2^31 by a small amount */
> >  #define XFS_MAX_LOG_BYTES \
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 994ad783d407..017aebdda42f 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -2793,6 +2793,7 @@ xfs_ialloc_setup_geometry(
> >  	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
> >  	igeo->inobt_maxlevels = xfs_btree_compute_maxlevels(igeo->inobt_mnr,
> >  			inodes);
> > +	ASSERT(igeo->inobt_maxlevels <= xfs_inobt_absolute_maxlevels());
> >  
> >  	/*
> >  	 * Set the maximum inode count for this filesystem, being careful not
> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index 3a5a24648b87..2e3dd1d798bd 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > @@ -542,6 +542,25 @@ xfs_inobt_maxrecs(
> >  	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
> >  }
> >  
> > +/* Compute the max possible height of the maximally sized inode btree. */
> > +unsigned int
> > +xfs_inobt_absolute_maxlevels(void)
> > +{
> > +	unsigned int		minrecs[2];
> > +	unsigned long long	max_ag_inodes;
> > +
> > +	/*
> > +	 * For the absolute maximum, pretend that we can fill an entire AG
> > +	 * completely full of inodes except for the AG headers.
> > +	 */
> > +	max_ag_inodes = (XFS_MAX_AG_BYTES - (4 * BBSIZE)) / XFS_DINODE_MIN_SIZE;
> > +
> > +	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_inobt_rec_t),
> > +			sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
> > +
> > +	return xfs_btree_compute_maxlevels(minrecs, max_ag_inodes);
> > +}
> 
> We've got two different inobt max levels on disk. The inobt which has v4
> limits, whilst the finobt that has v5 limits...

<nod> I'll make it return the larger of the two heights, though the
inode btree is always going to win due to its smaller minimum block size.

> > +/* Compute the max possible height of the maximally sized rmap btree. */
> > +unsigned int
> > +xfs_rmapbt_absolute_maxlevels(void)
> > +{
> > +	unsigned int		minrecs[2];
> > +
> > +	xfs_btree_absolute_minrecs(minrecs,
> > +			XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING,
> > +			sizeof(struct xfs_rmap_rec),
> > +			sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
> > +
> > +	/*
> > +	 * Compute the asymptotic maxlevels for an rmapbt on any reflink fs.
> > +	 *
> > +	 * On a reflink filesystem, each AG block can have up to 2^32 (per the
> > +	 * refcount record format) owners, which means that theoretically we
> > +	 * could face up to 2^64 rmap records.  However, we're likely to run
> > +	 * out of blocks in the AG long before that happens, which means that
> > +	 * we must compute the max height based on what the btree will look
> > +	 * like if it consumes almost all the blocks in the AG due to maximal
> > +	 * sharing factor.
> > +	 */
> > +	return xfs_btree_compute_maxlevels_size(XFS_MAX_CRC_AG_BLOCKS,
> 
> Huh. I don't know where XFS_MAX_CRC_AG_BLOCKS is defined. I must
> have missed it somewhere?

It was added elsewhere in this patch.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
