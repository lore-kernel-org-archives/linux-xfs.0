Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbeLCSYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 13:24:39 -0500
Date: Mon, 3 Dec 2018 10:24:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/11] vfs: push EXDEV check down into ->remap_file_range
Message-ID: <20181203182425.GA24487@magnolia>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203083416.28978-9-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 03, 2018 at 07:34:13PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> before we can enable cross-device copies into copy_file_range(),
> we have to ensure that ->remap_file_range() implemenations will
> correctly reject attempts to do cross filesystem clones. Currently
> these checks are done above calls to ->remap_file_range(), but
> we need to drive them inwards so that we get EXDEV protection for all
> callers of ->remap_file_range().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/read_write.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 3288db1d5f21..174cf92eea1d 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1909,6 +1909,19 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  	bool same_inode = (inode_in == inode_out);
>  	int ret;
>  
> +	/*
> +	 * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
> +	 * the same mount. Practically, they only need to be on the same file
> +	 * system. We check this here rather than at the ioctl layers because
> +	 * this is effectively a limitation of the fielsystem implementations,

"filesystem"...

--D

> +	 * not so much the API itself. Further, ->remap_file_range() can be
> +	 * called from syscalls that don't have cross device copy restrictions
> +	 * (such as copy_file_range()) and so we need to catch them before we
> +	 * do any damage.
> +	 */
> +	if (inode_in->i_sb != inode_out->i_sb)
> +		return -EXDEV;
> +
>  	/* Don't touch certain kinds of inodes */
>  	if (IS_IMMUTABLE(inode_out))
>  		return -EPERM;
> @@ -2013,14 +2026,6 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
>  	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
>  		return -EINVAL;
>  
> -	/*
> -	 * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
> -	 * the same mount. Practically, they only need to be on the same file
> -	 * system.
> -	 */
> -	if (inode_in->i_sb != inode_out->i_sb)
> -		return -EXDEV;
> -
>  	if (!(file_in->f_mode & FMODE_READ) ||
>  	    !(file_out->f_mode & FMODE_WRITE) ||
>  	    (file_out->f_flags & O_APPEND))
> -- 
> 2.19.1
> 
