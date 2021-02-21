Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D70BC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 04:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F8B64F09
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 04:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhBUEeH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 23:34:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53244 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhBUEeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 23:34:06 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dimitri.ledkov@canonical.com>)
        id 1lDgQt-0001QG-Bn
        for linux-xfs@vger.kernel.org; Sun, 21 Feb 2021 04:33:23 +0000
Received: by mail-io1-f70.google.com with SMTP id q10so6933542ion.4
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 20:33:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zeHFZheTphVlLGIllBzi8dS6vYFWtK/5bAzRMREuPW8=;
        b=ty5FxTFZ2u+YmwDCZBWq6Q/bevaZCb1VxrTvPqItXDPxkG48vgTh3ikk6yJ1DgEEaT
         m47/QqDvTF025nzRi0c3eIe9qjwl0+azwl2qauV5LpHCxshDFu1B/8GnMn9Qn/53iCze
         twPTSxQIcxBDrbe0KI8BlG4W7WHSBxlaf2K+ql1gW0ErjH+GYk6vGJl/XrYAJvs2SSTA
         qSsXDWjxxXey70C9Qre7QTt23HycEIYAcOYDujx+ahRTc0UKKJdqwJJ+YhzVX1F77dEP
         xBJq5hRTGjcyRdh2MWe+RFsKYOLbCXc7YC0/GCTDZiq7Pr/VXJ2KLWwMJofXxd3yy5sS
         66+w==
X-Gm-Message-State: AOAM533yXpefOWXt/Fy9ehdOTow8oIjpOKKioek16MGkMm/CrS0jkZAJ
        bwCeidTKYB9cH8uerzqYd5wW2S4AeI9TA/T0ljrJHiAjmH2abiB6+39ytrVYLUDmxsu8f0isCWv
        UGkYz+kV5oEQ2B5X8v00n10V5LkR8AEC3T56OwbAm8Y7+aB14DCfErw==
X-Received: by 2002:a92:cda1:: with SMTP id g1mr10107583ild.267.1613882002245;
        Sat, 20 Feb 2021 20:33:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvOuwQBmCn1YlSWkPl8GR2VS4XmprJGDM0HCxqy8HVcwjVTMxrE6vsVAv+TfmuOr/WqsQOhoTc8RC1nZrlh2c=
X-Received: by 2002:a92:cda1:: with SMTP id g1mr10107578ild.267.1613882001999;
 Sat, 20 Feb 2021 20:33:21 -0800 (PST)
MIME-Version: 1.0
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
 <20210220121610.3982-3-bastiangermann@fishpost.de> <20210221035943.GJ4662@dread.disaster.area>
 <CADWks+Y93MB=fO42K4oQ2kKt=82bz9m=KDVHWeZmqxLV40-PdA@mail.gmail.com> <20210221042809.GM4662@dread.disaster.area>
In-Reply-To: <20210221042809.GM4662@dread.disaster.area>
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Date:   Sun, 21 Feb 2021 04:32:46 +0000
Message-ID: <CADWks+Yf_Vg7fTPH_BoXEmxUoo_XnyCLj4oeBme5fRTqoy+o4g@mail.gmail.com>
Subject: Re: NACK Re: [PATCH 2/4] debian: Enable CET on amd64
To:     Dave Chinner <david@fromorbit.com>
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 21, 2021 at 4:28 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sun, Feb 21, 2021 at 04:02:55AM +0000, Dimitri John Ledkov wrote:
> > The patch in question is specific to Ubuntu and was not submitted by
> > me to neither Debian or Upstream.
> >
> > Indeed, this is very distro specific, because of all the other things
> > that we turn on by default in our toolchain, dpkg build flags, and all
> > other packages.
> >
> > This patch if taken at face value, will not enable CET. And will make
> > the package start failing to build from source, when using older
> > toolchains that don't support said flag.
>
> Yes, that is exactly what I said when pointing out how to *support
> this properly* so it doesn't break builds in environments that do
> not support such functionality.
>
> Having it as a configure option allows the configure script to -test
> whether the toolchain supports it- and then either fail (enable=yes)
> or not use it (enable=probe) and continue the build without it.
>
> > It should not go upstream nor into debian.
>
> There is no reason it cannot be implemented as a build option in the
> upstream package. Then you can get rid of all your nasty hacks and
> simply add --enable-cf-protections to your distro's configure
> options.
>
> And other distros that also support all this functionality can use
> it to. Please play nice with others and do things the right way
> instead of making silly claims about how "nobody else can use this"
> when it's clear that they can if they also tick all the necessary
> boxes.

debian will probably will not want --enable-cf-protections as a
configure option, and will enable CET via dpkg-buildflags as a
hardening option, which will then be turned on by default for relevant
architectures and series as of when debian kernel starts to support
it.

as that way, debian will be able to affect that change across the whole distro.

once CET is actually merged into kernel, I do not expect configure
options or debian/rules changes to enable CET. At most `export
DEB_BUILD_MAINT_OPTIONS=hardening` should be enough in debian/rules.

-- 
Regards,

Dimitri.
