Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RLVr6T165761 for <xfs@oss.sgi.com>; Thu, 27 May 2010 16:31:53 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EABEB10A3A6D
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 14:36:09 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	0jhKraQ0Ejmy1Nzh for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 14:36:09 -0700 (PDT)
Date: Thu, 27 May 2010 14:33:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] writeback: limit write_cache_pages integrity
	scanning to current EOF
Message-Id: <20100527143341.d4258798.akpm@linux-foundation.org>
In-Reply-To: <1274784852-30502-7-git-send-email-david@fromorbit.com>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-7-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
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
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, 25 May 2010 20:54:12 +1000
Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> sync can currently take a really long time if a concurrent writer is
> extending a file. The problem is that the dirty pages on the address
> space grow in the same direction as write_cache_pages scans, so if
> the writer keeps ahead of writeback, the writeback will not
> terminate until the writer stops adding dirty pages.

<looks at Jens>

The really was a pretty basic bug.  It's writeback 101 to test that case :(

> For a data integrity sync, we only need to write the pages dirty at
> the time we start the writeback, so we can stop scanning once we get
> to the page that was at the end of the file at the time the scan
> started.
> 
> This will prevent operations like copying a large file preventing
> sync from completing as it will not write back pages that were
> dirtied after the sync was started. This does not impact the
> existing integrity guarantees, as any dirty page (old or new)
> within the EOF range at the start of the scan will still be
> captured.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mm/page-writeback.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 0fe713d..c97e973 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -855,7 +855,22 @@ int write_cache_pages(struct address_space *mapping,
>  		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
>  			range_whole = 1;
>  		cycled = 1; /* ignore range_cyclic tests */
> +
> +		/*
> +		 * If this is a data integrity sync, cap the writeback to the
> +		 * current end of file. Any extension to the file that occurs
> +		 * after this is a new write and we don't need to write those
> +		 * pages out to fulfil our data integrity requirements. If we
> +		 * try to write them out, we can get stuck in this scan until
> +		 * the concurrent writer stops adding dirty pages and extending
> +		 * EOF.
> +		 */
> +		if (wbc->sync_mode == WB_SYNC_ALL &&
> +		    wbc->range_end == LLONG_MAX) {
> +			end = i_size_read(mapping->host) >> PAGE_CACHE_SHIFT;
> +		}
>  	}
> +

This is somewhat inefficient.  It's really trivial and fast to find the
highest-index dirty page by walking straight down the
PAGECACHE_TAG_DIRTY-tagged nodes.

However pagevec_lookup_tag(..., PAGECACHE_TAG_DIRTY) should do a pretty
good job of skipping over the (millions of) pages between the (last
dirty page before `end') and (`end').  So it _should_ be OK.  Some thought
and runtime testing would be good.



That being said, I think the patch is insufficient.  If I create an
enormous (possibly sparse) file with a 16TB hole (or a run of clean
pages) in the middle and then start busily writing into that hole (run
of clean pages), the problem will still occur.

One obvious fix for that (a) would be to add another radix-tree tag and
do two passes across the radix-tree.

Another fix (b) would be to track the number of dirty pages per
adddress_space, and only write that number of pages.

Another fix would be to work out how the code handled this situation
before we broke it, and restore that in some fashion.  I guess fix (b)
above kinda does that.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
