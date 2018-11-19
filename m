Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbeKSMqB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Nov 2018 07:46:01 -0500
Date: Mon, 19 Nov 2018 10:23:28 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 01/19] block: introduce multi-page page bvec helpers
Message-ID: <20181119022327.GC10838@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-2-ming.lei@redhat.com>
 <20181116131305.GA3165@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116131305.GA3165@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Fri, Nov 16, 2018 at 02:13:05PM +0100, Christoph Hellwig wrote:
> > -#define bvec_iter_page(bvec, iter)				\
> > +#define mp_bvec_iter_page(bvec, iter)				\
> >  	(__bvec_iter_bvec((bvec), (iter))->bv_page)
> >  
> > -#define bvec_iter_len(bvec, iter)				\
> > +#define mp_bvec_iter_len(bvec, iter)				\
> 
> I'd much prefer if we would stick to the segment naming that
> we also use in the higher level helper.
> 
> So segment_iter_page, segment_iter_len, etc.

We discussed the naming problem before, one big problem is that the 'segment'
in bio_for_each_segment*() means one single page segment actually.

If we use segment_iter_page() here for multi-page segment, it may
confuse people.

Of course, I prefer to the naming of segment/page, 

And Jens didn't agree to rename bio_for_each_segment*() before.

So what is the solution we should take for moving on?

> 
> > + * This helpers are for building sp bvec in flight.
> 
> Please spell out single page, sp is not easy understandable.

OK.

Thanks,
Ming
