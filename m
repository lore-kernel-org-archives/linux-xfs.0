Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42743 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbeKPMQD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 07:16:03 -0500
Received: by mail-pf1-f193.google.com with SMTP id 64so6134918pfr.9
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 18:05:36 -0800 (PST)
Date: Thu, 15 Nov 2018 18:05:33 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V10 16/19] block: document usage of bio iterator helpers
Message-ID: <20181116020533.GK23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-17-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-17-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Thu, Nov 15, 2018 at 04:53:03PM +0800, Ming Lei wrote:
> Now multi-page bvec is supported, some helpers may return page by
> page, meantime some may return segment by segment, this patch
> documents the usage.
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
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  Documentation/block/biovecs.txt | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/Documentation/block/biovecs.txt b/Documentation/block/biovecs.txt
> index 25689584e6e0..bfafb70d0d9e 100644
> --- a/Documentation/block/biovecs.txt
> +++ b/Documentation/block/biovecs.txt
> @@ -117,3 +117,29 @@ Other implications:
>     size limitations and the limitations of the underlying devices. Thus
>     there's no need to define ->merge_bvec_fn() callbacks for individual block
>     drivers.
> +
> +Usage of helpers:
> +=================
> +
> +* The following helpers whose names have the suffix of "_all" can only be used
> +on non-BIO_CLONED bio, and usually they are used by filesystem code, and driver
> +shouldn't use them because bio may have been split before they got to the driver:

Putting an english teacher hat on, this is quite the run-on sentence.
How about:

* The following helpers whose names have the suffix of "_all" can only be used
on non-BIO_CLONED bio. They are usually used by filesystem code. Drivers
shouldn't use them because the bio may have been split before it reached the
driver.

Maybe also an explanation of why the filesystem would want to use these?

> +	bio_for_each_segment_all()
> +	bio_first_bvec_all()
> +	bio_first_page_all()
> +	bio_last_bvec_all()
> +
> +* The following helpers iterate over single-page bvec, and the local
> +variable of 'struct bio_vec' or the reference records single-page IO
> +vector during the itearation:


* The following helpers iterate over single-page bvecs. The passed 'struct
bio_vec' will contain a single-page IO vector during the iteration.

> +	bio_for_each_segment()
> +	bio_for_each_segment_all()
> +
> +* The following helper iterates over multi-page bvec, and each bvec may
> +include multiple physically contiguous pages, and the local variable of
> +'struct bio_vec' or the reference records multi-page IO vector during the
> +itearation:

* The following helper iterates over multi-page bvecs. Each bvec may
include multiple physically contiguous pages. The passed 'struct bio_vec' will
contain a multi-page IO vector during the iteration.

> +	bio_for_each_bvec()
> -- 
> 2.9.5
> 
