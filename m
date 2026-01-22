Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5564D328243;
	Thu, 22 Jan 2026 17:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769104749; cv=none; b=M5i4QofPIt/oJ44R55CCBsVp0y7DV01r1GQWHM2MHaWul0C3r3s3t4/wihWdze60yFP9cbpAkADjNaRLHgdyXQai241yeZHp7KOaHyHtQf94ieLY+/s2JjLanJPG2b0TcrvRxWDMSSnjUwcWTe+0G0AJm6tOp/voQ8Gc6xM0gbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769104749; c=relaxed/simple;
	bh=hupmG1zghepUio3YBCHAt3r28DiARpe2V9FePvpsTqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KKLgpctaBmp7vnVmusTW7aWx1uOoQoqPhuJR8Kwu8rBSlKyDDpw1/nQg995lhrj8Zs/y2M0Efr8IWNWqRfM3VyTXElDrd6DeL2quLbqPdaGIxqYgyAyYWNw/7JWZZ54otPnHbOAbe0Yyf44hYVme3qGuA65gv8NIj5iAxFFmIQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SoVIDDfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SoVIDDfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13A2C116C6;
	Thu, 22 Jan 2026 17:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769104748;
	bh=hupmG1zghepUio3YBCHAt3r28DiARpe2V9FePvpsTqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SoVIDDfP2wUPgrkT5linwbcos9ohbtMotYWPEC1rFob3XW2rvOdE0L1m7lKJSMNJR
	 XjWdkf1OhKLgidgYbiLXJXRFK2WMMtKFcwVcASuPmkUZ4EwckxwIxgZe66wZRIdSaz
	 qpRfBevbedgXI14HccxzVwz/s+BFl3CmvoL7IvdZJJyhhcW2un2bSVaGkOJt36z26t
	 s2DZ2SlfOk7oPV78oEReu2c+dy/PkyWboUHW6OOAg3yATNODtQfHIVPOZ6r6++AerQ
	 ps93RByDcinY9z1h3/MK7pLOiayFjPV6O4iv3sSjOrBI3myjMPHUXE8Sn3HmeXSpug
	 L0PJCSDgfSTNw==
Date: Thu, 22 Jan 2026 09:59:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/14] block: open code bio_add_page and fix handling of
 mismatching P2P ranges
Message-ID: <20260122175908.GZ5945@frogsfrogsfrogs>
References: <20260119074425.4005867-1-hch@lst.de>
 <20260119074425.4005867-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119074425.4005867-3-hch@lst.de>

On Mon, Jan 19, 2026 at 08:44:09AM +0100, Christoph Hellwig wrote:
> bio_add_page fails to add data to the bio when mixing P2P with non-P2P
> ranges, or ranges that map to different P2P providers.  In that case
> it will trigger that WARN_ON and return an error up the chain instead of
> simply starting a new bio as intended.  Fix this by open coding

AFAICT we've already done all the other checks in bio_add_page, so
calling __bio_add_page directly from within the loop is ok since you've
explicitly handled the !zone_device_pages_have_same_pgmap() case.

> bio_add_page and handling this case explicitly.  While doing so, stop
> merging physical contiguous data that belongs to multiple folios.  While
> this merge could lead to more efficient bio packing in some case,
> dropping will allow to remove handling of this corner case in other
> places and make the code more robust.

That does sound like a landmine waiting to go off...

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  block/bio.c | 37 +++++++++++++------------------------
>  1 file changed, 13 insertions(+), 24 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 18dfdaba0c73..46ff33f4de04 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1216,7 +1216,7 @@ static unsigned int get_contig_folio_len(struct page **pages,
>   * For a multi-segment *iter, this function only adds pages from the next
>   * non-empty segment of the iov iterator.
>   */
> -static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
> +static ssize_t __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  {
>  	iov_iter_extraction_t extraction_flags = 0;
>  	unsigned short nr_pages = bio->bi_max_vecs - bio->bi_vcnt;
> @@ -1226,7 +1226,6 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  	ssize_t size;
>  	unsigned int i = 0;
>  	size_t offset, left, len;
> -	int ret = 0;
>  
>  	/*
>  	 * Move page array up in the allocated memory for the bio vecs as far as
> @@ -1247,37 +1246,26 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  
>  	nr_pages = DIV_ROUND_UP(offset + size, PAGE_SIZE);
>  	for (left = size; left > 0; left -= len) {
> -		unsigned int old_vcnt = bio->bi_vcnt;
>  		unsigned int nr_to_add;
>  
> -		len = get_contig_folio_len(&pages[i], &nr_to_add, left, offset);
> -		if (!bio_add_page(bio, pages[i], len, offset)) {
> -			WARN_ON_ONCE(1);
> -			ret = -EINVAL;
> -			goto out;
> -		}
> +		if (bio->bi_vcnt > 0) {
> +			struct bio_vec *prev = &bio->bi_io_vec[bio->bi_vcnt - 1];
>  
> -		if (bio_flagged(bio, BIO_PAGE_PINNED)) {
> -			/*
> -			 * We're adding another fragment of a page that already
> -			 * was part of the last segment.  Undo our pin as the
> -			 * page was pinned when an earlier fragment of it was
> -			 * added to the bio and __bio_release_pages expects a
> -			 * single pin per page.
> -			 */
> -			if (offset && bio->bi_vcnt == old_vcnt)
> -				unpin_user_folio(page_folio(pages[i]), 1);
> +			if (!zone_device_pages_have_same_pgmap(prev->bv_page,
> +					pages[i]))
> +				break;
>  		}
> +
> +		len = get_contig_folio_len(&pages[i], &nr_to_add, left, offset);
> +		__bio_add_page(bio, pages[i], len, offset);
>  		i += nr_to_add;
>  		offset = 0;
>  	}
>  
>  	iov_iter_revert(iter, left);
> -out:
>  	while (i < nr_pages)
>  		bio_release_page(bio, pages[i++]);
> -
> -	return ret;
> +	return size - left;
>  }
>  
>  /*
> @@ -1337,7 +1325,7 @@ static int bio_iov_iter_align_down(struct bio *bio, struct iov_iter *iter,
>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
>  			   unsigned len_align_mask)
>  {
> -	int ret = 0;
> +	ssize_t ret;
>  
>  	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>  		return -EIO;
> @@ -1350,9 +1338,10 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
>  
>  	if (iov_iter_extract_will_pin(iter))
>  		bio_set_flag(bio, BIO_PAGE_PINNED);
> +
>  	do {
>  		ret = __bio_iov_iter_get_pages(bio, iter);
> -	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
> +	} while (ret > 0 && iov_iter_count(iter) && !bio_full(bio, 0));
>  
>  	if (bio->bi_vcnt)
>  		return bio_iov_iter_align_down(bio, iter, len_align_mask);
> -- 
> 2.47.3
> 
> 
