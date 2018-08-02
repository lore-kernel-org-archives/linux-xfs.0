Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731961AbeHBN76 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Aug 2018 09:59:58 -0400
Date: Thu, 2 Aug 2018 08:09:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 12/15] xfs: replace xfs_defer_ops ->dop_pending with
 on-stack list
Message-ID: <20180802120901.GA65267@bfoster>
References: <20180801131952.60250-1-bfoster@redhat.com>
 <20180801131952.60250-13-bfoster@redhat.com>
 <20180802092913.GA6854@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180802092913.GA6854@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 02, 2018 at 02:29:13AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 01, 2018 at 09:19:49AM -0400, Brian Foster wrote:
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
> >  fs/xfs/libxfs/xfs_defer.c | 129 ++++++++++++++++++--------------------
> >  fs/xfs/libxfs/xfs_defer.h |   1 -
> >  fs/xfs/xfs_trace.h        |   5 +-
> >  fs/xfs/xfs_trans.c        |   2 +-
> >  fs/xfs/xfs_trans.h        |   1 -
> >  5 files changed, 64 insertions(+), 74 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index b656a399cd71..d811a85daf6e 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
...
> > @@ -228,7 +229,8 @@ xfs_defer_trans_abort(
> >  /* Roll a transaction so we can do some deferred op processing. */
> >  STATIC int
> >  xfs_defer_trans_roll(
> > -	struct xfs_trans		**tp)
> > +	struct xfs_trans		**tp,
> > +	struct list_head		*dop_pending)
> >  {
> >  	struct xfs_buf_log_item		*bli;
> >  	struct xfs_inode_log_item	*ili;
> > @@ -278,7 +280,7 @@ xfs_defer_trans_roll(
> >  	if (error) {
> >  		trace_xfs_defer_trans_roll_error((*tp)->t_mountp,
> >  						 (*tp)->t_dfops, error);
> > -		xfs_defer_trans_abort(*tp,  error);
> > +		xfs_defer_trans_abort(*tp,  dop_pending, error);
> 
> Can you just move this call into the caller?  That way we don't
> need to pass dop_pending at all, xfs_defer_finish can just do
> the plain shutdown instead of calling xfs_defer_trans_abort,
> we can remove the NULL dop handling from xfs_defer_trans_abort.
> In fact we could also move the shutdown out of xfs_defer_trans_abort
> entirely and stop passing the errno to it.
> 

Sure. I dropped the SHUTDOWN_META_IO_ERROR usage as well because it
reduces the churn a little bit and outside of here only seems to be used
on legitimate I/O errors.

> > -	while (xfs_defer_has_unfinished_work(*tp)) {
> > -		/* Log intents for work items sitting in the intake. */
> > -		xfs_defer_intake_work(*tp);
> > +	while (!list_empty(&dop_pending) ||
> > +	       !list_empty(&(*tp)->t_dfops->dop_intake)) {
> > +		/* log intents and pull in intake items */
> > +		xfs_defer_create_intents(*tp);
> > +		list_splice_tail_init(&(*tp)->t_dfops->dop_intake,
> > +				      &dop_pending);
> 
> Btw, it would be nice to rename tp to tpp in this function and have
> a local tp without the double indirection.  Reading the current code
> is a bit of a pain.
> 

Ok.

Brian

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
