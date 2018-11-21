Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbeKUORV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Nov 2018 09:17:21 -0500
Date: Wed, 21 Nov 2018 11:44:16 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 09/19] block: introduce bio_bvecs()
Message-ID: <20181121034415.GA8408@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-10-ming.lei@redhat.com>
 <20181116134541.GH3165@lst.de>
 <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
 <20181120161651.GB2629@lst.de>
 <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
 <20181121005902.GA31748@ming.t460p>
 <2d9bee7a-f010-dcf4-1184-094101058584@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d9bee7a-f010-dcf4-1184-094101058584@grimberg.me>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Tue, Nov 20, 2018 at 07:20:45PM -0800, Sagi Grimberg wrote:
> 
> > Not sure I understand the 'blocking' problem in this case.
> > 
> > We can build a bvec table from this req, and send them all
> > in send(),
> 
> I would like to avoid growing bvec tables and keep everything
> preallocated. Plus, a bvec_iter operates on a bvec which means
> we'll need a table there as well... Not liking it so far...

In case of bios in one request, we can't know how many bvecs there
are except for calling rq_bvecs(), so it may not be suitable to
preallocate the table. If you have to send the IO request in one send(),
runtime allocation may be inevitable.

If you don't require to send the IO request in one send(), you may send
one bio in one time, and just uses the bio's bvec table directly,
such as the single bio case in lo_rw_aio().

> 
> > can this way avoid your blocking issue? You may see this
> > example in branch 'rq->bio != rq->biotail' of lo_rw_aio().
> 
> This is exactly an example of not ignoring the bios...

Yeah, that is the most common example, given merge is enabled
in most of cases. If the driver or device doesn't care merge,
you can disable it and always get single bio request, then the
bio's bvec table can be reused for send().

> 
> > If this way is what you need, I think you are right, even we may
> > introduce the following helpers:
> > 
> > 	rq_for_each_bvec()
> > 	rq_bvecs()
> 
> I'm not sure how this helps me either. Unless we can set a bvec_iter to
> span bvecs or have an abstract bio crossing when we re-initialize the
> bvec_iter I don't see how I can ignore bios completely...

rq_for_each_bvec() will iterate over all bvecs from all bios, so you
needn't to see any bio in this req.

rq_bvecs() will return how many bvecs there are in this request(cover
all bios in this req)

> 
> > So looks nvme-tcp host driver might be the 2nd driver which benefits
> > from multi-page bvec directly.
> > 
> > The multi-page bvec V11 has passed my tests and addressed almost
> > all the comments during review on V10. I removed bio_vecs() in V11,
> > but it won't be big deal, we can introduce them anytime when there
> > is the requirement.
> 
> multipage-bvecs and nvme-tcp are going to conflict, so it would be good
> to coordinate on this. I think that nvme-tcp host needs some adjustments
> as setting a bvec_iter. I'm under the impression that the change is rather
> small and self-contained, but I'm not sure I have the full
> picture here.

I guess I may not get your exact requirement on block io iterator from nvme-tcp
too, :-(

thanks,
Ming
