Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B00B37F52
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 07:02:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 71C34304053
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 05:02:06 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	32JBhvqCHqsQYE4b for <xfs@oss.sgi.com>;
	Thu, 21 Nov 2013 05:02:00 -0800 (PST)
Date: Fri, 22 Nov 2013 00:01:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent spurious "head behind tail" warnings
Message-ID: <20131121130156.GA6502@dastard>
References: <1384900659-22215-1-git-send-email-david@fromorbit.com>
	<528BEF71.1000607@sgi.com> <20131121014255.GZ6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131121014255.GZ6188@dastard>
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

On Thu, Nov 21, 2013 at 12:42:55PM +1100, Dave Chinner wrote:
> On Tue, Nov 19, 2013 at 05:08:33PM -0600, Mark Tinguely wrote:
> > On 11/19/13 16:37, Dave Chinner wrote:
> > >From: Dave Chinner<dchinner@redhat.com>
> > >
> > >When xlog_space_left() cracks the grant head and the log tail, it
> > >does so without locking to synchronise the sampling of the
> > >variables. It samples the grant head first, so if there is a delay
> > >before it smaples the log tail, there is a window where the log tail
> > >could have moved onwards and be moved past the sampled value of the
> > >grant head. This then leads to the "xlog_space_left: head behind
> > >tail" warning message.
> > >
> > >To avoid spurious output in this situation, swap the order in which
> > >the variables are cracked. This means that the head may grant head
> > >may move if there is a delay, but the log tail will be stable, hence
> > >ensure the tail does not jump the head accidentally.
> > >
> > >While this avoids the spurious head behind tail problem, it
> > >introduces the opposite problem - the head can move more than a full
> > >cycle past the tail. The code already handles this case by
> > >indicating that the log is full (i.e. zero space available) but
> > >that's still (generally) a spurious situation.
> > >
> > >Hence, if we detect that the head is more than a cycle ahead of the
> > >tail or the head is behind the tail, start the calculation again by
> > >resampling the variables and trying again. If we get too many
> > >resamples, then throw a warning and return a full or empty log
> > >appropriately.
> > >
> > >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> > >---
> > 
> > I am still getting the debug message:
> > 
> >   xlog_verify_grant_tail: space > BBTOB(tail_blocks)
> 
> I'm not sure why that is relevant to this patch - it doesn't touch
> xlog_verify_grant_tail(), nor does it change the functioning of the
> code except to remove false positive warnings.
> 
> Further, the comment about xlog_verify_grant_tail() says:
> 
>   * This check is run unlocked, so can give false positives. 
> 
> That's exactly what this patch addresses for xlog_space_left() -
> it prevents false positives when it is run unlocked. So we could do
> exactly the same thing to xlog_verify_grant_tail() as well. Patch
> attached below.
> 
> > This is a real over grant.
> 
> Evidence, please.

So, I've done some more testing with these patches, and found a
couple of interesting things.  I found that xfs/297 with a bunch of
memory, VM and lock debugging turned on has fairly reliably
reproduced the messages from both functions, albeit slowly (taking
10 minutes a cycle, 3-4 cycles to get a single xlog_space_left()
failure).

First thing I did was remove the "print once" flag from
xlog_verify_grant_tail(), and I generally see 2-3 outputs from it
during a run, usaully tens to hundreds of seconds apart. No hangs,
and the difference in byte counts generally is under 200k.

It then made it print each retry, knowing that it wouldn't swamp the
logs. What each event gave was this:

[  201.796132] XFS (vdb): xlog_verify_grant_tail: retries 0, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
[  201.798514] XFS (vdb): xlog_verify_grant_tail: retries 1, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
[  201.800890] XFS (vdb): xlog_verify_grant_tail: retries 2, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
[  201.802951] XFS (vdb): xlog_verify_grant_tail: retries 3, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
[  201.805238] XFS (vdb): xlog_verify_grant_tail: retries 4, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
[  201.807378] XFS (vdb): xlog_verify_grant_tail: retries 5, head_bytes > BBTOB(tail_blocks) (8365828/8126464)
[  201.809619] XFS (vdb): xlog_verify_grant_tail: head_bytes > BBTOB(tail_blocks) (8365828/8126464)

Which, as you can see, resampling didn't help prevent the message
output at all. The region of the log that this warning comes up in
is random; there is no pattern to it the repeated occurrences. Hence
I will drop the repeated sampling part of the patches, but keep the
memory barrier and preemption disabling around the sampling...

Scratch that - I just had the repeated sampling avoid a warning -
the fifth sample saw the problem go away....

[  140.728172] XFS (vdb): xlog_verify_grant_tail: retries 0, head_bytes > BBTOB(tail_blocks) (4099150/3932160)
[  140.731761] XFS (vdb): xlog_verify_grant_tail: retries 1, head_bytes > BBTOB(tail_blocks) (4099150/3932160)
[  140.735495] XFS (vdb): xlog_verify_grant_tail: retries 2, head_bytes > BBTOB(tail_blocks) (4099150/3932160)
[  140.739059] XFS (vdb): xlog_verify_grant_tail: retries 3, head_bytes > BBTOB(tail_blocks) (4099150/3932160)
[  140.742561] XFS (vdb): xlog_verify_grant_tail: retries 4, head_bytes > BBTOB(tail_blocks) (4099150/3932160)

What this points out is that the while the problem state is
temporary, the cause of it is not racing updates during sampling. We
do, indeed, appear to have a temporary state where the grant head
has passed over the log tail. By the next check, the grant head no
longer covers the tail.

The next step is to dump the stack when-ever such a warning is
emitted to find out what if there is a specific operation is that
is triggering them. All are coming from this path:

.....
  xfs_trans_reserve
    xfs_log_reserve
      xlog_verify_grant_tail

And so are occurring after the grant head has been moved forward by
the log reservation. That's rather interesting.

xlog_verify_grant_tail() verifies the log tail against the write
grant head, not the reserve grant head. The reserve grant head is
what prevents log space overcommit, and that's the one that the
xfs_log_reserve sleeps on waiting for log space to become available.
Once space is available on the reserve grant head, it adds the space
to both the reserve grant and the write grant.

Hence we know that we haven't unintentionally overcommitted the
reserve head via transaction reservations, so why does the write
head go past the log tail, and how is it different to the reserve
grant head.

Well, the write grant and the reserve grant are mostly tracking the
same thing. The difference comes, however, in permanent
transactions. While the permanent transaction has reservations for
multiple commits available (which they start with) both the write
grant and the reserve grant are updated during transaction commit

xfs_trans_commit
  xfs_log_commit_cil
    xfs_log_done
      xlog_regrant_reserve_log_space
	ticket->t_unit--
	xlog_grant_sub_space(reserve head, unused resv);
	xlog_grant_sub_space(write head, unused resv);

At this point, if the permanent log transaction still has reserved
units available, it returns. We'll come back to this.

For a rolling transaction, just before transaction commit, the
transaction will have been duplicated via xfs_trans_dup(). This
takes a reference to the ticket, and attaches it to the new
transaction. The old transaction is then committed like above, and
we continue with the same ticket in the above but with one less
reservation unit.

We then call xfs_trans_reserve on the ticket again, and that enters
xfs_log_regrant rather than xfs_log_reserve like the original ticket
reservation would have. if the ticket still has reservation units
left on it, it does nothing that push the AIL and reset the
reservation for the new transaction.

Where it gets interesting is when the ticket unit reservation runs
out, and we have to get new reservations to continue a rolling
transaction. Very few permanent log transactions actually need this.
In fact, I think xfs_itruncate_extents() is the only code that makes
use of this facility, as all other transactions have bound limits in
the code. xfs_itruncate_extents() can remove an unbound number of
extents, and hence the rolling transaction is essentially unbound in
size. Remember this, too.

So, when we run out of reservation units on the ticket, we do this:

xfs_trans_dup
xfs_trans_commit
  xfs_log_commit_cil
    xfs_log_done
      xlog_regrant_reserve_log_space
	xlog_grant_sub_space(reserve head, unused resv);
	xlog_grant_sub_space(write head, unused resv);
	xlog_grant_add_space(reserve head, unit reservation);

i.e. is simply steals the unit reservation from the reserve head
*without caring about the amount of reservation space that is
available*. This can push the reserve grant head past the tail if
the reservation space is already full.

While this might seem bad and wrong, it actually isn't because the
ticket doesn't yet have *write grant space*. So, following the
commit, we do:

xfs_trans_reserve
  xfs_log_regrant
    xlog_grant_head_check(write head, space needed)
    xlog_grant_add_space(write head, space needed)

It's the xlog_grant_head_check() that blocks waiting for write grant
space to come available, and hence we dont over-commit the log space
in such permanent transactions. Yes, we overcommit the reservation
spae, but we never overcommit the write space and hence we don't
overcommit the log space in this situation.

But, what is does point out is that the reserve head can *validly*
overcommit log space and overlap the tail of the log. This doesn't
explain the write grant head getting ahead of the log tail, but
let's ignore that and look at ithe warnings I'm getting from
xlog_space_left() for a moment.

[ 1458.577318] XFS (vdb): xlog_space_left: The grant head is in front of the log tail.
[ 1458.577318]   tail_cycle = 17, tail_bytes = 10223616
[ 1458.577318]   GH   cycle = 19, GH   bytes = 74284
[ 1458.577320] XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 1194
[ 1458.580128] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[ 1458.580128] Modules linked in:
[ 1458.580128] CPU: 0 PID: 16722 Comm: fsstress Not tainted 3.12.0-dgc+ #60
[ 1458.580128] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1458.580128] task: ffff88006d29e1c0 ti: ffff8800592e2000 task.ti: ffff8800592e2000
[ 1458.580128] RIP: 0010:[<ffffffff8149cf32>]  [<ffffffff8149cf32>] assfail+0x22/0x30
[ 1458.580128] RSP: 0018:ffff8800592e3b58  EFLAGS: 00010292
[ 1458.580128] RAX: 000000000000003c RBX: ffff88007764da68 RCX: 000000000000006c
[ 1458.580128] RDX: 00000000000000f2 RSI: 0000000000000046 RDI: 0000000000000246
[ 1458.580128] RBP: ffff8800592e3b58 R08: 0000000000000096 R09: 0000000000001383
[ 1458.580128] R10: 0000000000000000 R11: 0000000000001382 R12: 000000000001222c
[ 1458.580128] R13: ffff8800592e3c8c R14: 0000000000000000 R15: 0000000000000000
[ 1458.580128] FS:  00007f42f1fbe700(0000) GS:ffff88007f800000(0000) knlGS:0000000000000000
[ 1458.580128] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1458.580128] CR2: 00007f42f14c4c60 CR3: 000000005fd19000 CR4: 00000000000006f0
[ 1458.580128] Stack:
[ 1458.580128]  ffff8800592e3b98 ffffffff814f7a47 ffff880000000013 ffffffff0001222c
[ 1458.580128]  ffff8800517ec4f0 ffff8800517ec4f0 ffff88007764da68 00000000000005be
[ 1458.580128]  ffff8800592e3bb8 ffffffff814f8480 ffff88006312be00 ffff88007764da68
[ 1458.580128] Call Trace:
[ 1458.580128]  [<ffffffff814f7a47>] xlog_space_left+0xf7/0x160
[ 1458.580128]  [<ffffffff814f8480>] xlog_grant_push_ail+0x50/0xf0
[ 1458.580128]  [<ffffffff814fa19e>] xfs_log_regrant+0x5e/0x190
[ 1458.580128]  [<ffffffff814a426d>] xfs_trans_reserve+0xfd/0x310
[ 1458.580128]  [<ffffffff814a5596>] ? xfs_trans_commit+0xf6/0x2d0
[ 1458.580128]  [<ffffffff814861fa>] xfs_bmap_finish+0x11a/0x1e0
[ 1458.580128]  [<ffffffff814e5dfb>] xfs_itruncate_extents+0x24b/0x440
[ 1458.580128]  [<ffffffff814e62c8>] xfs_inactive_truncate+0xd8/0x140
[ 1458.580128]  [<ffffffff814e74f0>] xfs_inactive+0x1d0/0x1f0
[ 1458.580128]  [<ffffffff814a0656>] xfs_fs_evict_inode+0xa6/0xf0
[ 1458.580128]  [<ffffffff811bd2a8>] evict+0xb8/0x1b0
[ 1458.580128]  [<ffffffff811bda45>] iput+0x105/0x190
[ 1458.580128]  [<ffffffff811b01e2>] do_unlinkat+0x182/0x2a0
[ 1458.580128]  [<ffffffff811a44ee>] ? ____fput+0xe/0x10
[ 1458.580128]  [<ffffffff810af96c>] ? task_work_run+0xac/0xe0
[ 1458.580128]  [<ffffffff81ae3655>] ? do_device_not_available+0x35/0x60
[ 1458.580128]  [<ffffffff811b3446>] SyS_unlink+0x16/0x20
[ 1458.580128]  [<ffffffff81aead69>] system_call_fastpath+0x16/0x1b

First thing to note: this has come from xfs_itruncate_extents(),
pushing the AIL from the xfs_log_regrant(). There's a good chance we
have just overcommitted the reserve grant head here, because
xlog_grant_push ail() does:

	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);

Yup, in the situation where we have just validly overcommitted the
reserve grant space, xlog_space_left has detected that we've
overcommited the reserve grant space and assert failed.

The fact that overrun here is by a couple of hundred kilobytes is no
surprise - it's in the ballpark of a itruncate transaction unit
reservation (IIRC ~150-200k), and there can be multiple threads in
the same overcommit state at the same time so seeing 300-400k as the
overcommit is not unexpected.

Further, this overcommit situation is handled just fine by the
xlog_space_left() - it returns 0 bytes of log space available - and
so there are no problems with this situation at all.  In fact, now I
understand why the original code in xlog_space_left() handled this
situation silently without emmitting an error:

	else if (tail_cycle + 1 < head_cycle)
		return 0;

200 lines of explanation for 2 lines of code might be some kind of
record. :/

What that means, though, is that I still haven't been able to
reproduce the "head behind tail" conditions that people are
complaining about, and i don't yet have an answer to the
xlog_verify_grant_tail() issue.

I'll take on xlog_verify_grant_tail() where I left it in the
morning.  It's going on midnight and I've already drunk enough
expensive scotch for the evening plowing through this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
