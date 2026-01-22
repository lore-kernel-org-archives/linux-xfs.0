Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB8738758D;
	Thu, 22 Jan 2026 17:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102783; cv=none; b=glcKK/C6uoFUWoDxub3icwsSC9B/mTBpbezBCqXV1M86g0/vDFAxEMzgS3L2bg43IR/00rhX5Xga2oJzvtCrDojQwzIIdXKMPaOOhgJAOjInCoY54pW9h1AoOXTJx+n8gvB4t097btvs0NZLsLoV6WMuNGUHUgnzkpKtm1f2Mk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102783; c=relaxed/simple;
	bh=+uprx3K11EFrSbxk+wVY/WJnH/k03EUP11gqmh7JhEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k79RejFsJ2DoWOg8P4QiVVoNinWmi7fbNIjbZrkwlFtcdlW8FnGwvQdJnddTBqfckgrtuQ2gvPpWtwjoWzm8ChIngcxob0/xFPIvzNN8BtLTIg78JxoNMPv2kvNsuArw1YLxuIodbHHfhR4imMKUEoJnF0HyvhCWq1Z0zUoG1OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdpNxxwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdpNxxwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA28C116C6;
	Thu, 22 Jan 2026 17:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769102780;
	bh=+uprx3K11EFrSbxk+wVY/WJnH/k03EUP11gqmh7JhEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gdpNxxwYXwtPCmE21HJ5h7uyAT0nq72KYG/ooW2ub/SjnlFs8yxUvKWWl0gqnLSrY
	 S9C4lpcRJsj/ZvFkGC+RN/xFkTG0Zwxi4+FSgGFXRlO0vyEhfycWwi9ni5n7v8k7Lg
	 PXojlwy/WGUxvlW5qCl37awdjU5SSS6G7HbyDvfGVZFGV6Al7yXmRpObMd+vNVZxvE
	 HbOdyIAf4+joTy+FCg5ikTPJo1duBaOm9/9Es/59/u+T/F9+59tMkLFo+BSZkmjfZx
	 bGv2XokV6UE6tH6wL/CrazpDCBqCROf43eTSYNLHJGIpwBQC/udApAmw4n3uaNVfbP
	 dZYzLnDwf1ePw==
Date: Thu, 22 Jan 2026 09:26:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/14] block: remove bio_release_page
Message-ID: <20260122172620.GW5945@frogsfrogsfrogs>
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119074425.4005867-5-hch@lst.de>

On Mon, Jan 19, 2026 at 08:44:11AM +0100, Christoph Hellwig wrote:
> Merge bio_release_page into the only remaining caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  block/bio.c |  4 +++-
>  block/blk.h | 11 -----------
>  2 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 12cd3c5f6d6d..c51b4e2470e2 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1195,7 +1195,9 @@ static int bio_iov_iter_align_down(struct bio *bio, struct iov_iter *iter,
>  			break;
>  		}
>  
> -		bio_release_page(bio, bv->bv_page);
> +		if (bio_flagged(bio, BIO_PAGE_PINNED))
> +			unpin_user_page(bv->bv_page);
> +
>  		bio->bi_vcnt--;
>  		nbytes -= bv->bv_len;
>  	} while (nbytes);
> diff --git a/block/blk.h b/block/blk.h
> index 980eef1f5690..886238cae5f1 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -595,17 +595,6 @@ void bdev_set_nr_sectors(struct block_device *bdev, sector_t sectors);
>  
>  struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
>  		struct lock_class_key *lkclass);
> -
> -/*
> - * Clean up a page appropriately, where the page may be pinned, may have a
> - * ref taken on it or neither.
> - */
> -static inline void bio_release_page(struct bio *bio, struct page *page)
> -{
> -	if (bio_flagged(bio, BIO_PAGE_PINNED))
> -		unpin_user_page(page);
> -}
> -
>  struct request_queue *blk_alloc_queue(struct queue_limits *lim, int node_id);
>  
>  int disk_scan_partitions(struct gendisk *disk, blk_mode_t mode);
> -- 
> 2.47.3
> 
> 
