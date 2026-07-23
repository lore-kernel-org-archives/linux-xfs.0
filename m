Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248383F482D;
	Thu, 23 Jul 2026 21:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784841009; cv=none; b=Y6py9SHH9IY2EOOHrePqwx3xZ2BAdiHMMroMh0Iypj0SXqcHfI4bsOyGbuR9I1cJ5eCvKX9VbxwMxXcQx7D1OVYgZu6VAo52s7itLR7fYKgJ4Ga/HXh12pdBdvhypaV2ou48EkSWyyM+n4piUQhgAXwWBbjXzfLJneHkMla/avQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784841009; c=relaxed/simple;
	bh=fIQBVZt1xuFstIEdkcZMMwBH2X98Qw1KXcpes1I2ppQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eoQR6g/khCUNnXCqJ3knj8mCxSfgby3ykYXbJ26MemEY/OIDKRhvpix/I7xL6x2CJ76batZRjJ1uyrivK93gDgqwzW3SQ0+d+ME/+GkARXMaBQpz8jWrDkQHstjRR5vMylMehurCXO7lYMIZdB9tESIFJjTQw64SV/FnH15WQjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U42nDfJO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U42nDfJO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 629931F000E9;
	Thu, 23 Jul 2026 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784841004;
	bh=hQKyzsXUpRVSua9SR3+AO1/yAKpGH8U45cJc7xiCvD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U42nDfJOXg6N4Kzo8xXpvpeYyKiikWl8Goe/NA7/snJjnunRD5/LahPgmcp6bPQz/
	 l4GrTff64foViQAz7SjWhXLMMc3GHzFPu3OU6vCWKqBVdrXrP9Pg8ikbCJw2ONPFJT
	 rURx5JckuqX9o2X1Th2VbvN1SVeyGGkaKANr7Ndog0OURJEyEUQhbO5PrdjDcJTpfe
	 Ro4qLGDdINDI1tYEurC1+atjhNFQnC99tIzPA2Ses9L/0To+4av1UXE9nWWJydmS4W
	 r52Gm9OP2ZaLJEOPPt3XL4l7zNgtxRxgH4mfgyxUvwzbNQjx87z/yFYDwF7GFRwezE
	 ejUxgM9xUSr4Q==
Date: Thu, 23 Jul 2026 14:10:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 12/22] iomap: better read bounce buffering support
Message-ID: <20260723211004.GM2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-13-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:37PM +0200, Christoph Hellwig wrote:
> Add helpers to bounce buffer an upper bio into one or more lower bios
> using bounce buffers, and to copy the data back on completion.
> 
> Compared to the existing IOMAP_DIO_BOUNCE support for read bios, this
> has two advantages:  by removing the special bounce bio_vec it allows
> to the full and "round" size of a single bio, i.e., 1MiB when using
> 4k pages.  This is important for good performance on HDD.  Additionally
> it allows to bounce buffer a bio from completion conext, and thus
> implement a "lazy" bounce buffering scheme, where the data is only
> read into a bounce buffer after an initial checksum validation failure,
> thus avoiding the bounce buffering I/O for most I/O.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Now that I can see how this is used ("xfs: add support for lazy direct
read bounce buffering") I think I'm ok with this.  Should there be some
Documentation/ about how to use PI with iomap?

In the mean time,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/ioend.c      | 87 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/iomap.h |  5 +++
>  2 files changed, 92 insertions(+)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index d43e6229900c..34f71c8b5ebd 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -515,6 +515,93 @@ struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
>  }
>  EXPORT_SYMBOL_GPL(iomap_split_ioend);
>  
> +void iomap_bounce_read(struct iomap_ioend *orig_ioend, unsigned int minsize,
> +		void (*submit_ioend)(struct iomap_ioend *ioend))
> +{
> +	struct inode *inode = orig_ioend->io_inode;
> +	struct bio *orig_bio = &orig_ioend->io_bio;
> +	loff_t file_offset = orig_ioend->io_offset;
> +	sector_t sector = orig_ioend->io_sector;
> +	size_t total_len = round_up(orig_ioend->io_size, minsize);
> +
> +	WARN_ON_ONCE(!(orig_ioend->io_flags & IOMAP_IOEND_DIRECT));
> +
> +	do {
> +		struct iomap_ioend *ioend;
> +		struct bio *bio;
> +		int error;
> +
> +		bio = bio_alloc_bioset(orig_bio->bi_bdev,
> +				min(total_len / minsize, BIO_MAX_VECS),
> +				orig_bio->bi_opf, GFP_KERNEL,
> +				&iomap_ioend_split_bioset);
> +		error = bio_alloc_bounce_folios(bio, total_len, minsize);
> +		if (error) {
> +			bio_put(bio);
> +			orig_bio->bi_status = errno_to_blk_status(error);
> +			break;
> +		}
> +		bio->bi_ioprio = orig_bio->bi_ioprio;
> +		bio->bi_write_hint = orig_bio->bi_write_hint;
> +		bio->bi_write_stream = orig_bio->bi_write_stream;
> +		bio->bi_iter.bi_sector = sector;
> +
> +		ioend = iomap_init_ioend(inode, bio, file_offset,
> +				orig_ioend->io_flags);
> +
> +		total_len -= bio->bi_iter.bi_size;
> +		file_offset += bio->bi_iter.bi_size;
> +		sector += (bio->bi_iter.bi_size >> SECTOR_SHIFT);
> +
> +		bio->bi_private = orig_bio;
> +		bio_inc_remaining(orig_bio);
> +		submit_ioend(ioend);
> +	} while (total_len > 0);
> +
> +	bio_endio(&orig_ioend->io_bio);
> +}
> +EXPORT_SYMBOL_GPL(iomap_bounce_read);
> +
> +static void iomap_ioend_unbounce(struct iomap_ioend *orig_ioend,
> +		struct iomap_ioend *ioend)
> +{
> +	struct bio *orig_bio = &orig_ioend->io_bio;
> +	struct iov_iter to;
> +	struct bio_vec *bv;
> +	int i;
> +
> +	iov_iter_bvec(&to, ITER_DEST, orig_bio->bi_io_vec, orig_bio->bi_vcnt,
> +			orig_ioend->io_size);
> +	to.iov_offset = orig_ioend->io_bvec_offset;
> +
> +	if (ioend->io_offset != orig_ioend->io_offset) {
> +		WARN_ON_ONCE(ioend->io_offset < orig_ioend->io_offset);
> +		iov_iter_advance(&to, ioend->io_offset - orig_ioend->io_offset);
> +	}
> +
> +	/* copying to pinned pages should always work */
> +	bio_for_each_bvec_all(bv, &ioend->io_bio, i)
> +		WARN_ON_ONCE(copy_to_iter(bvec_virt(bv), bv->bv_len, &to) !=
> +				bv->bv_len);
> +}
> +
> +void iomap_bounce_read_end_io(struct iomap_ioend *ioend, struct bio *orig_bio,
> +		int error)
> +{
> +	if (error)
> +		orig_bio->bi_status = errno_to_blk_status(error);
> +	else
> +		iomap_ioend_unbounce(iomap_ioend_from_bio(orig_bio), ioend);
> +
> +	bio_free_folios(&ioend->io_bio);
> +	if (bio_integrity(&ioend->io_bio))
> +		fs_bio_integrity_free(&ioend->io_bio);
> +	bio_put(&ioend->io_bio);
> +
> +	bio_endio(orig_bio);
> +}
> +EXPORT_SYMBOL_GPL(iomap_bounce_read_end_io);
> +
>  static int __init iomap_ioend_init(void)
>  {
>  	const unsigned int nr_mempool_entries = 4 * (PAGE_SIZE / SECTOR_SIZE);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index e7bee96379df..ff9afdd39682 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -509,6 +509,11 @@ void iomap_finish_folio_write(struct inode *inode, struct folio *folio,
>  int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio);
>  int iomap_writepages(struct iomap_writepage_ctx *wpc);
>  
> +void iomap_bounce_read(struct iomap_ioend *orig_ioend, unsigned int minsize,
> +		void (*submit_ioend)(struct iomap_ioend *ioend));
> +void iomap_bounce_read_end_io(struct iomap_ioend *ioend, struct bio *orig_bio,
> +		int error);
> +
>  struct iomap_read_folio_ctx {
>  	const struct iomap_read_ops *ops;
>  	struct folio		*cur_folio;
> -- 
> 2.53.0
> 
> 
