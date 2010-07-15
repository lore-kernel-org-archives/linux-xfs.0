Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FI7SVt216415 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 13:07:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB1741D68B4D
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 11:10:25 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5uhnQFuHYtip24Au for
	<xfs@oss.sgi.com>; Thu, 15 Jul 2010 11:10:25 -0700 (PDT)
Date: Thu, 15 Jul 2010 14:10:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: convert inode shrinker to per-filesystem contexts
Message-ID: <20100715181025.GB14554@infradead.org>
References: <1279194418-16119-1-git-send-email-david@fromorbit.com>
	<1279194418-16119-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279194418-16119-3-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 15, 2010 at 09:46:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now the shrinker passes us a context, wire up a shrinker context per
> filesystem. This allows us to remove the global mount list and the
> locking problems that introduced. It also means that a shrinker call
> does not need to traverse clean filesystems before finding a
> filesystem with reclaimable inodes.  This significantly reduces
> scanning overhead when lots of filesystems are present.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_super.c |    2 -
>  fs/xfs/linux-2.6/xfs_sync.c  |   62 +++++++++--------------------------------
>  fs/xfs/linux-2.6/xfs_sync.h  |    2 -
>  fs/xfs/xfs_mount.h           |    2 +-
>  4 files changed, 15 insertions(+), 53 deletions(-)

And makes the code a lot simpler and more obvious.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
