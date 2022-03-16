Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5EB5C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 23:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239181AbiCPXZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 19:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245358AbiCPXZy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 19:25:54 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A017BBC1A
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 16:24:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E199D10E4690;
        Thu, 17 Mar 2022 10:24:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUd0Q-006KL8-CS; Thu, 17 Mar 2022 10:24:38 +1100
Date:   Thu, 17 Mar 2022 10:24:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: async CIL flushes need pending pushes to be
 made stable
Message-ID: <20220316232438.GS3927073@dread.disaster.area>
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-5-david@fromorbit.com>
 <871qz2dw34.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qz2dw34.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623271b7
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=miITSsmNRBKvk4OpMLUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 04:04:55PM +0530, Chandan Babu R wrote:
> On 15 Mar 2022 at 12:12, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > When the AIL tries to flush the CIL, it relies on the CIL push
> > ending up on stable storage without having to wait for and
> > manipulate iclog state directly. However, if there is already a
> > pending CIL push when the AIL tries to flush the CIL, it won't set
> > the cil->xc_push_commit_stable flag and so the CIL push will not
> > actively flush the commit record iclog.
> 
> I think the above sentence maps to the following snippet from
> xlog_cil_push_now(),
> 
> 	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
> 		spin_unlock(&cil->xc_push_lock);
> 		return;
> 	}
> 
> i.e. if the CIL sequence that we are trying to push is already being pushed
> then xlog_cil_push_now() returns without queuing work on cil->xc_push_wq.
> 
> However, the push_seq could have been previously pushed by,
> 1. xfsaild_push()
>    In this case, cil->xc_push_commit_stable is set to true. Hence,
>    xlog_cil_push_work() will definitely make sure to submit the commit record
>    iclog for write I/O.
> 2. xfs_log_force_seq() => xlog_cil_force_seq()
>    xfs_log_force_seq() invokes xlog_force_lsn() after executing
>    xlog_cil_force_seq(). Here, A partially filled iclog will be in
>    XLOG_STATE_ACTIVE state. This will cause xlog_force_and_check_iclog() to be
>    invoked and hence the iclog is submitted for write I/O.
> 
> In both the cases listed above, iclog is guaranteed to be submitted for I/O
> without any help from the log worker task.
> 
> Looks like I am missing something obvious here.

Pushes triggered by xlog_cil_push_background() can complete leaving
the partially filled iclog in ACTIVE state. Then xlog_cil_push_now()
does nothing because it doesn't trigger a new CIL push and so
setting the cil->xc_push_commit_stable flag doesn't trigger a flush
of the ACTIVE iclog.

The AIL flush does not use xfs_log_force_seq() because that blocks
waiting for the entire CIL to hit the disk before it can force the
last iclog to disk. Hence the second piece of this patch is
necessary, and that is to call xfs_log_force() if the CIL is empty
(i.e. the case where xlog_cil_push_now() is a no-op because the
CIL is empty due to background pushes).


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
