Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53080 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfDWGUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 02:20:35 -0400
Date: Mon, 22 Apr 2019 23:20:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] block: clarify that bio_add_page() and related
 helpers can add multi pages
Message-ID: <20190423062034.GB28518@infradead.org>
References: <20190422100207.13057-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190422100207.13057-1-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Mon, Apr 22, 2019 at 06:02:07PM +0800, Ming Lei wrote:
> bio_add_page() and __bio_add_page() are capable of adding pages into
> bio, and now we have at least two such usages alreay:
> 
> 	- __bio_iov_bvec_add_pages()
> 	- nvmet_bdev_execute_rw().
> 
> So update comments on these two helpers.
> 
> The thing is a bit special for __bio_try_merge_page(), given the caller
> needs to know if the new added page is same with the last added page,
> then it isn't safe to pass multi-page in case that 'same_page' is true,
> so adds warning on potential misuse, and updates comment on
> __bio_try_merge_page().
> 
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V2:
> 	- add Reviewed-by tag
> 	- rebase on latest for-5.2/block
> 
>  block/bio.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 5959141d4e46..e92c37ce20a6 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -688,6 +688,8 @@ static bool can_add_page_to_seg(struct request_queue *q,
>  	if (bv->bv_len + len > queue_max_segment_size(q))
>  		return false;
>  
> +	WARN_ON_ONCE(same_page && (len + off) > PAGE_SIZE);

No need for the inner braces.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
