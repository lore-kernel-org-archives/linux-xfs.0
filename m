Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41466 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731929AbeGaNax (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 09:30:53 -0400
Date: Tue, 31 Jul 2018 07:50:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/15] xfs: replace xfs_defer_ops ->dop_pending with
 on-stack list
Message-ID: <20180731115053.GG40201@bfoster>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-13-bfoster@redhat.com>
 <20180731083002.GA9242@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180731083002.GA9242@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 31, 2018 at 01:30:02AM -0700, Christoph Hellwig wrote:
> On Mon, Jul 30, 2018 at 12:45:17PM -0400, Brian Foster wrote:
> > The xfs_defer_ops ->dop_pending list is used to track active
> > deferred operations once intents are logged. These items must be
> > aborted in the event of an error. The list is populated as intents
> > are logged and items are removed as they complete (or are aborted).
> > 
> > Now that xfs_defer_finish() cancels on error, there is no need to
> > ever access ->dop_pending outside of xfs_defer_finish(). The list is
> > only ever populated after xfs_defer_finish() begins and is either
> > completed or cancelled before it returns.
> > 
> > Remove ->dop_pending from xfs_defer_ops and replace it with a local
> > list in the xfs_defer_finish() path. Pass the local list to the
> > various helpers now that it is not accessible via dfops. Note that
> > we have to check for NULL in the abort case as the final tx roll
> > occurs outside of the scope of the new local list (once the dfops
> > has completed and thus drained the list).
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c | 80 ++++++++++++++++++++-------------------
> >  fs/xfs/libxfs/xfs_defer.h |  3 +-
> >  fs/xfs/xfs_trace.h        |  1 -
> >  fs/xfs/xfs_trans.h        |  1 -
> >  4 files changed, 43 insertions(+), 42 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 66848ede62c0..6bf792e2d61b 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -174,6 +174,8 @@
> >  
> >  static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];
> >  
> > +static void __xfs_defer_cancel(struct list_head *);
> 
> Can you just move __xfs_defer_cancel up to here to avoid the
> forward declaration?
> 

I think so, I'll give it a try.

> > +
> >  /*
> >   * For each pending item in the intake list, log its intent item and the
> >   * associated extents, then add the entire intake list to the end of
> > @@ -181,7 +183,8 @@ static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];
> >   */
> >  STATIC void
> >  xfs_defer_intake_work(
> > -	struct xfs_trans		*tp)
> > +	struct xfs_trans		*tp,
> > +	struct list_head		*dop_pending)
> >  {
> >  	struct xfs_defer_ops		*dop = tp->t_dfops;
> >  	struct list_head		*li;
> > @@ -197,13 +200,14 @@ xfs_defer_intake_work(
> >  			dfp->dfp_type->log_item(tp, dfp->dfp_intent, li);
> >  	}
> >  
> > -	list_splice_tail_init(&dop->dop_intake, &dop->dop_pending);
> > +	list_splice_tail_init(&dop->dop_intake, dop_pending);
> 
> It almost seems simpler to just move the list_splice_tail_init to the
> (only) caller.
> 

Hm, yeah. I guess that changes the semantics of the function a bit. I
could rename it (and the tracepoint) to something like
xfs_defer_create_intents(), drop the dop_pending param and lift the
splice into the caller if nobody objects..?

> > @@ -292,9 +299,10 @@ xfs_defer_trans_roll(
> >  /* Do we have any work items to finish? */
> >  bool
> >  xfs_defer_has_unfinished_work(
> > -	struct xfs_trans		*tp)
> > +	struct xfs_trans		*tp,
> > +	struct list_head		*dop_pending)
> >  {
> > -	return !list_empty(&tp->t_dfops->dop_pending) ||
> > +	return !list_empty(dop_pending) ||
> >  		!list_empty(&tp->t_dfops->dop_intake);
> >  }
> 
> I'd just opencode this in the only caller that is left.

Yep, thanks.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
