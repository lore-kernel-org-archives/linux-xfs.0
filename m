Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 71FDA7CB8
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 09:56:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3499D30404E
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 07:56:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id WSMDazhS5yg3XVc4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 May 2016 07:56:08 -0700 (PDT)
Date: Mon, 2 May 2016 07:56:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
Message-ID: <20160502145606.GD20589@infradead.org>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>, linux-nvdimm@ml01.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

> index 79defba..97a1f5f 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -167,12 +167,21 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = bdev_file_inode(file);
>  
> -	if (IS_DAX(inode))
> +	if (iocb_is_direct(iocb))
> +		return __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter,
> +					    offset, blkdev_get_block, NULL,
> +					    NULL, DIO_SKIP_DIO_COUNT);
> +	else if (iocb_is_dax(iocb))
>  		return dax_do_io(iocb, inode, iter, offset, blkdev_get_block,
>  				NULL, DIO_SKIP_DIO_COUNT);
> -	return __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter, offset,
> -				    blkdev_get_block, NULL, NULL,
> -				    DIO_SKIP_DIO_COUNT);
> +	else {
> +		/*
> +		 * If we're in the direct_IO path, either the IOCB_DIRECT or
> +		 * IOCB_DAX flags must be set.
> +		 */
> +		WARN_ONCE(1, "Kernel Bug with iocb flags\n");
> +		return -ENXIO;
> +	}

DAX should not even end up in ->direct_IO.

> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -300,7 +300,7 @@ xfs_file_read_iter(
>  
>  	XFS_STATS_INC(mp, xs_read_calls);
>  
> -	if (unlikely(iocb->ki_flags & IOCB_DIRECT))
> +	if (unlikely(iocb->ki_flags & (IOCB_DIRECT | IOCB_DAX)))
>  		ioflags |= XFS_IO_ISDIRECT;

please also add a XFS_IO_ISDAX flag to propagate the information
properly and allow tracing to display the actual I/O type.

> +static inline bool iocb_is_dax(struct kiocb *iocb)
>  {
> +	return IS_DAX(file_inode(iocb->ki_filp)) &&
> +		(iocb->ki_flags & IOCB_DAX);
> +}
> +
> +static inline bool iocb_is_direct(struct kiocb *iocb)
> +{
> +	return iocb->ki_flags & IOCB_DIRECT;
>  }

No need for these helpers - especially as IOCB_DAX should never be set
if IS_DAX is false.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
