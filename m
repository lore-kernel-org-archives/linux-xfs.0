Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PKvioQ245832 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 15:57:44 -0500
Subject: Re: [PATCH 3/6] xfs: introduce inode cluster buffer trylocks for
	xfs_iflush
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1300860870-15471-4-git-send-email-david@fromorbit.com>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-4-git-send-email-david@fromorbit.com>
Date: Fri, 25 Mar 2011 16:00:50 -0500
Message-ID: <1301086850.2537.681.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-03-23 at 17:14 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is an ABBA deadlock between synchronous inode flushing in
> xfs_reclaim_inode and xfs_icluster_free. xfs_icluster_free locks the
> buffer, then takes inode ilocks, whilst synchronous reclaim takes
> the ilock followed by the buffer lock in xfs_iflush().
> 
> To avoid this deadlock, separate the inode cluster buffer locking
> semantics from the synchronous inode flush semantics, allowing
> callers to attempt to lock the buffer but still issue synchronous IO
> if it can get the buffer. This requires xfs_iflush() calls that
> currently use non-blocking semantics to pass SYNC_TRYLOCK rather
> than 0 as the flags parameter.
> 
> This allows xfs_reclaim_inode to avoid the deadlock on the buffer
> lock and detect the failure so that it can drop the inode ilock and
> restart the reclaim attempt on the inode. This allows
> xfs_ifree_cluster to obtain the inode lock, mark the inode stale and
> release it and hence defuse the deadlock situation. It also has the
> pleasant side effect of avoiding IO in xfs_reclaim_inode when it
> tries to next reclaim the inode as it is now marked stale.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
