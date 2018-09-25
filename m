Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f170.google.com ([209.85.215.170]:35903 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbeIYKQT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Sep 2018 06:16:19 -0400
Subject: Re: block: DMA alignment of IO buffer allocated from slab
References: <38c03920-0fd0-0a39-2a6e-70cd8cb4ef34@virtuozzo.com>
 <20a20568-5089-541d-3cee-546e549a0bc8@acm.org>
 <12eee877-affa-c822-c9d5-fda3aa0a50da@virtuozzo.com>
 <1537801706.195115.7.camel@acm.org>
 <c844c598-be1d-bef4-fb99-09cf99571fd7@virtuozzo.com>
 <1537804720.195115.9.camel@acm.org>
 <10c706fd-2252-f11b-312e-ae0d97d9a538@virtuozzo.com>
 <1537805984.195115.14.camel@acm.org>
 <20180924185753.GA32269@bombadil.infradead.org>
 <20180925001615.GA14386@ming.t460p>
 <20180925032826.GA4110@bombadil.infradead.org>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <4a19ac2f-82c1-db55-9b93-4005ace5e2fe@acm.org>
Date: Mon, 24 Sep 2018 21:10:43 -0700
MIME-Version: 1.0
In-Reply-To: <20180925032826.GA4110@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On 9/24/18 8:28 PM, Matthew Wilcox wrote:
> [ ... ] Because if we have to
> round all allocations below 64 bytes up to 64 bytes, [ ... ]
Have you noticed that in another e-mail in this thread it has been 
explained why it is not necessary on x86 to align buffers allocated by 
kmalloc() on a 64-byte boundary even if these buffers are used for DMA?

Bart.
