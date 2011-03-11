Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2BADr4s154985 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 04:14:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3B0D33B7B2
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 02:16:44 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iBAZzEgDFKtOiX3u for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2011 02:16:44 -0800 (PST)
Date: Fri, 11 Mar 2011 05:16:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: stop using the page cache to back the buffer cache
Message-ID: <20110311101642.GA15786@infradead.org>
References: <1299719104-11961-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299719104-11961-1-git-send-email-david@fromorbit.com>
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
Cc: chris.mason@oracle.com, xfs@oss.sgi.com

> +		if (((unsigned long)(bp->b_addr + bp->b_buffer_length - 1) &
> +								PAGE_MASK) !=
> +		    ((unsigned long)bp->b_addr & PAGE_MASK)) {
> +			/* b_addr spans two pages - use alloc_page instead */
> +			kmem_free(bp->b_addr);
> +			bp->b_addr = NULL;
> +			goto use_alloc_page;
> +		}

Did you manage to hit this case?  If it happens with any frequency under
real workloads we really need to find a wayto avoid the allocation to
start with.


Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
