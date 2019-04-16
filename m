Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from a9-92.smtp-out.amazonses.com ([54.240.9.92]:37986 "EHLO
        a9-92.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728028AbfDPPiz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 11:38:55 -0400
Date: Tue, 16 Apr 2019 15:38:54 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [LSF/MM TOPIC] guarantee natural alignment for kmalloc()?
In-Reply-To: <68385367-8744-50c3-8a81-be3a4637ea80@suse.cz>
Message-ID: <0100016a26cd1058-d1ed3b2e-0cca-4e61-8837-79dfeca68682-000000@email.amazonses.com>
References: <790b68b7-3689-0ff6-08ae-936728bc6458@suse.cz> <1555053293.3046.4.camel@HansenPartnership.com> <68385367-8744-50c3-8a81-be3a4637ea80@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vlastimil Babka <vbabka@suse.cz>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, lsf-pc@lists.linux-foundation.org, Linux-FSDevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

On Fri, 12 Apr 2019, Vlastimil Babka wrote:

> On 4/12/19 9:14 AM, James Bottomley wrote:
> >> In the session I hope to resolve the question whether this is indeed
> >> the right thing to do for all kmalloc() users, without an explicit
> >> alignment requests, and if it's worth the potentially worse
> >> performance/fragmentation it would impose on a hypothetical new slab
> >> implementation for which it wouldn't be optimal to split power-of-two
> >> sized pages into power-of-two-sized objects (or whether there are any
> >> other downsides).
> >
> > I think so.  The question is how aligned?  explicit flushing arch's
> > definitely need at least cache line alignment when using kmalloc for
> > I/O and if allocations cross cache lines they have serious coherency
> > problems.   The question of how much more aligned than this is
> > interesting ... I've got to say that the power of two allocator implies
> > same alignment as size and we seem to keep growing use cases that
> > assume this.

Well that can be controlled on a  per arch level through KMALLOC_MIN_ALIGN
already. There are architectues that align to cache line boundaries.
However you sometimes have hardware with ridiculous large cache line
length configurations like VSMP with 4k.

> Right, by "natural alignment" I meant exactly that - align to size for
> power-of-two sizes.

Well for which sizes? Double word till PAGE_SIZE? This gets us into weird
and difficult to comprehend rules for how objects are aligned. Or do we
start on the cache line size to provide cacheline alignment and do word
alignment before?

Consistency is important I think and if you want something different then
you need to say so in one way or another.


> > I'm not so keen on growing a separate API unless there's
> > a really useful mm efficiency in breaking the kmalloc alignment
> > assumptions.
>
> I'd argue there's not.
