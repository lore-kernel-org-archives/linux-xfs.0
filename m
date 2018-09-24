Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-eopbgr60113.outbound.protection.outlook.com ([40.107.6.113]:3688
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728421AbeIXUp3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Sep 2018 16:45:29 -0400
Subject: Re: block: DMA alignment of IO buffer allocated from slab
References: <CACVXFVOBq3L_EjSTCoiqUL1PH=HMR5EuNNQV0hNndFpGxmUK6g@mail.gmail.com>
 <20180920063129.GB12913@lst.de> <87h8ij0zot.fsf@vitty.brq.redhat.com>
 <20180923224206.GA13618@ming.t460p>
 <38c03920-0fd0-0a39-2a6e-70cd8cb4ef34@virtuozzo.com>
 <20a20568-5089-541d-3cee-546e549a0bc8@acm.org>
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <12eee877-affa-c822-c9d5-fda3aa0a50da@virtuozzo.com>
Date: Mon, 24 Sep 2018 17:43:10 +0300
MIME-Version: 1.0
In-Reply-To: <20a20568-5089-541d-3cee-546e549a0bc8@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>, linux-block <linux-block@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>



On 09/24/2018 05:19 PM, Bart Van Assche wrote:
> On 9/24/18 2:46 AM, Andrey Ryabinin wrote:
>> On 09/24/2018 01:42 AM, Ming Lei wrote:
>>> On Fri, Sep 21, 2018 at 03:04:18PM +0200, Vitaly Kuznetsov wrote:
>>>> Christoph Hellwig <hch@lst.de> writes:
>>>>
>>>>> On Wed, Sep 19, 2018 at 05:15:43PM +0800, Ming Lei wrote:
>>>>>> 1) does kmalloc-N slab guarantee to return N-byte aligned buffer?  If
>>>>>> yes, is it a stable rule?
>>>>>
>>>>> This is the assumption in a lot of the kernel, so I think if somethings
>>>>> breaks this we are in a lot of pain.
>>
>> This assumption is not correct. And it's not correct at least from the beginning of the
>> git era, which is even before SLUB allocator appeared. With CONFIG_DEBUG_SLAB=y
>> the same as with CONFIG_SLUB_DEBUG_ON=y kmalloc return 'unaligned' objects.
>> The guaranteed arch-and-config-independent alignment of kmalloc() result is "sizeof(void*)".


Correction sizeof(unsigned long long), so 8-byte alignment guarantee.

>>
>> If objects has higher alignment requirement, the could be allocated via specifically created kmem_cache.
> 
> Hello Andrey,
> 
> The above confuses me. Can you explain to me why the following comment is present in include/linux/slab.h?
> 
> /*
>  * kmalloc and friends return ARCH_KMALLOC_MINALIGN aligned
>  * pointers. kmem_cache_alloc and friends return ARCH_SLAB_MINALIGN
>  * aligned pointers.
>  */
> 

ARCH_KMALLOC_MINALIGN - guaranteed alignment of the kmalloc() result.
ARCH_SLAB_MINALIGN - guaranteed alignment of kmem_cache_alloc() result.

If the 'align' argument passed into kmem_cache_create() is bigger than ARCH_SLAB_MINALIGN
than kmem_cache_alloc() from that cache should return 'align'-aligned pointers.


> Thanks,
> 
> Bart.
