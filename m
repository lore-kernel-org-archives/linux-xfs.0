Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33712 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752437AbdDKOxF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 10:53:05 -0400
Date: Tue, 11 Apr 2017 10:53:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: push buffer of flush locked dquot to avoid
 quotacheck deadlock
Message-ID: <20170411145300.GA12111@bfoster.bfoster>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
 <1487966001-63263-3-git-send-email-bfoster@redhat.com>
 <20170410050001.GI23007@dastard>
 <20170410141521.GB3991@bfoster.bfoster>
 <20170410235525.GA12369@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170410235525.GA12369@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Martin Svec <martin.svec@zoner.cz>

On Tue, Apr 11, 2017 at 09:55:25AM +1000, Dave Chinner wrote:
> On Mon, Apr 10, 2017 at 10:15:21AM -0400, Brian Foster wrote:
> > On Mon, Apr 10, 2017 at 03:00:01PM +1000, Dave Chinner wrote:
> > > On Fri, Feb 24, 2017 at 02:53:20PM -0500, Brian Foster wrote:
> > > > +	/*
> > > > +	 * Move the buffer to an empty list and submit. Pass the original list
> > > > +	 * as the wait list so delwri submission moves the buf back to it before
> > > > +	 * it is submitted (and thus before it is unlocked). This means the
> > > > +	 * buffer cannot be placed on another list while we wait for it.
> > > > +	 */
> > > > +	list_move(&bp->b_list, &submit_list);
> > > > +	xfs_buf_unlock(bp);
> > > 
> > > .... this is safe/racy as we may have just moved it off the delwri
> > > queue without changing state, reference counts, etc?
> > > 
> > 
> > Racy with..?
> 
> Whatever might possibly manipulate the buffer that thinks it's on a
> specific delwri list. We've unlocked it.
> 
> As I said, I haven't spend hours thinking this all through, I'm just
> throwing out the questions I had....
> 

Ok, I'm just trying to answer them. ;)

Here, we unlock buffers after they are added to the original delwri
queue as well. So the buffer is sitting on a local delwri queue before
it is locked and it is sitting on a local delwri queue after it is
unlocked. This is the expected state for an external lookup of the
buffer to observe before delwri_submit_buffers() acquires the lock for
I/O submission.

> > The buffer is effectively still on the delwri queue here.
> > We've just replaced the caller queue with a local queue to reuse the
> > existing submission infrastructure. IOW, we've just changed the queue
> > that the buffer is on.
> 
> Yes, in theory, but it's not something we every considered would be
> done when designing the private delwri queue infrastructure...
> 

As mentioned before, this is a resurrection of an old fix, though it may
pre-date the shift of the delwri queue mechanism to a local one.

> > > > +
> > > > +	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
> > > 
> > > .... using a caller supplied delwri buffer list as the buffer IO
> > > wait list destination is making big assumptions about the internal
> > > use of the wait list? e.g that xfs_buf_delwri_submit_buffers() does
> > > not initialise the list_head before use...
> > > 
> > 
> > This is the scope at which the wait list is defined/initialized.
> 
> It is now - passing in a list that is not empty effectively prevents
> us from implementing anything differently in future....
> 

This is nothing more than an implementation detail. It simply optimizes
away an additional list on the stack. It exists purely because it is
safe to do with the current code and can be trivially factored away
either now or if the code demands it in the future.

> > E.g.,
> > _delwri_submit() initializes its local wait list and passes it down for
> > _delwri_submit_buffers() to use. This basically ensures that the buffer
> > is placed back on the original delwri queue because the latter moves the
> > buffer over under lock, before it is submitted for I/O.
> 
> But xfs_buf_delwri_submit_buffers() adds a reference count to the
> buffer if it's placed on a wait list. but we just moved it back to
> the original buffer list. Now I have to look for why that works, and
> determine if that was intended behaviour or not.
> 
> i.e. _delwri_submit_buffers is being used for more than just moving
> the buffer back to the buffer list - there's reference counting
> shenanigans going on here, too....
> 
> > We could probably use a local wait_list just the same if that is
> > preferred, and explicitly add the buffer back from the wait_list to the
> > original delwri queue. FWIW, it's not clear to me whether you're asking
> > about the use of the wait_list here or indicating preference.
> 
> All I'm pointing out is that I don't think the patch is a good
> solution, not what the solution should be. I haven't spent the hours
> needed to think out a proper solution.
> 
> > > .... we should be doing IO submission while holding other things on
> > > the delwri list and unknown caller locks?
> > > 
> > 
> > I'm not following... this is effectively a move/submit of a delwri queue
> > item to another delwri queue. If the delwri queue is by design a local
> > data structure then only one thread should be queue processing at a
> > time. Why would this particular action be problematic?
> 
> No, no it's not just a "list move". xfs_buf_delwri_submit_buffers()
> calls xfs_buf_submit() to start IO on the buffers passed in on the
> submit list. We're adding a new IO submission path here....
> 

Just above, I said "move/submit," which clearly refers to pushbuf() as
an aggregate of both actions. Regardless, it sounds to me that the
concern here is "is it safe to submit this I/O while we still have
things on a list?" What I'm trying to say is the notion of a private
delwri queue mechanism implies that is safe from a delwri queue
infrastructure point of view. Nothing prevents a particular context from
using multiple lists. Analysis beyond that is context dependent, and I
don't see anything in quotacheck that conflicts.

> > Technically, we could rework this into something like a
> > delwri_queue_move()/delwri_submit() sequence, but the problem with that
> > is we lose the queue-populated state of the buffer for a period of time
> > and thus somebody else (i.e., reclaim) can jump in and queue it out from
> > underneath the caller. The purpose of this mechanism is to preserve
> > original delwri queue ownership of the buffer.
> 
> Sure, I understand that, but I still don't think this is the right
> thing to be doing.
> 

Fair enough..

> > > .... we have all the buffer reference counts we need to make this
> > > work correctly?
> > > 
> > 
> > AFAICT, we follow the existing delwri queue rules with regard to locking
> > and reference counting. A buffer is queued under the buf lock and the
> > queue takes a reference on the buffer. Queue submission locks the
> > buffer, acquires a wait_list reference and moves to the wait list if one
> > is specified and submits the buffer. Buffer I/O completion drops the
> > original queue reference. If the wait_list was specified, we cycle the
> > buffer lock (to wait for I/O completion), remove from the wait_list and
> > drop the wait_list reference.
> >
> > The pushbuf() call moves the buffer to the submit_list under the buffer
> > lock, which is effectively another local delwri queue. This takes
> > ownership of the original delwri queue reference. Queue submission
> > occurs as above: the buffer is moved to the wait_list, an associated
> > wait_list reference is acquired and the buffer is submitted. I/O
> > completion drops the original delwri queue reference as before, so we
> > are in the same state as delwri_submit() up through I/O completion.
> > 
> > We again cycle the buf lock to wait on I/O completion and process an
> > error. Rather than remove from the wait_list and drop the reference,
> > however, pushbuf() has the buffer back on the original delwri queue with
> > an associated reference. The only explicit state change here is the
> > DELWRI_Q flag, which is reset.
> > 
> > So am I missing something here with regard to proper reference
> > counting..? If so, please elaborate and I'll try to dig into it.
> 
> IOWs, your abusing the waitlist reference count added deep inside
> xfs_buf_delwri_submit_buffers() to handle the fact
> that the IO submission removes the delwri queue reference count that
> the buffer had on entry to the function, but still needs on exit to
> the function.
> 
> I guarantee we'll break this in future - it's too subtle and fragile
> for core infrastructure. Also, there's no comments to explain any of
> these games being played, which makes it even less maintainable...
> 

Heh. Yeah, this is not clear from the code. We should have a comment
here to walk through the reference count semantics.

That aside... if we drop the wait_list optimization, as mentioned
earlier, we'd basically do what delwri_submit() does with the exception
of moving the buffer to a private delwri queue for submission and moving
it back to the original delwri queue (from the wait_list) after
acquiring the buffer lock (to wait on the I/O). We could even do the
moves in the caller and the only change that would be required to the
delwri queue infrastructure is effectively to export
delwri_submit_buffers() (I'd probably suggest an
xfs_buf_delwri_submit_waitlist() variant or some such instead, but that
is beside the point).

The broader point here is that this code isn't doing much fundamentally
different from the existing delwri infrastructure, certainly not enough
to qualify this as fragile and the existing mechanism as not, so I think
that is a bit over the top. Another option to consider here is that this
could all easily be refactored to open code the buffer submission from
pushbuf(), which perhaps would localize the reference count bump to the
pushbuf() function rather than reuse the delwri_submit_buffers() logic.

> 
> > > > +	/*
> > > > +	 * Lock the buffer to wait for I/O completion. It's already held on the
> > > > +	 * original list, so all we have to do is reset the delwri queue flag
> > > > +	 * that was cleared by delwri submission.
> > > > +	 */
> > > > +	xfs_buf_lock(bp);
> > > > +	error = bp->b_error;
> > > > +	bp->b_flags |= _XBF_DELWRI_Q;
> > > > +	xfs_buf_unlock(bp);
> > > 
> > > .... this is racy w.r.t. the buffer going back onto the
> > > buffer list without holding the buffer lock, or that the
> > > _XBF_DELWRI_Q setting/clearing is not atomic w.r.t. the delwri queue
> > > manipulations (i.e. can now be on the delwri list but not have
> > > _XBF_DELWRI_Q set)?
> > > 
> > 
> > The buffer has been put back on the original delwri queue (by
> > _delwri_submit_buffers()) before the lock was dropped. Using the delwri
> > queue as the wait_list does mean that the flag might not be set until
> > the delwri queue processing is done and we have returned to the caller.
> > If another delwri queue occurs, the flag may be reset but the buffer
> > cannot be added to another queue, which is what we want (as noted
> > above).
> 
> Yes, I know this is what happens. My point is that the internal
> _XBF_DELWRI_Q no longer indicates that a buffer is on a delwri queue
> (i.e. that bp->b_list is valid). IOWs, if we want to check a buffer
> is on a delwri queue, we can no longer just check the flag, we have
> to check both the flag and list_empty(bp->b_list) because they are
> no longer atomically updated.
> 

It is true that this code puts the buffer through a state where
_XBF_DELWRI_Q cannot be used to verify the buffer is on a delwri queue.
It is also true that today the absence of _XBF_DELWRI_Q cannot be used
to verify that a buffer can actually be put onto a delwri queue.

IOW, any code that truly cares about delwri queue state probably needs
to check both as it is, particularly any code that actually wants to
queue the buffer locally.

> To me this is a design rule violation, regardless of whether the
> code works or not...
> 
> > (I'm not sure why delwri_queue() returns true in that case, but that's a
> > separate issue.)
> > 
> > > .... the error is left on the buffer so it gets tripped over when
> > > it is next accessed?
> > > 
> > 
> > Same as delwri_submit(). IIUC, errors are left on buffers by design and
> > cleared on a subsequemt I/O submission.
> 
> That doesn't mean it's the right thing to do here. Think about how
> the error shold be handled in this case, don't copy something from a
> bulk IO submission interface....
> 

I'm not following what you are suggesting here.

> > > > +	/*
> > > > +	 * The only way the dquot is already flush locked by the time quotacheck
> > > > +	 * gets here is if reclaim flushed it before the dqadjust walk dirtied
> > > > +	 * it for the final time. Quotacheck collects all dquot bufs in the
> > > > +	 * local delwri queue before dquots are dirtied, so reclaim can't have
> > > > +	 * possibly queued it for I/O. The only way out is to push the buffer to
> > > > +	 * cycle the flush lock.
> > > > +	 */
> > > > +	if (!xfs_dqflock_nowait(dqp)) {
> > > > +		/* buf is pinned in-core by delwri list */
> > > > +		DEFINE_SINGLE_BUF_MAP(map, dqp->q_blkno,
> > > > +				      mp->m_quotainfo->qi_dqchunklen);
> > > > +		bp = _xfs_buf_find(mp->m_ddev_targp, &map, 1, 0, NULL);
> > > > +		if (!bp) {
> > > > +			error = -EINVAL;
> > > > +			goto out_unlock;
> > > > +		}
> > > > +
> > > > +		/* delwri_pushbuf drops the buf lock */
> > > > +		xfs_buf_delwri_pushbuf(bp, buffer_list);
> > > 
> > > Ummm - you threw away the returned error....
> > > 
> > 
> > The I/O is going to be retried, but I'll fix it to just return from
> > here.
> > 
> > > > +		xfs_buf_rele(bp);
> > > 
> > > And despite the comment, I think this is simply wrong. We try really
> > > hard to maintain balanced locking, and as such xfs_buf_relse() is
> > > what goes along with _xfs_buf_find(). i.e. we are returned a locked
> > > buffer with a reference by xfs_buf_find(), but xfs_buf_rele() only
> > > drops the reference.
> > > 
> > 
> > I'm not quite following if you are saying the locking is unbalanced or
> > it simply looks that way. If the former, can you please elaborate?
> 
> It's not obviously correct, which to me is a bug. If I read this
> code, you're forcing me to go read more code to work out why it is
> correct because it doesn't follow the expected patterns. And then
> the reader disappears down a hole for hours trying to work out how
> this code actually works.
> 

I do agree that maintaining the lock state through the pushbuf() call is
probably more clear than what the patch does currently (e.g., I agree
with your core point to justify adjusting how the locking is done here).

That said, the buffer locking in xfs_buf_delwri_pushbuf() can be
evaluated pretty quickly between reading through the former function and
xfs_buf_delwri_submit[_buffers](), if one is familiar with the delwri
queue infrastructure (which you are). So the idea that this requires
hours of validation time because the locking pattern is quirky is also a
little over the top.

> > Otherwise, we can probably have pushbuf() return with the buffer lock
> > held so the caller remains responsible for the lock and reference it
> > acquired.
> >
> > > So if I look at this code in isolation, it looks like it leaks a
> > > buffer lock, and now I have to go read other code to understand why
> > > it doesn't and I'm left to wonder why it was implemented this
> > > way....
> > > 
> > 
> > Thanks for taking the time to send feedback. FWIW, I take most of these
> > questions as "things one would have to verify in order to review this
> > patch if one were not on vacation" :P as opposed to pointing things out
> > as explicitly broken.
> 
> Keep in mind that while the code /might work/, that doesn't mean it
> can be merged. The more I look at the patch and think about it, the
> more strongly I feel that we need to "go back to the drawing board
> and try again".
> 

This is fair enough. "I don't like the approach" as a subjective
argument is more concrete (IMO) than to artificially inflate some of the
implementation details into architectural flaws. That at least saves me
the time spent working through what those arguments mean, whether they
legitimately apply to the changes made in the code and/or refactoring
the code to try and deal with what, to me, appears to mostly boil down
to confusion/complaints about code factoring (only to eventually
determine that the core argument is subjective).

> So, rather than just being a negative prick that says no and doesn't
> provide any real help, how about considering this line of
> thinking....
> 

That would certainly be more productive. This is not the only solution
I've considered, but clearly it is one of only a couple or so I'm aware
of so far that I consider any better than just leaving the code as is.
In fact, I had pretty much given up on this before Darrick happened to
pick up review of it.

> We hold the buffer locked, the dquot is locked and the dquot is
> flush locked already, right? We know the IO has not been submitted
> because we have the buffer lock and the dquot is still flush locked,
> which means /some/ dirty dquot data is already in the buffer.
> 

Essentially. The buffer is queued and the dquot flush locked by reclaim.
By the time we get to the problematic scenario, we acquire the dquot
lock and can acquire the buffer lock in response to flush lock failure.
The buffer cannot be under I/O because we hold it on the local delwri
queue.

> So why can't we just modify the dquot in the buffer?  We already
> hold all the locks needed to guarantee exclusive access to the dquot
> and buffer, and they are all we hold when we do the initial flush to
> the buffer. So why do we need to do IO to unlock the dquot flush
> lock when we could just rewrite before we submit the buffer for IO?
> 

Are you suggesting to essentially ignore the flush lock? I suppose we
could get away with this in dq_flush_one() since it is only called from
quotacheck, but we may have to kill off any assertions that expect the
flush lock in xfs_dqflush(), and perhaps refactor that code to accept a
locked buffer as a param.

I don't see anything that would break off hand, but my first reaction is
it sounds more hackish than this patch or the previous patch that just
disabled reclaim during quotacheck. In fact, if we're going to hack
around avoiding the flush lock, why not just hack up xfs_buf_submit() to
allow submission of a buffer while it remains on a delwri queue? AFAICT,
that would only require removing an assert and not clearing the flag on
I/O completion. I'm not convinced I'd post something for either
approach, but I'd have to think about it some more.

> Indeed, let's go look at inodes for an example of this, 
> xfs_ifree_cluster() to be precise:
> 
>                 /*                                                               
>                  * We obtain and lock the backing buffer first in the process    
>                  * here, as we have to ensure that any dirty inode that we       
>                  * can't get the flush lock on is attached to the buffer.        
>                  * If we scan the in-memory inodes first, then buffer IO can     
>                  * complete before we get a lock on it, and hence we may fail    
>                  * to mark all the active inodes on the buffer stale.            
>                  */                                                              
>  .....
>                 /*                                                               
>                  * Walk the inodes already attached to the buffer and mark them  
>                  * stale. These will all have the flush locks held, so an        
>                  * in-memory inode walk can't lock them. By marking them all     
>                  * stale first, we will not attempt to lock them in the loop     
>                  * below as the XFS_ISTALE flag will be set.                     
>                  */                                                              
> .....
>                 /*                                                               
>                  * For each inode in memory attempt to add it to the inode       
>                  * buffer and set it up for being staled on buffer IO            
>                  * completion.  This is safe as we've locked out tail pushing    
>                  * and flushing by locking the buffer.                           
>                  *                                                               
>                  * We have already marked every inode that was part of a         
>                  * transaction stale above, which means there is no point in     
>                  * even trying to lock them.                                     
>                  */                                                              
> 
> IOWs, what we have here is precendence for modifying the flush
> locked objects attached to a buffer after first locking the buffer.
> dquots have the same transaction/flush model as inodes, so I'm
> pretty sure this will lead to the simplest, cleanest way to avoid
> this deadlock....
> 

The simplest approach to avoid the deadlock is to disable dquot reclaim
during quotacheck. ;)

On a quick scan through the inode code, it seems the above refer to
using the buffer lock to serialize invalidation of higher level objects
based on the buffer. IOW, to ensure that we don't leave "valid" in-core
inode objects referring to an inode metadata buffer that is about to be
invalidated.

So while we do set the stale state on presumably flush locked objects
attached to the buffer here, this doesn't exactly establish precedent
for modifying flush locked content (meaning the range of the buffer that
covers the flush locked inode). But if precedent is of particular
concern, the approach with most historical precedent is probably the one
actually used in XFS to avoid this deadlock up until commit 43ff2122e6
(that is effectively implemented by this patch :/).

Brian

> 
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
