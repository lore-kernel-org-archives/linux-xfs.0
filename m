Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7673C3A59F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FFDC21874
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfH3Aer (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:34:47 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54883 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726983AbfH3Aer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 20:34:47 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 19FD343E7A2;
        Fri, 30 Aug 2019 10:34:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3UsD-00020V-9U; Fri, 30 Aug 2019 10:34:41 +1000
Date:   Fri, 30 Aug 2019 10:34:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        hch@infradead.org
Subject: Re: [RFC] xfs: Flush iclog containing XLOG_COMMIT_TRANS before
 waiting for log space
Message-ID: <20190830003441.GY1119@dread.disaster.area>
References: <20190821110448.30161-1-chandanrlinux@gmail.com>
 <3457989.EyS6152c1k@localhost.localdomain>
 <20190826003253.GK1119@dread.disaster.area>
 <783535067.D5oYYkGoWf@localhost.localdomain>
 <20190829230817.GW1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829230817.GW1119@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8 a=JZmxIDy6zt7q3VDMayUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 09:08:17AM +1000, Dave Chinner wrote:
> On Thu, Aug 29, 2019 at 10:51:59AM +0530, Chandan Rajendra wrote:
> > 	 786576: kworker/4:1H-kb  1825 [004]   217.041079:                       xfs:xfs_log_assign_tail_lsn: dev 7:1 new tail lsn 2/19333, old lsn 2/19330, last sync 3/18501
> 
> 200ms later the tail has moved, and last_sync_lsn is now 3/18501.
> i.e. the iclog writes have made it to disk, and the items have been
> moved into the AIL. I don't know where that came from, but I'm
> assuming it's an IO completion based on it being run from a
> kworker context that doesn't have an "xfs-" name prefix(*).
> 
> As the tail has moved, this should have woken the anything sleeping
> on the log tail in xlog_grant_head_wait() via a call to
> xfs_log_space_wake(). The first waiter should wake, see that there
> still isn't room in the log (only 3 sectors were freed in the log,
> we need at least 60). That woken process should then run
> xlog_grant_push_ail() again and go back to sleep.

Actually, it doesn't get woken because xlog_grant_head_wake() checks
how much space is available before waking waiters, and there clearly
isn't enough here. So that's one likely vector. Can you try this
patch?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: push the AIL in xlog_grant_head_wake

From: Dave Chinner <dchinner@redhat.com>

In the situation where the log is full and the CIL has not recently
flushed, the AIL push threshold is throttled back to the where the
last write of the head of the log was completed. This is stored in
log->l_last_sync_lsn. Hence if the CIL holds > 25% of the log space
pinned by flushes and/or aggregation in progress, we can get the
situation where the head of the log lags a long way behind the
reservation grant head.

When this happens, the AIL push target is trimmed back from where
the reservation grant head wants to push the log tail to, back to
where the head of the log currently is. This means the push target
doesn't reach far enough into the log to actually move the tail
before the transaction reservation goes to sleep.

When the CIL push completes, it moves the log head forward such that
the AIL push target can now be moved, but that has no mechanism for
puhsing the log tail. Further, if the next tail movement of the log
is not large enough wake the waiter (i.e. still not enough space for
it to have a reservation granted), we don't wake anything up, and
hence we do not update the AIL push target to take into account the
head of the log moving and allowing the push target to be moved
forwards.

To avoid this particular condition, if we fail to wake the first
waiter on the grant head because we don't have enough space,
push on the AIL again. This will pick up any movement of the log
head and allow the push target to move forward due to completion of
CIL pushing.

XXX: this does not address the situation where there are no tail
updates after the log head moves forward. There is currently no
infrastructure for a log head update to trigger an AIL tail push if
necessary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b159a9e9fef0..941f10ff99d9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -214,15 +214,20 @@ xlog_grant_head_wake(
 {
 	struct xlog_ticket	*tic;
 	int			need_bytes;
+	bool			woken_task = false;
 
 	list_for_each_entry(tic, &head->waiters, t_queue) {
 		need_bytes = xlog_ticket_reservation(log, head, tic);
-		if (*free_bytes < need_bytes)
+		if (*free_bytes < need_bytes) {
+			if (!woken_task)
+				xlog_grant_push_ail(log, need_bytes);
 			return false;
+		}
 
 		*free_bytes -= need_bytes;
 		trace_xfs_log_grant_wake_up(log, tic);
 		wake_up_process(tic->t_task);
+		woken_task = true;
 	}
 
 	return true;
