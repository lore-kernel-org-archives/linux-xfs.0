Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B04FC4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 13:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AA7A222C3
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 13:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfIZNT5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 09:19:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfIZNT5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 09:19:57 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D45D6307D84B;
        Thu, 26 Sep 2019 13:19:56 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CC05600CE;
        Thu, 26 Sep 2019 13:19:56 +0000 (UTC)
Date:   Thu, 26 Sep 2019 09:19:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: push the grant head when the log head moves
 forward
Message-ID: <20190926131954.GD26832@bfoster>
References: <20190906000205.GL1119@dread.disaster.area>
 <20190906131014.GA62719@bfoster>
 <20190907151050.GA3967@bfoster>
 <20190908232632.GD16973@dread.disaster.area>
 <20190910095628.GA16331@bfoster>
 <20190910233858.GM16973@dread.disaster.area>
 <20190912134606.GA33594@bfoster>
 <20190917043156.GR2229799@magnolia>
 <20190917124827.GD2868@bfoster>
 <20190924171609.GP5340@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924171609.GP5340@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 26 Sep 2019 13:19:56 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 24, 2019 at 10:16:09AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 17, 2019 at 08:48:27AM -0400, Brian Foster wrote:
> > On Mon, Sep 16, 2019 at 09:31:56PM -0700, Darrick J. Wong wrote:
> > > On Thu, Sep 12, 2019 at 09:46:06AM -0400, Brian Foster wrote:
> > > > On Wed, Sep 11, 2019 at 09:38:58AM +1000, Dave Chinner wrote:
> > > > > On Tue, Sep 10, 2019 at 05:56:28AM -0400, Brian Foster wrote:
> > > > > > On Mon, Sep 09, 2019 at 09:26:32AM +1000, Dave Chinner wrote:
> > > > > > > On Sat, Sep 07, 2019 at 11:10:50AM -0400, Brian Foster wrote:
> > > > > > > > This is an instance of xfsaild going idle between the time this
> > > > > > > > new AIL push sets the target based on the iclog about to be
> > > > > > > > committed and AIL insertion of the associated log items,
> > > > > > > > reproduced via a bit of timing instrumentation.  Don't be
> > > > > > > > distracted by the timestamps or the fact that the LSNs do not
> > > > > > > > match because the log items in the AIL end up indexed by the start
> > > > > > > > lsn of the CIL checkpoint (whereas last_sync_lsn refers to the
> > > > > > > > commit record). The point is simply that xfsaild has completed a
> > > > > > > > push of a target that hasn't been inserted yet.
> > > > > > > 
> > > > > > > AFAICT, what you are showing requires delaying of the CIL push to the
> > > > > > > point it violates a fundamental assumption about commit sizes, which
> > > > > > > is why I largely think it's irrelevant.
> > > > > > > 
> > > > > > 
> > > > > > The CIL checkpoint size is an unrelated side effect of the test I
> > > > > > happened to use, not a fundamental cause of the problem it demonstrates.
> > > > > > Fixing CIL checkpoint size issues won't change anything. Here's a
> > > > > > different variant of the same problem with a small enough number of log
> > > > > > items such that background CIL pushing is not a factor:
> > > > > > 
> > > > > >        <...>-79670 [000] ...1 56126.015522: xfs_log_force: dev 253:4 lsn 0x0 caller xfs_log_worker+0x2f/0xf0 [xfs]
> > > > > > kworker/0:1H-220   [000] ...1 56126.030587: __xlog_grant_push_ail: 1596: threshold_lsn 0x1000032e4
> > > > > > 	...
> > > > > >        <...>-81293 [000] ...2 56126.032647: xfs_ail_delete: dev 253:4 lip 00000000cbe82125 old lsn 1/13026 new lsn 1/13026 type XFS_LI_INODE flags IN_AIL
> > > > > >        <...>-81633 [000] .... 56126.053544: xfsaild: 588: idle ->ail_target 0x1000032e4
> > > > > > kworker/0:1H-220   [000] ...2 56127.038835: xfs_ail_insert: dev 253:4 lip 00000000a44ab1ef old lsn 0/0 new lsn 1/13028 type XFS_LI_INODE flags IN_AIL
> > > > > > kworker/0:1H-220   [000] ...2 56127.038911: xfs_ail_insert: dev 253:4 lip 0000000028d2061f old lsn 0/0 new lsn 1/13028 type XFS_LI_INODE flags IN_AIL
> > > > > > 	....
> > > > > >
> > > > > > This sequence starts with one log item in the AIL and some number of
> > > > > > items in the CIL such that a checkpoint executes from the background log
> > > > > > worker. The worker forces the CIL and log I/O completion issues an AIL
> > > > > > push that is truncated by the recently updated ->l_last_sync_lsn due to
> > > > > > outstanding transaction reservation and small AIL size. This push races
> > > > > > with completion of a previous push that empties the AIL and iclog
> > > > > > callbacks insert log items for the current checkpoint at the LSN target
> > > > > > xfsaild just idled at.
> > > > > 
> > > > > I'm just not seeing what the problem here is. The behaviour you are
> > > > > describing has been around since day zero and doesn't require the
> > > > > addition of an ail push from iclog completion to trigger.  Prior to
> > > > > this series, it would be:
> > > > > 
> > > > 
> > > > A few days ago you said that if we're inserting log items before the
> > > > push target, "something is very wrong." Since this was what I was
> > > > concerned about, I attempted to manufacture the issue to demonstrate.
> > > > You suggested the first reproducer I came up with was a separate problem
> > > > (related to CIL size issues), so I came up with the one above to avoid
> > > > that distraction. Now you're telling me this has always happened and is
> > > > fine..
> > > > 
> > > > While I don't think this is quite accurate (more below), I do find this
> > > > reasoning somewhat amusing in that it essentially implies that this
> > > > patch itself is dubious. If this new AIL push is required to fix a real
> > > > issue, and this race is essentially manifest as implied, then this patch
> > > > can't possibly reliably fix the original problem. Anyways, that is
> > > > neither here nor there..
> > > > 
> > > > All of the details of this particular issue aside, I do think there's a
> > > > development process problem here. It shouldn't require an extended game
> > > > of whack-a-mole with this kind of inconsistent reasoning just to request
> > > > a trivial change to a patch (you also implied in a previous response it
> > > > was me wasting your time on this topic) that closes an obvious race and
> > > > otherwise has no negative effect. Someone is being unreasonable here and
> > > > I don't think it's me. More importantly, discussion of open issues
> > > > shouldn't be a race against the associated patch being merged. :/
> > > > 
> > > > > process 1	reservation	log completion	xfsaild
> > > > > <completes metadata IO>
> > > > >   xfs_ail_delete()
> > > > >     mlip_changed
> > > > >     xlog_assign_tail_lsn_locked()
> > > > >       ail empty, sets l_last_sync = 0x1000032e2
> > > > >     xfs_log_space_wake()
> > > > > 				xlog_state_do_callback
> > > > > 				  sets CALLBACK
> > > > > 				  sets last_sync_lsn to iclog head
> > > > > 				    -> 0x1000032e4
> > > > > 				  <drops icloglock, gets preempted>
> > > > > 		<wakes>
> > > > > 		xlog_grant_head_wait
> > > > > 		  free_bytes < need_bytes
> > > > > 		    xlog_grant_push_ail()
> > > > > 		      xlog_push_ail()
> > > > > 		        ->ail_target 0x1000032e4
> > > > > 		<sleeps>
> > > > > 						<wakes>
> > > > > 						sets prev target to 0x1000032e4
> > > > > 						sees empty AIL
> > > > > 						<sleeps>
> > > > > 				    <runs again>
> > > > > 				    runs callbacks
> > > > > 				      xfs_ail_insert(lsn = 0x1000032e4)
> > > > > 
> > > > > and now we have the AIL push thread asleep with items in it at the
> > > > > push threshold.  IOWs, what you describe has always been possible,
> > > > > and before the CIL was introduced this sort of thing happened quite
> > > > > a bit because iclog completions freed up much less space in the log
> > > > > than a CIL commit completion.
> > > > > 
> > > > 
> > > > I was suspicious that this could occur prior to this change but I hadn't
> > > > confirmed. The scenario documented above cannot occur because a push on
> > > > an empty AIL has no effect. The target doesn't move and the task isn't
> > > > woken. That said, I still suspect the race can occur with the current
> > > > code via between a grant head waiter, AIL emptying and iclog completion.
> > > > 
> > > > This just speaks to the frequency of the problem, though. I'm not
> > > > convinced it's something that happens "quite a bit" given the nature of
> > > > the 3-way race. I also don't agree that existence of a historical
> > > > problem somehow excuses introduction a new variant of the same problem.
> > > > Instead, if this patch exposes a historical problem that simply had no
> > > > noticeable impact to this point, we should probably look into whether it
> > > > needs fixing too.
> > > > 
> > > > > It's not a problem, however, because if we are out of transaction
> > > > > reservation space we must have transactions in progress, and as long
> > > > > as they make progress then the commit of each transaction will end
> > > > > up calling xlog_ungrant_log_space() to return the unused portion of
> > > > > the transaction reservation. That calls xfs_log_space_wake() to
> > > > > allow reservation waiters to try to make progress.
> > > > > 
> > > > 
> > > > Yes, this is why I don't see immediate side effects in the tests I've
> > > > run so far. The assumptions you're basing this off are not always true,
> > > > however. Particularly on smaller (<= 1GB) filesystems, it's relatively
> > > > easy to produce conditions where the entire reservation space is
> > > > consumed by open transactions that don't ultimately commit anything to
> > > > the log subsystem and thus generate no forward progress.
> > > > 
> > > > > If there's still not enough space reservation after the transaction
> > > > > in progress has released it's reservation, then it goes back to
> > > > > sleep. As long as we have active transactions in progress while
> > > > > there are transaction reservations waiting on reservation space,
> > > > > there will be a wakeup vector for the reservation independent of
> > > > > the CIL, iclogs and AIL behaviour.
> > > > > 
> > > > 
> > > > We do have clean transaction cancel and error scenarios, existing log
> > > > deadlock vectors, increasing reliance on long running transactions via
> > > > deferred ops, scrub, etc. Also consider the fact that open transactions
> > > > consume considerably more reservation than committed transactions on
> > > > average.
> > > > 
> > > > I'm not saying it's likely for a real world workload to consume the
> > > > entirety of log reservation space via open transactions and then release
> > > > it without filesystem modification (and then race with log I/O and AIL
> > > > emptying), but from the perspective of proving the existence of a bug
> > > > it's really not that difficult to produce. I've not seen a real world
> > > > workload that reproduces the problems fixed by any of these patches
> > > > either, but we still fix them.
> > > > 
> > > > > [ Yes, there was a bug here, in the case xfs_log_space_wake() did
> > > > > not issue a wakeup because of not enough space being availble and
> > > > > the push target was limited by the old log head location. i.e.
> > > > > nothing ever updated the push target to reflect the new log head and
> > > > > so the tail might never get moved now. That particular bug was fixed
> > > > > by a an earlier patch in the series, so we can ignore it here. ]
> > > > > 
> > > > > IOWs, if the AIL is empty, the CIL cannot consume more than 25% of
> > > > > the log space, and we have transactions waiting on log reservation
> > > > > space, then we must have enough transactions in progress to cover at
> > > > > least 75% of the log space. Completion of those transactions will
> > > > > wake waiters and, if necessary, push the AIL again to keep the log
> > > > > tail moving appropriately. This handles the AIL empty and "insert
> > > > > before target" situations you are concerned about just fine, as long
> > > > > as we have a guarantee of forwards progress. Bounding the CIL size
> > > > > provides that forwards progress guarantee for the CIL...
> > > > > 
> > > > 
> > > > I think you have some tunnel vision or something going on here with
> > > > regard to the higher level architectural view of how things are supposed
> > > > to operate in a normal running/steady state vs simply what can and
> > > > cannot happen in the code. I can't really tell why/how, but the only
> > > > suggestion I can make is to perhaps separate from this high level view
> > > > of things and take a closer look at the code. This is a simple code bug,
> > > > not some grand architectural flaw. The context here is way out of whack.
> > > > The repeated unrelated and overblown architectural assertions come off
> > > > as indication of lack of any real argument to allow this race to live.
> > > > There is simply no such guarantee of forward progress in all scenarios
> > > > that produce the conditions that can cause this race.
> > > > 
> > > > Yet another example:
> > > > 
> > > >            <...>-369   [002] ...2   220.055746: xfs_ail_insert: dev 253:4 lip 00000000ddb123f2 old lsn 0/0 new lsn 1/248 type XFS_LI_INODE flags IN_AIL
> > > >            <...>-27    [003] ...1   224.753110: xfs_log_force: dev 253:4 lsn 0x0 caller xfs_log_worker+0x2f/0xf0 [xfs]
> > > >            <...>-404   [003] ...1   224.775551: __xlog_grant_push_ail: 1596: threshold_lsn 0x1000000fa
> > > >      kworker/3:1-39    [003] ...2   224.777953: xfs_ail_delete: dev 253:4 lip 00000000ddb123f2 old lsn 1/248 new lsn 1/248 type XFS_LI_INODE flags IN_AIL
> > > >     xfsaild/dm-4-1034  [000] ....   224.797919: xfsaild: 588: idle ->ail_target 0x1000000fa
> > > >     kworker/3:1H-404   [003] ...2   225.841198: xfs_ail_insert: dev 253:4 lip 000000006845aeed old lsn 0/0 new lsn 1/250 type XFS_LI_INODE flags IN_AIL
> > > >      kworker/3:1-39    [003] ...1   254.962822: xfs_log_force: dev 253:4 lsn 0x0 caller xfs_log_worker+0x2f/0xf0 [xfs]
> > > > 	...
> > > >      kworker/3:2-1920  [003] ...1  3759.291275: xfs_log_force: dev 253:4 lsn 0x0 caller xfs_log_worker+0x2f/0xf0 [xfs]
> > > > 
> > > > 
> > > > # cat /sys/fs/xfs/dm-4/log/log_*lsn
> > > > 1:252
> > > > 1:250
> > > > 
> > > > This instance of the race uses the same serialization instrumentation to
> > > > control execution timing and whatnot as before (i.e. no functional
> > > > changes). First, an item is inserted into the AIL. Immediately after AIL
> > > > insertion, another transaction commits to the CIL (not shown in the
> > > > trace). The background log worker comes around a few seconds later and
> > > > forces the log/CIL. The checkpoint for this log force races with an AIL
> > > > delete and idle (same as before). AIL insertion occurs at the push
> > > > target xfsaild just idled at, but this time reservation pressure
> > > > relieves and the filesystem goes idle.
> > > > 
> > > > At this point, nothing occurs on the fs except for continuous background
> > > > log worker jobs. Note the timestamp difference between the first
> > > > post-race log force and the last in the trace. The log worker runs at
> > > > the default 30s interval and has run repeatedly for almost an hour while
> > > > failing to push the AIL and subsequently cover the log. To confirm the
> > > > AIL is populated, see the log head/tail LSNs reported via sysfs. This
> > > > state persists indefinitely so long as the fs is idle. This is a bug.
> > > 
> > > /me stumbles back in after ~2wks, and has a few questions:
> > > 
> > 
> > Heh, welcome back.. ;)
> > 
> > > 1) Are these concerns a reason to hold up this series, or are they a
> > > separate bug lurking in the code being touched by the series?  AFAICT I
> > > think it's the second, but <shrug> my brain is still mush.
> > > 
> > 
> > A little of both I guess. To Dave's earlier point, I think this
> > technically can happen in the existing code as a 3-way race between the
> > aforementioned tasks (just not the way it was described). OTOH, I'm not
> > sure what this has to do with the fact that the new code being added is
> > racy on its own (or since when discovery of some old bug justifies
> > adding new ones..?). The examples shown above are fundamentally races
> > between log I/O completion and xfsaild. The last one shows the log
> > remain uncovered indefinitely on an idle fs (which is not a corruption
> > or anything, but certainly a bug) simply because that's the easiest side
> > effect to reproduce. I'm fairly confident at this point that one could
> > be manufactured into a similar log deadlock if we really wanted to try,
> > but that would be much more difficult and TBH I'm tired of burning
> > myself out on these kind of objections to obvious and easily addressed
> > landmines. How likely is it that somebody would hit these problems?
> > Probably highly unlikely. How likely is it somebody would hit this
> > problem before whatever problem this patch fixes? *shrug*
> > 
> > I don't think it's a reason to hold up the series, but at the same time
> > this patch is unrelated to the original problem. IIRC, it fell out of
> > some other issue reproduced with a different experimental hack/fix (that
> > was eventually replaced) to the original problem. FWIW, I'm annoyed with
> > the lazy approach to review here more than anything. In hindsight, if I
> > knew the feedback was going to be dismissed and the patchset rolled
> > forward and merged, perhaps I should have just nacked the subsequent
> > reposts to make the objection clear.
> 
> :(
> 
> I'm sorry you feel that way.  I myself don't feel that my own handling
> of this merge window has been good, between feeling pressured to get the
> branches ready to go before vacation and for-next becoming intermittent
> right around the same time.  Those both decrease my certainty about
> what's going in the next merge and increases my own anxieties, and it
> becomes a competition in my head between "I can add it now and revert it
> later as a regression fix" vs. "if I don't add it I'll wonder if it was
> necessary".
> 

Eh, it is what it is. I don't expect to always agree on everything. I
could/should have noted the objection more clearly on subsequent posts
and will try to do so in the future. Conversely, a quick "there appears
to be a disagreement, the maintainer is making a decision" note on the
list would be appreciated should that play out in the future.

Just my .02 (and not saying this is some kind of pattern or anything),
but I do think the whole "merge it since we can revert it from for-next
later if it causes problems" thing kind of sets a low bar and a bad
precedent. What's the point of reviewing patches with that approach?
Beyond discouraging review, it also diminishes sense of responsibility
for the quality of affected areas of code IMO.

> Anyway, I /think/ the end result is that if the AIL gets stuck /and/ the
> system goes down before it becomes unstuck, then there'll be more work
> for log recovery to do, because we failed to checkpoint everything that
> we possibly could have before the crash?
> 

Yep, in this particular variant at least.

> So AFAICT it's not a critical disaster bug but I would like to study
> this situation some more, particularly now that we have ~2mos for
> stabilizing things.
> 

Right, this is definitely not a critical bug. AFAICT neither is the bug
fixed by the patch.

Note that just on principle I'm not going to spend a whole lot of time
testing for things post-merge that I consider and/or call out as
problems during review and end up ignored. The point of addressing such
things during review is to avoid those problems in the first place. In
this particular case, why spend time on that when it is so relatively
simple to relocate the xlog_grant_push_ail() call to after callback
processing? I still don't understand that tbh.

> > I dunno, not my call on what to do with it now. Feel free to add my
> > Nacked-by: to the upstream commit I guess so I at least remember this
> > when/if considering whether to backport it anywhere. :/
> 
> (/me continues to wish there was an easy way to add tagging to a commit,
> particularly when it comes well after the fact.)
> 

No big deal, this was all in hindsight.

> > > 2) Er... how do you get the log stuck like this?  I see things earlier
> > > in the thread like "open transactions that don't ultimately commit
> > > anything to the log subsystem" and think "OH, you mean xfs_scrub!"
> > > 
> > 
> > That's one thing I was thinking about but I didn't end up looking into
> > it (does scrub actually acquire log reservation?).
> 
> If you invoke the scrub ioctl with IFLAG_REPAIR set, it allocates a
> non-empty transaction (itruncate, iirc) to do the check and rebuild the
> data structure.  If the item is ok then it'll cancel the transaction.
> 

Ah, tr_itruncate is actually larger than tr_write too (which I assume is
why it's used here)...

> > For a more simple
> > example, consider a bunch of threads running into quota block allocation
> > failures where a system is also under memory pressure. On filesystems
> > with smaller logs, it only takes a handful of such threads to bash the
> > reservation grant head against the log tail even though the log is empty
> > (and doing so without ever committing anything to the log).
> > 
> > Note that this by itself isn't what gets the log "stuck" in the most
> > recent example (note: not deadlocked), but rather if we're in a state
> > where the grant head is close enough to the log head (such that we AIL
> > push the items associated with the current checkpoint before it inserts)
> > when log I/O completion happens to race with AIL emptying as described.
> 
> Hmm... I wonder if we could reproduce this by formatting a filesystem
> with a small log; running a slow moving thread that touches a file once
> per second (or something to generate a moderate amount of workload) and
> monitors the log to watch its progress; and then kicking off dozens of
> threads to invoke IFLAG_REPAIR scrubbers on some other non-corrupt part
> of the filesystem?
> 

Yeah, given the above and if we're able to kick off enough concurrent
scrubbers such that they do nontrivial work and don't block eachother
before transaction allocation, that looks like it could result in
similar behavior wrt to reservation. Concurrent allocbt scrubs perhaps?
If so, on an otherwise default sized 100g fs, concurrent repair scrubs
to anything more than 18 or so AGs (based on tr_itruncate size) would be
enough to cause AIL pushing from the log subsystem (with a minimum size
log, I think something like 3 AGs would be enough) without any guarantee
that any of those transactions commit. The rest is just a simple race
between AIL pushing a fabricated target and xfsaild.

BTW, another thing I noticed with regard to timing is that on 32-bit
systems the push target is updated under ->ail_lock, which I think means
the xfs_ail_push() call from log I/O completion can serialize behind an
xfsaild push in progress (after the former has checked for a !empty
AIL). I'm not sure that's enough to make the race easy to reproduce
without explicit delay injection, but it's a step in that direction..

Brian

> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > Cheers,
> > > > > 
> > > > > Dave.
> > > > > -- 
> > > > > Dave Chinner
> > > > > david@fromorbit.com
