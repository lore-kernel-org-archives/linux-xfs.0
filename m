Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CDC2114
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734129578; cv=none; b=HfXEpwkhsdmX2vzX9b3zumHUBN4j2s8CvnPw7sORHDTfZ7RygHsfUPdw4pPJL2OSjsLugUcUU0j3bSoiUAnN+BTDaxYO5mnWuI4O3y4I/FOBq1h4CTwutI1wjWGBrEndc5XELq534iNd30E218998jNuwErQrW11uEHS8MC3qI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734129578; c=relaxed/simple;
	bh=yABF4MrYQwWL1SZTFPB9ZwkbsT1dX0wpi3gTNTUk8+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WSXUho9roHL7NKghu0RLCsBB5JiaePQ6gC1KChTRjgYeW3Hlgwaw0nPqQdyi/EFXOc1gxjIbCrzCyDoCahCBD4LKA6vQ/yeggbWdrJ4uXxJd704m3vHzQjBrnLLVUHQu3LZwk1k7qM8i3XVFyXKqLk1KMqMCr9V5Br8Jy+xqTeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rI0uJg4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rI0uJg4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3020AC4CED0;
	Fri, 13 Dec 2024 22:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734129578;
	bh=yABF4MrYQwWL1SZTFPB9ZwkbsT1dX0wpi3gTNTUk8+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rI0uJg4SG4pVEcd2PxMbS9f8HyvpotKjIVcFaQUpD3hcHWj2xJoaxPdJ/RQYAVMFT
	 vYXSMXiBeUeDAlw6LDR4f6ctFRlPhu8w1yrRc7RBzK9CBrf7Xl4rI7MtcEcOWW49fv
	 IbMz79eSXzmbnae9H+ZESUA0vxdw15l8Oyk4S/J4RX9elY94F9oq24hLnY8Sw+E/Yc
	 o/f1CJ6VacGOjuXeUPSeB2X7Y0t1gHZLnZMRzkc0xa46Envju1kwqRl9K5AmTT/eKN
	 y/q1+IATXDUzYWF5ZAbS5uUa2k3CFcAF7MVIcZ/Z0S/yHQueYrZjNTZjgeGgHqlVcs
	 tMsawSHf5sYag==
Date: Fri, 13 Dec 2024 14:39:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/43] xfs: implement direct writes to zoned RT devices
Message-ID: <20241213223937.GR6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-29-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-29-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:53AM +0100, Christoph Hellwig wrote:
> Direct writes to zoned RT devices are extremely simple.  After taking the
> block reservation before acquiring the iolock, the iomap direct I/O calls
> into ->iomap_begin which will return a "fake" iomap for the entire
> requested range.  The actual block allocation is then done from the
> submit_io handler using code shared with the buffered I/O path.
> 
> The iomap_dio_ops set the bio_set to the (iomap) ioend one and initialize
> the embedded ioend, which allows reusing the existing ioend based buffered
> I/O completion path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah that is a lot simpler. :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_aops.c  |  6 ++--
>  fs/xfs/xfs_aops.h  |  3 +-
>  fs/xfs/xfs_file.c  | 80 +++++++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_iomap.c | 54 +++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iomap.h |  1 +
>  5 files changed, 133 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 67392413216b..a3ca14e811fd 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -137,7 +137,9 @@ xfs_end_ioend(
>  	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
>  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
>  
> -	if (!error && xfs_ioend_is_append(ioend))
> +	if (!error &&
> +	    !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
> +	    xfs_ioend_is_append(ioend))
>  		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
>  done:
>  	iomap_finish_ioends(ioend, error);
> @@ -182,7 +184,7 @@ xfs_end_io(
>  	}
>  }
>  
> -static void
> +void
>  xfs_end_bio(
>  	struct bio		*bio)
>  {
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index e0bd68419764..5a7a0f1a0b49 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -9,6 +9,7 @@
>  extern const struct address_space_operations xfs_address_space_operations;
>  extern const struct address_space_operations xfs_dax_aops;
>  
> -int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
> +int xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
> +void xfs_end_bio(struct bio *bio);
>  
>  #endif /* __XFS_AOPS_H__ */
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 195cf60a81b0..1b39000b7c62 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -25,6 +25,7 @@
>  #include "xfs_iomap.h"
>  #include "xfs_reflink.h"
>  #include "xfs_file.h"
> +#include "xfs_aops.h"
>  #include "xfs_zone_alloc.h"
>  
>  #include <linux/dax.h>
> @@ -548,6 +549,9 @@ xfs_dio_write_end_io(
>  	loff_t			offset = iocb->ki_pos;
>  	unsigned int		nofs_flag;
>  
> +	ASSERT(!xfs_is_zoned_inode(ip) ||
> +	       !(flags & (IOMAP_DIO_UNWRITTEN | IOMAP_DIO_COW)));
> +
>  	trace_xfs_end_io_direct_write(ip, offset, size);
>  
>  	if (xfs_is_shutdown(ip->i_mount))
> @@ -627,14 +631,51 @@ static const struct iomap_dio_ops xfs_dio_write_ops = {
>  	.end_io		= xfs_dio_write_end_io,
>  };
>  
> +static void
> +xfs_dio_zoned_submit_io(
> +	const struct iomap_iter	*iter,
> +	struct bio		*bio,
> +	loff_t			file_offset)
> +{
> +	struct xfs_mount	*mp = XFS_I(iter->inode)->i_mount;
> +	struct xfs_zone_alloc_ctx *ac = iter->private;
> +	xfs_filblks_t		count_fsb;
> +	struct iomap_ioend	*ioend;
> +
> +	count_fsb = XFS_B_TO_FSB(mp, bio->bi_iter.bi_size);
> +	if (count_fsb > ac->reserved_blocks) {
> +		xfs_err(mp,
> +"allocation (%lld) larger than reservation (%lld).",
> +			count_fsb, ac->reserved_blocks);
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		bio_io_error(bio);
> +		return;
> +	}
> +	ac->reserved_blocks -= count_fsb;
> +
> +	bio->bi_end_io = xfs_end_bio;
> +	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
> +			IOMAP_IOEND_DIRECT);
> +	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
> +}
> +
> +static const struct iomap_dio_ops xfs_dio_zoned_write_ops = {
> +	.bio_set	= &iomap_ioend_bioset,
> +	.submit_io	= xfs_dio_zoned_submit_io,
> +	.end_io		= xfs_dio_write_end_io,
> +};
> +
>  /*
> - * Handle block aligned direct I/O writes
> + * Handle block aligned direct I/O writes.
>   */
>  static noinline ssize_t
>  xfs_file_dio_write_aligned(
>  	struct xfs_inode	*ip,
>  	struct kiocb		*iocb,
> -	struct iov_iter		*from)
> +	struct iov_iter		*from,
> +	const struct iomap_ops	*ops,
> +	const struct iomap_dio_ops *dops,
> +	struct xfs_zone_alloc_ctx *ac)
>  {
>  	unsigned int		iolock = XFS_IOLOCK_SHARED;
>  	ssize_t			ret;
> @@ -642,7 +683,7 @@ xfs_file_dio_write_aligned(
>  	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
>  	if (ret)
>  		return ret;
> -	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
> +	ret = xfs_file_write_checks(iocb, from, &iolock, ac);
>  	if (ret)
>  		goto out_unlock;
>  
> @@ -656,11 +697,31 @@ xfs_file_dio_write_aligned(
>  		iolock = XFS_IOLOCK_SHARED;
>  	}
>  	trace_xfs_file_direct_write(iocb, from);
> -	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
> -			   &xfs_dio_write_ops, 0, NULL, 0);
> +	ret = iomap_dio_rw(iocb, from, ops, dops, 0, ac, 0);
>  out_unlock:
> -	if (iolock)
> -		xfs_iunlock(ip, iolock);
> +	xfs_iunlock(ip, iolock);
> +	return ret;
> +}
> +
> +/*
> + * Handle block aligned direct I/O writes to zoned devices.
> + */
> +static noinline ssize_t
> +xfs_file_dio_write_zoned(
> +	struct xfs_inode	*ip,
> +	struct kiocb		*iocb,
> +	struct iov_iter		*from)
> +{
> +	struct xfs_zone_alloc_ctx ac = { };
> +	ssize_t			ret;
> +
> +	ret = xfs_zoned_write_space_reserve(ip, iocb, from, 0, &ac);
> +	if (ret < 0)
> +		return ret;
> +	ret = xfs_file_dio_write_aligned(ip, iocb, from,
> +			&xfs_zoned_direct_write_iomap_ops,
> +			&xfs_dio_zoned_write_ops, &ac);
> +	xfs_zoned_space_unreserve(ip, &ac);
>  	return ret;
>  }
>  
> @@ -777,7 +838,10 @@ xfs_file_dio_write(
>  	    (xfs_is_always_cow_inode(ip) &&
>  	     (iov_iter_alignment(from) & ip->i_mount->m_blockmask)))
>  		return xfs_file_dio_write_unaligned(ip, iocb, from);
> -	return xfs_file_dio_write_aligned(ip, iocb, from);
> +	if (xfs_is_zoned_inode(ip))
> +		return xfs_file_dio_write_zoned(ip, iocb, from);
> +	return xfs_file_dio_write_aligned(ip, iocb, from,
> +			&xfs_direct_write_iomap_ops, &xfs_dio_write_ops, NULL);
>  }
>  
>  static noinline ssize_t
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 402b253ce3a2..9626632883d0 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -965,6 +965,60 @@ const struct iomap_ops xfs_direct_write_iomap_ops = {
>  	.iomap_begin		= xfs_direct_write_iomap_begin,
>  };
>  
> +#ifdef CONFIG_XFS_RT
> +/*
> + * This is really simple.  The space has already been reserved before taking the
> + * IOLOCK, the actual block allocation is done just before submitting the bio
> + * and only recorded in the extent map on I/O completion.
> + */
> +static int
> +xfs_zoned_direct_write_iomap_begin(
> +	struct inode		*inode,
> +	loff_t			offset,
> +	loff_t			length,
> +	unsigned		flags,
> +	struct iomap		*iomap,
> +	struct iomap		*srcmap)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	int			error;
> +
> +	ASSERT(!(flags & IOMAP_OVERWRITE_ONLY));
> +
> +	/*
> +	 * Needs to be pushed down into the allocator so that only writes into
> +	 * a single zone can be supported.
> +	 */
> +	if (flags & IOMAP_NOWAIT)
> +		return -EAGAIN;
> +
> +	/*
> +	 * Ensure the extent list is in memory in so that we don't have to do
> +	 * read it from the I/O completion handler.
> +	 */
> +	if (xfs_need_iread_extents(&ip->i_df)) {
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		if (error)
> +			return error;
> +	}
> +
> +	iomap->type = IOMAP_MAPPED;
> +	iomap->flags = IOMAP_F_DIRTY;
> +	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
> +	iomap->offset = offset;
> +	iomap->length = length;
> +	iomap->flags = IOMAP_F_ZONE_APPEND;
> +	iomap->addr = 0;
> +	return 0;
> +}
> +
> +const struct iomap_ops xfs_zoned_direct_write_iomap_ops = {
> +	.iomap_begin		= xfs_zoned_direct_write_iomap_begin,
> +};
> +#endif /* CONFIG_XFS_RT */
> +
>  static int
>  xfs_dax_write_iomap_end(
>  	struct inode		*inode,
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index bc8a00cad854..d330c4a581b1 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -51,6 +51,7 @@ xfs_aligned_fsb_count(
>  
>  extern const struct iomap_ops xfs_buffered_write_iomap_ops;
>  extern const struct iomap_ops xfs_direct_write_iomap_ops;
> +extern const struct iomap_ops xfs_zoned_direct_write_iomap_ops;
>  extern const struct iomap_ops xfs_read_iomap_ops;
>  extern const struct iomap_ops xfs_seek_iomap_ops;
>  extern const struct iomap_ops xfs_xattr_iomap_ops;
> -- 
> 2.45.2
> 
> 
