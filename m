Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC31C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 23:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiC1XPB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 19:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiC1XPB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 19:15:01 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4808D1D323
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 16:13:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A04AF534020;
        Tue, 29 Mar 2022 10:13:17 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nYyY0-00B4tk-0C; Tue, 29 Mar 2022 10:13:16 +1100
Date:   Tue, 29 Mar 2022 10:13:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: run callbacks before waking waiters in
 xlog_state_shutdown_callbacks
Message-ID: <20220328231315.GW1544202@dread.disaster.area>
References: <20220324002103.710477-1-david@fromorbit.com>
 <20220324002103.710477-4-david@fromorbit.com>
 <20220328230531.GB27713@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328230531.GB27713@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6242410d
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=lDF8XiAqVpDjYKSEIroA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 28, 2022 at 04:05:31PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 24, 2022 at 11:21:00AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Brian reported a null pointer dereference failure during unmount in
> > xfs/006. He tracked the problem down to the AIL being torn down
> > before a log shutdown had completed and removed all the items from
> > the AIL. The failure occurred in this path while unmount was
> > proceeding in another task:
> > 
> >  xfs_trans_ail_delete+0x102/0x130 [xfs]
> >  xfs_buf_item_done+0x22/0x30 [xfs]
> >  xfs_buf_ioend+0x73/0x4d0 [xfs]
> >  xfs_trans_committed_bulk+0x17e/0x2f0 [xfs]
> >  xlog_cil_committed+0x2a9/0x300 [xfs]
> >  xlog_cil_process_committed+0x69/0x80 [xfs]
> >  xlog_state_shutdown_callbacks+0xce/0xf0 [xfs]
> >  xlog_force_shutdown+0xdf/0x150 [xfs]
> >  xfs_do_force_shutdown+0x5f/0x150 [xfs]
> >  xlog_ioend_work+0x71/0x80 [xfs]
> >  process_one_work+0x1c5/0x390
> >  worker_thread+0x30/0x350
> >  kthread+0xd7/0x100
> >  ret_from_fork+0x1f/0x30
> > 
> > This is processing an EIO error to a log write, and it's
> > triggering a force shutdown. This causes the log to be shut down,
> > and then it is running attached iclog callbacks from the shutdown
> > context. That means the fs and log has already been marked as
> > xfs_is_shutdown/xlog_is_shutdown and so high level code will abort
> > (e.g. xfs_trans_commit(), xfs_log_force(), etc) with an error
> > because of shutdown.
> > 
> > The umount would have been blocked waiting for a log force
> > completion inside xfs_log_cover() -> xfs_sync_sb(). The first thing
> > for this situation to occur is for xfs_sync_sb() to exit without
> > waiting for the iclog buffer to be comitted to disk. The
> > above trace is the completion routine for the iclog buffer, and
> > it is shutting down the filesystem.
> > 
> > xlog_state_shutdown_callbacks() does this:
> > 
> > {
> >         struct xlog_in_core     *iclog;
> >         LIST_HEAD(cb_list);
> > 
> >         spin_lock(&log->l_icloglock);
> >         iclog = log->l_iclog;
> >         do {
> >                 if (atomic_read(&iclog->ic_refcnt)) {
> >                         /* Reference holder will re-run iclog callbacks. */
> >                         continue;
> >                 }
> >                 list_splice_init(&iclog->ic_callbacks, &cb_list);
> > >>>>>>           wake_up_all(&iclog->ic_write_wait);
> > >>>>>>           wake_up_all(&iclog->ic_force_wait);
> >         } while ((iclog = iclog->ic_next) != log->l_iclog);
> > 
> >         wake_up_all(&log->l_flush_wait);
> >         spin_unlock(&log->l_icloglock);
> > 
> > >>>>>>  xlog_cil_process_committed(&cb_list);
> > }
> > 
> > It wakes forces waiters before shutdown processes all the pending
> > callbacks.
> 
> I'm not sure what this means.

"It wakes force waiters" i.e. any process in xfs_log_force() waiting
on iclog->ic_force_wait...

> Are you saying that log shutdown wakes up iclog waiters before it
> processes pending callbacks?  And then anyone who waits on an iclog (log
> forces, I guess?) will wake up and race with the callbacks?

Yes, exactly that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
