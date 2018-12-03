Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35798 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbeLCTEk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 14:04:40 -0500
Date: Mon, 3 Dec 2018 11:04:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/11] vfs: add missing checks to copy_file_range
Message-ID: <20181203190424.GC24487@magnolia>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203083416.28978-5-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 03, 2018 at 07:34:09PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Like the clone and dedupe interfaces we've recently fixed, the
> copy_file_range() implementation is missing basic sanity, limits and
> boundary condition tests on the parameters that are passed to it
> from userspace. Create a new "generic_copy_file_checks()" function
> modelled on the generic_remap_checks() function to provide this
> missing functionality.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/read_write.c    | 27 ++++++------------
>  include/linux/fs.h |  3 ++
>  mm/filemap.c       | 69 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 81 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 44339b44accc..69809345977e 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1578,7 +1578,7 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
>  		return file_out->f_op->copy_file_range(file_in, pos_in, file_out,
>  						      pos_out, len, flags);
>  
> -	return generic_copy_file_range(file_in, &pos_in, file_out, &pos_out,
> +	return generic_copy_file_range(file_in, pos_in, file_out, pos_out,
>  					len, flags);
>  }
>  
> @@ -1598,10 +1598,14 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	if (flags != 0)
>  		return -EINVAL;
>  
> -	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> -		return -EISDIR;
> -	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> -		return -EINVAL;
> +	/* this could be relaxed once a method supports cross-fs copies */
> +	if (inode_in->i_sb != inode_out->i_sb)
> +		return -EXDEV;
> +
> +	ret = generic_copy_file_checks(file_in, pos_in, file_out, pos_out, &len,
> +					flags);
> +	if (ret < 0)
> +		return ret;
>  
>  	ret = rw_verify_area(READ, file_in, &pos_in, len);
>  	if (unlikely(ret))
> @@ -1611,22 +1615,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
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
> -	/* If the source range crosses EOF, fail the copy */
> -	if (pos_in >= i_size(inode_in) || pos_in + len > i_size(inode_in))
> -		return -EINVAL;
> -
>  	file_start_write(file_out);
>  
>  	/*
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a4478764cf63..0d9d2d93d4df 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3022,6 +3022,9 @@ extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
>  extern int generic_remap_checks(struct file *file_in, loff_t pos_in,
>  				struct file *file_out, loff_t pos_out,
>  				loff_t *count, unsigned int remap_flags);
> +extern int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
> +				struct file *file_out, loff_t pos_out,
> +				size_t *count, unsigned int flags);
>  extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
>  extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
>  extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 81adec8ee02c..0a170425935b 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2975,6 +2975,75 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
>  	return 0;
>  }
>  
> +
> +/*
> + * Performs necessary checks before doing a file copy
> + *
> + * Can adjust amount of bytes to copy
> + * Returns appropriate error code that caller should return or
> + * zero in case the copy should be allowed.
> + */
> +int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
> +			 struct file *file_out, loff_t pos_out,
> +			 size_t *req_count, unsigned int flags)
> +{
> +	struct inode *inode_in = file_inode(file_in);
> +	struct inode *inode_out = file_inode(file_out);
> +	uint64_t count = *req_count;
> +	uint64_t bcount;
> +	loff_t size_in, size_out;
> +	loff_t bs = inode_out->i_sb->s_blocksize;
> +	int ret;
> +
> +	/* Don't touch certain kinds of inodes */
> +	if (IS_IMMUTABLE(inode_out))
> +		return -EPERM;
> +
> +	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
> +		return -ETXTBSY;
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

These five checks are the same as the ones that are split between
do_clone_file_range and generic_remap_file_range_prep.  Perhaps they
should be factored into a single function that can be called from the
do_clone_file_range function as well as do_copy_file_range?

(I suspect also vfs_dedupe_file_range_one() should call it too, but the
dedupe code is so grotty and weird...)

--D

> +
> +	/* Ensure offsets don't wrap. */
> +	if (pos_in + count < pos_in || pos_out + count < pos_out)
> +		return -EOVERFLOW;
> +
> +	size_in = i_size_read(inode_in);
> +	size_out = i_size_read(inode_out);
> +
> +	/* If the source range crosses EOF, fail the copy */
> +	if (pos_in >= size_in)
> +		return -EINVAL;
> +	if (pos_in + count > size_in)
> +		return -EINVAL;
> +
> +	ret = generic_access_check_limits(file_in, pos_in, &count);
> +	if (ret)
> +		return ret;
> +
> +	ret = generic_write_check_limits(file_out, pos_out, &count);
> +	if (ret)
> +		return ret;
> +
> +	/* Don't allow overlapped copying within the same file. */
> +	if (inode_in == inode_out &&
> +	    pos_out + count > pos_in &&
> +	    pos_out < pos_in + count)
> +		return -EINVAL;
> +
> +	*req_count = count;
> +	return 0;
> +}
> +
>  int pagecache_write_begin(struct file *file, struct address_space *mapping,
>  				loff_t pos, unsigned len, unsigned flags,
>  				struct page **pagep, void **fsdata)
> -- 
> 2.19.1
> 
