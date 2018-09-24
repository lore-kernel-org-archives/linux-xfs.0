Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50474 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbeIYCpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 22:45:53 -0400
Date: Mon, 24 Sep 2018 13:41:48 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: block: DMA alignment of IO buffer allocated from slab
Message-ID: <20180924204148.GA2542@bombadil.infradead.org>
References: <38c03920-0fd0-0a39-2a6e-70cd8cb4ef34@virtuozzo.com>
 <20a20568-5089-541d-3cee-546e549a0bc8@acm.org>
 <12eee877-affa-c822-c9d5-fda3aa0a50da@virtuozzo.com>
 <1537801706.195115.7.camel@acm.org>
 <c844c598-be1d-bef4-fb99-09cf99571fd7@virtuozzo.com>
 <1537804720.195115.9.camel@acm.org>
 <10c706fd-2252-f11b-312e-ae0d97d9a538@virtuozzo.com>
 <1537805984.195115.14.camel@acm.org>
 <20180924185753.GA32269@bombadil.infradead.org>
 <1537818978.195115.25.camel@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537818978.195115.25.camel@acm.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <bvanassche@acm.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Ming Lei <ming.lei@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Mon, Sep 24, 2018 at 12:56:18PM -0700, Bart Van Assche wrote:
> On Mon, 2018-09-24 at 11:57 -0700, Matthew Wilcox wrote:
> > You're not supposed to use kmalloc memory for DMA.  This is why we have
> > dma_alloc_coherent() and friends.
> 
> Are you claiming that all drivers that use DMA should use coherent DMA only? If
> coherent DMA is the only DMA style that should be used, why do the following
> function pointers exist in struct dma_map_ops?

Good job snipping the part of my reply which addressed this.  Go read
DMA-API.txt yourself.  Carefully.
