Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p49E7OlA012543 for <xfs@oss.sgi.com>; Mon, 9 May 2011 09:07:24 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C909543D707
	for <xfs@oss.sgi.com>; Mon,  9 May 2011 07:07:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id btCJq3GReGh61lt7 for
	<xfs@oss.sgi.com>; Mon, 09 May 2011 07:07:23 -0700 (PDT)
Date: Mon, 9 May 2011 10:07:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: ensure reclaim cursor is reset correctly at end
	of AG
Message-ID: <20110509140721.GB12262@infradead.org>
References: <1304650448-28438-1-git-send-email-david@fromorbit.com>
	<1304650448-28438-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1304650448-28438-2-git-send-email-david@fromorbit.com>
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

On Fri, May 06, 2011 at 12:54:04PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On a 32 bit highmem PowerPC machine, the XFS inode cache was growing
> without bound and exhausting low memory causing the OOM killer to be
> triggered. After some effort, the problem was reproduced on a 32 bit
> x86 highmem machine.
> 
> The problem is that the per-ag inode reclaim index cursor was not
> getting reset to the start of the AG if the radix tree tag lookup
> found no more reclaimable inodes. Hence every further reclaim
> attempt started at the same index beyond where any reclaimable
> inodes lay, and no further background reclaim ever occurred from the
> AG.
> 
> Without background inode reclaim the VM driven cache shrinker
> simply cannot keep up with cache growth, and OOM is the result.
> 
> While the change that exposed the problem was the conversion of the
> inode reclaim to use work queues for background reclaim, it was not
> the cause of the bug. The bug was introduced when the cursor code
> was added, just waiting for some weird configuration to strike....

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
