Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 37AA67F37
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 12:34:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F21778F8035
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 10:34:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FyKKuefBxJoSE8OG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 10:34:04 -0800 (PST)
Date: Tue, 5 Jan 2016 13:34:02 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/9] libxfs: directory node splitting does not have an
	extra block
Message-ID: <20160105183401.GB38749@bfoster.bfoster>
References: <1450733829-9319-1-git-send-email-david@fromorbit.com>
	<1450733829-9319-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1450733829-9319-7-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 22, 2015 at 08:37:06AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_da3_split() has to handle all thre versions of the
> directory/attribute btree structure. The attr tree is v1, the dir
> tre is v2 or v3. The main difference between the v1 and v2/3 trees
> is the way tree nodes are split - in the v1 tree we can require a
> double split to occur because the object to be inserted may be
> larger than the space made by splitting a leaf. In this case we need
> to do a double split - one to split the full leaf, then another to
> allocate an empty leaf block in the correct location for the new
> entry.  This does not happen with dir (v2/v3) formats as the objects
> being inserted are always guaranteed to fit into the new space in
> the split blocks.
> 
> The problem is that when we are doing the first root split, there
> can be three leaf blocks that need to be updated for an attr tree,
> but there will ony ever be two blocks for the dir tree. The code,
> however, expects that there will always be an extra block (i.e.
> three blocks) that needs updating. When rebuilding broken
> directories, xfs_repair trips over this condition in the directroy
> code and SEGVs because state->extrablk.bp == NULL. i.e. there is no
> extra block.
> 
> Indeed, for directories they *may* be an extra block on this buffer
> pointer. However, it's guaranteed not to be a leaf block (i.e. a
> directory data block) - the directory code only ever places hash
> index or free space blocks in this pointer (as a cursor of
> sorts), and so to use it as a directory data block will immediately
> corrupt the directory. This manifests itself in repair as a
> directory corruption in a repaired directory, leaving the directory
> rebuild incomplete.
> 
> This is a dir v2 zero-day bug - it was in the initial dir v2 commit
> that was made back in February 1998.
> 
> Fix this by making the update code aware of whether the extra block
> is a valid node for linking into the tree, rather than asserting
> (incorrectly) that the extra block must be valid. This brings the
> code in line with xfs_da3_node_split() which, from the first dir v2
> commit, handled the conditional extra block case correctly....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Thanks for the explanation. The logic in xfs_da3_split() is a bit
confusing and I'm not sure I'm following it quite correctly. A couple
questions below...

>  libxfs/xfs_da_btree.c | 39 ++++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
> index bf5fe21..58a0361 100644
> --- a/libxfs/xfs_da_btree.c
> +++ b/libxfs/xfs_da_btree.c
> @@ -356,6 +356,7 @@ xfs_da3_split(
>  	int			action = 0;
>  	int			error;
>  	int			i;
> +	bool			use_extra = false;
>  
>  	trace_xfs_da_split(state->args);
>  
> @@ -395,6 +396,7 @@ xfs_da3_split(
>  			 * Entry wouldn't fit, split the leaf again.
>  			 */
>  			state->extravalid = 1;
> +			use_extra = true;
>  			if (state->inleaf) {
>  				state->extraafter = 0;	/* before newblk */
>  				trace_xfs_attr_leaf_split_before(state->args);

So here we walk up through a tree, doing splits as necessary. In this
particular case, we have the potential attr leaf double-split case
described above. If this happens, we set extrablk and use_extra. Is it
the case that if this occurs, we know the loop is good for at least one
more iteration (since this is a leaf block)?

If so, we get to a node block that might be the root and call
xfs_da3_node_split(). That function potentially splits the node block
and adds the entries for the previous split, "consuming" extrablk if it
had been set as well. In fact, if the node/root doesn't split, we don't
carry on to any of the below code at all since addblk is set to NULL
(even if the double split had occurred).

Given that, I'm not seeing how extrablk should be used by the following
root split code at all under normal circumstances. Wouldn't it always be
handled before that point? To frame the question another way, if the
double split is only a leaf block operation, shouldn't only addblk be
relevant to the root block split code? I could very easily be missing
something here...

Brian

> @@ -454,8 +456,13 @@ xfs_da3_split(
>  	/*
>  	 * Update pointers to the node which used to be block 0 and
>  	 * just got bumped because of the addition of a new root node.
> -	 * There might be three blocks involved if a double split occurred,
> -	 * and the original block 0 could be at any position in the list.
> +	 * There might be three blocks involved if a double split occurred and
> +	 * in this case use_extra will be set. This can only happen for attr
> +	 * trees, as extrablk for dir trees can only contain data or free space
> +	 * blocks, never leaf/node blocks.
> +	 *
> +	 * Note that the original block 0 could be at any position in the list
> +	 * of blocks in the tree.
>  	 *
>  	 * Note: the magic numbers and sibling pointers are in the same
>  	 * physical place for both v2 and v3 headers (by design). Hence it
> @@ -464,31 +471,37 @@ xfs_da3_split(
>  	 */
>  	node = oldblk->bp->b_addr;
>  	if (node->hdr.info.forw) {
> +		bp = NULL;
>  		if (be32_to_cpu(node->hdr.info.forw) == addblk->blkno) {
>  			bp = addblk->bp;
> -		} else {
> +		} else if (use_extra) {
>  			ASSERT(state->extravalid);
>  			bp = state->extrablk.bp;
>  		}
> -		node = bp->b_addr;
> -		node->hdr.info.back = cpu_to_be32(oldblk->blkno);
> -		xfs_trans_log_buf(state->args->trans, bp,
> -		    XFS_DA_LOGRANGE(node, &node->hdr.info,
> -		    sizeof(node->hdr.info)));
> +		if (bp) {
> +			node = bp->b_addr;
> +			node->hdr.info.back = cpu_to_be32(oldblk->blkno);
> +			xfs_trans_log_buf(state->args->trans, bp,
> +					  XFS_DA_LOGRANGE(node, &node->hdr.info,
> +					  sizeof(node->hdr.info)));
> +		}
>  	}
>  	node = oldblk->bp->b_addr;
>  	if (node->hdr.info.back) {
> +		bp = NULL;
>  		if (be32_to_cpu(node->hdr.info.back) == addblk->blkno) {
>  			bp = addblk->bp;
>  		} else {
>  			ASSERT(state->extravalid);
>  			bp = state->extrablk.bp;
>  		}
> -		node = bp->b_addr;
> -		node->hdr.info.forw = cpu_to_be32(oldblk->blkno);
> -		xfs_trans_log_buf(state->args->trans, bp,
> -		    XFS_DA_LOGRANGE(node, &node->hdr.info,
> -		    sizeof(node->hdr.info)));
> +		if (bp) {
> +			node = bp->b_addr;
> +			node->hdr.info.forw = cpu_to_be32(oldblk->blkno);
> +			xfs_trans_log_buf(state->args->trans, bp,
> +					  XFS_DA_LOGRANGE(node, &node->hdr.info,
> +					  sizeof(node->hdr.info)));
> +		}
>  	}
>  	addblk->bp = NULL;
>  	return 0;
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
