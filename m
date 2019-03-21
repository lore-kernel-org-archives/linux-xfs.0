Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:51458 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726377AbfCUXut (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Mar 2019 19:50:49 -0400
Date: Fri, 22 Mar 2019 10:50:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/475 deadlock?
Message-ID: <20190321235045.GW23020@dastard>
References: <20190320050408.GA24923@magnolia>
 <20190320170305.GA29010@bfoster>
 <20190320174551.GA1186@magnolia>
 <20190320175922.GB29010@bfoster>
 <20190320214938.GU23020@dastard>
 <20190321121152.GA33001@bfoster>
 <20190321211051.GV23020@dastard>
 <20190321215307.GA35644@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321215307.GA35644@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 21, 2019 at 05:53:07PM -0400, Brian Foster wrote:
> On Fri, Mar 22, 2019 at 08:10:51AM +1100, Dave Chinner wrote:
> > On Thu, Mar 21, 2019 at 08:11:52AM -0400, Brian Foster wrote:
> > > On Thu, Mar 21, 2019 at 08:49:38AM +1100, Dave Chinner wrote:
> > > The current xfsaild() log force logic is still tied to PINNED objects,
> > > but it has additional logic to detect skipped buffers at delwri queue
> > > submit time (i.e., due to being pinned) that should cover the pinned
> > > inode cluster buffer case.
> > 
> > And it's not skipped buffers, either. Skipped buffers are only for
> > determining timeouts - it's the ail->ail_log_flush counter that
> > determines whether a log flush should be done or not, and that's
> > only incremented on ITEM_PINNED objects. This is why I was
> > suggesting returning that if the backing buffer is pinned, but I
> > forgot all about how we already handle this case...
> > 
> > > But given the above, couldn't we just remove the log force from
> > > xfs_iflush() and let the existing xfsaild_push() logic handle it?
> > 
> > We can, but not for the reasons you are suggesting.
> > 
> 
> The reason I suggested is because we currently "detect skipped buffers
> at delwri queue submit time (i.e., due to being pinned)," which causes
> xfsaild to force the log.  I'm not sure how exactly you read that, but it
> refers exactly to the code snippet you posted below where we bump the
> log flush counter due to skipped buffers on submit (because they were
> pinned).

In the context of the AIL pushing, "skipped" has specific meaning -
it refers to items that could not be flushed for whatever reason.
And the actions that are taken based on the number of "skipped"
objects is taken after delwri queue submit time.

You used all the terminology that refers to /skipped/ item
handling, not /pinned/ item handling - if you re-read what I wrote
above with this difference in mind, then it will make a lot more
sense to you.

FWIW, this skipped/pinned terminology difference goes right down
into the delwri list handling I quoted - I'll add the next few lines
so it's clear what I'm talking about:


> > 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
> > 		if (!wait_list) {
> > 			if (xfs_buf_ispinned(bp)) {
> > 				pinned++;
> > 				continue;
> > 			}
			if (!xfs_buf_trylock(bp))
				continue;
		}

This code branch also avoid blocking on locked buffers. In AIL
terms these locked buffers have been "skipped", but the code only
counts and indicates pinned buffers to the caller. And the delwri
submission code in the AIL pushing acts on this specific
distinction - it triggers a log force if pinned buffers were
encountered, not if the flush skipped locked buffers.

> > ....
> > 	return pinned;
> > 
> 
> "detect skipped buffers at delwri queue submit time (i.e., due to being
> pinned)"

If the AIL code was detecting skipped buffers, it would do:

	xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list);
	if (!list_empty(&ailp->ail_buf_list)) {
		/* we skipped buffers */
		.....
	}

But it's not doing this.

i.e. "Pinned" vs "skipped" may be a subtle terminology difference,
but it is an important difference and they are not interchangable...

> > remove them and issue IO on them, and tell the caller that we left
> > pinned/locked buffers on the list that still need to be submitted.
> > The AIL takes this as an indication it needs to flush the log to
> > unpin the buffers it can't flush, and because they are still on it's
> > delwri list, it will attempt to submit them again next time around
> > after the log has been forced.
> > 
> 
> Right, so this is exactly the reason I suggested.

OK, we're on the same page. :)

Do want to submit a patch that fixes the inode and dquot flushing?
I haven't looked any further at the busy extent stuff, that's likely
to be a more difficult problem to solve...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
