Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbeIYDNY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 23:13:24 -0400
Date: Mon, 24 Sep 2018 14:09:13 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: block: DMA alignment of IO buffer allocated from slab
Message-ID: <20180924210913.GB2542@bombadil.infradead.org>
References: <12eee877-affa-c822-c9d5-fda3aa0a50da@virtuozzo.com>
 <1537801706.195115.7.camel@acm.org>
 <c844c598-be1d-bef4-fb99-09cf99571fd7@virtuozzo.com>
 <1537804720.195115.9.camel@acm.org>
 <10c706fd-2252-f11b-312e-ae0d97d9a538@virtuozzo.com>
 <1537805984.195115.14.camel@acm.org>
 <20180924185753.GA32269@bombadil.infradead.org>
 <1537818978.195115.25.camel@acm.org>
 <20180924204148.GA2542@bombadil.infradead.org>
 <1537822441.195115.32.camel@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537822441.195115.32.camel@acm.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <bvanassche@acm.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Ming Lei <ming.lei@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Mon, Sep 24, 2018 at 01:54:01PM -0700, Bart Van Assche wrote:
> On Mon, 2018-09-24 at 13:41 -0700, Matthew Wilcox wrote:
> > Good job snipping the part of my reply which addressed this.  Go read
> > DMA-API.txt yourself.  Carefully.
> 
> The snipped part did not contradict your claim that "You're not supposed to use
> kmalloc memory for DMA." In the DMA-API.txt document however there are multiple
> explicit statements that support allocating memory for DMA with kmalloc(). Here
> is one example from the DMA-API.txt section about dma_map_single():
> 
> 	Not all memory regions in a machine can be mapped by this API.
> 	Further, contiguous kernel virtual space may not be contiguous as
> 	physical memory.  Since this API does not provide any scatter/gather
> 	capability, it will fail if the user tries to map a non-physically
> 	contiguous piece of memory.  For this reason, memory to be mapped by
> 	this API should be obtained from sources which guarantee it to be
> 	physically contiguous (like kmalloc).

Since you're only interested in reading the parts which support your
viewpoint, I'll do the work for you.

        Memory coherency operates at a granularity called the cache
        line width.  In order for memory mapped by this API to operate
        correctly, the mapped region must begin exactly on a cache line
        boundary and end exactly on one (to prevent two separately mapped
        regions from sharing a single cache line).  Since the cache line size
        may not be known at compile time, the API will not enforce this
        requirement.  THEREFORE, IT IS RECOMMENDED THAT DRIVER WRITERS WHO
        DON'T TAKE SPECIAL CARE TO DETERMINE THE CACHE LINE SIZE AT RUN TIME
        ONLY MAP VIRTUAL REGIONS THAT BEGIN AND END ON PAGE BOUNDARIES (WHICH
        ARE GUARANTEED ALSO TO BE CACHE LINE BOUNDARIES).
