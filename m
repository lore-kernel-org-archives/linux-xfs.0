Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34362 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfDKN2W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Apr 2019 09:28:22 -0400
Date: Thu, 11 Apr 2019 06:28:19 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [LSF/MM TOPIC] guarantee natural alignment for kmalloc()?
Message-ID: <20190411132819.GB22763@bombadil.infradead.org>
References: <790b68b7-3689-0ff6-08ae-936728bc6458@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <790b68b7-3689-0ff6-08ae-936728bc6458@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vlastimil Babka <vbabka@suse.cz>
Cc: lsf-pc@lists.linux-foundation.org, Linux-FSDevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

On Thu, Apr 11, 2019 at 02:52:08PM +0200, Vlastimil Babka wrote:
> In the session I hope to resolve the question whether this is indeed the
> right thing to do for all kmalloc() users, without an explicit alignment
> requests, and if it's worth the potentially worse
> performance/fragmentation it would impose on a hypothetical new slab
> implementation for which it wouldn't be optimal to split power-of-two
> sized pages into power-of-two-sized objects (or whether there are any
> other downsides).

I think this is exactly the kind of discussion that LSFMM is for!  It's
really a whole-system question; is Linux better-off having the flexibility
for allocators to return non-power-of-two aligned memory, or allowing
consumers of the kmalloc API to assume that "sufficiently large" memory
is naturally aligned.

Another possibility that should be considered is introducing a kmalloc()
variant like posix_memalign() that allows for specifying the alignment,
or just kmalloc_naturally_aligned().

And we probably need to reiterate for the benefit of those not following
the discussion that creating a slab cache (which does allow for alignment
to be specified) is impractical for this use case because the actual
allocations are of variable size, but always need to be 512-byte aligned.
