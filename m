Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:61069 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751097AbcIMAIP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2016 20:08:15 -0400
Date: Tue, 13 Sep 2016 10:08:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/4] vfs: allow vfs_copy_file_range() across file
 systems
Message-ID: <20160913000811.GN22388@dastard>
References: <1473348594-31425-1-git-send-email-amir73il@gmail.com>
 <1473692803-11964-1-git-send-email-amir73il@gmail.com>
 <1473692803-11964-4-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473692803-11964-4-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org

On Mon, Sep 12, 2016 at 06:06:42PM +0300, Amir Goldstein wrote:
> copy_file_range syscall returns -EXDEV if src and dest
> file are not on the same file system.
> The vfs_copy_file_range() helper, however, knows how to copy
> across file systems with do_splice_direct().
> 
> Move the enforcement of same file system from the vfs helper
> to the syscall code.
> 
> A following patch is going to use the vfs_copy_file_range()
> helper in overlayfs to copy up between lower and upper
> not on the same file system.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/read_write.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 9dc6e52..c4675c6 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1502,10 +1502,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	    (file_out->f_flags & O_APPEND))
>  		return -EBADF;
>  
> -	/* this could be relaxed once a method supports cross-fs copies */
> -	if (inode_in->i_sb != inode_out->i_sb)
> -		return -EXDEV;
> -
>  	if (len == 0)
>  		return 0;
>  
> @@ -1514,7 +1510,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  		return ret;
>  
>  	ret = -EOPNOTSUPP;
> -	if (file_out->f_op->copy_file_range)
> +	if (inode_in->i_sb == inode_out->i_sb &&
> +			file_out->f_op->copy_file_range)
>  		ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
>  						      pos_out, len, flags);

Indenting is wrong, and you dropped an important comment. i.e
copy_file_range() still doesn't support cross fs copies.....

>  	if (ret == -EOPNOTSUPP)
> @@ -1569,6 +1566,14 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
>  		pos_out = f_out.file->f_pos;
>  	}
>  
> +	/*
> +	 * FIXME: should copy_file_range syscall enforce that src and
> +	 * dest files are on the same mount point or only on the same
> +	 * file system? none of the above?
> +	 */
> +	if (file_inode(f_in.file)->i_sb != file_inode(f_out.file)->i_sb)
> +		return -EXDEV;

For the purposes of this patch, it should simply do what it already
does. If there's a API semantic change that needs to be made, then
get that sorted out now rather than adding a "fixme" comment that
will simply be ignored....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
