Return-Path: <SRS0=fGHA=XF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7F4C49ED9
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 23:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2971E21D7B
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 23:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfIJXjD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Sep 2019 19:39:03 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44594 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbfIJXjD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Sep 2019 19:39:03 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B1C3543E87C;
        Wed, 11 Sep 2019 09:38:58 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i7pis-0006nF-4c; Wed, 11 Sep 2019 09:38:58 +1000
Date:   Wed, 11 Sep 2019 09:38:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: push the grant head when the log head moves
 forward
Message-ID: <20190910233858.GM16973@dread.disaster.area>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-8-david@fromorbit.com>
 <20190904193442.GA52970@bfoster>
 <20190904225056.GL1119@dread.disaster.area>
 <20190905162533.GA59149@bfoster>
 <20190906000205.GL1119@dread.disaster.area>
 <20190906131014.GA62719@bfoster>
 <20190907151050.GA3967@bfoster>
 <20190908232632.GD16973@dread.disaster.area>
 <20190910095628.GA16331@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910095628.GA16331@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=rulXVUxBDzVKczav9bQA:9 a=lmzFM_kOEwoBC5IQ:21
        a=dZFMB0mr9m0UF6ok:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 10, 2019 at 05:56:28AM -0400, Brian Foster wrote:
> On Mon, Sep 09, 2019 at 09:26:32AM +1000, Dave Chinner wrote:
> > On Sat, Sep 07, 2019 at 11:10:50AM -0400, Brian Foster wrote:
> > > This is an instance of xfsaild going idle between the time this
> > > new AIL push sets the target based on the iclog about to be
> > > committed and AIL insertion of the associated log items,
> > > reproduced via a bit of timing instrumentation.  Don't be
> > > distracted by the timestamps or the fact that the LSNs do not
> > > match because the log items in the AIL end up indexed by the start
> > > lsn of the CIL checkpoint (whereas last_sync_lsn refers to the
> > > commit record). The point is simply that xfsaild has completed a
> > > push of a target that hasn't been inserted yet.
> > 
> > AFAICT, what you are showing requires delaying of the CIL push to the
> > point it violates a fundamental assumption about commit sizes, which
> > is why I largely think it's irrelevant.
> > 
> 
> The CIL checkpoint size is an unrelated side effect of the test I
> happened to use, not a fundamental cause of the problem it demonstrates.
> Fixing CIL checkpoint size issues won't change anything. Here's a
> different variant of the same problem with a small enough number of log
> items such that background CIL pushing is not a factor:
> 
>        <...>-79670 [000] ...1 56126.015522: xfs_log_force: dev 253:4 lsn 0x0 caller xfs_log_worker+0x2f/0xf0 [xfs]
> kworker/0:1H-220   [000] ...1 56126.030587: __xlog_grant_push_ail: 1596: threshold_lsn 0x1000032e4
> 	...
>        <...>-81293 [000] ...2 56126.032647: xfs_ail_delete: dev 253:4 lip 00000000cbe82125 old lsn 1/13026 new lsn 1/13026 type XFS_LI_INODE flags IN_AIL
>        <...>-81633 [000] .... 56126.053544: xfsaild: 588: idle ->ail_target 0x1000032e4
> kworker/0:1H-220   [000] ...2 56127.038835: xfs_ail_insert: dev 253:4 lip 00000000a44ab1ef old lsn 0/0 new lsn 1/13028 type XFS_LI_INODE flags IN_AIL
> kworker/0:1H-220   [000] ...2 56127.038911: xfs_ail_insert: dev 253:4 lip 0000000028d2061f old lsn 0/0 new lsn 1/13028 type XFS_LI_INODE flags IN_AIL
> 	....
>
> This sequence starts with one log item in the AIL and some number of
> items in the CIL such that a checkpoint executes from the background log
> worker. The worker forces the CIL and log I/O completion issues an AIL
> push that is truncated by the recently updated ->l_last_sync_lsn due to
> outstanding transaction reservation and small AIL size. This push races
> with completion of a previous push that empties the AIL and iclog
> callbacks insert log items for the current checkpoint at the LSN target
> xfsaild just idled at.

I'm just not seeing what the problem here is. The behaviour you are
describing has been around since day zero and doesn't require the
addition of an ail push from iclog completion to trigger.  Prior to
this series, it would be:

process 1	reservation	log completion	xfsaild
<completes metadata IO>
  xfs_ail_delete()
    mlip_changed
    xlog_assign_tail_lsn_locked()
      ail empty, sets l_last_sync = 0x1000032e2
    xfs_log_space_wake()
				xlog_state_do_callback
				  sets CALLBACK
				  sets last_sync_lsn to iclog head
				    -> 0x1000032e4
				  <drops icloglock, gets preempted>
		<wakes>
		xlog_grant_head_wait
		  free_bytes < need_bytes
		    xlog_grant_push_ail()
		      xlog_push_ail()
		        ->ail_target 0x1000032e4
		<sleeps>
						<wakes>
						sets prev target to 0x1000032e4
						sees empty AIL
						<sleeps>
				    <runs again>
				    runs callbacks
				      xfs_ail_insert(lsn = 0x1000032e4)

and now we have the AIL push thread asleep with items in it at the
push threshold.  IOWs, what you describe has always been possible,
and before the CIL was introduced this sort of thing happened quite
a bit because iclog completions freed up much less space in the log
than a CIL commit completion.

It's not a problem, however, because if we are out of transaction
reservation space we must have transactions in progress, and as long
as they make progress then the commit of each transaction will end
up calling xlog_ungrant_log_space() to return the unused portion of
the transaction reservation. That calls xfs_log_space_wake() to
allow reservation waiters to try to make progress.

If there's still not enough space reservation after the transaction
in progress has released it's reservation, then it goes back to
sleep. As long as we have active transactions in progress while
there are transaction reservations waiting on reservation space,
there will be a wakeup vector for the reservation independent of
the CIL, iclogs and AIL behaviour.

[ Yes, there was a bug here, in the case xfs_log_space_wake() did
not issue a wakeup because of not enough space being availble and
the push target was limited by the old log head location. i.e.
nothing ever updated the push target to reflect the new log head and
so the tail might never get moved now. That particular bug was fixed
by a an earlier patch in the series, so we can ignore it here. ]

IOWs, if the AIL is empty, the CIL cannot consume more than 25% of
the log space, and we have transactions waiting on log reservation
space, then we must have enough transactions in progress to cover at
least 75% of the log space. Completion of those transactions will
wake waiters and, if necessary, push the AIL again to keep the log
tail moving appropriately. This handles the AIL empty and "insert
before target" situations you are concerned about just fine, as long
as we have a guarantee of forwards progress. Bounding the CIL size
provides that forwards progress guarantee for the CIL...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
