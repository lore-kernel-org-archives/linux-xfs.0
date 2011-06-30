Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U2xNCr166835 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 21:59:23 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FF221782992
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 19:59:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CEzooPXYc2yOYAyb for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 19:59:21 -0700 (PDT)
Date: Thu, 30 Jun 2011 12:59:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/27] xfs: fix filesystsem freeze race in xfs_trans_alloc
Message-ID: <20110630025918.GE561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140338.719775353@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629140338.719775353@bombadil.infradead.org>
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

On Wed, Jun 29, 2011 at 10:01:20AM -0400, Christoph Hellwig wrote:
> As pointed out by Jan xfs_trans_alloc can race with a concurrent filesystem
> free when it sleeps during the memory allocation.  Fix this by moving the
  freeze

> wait_for_freeze call after the memory allocation.  This means moving the
> freeze into the low-level _xfs_trans_alloc helper, which thus grows a new
> argument.  Also fix up some comments in that area while at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

>  /*
> - * xfs_log_sbcount
> - *
>   * Called either periodically to keep the on disk superblock values
>   * roughly up to date or from unmount to make sure the values are
>   * correct on a clean unmount.
> - *
> - * Note this code can be called during the process of freezing, so
> - * we may need to use the transaction allocator which does not not
> - * block when the transaction subsystem is in its frozen state.
>   */

I't s not called periodically any more from xfssyncd. Hmmm, that was
removed because it was preventing the filesystem from idling, but we
really should be doing this every so often when the filesystem is
dirty. I'll have a think about that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
