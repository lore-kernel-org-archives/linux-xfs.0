Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBA27VnA169282 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 20:07:31 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	WfQ2QR4HglrwPVmz for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 18:09:58 -0800 (PST)
Date: Mon, 10 Dec 2012 13:09:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: simplify the fallocate path
Message-ID: <20121210020956.GN15784@dastard>
References: <20121208120812.755863148@bombadil.infradead.org>
	<20121208121006.286014845@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121208121006.286014845@bombadil.infradead.org>
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

On Sat, Dec 08, 2012 at 07:08:16AM -0500, Christoph Hellwig wrote:
> Call xfs_alloc_file_space or xfs_free_file_space directly from
> xfs_file_fallocate instead of going through xfs_change_file_space.
> 
> This simplified the code by removing the unessecary marshalling of the
> arguments into an xfs_flock64_t structure and allows removing checks that
> are already done in the VFS code.

.....

>  			goto out_unlock;
> +		setprealloc = true;

You don't use this flag anywhere ;)

>  	}
>  
> -	if (file->f_flags & O_DSYNC)
> -		attr_flags |= XFS_ATTR_SYNC;
>  
> -	error = -xfs_change_file_space(ip, cmd, &bf, 0, attr_flags);
> +	tp = xfs_trans_alloc(ip->i_mount, XFS_TRANS_WRITEID);
> +	error = xfs_trans_reserve(tp, 0, XFS_WRITEID_LOG_RES(ip->i_mount),
> +				  0, 0, 0);
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
> +
> +	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	if (file->f_flags & O_DSYNC)
> +		xfs_trans_set_sync(tp);
> +	error = xfs_trans_commit(tp, 0);

While I like most of this series, I don't really like the
duplication of this piece of code. It seems to me that a simple
helper like:

int
xfs_inode_set_prealloc(
	struct xfs_inode	*ip,
	bool			set_prealloc,
	bool			clear_prealloc,
	bool			clear_sguid,
	bool			sync)

might be better, and call it from both the ioctl and fallocate
code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
