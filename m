Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 241107F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 13:55:51 -0500 (CDT)
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E675F8F8087
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 11:55:50 -0700 (PDT)
Date: Mon, 22 Apr 2013 13:55:50 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 15/22] xfs: add CRCs to dir2/da node blocks
Message-ID: <20130422185550.GA29359@sgi.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<1364965892-19623-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364965892-19623-16-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <davidatfromorbit.com@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 03, 2013 at 04:11:25PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner at redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner at redhat.com>

A few nits below.

> ---
>  fs/xfs/xfs_attr.c      |   33 +-
>  fs/xfs/xfs_attr_leaf.c |   29 +-
>  fs/xfs/xfs_bmap.c      |    1 +
>  fs/xfs/xfs_da_btree.c  | 1395 +++++++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_da_btree.h  |  106 +++-
>  fs/xfs/xfs_dir2_node.c |   26 +-
>  fs/xfs/xfs_trace.c     |    2 +-
>  7 files changed, 972 insertions(+), 620 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
> index 8886838..e03128c 100644
> --- a/fs/xfs/xfs_attr.c
> +++ b/fs/xfs/xfs_attr.c
> @@ -15,7 +15,6 @@
>   * along with this program; if not, write the Free Software Foundation,
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
> -
>  #include "xfs.h"
>  #include "xfs_fs.h"
>  #include "xfs_types.h"
> @@ -25,6 +24,7 @@
>  #include "xfs_sb.h"
>  #include "xfs_ag.h"
>  #include "xfs_mount.h"
> +#include "xfs_error.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_attr_sf.h"
> @@ -35,7 +35,6 @@
>  #include "xfs_bmap.h"
>  #include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
> -#include "xfs_error.h"

Why did xfs_error.h need to be moved?

> @@ -935,16 +936,16 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
>  	/*
>  	 * Set up the new root node.
>  	 */
> -	error = xfs_da_node_create(args, 0, 1, &bp1, XFS_ATTR_FORK);
> +	error = xfs_da3_node_create(args, 0, 1, &bp1, XFS_ATTR_FORK);
>  	if (error)
>  		goto out;
>  	node = bp1->b_addr;
>  	leaf = bp2->b_addr;
>  	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
>  	/* both on-disk, don't endian-flip twice */
> -	node->btree[0].hashval =
> -		leaf->entries[be16_to_cpu(leaf->hdr.count)-1 ].hashval;
> -	node->btree[0].before = cpu_to_be32(blkno);
> +	btree = xfs_da3_node_tree_p(node);
> +	btree[0].hashval = leaf->entries[be16_to_cpu(leaf->hdr.count)-1 ].hashval;
								       ^

Extra space.

> +static bool
> +xfs_da3_node_verify(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> -	struct xfs_da_node_hdr *hdr = bp->b_addr;
> -	int			block_ok = 0;
> -
> -	block_ok = hdr->info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC);
> -	block_ok = block_ok &&
> -			be16_to_cpu(hdr->level) > 0 &&
> -			be16_to_cpu(hdr->count) > 0 ;
> -	if (!block_ok) {
> -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, hdr);
> -		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +	struct xfs_da_intnode	*hdr = bp->b_addr;
> +	struct xfs_da3_icnode_hdr ichdr;
> +
> +	xfs_da3_node_hdr_from_disk(&ichdr, hdr);
> +
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
> +
> +		if (ichdr.magic != XFS_DA3_NODE_MAGIC)
> +			return false;
> +
> +		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_uuid))
> +			return false;
> +		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
> +			return false;
> +	} else {
> +		if (ichdr.magic != XFS_DA_NODE_MAGIC)
> +			return false;
>  	}
> +	if (ichdr.level == 0)
> +		return false;
> +	if (ichdr.level > XFS_DA_NODE_MAXDEPTH)
> +		return false;
> +	if (ichdr.count == 0)
> +		return false;
> +
> +	/*
> +	 * we don't know if the node is for and attribute or directory tree,
> +	 * so only fail if the count is outside both bounds
> +	 */
> +	if (ichdr.count > mp->m_dir_node_ents &&
> +	    ichdr.count > mp->m_attr_node_ents)
> +		return false;
> +
> +	/* XXX: hash order check? */

Still planning to add that in a subsequent patch?

> @@ -178,33 +314,45 @@ xfs_da_node_read(
>   * Create the initial contents of an intermediate node.
>   */
>  int
> -xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
> -				 struct xfs_buf **bpp, int whichfork)
> +xfs_da3_node_create(
> +	struct xfs_da_args	*args,
> +	xfs_dablk_t		blkno,
> +	int			level,
> +	struct xfs_buf		**bpp,
> +	int			whichfork)
>  {
> -	xfs_da_intnode_t *node;
> -	struct xfs_buf *bp;
> -	int error;
> -	xfs_trans_t *tp;
> +	struct xfs_da_intnode	*node;
> +	struct xfs_trans	*tp = args->trans;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_da3_icnode_hdr ichdr = {0};
> +	struct xfs_buf		*bp;
> +	int			error;
>  
>  	trace_xfs_da_node_create(args);
> +	ASSERT(level <= XFS_DA_NODE_MAXDEPTH);
>  
> -	tp = args->trans;
>  	error = xfs_da_get_buf(tp, args->dp, blkno, -1, &bp, whichfork);

Looks like this function can return 0 with a null bp.  We should probably check
for that.

> @@ -320,8 +474,10 @@ xfs_da_split(xfs_da_state_t *state)
>  	 * just got bumped because of the addition of a new root node.
>  	 * There might be three blocks involved if a double split occurred,
>  	 * and the original block 0 could be at any position in the list.
> +	 *
> +	 * Note: the info structures being modified here for both v2 and v3 da
> +	 * headers, so we can do this linkage just using the v2 structures.

I had a hard time parsing that the first few times.  How about something like:

Note:  The xfs_da_blkinfo fields being modified here are shared by both
xfs_da_node_hdr and xfs_da3_intnode, and occur before the additional fields
added in xfs_da3_intnode, so this linkage can be done using just the v2
structures.

> @@ -591,12 +801,12 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
>  		 * Move the req'd B-tree elements from high in node1 to
>  		 * low in node2.
>  		 */
> -		be16_add_cpu(&node2->hdr.count, count);
> +		nodehdr2.count += count;
>  		tmp = count * (uint)sizeof(xfs_da_node_entry_t);
> -		btree_s = &node1->btree[be16_to_cpu(node1->hdr.count) - count];
> -		btree_d = &node2->btree[0];
> +		btree_s = &btree1[nodehdr1.count- count];
						^ 
Add a space.

> @@ -926,35 +1172,34 @@ xfs_da_node_toosmall(xfs_da_state_t *state, int *action)
>  	 * We prefer coalescing with the lower numbered sibling so as
>  	 * to shrink a directory over time.
>  	 */
> +	count  = state->node_ents;
> +	count -= state->node_ents >> 2;
> +	count -= nodehdr.count;
> +
>  	/* start with smaller blk num */
> -	forward = (be32_to_cpu(info->forw) < be32_to_cpu(info->back));
> +	forward = nodehdr.forw < nodehdr.back;
>  	for (i = 0; i < 2; forward = !forward, i++) {
>  		if (forward)
> -			blkno = be32_to_cpu(info->forw);
> +			blkno = nodehdr.forw;
>  		else
> -			blkno = be32_to_cpu(info->back);
> +			blkno = nodehdr.back;
>  		if (blkno == 0)
>  			continue;
> -		error = xfs_da_node_read(state->args->trans, state->args->dp,
> +		error = xfs_da3_node_read(state->args->trans, state->args->dp,
>  					blkno, -1, &bp, state->args->whichfork);
>  		if (error)
>  			return(error);
> -		ASSERT(bp != NULL);
>  
> -		node = (xfs_da_intnode_t *)info;
> -		count  = state->node_ents;
> -		count -= state->node_ents >> 2;
> -		count -= be16_to_cpu(node->hdr.count);

At first initializing count outside the loop looked like a problem to me, but
upon a closer inspection now I believe it's ok.

>  /*
> - * Unbalance the btree elements between two intermediate nodes,
> + * Unbalance the elements between two intermediate nodes,
>   * move all Btree elements from one node into another.
>   */
>  STATIC void
> -xfs_da_node_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
> -				     xfs_da_state_blk_t *save_blk)
> +xfs_da3_node_unbalance(
> +	struct xfs_da_state	*state,
> +	struct xfs_da_state_blk	*drop_blk,
> +	struct xfs_da_state_blk	*save_blk)
>  {
> -	xfs_da_intnode_t *drop_node, *save_node;
> -	xfs_da_node_entry_t *btree;
> -	int tmp;
> -	xfs_trans_t *tp;
> +	struct xfs_da_intnode	*drop_node;
> +	struct xfs_da_intnode	*save_node;
> +	struct xfs_da_node_entry *dbtree;
> +	struct xfs_da_node_entry *sbtree;
> +	struct xfs_da3_icnode_hdr dhdr;
> +	struct xfs_da3_icnode_hdr shdr;

Would be better as drop and save.

> +	struct xfs_trans	*tp;
> +	int			sindex;
> +	int			tmp;
>  
>  	trace_xfs_da_node_unbalance(state->args);
>  
>  	drop_node = drop_blk->bp->b_addr;
>  	save_node = save_blk->bp->b_addr;
> -	ASSERT(drop_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
> -	ASSERT(save_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
> +	xfs_da3_node_hdr_from_disk(&dhdr, drop_node);
> +	xfs_da3_node_hdr_from_disk(&shdr, save_node);
> +	dbtree = xfs_da3_node_tree_p(drop_node);
> +	sbtree = xfs_da3_node_tree_p(save_node);
>  	tp = state->args->trans;
>  
>  	/*
>  	 * If the dying block has lower hashvals, then move all the
>  	 * elements in the remaining block up to make a hole.
>  	 */
> -	if ((be32_to_cpu(drop_node->btree[0].hashval) < be32_to_cpu(save_node->btree[ 0 ].hashval)) ||
> -	    (be32_to_cpu(drop_node->btree[be16_to_cpu(drop_node->hdr.count)-1].hashval) <
> -	     be32_to_cpu(save_node->btree[be16_to_cpu(save_node->hdr.count)-1].hashval)))
> -	{
> -		btree = &save_node->btree[be16_to_cpu(drop_node->hdr.count)];
> -		tmp = be16_to_cpu(save_node->hdr.count) * (uint)sizeof(xfs_da_node_entry_t);
> -		memmove(btree, &save_node->btree[0], tmp);
> -		btree = &save_node->btree[0];
> +	if ((be32_to_cpu(dbtree[0].hashval) < be32_to_cpu(sbtree[ 0 ].hashval)) ||
								 ^ ^

Extra spaces.

> +	    (be32_to_cpu(dbtree[dhdr.count - 1].hashval) <
> +				be32_to_cpu(sbtree[shdr.count - 1].hashval))) {
> +		/* XXX: check this - is memmove dst correct? */
> +		tmp = shdr.count * (uint)sizeof(xfs_da_node_entry_t);
> +		memmove(&sbtree[dhdr.count], &sbtree[0], tmp);

I believe the destination in this memmove is correct.  We're moving items from
the beginning of the save_node toward the end of save_node so that later we can
copy from drop_node into the beginning of save_node.  Making room.

> +
> +		sindex = 0;
>  		xfs_trans_log_buf(tp, save_blk->bp,
> -			XFS_DA_LOGRANGE(save_node, btree,
> -				(be16_to_cpu(save_node->hdr.count) + be16_to_cpu(drop_node->hdr.count)) *
> -				sizeof(xfs_da_node_entry_t)));
> +			XFS_DA_LOGRANGE(save_node, &sbtree[0],
> +				(shdr.count + dhdr.count) *
> +						sizeof(xfs_da_node_entry_t)));

Seems like here we are logging more of the node than is strictly necessary.  So
far we have only modified save_node at shdr.count up to shdr.count +
dhdr.count, there is no need to log the beginning of save_node until after
we've copied from drop_node into it.  Not a big deal I guess.

>  	} else {
> -		btree = &save_node->btree[be16_to_cpu(save_node->hdr.count)];
> +		sindex = shdr.count;
>  		xfs_trans_log_buf(tp, save_blk->bp,
> -			XFS_DA_LOGRANGE(save_node, btree,
> -				be16_to_cpu(drop_node->hdr.count) *
> -				sizeof(xfs_da_node_entry_t)));
> +			XFS_DA_LOGRANGE(save_node, &sbtree[sindex],
> +				dhdr.count * sizeof(xfs_da_node_entry_t)));

And here it seems that we're logging save_node before we've made any
modification to it.  Maybe I'm missing something.

>  	}
>  
>  	/*
>  	 * Move all the B-tree elements from drop_blk to save_blk.
>  	 */
> -	tmp = be16_to_cpu(drop_node->hdr.count) * (uint)sizeof(xfs_da_node_entry_t);
> -	memcpy(btree, &drop_node->btree[0], tmp);
> -	be16_add_cpu(&save_node->hdr.count, be16_to_cpu(drop_node->hdr.count));
> +	tmp = dhdr.count * (uint)sizeof(xfs_da_node_entry_t);
> +	memcpy(&sbtree[sindex], &dbtree[0], tmp);
> +	shdr.count += dhdr.count;
> +	xfs_da3_node_hdr_to_disk(save_node, &shdr);
>  	xfs_trans_log_buf(tp, save_blk->bp,
>  		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
> -			sizeof(save_node->hdr)));
> +				xfs_da3_node_hdr_size(save_node)));
>  

And then after modifying save_node by copying stuff in from drop_blk we only
log the header, and not the entries.  I guess I'd prefer to see the entries
logged after they've been modified.  It's not a bug, looks like.. just not what
I'm used to seeing.

> @@ -1190,66 +1478,73 @@ xfs_da_node_lookup_int(xfs_da_state_t *state, int *result)
>  		}
>  		curr = blk->bp->b_addr;
>  		blk->magic = be16_to_cpu(curr->magic);
> -		ASSERT(blk->magic == XFS_DA_NODE_MAGIC ||
> -		       blk->magic == XFS_DIR2_LEAFN_MAGIC ||
> -		       blk->magic == XFS_ATTR_LEAF_MAGIC);
> +
> +		if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
> +			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
> +			break;
> +		}
> +
> +		if (blk->magic == XFS_DIR2_LEAFN_MAGIC ||
> +		    blk->magic == XFS_DIR3_LEAFN_MAGIC) {
> +			blk->magic = XFS_DIR2_LEAFN_MAGIC;
> +			blk->hashval = xfs_dir2_leafn_lasthash(blk->bp, NULL);
> +			break;
> +		}

Something like this would be better for this rearrangement:

	if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
		...
		break;
	} else if (blk->magic == XFS_DIR2_LEAFN_MAGIC ||
		   blk->magic == XFS_DIR3_LEAFN_MAGIC) {
		...
		break;
	} else if (blk->magic != XFS_DA_NODE_MAGIC) {
		return XFS_ERROR(EFSCORRUPTED);
	}

So that we're sure what kind of block we have.

> +
> +		blk->magic = XFS_DA_NODE_MAGIC;
> +

Why was that assignment necessary?



> @@ -1316,9 +1647,6 @@ xfs_da_blk_link(xfs_da_state_t *state, xfs_da_state_blk_t *old_blk,
>  	ASSERT(old_blk->magic == XFS_DA_NODE_MAGIC ||
>  	       old_blk->magic == XFS_DIR2_LEAFN_MAGIC ||
>  	       old_blk->magic == XFS_ATTR_LEAF_MAGIC);

Seems like these asserts need to be updated.

> -	ASSERT(old_blk->magic == be16_to_cpu(old_info->magic));
> -	ASSERT(new_blk->magic == be16_to_cpu(new_info->magic));
> -	ASSERT(old_blk->magic == new_blk->magic);

These seem like good asserts.



> @@ -1449,8 +1738,6 @@ xfs_da_blk_unlink(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
>  	ASSERT(save_blk->magic == XFS_DA_NODE_MAGIC ||
>  	       save_blk->magic == XFS_DIR2_LEAFN_MAGIC ||
>  	       save_blk->magic == XFS_ATTR_LEAF_MAGIC);
		
Seems like these asserts need to be updated.

> -	ASSERT(save_blk->magic == be16_to_cpu(save_info->magic));
> -	ASSERT(drop_blk->magic == be16_to_cpu(drop_info->magic));

These two seem like useful asserts.


> @@ -1856,17 +2176,22 @@ xfs_da_swap_lastblock(
>  		dead_level = 0;
>  		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
>  	} else {
> -		ASSERT(dead_info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
> +		struct xfs_da3_icnode_hdr deadhdr;
> +
> +		ASSERT(dead_info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
> +		       dead_info->magic == cpu_to_be16(XFS_DA3_NODE_MAGIC));

I think these are covered by asserts in xfs_da3_node_hdr_from_disk and can be removed.

> @@ -1912,31 +2237,31 @@ xfs_da_swap_lastblock(
>  	 * Walk down the tree looking for the parent of the moved block.
>  	 */
>  	for (;;) {
> -		error = xfs_da_node_read(tp, ip, par_blkno, -1, &par_buf, w);
> +		error = xfs_da3_node_read(tp, ip, par_blkno, -1, &par_buf, w);
>  		if (error)
>  			goto done;
>  		par_node = par_buf->b_addr;
> -		if (unlikely(par_node->hdr.info.magic !=
> -		    cpu_to_be16(XFS_DA_NODE_MAGIC) ||
> -		    (level >= 0 && level != be16_to_cpu(par_node->hdr.level) + 1))) {
> +		xfs_da3_node_hdr_from_disk(&par_hdr, par_node);
> +		if (level >= 0 && level != par_hdr.level + 1) {

Do we need to test par_node magic here like we were before? 

>  			XFS_ERROR_REPORT("xfs_da_swap_lastblock(4)",
>  					 XFS_ERRLEVEL_LOW, mp);
>  			error = XFS_ERROR(EFSCORRUPTED);
>  			goto done;
>  		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
