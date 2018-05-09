Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56252 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934971AbeEIQqf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 12:46:35 -0400
Date: Wed, 9 May 2018 09:46:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/33] iomap: add an iomap-based bmap implementation
Message-ID: <20180509164628.GV11261@magnolia>
References: <20180509074830.16196-1-hch@lst.de>
 <20180509074830.16196-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509074830.16196-11-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Wed, May 09, 2018 at 09:48:07AM +0200, Christoph Hellwig wrote:
> This adds a simple iomap-based implementation of the legacy ->bmap
> interface.  Note that we can't easily add checks for rt or reflink
> files, so these will have to remain in the callers.  This interface
> just needs to die..

You /can/ check these...

if (iomap->bdev != inode->i_sb->s_bdev)
	return 0;
if (iomap->flags & IOMAP_F_SHARED)
	return 0;

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap.c            | 29 +++++++++++++++++++++++++++++
>  include/linux/iomap.h |  3 +++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index af525cb47339..049e0c4aacac 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1201,3 +1201,32 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iomap_dio_rw);
> +
> +static loff_t
> +iomap_bmap_actor(struct inode *inode, loff_t pos, loff_t length,
> +		void *data, struct iomap *iomap)
> +{
> +	sector_t *bno = data;
> +
> +	if (iomap->type == IOMAP_MAPPED)
> +		*bno = (iomap->addr + pos - iomap->offset) >> inode->i_blkbits;

Does this need to be careful w.r.t. overflow on systems where sector_t
is a 32-bit unsigned long?

Also, ioctl_fibmap() typecasts the returned sector_t to an int, which
also seems broken.  I agree the interface needs to die, but ioctls take
a long time to deprecate.

--D

> +	return 0;
> +}
> +
> +/* legacy ->bmap interface.  0 is the error return (!) */
> +sector_t
> +iomap_bmap(struct address_space *mapping, sector_t bno,
> +		const struct iomap_ops *ops)
> +{
> +	struct inode *inode = mapping->host;
> +	loff_t pos = bno >> inode->i_blkbits;
> +	unsigned blocksize = i_blocksize(inode);
> +
> +	if (filemap_write_and_wait(mapping))
> +		return 0;
> +
> +	bno = 0;
> +	iomap_apply(inode, pos, blocksize, 0, ops, &bno, iomap_bmap_actor);
> +	return bno;
> +}
> +EXPORT_SYMBOL_GPL(iomap_bmap);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 19a07de28212..07f73224c38b 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/types.h>
>  
> +struct address_space;
>  struct fiemap_extent_info;
>  struct inode;
>  struct iov_iter;
> @@ -95,6 +96,8 @@ loff_t iomap_seek_hole(struct inode *inode, loff_t offset,
>  		const struct iomap_ops *ops);
>  loff_t iomap_seek_data(struct inode *inode, loff_t offset,
>  		const struct iomap_ops *ops);
> +sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
> +		const struct iomap_ops *ops);
>  
>  /*
>   * Flags for direct I/O ->end_io:
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
