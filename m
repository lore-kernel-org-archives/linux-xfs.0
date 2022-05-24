Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FA7C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 18:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiEXSFt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 14:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240131AbiEXSFs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 14:05:48 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005F6140A8
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 11:05:47 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id g3so15308000qtb.7
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 11:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aZVbzC642qe2ohG7B3qHw3f/cYnmNDi7odCxBqYhovU=;
        b=Zu9wTPhxwgeKrV2eDwHlBNxMzx281OFjPguR7vsqfIY7cTdId24p6wN0IU2ykuXTYp
         hQk2etrfu7tzuRBAJ6Ywgxqvr3lgPIh8eLn+dKytPIAYeFTHEtTBw1Ds86cqoLAD4n7w
         T2WjR9ae+8XnQMLDHOLRPhsEf9t23HiQeMc9YcBdLTxBZQ6fiqhRooD50ya3j7nSRFzN
         15WkETsUQuGu/Y9nJ8eKQ2ZwZ/w8zQsuGWTbOgwOc6yY0Wn84jweq98yhjURlUrg50dy
         qz0ksZSloB/kwYvJJcXEW/XMvwuBBxIPUdFbdRXntyOiPxKhoV8yywcBTHDO08W98qVo
         cLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aZVbzC642qe2ohG7B3qHw3f/cYnmNDi7odCxBqYhovU=;
        b=4iijK2hmHZ+mjWiLapBtZ2cE+/6WAA7G99c+UN8xCpSytwfITHbe67rARRVcJuUpOn
         WfzkV0ARbw5Sp6pjkbgr2WdpQJvTnJ1sVYm0sQGNV9zRYhUPqF4576XcQZb+tCqB61t/
         ZV+Nvl90KRANOmS+qY2EGkcGufquC7RJNqFyb9418pAfezCrJICUEWjzGSD4afT0+Fzf
         Iw4LOkkg/N0VfIuv3Rjkb5PVEDGrWS/HwHVMBRidKaRt760TiULj2Z3ISn6MpItABtxJ
         QJ2o6V9f48dPGDzgPi2c7pHwSxk4e7CJhHu1tQmx9yWoDj64iNF1IlX8g3YRWYjl8el6
         Mmig==
X-Gm-Message-State: AOAM533Wo8pw/t3hvnxUVi+2Hw/PHdAAS+7hfWlPbJFKwQFKW+CYAL23
        eg1Oy9Aut7UPgGU5QGtw0nVLatj0zVjwpHZ8rmVB7yjo+3q0PA==
X-Google-Smtp-Source: ABdhPJwWP1PlX6kzJLu97H/0XQ4KlGORzE6hvLM7myV8wlSn3LKjDCT0AZSNo/GvVbXrVu9af10S1tjvgRKQ5a9/xkc=
X-Received: by 2002:a05:622a:1a9c:b0:2f3:d873:4acc with SMTP id
 s28-20020a05622a1a9c00b002f3d8734accmr21487181qtc.424.1653415547057; Tue, 24
 May 2022 11:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220524063802.1938505-1-david@fromorbit.com> <20220524063802.1938505-3-david@fromorbit.com>
 <CAOQ4uxj7q=XpAzPjcC46AUD3cmDzFwKaYsxmQSm=1pzCQrw+wQ@mail.gmail.com> <Yo0EWSKaNsQB/ZF7@magnolia>
In-Reply-To: <Yo0EWSKaNsQB/ZF7@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 24 May 2022 21:05:35 +0300
Message-ID: <CAOQ4uxjpYv55CjcM3Gg-310cWKOxAKEOHfG7v+XE28ufgskmXw@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: introduce xfs_inodegc_push()
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Chris Dunlop <chris@onthe.net.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 7:14 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Tue, May 24, 2022 at 01:47:36PM +0300, Amir Goldstein wrote:
> > On Tue, May 24, 2022 at 1:37 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > The current blocking mechanism for pushing the inodegc queue out to
> > > disk can result in systems becoming unusable when there is a long
> > > running inodegc operation. This is because the statfs()
> > > implementation currently issues a blocking flush of the inodegc
> > > queue and a significant number of common system utilities will call
> > > statfs() to discover something about the underlying filesystem.
> > >
> > > This can result in userspace operations getting stuck on inodegc
> > > progress, and when trying to remove a heavily reflinked file on slow
> > > storage with a full journal, this can result in delays measuring in
> > > hours.
> > >
> > > Avoid this problem by adding "push" function that expedites the
> > > flushing of the inodegc queue, but doesn't wait for it to complete.
> > >
> > > Convert xfs_fs_statfs() to use this mechanism so it doesn't block
> > > but it does ensure that queued operations are expedited.
> > >
> > > Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
> > > Reported-by: Chris Dunlop <chris@onthe.net.au>
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_icache.c | 20 +++++++++++++++-----
> > >  fs/xfs/xfs_icache.h |  1 +
> > >  fs/xfs/xfs_super.c  |  7 +++++--
> > >  fs/xfs/xfs_trace.h  |  1 +
> > >  4 files changed, 22 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index 786702273621..2609825d53ee 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -1862,19 +1862,29 @@ xfs_inodegc_worker(
> > >  }
> > >
> > >  /*
> > > - * Force all currently queued inode inactivation work to run immediately and
> > > - * wait for the work to finish.
> > > + * Expedite all pending inodegc work to run immediately. This does not wait for
> > > + * completion of the work.
> > >   */
> > >  void
> > > -xfs_inodegc_flush(
> > > +xfs_inodegc_push(
> > >         struct xfs_mount        *mp)
> > >  {
> > >         if (!xfs_is_inodegc_enabled(mp))
> > >                 return;
> > > +       trace_xfs_inodegc_push(mp, __return_address);
> > > +       xfs_inodegc_queue_all(mp);
> > > +}
> > >
> > > +/*
> > > + * Force all currently queued inode inactivation work to run immediately and
> > > + * wait for the work to finish.
> > > + */
> > > +void
> > > +xfs_inodegc_flush(
> > > +       struct xfs_mount        *mp)
> > > +{
> > > +       xfs_inodegc_push(mp);
> > >         trace_xfs_inodegc_flush(mp, __return_address);
> >
> > Unintentional(?) change of behavior:
> > trace_xfs_inodegc_flush() will be called in
> > (!xfs_is_inodegc_enabled(mp)) case.
>
> At worst we end up waiting for any inodegc workers that are sti
> running, right?  I think that's reasonable behavior for a flush
> function, and shouldn't cause any weird interactions.
>

Ah, can xfs_is_inodegc_enabled() be changed in runtime?
Sorry for being thick.
I did not understand why flush should be done in this case and
push should not, but if you say its ok I'll take your word for it.

Thanks,
Amir.
