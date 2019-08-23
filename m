Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6773CC3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 13:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FF6C22CEC
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 13:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388904AbfHWNI1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 09:08:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbfHWNI1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Aug 2019 09:08:27 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A647C10C6961;
        Fri, 23 Aug 2019 13:08:26 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFDBF5D9E5;
        Fri, 23 Aug 2019 13:08:25 +0000 (UTC)
Date:   Fri, 23 Aug 2019 09:08:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandan@linux.ibm.com,
        darrick.wong@oracle.com, hch@infradead.org
Subject: Re: [RFC] xfs: Flush iclog containing XLOG_COMMIT_TRANS before
 waiting for log space
Message-ID: <20190823130824.GC53137@bfoster>
References: <20190821110448.30161-1-chandanrlinux@gmail.com>
 <20190821221834.GQ1119@dread.disaster.area>
 <20190822163446.GC24151@bfoster>
 <20190823000636.GE1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823000636.GE1119@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Fri, 23 Aug 2019 13:08:26 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 10:06:36AM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2019 at 12:34:46PM -0400, Brian Foster wrote:
> > On Thu, Aug 22, 2019 at 08:18:34AM +1000, Dave Chinner wrote:
> > > On Wed, Aug 21, 2019 at 04:34:48PM +0530, Chandan Rajendra wrote:
> > > > The following call trace is seen when executing generic/530 on a ppc64le
> > > > machine,
> > > > 
> > > > INFO: task mount:7722 blocked for more than 122 seconds.
> > > >       Not tainted 5.3.0-rc1-next-20190723-00001-g1867922e5cbf-dirty #6
> > > 
> > > can you reproduce this on 5.3-rc5? There were bugs in log recovery
> > > IO in -rc1 that could result in things going wrong...
> > > 
> > > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > > mount           D 8448  7722   7490 0x00040008
> > > > Call Trace:
> > > > [c000000629343210] [0000000000000001] 0x1 (unreliable)
> > > > [c0000006293433f0] [c000000000021acc] __switch_to+0x2ac/0x490
> > > > [c000000629343450] [c000000000fbbbf4] __schedule+0x394/0xb50
> > > > [c000000629343510] [c000000000fbc3f4] schedule+0x44/0xf0
> > > > [c000000629343540] [c0000000007623b4] xlog_grant_head_wait+0x84/0x420
> > > > [c0000006293435b0] [c000000000762828] xlog_grant_head_check+0xd8/0x1e0
> > > > [c000000629343600] [c000000000762f6c] xfs_log_reserve+0x26c/0x310
> > > > [c000000629343690] [c00000000075defc] xfs_trans_reserve+0x28c/0x3e0
> > > > [c0000006293436e0] [c0000000007606ac] xfs_trans_alloc+0xfc/0x2f0
> > > > [c000000629343780] [c000000000749ca8] xfs_inactive_ifree+0x248/0x2a0
> > > > [c000000629343810] [c000000000749e58] xfs_inactive+0x158/0x300
> > > > [c000000629343850] [c000000000758554] xfs_fs_destroy_inode+0x104/0x3f0
> > > > [c000000629343890] [c00000000046850c] destroy_inode+0x6c/0xc0
> > > > [c0000006293438c0] [c00000000074c748] xfs_irele+0x168/0x1d0
> > > > [c000000629343900] [c000000000778c78] xlog_recover_process_one_iunlink+0x118/0x1e0
> > > > [c000000629343960] [c000000000778e10] xlog_recover_process_iunlinks+0xd0/0x130
> > > > [c0000006293439b0] [c000000000782408] xlog_recover_finish+0x58/0x130
> > > > [c000000629343a20] [c000000000763818] xfs_log_mount_finish+0xa8/0x1d0
> > > > [c000000629343a60] [c000000000750908] xfs_mountfs+0x6e8/0x9e0
> > > > [c000000629343b20] [c00000000075a210] xfs_fs_fill_super+0x5a0/0x7c0
> > > > [c000000629343bc0] [c00000000043e7fc] mount_bdev+0x25c/0x2a0
> > > > [c000000629343c60] [c000000000757c48] xfs_fs_mount+0x28/0x40
> > > > [c000000629343c80] [c0000000004956cc] legacy_get_tree+0x4c/0xb0
> > > > [c000000629343cb0] [c00000000043d690] vfs_get_tree+0x50/0x160
> > > > [c000000629343d30] [c0000000004775d4] do_mount+0xa14/0xc20
> > > > [c000000629343db0] [c000000000477d48] ksys_mount+0xc8/0x180
> > > > [c000000629343e00] [c000000000477e20] sys_mount+0x20/0x30
> > > > [c000000629343e20] [c00000000000b864] system_call+0x5c/0x70
> > > > 
> > > > i.e. the mount task gets hung indefinitely due to the following sequence
> > > > of events,
> > > > 
> > > > 1. Test creates lots of unlinked temp files and then shutsdown the
> > > >    filesystem.
> > > > 2. During mount, a transaction started in the context of processing
> > > >    unlinked inode list causes several iclogs to be filled up. All but
> > > >    the last one is submitted for I/O.
> > > > 3. After writing XLOG_COMMIT_TRANS record into the iclog, we will have
> > > >    18532 bytes of free space in the last iclog of the transaction which is
> > > >    greater than 2*sizeof(xlog_op_header_t). Hence
> > > >    xlog_state_get_iclog_space() does not switch over to using a newer iclog.
> > > > 4. Meanwhile, the endio code processing iclogs of the transaction do not
> > > >    insert items into the AIL since the iclog containing XLOG_COMMIT_TRANS
> > > >    hasn't been submitted for I/O yet. Hence a major part of the on-disk
> > > >    log cannot be freed yet.
> > > 
> > > So all those items are still pinned in memory.
> > > 
> > > > 5. A new request for log space (via xfs_log_reserve()) will now wait
> > > >    indefinitely for on-disk log space to be freed.
> > > 
> > > Because nothing has issued a xfs_log_force() for write the iclog to
> > > disk, unpin the objects that it pins in memory, and allow the tail
> > > to be moved forwards.
> > > 
> > > The xfsaild normally takes care of thisi - it gets pushed byt the
> > > log reserve when there's not enough space to in the log for the
> > > transaction before transaction reserve goes to sleep in
> > > xlog_grant_head_wait(). The AIL pushing code is then responsible for
> > > making sure log space is eventually freed. It will issue log forces
> > > if it isn't making progress and so this problem shouldn't occur.
> > > 
> > > So, why has it occurred?
> > > 
> > > The xfsaild kthread should be running at this point, so if it was
> > > pushed it should be trying to empty the journal to move the tail
> > > forward. Why hasn't it issue a log force?
> > > 
> > > 
> > > > To fix this issue, before waiting for log space to be freed, this commit
> > > > now submits xlog->l_iclog for write I/O if iclog->ic_state is
> > > > XLOG_STATE_ACTIVE and iclog has metadata written into it. This causes
> > > > AIL list to be populated and a later call to xlog_grant_push_ail() will
> > > > free up the on-disk log space.
> > > 
> > > hmmm.
> > > 
> > > > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > > > ---
> > > >  fs/xfs/xfs_log.c | 21 +++++++++++++++++++++
> > > >  1 file changed, 21 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > > index 00e9f5c388d3..dc785a6b9f47 100644
> > > > --- a/fs/xfs/xfs_log.c
> > > > +++ b/fs/xfs/xfs_log.c
> > > > @@ -236,11 +236,32 @@ xlog_grant_head_wait(
> > > >  	int			need_bytes) __releases(&head->lock)
> > > >  					    __acquires(&head->lock)
> > > >  {
> > > > +	struct xlog_in_core	*iclog;
> > > > +
> > > >  	list_add_tail(&tic->t_queue, &head->waiters);
> > > >  
> > > >  	do {
> > > >  		if (XLOG_FORCED_SHUTDOWN(log))
> > > >  			goto shutdown;
> > > > +
> > > > +		if (xfs_ail_min(log->l_ailp) == NULL) {
> > > 
> > > This is indicative of the situation. If the AIL is empty, and the
> > > log does not have room for an entire transaction reservation, then
> > > we need to be issuing synchronous transactions in recovery until
> > > such time the AIL pushing can actually function correctly to
> > > guarantee forwards progress for async transaction processing.
> > > 
> > 
> > Hmm, I don't think that addresses the fundamental problem. This
> > phenomenon doesn't require log recovery. The same scenario can present
> > itself after a clean mount or from an idle fs. I think the scenario that
> > plays out here, at a high level, is as follows:
> > 
> 
>   - mount
>   - [log recovery]
>   - xfs_log_mount_finish
>     - calls xfs_log_work_queue()
> 
> > - Heavy transaction workload commences. This continuously acquires log
> >   reservation and transfers it to the CIL as transactions commit.
> > - The CIL context grows until we cross the background threshold, at
> >   which point we schedule a background push.
> > - Background CIL push cycles the current context into the log via the
> >   iclog buffers. The commit record stays around in-core because the last
> >   iclog used for the CIL checkpoint isn't full. Hence, none of the
> >   associated log items make it into the AIL and the background CIL push
> >   had no effect with respect to freeing log reservation.
> > - The same transaction workload is still running and filling up the next
> >   CIL context. If we run out of log reservation before a second
> >   background CIL push comes along, we're basically stuck waiting on
> >   somebody to force the log.
> 
> - every 30s xfs_log_worker() runs, sees the log dirty, triggers
>   a log force. pending commit is flushed to log, dirty objects get
>   moved to AIL, then xfs_log_worker() pushes on the AIL to do
>   periodic background metadata writeback.
> 
> > The things that prevent this at normal runtime are timely execution of
> > background CIL pushes and the background log worker. If for some reason
> > the background CIL push is not timely enough that we consume all log
> > reservation before two background CIL pushes occur from the time the
> > racing workload begins (i.e. starting from an idle system such that the
> > AIL is empty), then we're stuck waiting on the background log worker to
> > force the log from the first background CIL push, populate the AIL and
> > get things moving again.
> 
> Right, this does not deadlock - it might pause for a short while
> while waiting for the log worker to run and issue a log force. I
> have never actually seen it happen in all my years of "mkfs; mount;
> fsmark" testing that places a /massive/ metadata modification
> workload on a pristine, newly mounted filesystems....
> 

Neither have I. That's why I'm asking for more details on how this
triggers. :) Whatever factors contribute to this particular instance may
or may not apply outside of log recovery context.

> As it is, we've always used the log worker as a watchdog in this
> way. The fact is that we have very few situations left in the code
> where it needs to act as a watchdog - delayed logging actually
> negated the vast majority of problems that required the periodic log
> force to get out of trouble because individual transactions no
> longer needed to wait on iclog space to make progress...
> 

Yes, the description I wrote up already explains that the background log
worker changes the symptom from a deadlock to a stall. The defaults
allow for a stall of up to 30s, but custom configuration allows for a
stall of up to 2 hours.

> > IOW, the same essential problem is reproducible outside of log
> > recovery in the form of stalls as opposed to deadlocks via an
> > artificial background CIL push delay (i.e., think workqueue or
> > xc_cil_ctx lock starvation) and an elevated xfssyncd_centisecs.
> > We aren't stuck forever because the background log worker will run
> > eventually, but it could certainly be a dead stall of minutes
> > before that occurs.
> 
> I don't think addressing it in xlog_grant_head_wait() fixes the
> problem fully, either.  If no other transaction comes in, then the
> ones already blocked (because the AIL was not empty when they tried
> to reserve space) will end up still blocked because nothing has
> kicked the code in the transaction reservation code. So putting the
> log force into the grant head wait code is not sufficient by itself.
> 
> > I think this
> > could still be addressed at transaction commit or reservation time, but
> > I think the logic needs to be more generic and based on log reservation
> > pressure rather than the context from which this particular test happens
> > to reproduce.
> 
> Log reservation pressure is what xlog_grant_push_ail() detects and
> that pressure is transferred to the AIL pushing code to clean dirty
> log items and move the tail of the log forward. It's right there
> where Chandan added the log force. :)
> 
> IOWs, xlog_grant_push_ail() tells the xfsaild how much log space to
> make available. If the log is full, then xlog_grant_push_ail() will
> already be telling the AIL to push and will be waking it up.
> However, the aild will see the AIL empty and go right back to sleep.
> That's likely the runtime problem here - the mechanism that pushes
> the log tail forwards is not realising that the log needs pushing
> via a log force.
> 
> IOWs, I suspect the xfsaild is the right place to take the action,
> because AIL pushing is triggered by much more than just log
> reservations. It gets kicked by memory reclaim, the log worker, new
> transactions, etc and so if a transaction doesn't kick it when it
> gest stuck like this, something else will.
> 

Perhaps, I could see that as an option too. TBH, it's not clear to me
where the best place to fix this is. I want to know more about the
reproducer first. My comment above was just that I'm not convinced the
previously proposed logic to force based on log recovery context is
correct.

> > If this is all on the right track, I'm still curious if/how you're
> > getting into a situation where all log reservation is held up in the CIL
> > before a couple background pushes occur.
> 
> I'd guess that it could be reproduced via a single CPU machine and
> non-preempt kernel. We've already replayed all the unlink
> transactions, so the buffer/inode caches are fully primed. If all
> unlink removal transactions the buffer/inode cache, then it won't
> block anywhere and will never yield the CPU. Hence the CIL push
> kworker thread doesn't get to run before the unlinks run the log out
> of space.
> 

Yeah, I wouldn't expect that for a ppc64 system, but I suppose this
could be a VM or something too. Chandan?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
