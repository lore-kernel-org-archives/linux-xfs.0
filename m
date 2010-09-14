Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ENJFkC153082 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 18:19:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 140D717F3DCE
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 16:20:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id G1wxXNTDQUh0nc7n for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 16:20:04 -0700 (PDT)
Date: Tue, 14 Sep 2010 19:20:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 18/18] xfs: stop using the page cache to back the buffer
	cache
Message-ID: <20100914232004.GC29338@infradead.org>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-19-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284461777-1496-19-git-send-email-david@fromorbit.com>
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

On Tue, Sep 14, 2010 at 08:56:17PM +1000, Dave Chinner wrote:
> The only open question is how to best handle sub-page buffers - can we use
> kmalloc/slab memory for sub-page sized buffers, or do we need to split up
> pages ourselves? Worth noting is that the current code still works on sub-page
> block size filesystems, it is just inefficient w.r.t. memory usage.

As mentioned before I think we're fine to use slab/kmalloc pages now.
In fact using them will probably be more efficient than the current
code, given that at least btree blocks usually won't be close to each
other, so the old code wasted lots of memory for it, too.

>  	for (i = 0; i < bp->b_page_count; i++) {
>  		struct page	*page;
>  		uint		retries = 0;
> +retry:
> +		page = alloc_page(gfp_mask);
>  		if (unlikely(page == NULL)) {
>  			if (flags & XBF_READ_AHEAD) {
>  				bp->b_page_count = i;
>  				for (i = 0; i < bp->b_page_count; i++)
> +					__free_page(bp->b_pages[i]);
>  				return -ENOMEM;

Maybe convert this to and out_free_pages goto while you're at it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
