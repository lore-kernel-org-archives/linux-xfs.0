Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C85BC3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 15:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D2172080F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 15:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388488AbfITP2Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfITP2Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Sep 2019 11:28:16 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 914B9C057F31;
        Fri, 20 Sep 2019 15:28:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 100AF19C5B;
        Fri, 20 Sep 2019 15:28:14 +0000 (UTC)
Date:   Fri, 20 Sep 2019 11:28:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 14/19] xfs: Add delayed attribute routines
Message-ID: <20190920152813.GL40150@bfoster>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905221837.17388-15-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 20 Sep 2019 15:28:15 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 03:18:32PM -0700, Allison Collins wrote:
> This patch adds new delayed attribute routines:
> 
> xfs_attr_set_later
> xfs_attr_remove_later
> xfs_leaf_addname_later
> xfs_node_addname_later
> xfs_node_removename_later
> 
> These routines are similar to their existing counter parts,
> but they do not roll or commit transactions.  They instead
> return -EAGAIN to allow the calling function to roll the
> transaction and recall the function.  This allows the
> attribute operations to be logged in multiple smaller
> transactions.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 591 ++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_attr.h |   2 +
>  2 files changed, 592 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 781dd8a..310f5b2 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -313,6 +316,112 @@ xfs_attr_set_args(
>  }
>  
>  /*
> + * Set the attribute specified in @args.
> + * This routine is meant to function as a delayed operation, and may return
> + * -EGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + * returned.
> + */
> +int
> +xfs_attr_set_later(
> +	struct xfs_da_args	*args,
> +	struct xfs_buf          **leaf_bp)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	int			error = 0;
> +	int			sf_size;
> +
> +	/*
> +	 * New inodes may not have an attribute fork yet. So set the attribute
> +	 * fork appropriately
> +	 */
> +	if (XFS_IFORK_Q((args->dp)) == 0) {
> +		sf_size = sizeof(struct xfs_attr_sf_hdr) +
> +		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
> +		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
> +		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
> +		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
> +	}
> +
> +	/*
> +	 * If the attribute list is non-existent or a shortform list,
> +	 * upgrade it to a single-leaf-block attribute list.
> +	 */
> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> +	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> +	     dp->i_d.di_anextents == 0)) {
> +		/*
> +		 * Build initial attribute list (if required).
> +		 */
> +		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
> +			xfs_attr_shortform_create(args);
> +
> +		/*
> +		 * Try to add the attr to the attribute list in the inode.
> +		 */
> +		error = xfs_attr_try_sf_addname(dp, args);
> +		if (error != -ENOSPC)
> +			return error;
> +
> +		/*
> +		 * It won't fit in the shortform, transform to a leaf block.
> +		 * GROT: another possible req'mt for a double-split btree op.
> +		 */
> +		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Prevent the leaf buffer from being unlocked so that a
> +		 * concurrent AIL push cannot grab the half-baked leaf
> +		 * buffer and run into problems with the write verifier.
> +		 */
> +
> +		xfs_trans_bhold(args->trans, *leaf_bp);
> +		return -EAGAIN;
> +	}

I haven't actually reviewed the code in this patch yet, but rather I
skipped ahead to try and get an understanding of the design approach and
flow of a deferred xattr operation. IIUC, we basically duplicate a bunch
of xattr code into these dfops oriented functions but instead of rolling
transactions, return -EAGAIN and use the XFS_DC_ state flags to manage
reentrancy into the xfs_trans_attr() function.

If I'm following that correctly, I'm concerned about a couple things
with the general approach. First, I think the complexity is high and
maintainability is low/difficult for this kind of reentrant approach.
The state is managed/changed all throughout the call tree and so the
risk and complexity of changing one particular bit in the sequence
requires subtle consideration to make sure it doesn't cause problems if
the function is reentered. For example, I'd prefer to see something like
xfs_trans_attr() broken down into smaller granularity functions with
higher level state that is managed and readable in one place, if
possible. Perhaps we could do that based on attr fork format, but I need
to stare at the code and think about this some more (it might be that
some degree of reentrancy is inevitable, or we just need to break things
down to even smaller states...).

Second, it seems like a lot of this code duplication between deferred
and non-deferred operations should be unnecessary, particularly since
the only difference between the contexts is how transactions are
managed. For example, if you follow the xattr set code path in both
contexts, we can see that functions like xfs_attr_set_args() are
basically duplicated in the xfs_attr_set_later() deferred variant just
so we can change the xfs_defer_finish() call in the former to a return
-EAGAIN in the latter.

Instead, what I think we should strive for is a common xattr mechanism
that consists of the lowest common denominator between the two contexts
(or IOW, core infrastructure that can be invoked from either context).
For example, on a kernel without deferred xattr support, could we find a
way to call the deferred variants directly and just let the
context-specific caller do the transaction rolls on -EAGAIN instead of
relying on the dfops infrastructure? ISTM that should be possible, it
just requires further breaking down the existing/non-deferred mechanism
into smaller bits that uses the new state management logic and
implements -EAGAIN handling for when the lower level code requires a
transaction roll. At that point, deferred support should basically just
consist of the dfops and log (i.e. intents) code to plug into the associated
infrastructure. I think another side effect of that approach is that we
shouldn't need these patches that add a bunch of new xattr
infrastructure code, but rather we'd just continue refactoring the
existing code and eventually implement a new high level function that
returns -EAGAIN directly to the dfops code instead of rolling
transactions explicitly. Thoughts?

Brian

> +
> +	/*
> +	 * After a shortform to leaf conversion, we need to hold the leaf and
> +	 * cylce out the transaction.  When we get back, we need to release
> +	 * the leaf.
> +	 */
> +	if (*leaf_bp != NULL) {
> +		xfs_trans_brelse(args->trans, *leaf_bp);
> +		*leaf_bp = NULL;
> +	}
> +
> +	/*
> +	 * If we fit in a block, or we are in the middle of adding a leaf name.
> +	 * xfs_attr_da_leaf_addname will set the XFS_DC_ALLOC_LEAF to indicate
> +	 * that it is not done yet, and need to be recalled to finish up from
> +	 * the last EAGAIN it returned
> +	 */
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK) ||
> +	    args->dc.flags & XFS_DC_ALLOC_LEAF) {
> +		if (!(args->dc.flags & XFS_DC_FOUND_LBLK)) {
> +			error = xfs_attr_leaf_try_add(args, *leaf_bp);
> +			args->dc.flags |= XFS_DC_FOUND_LBLK;
> +
> +			if (error && error != -ENOSPC)
> +				return error;
> +
> +			return -EAGAIN;
> +		}
> +
> +		error = xfs_leaf_addname_later(args);
> +		if (error && error != -ENOSPC)
> +			return error;
> +	} else {
> +		error = xfs_node_addname_later(args);
> +	}
> +
> +	return error;
> +}
> +
> +
> +
> +/*
>   * Return EEXIST if attr is found, or ENOATTR if not
>   */
>  int
> @@ -362,6 +471,57 @@ xfs_attr_remove_args(
>  	return error;
>  }
>  
> +/*
> + * Remove the attribute specified in @args.
> + * This routine is meant to function as a delayed operation, and may return
> + * -EGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + * returned.
> + */
> +int
> +xfs_attr_remove_later(
> +	struct xfs_da_args      *args)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_buf		*bp;
> +	int			forkoff, error = 0;
> +
> +	if (!xfs_inode_hasattr(dp)) {
> +		error = -ENOATTR;
> +	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> +		error = xfs_attr_shortform_remove(args);
> +	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK) &&
> +		   !(args->dc.flags & XFS_DC_RM_NODE_BLKS)) {
> +		/*
> +		 * If we fit in a block AND we are not in the middle of
> +		 * removing node blocks, remove the leaf attribute.
> +		 * xfs_attr_da_node_removename will set XFS_DC_RM_NODE_BLKS to
> +		 * signal that it is not done yet, and needs to be recalled to
> +		 * to finish up from the last -EAGAIN
> +		 */
> +		error = xfs_leaf_has_attr(args, &bp);
> +		if (error == -ENOATTR) {
> +			xfs_trans_brelse(args->trans, bp);
> +			return error;
> +		}
> +		error = 0;
> +
> +		xfs_attr3_leaf_remove(bp, args);
> +
> +		/* If the result is small enough, shrink it into the inode.*/
> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
> +		if (forkoff)
> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +	} else {
> +		error = xfs_node_removename_later(args);
> +	}
> +
> +	return error;
> +}
> +
> +
> +
>  int
>  xfs_attr_set(
>  	struct xfs_inode	*dp,
> @@ -794,6 +954,87 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
>  }
>  
>  /*
> + * Add a name to the leaf attribute list structure
> + *
> + * This leaf block cannot have a "remote" value, we only call this routine
> + * if bmap_one_block() says there is only one block (ie: no remote blks).
> + *
> + * This routine is meant to function as a delayed operation, and may return
> + * -EGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + * returned.
> + */
> +STATIC int
> +xfs_leaf_addname_later(
> +	struct xfs_da_args	*args)
> +{
> +	int			error, nmap;
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_bmbt_irec	*map = &args->dc.map;
> +
> +	/*
> +	 * If there was an out-of-line value, allocate the blocks we
> +	 * identified for its storage and copy the value.  This is done
> +	 * after we create the attribute so that we don't overflow the
> +	 * maximum size of a transaction and/or hit a deadlock.
> +	 */
> +	if (args->rmtblkno > 0) {
> +		if (!(args->dc.flags & XFS_DC_ALLOC_LEAF)) {
> +			args->dc.lfileoff = 0;
> +			args->dc.lblkno = 0;
> +			args->dc.blkcnt = 0;
> +			args->rmtblkcnt = 0;
> +			args->rmtblkno = 0;
> +			memset(map, 0, sizeof(struct xfs_bmbt_irec));
> +
> +			error = xfs_attr_rmt_find_hole(args);
> +			if (error)
> +				return error;
> +
> +			args->dc.blkcnt = args->rmtblkcnt;
> +			args->dc.lblkno = args->rmtblkno;
> +			args->dc.flags |= XFS_DC_ALLOC_LEAF;
> +		}
> +
> +		/*
> +		 * Roll through the "value", allocating blocks on disk as
> +		 * required.
> +		 */
> +		while (args->dc.blkcnt > 0) {
> +			nmap = 1;
> +			error = xfs_bmapi_write(args->trans, dp,
> +				  (xfs_fileoff_t)args->dc.lblkno,
> +				  args->dc.blkcnt, XFS_BMAPI_ATTRFORK,
> +				  args->total, map, &nmap);
> +			if (error)
> +				return error;
> +			ASSERT(nmap == 1);
> +			ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
> +			       (map->br_startblock != HOLESTARTBLOCK));
> +
> +			/* roll attribute extent map forwards */
> +			args->dc.lblkno += map->br_blockcount;
> +			args->dc.blkcnt -= map->br_blockcount;
> +
> +			return -EAGAIN;
> +		}
> +
> +		error = xfs_attr_rmtval_set_value(args);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (args->rmtblkno > 0) {
> +		/*
> +		 * Added a "remote" value, just clear the incomplete flag.
> +		 */
> +		error = xfs_attr3_leaf_clearflag(args);
> +	}
> +	args->dc.flags &= ~XFS_DC_ALLOC_LEAF;
> +	return error;
> +}
> +
> +/*
>   * Return EEXIST if attr is found, or ENOATTR if not
>   */
>  STATIC int
> @@ -1291,6 +1532,354 @@ xfs_attr_node_removename(
>  }
>  
>  /*
> + * Remove a name from a B-tree attribute list.
> + *
> + * This will involve walking down the Btree, and may involve joining
> + * leaf nodes and even joining intermediate nodes up to and including
> + * the root node (a special case of an intermediate node).
> + *
> + * This routine is meant to function as a delayed operation, and may return
> + * -EGAIN when the transaction needs to be rolled.  Calling functions
> + * will need to handle this, and recall the function until a successful error
> + * code is returned.
> + */
> +STATIC int
> +xfs_node_removename_later(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_da_state	*state = NULL;
> +	struct xfs_da_state_blk	*blk;
> +	struct xfs_buf		*bp;
> +	int			error, forkoff, retval = 0;
> +	struct xfs_inode	*dp = args->dp;
> +	int			done = 0;
> +
> +	trace_xfs_attr_node_removename(args);
> +
> +	if (args->dc.state == NULL) {
> +		error = xfs_attr_node_hasname(args, &args->dc.state);
> +		if (error != -EEXIST)
> +			goto out;
> +		else
> +			error = 0;
> +
> +		/*
> +		 * If there is an out-of-line value, de-allocate the blocks.
> +		 * This is done before we remove the attribute so that we don't
> +		 * overflow the maximum size of a transaction and/or hit a
> +		 * deadlock.
> +		 */
> +		state = args->dc.state;
> +		args->dc.blk = &state->path.blk[state->path.active - 1];
> +		ASSERT(args->dc.blk->bp != NULL);
> +		ASSERT(args->dc.blk->magic == XFS_ATTR_LEAF_MAGIC);
> +	}
> +	state = args->dc.state;
> +	blk = args->dc.blk;
> +
> +	if (args->rmtblkno > 0 && !(args->dc.flags & XFS_DC_RM_LEAF_BLKS)) {
> +		bool isset;
> +
> +		error = xfs_attr3_leaf_flag_is_set(args, &isset);
> +		if (error)
> +			goto out;
> +		if (!isset) {
> +			/*
> +			 * Fill in disk block numbers in the state structure
> +			 * so that we can get the buffers back after we commit
> +			 * several transactions in the following calls.
> +			 */
> +			error = xfs_attr_fillstate(state);
> +			if (error)
> +				goto out;
> +
> +			/*
> +			 * Mark the attribute as INCOMPLETE, then bunmapi() the
> +			 * remote value.
> +			 */
> +			error = xfs_attr3_leaf_setflag(args);
> +			if (error)
> +				goto out;
> +
> +			return -EAGAIN;
> +		}
> +
> +		if (!(args->dc.flags & XFS_DC_RM_NODE_BLKS)) {
> +			args->dc.flags |= XFS_DC_RM_NODE_BLKS;
> +			error = xfs_attr_rmtval_invalidate(args);
> +			if (error)
> +				goto out;
> +		}
> +
> +		/*
> +		 * Unmap value blocks for this attr.  This is similar to
> +		 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
> +		 * for new transactions
> +		 */
> +		while (!done && !error) {
> +			error = xfs_bunmapi(args->trans, args->dp,
> +				    args->rmtblkno, args->rmtblkcnt,
> +				    XFS_BMAPI_ATTRFORK, 1, &done);
> +			if (error)
> +				return error;
> +
> +			if (!done)
> +				return -EAGAIN;
> +		}
> +
> +		if (error)
> +			goto out;
> +
> +		/*
> +		 * Refill the state structure with buffers, the prior calls
> +		 * released our buffers.
> +		 */
> +		error = xfs_attr_refillstate(state);
> +		if (error)
> +			goto out;
> +	}
> +
> +	/*
> +	 * Remove the name and update the hashvals in the tree.
> +	 */
> +	if (!(args->dc.flags & XFS_DC_RM_LEAF_BLKS)) {
> +		blk = &state->path.blk[state->path.active - 1];
> +		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +		retval = xfs_attr3_leaf_remove(blk->bp, args);
> +		xfs_da3_fixhashpath(state, &state->path);
> +
> +		args->dc.flags |= XFS_DC_RM_LEAF_BLKS;
> +	}
> +
> +	/*
> +	 * Check to see if the tree needs to be collapsed.
> +	 */
> +	if (retval && (state->path.active > 1)) {
> +		args->dc.flags |= XFS_DC_RM_NODE_BLKS;
> +		error = xfs_da3_join(state);
> +		if (error)
> +			goto out;
> +
> +		return -EAGAIN;
> +	}
> +
> +	/*
> +	 * If the result is small enough, push it all into the inode.
> +	 */
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +		/*
> +		 * Have to get rid of the copy of this dabuf in the state.
> +		 */
> +		ASSERT(state->path.active == 1);
> +		ASSERT(state->path.blk[0].bp);
> +		state->path.blk[0].bp = NULL;
> +
> +		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, &bp);
> +		if (error)
> +			goto out;
> +
> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
> +		if (forkoff) {
> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +			/* bp is gone due to xfs_da_shrink_inode */
> +			if (error)
> +				goto out;
> +		} else
> +			xfs_trans_brelse(args->trans, bp);
> +	}
> +out:
> +	if (state != NULL)
> +		xfs_da_state_free(state);
> +
> +	return error;
> +}
> +
> +/*
> + * Add a name to a Btree-format attribute list.
> + *
> + * This will involve walking down the Btree, and may involve splitting
> + * leaf nodes and even splitting intermediate nodes up to and including
> + * the root node (a special case of an intermediate node).
> + *
> + * "Remote" attribute values confuse the issue and atomic rename operations
> + * add a whole extra layer of confusion on top of that.
> + *
> + * This routine is meant to function as a delayed operation, and may return
> + * -EGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + *returned.
> + */
> +STATIC int
> +xfs_node_addname_later(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_da_state	*state = NULL;
> +	struct xfs_da_state_blk	*blk;
> +	struct xfs_inode	*dp;
> +	int			retval, error = 0;
> +	int			nmap;
> +	struct xfs_bmbt_irec    *map = &args->dc.map;
> +
> +	trace_xfs_attr_node_addname(args);
> +
> +	/*
> +	 * Fill in bucket of arguments/results/context to carry around.
> +	 */
> +	dp = args->dp;
> +
> +	if (args->dc.flags & XFS_DC_FOUND_NBLK)
> +		goto found_blk;
> +
> +	/*
> +	 * Search to see if name already exists, and get back a pointer
> +	 * to where it should go.
> +	 */
> +	retval = xfs_attr_node_hasname(args, &state);
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +		goto out;
> +	} else if (retval == -EEXIST) {
> +		if (args->name.type & ATTR_CREATE)
> +			goto out;
> +
> +		trace_xfs_attr_node_replace(args);
> +
> +		/* save the attribute state for later removal*/
> +		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
> +		args->blkno2 = args->blkno;		/* set 2nd entry info*/
> +		args->index2 = args->index;
> +		args->rmtblkno2 = args->rmtblkno;
> +		args->rmtblkcnt2 = args->rmtblkcnt;
> +		args->rmtvaluelen2 = args->rmtvaluelen;
> +
> +		/*
> +		 * clear the remote attr state now that it is saved so that the
> +		 * values reflect the state of the attribute we are about to
> +		 * add, not the attribute we just found and will remove later.
> +		 */
> +		args->rmtblkno = 0;
> +		args->rmtblkcnt = 0;
> +		args->rmtvaluelen = 0;
> +	}
> +
> +	retval = xfs_attr3_leaf_add(blk->bp, state->args);
> +	if (retval == -ENOSPC) {
> +		if (state->path.active == 1) {
> +			/*
> +			 * Its really a single leaf node, but it had
> +			 * out-of-line values so it looked like it *might*
> +			 * have been a b-tree.
> +			 */
> +			xfs_da_state_free(state);
> +			state = NULL;
> +			error = xfs_attr3_leaf_to_node(args);
> +			if (error)
> +				goto out;
> +
> +			return -EAGAIN;
> +		}
> +
> +		/*
> +		 * Split as many Btree elements as required.
> +		 * This code tracks the new and old attr's location
> +		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
> +		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
> +		 */
> +		error = xfs_da3_split(state);
> +		if (error)
> +			goto out;
> +	} else {
> +		/*
> +		 * Addition succeeded, update Btree hashvals.
> +		 */
> +		xfs_da3_fixhashpath(state, &state->path);
> +	}
> +
> +	/*
> +	 * Kill the state structure, we're done with it and need to
> +	 * allow the buffers to come back later.
> +	 */
> +	xfs_da_state_free(state);
> +	state = NULL;
> +
> +	args->dc.flags |= XFS_DC_FOUND_NBLK;
> +	return -EAGAIN;
> +found_blk:
> +
> +	/*
> +	 * If there was an out-of-line value, allocate the blocks we
> +	 * identified for its storage and copy the value.  This is done
> +	 * after we create the attribute so that we don't overflow the
> +	 * maximum size of a transaction and/or hit a deadlock.
> +	 */
> +	if (args->rmtblkno > 0) {
> +		if (!(args->dc.flags & XFS_DC_ALLOC_NODE)) {
> +			args->dc.flags |= XFS_DC_ALLOC_NODE;
> +			args->dc.lblkno = 0;
> +			args->dc.lfileoff = 0;
> +			args->dc.blkcnt = 0;
> +			args->rmtblkcnt = 0;
> +			args->rmtblkno = 0;
> +			memset(map, 0, sizeof(struct xfs_bmbt_irec));
> +
> +			error = xfs_attr_rmt_find_hole(args);
> +			if (error)
> +				return error;
> +
> +			args->dc.blkcnt = args->rmtblkcnt;
> +			args->dc.lblkno = args->rmtblkno;
> +		}
> +		/*
> +		 * Roll through the "value", allocating blocks on disk as
> +		 * required.
> +		 */
> +		while (args->dc.blkcnt > 0) {
> +			nmap = 1;
> +			error = xfs_bmapi_write(args->trans, dp,
> +				(xfs_fileoff_t)args->dc.lblkno, args->dc.blkcnt,
> +				XFS_BMAPI_ATTRFORK, args->total, map, &nmap);
> +			if (error)
> +				return error;
> +
> +			ASSERT(nmap == 1);
> +			ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
> +			       (map->br_startblock != HOLESTARTBLOCK));
> +
> +			/* roll attribute extent map forwards */
> +			args->dc.lblkno += map->br_blockcount;
> +			args->dc.blkcnt -= map->br_blockcount;
> +
> +			return -EAGAIN;
> +		}
> +
> +		error = xfs_attr_rmtval_set_value(args);
> +		if (error)
> +			return error;
> +	}
> +
> +	if (args->rmtblkno > 0) {
> +		/*
> +		 * Added a "remote" value, just clear the incomplete flag.
> +		 */
> +		error = xfs_attr3_leaf_clearflag(args);
> +		if (error)
> +			goto out;
> +	}
> +	retval = error = 0;
> +
> +out:
> +	if (state)
> +		xfs_da_state_free(state);
> +	if (error)
> +		return error;
> +
> +	return retval;
> +}
> +
> +
> +
> +/*
>   * Fill in the disk block numbers in the state structure for the buffers
>   * that are attached to the state structure.
>   * This is done so that we can quickly reattach ourselves to those buffers
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index fb56d81..6203766 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -149,9 +149,11 @@ int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
>  int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
>  		 unsigned char *value, int valuelen);
>  int xfs_attr_set_args(struct xfs_da_args *args);
> +int xfs_attr_set_later(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
>  int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
> +int xfs_attr_remove_later(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> -- 
> 2.7.4
> 
