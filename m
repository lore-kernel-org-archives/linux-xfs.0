Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5L1M4rd207864 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 20:22:04 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 098CD1731D5E
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 18:22:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	24Djp0JeFcAzDTfG for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2011 18:22:02 -0700 (PDT)
Date: Tue, 21 Jun 2011 11:21:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: split xfs_setattr
Message-ID: <20110621012150.GK32466@dastard>
References: <20110617131519.GA2822@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110617131519.GA2822@infradead.org>
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

On Fri, Jun 17, 2011 at 09:15:20AM -0400, Christoph Hellwig wrote:
> Split up xfs_setattr into two functions, one for the complex truncate
> handling, and one for the trivial attribute updates.  Also move both
> new routines to xfs_iops.c as they are fairly Linux-specific.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. A few minor comments below.

> 
> Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2011-06-17 14:07:57.059091534 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2011-06-17 14:18:42.495725522 +0200
> @@ -39,6 +39,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_utils.h"
>  #include "xfs_vnodeops.h"
> +#include "xfs_inode_item.h"
>  #include "xfs_trace.h"
>  
>  #include <linux/capability.h>
> @@ -497,12 +498,452 @@ xfs_vn_getattr(
>  	return 0;
>  }
>  
> +int
> +xfs_setattr_simple(
> +	struct xfs_inode	*ip,
> +	struct iattr		*iattr,
> +	int			flags)
> +{

I'm not sure that xfs_setattr_simple() is the best name for this.
It's not really a simple setattr case, it's all the "all except size"
changes. Perhaps xfs_setattr_nonsize() and xfs_setattr_size()
would be a better name pair...

.....
> +
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> +	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
> +	if (error)
> +		goto error_return;
> +
> +	lock_flags = XFS_ILOCK_EXCL;
> +	xfs_ilock(ip, lock_flags);

With a slight change to the error unwind stack, you can kill the
lock_flags variable altogether - it never gets changed in the code
except for here. 

....

> +error_return:
> +	xfs_qm_dqrele(udqp);
> +	xfs_qm_dqrele(gdqp);
> +	if (tp)
> +		xfs_trans_cancel(tp, 0);
> +	if (lock_flags != 0)
> +		xfs_iunlock(ip, lock_flags);
> +	return error;

If you change it to:

error_return:
	xfs_iunlock(ip, XFS_ILOCK_EXCL);
error_free_tp:
	xfs_trans_cancel(tp, 0);
	xfs_qm_dqrele(udqp);
	xfs_qm_dqrele(gdqp);
	return error;

And jump to error_free_tp when xfs_trans_reserve() fails above,
lock_flags and the conditionals in the unwind stack go away.


> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	XFS_STATS_INC(xs_ig_attrchg);
> +
> +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +		xfs_trans_set_sync(tp);
> +
> +	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +	goto out_unlock;
> +
> +out_trans_abort:
> +	commit_flags |= XFS_TRANS_ABORT;
> +out_trans_cancel:
> +	xfs_trans_cancel(tp, commit_flags);
> +out_unlock:
> +	if (lock_flags)
> +		xfs_iunlock(ip, lock_flags);
> +	return error;
> +}

And here we never get to out_unlock without lock_flags being set, so
the conditional can be removed. I also think that the goto after the
commit call is a bit ugly. I'd prefer the none-failure case is
straight line code so it is easy to follow, and the unwind stack has
an extra jump in it. i.e.:


	if (mp->m_flags & XFS_MOUNT_WSYNC)
		xfs_trans_set_sync(tp);

	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);

out_unlock:
	xfs_iunlock(ip, lock_flags);
	return error;

out_trans_abort:
	commit_flags |= XFS_TRANS_ABORT;
out_trans_cancel:
	xfs_trans_cancel(tp, commit_flags);
	goto out_unlock;
}


Otherwise this looks like a good improvement - the setattr path has
always been a mess and difficult to follow....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
