Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 86E957F52
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 08:21:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 77F87304053
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 06:21:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id u7OlqFca4YsvcgGN for
	<xfs@oss.sgi.com>; Mon, 20 Jan 2014 06:21:24 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0KELOW4029843
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 09:21:24 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0KELNIh020006
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 09:21:23 -0500
Message-ID: <52DD30E2.1060400@redhat.com>
Date: Mon, 20 Jan 2014 09:21:22 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3 V2] xfs: rename xfs_buftarg structure members
References: <52D6CC91.6000408@redhat.com>
	<52D9910C.9000205@sandeen.net>	<52D991E5.1010300@sandeen.net>
	<52D99D29.4020400@sandeen.net>
In-Reply-To: <52D99D29.4020400@sandeen.net>
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
To: xfs@oss.sgi.com

On 01/17/2014 04:14 PM, Eric Sandeen wrote:
> In preparation for adding new members to the xfs_buftarg
> structure, give these old ones more descriptive names:
> 
> 	bt_ssize -> bt_meta_sectorsize
> 	bt_smask -> bt_meta_sectormask
> 
> (Note the slight change in logic format in xfs_file_aio_read(()
> and xfs_file_dio_aio_write(); this was done just for formatting,
> and should not change actual logic or behavior.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2: Really make the logic equivalent, thanks Roger!
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index b664bce..a526f8d 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -445,8 +445,8 @@ _xfs_buf_find(
>  	numbytes = BBTOB(numblks);
>  
>  	/* Check for IOs smaller than the sector size / not sector aligned */
> -	ASSERT(!(numbytes < btp->bt_ssize));
> -	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_smask));
> +	ASSERT(!(numbytes < btp->bt_meta_sectorsize));
> +	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_meta_sectormask));
>  
>  	/*
>  	 * Corrupted block numbers can get through to here, unfortunately, so we
> @@ -1599,8 +1599,8 @@ xfs_setsize_buftarg(
>  	unsigned int		blocksize,
>  	unsigned int		sectorsize)
>  {
> -	btp->bt_ssize = sectorsize;
> -	btp->bt_smask = sectorsize - 1;
> +	btp->bt_meta_sectorsize = sectorsize;
> +	btp->bt_meta_sectormask = sectorsize - 1;
>  
>  	if (set_blocksize(btp->bt_bdev, sectorsize)) {
>  		char name[BDEVNAME_SIZE];
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 4ef949a..d5d88dd 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -93,8 +93,8 @@ typedef struct xfs_buftarg {
>  	struct block_device	*bt_bdev;
>  	struct backing_dev_info	*bt_bdi;
>  	struct xfs_mount	*bt_mount;
> -	unsigned int		bt_ssize;
> -	size_t			bt_smask;
> +	unsigned int		bt_meta_sectorsize;
> +	size_t			bt_meta_sectormask;
>  
>  	/* LRU control structures */
>  	struct shrinker		bt_shrinker;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 52c91e1..61a7de0 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -261,7 +261,7 @@ xfs_file_aio_read(
>  		xfs_buftarg_t	*target =
>  			XFS_IS_REALTIME_INODE(ip) ?
>  				mp->m_rtdev_targp : mp->m_ddev_targp;
> -		if ((pos & target->bt_smask) || (size & target->bt_smask)) {
> +		if ((pos | size) & target->bt_meta_sectormask) {
>  			if (pos == i_size_read(inode))
>  				return 0;
>  			return -XFS_ERROR(EINVAL);
> @@ -641,7 +641,7 @@ xfs_file_dio_aio_write(
>  	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
>  					mp->m_rtdev_targp : mp->m_ddev_targp;
>  
> -	if ((pos & target->bt_smask) || (count & target->bt_smask))
> +	if ((pos | count) & target->bt_meta_sectormask)
>  		return -XFS_ERROR(EINVAL);
>  
>  	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 39c38ee..64ca8e9 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1587,7 +1587,7 @@ xfs_file_ioctl(
>  			XFS_IS_REALTIME_INODE(ip) ?
>  			mp->m_rtdev_targp : mp->m_ddev_targp;
>  
> -		da.d_mem = da.d_miniosz = target->bt_ssize;
> +		da.d_mem = da.d_miniosz = target->bt_meta_sectorsize;
>  		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
>  
>  		if (copy_to_user(arg, &da, sizeof(da)))
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
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
