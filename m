Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50138 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726801AbeGaN1g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 09:27:36 -0400
Date: Tue, 31 Jul 2018 07:47:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/15] xfs: refactor internal dfops initialization
Message-ID: <20180731114735.GA40201@bfoster>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-2-bfoster@redhat.com>
 <20180730193048.GB30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730193048.GB30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:30:48PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 30, 2018 at 12:45:06PM -0400, Brian Foster wrote:
> > The current transaction allocation code conditionally initializes
> > the ->t_dfops indirection pointer. Transaction commit/cancel check
> > the validity of the pointer to determine whether to finish/cancel
> > the internal dfops.
> > 
> > This disallows the ability to use the internal dfops list as a
> > temporary container (via xfs_trans_alloc_empty()). Refactor
> > transaction allocation to always initialize ->t_dfops and check
> > permanent reservation state on transaction commit/cancel.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_trans.c | 12 +++---------
> >  1 file changed, 3 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 7bf5c1202719..8d3b7f28b193 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -281,13 +281,7 @@ xfs_trans_alloc(
> >  	INIT_LIST_HEAD(&tp->t_items);
> >  	INIT_LIST_HEAD(&tp->t_busy);
> >  	tp->t_firstblock = NULLFSBLOCK;
> > -	/*
> > -	 * We only roll transactions with permanent log reservation. Don't init
> > -	 * ->t_dfops to skip attempts to finish or cancel an empty dfops with a
> > -	 * non-permanent res.
> > -	 */
> > -	if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES)
> > -		xfs_defer_init(tp, &tp->t_dfops_internal);
> > +	xfs_defer_init(tp, &tp->t_dfops_internal);
> >  
> >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> >  	if (error) {
> > @@ -932,7 +926,7 @@ __xfs_trans_commit(
> >  	trace_xfs_trans_commit(tp, _RET_IP_);
> >  
> >  	/* finish deferred items on final commit */
> > -	if (!regrant && tp->t_dfops) {
> > +	if (!regrant && (tp->t_flags & XFS_TRANS_PERM_LOG_RES)) {
> 
> The usage model of deferred ops is that one has to create a transaction
> with a permanent reservation, and only then start attaching deferred ops
> to the dfops inside the transaction.  It's a programming error if a
> caller tries to finish deferred ops using a non-permanent transaction,
> and prior to this patch t_dfops would be NULL and we'd blow up
> immediately in xfs_defer_add(..., tp->t_dfops, ...);
> 
> However, now that we initialize t_dfops unconditionally, won't this
> cause the above programming mistake to leak silently any incorrectly
> queued defer ops?
> 

Yeah, I'm not sure the previous behavior was really appropriate in that
regard either. I'll add the xfs_defer_add() assert suggested by
Christoph. We could also add a WARN_ON_ONCE() or something in the commit
path to make sure we never see a !perm transaction with dfops, if you
think that's useful..?

Brian

> --D
> 
> >  		error = xfs_defer_finish_noroll(&tp);
> >  		if (error) {
> >  			xfs_defer_cancel(tp);
> > @@ -1029,7 +1023,7 @@ xfs_trans_cancel(
> >  
> >  	trace_xfs_trans_cancel(tp, _RET_IP_);
> >  
> > -	if (tp->t_dfops)
> > +	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
> >  		xfs_defer_cancel(tp);
> >  
> >  	/*
> > -- 
> > 2.17.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
