Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED707C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 23:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5BF4208C2
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 23:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfH2XIZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 19:08:25 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55824 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727826AbfH2XIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 19:08:25 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 71AD143E86D;
        Fri, 30 Aug 2019 09:08:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3TWb-0001Ro-9P; Fri, 30 Aug 2019 09:08:17 +1000
Date:   Fri, 30 Aug 2019 09:08:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        hch@infradead.org
Subject: Re: [RFC] xfs: Flush iclog containing XLOG_COMMIT_TRANS before
 waiting for log space
Message-ID: <20190829230817.GW1119@dread.disaster.area>
References: <20190821110448.30161-1-chandanrlinux@gmail.com>
 <3457989.EyS6152c1k@localhost.localdomain>
 <20190826003253.GK1119@dread.disaster.area>
 <783535067.D5oYYkGoWf@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <783535067.D5oYYkGoWf@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=NAwevfv__Z65nvar3uUA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 10:51:59AM +0530, Chandan Rajendra wrote:
> On Monday, August 26, 2019 6:02 AM Dave Chinner wrote: 
> > On Sun, Aug 25, 2019 at 08:35:17PM +0530, Chandan Rajendra wrote:
> > > On Friday, August 23, 2019 7:08 PM Chandan Rajendra wrote:
> > > 
> > > Dave, With the above changes made in xfs_trans_reserve(), mount task is
> > > deadlocking due to the following,
> > > 1. With synchronous transactions, __xfs_trans_commit() now causes iclogs to be
> > > flushed to the disk and hence log items to be ultimately moved to AIL.
> > > 2. xfsaild task is woken up, which acts in items on AIL.
> > > 3. After some time, we stop issuing synchronous transactions because AIL has
> > >    log items in its list and hence !xfs_ail_min(tp->t_mountp->m_ail) evaluates to
> > >    false. In xfsaild_push(), "XFS_LSN_CMP(lip->li_lsn, target) <= 0"
> > >    evaluates to false on the first iteration of the while loop. This means we
> > >    have a log item whose LSN is larger than xfs_ail->ail_target at the
> > >    beginning of the AIL.
> > 
> > The push target for xlog_grant_push_ail() is to free 25% of the log
> > space. So if all the items in the AIL are not within 25% of the tail
> > end of the log, there's nothing for the AIL to push. This indicates
> > that there is at least 25% of physical log space free.
> 
> Sorry for the late response. I was trying to understand the code flow.
> 
> Here is a snippet of perf trace explaining what is going on,
> 
> 	 760881:           mount  8654 [002]   216.813041:                         probe:xlog_grant_push_ail: (c000000000765864) comm="xfsaild/loop1" threshold_cycle_s32=3 threshold_block_s32=3970 need_bytes_s32=389328 last_sync_cycle_u32=2 last_sync_block_u32=19330 free_threshold_s32=5120 free_bytes_s32=383756 free_blocks_s32=749 l_logsize=10485760 reserve_cycle_s32=3 reserve_block_s32=9513204(~18580 blocks) tail_cycle_s32=2 tail_block_s32=19330

So this looks like last_sync_lsn is 2/19330, and the transaction
reservation is ~380kB, or close on 3% of the log. The reserve grant
head is at 3/18580, so we're ~700 * 512 = ~350kB of reservation
remaining. Yup, so we are definitely in the "go to sleep and wait"
situation here.

> 	 786576: kworker/4:1H-kb  1825 [004]   217.041079:                       xfs:xfs_log_assign_tail_lsn: dev 7:1 new tail lsn 2/19333, old lsn 2/19330, last sync 3/18501

200ms later the tail has moved, and last_sync_lsn is now 3/18501.
i.e. the iclog writes have made it to disk, and the items have been
moved into the AIL. I don't know where that came from, but I'm
assuming it's an IO completion based on it being run from a
kworker context that doesn't have an "xfs-" name prefix(*).

As the tail has moved, this should have woken the anything sleeping
on the log tail in xlog_grant_head_wait() via a call to
xfs_log_space_wake(). The first waiter should wake, see that there
still isn't room in the log (only 3 sectors were freed in the log,
we need at least 60). That woken process should then run
xlog_grant_push_ail() again and go back to sleep.

(*) I have a patch that shortens "s/kworker/kw/" so that you can
actually see the name of the kworker in the 16 byte field we have
for the task name. We really should just increase current->comm to
32 bytes.

> 	 786577: kworker/4:1H-kb  1825 [004]   217.041087:                       xfs:xfs_log_assign_tail_lsn: dev 7:1 new tail lsn 2/19333, old lsn 2/19330, last sync 3/18501
> 	 793653:   xfsaild/loop1  8661 [004]   265.407708:                probe:xfsaild_push_last_pushed_lsn: (c000000000784644) comm="xfsaild/loop1" cycle_lsn_u32=0 block_lsn_u32=0 target_cycle_lsn_u32=2 target_block_lsn_u32=19330
> 	 793654:   xfsaild/loop1  8661 [004]   265.407717:              probe:xfsaild_push_min_lsn_less_than: (c0000000007846a0) comm="xfsaild/loop1" less_than_s32=0 cycle_lsn_u32=2 block_lsn_u32=19333 lip_x64=0xc000000303fb4a48

Ans some 40s later the xfsaild is woken by something, sees there's
nothing to do, and goes back to sleep. I don't see the process
sleeping on the grant head being ever being woken and calling
xlog_grant_push_ail(), which would see the new last_sync_lsn and
move the push target....

From this trace, it looks like the problem here is a missing or
incorrectly processed wakeup when the log tail moves.

Unfortunately, you haven't used the built in trace points for
debugging log space hangs so I can't tell anything more than this.
i.e the trace we need contains these build in tracepoints:

# trace-cmd record -e xfs_log\* -e xfs_ail\* sleep 120 &
# <run workload that hangs within 120s>

<wait for trace-cmd to exit>
# trace-cmd report | gzip > trace.txt.gz

as that will record all transaction reservations, grant head
manipulations, changes to the tail lsn, when processes sleep on the
grant head and are worken, AIL insert/move/delete, etc.

This will generate a -lot- of data. I often generate and analyse
traces in the order of tens of GBs of events to track down issues
like this, because the problem is often only seen in a single trace
event in amongst the millions that are recorded....

And if we need more info, then we add the appropriate tracepoints
into xlog_grant_push_ail, xfsaild_push, etc under those tracepoint
namespaces, so next time we have a problem we don't ahve to write
custom tracepoints.....

> i.e the log size was 2560 * 4096 = 10485760 bytes.

The default minimum size.

> > I suspect that this means the CIL is overruning it's background push
> > target by more than expected probably because the log is so small. That leads
> > to the outstanding CIL pending commit size (the current CIL context
> > and the previous CIL commit that is held off by the uncommited
> > iclog) is greater than the AIL push target, and so nothing will free
> > up more log space and wake up the transaction waiting for grant
> > space.
> > 
> > e.g. the previous CIL context commit might take 15% of the log
> > space, and the current CIL has reserved 11% of the log space.
> > Now new transactions reservations have run out of grant space and we
> > push on the ail, but it's lowest item is at 26%, and so the AIL push
> > does nothing and we're stuck because the CIL has pinned 26% of the
> > log space.
> > 
> > As a test, can you run the test with larger log sizes? I think
> > the default used was about ~3600 blocks, so it you step that up by
> > 500 blocks at a time we should get an idea of the size of the
> > overrun by the size of the log where the hang goes away. A
> > trace of the transaction reservations and AIL pushing would also be
> > insightful.
> 
> After increasing the log size to 4193 blocks (i.e. 4193 * 4k = 17174528
> bytes) and also the patch applied, I don't see the dead lock happening.

Likely because now the 380k transaction reservation is only 2% of the
log instead of close to 4% of the log, and so the overrun isn't
large enough to trigger whatever wakeup issue we have....

> Meanwhile, I am planning to read more code to map the explaination
> provided below.

Can you get a complete trace (as per above) of a hang? we're going
to need that trace to validate any analysis you do yourself,
anyway...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
