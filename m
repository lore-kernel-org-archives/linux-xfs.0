Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C5E267F9C
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 16:21:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 429DEAC001
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 14:21:13 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EJTEzMr4TOZhsu5n for <xfs@oss.sgi.com>;
	Fri, 21 Feb 2014 14:21:11 -0800 (PST)
Date: Sat, 22 Feb 2014 09:21:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: always do log forces via the workqueue
Message-ID: <20140221222106.GQ13647@dastard>
References: <1392783402-4726-1-git-send-email-david@fromorbit.com>
	<1392783402-4726-2-git-send-email-david@fromorbit.com>
	<5304F6F6.3070007@redhat.com> <20140220002358.GH4916@dastard>
	<53076B05.8010806@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53076B05.8010806@redhat.com>
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

On Fri, Feb 21, 2014 at 10:04:37AM -0500, Brian Foster wrote:
> On 02/19/2014 07:23 PM, Dave Chinner wrote:
> > On Wed, Feb 19, 2014 at 01:24:54PM -0500, Brian Foster wrote:
> >> On 02/18/2014 11:16 PM, Dave Chinner wrote:
> >>> From: Dave Chinner <dchinner@redhat.com>
> >>>
> ...
> >>> +
> >>> +	/*
> >>> +	 * The call to xlog_cil_push_now() executes the push in the background.
> >>> +	 * Hence by the time we have got here it our sequence may not have been
> >>> +	 * pushed yet. This is true if the current sequence still matches the
> >>> +	 * push sequence after the above wait loop and the CIL still contains
> >>> +	 * dirty objects.
> >>> +	 *
> >>> +	 * When the push occurs, it will empty the CIL and
> >>> +	 * atomically increment the currect sequence past the push sequence and
> >>> +	 * move it into the committing list. Of course, if the CIL is clean at
> >>> +	 * the time of the push, it won't have pushed the CIL at all, so in that
> >>> +	 * case we should try the push for this sequence again from the start
> >>> +	 * just in case.
> >>> +	 */
> >>> +
> >>> +	if (sequence == cil->xc_current_sequence &&
> >>> +	    !list_empty(&cil->xc_cil)) {
> >>> +		spin_unlock(&cil->xc_push_lock);
> >>> +		goto restart;
> >>> +	}
> >>> +
> >>
> >> IIUC, the objective here is to make sure we don't leave this code path
> >> before the push even starts and the ctx makes it onto the committing
> >> list, due to xlog_cil_push_now() moving things to a workqueue.
> > 
> > Right.
> > 
> >> Given that, what's the purpose of re-executing the background push as
> >> opposed to restarting the wait sequence (as done previously)? It looks
> >> like push_now() won't queue the work again due to cil->xc_push_seq, but
> >> it will flush the queue and I suppose make it more likely the push
> >> starts. Is that the intent?
> > 
> > Effectively. But the other thing that it is protecting against is
> > that foreground push is done without holding the cil->xc_ctx_lock,
> > and so we can get the situation where we try a foreground push
> > of the current sequence, see that the CIL is empty and return
> > without pushing, wait for previous sequences to commit, then find
> > that the CIL has items on the CIL in the sequence we are supposed to
> > be committing.
> > 
> > In this case, we don't know if this occurred because the workqueue
> > has not started working on our push, or whether we raced on an empty
> > CIL, and hence we need to make sure that everything in the sequence
> > we are support to commit is pushed to the log.
> > 
> > Hence if the current sequence is dirty after we've ensure that all
> > prior sequences are fully checkpointed, need to go back and
> > push the CIL again to ensure that when we return to the caller the
> > CIL is checkpointed up to the point in time of the log force
> > occurring.
> > 
> 
> Ok, I see. The foreground variant checks the push sequence and xc_cil
> list state without xc_ctx_lock. The background variant (down in
> xlog_cil_push()) will repeat the list check while under xc_ctx_lock.
> 
> From what I can see, this potential behavior of a foreground push seeing
> an empty cil is possible even before this patch. xlog_cil_force_lsn()
> will just wait on all of the previous sequences and return. Another push
> can move things along for that sequence, as xc_push_seq has not been
> updated.
> 
> The workqueue pattern opens up potential for the "wait before handler
> runs" race, and the sequence and list check is necessary to detect that.
> Doing the push_now() again seems technically unnecessary, but the flush
> executes and thus should guarantee we iterate this sequence twice at
> most. Seems reasonable.
> 
> General follow up question - what makes not taking xc_ctx_lock anywhere
> in here safe in the first place? In the current implementation, if the
> push has already been queued (note that we flush before we take the
> spinlock and check the push sequence) and we get into the ctx wait
> sequence, isn't it possible to see xc_committing before the ctx we're
> pushing is even added?

The waiting is serialised on the push lock, not the context lock.

The context lock is used to serialise addition to a CIL context with
the against the pushing of that sequence. Triggering a push of a CIL
context does not need to be serialised addition to the CIL, nor
directly against the push of the CIL. A blocking push needs to be
serialised against the checkpoint of a CIL context to the iclog,
which is a different thing altogether.

Hence we don't want to use the xc_ctx_lock for this - it is already
a contended lock and we don't want to hold off commits into a new
sequence while we wait for a previous sequence to finish pushing.

Yes, there are potential races in the exist code. They are fixed by
this patch.

> With this patch, what prevents us from seeing the updated
> xc_current_sequence and thus skipping the restart (xc_current_sequence
> isn't updated under the spinlock) before the pushed ctx has been added
> to xc_committing?

The fact that the patch moves the xc_current_sequence update under
the the push_lock avoids this. i.e. it is now only updated atomically
with adding the context to the committing list. Both are now
explicitly updated at the same time, so you can't see a sequence
number greater than what you might find on the list...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
