Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40066 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730419AbeHIUJS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Aug 2018 16:09:18 -0400
Date: Thu, 9 Aug 2018 10:43:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: xrep_findroot_block should reject root blocks
 with siblings
Message-ID: <20180809174317.GL30972@magnolia>
References: <153370061966.25077.161884080659267764.stgit@magnolia>
 <153370062610.25077.16005158396857920623.stgit@magnolia>
 <20180809130839.GB21639@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180809130839.GB21639@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Thu, Aug 09, 2018 at 09:08:39AM -0400, Brian Foster wrote:
> On Tue, Aug 07, 2018 at 08:57:06PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xrep_findroot_block, if we find a candidate root block with sibling
> > pointers or sibling blocks on the same tree level, we should not return
> > that block as a tree root because root blocks cannot have siblings.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/repair.c |   17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index 85b048b341a0..6c199e2ebb81 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> > @@ -727,6 +727,23 @@ xrep_findroot_block(
> >  	bp->b_ops->verify_read(bp);
> >  	if (bp->b_error)
> >  		goto out;
> > +
> > +	/* Root blocks can't have siblings. */
> > +	if (btblock->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) ||
> > +	    btblock->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK))
> > +		goto out;
> > +
> > +	/*
> > +	 * If we find a second block at this level, ignore this level because
> > +	 * it can't possibly be a root level.  Maybe we'll find a higher level,
> > +	 * or maybe the rmap information is garbage.
> > +	 */
> > +	if (fab->root != NULLAGBLOCK &&
> > +	    fab->height == xfs_btree_get_level(btblock) + 1) {
> > +		fab->root = NULLAGBLOCK;
> > +		goto out;
> > +	}
> 
> Ok, but is this enough? Won't resetting fab->root like this mean that
> we'd just reassign it to the next block we find at this level? I'm
> wondering if we should maintain ->height independently and anticipate
> that (height == <valid> && root == NULLAGBLOCK) means we couldn't find a
> valid root. That may also allow for more efficient height filtering
> during the query.

Working through this again, I think we could just set fab->root = 0
when we encounter this situation.  I think the two height checks could
be combined as well, so I'll retest and repost.

Roughly, I think this whole section could be restructured as:

/* Make sure we pass the verifiers. */
...

/* Root blocks can't have siblings. */
...

/* If we've recorded a root candidate... */
block_level = xfs_btree_get_level(btblock);
if (fab->root != NULLAGBLOCK) {
	/*
	 * ...and this no-sibling root block candidate has the same
	 * level as the recorded candidate, there's no way we're going
	 * to accept any candidates at this tree level.  Stash a root
	 * block of zero because the height is still valid, but no AG
	 * btree can root at agblock 0.  Callers should verify the root
	 * agbno.
	 */
	if (block_level + 1 == fab->height) {
		fab->root = 0;
		goto out;
	}

	/*
	 * ...and this no-sibling root block is lower in the tree than
	 * the recorded root block candidate, just ignore it.  There's
	 * still a strong chance that something is wrong with the btree
	 * itself, but that's not what we're fixing right now.
	 */
	if (block_level < fab->height)
		goto out;
}

/* Record the candidate root block */
...

--D

> 
> Brian
> 
> > +
> >  	fab->root = agbno;
> >  	fab->height = xfs_btree_get_level(btblock) + 1;
> >  	*found_it = true;
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
