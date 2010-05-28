Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4S1LXqo182124 for <xfs@oss.sgi.com>; Thu, 27 May 2010 20:21:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1296537EF5C
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 18:23:56 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	lk5AGnmTHFN4Gbrs for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 18:23:56 -0700 (PDT)
Date: Fri, 28 May 2010 11:23:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
	scanning to current EOF
Message-ID: <20100528012338.GX12087@dastard>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-7-git-send-email-david@fromorbit.com>
	<20100527143341.d4258798.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100527143341.d4258798.akpm@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, May 27, 2010 at 02:33:41PM -0700, Andrew Morton wrote:
> On Tue, 25 May 2010 20:54:12 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > sync can currently take a really long time if a concurrent writer is
> > extending a file. The problem is that the dirty pages on the address
> > space grow in the same direction as write_cache_pages scans, so if
> > the writer keeps ahead of writeback, the writeback will not
> > terminate until the writer stops adding dirty pages.
> 
> <looks at Jens>
> 
> The really was a pretty basic bug.  It's writeback 101 to test that case :(
> 
> > For a data integrity sync, we only need to write the pages dirty at
> > the time we start the writeback, so we can stop scanning once we get
> > to the page that was at the end of the file at the time the scan
> > started.
> > 
> > This will prevent operations like copying a large file preventing
> > sync from completing as it will not write back pages that were
> > dirtied after the sync was started. This does not impact the
> > existing integrity guarantees, as any dirty page (old or new)
> > within the EOF range at the start of the scan will still be
> > captured.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  mm/page-writeback.c |   15 +++++++++++++++
> >  1 files changed, 15 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 0fe713d..c97e973 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -855,7 +855,22 @@ int write_cache_pages(struct address_space *mapping,
> >  		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
> >  			range_whole = 1;
> >  		cycled = 1; /* ignore range_cyclic tests */
> > +
> > +		/*
> > +		 * If this is a data integrity sync, cap the writeback to the
> > +		 * current end of file. Any extension to the file that occurs
> > +		 * after this is a new write and we don't need to write those
> > +		 * pages out to fulfil our data integrity requirements. If we
> > +		 * try to write them out, we can get stuck in this scan until
> > +		 * the concurrent writer stops adding dirty pages and extending
> > +		 * EOF.
> > +		 */
> > +		if (wbc->sync_mode == WB_SYNC_ALL &&
> > +		    wbc->range_end == LLONG_MAX) {
> > +			end = i_size_read(mapping->host) >> PAGE_CACHE_SHIFT;
> > +		}
> >  	}
> > +
> 
> This is somewhat inefficient.  It's really trivial and fast to find the
> highest-index dirty page by walking straight down the
> PAGECACHE_TAG_DIRTY-tagged nodes.
> 
> However pagevec_lookup_tag(..., PAGECACHE_TAG_DIRTY) should do a pretty
> good job of skipping over the (millions of) pages between the (last
> dirty page before `end') and (`end').  So it _should_ be OK.  Some thought
> and runtime testing would be good.

I've done plenty of testing here - the patch is part of my usual QA
stack so it's probably run through XFSQA a few hundred times now.

The behaviour w.r.t. writes into holes appears to be identical to
the current behaviour (i.e. sync hangs until the write stops). I
can't _see_ any difference in behaviour of increase in overhead, but
we all know that this doesn't mean there isn't one.

The test I ran to determine it's effectiveness against extending
writes was running sync during an 8GB sequential write. It would
hang every time until the write completes - typically around 50-60s
- without this patch. With this patch sync returns within 3-4s every
time.

> That being said, I think the patch is insufficient.  If I create an
> enormous (possibly sparse) file with a 16TB hole (or a run of clean
> pages) in the middle and then start busily writing into that hole (run
> of clean pages), the problem will still occur.

Yes, that's already been pointed out. This doesn't attempt to
address that problem because....

> One obvious fix for that (a) would be to add another radix-tree tag and
> do two passes across the radix-tree.

.... we're still waiting for Jan's mark and sweep patch that does
this to make progress. This patch is just a simple fix for the most
common cause of the problem and might get into the tree sooner.

Personally I see no problems with using a mark+sweep algorithm for
this - IMO ensuring that data integrity requirements are met is more
important than ultimate performance.

> Another fix (b) would be to track the number of dirty pages per
> adddress_space, and only write that number of pages.
> 
> Another fix would be to work out how the code handled this situation
> before we broke it, and restore that in some fashion.  I guess fix (b)
> above kinda does that.

Yes, b) is similar to the old code, but like the old code it doesn't
work for the data integrity case because it doesn't guarantee the
correct pages are written out. This patch does for the append case,
and a) guarantees it in all cases....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
