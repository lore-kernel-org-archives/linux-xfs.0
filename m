Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 May 2007 21:32:51 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [65.172.181.25])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l444WmfB027913
	for <xfs@oss.sgi.com>; Thu, 3 May 2007 21:32:49 -0700
Date: Thu, 3 May 2007 21:32:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] ext4: write support for preallocated blocks/extents
Message-Id: <20070503213238.5cdb1585.akpm@linux-foundation.org>
In-Reply-To: <20070426181623.GE7209@amitarora.in.ibm.com>
References: <20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
	<20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071417.GI355@devserv.devel.redhat.com>
	<20070417125514.GA7574@amitarora.in.ibm.com>
	<20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070426181623.GE7209@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, 26 Apr 2007 23:46:23 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:

> This patch adds write support for preallocated (using fallocate system
> call) blocks/extents. The preallocated extents in ext4 are marked
> "uninitialized", hence they need special handling especially while
> writing to them. This patch takes care of that.
> 
> ...
>
>  /*
> + * ext4_ext_try_to_merge:
> + * tries to merge the "ex" extent to the next extent in the tree.
> + * It always tries to merge towards right. If you want to merge towards
> + * left, pass "ex - 1" as argument instead of "ex".
> + * Returns 0 if the extents (ex and ex+1) were _not_ merged and returns
> + * 1 if they got merged.

OK.

> + */
> +int ext4_ext_try_to_merge(struct inode *inode,
> +				struct ext4_ext_path *path,
> +				struct ext4_extent *ex)
> +{
> +	struct ext4_extent_header *eh;
> +	unsigned int depth, len;
> +	int merge_done=0, uninitialized = 0;

space around "=", please.

Many people prefer not to do the multiple-definitions-per-line, btw:

	int merge_done = 0;
	int uninitialized = 0;

reasons:

- If gives you some space for a nice comment

- It makes patches much more readable, and it makes rejects easier to fix

- standardisation.

> +	depth = ext_depth(inode);
> +	BUG_ON(path[depth].p_hdr == NULL);
> +	eh = path[depth].p_hdr;
> +
> +	while (ex < EXT_LAST_EXTENT(eh)) {
> +		if (!ext4_can_extents_be_merged(inode, ex, ex + 1))
> +			break;
> +		/* merge with next extent! */
> +		if (ext4_ext_is_uninitialized(ex))
> +			uninitialized = 1;
> +		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
> +					+ ext4_ext_get_actual_len(ex + 1));
> +		if (uninitialized)
> +			ext4_ext_mark_uninitialized(ex);
> +
> +		if (ex + 1 < EXT_LAST_EXTENT(eh)) {
> +			len = (EXT_LAST_EXTENT(eh) - ex - 1)
> +					* sizeof(struct ext4_extent);
> +			memmove(ex + 1, ex + 2, len);
> +		}
> +		eh->eh_entries = cpu_to_le16(le16_to_cpu(eh->eh_entries)-1);

Kenrel convention is to put spaces around "-"

> +		merge_done = 1;
> +		BUG_ON(eh->eh_entries == 0);

eek, scary BUG_ON.  Do we really need to be that severe?  Would it be
better to warn and run ext4_error() here?

> +	}
> +
> +	return merge_done;
> +}
> +
> +
>
> ...
>
> +/*
> + * ext4_ext_convert_to_initialized:
> + * this function is called by ext4_ext_get_blocks() if someone tries to write
> + * to an uninitialized extent. It may result in splitting the uninitialized
> + * extent into multiple extents (upto three). Atleast one initialized extent
> + * and atmost two uninitialized extents can result.

There are some typos here

> + * There are three possibilities:
> + *   a> No split required: Entire extent should be initialized.
> + *   b> Split into two extents: Only one end of the extent is being written to.
> + *   c> Split into three extents: Somone is writing in middle of the extent.

and here

> + */
> +int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
> +					struct ext4_ext_path *path,
> +					ext4_fsblk_t iblock,
> +					unsigned long max_blocks)
> +{
> +	struct ext4_extent *ex, *ex1 = NULL, *ex2 = NULL, *ex3 = NULL, newex;
> +	struct ext4_extent_header *eh;
> +	unsigned int allocated, ee_block, ee_len, depth;
> +	ext4_fsblk_t newblock;
> +	int err = 0, ret = 0;
> +
> +	depth = ext_depth(inode);
> +	eh = path[depth].p_hdr;
> +	ex = path[depth].p_ext;
> +	ee_block = le32_to_cpu(ex->ee_block);
> +	ee_len = ext4_ext_get_actual_len(ex);
> +	allocated = ee_len - (iblock - ee_block);
> +	newblock = iblock - ee_block + ext_pblock(ex);
> +	ex2 = ex;
> +
> +	/* ex1: ee_block to iblock - 1 : uninitialized */
> +	if (iblock > ee_block) {
> +		ex1 = ex;
> +		ex1->ee_len = cpu_to_le16(iblock - ee_block);
> +		ext4_ext_mark_uninitialized(ex1);
> +		ex2 = &newex;
> +	}
> +	/* for sanity, update the length of the ex2 extent before
> +	 * we insert ex3, if ex1 is NULL. This is to avoid temporary
> +	 * overlap of blocks.
> +	 */
> +	if (!ex1 && allocated > max_blocks)
> +		ex2->ee_len = cpu_to_le16(max_blocks);
> +	/* ex3: to ee_block + ee_len : uninitialised */
> +	if (allocated > max_blocks) {
> +		unsigned int newdepth;
> +		ex3 = &newex;
> +		ex3->ee_block = cpu_to_le32(iblock + max_blocks);
> +		ext4_ext_store_pblock(ex3, newblock + max_blocks);
> +		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
> +		ext4_ext_mark_uninitialized(ex3);
> +		err = ext4_ext_insert_extent(handle, inode, path, ex3);
> +		if (err)
> +			goto out;
> +		/* The depth, and hence eh & ex might change
> +		 * as part of the insert above.
> +		 */
> +		newdepth = ext_depth(inode);
> +		if (newdepth != depth)
> +		{

Use

		if (newdepth != depth) {

> +			depth=newdepth;

spaces

> +			path = ext4_ext_find_extent(inode, iblock, NULL);
> +			if (IS_ERR(path)) {
> +				err = PTR_ERR(path);
> +				path = NULL;
> +				goto out;
> +			}
> +			eh = path[depth].p_hdr;
> +			ex = path[depth].p_ext;
> +			if (ex2 != &newex)
> +				ex2 = ex;
> +		}
> +		allocated = max_blocks;
> +	}
> +	/* If there was a change of depth as part of the
> +	 * insertion of ex3 above, we need to update the length
> +	 * of the ex1 extent again here
> +	 */
> +	if (ex1 && ex1 != ex) {
> +		ex1 = ex;
> +		ex1->ee_len = cpu_to_le16(iblock - ee_block);
> +		ext4_ext_mark_uninitialized(ex1);
> +		ex2 = &newex;
> +	}
> +	/* ex2: iblock to iblock + maxblocks-1 : initialised */
> +	ex2->ee_block = cpu_to_le32(iblock);
> +	ex2->ee_start = cpu_to_le32(newblock);
> +	ext4_ext_store_pblock(ex2, newblock);
> +	ex2->ee_len = cpu_to_le16(allocated);
> +	if (ex2 != ex)
> +		goto insert;
> +	if ((err = ext4_ext_get_access(handle, inode, path + depth)))
> +		goto out;

The preferred style is

	err = ext4_ext_get_access(handle, inode, path + depth);
	if (err)
		goto out;

> +	/* New (initialized) extent starts from the first block
> +	 * in the current extent. i.e., ex2 == ex
> +	 * We have to see if it can be merged with the extent
> +	 * on the left.
> +	 */
> +	if (ex2 > EXT_FIRST_EXTENT(eh)) {
> +		/* To merge left, pass "ex2 - 1" to try_to_merge(),
> +		 * since it merges towards right _only_.
> +		 */
> +		ret = ext4_ext_try_to_merge(inode, path, ex2 - 1);
> +		if (ret) {
> +			err = ext4_ext_correct_indexes(handle, inode, path);
> +			if (err)
> +				goto out;
> +			depth = ext_depth(inode);
> +			ex2--;
> +		}
> +	}
> +	/* Try to Merge towards right. This might be required
> +	 * only when the whole extent is being written to.
> +	 * i.e. ex2==ex and ex3==NULL.
> +	 */
> +	if (!ex3) {
> +		ret = ext4_ext_try_to_merge(inode, path, ex2);
> +		if (ret) {
> +			err = ext4_ext_correct_indexes(handle, inode, path);
> +			if (err)
> +				goto out;
> +		}
> +	}
> +	/* Mark modified extent as dirty */
> +	err = ext4_ext_dirty(handle, inode, path + depth);
> +	goto out;
> +insert:
> +	err = ext4_ext_insert_extent(handle, inode, path, &newex);
> +out:
> +	return err ? err : allocated;
> +}

Sigh.  I hope you guys know how all this works, because the extent code is
a mystery to me.  Is the on-disk layout and the allocation strategy
described anywhere?

> +extern int ext4_ext_try_to_merge(struct inode *, struct ext4_ext_path *, struct ext4_extent *);

Again, I do think that sticking the identifiers in there helps
readability.  Although it is not as important in a boring old declaration
as it is in, say, inode_operations, etc.

Please try to keep the code looking nice in an 80-column display.
