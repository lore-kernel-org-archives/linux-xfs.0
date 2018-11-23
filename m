Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733028AbeKWMaz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Nov 2018 07:30:55 -0500
Date: Fri, 23 Nov 2018 09:48:21 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V11 07/19] fs/buffer.c: use bvec iterator to truncate the
 bio
Message-ID: <20181123014820.GA20110@ming.t460p>
References: <20181121032327.8434-1-ming.lei@redhat.com>
 <20181121032327.8434-8-ming.lei@redhat.com>
 <20181122105849.GA30066@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122105849.GA30066@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Thu, Nov 22, 2018 at 11:58:49AM +0100, Christoph Hellwig wrote:
> Btw, given that this is the last user of bvec_last_segment after my
> other patches I think we should kill bvec_last_segment and do something
> like this here:
> 
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index fa37ad52e962..af5e135d2b83 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2981,6 +2981,14 @@ static void end_bio_bh_io_sync(struct bio *bio)
>  	bio_put(bio);
>  }
>  
> +static void zero_trailing_sectors(struct bio_vec *bvec, unsigned bytes)
> +{
> +	unsigned last_page = (bvec->bv_offset + bvec->bv_len - 1) >> PAGE_SHIFT;
> +
> +	zero_user(nth_page(bvec->bv_page, last_page),
> +		  bvec->bv_offset % PAGE_SIZE + bvec->bv_len, bytes);
> +}

The above 'start' parameter is figured out as wrong, and the computation
isn't very obvious, so I'd suggest to keep bvec_last_segment().

Thanks,
Ming
