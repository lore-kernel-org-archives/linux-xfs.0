Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755489AbeCHTLQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Mar 2018 14:11:16 -0500
Date: Thu, 8 Mar 2018 14:11:13 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: handle inconsistent log item formatting state
 correctly
Message-ID: <20180308191113.GA2725@dhcp-41-192.bos.redhat.com>
References: <20180301223527.28626-1-david@fromorbit.com>
 <20180305144001.GA6135@bfoster.bfoster>
 <20180305221857.GF18129@dastard>
 <20180306123155.GB10982@bfoster.bfoster>
 <20180306221441.GK18129@dastard>
 <20180307011602.GA19337@bfoster.bfoster>
 <20180307021245.GV18989@magnolia>
 <20180308044017.GR18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180308044017.GR18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Mar 08, 2018 at 03:40:17PM +1100, Dave Chinner wrote:
> On Tue, Mar 06, 2018 at 06:12:45PM -0800, Darrick J. Wong wrote:
> > On Tue, Mar 06, 2018 at 08:16:02PM -0500, Brian Foster wrote:
> > > On Wed, Mar 07, 2018 at 09:14:41AM +1100, Dave Chinner wrote:
> > > > On Tue, Mar 06, 2018 at 07:31:56AM -0500, Brian Foster wrote:
> > > My argument is not that it's not possible. My argument is that the
> > > semantics of XFS_LID_DIRTY suggest the transaction modified the object
> > > in memory. Today, that means we log a range of the object, log an
> > > invalidation or order a buffer. E.g., we modify an actual metadata
> > > object, dirty the item (log or order), dirty the lidp and dirty the
> > > transaction. If we didn't ever modify a particular object, then there's
> > > no reason to dirty it that I can see. Failing to log/order the object
> > > properly doesn't justify assuming it hasn't been modified IMO, we don't
> > > really know either way.
> > > 
> > > The way the flag is used seems to bear that out. It's set when an object
> > > has been modified by a transaction. The way the flag alters behavior
> > > suggests the same. Objects that have been dirtied by a transaction
> > > cannot be released from that transaction and a cancel of a transaction
> > > with a dirty lidp causes fs shutdown (because we dirty the transaction
> > > once we dirty a lidp).
> 
> I'll point out that I've just stumbled onto a series of bugs where
> log items are multiply joined to a single transaction, in which case
> the lidp state may not reflect the current state of the log item
> because the log item no longer points to the lidp in question.
> 
> This also raises questions about what happens when we process a log
> item twice in the cil commit infrastructure - two formatting passes,
> multiple inserts into the CIL list, multiple calls to
> iop_committing/iop_unlock when the transaction is freed, etc.
> There's lots of shit that could go wrong as a result of this type of
> bug...
> 
> > > A cancel of that same transaction would shutdown the fs because it
> > > dirtied (i.e., presumably modified) an object. So we can't cancel the
> > > transaction for risk of corruption, we can't release the object from the
> > > transaction, yet this patch proposes behavior where a commit of that
> > > transaction can silently undirty the lidp, commit whatever else might be
> > > in the transaction and carry on as if nothing were wrong.
> > > 
> > > At the very least, this is inconsistent with how this flag is used
> > > everywhere else. How do you explain that?
> > 
> > So the state "li dirty, lip !ordered, niovecs == 0" is an invalid state,
> > and this patch proposes that if we ever see this invalid state then we
> > decide that no the buffer isn't dirty since there are zero iovecs.  This
> > prevents the log from allocating anything for this item since there's no
> > evidence of anything being dirty.
> 
> Essentially. The log item dirty state is the thing we trust right
> through the log item life cycle. It's fundamental to the relogging
> algorithm we use to keep dirty metadata moving forwards through the
> log.
> 
> The log item descriptor, OTOH, was just an abstraction that allowed
> the transaction commit to couple the log item formatting to the
> xlog_write() vector calls, which is something that went away with
> delayed logging about 8 years ago. The only piece of the log item
> descriptor that remained was the dirty flag, and the issue here
> boils down to one simple question: which dirty state do we trust -
> the log item or the descriptor?
> 
> That, as an architectural question, is a no brainer. It's the log
> item state that matters. The log item descriptor is an abstraction
> long past it's use-by date, so I'm going to resolve this problem
> simply by removing it (if you are wondering how I found the
> mulitply-joined log item bugs...).
> 

Ooh, we're in danger of making some progress here... :P

So this all suggests to me that you see the lidp dirty state as
duplicative with the log item dirty state. That is quite different from
the perception I have from reading the code (a perception which I tried
my best to describe so you, or somebody, could set me straight if
necessary). Then again...

> In doing this, we no longer have the question of which one to trust
> - all the "dirty in transaction" state is carried on the log item
> itself and is valid only during the life of a transaction.  At
> which point, there should be no possibility of the log item dirty
> flag getting out of step with it's dirty state, and we can simply
> add asserts in the write place to validate this.
> 

This more describes the lidp object as duplicative, while the dirty
state it supports may still be unique with respect to the lip dirty
state (which is what I thought to begin with). In other words, we still
need to differentiate between a dirty lip that might be in the log
pipeline and a log item that is "dirty in a transaction," because afaict
it's still possible to have a dirty log item in a clean transaction.

So which of the above is more accurate? If the latter, doesn't the
"dirty in transaction" state we'd move over to the lip reflect the same
meaning as XFS_LID_DIRTY today? If so, ISTM that we should still not
expect to have a "dirty in transaction" log item unless the log item
itself is dirty. Hm?

(All the other bits around multi-join bugs and whatnot certainly sound
legitimately borked, I'm just still trying to make sense of the bit that
relates to this patch. I'll try and make sense of the other stuff when
patches are available.).

Brian (who will be online intermittently for the next several days due
to power outages...)

> > As for clearing LID_DIRTY, someone handed us a log item in an
> > inconsistent state, so perhaps we should shut down the fs instead?  I
> > get that LID_DIRTY is a flag that is a proxy for counting the iovecs,
> > but if the iovec array and the flag disagree then something funny is
> > going on.
> 
> Yup, like we have a multiply joined log item and stale log item
> descriptors. :/
> 
> > Then again I guess it's mysterious if something scribbles on
> > our incore log and the fs just shuts down... so I guess I'd be ok with
> > clearing the flag so long as /something/ gets logged about in-memory
> > state being weird even on production kernels.
> 
> I'm just going to make the coherency problem go away completely.
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
