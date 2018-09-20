Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out002.mailprotect.be ([83.217.72.86]:37797 "EHLO
        out002.mailprotect.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387616AbeITTvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 15:51:12 -0400
Subject: Re: block: DMA alignment of IO buffer allocated from slab
References: <CACVXFVOBq3L_EjSTCoiqUL1PH=HMR5EuNNQV0hNndFpGxmUK6g@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <c5acf280-b3e3-51b3-da98-0809d9d76cc4@acm.org>
Date: Thu, 20 Sep 2018 07:07:19 -0700
MIME-Version: 1.0
In-Reply-To: <CACVXFVOBq3L_EjSTCoiqUL1PH=HMR5EuNNQV0hNndFpGxmUK6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <tom.leiming@gmail.com>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>

On 9/19/18 2:15 AM, Ming Lei wrote:
> Hi Guys,
> 
> Some storage controllers have DMA alignment limit, which is often set via
> blk_queue_dma_alignment(), such as 512-byte alignment for IO buffer.
> 
> Block layer now only checks if this limit is respected for buffer of
> pass-through request,
> see blk_rq_map_user_iov(), bio_map_user_iov().
> 
> The userspace buffer for direct IO is checked in dio path, see
> do_blockdev_direct_IO().
> IO buffer from page cache should be fine wrt. this limit too.
> 
> However, some file systems, such as XFS, may allocate single sector IO buffer
> via slab. Usually I guess kmalloc-512 should be fine to return
> 512-aligned buffer.
> But once KASAN or other slab debug options are enabled, looks this
> isn't true any
> more, kmalloc-512 may not return 512-aligned buffer. Then data corruption
> can be observed because the IO buffer from fs layer doesn't respect the DMA
> alignment limit any more.
> 
> Follows several related questions:
> 
> 1) does kmalloc-N slab guarantee to return N-byte aligned buffer?  If
> yes, is it a stable rule?
> 
> 2) If it is a rule for kmalloc-N slab to return N-byte aligned buffer,
> seems KASAN violates this
> rule?
> 
> 3) If slab can't guarantee to return 512-aligned buffer, how to fix
> this data corruption issue?

I don't think that (1) is correct, especially if N is not a power of 
two. In the skd driver I addressed this problem by using 
kmem_cache_create() and kmem_cache_alloc() instead of kmalloc(). 
kmem_cache_create() allows to specify the alignment explicitly.

Bart.
