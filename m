Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752563AbdESRms (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 May 2017 13:42:48 -0400
Date: Fri, 19 May 2017 13:42:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/1] xfs: add trace points for xlog cil operations
Message-ID: <20170519174243.GA64606@bfoster.bfoster>
References: <1495075791-30366-1-git-send-email-shan.hai@oracle.com>
 <20170518123156.GB18240@bfoster.bfoster>
 <df9a5c6e-6d6f-571e-8464-58a2596e4008@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df9a5c6e-6d6f-571e-8464-58a2596e4008@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

On Fri, May 19, 2017 at 07:57:38PM +0800, Shan Hai wrote:
> 
> 
> On 2017年05月18日 20:31, Brian Foster wrote:
> > On Thu, May 18, 2017 at 10:49:51AM +0800, Shan Hai wrote:
> > > Signed-off-by: Shan Hai <shan.hai@oracle.com>
> > > ---
> > Any particular reason you're looking for these new tracepoints (i.e., a
> > commit log would be nice ;).
> 
> Sorry for the late reply.
> 
> The reason why I try to add the trace points is that when I was running
> fs_mark to stress the xfs log operations by small files I found out
> that the files/sec statistic drops from thousands to hundreds in certain
> point of time, the reason for this is probably that the ail/cil is pushing
> at the same time since the log is full and the new transactions are
> waiting for the log space to be freed.
> 
> I was hoping that tracing the cil would probably provide information for
> further analyzing the issue.
> 

Hmm, then wouldn't existing tracepoints like xfs_log_reserve or
xfs_log_grant_* be more useful for that case?

> I agree with your opinions on the patch, and how about just tracing
> the _push_cil to get start/commit lsn of the checkpoint transaction?
> 

Seems reasonable on its own, but I still don't really follow what that
is helping you with. Perhaps it is best to resolve your issue first,
then follow up with any tracepoints you found useful in practice and
provide a brief example or description of why those particular tp's were
useful.

> I have tried to push the cil in 5 seconds intervals and push ail to
> ctx->commit_lsn at the end of cil_committed but it didn't help much,
> but I am still trying :)
> 

As it is, it sounds more like you are trying to analyze a performance
problem. Perhaps you need a larger physical log or larger log buffers
(-o logbsize=...)?

Brian

> Thanks
> Shan Hai
> > > I  fs/xfs/xfs_log_cil.c | 16 +++++++++++++++-
> > >   fs/xfs/xfs_trace.h   | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >   2 files changed, 64 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > index 10309cf..f2cf0fe 100644
> > > --- a/fs/xfs/xfs_log_cil.c
> > > +++ b/fs/xfs/xfs_log_cil.c
> > > @@ -579,6 +579,8 @@
> > >   	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
> > >   					ctx->start_lsn, abort);
> > > +	trace_xlog_cil_committed(ctx->cil, ctx);
> > > +
> > FWIW, I think we tend to put these kind of function call tracepoints at
> > or towards the beginning of the associated function.
> > 
> > >   	xfs_extent_busy_sort(&ctx->busy_extents);
> > >   	xfs_extent_busy_clear(mp, &ctx->busy_extents,
> > >   			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
> > > @@ -841,6 +843,8 @@
> > >   	wake_up_all(&cil->xc_commit_wait);
> > >   	spin_unlock(&cil->xc_push_lock);
> > > +	trace_xlog_cil_push(cil, ctx);
> > > +
> > >   	/* release the hounds! */
> > >   	return xfs_log_release_iclog(log->l_mp, commit_iclog);
> > > @@ -898,7 +902,8 @@
> > >   		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
> > >   	}
> > >   	spin_unlock(&cil->xc_push_lock);
> > > -
> > > +	
> > > +	trace_xlog_cil_push_background(cil, cil->xc_ctx);
> > Whitespace damage above.
> > 
> > And do we really need the ctx information for all of these tp's? It
> > looks like some of these could be racy (i.e., _push_now()). FWIW,
> > _push_background() and _push_now() both seem like a bit of overkill to
> > me as well.
> > 
> > >   }
> > >   /*
> > > @@ -935,6 +940,8 @@
> > >   	cil->xc_push_seq = push_seq;
> > >   	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
> > >   	spin_unlock(&cil->xc_push_lock);
> > > +
> > > +	trace_xlog_cil_push_now(cil, cil->xc_ctx);
> > >   }
> > >   bool
> > > @@ -1011,6 +1018,8 @@
> > >   	 */
> > >   	xfs_trans_free_items(tp, xc_commit_lsn, false);
> > > +	trace_xfs_log_commit_cil(cil, cil->xc_ctx);
> > > +
> > >   	xlog_cil_push_background(log);
> > >   	up_read(&cil->xc_ctx_lock);
> > > @@ -1037,6 +1046,8 @@
> > >   	ASSERT(sequence <= cil->xc_current_sequence);
> > > +	trace_xlog_cil_force_lsn(cil, cil->xc_ctx);
> > > +
> > Racy (what stabilizes xc_ctx)? Also, why wouldn't we want the sequence
> > value here?
> > 
> > >   	/*
> > >   	 * check to see if we need to force out the current context.
> > >   	 * xlog_cil_push() handles racing pushes for the same sequence,
> > > @@ -1098,6 +1109,9 @@
> > >   	}
> > >   	spin_unlock(&cil->xc_push_lock);
> > > +
> > > +	trace_xlog_cil_force_lsn_exit(cil, cil->xc_ctx);
> > > +
> > >   	return commit_lsn;
> > >   	/*
> > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > index 0712eb7..8d0cb73 100644
> > > --- a/fs/xfs/xfs_trace.h
> > > +++ b/fs/xfs/xfs_trace.h
> > > @@ -37,6 +37,8 @@
> > >   struct xlog_recover_item;
> > >   struct xfs_buf_log_format;
> > >   struct xfs_inode_log_format;
> > > +struct xfs_cil;
> > > +struct xfs_cil_ctx;
> > >   struct xfs_bmbt_irec;
> > >   struct xfs_btree_cur;
> > >   struct xfs_refcount_irec;
> > > @@ -1112,6 +1114,53 @@
> > >   DEFINE_AIL_EVENT(xfs_ail_move);
> > >   DEFINE_AIL_EVENT(xfs_ail_delete);
> > > +DECLARE_EVENT_CLASS(xfs_cil_class,
> > > +	TP_PROTO(struct xfs_cil *cil, struct xfs_cil_ctx *ctx),
> > > +	TP_ARGS(cil, ctx),
> > > +	TP_STRUCT__entry(
> > > +		__field(struct xfs_cil *, cil)
> > > +		__field(xfs_lsn_t, push_seq)
> > > +		__field(xfs_lsn_t, curr_seq)
> > > +		__field(xfs_lsn_t, chkpt_seq)
> > > +		__field(xfs_lsn_t, start_lsn)
> > > +		__field(xfs_lsn_t, commit_lsn)
> > > +		__field(int, nvecs)
> > > +		__field(int, space_used)
> > > +	),
> > > +	TP_fast_assign(
> > > +		__entry->cil = cil;
> > > +		__entry->push_seq = cil->xc_push_seq;
> > > +		__entry->curr_seq = cil->xc_current_sequence;
> > > +		__entry->chkpt_seq = ctx->sequence;
> > > +		__entry->start_lsn = ctx->start_lsn;
> > > +		__entry->commit_lsn = ctx->commit_lsn;
> > > +		__entry->nvecs = ctx->nvecs;
> > > +		__entry->space_used = ctx->space_used;
> > > +	),
> > > +	TP_printk("cil 0x%p push_seq %d/%d current_seq %d/%d chkpt_seq %d/%d "
> > > +		  "start_lsn %d/%d commit_lsn %d/%d nvecs %d space_used %d",
> > > +		  __entry->cil,
> > We need to print the "dev %d:%d" major/minor pair first so the
> > tracepoints can be correlated to a specific mount.
> > 
> > Brian
> > 
> > > +		  CYCLE_LSN(__entry->push_seq), BLOCK_LSN(__entry->push_seq),
> > > +		  CYCLE_LSN(__entry->curr_seq), BLOCK_LSN(__entry->curr_seq),
> > > +		  CYCLE_LSN(__entry->chkpt_seq), BLOCK_LSN(__entry->chkpt_seq),
> > > +		  CYCLE_LSN(__entry->start_lsn), BLOCK_LSN(__entry->start_lsn),
> > > +		  CYCLE_LSN(__entry->commit_lsn),
> > > +		  BLOCK_LSN(__entry->commit_lsn),
> > > +		  __entry->nvecs, __entry->space_used)
> > > +)
> > > +
> > > +#define DEFINE_CIL_EVENT(name) \
> > > +DEFINE_EVENT(xfs_cil_class, name, \
> > > +	TP_PROTO(struct xfs_cil *cil, struct xfs_cil_ctx *ctx), \
> > > +	TP_ARGS(cil, ctx))
> > > +DEFINE_CIL_EVENT(xlog_cil_push);
> > > +DEFINE_CIL_EVENT(xlog_cil_push_now);
> > > +DEFINE_CIL_EVENT(xlog_cil_push_background);
> > > +DEFINE_CIL_EVENT(xlog_cil_force_lsn);
> > > +DEFINE_CIL_EVENT(xlog_cil_force_lsn_exit);
> > > +DEFINE_CIL_EVENT(xlog_cil_committed);
> > > +DEFINE_CIL_EVENT(xfs_log_commit_cil);
> > > +
> > >   TRACE_EVENT(xfs_log_assign_tail_lsn,
> > >   	TP_PROTO(struct xlog *log, xfs_lsn_t new_lsn),
> > >   	TP_ARGS(log, new_lsn),
> > > -- 
> > > 1.8.3.1
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
