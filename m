Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2AFC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 16:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiEXQOY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 12:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbiEXQOW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 12:14:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2167E1FC
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 09:14:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01659CE1C0F
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 16:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC98C34113;
        Tue, 24 May 2022 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408858;
        bh=GFMTED3XoM8zgi0SIO51YpM+OPOfoKHjVSlilv5Js54=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d059CysBGi/N3UGB+rHP23ZLdpnOjx7uCwOH4GXZRT1Pgg0Hql9FAhpWMB8anCN0y
         /5nmXgxD/c9enGOWCZqnt2kd8O5s+pEbUJtPXwwZB67VKyitOk3hJyJiHti824uMDM
         66ee3bLNO6LvGrxs+vpyu6LS3Vp6GQpiz3/K7zrDJ7e6WTNB89APCbSAF2831EIJM/
         oVFk4Q3Mg89Xo2YOcxn2o2hnBYI+/9o0OTCYHjBHZQUSYVika/ETTiz6X5SFpf5eJF
         RImD+0ob1cciKKlaz1nHLdGCzyj8Gaeoww6umwy7is6L7qYH58xcYOLWVSlfgcciD5
         tMMjbU27FF+YQ==
Date:   Tue, 24 May 2022 09:14:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Chris Dunlop <chris@onthe.net.au>
Subject: Re: [PATCH 2/2] xfs: introduce xfs_inodegc_push()
Message-ID: <Yo0EWSKaNsQB/ZF7@magnolia>
References: <20220524063802.1938505-1-david@fromorbit.com>
 <20220524063802.1938505-3-david@fromorbit.com>
 <CAOQ4uxj7q=XpAzPjcC46AUD3cmDzFwKaYsxmQSm=1pzCQrw+wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj7q=XpAzPjcC46AUD3cmDzFwKaYsxmQSm=1pzCQrw+wQ@mail.gmail.com>
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

At worst we end up waiting for any inodegc workers that are still
running, right?  I think that's reasonable behavior for a flush
function, and shouldn't cause any weird interactions.

> I also wonder if trace_xfs_inodegc_flush()
> should not be before trace_xfs_inodegc_push() in this flow,
> but this is just a matter of tracing conventions and you should
> know best how it will be convenient for xfs developers to be
> reading the trace events stream.

Why?  _push has its own tracepoint which we can use to tell if inodegc
was enabled at _flush time.

--D

> Thanks,
> Amir.
