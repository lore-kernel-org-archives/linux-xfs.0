Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2D64qRo207739 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 01:04:52 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UctKRH4vvMNyWWaJ for <xfs@oss.sgi.com>;
	Mon, 12 Mar 2012 23:04:48 -0700 (PDT)
Date: Tue, 13 Mar 2012 17:04:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: repeatable attribute corruption
Message-ID: <20120313060444.GE5091@dastard>
References: <1331589615.25204.35.camel@montana.filmlight.ltd.uk>
	<20120313042216.GD5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313042216.GD5091@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

On Tue, Mar 13, 2012 at 03:22:16PM +1100, Dave Chinner wrote:
> On Mon, Mar 12, 2012 at 10:00:15PM +0000, Roger Willcocks wrote:
> > Hi folks,
> > 
> > On stock CentOS kernels from 5.5 (earliest I tried) through to the
> > latest 6.2 kernel (as of five days ago) 2.6.32-220.7.1.el6.x86_64 I can
> > repeatedly create a silent on-disk corruption. This typically shows up
> > later as:
> > 
> > XFS internal error xfs_da_do_buf(1) at line 2020 of
> > file /usr/src/redhat/BUILD/kernel-2.6.18/linux-2.6.18.x86_64/fs/xfs/xfs_da_btree.c
> > 
> > (or line 2112 of the same file).
> > 
> > The 'before' metadump is a bit big to attach to an email (~600k) so
> > here's a download link valid for 30 days -
> > 
> > http://private.filmlight.ltd.uk/c4c864ecca4ac13b/xfs_attrib_crash.taz
> > 
> > - this is a gzip-compressed tar file containing 
> > 
> > -rw-r--r--.  1 root root   10885632 Mar 12 18:02 xfs_metadump_hda6
> > -rw-r--r--.  1 root root       3558 Mar 12 18:15 zap.txt
> > 
> > The metadump expands to about 5GB. xfs_repair believes it to be clean.
> > I've not obfuscated the dump; it was originally a copy of the linux
> > header directory from the 5.5 kernel.
> > 
> > 'zap.txt' simply overwrites a single existing extended (directory)
> > attribute with a slightly longer value. So, steps to repeat:
> > 
> > # xfs_mdrestore xfs_metadump_hda6 xfs.img 
> > # mkdir /mnt/disk1
> > # mount -o loop xfs.img /mnt/disk1
> > # setfattr --restore=zap.txt
> > # umount /mnt/disk1
> > # xfs_repair -n xfs.img
> > ...
> > bad sibling back pointer for block 4 in attribute fork for inode 131
> > problem with attribute contents in inode 131
> > would clear attr fork
> > bad nblocks 8 for inode 131, would reset to 3
> > bad anextents 4 for inode 131, would reset to 0
> > ...
> 
> OK, I've reproduced it. There's some kind of problem in the atomic
> attribute rename code when the new attribute gets has to be moved
> into a new block.
....

> So there's been multiple blocks added, but not enough removed, and
> somewhere along the line the ordering of them has been screwed up.
> Both copies of the attribute that remain are marked complete, so
> something is definitely screwed up here.
> 
> First thing I need to do is add tracing to the attribute
> modification code to find out what is going on here....

And the tracing shows just how complex a "simple" operation can be:

xfs_ilock:            dev 7:0 ino 0x83 flags ILOCK_EXCL caller xfs_attr_set_int
xfs_attr_node_addname: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags ADDNAME|OKNOENT
xfs_attr_leaf_lookup: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags ADDNAME|OKNOENT
xfs_attr_node_replace: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags ADDNAME|OKNOENT

Here we see adding the new attribute has detected that it is a
replacement of an existing attribute, so it triggers the atomic
rename behaviour. First thing it tries to do is add the new
attribute with an "incomplete" flag.


xfs_attr_leaf_add:    dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_da_split:         dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_attr_leaf_split:  dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT

The new attribute doesn't fit into the existing leaf, so it splits.

xfs_da_grow_inode:    dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_iext_insert:      dev 7:0 ino 0x83 state ATTR idx 3 offset 3 block 622 count 1 flag 0 caller xfs_bmap_add_extent_hole_real

so a block at fab 622 was added, and a rebalance was done:

xfs_attr_leaf_create: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_attr_leaf_rebalance: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT

Now it tries to add the new attribute again, and finds it doesn't
fit into either of the rebalanced blocks:

xfs_attr_leaf_add:    dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_attr_leaf_split:  dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT

so it grows again:

xfs_da_grow_inode:    dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_bmap_post_update: dev 7:0 ino 0x83 state LC|ATTR idx 3 offset 3 block 622 count 2 flag 0 caller xfs_bmap_add_extent_hole_real

And it is block 623 that was added. It now tries to rebalance again,
and add the entry again. This time it does a node split onto the new
block, andch results in a successful add, and then it commits the
transaction:

xfs_attr_leaf_create: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_attr_leaf_rebalance: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_attr_leaf_add:    dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_da_node_split:    dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_da_node_add:      dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_da_node_add:      dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_inode_pin:        dev 7:0 ino 0x83 count 1 pincount 0 caller xfs_cil_prepare_item.isra.1
xfs_log_done_perm:    dev 7:0 type ATTR_SET .....

At this point, we have an attribute tree that has two copies of the
attribute - the old and the new - with the new entry having the
incomplete flag set in it. The transaction has committed, so we are
ready to do the atomic swap:

xfs_attr_leaf_flipflags: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_log_done_perm:    dev 7:0 type ATTR_SET ....

We've now changed the incomplete flag to be on the old entry, so now
the new entry is the valid one. The final trnasaction will remove
the old entry, the stale blocks and rebalance the attribute tree:

xfs_attr_leaf_lookup: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_attr_leaf_lookup: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_attr_leaf_lookup: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_da_join:          dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_attr_leaf_unbalance: dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_da_shrink_inode:  dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_bunmap:           dev 7:0 ino 0x83 size 0x2000 bno 0x3 len 0x1flags METADATA|ATTRFORK caller xfs_da_shrink_inode
xfs_bmap_pre_update:  dev 7:0 ino 0x83 state ATTR idx 3 offset 3 block 622 count 2 flag 0 caller xfs_bmap_del_extent
xfs_bmap_post_update: dev 7:0 ino 0x83 state ATTR idx 3 offset 4 block 623 count 1 flag 0 caller xfs_bmap_del_extent
xfs_da_node_remove:   dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_da_root_join:     dev 7:0 ino 0x83 name FLAX_OTHER namelen 10 hashval 0xb611400d inumber 0x0 op_flags RENAME|ADDNAME|OKNOENT
xfs_log_done_perm:    dev 7:0 type ATTR_SET ...
xfs_free_extent:      dev 7:0 agno 0 agbno 622 len 1 isfl 0 none
xfs_alloc_busy:       dev 7:0 agno 0 agbno 622 len 1
xfs_log_done_perm:    dev 7:0 type ATTR_SET ....

And what we see here is only block 622 is freed. So we added two
blocks to the tree, but only removed one, but ended up with all the
attributes fitting back in the original two leaf blocks.

I suspect this is rarely travelled code - the replacement of the
attribute where it requires two new blocks, splits and rebalances to
occur before an add can be made is likely to be a rarely trodden
path, and it's probably rarer that the removal path ends up with the
new attribute fitting in the old block and so has to clean up the
two added blocks at once.

more in-depth tracing is required to understand where it is going
wrong. The patch that created the above traces is below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: add lots of attribute trace points

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c      |   16 ++++++++++++++
 fs/xfs/xfs_attr_leaf.c |   33 +++++++++++++++++++++++++++-
 fs/xfs/xfs_da_btree.c  |   26 +++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |   54 ++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 125 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 08b9ac6..65d61b9 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -853,6 +853,8 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 {
 	int newsize, forkoff, retval;
 
+	trace_xfs_attr_sf_addname(args);
+
 	retval = xfs_attr_shortform_lookup(args);
 	if ((args->flags & ATTR_REPLACE) && (retval == ENOATTR)) {
 		return(retval);
@@ -896,6 +898,8 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	xfs_dabuf_t *bp;
 	int retval, error, committed, forkoff;
 
+	trace_xfs_attr_leaf_addname(args);
+
 	/*
 	 * Read the (only) block in the attribute list in.
 	 */
@@ -920,6 +924,9 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 			xfs_da_brelse(args->trans, bp);
 			return(retval);
 		}
+
+		trace_xfs_attr_leaf_replace(args);
+
 		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic rename */
 		args->blkno2 = args->blkno;		/* set 2nd entry info*/
 		args->index2 = args->index;
@@ -1090,6 +1097,8 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
 	xfs_dabuf_t *bp;
 	int error, committed, forkoff;
 
+	trace_xfs_attr_leaf_removename(args);
+
 	/*
 	 * Remove the attribute.
 	 */
@@ -1223,6 +1232,8 @@ xfs_attr_node_addname(xfs_da_args_t *args)
 	xfs_mount_t *mp;
 	int committed, retval, error;
 
+	trace_xfs_attr_node_addname(args);
+
 	/*
 	 * Fill in bucket of arguments/results/context to carry around.
 	 */
@@ -1249,6 +1260,9 @@ restart:
 	} else if (retval == EEXIST) {
 		if (args->flags & ATTR_CREATE)
 			goto out;
+
+		trace_xfs_attr_node_replace(args);
+
 		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
 		args->blkno2 = args->blkno;		/* set 2nd entry info*/
 		args->index2 = args->index;
@@ -1480,6 +1494,8 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	xfs_dabuf_t *bp;
 	int retval, error, committed, forkoff;
 
+	trace_xfs_attr_node_removename(args);
+
 	/*
 	 * Tie a string around our finger to remind us where we are.
 	 */
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index d25eafd..73c0679 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -235,6 +235,8 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
 	xfs_inode_t *dp;
 	xfs_ifork_t *ifp;
 
+	trace_xfs_attr_sf_create(args);
+
 	dp = args->dp;
 	ASSERT(dp != NULL);
 	ifp = dp->i_afp;
@@ -268,6 +270,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 	xfs_inode_t *dp;
 	xfs_ifork_t *ifp;
 
+	trace_xfs_attr_sf_add(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	dp->i_d.di_forkoff = forkoff;
@@ -337,6 +341,8 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 	xfs_mount_t *mp;
 	xfs_inode_t *dp;
 
+	trace_xfs_attr_sf_remove(args);
+
 	dp = args->dp;
 	mp = dp->i_mount;
 	base = sizeof(xfs_attr_sf_hdr_t);
@@ -405,6 +411,8 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 	int i;
 	xfs_ifork_t *ifp;
 
+	trace_xfs_attr_sf_lookup(args);
+
 	ifp = args->dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
@@ -476,6 +484,8 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 	xfs_dabuf_t *bp;
 	xfs_ifork_t *ifp;
 
+	trace_xfs_attr_sf_to_leaf(args);
+
 	dp = args->dp;
 	ifp = dp->i_afp;
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
@@ -775,6 +785,8 @@ xfs_attr_leaf_to_shortform(xfs_dabuf_t *bp, xfs_da_args_t *args, int forkoff)
 	char *tmpbuffer;
 	int error, i;
 
+	trace_xfs_attr_leaf_to_sf(args);
+
 	dp = args->dp;
 	tmpbuffer = kmem_alloc(XFS_LBSIZE(dp->i_mount), KM_SLEEP);
 	ASSERT(tmpbuffer != NULL);
@@ -848,6 +860,8 @@ xfs_attr_leaf_to_node(xfs_da_args_t *args)
 	xfs_dablk_t blkno;
 	int error;
 
+	trace_xfs_attr_leaf_to_node(args);
+
 	dp = args->dp;
 	bp1 = bp2 = NULL;
 	error = xfs_da_grow_inode(args, &blkno);
@@ -911,6 +925,8 @@ xfs_attr_leaf_create(xfs_da_args_t *args, xfs_dablk_t blkno, xfs_dabuf_t **bpp)
 	xfs_dabuf_t *bp;
 	int error;
 
+	trace_xfs_attr_leaf_create(args);
+
 	dp = args->dp;
 	ASSERT(dp != NULL);
 	error = xfs_da_get_buf(args->trans, args->dp, blkno, -1, &bp,
@@ -948,6 +964,8 @@ xfs_attr_leaf_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	xfs_dablk_t blkno;
 	int error;
 
+	trace_xfs_attr_leaf_split(state->args);
+
 	/*
 	 * Allocate space for a new leaf node.
 	 */
@@ -1001,6 +1019,8 @@ xfs_attr_leaf_add(xfs_dabuf_t *bp, xfs_da_args_t *args)
 	xfs_attr_leaf_map_t *map;
 	int tablesize, entsize, sum, tmp, i;
 
+	trace_xfs_attr_leaf_add(args);
+
 	leaf = bp->data;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT((args->index >= 0)
@@ -1128,8 +1148,6 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, xfs_da_args_t *args, int mapindex)
 	       (be32_to_cpu(entry->hashval) <= be32_to_cpu((entry+1)->hashval)));
 
 	/*
-	 * Copy the attribute name and value into the new space.
-	 *
 	 * For "remote" attribute values, simply note that we need to
 	 * allocate space for the "remote" value.  We can't actually
 	 * allocate the extents in this transaction, and we can't decide
@@ -1265,6 +1283,8 @@ xfs_attr_leaf_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	ASSERT(leaf2->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	args = state->args;
 
+	trace_xfs_attr_leaf_rebalance(args);
+
 	/*
 	 * Check ordering of blocks, reverse if it makes things simpler.
 	 *
@@ -1810,6 +1830,8 @@ xfs_attr_leaf_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 	xfs_mount_t *mp;
 	char *tmpbuffer;
 
+	trace_xfs_attr_leaf_unbalance(state->args);
+
 	/*
 	 * Set up environment.
 	 */
@@ -1919,6 +1941,8 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp, xfs_da_args_t *args)
 	int probe, span;
 	xfs_dahash_t hashval;
 
+	trace_xfs_attr_leaf_lookup(args);
+
 	leaf = bp->data;
 	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
 	ASSERT(be16_to_cpu(leaf->hdr.count)
@@ -2445,6 +2469,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *args)
 	char *name;
 #endif /* DEBUG */
 
+	trace_xfs_attr_leaf_clearflag(args);
 	/*
 	 * Set up the operation.
 	 */
@@ -2509,6 +2534,8 @@ xfs_attr_leaf_setflag(xfs_da_args_t *args)
 	xfs_dabuf_t *bp;
 	int error;
 
+	trace_xfs_attr_leaf_setflag(args);
+
 	/*
 	 * Set up the operation.
 	 */
@@ -2565,6 +2592,8 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *args)
 	char *name1, *name2;
 #endif /* DEBUG */
 
+	trace_xfs_attr_leaf_flipflags(args);
+
 	/*
 	 * Read the block containing the "old" attr
 	 */
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 77c7425..2ce0e28 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -108,6 +108,8 @@ xfs_da_node_create(xfs_da_args_t *args, xfs_dablk_t blkno, int level,
 	int error;
 	xfs_trans_t *tp;
 
+	trace_xfs_da_node_create(args);
+
 	tp = args->trans;
 	error = xfs_da_get_buf(tp, args->dp, blkno, -1, &bp, whichfork);
 	if (error)
@@ -140,6 +142,8 @@ xfs_da_split(xfs_da_state_t *state)
 	xfs_dabuf_t *bp;
 	int max, action, error, i;
 
+	trace_xfs_da_split(state->args);
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
@@ -300,6 +304,8 @@ xfs_da_root_split(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	xfs_mount_t *mp;
 	xfs_dir2_leaf_t *leaf;
 
+	trace_xfs_da_root_split(state->args);
+
 	/*
 	 * Copy the existing (incorrect) block from the root node position
 	 * to a free space somewhere.
@@ -380,6 +386,8 @@ xfs_da_node_split(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	int newcount, error;
 	int useextra;
 
+	trace_xfs_da_node_split(state->args);
+
 	node = oldblk->bp->data;
 	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 
@@ -466,6 +474,8 @@ xfs_da_node_rebalance(xfs_da_state_t *state, xfs_da_state_blk_t *blk1,
 	int count, tmp;
 	xfs_trans_t *tp;
 
+	trace_xfs_da_node_rebalance(state->args);
+
 	node1 = blk1->bp->data;
 	node2 = blk2->bp->data;
 	/*
@@ -574,6 +584,8 @@ xfs_da_node_add(xfs_da_state_t *state, xfs_da_state_blk_t *oldblk,
 	xfs_da_node_entry_t *btree;
 	int tmp;
 
+	trace_xfs_da_node_add(state->args);
+
 	node = oldblk->bp->data;
 	ASSERT(node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
 	ASSERT((oldblk->index >= 0) && (oldblk->index <= be16_to_cpu(node->hdr.count)));
@@ -619,6 +631,8 @@ xfs_da_join(xfs_da_state_t *state)
 	xfs_da_state_blk_t *drop_blk, *save_blk;
 	int action, error;
 
+	trace_xfs_da_join(state->args);
+
 	action = 0;
 	drop_blk = &state->path.blk[ state->path.active-1 ];
 	save_blk = &state->altpath.blk[ state->path.active-1 ];
@@ -723,6 +737,8 @@ xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
 	xfs_dabuf_t *bp;
 	int error;
 
+	trace_xfs_da_root_join(state->args);
+
 	args = state->args;
 	ASSERT(args != NULL);
 	ASSERT(root_blk->magic == XFS_DA_NODE_MAGIC);
@@ -941,6 +957,8 @@ xfs_da_node_remove(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk)
 	xfs_da_node_entry_t *btree;
 	int tmp;
 
+	trace_xfs_da_node_remove(state->args);
+
 	node = drop_blk->bp->data;
 	ASSERT(drop_blk->index < be16_to_cpu(node->hdr.count));
 	ASSERT(drop_blk->index >= 0);
@@ -984,6 +1002,8 @@ xfs_da_node_unbalance(xfs_da_state_t *state, xfs_da_state_blk_t *drop_blk,
 	int tmp;
 	xfs_trans_t *tp;
 
+	trace_xfs_da_node_unbalance(state->args);
+
 	drop_node = drop_blk->bp->data;
 	save_node = save_blk->bp->data;
 	ASSERT(drop_node->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC));
@@ -1652,6 +1672,8 @@ xfs_da_grow_inode(
 	int			count;
 	int			error;
 
+	trace_xfs_da_grow_inode(args);
+
 	if (args->whichfork == XFS_DATA_FORK) {
 		bno = args->dp->i_mount->m_dirleafblk;
 		count = args->dp->i_mount->m_dirblkfsbs;
@@ -1690,6 +1712,8 @@ xfs_da_swap_lastblock(xfs_da_args_t *args, xfs_dablk_t *dead_blknop,
 	xfs_dir2_leaf_t *dead_leaf2;
 	xfs_dahash_t dead_hash;
 
+	trace_xfs_da_swap_lastblock(args);
+
 	dead_buf = *dead_bufp;
 	dead_blkno = *dead_blknop;
 	tp = args->trans;
@@ -1878,6 +1902,8 @@ xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 	xfs_trans_t *tp;
 	xfs_mount_t *mp;
 
+	trace_xfs_da_shrink_inode(args);
+
 	dp = args->dp;
 	w = args->whichfork;
 	tp = args->trans;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3b369c1..cde466b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1408,7 +1408,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
 
-DECLARE_EVENT_CLASS(xfs_dir2_class,
+DECLARE_EVENT_CLASS(xfs_da_class,
 	TP_PROTO(struct xfs_da_args *args),
 	TP_ARGS(args),
 	TP_STRUCT__entry(
@@ -1443,7 +1443,7 @@ DECLARE_EVENT_CLASS(xfs_dir2_class,
 )
 
 #define DEFINE_DIR2_EVENT(name) \
-DEFINE_EVENT(xfs_dir2_class, name, \
+DEFINE_EVENT(xfs_da_class, name, \
 	TP_PROTO(struct xfs_da_args *args), \
 	TP_ARGS(args))
 DEFINE_DIR2_EVENT(xfs_dir2_sf_addname);
@@ -1472,6 +1472,56 @@ DEFINE_DIR2_EVENT(xfs_dir2_node_replace);
 DEFINE_DIR2_EVENT(xfs_dir2_node_removename);
 DEFINE_DIR2_EVENT(xfs_dir2_node_to_leaf);
 
+#define DEFINE_ATTR_EVENT(name) \
+DEFINE_EVENT(xfs_da_class, name, \
+	TP_PROTO(struct xfs_da_args *args), \
+	TP_ARGS(args))
+DEFINE_ATTR_EVENT(xfs_attr_sf_add);
+DEFINE_ATTR_EVENT(xfs_attr_sf_addname);
+DEFINE_ATTR_EVENT(xfs_attr_sf_create);
+DEFINE_ATTR_EVENT(xfs_attr_sf_lookup);
+DEFINE_ATTR_EVENT(xfs_attr_sf_remove);
+DEFINE_ATTR_EVENT(xfs_attr_sf_removename);
+DEFINE_ATTR_EVENT(xfs_attr_sf_to_leaf);
+
+DEFINE_ATTR_EVENT(xfs_attr_leaf_add);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_addname);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_create);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_lookup);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_replace);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_removename);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_split);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_clearflag);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_setflag);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_flipflags);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_to_sf);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_to_node);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_rebalance);
+DEFINE_ATTR_EVENT(xfs_attr_leaf_unbalance);
+
+DEFINE_ATTR_EVENT(xfs_attr_node_addname);
+DEFINE_ATTR_EVENT(xfs_attr_node_lookup);
+DEFINE_ATTR_EVENT(xfs_attr_node_replace);
+DEFINE_ATTR_EVENT(xfs_attr_node_removename);
+
+#define DEFINE_DA_EVENT(name) \
+DEFINE_EVENT(xfs_da_class, name, \
+	TP_PROTO(struct xfs_da_args *args), \
+	TP_ARGS(args))
+DEFINE_DA_EVENT(xfs_da_split);
+DEFINE_DA_EVENT(xfs_da_join);
+DEFINE_DA_EVENT(xfs_da_root_split);
+DEFINE_DA_EVENT(xfs_da_root_join);
+DEFINE_DA_EVENT(xfs_da_node_add);
+DEFINE_DA_EVENT(xfs_da_node_create);
+DEFINE_DA_EVENT(xfs_da_node_split);
+DEFINE_DA_EVENT(xfs_da_node_remove);
+DEFINE_DA_EVENT(xfs_da_node_rebalance);
+DEFINE_DA_EVENT(xfs_da_node_unbalance);
+DEFINE_DA_EVENT(xfs_da_swap_lastblock);
+DEFINE_DA_EVENT(xfs_da_grow_inode);
+DEFINE_DA_EVENT(xfs_da_shrink_inode);
+
 DECLARE_EVENT_CLASS(xfs_dir2_space_class,
 	TP_PROTO(struct xfs_da_args *args, int idx),
 	TP_ARGS(args, idx),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
