Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 03:58:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LAwHLV012496
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 03:58:18 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C612711E98E3
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 03:59:24 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id krTIAOBxqgHMn8Bz for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 03:59:24 -0700 (PDT)
Date: Mon, 21 Jul 2008 20:59:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Use KM_NOFS for incore inode extent tree
	allocation
Message-ID: <20080721105915.GB6761@disturbed>
References: <1216615959-23010-1-git-send-email-david@fromorbit.com> <20080721075235.GA6692@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721075235.GA6692@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 03:52:35AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 21, 2008 at 02:52:39PM +1000, Dave Chinner wrote:
> > If we allow incore extent tree allocations to recurse into the
> > filesystem under memory pressure, new delayed allocations through
> > xfs_iomap_write_delay() can deadlock on themselves if memory reclaim
> > tries to write back dirty pages from that inode.
> > 
> > It will deadlock in xfs_iomap_write_allocate() trying to take the
> > ilock we already hold. This can also show up as complex ABBA
> > deadlocks when multiple threeads are triggering memory reclaim when
> > trying to allocate extents.
> > 
> > The main cause of this is the fact that delayed allocation is
> > not done in a transaction, so KM_NOFS is not automatically
> > added to the allocations to prevent this recursion.
> > 
> > Mark all allocations done for the incore inode extent tree as
> > KM_NOFS to ensure they never recurse back into the filesystem.
> 
> Looks good.  Note that KM_NOFS alone already means a allocation
> that can't fail, so no need to or it to KM_SLEEP.

Right. I'll update the patch and resend it.

> And long term we should try to look into allowing these to fail,
> allocations that aren't allowed to fail but can't recurse back into
> the fs still have a chance to deadlock.

We need dirty transaction rollback capabilities before we can do that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
