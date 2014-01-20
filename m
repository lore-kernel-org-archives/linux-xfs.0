Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 74F017F37
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 08:21:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4800B304053
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 06:21:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3PP3uQ9w0aGG6tmD for
	<xfs@oss.sgi.com>; Mon, 20 Jan 2014 06:21:10 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0KEL9J8001315
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 09:21:09 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0KEL8L5019770
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 09:21:09 -0500
Message-ID: <52DD30D3.9000806@redhat.com>
Date: Mon, 20 Jan 2014 09:21:07 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: clean up xfs_buftarg
References: <52D6CC91.6000408@redhat.com> <52D9910C.9000205@sandeen.net>
	<52D99158.8070108@sandeen.net>
In-Reply-To: <52D99158.8070108@sandeen.net>
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

On 01/17/2014 03:23 PM, Eric Sandeen wrote:
> Clean up the xfs_buftarg structure a bit:
> - remove bt_bsize, which is never used
> - replace bt_sshift with bt_ssize; we only ever shift it back
>   to a size anyway
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9fccfb5..b664bce 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -445,7 +445,7 @@ _xfs_buf_find(
>  	numbytes = BBTOB(numblks);
>  
>  	/* Check for IOs smaller than the sector size / not sector aligned */
> -	ASSERT(!(numbytes < (1 << btp->bt_sshift)));
> +	ASSERT(!(numbytes < btp->bt_ssize));
>  	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_smask));
>  
>  	/*
> @@ -1599,8 +1599,7 @@ xfs_setsize_buftarg(
>  	unsigned int		blocksize,
>  	unsigned int		sectorsize)
>  {
> -	btp->bt_bsize = blocksize;
> -	btp->bt_sshift = ffs(sectorsize) - 1;
> +	btp->bt_ssize = sectorsize;
>  	btp->bt_smask = sectorsize - 1;
>  
>  	if (set_blocksize(btp->bt_bdev, sectorsize)) {
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 1cf21a4..4ef949a 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -93,8 +93,7 @@ typedef struct xfs_buftarg {
>  	struct block_device	*bt_bdev;
>  	struct backing_dev_info	*bt_bdi;
>  	struct xfs_mount	*bt_mount;
> -	unsigned int		bt_bsize;
> -	unsigned int		bt_sshift;
> +	unsigned int		bt_ssize;
>  	size_t			bt_smask;
>  
>  	/* LRU control structures */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 33ad9a7..39c38ee 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1587,7 +1587,7 @@ xfs_file_ioctl(
>  			XFS_IS_REALTIME_INODE(ip) ?
>  			mp->m_rtdev_targp : mp->m_ddev_targp;
>  
> -		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
> +		da.d_mem = da.d_miniosz = target->bt_ssize;
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
