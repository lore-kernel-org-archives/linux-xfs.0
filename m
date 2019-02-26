Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49126 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfBZNCd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Feb 2019 08:02:33 -0500
Date: Tue, 26 Feb 2019 05:02:30 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
Message-ID: <20190226130230.GD11592@bombadil.infradead.org>
References: <20190225202630.GG23020@dastard>
 <20190226022249.GA17747@ming.t460p>
 <20190226030214.GI23020@dastard>
 <20190226032737.GA11592@bombadil.infradead.org>
 <20190226045826.GJ23020@dastard>
 <20190226093302.GA24879@ming.t460p>
 <a641feb8-ceb2-2dac-27aa-7b1df10f5ae5@suse.cz>
 <CACVXFVMX=WpTRBbDTSibfXkTZxckk3ootetbE+rkJtHhsZkRAw@mail.gmail.com>
 <20190226121209.GC11592@bombadil.infradead.org>
 <20190226123545.GA6163@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226123545.GA6163@ming.t460p>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block <linux-block@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>

On Tue, Feb 26, 2019 at 08:35:46PM +0800, Ming Lei wrote:
> On Tue, Feb 26, 2019 at 04:12:09AM -0800, Matthew Wilcox wrote:
> > On Tue, Feb 26, 2019 at 07:12:49PM +0800, Ming Lei wrote:
> > > The buffer needs to be device block size aligned for dio, and now the block
> > > size can be 512, 1024, 2048 and 4096.
> > 
> > Why does the block size make a difference?  This requirement is due to
> > some storage devices having shoddy DMA controllers.  Are you saying there
> > are devices which can't even do 512-byte aligned I/O?
> 
> Direct IO requires that, see do_blockdev_direct_IO().
> 
> This issue can be triggered when running xfs over loop/dio. We could
> fallback to buffered IO under this situation, but not sure it is the
> only case.

Wait, we're imposing a ridiculous amount of complexity on XFS for no
reason at all?  We should just change this to 512-byte alignment.  Tying
it to the blocksize of the device never made any sense.
