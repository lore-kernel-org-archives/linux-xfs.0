Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43542 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbeIYC6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 22:58:07 -0400
Message-ID: <1537822441.195115.32.camel@acm.org>
Subject: Re: block: DMA alignment of IO buffer allocated from slab
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 24 Sep 2018 13:54:01 -0700
In-Reply-To: <20180924204148.GA2542@bombadil.infradead.org>
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
         <20180924204148.GA2542@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-7"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Ming Lei <ming.lei@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Mon, 2018-09-24 at 13:41 -0700, Matthew Wilcox wrote:
+AD4 On Mon, Sep 24, 2018 at 12:56:18PM -0700, Bart Van Assche wrote:
+AD4 +AD4 On Mon, 2018-09-24 at 11:57 -0700, Matthew Wilcox wrote:
+AD4 +AD4 +AD4 You're not supposed to use kmalloc memory for DMA.  This is why we have
+AD4 +AD4 +AD4 dma+AF8-alloc+AF8-coherent() and friends.
+AD4 +AD4 
+AD4 +AD4 Are you claiming that all drivers that use DMA should use coherent DMA only? If
+AD4 +AD4 coherent DMA is the only DMA style that should be used, why do the following
+AD4 +AD4 function pointers exist in struct dma+AF8-map+AF8-ops?
+AD4 
+AD4 Good job snipping the part of my reply which addressed this.  Go read
+AD4 DMA-API.txt yourself.  Carefully.

The snipped part did not contradict your claim that +ACI-You're not supposed to use
kmalloc memory for DMA.+ACI In the DMA-API.txt document however there are multiple
explicit statements that support allocating memory for DMA with kmalloc(). Here
is one example from the DMA-API.txt section about dma+AF8-map+AF8-single():

	Not all memory regions in a machine can be mapped by this API.
	Further, contiguous kernel virtual space may not be contiguous as
	physical memory.  Since this API does not provide any scatter/gather
	capability, it will fail if the user tries to map a non-physically
	contiguous piece of memory.  For this reason, memory to be mapped by
	this API should be obtained from sources which guarantee it to be
	physically contiguous (like kmalloc).

Bart.
