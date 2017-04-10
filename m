Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753414AbdDJOPW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 10:15:22 -0400
Date: Mon, 10 Apr 2017 10:15:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: push buffer of flush locked dquot to avoid
 quotacheck deadlock
Message-ID: <20170410141521.GB3991@bfoster.bfoster>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
 <1487966001-63263-3-git-send-email-bfoster@redhat.com>
 <20170410050001.GI23007@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170410050001.GI23007@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Martin Svec <martin.svec@zoner.cz>

On Mon, Apr 10, 2017 at 03:00:01PM +1000, Dave Chinner wrote:
> On Fri, Feb 24, 2017 at 02:53:20PM -0500, Brian Foster wrote:
> > Reclaim during quotacheck can lead to deadlocks on the dquot flush
> > lock:
> > 
> >  - Quotacheck populates a local delwri queue with the physical dquot
> >    buffers.
> >  - Quotacheck performs the xfs_qm_dqusage_adjust() bulkstat and
> >    dirties all of the dquots.
> >  - Reclaim kicks in and attempts to flush a dquot whose buffer is
> >    already queud on the quotacheck queue. The flush succeeds but
> >    queueing to the reclaim delwri queue fails as the backing buffer is
> >    already queued. The flush unlock is now deferred to I/O completion
> >    of the buffer from the quotacheck queue.
> >  - The dqadjust bulkstat continues and dirties the recently flushed
> >    dquot once again.
> >  - Quotacheck proceeds to the xfs_qm_flush_one() walk which requires
> >    the flush lock to update the backing buffers with the in-core
> >    recalculated values. It deadlocks on the redirtied dquot as the
> >    flush lock was already acquired by reclaim, but the buffer resides
> >    on the local delwri queue which isn't submitted until the end of
> >    quotacheck.
> > 
> > This is reproduced by running quotacheck on a filesystem with a
> > couple million inodes in low memory (512MB-1GB) situations. This is
> > a regression as of commit 43ff2122e6 ("xfs: on-stack delayed write
> > buffer lists"), which removed a trylock and buffer I/O submission
> > from the quotacheck dquot flush sequence.
> > 
> > Quotacheck first resets and collects the physical dquot buffers in a
> > delwri queue. Then, it traverses the filesystem inodes via bulkstat,
> > updates the in-core dquots, flushes the corrected dquots to the
> > backing buffers and finally submits the delwri queue for I/O. Since
> > the backing buffers are queued across the entire quotacheck
> > operation, dquot reclaim cannot possibly complete a dquot flush
> > before quotacheck completes.
> > 
> > Therefore, quotacheck must submit the buffer for I/O in order to
> > cycle the flush lock and flush the dirty in-core dquot to the
> > buffer. Add a delwri queue buffer push mechanism to submit an
> > individual buffer for I/O without losing the delwri queue status and
> > use it from quotacheck to avoid the deadlock. This restores
> > quotacheck behavior to as before the regression was introduced.
> 
> While it may fix the problem, the solution gives me the heebee
> jeebees. I'm on holidays, so I haven't bothered to spend the hours
> necessary to answer these questions, but to give you an idea, this
> was what I thought as I read the patch.  i.e. I have concerns about
> whether....
> 

Thanks for looking at this. FWIW, this is based on a preexisting
solution prior to the commit referenced above (obviously this doesn't
mean the code is correct or that this is the best solution).

> > Reported-by: Martin Svec <martin.svec@zoner.cz>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c   | 37 +++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_buf.h   |  1 +
> >  fs/xfs/xfs_qm.c    | 28 +++++++++++++++++++++++++++-
> >  fs/xfs/xfs_trace.h |  1 +
> >  4 files changed, 66 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index e566510..e97cf56 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -2011,6 +2011,43 @@ xfs_buf_delwri_submit(
> >  	return error;
> >  }
> >  
> > +int
> > +xfs_buf_delwri_pushbuf(
> > +	struct xfs_buf		*bp,
> > +	struct list_head	*buffer_list)
> > +{
> > +	LIST_HEAD		(submit_list);
> > +	int			error;
> > +
> > +	ASSERT(xfs_buf_islocked(bp));
> > +	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
> > +
> > +	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
> > +
> > +	/*
> > +	 * Move the buffer to an empty list and submit. Pass the original list
> > +	 * as the wait list so delwri submission moves the buf back to it before
> > +	 * it is submitted (and thus before it is unlocked). This means the
> > +	 * buffer cannot be placed on another list while we wait for it.
> > +	 */
> > +	list_move(&bp->b_list, &submit_list);
> > +	xfs_buf_unlock(bp);
> 
> .... this is safe/racy as we may have just moved it off the delwri
> queue without changing state, reference counts, etc?
> 

Racy with..? The buffer is effectively still on the delwri queue here.
We've just replaced the caller queue with a local queue to reuse the
existing submission infrastructure. IOW, we've just changed the queue
that the buffer is on.

> > +
> > +	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
> 
> .... using a caller supplied delwri buffer list as the buffer IO
> wait list destination is making big assumptions about the internal
> use of the wait list? e.g that xfs_buf_delwri_submit_buffers() does
> not initialise the list_head before use...
> 

This is the scope at which the wait list is defined/initialized. E.g.,
_delwri_submit() initializes its local wait list and passes it down for
_delwri_submit_buffers() to use. This basically ensures that the buffer
is placed back on the original delwri queue because the latter moves the
buffer over under lock, before it is submitted for I/O.

We could probably use a local wait_list just the same if that is
preferred, and explicitly add the buffer back from the wait_list to the
original delwri queue. FWIW, it's not clear to me whether you're asking
about the use of the wait_list here or indicating preference.

> .... we should be doing IO submission while holding other things on
> the delwri list and unknown caller locks?
> 

I'm not following... this is effectively a move/submit of a delwri queue
item to another delwri queue. If the delwri queue is by design a local
data structure then only one thread should be queue processing at a
time. Why would this particular action be problematic?

Technically, we could rework this into something like a
delwri_queue_move()/delwri_submit() sequence, but the problem with that
is we lose the queue-populated state of the buffer for a period of time
and thus somebody else (i.e., reclaim) can jump in and queue it out from
underneath the caller. The purpose of this mechanism is to preserve
original delwri queue ownership of the buffer.

> .... we have all the buffer reference counts we need to make this
> work correctly?
> 

AFAICT, we follow the existing delwri queue rules with regard to locking
and reference counting. A buffer is queued under the buf lock and the
queue takes a reference on the buffer. Queue submission locks the
buffer, acquires a wait_list reference and moves to the wait list if one
is specified and submits the buffer. Buffer I/O completion drops the
original queue reference. If the wait_list was specified, we cycle the
buffer lock (to wait for I/O completion), remove from the wait_list and
drop the wait_list reference.

The pushbuf() call moves the buffer to the submit_list under the buffer
lock, which is effectively another local delwri queue. This takes
ownership of the original delwri queue reference. Queue submission
occurs as above: the buffer is moved to the wait_list, an associated
wait_list reference is acquired and the buffer is submitted. I/O
completion drops the original delwri queue reference as before, so we
are in the same state as delwri_submit() up through I/O completion.

We again cycle the buf lock to wait on I/O completion and process an
error. Rather than remove from the wait_list and drop the reference,
however, pushbuf() has the buffer back on the original delwri queue with
an associated reference. The only explicit state change here is the
DELWRI_Q flag, which is reset.

So am I missing something here with regard to proper reference
counting..? If so, please elaborate and I'll try to dig into it.

> > +	/*
> > +	 * Lock the buffer to wait for I/O completion. It's already held on the
> > +	 * original list, so all we have to do is reset the delwri queue flag
> > +	 * that was cleared by delwri submission.
> > +	 */
> > +	xfs_buf_lock(bp);
> > +	error = bp->b_error;
> > +	bp->b_flags |= _XBF_DELWRI_Q;
> > +	xfs_buf_unlock(bp);
> 
> .... this is racy w.r.t. the buffer going back onto the
> buffer list without holding the buffer lock, or that the
> _XBF_DELWRI_Q setting/clearing is not atomic w.r.t. the delwri queue
> manipulations (i.e. can now be on the delwri list but not have
> _XBF_DELWRI_Q set)?
> 

The buffer has been put back on the original delwri queue (by
_delwri_submit_buffers()) before the lock was dropped. Using the delwri
queue as the wait_list does mean that the flag might not be set until
the delwri queue processing is done and we have returned to the caller.
If another delwri queue occurs, the flag may be reset but the buffer
cannot be added to another queue, which is what we want (as noted
above).

(I'm not sure why delwri_queue() returns true in that case, but that's a
separate issue.)

> .... the error is left on the buffer so it gets tripped over when
> it is next accessed?
> 

Same as delwri_submit(). IIUC, errors are left on buffers by design and
cleared on a subsequemt I/O submission.

> .... that the buffer locking is unbalanced for some undocumented
> reason?
> 
> > +	return error;
> > +}
> > +
> >  int __init
> >  xfs_buf_init(void)
> >  {
> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index 8a9d3a9..cd74216 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -334,6 +334,7 @@ extern void xfs_buf_stale(struct xfs_buf *bp);
> >  extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
> >  extern int xfs_buf_delwri_submit(struct list_head *);
> >  extern int xfs_buf_delwri_submit_nowait(struct list_head *);
> > +extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
> >  
> >  /* Buffer Daemon Setup Routines */
> >  extern int xfs_buf_init(void);
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index 4ff993c..3815ed3 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1247,6 +1247,7 @@ xfs_qm_flush_one(
> >  	struct xfs_dquot	*dqp,
> >  	void			*data)
> >  {
> > +	struct xfs_mount	*mp = dqp->q_mount;
> >  	struct list_head	*buffer_list = data;
> >  	struct xfs_buf		*bp = NULL;
> >  	int			error = 0;
> > @@ -1257,7 +1258,32 @@ xfs_qm_flush_one(
> >  	if (!XFS_DQ_IS_DIRTY(dqp))
> >  		goto out_unlock;
> >  
> > -	xfs_dqflock(dqp);
> > +	/*
> > +	 * The only way the dquot is already flush locked by the time quotacheck
> > +	 * gets here is if reclaim flushed it before the dqadjust walk dirtied
> > +	 * it for the final time. Quotacheck collects all dquot bufs in the
> > +	 * local delwri queue before dquots are dirtied, so reclaim can't have
> > +	 * possibly queued it for I/O. The only way out is to push the buffer to
> > +	 * cycle the flush lock.
> > +	 */
> > +	if (!xfs_dqflock_nowait(dqp)) {
> > +		/* buf is pinned in-core by delwri list */
> > +		DEFINE_SINGLE_BUF_MAP(map, dqp->q_blkno,
> > +				      mp->m_quotainfo->qi_dqchunklen);
> > +		bp = _xfs_buf_find(mp->m_ddev_targp, &map, 1, 0, NULL);
> > +		if (!bp) {
> > +			error = -EINVAL;
> > +			goto out_unlock;
> > +		}
> > +
> > +		/* delwri_pushbuf drops the buf lock */
> > +		xfs_buf_delwri_pushbuf(bp, buffer_list);
> 
> Ummm - you threw away the returned error....
> 

The I/O is going to be retried, but I'll fix it to just return from
here.

> > +		xfs_buf_rele(bp);
> 
> And despite the comment, I think this is simply wrong. We try really
> hard to maintain balanced locking, and as such xfs_buf_relse() is
> what goes along with _xfs_buf_find(). i.e. we are returned a locked
> buffer with a reference by xfs_buf_find(), but xfs_buf_rele() only
> drops the reference.
> 

I'm not quite following if you are saying the locking is unbalanced or
it simply looks that way. If the former, can you please elaborate?

Otherwise, we can probably have pushbuf() return with the buffer lock
held so the caller remains responsible for the lock and reference it
acquired.

> So if I look at this code in isolation, it looks like it leaks a
> buffer lock, and now I have to go read other code to understand why
> it doesn't and I'm left to wonder why it was implemented this
> way....
> 

Thanks for taking the time to send feedback. FWIW, I take most of these
questions as "things one would have to verify in order to review this
patch if one were not on vacation" :P as opposed to pointing things out
as explicitly broken. As noted previously, please do point out anything
I've missed to the contrary. Otherwise, I'll plan to send another
version that includes the error and locking API fixups.

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
