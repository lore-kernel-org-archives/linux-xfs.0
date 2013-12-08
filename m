Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8923A7F86
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:31:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 68A9C304032
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 14:31:46 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1dmXSW2XRqRbj4fn for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 14:31:26 -0800 (PST)
Date: Mon, 9 Dec 2013 09:31:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/11] xfs: no need to lock the inode in xfs_find_handle
Message-ID: <20131208223120.GB31386@dastard>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.196574675@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206203128.196574675@bombadil.infradead.org>
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

On Fri, Dec 06, 2013 at 12:30:07PM -0800, Christoph Hellwig wrote:
> Both the inode number and the generation do not change on a live inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_ioctl.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_ioctl.c	2013-12-06 19:16:33.819188640 +0100
> +++ xfs/fs/xfs/xfs_ioctl.c	2013-12-06 19:17:04.087188019 +0100
> @@ -112,15 +112,11 @@ xfs_find_handle(
>  		memset(&handle.ha_fid, 0, sizeof(handle.ha_fid));
>  		hsize = sizeof(xfs_fsid_t);
>  	} else {
> -		int		lock_mode;
> -
> -		lock_mode = xfs_ilock_map_shared(ip);
>  		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
>  					sizeof(handle.ha_fid.fid_len);
>  		handle.ha_fid.fid_pad = 0;
>  		handle.ha_fid.fid_gen = ip->i_d.di_gen;
>  		handle.ha_fid.fid_ino = ip->i_ino;
> -		xfs_iunlock_map_shared(ip, lock_mode);
>  
>  		hsize = XFS_HSIZE(handle);
>  	}

Agreed.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
