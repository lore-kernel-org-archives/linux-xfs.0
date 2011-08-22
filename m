Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M6P3Is035669 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 01:25:03 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D9BDFC666
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 23:25:01 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	s9E241N6JqOh4LBz for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 23:25:01 -0700 (PDT)
Date: Mon, 22 Aug 2011 16:24:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: let xfs_bwrite callers handle the xfs_buf_relse
Message-ID: <20110822062459.GI3162@dastard>
References: <20110814171517.174040686@bombadil.infradead.org>
	<20110814171652.574296593@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110814171652.574296593@bombadil.infradead.org>
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

On Sun, Aug 14, 2011 at 01:15:22PM -0400, Christoph Hellwig wrote:
> Remove the xfs_buf_relse from xfs_bwrite and let the caller handle it to
> mirror the delwri and read paths.
> 
> Also remove the mount pointer passed to xfs_bwrite, which is superflous now
> that we have a mount pointer in the buftarg.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
