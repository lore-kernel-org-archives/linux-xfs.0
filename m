Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57417 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387625AbeKVVB7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Nov 2018 16:01:59 -0500
Date: Thu, 22 Nov 2018 11:23:09 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V11 03/19] block: introduce bio_for_each_bvec()
Message-ID: <20181122102309.GA29295@lst.de>
References: <20181121032327.8434-1-ming.lei@redhat.com> <20181121032327.8434-4-ming.lei@redhat.com> <20181121133244.GB1640@lst.de> <20181121153135.GB19111@ming.t460p> <20181121161025.GB4977@lst.de> <20181121171217.GA6259@lst.de> <20181122101527.GB27273@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122101527.GB27273@ming.t460p>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Thu, Nov 22, 2018 at 06:15:28PM +0800, Ming Lei wrote:
> >  	while (bytes) {
> > -		unsigned segment_len = segment_iter_len(bv, *iter);
> > -
> > -		if (max_seg_len < BVEC_MAX_LEN)
> > -			segment_len = min_t(unsigned, segment_len,
> > -					    max_seg_len -
> > -					    bvec_iter_offset(bv, *iter));
> > +		unsigned iter_len = bvec_iter_len(bv, *iter);
> > +		unsigned len = min(bytes, iter_len);
> 
> It may not work to always use bvec_iter_len() here, and 'segment_len'
> should be max length of the passed 'bv', however we don't know if it is
> single-page or mutli-page bvec if no one tells us.

The plain revert I sent isn't totally correct in your current tree
indeed because of the odd change that segment_iter_len now is the
full bvec len, so it should be changed to that until we switch to the
sane naming scheme used elsewhere.

But except for that, it will work.  The bvec we operate on (part of the
array in the bio pointed to by the iter) is always a multi-page capable
one. We only fake up a single page on for users using segment_iter_len.

Think of what you are doing in the (I think mostly hypothetical) case
that we call bvec_iter_advance with a bytes > PAGE_SIZE on a segment
small than page size.

In this case we will limit the current iteration to the while loop
until we git a page boundary.  This means we will not hit the condition
moving to the next (real, in the array) bvec at the end of the loop,
and just go on into the next iteration of the loop with the reduced
amount of bytes.  Depending on how large byte is this might repeat
a few more times.  Then on the final one we hit the limit and move
to the next (real, in the array) bvec.

Now if we don't have the segment limit we do exactly the same thing,
just a whole lot more efficiently in a single loop iteration.
tree where segment_iter_len is the 
