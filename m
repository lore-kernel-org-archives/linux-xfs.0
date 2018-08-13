Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730079AbeHMTjl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Aug 2018 15:39:41 -0400
Date: Mon, 13 Aug 2018 12:56:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/6] xfs: xrep_findroot_block should reject root blocks
 with siblings
Message-ID: <20180813165635.GA64121@bfoster>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
 <153400170977.27471.4053607329690572828.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153400170977.27471.4053607329690572828.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Aug 11, 2018 at 08:35:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xrep_findroot_block, if we find a candidate root block with sibling
> pointers or sibling blocks on the same tree level, we should not return
> that block as a tree root because root blocks cannot have siblings.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/repair.c |   47 +++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 41 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 17cf48564390..42d8c798ce7d 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -690,6 +690,7 @@ xrep_findroot_block(
>  	struct xfs_buf			*bp;
>  	struct xfs_btree_block		*btblock;
>  	xfs_daddr_t			daddr;
> +	int				block_level;
>  	int				error;
>  
>  	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.agno, agbno);
> @@ -727,17 +728,51 @@ xrep_findroot_block(
>  		goto out;
>  	bp->b_ops = fab->buf_ops;
>  
> -	/* Ignore this block if it's lower in the tree than we've seen. */
> -	if (fab->root != NULLAGBLOCK &&
> -	    xfs_btree_get_level(btblock) < fab->height)
> -		goto out;
> -
>  	/* Make sure we pass the verifiers. */
>  	bp->b_ops->verify_read(bp);
>  	if (bp->b_error)
>  		goto out;
> +
> +	/* If we've recorded a root candidate... */
> +	block_level = xfs_btree_get_level(btblock);
> +	if (fab->root != NULLAGBLOCK) {
> +		/*
> +		 * ...and this no-sibling root block candidate has the same
> +		 * level as the recorded candidate, there's no way we're going
> +		 * to accept any candidates at this tree level.  Stash a root
> +		 * block of zero because the height is still valid, but no
> +		 * AG btree can root at agblock 0.  Callers should verify the
> +		 * root agbno with xfs_verify_agbno...
> +		 */
> +		if (block_level + 1 == fab->height) {
> +			fab->root = 0;
> +			goto out;
> +		}
> +
> +		/*
> +		 * ...and this no-sibling root block is lower in the tree than
> +		 * the recorded root block candidate, just ignore it.  There's
> +		 * still a strong chance that something is wrong with the btree
> +		 * itself, but that's not what we're fixing right now.
> +		 */
> +		if (block_level < fab->height)
> +			goto out;
> +	}
> +
> +	/*
> +	 * Root blocks can't have siblings.  This level can't be the root, so
> +	 * record the tree height (but not the ag block pointer) to force us to
> +	 * look for a higher level in the tree.
> +	 */
> +	if (btblock->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) ||
> +	    btblock->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)) {
> +		fab->root = 0;
> +		fab->height = block_level + 1;
> +		goto out;
> +	}
> +

Hmm, this looks technically correct but this still seems more involved
than necessary. I don't really like how we define yet another magic
value of 0, for example, and differentiate that from NULLAGBLOCK when it
seems like we could just check the height.

Could we do something like the following (which assumes ->height is
initialized to 0)?

        /*
         * If current height exceeds the block level, we've already seen at
         * least one block at this level or higher. Skip it and invalidate the
         * root if this block matches the current root level because a root
         * block has no siblings.
         */
        block_level = xfs_btree_get_level(btblock);
        if (fab->height > block_level) {
                if (fab->height - 1 == block_level)
                        fab->root = NULLAGBLOCK;
                goto out;
        }

        /*
         * Found a block with a new max height. Track it as a root candidate if
         * it has no siblings. Otherwise invalidate root since we know the root
         * can't be at this level.
         */
        if (btblock->bb_u.s.bb_leftsib == cpu_to_be32(NULLAGBLOCK) &&
            btblock->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK))
                fab->root = agbno;
        else
                fab->root = NULLAGBLOCK;
        fab->height = block_level + 1;

... and then ->root should either be valid or NULLAGBLOCK at the end..?

Also, shouldn't we set *found_it a bit earlier in this function? It
looks like that simply controls the fab iteration and we have
technically matched the block to a btree type at this point, regardless
of whether we update root/height. (I wonder if something like "matched"
or "found_match" might be a better name than found_it...).

Brian

>  	fab->root = agbno;
> -	fab->height = xfs_btree_get_level(btblock) + 1;
> +	fab->height = block_level + 1;
>  	*found_it = true;
>  
>  	trace_xrep_findroot_block(mp, ri->sc->sa.agno, agbno,
> 
