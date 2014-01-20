Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A61F87F37
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 08:21:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9613A8F8033
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 06:21:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1F4qsXEqoCAcCe0f for
	<xfs@oss.sgi.com>; Mon, 20 Jan 2014 06:21:40 -0800 (PST)
Message-ID: <52DD30F2.3000504@redhat.com>
Date: Mon, 20 Jan 2014 09:21:38 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfs: allow logical-sector sized O_DIRECT IOs
References: <52D6CC91.6000408@redhat.com> <52D9910C.9000205@sandeen.net>
	<52D99255.9090609@sandeen.net>
In-Reply-To: <52D99255.9090609@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On 01/17/2014 03:28 PM, Eric Sandeen wrote:
> Some time ago, mkfs.xfs started picking the storage physical
> sector size as the default filesystem "sector size" in order
> to avoid RMW costs incurred by doing IOs at logical sector
> size alignments.
> 
> However, this means that for a filesystem made with i.e.
> a 4k sector size on an "advanced format" 4k/512 disk,
> 512-byte direct IOs are no longer allowed.  This means
> that XFS has essentially turned this AF drive into a hard
> 4K device, from the filesystem on up.
> 
> XFS's mkfs-specified "sector size" is really just controlling
> the minimum size & alignment of filesystem metadata.
> 
> There is no real need to tightly couple XFS's minimal
> metadata size to the minimum allowed direct IO size;
> XFS can continue doing metadata in optimal sizes, but
> still allow smaller DIOs for apps which issue them,
> for whatever reason.
> 
> This patch adds new information to the xfs_buftarg, so that
> we now track 2 sizes:
> 
>  1) The metadata sector size, which is the minimum unit and
>     alignment of IO which will be performed by metadata operations.
>  2) The device logical sector size.
> 
> The first is used internally by the file system for metadata
> alignment and IOs.
> The second is used for the minimum allowed direct IO size and
> alignment.
> 
> This has passed xfstests on filesystems made with 4k sectors,
> including when run under the patch I sent to ignore
> XFS_IOC_DIOINFO, and issue 512 DIOs anyway.  I also directly
> tested end of block behavior on preallocated, sparse, and
> existing files when we do a 512 IO into a 4k file on a 
> 4k-sector filesystem, to be sure there were no unexpected
> behaviors.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a526f8d..5175711 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1599,6 +1599,7 @@ xfs_setsize_buftarg(
>  	unsigned int		blocksize,
>  	unsigned int		sectorsize)
>  {
> +	/* Set up metadata sector size info */
>  	btp->bt_meta_sectorsize = sectorsize;
>  	btp->bt_meta_sectormask = sectorsize - 1;
>  
> @@ -1613,6 +1614,10 @@ xfs_setsize_buftarg(
>  		return EINVAL;
>  	}
>  
> +	/* Set up device logical sector size mask */
> +	btp->bt_logical_sectorsize = bdev_logical_block_size(btp->bt_bdev);
> +	btp->bt_logical_sectormask = bdev_logical_block_size(btp->bt_bdev) - 1;
> +
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index d5d88dd..9953395 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -88,6 +88,19 @@ typedef unsigned int xfs_buf_flags_t;
>   */
>  #define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
>  
> +/*
> + * The xfs_buftarg contains 2 notions of "sector size" -
> + *
> + * 1) The metadata sector size, which is the minimum unit and
> + *    alignment of IO which will be performed by metadata operations.
> + * 2) The device logical sector size
> + *
> + * The first is specified at mkfs time, and is stored on-disk in the
> + * superblock's sb_sectsize.
> + *
> + * The latter is derived from the underlying device, and controls direct IO
> + * alignment constraints.
> + */
>  typedef struct xfs_buftarg {
>  	dev_t			bt_dev;
>  	struct block_device	*bt_bdev;
> @@ -95,6 +108,8 @@ typedef struct xfs_buftarg {
>  	struct xfs_mount	*bt_mount;
>  	unsigned int		bt_meta_sectorsize;
>  	size_t			bt_meta_sectormask;
> +	size_t			bt_logical_sectorsize;
> +	size_t			bt_logical_sectormask;
>  
>  	/* LRU control structures */
>  	struct shrinker		bt_shrinker;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 61a7de0..5507420 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -261,7 +261,8 @@ xfs_file_aio_read(
>  		xfs_buftarg_t	*target =
>  			XFS_IS_REALTIME_INODE(ip) ?
>  				mp->m_rtdev_targp : mp->m_ddev_targp;
> -		if ((pos || size) & target->bt_meta_sectormask) {
> +		/* DIO must be aligned to device logical sector size */
> +		if ((pos || size) & target->bt_logical_sectormask) {
>  			if (pos == i_size_read(inode))
>  				return 0;
>  			return -XFS_ERROR(EINVAL);
> @@ -641,9 +642,11 @@ xfs_file_dio_aio_write(
>  	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
>  					mp->m_rtdev_targp : mp->m_ddev_targp;
>  
> -	if ((pos || count) & target->bt_meta_sectormask)
> +	/* DIO must be aligned to device logical sector size */
> +	if ((pos || count) & target->bt_logical_sectormask)
>  		return -XFS_ERROR(EINVAL);
>  

Looks like this requires a v2 to preserve the fixes made in v2 of patch
2, unless I missed a newer version of this somewhere.

Brian

> +	/* "unaligned" here means not aligned to a filesystem block */
>  	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
>  		unaligned_io = 1;
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 64ca8e9..f7ac335 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1587,7 +1587,7 @@ xfs_file_ioctl(
>  			XFS_IS_REALTIME_INODE(ip) ?
>  			mp->m_rtdev_targp : mp->m_ddev_targp;
>  
> -		da.d_mem = da.d_miniosz = target->bt_meta_sectorsize;
> +		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
>  		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
>  
>  		if (copy_to_user(arg, &da, sizeof(da)))
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
