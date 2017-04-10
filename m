Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753294AbdDJONy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 10:13:54 -0400
Date: Mon, 10 Apr 2017 10:13:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: fix up quotacheck buffer list error handling
Message-ID: <20170410141352.GA3991@bfoster.bfoster>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
 <1487966001-63263-2-git-send-email-bfoster@redhat.com>
 <20170410041841.GH23007@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170410041841.GH23007@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Martin Svec <martin.svec@zoner.cz>

On Mon, Apr 10, 2017 at 02:18:41PM +1000, Dave Chinner wrote:
> On Fri, Feb 24, 2017 at 02:53:19PM -0500, Brian Foster wrote:
> > The quotacheck error handling of the delwri buffer list assumes the
> > resident buffers are locked and doesn't clear the _XBF_DELWRI_Q flag
> > on the buffers that are dequeued. This can lead to assert failures
> > on buffer release and possibly other locking problems.
> > 
> > Update the error handling code to lock each buffer as it is removed
> > from the buffer list and clear the delwri queue flag.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c | 2 ++
> >  fs/xfs/xfs_qm.c  | 2 ++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index ac3b4db..e566510 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1078,6 +1078,8 @@ void
> >  xfs_buf_unlock(
> >  	struct xfs_buf		*bp)
> >  {
> > +	ASSERT(xfs_buf_islocked(bp));
> > +
> >  	XB_CLEAR_OWNER(bp);
> >  	up(&bp->b_sema);
> >  
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index b669b12..4ff993c 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1387,6 +1387,8 @@ xfs_qm_quotacheck(
> >  	while (!list_empty(&buffer_list)) {
> >  		struct xfs_buf *bp =
> >  			list_first_entry(&buffer_list, struct xfs_buf, b_list);
> > +		xfs_buf_lock(bp);
> > +		bp->b_flags &= ~_XBF_DELWRI_Q;
> >  		list_del_init(&bp->b_list);
> >  		xfs_buf_relse(bp);
> >  	}
> 
> I think that should be put in a xfs_buf_delwri_cancel() function,
> because the delwri state of a buffer is entirely internal to the
> buffer cache - they are on the buffer list as a result of a call to
> xfs_buf_delwri_queue() which hides all this internal buffer state
> from the callers. Hence the details of cancelling - as the callers
> have no idea what xfs_buf_delwri_queue() actually did - should be
> internal to the buffer cache code, too.
> 

Ok, sounds reasonable.

> And, FWIW, it looks highly suspect running this list cancelling
> code in response to an error being returned from
> xfs_buf_delwri_submit(). xfs_buf_delwri_submit consumes the buffer
> list regardless of error state returned, so having the same error
> handling for errors before submission as we do afterwards just seems
> wrong to me....
> 

We can add a new label after the list_empty() check for the post-submit
case if that is preferred. Either way seems fine to me.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
