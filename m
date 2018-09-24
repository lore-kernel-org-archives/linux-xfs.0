Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from a9-54.smtp-out.amazonses.com ([54.240.9.54]:56082 "EHLO
        a9-54.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728880AbeIXVT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 17:19:56 -0400
Date: Mon, 24 Sep 2018 15:17:16 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: block: DMA alignment of IO buffer allocated from slab
In-Reply-To: <20a20568-5089-541d-3cee-546e549a0bc8@acm.org>
Message-ID: <010001660c27f079-7ba54431-6f0c-430a-8db5-2398a8e761f0-000000@email.amazonses.com>
References: <CACVXFVOBq3L_EjSTCoiqUL1PH=HMR5EuNNQV0hNndFpGxmUK6g@mail.gmail.com> <20180920063129.GB12913@lst.de> <87h8ij0zot.fsf@vitty.brq.redhat.com> <20180923224206.GA13618@ming.t460p> <38c03920-0fd0-0a39-2a6e-70cd8cb4ef34@virtuozzo.com>
 <20a20568-5089-541d-3cee-546e549a0bc8@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <bvanassche@acm.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Ming Lei <ming.lei@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Mon, 24 Sep 2018, Bart Van Assche wrote:

> /*
>  * kmalloc and friends return ARCH_KMALLOC_MINALIGN aligned
>  * pointers. kmem_cache_alloc and friends return ARCH_SLAB_MINALIGN
>  * aligned pointers.
>  */

kmalloc alignment is only guaranteed to ARCH_KMALLOC_MINALIGN. That power
of 2 byte caches (without certain options) are aligned to the power of 2
is due to the nature that these objects are stored in SLUB. Other
allocators may behave different and actually different debug options
result in different alignments. You cannot rely on that.

ARCH_KMALLOC minalign shows the mininum alignment guarantees. If that is
not sufficient and you do not want to change the arch guarantees then you
can open you own slab cache with kmem_cache_create() where you can specify
different alignment requirements.
