Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4SJdJNm239130 for <xfs@oss.sgi.com>; Fri, 28 May 2010 14:39:19 -0500
Subject: Re: [PATCH] xfs: improve xfs_isilocked
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100527190533.GB16102@infradead.org>
References: <20100527190533.GB16102@infradead.org>
Date: Fri, 28 May 2010 14:40:53 -0500
Message-ID: <1275075653.2302.38.camel@doink>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 2010-05-27 at 15:05 -0400, Christoph Hellwig wrote:
> Use rwsem_is_locked to make the assertations for shared locks work.

So you're changing it so it answers "yes it's locked"
even it it's only a read lock now, right?

Previously it was basically (once each for ilock and
iolock):  "If the exclusive flag is set, but there is no
writer, then it is not locked; otherwise it is."

Now it's "If the exclusive flag is set, but no writer,
it's not locked.  Otherwise if the shared flag is
set it's locked if rwsem_is_locked() says we are.
Otherwise (ASSERT(0) and) it is not locked."

That last part is wrong I think.  It should be OK to
call xfs_isilocked() with neither flag set, in which
case the result should be 0.  And if the exclusive
flag is set, and there *is* a writer, it *is* locked,
so it should return 1.

					-Alex

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_iget.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iget.c	2010-05-25 11:40:59.216005587 +0200
> +++ xfs/fs/xfs/xfs_iget.c	2010-05-27 20:59:09.244004330 +0200
> @@ -740,30 +738,24 @@ xfs_ilock_demote(
>  }
>  
>  #ifdef DEBUG
> -/*
> - * Debug-only routine, without additional rw_semaphore APIs, we can
> - * now only answer requests regarding whether we hold the lock for write
> - * (reader state is outside our visibility, we only track writer state).
> - *
> - * Note: this means !xfs_isilocked would give false positives, so don't do that.
> - */
>  int
>  xfs_isilocked(
>  	xfs_inode_t		*ip,
>  	uint			lock_flags)
>  {
> -	if ((lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) ==
> -			XFS_ILOCK_EXCL) {
> -		if (!ip->i_lock.mr_writer)
> -			return 0;
> +	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
> +		if (!(lock_flags & XFS_ILOCK_SHARED))
> +			return !!ip->i_lock.mr_writer;
> +		return rwsem_is_locked(&ip->i_lock.mr_lock);
>  	}
>  
> -	if ((lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) ==
> -			XFS_IOLOCK_EXCL) {
> -		if (!ip->i_iolock.mr_writer)
> -			return 0;
> +	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
> +		if (!(lock_flags & XFS_IOLOCK_SHARED))
> +			return !!ip->i_iolock.mr_writer;
> +		return rwsem_is_locked(&ip->i_iolock.mr_lock);
>  	}
>  
> -	return 1;
> +	ASSERT(0);
> +	return 0;
>  }
>  #endif
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
