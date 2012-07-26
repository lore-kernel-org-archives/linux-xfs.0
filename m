Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QFVutA048475 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:31:56 -0500
Message-ID: <501162EF.6090107@sgi.com>
Date: Thu, 26 Jul 2012 10:31:59 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] xfs: remove iolock lock classes
References: <20120704151328.928543446@bombadil.infradead.org>
	<20120704151444.401872600@bombadil.infradead.org>
In-Reply-To: <20120704151444.401872600@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 07/04/2012 10:13 AM, Christoph Hellwig wrote:
> > Now that we never take the iolock during inode reclaim we don't need
> to play games with lock classes.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> ---
>  fs/xfs/xfs_iget.c  |   15 ---------------
>  fs/xfs/xfs_inode.h |    2 --
>  fs/xfs/xfs_super.c |   18 ++----------------
>  3 files changed, 2 insertions(+), 33 deletions(-)
>
Last patch in this series which removes the unneeded lock classes. 
Looks good.

Reviewed-by:	Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
