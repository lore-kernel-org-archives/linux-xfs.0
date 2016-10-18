Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:63139 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752128AbcJRVVV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 17:21:21 -0400
Date: Wed, 19 Oct 2016 08:21:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] XFS buffer cache scalability improvements
Message-ID: <20161018212116.GC23194@dastard>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <dev@lynxeye.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 18, 2016 at 10:14:11PM +0200, Lucas Stach wrote:
> Hi all,
> 
> this series scratches my own small itch with XFS, namely scalability of the buffer
> cache in metadata intensive workloads. With a large number of cached buffers those
> workloads are CPU bound with a significant amount of time spent searching the cache.
> 
> The first commit replaces the rbtree used to index the cache with an rhashtable. The
> rbtree is a bottleneck in scalability, as the data structure itself is pretty CPU
> cache unfriendly. For larger numbers of cached buffers over 80% of the CPU time
> is spent waiting on cache misses resulting from the inherent pointer chasing.
> 
> rhashtables provide a fast lookup with the ability to have lookups proceed while the
> hashtable is being resized. This seems to match the read dominated workload of the
> buffer cache index structure pretty well.

Yup, it's a good idea - I have considered doing this change for
these reasons, but have never found the time.

> The second patch is logical follow up. The rhashtable cache index is protected by
> RCU and does not need any additional locking. By switching the buffer cache entries
> over to RCU freeing the buffer cache can be operated in a completely lock-free
> manner. This should help scalability in the long run.

Yup, that's another reason I'd considered rhashtables :P

However, this is where it gets hairy. The buffer lifecycle is
intricate, subtle, and has a history of nasty bugs that just never
seem to go away. This change will require a lot of verification
work to ensure things like the LRU manipulations haven't been
compromised by the removal of this lock...

> This series survives at least a xfstests auto group run (though with the scratch
> device being a ramdisk) with no regressions and didn't show any problems in my
> real world testing (using the patched FS with multiple large git trees) so far.

It's a performance modification - any performance/profile numbers
that show the improvement?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
