Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50051 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbeKQAFl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Nov 2018 19:05:41 -0500
Date: Fri, 16 Nov 2018 14:53:08 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V10 14/19] block: enable multipage bvecs
Message-ID: <20181116135308.GK3165@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com> <20181115085306.9910-15-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-15-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

> -
> -		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
> -			bv->bv_len += len;
> -			bio->bi_iter.bi_size += len;
> -			return true;
> -		}
> +		struct request_queue *q = NULL;
> +
> +		if (page == bv->bv_page && off == (bv->bv_offset + bv->bv_len)
> +				&& (off + len) <= PAGE_SIZE)

How could the page struct be the same, but the range beyond PAGE_SIZE
(at least with the existing callers)?

Also no need for the inner btraces, and the && always goes on the
first line.

> +		if (bio->bi_disk)
> +			q = bio->bi_disk->queue;
> +
> +		/* disable multi-page bvec too if cluster isn't enabled */
> +		if (!q || !blk_queue_cluster(q) ||
> +		    ((page_to_phys(bv->bv_page) + bv->bv_offset + bv->bv_len) !=
> +		     (page_to_phys(page) + off)))
> +			return false;
> + merge:
> +		bv->bv_len += len;
> +		bio->bi_iter.bi_size += len;
> +		return true;

Ok, this is scary, as it will give differen results depending on when
bi_disk is assigned.  But then again we shouldn't really do the cluster
check here, but rather when splitting the bio for the actual low-level
driver.

(and eventually we should kill this clustering setting off in favor
of our normal segment limits).
