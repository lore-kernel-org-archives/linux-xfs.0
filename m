Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16990 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932127AbdJZQpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 12:45:13 -0400
Date: Thu, 26 Oct 2017 09:45:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: refactor extended attribute list operation
Message-ID: <20171026164508.GY5483@magnolia>
References: <150899696463.18095.9642473908739425678.stgit@magnolia>
 <20171026131636.GA3450@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026131636.GA3450@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 09:16:37AM -0400, Brian Foster wrote:
> On Wed, Oct 25, 2017 at 10:49:24PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're iterating the attribute list and we can't find our previous
> > location based off the attribute cursor, we'll instead walk down the
> > attribute btree from the root trying to find where we left off.  Move
> > this code into a separate function for later cleanups.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_attr_list.c |  136 ++++++++++++++++++++++++++++++------------------
> >  1 file changed, 84 insertions(+), 52 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > index 5816786..48423eb 100644
> > --- a/fs/xfs/xfs_attr_list.c
> > +++ b/fs/xfs/xfs_attr_list.c
> > @@ -204,19 +204,89 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
> >  	return 0;
> >  }
> >  
> > +/*
> > + * We didn't find the block & hash mentioned in the cursor state, so
> > + * walk down the attr btree looking for the hash.
> > + */
> >  STATIC int
> > -xfs_attr_node_list(xfs_attr_list_context_t *context)
> > +xfs_attr_node_list_lookup(
> > +	struct xfs_attr_list_context	*context,
> > +	struct attrlist_cursor_kern	*cursor,
> > +	struct xfs_buf			**pbp)
> 
> Looks Ok, but the label usage at the bottom seems a bit gratuitous...
> 
> >  {
> > -	attrlist_cursor_kern_t *cursor;
> > -	xfs_attr_leafblock_t *leaf;
> > -	xfs_da_intnode_t *node;
> > -	struct xfs_attr3_icleaf_hdr leafhdr;
> > -	struct xfs_da3_icnode_hdr nodehdr;
> > -	struct xfs_da_node_entry *btree;
> > -	int error, i;
> > -	struct xfs_buf *bp;
> > -	struct xfs_inode	*dp = context->dp;
> > -	struct xfs_mount	*mp = dp->i_mount;
> > +	struct xfs_da3_icnode_hdr	nodehdr;
> > +	struct xfs_da_intnode		*node;
> > +	struct xfs_da_node_entry	*btree;
> > +	struct xfs_inode		*dp = context->dp;
> > +	struct xfs_mount		*mp = dp->i_mount;
> > +	struct xfs_trans		*tp = context->tp;
> > +	int				i;
> > +	int				error = 0;
> > +	uint16_t			magic;
> > +
> > +	ASSERT(*pbp == NULL);
> > +	cursor->blkno = 0;
> > +	for (;;) {
> > +		error = xfs_da3_node_read(tp, dp, cursor->blkno, -1, pbp,
> > +				XFS_ATTR_FORK);
> > +		if (error)
> > +			return error;
> > +		node = (*pbp)->b_addr;
> > +		magic = be16_to_cpu(node->hdr.info.magic);
> > +		switch (magic) {
> > +		case XFS_ATTR_LEAF_MAGIC:
> > +		case XFS_ATTR3_LEAF_MAGIC:
> > +			goto found_leaf;
> 
> The label after the loop suggests a break should be sufficient, but the
> switch statement conflicts with that. So why not just use the if logic
> from the original code and kill that label?

Ok.

> > +		case XFS_DA_NODE_MAGIC:
> > +		case XFS_DA3_NODE_MAGIC:
> > +			/* process btree node below */
> > +			break;
> > +		default:
> > +			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> > +					node);
> > +			goto out_corruptbuf;
> > +		}
> > +
> > +		dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> > +
> > +		btree = dp->d_ops->node_tree_p(node);
> > +		for (i = 0; i < nodehdr.count; btree++, i++) {
> > +			if (cursor->hashval <= be32_to_cpu(btree->hashval)) {
> > +				cursor->blkno = be32_to_cpu(btree->before);
> > +				trace_xfs_attr_list_node_descend(context,
> > +						btree);
> > +				break;
> > +			}
> > +		}
> > +		if (i == nodehdr.count)
> > +			goto out_buf;
> 
> We can move this after the line below to pick up the brelse(). Also, if
> we use a local bp pointer and assign pbp = &bp in the one case we know
> we found something, that eliminates the need to clear pbp in the
> multiple other cases. It also means we can now just return directly from
> any checks after the brelse() in the loop.
> 
> > +
> > +		xfs_trans_brelse(tp, *pbp);
> > +	}
> > +
> > +found_leaf:
> > +	return error;
> > +
> > +out_corruptbuf:
> > +	error = -EFSCORRUPTED;
> 
> Might as well just return -EFSCORRUPTED. We already return directly from
> the only place error is potentially assigned anything else.
> 
> > +out_buf:
> > +	xfs_trans_brelse(tp, *pbp);
> > +	*pbp = NULL;
> > +	return error;
> 
> With all of that and from taking a quick look at the next patch, I think
> we should be able to end up with something like the following logic with
> only a single label for the corrupted buf case, which is now common
> between the existing magic val corruption check and the new level
> checks.
> 
> 		...
> 	}
> 
> 	if (expected_level != 0)
> 		goto out_corruptbp;
> 	*pbp = bp;
> 	return 0;
> 
> out_corruptbp:
> 	xfs_trans_brelse(tp, bp);
> 	return -EFSCORRUPTED;

Ok, will do.

--D

> }
> 
> Brian
> 
> > +}
> > +
> > +STATIC int
> > +xfs_attr_node_list(
> > +	struct xfs_attr_list_context	*context)
> > +{
> > +	struct xfs_attr3_icleaf_hdr	leafhdr;
> > +	struct attrlist_cursor_kern	*cursor;
> > +	struct xfs_attr_leafblock	*leaf;
> > +	struct xfs_da_intnode		*node;
> > +	struct xfs_buf			*bp;
> > +	struct xfs_inode		*dp = context->dp;
> > +	struct xfs_mount		*mp = dp->i_mount;
> > +	int				error;
> >  
> >  	trace_xfs_attr_node_list(context);
> >  
> > @@ -277,47 +347,9 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
> >  	 * Note that start of node block is same as start of leaf block.
> >  	 */
> >  	if (bp == NULL) {
> > -		cursor->blkno = 0;
> > -		for (;;) {
> > -			uint16_t magic;
> > -
> > -			error = xfs_da3_node_read(context->tp, dp,
> > -						      cursor->blkno, -1, &bp,
> > -						      XFS_ATTR_FORK);
> > -			if (error)
> > -				return error;
> > -			node = bp->b_addr;
> > -			magic = be16_to_cpu(node->hdr.info.magic);
> > -			if (magic == XFS_ATTR_LEAF_MAGIC ||
> > -			    magic == XFS_ATTR3_LEAF_MAGIC)
> > -				break;
> > -			if (magic != XFS_DA_NODE_MAGIC &&
> > -			    magic != XFS_DA3_NODE_MAGIC) {
> > -				XFS_CORRUPTION_ERROR("xfs_attr_node_list(3)",
> > -						     XFS_ERRLEVEL_LOW,
> > -						     context->dp->i_mount,
> > -						     node);
> > -				xfs_trans_brelse(context->tp, bp);
> > -				return -EFSCORRUPTED;
> > -			}
> > -
> > -			dp->d_ops->node_hdr_from_disk(&nodehdr, node);
> > -			btree = dp->d_ops->node_tree_p(node);
> > -			for (i = 0; i < nodehdr.count; btree++, i++) {
> > -				if (cursor->hashval
> > -						<= be32_to_cpu(btree->hashval)) {
> > -					cursor->blkno = be32_to_cpu(btree->before);
> > -					trace_xfs_attr_list_node_descend(context,
> > -									 btree);
> > -					break;
> > -				}
> > -			}
> > -			if (i == nodehdr.count) {
> > -				xfs_trans_brelse(context->tp, bp);
> > -				return 0;
> > -			}
> > -			xfs_trans_brelse(context->tp, bp);
> > -		}
> > +		error = xfs_attr_node_list_lookup(context, cursor, &bp);
> > +		if (error || !bp)
> > +			return error;
> >  	}
> >  	ASSERT(bp != NULL);
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
