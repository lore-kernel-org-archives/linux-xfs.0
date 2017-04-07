Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25653 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932199AbdDGUHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 16:07:38 -0400
Date: Fri, 7 Apr 2017 13:07:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: push buffer of flush locked dquot to avoid
 quotacheck deadlock
Message-ID: <20170407200725.GM4874@birch.djwong.org>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
 <1487966001-63263-3-git-send-email-bfoster@redhat.com>
 <20170406223417.GJ4874@birch.djwong.org>
 <20170407120631.GB54992@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170407120631.GB54992@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Martin Svec <martin.svec@zoner.cz>, Christian Affolter <c.affolter@stepping-stone.ch>

On Fri, Apr 07, 2017 at 08:06:31AM -0400, Brian Foster wrote:
> On Thu, Apr 06, 2017 at 03:34:17PM -0700, Darrick J. Wong wrote:
> > On Fri, Feb 24, 2017 at 02:53:20PM -0500, Brian Foster wrote:
> > > Reclaim during quotacheck can lead to deadlocks on the dquot flush
> > > lock:
> > > 
> > >  - Quotacheck populates a local delwri queue with the physical dquot
> > >    buffers.
> > >  - Quotacheck performs the xfs_qm_dqusage_adjust() bulkstat and
> > >    dirties all of the dquots.
> > >  - Reclaim kicks in and attempts to flush a dquot whose buffer is
> > >    already queud on the quotacheck queue. The flush succeeds but
> > >    queueing to the reclaim delwri queue fails as the backing buffer is
> > >    already queued. The flush unlock is now deferred to I/O completion
> > >    of the buffer from the quotacheck queue.
> > 
> > <typing aloud here, trying to follow along...>
> > 
> > If I'm reading this correctly, this is the _buf_delwri_queue call
> > towards the end of the _DQ_IS_DIRTY clause in _qm_dquot_isolate?  Once
> > the dquot is flushed we fail to add it to isol->buffers because it's
> > already on quotacheck's buffer_list, which means that the
> > _buf_delwri_submit call in _qm_shrink_scan never sees our dirty dquot.
> > 
> > Therefore, the dquot doesn't get written and the flush lock stays
> > locked...
> > 
> 
> Yes, exactly.
> 
> > >  - The dqadjust bulkstat continues and dirties the recently flushed
> > >    dquot once again.
> > >  - Quotacheck proceeds to the xfs_qm_flush_one() walk which requires
> > >    the flush lock to update the backing buffers with the in-core
> > >    recalculated values. It deadlocks on the redirtied dquot as the
> > >    flush lock was already acquired by reclaim, but the buffer resides
> > >    on the local delwri queue which isn't submitted until the end of
> > >    quotacheck.
> > 
> > ...until quotacheck tries to relock it and deadlocks, like you said.
> > Ok, I think I understand the deadlock...
> > 
> 
> Yep.
> 
> > > This is reproduced by running quotacheck on a filesystem with a
> > > couple million inodes in low memory (512MB-1GB) situations. This is
> > > a regression as of commit 43ff2122e6 ("xfs: on-stack delayed write
> > > buffer lists"), which removed a trylock and buffer I/O submission
> > > from the quotacheck dquot flush sequence.
> > > 
> > > Quotacheck first resets and collects the physical dquot buffers in a
> > > delwri queue. Then, it traverses the filesystem inodes via bulkstat,
> > > updates the in-core dquots, flushes the corrected dquots to the
> > > backing buffers and finally submits the delwri queue for I/O. Since
> > > the backing buffers are queued across the entire quotacheck
> > > operation, dquot reclaim cannot possibly complete a dquot flush
> > > before quotacheck completes.
> > > 
> > > Therefore, quotacheck must submit the buffer for I/O in order to
> > > cycle the flush lock and flush the dirty in-core dquot to the
> > > buffer. Add a delwri queue buffer push mechanism to submit an
> > > individual buffer for I/O without losing the delwri queue status and
> > > use it from quotacheck to avoid the deadlock. This restores
> > > quotacheck behavior to as before the regression was introduced.
> > 
> > ...and therefore why this patch changes quotacheck to check if the
> > dquot's flush lock is already held and if so, to call
> > _buf_delwri_submit_buffers so that the io completion will unlock the
> > flush lock and try again.
> > 
> 
> Yes, though only for the specific buffer.
> 
> > When we return to _qm_flush_one, the dquot is no longer dirty and we're
> > done.  I /think/ this looks ok, though I also think I want to hear if
> > either Christian Affolter or Martin Svec have had any problems with
> > these two patches applied.  My current feeling is that this is a bit
> > late for 4.12, but I'd certainly put it in -washme for wider testing.
> > If anyone thinks this needs to happen sooner, please speak up.
> > 
> 
> The dquot is still dirty and needs to be flushed on the second go around
> (otherwise we wouldn't have needed the flush lock here on the first
> try). The issue is basically that the dquot was adjusted (dirtied) at
> some point during the bulkstat scan, reclaimed and flushed, and then
> subsequently dirtied again such that another flush is required via
> qm_flush_one(). The buffer push frees up the held flush lock so that
> final flush can proceed.

Ok.  I'd thought that the dquot could still be dirty when we got to there.

> BTW, what's the reasoning for being late to 4.12? I actually don't have
> much of an opinion which release this goes into, so I guess my question
> is more logistical due to the fact that up until recently I haven't paid
> much attention to the upstream release cycles. ;P The 4.12 merge window
> hasn't opened as we are still on 4.11-rc5, right? Is the concern then
> that the merge window is close enough that this has missed 4.12
> linux-next soak time?

We're still at least a week or two away from the merge window opening,
but I want to hear from the two bug reporters that this patch series has
made their symptoms go away, and that they've mounted enough times to be
reasonably confident that they haven't simply gotten lucky and not hit
the deadlock.  I don't know that both of those things will happen in the
time we have left, and seeing as the frequency of reports is pretty low,
it doesn't seem like we have to rush it into 4.12.

> Also, can you clarify the semantics of the -washme thing? ;) That
> doesn't necessarily mean the patch has been "merged." Rather, it might
> be suitable for the next for-next (4.13) provided nothing explodes by
> then, correct?

Yep.

> I'm also a little curious on what extra testing that entails, if any,
> though perhaps this topic is better suited by an independent thread..

Same testing as for-next gets (nightly auto group runs, ltp every now
and then, various $magic workloads); it's really just a place to land
patches that have been code reviewed but I'm not yet confident enough
about to put into for-next for the next cycle.

--D

> 
> > Sorry this one took me a while to get to. :/
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> 
> No problem. Thanks for review...
> 
> Brian
> 
> > --D
> > 
> > > Reported-by: Martin Svec <martin.svec@zoner.cz>
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_buf.c   | 37 +++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_buf.h   |  1 +
> > >  fs/xfs/xfs_qm.c    | 28 +++++++++++++++++++++++++++-
> > >  fs/xfs/xfs_trace.h |  1 +
> > >  4 files changed, 66 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index e566510..e97cf56 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -2011,6 +2011,43 @@ xfs_buf_delwri_submit(
> > >  	return error;
> > >  }
> > >  
> > > +int
> > > +xfs_buf_delwri_pushbuf(
> > > +	struct xfs_buf		*bp,
> > > +	struct list_head	*buffer_list)
> > > +{
> > > +	LIST_HEAD		(submit_list);
> > > +	int			error;
> > > +
> > > +	ASSERT(xfs_buf_islocked(bp));
> > > +	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
> > > +
> > > +	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
> > > +
> > > +	/*
> > > +	 * Move the buffer to an empty list and submit. Pass the original list
> > > +	 * as the wait list so delwri submission moves the buf back to it before
> > > +	 * it is submitted (and thus before it is unlocked). This means the
> > > +	 * buffer cannot be placed on another list while we wait for it.
> > > +	 */
> > > +	list_move(&bp->b_list, &submit_list);
> > > +	xfs_buf_unlock(bp);
> > > +
> > > +	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
> > > +
> > > +	/*
> > > +	 * Lock the buffer to wait for I/O completion. It's already held on the
> > > +	 * original list, so all we have to do is reset the delwri queue flag
> > > +	 * that was cleared by delwri submission.
> > > +	 */
> > > +	xfs_buf_lock(bp);
> > > +	error = bp->b_error;
> > > +	bp->b_flags |= _XBF_DELWRI_Q;
> > > +	xfs_buf_unlock(bp);
> > > +
> > > +	return error;
> > > +}
> > > +
> > >  int __init
> > >  xfs_buf_init(void)
> > >  {
> > > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > > index 8a9d3a9..cd74216 100644
> > > --- a/fs/xfs/xfs_buf.h
> > > +++ b/fs/xfs/xfs_buf.h
> > > @@ -334,6 +334,7 @@ extern void xfs_buf_stale(struct xfs_buf *bp);
> > >  extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
> > >  extern int xfs_buf_delwri_submit(struct list_head *);
> > >  extern int xfs_buf_delwri_submit_nowait(struct list_head *);
> > > +extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
> > >  
> > >  /* Buffer Daemon Setup Routines */
> > >  extern int xfs_buf_init(void);
> > > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > > index 4ff993c..3815ed3 100644
> > > --- a/fs/xfs/xfs_qm.c
> > > +++ b/fs/xfs/xfs_qm.c
> > > @@ -1247,6 +1247,7 @@ xfs_qm_flush_one(
> > >  	struct xfs_dquot	*dqp,
> > >  	void			*data)
> > >  {
> > > +	struct xfs_mount	*mp = dqp->q_mount;
> > >  	struct list_head	*buffer_list = data;
> > >  	struct xfs_buf		*bp = NULL;
> > >  	int			error = 0;
> > > @@ -1257,7 +1258,32 @@ xfs_qm_flush_one(
> > >  	if (!XFS_DQ_IS_DIRTY(dqp))
> > >  		goto out_unlock;
> > >  
> > > -	xfs_dqflock(dqp);
> > > +	/*
> > > +	 * The only way the dquot is already flush locked by the time quotacheck
> > > +	 * gets here is if reclaim flushed it before the dqadjust walk dirtied
> > > +	 * it for the final time. Quotacheck collects all dquot bufs in the
> > > +	 * local delwri queue before dquots are dirtied, so reclaim can't have
> > > +	 * possibly queued it for I/O. The only way out is to push the buffer to
> > > +	 * cycle the flush lock.
> > > +	 */
> > > +	if (!xfs_dqflock_nowait(dqp)) {
> > > +		/* buf is pinned in-core by delwri list */
> > > +		DEFINE_SINGLE_BUF_MAP(map, dqp->q_blkno,
> > > +				      mp->m_quotainfo->qi_dqchunklen);
> > > +		bp = _xfs_buf_find(mp->m_ddev_targp, &map, 1, 0, NULL);
> > > +		if (!bp) {
> > > +			error = -EINVAL;
> > > +			goto out_unlock;
> > > +		}
> > > +
> > > +		/* delwri_pushbuf drops the buf lock */
> > > +		xfs_buf_delwri_pushbuf(bp, buffer_list);
> > > +		xfs_buf_rele(bp);
> > > +
> > > +		error = -EAGAIN;
> > > +		goto out_unlock;
> > > +	}
> > > +
> > >  	error = xfs_qm_dqflush(dqp, &bp);
> > >  	if (error)
> > >  		goto out_unlock;
> > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > index fb7555e..c8d28a9 100644
> > > --- a/fs/xfs/xfs_trace.h
> > > +++ b/fs/xfs/xfs_trace.h
> > > @@ -365,6 +365,7 @@ DEFINE_BUF_EVENT(xfs_buf_iowait_done);
> > >  DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
> > >  DEFINE_BUF_EVENT(xfs_buf_delwri_queued);
> > >  DEFINE_BUF_EVENT(xfs_buf_delwri_split);
> > > +DEFINE_BUF_EVENT(xfs_buf_delwri_pushbuf);
> > >  DEFINE_BUF_EVENT(xfs_buf_get_uncached);
> > >  DEFINE_BUF_EVENT(xfs_buf_item_relse);
> > >  DEFINE_BUF_EVENT(xfs_buf_item_iodone_async);
> > > -- 
> > > 2.7.4
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
