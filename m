Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 577567F5A
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 09:53:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C734CAC002
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 07:53:35 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id uTnUzDB3DimHitL3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Apr 2015 07:53:33 -0700 (PDT)
Date: Wed, 1 Apr 2015 16:53:28 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/8] dax: don't abuse get_block mapping for endio callbacks
Message-ID: <20150401145328.GP26339@quack.suse.cz>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1427194266-2885-3-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Tue 24-03-15 21:51:00, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> dax_fault() currently relies on the get_block callback to attach an
> io completion callback to the mapping buffer head so that it can
> run unwritten extent conversion after zeroing allocated blocks.
> 
> Instead of this hack, pass the conversion callback directly into
> dax_fault() similar to the get_block callback. When the filesystem
> allocates unwritten extents, it will set the buffer_unwritten()
> flag, and hence the dax_fault code can call the completion function
> in the contexts where it is necessary without overloading the
> mapping buffer head.
> 
> Note: The changes to ext4 to use this interface are suspect at best.
> In fact, the way ext4 did this end_io assignment in the first place
> looks suspect because it only set a completion callback when there
> wasn't already some other write() call taking place on the same
> inode. The ext4 end_io code looks rather intricate and fragile with
> all it's reference counting and passing to different contexts for
> modification via inode private pointers that aren't protected by
> locks...
  Yeah, the io_end handling is currently buggy when you try to do more than
one write in parallel (normally we don't allow that and seriealize
everything behind i_mutex). That needs fixing but here what you did looks
good enough for this patch set. You have my

Acked-by: Jan Kara <jack@suse.cz>

								Honza

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/dax.c           | 17 +++++++++++------
>  fs/ext2/file.c     |  4 ++--
>  fs/ext4/file.c     | 16 ++++++++++++++--
>  fs/ext4/inode.c    | 21 +++++++--------------
>  include/linux/fs.h |  6 ++++--
>  5 files changed, 38 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index ed1619e..431ec2b 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -310,14 +310,11 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
>   out:
>  	i_mmap_unlock_read(mapping);
>  
> -	if (bh->b_end_io)
> -		bh->b_end_io(bh, 1);
> -
>  	return error;
>  }
>  
>  static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> -			get_block_t get_block)
> +			get_block_t get_block, dax_iodone_t complete_unwritten)
>  {
>  	struct file *file = vma->vm_file;
>  	struct address_space *mapping = file->f_mapping;
> @@ -418,7 +415,15 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		page_cache_release(page);
>  	}
>  
> +	/*
> +	 * If we successfully insert the new mapping over an unwritten extent,
> +	 * we need to ensure we convert the unwritten extent. If there is an
> +	 * error inserting the mapping, we leave the extent as unwritten to
> +	 * prevent exposure of the stale underlying data to userspace.
> +	 */
>  	error = dax_insert_mapping(inode, &bh, vma, vmf);
> +	if (!error && buffer_unwritten(&bh))
> +		complete_unwritten(&bh, 1);
>  
>   out:
>  	if (error == -ENOMEM)
> @@ -446,7 +451,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>   * fault handler for DAX files.
>   */
>  int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> -			get_block_t get_block)
> +	      get_block_t get_block, dax_iodone_t complete_unwritten)
>  {
>  	int result;
>  	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
> @@ -455,7 +460,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  		sb_start_pagefault(sb);
>  		file_update_time(vma->vm_file);
>  	}
> -	result = do_dax_fault(vma, vmf, get_block);
> +	result = do_dax_fault(vma, vmf, get_block, complete_unwritten);
>  	if (vmf->flags & FAULT_FLAG_WRITE)
>  		sb_end_pagefault(sb);
>  
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index e317017..8da747a 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -28,12 +28,12 @@
>  #ifdef CONFIG_FS_DAX
>  static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
> -	return dax_fault(vma, vmf, ext2_get_block);
> +	return dax_fault(vma, vmf, ext2_get_block, NULL);
>  }
>  
>  static int ext2_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
> -	return dax_mkwrite(vma, vmf, ext2_get_block);
> +	return dax_mkwrite(vma, vmf, ext2_get_block, NULL);
>  }
>  
>  static const struct vm_operations_struct ext2_dax_vm_ops = {
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 33a09da..f7dabb1 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -192,15 +192,27 @@ errout:
>  }
>  
>  #ifdef CONFIG_FS_DAX
> +static void ext4_end_io_unwritten(struct buffer_head *bh, int uptodate)
> +{
> +	struct inode *inode = bh->b_assoc_map->host;
> +	/* XXX: breaks on 32-bit > 16GB. Is that even supported? */
> +	loff_t offset = (loff_t)(uintptr_t)bh->b_private << inode->i_blkbits;
> +	int err;
> +	if (!uptodate)
> +		return;
> +	WARN_ON(!buffer_unwritten(bh));
> +	err = ext4_convert_unwritten_extents(NULL, inode, offset, bh->b_size);
> +}
> +
>  static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
> -	return dax_fault(vma, vmf, ext4_get_block);
> +	return dax_fault(vma, vmf, ext4_get_block, ext4_end_io_unwritten);
>  					/* Is this the right get_block? */
>  }
>  
>  static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
> -	return dax_mkwrite(vma, vmf, ext4_get_block);
> +	return dax_mkwrite(vma, vmf, ext4_get_block, ext4_end_io_unwritten);
>  }
>  
>  static const struct vm_operations_struct ext4_dax_vm_ops = {
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5cb9a21..43433de 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -657,18 +657,6 @@ has_zeroout:
>  	return retval;
>  }
>  
> -static void ext4_end_io_unwritten(struct buffer_head *bh, int uptodate)
> -{
> -	struct inode *inode = bh->b_assoc_map->host;
> -	/* XXX: breaks on 32-bit > 16GB. Is that even supported? */
> -	loff_t offset = (loff_t)(uintptr_t)bh->b_private << inode->i_blkbits;
> -	int err;
> -	if (!uptodate)
> -		return;
> -	WARN_ON(!buffer_unwritten(bh));
> -	err = ext4_convert_unwritten_extents(NULL, inode, offset, bh->b_size);
> -}
> -
>  /* Maximum number of blocks we map for direct IO at once. */
>  #define DIO_MAX_BLOCKS 4096
>  
> @@ -706,10 +694,15 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
>  
>  		map_bh(bh, inode->i_sb, map.m_pblk);
>  		bh->b_state = (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;
> -		if (IS_DAX(inode) && buffer_unwritten(bh) && !io_end) {
> +		if (IS_DAX(inode) && buffer_unwritten(bh)) {
> +			/*
> +			 * dgc: I suspect unwritten conversion on ext4+DAX is
> +			 * fundamentally broken here when there are concurrent
> +			 * read/write in progress on this inode.
> +			 */
> +			WARN_ON_ONCE(io_end);
>  			bh->b_assoc_map = inode->i_mapping;
>  			bh->b_private = (void *)(unsigned long)iblock;
> -			bh->b_end_io = ext4_end_io_unwritten;
>  		}
>  		if (io_end && io_end->flag & EXT4_IO_END_UNWRITTEN)
>  			set_buffer_defer_completion(bh);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 937e280..82100ae 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -70,6 +70,7 @@ typedef int (get_block_t)(struct inode *inode, sector_t iblock,
>  			struct buffer_head *bh_result, int create);
>  typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  			ssize_t bytes, void *private);
> +typedef void (dax_iodone_t)(struct buffer_head *bh_map, int uptodate);
>  
>  #define MAY_EXEC		0x00000001
>  #define MAY_WRITE		0x00000002
> @@ -2603,8 +2604,9 @@ ssize_t dax_do_io(int rw, struct kiocb *, struct inode *, struct iov_iter *,
>  int dax_clear_blocks(struct inode *, sector_t block, long size);
>  int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
>  int dax_truncate_page(struct inode *, loff_t from, get_block_t);
> -int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
> -#define dax_mkwrite(vma, vmf, gb)	dax_fault(vma, vmf, gb)
> +int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
> +		dax_iodone_t);
> +#define dax_mkwrite(vma, vmf, gb, iod)	dax_fault(vma, vmf, gb, iod)
>  
>  #ifdef CONFIG_BLOCK
>  typedef void (dio_submit_t)(int rw, struct bio *bio, struct inode *inode,
> -- 
> 2.0.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
