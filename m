Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FD8C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC8572086A
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BfL6qEQz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgFBEEh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBEEh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:04:37 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C5FC061A0E
        for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2020 21:04:37 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id p5so10504133ile.6
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jun 2020 21:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fifCfaZW/GsCIL1D5aAtR9JeZYH5AKHn1Hsk1/Pt9V8=;
        b=BfL6qEQzJeOCb4/NYcEZIVJrvIAQg51ML1X+3R1k1mplHBO5PO7G4+GYnWjgmxgmyA
         HuJlcI6W6a6m4YPpGtbcjfCffutzdZq1PjCyjd9xpe1livJkZBtSMeRIen2cdgIOdcON
         rA6liOx5wePllSg33hP8AdKExZLlgrSX+xqEnNxYIHfA7oQ8abJQdExrX57rosQ6bYx1
         FEyeWWjF9gmDVnRqCqJeNQGA5ongx6eESzR/ZtOV+SASA+zk8n/38xzwF7hCV1qyI79c
         jaYitL9ewMXAnd7Y5h9CX+z5vGhs5tYa0fA0ECDMkq5gP0CJMF1u+HqkIz/ytjzMd2PA
         kYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fifCfaZW/GsCIL1D5aAtR9JeZYH5AKHn1Hsk1/Pt9V8=;
        b=RbnKFP365L6NGCw/CDZBD2Qr1B19jAI/WNXy3OScO0klbEGW4ZuLi2lmkJh//q6COd
         ulgOnUSQdx1jxlM4A9rvXTcBLoF0xocQ9Z44S7Okdl3C1kgzjp3+rJfcc9VGBaXy5Yfj
         CcFC+R4sXGmajaIULt2DulZ1u+ZqpAMLzfIbyaxxIBDw1+kW5lqnidHfBFfMXLB/e/VH
         7YyKc3XoEV3vPLXeLdFzHZ9jDgW1QcuKfv5RoI/BdaF2KljtSg0+I7d2jdKah9IeiH8/
         /JWyOzmiOSDvAEKJe2RVdiE3AitM4k9jkzgIrhhjcHPJPtFUz/A0+5yj3FAVQCRR6Kh1
         jjGQ==
X-Gm-Message-State: AOAM530OhEeCZKbJPdBm+SbzYXyqWE7sWOj7tWMWPLRTgiuebilgkv47
        2f+P4LbxEwubEnNUzFYXeGYDJXYUSViTSN5Ev+8=
X-Google-Smtp-Source: ABdhPJzEDLfEHRo3zSUMoa+tjOOEtHyRyeU8dm5xoRO7A0wwfdhWrFj9VhlKDjQhQo/iUYRWmm31tVqvPsSICC3h/4I=
X-Received: by 2002:a92:1b86:: with SMTP id f6mr24951216ill.9.1591070676240;
 Mon, 01 Jun 2020 21:04:36 -0700 (PDT)
MIME-Version: 1.0
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784114490.1364230.7521571821422773694.stgit@magnolia> <CAOQ4uxgvnuVtfxz41W+FuTxy2GZ5QZwwUhacHgfMzJMKJ_db1g@mail.gmail.com>
 <20200602000917.GE2162697@magnolia>
In-Reply-To: <20200602000917.GE2162697@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 2 Jun 2020 07:04:24 +0300
Message-ID: <CAOQ4uxj9OEEo4SdPAnY231+t5v_niR8vQ3a1ZTZJ14oJtFJ1Sg@mail.gmail.com>
Subject: Re: [PATCH 13/14] xfs: enable bigtime for quota timers
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 2, 2020 at 3:09 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Sun, May 31, 2020 at 08:07:59PM +0300, Amir Goldstein wrote:
> > On Wed, Jan 1, 2020 at 3:12 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Enable the bigtime feature for quota timers.  We decrease the accuracy
> > > of the timers to ~4s in exchange for being able to set timers up to the
> > > bigtime maximum.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_dquot_buf.c  |   72 ++++++++++++++++++++++++++++++++++++++--
> > >  fs/xfs/libxfs/xfs_format.h     |   22 ++++++++++++
> > >  fs/xfs/libxfs/xfs_quota_defs.h |   11 ++++--
> > >  fs/xfs/scrub/quota.c           |    5 +++
> > >  fs/xfs/xfs_dquot.c             |   71 +++++++++++++++++++++++++++++++--------
> > >  fs/xfs/xfs_ondisk.h            |    6 +++
> > >  fs/xfs/xfs_qm.c                |   13 ++++---
> > >  fs/xfs/xfs_qm.h                |    8 ++--
> > >  fs/xfs/xfs_qm_syscalls.c       |   19 ++++++-----
> > >  9 files changed, 186 insertions(+), 41 deletions(-)
> > >
> > >
> > > diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> > > index 72e0fcfef580..2b5d51a6d64b 100644
> > > --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> > > +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> > > @@ -40,6 +40,8 @@ xfs_dquot_verify(
> > >         xfs_dqid_t              id,
> > >         uint                    type)   /* used only during quotacheck */
> > >  {
> > > +       uint8_t                 dtype;
> > > +
> > >         /*
> > >          * We can encounter an uninitialized dquot buffer for 2 reasons:
> > >          * 1. If we crash while deleting the quotainode(s), and those blks got
> > > @@ -60,11 +62,22 @@ xfs_dquot_verify(
> > >         if (ddq->d_version != XFS_DQUOT_VERSION)
> > >                 return __this_address;
> > >
> > > -       if (type && ddq->d_flags != type)
> > > +       dtype = ddq->d_flags & XFS_DQ_ALLTYPES;
> >
> > Suggest dtype = XFS_DQ_TYPE(ddq->d_flags);
> >
> > [...]
> >
> > > @@ -540,13 +551,28 @@ xfs_dquot_from_disk(
> > >         dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
> > >         dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
> > >
> > > -       xfs_dquot_from_disk_timestamp(&tv, ddqp->d_btimer);
> > > +       xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_btimer);
> > >         dqp->q_btimer = tv.tv_sec;
> > > -       xfs_dquot_from_disk_timestamp(&tv, ddqp->d_itimer);
> > > +       xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_itimer);
> > >         dqp->q_itimer = tv.tv_sec;
> > > -       xfs_dquot_from_disk_timestamp(&tv, ddqp->d_rtbtimer);
> > > +       xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_rtbtimer);
> > >         dqp->q_rtbtimer = tv.tv_sec;
> > >
> > > +       /* Upgrade to bigtime if possible. */
> > > +       if (xfs_dquot_add_bigtime(dqp->q_mount, iddq)) {
> > > +               tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_btimer);
> > > +               xfs_dquot_to_disk_timestamp(iddq, &iddq->d_btimer, &tv);
> > > +               dqp->q_btimer = tv.tv_sec;
> > > +
> > > +               tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_itimer);
> > > +               xfs_dquot_to_disk_timestamp(iddq, &iddq->d_itimer, &tv);
> > > +               dqp->q_itimer = tv.tv_sec;
> > > +
> > > +               tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_rtbtimer);
> > > +               xfs_dquot_to_disk_timestamp(iddq, &iddq->d_rtbtimer, &tv);
> > > +               dqp->q_rtbtimer = tv.tv_sec;
> > > +       }
> > > +
> >
> > This is better than the inode timestamp conversion because at
> > least the bigtime flag incore is always consistent with the incore values.
> > But I think it would be safer if the conversion happened inside the helper.
>
> This code, like the inode timestamp handling code, reads the ondisk
> timer value into the incore dquot, and sets the bigtime flag on the
> incore dquot.  We then wait until someone dirties the dquot to transform
> the ondisk dquot to be in bigtime format with the flag set.
>
> The dquot conversion is /much/ messier than the inode, because the dquot
> infrastructure maintains an incore copy of the ondisk dquot as well as
> an incore time64_t value, and we have to keep that whole mess
> consistent.
>

I see. That's what got me confused about how the inode timestamp incore
values are stored.

> TBH someone should probably go fix the incore dquots to have only the
> incore values (instead of the embedded xfs_disk_dquot) but I'd rather
> that go in as a cleanup after adding this series, because this series is
> already 13 patches, and if you combine cleaning up dquots with hch's
> incore inode removal now we have Yet Another Friggin 40-patch series.
>

Fare enough, but until someone does go and fix this code, my comment
still stands.

This patch calls xfs_dquot_add_bigtime() in three call sites.

Two of them are correct because the values of timers is 0.
The one above is correct because it shifts the embedded timer
values right after the call.

IMO it would be a better practice to keep this conversion
containers in a helper xfs_dquot_upgrade_bigtime() and
explicitly check for the 0 value case.

Thanks,
Amir.
