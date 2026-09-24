Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF2B3911B5;
	Thu, 24 Sep 2026 21:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790285945; cv=none; b=IKOgSsUixWKf+ltc6+hDXKueisqg0VFZMDGBD2u58d7kS38GTguVnrtHyToooM1V+NaiA8rpw2sm7KOI3yXP+etwZTJHUlFP7Mh9hGHddn8kmtlVw/D4GfGNI/ISdovV0ZZSdcvnLPLKhqKtUGThI2uDuKmLluEhY3EeQwPM68s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790285945; c=relaxed/simple;
	bh=NRtLzi7LAK6YpfmO67Z5+pa+d1jb/afcSrdvFYDwFZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UT5uyVfWfKYB9B8mRhrsLQ2d8N5O/1Ln7Lo9rnXT9AR6VRPa2tl5ZLP/NP6kkz4znZPTdpUsHRkh95l88hw6dq3paUh8BSCVXOVqCVpb30mFNerybKYJU1HwmI92biyOt2P8j/MlJk6y6uIA2KmhGpA97EBP8FSIdIrRAkgUh3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZa9aLc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZa9aLc8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 987721F000FF;
	Thu, 24 Sep 2026 21:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790285942;
	bh=C7VABCJNbqJak0u/ubw1Jnz/NjHM4q5CwuBYScK47QQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PZa9aLc81Uxn5GZ7ZO2moCT6Jx6t/wg4NLmuEk4HYOIe7JiScHCqW0ZL9rHyK0g2t
	 aZakKA8yeb9k4ULVBoKgC+zLSXhtELTUNz+7aaIzLF8Y3TxaoxIbtd8+kMQmHC0E0L
	 uQu/GBgaB/Cj6e74A+j3qVFebJaWfRlXp7REunVMMCw8X8kwkk2yfxCsn7LaD3YHAD
	 /FmDDtZepRXXaLUyZeS8R449R0xuRSJpHGcpOw0tffHCtOEwAHbgayngiN1ymgdywc
	 p+tpXrKwKBmUq9a/wu1aF85JqdPBCEOTkMuR5VBOS73/QMyGhAl/oePoZtNwVyak+Z
	 WywL8fgm1Q9qQ==
Date: Thu, 24 Sep 2026 14:39:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/21] iomap: add support for data checksumming
Message-ID: <20260924213902.GD2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-3-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:34AM +0200, Christoph Hellwig wrote:
> Add a new refcounted structure for a data checksum attached to
> an iomap_ioend, and helpers to allocate, split and access it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/bio.c        |  3 +-
>  fs/iomap/direct-io.c  |  2 +-
>  fs/iomap/internal.h   | 21 +++++++++---
>  fs/iomap/ioend.c      | 77 ++++++++++++++++++++++++++++++++++++++++---
>  include/linux/iomap.h | 31 ++++++++++++++++-
>  5 files changed, 122 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index d46c2f8ea18c..7b8fddd6d061 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -151,7 +151,8 @@ int iomap_bio_read_folio_range(const struct iomap_iter *iter,
>  
>  	if (!bio ||
>  	    bio_end_sector(bio) != iomap_sector(&iter->iomap, iter->pos) ||
> -	    bio->bi_iter.bi_size > iomap_max_bio_size(&iter->iomap) - plen ||
> +	    bio->bi_iter.bi_size >
> +			iomap_max_bio_size(iter->inode, &iter->iomap) - plen ||
>  	    !bio_add_folio(bio, folio, plen, offset_in_folio(folio, iter->pos)))
>  		iomap_read_alloc_bio(iter, ctx, plen);
>  	return 0;
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 41fdc90a9094..7cf70fb0165a 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -344,7 +344,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>  		struct iomap_dio *dio, loff_t pos, unsigned int alignment,
>  		blk_opf_t op)
>  {
> -	unsigned int maxsize = iomap_max_bio_size(&iter->iomap);
> +	unsigned int maxsize = iomap_max_bio_size(iter->inode, &iter->iomap);
>  	unsigned int nr_vecs;
>  	struct bio *bio;
>  	ssize_t ret;
> diff --git a/fs/iomap/internal.h b/fs/iomap/internal.h
> index 74e898b196dc..7ac5e300e010 100644
> --- a/fs/iomap/internal.h
> +++ b/fs/iomap/internal.h
> @@ -4,17 +4,28 @@
>  
>  #define IOEND_BATCH_SIZE	4096
>  
> +static inline unsigned int max_csum_io_size(const struct inode *inode,
> +		const struct iomap *iomap)
> +{
> +	return IOMAP_CSUM_MAX_SIZE << (inode->i_blkbits - iomap->csum_shift);
> +}
> +
>  /*
>   * Normally we can build bios as big as the data structure supports.
>   *
> - * But for integrity protected I/O we need to respect the maximum size of the
> - * single contiguous allocation for the integrity buffer.
> + * But for checksum or integrity protected I/O we need to respect the maximum
> + * size of the single contiguous allocation for the checksum/integrity buffer.
>   */
> -static inline size_t iomap_max_bio_size(const struct iomap *iomap)
> +static inline size_t iomap_max_bio_size(const struct inode *inode,
> +		const struct iomap *iomap)
>  {
> +	size_t max = BIO_MAX_SIZE;
> +
>  	if (iomap->flags & IOMAP_F_INTEGRITY)
> -		return max_integrity_io_size(bdev_limits(iomap->bdev));
> -	return BIO_MAX_SIZE;
> +		max = min(max, max_integrity_io_size(bdev_limits(iomap->bdev)));
> +	if (iomap->csum_shift)
> +		max = min(max, max_csum_io_size(inode, iomap));
> +	return max;
>  }
>  
>  u32 iomap_finish_ioend_buffered_read(struct iomap_ioend *ioend);
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index bbebecc31670..877f0f470947 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -14,6 +14,7 @@
>  struct bio_set iomap_ioend_bioset;
>  EXPORT_SYMBOL_GPL(iomap_ioend_bioset);
>  static struct bio_set iomap_ioend_split_bioset;
> +static mempool_t ioend_csum_pool;
>  
>  struct iomap_ioend *iomap_init_ioend(struct inode *inode,
>  		struct bio *bio, loff_t file_offset, u16 ioend_flags)
> @@ -25,6 +26,7 @@ struct iomap_ioend *iomap_init_ioend(struct inode *inode,
>  	ioend->io_parent = NULL;
>  	INIT_LIST_HEAD(&ioend->io_list);
>  	ioend->io_flags = ioend_flags;
> +	ioend->io_csum_shift = 0;
>  	ioend->io_bvec_offset = bio->bi_iter.bi_offset;
>  	ioend->io_inode = inode;
>  	ioend->io_offset = file_offset;
> @@ -32,10 +34,55 @@ struct iomap_ioend *iomap_init_ioend(struct inode *inode,
>  	ioend->io_sector = bio->bi_iter.bi_sector;
>  	ioend->io_vi = NULL;
>  	ioend->io_private = NULL;
> +	ioend->io_csum = NULL;
>  	return ioend;
>  }
>  EXPORT_SYMBOL_GPL(iomap_init_ioend);
>  
> +static void *__iomap_csum_alloc(struct iomap_ioend *ioend)
> +{
> +	size_t csum_size = iomap_csum_size(ioend);
> +
> +	WARN_ON_ONCE(csum_size > IOMAP_CSUM_MAX_SIZE);
> +	if (csum_size <= sizeof(ioend->io_csum_inline)) {
> +		ioend->io_flags |= IOMAP_IOEND_CSUM_INLINE;
> +		return ioend->io_csum_inline;
> +	}
> +
> +	ioend->io_csum_alloc = kmalloc(csum_size,
> +		GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NORETRY);

Odd indenting here -- two tabs?

> +	if (!ioend->io_csum_alloc) {
> +		struct page *page = mempool_alloc(&ioend_csum_pool, GFP_NOFS);
> +
> +		ioend->io_flags |= IOMAP_IOEND_CSUM_MEMPOOL;
> +		ioend->io_csum_alloc = page_address(page);
> +	}
> +	return ioend->io_csum_alloc;
> +}
> +
> +void *iomap_csum_alloc(struct iomap_ioend *ioend, u8 csum_shift)
> +{
> +	ioend->io_csum_shift = csum_shift;
> +	ioend->io_csum = __iomap_csum_alloc(ioend);
> +	return ioend->io_csum;
> +}
> +EXPORT_SYMBOL_GPL(iomap_csum_alloc);

AFAICT, io_csum_inline is a small amount of memory in the ioend itself
to store checksums for the blocks being written, and io_csum_alloc is a
dynamically allocated blob if the checksums don't fit inline?  And
io_csum points to wherever that data lives?

Hrm.  What if you want to split an ioend, I guess the child's io_csum
points to somewhere inside io_parent->io_csum?

(Perhaps it would help to point this out in the struct definition?)

> +void iomap_csum_free(struct iomap_ioend *ioend)
> +{
> +	if (ioend->io_flags & IOMAP_IOEND_CSUM_MEMPOOL) {
> +		mempool_free(virt_to_page(ioend->io_csum_alloc),
> +				&ioend_csum_pool);
> +	} else if (!(ioend->io_flags & IOMAP_IOEND_CSUM_INLINE)) {
> +		kfree(ioend->io_csum_alloc);
> +	}
> +
> +	ioend->io_flags &=
> +		~(IOMAP_IOEND_CSUM_MEMPOOL | IOMAP_IOEND_CSUM_INLINE);
> +	ioend->io_csum_shift = 0;
> +}
> +EXPORT_SYMBOL_GPL(iomap_csum_free);
> +
>  /*
>   * We're now finished for good with this ioend structure.  Update the folio
>   * state, release holds on bios, and finally free up memory.  Do not use the
> @@ -178,7 +225,7 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos,
>  	struct iomap_ioend *ioend = wpc->wb_ctx;
>  
>  	if (ioend->io_bio.bi_iter.bi_size >
> -	    iomap_max_bio_size(&wpc->iomap) - map_len)
> +	    iomap_max_bio_size(wpc->inode, &wpc->iomap) - map_len)
>  		return false;
>  	if (ioend_flags & IOMAP_IOEND_BOUNDARY)
>  		return false;
> @@ -321,7 +368,7 @@ EXPORT_SYMBOL_GPL(iomap_ioend_integrity_verify);
>  
>  static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
>  {
> -	if (ioend->io_parent) {
> +	if (ioend->io_flags & IOMAP_IOEND_CHAINED) {
>  		struct bio *bio = &ioend->io_bio;
>  
>  		ioend = ioend->io_parent;
> @@ -334,6 +381,9 @@ static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
>  	if (!atomic_dec_and_test(&ioend->io_remaining))
>  		return 0;
>  
> +	if (iomap_has_csum(ioend))
> +		iomap_csum_free(ioend);
> +
>  	if (ioend->io_flags & IOMAP_IOEND_DIRECT)
>  		return iomap_finish_ioend_direct(ioend);
>  	if (bio_op(&ioend->io_bio) == REQ_OP_READ)
> @@ -409,6 +459,8 @@ static bool iomap_ioend_can_merge(struct iomap_ioend *ioend,
>  	if (ioend->io_sector + (ioend->io_size >> SECTOR_SHIFT) !=
>  	    next->io_sector)
>  		return false;
> +	if (ioend->io_csum || next->io_csum)
> +		return false;
>  	return true;
>  }
>  
> @@ -498,8 +550,9 @@ struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
>  	split->bi_end_io = bio->bi_end_io;
>  
>  	split_ioend = iomap_init_ioend(ioend->io_inode, split, ioend->io_offset,
> -			ioend->io_flags);
> +			ioend->io_flags | IOMAP_IOEND_CHAINED);
>  	split_ioend->io_parent = ioend;
> +	split_ioend->io_csum_shift = ioend->io_csum_shift;
>  
>  	atomic_inc(&ioend->io_remaining);
>  	ioend->io_offset += split_ioend->io_size;
> @@ -508,6 +561,12 @@ struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
>  	split_ioend->io_sector = ioend->io_sector;
>  	if (!is_append)
>  		ioend->io_sector += (split_ioend->io_size >> SECTOR_SHIFT);
> +
> +	if (iomap_has_csum(ioend)) {
> +		split_ioend->io_csum = ioend->io_csum;
> +		ioend->io_csum += iomap_csum_size(split_ioend);
> +	}
> +
>  	return split_ioend;
>  }
>  EXPORT_SYMBOL_GPL(iomap_split_ioend);
> @@ -547,7 +606,9 @@ void iomap_bounce_read(struct iomap_ioend *orig_ioend, unsigned int minsize,
>  		bio->bi_iter.bi_sector = sector;
>  
>  		ioend = iomap_init_ioend(inode, bio, file_offset,
> -				orig_ioend->io_flags);
> +				orig_ioend->io_flags &
> +					~(IOMAP_IOEND_CSUM_MEMPOOL |
> +					  IOMAP_IOEND_CSUM_INLINE));
>  
>  		total_len -= bio->bi_iter.bi_size;
>  		file_offset += bio->bi_iter.bi_size;
> @@ -593,6 +654,8 @@ void iomap_bounce_read_end_io(struct iomap_ioend *ioend, struct bio *orig_bio,
>  	else
>  		iomap_ioend_unbounce(iomap_ioend_from_bio(orig_bio), ioend);
>  
> +	if (iomap_has_csum(ioend))
> +		iomap_csum_free(ioend);
>  	bio_free_folios(&ioend->io_bio);
>  	if (bio_integrity(&ioend->io_bio))
>  		fs_bio_integrity_free(&ioend->io_bio);
> @@ -617,8 +680,14 @@ static int __init iomap_ioend_init(void)
>  			   BIOSET_NEED_BVECS);
>  	if (error)
>  		goto out_exit_ioend_bioset;
> +	error = mempool_init_page_pool(&ioend_csum_pool, BIO_POOL_SIZE,
> +			get_order(IOMAP_CSUM_MAX_SIZE));
> +	if (error)
> +		goto out_exit_ioend_split_bioset;
>  	return 0;
>  
> +out_exit_ioend_split_bioset:
> +	bioset_exit(&iomap_ioend_split_bioset);
>  out_exit_ioend_bioset:
>  	bioset_exit(&iomap_ioend_bioset);
>  	return error;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 59718f73c15a..e7db13ea0f70 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -133,6 +133,7 @@ struct iomap {
>  	u64			length;	/* length of mapping, bytes */
>  	u16			type;	/* type of mapping */
>  	u16			flags;	/* flags for mapping */
> +	u8			csum_shift; /* ilog() of csum size */
>  	struct block_device	*bdev;	/* block device for I/O */
>  	struct dax_device	*dax_dev; /* dax_dev for dax operations */
>  	void			*inline_data;
> @@ -489,6 +490,12 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
>  #else
>  #define IOMAP_IOEND_INTEGRITY		0
>  #endif /* CONFIG_BLK_DEV_INTEGRITY */
> +/* chained ioend that has io_parent */
> +#define IOMAP_IOEND_CHAINED		(1U << 6)
> +/* using io_csum_inline */
> +#define IOMAP_IOEND_CSUM_INLINE		(1U << 7)
> +/* io_csum is backed by a mempool */
> +#define IOMAP_IOEND_CSUM_MEMPOOL	(1U << 8)
>  
>  /*
>   * Flags that if set on either ioend prevent the merge of two ioends.
> @@ -522,14 +529,20 @@ static inline u16 iomap_ioend_flags(const struct iomap *iomap)
>  struct iomap_ioend {
>  	struct list_head	io_list;	/* next ioend in chain */
>  	u16			io_flags;	/* IOMAP_IOEND_* */
> +	u8			io_csum_shift;	/* ilog(2) of csum size */
>  	u32			io_bvec_offset;	/* offset into first bvec */
>  	struct inode		*io_inode;	/* file being written to */
>  	size_t			io_size;	/* size of the extent */
>  	atomic_t		io_remaining;	/* completetion defer count */
>  	int			io_error;	/* stashed away status */
> -	struct iomap_ioend	*io_parent;	/* parent for completions */
> +	union {
> +		struct iomap_ioend *io_parent;	/* parent for completions */
> +		void		*io_csum_alloc; /* original csum allocation. */
> +		u8		io_csum_inline[sizeof(void *)];
> +	};
>  	loff_t			io_offset;	/* offset in the file */
>  	sector_t		io_sector;	/* start sector of ioend */
> +	void			*io_csum;	/* data checksum */
>  	void			*io_private;	/* file system private data */
>  	struct fsverity_info	*io_vi;		/* fsverity info */
>  	struct bio		io_bio;		/* MUST BE LAST! */
> @@ -547,6 +560,22 @@ static inline struct iomap_ioend *iomap_ioend_from_bio(struct bio *bio)
>  	.bi_offset	= (_ioend)->io_bvec_offset,	\
>  }
>  
> +#define IOMAP_CSUM_MAX_SIZE	SZ_64K
> +
> +static inline bool iomap_has_csum(const struct iomap_ioend *ioend)
> +{
> +	return ioend->io_csum_shift > 0;
> +}
> +
> +static inline size_t iomap_csum_size(const struct iomap_ioend *ioend)
> +{
> +	return DIV_ROUND_UP(ioend->io_size, i_blocksize(ioend->io_inode)) <<
> +			ioend->io_csum_shift;
> +}
> +
> +void *iomap_csum_alloc(struct iomap_ioend *ioend, u8 csum_shift);
> +void iomap_csum_free(struct iomap_ioend *ioend);
> +
>  struct iomap_writeback_ops {
>  	/*
>  	 * Performs writeback on the passed in range
> -- 
> 2.53.0
> 
> 
