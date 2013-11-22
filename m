Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C851B7F37
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 20:58:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 617D78F8040
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 18:58:06 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZLs0GxfNuLoYCEB1 for <xfs@oss.sgi.com>;
	Thu, 21 Nov 2013 18:58:03 -0800 (PST)
Date: Fri, 22 Nov 2013 13:57:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent spurious "head behind tail" warnings
Message-ID: <20131122025757.GF6502@dastard>
References: <1384900659-22215-1-git-send-email-david@fromorbit.com>
	<528BEF71.1000607@sgi.com> <20131121014255.GZ6188@dastard>
	<20131121130156.GA6502@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131121130156.GA6502@dastard>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 22, 2013 at 12:01:56AM +1100, Dave Chinner wrote:
> On Thu, Nov 21, 2013 at 12:42:55PM +1100, Dave Chinner wrote:
> > On Tue, Nov 19, 2013 at 05:08:33PM -0600, Mark Tinguely wrote:
> > > On 11/19/13 16:37, Dave Chinner wrote:
> > > >From: Dave Chinner<dchinner@redhat.com>
> > > >
> > > >When xlog_space_left() cracks the grant head and the log tail, it
> > > >does so without locking to synchronise the sampling of the
> > > >variables. It samples the grant head first, so if there is a delay
> > > >before it smaples the log tail, there is a window where the log tail
> > > >could have moved onwards and be moved past the sampled value of the
> > > >grant head. This then leads to the "xlog_space_left: head behind
> > > >tail" warning message.
.....
> > > 
> > > I am still getting the debug message:
> > > 
> > >   xlog_verify_grant_tail: space > BBTOB(tail_blocks)
> > 
> > I'm not sure why that is relevant to this patch - it doesn't touch
> > xlog_verify_grant_tail(), nor does it change the functioning of the
> > code except to remove false positive warnings.
> > 
> > Further, the comment about xlog_verify_grant_tail() says:
> > 
> >   * This check is run unlocked, so can give false positives. 
> > 
> > That's exactly what this patch addresses for xlog_space_left() -
> > it prevents false positives when it is run unlocked. So we could do
> > exactly the same thing to xlog_verify_grant_tail() as well. Patch
> > attached below.
> > 
> > > This is a real over grant.
> > 
> > Evidence, please.
> 
> So, I've done some more testing with these patches, and found a
> couple of interesting things.  I found that xfs/297 with a bunch of
> memory, VM and lock debugging turned on has fairly reliably
> reproduced the messages from both functions, albeit slowly (taking
> 10 minutes a cycle, 3-4 cycles to get a single xlog_space_left()
> failure).
> 
> First thing I did was remove the "print once" flag from
> xlog_verify_grant_tail(), and I generally see 2-3 outputs from it
> during a run, usaully tens to hundreds of seconds apart. No hangs,
> and the difference in byte counts generally is under 200k.
> 
> It then made it print each retry, knowing that it wouldn't swamp the
> logs. What each event gave was this:
> 
> [  201.796132] XFS (vdb): xlog_verify_grant_tail: retries 0, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
> [  201.798514] XFS (vdb): xlog_verify_grant_tail: retries 1, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
> [  201.800890] XFS (vdb): xlog_verify_grant_tail: retries 2, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
> [  201.802951] XFS (vdb): xlog_verify_grant_tail: retries 3, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
> [  201.805238] XFS (vdb): xlog_verify_grant_tail: retries 4, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
> [  201.807378] XFS (vdb): xlog_verify_grant_tail: retries 5, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
> [  201.809619] XFS (vdb): xlog_verify_grant_tail: head_bytes > BBTOB(tail_blocks) (8365828/8126464)
> 
> Which, as you can see, resampling didn't help prevent the message
> output at all. The region of the log that this warning comes up in
> is random; there is no pattern to it the repeated occurrences. Hence
> I will drop the repeated sampling part of the patches, but keep the
> memory barrier and preemption disabling around the sampling...
> 
> Scratch that - I just had the repeated sampling avoid a warning -
> the fifth sample saw the problem go away....
> 
> [  140.728172] XFS (vdb): xlog_verify_grant_tail: retries 0, head_bytes > BBTOB(tail_blocks) (4099150/3932160)
> [  140.731761] XFS (vdb): xlog_verify_grant_tail: retries 1, head_bytes > BBTOB(tail_blocks) (4099150/3932160)
> [  140.735495] XFS (vdb): xlog_verify_grant_tail: retries 2, head_bytes > BBTOB(tail_blocks) (4099150/3932160)
> [  140.739059] XFS (vdb): xlog_verify_grant_tail: retries 3, head_bytes > BBTOB(tail_blocks) (4099150/3932160)
> [  140.742561] XFS (vdb): xlog_verify_grant_tail: retries 4, head_bytes > BBTOB(tail_blocks) (4099150/3932160)
> 
> What this points out is that the while the problem state is
> temporary, the cause of it is not racing updates during sampling. We
> do, indeed, appear to have a temporary state where the grant head
> has passed over the log tail. By the next check, the grant head no
> longer covers the tail.
> 
> The next step is to dump the stack when-ever such a warning is
> emitted to find out what if there is a specific operation is that
> is triggering them. All are coming from this path:
> 
> .....
>   xfs_trans_reserve
>     xfs_log_reserve
>       xlog_verify_grant_tail
> 
> And so are occurring after the grant head has been moved forward by
> the log reservation. That's rather interesting.
> 
> xlog_verify_grant_tail() verifies the log tail against the write
> grant head, not the reserve grant head. The reserve grant head is
> what prevents log space overcommit, and that's the one that the
> xfs_log_reserve sleeps on waiting for log space to become available.
> Once space is available on the reserve grant head, it adds the space
> to both the reserve grant and the write grant.
> 
> Hence we know that we haven't unintentionally overcommitted the
> reserve head via transaction reservations, so why does the write
> head go past the log tail, and how is it different to the reserve
> grant head.
> 
> Well, the write grant and the reserve grant are mostly tracking the
> same thing. The difference comes, however, in permanent
> transactions. While the permanent transaction has reservations for
> multiple commits available (which they start with) both the write
> grant and the reserve grant are updated during transaction commit
> 
> xfs_trans_commit
>   xfs_log_commit_cil
>     xfs_log_done
>       xlog_regrant_reserve_log_space
> 	ticket->t_unit--
> 	xlog_grant_sub_space(reserve head, unused resv);
> 	xlog_grant_sub_space(write head, unused resv);
> 
> At this point, if the permanent log transaction still has reserved
> units available, it returns. We'll come back to this.
> 
> For a rolling transaction, just before transaction commit, the
> transaction will have been duplicated via xfs_trans_dup(). This
> takes a reference to the ticket, and attaches it to the new
> transaction. The old transaction is then committed like above, and
> we continue with the same ticket in the above but with one less
> reservation unit.
> 
> We then call xfs_trans_reserve on the ticket again, and that enters
> xfs_log_regrant rather than xfs_log_reserve like the original ticket
> reservation would have. if the ticket still has reservation units
> left on it, it does nothing that push the AIL and reset the
> reservation for the new transaction.
> 
> Where it gets interesting is when the ticket unit reservation runs
> out, and we have to get new reservations to continue a rolling
> transaction. Very few permanent log transactions actually need this.
> In fact, I think xfs_itruncate_extents() is the only code that makes
> use of this facility, as all other transactions have bound limits in
> the code. xfs_itruncate_extents() can remove an unbound number of
> extents, and hence the rolling transaction is essentially unbound in
> size. Remember this, too.
> 
> So, when we run out of reservation units on the ticket, we do this:
> 
> xfs_trans_dup
> xfs_trans_commit
>   xfs_log_commit_cil
>     xfs_log_done
>       xlog_regrant_reserve_log_space
> 	xlog_grant_sub_space(reserve head, unused resv);
> 	xlog_grant_sub_space(write head, unused resv);
> 	xlog_grant_add_space(reserve head, unit reservation);
> 
> i.e. is simply steals the unit reservation from the reserve head
> *without caring about the amount of reservation space that is
> available*. This can push the reserve grant head past the tail if
> the reservation space is already full.
> 
> While this might seem bad and wrong, it actually isn't because the
> ticket doesn't yet have *write grant space*. So, following the
> commit, we do:
> 
> xfs_trans_reserve
>   xfs_log_regrant
>     xlog_grant_head_check(write head, space needed)
>     xlog_grant_add_space(write head, space needed)
> 
> It's the xlog_grant_head_check() that blocks waiting for write grant
> space to come available, and hence we dont over-commit the log space
> in such permanent transactions. Yes, we overcommit the reservation
> spae, but we never overcommit the write space and hence we don't
> overcommit the log space in this situation.
> 
> But, what is does point out is that the reserve head can *validly*
> overcommit log space and overlap the tail of the log. This doesn't
> explain the write grant head getting ahead of the log tail, but
> let's ignore that and look at ithe warnings I'm getting from
> xlog_space_left() for a moment.

[snip xlog_space_left() "overcommit is OK" debug]
> 
> What that means, though, is that I still haven't been able to
> reproduce the "head behind tail" conditions that people are
> complaining about, and i don't yet have an answer to the
> xlog_verify_grant_tail() issue.

So, how does the write grant head overlap the log tail? My current
hypothesis is that we're seeing the same pattern of "add space
without first checking" that results in overcommit of the write
head, just like we are doing with the reserve head.

That is, the reserve grant is overcommitting because we check and
throttle in xfs_log_reserve(), but then do an unchecked addition on
permanent transaction commit. In the case of the write head, we do
checking and throttling on permanent transaction reserve via
xfs_log_regrant(), but we do unchecked addition in
xfs_log_reserve().

Put simply, if we throttle in xfs_log_regrant because we don't have
write space available, we can have another transaction (say with a
smaller unit reservation) come through xfs_log_reserve() and get
reserve head space, which it then unconditionally adds to the write
head.

				resv head		write head
				X			Y
permanent xact P1 completes	X - curr		Y - curr
				  + unit_P1
                                (overcommit)
xact T2 reserve			OC, blocks
xact P1 reserve on dup					Not enough space,
							blocks
....
log tail moves a small amount
	space availble enough to fulfil T2 reserve, P1 write grants

xact P1 wakes			X - curr		Y - curr
				  + unit_P1		  + unit_P1
xact T2 wakes			X - curr		Y - curr
				  + unit_P1		  + unit_P1
				  + unit_T2		  + unit_T2
							  (overcommit)

In this case, it appears to me that the overcommit of the write
space is valid because transactions that block on write space
overcommit also hold a reserve space grant.

We already know that if we overcommit the reserve head due to a
permanent transaction regrant, then all new transactions are
throttled until the reserve space overcommit situation goes away.
Permanent transactions can continue to regrant even in an overcommit
situation, but we prevent real overcommit by throttling the write
grants.

IOWs, if we are in a reserve head overcommit situation, we cannot
then overcommit the write head because all new write head regrants
are checked and prevented from overcommit.

If we are in a write space overcommit state, then write regrants are
blocked after consuming reserve space. This will cause reserve
space to run out and so we can't can't overcommit the log with new
transactions. Permanent transactions can the drive the reserve space
into overcommit, but then block on the write space grant head
that is already over committed. At this point, the reserve space
overcommit situation will not be cleared until the write space
overcommit is resolved.

That is, the only way to make progress at this point is by the log
tail moving forwards due to metadata IO completion. If it only moves
forward a small amount, then write space will be the first to allow
progress, and so the permanent transactions will make progress and
complete ahead of new transactions being started, releasing their
overcommitted reserve space grants. If the log tail jumps by a long
way, it will alleviate the overcommit on both grant heads and both
new and permanent transactions will immediately make progress.

In summary: overcommits on both the reserve grant space and the
write grant space can and do occur, and both are valid temporary
conditions that resolve themselves through mechanisms built into the
algorithms without resulting in a real log space overcommit. Hence
debug code that triggers on grant head overcommit situations will
always generate false positive warnings.

I will rework the two patches to take this into account...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
