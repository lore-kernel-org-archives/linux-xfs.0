Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbeCGOFy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Mar 2018 09:05:54 -0500
Date: Wed, 7 Mar 2018 09:05:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: handle inconsistent log item formatting state
 correctly
Message-ID: <20180307140552.GB22352@bfoster.bfoster>
References: <20180301223527.28626-1-david@fromorbit.com>
 <20180305144001.GA6135@bfoster.bfoster>
 <20180305221857.GF18129@dastard>
 <20180306123155.GB10982@bfoster.bfoster>
 <20180306221441.GK18129@dastard>
 <20180307011602.GA19337@bfoster.bfoster>
 <20180307021245.GV18989@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180307021245.GV18989@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Tue, Mar 06, 2018 at 06:12:45PM -0800, Darrick J. Wong wrote:
> On Tue, Mar 06, 2018 at 08:16:02PM -0500, Brian Foster wrote:
> > On Wed, Mar 07, 2018 at 09:14:41AM +1100, Dave Chinner wrote:
> > > On Tue, Mar 06, 2018 at 07:31:56AM -0500, Brian Foster wrote:
> > > > On Tue, Mar 06, 2018 at 09:18:57AM +1100, Dave Chinner wrote:
> > > > > On Mon, Mar 05, 2018 at 09:40:01AM -0500, Brian Foster wrote:
> > > > > > On Fri, Mar 02, 2018 at 09:35:27AM +1100, Dave Chinner wrote:
> > > > > > but will it ever be written back (unless some other
> > > > > > transaction modifies/commits it) if it doesn't make it to the AIL? ISTM
> > > > > > that this is a corruption vector with at least a couple different
> > > > > > interesting paths (e.g. unmount losing data or a crash -> log recovery
> > > > > > inconsistency).
> > > > > > 
> > > > > > Unless I'm mistaken in the above, I think we need to be a bit more
> > > > > > aggressive in handling this condition. We could obviously assert/warn,
> > > > > > but IMO a shutdown is appropriate given that we may have to assume that
> > > > > > clearing the dirty state made the fs inconsistent (and we already
> > > > > > shutdown for slightly more innocuous things, like tx overrun, in
> > > > > > comparison). The problem is that we need to make sure the current
> > > > > > transaction is not partially committed so we don't actually corrupt the
> > > > > > fs by shutting down, which leads to one last thought...
> > > > > > 
> > > > > > AFAICT the transaction commit path expects to handle items that are
> > > > > > either not dirty or otherwise must be logged. It looks like the earliest
> > > > > > we identify this problem is xlog_cil_alloc_shadow_bufs() after we've
> > > > > > called ->iop_size(). Any reason we couldn't handle this problem there?
> > > > > 
> > > > > Because that code can validly be passed a dirty object that ends up
> > > > > with no logged regions. IMO, shadow buffer allocation is the wrong
> > > > > place to be determining if a dirty item needs to be added to the CIL
> > > > > or not - that's the job of the formatting code....
> > > > 
> > > > I don't think the lidp dirty state necessarily means an item has logged
> > > > regions or not (and so lack of dirty regions doesn't necessarily justify
> > > > clearing the dirty flag). We still log for an invalidated buffer, for
> > > > example, and/or an item may have been dirtied by a previous transaction
> > > > and end up clean in a subsequent one.
> > > 
> > > An invalidated buffer has the BLI_STALE state, and this gets
> > > formatted into the log on commit in the buf log format structure so
> > > that log recovery can correctly cancel invalidated buffers instead
> > > of replaying them. IOWs, they *definitely* have log vectors
> > > associated with them.
> > > 
> > 
> > Yep, pretty much what I stated above.
> > 
> > > That's the thing - anything that is dirtied and needs to be written
> > > to the log will write a log item format structure into a log vector.
> > > The only time this will not occur is if the object is actually clean
> > > and a log item format structure does not need to be written. That's
> > > the case where niovecs = 0.
> > > 
> > > The only exception to this case is ordered buffers - they have a
> > > dirty lidp, but a clean log item format structure. They need a log
> > > vector structure allocated because they have to pass through the CIL
> > > into the AIL so they can be correctly ordered. But the point here is
> > > that we've passed a "dirty object that ends up with no logged
> > > regions" to the formatting code, and it's special cased this because
> > > it's been marked as an "ordered" log item.
> > > 
> > 
> > Right, and both of these fall under the categories I had listed below
> > (lidp clean or lidp dirty+ordered)...
> > 
> > > > FWIW, I think it would make sense to handle this case at format time if
> > > > it were a valid state, not so much if it isn't. I'm simply not following
> > > > how it is a valid state.
> > > 
> > > The object state is valid. putting such objects into the CIL is what
> > > is not valid, and that's where the bug is.
> > > 
> > > > AFAICT we have the following valid states at
> > > > transaction commit time:
> > > > 
> > > > - lid not dirty, lip state is a 'don't care'
> > > > - lid dirty, lip ordered, niovecs == 0
> > > > - lid dirty, lip !ordered, niovecs != 0
> > > > 
> > > > ... and anything else is essentially a bug. Am I missing some other
> > > > case?
> > > 
> > > No. We handle all 3 cases you mention above, but we must keep in
> > > mind that there's only one other case here:
> > > 
> > > - lid dirty, lip !ordered, niovecs == 0
> > > 
> > > And that's exactly the case that the code currently tries to handle
> > > and gets wrong. It leaves this log item in a bad state (dirty, but
> > > with no attached xfs_log_vec) and adds it to the CIL, and that gets
> > > tripped over later when pushing the CIL.
> > > 
> > > 
> > > That's all I'm fixing in this patch. I'm ignoring whether it's
> > > possible or not (the original code thought it necessary to handle),
> > > and if the log item format information says the object is clean,
> > > then it's clean and we should reflect that in the transaction we are
> > > committing. That's why I cleared the lid dirty flag - it's clean,
> > > and we should make sure we treat it consistently as a clean object.
> > >
> > 
> > My argument is not that it's not possible. My argument is that the
> > semantics of XFS_LID_DIRTY suggest the transaction modified the object
> > in memory. Today, that means we log a range of the object, log an
> > invalidation or order a buffer. E.g., we modify an actual metadata
> > object, dirty the item (log or order), dirty the lidp and dirty the
> > transaction. If we didn't ever modify a particular object, then there's
> > no reason to dirty it that I can see. Failing to log/order the object
> > properly doesn't justify assuming it hasn't been modified IMO, we don't
> > really know either way.
> > 
> > The way the flag is used seems to bear that out. It's set when an object
> > has been modified by a transaction. The way the flag alters behavior
> > suggests the same. Objects that have been dirtied by a transaction
> > cannot be released from that transaction and a cancel of a transaction
> > with a dirty lidp causes fs shutdown (because we dirty the transaction
> > once we dirty a lidp).
> 
> At this point your disheveled maintainer stumbles in with stale replies
> that took three days to get to him, and realizes that the crash
> mentioned in the commit message only happened if Dave's buffer range
> logging patch was applied and it miscalculated the log item size. :(
> 

;) Yeah, this originated from a bug in an under-development patch that
failed to correctly track a range to log in a buffer. This doesn't
happen in the current code, but using that bug as an example, this patch
would convert that bug from a crash/panic into a log recovery corruption
vector [1].

Obviously crashing is not good, but I think something like a shutdown
might be more appropriate.

> > > All the transaction cleanup will work correctly when it's committed
> > > and clean log items are released (and freed) because that doesn't
> > > care what the lid dirty state is, just what the log item state is...
> > > 
> > 
> > A cancel of that same transaction would shutdown the fs because it
> > dirtied (i.e., presumably modified) an object. So we can't cancel the
> > transaction for risk of corruption, we can't release the object from the
> > transaction, yet this patch proposes behavior where a commit of that
> > transaction can silently undirty the lidp, commit whatever else might be
> > in the transaction and carry on as if nothing were wrong.
> > 
> > At the very least, this is inconsistent with how this flag is used
> > everywhere else. How do you explain that?
> 
> So the state "li dirty, lip !ordered, niovecs == 0" is an invalid state,
> and this patch proposes that if we ever see this invalid state then we
> decide that no the buffer isn't dirty since there are zero iovecs.  This
> prevents the log from allocating anything for this item since there's no
> evidence of anything being dirty.
> 

Well, AFAICT we still allocate a log vector to attach to the log item
(if one doesn't exist already), but that might not be your point.
Indeed, we essentially wouldn't log anything or otherwise insert the log
item if ->iop_size() tells us there's nothing to log (or order).

> I think I'd be more comfortable with this patch if there was an ASSERT
> to that effect so that if some future patch screws up and fails to
> attach any iovecs to a dirty buffer (or sets the dirty flag without
> marking anything dirty) then it's clear that this isn't supposed to
> happen.
> 

... or if some future patch modifies a buffer and somehow dirties it
without logging it, or if the logging code breaks and fails to track a
request to log an object. ;)

Yeah, I agree on an assert as a minimum contingency.

> As for clearing LID_DIRTY, someone handed us a log item in an
> inconsistent state, so perhaps we should shut down the fs instead?  I
> get that LID_DIRTY is a flag that is a proxy for counting the iovecs,
> but if the iovec array and the flag disagree then something funny is
> going on.  Then again I guess it's mysterious if something scribbles on
> our incore log and the fs just shuts down... so I guess I'd be ok with
> clearing the flag so long as /something/ gets logged about in-memory
> state being weird even on production kernels.
> 

As I see it, it's really not so much about the log item as it is about
the implications of implicitly (partially) clearing a dirty transaction.
We definitely don't want to insert a clean (niovecs == 0, ->li_lv ==
NULL) log item into the CIL. That's part of what this patch does and
certainly makes sense.

However, what it also does is assume the transaction that set
the lidp dirty did not physically modify the associated metadata item
based on what was(n't) logged. If the metadata wasn't modified, then
everything is fine, this causes no problems and shutting down would be
overkill for what was likely a code bug to erroneously dirty a lidp. If
the metadata was modified, then the transaction commit probably corrupts
the filesystem (consider how whatever else is in the transaction may
relate to the modified/unlogged buffer).

Essentially all I'm really suggesting is an earlier error check on the
transaction during the commit process. E.g., if a lidp is dirty but
points to a clean lip, return an error rather than assume whatever bug
that lead to dirtying the lip didn't modify the in-core metadata so that
in addition to not inserting to the CIL, we also minimize risk of silent
corruption.

Brian

[1] The specific bug was a case where we create a multi-block symlink
such that each block is an independent buffer. The last buffer holds the
last byte of the symlink, but the xfs_trans_log_buf() code failed to log
that byte, which essentially means that nothing in the buffer was
logged.

If I remember all the details correctly, this resulted in the following
sequence at tx commit:

- allocate a niovecs == 0 log vector (via ->iop_size())
- the log format code skips the associated log item because niovecs == 0
	- we skip xfs_cil_prepare_item(), therefore lip->li_lv == NULL
- the log item ends up in the CIL because the lidp is dirty
- CIL push occurs sometime later, iterates the CIL log items and crashes
  into a NULL lip->li_lv

With this patch, the sequence for that same bug looks more like:

- allocate a niovecs == 0 log vector
- log format code skips the associated log item and clears the dirty
  lidp state
- the log item is not inserted to the CIL because the lidp is clean

This all seems fine from a CIL/log item perspective because all that
matters from the CIL perspective is that we don't insert the log item
with a NULL log vector. However, if we step off CIL island for a moment
and consider the bigger picture ramifications of essentially cancelling
a dirty part of the transaction in this example, I think you'll have an
idea of my question/concern. HTH.

> --D
> 
> > > > > > There's no reason to allocate a vector we already know we aren't going
> > > > > > to use (and that is clearly based on invalid parameters), after all.
> > > > > 
> > > > > Such objects still need a log vector attached to them so they can be
> > > > > processed through the CIL and entered into the AIL via the log
> > > > > vector chain.
> > > > 
> > > > Confused. This patch prevents that from happening on such objects (which
> > > > you just noted above wrt to the appropriate place to determine whether
> > > > to insert into the CIL). Hm?
> > > 
> > > See my comments about ordered buffers above. The only difference
> > > between a clean log item we should drop from the transaction and a
> > > clean log item we should consider as dirty and pass through the CIL
> > > into the AIL is the ordered flag....
> > > 
> > 
> > Sure, but that doesn't answer my question. Why does this patch allocate
> > log vectors for log items that are not going to be inserted to the CIL
> > by the committing transaction? I don't see a reason to do that
> > regardless of the validity question.
> > 
> > Brian
> > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
