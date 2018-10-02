Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40466 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbeJBWXJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 18:23:09 -0400
Date: Tue, 2 Oct 2018 08:39:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: xrep_findroot_block should reject root blocks
 with siblings
Message-ID: <20181002153903.GD6706@magnolia>
References: <153843409576.24414.14199833763423874927.stgit@magnolia>
 <153843410206.24414.16640243145941466296.stgit@magnolia>
 <20181002123429.GA55077@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002123429.GA55077@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Oct 02, 2018 at 08:34:30AM -0400, Brian Foster wrote:
> On Mon, Oct 01, 2018 at 03:48:22PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xrep_findroot_block, if we find a candidate root block with sibling
> > pointers or sibling blocks on the same tree level, we should not return
> > that block as a tree root because root blocks cannot have siblings.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/repair.c |   61 +++++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 48 insertions(+), 13 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index 9f08dd9bf1d5..6eb66b3543ff 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> ...
> > @@ -735,18 +736,52 @@ xrep_findroot_block(
> >  		goto out;
> >  	bp->b_ops = fab->buf_ops;
> >  
> > -	/* Ignore this block if it's lower in the tree than we've seen. */
> > -	if (fab->root != NULLAGBLOCK &&
> > -	    xfs_btree_get_level(btblock) < fab->height)
> > -		goto out;
> > -
> >  	/* Make sure we pass the verifiers. */
> >  	bp->b_ops->verify_read(bp);
> >  	if (bp->b_error)
> >  		goto out;
> > -	fab->root = agbno;
> > -	fab->height = xfs_btree_get_level(btblock) + 1;
> > -	*found_it = true;
> > +
> > +	/*
> > +	 * This block passes the magic/uuid and verifier tests for this btree
> > +	 * type.  We don't need the caller to try the other tree types.
> > +	 */
> > +	*done_with_block = true;
> > +
> > +	block_level = xfs_btree_get_level(btblock);
> > +	if (block_level + 1 == fab->height) {
> > +		/*
> > +		 * This block claims to be at the same level as the root we
> > +		 * found previously.  There can't be two candidate roots, so
> > +		 * we'll throw away both of them and hope we later find a block
> > +		 * even higher in the tree.
> > +		 */
> > +		fab->root = NULLAGBLOCK;
> > +		goto out;
> > +	} else if (block_level < fab->height) {
> > +		/*
> > +		 * This block is lower in the tree than the root we found
> > +		 * previously, so just ignore it.
> > +		 */
> 
> Nit: can we combine these two comments into one above the whole if/else
> statement? It makes the code slightly more readable than multi-line
> comments in each branch, IMO. E.g.:
> 
>         /*
>          * Compare the current block level with the height of the current
>          * candidate root block. If the level matches the current candidate,
>          * we know the current candidate can't be a root so we must invalidate
>          * it. If the level is lower than the current candidate, just ignore
>          * this block.
>          */
>         block_level = xfs_btree_get_level(btblock);
>         if (block_level + 1 == fab->height) {
>                 fab->root = NULLAGBLOCK;
>                 goto out;
>         } else if (block_level < fab->height) {
>                 goto out;
>         }
> 
> With that:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Done; thanks for the review!

--D

> 
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * This is the highest block in the tree that we've found so far.
> > +	 * Update the btree height to reflect what we've learned from this
> > +	 * block.
> > +	 */
> > +	fab->height = block_level + 1;
> > +
> > +	/*
> > +	 * If this block doesn't have sibling pointers, then it's the new root
> > +	 * block candidate.  Otherwise, the root will be found farther up the
> > +	 * tree.
> > +	 */
> > +	if (btblock->bb_u.s.bb_leftsib == cpu_to_be32(NULLAGBLOCK) &&
> > +	    btblock->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK))
> > +		fab->root = agbno;
> > +	else
> > +		fab->root = NULLAGBLOCK;
> >  
> >  	trace_xrep_findroot_block(mp, ri->sc->sa.agno, agbno,
> >  			be32_to_cpu(btblock->bb_magic), fab->height - 1);
> > @@ -768,7 +803,7 @@ xrep_findroot_rmap(
> >  	struct xrep_findroot		*ri = priv;
> >  	struct xrep_find_ag_btree	*fab;
> >  	xfs_agblock_t			b;
> > -	bool				found_it;
> > +	bool				done;
> >  	int				error = 0;
> >  
> >  	/* Ignore anything that isn't AG metadata. */
> > @@ -777,16 +812,16 @@ xrep_findroot_rmap(
> >  
> >  	/* Otherwise scan each block + btree type. */
> >  	for (b = 0; b < rec->rm_blockcount; b++) {
> > -		found_it = false;
> > +		done = false;
> >  		for (fab = ri->btree_info; fab->buf_ops; fab++) {
> >  			if (rec->rm_owner != fab->rmap_owner)
> >  				continue;
> >  			error = xrep_findroot_block(ri, fab,
> >  					rec->rm_owner, rec->rm_startblock + b,
> > -					&found_it);
> > +					&done);
> >  			if (error)
> >  				return error;
> > -			if (found_it)
> > +			if (done)
> >  				break;
> >  		}
> >  	}
> > 
