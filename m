Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56714 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfE1QTY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 12:19:24 -0400
Date: Tue, 28 May 2019 09:18:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 4/8] vfs: add missing checks to copy_file_range
Message-ID: <20190528161829.GD5221@magnolia>
References: <20190526061100.21761-1-amir73il@gmail.com>
 <20190526061100.21761-5-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190526061100.21761-5-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Sun, May 26, 2019 at 09:10:55AM +0300, Amir Goldstein wrote:
> Like the clone and dedupe interfaces we've recently fixed, the
> copy_file_range() implementation is missing basic sanity, limits and
> boundary condition tests on the parameters that are passed to it
> from userspace. Create a new "generic_copy_file_checks()" function
> modelled on the generic_remap_checks() function to provide this
> missing functionality.
> 
> [Amir] Shorten copy length instead of checking pos_in limits
> because input file size already abides by the limits.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/read_write.c    |  3 ++-
>  include/linux/fs.h |  3 +++
>  mm/filemap.c       | 53 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index f1900bdb3127..b0fb1176b628 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1626,7 +1626,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
>  		return -EXDEV;
>  
> -	ret = generic_file_rw_checks(file_in, file_out);
> +	ret = generic_copy_file_checks(file_in, pos_in, file_out, pos_out, &len,
> +				       flags);
>  	if (unlikely(ret))
>  		return ret;
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 89b9b73eb581..e4d382c4342a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3050,6 +3050,9 @@ extern int generic_remap_checks(struct file *file_in, loff_t pos_in,
>  				struct file *file_out, loff_t pos_out,
>  				loff_t *count, unsigned int remap_flags);
>  extern int generic_file_rw_checks(struct file *file_in, struct file *file_out);
> +extern int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
> +				    struct file *file_out, loff_t pos_out,
> +				    size_t *count, unsigned int flags);
>  extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
>  extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
>  extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 798aac92cd76..1852fbf08eeb 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3064,6 +3064,59 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
>  	return 0;
>  }
>  
> +/*
> + * Performs necessary checks before doing a file copy
> + *
> + * Can adjust amount of bytes to copy

That's the @req_count parameter, correct?

> + * Returns appropriate error code that caller should return or
> + * zero in case the copy should be allowed.
> + */
> +int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
> +			     struct file *file_out, loff_t pos_out,
> +			     size_t *req_count, unsigned int flags)
> +{
> +	struct inode *inode_in = file_inode(file_in);
> +	struct inode *inode_out = file_inode(file_out);
> +	uint64_t count = *req_count;
> +	loff_t size_in;
> +	int ret;
> +
> +	ret = generic_file_rw_checks(file_in, file_out);
> +	if (ret)
> +		return ret;
> +
> +	/* Don't touch certain kinds of inodes */
> +	if (IS_IMMUTABLE(inode_out))
> +		return -EPERM;
> +
> +	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
> +		return -ETXTBSY;
> +
> +	/* Ensure offsets don't wrap. */
> +	if (pos_in + count < pos_in || pos_out + count < pos_out)
> +		return -EOVERFLOW;
> +
> +	/* Shorten the copy to EOF */
> +	size_in = i_size_read(inode_in);
> +	if (pos_in >= size_in)
> +		count = 0;
> +	else
> +		count = min(count, size_in - (uint64_t)pos_in);

Do we need a call to generic_access_check_limits(file_in...) here to
prevent copies from ranges that the page cache doesn't support?

--D

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
> 2.17.1
> 
