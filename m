Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1CFC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 21:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiCOVtB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 17:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352018AbiCOVtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 17:49:00 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DCC8DE9
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 14:47:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6561B5333E9;
        Wed, 16 Mar 2022 08:47:46 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUF17-005uB9-8I; Wed, 16 Mar 2022 08:47:45 +1100
Date:   Wed, 16 Mar 2022 08:47:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: async CIL flushes need pending pushes to be
 made stable
Message-ID: <20220315214745.GM3927073@dread.disaster.area>
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-5-david@fromorbit.com>
 <20220315193624.GH8241@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315193624.GH8241@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62310982
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=1_oCeihGZhIlbO3SolkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 12:36:24PM -0700, Darrick J. Wong wrote:
> On Tue, Mar 15, 2022 at 05:42:38PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When the AIL tries to flush the CIL, it relies on the CIL push
> > ending up on stable storage without having to wait for and
> > manipulate iclog state directly. However, if there is already a
> > pending CIL push when the AIL tries to flush the CIL, it won't set
> > the cil->xc_push_commit_stable flag and so the CIL push will not
> > actively flush the commit record iclog.
> > 
> > generic/530 when run on a single CPU test VM can trigger this fairly
> > reliably. This test exercises unlinked inode recovery, and can
> > result in inodes being pinned in memory by ongoing modifications to
> > the inode cluster buffer to record unlinked list modifications. As a
> > result, the first inode unlinked in a buffer can pin the tail of the
> > log whilst the inode cluster buffer is pinned by the current
> > checkpoint that has been pushed but isn't on stable storage because
> > because the cil->xc_push_commit_stable was not set. This results in
> > the log/AIL effectively deadlocking until something triggers the
> > commit record iclog to be pushed to stable storage (i.e. the
> > periodic log worker calling xfs_log_force()).
> > 
> > The fix is two-fold - first we should always set the
> > cil->xc_push_commit_stable when xlog_cil_flush() is called,
> > regardless of whether there is already a pending push or not.
> > 
> > Second, if the CIL is empty, we should trigger an iclog flush to
> > ensure that the iclogs of the last checkpoint have actually been
> > submitted to disk as that checkpoint may not have been run under
> > stable completion constraints.
> 
> Can it ever be the case that the CIL is not empty but the last
> checkpoint wasn't committed to disk?

Yes. But xlog_cil_push_now() will capture that, queue it and mark
it as xc_push_commit_stable. 

Remember that the push_now() code updates the push seq/stable
state under down_read(ctx lock) + spin_lock(push lock) context. The
push seq/stable state is cleared by the push worker under
down_write(ctx lock) + spin_lock(push lock) conditions when it
atomically swaps in the new empty CIL context. Hence the push worker
will always see the stable flag if it has been set for that push
sequence.

> Let's say someone else
> commits a transaction after the worker samples xc_push_commit_stable?

If we race with commits between the xlog_cil_push_now(log, seq,
true) and the CIL list_empty check in xlog_cil_flush(), there are
two posibilities:

1. the CIL push worker hasn't run and atomically switched in a new
CIL context.
2. the CIL push worker has run and switched contexts

In the first case, the commit will end up in the same context that
xlog_cil_flush() pushed, and it will be stable. That will result in
an empty CIL after the CIL push worker runs, but the racing commit
will be stable as per the xc_push_commit_stable flag. This can also
lead to the CIL being empty by the time the list_empty check is done
(because pre-empt), in which case the log force will be a no-op
because none of the iclogs need flushing.

> IOWs, why does a not-empty CIL mean that the last checkpoint is on disk?

In the second case, the CIL push triggered by xlog_cil_push_now()
will be stable because xc_push_commit_stable says it must be, and
the racing commit will end up in the new CIL context and the CIL
won't be empty. We don't need a log force in this case because the
previous sequence that was flushed with stable semantics as required.

In the case of AIL pushing, we don't actually care about racing CIL
commits because we are trying to get pinned AIL items unpinned so we
can move the tail of the log forwards. If those pinned items are
relogged by racing transactions, then the next call to
xlog_cil_flush() from the AIL will get them unpinned and that will
move them forward in the log, anyway.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
