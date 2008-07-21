Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 00:51:32 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6L7pRIZ031303
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 00:51:30 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5066A13A199E
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 00:52:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id knfEORUNb6U89Vaa for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 00:52:36 -0700 (PDT)
Date: Mon, 21 Jul 2008 03:52:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Use KM_NOFS for incore inode extent tree
	allocation
Message-ID: <20080721075235.GA6692@infradead.org>
References: <1216615959-23010-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216615959-23010-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 02:52:39PM +1000, Dave Chinner wrote:
> If we allow incore extent tree allocations to recurse into the
> filesystem under memory pressure, new delayed allocations through
> xfs_iomap_write_delay() can deadlock on themselves if memory reclaim
> tries to write back dirty pages from that inode.
> 
> It will deadlock in xfs_iomap_write_allocate() trying to take the
> ilock we already hold. This can also show up as complex ABBA
> deadlocks when multiple threeads are triggering memory reclaim when
> trying to allocate extents.
> 
> The main cause of this is the fact that delayed allocation is
> not done in a transaction, so KM_NOFS is not automatically
> added to the allocations to prevent this recursion.
> 
> Mark all allocations done for the incore inode extent tree as
> KM_NOFS to ensure they never recurse back into the filesystem.

Looks good.  Note that KM_NOFS alone already means a allocation
that can't fail, so no need to or it to KM_SLEEP.

And long term we should try to look into allowing these to fail,
allocations that aren't allowed to fail but can't recurse back into
the fs still have a chance to deadlock.
