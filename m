Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B95F8C4320A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 10:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A20C60F23
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 10:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbhG2KTM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 06:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbhG2KTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jul 2021 06:19:10 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1584C061757;
        Thu, 29 Jul 2021 03:19:07 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id m12so2477599qvt.1;
        Thu, 29 Jul 2021 03:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=Uy43ytHtPMo4HQ8sAfwR9QUKOxEF8UFfh2huFVQFBWg=;
        b=buplz+FnkMrw9wHPZz5Px7CtW4U1mcPc5yHT2P+jMbYTRKQJMe+WQrtRRV158DNHWc
         +NBh417DT5NWXTJ359vBK5Hk+hqRv2nsVFFjNnqM3O7frQCuewq3QDEKEJ1nbW6g+txP
         nzvbX2MG9FCUFMVrqD2lWI73a4uwLLw/3T5NCQaym7W2XU8t+3wOJd2rXeT14/fVHeFd
         /f3mRFRGuT5FLra1PDSxFSgGeA9SDrA4GKC1cEwkAWz48MNofGDwl8QlFAwc4YSnlOvR
         7oLXwA/uMIhxP7QvMUxL2nrfTr0wyud2Gl7x7eav/yM9U/Rcxf+BodLNjwVgcOWIyRJj
         rlqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=Uy43ytHtPMo4HQ8sAfwR9QUKOxEF8UFfh2huFVQFBWg=;
        b=q2DyCvxnviCfv3IDSwyHnwgI92msddiwiIBhGgSVRMEKYtQnRwachUAhLtvFyRPEV8
         06eeH4x5aSYLZ/B9Ig3MPyjInZzd3BBAc5lFgAOtELZbqgNd3S3Iird30y2CXdkWCYka
         k8qZvet4hcAG2+BxbjQZgmI4joHw62ODIJgxRidFnuNyZSn5ltzqY3xo0OxCy5isBtMs
         MENppKU6mbF8MSeB2mJ6G0xbpGexSvwxZvgZrSRzI8gXSuHFJRsw0wK2kN9nFry0bGQs
         A3s/LxgcL24lKM4LfUMX5ztm18a8BZoEK7le2bbbVphtT8sO/cLQ1JY1+21Sb+wXnMH0
         CCDA==
X-Gm-Message-State: AOAM533JhhrGc5i5r+py3QcrqX9csyogGQ3PssBym21WWpeUCYzQqLJo
        OvqQot3WJaRG0+jrb/rEuSvUQAb+7NVgo6BTFdM=
X-Google-Smtp-Source: ABdhPJyBXgJNGr05m8FhUUYj09ElAJZ+PanhziO2o9ucJb5Sik/pvCdkDOeZ89uv7UHyJpeqym3a0sEVIBJ9bQJTNuY=
X-Received: by 2002:ad4:52ea:: with SMTP id p10mr4046161qvu.45.1627553947058;
 Thu, 29 Jul 2021 03:19:07 -0700 (PDT)
MIME-Version: 1.0
References: <162743103739.3429001.16912087881683869606.stgit@magnolia>
 <162743104288.3429001.18145781236429703996.stgit@magnolia>
 <CAL3q7H511wY0nHvTuqfnp0ttvvGuFt9Eke2B6cXy_4+JDyJVRw@mail.gmail.com> <20210728164553.GA3601443@magnolia>
In-Reply-To: <20210728164553.GA3601443@magnolia>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 29 Jul 2021 11:18:56 +0100
Message-ID: <CAL3q7H5Q+dvpcGiiOO95S9F3Sv7k+hQj+=L_eiZ4J0Wqpb+WEA@mail.gmail.com>
Subject: Re: [PATCH 1/1] misc: tag all tests that examine crash recovery in a loop
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 28, 2021 at 5:45 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Jul 28, 2021 at 10:40:29AM +0100, Filipe Manana wrote:
> > On Wed, Jul 28, 2021 at 1:10 AM Darrick J. Wong <djwong@kernel.org> wro=
te:
> > >
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > Given all the recent problems that we've been finding with log recove=
ry,
> > > I think it would be useful to create a 'recoveryloop' group so that
> > > developers have a convenient way to run every single test that rolls
> > > around in a fs shutdown loop looking for subtle errors in recovery.
> > >
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/btrfs/190   |    2 +-
> > >  tests/generic/019 |    2 +-
> > >  tests/generic/388 |    2 +-
> > >  tests/generic/455 |    2 +-
> > >  tests/generic/457 |    2 +-
> > >  tests/generic/475 |    2 +-
> > >  tests/generic/482 |    2 +-
> > >  tests/generic/725 |    2 +-
> > >  tests/xfs/057     |    2 +-
> > >  9 files changed, 9 insertions(+), 9 deletions(-)
> > >
> > >
> > > diff --git a/tests/btrfs/190 b/tests/btrfs/190
> > > index 3aa718e2..974438c1 100755
> > > --- a/tests/btrfs/190
> > > +++ b/tests/btrfs/190
> > > @@ -8,7 +8,7 @@
> > >  # balance needs to be resumed on mount.
> > >  #
> > >  . ./common/preamble
> > > -_begin_fstest auto quick replay balance qgroup
> > > +_begin_fstest auto quick replay balance qgroup recoveryloop
> >
> > For btrfs, there are more tests like this: btrfs/172, btrfs/192 and btr=
fs/206.
>
> I saw those when I was collecting tests for the new group.  I couldn't
> tell if they were looping recovery tests, though if you'd like me to add
> them to the group I certain will?

If you have to send another version, please include them.
Otherwise I won't bother you as probably Eryu can do it at commit time.

thanks

>
> --D
>
> > >
> > >  # Import common functions.
> > >  . ./common/filter
> > > diff --git a/tests/generic/019 b/tests/generic/019
> > > index b8d025d6..db56dac1 100755
> > > --- a/tests/generic/019
> > > +++ b/tests/generic/019
> > > @@ -8,7 +8,7 @@
> > >  # check filesystem consistency at the end.
> > >  #
> > >  . ./common/preamble
> > > -_begin_fstest aio dangerous enospc rw stress
> > > +_begin_fstest aio dangerous enospc rw stress recoveryloop
> > >
> > >  fio_config=3D$tmp.fio
> > >
> > > diff --git a/tests/generic/388 b/tests/generic/388
> > > index e41712af..9cd737e8 100755
> > > --- a/tests/generic/388
> > > +++ b/tests/generic/388
> > > @@ -15,7 +15,7 @@
> > >  # spurious corruption reports and/or mount failures.
> > >  #
> > >  . ./common/preamble
> > > -_begin_fstest shutdown auto log metadata
> > > +_begin_fstest shutdown auto log metadata recoveryloop
> > >
> > >  # Override the default cleanup function.
> > >  _cleanup()
> > > diff --git a/tests/generic/455 b/tests/generic/455
> > > index 62788798..13d326e7 100755
> > > --- a/tests/generic/455
> > > +++ b/tests/generic/455
> > > @@ -7,7 +7,7 @@
> > >  # Run fsx with log writes to verify power fail safeness.
> > >  #
> > >  . ./common/preamble
> > > -_begin_fstest auto log replay
> > > +_begin_fstest auto log replay recoveryloop
> > >
> > >  # Override the default cleanup function.
> > >  _cleanup()
> > > diff --git a/tests/generic/457 b/tests/generic/457
> > > index d9e38268..f4fdd81d 100755
> > > --- a/tests/generic/457
> > > +++ b/tests/generic/457
> > > @@ -7,7 +7,7 @@
> > >  # Run fsx with log writes on cloned files to verify power fail safen=
ess.
> > >  #
> > >  . ./common/preamble
> > > -_begin_fstest auto log replay clone
> > > +_begin_fstest auto log replay clone recoveryloop
> > >
> > >  # Override the default cleanup function.
> > >  _cleanup()
> > > diff --git a/tests/generic/475 b/tests/generic/475
> > > index 62894491..c426402e 100755
> > > --- a/tests/generic/475
> > > +++ b/tests/generic/475
> > > @@ -12,7 +12,7 @@
> > >  # testing efforts.
> > >  #
> > >  . ./common/preamble
> > > -_begin_fstest shutdown auto log metadata eio
> > > +_begin_fstest shutdown auto log metadata eio recoveryloop
> > >
> > >  # Override the default cleanup function.
> > >  _cleanup()
> > > diff --git a/tests/generic/482 b/tests/generic/482
> > > index f26e6fc4..0fadf795 100755
> > > --- a/tests/generic/482
> > > +++ b/tests/generic/482
> > > @@ -9,7 +9,7 @@
> > >  # Will do log replay and check the filesystem.
> > >  #
> > >  . ./common/preamble
> > > -_begin_fstest auto metadata replay thin
> > > +_begin_fstest auto metadata replay thin recoveryloop
> > >
> > >  # Override the default cleanup function.
> > >  _cleanup()
> > > diff --git a/tests/generic/725 b/tests/generic/725
> > > index f43bcb37..8bd724e3 100755
> > > --- a/tests/generic/725
> > > +++ b/tests/generic/725
> > > @@ -12,7 +12,7 @@
> > >  # in writeback on the host that cause VM guests to fail to recover.
> > >  #
> > >  . ./common/preamble
> > > -_begin_fstest shutdown auto log metadata eio
> > > +_begin_fstest shutdown auto log metadata eio recoveryloop
> > >
> > >  _cleanup()
> > >  {
> > > diff --git a/tests/xfs/057 b/tests/xfs/057
> > > index d4cfa8dc..9fb3f406 100755
> > > --- a/tests/xfs/057
> > > +++ b/tests/xfs/057
> > > @@ -21,7 +21,7 @@
> > >  # Note that this test requires a DEBUG mode kernel.
> > >  #
> > >  . ./common/preamble
> > > -_begin_fstest auto log
> > > +_begin_fstest auto log recoveryloop
> > >
> > >  # Override the default cleanup function.
> > >  _cleanup()
> > >
> >
> >
> > --
> > Filipe David Manana,
> >
> > =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 yo=
u're right.=E2=80=9D



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
