Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752376AbdKHNuf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Nov 2017 08:50:35 -0500
Date: Wed, 8 Nov 2017 08:50:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 17/21] xfs: use a b+tree for the in-core extent list
Message-ID: <20171108135032.GA39207@bfoster.bfoster>
References: <20171103144539.2187-1-hch@lst.de>
 <20171103144539.2187-18-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103144539.2187-18-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 03, 2017 at 05:45:35PM +0300, Christoph Hellwig wrote:
> Replace the current linear list and the indirection array for the in-core
> extent list with a b+tree to avoid the need for larger memory allocations
> for the indirection array when lots of extents are present.  The current
> extent list implementations leads to heavy pressure on the memory
> allocator when modifying files with a high extent count, and can lead
> to high latencies because of that.
> 
> The replacement is a b+tree with a few quirks.  The leaf nodes directly
> store the extent record in two u64 values.  The encoding is a little bit
> different from the existing in-core extent records so that the start
> offset and length which are required for lookups can be retreived with
> simple mask operations.  The inner nodes store a 64-bit key containing
> the start offset in the first half of the node, and the pointers to the
> next lower level in the second half.  In either case we walk the node
> from the beginninig to the end and do a linear search, as that is more
> efficient for the low number of cache lines touched during a search
> (2 for the inner nodes, 4 for the leaf nodes) than a binary search.
> We store termination markers (zero length for the leaf nodes, an
> otherwise impossible high bit for the inner nodes) to terminate the key
> list / records instead of storing a count to use the available cache
> lines as efficiently as possible.
> 
> One quirk of the algorithm is that while we normally split a node half and
> half like usual btree implementations we just spill over entries added at
> the very end of the list to a new node on its own.  This means we get a
> 100% fill grade for the common cases of bulk inseration at reading an
> inode into memory, and when only sequentially appending to a file.  The
> downside is a slightly higher chance of splits on the first random
> inserations.
> 
> Both insert and removal manually recurse into the lower levels, but
> the bulk deletion of the whole tree is still implemented as a recursive
> function call, although one limited by the overall depth and with very
> little stack usage in every iteration.
> 
> For the first few extents we dynamically grow the list from a single
> extent to the next powers of two until we have a first full leaf block
> and that building the actual tree.
> 
> The code started out based on the generic lib/btree.c code from Joern
> Engel based on earlier work from Peter Zijlstra, but has since been
> rewritten beyond recognition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

I notice this was actually already merged. Sorry for being slow, I've
been rather distracted this week. I hadn't got through all of this, but
here's the comments I have through most of it..

>  fs/xfs/Makefile                |    1 +
>  fs/xfs/libxfs/xfs_bmap.c       |   20 +-
>  fs/xfs/libxfs/xfs_bmap_btree.c |  103 +---
>  fs/xfs/libxfs/xfs_bmap_btree.h |    7 +-
>  fs/xfs/libxfs/xfs_format.h     |    4 -
>  fs/xfs/libxfs/xfs_iext_tree.c  | 1035 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.c | 1035 +---------------------------------------
>  fs/xfs/libxfs/xfs_inode_fork.h |   84 +---
>  fs/xfs/libxfs/xfs_types.h      |    3 +-
>  fs/xfs/scrub/bmap.c            |    5 +-
>  fs/xfs/xfs_inode.c             |    2 +-
>  fs/xfs/xfs_inode_item.c        |    2 -
>  fs/xfs/xfs_trace.h             |   51 +-
>  13 files changed, 1093 insertions(+), 1259 deletions(-)
>  create mode 100644 fs/xfs/libxfs/xfs_iext_tree.c
> 
...
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> new file mode 100644
> index 000000000000..8b6402d2d9b2
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -0,0 +1,1035 @@
...
> +static void
> +xfs_iext_update_node(
> +	struct xfs_ifork	*ifp,
> +	xfs_fileoff_t		old_offset,
> +	xfs_fileoff_t		new_offset,
> +	int			level,
> +	void			*ptr)
> +{
> +	struct xfs_iext_node	*node = ifp->if_u1.if_root;
> +	int			height, i;
> +
> +	for (height = ifp->if_height; height > level; height--) {
> +		for (i = 0; i < KEYS_PER_NODE; i++) {
> +			if (i > 0 && xfs_iext_key_cmp(node, i, old_offset) > 0)
> +				break;
> +			if (node->keys[i] == old_offset)
> +				node->keys[i] = new_offset;

The logic seems a bit convoluted. Is this not the same as something like
the following:

                        if (xfs_iext_key_cmp(node, i, old_offset) == 0) {
                                node->keys[i] = new_offset;
                                node = node->ptrs[i];
                                break;
                        }

(and kill the node assignment below)..?

> +		}
> +		node = node->ptrs[i - 1];
> +		ASSERT(node);
> +	}

Hmm, so we walk the tree from the top and update any references to a
particular key. I'm wondering why we wouldn't/couldn't do something a
bit more efficient (and cautious) like walk from the leaf up using the
find_level bits, then stop once we update a key that is not a zero
index..?

I guess find_level() itself has to do a top-down walk each go around
since we don't have any up-pointers, so maybe that answers my question.
;) Perhaps a more robust cursor could help us optimize some of these
cases in the future without bloating the tree, if warranted.

> +
> +	ASSERT(node == ptr);
> +}
> +
...
> +static struct xfs_iext_leaf *
> +xfs_iext_split_leaf(
> +	struct xfs_iext_cursor	*cur,
> +	int			*nr_entries)
> +{
> +	struct xfs_iext_leaf	*leaf = cur->leaf;
> +	struct xfs_iext_leaf	*new = kmem_zalloc(NODE_SIZE, KM_NOFS);
> +	const int		nr_move = RECS_PER_LEAF / 2;
> +	int			nr_keep = nr_move + (RECS_PER_LEAF & 1);
> +	int			i;
> +
> +	/* for sequential append operations just spill over into the new node */
> +	if (cur->pos == KEYS_PER_NODE) {
> +		cur->leaf = new;
> +		cur->pos = 0;
> +		*nr_entries = 0;
> +		goto done;
> +	}

Hmm, this is called when nr_entries is RECS_PER_LEAF, which is currently
15. KEYS_PER_NODE is currently 16, so when will the above ever occur?
Wouldn't cur->pos point to 15 on a sequential append?

> +
> +	if (nr_keep & 1)
> +		nr_keep++;
> +

This also seems superfluous. nr_move is RECS_PER_LEAF/2 and so matches
the parity of RECS_PER_LEAF. nr_keep is nr_move plus 1 iff RECS_PER_LEAF
is odd, which looks like it means nr_keep is always even. Am I missing
some other case..?

> +	for (i = 0; i < nr_move; i++) {
> +		new->recs[i] = leaf->recs[nr_keep + i];
> +		xfs_iext_rec_clear(&leaf->recs[nr_keep + i]);
> +	}
> +
> +	if (cur->pos >= nr_keep) {
> +		cur->leaf = new;
> +		cur->pos -= nr_keep;
> +		*nr_entries = nr_move;
> +	} else {
> +		*nr_entries = nr_keep;
> +	}
> +done:
> +	if (leaf->next)
> +		leaf->next->prev = new;
> +	new->next = leaf->next;
> +	new->prev = leaf;
> +	leaf->next = new;
> +	return new;
> +}
> +
...
> +
> +static void
> +xfs_iext_realloc_root(
> +	struct xfs_ifork	*ifp,
> +	struct xfs_iext_cursor	*cur)
> +{
> +	size_t new_size = ifp->if_bytes + sizeof(struct xfs_iext_rec);
> +	void *new;
> +
> +	/* account for the prev/next pointers */
> +	if (new_size / sizeof(struct xfs_iext_rec) == RECS_PER_LEAF)
> +		new_size = NODE_SIZE;
> +
> +	new = kmem_realloc(ifp->if_u1.if_root, new_size, KM_NOFS);
> +	memset(new + ifp->if_bytes, 0, new_size - ifp->if_bytes);
> +	ifp->if_u1.if_root = new;
> +	cur->leaf = new;

I don't think it's an immediate problem, but this look like a bit of a
landmine because of how we update to the node size. The first time that
we bump up to NODE_SIZE it looks like we zero everything properly. We
call this again however in the case where the leaf would need to be
split. The new_size doesn't change and so I suspect the realloc doesn't
do anything, but we still zero over the last part of the structure as if
it were going to be a new record.

> +}
> +
> +static void
> +__xfs_iext_insert(
> +	struct xfs_ifork	*ifp,
> +	struct xfs_iext_cursor	*cur,
> +	struct xfs_bmbt_irec	*irec)
> +{
> +	xfs_fileoff_t		offset = irec->br_startoff;
> +	struct xfs_iext_leaf	*new = NULL;
> +	int			nr_entries, i;
> +
> +	if (ifp->if_height == 0)
> +		xfs_iext_alloc_root(ifp, cur);
> +	else if (ifp->if_height == 1)
> +		xfs_iext_realloc_root(ifp, cur);
> +
> +	nr_entries = xfs_iext_leaf_nr_entries(ifp, cur->leaf, cur->pos);
> +	ASSERT(nr_entries <= RECS_PER_LEAF);
> +	ASSERT(cur->pos >= nr_entries ||
> +	       xfs_iext_rec_cmp(cur_rec(cur), irec->br_startoff) != 0);
> +
> +	if (nr_entries == RECS_PER_LEAF)
> +		new = xfs_iext_split_leaf(cur, &nr_entries);
> +

A comment would be nice here since the function names are a bit vague
(to me). I.e., point out we're updating the keys up the tree unless
we've added a new node, since a new node hasn't been added to the tree
yet.

> +	if (cur->leaf != new && cur->pos == 0 && nr_entries > 0) {
> +		xfs_iext_update_node(ifp, xfs_iext_leaf_key(cur->leaf, 0), offset, 1,
> +				cur->leaf);
> +	}
> +
> +	for (i = nr_entries; i > cur->pos; i--)
> +		cur->leaf->recs[i] = cur->leaf->recs[i - 1];
> +	xfs_iext_set(cur_rec(cur), irec);
> +	ifp->if_bytes += sizeof(struct xfs_iext_rec);
> +
> +	if (new)
> +		xfs_iext_insert_node(ifp, xfs_iext_leaf_key(new, 0), new, 2);
> +}
> +
...
> +
> +static void
> +xfs_iext_remove_node(
> +	struct xfs_ifork	*ifp,
> +	xfs_fileoff_t		offset,
> +	void			*victim)
> +{
> +	struct xfs_iext_node	*node, *parent;
> +	int			level = 2, pos, nr_entries, i;
> +
> +	ASSERT(level <= ifp->if_height);
> +	node = xfs_iext_find_level(ifp, offset, level);
> +	pos = xfs_iext_node_pos(node, offset);
> +again:
> +	ASSERT(node->ptrs[pos]);
> +	ASSERT(node->ptrs[pos] == victim);
> +	kmem_free(victim);
> +
> +	nr_entries = xfs_iext_node_nr_entries(node, pos) - 1;
> +	offset = node->keys[0];
> +	for (i = pos; i < nr_entries; i++) {
> +		node->keys[i] = node->keys[i + 1];
> +		node->ptrs[i] = node->ptrs[i + 1];
> +	}
> +	node->keys[nr_entries] = XFS_IEXT_KEY_INVALID;
> +	node->ptrs[nr_entries] = NULL;
> +
> +	if (pos == 0 && nr_entries > 0) {
> +		xfs_iext_update_node(ifp, offset, node->keys[0], level,
> +				node);
> +		offset = node->keys[0];
> +	}
> +
> +	if (nr_entries >= KEYS_PER_NODE / 2)
> +		return;
> +
> +	if (level < ifp->if_height) {
> +		level++;
> +		parent = xfs_iext_find_level(ifp, offset, level);
> +		pos = xfs_iext_node_pos(parent, offset);
> +
> +		ASSERT(pos != KEYS_PER_NODE);
> +		ASSERT(parent->ptrs[pos] == node);
> +
> +		node = xfs_iext_rebalance_node(parent, &pos, node, nr_entries);
> +		if (node) {
> +			offset = node->keys[0];

It doesn't look like there is any need to update offset here. It will be
overwritten above.

> +			victim = node;
> +			node = parent;
> +			goto again;
> +		}
> +	} else if (nr_entries == 1) {
> +		ASSERT(node == ifp->if_u1.if_root);
> +		ifp->if_u1.if_root = node->ptrs[0];
> +		ifp->if_height--;
> +		kmem_free(node);
> +	}
> +}
> +

These lower level rebalance functions could really use some comments.
It's easy to lose track of the current state of things, for example, why
we pass leaf separate from cursor...

> +static void
> +xfs_iext_rebalance_leaf(
> +	struct xfs_ifork	*ifp,
> +	struct xfs_iext_cursor	*cur,
> +	struct xfs_iext_leaf	*leaf,
> +	xfs_fileoff_t		offset,
> +	int			fill)
> +{
> +	if (leaf->prev) {
> +		int nr_prev = xfs_iext_leaf_nr_entries(ifp, leaf->prev, 0), i;
> +

... and then why we do things like remove the current node vs. the next
node in the below hunks. I'm guessing that is to easily preserve record
order by always filling backwards, and perhaps implicitly avoid the need
for key updates as part of the rebalance itself..?

> +		if (nr_prev + fill <= RECS_PER_LEAF) {
> +			for (i = 0; i < fill; i++)
> +				leaf->prev->recs[nr_prev + i] = leaf->recs[i];
> +
> +			if (cur->leaf == leaf) {
> +				cur->leaf = leaf->prev;
> +				cur->pos += nr_prev;
> +			}
> +			goto remove_node;
> +		}
> +	}
> +
> +	if (leaf->next) {
> +		int nr_next = xfs_iext_leaf_nr_entries(ifp, leaf->next, 0), i;
> +
> +		if (fill + nr_next <= RECS_PER_LEAF) {
> +			for (i = 0; i < nr_next; i++)
> +				leaf->recs[fill + i] = leaf->next->recs[i];
> +
> +			if (cur->leaf == leaf->next) {
> +				cur->leaf = leaf;
> +				cur->pos += fill;
> +			}
> +
> +			offset = xfs_iext_leaf_key(leaf->next, 0);
> +			leaf = leaf->next;

If fill happens to be 0 [1] because we've emptied the first leaf in the
tree, we end up here where we copy all of the records from the next leaf
to the empty leaf. We therefore update recs[0] of the empty leaf, set
'offset' to the key of the next and proceed to delete that next leaf.

The node remove below would then remove the keys up the tree based on
next, but where would we have updated the key of the reference to the
current leaf that we've just updated with a new index 0? Unless I'm
missing where that happens, it looks like we could end up with a busted
tree.

[1] Note that I'm not sure how possible this is atm if the sequential
append spillover logic is actually broken. That aside... at least with
that kind of logic in place, it seems you'd be able to fill up two
leaves sequentially, then remove all of the records from the first
without ever triggering a rebalance (until fill == 0) because the next
leaf is already full.

Even if I'm missing something here and/or with the spillover logic and
this is not a problem, I'd really like to see some DEBUG code attached
to this that validates the integrity of the tree every so often (after
certain operations, for example).

Brian

> +			goto remove_node;
> +		}
> +	}
> +
> +	return;
> +remove_node:
> +	if (leaf->prev)
> +		leaf->prev->next = leaf->next;
> +	if (leaf->next)
> +		leaf->next->prev = leaf->prev;
> +	xfs_iext_remove_node(ifp, offset, leaf);
> +}
> +
...
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
