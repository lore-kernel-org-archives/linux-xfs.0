Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbeIYNBj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Sep 2018 09:01:39 -0400
Date: Tue, 25 Sep 2018 14:55:18 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: block: DMA alignment of IO buffer allocated from slab
Message-ID: <20180925065517.GA4868@ming.t460p>
References: <1537801706.195115.7.camel@acm.org>
 <c844c598-be1d-bef4-fb99-09cf99571fd7@virtuozzo.com>
 <1537804720.195115.9.camel@acm.org>
 <10c706fd-2252-f11b-312e-ae0d97d9a538@virtuozzo.com>
 <1537805984.195115.14.camel@acm.org>
 <20180924185753.GA32269@bombadil.infradead.org>
 <20180925001615.GA14386@ming.t460p>
 <20180925032826.GA4110@bombadil.infradead.org>
 <4a19ac2f-82c1-db55-9b93-4005ace5e2fe@acm.org>
 <20180925044421.GA11163@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180925044421.GA11163@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Mon, Sep 24, 2018 at 09:44:21PM -0700, Matthew Wilcox wrote:
> On Mon, Sep 24, 2018 at 09:10:43PM -0700, Bart Van Assche wrote:
> > On 9/24/18 8:28 PM, Matthew Wilcox wrote:
> > > [ ... ] Because if we have to
> > > round all allocations below 64 bytes up to 64 bytes, [ ... ]
> > Have you noticed that in another e-mail in this thread it has been explained
> > why it is not necessary on x86 to align buffers allocated by kmalloc() on a
> > 64-byte boundary even if these buffers are used for DMA?
> 
> Oh, so drivers which do this only break on !x86.  Yes, that'll work
> out great.

It shouldn't break !x86 because ARCH_KMALLOC_MINALIGN handles that.

Thanks,
Ming
