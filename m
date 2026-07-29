Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4D344160F
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 09:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318774; cv=none; b=rXuPYXSQG3hdRbZcgwoaUwEOSATf5ui5AeU/Zxq4l8/zKIgGTqI0Y0DH13D29+v6zdhr+54AS3t27pdCHInCGLFVKMmKy+M2u2o1YuDjGDIe1hxWFo7OZGX/oZD9kebRE/hw2/zrh/gFrLIYaStfLrlvh5kYCotKF2wn5ZsIjcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318774; c=relaxed/simple;
	bh=npoQEiDvN1yxH7BsBNSL0UIpLQBvzsgp7LVJ168Zdig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XyO2SBYnbkhEjr2EjkYhaz5qGKOpuDiUMme3s/9hg3+OAxiVfZuTGQ++igE5eQBq63EPjnKB7rlEpD9xKJQ4VRXp4pvxWiLXo1SSNOt4h/7xZw0yIpwdSWsiFrJQpXT6E5zZSQm+hrP9i765c26okkckeMLTV9QHduBgXA5IGNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wznb2WZc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OQqBU48v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wznb2WZc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OQqBU48v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785318771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IMtixXml2fd5ko/LMxKKst4tpZQdQmsUb4+nyDRXP5s=;
	b=Wznb2WZc5JKMpwZ4jIdR/2OtwIUOl70x9qENVwNwW1V18zZ6qQjHuYz7Dx0HEk0EdCCI5v
	oLwIDqgwr/UQivma2k5TWysuv6jFScxfGXPHZ/4XHmJiM5f1Lx+GpNA1/jsbvvjbRBEZGU
	nJky3E/GcXxv9TAELnn9IjuCHPs4fAA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-Tf88oWnaN361WxVLe9fuJA-1; Wed, 29 Jul 2026 05:52:49 -0400
X-MC-Unique: Tf88oWnaN361WxVLe9fuJA-1
X-Mimecast-MFC-AGG-ID: Tf88oWnaN361WxVLe9fuJA_1785318768
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f8158485eso667238f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 02:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785318768; x=1785923568; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IMtixXml2fd5ko/LMxKKst4tpZQdQmsUb4+nyDRXP5s=;
        b=OQqBU48vEentkiII+pi+dE9cttvh79Std+RmKv+C7icrMLs4qfqaaabp8KhGpXnP2i
         zp3n+9aQIwZmdA+iq8ihLg939goND5Y/ZLDxE7RNSXsk73vsSKQUBOfsSungu8chdRB8
         cMOCnhh4c3o8YdSfFxQ6/TzKspq2rYrPg5VTxJRnoXJsjuXnEG0AU+WwBfV0cg68NbB/
         d42TCvCWoyx0hj0cVlxNC2AgC4BU/xHvnmvG/WVbgaiCJiYZYAaeI6/5Jm1kflSzLIzd
         WASIXhBhWlI0P3MNaHU/C3ZigLYmSY+qNMHwGCKk5BeKfvm2IITuAQkiQ4pl4X95C3b8
         Lmqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785318768; x=1785923568;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IMtixXml2fd5ko/LMxKKst4tpZQdQmsUb4+nyDRXP5s=;
        b=aR2FNtVpvkFOtrBFhjMbWxjNfKwZ0dNti8JLUKCOalRQ/1xbIKwcrgIr63rt160GJm
         TXo1+Yqqo8H2Aqm+QsR86SuoPvE1fHxMv14si0YeHew3g0Gv7FtG2vT1Ak71eKcccy1n
         RR3ZWH6T9PyneGamy/vGNqIz4MvV4YIOhBTHnMHkvuvW2pns9kLjRtxXjqmnWnFymljs
         NzuMfTFKyciWk1toyxGIz919m7qFvNflrxi9e5K909/IfmmFYEXKXUr0J26ypxCqV6bz
         ldy1fY9/9tVht4J55jHeBSdjKhQsDESM87EkEpIGxt1EBPTLrJc2Z2D6Vdo2dE14ngxD
         ELGQ==
X-Forwarded-Encrypted: i=1; AHgh+RpXe9NdOjpcrlOCXt41uTM/uinwdtIzUXsi6y9xVKyv802tHuX8+M/v0ljrRYTuU6PKClCCj1Te5nM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwchXDmwuX1Af1H1ypw6BT3qW2kdctpGQh4nWWGBOC6lzWtazy7
	KvXX6XlX1lA49SEV5s5kD9QnYfurIUO0fd5x2CBILst6AgpSk3Z7o87zN7Jg9PnAGLoMr6STZhN
	8aasaar4ReNhhO1kc4uGBWm4iEj2/m5h0jIBxrzfFOI7t4fvL1htXgCJG4Nvt
X-Gm-Gg: AR+sD13aqEmHUXFFW0fC6513hRFcqGvVarxRqAJJgx28C5iq6KdAFd7Epd10E2i9eqG
	X9sVaugvNWptBuYiCeDlIDm95Lx/o+Htc+KCC6/9UsSCb8rvCtlB6uGIO87Veq7kUkalV9fmsYl
	aoNGjiMiH+hTWVKei5ngXF7kuzV5YE/2A90w4hDW5TeZ6+mSuZCj/cEVl2jHlKdNqCu8Cj/2EOi
	WMehdwg2i9HXHebHE98/jxK0s819udItUEoeTx9KZykjhYEUYeZfBuafzlm+RsmTOh3hZ1PdsQ5
	2dky4t5485auAtTCO1dwqVImJkDC3YVVR3wvLF2KAjSQTa4ZfZugUsS74STxydlq4ol81sWF14L
	iPExStxsAzvLhXo2sye56AU7r47AsbM2q57o=
X-Received: by 2002:a05:6000:5c2:b0:47f:7aee:ed3c with SMTP id ffacd0b85a97d-47fb1ec81eamr8509546f8f.5.1785318768188;
        Wed, 29 Jul 2026 02:52:48 -0700 (PDT)
X-Received: by 2002:a05:6000:5c2:b0:47f:7aee:ed3c with SMTP id ffacd0b85a97d-47fb1ec81eamr8509465f8f.5.1785318767507;
        Wed, 29 Jul 2026 02:52:47 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b1cf09sm6907867f8f.31.2026.07.29.02.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 02:52:47 -0700 (PDT)
Date: Wed, 29 Jul 2026 11:52:46 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Tal Zussman <tz2294@columbia.edu>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/22] block,iomap: fix protection information
 verification with initial bvec offset
Message-ID: <amnJ0rFnXTcfmcVJ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-7-hch@lst.de>

On 2026-07-23 16:49:31, Christoph Hellwig wrote:
> When reconstructing a bvec_iter from an ioend for protection information
> verification, iomap currently ignores the offset into the initial
> bio_vec.
> 
> This can't happen for buffered I/O an direct I/O to user addresses, but
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
> ---
>  block/bio-integrity-fs.c      | 13 +++++--------
>  fs/iomap/bio.c                |  4 +++-
>  fs/iomap/ioend.c              | 14 ++++++++++----
>  include/linux/bio-integrity.h |  3 +--
>  include/linux/iomap.h         |  8 ++++++++
>  5 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
> index 692403dfa047..dd6c85530913 100644
> --- a/block/bio-integrity-fs.c
> +++ b/block/bio-integrity-fs.c
> @@ -52,14 +52,10 @@ void fs_bio_integrity_generate(struct bio *bio)
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
> @@ -71,9 +67,10 @@ int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
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
> index 30ef78a66b4f..813002b2299d 100644
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
>  	return error;
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index 2ec755a89228..d43e6229900c 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -25,6 +25,7 @@ struct iomap_ioend *iomap_init_ioend(struct inode *inode,
>  	ioend->io_parent = NULL;
>  	INIT_LIST_HEAD(&ioend->io_list);
>  	ioend->io_flags = ioend_flags;
> +	ioend->io_bvec_offset = bio->bi_iter.bi_bvec_done;
>  	ioend->io_inode = inode;
>  	ioend->io_offset = file_offset;
>  	ioend->io_size = bio->bi_iter.bi_size;
> @@ -311,6 +312,13 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
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
> @@ -328,10 +336,8 @@ static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
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

shouldn't this have a static inline stub if BLK_DEV_INTEGRITY=no?
linker fails to resolve this in ioend.c

not sure why _generate and rest are apparently fine

-- 
- Andrey

