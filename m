Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33889 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbeHMKZM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Aug 2018 06:25:12 -0400
Received: by mail-wm0-f66.google.com with SMTP id l2-v6so6890177wme.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Aug 2018 00:44:07 -0700 (PDT)
Date: Mon, 13 Aug 2018 09:44:04 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: remove b_last_holder & associated macros
Message-ID: <20180813074404.63xbixyxird7jrih@odin.usersys.redhat.com>
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
> ---
> 
> If I'm missing the usefulness of this, please speak up :)

The tracepoints already mention the task trying to lock/release the lock, so,
yeah, I don't see much usability for it anymore.

There is a single usage I could think of, which would be some deadlock in
xfs_buf code, and forcing a crash and reading the b_last_holder from the vmcore
would give some clue about the deadlock.
But... For this to happen, the kernel running should be compiled with debug, so,
it's not a production thing, and, if the problem could be reproduced, then,
enabling the tracepoints will do the 'same' job.

So, IMHO it's good to go.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


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

-- 
Carlos
