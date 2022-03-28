Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188DFC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 23:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiC1Xi0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 19:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiC1XiH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 19:38:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCBCD7613
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 16:36:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76AE1B8115C
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 23:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A532C340ED;
        Mon, 28 Mar 2022 23:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648510583;
        bh=8RC5cdkMmeabO7xD7QJ5XmP1A+VBdtYk+nTvXXXcCgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PKK1M/e36ZZ8h2X7Xzpi57mGIQxGMfB1jDTXrRt2Ka3QsR3VJHBVLbSmx1YFoV68e
         U46GVBItiobyvaCxYoPBcGUmzdu1aZQsOkw4kegkenWDuffgHln+VEh1z2Jda+DuPx
         CwSGoDgDnJFmz4cF9WfeQxCZ459N4NuIbBGkCl8+LbdvSSdTFA+/0mbpseFl0bB68m
         NSFFKyyjlCTYA/cnsAs7ImRObvbnbqUESYHwKQfT4HiWlB2i4zGgMln/d2Vwu9yy0J
         O2RDHKp94TpCGneP13kzIksrArFLJ+B88v2NS/7COO0Yvl5FbtP9KaKBSigbPiTZuf
         nrzBMkCOKCrUg==
Date:   Mon, 28 Mar 2022 16:36:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: run callbacks before waking waiters in
 xlog_state_shutdown_callbacks
Message-ID: <20220328233622.GB27690@magnolia>
References: <20220324002103.710477-1-david@fromorbit.com>
 <20220324002103.710477-4-david@fromorbit.com>
 <20220328230531.GB27713@magnolia>
 <20220328231315.GW1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328231315.GW1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 29, 2022 at 10:13:15AM +1100, Dave Chinner wrote:
> On Mon, Mar 28, 2022 at 04:05:31PM -0700, Darrick J. Wong wrote:
> > On Thu, Mar 24, 2022 at 11:21:00AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Brian reported a null pointer dereference failure during unmount in
> > > xfs/006. He tracked the problem down to the AIL being torn down
> > > before a log shutdown had completed and removed all the items from
> > > the AIL. The failure occurred in this path while unmount was
> > > proceeding in another task:
> > > 
> > >  xfs_trans_ail_delete+0x102/0x130 [xfs]
> > >  xfs_buf_item_done+0x22/0x30 [xfs]
> > >  xfs_buf_ioend+0x73/0x4d0 [xfs]
> > >  xfs_trans_committed_bulk+0x17e/0x2f0 [xfs]
> > >  xlog_cil_committed+0x2a9/0x300 [xfs]
> > >  xlog_cil_process_committed+0x69/0x80 [xfs]
> > >  xlog_state_shutdown_callbacks+0xce/0xf0 [xfs]
> > >  xlog_force_shutdown+0xdf/0x150 [xfs]
> > >  xfs_do_force_shutdown+0x5f/0x150 [xfs]
> > >  xlog_ioend_work+0x71/0x80 [xfs]
> > >  process_one_work+0x1c5/0x390
> > >  worker_thread+0x30/0x350
> > >  kthread+0xd7/0x100
> > >  ret_from_fork+0x1f/0x30
> > > 
> > > This is processing an EIO error to a log write, and it's
> > > triggering a force shutdown. This causes the log to be shut down,
> > > and then it is running attached iclog callbacks from the shutdown
> > > context. That means the fs and log has already been marked as
> > > xfs_is_shutdown/xlog_is_shutdown and so high level code will abort
> > > (e.g. xfs_trans_commit(), xfs_log_force(), etc) with an error
> > > because of shutdown.
> > > 
> > > The umount would have been blocked waiting for a log force
> > > completion inside xfs_log_cover() -> xfs_sync_sb(). The first thing
> > > for this situation to occur is for xfs_sync_sb() to exit without
> > > waiting for the iclog buffer to be comitted to disk. The
> > > above trace is the completion routine for the iclog buffer, and
> > > it is shutting down the filesystem.
> > > 
> > > xlog_state_shutdown_callbacks() does this:
> > > 
> > > {
> > >         struct xlog_in_core     *iclog;
> > >         LIST_HEAD(cb_list);
> > > 
> > >         spin_lock(&log->l_icloglock);
> > >         iclog = log->l_iclog;
> > >         do {
> > >                 if (atomic_read(&iclog->ic_refcnt)) {
> > >                         /* Reference holder will re-run iclog callbacks. */
> > >                         continue;
> > >                 }
> > >                 list_splice_init(&iclog->ic_callbacks, &cb_list);
> > > >>>>>>           wake_up_all(&iclog->ic_write_wait);
> > > >>>>>>           wake_up_all(&iclog->ic_force_wait);
> > >         } while ((iclog = iclog->ic_next) != log->l_iclog);
> > > 
> > >         wake_up_all(&log->l_flush_wait);
> > >         spin_unlock(&log->l_icloglock);
> > > 
> > > >>>>>>  xlog_cil_process_committed(&cb_list);
> > > }
> > > 
> > > It wakes forces waiters before shutdown processes all the pending
> > > callbacks.
> > 
> > I'm not sure what this means.
> 
> "It wakes force waiters" i.e. any process in xfs_log_force() waiting
> on iclog->ic_force_wait...

Ahh, 'forces' is not part of the verb in that sentence.

Would you mind rewording that sentence to:

"It wakes any thread waiting on IO completion of the iclog (in this case
the umount log force) before shutdown processes all the pending
callbacks."

With that change, I think I understand this now.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> > Are you saying that log shutdown wakes up iclog waiters before it
> > processes pending callbacks?  And then anyone who waits on an iclog (log
> > forces, I guess?) will wake up and race with the callbacks?
> 
> Yes, exactly that.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
