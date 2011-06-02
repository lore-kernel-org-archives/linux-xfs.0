Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p520GTqe156953 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 19:16:29 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DAE5167AFBD
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 17:16:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iV9MFHv6TkEEm3ma for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2011 17:16:27 -0700 (PDT)
Date: Thu, 2 Jun 2011 10:16:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: clear inode per-lifetime state when recycling it
Message-ID: <20110602001624.GM561@dastard>
References: <1306815659-23346-1-git-send-email-david@fromorbit.com>
	<1306815659-23346-2-git-send-email-david@fromorbit.com>
	<20110531200950.GA31713@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110531200950.GA31713@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, May 31, 2011 at 04:09:50PM -0400, Christoph Hellwig wrote:
> Looks good.
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > +		 * XXX(dgc): should the XFS_ISTALE flag only be cleared here?
> 
> I think so.  Right now any iget on a stale inode will clear it, which
> is very wrong.  Care to send a separate patch for that?

However, the di_mode has already been set to zero before it is
marked stale, so any lookup on it without the XFS_IGET_CREATE flag
set will fail. And only inode allocation sets that flag, in which
case we want the XFS_ISTALE flag cleared. We can't have a race with
the XFS_ISTALE flag being set (both inode freeing and allocation
requires the AGI lock), so once it is stale it is protected by the
mode/flag check.

So it seems safe where it is, but it's not exactly obvious why.

Hmmmm. The inode_init_always() failure case does not clear the
XFS_IRECLAIM flag - that seems like a bug as it will prevent the
inode from ever being reclaimed. Indeed, the error handling looks
completely broken - it's like it is assuming the inode has already
been removed from the reclaim list and marked XFS_INEW. Oh, it used
to do exactly that before this commmit:


commit f1f724e4b523d444c5a598d74505aefa3d6844d2
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Mar 1 11:30:31 2010 +0000

    xfs: fix locking for inode cache radix tree tag updates

    The radix-tree code requires it's users to serialize tag updates
    against other updates to the tree.  While XFS protects tag updates
    against each other it does not serialize them against updates of the
    tree contents, which can lead to tag corruption.  Fix the inode
    cache to always take pag_ici_lock in exclusive mode when updating
    radix tree tags.

    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reported-by: Patrick Schreurs <patrick@news-service.com>
    Tested-by: Patrick Schreurs <patrick@news-service.com>
    Signed-off-by: Alex Elder <aelder@sgi.com>

So yes, it needs fixing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
