Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 102F67F5E
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 00:05:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F350F304039
	for <xfs@oss.sgi.com>; Sun, 13 Oct 2013 22:05:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8acZQhYP2CheWE76 for <xfs@oss.sgi.com>;
	Sun, 13 Oct 2013 22:05:26 -0700 (PDT)
Date: Mon, 14 Oct 2013 16:04:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: simplify the fallocate path
Message-ID: <20131014050424.GI4446@dastard>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075640.467511096@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131012075640.467511096@bombadil.infradead.org>
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

On Sat, Oct 12, 2013 at 12:55:07AM -0700, Christoph Hellwig wrote:
> Call xfs_alloc_file_space or xfs_free_file_space directly from
> xfs_file_fallocate instead of going through xfs_change_file_space.
> 
> This simplified the code by removing the unessecary marshalling of the
> arguments into an xfs_flock64_t structure and allows removing checks that
> are already done in the VFS code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_bmap_util.c |   39 ++-----------------------
>  fs/xfs/xfs_bmap_util.h |    4 ++
>  fs/xfs/xfs_file.c      |   76 ++++++++++++++++++++++++++++++-------------------
>  3 files changed, 56 insertions(+), 63 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_file.c	2013-10-01 21:06:23.000000000 +0200
> +++ xfs/fs/xfs/xfs_file.c	2013-10-01 21:12:47.552218689 +0200
> @@ -805,44 +805,64 @@ out:
>  
>  STATIC long
>  xfs_file_fallocate(
.....
> +	tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_WRITEID);
> +	error = xfs_trans_reserve(tp, &M_RES(ip->i_mount)->tr_writeid, 0, 0);
> +	if (error) {
> +		xfs_trans_cancel(tp, 0);
> +		goto out_unlock;
> +	}
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	ip->i_d.di_mode &= ~S_ISUID;
> +	if (ip->i_d.di_mode & S_IXGRP)
> +		ip->i_d.di_mode &= ~S_ISGID;
> +
> +	if (!(mode & FALLOC_FL_PUNCH_HOLE))
> +		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
>  
> -	error = -xfs_change_file_space(ip, cmd, &bf, 0, attr_flags);
> +	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	if (file->f_flags & O_DSYNC)
> +		xfs_trans_set_sync(tp);
> +	error = xfs_trans_commit(tp, 0);
>  	if (error)
>  		goto out_unlock;

Seems a bit clunky to do all this work when we've got to repeat most
of it when when we call xfs_setattr_size() if the size has changed.
Any thoughts on how we might reduce to a single transaction?

Otherwise it looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
