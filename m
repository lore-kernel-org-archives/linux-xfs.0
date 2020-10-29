Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B8DC55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 18:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24F8420838
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 18:56:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BBidAWnU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJ2S4k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 14:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJ2S4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 14:56:40 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA67C0613CF;
        Thu, 29 Oct 2020 11:56:39 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id v18so4143476ilg.1;
        Thu, 29 Oct 2020 11:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kI/Crql0FNrlDa/ubfAXL2ewr6hUN9HF7DMpMQOLpos=;
        b=BBidAWnUi5C23d9DhOWDOzNMcXAtx7SLfwBimeHZiJoMuNVJhvv0GBfEFcaAbJjNZ3
         MJimk6nSvGHwAJQkVX4zNRoq9I6xC77AmN9hgiUOCSmfGq1jTvNEdXXUbxxSKgakCZPW
         7uO4PoApZATR/Z3JXAHE4Q83+IMm7pKKASiVhQ2uFf+rPlPZPCouXfqerq/VXwZwTrUo
         6wqcd0+VgqY2rrcD3yqpzYFQk8h1Z/q161zvBRw1LuylVh0c/ygRIeKxGY81MKl//hkU
         I93ynQxKTOVIP5O9cqqDix+3caG/Yi26Y2W5B5432Qk9rTrSf5n91IirVxmcOxAJKUwJ
         Oo1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kI/Crql0FNrlDa/ubfAXL2ewr6hUN9HF7DMpMQOLpos=;
        b=ZvfaPcCBqmQpbetsuJpibdZbPzvW6uM+Z29/ivwURuTJkN/5oQOocUVFo0v/Q89G/Q
         Nv7Myb74mJiI5G90/WN3ShakyhAfm6z0NrpCRx2r1XF2+pclcqyvh+GfqbI3/5kDkJGs
         3ALxDK4CRN73WcteC0KWajIWeVqMMAtrFnEXkLjjLdDZI6eik6oorZpPDMxIJUWju1Ax
         +gRDR6PSamjJ8WLw2XKAsgMIrhVJINOVYmNnYetrJ6iukcikynmIXELUFgsQxIhvIZ8Z
         fu1+TZV6QYifWzBQa0JFxuSyj0MQHmqsWqIpTGkfKwXf/JnTII7pM4Lvz1QEcXcFAqAz
         RSiw==
X-Gm-Message-State: AOAM531Y5uhI7X84QYQA8jjOuRHtTZ0W4iWSpvTt7/GxM5ZJyI3wnB+I
        ed4sBDW5fWNV04Hw1frODRqXGhnAnwAk8PNt6CY=
X-Google-Smtp-Source: ABdhPJxON1hmj6X9tUJGCHVExUCOkn3uqr3SjA0b9qm1V/2xenLm9xgWyGIHMeoL4x9cadgCBUn1FTX++Bdngmjf/E4=
X-Received: by 2002:a92:d30f:: with SMTP id x15mr2673971ila.9.1603997799356;
 Thu, 29 Oct 2020 11:56:39 -0700 (PDT)
MIME-Version: 1.0
References: <160382543472.1203848.8335854864075548402.stgit@magnolia>
 <160382545348.1203848.12227735405144915534.stgit@magnolia>
 <CAOQ4uxhNpej-U-7NjA1VuU3OH=ttT7npwYrzODqThdta5Qka1A@mail.gmail.com> <20201029182747.GU1061252@magnolia>
In-Reply-To: <20201029182747.GU1061252@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 29 Oct 2020 20:56:28 +0200
Message-ID: <CAOQ4uxhHjfGdkHdyDDRbfu7vzb2r__89CyrQ4HikBCXpVspmUQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] xfs: detect time limits from filesystem
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 8:27 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Thu, Oct 29, 2020 at 12:47:32PM +0200, Amir Goldstein wrote:
> > On Wed, Oct 28, 2020 at 10:24 PM Darrick J. Wong
> > <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Teach fstests to extract timestamp limits of a filesystem using the new
> > > xfs_db timelimit command.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  common/rc         |    2 +-
> > >  common/xfs        |   14 ++++++++++++++
> > >  tests/xfs/911     |   44 ++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/911.out |   15 +++++++++++++++
> > >  tests/xfs/group   |    1 +
> > >  5 files changed, 75 insertions(+), 1 deletion(-)
> > >  create mode 100755 tests/xfs/911
> > >  create mode 100644 tests/xfs/911.out
> > >
> > >
> > > diff --git a/common/rc b/common/rc
> > > index 41f93047..162d957a 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -2029,7 +2029,7 @@ _filesystem_timestamp_range()
> > >                 echo "0 $u32max"
> > >                 ;;
> > >         xfs)
> > > -               echo "$s32min $s32max"
> > > +               _xfs_timestamp_range "$device"
> > >                 ;;
> > >         btrfs)
> > >                 echo "$s64min $s64max"
> > > diff --git a/common/xfs b/common/xfs
> > > index e548a0a1..19ccee03 100644
> > > --- a/common/xfs
> > > +++ b/common/xfs
> > > @@ -994,3 +994,17 @@ _require_xfs_scratch_inobtcount()
> > >                 _notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
> > >         _scratch_unmount
> > >  }
> > > +
> > > +_xfs_timestamp_range()
> > > +{
> > > +       local use_db=0
> > > +       local dbprog="$XFS_DB_PROG $device"
>
> Heh, device isn't defined, I'll fix that.
>
> > > +       test "$device" = "$SCRATCH_DEV" && dbprog=_scratch_xfs_db
> > > +
> > > +       $dbprog -f -c 'help timelimit' | grep -v -q 'not found' && use_db=1
> > > +       if [ $use_db -eq 0 ]; then
> > > +               echo "-$((1<<31)) $(((1<<31)-1))"
> >
> > This embodies an assumption that the tested filesystem does not have
> > bigtime enabled if xfs_db tool is not uptodate.
>
> If the xfs_db tool doesn't support the timelimit command then it doesn't
> support formatting with bigtime.  I don't think it's reasonable to
> expect to be able to run fstests on a test filesystem that xfsprogs
> doesn't support.  Hence it's fine to output the old limits if the
> timelimit command doesn't exist.

ok.

>
> > Maybe it makes sense, but it may be safer to return "-1 -1" and not_run
> > generic/402 if xfs_db is not uptodate, perhaps with an extra message
> > hinting the user to upgrade xfs_db.
>
> TBH it boggles my mind that there *still* is no way to ask the kernel
> for the supported timestamp range of a mounted filesystem.  The
> timelimit command and this mess in fstests was supposed to be a
> temporary workaround that would (in my ideal world) have become
> unnecessary before this landed, but ... ugh.
>

Oh well, consider this

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
