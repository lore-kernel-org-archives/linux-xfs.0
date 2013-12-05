Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6BE527F6F
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 14:31:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3842F30407E
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 12:31:20 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	FJ5Pm2A262TUK6rf for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 12:31:18 -0800 (PST)
Date: Fri, 6 Dec 2013 07:31:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: take the ilock around xfs_bmapi_read in
	xfs_zero_remaining_bytes
Message-ID: <20131205203115.GA29897@dastard>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.199565525@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205155951.199565525@bombadil.infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 05, 2013 at 07:58:31AM -0800, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_bmap_util.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-12-05 11:37:57.791685284 +0100
> +++ xfs/fs/xfs/xfs_bmap_util.c	2013-12-05 11:39:43.599683113 +0100
> @@ -1147,6 +1147,7 @@ xfs_zero_remaining_bytes(
>  	xfs_mount_t		*mp = ip->i_mount;
>  	int			nimap;
>  	int			error = 0;
> +	uint			lock_mode;
>  
>  	/*
>  	 * Avoid doing I/O beyond eof - it's not necessary
> @@ -1159,11 +1160,15 @@ xfs_zero_remaining_bytes(
>  	if (endoff > XFS_ISIZE(ip))
>  		endoff = XFS_ISIZE(ip);
>  
> +	lock_mode = xfs_ilock_map_shared(ip);
> +
>  	bp = xfs_buf_get_uncached(XFS_IS_REALTIME_INODE(ip) ?
>  					mp->m_rtdev_targp : mp->m_ddev_targp,
>  				  BTOBB(mp->m_sb.sb_blocksize), 0);

This now holds the ilock over data IO, which is not allowed to be
done as data IO completion can require the ilock to be taken. Yes,
the code specifically avoids all these problems, but the general
rule is that ilock is only held over metadata IO operations, not
data IO. If we need data IO serialisation, then we use the iolock.

So, while this protects the extent tree, it also violates other
long-standing conventions for locking. Given that the code is
special, I'mnot opposed to making a special rule for this one
function, but it needs to be commented as to why this is a valid
thing to do in this function....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
