Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19562 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753891AbdHRCEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 22:04:45 -0400
Date: Fri, 18 Aug 2017 12:04:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170818020442.GW21024@dastard>
References: <63920C3663124B75BC0983A17533395A@alyakaslap>
 <20170810145248.GE3777@bfoster.bfoster>
 <20170810175548.GX24087@magnolia>
 <20170810183233.GG3777@bfoster.bfoster>
 <20170811022204.GQ21024@dastard>
 <20170811142741.GA18609@bfoster.bfoster>
 <20170812001637.GW21024@dastard>
 <20170812140433.GA31523@bfoster.bfoster>
 <20170814002809.GA21024@dastard>
 <20170817203826.GB62570@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817203826.GB62570@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Alex Lyakas <alex@zadarastorage.com>, linux-xfs@vger.kernel.org, libor.klepac@bcom.cz

On Thu, Aug 17, 2017 at 04:38:26PM -0400, Brian Foster wrote:
> On Mon, Aug 14, 2017 at 10:28:09AM +1000, Dave Chinner wrote:
> > On Sat, Aug 12, 2017 at 10:04:34AM -0400, Brian Foster wrote:
> > > On Sat, Aug 12, 2017 at 10:16:37AM +1000, Dave Chinner wrote:
> > > > On Fri, Aug 11, 2017 at 10:27:43AM -0400, Brian Foster wrote:
> > > > > On Fri, Aug 11, 2017 at 12:22:04PM +1000, Dave Chinner wrote:
> > > > Using XFS_BLI_ORDERED allows us to log the buffer without recording
> > > > a new dirty range on the buffer. IOWs, it retains whatever dirty range
> > > > it already had, and so after joining, marking it ordered and then
> > > > logging the buffer, we have a XFS_BLI_DIRTY | XFS_BLI_ORDERED buffer
> > > > in the transaction.
> > > > 
> > > > The question is this: what happens when a XFS_BLI_ORDERED buffer
> > > > with a pre-existing dirty region is formatted for the CIL? We
> > > > haven't done that before, so I'm betting that we don't relog the
> > > > dirty region like we should be doing....
> > > > 
> > > > ... and we don't relog the existing dirty range because the
> > > > ordered flag takes precedence.
> > > > 
> > > 
> > > Right.. so it seems that the current implementation for ordered buffers
> > > assumes a buffer is only ever used in one mode or the other.
> > > Additionally, the AIL assumes that any reinserted item has been fully
> > > relogged and so it moves the LSN forward unconditionally. Current
> > > ordered buffer processing violates this constraint for an already logged
> > > buffer.
> > 
> > Right, but it's not been a concern until now because we've only ever
> > used ordered buffers on newly allocated buffers that haven't been
> > previously logged.
> > 
> 
> Shortly after starting to test the latest refactoring with some asserts
> that enforce "strict" buffer ordering, I (sure enough ;)) ran into an
> instance of the above.
> 
> The issue is with the bmbt owner change operation that is part of the
> swap extent sequence.

Ah, I forgot about that. I was thinking that it went away with
rmapbt....

> The owner change code ends up setting a buffer
> ordered that is currently dirty due to an unrelated previous
> transaction. The potential side effects of this are basically what we've
> already laid out above. Note that this is only relevant on
> crc=1,rmapbt=0 filesystems.

.... but obviously I was wrong. :/

[....]

> 
> 4.) Implement the ordered buffer relogging logic discussed below: detect
> ordered buffers with previously logged segments and relog them at
> ->iop_format() time. I suppose I could alleviate my aforementioned
> concerns with an assert that verifies an ordered buffer isn't already
> dirtied by the _current_ transaction (i.e., to catch the case of the
> "screwed up optimization" I was concerned about).

Yeah, that would work, except .....

> That aside, I think there is another problem here that we missed
> previously: transactions that use ordered buffers don't reserve log
> space for them, but relogged items require log reservation. If I follow
> the code correctly, a relogged item that is presently in the CIL may not
> use reservation in a subsequent tx. If the item resides in the AIL at
> relog commit time, however, the relogging transaction must have
> reservation for the item (the physical log space for the item is freed
> and the space used for the relog is accounted out of the reservation).

... this.

Yes, you are right, Brian, that if the item is in the CIL then we
don't need a new reservation because the space is already accounted
for in the current checkpoint. This, however, is still racy as the
item in the CIL can be committed while we have it locked and so
when we commit it's the same as "in the AIL and we need a
reservation".

> So I think the only way we can support the ability to relog previously
> dirty buffers that have been marked ordered is to require log
> reservation for them as for normal physically logged buffers, which kind
> of defeats the purpose.
> 
> 5.) A deferred op variant of the bmbt owner change algorithm. I haven't
> fully thought this one through yet so it may not be viable, but the
> general idea is to use deferred ops to conditionally physically log
> previously dirty buffers where required. For example, use a transaction
> with log reservation for one full buffer, log a new bmbt owner change
> intent and start running through the bmbt scan attempting to order
> buffers. Update xfs_trans_ordered_buf() to explicitly fail on buffers
> with dirty segments. When said failure occurs during the bmbt scan,
> physically log the buffer and terminate the scan with -EAGAIN. The
> deferred infra rolls the tx, relogs the intent and has to restart the
> bmbt scan over again. This repeats until we've processed the entire
> tree.

Problem is that a deferred op variant isn't backwards compatible,
and given this is a v4 filesystem issue, that's a big problem
because we can't just use a log incompat flag while the op is active
in the log.

However, I think we can do this with just normal rolling
transactions. Like you suggest, we can create the transaction with a
small amount of buffer space that can be logged (e.g. enough for N
complete buffers). Then we modify xfs_trans_buf_ordered() to "try
ordering the buffer". If the buffer needs relogging, then it fails
and we log the owner field in the buffer as per a normal buffer. (or
maybe just take the range we need to log and log that instead of
ordering the buffer - as long as we can count the buffers that do
this.)

On the N-th relogged buffer, roll the transaction to trigger
regranting of the log space for another N buffers and keep going
with the owner change.  The transaction roll will then commit the
buffer owner change to the log.

In recovery, we just replay the owner change as we currently do,
knowing that if the buffer was logged during the owner change and
written to a later checkpoint, the replay of that buffer will
contain the owner change we just did and so we won't lose anything.

I think this should work on all v4 filesystems without any need to
modify log recovery or new log items....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
