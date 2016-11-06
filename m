Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26520 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750909AbcKFWky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Nov 2016 17:40:54 -0500
Date: Mon, 7 Nov 2016 09:40:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] iomap: implement direct I/O
Message-ID: <20161106224049.GP14023@dastard>
References: <1478276479-10749-1-git-send-email-hch@lst.de>
 <1478276479-10749-5-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478276479-10749-5-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, axboe@fb.com, kent.overstreet@gmail.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Nov 04, 2016 at 10:21:18AM -0600, Christoph Hellwig wrote:
> This adds a full fledget direct I/O implementation using the iomap
> interface. Full fledged in this case means all features are supported:
> AIO, vectored I/O, any iov_iter type including kernel pointers, bvecs
> and pipes, support for hole filling and async apending writes.  It does
> not mean supporting all the warts of the old generic code.  We expect
> i_rwsem to be held over the duration of the call, and we expect to
> maintain i_dio_count ourselves, and we pass on any kinds of mapping
> to the file system for now.
> 
> The algorithm used is very simple: We use iomap_apply to iterate over
> the range of the I/O, and then we use the new bio_iov_iter_get_pages
> helper to lock down the user range for the size of the extent.
> bio_iov_iter_get_pages can currently lock down twice as many pages as
> the old direct I/O code did, which means that we will have a better
> batch factor for everything but overwrites of badly fragmented files.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> +static loff_t
> +iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
> +		void *data, struct iomap *iomap)
> +{
> +	struct iomap_dio *dio = data;
> +	unsigned blkbits = blksize_bits(bdev_logical_block_size(iomap->bdev));
> +	unsigned fs_block_size = (1 << inode->i_blkbits), pad;
> +	struct iov_iter iter = *dio->submit.iter;
> +	struct bio *bio;
> +	bool may_zero = false;
> +	int nr_pages, ret;
> +
> +	if ((pos | length | iov_iter_alignment(&iter)) & ((1 << blkbits) - 1))
> +		return -EINVAL;
> +
> +	switch (iomap->type) {
> +	case IOMAP_HOLE:
> +		/*
> +		 * We return -ENOTBLK to fall back to buffered I/O for file
> +		 * systems that can't fill holes from direct writes.
> +		 */
> +		if (dio->flags & IOMAP_DIO_WRITE)
> +			return -ENOTBLK;
> +		/*FALLTHRU*/

This is preventing direct IO writes from being done into holes for
all filesystems.

> +	case IOMAP_UNWRITTEN:
> +		if (!(dio->flags & IOMAP_DIO_WRITE)) {
> +			iov_iter_zero(length, dio->submit.iter);
> +			dio->size += length;
> +			return length;
> +		}
> +		dio->flags |= IOMAP_DIO_UNWRITTEN;
> +		may_zero = true;
> +		break;
> +	case IOMAP_MAPPED:
> +		if (iomap->flags & IOMAP_F_SHARED)
> +			dio->flags |= IOMAP_DIO_COW;
> +		if (iomap->flags & IOMAP_F_NEW)
> +			may_zero = true;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EIO;
> +	}
> +
> +	iov_iter_truncate(&iter, length);

Won't this truncate the entire DIO down to the length of the first
extent that is mapped? 

> +	if (may_zero) {
> +		pad = pos & (fs_block_size - 1);
> +		if (pad)
> +			iomap_dio_zero(dio, iomap, pos, fs_block_size - pad);
> +	}

Repeated zeroing code. helper function?

> +	inode_dio_begin(inode);
> +
> +	blk_start_plug(&plug);
> +	do {
> +		ret = iomap_apply(inode, pos, count, flags, ops, dio,
> +				iomap_dio_actor);
> +		if (ret <= 0) {
> +			/* magic error code to fall back to buffered I/O */
> +			if (ret == -ENOTBLK)
> +				ret = 0;
> +			break;
> +		}
> +		pos += ret;
> +	} while ((count = iov_iter_count(iter)) > 0);
> +	blk_finish_plug(&plug);
> +
> +	if (ret < 0)
> +		cmpxchg(&dio->error, 0, ret);

Why cmpxchg? What are we racing with here? Helper (e.g.
dio_set_error())?

> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -49,6 +49,7 @@ struct iomap {
>  #define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
>  #define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
>  #define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
> +#define IOMAP_DIRECT		(1 << 3)

Comment decribing use?

>  struct iomap_ops {
>  	/*
> @@ -82,4 +83,11 @@ int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		loff_t start, loff_t len, struct iomap_ops *ops);
>  
> +#define IOMAP_DIO_UNWRITTEN	(1 << 0)
> +#define IOMAP_DIO_COW		(1 << 1)
> +typedef int (iomap_dio_end_io_t)(struct kiocb *iocb, ssize_t ret,
> +		unsigned flags);
> +ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> +		struct iomap_ops *ops, iomap_dio_end_io_t end_io);

Comment on the context the new flags are used under and what they
mean?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
