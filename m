Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:42616 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750934AbdDJFAU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 01:00:20 -0400
Date: Mon, 10 Apr 2017 15:00:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: push buffer of flush locked dquot to avoid
 quotacheck deadlock
Message-ID: <20170410050001.GI23007@dastard>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
 <1487966001-63263-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487966001-63263-3-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Martin Svec <martin.svec@zoner.cz>

On Fri, Feb 24, 2017 at 02:53:20PM -0500, Brian Foster wrote:
> Reclaim during quotacheck can lead to deadlocks on the dquot flush
> lock:
> 
>  - Quotacheck populates a local delwri queue with the physical dquot
>    buffers.
>  - Quotacheck performs the xfs_qm_dqusage_adjust() bulkstat and
>    dirties all of the dquots.
>  - Reclaim kicks in and attempts to flush a dquot whose buffer is
>    already queud on the quotacheck queue. The flush succeeds but
>    queueing to the reclaim delwri queue fails as the backing buffer is
>    already queued. The flush unlock is now deferred to I/O completion
>    of the buffer from the quotacheck queue.
>  - The dqadjust bulkstat continues and dirties the recently flushed
>    dquot once again.
>  - Quotacheck proceeds to the xfs_qm_flush_one() walk which requires
>    the flush lock to update the backing buffers with the in-core
>    recalculated values. It deadlocks on the redirtied dquot as the
>    flush lock was already acquired by reclaim, but the buffer resides
>    on the local delwri queue which isn't submitted until the end of
>    quotacheck.
> 
> This is reproduced by running quotacheck on a filesystem with a
> couple million inodes in low memory (512MB-1GB) situations. This is
> a regression as of commit 43ff2122e6 ("xfs: on-stack delayed write
> buffer lists"), which removed a trylock and buffer I/O submission
> from the quotacheck dquot flush sequence.
> 
> Quotacheck first resets and collects the physical dquot buffers in a
> delwri queue. Then, it traverses the filesystem inodes via bulkstat,
> updates the in-core dquots, flushes the corrected dquots to the
> backing buffers and finally submits the delwri queue for I/O. Since
> the backing buffers are queued across the entire quotacheck
> operation, dquot reclaim cannot possibly complete a dquot flush
> before quotacheck completes.
> 
> Therefore, quotacheck must submit the buffer for I/O in order to
> cycle the flush lock and flush the dirty in-core dquot to the
> buffer. Add a delwri queue buffer push mechanism to submit an
> individual buffer for I/O without losing the delwri queue status and
> use it from quotacheck to avoid the deadlock. This restores
> quotacheck behavior to as before the regression was introduced.

While it may fix the problem, the solution gives me the heebee
jeebees. I'm on holidays, so I haven't bothered to spend the hours
necessary to answer these questions, but to give you an idea, this
was what I thought as I read the patch.  i.e. I have concerns about
whether....

> Reported-by: Martin Svec <martin.svec@zoner.cz>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf.c   | 37 +++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_buf.h   |  1 +
>  fs/xfs/xfs_qm.c    | 28 +++++++++++++++++++++++++++-
>  fs/xfs/xfs_trace.h |  1 +
>  4 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e566510..e97cf56 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2011,6 +2011,43 @@ xfs_buf_delwri_submit(
>  	return error;
>  }
>  
> +int
> +xfs_buf_delwri_pushbuf(
> +	struct xfs_buf		*bp,
> +	struct list_head	*buffer_list)
> +{
> +	LIST_HEAD		(submit_list);
> +	int			error;
> +
> +	ASSERT(xfs_buf_islocked(bp));
> +	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
> +
> +	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
> +
> +	/*
> +	 * Move the buffer to an empty list and submit. Pass the original list
> +	 * as the wait list so delwri submission moves the buf back to it before
> +	 * it is submitted (and thus before it is unlocked). This means the
> +	 * buffer cannot be placed on another list while we wait for it.
> +	 */
> +	list_move(&bp->b_list, &submit_list);
> +	xfs_buf_unlock(bp);

.... this is safe/racy as we may have just moved it off the delwri
queue without changing state, reference counts, etc?

> +
> +	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);

.... using a caller supplied delwri buffer list as the buffer IO
wait list destination is making big assumptions about the internal
use of the wait list? e.g that xfs_buf_delwri_submit_buffers() does
not initialise the list_head before use...

.... we should be doing IO submission while holding other things on
the delwri list and unknown caller locks?

.... we have all the buffer reference counts we need to make this
work correctly?

> +	/*
> +	 * Lock the buffer to wait for I/O completion. It's already held on the
> +	 * original list, so all we have to do is reset the delwri queue flag
> +	 * that was cleared by delwri submission.
> +	 */
> +	xfs_buf_lock(bp);
> +	error = bp->b_error;
> +	bp->b_flags |= _XBF_DELWRI_Q;
> +	xfs_buf_unlock(bp);

.... this is racy w.r.t. the buffer going back onto the
buffer list without holding the buffer lock, or that the
_XBF_DELWRI_Q setting/clearing is not atomic w.r.t. the delwri queue
manipulations (i.e. can now be on the delwri list but not have
_XBF_DELWRI_Q set)?

.... the error is left on the buffer so it gets tripped over when
it is next accessed?

.... that the buffer locking is unbalanced for some undocumented
reason?

> +	return error;
> +}
> +
>  int __init
>  xfs_buf_init(void)
>  {
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 8a9d3a9..cd74216 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -334,6 +334,7 @@ extern void xfs_buf_stale(struct xfs_buf *bp);
>  extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
>  extern int xfs_buf_delwri_submit(struct list_head *);
>  extern int xfs_buf_delwri_submit_nowait(struct list_head *);
> +extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
>  
>  /* Buffer Daemon Setup Routines */
>  extern int xfs_buf_init(void);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 4ff993c..3815ed3 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1247,6 +1247,7 @@ xfs_qm_flush_one(
>  	struct xfs_dquot	*dqp,
>  	void			*data)
>  {
> +	struct xfs_mount	*mp = dqp->q_mount;
>  	struct list_head	*buffer_list = data;
>  	struct xfs_buf		*bp = NULL;
>  	int			error = 0;
> @@ -1257,7 +1258,32 @@ xfs_qm_flush_one(
>  	if (!XFS_DQ_IS_DIRTY(dqp))
>  		goto out_unlock;
>  
> -	xfs_dqflock(dqp);
> +	/*
> +	 * The only way the dquot is already flush locked by the time quotacheck
> +	 * gets here is if reclaim flushed it before the dqadjust walk dirtied
> +	 * it for the final time. Quotacheck collects all dquot bufs in the
> +	 * local delwri queue before dquots are dirtied, so reclaim can't have
> +	 * possibly queued it for I/O. The only way out is to push the buffer to
> +	 * cycle the flush lock.
> +	 */
> +	if (!xfs_dqflock_nowait(dqp)) {
> +		/* buf is pinned in-core by delwri list */
> +		DEFINE_SINGLE_BUF_MAP(map, dqp->q_blkno,
> +				      mp->m_quotainfo->qi_dqchunklen);
> +		bp = _xfs_buf_find(mp->m_ddev_targp, &map, 1, 0, NULL);
> +		if (!bp) {
> +			error = -EINVAL;
> +			goto out_unlock;
> +		}
> +
> +		/* delwri_pushbuf drops the buf lock */
> +		xfs_buf_delwri_pushbuf(bp, buffer_list);

Ummm - you threw away the returned error....

> +		xfs_buf_rele(bp);

And despite the comment, I think this is simply wrong. We try really
hard to maintain balanced locking, and as such xfs_buf_relse() is
what goes along with _xfs_buf_find(). i.e. we are returned a locked
buffer with a reference by xfs_buf_find(), but xfs_buf_rele() only
drops the reference.

So if I look at this code in isolation, it looks like it leaks a
buffer lock, and now I have to go read other code to understand why
it doesn't and I'm left to wonder why it was implemented this
way....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
