Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 05:11:58 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l47CBqfB003761
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 05:11:54 -0700
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l47C7E7Y027576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 08:07:15 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l47C3sWu029214
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 08:03:54 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l47C7CFZ184746
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 06:07:12 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l47C7CKS012675
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 06:07:12 -0600
Date: Mon, 7 May 2007 17:37:19 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-ID: <20070507120719.GD7012@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181332.GD7209@amitarora.in.ibm.com> <20070503213133.d1559f52.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503213133.d1559f52.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, May 03, 2007 at 09:31:33PM -0700, Andrew Morton wrote:
> On Thu, 26 Apr 2007 23:43:32 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> 
> > This patch has the ext4 implemtation of fallocate system call.
> > 
> > ...
> >
> > +		/* ext4_can_extents_be_merged should have checked that either
> > +		 * both extents are uninitialized, or both aren't. Thus we
> > +		 * need to check only one of them here.
> > +		 */
> 
> Please always format multiline comments like this:
> 
> 		/*
> 		 * ext4_can_extents_be_merged should have checked that either
> 		 * both extents are uninitialized, or both aren't. Thus we
> 		 * need to check only one of them here.
> 		 */

Ok.
 
> > ...
> >
> > +/*
> > + * ext4_fallocate:
> > + * preallocate space for a file
> > + * mode is for future use, e.g. for unallocating preallocated blocks etc.
> > + */
> 
> This description is rather thin.  What is the filesystem's actual behaviour
> here?  If the file is using extents then the implementation will do
> <something>.  If the file is using bitmaps then we will do <something else>.
> 
> But what?   Here is where it should be described.

Ok. Will expand the description.
 
> > +int ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
> > +{
> > +	handle_t *handle;
> > +	ext4_fsblk_t block, max_blocks;
> > +	int ret, ret2, nblocks = 0, retries = 0;
> > +	struct buffer_head map_bh;
> > +	unsigned int credits, blkbits = inode->i_blkbits;
> > +
> > +	/* Currently supporting (pre)allocate mode _only_ */
> > +	if (mode != FA_ALLOCATE)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> > +		return -ENOTTY;
> 
> So we don't implement fallocate on bitmap-based files!  Well that's huge
> news.  The changelog would be an appropriate place to communicate this,
> along with reasons why, or a description of the plan to fix it.

Ok. Will add this in the function description as well.
 
> Also, posix says nothing about fallocate() returning ENOTTY.

Right. I don't seem to find any suitable error from posix description.
Can you please suggest an error code which might make more sense here ?
Will -ENOTSUPP be ok ? Since we want to say here that we don't support
non-extent files.
 
> > +	block = offset >> blkbits;
> > +	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
> > +			 - block;
> > +	mutex_lock(&EXT4_I(inode)->truncate_mutex);
> > +	credits = ext4_ext_calc_credits_for_insert(inode, NULL);
> > +	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
> 
> Now I'm mystified.  Given that we're allocating an arbitrary amount of disk
> space, and that this disk space will require an arbitrary amount of
> metadata, how can we work out how much journal space we'll be needing
> without at least looking at `len'?

You are right to say that the credits can not be fixed here. But, 'len'
will not directly tell us how many extents might need to be inserted and
how many block groups (if any - think about the "segment range" already
being allocated case) the allocation request might touch.
One solution I have thought is to check the buffer credits after a call to
ext4_ext_get_blocks (in the while loop) and do a journal_extend, if the
credits are falling short. Incase journal_extend fails, we call
journal_restart. This will automatically take care of how much journal
space we might need for any value of "len".
 
> > +	handle=ext4_journal_start(inode, credits +
> 
> Please always put spaces around "="A
Ok.
> 
> > +					EXT4_DATA_TRANS_BLOCKS(inode->i_sb)+1);
> 
> And around "+"
Ok.
> 
> > +	if (IS_ERR(handle))
> > +		return PTR_ERR(handle);
> > +retry:
> > +	ret = 0;
> > +	while (ret >= 0 && ret < max_blocks) {
> > +		block = block + ret;
> > +		max_blocks = max_blocks - ret;
> > +		ret = ext4_ext_get_blocks(handle, inode, block,
> > +					  max_blocks, &map_bh,
> > +					  EXT4_CREATE_UNINITIALIZED_EXT, 0);
> > +		BUG_ON(!ret);
> 
> BUG_ON is vicious.  Is it really justified here?  Possibly a WARN_ON and
> ext4_error() would be safer and more useful here.

Ok. Will do that.
> 
> > +		if (ret > 0 && test_bit(BH_New, &map_bh.b_state)
> 
> Use buffer_new() here.   A separate patch which fixes the three existing
> instances of open-coded BH_foo usage would be appreciated.

Ok.
> 
> > +			&& ((block + ret) > (i_size_read(inode) << blkbits)))
> 
> Check for wrap though the sign bit and through zero please.
Ok.
> 
> > +			nblocks = nblocks + ret;
> > +	}
> > +
> > +	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> > +		goto retry;
> > +
> > +	/* Time to update the file size.
> > +	 * Update only when preallocation was requested beyond the file size.
> > +	 */
> 
> Fix comment layout.
Ok.
> 
> > +	if ((offset + len) > i_size_read(inode)) {
> 
> Both the lhs and the rhs here are signed.  Please review for possible
> overflows through the sign bit and through zero.  Perhaps a comment
> explaining why it's correct would be appropriate.
Ok.
> 
> 
> > +		if (ret > 0) {
> > +		/* if no error, we assume preallocation succeeded completely */
> > +			mutex_lock(&inode->i_mutex);
> > +			i_size_write(inode, offset + len);
> > +			EXT4_I(inode)->i_disksize = i_size_read(inode);
> > +			mutex_unlock(&inode->i_mutex);
> > +		} else if (ret < 0 && nblocks) {
> > +		/* Handle partial allocation scenario */
> 
> The above two comments should be indented one additional tabstop.
Ok.
> 
> > +			loff_t newsize;
> > +			mutex_lock(&inode->i_mutex);
> > +			newsize  = (nblocks << blkbits) + i_size_read(inode);
> > +			i_size_write(inode, EXT4_BLOCK_ALIGN(newsize, blkbits));
> > +			EXT4_I(inode)->i_disksize = i_size_read(inode);
> > +			mutex_unlock(&inode->i_mutex);
> > +		}
> > +	}
> > +	ext4_mark_inode_dirty(handle, inode);
> > +	ret2 = ext4_journal_stop(handle);
> > +	if (ret > 0)
> > +		ret = ret2;
> > +
> > +	return ret > 0 ? 0 : ret;
> > +}
> > +
> >  EXPORT_SYMBOL(ext4_mark_inode_dirty);
> >  EXPORT_SYMBOL(ext4_ext_invalidate_cache);
> >  EXPORT_SYMBOL(ext4_ext_insert_extent);
> >  EXPORT_SYMBOL(ext4_ext_walk_space);
> >  EXPORT_SYMBOL(ext4_ext_find_goal);
> >  EXPORT_SYMBOL(ext4_ext_calc_credits_for_insert);
> > +EXPORT_SYMBOL(ext4_fallocate);
> >  
> > Index: linux-2.6.21/fs/ext4/file.c
> > ===================================================================
> > --- linux-2.6.21.orig/fs/ext4/file.c
> > +++ linux-2.6.21/fs/ext4/file.c
> > @@ -135,5 +135,6 @@ const struct inode_operations ext4_file_
> >  	.removexattr	= generic_removexattr,
> >  #endif
> >  	.permission	= ext4_permission,
> > +	.fallocate	= ext4_fallocate,
> >  };
> >  
> > Index: linux-2.6.21/include/linux/ext4_fs.h
> > ===================================================================
> > --- linux-2.6.21.orig/include/linux/ext4_fs.h
> > +++ linux-2.6.21/include/linux/ext4_fs.h
> > @@ -102,6 +102,8 @@
> >  				 EXT4_GOOD_OLD_FIRST_INO : \
> >  				 (s)->s_first_ino)
> >  #endif
> > +#define EXT4_BLOCK_ALIGN(size, blkbits) 	(((size)+(1 << blkbits)-1) & \
> > +							(~((1 << blkbits)-1)))
> 
> Maybe a comment describing what this does?  Probably it's obvious enough.
> 
> I think it could use the standard ALIGN macro.
> 
> Is blkbits sufficiently parenthesised here?  Even if it is, adding the
> parens would be better practice.

I agree. Will change it.
> 
> >  /*
> >   * Macro-instructions used to manage fragments
> > @@ -225,6 +227,10 @@ struct ext4_new_group_data {
> >  	__u32 free_blocks_count;
> >  };
> >  
> > +/* Following is used by preallocation logic to tell get_blocks() that we
> > + * want uninitialzed extents.
> > + */
> 
> Please convert all newly-added multiline comments to the preferred layout.
Ok.
> 
> > +#define EXT4_CREATE_UNINITIALIZED_EXT		2
> >  
> >  /*
> >   * ioctl commands
> > @@ -976,6 +982,7 @@ extern int ext4_ext_get_blocks(handle_t 
> >  extern void ext4_ext_truncate(struct inode *, struct page *);
> >  extern void ext4_ext_init(struct super_block *);
> >  extern void ext4_ext_release(struct super_block *);
> > +extern int ext4_fallocate(struct inode *, int, loff_t, loff_t);
> 
> argh.  And feel free to give these args some useful names.
Ok.
> 
> >  static inline int
> >  ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
> >  			unsigned long max_blocks, struct buffer_head *bh,
> > Index: linux-2.6.21/include/linux/ext4_fs_extents.h
> > ===================================================================
> > --- linux-2.6.21.orig/include/linux/ext4_fs_extents.h
> > +++ linux-2.6.21/include/linux/ext4_fs_extents.h
> > @@ -125,6 +125,19 @@ struct ext4_ext_path {
> >  #define EXT4_EXT_CACHE_EXTENT	2
> >  
> >  /*
> > + * Macro-instructions to handle (mark/unmark/check/create) unitialized
> > + * extents. Applications can issue an IOCTL for preallocation, which results
> > + * in assigning unitialized extents to the file.
> > + */
> > +#define ext4_ext_mark_uninitialized(ext)	((ext)->ee_len |= \
> > +							cpu_to_le16(0x8000))
> > +#define ext4_ext_is_uninitialized(ext)  	((le16_to_cpu((ext)->ee_len))& \
> > +									0x8000)
> > +#define ext4_ext_get_actual_len(ext)		((le16_to_cpu((ext)->ee_len))& \
> > +									0x7FFF)
> 
> inlined C functions are preferred, and I think these could be implemented
> that way.

Ok. Will convert them to inline functions.

Thanks!

--
Regards,
Amit Arora
