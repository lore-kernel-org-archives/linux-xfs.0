Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C3248424E;
	Fri, 25 Sep 2026 23:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790378699; cv=none; b=BHwzPfg05hpogKfBhA1v7PawwtsLfinJZKUb8UHY7j710Hxu3SfRlCGsHweeBYRXRNGEdHXM9KFhjt94RcIr2Ka9M6tmOqajvL2jIfhZqVzDmTqu/rEpgGStro8BcE4I+Z2Gttai2Tjd8GNpz8rkuNDZDtZCVJmeaNJ6lR0fKlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790378699; c=relaxed/simple;
	bh=l/LkNv3OX/Ocm6W1knZCyrnWNyaZnNUX2F6zQl+Tca8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gsdgCIgS2UDHHfWn5e+A+H3+3FhYCEo+wQRhDVTWN/jKnnMnPSPZUn2NrK2yLJhNQ8XqDFBy5tEW0xCW6MXI7vHvywO3gDEhTN8oXhfvxA+G3k1oyORyqHaOZn6x4Js9oax53GHsUuXyYRcQnfYdIYEm12XfXIDxVNPIg8bXzAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MEAqkLWF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MEAqkLWF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 553591F000FF;
	Fri, 25 Sep 2026 23:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790378697;
	bh=wgD5mIITMUR7iEBhVl+q95S9ZeAxY1aL0FlfAQdUB48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MEAqkLWFf24zQ8scDjh2QNVDVciVv8M1Fd7RK4ojQizBwpj/IkOeb6jP26tOM8oJU
	 C2148KJd8Y/LjtTU8XsEv5/HlPgMfynoP6N0Xt2j5+xfs3S+Zym/pNaV7xa7ZXO4AW
	 pNljkDq57kBYYvCu6BpMln0XJHE7HaFTH9ez1dhow31vCI39Ns9hxbOvYzi8gFOLZe
	 br71yMGbUDKPC62CoTpO/VGL31wc/G0b5Pu+eCfaeeNvlOX+T3wRqi7ma3yIMMWwJA
	 nA8rmRgLILriZosI8AKQlFAmV3fxfdltW/rAc+/RoWuyOxp4K4aJGUHO346UJz+0l3
	 zDQ1QJ3JFfu8A==
Date: Fri, 25 Sep 2026 16:24:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 13/21] xfs: require file system block size alignment when
 using data checksums
Message-ID: <20260925232456.GH2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-14-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:45AM +0200, Christoph Hellwig wrote:
> The checksums cover a whole block, so we can't read or update parts of a
> block.  Report the requirement and enforce it for direct I/O reads.
> Direct I/O writes already require file system block size alignment when
> using the zoned allocator, and buffered I/O never does sub-block I/O.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c  | 14 +++++++++++++-
>  fs/xfs/xfs_ioend.c | 13 +++++++++++--
>  fs/xfs/xfs_iops.c  | 10 +++++++++-
>  3 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 6f25879b6510..5b25f33527c0 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -29,6 +29,7 @@
>  #include "xfs_zone_alloc.h"
>  #include "xfs_error.h"
>  #include "xfs_errortag.h"
> +#include "xfs_rtcsum.h"
>  
>  #include <linux/dax.h>
>  #include <linux/falloc.h>
> @@ -270,9 +271,20 @@ xfs_file_dio_read(
>  	if (ret)
>  		return ret;
>  	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
> +		unsigned int		dio_flags = 0;
> +
> +		/*
> +		 * Each checksums covers a whole file system block, and thus
> +		 * sub-fsblock reads are not supported for file systems using
> +		 * data checksums.
> +		 */
> +		if (xfs_is_rtcsum_inode(ip))
> +			dio_flags |= IOMAP_DIO_FSBLOCK_ALIGNED;
>  		ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops,
> -				&xfs_dio_read_bounce_ops, 0, NULL, 0);
> +				&xfs_dio_read_bounce_ops, dio_flags, NULL, 0);
>  	} else {
> +		ASSERT(!xfs_is_rtcsum_inode(ip));
> +
>  		ret = iomap_dio_read_simple(iocb, to, xfs_read_iomap_begin);
>  		if (ret == -ENOTBLK)
>  			ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index f0e01ac34de8..54bd0995ac29 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
> @@ -44,6 +44,15 @@ xfs_bounce_submit_ioend(
>  	submit_bio(&ioend->io_bio);
>  }
>  
> +static unsigned int
> +xfs_read_bounce_minsize(
> +	struct iomap_ioend	*ioend)
> +{
> +	if (xfs_is_rtcsum_inode(XFS_I(ioend->io_inode)))
> +		return i_blocksize(ioend->io_inode);
> +	return bdev_logical_block_size(ioend->io_bio.bi_bdev);
> +}
> +
>  static void
>  xfs_end_bio_bounced(
>  	struct bio		*bio)
> @@ -86,7 +95,7 @@ xfs_read_bounce_and_resubmit(
>  		.bi_offset	= ioend->io_bvec_offset,
>  	};
>  	bio->bi_end_io = xfs_end_bio_bounced;
> -	iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
> +	iomap_bounce_read(ioend, xfs_read_bounce_minsize(ioend),
>  			xfs_bounce_submit_ioend);
>  	memalloc_nofs_restore(nofs_flag);
>  }
> @@ -134,7 +143,7 @@ xfs_ioend_submit_read(
>  	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
>  	if ((ioend_flags & IOMAP_IOEND_DIRECT) &&
>  	    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_ALWAYS) {
> -		iomap_bounce_read(ioend, bdev_logical_block_size(bio->bi_bdev),
> +		iomap_bounce_read(ioend, xfs_read_bounce_minsize(ioend),
>  				xfs_bounce_submit_ioend);
>  		return;
>  	}
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index d1306e723899..a5f01e2e3a67 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -581,6 +581,15 @@ xfs_report_dioalign(
>  	stat->result_mask |= STATX_DIOALIGN | STATX_DIO_READ_ALIGN;
>  	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
>  
> +	/*
> +	 * Each checksums covers a whole file system block, and thus sub-fsblock
> +	 * reads are not supported for file systems using data checksums.
> +	 */
> +	if (xfs_is_rtcsum_inode(ip))
> +		stat->dio_read_offset_align = xfs_inode_alloc_unitsize(ip);

The allocation unit could be larger than the fsblock size, why is it
necessary to have such large directio reads on a checksummed file?
Though come to think of it zoned mode doesn't allow rtextsize > 1fsb
so this question might be hair-splitting.

I think you could reuse xfs_read_bounce_minsize() here.

--D

> +	else
> +		stat->dio_read_offset_align = bdev_logical_block_size(bdev);
> +
>  	/*
>  	 * For COW inodes, we can only perform out of place writes of entire
>  	 * allocation units (blocks or RT extents).
> @@ -591,7 +600,6 @@ xfs_report_dioalign(
>  	 * alignment in dio_offset_align, and the smaller read alignment in
>  	 * dio_read_offset_align.
>  	 */
> -	stat->dio_read_offset_align = bdev_logical_block_size(bdev);
>  	if (xfs_is_cow_inode(ip))
>  		stat->dio_offset_align = xfs_inode_alloc_unitsize(ip);
>  	else
> -- 
> 2.53.0
> 
> 
