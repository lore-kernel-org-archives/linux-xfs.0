Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A2567CA6
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 08:21:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1CDAFAC004
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 06:20:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TsrPdZtJo340k7VT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2016 06:20:58 -0800 (PST)
Date: Fri, 5 Feb 2016 09:20:57 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/7] libxfs: directory node splitting does not have an
	extra block
Message-ID: <20160205142056.GB52478@bfoster.bfoster>
References: <1454627108-19036-1-git-send-email-david@fromorbit.com>
	<1454627108-19036-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454627108-19036-4-git-send-email-david@fromorbit.com>
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

On Fri, Feb 05, 2016 at 10:05:04AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_da3_split() has to handle all three versions of the
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
> Indeed, for directories they *may* be an extra block on this buffer
> pointer. However, it's guaranteed not to be a leaf block (i.e. a
> directory data block) - the directory code only ever places hash
> index or free space blocks in this pointer (as a cursor of
> sorts), and so to use it as a directory data block will immediately
> corrupt the directory.
> 
> The problem is that the code assumes that there may be extra blocks
> that we need to link into the tree once we've split the root, but
> this is not true for either dir or attr trees, because the extra
> attr block is always consumed by the last node split before we split
> the root. Hence the linking in an extra block is always wrong at the
> root split level, and this manifests itself in repair as a directory
> corruption in a repaired directory, leaving the directory rebuild
> incomplete.
> 
> This is a dir v2 zero-day bug - it was in the initial dir v2 commit
> that was made back in February 1998.
> 
> Fix this by ensuring the linking of the blocks after the root split
> never tries to make use of the extra blocks that may be held in the
> cursor. They are held there for other purposes and should never be
> touched by the root splitting code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libxfs/xfs_da_btree.c | 59 +++++++++++++++++++++++++--------------------------
>  1 file changed, 29 insertions(+), 30 deletions(-)
> 
> diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
> index bf5fe21..25072c7 100644
> --- a/libxfs/xfs_da_btree.c
> +++ b/libxfs/xfs_da_btree.c
> @@ -351,7 +351,6 @@ xfs_da3_split(
>  	struct xfs_da_state_blk	*newblk;
>  	struct xfs_da_state_blk	*addblk;
>  	struct xfs_da_intnode	*node;
> -	struct xfs_buf		*bp;
>  	int			max;
>  	int			action = 0;
>  	int			error;
> @@ -392,7 +391,9 @@ xfs_da3_split(
>  				break;
>  			}
>  			/*
> -			 * Entry wouldn't fit, split the leaf again.
> +			 * Entry wouldn't fit, split the leaf again. The new
> +			 * extrablk will be consumed by xfs_da3_node_split if
> +			 * the node is split.
>  			 */
>  			state->extravalid = 1;
>  			if (state->inleaf) {
> @@ -441,6 +442,14 @@ xfs_da3_split(
>  		return 0;
>  
>  	/*
> +	 * xfs_da3_node_split() should have consumed any extra blocks we added
> +	 * during a double leaf split in the attr fork. This is guaranteed as
> +	 * we can't be here if the attr fork only has a single leaf block.
> +	 */
> +	ASSERT(state->extravalid == 0 ||
> +	       state->path.blk[max].magic == XFS_DIR2_LEAFN_MAGIC);
> +
> +	/*
>  	 * Split the root node.
>  	 */
>  	ASSERT(state->path.active == 0);
> @@ -452,43 +461,33 @@ xfs_da3_split(
>  	}
>  
>  	/*
> -	 * Update pointers to the node which used to be block 0 and
> -	 * just got bumped because of the addition of a new root node.
> -	 * There might be three blocks involved if a double split occurred,
> -	 * and the original block 0 could be at any position in the list.
> +	 * Update pointers to the node which used to be block 0 and just got
> +	 * bumped because of the addition of a new root node.  Note that the
> +	 * original block 0 could be at any position in the list of blocks in
> +	 * the tree.
>  	 *
> -	 * Note: the magic numbers and sibling pointers are in the same
> -	 * physical place for both v2 and v3 headers (by design). Hence it
> -	 * doesn't matter which version of the xfs_da_intnode structure we use
> -	 * here as the result will be the same using either structure.
> +	 * Note: the magic numbers and sibling pointers are in the same physical
> +	 * place for both v2 and v3 headers (by design). Hence it doesn't matter
> +	 * which version of the xfs_da_intnode structure we use here as the
> +	 * result will be the same using either structure.
>  	 */
>  	node = oldblk->bp->b_addr;
>  	if (node->hdr.info.forw) {
> -		if (be32_to_cpu(node->hdr.info.forw) == addblk->blkno) {
> -			bp = addblk->bp;
> -		} else {
> -			ASSERT(state->extravalid);
> -			bp = state->extrablk.bp;
> -		}
> -		node = bp->b_addr;
> +		ASSERT(be32_to_cpu(node->hdr.info.forw) == addblk->blkno);
> +		node = addblk->bp->b_addr;
>  		node->hdr.info.back = cpu_to_be32(oldblk->blkno);
> -		xfs_trans_log_buf(state->args->trans, bp,
> -		    XFS_DA_LOGRANGE(node, &node->hdr.info,
> -		    sizeof(node->hdr.info)));
> +		xfs_trans_log_buf(state->args->trans, addblk->bp,
> +				  XFS_DA_LOGRANGE(node, &node->hdr.info,
> +				  sizeof(node->hdr.info)));
>  	}
>  	node = oldblk->bp->b_addr;
>  	if (node->hdr.info.back) {
> -		if (be32_to_cpu(node->hdr.info.back) == addblk->blkno) {
> -			bp = addblk->bp;
> -		} else {
> -			ASSERT(state->extravalid);
> -			bp = state->extrablk.bp;
> -		}
> -		node = bp->b_addr;
> +		ASSERT(be32_to_cpu(node->hdr.info.back) == addblk->blkno);
> +		node = addblk->bp->b_addr;
>  		node->hdr.info.forw = cpu_to_be32(oldblk->blkno);
> -		xfs_trans_log_buf(state->args->trans, bp,
> -		    XFS_DA_LOGRANGE(node, &node->hdr.info,
> -		    sizeof(node->hdr.info)));
> +		xfs_trans_log_buf(state->args->trans, addblk->bp,
> +				  XFS_DA_LOGRANGE(node, &node->hdr.info,
> +				  sizeof(node->hdr.info)));
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
