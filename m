Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754303AbdAFOqE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Jan 2017 09:46:04 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE39131B308
        for <linux-xfs@vger.kernel.org>; Fri,  6 Jan 2017 14:45:21 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v06EjLWE000731
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jan 2017 09:45:21 -0500
Date: Fri, 6 Jan 2017 09:45:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] [RFC] Propagate error state from buffers to the objects
 attached
Message-ID: <20170106144520.GA52172@bfoster.bfoster>
References: <20170104184609.1102-1-cmaiolino@redhat.com>
 <20170105150113.GB3345@bfoster.bfoster>
 <20170106104430.gixpqeqdlhdlqxy3@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170106104430.gixpqeqdlhdlqxy3@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Fri, Jan 06, 2017 at 11:44:30AM +0100, Carlos Maiolino wrote:
> Hi,
> 
> On Thu, Jan 05, 2017 at 10:01:14AM -0500, Brian Foster wrote:
> > On Wed, Jan 04, 2017 at 07:46:09PM +0100, Carlos Maiolino wrote:
> > > Hi folks,
> > > 
> > > I've been working on a problem regarding buffers that failed to be written back
> > > not being retried as they should, because the items attached to it were flush
> > > locked.
> > > 
> > > Discussing the problem previously with Dave and Brian, Dave suggested that first
> > > we create an error propagation model, so notify items in case of a failure with
> > > the buffer.
> > > 
> > 
> > Hi Carlos,
> > 
> > Firstly, it's probably a good idea to reference the previous discussion
> > for context. That is available here:
> > 
> >   http://www.spinics.net/lists/linux-xfs/msg01018.html
> > 
> > There is some noise due to confusion between Dave and I, but the last
> > couple messages or so describe the design required to resolve the
> > problem.
> > 
> 
> Right, I tent to think that everybody remember things, my bad, I'll make sure to
> keep the history :)
> 
> 
> > > Based on that discussion, I've been playing with a prototype for this, and I
> > > thought about sending it here so I can get some extra input about the model and
> > > if I'm on the right direction (or not :)
> > > 
> > > The basic idea is to modify xfs_buf_iodone_callbacks() to trigger the iodone
> > > callbacks of the items attached to the buffer, or, in case of failure, trigger a
> > > callback to notify the items about the error, where, we can propagate the buffer
> > > error flags to the items attached to it.
> > > 
> > > Currently, we only run the callbacks in case of success or a permanent error,
> > > items are not aware of any temporary error, since no callbacks are triggered,
> > > which (in my specific case), can lead to an item to be flush locked forever.
> > > 
> > 
> > Right.. so the core issue is that log item retry (after non-permanent
> > metadata I/O failure) for flush locked items is broken. This is because
> > 1.) the first item push flush locks the object and it must remain flush
> > locked until the associated buffer makes it to disk and 2.) a subsequent
> > AIL push skips any object that is already flush locked. The example
> > we're running into is for inodes, but IIRC this problem applies to
> > xfs_dquot's as well, so we'll want to cover that with this work as well.
> > 
> 
> Yeah, I know inode items are not the only item with the problem here, my idea of
> this RFC was to get inputs about the model about how to propagate errors back to
> the item, once I have a reproducer for problems with the inodes, I believed the
> prototype only caring about xfs inode would give an idea of the model, then it
> is just a matter of duplicating it into dquots.
> 

Ok, just checking. :) (Sorry if you mentioned that somewhere and I just
missed it...).

> 
...
> > > @@ -512,6 +523,16 @@ xfs_inode_item_push(
> > >  	}
> > >  
> > >  	/*
> > > +	 * EXAMPLE:
> > > +	 *	Have we already tried to submit the buffer attached to this
> > > +	 *	inode, and has it failed?
> > > +	 */
> > > +	if (ip->i_flags & XFS_IBFAIL) {
> > > +		printk("XFS: %s: inode buffer already submitted. ino: %llu\n",
> > > +		       __func__, ip->i_ino);
> > > +	}
> > 
> > I think we only care about the new failure case when the flush lock is
> > not acquired. At that point we have to continue on and verify that the
> > buffer was marked as failed as well and then resubmit the buffer.
> 
> Yup, code above was a tentative to exemplify where we might need to use this
> model, but, sounds like an unfortunate bad example :)
> 
> Regarding about the verification if the buffer has failed or not, I don't know
> if we really need to do that there. I mean, the idea of the model is to capture
> the errors and pass it back to the log item, if we already have the log item
> (flag or callback or whatever) notified of the error, why should we need to test
> if the buffer failed or not? I mean, the log_item should be notified the buffer
> has been already failed. Am I missing something else here that I am not seeing?
> 

The XBF_WRITE_FAIL flag is going to be reset once the buffer is
resubmitted. Also note that the buffer can have multiple failed log
items, the latter being the objects that are tracked by the AIL. We may
want to reset the failed state of the items once the buffer is
resubmitted to avoid such retries.

What I'd be a little more concerned about than spurious delwri requeues
is that we don't confuse the state when the buffer and log items have
been marked failed, we detect this and retry from the AIL, the I/O fails
again and thus XBF_WRITE_FAIL is set on the buffer, but the buffer is
still undergoing the internal retry. To handle that case, I think it is
important we reset the log item flags before submission and not reset
them unless the internal retry also fails.

Even if technically all of that is possible without checking the buffer
flag state, I think it's smart from a robustness perspective to check
and warn/assert that the state matches our expectations.

Brian

> > 
> > FWIW, I think it might be a good idea to break this down into at least a
> > few patches. One to add generic error propagation infrastructure and
> > subsequent to process the error state in the appropriate log item
> > handlers.
> > 
> 
> Yes, that's the idea as I wrote in the description (not sure if it was clear
> enough), but I want to have a model 'accepted' before actually trying add the
> error state processing over a model that will not work very well :)
> 
> 
> Thanks for the review, I'll give a shot with the flag instead of a callback and
> see how it goes.
> 
> Cheers
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
