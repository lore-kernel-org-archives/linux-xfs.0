Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54292 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726061AbfDLHPC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 03:15:02 -0400
Message-ID: <1555053293.3046.4.camel@HansenPartnership.com>
Subject: Re: [LSF/MM TOPIC] guarantee natural alignment for kmalloc()?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Fri, 12 Apr 2019 09:14:53 +0200
In-Reply-To: <790b68b7-3689-0ff6-08ae-936728bc6458@suse.cz>
References: <790b68b7-3689-0ff6-08ae-936728bc6458@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vlastimil Babka <vbabka@suse.cz>, lsf-pc@lists.linux-foundation.org
Cc: Linux-FSDevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

On Thu, 2019-04-11 at 14:52 +0200, Vlastimil Babka wrote:
> Hi,
> 
> here's a late topic for discussion that came out of my patchset [1].
> It would likely have to involve all three groups, as FS/IO people
> would benefit, but it's MM area.
> 
> Background:
> The recent thread [2] inspired me to look into guaranteeing alignment
> for kmalloc() for power-of-two sizes. IIUC some usecases (see [2])
> don't know the required sizes in advance in order to create named
> caches via kmem_cache_create() with explicit alignment parameter
> (which is the only way to guarantee alignment right now). Moreover,
> in most cases the alignment happens naturally as the slab allocators
> split power-of-two-sized pages into smaller power-of-two-sized
> objects. kmalloc() users then might rely on the alignment even
> unknowingly, until it breaks when e.g. SLUB debugging is enabled.
> 
> Turns out it's not difficult to add the guarantees [1] and in the
> production SLAB/SLUB configurations nothing really changes as
> explained above. Then folks wouldn't have to come up with workarounds
> as in [2]. Technical downsides would be for SLUB debug mode
> (increased memory fragmentation, should be acceptable in a bug
> hunting scenario?), and SLOB (potentially worse performance due to
> increased packing effort, but this slab variant is rather marginal).
> 
> In the session I hope to resolve the question whether this is indeed
> the right thing to do for all kmalloc() users, without an explicit
> alignment requests, and if it's worth the potentially worse
> performance/fragmentation it would impose on a hypothetical new slab
> implementation for which it wouldn't be optimal to split power-of-two
> sized pages into power-of-two-sized objects (or whether there are any
> other downsides).

I think so.  The question is how aligned?  explicit flushing arch's
definitely need at least cache line alignment when using kmalloc for
I/O and if allocations cross cache lines they have serious coherency
problems.   The question of how much more aligned than this is
interesting ... I've got to say that the power of two allocator implies
same alignment as size and we seem to keep growing use cases that
assume this.  I'm not so keen on growing a separate API unless there's
a really useful mm efficiency in breaking the kmalloc alignment
assumptions.

James
