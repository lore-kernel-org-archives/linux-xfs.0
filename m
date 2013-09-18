Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 515AE29E13
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 16:48:46 -0500 (CDT)
Message-ID: <523A1FBD.4010701@sgi.com>
Date: Wed, 18 Sep 2013 16:48:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] [RFC] xfs: lookaside cache for xfs_buf_find
References: <1378690396-15792-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1378690396-15792-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/08/13 20:33, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> CPU overhead of buffer lookups dominate most metadata intensive
> workloads. The thing is, most such workloads are hitting a
> relatively small number of buffers repeatedly, and so caching
> recently hit buffers is a good idea.
>
> Add a hashed lookaside buffer that records the recent buffer
> lookup successes and is searched first before doing a rb-tree
> lookup. If we get a hit, we avoid the expensive rbtree lookup and
> greatly reduce the overhead of the lookup. If we get a cache miss,
> then we've added an extra CPU cacheline miss into the lookup.
>
> In cold cache lookup cases, this extra cache line miss is irrelevant
> as we need to read or allocate the buffer anyway, and the etup time
> for that dwarfs the cost of the miss.
>
> In the case that we miss the lookaside cache and find the buffer in
> the rbtree, the cache line miss overhead will be noticable only if
> we don't see any lookaside cache misses at all in subsequent
> lookups. We don't tend to do random cache walks in perfomrance
> critical paths, so the net result is that the extra CPU cacheline
> miss will be lost in the reduction of misses due to cache hits. This
> hit/miss case is what we'll see with file removal operations.
>
> A simple prime number hash was chosen for the cache (i.e. modulo 37)
> because it is fast, simple, and works really well with block numbers
> that tend to be aligned to a multiple of 8. No attempt to optimise
> this has been made - it's just a number I picked out of thin air
> given that most repetitive workloads have a working set of buffers
> that is significantly smaller than 37 per AG and should hold most of
> the AG header buffers permanently in the lookaside cache.
>
> The result is that on a typical concurrent create fsmark benchmark I
> run, the profile of CPU usage went from having _xfs_buf_find() as
> teh number one CPU consumer:
>
>     6.55%  [kernel]  [k] _xfs_buf_find
>     4.94%  [kernel]  [k] xfs_dir3_free_hdr_from_disk
>     4.77%  [kernel]  [k] native_read_tsc
>     4.67%  [kernel]  [k] __ticket_spin_trylock
>
> to this, at about #8 and #30 in the profile:
>
>     2.56%  [kernel]  [k] _xfs_buf_find
> ....
>     0.55%  [kernel]  [k] _xfs_buf_find_lookaside
>
> So the lookaside cache has halved the CPU overhead of looking up
> buffers for this workload.
>
> On a buffer hit/miss workload like the followup concurrent removes,
> _xfs_buf_find() went from #1 in the profile again at:
>
>     9.13%  [kernel]  [k] _xfs_buf_find
>
> to #6 and #23 repesctively:
>
>     2.82%  [kernel]  [k] _xfs_buf_find
> ....
>     0.78%  [kernel]  [k] _xfs_buf_find_lookaside
>
> Which is also a significant reduction in CPU overhead for buffer
> lookups, and shows the benefit on mixed cold/hot cache lookup
> workloads.
>
> Performance differential, as measured with -m crc=1,finobt=1:
>
> 		   create		remove
> 		time    rate		time
> xfsdev		4m16s	221k/s		6m18s
> patched		3m59s	236k/s		5m56s
>
> So less CPU time spent on lookups translates directly to better
> metadata performance.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Low cost, possible higher return. Idea looks good to me.

What happens in xfs_buf_get_map() when we lose the xfs_buf_find() race?
I don't see a removal of the losing lookaside entry inserted in the
xfs_buf_find().

I will let it run for a while.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
