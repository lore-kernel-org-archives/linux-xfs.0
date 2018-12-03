Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbeLCSxK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Dec 2018 13:53:10 -0500
Date: Mon, 3 Dec 2018 10:53:06 -0800
From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 05/11] vfs: use inode_permission in copy_file_range()
Message-ID: <20181203185305.GA32539@gmail.com>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203083416.28978-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 03, 2018 at 07:34:10PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Similar to FI_DEDUPERANGE, make copy_file_range() check that we have
> write permissions to the destination inode.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mm/filemap.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 0a170425935b..876df5275514 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3013,6 +3013,11 @@ int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
>  	    (file_out->f_flags & O_APPEND))
>  		return -EBADF;
>  
> +	/* may sure we really are allowed to write to the destination inode */
> +	ret = inode_permission(inode_out, MAY_WRITE);
> +	if (ret < 0)
> +		return ret;
> +
>  	/* Ensure offsets don't wrap. */
>  	if (pos_in + count < pos_in || pos_out + count < pos_out)
>  		return -EOVERFLOW;
> -- 
> 2.19.1
> 

Why?  The file descriptor was already checked for write permission above:

       if (!(file_in->f_mode & FMODE_READ) ||
            !(file_out->f_mode & FMODE_WRITE) ||
            (file_out->f_flags & O_APPEND))
                return -EBADF;

Yes, that doesn't detect removing write permission from the *inode*, but write()
doesn't either.

- Eric
