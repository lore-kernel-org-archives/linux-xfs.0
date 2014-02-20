Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F31F77FDB
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 18:24:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6D57EAC003
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 16:24:26 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	S2q2nBOZE1NQGijp for <xfs@oss.sgi.com>;
	Wed, 19 Feb 2014 16:24:23 -0800 (PST)
Date: Thu, 20 Feb 2014 11:23:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: always do log forces via the workqueue
Message-ID: <20140220002358.GH4916@dastard>
References: <1392783402-4726-1-git-send-email-david@fromorbit.com>
	<1392783402-4726-2-git-send-email-david@fromorbit.com>
	<5304F6F6.3070007@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5304F6F6.3070007@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 19, 2014 at 01:24:54PM -0500, Brian Foster wrote:
> On 02/18/2014 11:16 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Log forces can occur deep in the call chain when we have relatively
> > little stack free. Log forces can also happen at close to the call
> > chain leaves (e.g. xfs_buf_lock()) and hence we can trigger IO from
> > places where we really don't want to add more stack overhead.
> > 
> > This stack overhead occurs because log forces do foreground CIL
> > pushes (xlog_cil_push_foreground()) rather than waking the
> > background push wq and waiting for the for the push to complete.
> > This foreground push was done to avoid confusing the CFQ Io
> > scheduler when fsync()s were issued, as it has trouble dealing with
> > dependent IOs being issued from different process contexts.
> > 
> > Avoiding blowing the stack is much more critical than performance
> > optimisations for CFQ, especially as we've been recommending against
> > the use of CFQ for XFS since 3.2 kernels were release because of
> > it's problems with multi-threaded IO workloads.
> > 
> > Hence convert xlog_cil_push_foreground() to move the push work
> > to the CIL workqueue. We already do the waiting for the push to
> > complete in xlog_cil_force_lsn(), so there's nothing else we need to
> > modify to make this work.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 39 insertions(+), 13 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index b57a8e0..7e54553 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -499,13 +499,6 @@ xlog_cil_push(
> >  	cil->xc_ctx = new_ctx;
> >  
> >  	/*
> > -	 * mirror the new sequence into the cil structure so that we can do
> > -	 * unlocked checks against the current sequence in log forces without
> > -	 * risking deferencing a freed context pointer.
> > -	 */
> > -	cil->xc_current_sequence = new_ctx->sequence;
> > -
> > -	/*
> >  	 * The switch is now done, so we can drop the context lock and move out
> >  	 * of a shared context. We can't just go straight to the commit record,
> >  	 * though - we need to synchronise with previous and future commits so
> > @@ -523,8 +516,15 @@ xlog_cil_push(
> >  	 * Hence we need to add this context to the committing context list so
> >  	 * that higher sequences will wait for us to write out a commit record
> >  	 * before they do.
> > +	 *
> > +	 * xfs_log_force_lsn requires us to mirror the new sequence into the cil
> > +	 * structure atomically with the addition of this sequence to the
> > +	 * committing list. This also ensures that we can do unlocked checks
> > +	 * against the current sequence in log forces without risking
> > +	 * deferencing a freed context pointer.
> >  	 */
> >  	spin_lock(&cil->xc_push_lock);
> > +	cil->xc_current_sequence = new_ctx->sequence;
> >  	list_add(&ctx->committing, &cil->xc_committing);
> >  	spin_unlock(&cil->xc_push_lock);
> >  	up_write(&cil->xc_ctx_lock);
> > @@ -662,8 +662,14 @@ xlog_cil_push_background(
> >  
> >  }
> >  
> > +/*
> > + * xlog_cil_push_now() is used to trigger an immediate CIL push to the sequence
> > + * number that is passed. When it returns, the work will be queued for
> > + * @push_seq, but it won't be completed. The caller is expected to do any
> > + * waiting for push_seq to complete if it is required.
> > + */
> >  static void
> > -xlog_cil_push_foreground(
> > +xlog_cil_push_now(
> >  	struct xlog	*log,
> >  	xfs_lsn_t	push_seq)
> >  {
> > @@ -688,10 +694,8 @@ xlog_cil_push_foreground(
> >  	}
> >  
> >  	cil->xc_push_seq = push_seq;
> > +	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
> >  	spin_unlock(&cil->xc_push_lock);
> > -
> > -	/* do the push now */
> > -	xlog_cil_push(log);
> >  }
> >  
> >  bool
> > @@ -795,7 +799,8 @@ xlog_cil_force_lsn(
> >  	 * xlog_cil_push() handles racing pushes for the same sequence,
> >  	 * so no need to deal with it here.
> >  	 */
> > -	xlog_cil_push_foreground(log, sequence);
> > +restart:
> > +	xlog_cil_push_now(log, sequence);
> >  
> >  	/*
> >  	 * See if we can find a previous sequence still committing.
> > @@ -803,7 +808,6 @@ xlog_cil_force_lsn(
> >  	 * before allowing the force of push_seq to go ahead. Hence block
> >  	 * on commits for those as well.
> >  	 */
> > -restart:
> >  	spin_lock(&cil->xc_push_lock);
> >  	list_for_each_entry(ctx, &cil->xc_committing, committing) {
> >  		if (ctx->sequence > sequence)
> > @@ -821,6 +825,28 @@ restart:
> >  		/* found it! */
> >  		commit_lsn = ctx->commit_lsn;
> >  	}
> > +
> > +	/*
> > +	 * The call to xlog_cil_push_now() executes the push in the background.
> > +	 * Hence by the time we have got here it our sequence may not have been
> > +	 * pushed yet. This is true if the current sequence still matches the
> > +	 * push sequence after the above wait loop and the CIL still contains
> > +	 * dirty objects.
> > +	 *
> > +	 * When the push occurs, it will empty the CIL and
> > +	 * atomically increment the currect sequence past the push sequence and
> > +	 * move it into the committing list. Of course, if the CIL is clean at
> > +	 * the time of the push, it won't have pushed the CIL at all, so in that
> > +	 * case we should try the push for this sequence again from the start
> > +	 * just in case.
> > +	 */
> > +
> > +	if (sequence == cil->xc_current_sequence &&
> > +	    !list_empty(&cil->xc_cil)) {
> > +		spin_unlock(&cil->xc_push_lock);
> > +		goto restart;
> > +	}
> > +
> 
> IIUC, the objective here is to make sure we don't leave this code path
> before the push even starts and the ctx makes it onto the committing
> list, due to xlog_cil_push_now() moving things to a workqueue.

Right.

> Given that, what's the purpose of re-executing the background push as
> opposed to restarting the wait sequence (as done previously)? It looks
> like push_now() won't queue the work again due to cil->xc_push_seq, but
> it will flush the queue and I suppose make it more likely the push
> starts. Is that the intent?

Effectively. But the other thing that it is protecting against is
that foreground push is done without holding the cil->xc_ctx_lock,
and so we can get the situation where we try a foreground push
of the current sequence, see that the CIL is empty and return
without pushing, wait for previous sequences to commit, then find
that the CIL has items on the CIL in the sequence we are supposed to
be committing.

In this case, we don't know if this occurred because the workqueue
has not started working on our push, or whether we raced on an empty
CIL, and hence we need to make sure that everything in the sequence
we are support to commit is pushed to the log.

Hence if the current sequence is dirty after we've ensure that all
prior sequences are fully checkpointed, need to go back and
push the CIL again to ensure that when we return to the caller the
CIL is checkpointed up to the point in time of the log force
occurring.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
