Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 23:00:40 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E60bNA027382
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 23:00:38 -0700
Message-ID: <48F443A9.70808@sgi.com>
Date: Tue, 14 Oct 2008 17:00:57 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] Inode: Allow external initialisers
References: <1223416332-7026-1-git-send-email-david@fromorbit.com> <1223416332-7026-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1223416332-7026-4-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

Dave, this is modifying files outside fs/xfs.  Who has reviewed this patch?

Dave Chinner wrote:
> To allow XFS to combine the XFS and linux inodes into a single
> structure, we need to drive inode lookup from the XFS inode cache,
> not the generic inode cache. This means that we need initialise a
> struct inode from a context outside alloc_inode() as it is no longer
> used by XFS.
> 
> Factor and export the struct inode initialisation code from
> alloc_inode() to inode_init_always() as a counterpart to
> inode_init_once().  i.e. we have to call this init function for each
> inode instantiation (always), as opposed inode_init_once() which is
> only called on slab object instantiation (once).
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/inode.c         |  152 +++++++++++++++++++++++++++++-----------------------
>  include/linux/fs.h |    1 +
>  2 files changed, 85 insertions(+), 68 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 0487ddb..e7ee999 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -108,84 +108,100 @@ static void wake_up_inode(struct inode *inode)
>  	wake_up_bit(&inode->i_state, __I_LOCK);
>  }
>  
> -static struct inode *alloc_inode(struct super_block *sb)
> +/**
> + * inode_init_always - perform inode structure intialisation
> + * @sb		- superblock inode belongs to.
> + * @inode	- inode to initialise
> + *
> + * These are initializations that need to be done on every inode
> + * allocation as the fields are not initialised by slab allocation.
> + */
> +struct inode *inode_init_always(struct super_block *sb, struct inode *inode)
>  {
>  	static const struct address_space_operations empty_aops;
>  	static struct inode_operations empty_iops;
>  	static const struct file_operations empty_fops;
> -	struct inode *inode;
> -
> -	if (sb->s_op->alloc_inode)
> -		inode = sb->s_op->alloc_inode(sb);
> -	else
> -		inode = (struct inode *) kmem_cache_alloc(inode_cachep, GFP_KERNEL);
>  
> -	if (inode) {
> -		struct address_space * const mapping = &inode->i_data;
> -
> -		inode->i_sb = sb;
> -		inode->i_blkbits = sb->s_blocksize_bits;
> -		inode->i_flags = 0;
> -		atomic_set(&inode->i_count, 1);
> -		inode->i_op = &empty_iops;
> -		inode->i_fop = &empty_fops;
> -		inode->i_nlink = 1;
> -		atomic_set(&inode->i_writecount, 0);
> -		inode->i_size = 0;
> -		inode->i_blocks = 0;
> -		inode->i_bytes = 0;
> -		inode->i_generation = 0;
> +	struct address_space * const mapping = &inode->i_data;
> +
> +	inode->i_sb = sb;
> +	inode->i_blkbits = sb->s_blocksize_bits;
> +	inode->i_flags = 0;
> +	atomic_set(&inode->i_count, 1);
> +	inode->i_op = &empty_iops;
> +	inode->i_fop = &empty_fops;
> +	inode->i_nlink = 1;
> +	atomic_set(&inode->i_writecount, 0);
> +	inode->i_size = 0;
> +	inode->i_blocks = 0;
> +	inode->i_bytes = 0;
> +	inode->i_generation = 0;
>  #ifdef CONFIG_QUOTA
> -		memset(&inode->i_dquot, 0, sizeof(inode->i_dquot));
> +	memset(&inode->i_dquot, 0, sizeof(inode->i_dquot));
>  #endif
> -		inode->i_pipe = NULL;
> -		inode->i_bdev = NULL;
> -		inode->i_cdev = NULL;
> -		inode->i_rdev = 0;
> -		inode->dirtied_when = 0;
> -		if (security_inode_alloc(inode)) {
> -			if (inode->i_sb->s_op->destroy_inode)
> -				inode->i_sb->s_op->destroy_inode(inode);
> -			else
> -				kmem_cache_free(inode_cachep, (inode));
> -			return NULL;
> -		}
> +	inode->i_pipe = NULL;
> +	inode->i_bdev = NULL;
> +	inode->i_cdev = NULL;
> +	inode->i_rdev = 0;
> +	inode->dirtied_when = 0;
> +	if (security_inode_alloc(inode)) {
> +		if (inode->i_sb->s_op->destroy_inode)
> +			inode->i_sb->s_op->destroy_inode(inode);
> +		else
> +			kmem_cache_free(inode_cachep, (inode));
> +		return NULL;
> +	}
>  
> -		spin_lock_init(&inode->i_lock);
> -		lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
> +	spin_lock_init(&inode->i_lock);
> +	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
>  
> -		mutex_init(&inode->i_mutex);
> -		lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);
> +	mutex_init(&inode->i_mutex);
> +	lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);
>  
> -		init_rwsem(&inode->i_alloc_sem);
> -		lockdep_set_class(&inode->i_alloc_sem, &sb->s_type->i_alloc_sem_key);
> +	init_rwsem(&inode->i_alloc_sem);
> +	lockdep_set_class(&inode->i_alloc_sem, &sb->s_type->i_alloc_sem_key);
>  
> -		mapping->a_ops = &empty_aops;
> - 		mapping->host = inode;
> -		mapping->flags = 0;
> -		mapping_set_gfp_mask(mapping, GFP_HIGHUSER_PAGECACHE);
> -		mapping->assoc_mapping = NULL;
> -		mapping->backing_dev_info = &default_backing_dev_info;
> -		mapping->writeback_index = 0;
> +	mapping->a_ops = &empty_aops;
> +	mapping->host = inode;
> +	mapping->flags = 0;
> +	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_PAGECACHE);
> +	mapping->assoc_mapping = NULL;
> +	mapping->backing_dev_info = &default_backing_dev_info;
> +	mapping->writeback_index = 0;
>  
> -		/*
> -		 * If the block_device provides a backing_dev_info for client
> -		 * inodes then use that.  Otherwise the inode share the bdev's
> -		 * backing_dev_info.
> -		 */
> -		if (sb->s_bdev) {
> -			struct backing_dev_info *bdi;
> +	/*
> +	 * If the block_device provides a backing_dev_info for client
> +	 * inodes then use that.  Otherwise the inode share the bdev's
> +	 * backing_dev_info.
> +	 */
> +	if (sb->s_bdev) {
> +		struct backing_dev_info *bdi;
>  
> -			bdi = sb->s_bdev->bd_inode_backing_dev_info;
> -			if (!bdi)
> -				bdi = sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
> -			mapping->backing_dev_info = bdi;
> -		}
> -		inode->i_private = NULL;
> -		inode->i_mapping = mapping;
> +		bdi = sb->s_bdev->bd_inode_backing_dev_info;
> +		if (!bdi)
> +			bdi = sb->s_bdev->bd_inode->i_mapping->backing_dev_info;
> +		mapping->backing_dev_info = bdi;
>  	}
> +	inode->i_private = NULL;
> +	inode->i_mapping = mapping;
> +
>  	return inode;
>  }
> +EXPORT_SYMBOL(inode_init_always);
> +
> +static struct inode *alloc_inode(struct super_block *sb)
> +{
> +	struct inode *inode;
> +
> +	if (sb->s_op->alloc_inode)
> +		inode = sb->s_op->alloc_inode(sb);
> +	else
> +		inode = kmem_cache_alloc(inode_cachep, GFP_KERNEL);
> +
> +	if (inode)
> +		return inode_init_always(sb, inode);
> +	return NULL;
> +}
>  
>  void destroy_inode(struct inode *inode) 
>  {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 580b513..ce55983 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1811,6 +1811,7 @@ extern loff_t default_llseek(struct file *file, loff_t offset, int origin);
>  
>  extern loff_t vfs_llseek(struct file *file, loff_t offset, int origin);
>  
> +extern struct inode * inode_init_always(struct super_block *, struct inode *);
>  extern void inode_init_once(struct inode *);
>  extern void iput(struct inode *);
>  extern struct inode * igrab(struct inode *);
