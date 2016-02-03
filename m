Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A76B57CA5
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 07:52:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2DD9BAC004
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 05:52:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0wqGpokJ4aE1oehs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 05:52:22 -0800 (PST)
Date: Wed, 3 Feb 2016 08:52:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: fold xfs_vm_do_dio into xfs_vm_direct_IO
Message-ID: <20160203135220.GD20211@bfoster.bfoster>
References: <1454444257-9086-1-git-send-email-hch@lst.de>
	<1454444257-9086-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454444257-9086-4-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, darrick.wong@oracle.com, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Tue, Feb 02, 2016 at 09:17:37PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c | 39 ++++++++++++++-------------------------
>  1 file changed, 14 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f6b08ea..e3cb7f8 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1599,41 +1599,30 @@ xfs_end_io_direct_write(
>  	}
>  }
>  
> -static inline ssize_t
> -xfs_vm_do_dio(
> -	struct inode		*inode,
> +STATIC ssize_t
> +xfs_vm_direct_IO(
>  	struct kiocb		*iocb,
>  	struct iov_iter		*iter,
> -	loff_t			offset,
> -	void			(*endio)(struct kiocb	*iocb,
> -					 loff_t		offset,
> -					 ssize_t	size,
> -					 void		*private),
> -	int			flags)
> +	loff_t			offset)
>  {
> +	struct inode		*inode = iocb->ki_filp->f_mapping->host;
> +	dio_iodone_t		*endio = NULL;
> +	int			flags = 0;
>  	struct block_device	*bdev;
>  
> -	if (IS_DAX(inode))
> +	if (iov_iter_rw(iter) == WRITE) {
> +		endio = xfs_end_io_direct_write;
> +		flags = DIO_ASYNC_EXTEND;
> +	}
> +
> +	if (IS_DAX(inode)) {
>  		return dax_do_io(iocb, inode, iter, offset,
>  				 xfs_get_blocks_direct, endio, 0);
> +	}
>  
>  	bdev = xfs_find_bdev_for_inode(inode);
>  	return  __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
> -				     xfs_get_blocks_direct, endio, NULL, flags);
> -}
> -
> -STATIC ssize_t
> -xfs_vm_direct_IO(
> -	struct kiocb		*iocb,
> -	struct iov_iter		*iter,
> -	loff_t			offset)
> -{
> -	struct inode		*inode = iocb->ki_filp->f_mapping->host;
> -
> -	if (iov_iter_rw(iter) == WRITE)
> -		return xfs_vm_do_dio(inode, iocb, iter, offset,
> -				     xfs_end_io_direct_write, DIO_ASYNC_EXTEND);
> -	return xfs_vm_do_dio(inode, iocb, iter, offset, NULL, 0);
> +			xfs_get_blocks_direct, endio, NULL, flags);
>  }
>  
>  /*
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
