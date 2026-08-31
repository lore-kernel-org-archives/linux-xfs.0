Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FE8446C00;
	Mon, 31 Aug 2026 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198744; cv=none; b=TeTx6ICkQu1uwPFC3AbwOpuqpZVLQT779qcYcQrrkY+8ReTyHVg/lIveVkVCUf5UYKEvafMi2U1SktuD/v0Y9sYzJ6apiNOxJWyhtk5mcHJesZapj2CW/DPxquFvN//aItxdx4faFi/vJK5kZPuWyPslXrD532t2+TAdN8NwjOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198744; c=relaxed/simple;
	bh=+hZDxDd2VLw9USpGO3cfvT/AUgNzkGgwwYV49V4yBGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rMgxGVH/luGx3Z/9hY04nu2IjqS5fBM0/bDnaLXR1T5a0y7/thXKPcRWlsDv9fVqaaCJNgyiVYTwyQvZZHkdedhNxgs78o4XNrObWRR9r0zVpxWocpQbluIdnxORU6sSTMjA2s672HIeLba/nsL3ymqZkqiZjA9kR7qvUlgFOdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VajpOdM3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VajpOdM3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A9E311F00A3D;
	Mon, 31 Aug 2026 17:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788198742;
	bh=cLLYK4sEOKImB1LU0dAovEiHwphslOSQpi7U/F5AWeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VajpOdM3btkh5cMUsuVlvC1pYfe8rlagIJByItlLrj8aqC2558RzdbEtT2cqxz81A
	 VsceIywGP7PiBsRbuW1O4hd1hOlzXEgAG1u+IaSf/gIsTwSSwldaGBM3C+b0a9EJWb
	 ABlL4i25j3p2SKBCusN7g+Y93gGORYFQ0sb/2YZd1cxsPezl6qy0HIbMZTKysBC8YN
	 1HRW0+dDKZMK8SfgefqlP1g7EkHEtcg9J6y07b4FBnUVidZbwOehuUZyz48dAD0OEP
	 CtdnKWNWeRTTpGep2XB1V8/QateD2d0H/4hCd9L3yxQT+aDZ5m4q8uWM/X+3kG6xkf
	 EPIXh5kOw4PJw==
Date: Mon, 31 Aug 2026 10:52:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/17] block,iomap: fix protection information
 verification with initial bvec offset
Message-ID: <20260831175222.GD1933798@frogsfrogsfrogs>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064010.2574896-11-hch@lst.de>

On Mon, Aug 31, 2026 at 09:39:58AM +0300, Christoph Hellwig wrote:
> When reconstructing a bvec_iter from an ioend for protection information
> verification, iomap currently ignores the offset into the initial
> bio_vec.
> 
> This can't happen for buffered I/O an direct I/O to user addresses, but

"...buffered I/O or a direct I/O..." ?

> is exercised by split on O_DIRECT file descriptors or when using the loop
> driver.
> 
> Fortunately the only file system PI user (XFS) currently always bounce
> buffers, so this can't actually be triggered yet.  But we'll want to make
> the bounce buffering conditional soon, for which this needs to be fixed.
> 
> Store the initial offset in struct iomap_ioend, and pass a
> pre-constructed bvec_iter to fs_bio_integrity_verify.  For the
> synchronous read case the fix is even simpler as this path can
> simply stash away the original bvec_iter.
> 
> Fixes: 0bde8a12b554 ("block: add fs_bio_integrity helpers")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With that fixed, this seems reasonable to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  block/bio-integrity-fs.c      | 13 +++++--------
>  fs/iomap/bio.c                |  4 +++-
>  fs/iomap/ioend.c              | 14 ++++++++++----
>  include/linux/bio-integrity.h |  3 +--
>  include/linux/iomap.h         |  8 ++++++++
>  5 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
> index 4f67b34bf289..c8e91ada8ca6 100644
> --- a/block/bio-integrity-fs.c
> +++ b/block/bio-integrity-fs.c
> @@ -54,14 +54,10 @@ void fs_bio_integrity_generate(struct bio *bio)
>  }
>  EXPORT_SYMBOL_GPL(fs_bio_integrity_generate);
>  
> -int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
> +int fs_bio_integrity_verify(struct bio *bio, struct bvec_iter *data_iter)
>  {
>  	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
>  	struct bio_integrity_payload *bip = bio_integrity(bio);
> -	struct bvec_iter data_iter = {
> -		.bi_sector	= sector,
> -		.bi_size	= size,
> -	};
>  
>  	if (!bip || !(bip->bip_flags & BIP_CHECK_FLAGS))
>  		return 0;
> @@ -73,9 +69,10 @@ int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
>  	 * bio.  Requires the submitter to remember the sector and the size.
>  	 */
>  	memset(&bip->bip_iter, 0, sizeof(bip->bip_iter));
> -	bip->bip_iter.bi_sector = sector;
> -	bip->bip_iter.bi_size = bio_integrity_bytes(bi, size >> SECTOR_SHIFT);
> -	return blk_status_to_errno(bio_integrity_verify(bio, &data_iter));
> +	bip->bip_iter.bi_sector = data_iter->bi_sector;
> +	bip->bip_iter.bi_size =
> +		bio_integrity_bytes(bi, data_iter->bi_size >> SECTOR_SHIFT);
> +	return blk_status_to_errno(bio_integrity_verify(bio, data_iter));
>  }
>  
>  static int __init fs_bio_integrity_init(void)
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index 48100c614431..d46c2f8ea18c 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -169,6 +169,7 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
>  {
>  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
>  	sector_t sector = iomap_sector(srcmap, pos);
> +	struct bvec_iter saved_iter;
>  	struct bio_vec bvec;
>  	struct bio bio;
>  	int error;
> @@ -178,10 +179,11 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
>  	bio_add_folio_nofail(&bio, folio, len, offset_in_folio(folio, pos));
>  	if (srcmap->flags & IOMAP_F_INTEGRITY)
>  		fs_bio_integrity_alloc(&bio);
> +	saved_iter = bio.bi_iter;
>  	error = submit_bio_wait(&bio);
>  	if (bio_integrity(&bio)) {
>  		if (!error)
> -			error = fs_bio_integrity_verify(&bio, sector, len);
> +			error = fs_bio_integrity_verify(&bio, &saved_iter);
>  		fs_bio_integrity_free(&bio);
>  	}
>  	bio_uninit(&bio);
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index 573fa89c1632..332dbfb2230f 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -25,6 +25,7 @@ struct iomap_ioend *iomap_init_ioend(struct inode *inode,
>  	ioend->io_parent = NULL;
>  	INIT_LIST_HEAD(&ioend->io_list);
>  	ioend->io_flags = ioend_flags;
> +	ioend->io_bvec_offset = bio->bi_iter.bi_offset;
>  	ioend->io_inode = inode;
>  	ioend->io_offset = file_offset;
>  	ioend->io_size = bio->bi_iter.bi_size;
> @@ -308,6 +309,13 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>  }
>  EXPORT_SYMBOL_GPL(iomap_add_to_ioend);
>  
> +static int iomap_ioend_integrity_verify(struct iomap_ioend *ioend)
> +{
> +	struct bvec_iter data_iter = BVEC_ITER_IOEND(ioend);
> +
> +	return fs_bio_integrity_verify(&ioend->io_bio, &data_iter);
> +}
> +
>  static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
>  {
>  	if (ioend->io_parent) {
> @@ -325,10 +333,8 @@ static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
>  
>  	if (!ioend->io_error &&
>  	    bio_integrity(&ioend->io_bio) &&
> -	    bio_op(&ioend->io_bio) == REQ_OP_READ) {
> -		ioend->io_error = fs_bio_integrity_verify(&ioend->io_bio,
> -			ioend->io_sector, ioend->io_size);
> -	}
> +	    bio_op(&ioend->io_bio) == REQ_OP_READ)
> +		ioend->io_error = iomap_ioend_integrity_verify(ioend);
>  
>  	if (ioend->io_flags & IOMAP_IOEND_DIRECT)
>  		return iomap_finish_ioend_direct(ioend);
> diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
> index 0ea2a8bf7efb..a954c97be0b3 100644
> --- a/include/linux/bio-integrity.h
> +++ b/include/linux/bio-integrity.h
> @@ -151,7 +151,6 @@ void bio_integrity_setup_default(struct bio *bio);
>  unsigned int fs_bio_integrity_alloc(struct bio *bio);
>  void fs_bio_integrity_free(struct bio *bio);
>  void fs_bio_integrity_generate(struct bio *bio);
> -int fs_bio_integrity_verify(struct bio *bio, sector_t sector,
> -		unsigned int size);
> +int fs_bio_integrity_verify(struct bio *bio, struct bvec_iter *data_iter);
>  
>  #endif /* _LINUX_BIO_INTEGRITY_H */
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 1cc9a35fd5cc..bffdc217ad85 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -522,6 +522,7 @@ static inline u16 iomap_ioend_flags(const struct iomap *iomap)
>  struct iomap_ioend {
>  	struct list_head	io_list;	/* next ioend in chain */
>  	u16			io_flags;	/* IOMAP_IOEND_* */
> +	u32			io_bvec_offset;	/* offset into first bvec */
>  	struct inode		*io_inode;	/* file being written to */
>  	size_t			io_size;	/* size of the extent */
>  	atomic_t		io_remaining;	/* completetion defer count */
> @@ -539,6 +540,13 @@ static inline struct iomap_ioend *iomap_ioend_from_bio(struct bio *bio)
>  	return container_of(bio, struct iomap_ioend, io_bio);
>  }
>  
> +#define BVEC_ITER_IOEND(_ioend)				\
> +{							\
> +	.bi_sector	= (_ioend)->io_sector,		\
> +	.bi_size	= (_ioend)->io_size,		\
> +	.bi_offset	= (_ioend)->io_bvec_offset,	\
> +}
> +
>  struct iomap_writeback_ops {
>  	/*
>  	 * Performs writeback on the passed in range
> -- 
> 2.53.0
> 
> 
