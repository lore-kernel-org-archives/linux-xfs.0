Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDLNYQl174177 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 15:23:34 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 098392BDAF3
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 13:23:32 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kKXk0kTTJ3s2KD3J for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 13:23:32 -0800 (PST)
Date: Wed, 14 Dec 2011 08:23:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/11] xfs: remove xfs_itruncate_data
Message-ID: <20111213212330.GA3179@dastard>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155917.662964294@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111208155917.662964294@bombadil.infradead.org>
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

On Thu, Dec 08, 2011 at 10:57:56AM -0500, Christoph Hellwig wrote:
> This wrapper isn't overly useful, not to say rather confusing.
> 
> Around the call to xfs_itruncate_extents it does:
> 
>  - add tracing
>  - add a few asserts in debug builds
>  - conditionally update the inode size in two places
>  - log the inode
> 
> Both the tracing and the inode logging can be moved to xfs_itruncate_extents
> as they are useful for the attribute fork as well - in fact the attr code
> already does an equivalent xfs_trans_log_inode call just after calling
> xfs_itruncate_extents.  The conditional size updates are a mess, and there
> was no reason to do them in two places anyway, as the first one was
> conditional on the inode having extents - but without extents we
> xfs_itruncate_extents would be a no-op and the placement wouldn't matter
> anyway.  Instead move the size assignments and the asserts that make sense
> to the callers that want it.
> 
> As a side effect of this clean up xfs_setattr_size by introducing variables
> for the old and new inode size, and moving the size updates into a common
> place.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I can't see anything wrong with this, and it hasn't produced any
failures in my testing, so it looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
