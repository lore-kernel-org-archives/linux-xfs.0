Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38402 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727662AbfBZKGR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Feb 2019 05:06:17 -0500
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
References: <20190225040904.5557-1-ming.lei@redhat.com>
 <20190225043648.GE23020@dastard>
 <5ad2ef83-8b3a-0a15-d72e-72652b807aad@suse.cz>
 <20190225202630.GG23020@dastard> <20190226022249.GA17747@ming.t460p>
 <20190226030214.GI23020@dastard>
 <20190226032737.GA11592@bombadil.infradead.org>
 <20190226045826.GJ23020@dastard> <20190226093302.GA24879@ming.t460p>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <a641feb8-ceb2-2dac-27aa-7b1df10f5ae5@suse.cz>
Date: Tue, 26 Feb 2019 11:06:12 +0100
MIME-Version: 1.0
In-Reply-To: <20190226093302.GA24879@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, linux-block@vger.kernel.orgChristoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>

On 2/26/19 10:33 AM, Ming Lei wrote:
> On Tue, Feb 26, 2019 at 03:58:26PM +1100, Dave Chinner wrote:
>> On Mon, Feb 25, 2019 at 07:27:37PM -0800, Matthew Wilcox wrote:
>>> On Tue, Feb 26, 2019 at 02:02:14PM +1100, Dave Chinner wrote:
>>>>> Or what is the exact size of sub-page IO in xfs most of time? For
>>>>
>>>> Determined by mkfs parameters. Any power of 2 between 512 bytes and
>>>> 64kB needs to be supported. e.g:
>>>>
>>>> # mkfs.xfs -s size=512 -b size=1k -i size=2k -n size=8k ....
>>>>
>>>> will have metadata that is sector sized (512 bytes), filesystem
>>>> block sized (1k), directory block sized (8k) and inode cluster sized
>>>> (32k), and will use all of them in large quantities.
>>>
>>> If XFS is going to use each of these in large quantities, then it doesn't
>>> seem unreasonable for XFS to create a slab for each type of metadata?
>>
>>
>> Well, that is the question, isn't it? How many other filesystems
>> will want to make similar "don't use entire pages just for 4k of
>> metadata" optimisations as 64k page size machines become more
>> common? There are others that have the same "use slab for sector
>> aligned IO" which will fall foul of the same problem that has been
>> reported for XFS....
>>
>> If nobody else cares/wants it, then it can be XFS only. But it's
>> only fair we address the "will it be useful to others" question
>> first.....
> 
> This kind of slab cache should have been global, just like interface of
> kmalloc(size).
> 
> However, the alignment requirement depends on block device's block size,
> then it becomes hard to implement as genera interface, for example:
> 
> 	block size: 512, 1024, 2048, 4096
> 	slab size: 512*N, 0 < N < PAGE_SIZE/512
> 
> For 4k page size, 28(7*4) slabs need to be created, and 64k page size
> needs to create 127*4 slabs.
>

Where does the '*4' multiplier come from?

So I wonder how hard would it actually be (+CC slab maintainers) to just
guarantee generic kmalloc() alignment for power-of-two sizes. If we can
do that for kmem_cache_create() then the code should be already there.
AFAIK the alignment happens anyway (albeit not guaranteed) in the
non-debug cases, and if guaranteeing alignment for certain debugging
configurations (that need some space before the object) means larger
memory overhead, then the cost should still be bearable since its
non-standard configuration where the point is to catch bug and not have
peak performance?

> But, specific file system may only use some of them, and it depends
> on meta data size.
> 
> Thanks,
> Ming
> 
