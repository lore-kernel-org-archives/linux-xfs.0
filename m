Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727544AbfGAGqz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Jul 2019 02:46:55 -0400
Date: Mon, 1 Jul 2019 14:46:30 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] block: fix .bi_size overflow
Message-ID: <20190701064628.GC16809@ming.t460p>
References: <20190701041644.16052-1-ming.lei@redhat.com>
 <20190701063613.GA20733@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701063613.GA20733@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Liu Yiding <liuyd.fnst@cn.fujitsu.com>, kernel test robot <rong.a.chen@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org

On Mon, Jul 01, 2019 at 08:36:13AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 01, 2019 at 12:16:44PM +0800, Ming Lei wrote:
> > 'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
> > bytes.
> > 
> > Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
> > include very limited pages, and usually at most 256, so the fs bio
> > size won't be bigger than 1M bytes most of times.
> > 
> > Since we support multi-page bvec, in theory one fs bio really can
> > be added > 1M pages, especially in case of hugepage, or big writeback
> > in case of huge dirty pages. Then there is chance in which .bi_size
> > is overflowed.
> > 
> > Fixes this issue by adding bio_will_full() which checks if the added
> > segment may overflow .bi_size.
> 
> Can you please just add the argument to bio_full?  bio_will_full sounds
> rather odd.

OK.

> 
> Maybe also add a kerneldoc comment to the new bio_full to explain
> it.  Otherwise this looks fine to me.

Fine.


Thanks,
Ming
