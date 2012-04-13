Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DAF35Q023385 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 05:15:03 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CIo8u2xG7V706EP6 for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 03:15:01 -0700 (PDT)
Date: Fri, 13 Apr 2012 20:14:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/10] xfs: do flush inodes from background inode reclaim
Message-ID: <20120413101459.GI6734@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164645.389070852@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327164645.389070852@bombadil.infradead.org>
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

On Tue, Mar 27, 2012 at 12:44:05PM -0400, Christoph Hellwig wrote:
> We already flush dirty inodes throug the AIL regularly, there is no reason
> to have second thread compete with it and disturb the I/O pattern.  We still
> do write inodes when doing a synchronous reclaim from the shrinker or during
> unmount for now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think the subject line should say "don't" rather than "do".

....
> -
> -	/*
> -	 * When we have to flush an inode but don't have SYNC_WAIT set, we
> -	 * flush the inode out using a delwri buffer and wait for the next
> -	 * call into reclaim to find it in a clean state instead of waiting for
> -	 * it now. We also don't return errors here - if the error is transient
> -	 * then the next reclaim pass will flush the inode, and if the error
> -	 * is permanent then the next sync reclaim will reclaim the inode and
> -	 * pass on the error.
> -	 */
> -	if (error && error != EAGAIN && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
> -		xfs_warn(ip->i_mount,
> -			"inode 0x%llx background reclaim flush failed with %d",
> -			(long long)ip->i_ino, error);
> -	}
> -out:
> -	xfs_iflags_clear(ip, XFS_IRECLAIM);
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	/*
> -	 * We could return EAGAIN here to make reclaim rescan the inode tree in
> -	 * a short while. However, this just burns CPU time scanning the tree
> -	 * waiting for IO to complete and xfssyncd never goes back to the idle
> -	 * state. Instead, return 0 to let the next scheduled background reclaim
> -	 * attempt to reclaim the inode again.
> -	 */
> -	return 0;

Getting rid of this mess is great. Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
