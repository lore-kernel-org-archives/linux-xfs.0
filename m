Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59931 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbdKHRTG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Nov 2017 12:19:06 -0500
Date: Wed, 8 Nov 2017 18:19:05 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/21] xfs: use a b+tree for the in-core extent list
Message-ID: <20171108171905.GA30809@lst.de>
References: <20171103144539.2187-1-hch@lst.de> <20171103144539.2187-18-hch@lst.de> <20171108135032.GA39207@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171108135032.GA39207@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Nov 08, 2017 at 08:50:33AM -0500, Brian Foster wrote:
> > +	for (height = ifp->if_height; height > level; height--) {
> > +		for (i = 0; i < KEYS_PER_NODE; i++) {
> > +			if (i > 0 && xfs_iext_key_cmp(node, i, old_offset) > 0)
> > +				break;
> > +			if (node->keys[i] == old_offset)
> > +				node->keys[i] = new_offset;
> 
> The logic seems a bit convoluted. Is this not the same as something like
> the following:
> 
>                         if (xfs_iext_key_cmp(node, i, old_offset) == 0) {
>                                 node->keys[i] = new_offset;
>                                 node = node->ptrs[i];
>                                 break;
>                         }
> 
> (and kill the node assignment below)..?

No.  The big difference is that we need to handle non-exact matches.
Not every possible offset exists at the lower levels - we need to grab
the previous pointer as soon as a key is larger than the offset to deal
with offsets that are inside the next node, and not the first one.

> Hmm, so we walk the tree from the top and update any references to a
> particular key. I'm wondering why we wouldn't/couldn't do something a
> bit more efficient (and cautious) like walk from the leaf up using the
> find_level bits, then stop once we update a key that is not a zero
> index..?
> 
> I guess find_level() itself has to do a top-down walk each go around
> since we don't have any up-pointers, so maybe that answers my question.
> ;)

Yes.  Your above suggestion was my first naive implementation until
I noticed it is very ineffcient.

> Perhaps a more robust cursor could help us optimize some of these
> cases in the future without bloating the tree, if warranted.

Such a cursor would have to track a node + offset for each level,
so we couldn't easily keep it on the stack and would have to introduce
a memory allocation.

> > +static struct xfs_iext_leaf *
> > +xfs_iext_split_leaf(
> > +	struct xfs_iext_cursor	*cur,
> > +	int			*nr_entries)
> > +{
> > +	struct xfs_iext_leaf	*leaf = cur->leaf;
> > +	struct xfs_iext_leaf	*new = kmem_zalloc(NODE_SIZE, KM_NOFS);
> > +	const int		nr_move = RECS_PER_LEAF / 2;
> > +	int			nr_keep = nr_move + (RECS_PER_LEAF & 1);
> > +	int			i;
> > +
> > +	/* for sequential append operations just spill over into the new node */
> > +	if (cur->pos == KEYS_PER_NODE) {
> > +		cur->leaf = new;
> > +		cur->pos = 0;
> > +		*nr_entries = 0;
> > +		goto done;
> > +	}
> 
> Hmm, this is called when nr_entries is RECS_PER_LEAF, which is currently
> 15. KEYS_PER_NODE is currently 16, so when will the above ever occur?
> Wouldn't cur->pos point to 15 on a sequential append?

This should actually be RECS_PER_LEAF..

> > +	if (nr_keep & 1)
> > +		nr_keep++;
> > +
> 
> This also seems superfluous. nr_move is RECS_PER_LEAF/2 and so matches
> the parity of RECS_PER_LEAF. nr_keep is nr_move plus 1 iff RECS_PER_LEAF
> is odd, which looks like it means nr_keep is always even. Am I missing
> some other case..?

Yes, this should be dropped.  I'm pretty sure I got this right before,
I suspect I got some mismerge here when cleaning up the patch series.

> > +	size_t new_size = ifp->if_bytes + sizeof(struct xfs_iext_rec);
> > +	void *new;
> > +
> > +	/* account for the prev/next pointers */
> > +	if (new_size / sizeof(struct xfs_iext_rec) == RECS_PER_LEAF)
> > +		new_size = NODE_SIZE;
> > +
> > +	new = kmem_realloc(ifp->if_u1.if_root, new_size, KM_NOFS);
> > +	memset(new + ifp->if_bytes, 0, new_size - ifp->if_bytes);
> > +	ifp->if_u1.if_root = new;
> > +	cur->leaf = new;
> 
> I don't think it's an immediate problem, but this look like a bit of a
> landmine because of how we update to the node size. The first time that
> we bump up to NODE_SIZE it looks like we zero everything properly. We
> call this again however in the case where the leaf would need to be
> split. The new_size doesn't change and so I suspect the realloc doesn't
> do anything, but we still zero over the last part of the structure as if
> it were going to be a new record.

It will zero the next/prev pointers again which is pointless, but also
harmless because we don't use the next/prev pointers for  a single-level
tree.  I'll see if I can avoid it somehow.

> A comment would be nice here since the function names are a bit vague
> (to me). I.e., point out we're updating the keys up the tree unless
> we've added a new node, since a new node hasn't been added to the tree
> yet.

Ok.

> > +		node = xfs_iext_rebalance_node(parent, &pos, node, nr_entries);
> > +		if (node) {
> > +			offset = node->keys[0];
> 
> It doesn't look like there is any need to update offset here. It will be
> overwritten above.

Indeed, fixed.

> > +	} else if (nr_entries == 1) {
> > +		ASSERT(node == ifp->if_u1.if_root);
> > +		ifp->if_u1.if_root = node->ptrs[0];
> > +		ifp->if_height--;
> > +		kmem_free(node);
> > +	}
> > +}
> > +
> 
> These lower level rebalance functions could really use some comments.
> It's easy to lose track of the current state of things, for example, why
> we pass leaf separate from cursor...
> 
> > +static void
> > +xfs_iext_rebalance_leaf(
> > +	struct xfs_ifork	*ifp,
> > +	struct xfs_iext_cursor	*cur,
> > +	struct xfs_iext_leaf	*leaf,
> > +	xfs_fileoff_t		offset,
> > +	int			fill)
> > +{
> > +	if (leaf->prev) {
> > +		int nr_prev = xfs_iext_leaf_nr_entries(ifp, leaf->prev, 0), i;
> > +
> 
> ... and then why we do things like remove the current node vs. the next
> node in the below hunks. I'm guessing that is to easily preserve record
> order by always filling backwards, and perhaps implicitly avoid the need
> for key updates as part of the rebalance itself..?

Mostly for the latter.  Preserving the order would be doable even
without that.

> > +	if (leaf->next) {
> > +		int nr_next = xfs_iext_leaf_nr_entries(ifp, leaf->next, 0), i;
> > +
> > +		if (fill + nr_next <= RECS_PER_LEAF) {
> > +			for (i = 0; i < nr_next; i++)
> > +				leaf->recs[fill + i] = leaf->next->recs[i];
> > +
> > +			if (cur->leaf == leaf->next) {
> > +				cur->leaf = leaf;
> > +				cur->pos += fill;
> > +			}
> > +
> > +			offset = xfs_iext_leaf_key(leaf->next, 0);
> > +			leaf = leaf->next;
> 
> If fill happens to be 0 [1] because we've emptied the first leaf in the
> tree, we end up here where we copy all of the records from the next leaf
> to the empty leaf. We therefore update recs[0] of the empty leaf, set
> 'offset' to the key of the next and proceed to delete that next leaf.

Yeah, we can handle it the same way as for the lower levels.  Note that
you don't need the sequential insert logic to trigger it - just fill
up at least three nodes entirely after they are split and delete all th
e entries in the middle one then.  This might even be doable with an
xfstest.
