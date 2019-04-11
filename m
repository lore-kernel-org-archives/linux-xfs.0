Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47422 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfDKMwM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Apr 2019 08:52:12 -0400
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [LSF/MM TOPIC] guarantee natural alignment for kmalloc()?
Message-ID: <790b68b7-3689-0ff6-08ae-936728bc6458@suse.cz>
Date: Thu, 11 Apr 2019 14:52:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: lsf-pc@lists.linux-foundation.org
Cc: Linux-FSDevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-block@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

Hi,

here's a late topic for discussion that came out of my patchset [1]. It
would likely have to involve all three groups, as FS/IO people would
benefit, but it's MM area.

Background:
The recent thread [2] inspired me to look into guaranteeing alignment
for kmalloc() for power-of-two sizes. IIUC some usecases (see [2]) don't
know the required sizes in advance in order to create named caches via
kmem_cache_create() with explicit alignment parameter (which is the only
way to guarantee alignment right now). Moreover, in most cases the
alignment happens naturally as the slab allocators split
power-of-two-sized pages into smaller power-of-two-sized objects.
kmalloc() users then might rely on the alignment even unknowingly, until
it breaks when e.g. SLUB debugging is enabled.

Turns out it's not difficult to add the guarantees [1] and in the
production SLAB/SLUB configurations nothing really changes as explained
above. Then folks wouldn't have to come up with workarounds as in [2].
Technical downsides would be for SLUB debug mode (increased memory
fragmentation, should be acceptable in a bug hunting scenario?), and
SLOB (potentially worse performance due to increased packing effort, but
this slab variant is rather marginal).

In the session I hope to resolve the question whether this is indeed the
right thing to do for all kmalloc() users, without an explicit alignment
requests, and if it's worth the potentially worse
performance/fragmentation it would impose on a hypothetical new slab
implementation for which it wouldn't be optimal to split power-of-two
sized pages into power-of-two-sized objects (or whether there are any
other downsides).

Thanks,
Vlastimil

[1] https://lore.kernel.org/lkml/20190319211108.15495-1-vbabka@suse.cz/T/#u
[2]
https://lore.kernel.org/linux-fsdevel/20190225040904.5557-1-ming.lei@redhat.com/T/#u
