Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57242 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbfCTIsu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Mar 2019 04:48:50 -0400
Subject: Re: [RFC 0/2] guarantee natural alignment for kmalloc()
References: <20190319211108.15495-1-vbabka@suse.cz>
 <01000169988d4e34-b4178f68-c390-472b-b62f-a57a4f459a76-000000@email.amazonses.com>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <5d7fee9c-1a80-6ac9-ac1d-b1ce05ed27a8@suse.cz>
Date: Wed, 20 Mar 2019 09:48:47 +0100
MIME-Version: 1.0
In-Reply-To: <01000169988d4e34-b4178f68-c390-472b-b62f-a57a4f459a76-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christopher Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On 3/20/19 1:43 AM, Christopher Lameter wrote:
> On Tue, 19 Mar 2019, Vlastimil Babka wrote:
> 
>> The recent thread [1] inspired me to look into guaranteeing alignment for
>> kmalloc() for power-of-two sizes. Turns out it's not difficult and in most
>> configuration nothing really changes as it happens implicitly. More details in
>> the first patch. If we agree we want to do this, I will see where to update
>> documentation and perhaps if there are any workarounds in the tree that can be
>> converted to plain kmalloc() afterwards.
> 
> This means that the alignments are no longer uniform for all kmalloc
> caches and we get back to code making all sorts of assumptions about
> kmalloc alignments.

Natural alignment to size is rather well defined, no? Would anyone ever
assume a larger one, for what reason?
It's now where some make assumptions (even unknowingly) for natural
There are two 'odd' sizes 96 and 192, which will keep cacheline size
alignment, would anyone really expect more than 64 bytes?

> Currently all kmalloc objects are aligned to KMALLOC_MIN_ALIGN. That will
> no longer be the case and alignments will become inconsistent.

KMALLOC_MIN_ALIGN is still the minimum, but in practice it's larger
which is not a problem.

Also let me stress again that nothing really changes except for SLOB,
and SLUB with debug options. The natural alignment for power-of-two
sizes already happens as SLAB and SLUB both allocate objects starting on
the page boundary. So people make assumptions based on that, and then
break with SLOB, or SLUB with debug. This patch just prevents that
breakage by guaranteeing those natural assumptions at all times.

> I think its valuable that alignment requirements need to be explicitly
> requested.

That's still possible for named caches created by kmem_cache_create().

> Lets add an array of power of two aligned kmalloc caches if that is really
> necessary. Add some GFP_XXX flag to kmalloc to make it ^2 aligned maybe?

That's unnecessary and wasteful, as the existing caches are already
aligned in the common configurations. Requiring a flag doesn't help with
the implicit assumptions going wrong. I really don't think it needs to
get more complicated than adjusting the uncommon configuration, as this
patch does.
