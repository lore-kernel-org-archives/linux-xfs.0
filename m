Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8F8C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 07:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiFFHWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 03:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiFFHWS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 03:22:18 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF1EB4A
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 00:22:16 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id r9so4511179uaf.13
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jun 2022 00:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iCwEkoc1txqrQ04SGNW0C/qlLiippZwL9GMHRIuOW/A=;
        b=QZ7ACBslW2Wfrq//MoESTeGgRPCmQurAPCu4z5HS7T+ycIWxNH0PtK+OgIh+wMMUBH
         KG/s+LWbPx3wRlmv/QVuAtWcm0BhleIba4xlZ59nSLDGW+/UT8wOP/uIxp2JzbOo6PvF
         fprKbyYRaL0+2SX5cZJouqnGoVdOnuh1VN5G+1H+HfMrz0odgmAzuv1PCMkeuqk1ubrS
         br5oNwnXlKdLGg64A1drY9qwarAKJesgAMdDoKMY4w2qz6mQ3g3UrNjCS62tPZ+pt5gp
         pDmk+iLK2Ubh7pEw71MhDqkU41Le98WVsk5gQ+bUCncXPMY+Km4tdRmAk/MRJPVdX8Dz
         EDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iCwEkoc1txqrQ04SGNW0C/qlLiippZwL9GMHRIuOW/A=;
        b=HIzy75afT3t8lkguqa862LH4MmetbdB0ZMmCLd9QpjzL+EDL3jaWjA9k9HrdHFdNMG
         bbNJrQ1U+9pxDeO0KQtuFMSWA/h20Y9CVnXJTHGAiwRb24Y3BC0Ff4cFtYoy/Qj1obVH
         ssYzs7Cl7xsNPr5icm293if7WMqcfrzNDZKKCDNAAMFbGvaj5EFaCuF4ijfQVP19wbCf
         Ur0NzjdDrpV+iNayppmF52WG+fiddW+I0BCw1ilvMORotlwTruwaW8HrS2Q50WxoDCi5
         IPPCuPy7bAbMGvzLHnpZkQwITIGKwPlYLmsTcMSRdipCrGm7eOLkIoH4PmRtOoZ3/ikp
         eCQQ==
X-Gm-Message-State: AOAM53216HLF9HG21qf3kMYjzU+dXXi2gA0bdSd47//YAuX3y82mnOqb
        gCBgsBOOIoMmVfBUN5A9pSrP9z+kWMwcHflrDPOzrOvoRXobYQ==
X-Google-Smtp-Source: ABdhPJyVfKY2laotJNoL7XRr6RoIHRPNLEj+deGAGDSZe5K8PhkArMYutonhgIxxq29gO/kxOdypzpGAVxAr0NMtoCc=
X-Received: by 2002:ab0:3da8:0:b0:35d:1e90:ee26 with SMTP id
 l40-20020ab03da8000000b0035d1e90ee26mr31267785uac.80.1654500135277; Mon, 06
 Jun 2022 00:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <YpzbX/5sgRIcN2LC@magnolia> <20220605222940.GL1098723@dread.disaster.area>
 <Yp1EGf+d/rzCgvJ4@magnolia>
In-Reply-To: <Yp1EGf+d/rzCgvJ4@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 6 Jun 2022 10:22:03 +0300
Message-ID: <CAOQ4uxiMJ9gGATN8pdPhJhR-_3m2N4vcFTeBPLdLL1DFddRy9g@mail.gmail.com>
Subject: Re: [PATCH] xfs: preserve DIFLAG2_NREXT64 when setting other inode attributes
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 6, 2022 at 8:24 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Mon, Jun 06, 2022 at 08:29:40AM +1000, Dave Chinner wrote:
> > On Sun, Jun 05, 2022 at 09:35:43AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > It is vitally important that we preserve the state of the NREXT64 inode
> > > flag when we're changing the other flags2 fields.
> > >
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_ioctl.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > Fixes tag?

Thank you Dave!

>
> Does this really need one?

I say why not.

I am not looking for a fight. Really, it's up to xfs maintainers how to manage
experimental features. That is completely outside of scope for LTS.
I only want to explain my POV as a developer.

You know my interest is in backporting fixes for LTS, so this one won't be
relevant anyway, but if I were you, I would send this patch to stable 5.18.y
to *reduce* burden on myself -

The mental burden of having to carry the doubt of whether a certain
reported bug could have been involved with user booting into 5.18.y
and back.

When you think about it, it kind of makes sense to have the latest .y
in your grub menu when you are running upstream...
Users do that - heck, user do anything you don't want them to do,
even if eventually you can tell the users they did something that is
not expected to work, you had already invested the time in triage.

Sure, there is always the possibility that someone in the future of 5.19.y
will boot into 5.18.0, but that is a far less likely possibility.

For this reason, when I write new features I really try to treat the .y
release as the true release cycle of that feature rather than the .0,
regardless of LTS.
If I were the developer of the feature, I would have wanted to see
this fix applied to 5.18.y.

Thanks,
Amir.
