Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RCJPqE132349 for <xfs@oss.sgi.com>; Thu, 27 May 2010 07:19:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4D0E157BAB4
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 05:23:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sdNt6dyZ0pv38rbG for
	<xfs@oss.sgi.com>; Thu, 27 May 2010 05:23:40 -0700 (PDT)
Date: Thu, 27 May 2010 08:21:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix might_sleep() warning when initialising
	per-ag tree
Message-ID: <20100527122149.GB14632@infradead.org>
References: <1274925493-31401-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274925493-31401-1-git-send-email-david@fromorbit.com>
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

On Thu, May 27, 2010 at 11:58:13AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The use of radix_tree_preload() only works if the radix tree was initialised
> without the __GFP_WAIT flag. The per-ag tree uses GFP_NOFS, so does not trigger
> allocation of new tree nodes from the preloaded array. Hence it enters the
> allocator with a spinlock held and triggers the might_sleep() warnings.
> 
> Reported-by; Chris Mason <chris.mason@oracle.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
