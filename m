Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35696 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726237AbfDQILM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Apr 2019 04:11:12 -0400
Subject: Re: [LSF/MM TOPIC] guarantee natural alignment for kmalloc()?
References: <790b68b7-3689-0ff6-08ae-936728bc6458@suse.cz>
 <1555053293.3046.4.camel@HansenPartnership.com>
 <68385367-8744-50c3-8a81-be3a4637ea80@suse.cz>
 <0100016a26cd1058-d1ed3b2e-0cca-4e61-8837-79dfeca68682-000000@email.amazonses.com>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <e1666bc2-13ef-21d5-1ed7-f1738d577278@suse.cz>
Date: Wed, 17 Apr 2019 10:07:51 +0200
MIME-Version: 1.0
In-Reply-To: <0100016a26cd1058-d1ed3b2e-0cca-4e61-8837-79dfeca68682-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christopher Lameter <cl@linux.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, lsf-pc@lists.linux-foundation.org, Linux-FSDevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

On 4/16/19 5:38 PM, Christopher Lameter wrote:
> On Fri, 12 Apr 2019, Vlastimil Babka wrote:
> 
>> On 4/12/19 9:14 AM, James Bottomley wrote:
>>>> In the session I hope to resolve the question whether this is indeed
>>>> the right thing to do for all kmalloc() users, without an explicit
>>>> alignment requests, and if it's worth the potentially worse
>>>> performance/fragmentation it would impose on a hypothetical new slab
>>>> implementation for which it wouldn't be optimal to split power-of-two
>>>> sized pages into power-of-two-sized objects (or whether there are any
>>>> other downsides).
>>>
>>> I think so.  The question is how aligned?  explicit flushing arch's
>>> definitely need at least cache line alignment when using kmalloc for
>>> I/O and if allocations cross cache lines they have serious coherency
>>> problems.   The question of how much more aligned than this is
>>> interesting ... I've got to say that the power of two allocator implies
>>> same alignment as size and we seem to keep growing use cases that
>>> assume this.
> 
> Well that can be controlled on a  per arch level through KMALLOC_MIN_ALIGN
> already. There are architectues that align to cache line boundaries.
> However you sometimes have hardware with ridiculous large cache line
> length configurations like VSMP with 4k.

The arch and cache line limits would be respected as well, of course.

>> Right, by "natural alignment" I meant exactly that - align to size for
>> power-of-two sizes.
> 
> Well for which sizes? Double word till PAGE_SIZE?

Basically, yes. Above page size this is also true thanks to the buddy
allocator scheme.

> This gets us into weird
> and difficult to comprehend rules for how objects are aligned.

I don't think the rules are really difficult to comprehend for kmalloc()
users when they can rely on these alignment guarantees:

- alignment is at least what the arch mandates (to prevent unaligned
access, which is either illegal, or slower, right?)
- alignment at least to allocation size, for power of two sizes
- alignment at least to cache line size for performance or coherency reasons

The point is that kmalloc() users do not ever need to know the exact
alignment! Why should they care? It's enough that the guarantees are
fulfilled, and thanks to the "at least" part, the alignment might be
e.g. twice the size sometimes (e.g. 64 instead of 32), but that's
obviously not a problem for the kmalloc() user as the larger alignment
still satisfies the need for the smaller alignment.

(Implementation-wise a simple max(KMALLOC_MIN_ALIGN, size, cache_line)
is enough if all three are a power-of-two values, otherwise we need to
calculate LCM, but IIRC existing code already uses max() for
KMALLOC_MIN_ALIGN and cache_line at least in SLAB).

> Or do we
> start on the cache line size to provide cacheline alignment and do word
> alignment before?

I didn't intend to change how cache line alignment works, that's a
separate thing. Looks like on my system with SLAB and 64B cache line
size, I have kmalloc-32 aligned to 32, kmalloc-64 aligned to 64 and
kmalloc-96 aligned to 64, thus practically the same as kmalloc-128.
Adding the align-to-size-for-power-of-two guarantee would change nothing
here.

> Consistency is important I think

I think using the three "at least" rules above is consistent enough, or
I'm not sure what kind of consistency you mean here?

> and if you want something different then
> you need to say so in one way or another.
> 
> 
>>> I'm not so keen on growing a separate API unless there's
>>> a really useful mm efficiency in breaking the kmalloc alignment
>>> assumptions.
>>
>> I'd argue there's not.
> 
> 
