Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0BN6fUF008297 for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 17:06:41 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1CDE7BA86
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 15:06:39 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	smL8ypjsMZA7LfZi for <xfs@oss.sgi.com>;
	Sun, 11 Jan 2009 15:06:39 -0800 (PST)
Date: Mon, 12 Jan 2009 10:06:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] xfs: lockdep annotations for xfs_dqlock2
Message-ID: <20090111230637.GE8071@disturbed>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090109221300.520949000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109221300.520949000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Fri, Jan 09, 2009 at 05:11:08PM -0500, Christoph Hellwig wrote:
> xfs_dqlock2 locks two xfs_dquots, which is fine as it always locks the
> dquot with the lower id first.  Use mutex_lock_nested to tell lockdep 
> about this fact.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/quota/xfs_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_dquot.c	2008-12-29 11:28:54.459613573 +0100
> +++ xfs/fs/xfs/quota/xfs_dquot.c	2008-12-29 11:29:31.037738842 +0100
> @@ -1383,6 +1383,12 @@ xfs_dqunlock_nonotify(
>  	mutex_unlock(&(dqp->q_qlock));
>  }
>  
> +/*
> + * Lock two xfs_dquot structures.
> + *
> + * To avoid deadlocks we always lock the quota structure with
> + * the lowerd id first.
> + */
>  void
>  xfs_dqlock2(
>  	xfs_dquot_t	*d1,
> @@ -1393,10 +1399,10 @@ xfs_dqlock2(
>  		if (be32_to_cpu(d1->q_core.d_id) >
>  		    be32_to_cpu(d2->q_core.d_id)) {
>  			xfs_dqlock(d2);
> -			xfs_dqlock(d1);
> +			mutex_lock_nested(&d1->q_qlock, XFS_QLOCK_2ND);
>  		} else {
>  			xfs_dqlock(d1);
> -			xfs_dqlock(d2);
> +			mutex_lock_nested(&d2->q_qlock, XFS_QLOCK_2ND);

This looks a bit wierd.

Yes, xfs_dqlock() is just a wrapper around mutex_lock, but we should
be consistent here. Can you add a xfs_dqlock_nested() wrapper to do
this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
