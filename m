Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57014 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726253AbfCUHmI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Mar 2019 03:42:08 -0400
Subject: Re: [RFC 0/2] guarantee natural alignment for kmalloc()
References: <20190319211108.15495-1-vbabka@suse.cz>
 <01000169988d4e34-b4178f68-c390-472b-b62f-a57a4f459a76-000000@email.amazonses.com>
 <5d7fee9c-1a80-6ac9-ac1d-b1ce05ed27a8@suse.cz>
 <010001699c5563f8-36c6909f-ed43-4839-82da-b5f9f21594b8-000000@email.amazonses.com>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <4d2a55dc-b29f-1309-0a8e-83b057e186e6@suse.cz>
Date: Thu, 21 Mar 2019 08:42:02 +0100
MIME-Version: 1.0
In-Reply-To: <010001699c5563f8-36c6909f-ed43-4839-82da-b5f9f21594b8-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christopher Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On 3/20/19 7:20 PM, Christopher Lameter wrote:
>>> Currently all kmalloc objects are aligned to KMALLOC_MIN_ALIGN. That will
>>> no longer be the case and alignments will become inconsistent.
>>
>> KMALLOC_MIN_ALIGN is still the minimum, but in practice it's larger
>> which is not a problem.
> 
> "In practice" refers to the current way that slab allocators arrange
> objects within the page. They are free to do otherwise if new ideas come
> up for object arrangements etc.
> 
> The slab allocators already may have to store data in addition to the user
> accessible part (f.e. for RCU or ctor). The "natural alighnment" of a
> power of 2 cache is no longer as you expect for these cases. Debugging is
> not the only case where we extend the object.

For plain kmalloc() caches, RCU and ctors don't apply, right.

>> Also let me stress again that nothing really changes except for SLOB,
>> and SLUB with debug options. The natural alignment for power-of-two
>> sizes already happens as SLAB and SLUB both allocate objects starting on
>> the page boundary. So people make assumptions based on that, and then
>> break with SLOB, or SLUB with debug. This patch just prevents that
>> breakage by guaranteeing those natural assumptions at all times.
> 
> As explained before there is nothing "natural" here. Doing so restricts
> future features

Well, future features will have to deal with the existing named caches
created with specific alignment.

> and creates a mess within the allocator of exceptions for
> debuggin etc etc (see what happened to SLAB).

SLAB could be fixed, just nobody cares enough I guess. If I want to
debug wrong SL*B usage I'll use SLUB.

> "Natural" is just a
> simplistic thought of a user how he would arrange power of 2 objects.
> These assumption should not be made but specified explicitly.

Patch 1 does this explicitly for plain kmalloc(). It's unrealistic to
add 'align' parameter to plain kmalloc() as that would have to create
caches on-demand for 'new' values of align parameter.

>>> I think its valuable that alignment requirements need to be explicitly
>>> requested.
>>
>> That's still possible for named caches created by kmem_cache_create().
> 
> So lets leave it as it is now then.

That however doesn't work well for the xfs/IO case where block sizes are
not known in advance:

https://lore.kernel.org/linux-fsdevel/20190225040904.5557-1-ming.lei@redhat.com/T/#ec3a292c358d05a6b29cc4a9ce3ae6b2faf31a23f
