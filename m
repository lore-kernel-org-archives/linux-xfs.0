Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfE1QPD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 12:15:03 -0400
Date: Tue, 28 May 2019 09:14:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 3/8] vfs: introduce generic_file_rw_checks()
Message-ID: <20190528161449.GC5221@magnolia>
References: <20190526061100.21761-1-amir73il@gmail.com>
 <20190526061100.21761-4-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190526061100.21761-4-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-api@vger.kernel.org

On Sun, May 26, 2019 at 09:10:54AM +0300, Amir Goldstein wrote:
> Factor out helper with some checks on in/out file that are
> common to clone_file_range and copy_file_range.
> 
> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/read_write.c    | 38 +++++++++++---------------------------
>  include/linux/fs.h |  1 +
>  mm/filemap.c       | 24 ++++++++++++++++++++++++
>  3 files changed, 36 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index b63dcb4e4fe9..f1900bdb3127 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1617,17 +1617,18 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  			    struct file *file_out, loff_t pos_out,
>  			    size_t len, unsigned int flags)
>  {
> -	struct inode *inode_in = file_inode(file_in);
> -	struct inode *inode_out = file_inode(file_out);
>  	ssize_t ret;
>  
>  	if (flags != 0)
>  		return -EINVAL;
>  
> -	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> -		return -EISDIR;
> -	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> -		return -EINVAL;
> +	/* this could be relaxed once a method supports cross-fs copies */
> +	if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
> +		return -EXDEV;
> +
> +	ret = generic_file_rw_checks(file_in, file_out);
> +	if (unlikely(ret))
> +		return ret;
>  
>  	ret = rw_verify_area(READ, file_in, &pos_in, len);
>  	if (unlikely(ret))
> @@ -1637,15 +1638,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	if (unlikely(ret))
>  		return ret;
>  
> -	if (!(file_in->f_mode & FMODE_READ) ||
> -	    !(file_out->f_mode & FMODE_WRITE) ||
> -	    (file_out->f_flags & O_APPEND))
> -		return -EBADF;
> -
> -	/* this could be relaxed once a method supports cross-fs copies */
> -	if (inode_in->i_sb != inode_out->i_sb)
> -		return -EXDEV;
> -
>  	if (len == 0)
>  		return 0;
>  
> @@ -2013,29 +2005,21 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
>  			   struct file *file_out, loff_t pos_out,
>  			   loff_t len, unsigned int remap_flags)
>  {
> -	struct inode *inode_in = file_inode(file_in);
> -	struct inode *inode_out = file_inode(file_out);
>  	loff_t ret;
>  
>  	WARN_ON_ONCE(remap_flags & REMAP_FILE_DEDUP);
>  
> -	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> -		return -EISDIR;
> -	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> -		return -EINVAL;
> -
>  	/*
>  	 * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
>  	 * the same mount. Practically, they only need to be on the same file
>  	 * system.
>  	 */
> -	if (inode_in->i_sb != inode_out->i_sb)
> +	if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
>  		return -EXDEV;
>  
> -	if (!(file_in->f_mode & FMODE_READ) ||
> -	    !(file_out->f_mode & FMODE_WRITE) ||
> -	    (file_out->f_flags & O_APPEND))
> -		return -EBADF;
> +	ret = generic_file_rw_checks(file_in, file_out);
> +	if (ret < 0)
> +		return ret;
>  
>  	if (!file_in->f_op->remap_file_range)
>  		return -EOPNOTSUPP;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index ea17858310ff..89b9b73eb581 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3049,6 +3049,7 @@ extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
>  extern int generic_remap_checks(struct file *file_in, loff_t pos_in,
>  				struct file *file_out, loff_t pos_out,
>  				loff_t *count, unsigned int remap_flags);
> +extern int generic_file_rw_checks(struct file *file_in, struct file *file_out);
>  extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
>  extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
>  extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c5af80c43d36..798aac92cd76 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3040,6 +3040,30 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
>  	return 0;
>  }
>  
> +
> +/*
> + * Performs common checks before doing a file copy/clone
> + * from @file_in to @file_out.
> + */
> +int generic_file_rw_checks(struct file *file_in, struct file *file_out)
> +{
> +	struct inode *inode_in = file_inode(file_in);
> +	struct inode *inode_out = file_inode(file_out);
> +
> +	/* Don't copy dirs, pipes, sockets... */
> +	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> +		return -EISDIR;
> +	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> +		return -EINVAL;
> +
> +	if (!(file_in->f_mode & FMODE_READ) ||
> +	    !(file_out->f_mode & FMODE_WRITE) ||
> +	    (file_out->f_flags & O_APPEND))
> +		return -EBADF;
> +
> +	return 0;
> +}

/me wishes all these generic vfs io check helpers weren't all being
stuffed into mm/ but that's a refactoring for a different patchset...

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +
>  int pagecache_write_begin(struct file *file, struct address_space *mapping,
>  				loff_t pos, unsigned len, unsigned flags,
>  				struct page **pagep, void **fsdata)
> -- 
> 2.17.1
> 
