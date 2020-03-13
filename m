Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A87C2BB1D
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 14:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1A6320746
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 14:49:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cyzGN4eY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgCMOtu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 10:49:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37550 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgCMOtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 10:49:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584110988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r61CM5Wyt3WlhMHMgde+CNzTaf9xjCLlwr/8/Dui1yM=;
        b=cyzGN4eYKDL//sJb+dn/b5bPQGzIv8OAb4HGQwhoefzv/w8OWhIAe+UTKdc6dMpznNqYmP
        vHM+umPMWHJadWStCMFu0P1SZvqExg3+PAdU4DqEeD++ac3+v4vzC6KC6maFydRL1Gm18a
        dQAs/qTApJ0R+gIRyuIgHsQS/2KgeeY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-PZekbHpEMrWtLOEXJINAcg-1; Fri, 13 Mar 2020 10:49:46 -0400
X-MC-Unique: PZekbHpEMrWtLOEXJINAcg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EBE3800D48;
        Fri, 13 Mar 2020 14:49:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3614A5DA2C;
        Fri, 13 Mar 2020 14:49:45 +0000 (UTC)
Date:   Fri, 13 Mar 2020 10:49:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: support bulk loading of staged btrees
Message-ID: <20200313144943.GC11929@bfoster>
References: <158398473036.1308059.18353233923283406961.stgit@magnolia>
 <158398474975.1308059.5474941693856744742.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158398474975.1308059.5474941693856744742.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 08:45:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new btree function that enables us to bulk load a btree cursor.
> This will be used by the upcoming online repair patches to generate new
> btrees.  This avoids the programmatic inefficiency of calling
> xfs_btree_insert in a loop (which generates a lot of log traffic) in
> favor of stamping out new btree blocks with ordered buffers, and then
> committing both the new root and scheduling the removal of the old btree
> blocks in a single transaction commit.
> 
> The design of this new generic code is based off the btree rebuilding
> code in xfs_repair's phase 5 code, with the explicit goal of enabling us
> to share that code between scrub and repair.  It has the additional
> feature of being able to control btree block loading factors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

The code mostly looks fine to me. A few nits around comments and such
below. With those fixed up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_btree.c |  604 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_btree.h |   68 +++++
>  fs/xfs/xfs_trace.c        |    1 
>  fs/xfs/xfs_trace.h        |   85 ++++++
>  4 files changed, 757 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 4e1d4f184d4b..d579d8e99046 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -1324,7 +1324,7 @@ STATIC void
>  xfs_btree_copy_ptrs(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_ptr	*dst_ptr,
> -	union xfs_btree_ptr	*src_ptr,
> +	const union xfs_btree_ptr *src_ptr,
>  	int			numptrs)
>  {
>  	ASSERT(numptrs >= 0);
> @@ -5179,3 +5179,605 @@ xfs_btree_commit_ifakeroot(
>  	cur->bc_flags &= ~XFS_BTREE_STAGING;
>  	cur->bc_tp = tp;
>  }
> +
...
> +/*
> + * Put a btree block that we're loading onto the ordered list and release it.
> + * The btree blocks will be written to disk when bulk loading is finished.
> + */
> +static void
> +xfs_btree_bload_drop_buf(
> +	struct list_head	*buffers_list,
> +	struct xfs_buf		**bpp)
> +{
> +	if (*bpp == NULL)
> +		return;
> +
> +	xfs_buf_delwri_queue(*bpp, buffers_list);

Might want to do something like the following here, given there is no
error path:

	if (!xfs_buf_delwri_queue(...))
		ASSERT(0);

> +	xfs_buf_relse(*bpp);
> +	*bpp = NULL;
> +}
> +
> +/*
> + * Allocate and initialize one btree block for bulk loading.
> + *
> + * The new btree block will have its level and numrecs fields set to the values
> + * of the level and nr_this_block parameters, respectively.  On exit, ptrp,
> + * bpp, and blockp will all point to the new block.
> + */
> +STATIC int
> +xfs_btree_bload_prep_block(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_btree_bload		*bbl,
> +	unsigned int			level,
> +	unsigned int			nr_this_block,
> +	union xfs_btree_ptr		*ptrp,
> +	struct xfs_buf			**bpp,
> +	struct xfs_btree_block		**blockp,
> +	void				*priv)

The header comment doesn't mention that ptrp and blockp are input values
as well. I'd expect inline comments for the certain parameters that have
non-obvious uses. Something like the following for example:

	union xfs_btree_ptr		*ptrp,	/* in: prev ptr, out: current */
	...
	struct xfs_btree_block		*blockp, /* in: prev block, out: current */

> +{
> +	union xfs_btree_ptr		new_ptr;
> +	struct xfs_buf			*new_bp;
> +	struct xfs_btree_block		*new_block;
> +	int				ret;
> +
> +	ASSERT(*bpp == NULL);
> +
> +	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> +	    level == cur->bc_nlevels - 1) {
> +		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
> +		size_t			new_size;
> +
> +		/* Allocate a new incore btree root block. */
> +		new_size = bbl->iroot_size(cur, nr_this_block, priv);
> +		ifp->if_broot = kmem_zalloc(new_size, 0);
> +		ifp->if_broot_bytes = (int)new_size;
> +		ifp->if_flags |= XFS_IFBROOT;
> +
> +		/* Initialize it and send it out. */
> +		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
> +				XFS_BUF_DADDR_NULL, cur->bc_btnum, level,
> +				nr_this_block, cur->bc_ino.ip->i_ino,
> +				cur->bc_flags);
> +
> +		*bpp = NULL;
> +		*blockp = ifp->if_broot;
> +		xfs_btree_set_ptr_null(cur, ptrp);
> +		return 0;
> +	}
> +
> +	/* Claim one of the caller's preallocated blocks. */
> +	xfs_btree_set_ptr_null(cur, &new_ptr);
> +	ret = bbl->claim_block(cur, &new_ptr, priv);
> +	if (ret)
> +		return ret;
> +
> +	ASSERT(!xfs_btree_ptr_is_null(cur, &new_ptr));
> +
> +	ret = xfs_btree_get_buf_block(cur, &new_ptr, &new_block, &new_bp);
> +	if (ret)
> +		return ret;
> +
> +	/* Initialize the btree block. */
> +	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);
> +	if (*blockp)
> +		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
> +	xfs_btree_set_sibling(cur, new_block, ptrp, XFS_BB_LEFTSIB);
> +
> +	/* Set the out parameters. */
> +	*bpp = new_bp;
> +	*blockp = new_block;
> +	xfs_btree_copy_ptrs(cur, ptrp, &new_ptr, 1);
> +	return 0;
> +}
...
> +/*
> + * Prepare a btree cursor for a bulk load operation by computing the geometry
> + * fields in bbl.  Caller must ensure that the btree cursor is a staging
> + * cursor.  This function can be called multiple times.
> + */
> +int
> +xfs_btree_bload_compute_geometry(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_btree_bload	*bbl,
> +	uint64_t		nr_records)
> +{
> +	uint64_t		nr_blocks = 0;
> +	uint64_t		nr_this_level;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	/*
> +	 * Make sure that the slack values make sense for btree blocks that are
> +	 * full disk blocks.  We do this by setting the btree nlevels to 3,
> +	 * because inode-rooted btrees will return different minrecs/maxrecs
> +	 * values for the root block.  Note that slack settings are not applied
> +	 * to inode roots.
> +	 */
> +	cur->bc_nlevels = 3;

I still find the wording of the comment a little confusing...

"Make sure the slack values make sense for leaf and node blocks.
Inode-rooted btrees return different geometry for the root block (when
->bc_nlevels == level - 1). We're checking levels 0 and 1 here, so set
->bc_nlevels such that btree code doesn't interpret either as the root
level."

BTW.. I also wonder if just setting XFS_BTREE_MAXLEVELS-1 would be more
clear than 3?

> +	xfs_btree_bload_ensure_slack(cur, &bbl->leaf_slack, 0);
> +	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
> +
> +	bbl->nr_records = nr_this_level = nr_records;
> +	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
> +		uint64_t	level_blocks;
> +		uint64_t	dontcare64;
> +		unsigned int	level = cur->bc_nlevels - 1;
> +		unsigned int	avg_per_block;
> +
> +		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> +				&avg_per_block, &level_blocks, &dontcare64);
> +
> +		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
> +			/*
> +			 * If all the items we want to store at this level
> +			 * would fit in the inode root block, then we have our
> +			 * btree root and are done.
> +			 *
> +			 * Note that bmap btrees forbid records in the root.
> +			 */
> +			if (level != 0 && nr_this_level <= avg_per_block) {
> +				nr_blocks++;
> +				break;
> +			}
> +
> +			/*
> +			 * Otherwise, we have to store all the items for this
> +			 * level in traditional btree blocks and therefore need
> +			 * another level of btree to point to those blocks.
> +			 *
> +			 * We have to re-compute the geometry for each level of
> +			 * an inode-rooted btree because the geometry differs
> +			 * between a btree root in an inode fork and a
> +			 * traditional btree block.
> +			 *
> +			 * This distinction is made in the btree code based on
> +			 * whether level == bc_nlevels - 1.  Based on the
> +			 * previous root block size check against the root
> +			 * block geometry, we know that we aren't yet ready to
> +			 * populate the root.  Increment bc_nevels and
> +			 * recalculate the geometry for a traditional
> +			 * block-based btree level.
> +			 */
> +			cur->bc_nlevels++;
> +			xfs_btree_bload_level_geometry(cur, bbl, level,
> +					nr_this_level, &avg_per_block,
> +					&level_blocks, &dontcare64);
> +		} else {
> +			/*
> +			 * If all the items we want to store at this level
> +			 * would fit in a single root block, we're done.
> +			 */
> +			if (nr_this_level <= avg_per_block) {
> +				nr_blocks++;
> +				break;
> +			}
> +
> +			/* Otherwise, we need another level of btree. */
> +			cur->bc_nlevels++;
> +		}
> +
> +		nr_blocks += level_blocks;
> +		nr_this_level = level_blocks;
> +	}
> +
> +	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
> +		return -EOVERFLOW;
> +
> +	bbl->btree_height = cur->bc_nlevels;
> +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> +		bbl->nr_blocks = nr_blocks - 1;
> +	else
> +		bbl->nr_blocks = nr_blocks;
> +	return 0;
> +}
> +
> +/* Bulk load a btree given the parameters and geometry established in bbl. */
> +int
> +xfs_btree_bload(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_btree_bload		*bbl,
> +	void				*priv)
> +{
> +	struct list_head		buffers_list;
> +	union xfs_btree_ptr		child_ptr;
> +	union xfs_btree_ptr		ptr;
> +	struct xfs_buf			*bp = NULL;
> +	struct xfs_btree_block		*block = NULL;
> +	uint64_t			nr_this_level = bbl->nr_records;
> +	uint64_t			blocks;
> +	uint64_t			i;
> +	uint64_t			blocks_with_extra;
> +	uint64_t			total_blocks = 0;
> +	unsigned int			avg_per_block;
> +	unsigned int			level = 0;
> +	int				ret;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> +
> +	INIT_LIST_HEAD(&buffers_list);
> +	cur->bc_nlevels = bbl->btree_height;
> +	xfs_btree_set_ptr_null(cur, &child_ptr);
> +	xfs_btree_set_ptr_null(cur, &ptr);
> +
> +	xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> +			&avg_per_block, &blocks, &blocks_with_extra);
> +
> +	/* Load each leaf block. */
> +	for (i = 0; i < blocks; i++) {
> +		unsigned int		nr_this_block = avg_per_block;
> +
> +		if (i < blocks_with_extra)
> +			nr_this_block++;

The blocks_with_extra thing kind of confused me until I made it through
the related functions. A brief comment would be helpful here, just to
explain what's going on in the high level context. I.e.:

"btree blocks will not be evenly populated in most cases.
blocks_with_extra tells us how many blocks get an extra record to evenly
distribute the excess across the current level."

Brian

> +
> +		xfs_btree_bload_drop_buf(&buffers_list, &bp);
> +
> +		ret = xfs_btree_bload_prep_block(cur, bbl, level,
> +				nr_this_block, &ptr, &bp, &block, priv);
> +		if (ret)
> +			goto out;
> +
> +		trace_xfs_btree_bload_block(cur, level, i, blocks, &ptr,
> +				nr_this_block);
> +
> +		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_record,
> +				block, priv);
> +		if (ret)
> +			goto out;
> +
> +		/*
> +		 * Record the leftmost leaf pointer so we know where to start
> +		 * with the first node level.
> +		 */
> +		if (i == 0)
> +			xfs_btree_copy_ptrs(cur, &child_ptr, &ptr, 1);
> +	}
> +	total_blocks += blocks;
> +	xfs_btree_bload_drop_buf(&buffers_list, &bp);
> +
> +	/* Populate the internal btree nodes. */
> +	for (level = 1; level < cur->bc_nlevels; level++) {
> +		union xfs_btree_ptr	first_ptr;
> +
> +		nr_this_level = blocks;
> +		block = NULL;
> +		xfs_btree_set_ptr_null(cur, &ptr);
> +
> +		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> +				&avg_per_block, &blocks, &blocks_with_extra);
> +
> +		/* Load each node block. */
> +		for (i = 0; i < blocks; i++) {
> +			unsigned int	nr_this_block = avg_per_block;
> +
> +			if (i < blocks_with_extra)
> +				nr_this_block++;
> +
> +			xfs_btree_bload_drop_buf(&buffers_list, &bp);
> +
> +			ret = xfs_btree_bload_prep_block(cur, bbl, level,
> +					nr_this_block, &ptr, &bp, &block,
> +					priv);
> +			if (ret)
> +				goto out;
> +
> +			trace_xfs_btree_bload_block(cur, level, i, blocks,
> +					&ptr, nr_this_block);
> +
> +			ret = xfs_btree_bload_node(cur, nr_this_block,
> +					&child_ptr, block);
> +			if (ret)
> +				goto out;
> +
> +			/*
> +			 * Record the leftmost node pointer so that we know
> +			 * where to start the next node level above this one.
> +			 */
> +			if (i == 0)
> +				xfs_btree_copy_ptrs(cur, &first_ptr, &ptr, 1);
> +		}
> +		total_blocks += blocks;
> +		xfs_btree_bload_drop_buf(&buffers_list, &bp);
> +		xfs_btree_copy_ptrs(cur, &child_ptr, &first_ptr, 1);
> +	}
> +
> +	/* Initialize the new root. */
> +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
> +		ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
> +		cur->bc_ino.ifake->if_levels = cur->bc_nlevels;
> +		cur->bc_ino.ifake->if_blocks = total_blocks - 1;
> +	} else {
> +		cur->bc_ag.afake->af_root = be32_to_cpu(ptr.s);
> +		cur->bc_ag.afake->af_levels = cur->bc_nlevels;
> +		cur->bc_ag.afake->af_blocks = total_blocks;
> +	}
> +
> +	/*
> +	 * Write the new blocks to disk.  If the ordered list isn't empty after
> +	 * that, then something went wrong and we have to fail.  This should
> +	 * never happen, but we'll check anyway.
> +	 */
> +	ret = xfs_buf_delwri_submit(&buffers_list);
> +	if (ret)
> +		goto out;
> +	if (!list_empty(&buffers_list)) {
> +		ASSERT(list_empty(&buffers_list));
> +		ret = -EIO;
> +	}
> +
> +out:
> +	xfs_buf_delwri_cancel(&buffers_list);
> +	if (bp)
> +		xfs_buf_relse(bp);
> +	return ret;
> +}
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 047067f52063..c2de439a6f0d 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -574,4 +574,72 @@ void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
>  void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
>  		int whichfork, const struct xfs_btree_ops *ops);
>  
> +/* Bulk loading of staged btrees. */
> +typedef int (*xfs_btree_bload_get_record_fn)(struct xfs_btree_cur *cur, void *priv);
> +typedef int (*xfs_btree_bload_claim_block_fn)(struct xfs_btree_cur *cur,
> +		union xfs_btree_ptr *ptr, void *priv);
> +typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
> +		unsigned int nr_this_level, void *priv);
> +
> +struct xfs_btree_bload {
> +	/*
> +	 * This function will be called nr_records times to load records into
> +	 * the btree.  The function does this by setting the cursor's bc_rec
> +	 * field in in-core format.  Records must be returned in sort order.
> +	 */
> +	xfs_btree_bload_get_record_fn	get_record;
> +
> +	/*
> +	 * This function will be called nr_blocks times to obtain a pointer
> +	 * to a new btree block on disk.  Callers must preallocate all space
> +	 * for the new btree before calling xfs_btree_bload, and this function
> +	 * is what claims that reservation.
> +	 */
> +	xfs_btree_bload_claim_block_fn	claim_block;
> +
> +	/*
> +	 * This function should return the size of the in-core btree root
> +	 * block.  It is only necessary for XFS_BTREE_ROOT_IN_INODE btree
> +	 * types.
> +	 */
> +	xfs_btree_bload_iroot_size_fn	iroot_size;
> +
> +	/*
> +	 * The caller should set this to the number of records that will be
> +	 * stored in the new btree.
> +	 */
> +	uint64_t			nr_records;
> +
> +	/*
> +	 * Number of free records to leave in each leaf block.  If the caller
> +	 * sets this to -1, the slack value will be calculated to be be halfway
> +	 * between maxrecs and minrecs.  This typically leaves the block 75%
> +	 * full.  Note that slack values are not enforced on inode root blocks.
> +	 */
> +	int				leaf_slack;
> +
> +	/*
> +	 * Number of free key/ptrs pairs to leave in each node block.  This
> +	 * field has the same semantics as leaf_slack.
> +	 */
> +	int				node_slack;
> +
> +	/*
> +	 * The xfs_btree_bload_compute_geometry function will set this to the
> +	 * number of btree blocks needed to store nr_records records.
> +	 */
> +	uint64_t			nr_blocks;
> +
> +	/*
> +	 * The xfs_btree_bload_compute_geometry function will set this to the
> +	 * height of the new btree.
> +	 */
> +	unsigned int			btree_height;
> +};
> +
> +int xfs_btree_bload_compute_geometry(struct xfs_btree_cur *cur,
> +		struct xfs_btree_bload *bbl, uint64_t nr_records);
> +int xfs_btree_bload(struct xfs_btree_cur *cur, struct xfs_btree_bload *bbl,
> +		void *priv);
> +
>  #endif	/* __XFS_BTREE_H__ */
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index bc85b89f88ca..9b5e58a92381 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -6,6 +6,7 @@
>  #include "xfs.h"
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
> +#include "xfs_bit.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 05db0398f040..efc7751550d9 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -35,6 +35,7 @@ struct xfs_icreate_log;
>  struct xfs_owner_info;
>  struct xfs_trans_res;
>  struct xfs_inobt_rec_incore;
> +union xfs_btree_ptr;
>  
>  #define XFS_ATTR_FILTER_FLAGS \
>  	{ XFS_ATTR_ROOT,	"ROOT" }, \
> @@ -3666,6 +3667,90 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
>  		  __entry->blocks)
>  )
>  
> +TRACE_EVENT(xfs_btree_bload_level_geometry,
> +	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
> +		 uint64_t nr_this_level, unsigned int nr_per_block,
> +		 unsigned int desired_npb, uint64_t blocks,
> +		 uint64_t blocks_with_extra),
> +	TP_ARGS(cur, level, nr_this_level, nr_per_block, desired_npb, blocks,
> +		blocks_with_extra),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_btnum_t, btnum)
> +		__field(unsigned int, level)
> +		__field(unsigned int, nlevels)
> +		__field(uint64_t, nr_this_level)
> +		__field(unsigned int, nr_per_block)
> +		__field(unsigned int, desired_npb)
> +		__field(unsigned long long, blocks)
> +		__field(unsigned long long, blocks_with_extra)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = cur->bc_mp->m_super->s_dev;
> +		__entry->btnum = cur->bc_btnum;
> +		__entry->level = level;
> +		__entry->nlevels = cur->bc_nlevels;
> +		__entry->nr_this_level = nr_this_level;
> +		__entry->nr_per_block = nr_per_block;
> +		__entry->desired_npb = desired_npb;
> +		__entry->blocks = blocks;
> +		__entry->blocks_with_extra = blocks_with_extra;
> +	),
> +	TP_printk("dev %d:%d btree %s level %u/%u nr_this_level %llu nr_per_block %u desired_npb %u blocks %llu blocks_with_extra %llu",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> +		  __entry->level,
> +		  __entry->nlevels,
> +		  __entry->nr_this_level,
> +		  __entry->nr_per_block,
> +		  __entry->desired_npb,
> +		  __entry->blocks,
> +		  __entry->blocks_with_extra)
> +)
> +
> +TRACE_EVENT(xfs_btree_bload_block,
> +	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
> +		 uint64_t block_idx, uint64_t nr_blocks,
> +		 union xfs_btree_ptr *ptr, unsigned int nr_records),
> +	TP_ARGS(cur, level, block_idx, nr_blocks, ptr, nr_records),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_btnum_t, btnum)
> +		__field(unsigned int, level)
> +		__field(unsigned long long, block_idx)
> +		__field(unsigned long long, nr_blocks)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agblock_t, agbno)
> +		__field(unsigned int, nr_records)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = cur->bc_mp->m_super->s_dev;
> +		__entry->btnum = cur->bc_btnum;
> +		__entry->level = level;
> +		__entry->block_idx = block_idx;
> +		__entry->nr_blocks = nr_blocks;
> +		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> +			xfs_fsblock_t	fsb = be64_to_cpu(ptr->l);
> +
> +			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);
> +			__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsb);
> +		} else {
> +			__entry->agno = cur->bc_ag.agno;
> +			__entry->agbno = be32_to_cpu(ptr->s);
> +		}
> +		__entry->nr_records = nr_records;
> +	),
> +	TP_printk("dev %d:%d btree %s level %u block %llu/%llu fsb (%u/%u) recs %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> +		  __entry->level,
> +		  __entry->block_idx,
> +		  __entry->nr_blocks,
> +		  __entry->agno,
> +		  __entry->agbno,
> +		  __entry->nr_records)
> +)
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 

