Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbeIGStF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Sep 2018 14:49:05 -0400
Date: Fri, 7 Sep 2018 10:07:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Message-ID: <20180907140755.GC37751@bfoster>
References: <20180907015155.32559-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180907015155.32559-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, jeffm@suse.com

On Fri, Sep 07, 2018 at 11:51:55AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We've had a few reports of lockdep tripping over memory reclaim
> context vs filesystem freeze "deadlocks". They all have looked
> to be false positives on analysis, but it seems that they are
> being tripped because we take freeze references before we run
> a GFP_KERNEL allocation for the struct xfs_trans.
> 
> We can avoid this false positive vector just by re-ordering the
> operations in xfs_trans_alloc(). That is. we need allocate the
> structure before we take the freeze reference and enter the GFP_NOFS
> allocation context that follows the xfs_trans around. This prevents
> lockdep from seeing the GFP_KERNEL allocation inside the transaction
> context, and that prevents it from triggering the freeze level vs
> alloc context vs reclaim warnings.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

We have an old RHEL bug for this problem and I recall dwelling on this
exact change for a bit. I don't recall whether I just lost track of it,
there was some kind of problem or I just didn't think it worth the
change to quiet a false positive. I think the latter because I don't
remember actually testing it and don't otherwise have any notes to
suggest it's problematic in any way.

The only difference I can think of is that on a frozen fs, we'd allow
some number of transaction allocations to occur and either immediately
block on the freeze/write lock or drop into reclaim. Those instances
should be limited, however, because most user-driven operations should
block at the write level rather than the internal/transaction level.
I'll run some tests to see if anything explodes, but in the meantime
this seems reasonable to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index bedc5a5133a5..912b42f5fe4a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -259,6 +259,14 @@ xfs_trans_alloc(
>  	struct xfs_trans	*tp;
>  	int			error;
>  
> +	/*
> +	 * Allocate the handle before we do our freeze accounting and setting up
> +	 * GFP_NOFS allocation context so that we avoid lockdep false positives
> +	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
> +	 */
> +	tp = kmem_zone_zalloc(xfs_trans_zone,
> +		(flags & XFS_TRANS_NOFS) ? KM_NOFS : KM_SLEEP);
> +
>  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_start_intwrite(mp->m_super);
>  
> @@ -270,8 +278,6 @@ xfs_trans_alloc(
>  		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
>  	atomic_inc(&mp->m_active_trans);
>  
> -	tp = kmem_zone_zalloc(xfs_trans_zone,
> -		(flags & XFS_TRANS_NOFS) ? KM_NOFS : KM_SLEEP);
>  	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
>  	tp->t_flags = flags;
>  	tp->t_mountp = mp;
> -- 
> 2.17.0
> 
