Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51393 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbeKVAHL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Nov 2018 19:07:11 -0500
Date: Wed, 21 Nov 2018 14:32:44 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V11 03/19] block: introduce bio_for_each_bvec()
Message-ID: <20181121133244.GB1640@lst.de>
References: <20181121032327.8434-1-ming.lei@redhat.com> <20181121032327.8434-4-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121032327.8434-4-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

> +#define bio_iter_mp_iovec(bio, iter)				\
> +	segment_iter_bvec((bio)->bi_io_vec, (iter))

Besides the mp naming we'd like to get rid off there also is just
a single user of this macro, please just expand it there.

> +#define segment_iter_bvec(bvec, iter)				\
> +((struct bio_vec) {							\
> +	.bv_page	= segment_iter_page((bvec), (iter)),	\
> +	.bv_len		= segment_iter_len((bvec), (iter)),	\
> +	.bv_offset	= segment_iter_offset((bvec), (iter)),	\
> +})

And for this one please keep the segment vs bvec versions of these
macros close together in the file please, right now it follow the
bvec_iter_bvec variant closely.

> +static inline void __bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
> +				      unsigned bytes, unsigned max_seg_len)
>  {
>  	iter->bi_sector += bytes >> 9;
>  
>  	if (bio_no_advance_iter(bio))
>  		iter->bi_size -= bytes;
>  	else
> -		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
> +		__bvec_iter_advance(bio->bi_io_vec, iter, bytes, max_seg_len);
>  		/* TODO: It is reasonable to complete bio with error here. */
>  }
>  
> +static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
> +				    unsigned bytes)
> +{
> +	__bio_advance_iter(bio, iter, bytes, PAGE_SIZE);
> +}

Btw, I think the remaining users of bio_advance_iter() in bio.h
should probably switch to using __bio_advance_iter to make them a little
more clear to read.

> +/* returns one real segment(multi-page bvec) each time */

space before the brace, please.

> +#define BVEC_MAX_LEN  ((unsigned int)-1)

>  	while (bytes) {
> +		unsigned segment_len = segment_iter_len(bv, *iter);
>  
> -		iter->bi_bvec_done += len;
> +		if (max_seg_len < BVEC_MAX_LEN)
> +			segment_len = min_t(unsigned, segment_len,
> +					    max_seg_len -
> +					    bvec_iter_offset(bv, *iter));
> +
> +		segment_len = min(bytes, segment_len);

Please stick to passing the magic zero here as can often generate more
efficient code.

Talking about efficent code - I wonder how much code size we'd save
by moving this function out of line..

But while looking over this I wonder why we even need the max_seg_len
here.  The only thing __bvec_iter_advance does it to move bi_bvec_done
and bi_idx forward, with corresponding decrements of bi_size.  As far
as I can tell the only thing that max_seg_len does is that we need
to more iterations of the while loop to archive the same thing.

And actual bvec used by the caller will be obtained using
bvec_iter_bvec or segment_iter_bvec depending on if they want multi-page
or single-page variants.
