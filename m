Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727343AbeKWNCN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Nov 2018 08:02:13 -0500
Date: Fri, 23 Nov 2018 10:19:34 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V11 12/19] block: allow bio_for_each_segment_all() to
 iterate over multi-page bvec
Message-ID: <20181123021933.GB20110@ming.t460p>
References: <20181121032327.8434-1-ming.lei@redhat.com>
 <20181121032327.8434-13-ming.lei@redhat.com>
 <20181122110315.GA30369@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122110315.GA30369@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Thu, Nov 22, 2018 at 12:03:15PM +0100, Christoph Hellwig wrote:
> > +/* used for chunk_for_each_segment */
> > +static inline void bvec_next_segment(const struct bio_vec *bvec,
> > +				     struct bvec_iter_all *iter_all)
> 
> FYI, chunk_for_each_segment doesn't exist anymore, this is
> bvec_for_each_segment now.  Not sure the comment helps much, though.

OK, will remove the comment.

> 
> > +{
> > +	struct bio_vec *bv = &iter_all->bv;
> > +
> > +	if (bv->bv_page) {
> > +		bv->bv_page += 1;
> 
> I think this needs to use nth_page() given that with discontigmem
> page structures might not be allocated contigously.

Good catch!

Thanks,
Ming
