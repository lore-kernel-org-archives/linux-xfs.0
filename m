Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CCCC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 00:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD586206BB
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 00:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389073AbfIFAF6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 20:05:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37846 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731943AbfIFAF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 20:05:57 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E1DF343CB25
        for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2019 10:05:55 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i61lD-0003ZP-Fe
        for linux-xfs@vger.kernel.org; Fri, 06 Sep 2019 10:05:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i61lD-0001mU-DY
        for linux-xfs@vger.kernel.org; Fri, 06 Sep 2019 10:05:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: fix missed wakeup on l_flush_wait
Date:   Fri,  6 Sep 2019 10:05:47 +1000
Message-Id: <20190906000553.6740-3-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190906000553.6740-1-david@fromorbit.com>
References: <20190906000553.6740-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=J70Eh1EUuV4A:10 a=fwyzoN0nAAAA:8
        a=FOH2dFAWAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=TIbIJjZQYPkjqnKAcywA:9
        a=Sc3RvPAMVtkGz6dGeUiH:22 a=i3VuKzQdj-NEYjvDI-p3:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

The code in xlog_wait uses the spinlock to make adding the task to
the wait queue, and setting the task state to UNINTERRUPTIBLE atomic
with respect to the waker.

Doing the wakeup after releasing the spinlock opens up the following
race condition:

Task 1					task 2
add task to wait queue
					wake up task
set task state to UNINTERRUPTIBLE

This issue was found through code inspection as a result of kworkers
being observed stuck in UNINTERRUPTIBLE state with an empty
wait queue. It is rare and largely unreproducable.

Simply moving the spin_unlock to after the wake_up_all results
in the waker not being able to see a task on the waitqueue before
it has set its state to UNINTERRUPTIBLE.

This bug dates back to the conversion of this code to generic
waitqueue infrastructure from a counting semaphore back in 2008
which didn't place the wakeups consistently w.r.t. to the relevant
spin locks.

[dchinner: Also fix a similar issue in the shutdown path on
xc_commit_wait. Update commit log with more details of the issue.]

Fixes: d748c62367eb ("[XFS] Convert l_flushsema to a sv_t")
Reported-by: Chris Mason <clm@fb.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c2862b1a2780..4027158d1b2a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2650,7 +2650,6 @@ xlog_state_do_callback(
 	int		   funcdidcallbacks; /* flag: function did callbacks */
 	int		   repeats;	/* for issuing console warnings if
 					 * looping too many times */
-	int		   wake = 0;
 
 	spin_lock(&log->l_icloglock);
 	first_iclog = iclog = log->l_iclog;
@@ -2846,11 +2845,9 @@ xlog_state_do_callback(
 #endif
 
 	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR))
-		wake = 1;
-	spin_unlock(&log->l_icloglock);
-
-	if (wake)
 		wake_up_all(&log->l_flush_wait);
+
+	spin_unlock(&log->l_icloglock);
 }
 
 
@@ -3950,7 +3947,9 @@ xfs_log_force_umount(
 	 * item committed callback functions will do this again under lock to
 	 * avoid races.
 	 */
+	spin_lock(&log->l_cilp->xc_push_lock);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
+	spin_unlock(&log->l_cilp->xc_push_lock);
 	xlog_state_do_callback(log, true, NULL);
 
 #ifdef XFSERRORDEBUG
-- 
2.23.0.rc1

