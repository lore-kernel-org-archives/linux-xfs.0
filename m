Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EED4B7F47
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 07:33:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E591AC004
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 05:33:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hni4EhXk5YlLRSbo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 11 Jul 2014 05:33:57 -0700 (PDT)
Date: Fri, 11 Jul 2014 08:33:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: refine the allocation stack switch
Message-ID: <20140711123352.GB3077@laptop.bfoster>
References: <1405034779-2028-1-git-send-email-david@fromorbit.com>
	<1405034779-2028-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1405034779-2028-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 11, 2014 at 09:26:18AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bmap.c      |  4 +--
>  fs/xfs/xfs_bmap_util.c | 43 --------------------------
>  fs/xfs/xfs_bmap_util.h | 15 +++++----
>  fs/xfs/xfs_btree.c     | 84 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  4 files changed, 91 insertions(+), 55 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 935ed2b..91df8e9 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -50,12 +50,13 @@ struct xfs_bmalloca {
>  	xfs_extlen_t		total;	/* total blocks needed for xaction */
>  	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
>  	xfs_extlen_t		minleft; /* amount must be left after alloc */
> -	char			eof;	/* set if allocating past last extent */
> -	char			wasdel;	/* replacing a delayed allocation */
> -	char			userdata;/* set if is user data */
> -	char			aeof;	/* allocated space at eof */
> -	char			conv;	/* overwriting unwritten extents */
> -	char			stack_switch;
> +	bool			eof;	/* set if allocating past last extent */
> +	bool			wasdel;	/* replacing a delayed allocation */
> +	bool			userdata;/* set if is user data */
> +	bool			aeof;	/* allocated space at eof */
> +	bool			conv;	/* overwriting unwritten extents */
> +	bool			stack_switch;
> +	bool			kswapd;	/* work being done for kswapd */

Neither stack_switch nor kswapd are used any longer. Removal of
stack_switch means that the XFS_BMAPI_STACK_SWITCH flag can go away as
well.

>  	int			flags;
>  	struct completion	*done;
>  	struct work_struct	work;
> @@ -65,8 +66,6 @@ struct xfs_bmalloca {
>  int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
>  			int *committed);
>  int	xfs_bmap_rtalloc(struct xfs_bmalloca *ap);
> -int	xfs_bmapi_allocate(struct xfs_bmalloca *args);
> -int	__xfs_bmapi_allocate(struct xfs_bmalloca *args);
>  int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
>  		     int whichfork, int *eof);
>  int	xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
> diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
> index bf810c6..61168e3 100644
> --- a/fs/xfs/xfs_btree.c
> +++ b/fs/xfs/xfs_btree.c
> @@ -33,6 +33,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_cksum.h"
> +#include "xfs_alloc.h"
>  
>  /*
>   * Cursor allocation zone.
> @@ -2322,8 +2323,8 @@ error1:
>   * Return new block number and the key to its first
>   * record (to be inserted into parent).
>   */
> -STATIC int					/* error */
> -xfs_btree_split(
> +int					/* error */
> +__xfs_btree_split(

Looks like this can remain static. The rest looks Ok to me, but I'll run
some tests too.

Brian

>  	struct xfs_btree_cur	*cur,
>  	int			level,
>  	union xfs_btree_ptr	*ptrp,
> @@ -2503,6 +2504,85 @@ error0:
>  	return error;
>  }
>  
> +struct xfs_btree_split_args {
> +	struct xfs_btree_cur	*cur;
> +	int			level;
> +	union xfs_btree_ptr	*ptrp;
> +	union xfs_btree_key	*key;
> +	struct xfs_btree_cur	**curp;
> +	int			*stat;		/* success/failure */
> +	int			result;
> +	bool			kswapd;	/* allocation in kswapd context */
> +	struct completion	*done;
> +	struct work_struct	work;
> +};
> +
> +/*
> + * Stack switching interfaces for allocation
> + */
> +static void
> +xfs_btree_split_worker(
> +	struct work_struct	*work)
> +{
> +	struct xfs_btree_split_args	*args = container_of(work,
> +						struct xfs_btree_split_args, work);
> +	unsigned long		pflags;
> +	unsigned long		new_pflags = PF_FSTRANS;
> +
> +	/*
> +	 * we are in a transaction context here, but may also be doing work
> +	 * in kswapd context, and hence we may need to inherit that state
> +	 * temporarily to ensure that we don't block waiting for memory reclaim
> +	 * in any way.
> +	 */
> +	if (args->kswapd)
> +		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
> +
> +	current_set_flags_nested(&pflags, new_pflags);
> +
> +	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
> +					 args->key, args->curp, args->stat);
> +	complete(args->done);
> +
> +	current_restore_flags_nested(&pflags, new_pflags);
> +}
> +
> +/*
> + * BMBT split requests often come in with little stack to work on. Push
> + * them off to a worker thread so there is lots of stack to use. For the other
> + * btree types, just call directly to avoid the context switch overhead here.
> + */
> +STATIC int					/* error */
> +xfs_btree_split(
> +	struct xfs_btree_cur	*cur,
> +	int			level,
> +	union xfs_btree_ptr	*ptrp,
> +	union xfs_btree_key	*key,
> +	struct xfs_btree_cur	**curp,
> +	int			*stat)		/* success/failure */
> +{
> +	struct xfs_btree_split_args	args;
> +	DECLARE_COMPLETION_ONSTACK(done);
> +
> +	if (cur->bc_btnum != XFS_BTNUM_BMAP)
> +		return __xfs_btree_split(cur, level, ptrp, key, curp, stat);
> +
> +	args.cur = cur;
> +	args.level = level;
> +	args.ptrp = ptrp;
> +	args.key = key;
> +	args.curp = curp;
> +	args.stat = stat;
> +	args.done = &done;
> +	args.kswapd = current_is_kswapd();
> +	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
> +	queue_work(xfs_alloc_wq, &args.work);
> +	wait_for_completion(&done);
> +	destroy_work_on_stack(&args.work);
> +	return args.result;
> +}
> +
> +
>  /*
>   * Copy the old inode root contents into a real block and make the
>   * broot point to it.
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
