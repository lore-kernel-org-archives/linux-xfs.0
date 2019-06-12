Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbfFLKS0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jun 2019 06:18:26 -0400
Date: Wed, 12 Jun 2019 18:18:11 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 4/5] block: fix page leak when merging to same page
Message-ID: <20190612101808.GC16000@ming.t460p>
References: <20190611151007.13625-1-hch@lst.de>
 <20190611151007.13625-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611151007.13625-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 05:10:06PM +0200, Christoph Hellwig wrote:
> When multiple iovecs reference the same page, each get_user_page call
> will add a reference to the page.  But once we've created the bio that
> information gets lost and only a single reference will be dropped after
> I/O completion.  Use the same_page information returned from
> __bio_try_merge_page to drop additional references to pages that were
> already present in the bio.
> 
> Based on a patch from Ming Lei.
> 
> Link: https://lkml.org/lkml/2019/4/23/64
> Fixes: 576ed913 ("block: use bio_add_page in bio_iov_iter_get_pages")
> Reported-by: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bio.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index c34327aa9216..0d841ba4373a 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -891,6 +891,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
>  	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
>  	struct page **pages = (struct page **)bv;
> +	bool same_page = false;
>  	ssize_t size, left;
>  	unsigned len, i;
>  	size_t offset;
> @@ -911,8 +912,15 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  		struct page *page = pages[i];
>  
>  		len = min_t(size_t, PAGE_SIZE - offset, left);
> -		if (WARN_ON_ONCE(bio_add_page(bio, page, len, offset) != len))
> -			return -EINVAL;
> +
> +		if (__bio_try_merge_page(bio, page, len, offset, &same_page)) {
> +			if (same_page)
> +				put_page(page);
> +		} else {
> +			if (WARN_ON_ONCE(bio_full(bio)))
> +                                return -EINVAL;
> +			__bio_add_page(bio, page, len, offset);
> +		}
>  		offset = 0;
>  	}

Looks fine for v5.2:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming
