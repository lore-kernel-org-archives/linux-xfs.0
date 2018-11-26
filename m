Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45056 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeK0Jje (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Nov 2018 04:39:34 -0500
Received: by mail-pl1-f193.google.com with SMTP id a14so14552936plm.12
        for <linux-xfs@vger.kernel.org>; Mon, 26 Nov 2018 14:43:54 -0800 (PST)
Date: Mon, 26 Nov 2018 14:43:51 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V12 18/20] block: document usage of bio iterator helpers
Message-ID: <20181126224351.GM30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-19-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-19-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Mon, Nov 26, 2018 at 10:17:18AM +0800, Ming Lei wrote:
> Now multi-page bvec is supported, some helpers may return page by
> page, meantime some may return segment by segment, this patch
> documents the usage.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  Documentation/block/biovecs.txt | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/Documentation/block/biovecs.txt b/Documentation/block/biovecs.txt
> index 25689584e6e0..ce6eccaf5df7 100644
> --- a/Documentation/block/biovecs.txt
> +++ b/Documentation/block/biovecs.txt
> @@ -117,3 +117,28 @@ Other implications:
>     size limitations and the limitations of the underlying devices. Thus
>     there's no need to define ->merge_bvec_fn() callbacks for individual block
>     drivers.
> +
> +Usage of helpers:
> +=================
> +
> +* The following helpers whose names have the suffix of "_all" can only be used
> +on non-BIO_CLONED bio. They are usually used by filesystem code. Drivers
> +shouldn't use them because the bio may have been split before it reached the
> +driver.
> +
> +	bio_for_each_segment_all()
> +	bio_first_bvec_all()
> +	bio_first_page_all()
> +	bio_last_bvec_all()
> +
> +* The following helpers iterate over single-page segment. The passed 'struct
> +bio_vec' will contain a single-page IO vector during the iteration
> +
> +	bio_for_each_segment()
> +	bio_for_each_segment_all()
> +
> +* The following helpers iterate over multi-page bvec. The passed 'struct
> +bio_vec' will contain a multi-page IO vector during the iteration
> +
> +	bio_for_each_bvec()
> +	rq_for_each_bvec()
> -- 
> 2.9.5
> 
