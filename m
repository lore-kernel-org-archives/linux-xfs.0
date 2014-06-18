Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 533EE7F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 08:29:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28F90304067
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 06:29:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jrZe0ssqydRt9mwc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 06:29:14 -0700 (PDT)
Date: Wed, 18 Jun 2014 09:29:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: refine the allocation stack switch
Message-ID: <20140618132906.GB57367@bfoster.bfoster>
References: <1403081741-4596-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1403081741-4596-1-git-send-email-david@fromorbit.com>
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

On Wed, Jun 18, 2014 at 06:55:41PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The allocation stack switch at xfs_bmapi_allocate() has served it's
> purpose, but is no longer a sufficient solution to the stack usage
> problem we have in the XFS allocation path.
> 
...
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c  |  4 +--
>  fs/xfs/libxfs/xfs_btree.c | 84 +++++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_bmap_util.c    | 53 ------------------------------
>  fs/xfs/xfs_bmap_util.h    |  2 --
>  4 files changed, 84 insertions(+), 59 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 56f050e..43a9744 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -249,59 +249,6 @@ xfs_bmap_rtalloc(
>  }
>  
>  /*
> - * Stack switching interfaces for allocation
> - */
> -static void
> -xfs_bmapi_allocate_worker(
> -	struct work_struct	*work)
> -{
> -	struct xfs_bmalloca	*args = container_of(work,
> -						struct xfs_bmalloca, work);
> -	unsigned long		pflags;
> -	unsigned long		new_pflags = PF_FSTRANS;
> -
> -	/*
> -	 * we are in a transaction context here, but may also be doing work
> -	 * in kswapd context, and hence we may need to inherit that state
> -	 * temporarily to ensure that we don't block waiting for memory reclaim
> -	 * in any way.
> -	 */
> -	if (args->kswapd)
> -		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
> -
> -	current_set_flags_nested(&pflags, new_pflags);
> -
> -	args->result = __xfs_bmapi_allocate(args);
> -	complete(args->done);
> -
> -	current_restore_flags_nested(&pflags, new_pflags);
> -}
> -
> -/*
> - * Some allocation requests often come in with little stack to work on. Push
> - * them off to a worker thread so there is lots of stack to use. Otherwise just
> - * call directly to avoid the context switch overhead here.
> - */
> -int
> -xfs_bmapi_allocate(
> -	struct xfs_bmalloca	*args)
> -{
> -	DECLARE_COMPLETION_ONSTACK(done);
> -
> -	if (!args->stack_switch)
> -		return __xfs_bmapi_allocate(args);

Looks like we can kill args->stack_switch up through the controlling
XFS_BMAPI_STACK_SWITCH flag. The rest of the code looks fine to me,
though I need to do some testing...

Brian

> -
> -
> -	args->done = &done;
> -	args->kswapd = current_is_kswapd();
> -	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
> -	queue_work(xfs_alloc_wq, &args->work);
> -	wait_for_completion(&done);
> -	destroy_work_on_stack(&args->work);
> -	return args->result;
> -}
> -
> -/*
>   * Check if the endoff is outside the last extent. If so the caller will grow
>   * the allocation to a stripe unit boundary.  All offsets are considered outside
>   * the end of file for an empty fork, so 1 is returned in *eof in that case.
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 075f722..5f8abb9 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -66,8 +66,6 @@ struct xfs_bmalloca {
>  int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
>  			int *committed);
>  int	xfs_bmap_rtalloc(struct xfs_bmalloca *ap);
> -int	xfs_bmapi_allocate(struct xfs_bmalloca *args);
> -int	__xfs_bmapi_allocate(struct xfs_bmalloca *args);
>  int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
>  		     int whichfork, int *eof);
>  int	xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
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
