Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51394 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfE2Sdt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 14:33:49 -0400
Date: Wed, 29 May 2019 11:33:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 08/13] vfs: copy_file_range needs to strip setuid bits
 and update timestamps
Message-ID: <20190529183333.GH5231@magnolia>
References: <20190529174318.22424-1-amir73il@gmail.com>
 <20190529174318.22424-9-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529174318.22424-9-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org

On Wed, May 29, 2019 at 08:43:12PM +0300, Amir Goldstein wrote:
> Because generic_copy_file_range doesn't hold the destination inode lock
> throughout the copy, strip setuid bits before and after copy.
> 
> The destination inode mtime is updated before and after the copy and the
> source inode atime is updated after the copy, similar to
> generic_file_read_iter().
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/read_write.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index cec7e7b1f693..706ea5f276a7 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1590,8 +1590,27 @@ ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
>  				struct file *file_out, loff_t pos_out,
>  				size_t len, unsigned int flags)
>  {
> -	return do_splice_direct(file_in, &pos_in, file_out, &pos_out,
> -				len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
> +	struct inode *inode_out = file_inode(file_out);
> +	int ret, err;
> +
> +	/* Should inode_out lock be held throughout the copy operation? */
> +	inode_lock(inode_out);
> +	err = file_modified(file_out);
> +	inode_unlock(inode_out);
> +	if (err)
> +		return err;
> +
> +	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
> +			       len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
> +
> +	file_accessed(file_in);
> +
> +	/* To be on the safe side, remove privs also after copy */
> +	inode_lock(inode_out);
> +	err = file_modified(file_out);
> +	inode_unlock(inode_out);
> +
> +	return err ?: ret;
>  }
>  EXPORT_SYMBOL(generic_copy_file_range);
>  
> -- 
> 2.17.1
> 
