Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from a9-114.smtp-out.amazonses.com ([54.240.9.114]:42366 "EHLO
        a9-114.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726529AbfCTSUh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 14:20:37 -0400
Date: Wed, 20 Mar 2019 18:20:35 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC 0/2] guarantee natural alignment for kmalloc()
In-Reply-To: <5d7fee9c-1a80-6ac9-ac1d-b1ce05ed27a8@suse.cz>
Message-ID: <010001699c5563f8-36c6909f-ed43-4839-82da-b5f9f21594b8-000000@email.amazonses.com>
References: <20190319211108.15495-1-vbabka@suse.cz> <01000169988d4e34-b4178f68-c390-472b-b62f-a57a4f459a76-000000@email.amazonses.com> <5d7fee9c-1a80-6ac9-ac1d-b1ce05ed27a8@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Wed, 20 Mar 2019, Vlastimil Babka wrote:

> > This means that the alignments are no longer uniform for all kmalloc
> > caches and we get back to code making all sorts of assumptions about
> > kmalloc alignments.
>
> Natural alignment to size is rather well defined, no? Would anyone ever
> assume a larger one, for what reason?
> It's now where some make assumptions (even unknowingly) for natural
> There are two 'odd' sizes 96 and 192, which will keep cacheline size
> alignment, would anyone really expect more than 64 bytes?

I think one would expect one set of alighment for any kmalloc object.

> > Currently all kmalloc objects are aligned to KMALLOC_MIN_ALIGN. That will
> > no longer be the case and alignments will become inconsistent.
>
> KMALLOC_MIN_ALIGN is still the minimum, but in practice it's larger
> which is not a problem.

"In practice" refers to the current way that slab allocators arrange
objects within the page. They are free to do otherwise if new ideas come
up for object arrangements etc.

The slab allocators already may have to store data in addition to the user
accessible part (f.e. for RCU or ctor). The "natural alighnment" of a
power of 2 cache is no longer as you expect for these cases. Debugging is
not the only case where we extend the object.

> Also let me stress again that nothing really changes except for SLOB,
> and SLUB with debug options. The natural alignment for power-of-two
> sizes already happens as SLAB and SLUB both allocate objects starting on
> the page boundary. So people make assumptions based on that, and then
> break with SLOB, or SLUB with debug. This patch just prevents that
> breakage by guaranteeing those natural assumptions at all times.

As explained before there is nothing "natural" here. Doing so restricts
future features and creates a mess within the allocator of exceptions for
debuggin etc etc (see what happened to SLAB). "Natural" is just a
simplistic thought of a user how he would arrange power of 2 objects.
These assumption should not be made but specified explicitly.

> > I think its valuable that alignment requirements need to be explicitly
> > requested.
>
> That's still possible for named caches created by kmem_cache_create().

So lets leave it as it is now then.
