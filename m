Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BAFF67CA0
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 19:16:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21E89AC001
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 17:16:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EXVl4YsX5iehEA9n for <xfs@oss.sgi.com>;
	Sun, 31 Jul 2016 17:16:10 -0700 (PDT)
Date: Mon, 1 Aug 2016 10:16:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: iomap infrastructure and multipage writes V5
Message-ID: <20160801001608.GH16044@dastard>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<20160628002649.GI12670@dastard> <20160630172239.GA23082@lst.de>
	<20160718111400.GC16044@dastard> <20160718111851.GD16044@dastard>
	<20160731191900.GA29301@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160731191900.GA29301@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Jul 31, 2016 at 09:19:00PM +0200, Christoph Hellwig wrote:
> Another quiet weekend trying to debug this, and only minor progress.
> 
> The biggest different in traces of the old vs new code is that we manage
> to allocate much bigger delalloc reservations at a time in xfs_bmapi_delay
> -> xfs_bmapi_reserve_delalloc.  The old code always went for a single FSB,
> which also meant allocating an indlen of 7 FSBs.  With the iomap code
> we always allocate at least 4FSB (aka a page), and sometimes 8 or 12.
> All of these still need 7 FSBs for the worst case indirect blocks.  So
> what happens here is that in an ENOSPC case we manage to allocate more
> actual delalloc blocks before hitting ENOSPC - notwithstanding that the
> old case would immediately release them a little later in
> xfs_bmap_add_extent_hole_delay after merging the delalloc extents.
> 
> On the writeback side I don't see to many changes either.  We'll
> eventually run out of blocks when allocating the transaction in
> xfs_iomap_write_allocate because the reserved pool is too small.

Yup, that's exactly what generic/224 is testing - it sets the
reserve pool to 4 blocks so it does get exhausted very quickly
and then it exposes the underlying ENOSPC issue. Most users won't
ever see reserve pool exhaustion, which is why I didn't worry too
much about solving this before merging.

> The
> only real difference to before is that under the ENOSPC / out of memory
> case we have allocated between 4 to 12 times more blocks, so we have
> to clean up 4 to 12 times as much while write_cache_pages continues
> iterating over these dirty delalloc blocks.   For me this happens
> ~6 times as much as before, but I still don't manage to hit an
> endless loop.

Ok, I'd kind of got that far myself, but then never really got much
further than that - I suspected some kind of "split a delalloc
extent too many times, run out of reservation" type of issue, but
couldn't isolate such a problem in any of the traces.

> Now after spending this much time I've started wondering why we even
> reserve blocks in xfs_iomap_write_allocate - after all we've reserved
> space for the actual data blocks and the indlen worst case in
> xfs_bmapi_reserve_delalloc.  And in fact a little hack to drop that
> reservation seems to solve both the root cause (depleted reserved pool)
> and the cleanup mess.  I just haven't spend enought time to convince
> myself that it's actually safe, and in fact looking at the allocator
> makes me thing it only works by accident currently despite generally
> postive test results.

Hmmm, interesting. I didn't think about that. I have been looking at
this exact code as a result of rmap ENOSPC problems, and now that
you mention this, I can't see why we'd need a block reservation here
for delalloc conversion, either. Time for more <reverb on>
Adventures in Code Archeology! <reverb off>

/me digs

First stop - just after we removed the behaviour layer. Only caller
of xfs_iomap_write_allocate was:

writepage
  xfs_map_block(BMAPI_ALLOCATE) // only for delalloc
    xfs_iomap
      xfs_iomap_write_allocate

Which is essentially the same single caller we have now, just with
much less indirection.

Looking at the code before the behaviour layer removal, there was
also an "xfs_iocore" abstraction, which abstracted inode locking,
block mapping and allocation and a few other miscellaneous IO
functions. This was so CXFS server could plug into the XFS IO path
and intercept allocation requests on the CXFS client side.  This
leads me to think that the CXFS server could call
xfs_iomap_write_allocate() directly. Whether or not the server kept
the delalloc reservation or not, I'm not sure.

So, let's go back to before this abstraction was in place. Takes us
back to before the linux port was started, back to pure Irix
code....

.... and there's no block reservation done for delalloc conversion.

Ok, so here's the commit that introduced the block reservation for
delalloc conversion:

commit 6706e96e324a2fa9636e93facfd4b7fbbf5b85f8
Author: Glen Overby <overby@sgi.com>
Date:   Tue Mar 4 20:15:43 2003 +0000

    Add error reporting calls in error paths that return EFSCORRUPTED


Yup, hidden deep inside the commit that added the
XFS_CORRUPTION_ERROR and XFS_ERROR_REPORT macros for better error
reporting was this unexplained, uncommented hunk:

@@ -562,9 +563,19 @@ xfs_iomap_write_allocate(
                nimaps = 0;
                while (nimaps == 0) {
                        tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
-                       error = xfs_trans_reserve(tp, 0, XFS_WRITE_LOG_RES(mp),
+                       nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+                       error = xfs_trans_reserve(tp, nres,
+                                       XFS_WRITE_LOG_RES(mp),
                                        0, XFS_TRANS_PERM_LOG_RES,
                                        XFS_WRITE_LOG_COUNT);
+
+                       if (error == ENOSPC) {
+                               error = xfs_trans_reserve(tp, 0,
+                                               XFS_WRITE_LOG_RES(mp),
+                                               0,
+                                               XFS_TRANS_PERM_LOG_RES,
+                                               XFS_WRITE_LOG_COUNT);
+                       }
                        if (error) {
                                xfs_trans_cancel(tp, 0);
                                return XFS_ERROR(error);


It's completely out of place compared to the rest of the patch which
didn't change any code logic or algorithms - it only added error
reporting macros. Hence THIS looks like it may have been an
accidental/unintended change in the commit.

The ENOSPC check here went away in 2007 when I expanded the reserve
block pool and added XFS_TRANS_RESERVE to this function to allow it
dip into the reserve pool (commit bdebc6a4 "Prevent ENOSPC from
aborting transactions that need to succeed"). I didn't pick up on
the history back then, I bet I was just focussed on fixing the
ENOSPC issue....

So, essentially, by emptying the reserve block pool, we've opened
this code back up to whatever underlying ENOSPC issue it had prior
to bdebc6a4. And looking back at 6706e96e, I can only guess that the
block reservation was added for a CXFS use case, because XFS still
only called this from a single place - delalloc conversion.

Christoph - it does look like you've found the problem - I agree
with your analysis that the delalloc already reserves space for the
bmbt blocks in the indlen reservation, and that adding another
reservation for bmbt blocks at transaction allocation makes no
obvious sense. The code history doesn't explain it - it only raises
more questions as to why this was done - it may even have been an
accidental change in the first place...

> Here is the quick patch if anyone wants to chime in:
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 620fc91..67c317f 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -717,7 +717,7 @@ xfs_iomap_write_allocate(
>  
>  		nimaps = 0;
>  		while (nimaps == 0) {
> -			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> +			nres = 0; // XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
>  
>  			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, nres,
>  					0, XFS_TRANS_RESERVE, &tp);

Let me go test it, see what comes up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
