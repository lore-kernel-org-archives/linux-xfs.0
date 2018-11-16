Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49688 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbeKPXZ2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Nov 2018 18:25:28 -0500
Date: Fri, 16 Nov 2018 14:13:05 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V10 01/19] block: introduce multi-page page bvec helpers
Message-ID: <20181116131305.GA3165@lst.de>
References: <20181115085306.9910-1-ming.lei@redhat.com> <20181115085306.9910-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-2-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

> -#define bvec_iter_page(bvec, iter)				\
> +#define mp_bvec_iter_page(bvec, iter)				\
>  	(__bvec_iter_bvec((bvec), (iter))->bv_page)
>  
> -#define bvec_iter_len(bvec, iter)				\
> +#define mp_bvec_iter_len(bvec, iter)				\

I'd much prefer if we would stick to the segment naming that
we also use in the higher level helper.

So segment_iter_page, segment_iter_len, etc.

> + * This helpers are for building sp bvec in flight.

Please spell out single page, sp is not easy understandable.
