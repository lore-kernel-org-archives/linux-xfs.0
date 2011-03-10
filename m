Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2A7Z2mO089555 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 01:35:12 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB56310BB59B
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 23:37:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IScG4kaFMM57710J for
	<xfs@oss.sgi.com>; Wed, 09 Mar 2011 23:37:52 -0800 (PST)
Date: Thu, 10 Mar 2011 02:37:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: flush vmap aliases when mapping fails
Message-ID: <20110310073751.GB25374@infradead.org>
References: <1299713876-7747-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299713876-7747-1-git-send-email-david@fromorbit.com>
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
Cc: linux-mm@kvack.org, npiggin@kernel.dk, xfs@oss.sgi.com

On Thu, Mar 10, 2011 at 10:37:56AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On 32 bit systems, vmalloc space is limited and XFS can chew through
> it quickly as the vmalloc space is lazily freed. This can result in
> failure to map buffers, even when there is apparently large amounts
> of vmalloc space available. Hence, if we fail to map a buffer, purge
> the aliases that have not yet been freed to hopefuly free up enough
> vmalloc space to allow a retry to succeed.

IMHO this should be done by vm_map_ram internally.  If we can't get the
core code fixes we can put this in as a last resort.

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 3cc671c..a5a260f 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -455,9 +455,17 @@ _xfs_buf_map_pages(
>  		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
>  		bp->b_flags |= XBF_MAPPED;
>  	} else if (flags & XBF_MAPPED) {
> -		bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
> -					-1, PAGE_KERNEL);
> -		if (unlikely(bp->b_addr == NULL))
> +		int retried = 0;
> +
> +		do {
> +			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
> +						-1, PAGE_KERNEL);
> +			if (bp->b_addr)
> +				break;
> +			vm_unmap_aliases();
> +		} while (retried++ <= 1);
> +
> +		if (!bp->b_addr)
>  			return -ENOMEM;
>  		bp->b_addr += bp->b_offset;
>  		bp->b_flags |= XBF_MAPPED;
> -- 
> 1.7.2.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
