Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA2FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 23:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbiEXXRR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 19:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237123AbiEXXRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 19:17:17 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E7103ED04
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 16:17:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9BA735347B5;
        Wed, 25 May 2022 09:17:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntdm5-00G0bF-Hr; Wed, 25 May 2022 09:17:13 +1000
Date:   Wed, 25 May 2022 09:17:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Chris Dunlop <chris@onthe.net.au>
Subject: Re: [PATCH 2/2] xfs: introduce xfs_inodegc_push()
Message-ID: <20220524231713.GD1098723@dread.disaster.area>
References: <20220524063802.1938505-1-david@fromorbit.com>
 <20220524063802.1938505-3-david@fromorbit.com>
 <CAOQ4uxj7q=XpAzPjcC46AUD3cmDzFwKaYsxmQSm=1pzCQrw+wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj7q=XpAzPjcC46AUD3cmDzFwKaYsxmQSm=1pzCQrw+wQ@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=628d677a
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8
        a=N8xf_ed3AAAA:8 a=93vLQDYR59KmNjmNFe0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22 a=sE4t997d3Q9FUvws1cBB:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 01:47:36PM +0300, Amir Goldstein wrote:
> On Tue, May 24, 2022 at 1:37 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > The current blocking mechanism for pushing the inodegc queue out to
> > disk can result in systems becoming unusable when there is a long
> > running inodegc operation. This is because the statfs()
> > implementation currently issues a blocking flush of the inodegc
> > queue and a significant number of common system utilities will call
> > statfs() to discover something about the underlying filesystem.
> >
> > This can result in userspace operations getting stuck on inodegc
> > progress, and when trying to remove a heavily reflinked file on slow
> > storage with a full journal, this can result in delays measuring in
> > hours.
> >
> > Avoid this problem by adding "push" function that expedites the
> > flushing of the inodegc queue, but doesn't wait for it to complete.
> >
> > Convert xfs_fs_statfs() to use this mechanism so it doesn't block
> > but it does ensure that queued operations are expedited.
> >
> > Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
> > Reported-by: Chris Dunlop <chris@onthe.net.au>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_icache.c | 20 +++++++++++++++-----
> >  fs/xfs/xfs_icache.h |  1 +
> >  fs/xfs/xfs_super.c  |  7 +++++--
> >  fs/xfs/xfs_trace.h  |  1 +
> >  4 files changed, 22 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 786702273621..2609825d53ee 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1862,19 +1862,29 @@ xfs_inodegc_worker(
> >  }
> >
> >  /*
> > - * Force all currently queued inode inactivation work to run immediately and
> > - * wait for the work to finish.
> > + * Expedite all pending inodegc work to run immediately. This does not wait for
> > + * completion of the work.
> >   */
> >  void
> > -xfs_inodegc_flush(
> > +xfs_inodegc_push(
> >         struct xfs_mount        *mp)
> >  {
> >         if (!xfs_is_inodegc_enabled(mp))
> >                 return;
> > +       trace_xfs_inodegc_push(mp, __return_address);
> > +       xfs_inodegc_queue_all(mp);
> > +}
> >
> > +/*
> > + * Force all currently queued inode inactivation work to run immediately and
> > + * wait for the work to finish.
> > + */
> > +void
> > +xfs_inodegc_flush(
> > +       struct xfs_mount        *mp)
> > +{
> > +       xfs_inodegc_push(mp);
> >         trace_xfs_inodegc_flush(mp, __return_address);
> 
> Unintentional(?) change of behavior:
> trace_xfs_inodegc_flush() will be called in
> (!xfs_is_inodegc_enabled(mp)) case.

Intentional. inodegc can be disabled/enabled at runtime (e.g.
freeze). This behaviour is to allow asynchronous push to minimise
wait time when needing to expedite inodegc and wait for it to
complete.

P1					P2
----					-----
xfs_inodegc_push()
<do stuff>				xfs_inodegc_stop()
.....					  inodegc disabled
					  xfs_inodegc_queue_all()
					  flush_workqueue()
					<block waiting for stuff push queued>
.....					.....
xfs_inodegc_flush()
  xfs_inodegc_push() (does nothing)
  flush_workqueue()
<block waiting for queued stuff>
.....					.....
					<inodegc completes>
<unblocks>				<unblocks>

> I also wonder if trace_xfs_inodegc_flush()
> should not be before trace_xfs_inodegc_push() in this flow,
> but this is just a matter of tracing conventions and you should
> know best how it will be convenient for xfs developers to be
> reading the trace events stream.

push and flush have their own tracepoints and so we can easily see
how flush has interacted with enable/disable - push+flush =
xfs_inodegc_flush when enabled, flush = xfs_inodegc_flush when
disabled, push = xfs_inodegc_push.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
