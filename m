Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43440 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934517AbeEIOvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 10:51:51 -0400
Date: Wed, 9 May 2018 07:51:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/9] xfs: add tracing to high level transaction operations
Message-ID: <20180509145147.GJ11261@magnolia>
References: <20180508034202.10136-1-david@fromorbit.com>
 <20180508034202.10136-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508034202.10136-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 01:41:55PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because currently we have no idea what the transaction context we
> are operating in is, and I need to know that information to track
> down bugs in multiple log item joins to transactions.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log_cil.c |  1 +
>  fs/xfs/xfs_trace.h   | 37 +++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trans.c   | 20 +++++++++++++++++++-
>  3 files changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 4668403b1741..a8675c631438 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1013,6 +1013,7 @@ xfs_log_commit_cil(
>  		*commit_lsn = xc_commit_lsn;
>  
>  	xfs_log_done(mp, tp->t_ticket, NULL, regrant);
> +	tp->t_ticket = NULL;
>  	xfs_trans_unreserve_and_mod_sb(tp);
>  
>  	/*
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 7f4d961fae12..8136f2280173 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3346,6 +3346,43 @@ TRACE_EVENT(xfs_trans_resv_calc,
>  		  __entry->logflags)
>  );
>  
> +DECLARE_EVENT_CLASS(xfs_trans_class,
> +	TP_PROTO(struct xfs_trans *tp, unsigned long caller_ip),
> +	TP_ARGS(tp, caller_ip),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(uint32_t, tid)
> +		__field(uint32_t, flags)
> +		__field(unsigned long, caller_ip)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = tp->t_mountp->m_super->s_dev;
> +		__entry->tid = 0;
> +		if (tp->t_ticket)
> +			__entry->tid = tp->t_ticket->t_tid;
> +		__entry->flags = tp->t_flags;
> +		__entry->caller_ip = caller_ip;
> +	),
> +	TP_printk("dev %d:%d trans %x flags 0x%x caller %pS",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->tid,
> +		  __entry->flags,
> +		  (char *)__entry->caller_ip)
> +)
> +
> +#define DEFINE_TRANS_EVENT(name) \
> +DEFINE_EVENT(xfs_trans_class, name, \
> +	TP_PROTO(struct xfs_trans *tp, unsigned long caller_ip), \
> +	TP_ARGS(tp, caller_ip))
> +DEFINE_TRANS_EVENT(xfs_trans_alloc);
> +DEFINE_TRANS_EVENT(xfs_trans_cancel);
> +DEFINE_TRANS_EVENT(xfs_trans_commit);
> +DEFINE_TRANS_EVENT(xfs_trans_dup);
> +DEFINE_TRANS_EVENT(xfs_trans_free);
> +DEFINE_TRANS_EVENT(xfs_trans_roll);
> +DEFINE_TRANS_EVENT(xfs_trans_add_item);
> +DEFINE_TRANS_EVENT(xfs_trans_free_items);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index c6a2a3cb9df5..24744915357b 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -79,6 +79,7 @@ xfs_trans_free(
>  	xfs_extent_busy_sort(&tp->t_busy);
>  	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
>  
> +	trace_xfs_trans_free(tp, _RET_IP_);
>  	atomic_dec(&tp->t_mountp->m_active_trans);
>  	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_end_intwrite(tp->t_mountp->m_super);
> @@ -100,6 +101,8 @@ xfs_trans_dup(
>  {
>  	xfs_trans_t	*ntp;
>  
> +	trace_xfs_trans_dup(tp, _RET_IP_);
> +
>  	ntp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
>  
>  	/*
> @@ -283,6 +286,8 @@ xfs_trans_alloc(
>  		return error;
>  	}
>  
> +	trace_xfs_trans_alloc(tp, _RET_IP_);
> +
>  	*tpp = tp;
>  	return 0;
>  }
> @@ -749,6 +754,8 @@ xfs_trans_add_item(
>  	list_add_tail(&lidp->lid_trans, &tp->t_items);
>  
>  	lip->li_desc = lidp;
> +
> +	trace_xfs_trans_add_item(tp, _RET_IP_);
>  }
>  
>  STATIC void
> @@ -782,6 +789,8 @@ xfs_trans_free_items(
>  {
>  	struct xfs_log_item_desc *lidp, *next;
>  
> +	trace_xfs_trans_free_items(tp, _RET_IP_);
> +
>  	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
>  		struct xfs_log_item	*lip = lidp->lid_item;
>  
> @@ -936,6 +945,8 @@ __xfs_trans_commit(
>  	int			error = 0;
>  	int			sync = tp->t_flags & XFS_TRANS_SYNC;
>  
> +	trace_xfs_trans_commit(tp, _RET_IP_);
> +
>  	/*
>  	 * If there is nothing to be logged by the transaction,
>  	 * then unlock all of the items associated with the
> @@ -991,6 +1002,7 @@ __xfs_trans_commit(
>  		commit_lsn = xfs_log_done(mp, tp->t_ticket, NULL, regrant);
>  		if (commit_lsn == -1 && !error)
>  			error = -EIO;
> +		tp->t_ticket = NULL;
>  	}
>  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>  	xfs_trans_free_items(tp, NULLCOMMITLSN, !!error);
> @@ -1022,6 +1034,8 @@ xfs_trans_cancel(
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	bool			dirty = (tp->t_flags & XFS_TRANS_DIRTY);
>  
> +	trace_xfs_trans_cancel(tp, _RET_IP_);
> +
>  	/*
>  	 * See if the caller is relying on us to shut down the
>  	 * filesystem.  This happens in paths where we detect
> @@ -1042,8 +1056,10 @@ xfs_trans_cancel(
>  	xfs_trans_unreserve_and_mod_sb(tp);
>  	xfs_trans_unreserve_and_mod_dquots(tp);
>  
> -	if (tp->t_ticket)
> +	if (tp->t_ticket) {
>  		xfs_log_done(mp, tp->t_ticket, NULL, false);
> +		tp->t_ticket = NULL;
> +	}
>  
>  	/* mark this thread as no longer being in a transaction */
>  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> @@ -1067,6 +1083,8 @@ xfs_trans_roll(
>  	struct xfs_trans_res	tres;
>  	int			error;
>  
> +	trace_xfs_trans_roll(trans, _RET_IP_);
> +
>  	/*
>  	 * Copy the critical parameters from one trans to the next.
>  	 */
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
