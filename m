Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56866 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932409AbeGCQHI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 12:07:08 -0400
Date: Tue, 3 Jul 2018 09:06:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] iomap: support direct I/O to inline data
Message-ID: <20180703160651.GY5711@magnolia>
References: <20180702145458.22330-1-hch@lst.de>
 <20180702145458.22330-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180702145458.22330-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org

On Mon, Jul 02, 2018 at 08:54:57AM -0600, Christoph Hellwig wrote:
> From: Andreas Gruenbacher <agruenba@redhat.com>
> 
> Add support for reading from and writing to inline data to iomap_dio_rw.
> This saves filesystems from having to implement fallback code for this
> case.
> 
> The inline data is actually cached in the inode, so the I/O is only
> direct in the sense that it doesn't go through the page cache.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 4d8ff0f5ecc9..98a1fdd5c091 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1450,6 +1450,33 @@ iomap_dio_hole_actor(loff_t length, struct iomap_dio *dio)
>  	return length;
>  }
>  
> +static loff_t
> +iomap_dio_inline_actor(struct inode *inode, loff_t pos, loff_t length,
> +		struct iomap_dio *dio, struct iomap *iomap)
> +{
> +	struct iov_iter *iter = dio->submit.iter;
> +	size_t copied;
> +
> +	BUG_ON(pos + length > PAGE_SIZE - offset_in_page(iomap->inline_data));
> +
> +	if (dio->flags & IOMAP_DIO_WRITE) {
> +		loff_t size = inode->i_size;
> +
> +		if (pos > size)
> +			memset(iomap->inline_data + size, 0, pos - size);
> +		copied = copy_from_iter(iomap->inline_data + pos, length, iter);
> +		if (copied) {
> +			if (pos + copied > size)
> +				i_size_write(inode, pos + copied);
> +			mark_inode_dirty(inode);
> +		}
> +	} else {
> +		copied = copy_to_iter(iomap->inline_data + pos, length, iter);
> +	}
> +	dio->size += copied;
> +	return copied;
> +}
> +
>  static loff_t
>  iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>  		void *data, struct iomap *iomap)
> @@ -1467,6 +1494,8 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>  		return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
>  	case IOMAP_MAPPED:
>  		return iomap_dio_bio_actor(inode, pos, length, dio, iomap);
> +	case IOMAP_INLINE:
> +		return iomap_dio_inline_actor(inode, pos, length, dio, iomap);
>  	default:
>  		WARN_ON_ONCE(1);
>  		return -EIO;
> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
