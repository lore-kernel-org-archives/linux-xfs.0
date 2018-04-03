Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755300AbeDCLvM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Apr 2018 07:51:12 -0400
Date: Tue, 3 Apr 2018 13:51:10 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v8 06/18] ext2, dax: introduce ext2_dax_aops
Message-ID: <20180403115110.x272sevqcutguna6@quack2.suse.cz>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152246896163.36038.15934876342603748972.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152246896163.36038.15934876342603748972.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, kbuild test robot <lkp@intel.com>, david@fromorbit.com, hch@lst.de, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, jack@suse.cz, snitzer@redhat.com

On Fri 30-03-18 21:02:41, Dan Williams wrote:
> In preparation for the dax implementation to start associating dax pages
> to inodes via page->mapping, we need to provide a 'struct
> address_space_operations' instance for dax. Otherwise, direct-I/O
> triggers incorrect page cache assumptions and warnings.
> 
> Cc: Jan Kara <jack@suse.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/ext2.h  |    1 +
>  fs/ext2/inode.c |   46 +++++++++++++++++++++++++++-------------------
>  fs/ext2/namei.c |   18 ++----------------
>  3 files changed, 30 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 032295e1d386..cc40802ddfa8 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -814,6 +814,7 @@ extern const struct inode_operations ext2_file_inode_operations;
>  extern const struct file_operations ext2_file_operations;
>  
>  /* inode.c */
> +extern void ext2_set_file_ops(struct inode *inode);
>  extern const struct address_space_operations ext2_aops;
>  extern const struct address_space_operations ext2_nobh_aops;
>  extern const struct iomap_ops ext2_iomap_ops;
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 9b2ac55ac34f..1e01fabef130 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -940,9 +940,6 @@ ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  	loff_t offset = iocb->ki_pos;
>  	ssize_t ret;
>  
> -	if (WARN_ON_ONCE(IS_DAX(inode)))
> -		return -EIO;
> -
>  	ret = blockdev_direct_IO(iocb, inode, iter, ext2_get_block);
>  	if (ret < 0 && iov_iter_rw(iter) == WRITE)
>  		ext2_write_failed(mapping, offset + count);
> @@ -952,17 +949,16 @@ ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  static int
>  ext2_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  {
> -#ifdef CONFIG_FS_DAX
> -	if (dax_mapping(mapping)) {
> -		return dax_writeback_mapping_range(mapping,
> -						   mapping->host->i_sb->s_bdev,
> -						   wbc);
> -	}
> -#endif
> -
>  	return mpage_writepages(mapping, wbc, ext2_get_block);
>  }
>  
> +static int
> +ext2_dax_writepages(struct address_space *mapping, struct writeback_control *wbc)
> +{
> +	return dax_writeback_mapping_range(mapping,
> +			mapping->host->i_sb->s_bdev, wbc);
> +}
> +
>  const struct address_space_operations ext2_aops = {
>  	.readpage		= ext2_readpage,
>  	.readpages		= ext2_readpages,
> @@ -990,6 +986,13 @@ const struct address_space_operations ext2_nobh_aops = {
>  	.error_remove_page	= generic_error_remove_page,
>  };
>  
> +static const struct address_space_operations ext2_dax_aops = {
> +	.writepages		= ext2_dax_writepages,
> +	.direct_IO		= noop_direct_IO,
> +	.set_page_dirty		= noop_set_page_dirty,
> +	.invalidatepage		= noop_invalidatepage,
> +};
> +
>  /*
>   * Probably it should be a library function... search for first non-zero word
>   * or memcmp with zero_page, whatever is better for particular architecture.
> @@ -1388,6 +1391,18 @@ void ext2_set_inode_flags(struct inode *inode)
>  		inode->i_flags |= S_DAX;
>  }
>  
> +void ext2_set_file_ops(struct inode *inode)
> +{
> +	inode->i_op = &ext2_file_inode_operations;
> +	inode->i_fop = &ext2_file_operations;
> +	if (IS_DAX(inode))
> +		inode->i_mapping->a_ops = &ext2_dax_aops;
> +	else if (test_opt(inode->i_sb, NOBH))
> +		inode->i_mapping->a_ops = &ext2_nobh_aops;
> +	else
> +		inode->i_mapping->a_ops = &ext2_aops;
> +}
> +
>  struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
>  {
>  	struct ext2_inode_info *ei;
> @@ -1480,14 +1495,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
>  		ei->i_data[n] = raw_inode->i_block[n];
>  
>  	if (S_ISREG(inode->i_mode)) {
> -		inode->i_op = &ext2_file_inode_operations;
> -		if (test_opt(inode->i_sb, NOBH)) {
> -			inode->i_mapping->a_ops = &ext2_nobh_aops;
> -			inode->i_fop = &ext2_file_operations;
> -		} else {
> -			inode->i_mapping->a_ops = &ext2_aops;
> -			inode->i_fop = &ext2_file_operations;
> -		}
> +		ext2_set_file_ops(inode);
>  	} else if (S_ISDIR(inode->i_mode)) {
>  		inode->i_op = &ext2_dir_inode_operations;
>  		inode->i_fop = &ext2_dir_operations;
> diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> index e078075dc66f..55f7caadb093 100644
> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -107,14 +107,7 @@ static int ext2_create (struct inode * dir, struct dentry * dentry, umode_t mode
>  	if (IS_ERR(inode))
>  		return PTR_ERR(inode);
>  
> -	inode->i_op = &ext2_file_inode_operations;
> -	if (test_opt(inode->i_sb, NOBH)) {
> -		inode->i_mapping->a_ops = &ext2_nobh_aops;
> -		inode->i_fop = &ext2_file_operations;
> -	} else {
> -		inode->i_mapping->a_ops = &ext2_aops;
> -		inode->i_fop = &ext2_file_operations;
> -	}
> +	ext2_set_file_ops(inode);
>  	mark_inode_dirty(inode);
>  	return ext2_add_nondir(dentry, inode);
>  }
> @@ -125,14 +118,7 @@ static int ext2_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	if (IS_ERR(inode))
>  		return PTR_ERR(inode);
>  
> -	inode->i_op = &ext2_file_inode_operations;
> -	if (test_opt(inode->i_sb, NOBH)) {
> -		inode->i_mapping->a_ops = &ext2_nobh_aops;
> -		inode->i_fop = &ext2_file_operations;
> -	} else {
> -		inode->i_mapping->a_ops = &ext2_aops;
> -		inode->i_fop = &ext2_file_operations;
> -	}
> +	ext2_set_file_ops(inode);
>  	mark_inode_dirty(inode);
>  	d_tmpfile(dentry, inode);
>  	unlock_new_inode(inode);
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
