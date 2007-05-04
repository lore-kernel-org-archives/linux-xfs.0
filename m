Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 May 2007 21:31:48 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [65.172.181.25])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l444VhfB027433
	for <xfs@oss.sgi.com>; Thu, 3 May 2007 21:31:44 -0700
Date: Thu, 3 May 2007 21:31:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-Id: <20070503213133.d1559f52.akpm@linux-foundation.org>
In-Reply-To: <20070426181332.GD7209@amitarora.in.ibm.com>
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
	<20070426181332.GD7209@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, 26 Apr 2007 23:43:32 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:

> This patch has the ext4 implemtation of fallocate system call.
> 
> ...
>
> +		/* ext4_can_extents_be_merged should have checked that either
> +		 * both extents are uninitialized, or both aren't. Thus we
> +		 * need to check only one of them here.
> +		 */

Please always format multiline comments like this:

		/*
		 * ext4_can_extents_be_merged should have checked that either
		 * both extents are uninitialized, or both aren't. Thus we
		 * need to check only one of them here.
		 */

> ...
>
> +/*
> + * ext4_fallocate:
> + * preallocate space for a file
> + * mode is for future use, e.g. for unallocating preallocated blocks etc.
> + */

This description is rather thin.  What is the filesystem's actual behaviour
here?  If the file is using extents then the implementation will do
<something>.  If the file is using bitmaps then we will do <something else>.

But what?   Here is where it should be described.

> +int ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
> +{
> +	handle_t *handle;
> +	ext4_fsblk_t block, max_blocks;
> +	int ret, ret2, nblocks = 0, retries = 0;
> +	struct buffer_head map_bh;
> +	unsigned int credits, blkbits = inode->i_blkbits;
> +
> +	/* Currently supporting (pre)allocate mode _only_ */
> +	if (mode != FA_ALLOCATE)
> +		return -EOPNOTSUPP;
> +
> +	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> +		return -ENOTTY;

So we don't implement fallocate on bitmap-based files!  Well that's huge
news.  The changelog would be an appropriate place to communicate this,
along with reasons why, or a description of the plan to fix it.

Also, posix says nothing about fallocate() returning ENOTTY.

> +	block = offset >> blkbits;
> +	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
> +			 - block;
> +	mutex_lock(&EXT4_I(inode)->truncate_mutex);
> +	credits = ext4_ext_calc_credits_for_insert(inode, NULL);
> +	mutex_unlock(&EXT4_I(inode)->truncate_mutex);

Now I'm mystified.  Given that we're allocating an arbitrary amount of disk
space, and that this disk space will require an arbitrary amount of
metadata, how can we work out how much journal space we'll be needing
without at least looking at `len'?

> +	handle=ext4_journal_start(inode, credits +

Please always put spaces around "="

> +					EXT4_DATA_TRANS_BLOCKS(inode->i_sb)+1);

And around "+"

> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +retry:
> +	ret = 0;
> +	while (ret >= 0 && ret < max_blocks) {
> +		block = block + ret;
> +		max_blocks = max_blocks - ret;
> +		ret = ext4_ext_get_blocks(handle, inode, block,
> +					  max_blocks, &map_bh,
> +					  EXT4_CREATE_UNINITIALIZED_EXT, 0);
> +		BUG_ON(!ret);

BUG_ON is vicious.  Is it really justified here?  Possibly a WARN_ON and
ext4_error() would be safer and more useful here.

> +		if (ret > 0 && test_bit(BH_New, &map_bh.b_state)

Use buffer_new() here.   A separate patch which fixes the three existing
instances of open-coded BH_foo usage would be appreciated.

> +			&& ((block + ret) > (i_size_read(inode) << blkbits)))

Check for wrap though the sign bit and through zero please.

> +			nblocks = nblocks + ret;
> +	}
> +
> +	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> +		goto retry;
> +
> +	/* Time to update the file size.
> +	 * Update only when preallocation was requested beyond the file size.
> +	 */

Fix comment layout.

> +	if ((offset + len) > i_size_read(inode)) {

Both the lhs and the rhs here are signed.  Please review for possible
overflows through the sign bit and through zero.  Perhaps a comment
explaining why it's correct would be appropriate.


> +		if (ret > 0) {
> +		/* if no error, we assume preallocation succeeded completely */
> +			mutex_lock(&inode->i_mutex);
> +			i_size_write(inode, offset + len);
> +			EXT4_I(inode)->i_disksize = i_size_read(inode);
> +			mutex_unlock(&inode->i_mutex);
> +		} else if (ret < 0 && nblocks) {
> +		/* Handle partial allocation scenario */

The above two comments should be indented one additional tabstop.

> +			loff_t newsize;
> +			mutex_lock(&inode->i_mutex);
> +			newsize  = (nblocks << blkbits) + i_size_read(inode);
> +			i_size_write(inode, EXT4_BLOCK_ALIGN(newsize, blkbits));
> +			EXT4_I(inode)->i_disksize = i_size_read(inode);
> +			mutex_unlock(&inode->i_mutex);
> +		}
> +	}
> +	ext4_mark_inode_dirty(handle, inode);
> +	ret2 = ext4_journal_stop(handle);
> +	if (ret > 0)
> +		ret = ret2;
> +
> +	return ret > 0 ? 0 : ret;
> +}
> +
>  EXPORT_SYMBOL(ext4_mark_inode_dirty);
>  EXPORT_SYMBOL(ext4_ext_invalidate_cache);
>  EXPORT_SYMBOL(ext4_ext_insert_extent);
>  EXPORT_SYMBOL(ext4_ext_walk_space);
>  EXPORT_SYMBOL(ext4_ext_find_goal);
>  EXPORT_SYMBOL(ext4_ext_calc_credits_for_insert);
> +EXPORT_SYMBOL(ext4_fallocate);
>  
> Index: linux-2.6.21/fs/ext4/file.c
> ===================================================================
> --- linux-2.6.21.orig/fs/ext4/file.c
> +++ linux-2.6.21/fs/ext4/file.c
> @@ -135,5 +135,6 @@ const struct inode_operations ext4_file_
>  	.removexattr	= generic_removexattr,
>  #endif
>  	.permission	= ext4_permission,
> +	.fallocate	= ext4_fallocate,
>  };
>  
> Index: linux-2.6.21/include/linux/ext4_fs.h
> ===================================================================
> --- linux-2.6.21.orig/include/linux/ext4_fs.h
> +++ linux-2.6.21/include/linux/ext4_fs.h
> @@ -102,6 +102,8 @@
>  				 EXT4_GOOD_OLD_FIRST_INO : \
>  				 (s)->s_first_ino)
>  #endif
> +#define EXT4_BLOCK_ALIGN(size, blkbits) 	(((size)+(1 << blkbits)-1) & \
> +							(~((1 << blkbits)-1)))

Maybe a comment describing what this does?  Probably it's obvious enough.

I think it could use the standard ALIGN macro.

Is blkbits sufficiently parenthesised here?  Even if it is, adding the
parens would be better practice.

>  /*
>   * Macro-instructions used to manage fragments
> @@ -225,6 +227,10 @@ struct ext4_new_group_data {
>  	__u32 free_blocks_count;
>  };
>  
> +/* Following is used by preallocation logic to tell get_blocks() that we
> + * want uninitialzed extents.
> + */

Please convert all newly-added multiline comments to the preferred layout.

> +#define EXT4_CREATE_UNINITIALIZED_EXT		2
>  
>  /*
>   * ioctl commands
> @@ -976,6 +982,7 @@ extern int ext4_ext_get_blocks(handle_t 
>  extern void ext4_ext_truncate(struct inode *, struct page *);
>  extern void ext4_ext_init(struct super_block *);
>  extern void ext4_ext_release(struct super_block *);
> +extern int ext4_fallocate(struct inode *, int, loff_t, loff_t);

argh.  And feel free to give these args some useful names.

>  static inline int
>  ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
>  			unsigned long max_blocks, struct buffer_head *bh,
> Index: linux-2.6.21/include/linux/ext4_fs_extents.h
> ===================================================================
> --- linux-2.6.21.orig/include/linux/ext4_fs_extents.h
> +++ linux-2.6.21/include/linux/ext4_fs_extents.h
> @@ -125,6 +125,19 @@ struct ext4_ext_path {
>  #define EXT4_EXT_CACHE_EXTENT	2
>  
>  /*
> + * Macro-instructions to handle (mark/unmark/check/create) unitialized
> + * extents. Applications can issue an IOCTL for preallocation, which results
> + * in assigning unitialized extents to the file.
> + */
> +#define ext4_ext_mark_uninitialized(ext)	((ext)->ee_len |= \
> +							cpu_to_le16(0x8000))
> +#define ext4_ext_is_uninitialized(ext)  	((le16_to_cpu((ext)->ee_len))& \
> +									0x8000)
> +#define ext4_ext_get_actual_len(ext)		((le16_to_cpu((ext)->ee_len))& \
> +									0x7FFF)

inlined C functions are preferred, and I think these could be implemented
that way.
