Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8ABC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 17:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98DB760FDA
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 17:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhJMRuR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238552AbhJMRtY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Oct 2021 13:49:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C56AD60F4A;
        Wed, 13 Oct 2021 17:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634147240;
        bh=BwbINfubVNIo01/JJj/TsV9szIK/A7OFtX0yUztRHHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WycLFGE2vyyWASoKYYw4QheleS9alxebTnhgEcB3dGlkK6QGnjhpnGr11cVvHvSDf
         q48tQjX5WDoOmJBdimxmQ+KzQLw91zp9/nBjAIQnAJK7Gv8TyQ9EhOtoar/IbJV2HG
         VOu6rv2nLYUfZxERPVJH73eQ4XZWKwKkNMvLQB3DiBP3tx4hqdvifcadi/BcJgqjvB
         nK2ntFzVEl1FUxg1tWKi3n+tiS+bdXWQ2M9P9Kuf12iD5Rf3CGK0TcWp6u4bqj0MKT
         vxn1EzJxSeAHG0FBHP1eG/sXu5q/0S8Q3NnITNGstWFcP9/wPXOLfBQtIG8ZurihuA
         gqOzplAyvMxFQ==
Date:   Wed, 13 Oct 2021 10:47:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 11/15] xfs: compute the maximum height of the rmap btree
 when reflink enabled
Message-ID: <20211013174720.GY24307@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408161434.4151249.874557928540897102.stgit@magnolia>
 <20211013072521.GD2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013072521.GD2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 06:25:21PM +1100, Dave Chinner wrote:
> On Tue, Oct 12, 2021 at 04:33:34PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Instead of assuming that the hardcoded XFS_BTREE_MAXLEVELS value is big
> > enough to handle the maximally tall rmap btree when all blocks are in
> > use and maximally shared, let's compute the maximum height assuming the
> > rmapbt consumes as many blocks as possible.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.c       |   34 ++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_btree.h       |    2 +
> >  fs/xfs/libxfs/xfs_rmap_btree.c  |   55 ++++++++++++++++++++++++---------------
> >  fs/xfs/libxfs/xfs_trans_resv.c  |   13 +++++++++
> >  fs/xfs/libxfs/xfs_trans_space.h |    7 +++++
> >  5 files changed, 90 insertions(+), 21 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 6ced8f028d47..201b81d54622 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -4531,6 +4531,40 @@ xfs_btree_compute_maxlevels(
> >  	return level;
> >  }
> >  
> > +/*
> > + * Compute the maximum height of a btree that is allowed to consume up to the
> > + * given number of blocks.
> > + */
> > +unsigned int
> > +xfs_btree_compute_maxlevels_size(
> > +	unsigned long long	max_btblocks,
> > +	unsigned int		leaf_mnr)
> 
> So "leaf_mnr" is supposed to be the minimum number of records in
> a leaf?
> 
> But this gets passed mp->m_rmap_mnr[1], which is the minimum number
> of keys/ptrs in a node, not a leaf. I'm confused.

That should have been "node_mnr".  Sorry. :(

> > +{
> > +	unsigned long long	leaf_blocks = leaf_mnr;
> > +	unsigned long long	blocks_left;
> > +	unsigned int		maxlevels;
> > +
> > +	if (max_btblocks < 1)
> > +		return 0;
> > +
> > +	/*
> > +	 * The loop increments maxlevels as long as there would be enough
> > +	 * blocks left in the reservation to handle each node block at the
> > +	 * current level pointing to the minimum possible number of leaf blocks
> > +	 * at the next level down.  We start the loop assuming a single-level
> > +	 * btree consuming one block.
> > +	 */
> > +	maxlevels = 1;
> > +	blocks_left = max_btblocks - 1;
> > +	while (leaf_blocks < blocks_left) {
> > +		maxlevels++;
> > +		blocks_left -= leaf_blocks;
> > +		leaf_blocks *= leaf_mnr;
> > +	}
> > +
> > +	return maxlevels;
> 
> Yup, I'm definitely confused. We also have:
> 
> xfs_btree_calc_size(limits, len)
> xfs_btree_compute_maxlevels(limits, len)
> 
> And they do something similar but subtly different. They aren't
> clearly documented, either, so from reading the code:
> 
> xfs_btree_calc_size is calculating the btree block usage for a
> discrete count of items based on the leaf and node population values
> from mp->m_rmap_mnr, etc. It uses a division based algorithm
> 
> 	recs = limits[0]	// min recs per block
> 	for (level = 0; len > 1; level++) {
> 		do_div(len, recs)
> 		recs = limits[1]	// min ptrs per node
> 		rval += len;
> 	}
> 	return rval
> 
> (why does this even calculate level?)
> 
> So it returns the number of blocks the btree will consume to
> index a given number of discrete blocks.
> 
> xfs_btree_compute_maxlevels() is basically:
> 
> 	len = len / limits[0]		// record blocks in level 0
> 	for (level = 1; len > 1; level++)
> 		len = len / limits[1]	// node blocks in level n
> 	return level
> 
> So it returns how many levels are required to index a specific
> number of discrete blocks given a specific leaf/node population.
> 
> But what does xfs_btree_compute_maxlevels_size do? I'm really not
> sure from the desription, the calculation or the parameters passed
> to it. Even a table doesn't tell me:
> 
> say 10000 records, leaf_mnr = 10
> 
> loop		blocks_left	leaf_blocks	max_levels
> 0 (at init)		9999		10		1
> 1			9989	       100		2
> 2			9889	      1000		3
> 3			8889	     10000		4
> Breaks out on (leaf_blocks > blocks_left)
> 
> So, after much head scratching, I *think* what this function is
> trying to do is take into account the case where we have a single
> block shared by reflink N times, such that the entire AG is made up
> of rmap records pointing to all the owners.  We're trying to
> determine the size is the height of the tree if we index enough leaf
> records to consume all the free space in the AG?
> 
> Which then means we don't care what the number of records are in the
> leaf nodes, we only need to know how many leaf blocks there are and
> how many interior nodes we consume to index them?
> 
> IOWs, we're counting the number of leaf blocks we can index at each
> level based on the _minimum number of pointers_ we can hold in a
> _node_?

Yes.

> If so, then the naming leaves a lot to be desired here. The
> variables all being named "leaf" even though they are being passed
> node limits and are calculating node level indexing limits and not
> leaf space consumption completely threw me in the wrong direction.
> I just spent the best part of 90 minutes working all this out
> from first principles because nothing is obvious about why this code
> is correct. Everything screamed "wrong wrong wrong" at me until
> I finally understood what was being calculated. And now I know, it
> still screams "wrong wrong wrong" at me.
> 
> So:
> 
> /*
>  * Given a number of available blocks for the btree to consume with
>  * records and pointers, calculate the height of the tree needed to
>  * index all the records that space can hold based on the number of
>  * pointers each interior node holds.
>  *
>  * We start by assuming a single level tree consumes a single block,
>  * then track the number of blocks each node level consumes until we
>  * no longer have space to store the next node level. At this point,
>  * we are indexing all the leaf blocks in the space, and there's no
>  * more free space to split the tree any further. That's our maximum
>  * btree height.

Ah, yes, that's a much better description and name than the ones I put
on the function.

>  */
> unsigned int
> xfs_btree_space_to_height(
> 	unsigned int		*limits,
> 	unsigned long long	leaf_blocks)
> {
> 	unsigned long long	node_blocks = limits[1];
> 	unsigned long long	blocks_left = leaf_blocks - 1;
> 	unsigned int		height = 1;
> 
> 	if (leaf_blocks < 1)
> 		return 0;
> 
> 	while (node_blocks < blocks_left) {
> 		height++;
> 		blocks_left -= node_blocks;
> 		node_blocks *= limits[1];
> 	}
> 
> 	return height;
> }
> 
> Oh, yeah, I made the parameters the same as the other btree
> height/size functions, too, because....
> 
> > +	unsigned int		val;
> > +
> > +	if (!xfs_has_rmapbt(mp)) {
> > +		mp->m_rmap_maxlevels = 0;
> > +		return;
> > +	}
> > +
> > +	if (xfs_has_reflink(mp)) {
> > +		/*
> > +		 * Compute the asymptotic maxlevels for an rmap btree on a
> > +		 * filesystem that supports reflink.
> > +		 *
> > +		 * On a reflink filesystem, each AG block can have up to 2^32
> > +		 * (per the refcount record format) owners, which means that
> > +		 * theoretically we could face up to 2^64 rmap records.
> > +		 * However, we're likely to run out of blocks in the AG long
> > +		 * before that happens, which means that we must compute the
> > +		 * max height based on what the btree will look like if it
> > +		 * consumes almost all the blocks in the AG due to maximal
> > +		 * sharing factor.
> > +		 */
> > +		val = xfs_btree_compute_maxlevels_size(mp->m_sb.sb_agblocks,
> > +				mp->m_rmap_mnr[1]);
> > +	} else {
> > +		/*
> > +		 * If there's no block sharing, compute the maximum rmapbt
> > +		 * height assuming one rmap record per AG block.
> > +		 */
> > +		val = xfs_btree_compute_maxlevels(mp->m_rmap_mnr,
> > +				mp->m_sb.sb_agblocks);
> 
> This just looks weird with the same parameters in reverse order to
> these two functions...

TBH I intentionally reversed the order to make it obvious which was
which, so we wouldn't end up with...

uint xfs_btree_compute_maxlevels(uint *limits, unsigned int len);
uint xfs_btree_space_to_height(uint *limits, unsigned int blocks);
uint xfs_btree_calc_size(uint *limits, unsigned int len);

...three functions with the same type signatures.  Three years have
flown by since I wrote this patch, and now the signatures have diverged
enough to make it at least somewhat distinct.

IOWs, I'll adopt your version. :)

> > +	}
> > +
> > +	mp->m_rmap_maxlevels = val;
> >  }
> 
> Also, this function becomes simpler if it just returns the maxlevels
> value and the caller writes it into mp->m_rmap_maxlevels.

Done.

> >  
> >  /* Calculate the refcount btree size for some records. */
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index 5e300daa2559..97bd17d84a23 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -814,6 +814,16 @@ xfs_trans_resv_calc(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_trans_resv	*resp)
> >  {
> > +	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
> > +
> > +	/*
> > +	 * In the early days of rmap+reflink, we always set the rmap maxlevels
> > +	 * to 9 even if the AG was small enough that it would never grow to
> > +	 * that height.
> > +	 */
> > +	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
> > +		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
> > +
> >  	/*
> >  	 * The following transactions are logged in physical format and
> >  	 * require a permanent reservation on space.
> > @@ -916,4 +926,7 @@ xfs_trans_resv_calc(
> >  	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
> >  	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
> >  	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
> > +
> > +	/* Put everything back the way it was.  This goes at the end. */
> > +	mp->m_rmap_maxlevels = rmap_maxlevels;
> >  }
> 
> Why play games like this? We want the reservations to go down in
> size if the btrees don't reach "XFS_OLD_REFLINK_RMAP_MAXLEVELS"
> size. The reason isn't mentioned in the commit message...

I think I'll record the reason why in the code itself.

	/*
	 * In the early days of rmap+reflink, we always set the rmap
	 * maxlevels to 9 even if the AG was small enough that it would
	 * never grow to that height.  Transaction reservation sizes
	 * influence the minimum log size calculation, which influences
	 * the size of the log that mkfs creates.  Use the old value
	 * here to ensure that newly formatted small filesystems will
	 * mount on older kernels.
	 */
	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;


> 
> > diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> > index 50332be34388..440c9c390b86 100644
> > --- a/fs/xfs/libxfs/xfs_trans_space.h
> > +++ b/fs/xfs/libxfs/xfs_trans_space.h
> > @@ -17,6 +17,13 @@
> >  /* Adding one rmap could split every level up to the top of the tree. */
> >  #define XFS_RMAPADD_SPACE_RES(mp) ((mp)->m_rmap_maxlevels)
> >  
> > +/*
> > + * Note that we historically set m_rmap_maxlevels to 9 when reflink was
> > + * enabled, so we must preserve this behavior to avoid changing the transaction
> > + * space reservations.
> > + */
> > +#define XFS_OLD_REFLINK_RMAP_MAXLEVELS	(9)
> 
> 9.

Assuming you meant '9 without the parentheses' here, fixed.  Thanks for
slogging through all that blocks_to_height stuff. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
