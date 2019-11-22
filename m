Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70687C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 16:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 395012071C
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 16:44:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aGpDuUE+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKVQoK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 11:44:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52280 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726046AbfKVQoK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 11:44:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574441048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mp0eQbgbMSDorBrxluA3vFioIit1coJg79b5KHXGyqI=;
        b=aGpDuUE+fGKXGEDFcMvrfyN3jkm7xoCd/md8HsjoRptB/khDrcXfKzUAkqYWXNrmySGqw/
        AYybaOa/Cg9e0kopRcBlTR/G6m6d9yde+mehh8oJXpyedvmShkRjcT+bWJBUBvOQsfImL5
        TK84YLtg8hpcoujwftMZ60Qz47EBBwE=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-NBmLcHvyPxmfOds6onhDYQ-1; Fri, 22 Nov 2019 11:44:07 -0500
Received: by mail-vk1-f200.google.com with SMTP id v71so3108370vkd.16
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 08:44:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y5KL4HpYah5p74b1e3x46ve7zFlWcUzRnwFJDnw0Vrk=;
        b=QtafvcAvCyAr6wVp4fy7uE1Zy4/WTCsjc/7mg22ujmWZRy4mdy7G6q847HPdJ/zBuu
         ZIUzESSoEueA618nzDeGdgGQN+ggkVODGLBShwVyiKA+ZeFVi9hM1XEyeeWEJxVe0Z8q
         uuAabBHoMvpsnzWZE98TcC4sWxDT9zQ9pAbmMLZnZMtBIn1iM0kim7GH4o1zIX+BS6zs
         G4XNDWRGa8U6VKEZMMf0UonfU2O8zKAwadTBG89kjZOwBeTCTQ3iVTVNBhgJgjtifllq
         laZr54hCqgqu4j7awVe/Fr0nDpRsW/yNlVpawySORfXSEwxl2Zlq+nqgNxVljLeV0Zh9
         1xGQ==
X-Gm-Message-State: APjAAAW04qfvs6NS/MuUOrGnmGj1PrL9b4ppgCrcrqXL7m+fGMpnP6Uw
        iedEFAOWqiE0sEuTnbIpyfShKFqHyIt4R5uOtKWdnm3P2pHsAyaw6k/em3OlbWgNVlrWElPQgiD
        u3Csm913qggT4uE6ZzciPHkracvq2gI8QKz2A
X-Received: by 2002:a1f:9192:: with SMTP id t140mr10318325vkd.27.1574441046323;
        Fri, 22 Nov 2019 08:44:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqyQDtW+ETVtF1rmb66FjaMOXgWskL6eDrPE+CyIhX7v8WLa3Dw2RClmqSu0tUSzY40NWxeRrgWfEM7WdnXYhdE=
X-Received: by 2002:a1f:9192:: with SMTP id t140mr10318299vkd.27.1574441045946;
 Fri, 22 Nov 2019 08:44:05 -0800 (PST)
MIME-Version: 1.0
References: <20191121214445.282160-1-preichl@redhat.com> <20191121214445.282160-3-preichl@redhat.com>
 <20191121234159.GI4614@dread.disaster.area>
In-Reply-To: <20191121234159.GI4614@dread.disaster.area>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Fri, 22 Nov 2019 17:43:55 +0100
Message-ID: <CAJc7PzVBcjXc5uBgyT_XiX1ffaoRTe8jkWmSq-F8pZqezpEnGA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mkfs: Show progress during block discard
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
X-MC-Unique: NBmLcHvyPxmfOds6onhDYQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 12:42 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Nov 21, 2019 at 10:44:45PM +0100, Pavel Reichl wrote:
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  mkfs/xfs_mkfs.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index a02d6f66..07b8bd78 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -1248,6 +1248,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
> >       const uint64_t  step            =3D (uint64_t)2<<30;
> >       /* Sector size is 512 bytes */
> >       const uint64_t  count           =3D nsectors << 9;
> > +     uint64_t        prev_done       =3D (uint64_t) ~0;
> >
> >       fd =3D libxfs_device_to_fd(dev);
> >       if (fd <=3D 0)
> > @@ -1255,6 +1256,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
> >
> >       while (offset < count) {
> >               uint64_t        tmp_step =3D step;
> > +             uint64_t        done =3D offset * 100 / count;
>
> That will overflow on a EB-scale (2^60 bytes) filesystems, won't it?

I guess that can happen, sorry. I'll try to come out with computation
based on a floating point arithmetic. There should not be any
performance or actual precision problem.
(well actually I'll drop this line completely, no ratio will be
computed in the end)

>
> >
> >               if ((offset + step) > count)
> >                       tmp_step =3D count - offset;
> > @@ -1268,7 +1270,13 @@ discard_blocks(dev_t dev, uint64_t nsectors)
> >                       return;
> >
> >               offset +=3D tmp_step;
> > +
> > +             if (prev_done !=3D done) {
> > +                     prev_done =3D done;
> > +                     fprintf(stderr, _("Discarding: %2lu%% done\n"), d=
one);
> > +             }
> >       }
> > +     fprintf(stderr, _("Discarding is done.\n"));
>
> Hmmm - this output doesn't get suppressed when the "quiet" (-q)
> option is used. mkfs is supposed to be silent when this option is
> specified.

OK, my bad. I'll fix that.
>
> I also suspect that it breaks a few fstests, too, as a some of them
> capture and filter mkfs output. They'll need filters to drop these
> new messages.
>
> FWIW, a 100 lines of extra mkfs output is going to cause workflow
> issues. I know it will cause me problems, because I often mkfs 500TB
> filesystems tens of times a day on a discard enabled device. This
> extra output will scroll all the context of the previous test run
> I'm about to compare against off my terminal screen and so now I
> will have to scroll the terminal to look at the results of
> back-to-back runs. IOWs, I'm going to immediately want to turn this
> output off and have it stay off permanently.
>
> Hence I think that, by default, just outputting a single "Discard in
> progress" line before starting the discard would be sufficient

OK, maybe just one line "Discard in progress" is actually what users
need. The computing of % done was probably just overkill from my side.
Sorry about that.

> indication of what mkfs is currently doing. If someone wants more
> verbose progress output, then we should probably introduce a
> "verbose" CLI option to go along with the "quiet" option that
> suppresses all output.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

