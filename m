Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 19:29:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R2TCKB016027
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 19:29:12 -0700
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4095512CCA13
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 19:30:12 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14]) by cuda.sgi.com with ESMTP id 2QiiRcpZZdLhep2G for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 19:30:12 -0700 (PDT)
Date: Thu, 26 Jun 2008 20:30:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/6] Replace inode flush semaphore with a completion
Message-ID: <20080627023011.GC7703@parisc-linux.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214455277-6387-3-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:41:13PM +1000, Dave Chinner wrote:
> Use the new completion flush code to implement the inode
> flush lock. Removes one of the final users of semaphores
> in the XFS code base.

Let's demonstrate converting this one to completions ...

> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@ -216,7 +216,7 @@ finish_inode:
>  	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
>  	init_waitqueue_head(&ip->i_ipin_wait);
>  	atomic_set(&ip->i_pincount, 0);
> -	initnsema(&ip->i_flock, 1, "xfsfino");
> +	init_completion_flush(&ip->i_flush);

+	init_completion(&ip->i_flush);
+	complete(&ip->i_flush);

>  
>  	if (lock_flags)
>  		xfs_ilock(ip, lock_flags);
> @@ -776,25 +776,24 @@ xfs_isilocked(
>  #endif
>  
>  /*
> - * The following three routines simply manage the i_flock
> - * semaphore embedded in the inode.  This semaphore synchronizes
> - * processes attempting to flush the in-core inode back to disk.
> + * Manage the i_flush queue embedded in the inode.  This completion
> + * queue synchronizes processes attempting to flush the in-core
> + * inode back to disk.
>   */
>  void
>  xfs_iflock(xfs_inode_t *ip)
>  {
> -	psema(&(ip->i_flock), PINOD|PLTWAIT);
> +	completion_flush_start(&ip->i_flush);

+	wait_for_completion(&ip->i_flush);

>  }
>  
>  int
>  xfs_iflock_nowait(xfs_inode_t *ip)
>  {
> -	return (cpsema(&(ip->i_flock)));
> +	return completion_flush_start_nowait(&ip->i_flush);

This is where you need a new function ...

+	return nowait_for_completion(&ip->i_flush);

Yes, we probably need a better name for the down_trylock() equivalent.

>  }
>  
>  void
>  xfs_ifunlock(xfs_inode_t *ip)
>  {
> -	ASSERT(issemalocked(&(ip->i_flock)));
> -	vsema(&(ip->i_flock));
> +	complete(&ip->i_flush);

Yep.

>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index bedc661..81e2040 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2630,7 +2630,6 @@ xfs_idestroy(
>  		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
>  	mrfree(&ip->i_lock);
>  	mrfree(&ip->i_iolock);
> -	freesema(&ip->i_flock);
>  
>  #ifdef XFS_INODE_TRACE
>  	ktrace_free(ip->i_trace);
> @@ -3048,10 +3047,10 @@ cluster_corrupt_out:
>  /*
>   * xfs_iflush() will write a modified inode's changes out to the
>   * inode's on disk home.  The caller must have the inode lock held
> - * in at least shared mode and the inode flush semaphore must be
> - * held as well.  The inode lock will still be held upon return from
> + * in at least shared mode and the inode flush completion must be
> + * active as well.  The inode lock will still be held upon return from
>   * the call and the caller is free to unlock it.
> - * The inode flush lock will be unlocked when the inode reaches the disk.
> + * The inode flush will be completed when the inode reaches the disk.
>   * The flags indicate how the inode's buffer should be written out.
>   */
>  int
> @@ -3070,7 +3069,7 @@ xfs_iflush(
>  	XFS_STATS_INC(xs_iflush_count);
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> -	ASSERT(issemalocked(&(ip->i_flock)));
> +	ASSERT(completion_flush_inprogress(&ip->i_flush));

is_complete()?

>  	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
>  	       ip->i_d.di_nextents > ip->i_df.if_ext_max);

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
