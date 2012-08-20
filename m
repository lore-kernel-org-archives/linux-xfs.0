Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KNDiQS012188 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 18:13:44 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Z247BPPCBcQFmK9K for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 16:13:42 -0700 (PDT)
Date: Tue, 21 Aug 2012 09:13:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 2/4] xfs: Introduce a helper routine to probe data or
	hole offset from page cache
Message-ID: <20120820231309.GJ19235@dastard>
References: <5028FC2E.2010802@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5028FC2E.2010802@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 13, 2012 at 09:07:58PM +0800, Jeff Liu wrote:
> helper routine to lookup data or hole offset from page cache for unwritten extents.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
....
> +		unsigned int	i;
> +
> +		want = min_t(pgoff_t, end - index, (pgoff_t)PAGEVEC_SIZE);

No need for the cast to (pgoff_t) here. That's what the min_t()
macro does for you.

> +		for (i = 0; i < nr_pages; i++) {
> +			struct page	*page = pvec.pages[i];
> +			loff_t		b_offset;
> +
> +			/*
> +			 * Page index is out of range, searching done.
> +			 * If the current offset is not reaches the end
> +			 * of the specified search range, there should
> +			 * be a hole between them.
> +			 */
> +			if (page->index > end) {
> +				if (type == HOLE_OFF && lastoff < endoff) {
> +					*offset = lastoff;
> +					found = true;
> +				}
> +				goto out;
> +			}
> +
> +			lock_page(page);
> +			/*
> +			 * Page truncated or invalidated(page->mapping == NULL).
> +			 * We can freely skip it and proceed to check the next
> +			 * page.
> +			 */
> +			if (unlikely(page->mapping != inode->i_mapping)) {
> +				unlock_page(page);
> +				continue;
> +			}

Still need to check page->index again after locking the page. As
this isn't performance critical, I don't think you need the check
before the page is locked, anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
