Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CDAC10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95CF020848
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:22:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H3I0Jj8k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgCFOW7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:22:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55376 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726090AbgCFOW6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:22:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583504576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=usboZiUncbj7Gsol8/FaAgiDP76K3PMiQPnI8DkXsbA=;
        b=H3I0Jj8kOQ7xMpOyOg9su/CLN3uhmvAtJahMjudfUL9aMS0QbM7VNdrV9/JnRRWZ7yN5Ar
        P9EJJx8GI9MxFCnEghhv9ttQKIUu56Hcroo7xrHaLS0xrICHuOLa5XsWjxfy8KNmmWtyLe
        Jvrem9h3V/2B2G+g7K0BhfCuBjZIkfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-pqajC0S1PR6DHvIzwtrKKg-1; Fri, 06 Mar 2020 09:22:54 -0500
X-MC-Unique: pqajC0S1PR6DHvIzwtrKKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7014218C8C01;
        Fri,  6 Mar 2020 14:22:53 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAE6C5D9CD;
        Fri,  6 Mar 2020 14:22:52 +0000 (UTC)
Date:   Fri, 6 Mar 2020 09:22:50 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: support bulk loading of staged btrees
Message-ID: <20200306142250.GB2773@bfoster>
References: <158329250190.2423432.16958662769192587982.stgit@magnolia>
 <158329252104.2423432.14412164596264053619.stgit@magnolia>
 <20200304182144.GC22037@bfoster>
 <20200305012213.GL8045@magnolia>
 <20200305143029.GB27418@bfoster>
 <20200305181329.GU8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305181329.GU8045@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 10:13:29AM -0800, Darrick J. Wong wrote:
> On Thu, Mar 05, 2020 at 09:30:29AM -0500, Brian Foster wrote:
> > On Wed, Mar 04, 2020 at 05:22:13PM -0800, Darrick J. Wong wrote:
> > > On Wed, Mar 04, 2020 at 01:21:44PM -0500, Brian Foster wrote:
> > > > On Tue, Mar 03, 2020 at 07:28:41PM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > Add a new btree function that enables us to bulk load a btree cursor.
> > > > > This will be used by the upcoming online repair patches to generate new
> > > > > btrees.  This avoids the programmatic inefficiency of calling
> > > > > xfs_btree_insert in a loop (which generates a lot of log traffic) in
> > > > > favor of stamping out new btree blocks with ordered buffers, and then
> > > > > committing both the new root and scheduling the removal of the old btree
> > > > > blocks in a single transaction commit.
> > > > > 
> > > > > The design of this new generic code is based off the btree rebuilding
> > > > > code in xfs_repair's phase 5 code, with the explicit goal of enabling us
> > > > > to share that code between scrub and repair.  It has the additional
> > > > > feature of being able to control btree block loading factors.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_btree.c |  581 +++++++++++++++++++++++++++++++++++++++++++++
> > > > >  fs/xfs/libxfs/xfs_btree.h |   46 ++++
> > > > >  fs/xfs/xfs_trace.c        |    1 
> > > > >  fs/xfs/xfs_trace.h        |   85 +++++++
> > > > >  4 files changed, 712 insertions(+), 1 deletion(-)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > > > index 469e1e9053bb..c21db7ed8481 100644
> > > > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > > > +++ b/fs/xfs/libxfs/xfs_btree.c
...
> > > > > +	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
> > > > > +		uint64_t	level_blocks;
> > > > > +		uint64_t	dontcare64;
> > > > > +		unsigned int	level = cur->bc_nlevels - 1;
> > > > > +		unsigned int	avg_per_block;
> > > > > +
> > > > > +		/*
> > > > > +		 * If all the things we want to store at this level would fit
> > > > > +		 * in a single root block, then we have our btree root and are
> > > > > +		 * done.  Note that bmap btrees do not allow records in the
> > > > > +		 * root.
> > > > > +		 */
> > > > > +		if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) || level != 0) {
> > > > > +			xfs_btree_bload_level_geometry(cur, bbl, level,
> > > > > +					nr_this_level, &avg_per_block,
> > > > > +					&level_blocks, &dontcare64);
> > > > > +			if (nr_this_level <= avg_per_block) {
> > > > > +				nr_blocks++;
> > > > > +				break;
> > > > > +			}
> > > > > +		}
> > > > > +
> > > > > +		/*
> > > > > +		 * Otherwise, we have to store all the records for this level
> > > > > +		 * in blocks and therefore need another level of btree to point
> > > > > +		 * to those blocks.  Increase the number of levels and
> > > > > +		 * recompute the number of records we can store at this level
> > > > > +		 * because that can change depending on whether or not a level
> > > > > +		 * is the root level.
> > > > > +		 */
> > > > > +		cur->bc_nlevels++;
> > > > 
> > > > Hmm.. so does the ->bc_nlevels increment affect the
> > > > _bload_level_geometry() call or is it just part of the loop iteration?
> > > > If the latter, can these two _bload_level_geometry() calls be combined?
> > > 
> > > It affects the xfs_btree_bload_level_geometry call because that calls
> > > ->get_maxrecs(), which returns a different answer for the root level
> > > when the root is an inode fork.  Therefore, we cannot combine the calls.
> > > 
> > 
> > Hmm.. but doesn't this cause double calls for other cases? I.e. for
> > non-inode rooted trees it looks like we call the function once, check
> > the avg_per_block and then potentially call it again until we get to the
> > root block. Confused.. :/
> 
> Yes, we do end up computing the geometry twice per level, which frees
> the bulkload code from having to know anything at all about the
> relationship between bc_nlevels and specific behaviors of some of the
> ->maxrecs functions.
> 

Sort of.. I think the pattern is odd enough that the fact it needs to
accommodate this special case kind of bleeds through even though it
isn't explicit.

> I guess you could do:
> 
> 	xfs_btree_bload_level_geometry(...)
> 
> 	if ((!ROOT_IN_INODE || level != 0) ** nr_this_level <= avg_per_block) {
> 		nr_blocks++
> 		break
> 	}
> 
> 	nlevels++
> 
> 	if (ROOT_IN_INODE) {
> 		xfs_btree_bload_level_geometry(...)
> 	}
> 
> 	nr_blocks += level_blocks
> 	nr_this_level = level_blocks
> 
> ...which would be slightly more efficient for AG btrees, though my
> crappy perf trace showed that the overhead for the _level_geometry()
> calls is ~0.4% even for a huge ugly rmap btree because most of the time
> gets spent in the delwri_submit_buffers at the end.
> 

It wasn't primarily a performance concern rather than a "this sure looks
like we call the function twice per loop for no reason" comment.
Something like the above might be more clear, but I need to make sure I
understand this loop first...

Having stared at this some more, I _think_ I understand why this is
written as such. For the non-inode rooted case, the double call is
basically unnecessary so the whole loop could look something like this
(if we factored out the bmbt case):

	for (cur->bc_nlevels = 1; ...) {
		xfs_btree_bload_level_geometry(...);
		if (nr_this_level <= avg_per_block) {
			nr_blocks++;
			break;
		}
		cur->bc_nlevels++;
		nr_this_level = level_blocks;
	}

Is that correct?

The bmbt case has these special cases where 1.) the bmbt root must be a
node block (not a leaf) and 2.) the root block has different size rules
than a typical node block because it's in the inode fork. The former
seems straightforward and explains the level != 0 check. The latter is
detected by the (level == ->bc_nlevels - 1) condition down in the
maxrecs code, so that means the order of ->bc_nlevels++ increment with
respect to the geometry call affects whether we check for a potential
bmbt root or regular node block (assuming level != 0). Hence, the bottom
part of the loop does the increment first and makes the geometry call
again... Am I following that correctly?

If so, I think at the very least the existing comments should start by
explaining the intentional construction of the loop and subtle ordering
requirements between ->bc_nlevels and the geometry calls for the bmbt.
In staring at it a bit more, I find something like the following more
clear even though it is more verbose:

       for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
                ...
                xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
                                               &avg_per_block,&level_blocks,
                                               &dontcare64);
                if (<inode rooted>) {
                        /* bmbt root must be node format, skip check for level 0 */
                        if (level != 0 && nr_this_level <= avg_per_block) {
                                nr_blocks++;
                                break;
                        }
                        /*
			 * We have to calculate geometry for each bmbt level
			 * twice because there is a distinction between a bmbt
			 * root in an inode fork and a traditional node block.
			 * This distinction is made in the btree code based on
			 * whether level == ->bc_nlevels - 1. We aren't yet at
			 * the root, so bump ->bc_nevels and recalculate
			 * geometry for a traditional node block tree level.
                         */
                        cur->bc_nlevels++;
                        xfs_btree_bload_level_geometry();
                } else {
                        if (nr_this_level <= avg_per_block) {
                                nr_blocks++;
                                break;
                        }
                        cur->bc_nlevels++;
                }

                nr_blocks += level_blocks;
                nr_this_level = level_blocks;
        }

The comments and whatnot could use massaging and perhaps it would still
be fine to factor out the root block check from the if/else, but that
illustrates the idea. Thoughts?

Brian

> --D
> 
> > Brian
> > 
> > > > 
> > > > > +		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> > > > > +				&avg_per_block, &level_blocks, &dontcare64);
> > > > > +		nr_blocks += level_blocks;
> > > > > +		nr_this_level = level_blocks;
> > > > > +	}
> > > > > +
> > > > > +	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
> > > > > +		return -EOVERFLOW;
> > > > > +
> > > > > +	bbl->btree_height = cur->bc_nlevels;
> > > > > +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> > > > > +		bbl->nr_blocks = nr_blocks - 1;
> > > > > +	else
> > > > > +		bbl->nr_blocks = nr_blocks;
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Bulk load a btree.
> > > > > + *
> > > > > + * Load @bbl->nr_records quantity of records into a btree using the supplied
> > > > > + * empty and staging btree cursor @cur and a @bbl that has been filled out by
> > > > > + * the xfs_btree_bload_compute_geometry function.
> > > > > + *
> > > > > + * The @bbl->get_data function must populate the cursor's bc_rec every time it
> > > > > + * is called.  The @bbl->alloc_block function will be used to allocate new
> > > > > + * btree blocks.  @priv is passed to both functions.
> > > > > + *
> > > > > + * Caller must ensure that @cur is a staging cursor.  Any existing btree rooted
> > > > > + * in the fakeroot will be lost, so do not call this function twice.
> > > > > + */
> > > > > +int
> > > > > +xfs_btree_bload(
> > > > > +	struct xfs_btree_cur		*cur,
> > > > > +	struct xfs_btree_bload		*bbl,
> > > > > +	void				*priv)
> > > > > +{
> > > > > +	union xfs_btree_ptr		child_ptr;
> > > > > +	union xfs_btree_ptr		ptr;
> > > > > +	struct xfs_buf			*bp = NULL;
> > > > > +	struct xfs_btree_block		*block = NULL;
> > > > > +	uint64_t			nr_this_level = bbl->nr_records;
> > > > > +	uint64_t			blocks;
> > > > > +	uint64_t			i;
> > > > > +	uint64_t			blocks_with_extra;
> > > > > +	uint64_t			total_blocks = 0;
> > > > > +	unsigned int			avg_per_block;
> > > > > +	unsigned int			level = 0;
> > > > > +	int				ret;
> > > > > +
> > > > > +	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
> > > > > +
> > > > > +	INIT_LIST_HEAD(&bbl->buffers_list);
> > > > > +	cur->bc_nlevels = bbl->btree_height;
> > > > > +	xfs_btree_set_ptr_null(cur, &child_ptr);
> > > > > +	xfs_btree_set_ptr_null(cur, &ptr);
> > > > > +
> > > > > +	xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> > > > > +			&avg_per_block, &blocks, &blocks_with_extra);
> > > > > +
> > > > > +	/* Load each leaf block. */
> > > > > +	for (i = 0; i < blocks; i++) {
> > > > > +		unsigned int		nr_this_block = avg_per_block;
> > > > > +
> > > > > +		if (i < blocks_with_extra)
> > > > > +			nr_this_block++;
> > > > > +
> > > > > +		ret = xfs_btree_bload_prep_block(cur, bbl, level,
> > > > > +				nr_this_block, &ptr, &bp, &block, priv);
> > > > > +		if (ret)
> > > > > +			return ret;
> > > > > +
> > > > > +		trace_xfs_btree_bload_block(cur, level, i, blocks, &ptr,
> > > > > +				nr_this_block);
> > > > > +
> > > > > +		ret = xfs_btree_bload_leaf(cur, nr_this_block, bbl->get_data,
> > > > > +				block, priv);
> > > > > +		if (ret)
> > > > > +			goto out;
> > > > > +
> > > > > +		/* Record the leftmost pointer to start the next level. */
> > > > > +		if (i == 0)
> > > > > +			xfs_btree_copy_ptrs(cur, &child_ptr, &ptr, 1);
> > > > 
> > > > "leftmost pointer" refers to the leftmost leaf block..?
> > > 
> > > Yes.  "Record the leftmost leaf pointer so we know where to start with
> > > the first node level." ?
> > > 
> > > > > +	}
> > > > > +	total_blocks += blocks;
> > > > > +	xfs_btree_bload_drop_buf(bbl, cur->bc_tp, &bp);
> > > > > +
> > > > > +	/* Populate the internal btree nodes. */
> > > > > +	for (level = 1; level < cur->bc_nlevels; level++) {
> > > > > +		union xfs_btree_ptr	first_ptr;
> > > > > +
> > > > > +		nr_this_level = blocks;
> > > > > +		block = NULL;
> > > > > +		xfs_btree_set_ptr_null(cur, &ptr);
> > > > > +
> > > > > +		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
> > > > > +				&avg_per_block, &blocks, &blocks_with_extra);
> > > > > +
> > > > > +		/* Load each node block. */
> > > > > +		for (i = 0; i < blocks; i++) {
> > > > > +			unsigned int	nr_this_block = avg_per_block;
> > > > > +
> > > > > +			if (i < blocks_with_extra)
> > > > > +				nr_this_block++;
> > > > > +
> > > > > +			ret = xfs_btree_bload_prep_block(cur, bbl, level,
> > > > > +					nr_this_block, &ptr, &bp, &block,
> > > > > +					priv);
> > > > > +			if (ret)
> > > > > +				return ret;
> > > > > +
> > > > > +			trace_xfs_btree_bload_block(cur, level, i, blocks,
> > > > > +					&ptr, nr_this_block);
> > > > > +
> > > > > +			ret = xfs_btree_bload_node(cur, nr_this_block,
> > > > > +					&child_ptr, block);
> > > > > +			if (ret)
> > > > > +				goto out;
> > > > > +
> > > > > +			/*
> > > > > +			 * Record the leftmost pointer to start the next level.
> > > > > +			 */
> > > > 
> > > > And the same thing here. I think the generic ptr name is a little
> > > > confusing, though I don't have a better suggestion. I think it would
> > > > help if the comments were more explicit to say something like: "ptr
> > > > refers to the current block addr. Save the first block in the current
> > > > level so the next level up knows where to start looking for keys."
> > > 
> > > Yes, I'll do that:
> > > 
> > > "Record the leftmost node pointer so that we know where to start the
> > > next node level above this one."
> > > 
> > > Thanks for reviewing!
> > > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > +			if (i == 0)
> > > > > +				xfs_btree_copy_ptrs(cur, &first_ptr, &ptr, 1);
> > > > > +		}
> > > > > +		total_blocks += blocks;
> > > > > +		xfs_btree_bload_drop_buf(bbl, cur->bc_tp, &bp);
> > > > > +		xfs_btree_copy_ptrs(cur, &child_ptr, &first_ptr, 1);
> > > > > +	}
> > > > > +
> > > > > +	/* Initialize the new root. */
> > > > > +	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
> > > > > +		ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
> > > > > +		cur->bc_private.b.ifake->if_levels = cur->bc_nlevels;
> > > > > +		cur->bc_private.b.ifake->if_blocks = total_blocks - 1;
> > > > > +	} else {
> > > > > +		cur->bc_private.a.afake->af_root = be32_to_cpu(ptr.s);
> > > > > +		cur->bc_private.a.afake->af_levels = cur->bc_nlevels;
> > > > > +		cur->bc_private.a.afake->af_blocks = total_blocks;
> > > > > +	}
> > > > > +
> > > > > +	/*
> > > > > +	 * Write the new blocks to disk.  If the ordered list isn't empty after
> > > > > +	 * that, then something went wrong and we have to fail.  This should
> > > > > +	 * never happen, but we'll check anyway.
> > > > > +	 */
> > > > > +	ret = xfs_buf_delwri_submit(&bbl->buffers_list);
> > > > > +	if (ret)
> > > > > +		goto out;
> > > > > +	if (!list_empty(&bbl->buffers_list)) {
> > > > > +		ASSERT(list_empty(&bbl->buffers_list));
> > > > > +		ret = -EIO;
> > > > > +	}
> > > > > +out:
> > > > > +	xfs_buf_delwri_cancel(&bbl->buffers_list);
> > > > > +	if (bp)
> > > > > +		xfs_trans_brelse(cur->bc_tp, bp);
> > > > > +	return ret;
> > > > > +}
> > > > > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > > > > index 2965ed663418..51720de366ae 100644
> > > > > --- a/fs/xfs/libxfs/xfs_btree.h
> > > > > +++ b/fs/xfs/libxfs/xfs_btree.h
> > > > > @@ -578,4 +578,50 @@ void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
> > > > >  void xfs_btree_commit_ifakeroot(struct xfs_btree_cur *cur, int whichfork,
> > > > >  		const struct xfs_btree_ops *ops);
> > > > >  
> > > > > +typedef int (*xfs_btree_bload_get_fn)(struct xfs_btree_cur *cur, void *priv);
> > > > > +typedef int (*xfs_btree_bload_alloc_block_fn)(struct xfs_btree_cur *cur,
> > > > > +		union xfs_btree_ptr *ptr, void *priv);
> > > > > +typedef size_t (*xfs_btree_bload_iroot_size_fn)(struct xfs_btree_cur *cur,
> > > > > +		unsigned int nr_this_level, void *priv);
> > > > > +
> > > > > +/* Bulk loading of staged btrees. */
> > > > > +struct xfs_btree_bload {
> > > > > +	/* Buffer list for delwri_queue. */
> > > > > +	struct list_head		buffers_list;
> > > > > +
> > > > > +	/* Function to store a record in the cursor. */
> > > > > +	xfs_btree_bload_get_fn		get_data;
> > > > > +
> > > > > +	/* Function to allocate a block for the btree. */
> > > > > +	xfs_btree_bload_alloc_block_fn	alloc_block;
> > > > > +
> > > > > +	/* Function to compute the size of the in-core btree root block. */
> > > > > +	xfs_btree_bload_iroot_size_fn	iroot_size;
> > > > > +
> > > > > +	/* Number of records the caller wants to store. */
> > > > > +	uint64_t			nr_records;
> > > > > +
> > > > > +	/* Number of btree blocks needed to store those records. */
> > > > > +	uint64_t			nr_blocks;
> > > > > +
> > > > > +	/*
> > > > > +	 * Number of free records to leave in each leaf block.  If this (or
> > > > > +	 * any of the slack values) are negative, this will be computed to
> > > > > +	 * be halfway between maxrecs and minrecs.  This typically leaves the
> > > > > +	 * block 75% full.
> > > > > +	 */
> > > > > +	int				leaf_slack;
> > > > > +
> > > > > +	/* Number of free keyptrs to leave in each node block. */
> > > > > +	int				node_slack;
> > > > > +
> > > > > +	/* Computed btree height. */
> > > > > +	unsigned int			btree_height;
> > > > > +};
> > > > > +
> > > > > +int xfs_btree_bload_compute_geometry(struct xfs_btree_cur *cur,
> > > > > +		struct xfs_btree_bload *bbl, uint64_t nr_records);
> > > > > +int xfs_btree_bload(struct xfs_btree_cur *cur, struct xfs_btree_bload *bbl,
> > > > > +		void *priv);
> > > > > +
> > > > >  #endif	/* __XFS_BTREE_H__ */
> > > > > diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> > > > > index bc85b89f88ca..9b5e58a92381 100644
> > > > > --- a/fs/xfs/xfs_trace.c
> > > > > +++ b/fs/xfs/xfs_trace.c
> > > > > @@ -6,6 +6,7 @@
> > > > >  #include "xfs.h"
> > > > >  #include "xfs_fs.h"
> > > > >  #include "xfs_shared.h"
> > > > > +#include "xfs_bit.h"
> > > > >  #include "xfs_format.h"
> > > > >  #include "xfs_log_format.h"
> > > > >  #include "xfs_trans_resv.h"
> > > > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > > > index 7e162ca80c92..69e8605f9f97 100644
> > > > > --- a/fs/xfs/xfs_trace.h
> > > > > +++ b/fs/xfs/xfs_trace.h
> > > > > @@ -35,6 +35,7 @@ struct xfs_icreate_log;
> > > > >  struct xfs_owner_info;
> > > > >  struct xfs_trans_res;
> > > > >  struct xfs_inobt_rec_incore;
> > > > > +union xfs_btree_ptr;
> > > > >  
> > > > >  DECLARE_EVENT_CLASS(xfs_attr_list_class,
> > > > >  	TP_PROTO(struct xfs_attr_list_context *ctx),
> > > > > @@ -3655,6 +3656,90 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
> > > > >  		  __entry->blocks)
> > > > >  )
> > > > >  
> > > > > +TRACE_EVENT(xfs_btree_bload_level_geometry,
> > > > > +	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
> > > > > +		 uint64_t nr_this_level, unsigned int nr_per_block,
> > > > > +		 unsigned int desired_npb, uint64_t blocks,
> > > > > +		 uint64_t blocks_with_extra),
> > > > > +	TP_ARGS(cur, level, nr_this_level, nr_per_block, desired_npb, blocks,
> > > > > +		blocks_with_extra),
> > > > > +	TP_STRUCT__entry(
> > > > > +		__field(dev_t, dev)
> > > > > +		__field(xfs_btnum_t, btnum)
> > > > > +		__field(unsigned int, level)
> > > > > +		__field(unsigned int, nlevels)
> > > > > +		__field(uint64_t, nr_this_level)
> > > > > +		__field(unsigned int, nr_per_block)
> > > > > +		__field(unsigned int, desired_npb)
> > > > > +		__field(unsigned long long, blocks)
> > > > > +		__field(unsigned long long, blocks_with_extra)
> > > > > +	),
> > > > > +	TP_fast_assign(
> > > > > +		__entry->dev = cur->bc_mp->m_super->s_dev;
> > > > > +		__entry->btnum = cur->bc_btnum;
> > > > > +		__entry->level = level;
> > > > > +		__entry->nlevels = cur->bc_nlevels;
> > > > > +		__entry->nr_this_level = nr_this_level;
> > > > > +		__entry->nr_per_block = nr_per_block;
> > > > > +		__entry->desired_npb = desired_npb;
> > > > > +		__entry->blocks = blocks;
> > > > > +		__entry->blocks_with_extra = blocks_with_extra;
> > > > > +	),
> > > > > +	TP_printk("dev %d:%d btree %s level %u/%u nr_this_level %llu nr_per_block %u desired_npb %u blocks %llu blocks_with_extra %llu",
> > > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> > > > > +		  __entry->level,
> > > > > +		  __entry->nlevels,
> > > > > +		  __entry->nr_this_level,
> > > > > +		  __entry->nr_per_block,
> > > > > +		  __entry->desired_npb,
> > > > > +		  __entry->blocks,
> > > > > +		  __entry->blocks_with_extra)
> > > > > +)
> > > > > +
> > > > > +TRACE_EVENT(xfs_btree_bload_block,
> > > > > +	TP_PROTO(struct xfs_btree_cur *cur, unsigned int level,
> > > > > +		 uint64_t block_idx, uint64_t nr_blocks,
> > > > > +		 union xfs_btree_ptr *ptr, unsigned int nr_records),
> > > > > +	TP_ARGS(cur, level, block_idx, nr_blocks, ptr, nr_records),
> > > > > +	TP_STRUCT__entry(
> > > > > +		__field(dev_t, dev)
> > > > > +		__field(xfs_btnum_t, btnum)
> > > > > +		__field(unsigned int, level)
> > > > > +		__field(unsigned long long, block_idx)
> > > > > +		__field(unsigned long long, nr_blocks)
> > > > > +		__field(xfs_agnumber_t, agno)
> > > > > +		__field(xfs_agblock_t, agbno)
> > > > > +		__field(unsigned int, nr_records)
> > > > > +	),
> > > > > +	TP_fast_assign(
> > > > > +		__entry->dev = cur->bc_mp->m_super->s_dev;
> > > > > +		__entry->btnum = cur->bc_btnum;
> > > > > +		__entry->level = level;
> > > > > +		__entry->block_idx = block_idx;
> > > > > +		__entry->nr_blocks = nr_blocks;
> > > > > +		if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> > > > > +			xfs_fsblock_t	fsb = be64_to_cpu(ptr->l);
> > > > > +
> > > > > +			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);
> > > > > +			__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsb);
> > > > > +		} else {
> > > > > +			__entry->agno = cur->bc_private.a.agno;
> > > > > +			__entry->agbno = be32_to_cpu(ptr->s);
> > > > > +		}
> > > > > +		__entry->nr_records = nr_records;
> > > > > +	),
> > > > > +	TP_printk("dev %d:%d btree %s level %u block %llu/%llu fsb (%u/%u) recs %u",
> > > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > > +		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> > > > > +		  __entry->level,
> > > > > +		  __entry->block_idx,
> > > > > +		  __entry->nr_blocks,
> > > > > +		  __entry->agno,
> > > > > +		  __entry->agbno,
> > > > > +		  __entry->nr_records)
> > > > > +)
> > > > > +
> > > > >  #endif /* _TRACE_XFS_H */
> > > > >  
> > > > >  #undef TRACE_INCLUDE_PATH
> > > > > 
> > > > 
> > > 
> > 
> 

