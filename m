Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p94LUhjU064173 for <xfs@oss.sgi.com>; Tue, 4 Oct 2011 16:30:43 -0500
Subject: Re: [PATCH 1/2] xfs: Don't allocate new buffers on every call to
	_xfs_buf_find
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1317357903-26947-2-git-send-email-david@fromorbit.com>
References: <1317357903-26947-1-git-send-email-david@fromorbit.com>
	<1317357903-26947-2-git-send-email-david@fromorbit.com>
Date: Tue, 4 Oct 2011 16:30:39 -0500
Message-ID: <1317763839.3541.4.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, 2011-09-30 at 14:45 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Stats show that for an 8-way unlink @ ~80,000 unlinks/s we are doing
> ~1 million cache hit lookups to ~3000 buffer creates. That's almost
> 3 orders of magnitude more cahce hits than misses, so optimising for
> cache hits is quite important. In the cache hit case, we do not need
> to allocate a new buffer in case of a cache miss, so we are
> effectively hitting the allocator for no good reason for vast the
> majority of calls to _xfs_buf_find. 8-way create workloads are
> showing similar cache hit/miss ratios.
> 
> The result is profiles that look like this:
> 
>      samples  pcnt function                        DSO
>      _______ _____ _______________________________ _________________
> 
>      1036.00 10.0% _xfs_buf_find                   [kernel.kallsyms]
>       582.00  5.6% kmem_cache_alloc                [kernel.kallsyms]
>       519.00  5.0% __memcpy                        [kernel.kallsyms]
>       468.00  4.5% __ticket_spin_lock              [kernel.kallsyms]
>       388.00  3.7% kmem_cache_free                 [kernel.kallsyms]
>       331.00  3.2% xfs_log_commit_cil              [kernel.kallsyms]
> 
> 
> Further, there is a fair bit of work involved in initialising a new
> buffer once a cache miss has occurred and we currently do that under
> the rbtree spinlock. That increases spinlock hold time on what are
> heavily used trees.
> 
> To fix this, remove the initialisation of the buffer from
> _xfs_buf_find() and only allocate the new buffer once we've had a
> cache miss. Initialise the buffer immediately after allocating it in
> xfs_buf_get, too, so that is it ready for insert if we get another
> cache miss after allocation. This minimises lock hold time and
> avoids unnecessary allocator churn. The resulting profiles look
> like:
> 
>      samples  pcnt function                    DSO
>      _______ _____ ___________________________ _________________
> 
>      8111.00  9.1% _xfs_buf_find               [kernel.kallsyms]
>      4380.00  4.9% __memcpy                    [kernel.kallsyms]
>      4341.00  4.8% __ticket_spin_lock          [kernel.kallsyms]
>      3401.00  3.8% kmem_cache_alloc            [kernel.kallsyms]
>      2856.00  3.2% xfs_log_commit_cil          [kernel.kallsyms]
>      2625.00  2.9% __kmalloc                   [kernel.kallsyms]
>      2380.00  2.7% kfree                       [kernel.kallsyms]
>      2016.00  2.3% kmem_cache_free             [kernel.kallsyms]
> 
> Showing a significant reduction in time spent doing allocation and
> freeing from slabs (kmem_cache_alloc and kmem_cache_free).
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This looks good.  I've been testing with it for several days
now as well.  I plan to commit it today or tomorrow.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
