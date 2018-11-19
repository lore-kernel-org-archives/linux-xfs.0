Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbeKSTaM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Nov 2018 14:30:12 -0500
Date: Mon, 19 Nov 2018 17:06:46 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 17/19] block: don't use bio->bi_vcnt to figure out
 segment number
Message-ID: <20181119090645.GN16736@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-18-ming.lei@redhat.com>
 <20181116021140.GL23828@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116021140.GL23828@vader>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On Thu, Nov 15, 2018 at 06:11:40PM -0800, Omar Sandoval wrote:
> On Thu, Nov 15, 2018 at 04:53:04PM +0800, Ming Lei wrote:
> > It is wrong to use bio->bi_vcnt to figure out how many segments
> > there are in the bio even though CLONED flag isn't set on this bio,
> > because this bio may be splitted or advanced.
> > 
> > So always use bio_segments() in blk_recount_segments(), and it shouldn't
> > cause any performance loss now because the physical segment number is figured
> > out in blk_queue_split() and BIO_SEG_VALID is set meantime since
> > bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting").
> > 
> > Cc: Dave Chinner <dchinner@redhat.com>
> > Cc: Kent Overstreet <kent.overstreet@gmail.com>
> > Fixes: 7f60dcaaf91 ("block: blk-merge: fix blk_recount_segments()")
> 
> From what I can tell, the problem was originally introduced by
> 76d8137a3113 ("blk-merge: recaculate segment if it isn't less than max segments")
> 
> Is that right?

Indeed, will update it in next version.

Thanks,
Ming
