Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A8A327F37
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 15:26:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 89D8E8F8033
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:26:55 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7mK5Ddk0gdeu64El for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:26:54 -0800 (PST)
Message-ID: <5283EE9C.6050008@redhat.com>
Date: Wed, 13 Nov 2013 16:26:52 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs: simplify xfs_setsize_buftarg callchain; remove
	unused arg
References: <5283BC4B.9090204@redhat.com> <5283E6D9.6070306@sandeen.net>
In-Reply-To: <5283E6D9.6070306@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 11/13/2013 03:53 PM, Eric Sandeen wrote:
> The "verbose" argument to xfs_setsize_buftarg_flags() has been
> unused since:
> 
> ffe37436 xfs: stop using the page cache to back the buffer cache
> 
> Remove it, and fold the function into xfs_setsize_buftarg()
> now that there's no need for different types of callers.
> 
> Fix inconsistent comment spacing while we're at it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good to me.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2: Fold old helper function into xfs_setsize_buftarg,
> per Brian's suggestion.
> 
>  xfs_buf.c |   26 ++++++++------------------
>  1 file changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 2634700..0ce3b7b 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1601,12 +1601,11 @@ xfs_free_buftarg(
>  	kmem_free(btp);
>  }
>  
> -STATIC int
> -xfs_setsize_buftarg_flags(
> +int
> +xfs_setsize_buftarg(
>  	xfs_buftarg_t		*btp,
>  	unsigned int		blocksize,
> -	unsigned int		sectorsize,
> -	int			verbose)
> +	unsigned int		sectorsize)
>  {
>  	btp->bt_bsize = blocksize;
>  	btp->bt_sshift = ffs(sectorsize) - 1;
> @@ -1627,26 +1626,17 @@ xfs_setsize_buftarg_flags(
>  }
>  
>  /*
> - *	When allocating the initial buffer target we have not yet
> - *	read in the superblock, so don't know what sized sectors
> - *	are being used at this early stage.  Play safe.
> + * When allocating the initial buffer target we have not yet
> + * read in the superblock, so don't know what sized sectors
> + * are being used at this early stage.  Play safe.
>   */
>  STATIC int
>  xfs_setsize_buftarg_early(
>  	xfs_buftarg_t		*btp,
>  	struct block_device	*bdev)
>  {
> -	return xfs_setsize_buftarg_flags(btp,
> -			PAGE_SIZE, bdev_logical_block_size(bdev), 0);
> -}
> -
> -int
> -xfs_setsize_buftarg(
> -	xfs_buftarg_t		*btp,
> -	unsigned int		blocksize,
> -	unsigned int		sectorsize)
> -{
> -	return xfs_setsize_buftarg_flags(btp, blocksize, sectorsize, 1);
> +	return xfs_setsize_buftarg(btp, PAGE_SIZE,
> +				   bdev_logical_block_size(bdev));
>  }
>  
>  xfs_buftarg_t *
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
