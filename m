Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36422 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbeHJXxL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Aug 2018 19:53:11 -0400
Date: Fri, 10 Aug 2018 14:21:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove b_last_holder & associated macros
Message-ID: <20180810212132.GA7332@magnolia>
References: <218d81aa-7047-5f9c-11cf-495e30aa9187@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <218d81aa-7047-5f9c-11cf-495e30aa9187@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Aug 10, 2018 at 02:46:04PM -0500, Eric Sandeen wrote:
> The old lock tracking infrastructure in xfs using the b_last_holder
> field seems to only be useful if you can get into the system with a
> debugger; it seems that the existing tracepoints would be the way to
> go these days, and this old infrastructure can be removed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine to me, will test....
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> If I'm missing the usefulness of this, please speak up :)
> 
> diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
> index 583a9f539bf1..f6ffb4f248f7 100644
> --- a/fs/xfs/xfs.h
> +++ b/fs/xfs/xfs.h
> @@ -8,7 +8,6 @@
>  
>  #ifdef CONFIG_XFS_DEBUG
>  #define DEBUG 1
> -#define XFS_BUF_LOCK_TRACKING 1
>  #endif
>  
>  #ifdef CONFIG_XFS_ASSERT_FATAL
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index c641c7fa1a03..e839907e8492 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -34,16 +34,6 @@
>  
>  static kmem_zone_t *xfs_buf_zone;
>  
> -#ifdef XFS_BUF_LOCK_TRACKING
> -# define XB_SET_OWNER(bp)	((bp)->b_last_holder = current->pid)
> -# define XB_CLEAR_OWNER(bp)	((bp)->b_last_holder = -1)
> -# define XB_GET_OWNER(bp)	((bp)->b_last_holder)
> -#else
> -# define XB_SET_OWNER(bp)	do { } while (0)
> -# define XB_CLEAR_OWNER(bp)	do { } while (0)
> -# define XB_GET_OWNER(bp)	do { } while (0)
> -#endif
> -
>  #define xb_to_gfp(flags) \
>  	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : GFP_NOFS) | __GFP_NOWARN)
>  
> @@ -226,7 +216,6 @@ _xfs_buf_alloc(
>  	INIT_LIST_HEAD(&bp->b_li_list);
>  	sema_init(&bp->b_sema, 0); /* held, no waiters */
>  	spin_lock_init(&bp->b_lock);
> -	XB_SET_OWNER(bp);
>  	bp->b_target = target;
>  	bp->b_flags = flags;
>  
> @@ -1091,12 +1080,10 @@ xfs_buf_trylock(
>  	int			locked;
>  
>  	locked = down_trylock(&bp->b_sema) == 0;
> -	if (locked) {
> -		XB_SET_OWNER(bp);
> +	if (locked)
>  		trace_xfs_buf_trylock(bp, _RET_IP_);
> -	} else {
> +	else
>  		trace_xfs_buf_trylock_fail(bp, _RET_IP_);
> -	}
>  	return locked;
>  }
>  
> @@ -1118,7 +1105,6 @@ xfs_buf_lock(
>  	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
>  		xfs_log_force(bp->b_target->bt_mount, 0);
>  	down(&bp->b_sema);
> -	XB_SET_OWNER(bp);
>  
>  	trace_xfs_buf_lock_done(bp, _RET_IP_);
>  }
> @@ -1129,9 +1115,7 @@ xfs_buf_unlock(
>  {
>  	ASSERT(xfs_buf_islocked(bp));
>  
> -	XB_CLEAR_OWNER(bp);
>  	up(&bp->b_sema);
> -
>  	trace_xfs_buf_unlock(bp, _RET_IP_);
>  }
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index f04613181ca1..4e3171acd0f8 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -198,10 +198,6 @@ typedef struct xfs_buf {
>  	int			b_last_error;
>  
>  	const struct xfs_buf_ops	*b_ops;
> -
> -#ifdef XFS_BUF_LOCK_TRACKING
> -	int			b_last_holder;
> -#endif
>  } xfs_buf_t;
>  
>  /* Finding and Reading Buffers */
> 
