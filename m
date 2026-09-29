Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B811D2D781B;
	Tue, 29 Sep 2026 01:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790643666; cv=none; b=SFPlkKf64iM8rrbEVImno/geBxJYZJ4pJ7xJakzInvJb1sYVnl6N90NhFDaxKu8nWKenDXhPw2s9BQZlDZ0FCoiEhWgzAjSuFgndg2LzuP0TG6oyh8IaQDo0SuQ/g1JhEp9wVNcXCKFNsLY3Q0w+672H4UpgfaORJJgXx7N5QhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790643666; c=relaxed/simple;
	bh=FWYGpEr8YsXubeMiQDDwxP7qoiPo0vDveL+foHn/dpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOayiC5ow+JLCS8AhUmmfss/Sqjg79y9kQCdUhKqc9sJtBkh71TrulGfTDNy3EGPJGs7weF+l67jLaQcNMsZ261Fl67QWde3CrUNEqag9flVBylsCpOcoqsQCFQZAoEoG3DNrzIkYP6FS9jjXYcsyqN8adPYejXV0utd78Qli2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqvtRUI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqvtRUI6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 441611F00898;
	Tue, 29 Sep 2026 01:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790643664;
	bh=dyD4888Y4a77ie2KOCA49ANsU7cF9TD5n/ZA/ReOgbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UqvtRUI67b7+TSdMc4lc9U4XpV7qxlacJhIPdvymFrQI4ADdylyybtH63e4WPut1t
	 mZvG75ijcAzyJRfKBSGVAAjQ+u9mCh2Ln3T+ikDpPKaJezSquS5z5/JYGlfwj1sP9l
	 uCAJqCeHaB19DyQNMmbyATOEsZL8Avu86iUo5zzC+m7tyhC76ajKifEPmrl2p8ajsX
	 UwOPTVo5uQea893G7DIljxejBmjbwJTYoAIa0b0f80qYBARWuae8frWl/FF7ksrkpK
	 JiUA1sDWtUpemnPc2YtHLdBtBDEkwUrbjVc8x3zOUUSLJrlwnRGFHvphHqlS65hPor
	 tgiE13Fhb0BcQ==
Date: Mon, 28 Sep 2026 18:01:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 15/21] xfs: add support for writing with data checksums
Message-ID: <20260929010103.GW2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-16-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:47AM +0200, Christoph Hellwig wrote:
> All write to checksummed files need to use ioends so that the checksum
> can be verified from process context.
> 
> The ioend submission path allocates the csum buffer and attaches it to
> the ioend before generating the checksum from the file data.  The I/O
> completion then logs the checksums into the buffers for the LBAs that
> were written.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c       |  7 +++---
>  fs/xfs/xfs_ioend.c      | 38 ++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_ioend.h      |  2 ++
>  fs/xfs/xfs_iomap.c      | 49 ++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_iomap.h      |  4 +++-
>  fs/xfs/xfs_reflink.c    |  2 +-
>  fs/xfs/xfs_zone_alloc.c |  5 +++++
>  7 files changed, 97 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5b25f33527c0..a38191760f81 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1073,7 +1073,8 @@ xfs_file_buffered_write(
>  
>  	trace_xfs_file_buffered_write(iocb, from);
>  	ret = iomap_file_buffered_write(iocb, from,
> -			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
> +			&xfs_buffered_write_iomap_ops,
> +			xfs_get_iomap_write_ops(ip),
>  			NULL);
>  
>  	/*
> @@ -1154,8 +1155,8 @@ xfs_file_buffered_write_zoned(
>  retry:
>  	trace_xfs_file_buffered_write(iocb, from);
>  	ret = iomap_file_buffered_write(iocb, from,
> -			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
> -			&ac);
> +			&xfs_buffered_write_iomap_ops,
> +			xfs_get_iomap_write_ops(ip), &ac);
>  	if (ret == -ENOSPC && !cleared_space) {
>  		/*
>  		 * Kick off writeback to convert delalloc space and release the
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index 7570a1b915c0..7b9c82e3c449 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
> @@ -235,6 +235,37 @@ xfs_ioend_submit_read(
>  	submit_bio(bio);
>  }
>  
> +int
> +xfs_ioend_submit_read_sync(
> +	struct bio		*bio,
> +	struct inode		*inode,
> +	loff_t			file_offset,
> +	u16			ioend_flags)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct iomap_ioend	*ioend;
> +	struct bvec_iter	saved_iter;
> +	int			error;
> +
> +	ASSERT(!(ioend_flags & IOMAP_IOEND_DIRECT));
> +
> +	ioend = iomap_init_ioend(inode, bio, file_offset, ioend_flags);
> +	if (xfs_is_rtcsum_inode(ip) && !xfs_rtcsum_prepare_read(ioend))
> +		return blk_status_to_errno(bio->bi_status);
> +	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
> +		fs_bio_integrity_alloc(bio);
> +	saved_iter = bio->bi_iter;
> +	error = submit_bio_wait(bio);
> +	if (bio_integrity(bio)) {
> +		if (!error)
> +			error = fs_bio_integrity_verify(bio, &saved_iter);
> +		fs_bio_integrity_free(bio);
> +	}
> +	if (xfs_is_rtcsum_inode(ip))
> +		error = xfs_rtcsum_verify_ioend(ioend, error);
> +	return error;
> +}

Hm, synchronous reads to pull in whatever unaligned parts of the
pagecache aren't yet uptodate?

> +
>  static void
>  xfs_end_ioend_write_zoned(
>  	struct iomap_ioend	*ioend)
> @@ -261,6 +292,13 @@ xfs_end_ioend_write_zoned(
>  		goto done;
>  	}
>  
> +	if (xfs_is_rtcsum_inode(ip)) {
> +		error = xfs_rtcsum_log(oz, ioend->io_sector, ioend->io_size,
> +				ioend->io_csum);
> +		if (error)
> +			goto done;
> +	}
> +

Neat that this is all we need to do -- log the computed checksum to
the rtcsum file prior to remapping the new blocks into the data fork.
That's how we take care of the ordering requirements: if the remap
transaction is written to disk, then we know the previous csum update
transaction has already gone out before that.  Right?  And it's harmless
if the csum update makes it to disk but the remap never does, because
the space is now written, nobody can see it yet, and can only be cleared
by zonegc.  Right?

It would be helpful to document this ordering dependency here explicitly
for the benefit of code spelunkers in a few years.

	/*
	 * Log the checksum updates before remapping the newly written
	 * extents into the data fork.  We must commit the csum update
	 * before the remap transaction to satisfy an ordering
	 * requirement that any read after a write must be able to find
	 * the new data and new checksum; or the old data and the old
	 * checksum.  It's harmless if the system fails after the csum
	 * update but before the remap because nobody will ever see the
	 * newly written extent until the next gc cycle.
	 */
	if (xfs_is_rtcsum_inode(ip)) {
		error = xfs_rtcsum_log(...);

(How does that sound?)

I think this looks right, so if the answers to the questions are all
'yes' and you're ok with the comment, then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	error = xfs_zoned_end_io(ip, ioend->io_offset, ioend->io_size,
>  			ioend->io_sector, oz, NULLFSBLOCK);
>  	if (error)
> diff --git a/fs/xfs/xfs_ioend.h b/fs/xfs/xfs_ioend.h
> index 7c2a1ea3e6ed..f01aa208c61f 100644
> --- a/fs/xfs/xfs_ioend.h
> +++ b/fs/xfs/xfs_ioend.h
> @@ -14,5 +14,7 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
>  void xfs_end_bio(struct bio *bio);
>  void xfs_ioend_submit_read(struct inode *inode, struct bio *bio,
>  		loff_t file_offset, u16 ioend_flags);
> +int xfs_ioend_submit_read_sync(struct bio *bio, struct inode *inode,
> +		loff_t file_offset, u16 ioend_flags);
>  
>  #endif /* __XFS_IOEND_H */
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 0e4396e52809..75d02a32a36a 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -33,6 +33,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_rtcsum.h"
> +#include "xfs_ioend.h"
>  
>  #define XFS_ALLOC_ALIGN(mp, off) \
>  	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
> @@ -93,10 +94,45 @@ xfs_iomap_valid(
>  	return true;
>  }
>  
> -const struct iomap_write_ops xfs_iomap_write_ops = {
> +static const struct iomap_write_ops xfs_iomap_write_ops = {
>  	.iomap_valid		= xfs_iomap_valid,
>  };
>  
> +static int
> +xfs_csum_read_folio_range(
> +	const struct iomap_iter	*iter,
> +	struct folio		*folio,
> +	loff_t			pos,
> +	size_t			len)
> +{
> +	const struct iomap	*srcmap = iomap_iter_srcmap(iter);
> +	unsigned int		ioend_flags = iomap_ioend_flags(&iter->iomap);
> +	struct bio		*bio;
> +	int			error;
> +
> +	bio = bio_alloc_bioset(srcmap->bdev, 1, REQ_OP_READ, GFP_NOFS,
> +			&iomap_ioend_bioset);
> +	bio->bi_iter.bi_sector = iomap_sector(srcmap, pos);
> +	bio_add_folio_nofail(bio, folio, len, offset_in_folio(folio, pos));
> +	error = xfs_ioend_submit_read_sync(bio, iter->inode, pos, ioend_flags);
> +	bio_put(bio);
> +	return error;
> +}
> +
> +static const struct iomap_write_ops xfs_iomap_csum_write_ops = {
> +	.iomap_valid		= xfs_iomap_valid,
> +	.read_folio_range	= xfs_csum_read_folio_range,
> +};
> +
> +const struct iomap_write_ops *
> +xfs_get_iomap_write_ops(
> +	struct xfs_inode	*ip)
> +{
> +	if (xfs_is_rtcsum_inode(ip))
> +		return &xfs_iomap_csum_write_ops;
> +	return &xfs_iomap_write_ops;
> +}
> +
>  int
>  xfs_bmbt_to_iomap(
>  	struct xfs_inode	*ip,
> @@ -1617,6 +1653,9 @@ xfs_zoned_fill_srcmap(
>  	 * There is a data fork mapping, only map until the end of it.
>  	 */
>  	xfs_trim_extent(&smap, offset_fsb, *end_fsb - offset_fsb);
> +	if (xfs_is_rtcsum_inode(ip))
> +		smap.br_blockcount = min(smap.br_blockcount,
> +			xfs_rtcsum_max_len(ip->i_mount, smap.br_startblock));
>  	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
>  	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
>  			xfs_iomap_inode_sequence(ip, 0));
> @@ -2415,8 +2454,8 @@ xfs_zero_range(
>  		return dax_zero_range(inode, pos, len, did_zero,
>  				      &xfs_dax_write_iomap_ops);
>  	return iomap_zero_range(inode, pos, len, did_zero,
> -			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
> -			ac);
> +			&xfs_buffered_write_iomap_ops,
> +			xfs_get_iomap_write_ops(ip), ac);
>  }
>  
>  int
> @@ -2432,6 +2471,6 @@ xfs_truncate_page(
>  		return dax_truncate_page(inode, pos, did_zero,
>  					&xfs_dax_write_iomap_ops);
>  	return iomap_truncate_page(inode, pos, did_zero,
> -			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
> -			ac);
> +			&xfs_buffered_write_iomap_ops,
> +			xfs_get_iomap_write_ops(ip), ac);
>  }
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index f2520a9b3a13..bb35e58d31ee 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -43,6 +43,7 @@ xfs_iomap_set_anon_write(
>  	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
>  	if (bdev_has_integrity_csum(iomap->bdev))
>  		iomap->flags |= IOMAP_F_INTEGRITY;
> +	iomap->csum_shift = ip->i_mount->m_rtcsum_shift;
>  }
>  
>  static inline xfs_filblks_t
> @@ -69,6 +70,8 @@ int xfs_read_iomap_begin(struct inode *inode, loff_t offset,
>  		loff_t length, unsigned flags, struct iomap *iomap,
>  		struct iomap *srcmap);
>  
> +const struct iomap_write_ops *xfs_get_iomap_write_ops(struct xfs_inode *ip);
> +
>  extern const struct iomap_ops xfs_buffered_write_iomap_ops;
>  extern const struct iomap_ops xfs_direct_write_iomap_ops;
>  extern const struct iomap_ops xfs_zoned_direct_write_iomap_ops;
> @@ -77,6 +80,5 @@ extern const struct iomap_ops xfs_seek_iomap_ops;
>  extern const struct iomap_ops xfs_xattr_iomap_ops;
>  extern const struct iomap_ops xfs_dax_write_iomap_ops;
>  extern const struct iomap_ops xfs_atomic_write_cow_iomap_ops;
> -extern const struct iomap_write_ops xfs_iomap_write_ops;
>  
>  #endif /* __XFS_IOMAP_H__*/
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 480136136635..6edbe12777ac 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1918,7 +1918,7 @@ xfs_reflink_unshare(
>  	else
>  		error = iomap_file_unshare(inode, offset, len,
>  				&xfs_buffered_write_iomap_ops,
> -				&xfs_iomap_write_ops);
> +				xfs_get_iomap_write_ops(ip));
>  	if (error)
>  		goto out;
>  
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 9d9a713684b9..71cd35352e2e 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -27,6 +27,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_mru_cache.h"
>  #include "xfs_rtcsum.h"
> +#include "xfs_rtcsum.h"
>  #include <linux/bio-integrity.h>
>  
>  static void
> @@ -934,6 +935,10 @@ xfs_zone_alloc_and_submit(
>  
>  	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
>  		fs_bio_integrity_generate(&ioend->io_bio);
> +	if (xfs_is_rtcsum_inode(ip)) {
> +		xfs_csum_generate(mp, &ioend->io_bio,
> +				iomap_csum_alloc(ioend, mp->m_rtcsum_shift));
> +	}
>  
>  	/*
>  	 * If we don't have a locally cached zone in this write context, see if
> -- 
> 2.53.0
> 
> 
