Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47731 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751992AbdDLIgZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 04:36:25 -0400
Date: Wed, 12 Apr 2017 01:36:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] nowait aio: return on congested block device
Message-ID: <20170412083625.GB22363@infradead.org>
References: <20170411142619.27205-1-rgoldwyn@suse.de>
 <20170411142619.27205-6-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170411142619.27205-6-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

As mentioned last time around, this should be a REQ_NOWAIT flag so
that it can be easily passed down to the request layer.

> +static inline void bio_wouldblock_error(struct bio *bio)
> +{
> +	bio->bi_error = -EAGAIN;
> +	bio_endio(bio);
> +}

Please skip this helper..

> +#define QUEUE_FLAG_NOWAIT      28	/* queue supports BIO_NOWAIT */

Please make the flag name a little more descriptive, this sounds like
it will never wait.
