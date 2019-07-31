Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaXOz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 19:14:55 -0400
Date: Wed, 31 Jul 2019 16:12:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/9] fibmap: Use bmap instead of ->bmap method in
 ioctl_fibmap
Message-ID: <20190731231217.GV1561054@magnolia>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
 <20190731141245.7230-5-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731141245.7230-5-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jul 31, 2019 at 04:12:40PM +0200, Carlos Maiolino wrote:
> Now we have the possibility of proper error return in bmap, use bmap()
> function in ioctl_fibmap() instead of calling ->bmap method directly.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changelog:
> 
> V4:
> 	- Ensure ioctl_fibmap() returns 0 in case of error returned from
> 	  bmap(). Otherwise we'll be changing the user interface (which
> 	  returns 0 in case of error)
> V3:
> 	- Rename usr_blk to ur_block
> 
> V2:
> 	- Use a local sector_t variable to asign the block number
> 	  instead of using direct casting.
> 
>  fs/ioctl.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index fef3a6bf7c78..6b589c873bc2 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -53,19 +53,28 @@ EXPORT_SYMBOL(vfs_ioctl);
>  
>  static int ioctl_fibmap(struct file *filp, int __user *p)
>  {
> -	struct address_space *mapping = filp->f_mapping;
> -	int res, block;
> +	struct inode *inode = file_inode(filp);
> +	int error, ur_block;
> +	sector_t block;
>  
> -	/* do we support this mess? */
> -	if (!mapping->a_ops->bmap)
> -		return -EINVAL;
>  	if (!capable(CAP_SYS_RAWIO))
>  		return -EPERM;
> -	res = get_user(block, p);
> -	if (res)
> -		return res;
> -	res = mapping->a_ops->bmap(mapping, block);
> -	return put_user(res, p);
> +
> +	error = get_user(ur_block, p);
> +	if (error)
> +		return error;
> +
> +	block = ur_block;
> +	error = bmap(inode, &block);
> +
> +	if (error)
> +		ur_block = 0;
> +	else
> +		ur_block = block;

What happens if ur_block > INT_MAX?  Shouldn't we return zero (i.e.
error) instead of truncating the value?  Maybe the code does this
somewhere else?  Here seemed like the obvious place for an overflow
check as we go from sector_t to int.

--D

> +
> +	error = put_user(ur_block, p);
> +
> +	return error;
>  }
>  
>  /**
> -- 
> 2.20.1
> 
