Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47947 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbdBAHmx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2017 02:42:53 -0500
Date: Tue, 31 Jan 2017 23:42:49 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] error propagation problem on xfs over dm stripe
Message-ID: <20170201074249.GA22669@infradead.org>
References: <b44b5dc2-eac0-cd40-6de8-b615cb4dece8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b44b5dc2-eac0-cd40-6de8-b615cb4dece8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>

On Tue, Jan 31, 2017 at 09:12:07PM -0600, Eric Sandeen wrote:
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3086da5..3555ba8 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -808,7 +808,9 @@ static void dec_pending(struct dm_io *io, int error)
>  		} else {
>  			/* done with normal IO or empty flush */
>  			trace_block_bio_complete(md->queue, bio, io_error);
> -			bio->bi_error = io_error;
> +			/* don't overwrite or clear existing errors */
> +			if (!bio->bi_error)
> +				bio->bi_error = io_error;
>  			bio_endio(bio);
>  		}
>  	}
> 
> but Mike was a little uneasy, not knowing for sure how we got here to
> overwrite this bio's error (hopefully I'm representing his concerns
> fairly and correctly).

FYI, what we do both in the XFS buffer cache and the new direct I/O
code is to use a

	        cmpxchg(&dio->error, 0, ret);

in a similar situation, which should work here, too.
