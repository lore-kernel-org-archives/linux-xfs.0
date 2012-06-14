Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5E2Fq37208975 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 21:15:53 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	mLcy8QmYYglfGjtL for <xfs@oss.sgi.com>;
	Wed, 13 Jun 2012 19:15:51 -0700 (PDT)
Date: Thu, 14 Jun 2012 12:15:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: add gfp_mask parameter to vm_map_ram()
Message-ID: <20120614021547.GC7339@dastard>
References: <20120612012134.GA7706@localhost> <20120613123932.GA1445@localhost>
	<20120614012026.GL3019@devil.redhat.com>
	<20120614014902.GB7289@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120614014902.GB7289@localhost>
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
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jun 14, 2012 at 09:49:02AM +0800, Fengguang Wu wrote:
> On Thu, Jun 14, 2012 at 11:20:26AM +1000, Dave Chinner wrote:
> > 
> > Bug in vm_map_ram - it does an unconditional GFP_KERNEL allocation
> > here, and we are in a GFP_NOFS context. We can't pass a gfp_mask to
> > vm_map_ram(), so until vm_map_ram() grows that we can't fix it...
> 
> This trivial patch should fix it.
> 
> The only behavior change is the XFS part:
> 
> @@ -406,7 +406,7 @@ _xfs_buf_map_pages(
>  
>                 do {
>                         bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
> -                                               -1, PAGE_KERNEL);
> +                                               -1, GFP_NOFS, PAGE_KERNEL);

This function isn't always called in GFP_NOFS context - readahead
uses different memory allocation semantics (no retry, no warn), so
there are flags that tell it what to do. i.e.

-						-1, PAGE_KERNEL);
+						-1, xb_to_gfp(flags), PAGE_KERNEL);

Otherwise looks fine to me...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
