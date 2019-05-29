Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41622 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfE2SYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 14:24:03 -0400
Date: Wed, 29 May 2019 11:23:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 04/13] vfs: remove redundant checks from
 generic_remap_checks()
Message-ID: <20190529182319.GD5231@magnolia>
References: <20190529174318.22424-1-amir73il@gmail.com>
 <20190529174318.22424-5-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529174318.22424-5-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org

On Wed, May 29, 2019 at 08:43:08PM +0300, Amir Goldstein wrote:
> The access limit checks on input file range in generic_remap_checks()
> are redundant because the input file size is guaranteied to be within

"guaranteed"...

> limits and pos+len are already checked to be within input file size.
> 
> Beyond the fact that the check cannot fail, if it would have failed,
> it could return -EFBIG for input file range error. There is no precedent
> for that. -EFBIG is returned in syscalls that would change file length.
> 
> With that call removed, we can fold generic_access_check_limits() into
> generic_write_check_limits().
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Once the changelog is fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  mm/filemap.c | 33 ++++++++++++---------------------
>  1 file changed, 12 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a38619a4a6af..44361928bbb0 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2895,24 +2895,11 @@ EXPORT_SYMBOL(read_cache_page_gfp);
>   * LFS limits.  If pos is under the limit it becomes a short access.  If it
>   * exceeds the limit we return -EFBIG.
>   */
> -static int generic_access_check_limits(struct file *file, loff_t pos,
> -				       loff_t *count)
> -{
> -	struct inode *inode = file->f_mapping->host;
> -	loff_t max_size = inode->i_sb->s_maxbytes;
> -
> -	if (!(file->f_flags & O_LARGEFILE))
> -		max_size = MAX_NON_LFS;
> -
> -	if (unlikely(pos >= max_size))
> -		return -EFBIG;
> -	*count = min(*count, max_size - pos);
> -	return 0;
> -}
> -
>  static int generic_write_check_limits(struct file *file, loff_t pos,
>  				      loff_t *count)
>  {
> +	struct inode *inode = file->f_mapping->host;
> +	loff_t max_size = inode->i_sb->s_maxbytes;
>  	loff_t limit = rlimit(RLIMIT_FSIZE);
>  
>  	if (limit != RLIM_INFINITY) {
> @@ -2923,7 +2910,15 @@ static int generic_write_check_limits(struct file *file, loff_t pos,
>  		*count = min(*count, limit - pos);
>  	}
>  
> -	return generic_access_check_limits(file, pos, count);
> +	if (!(file->f_flags & O_LARGEFILE))
> +		max_size = MAX_NON_LFS;
> +
> +	if (unlikely(pos >= max_size))
> +		return -EFBIG;
> +
> +	*count = min(*count, max_size - pos);
> +
> +	return 0;
>  }
>  
>  /*
> @@ -2963,7 +2958,7 @@ EXPORT_SYMBOL(generic_write_checks);
>  /*
>   * Performs necessary checks before doing a clone.
>   *
> - * Can adjust amount of bytes to clone.
> + * Can adjust amount of bytes to clone via @req_count argument.
>   * Returns appropriate error code that caller should return or
>   * zero in case the clone should be allowed.
>   */
> @@ -3001,10 +2996,6 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
>  		return -EINVAL;
>  	count = min(count, size_in - (uint64_t)pos_in);
>  
> -	ret = generic_access_check_limits(file_in, pos_in, &count);
> -	if (ret)
> -		return ret;
> -
>  	ret = generic_write_check_limits(file_out, pos_out, &count);
>  	if (ret)
>  		return ret;
> -- 
> 2.17.1
> 
