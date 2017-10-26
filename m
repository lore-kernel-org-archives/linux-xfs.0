Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36794 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932127AbdJZQzk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 12:55:40 -0400
Date: Thu, 26 Oct 2017 09:55:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] xfs: compare btree block keys to parent block's keys
 during scrub
Message-ID: <20171026165536.GA5483@magnolia>
References: <150899696463.18095.9642473908739425678.stgit@magnolia>
 <150899698291.18095.5640109148216105105.stgit@magnolia>
 <20171026131656.GD3450@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026131656.GD3450@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 09:16:56AM -0400, Brian Foster wrote:
> On Wed, Oct 25, 2017 at 10:49:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're done checking all the records/keys in a btree block, compute
> > the low and high key of the block and compare them to the associated key
> > in the parent btree block.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> I guess this one should be stacked on top of a scrub series.. (or the
> associated code merged)? Doesn't apply to for-next..

Yes, it goes atop the scrub series ... which means I forgot to push
for-next last night. :(

--D

> Brian
> 
> >  fs/xfs/libxfs/xfs_btree.c |    4 ++--
> >  fs/xfs/libxfs/xfs_btree.h |    4 ++++
> >  fs/xfs/scrub/btree.c      |   46 +++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 52 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index b3cd82a..848f371 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -2027,7 +2027,7 @@ xfs_btree_lookup(
> >  }
> >  
> >  /* Find the high key storage area from a regular key. */
> > -STATIC union xfs_btree_key *
> > +union xfs_btree_key *
> >  xfs_btree_high_key_from_key(
> >  	struct xfs_btree_cur	*cur,
> >  	union xfs_btree_key	*key)
> > @@ -2101,7 +2101,7 @@ xfs_btree_get_node_keys(
> >  }
> >  
> >  /* Derive the keys for any btree block. */
> > -STATIC void
> > +void
> >  xfs_btree_get_keys(
> >  	struct xfs_btree_cur	*cur,
> >  	struct xfs_btree_block	*block,
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index be82f41..b57501c 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -541,5 +541,9 @@ int64_t xfs_btree_diff_two_ptrs(struct xfs_btree_cur *cur,
> >  void xfs_btree_get_sibling(struct xfs_btree_cur *cur,
> >  			   struct xfs_btree_block *block,
> >  			   union xfs_btree_ptr *ptr, int lr);
> > +void xfs_btree_get_keys(struct xfs_btree_cur *cur,
> > +		struct xfs_btree_block *block, union xfs_btree_key *key);
> > +union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
> > +		union xfs_btree_key *key);
> >  
> >  #endif	/* __XFS_BTREE_H__ */
> > diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> > index 9ccf763..9e8b67a 100644
> > --- a/fs/xfs/scrub/btree.c
> > +++ b/fs/xfs/scrub/btree.c
> > @@ -358,6 +358,50 @@ xfs_scrub_btree_get_block(
> >  }
> >  
> >  /*
> > + * Check that the low and high keys of this block match the keys stored
> > + * in the parent block.
> > + */
> > +STATIC void
> > +xfs_scrub_btree_block_keys(
> > +	struct xfs_scrub_btree		*bs,
> > +	int				level,
> > +	struct xfs_btree_block		*block)
> > +{
> > +	union xfs_btree_key		block_keys;
> > +	struct xfs_btree_cur		*cur = bs->cur;
> > +	union xfs_btree_key		*high_bk;
> > +	union xfs_btree_key		*parent_keys;
> > +	union xfs_btree_key		*high_pk;
> > +	struct xfs_btree_block		*parent_block;
> > +	struct xfs_buf			*bp;
> > +
> > +	if (level >= cur->bc_nlevels - 1)
> > +		return;
> > +
> > +	/* Calculate the keys for this block. */
> > +	xfs_btree_get_keys(cur, block, &block_keys);
> > +
> > +	/* Obtain the parent's copy of the keys for this block. */
> > +	parent_block = xfs_btree_get_block(cur, level + 1, &bp);
> > +	parent_keys = xfs_btree_key_addr(cur, cur->bc_ptrs[level + 1],
> > +			parent_block);
> > +
> > +	if (cur->bc_ops->diff_two_keys(cur, &block_keys, parent_keys) != 0)
> > +		xfs_scrub_btree_set_corrupt(bs->sc, cur, 1);
> > +
> > +	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
> > +		return;
> > +
> > +	/* Get high keys */
> > +	high_bk = xfs_btree_high_key_from_key(cur, &block_keys);
> > +	high_pk = xfs_btree_high_key_addr(cur, cur->bc_ptrs[level + 1],
> > +			parent_block);
> > +
> > +	if (cur->bc_ops->diff_two_keys(cur, high_bk, high_pk) != 0)
> > +		xfs_scrub_btree_set_corrupt(bs->sc, cur, 1);
> > +}
> > +
> > +/*
> >   * Visit all nodes and leaves of a btree.  Check that all pointers and
> >   * records are in order, that the keys reflect the records, and use a callback
> >   * so that the caller can verify individual records.
> > @@ -418,6 +462,7 @@ xfs_scrub_btree(
> >  			/* End of leaf, pop back towards the root. */
> >  			if (cur->bc_ptrs[level] >
> >  			    be16_to_cpu(block->bb_numrecs)) {
> > +				xfs_scrub_btree_block_keys(&bs, level, block);
> >  				if (level < cur->bc_nlevels - 1)
> >  					cur->bc_ptrs[level + 1]++;
> >  				level++;
> > @@ -442,6 +487,7 @@ xfs_scrub_btree(
> >  
> >  		/* End of node, pop back towards the root. */
> >  		if (cur->bc_ptrs[level] > be16_to_cpu(block->bb_numrecs)) {
> > +			xfs_scrub_btree_block_keys(&bs, level, block);
> >  			if (level < cur->bc_nlevels - 1)
> >  				cur->bc_ptrs[level + 1]++;
> >  			level++;
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
