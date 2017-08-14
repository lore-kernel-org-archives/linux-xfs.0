Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21557 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752349AbdHNVdx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 17:33:53 -0400
Date: Mon, 14 Aug 2017 14:33:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170814213338.GA4796@magnolia>
References: <20170810175548.GX24087@magnolia>
 <20170810183233.GG3777@bfoster.bfoster>
 <20170811022204.GQ21024@dastard>
 <20170811142741.GA18609@bfoster.bfoster>
 <20170812001637.GW21024@dastard>
 <20170812140433.GA31523@bfoster.bfoster>
 <20170814002809.GA21024@dastard>
 <A86C45842A15447CAB819133E6AF76CF@alyakaslap>
 <20170814122216.GA39742@bfoster.bfoster>
 <0FC4BB5191444E42AD04581558F30898@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0FC4BB5191444E42AD04581558F30898@alyakaslap>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, libor.klepac@bcom.cz

On Mon, Aug 14, 2017 at 07:04:19PM +0300, Alex Lyakas wrote:
> Hi Brian,
> 
> Thanks for confirming. 3.18 is anyways EOL, so probably no more patches will
> show up for it. We are already running with this patch on our 3.18 for about
> a week, and did not see any issues.

Cool!  Thanks for supplying the testing data point!

--D

> 
> Alex.
> 
> 
> -----Original Message----- From: Brian Foster
> Sent: Monday, August 14, 2017 3:22 PM
> To: Alex Lyakas
> Cc: Dave Chinner ; Darrick J. Wong ; linux-xfs@vger.kernel.org ;
> libor.klepac@bcom.cz
> Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
> conversion and the addition of an attribute
> 
> On Mon, Aug 14, 2017 at 11:11:41AM +0300, Alex Lyakas wrote:
> >Hello David, Brian,
> >
> >I was not able to follow the details, unfortunately. Can you confirm that
> >this patch is safe to go into kernel 3.18?
> >
> 
> This is the open question in the separate subthread (this one is
> discussion around designing a solution for the current code):
> 
> http://marc.info/?l=linux-xfs&m=150246184413604&w=2
> 
> This could use confirmation, but my understanding is that this is safe
> because v3.18 doesn't have the more advanced deferred ops
> infrastructure. It uses xfs_bmap_finish() which has a max roll count of
> one and a transaction with enough reservation for 2 rolls before
> blocking reservation is required.
> 
> Note that doesn't mean we'd officially post a v3.18 stable patch before
> this is fixed in the upstream code. We always fix upstream first and
> backport from there to ensure a consistent base going forward (we don't
> want to go change v3.18, end up with a slightly different upstream
> patch, then have to backport more changes to fix the original patch).
> This may be safe enough for you to use locally in the meantime, however.
> 
> Brian
> 
> >Thanks,
> >Alex.
> >
> >
> >-----Original Message----- From: Dave Chinner
> >Sent: Monday, August 14, 2017 3:28 AM
> >To: Brian Foster
> >Cc: Darrick J. Wong ; Alex Lyakas ; linux-xfs@vger.kernel.org ;
> >libor.klepac@bcom.cz
> >Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
> >conversion and the addition of an attribute
> >
> >On Sat, Aug 12, 2017 at 10:04:34AM -0400, Brian Foster wrote:
> >> On Sat, Aug 12, 2017 at 10:16:37AM +1000, Dave Chinner wrote:
> >> > On Fri, Aug 11, 2017 at 10:27:43AM -0400, Brian Foster wrote:
> >> > > On Fri, Aug 11, 2017 at 12:22:04PM +1000, Dave Chinner wrote:
> >> > Using XFS_BLI_ORDERED allows us to log the buffer without recording
> >> > a new dirty range on the buffer. IOWs, it retains whatever dirty range
> >> > it already had, and so after joining, marking it ordered and then
> >> > logging the buffer, we have a XFS_BLI_DIRTY | XFS_BLI_ORDERED buffer
> >> > in the transaction.
> >> >
> >> > The question is this: what happens when a XFS_BLI_ORDERED buffer
> >> > with a pre-existing dirty region is formatted for the CIL? We
> >> > haven't done that before, so I'm betting that we don't relog the
> >> > dirty region like we should be doing....
> >> >
> >> > ... and we don't relog the existing dirty range because the
> >> > ordered flag takes precedence.
> >> >
> >>
> >> Right.. so it seems that the current implementation for ordered buffers
> >> assumes a buffer is only ever used in one mode or the other.
> >> Additionally, the AIL assumes that any reinserted item has been fully
> >> relogged and so it moves the LSN forward unconditionally. Current
> >> ordered buffer processing violates this constraint for an already logged
> >> buffer.
> >
> >Right, but it's not been a concern until now because we've only ever
> >used ordered buffers on newly allocated buffers that haven't been
> >previously logged.
> >
> >> > Ok, the ordered buffer checks in xfs_buf_item_size() and
> >> > xfs_buf_item_format() need to also check for dirty regions. If dirty
> >> > regions exist, then we treat it like a normal buffer rather than an
> >> > ordered buffer. We can factor the dirty region check out of
> >> > xfs_buf_item_unlock() for this...
> >> >
> >> > Actually, check the case in xfs_buf_item_size() and remove the
> >> > ordered flag if there are dirty regions. Then xfs_buf_item_format()
> >> > will do the right thing without needing a duplicate check...
> >> >
> >>
> >> I think that would work, assuming we actually check the
> >> xfs_buf_log_format for dirty-ness rather than just the log item. As it
> >> is, note that ordered buffers are still "logged" in the transaction
> >> because otherwise the transaction infrastructure will assume it made no
> >> change to the buf and toss the log item at commit time (we also need to
> >> set up I/O completion on the buf and whatnot).
> >
> >*nod*
> >
> >> What concerns me about this approach is that I think we introduce the
> >> possibility for subtle bugs. Existing ordered buffer code does this:
> >>
> >>         xfs_trans_ordered_buf(tp, fbuf);
> >>         xfs_trans_log_buf(tp, fbuf, 0,
> >>                           BBTOB(fbuf->b_length) - 1);
> >>
> >> ... which should continue to work fine. Allowing ordered buffers to
> >> physically log means that something like this:
> >>
> >>         xfs_trans_log_buf(tp, fbuf, 0,
> >>                           BBTOB(fbuf->b_length) - 1);
> >>         xfs_trans_ordered_buf(tp, fbuf);
> >>
> >> ... is now a bug that is only apparent after scrutiny of xfs_trans_*()
> >> and logging internals. Granted, the above already is incorrect, but it
> >> technically still works as expected. I don't see the need to turn that
> >> into a real problem by actually logging the buffer when we might not
> >> expect to.
> >
> >Well, it's not a "things go bad" bug. It's a "we screwed up an
> >optimisation" bug, because logging the buffer contents unnecessarily
> >only increases the required log bandwidth. It shouldn't affect
> >replay because the buffer is still correctly ordered in the log.
> >Hence both the transient and end states of the buffer during replay
> >will still be the same...
> >
> >> So while I agree that this could probably be made to work and I think it
> >> is ideal to doing any kind of logged range tracking in the deferred ops
> >> code, it still seems more tricky than it needs to be. To relog a held
> >> buffer in a new transaction, why not just mark the lidp dirty in the new
> >> transaction so it inherits all existing dirty segments? AFAICT, all we
> >> really need to do is:
> >>
> >>         tp->t_flags |= XFS_TRANS_DIRTY;
> >>         lidp->lid_flags |= XFS_LID_DIRTY;
> >>
> >> ... on the new transaction and everything should just work as designed
> >> (for a buffer that has been previously logged, held, rolled and
> >> rejoined).
> >
> >We would also need to set:
> >
> >bip->bli_flags |= XFS_BLI_DIRTY | XFS_BLI_LOGGED;
> >
> >which means we should....
> >
> >> To elaborate a bit, I think we could refactor xfs_trans_log_buf() into a
> >> new xfs_trans_dirty_buf() helper that covers all of the relevant bits
> >> not related to actually dirtying the bli. xfs_trans_log_buf() would call
> >> xfs_trans_dirty_buf() and thus would not change functionally.
> >> xfs_trans_ordered_buf() could now call xfs_trans_dirty_buf() and thus
> >> the existing ordered buf users would no longer need to log a range of
> >> the buffer (which doesn't make much sense anyways).
> >
> >... do this. :)
> >
> >> Finally, the
> >> deferred infrastructure could join/dirty/hold the buffer to the new
> >> transaction after each roll without needing to track and relog specific
> >> regions of the buffer. Thoughts?
> >
> >Yup, that's exactly what I was thinking should be possible by using
> >ordered buffers.... :)
> >
> >And Christoph's rework of the transaction roll and deferred inode
> >handling that he just posted should make adding buffer handling
> >quite a bit neater and cleaner.
> >
> >> Unless I'm missing something as to why this is busted, I'll take a
> >> closer look at the code and float an rfc next week since otherwise it
> >> sounds like this is something we could actually fix up in the ordered
> >> buffer code today.
> >
> >Cool.
> >
> >> > Nothing in XFS is ever simple, is it? :P
> >>
> >> There used to be a level of satisfaction at feeling I understood some
> >> new corner of XFS. Nowadays I know that just means I'm not yet aware of
> >> whatever dragons remain in that corner (is that paranoia? not if it's
> >> true!). :P
> >
> >Ah, the true signs of expertise: developing a knowledge base and
> >insight deep enough to understand that there is always another
> >hidden dragon poised to bite your head off. :)
> >
> >Cheers,
> >
> >Dave.
> >-- 
> >Dave Chinner
> >david@fromorbit.com
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
