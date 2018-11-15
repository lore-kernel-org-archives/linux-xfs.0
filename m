Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41091 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbeKPJdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 04:33:55 -0500
Received: by mail-pg1-f194.google.com with SMTP id 70so9697301pgh.8
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 15:24:00 -0800 (PST)
Date: Thu, 15 Nov 2018 15:23:56 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V10 05/19] block: introduce bvec_last_segment()
Message-ID: <20181115232356.GA23238@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-6-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-6-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Thu, Nov 15, 2018 at 04:52:52PM +0800, Ming Lei wrote:
> BTRFS and guard_bio_eod() need to get the last singlepage segment
> from one multipage bvec, so introduce this helper to make them happy.
> 
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: linux-erofs@lists.ozlabs.org
> Cc: David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org
> Cc: Gao Xiang <gaoxiang25@huawei.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Cc: Coly Li <colyli@suse.de>
> Cc: linux-bcache@vger.kernel.org
> Cc: Boaz Harrosh <ooo@electrozaur.com>
> Cc: Bob Peterson <rpeterso@redhat.com>
> Cc: cluster-devel@redhat.com

Reviewed-by: Omar Sandoval <osandov@fb.com>

Minor comments below.

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/bvec.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index 3d61352cd8cf..01616a0b6220 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -216,4 +216,29 @@ static inline bool mp_bvec_iter_advance(const struct bio_vec *bv,
>  	.bi_bvec_done	= 0,						\
>  }
>  
> +/*
> + * Get the last singlepage segment from the multipage bvec and store it
> + * in @seg
> + */
> +static inline void bvec_last_segment(const struct bio_vec *bvec,
> +		struct bio_vec *seg)

Indentation is all messed up here.

> +{
> +	unsigned total = bvec->bv_offset + bvec->bv_len;
> +	unsigned last_page = total / PAGE_SIZE;
> +
> +	if (last_page * PAGE_SIZE == total)
> +		last_page--;

I think this could just be

	unsigned int last_page = (total - 1) / PAGE_SIZE;

> +	seg->bv_page = nth_page(bvec->bv_page, last_page);
> +
> +	/* the whole segment is inside the last page */
> +	if (bvec->bv_offset >= last_page * PAGE_SIZE) {
> +		seg->bv_offset = bvec->bv_offset % PAGE_SIZE;
> +		seg->bv_len = bvec->bv_len;
> +	} else {
> +		seg->bv_offset = 0;
> +		seg->bv_len = total - last_page * PAGE_SIZE;
> +	}
> +}
> +
>  #endif /* __LINUX_BVEC_ITER_H */
> -- 
> 2.9.5
> 
