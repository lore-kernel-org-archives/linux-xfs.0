Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79ED1C433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 04:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48C5164EF6
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 04:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhBUEEY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 23:04:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52705 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhBUEEX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 23:04:23 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dimitri.ledkov@canonical.com>)
        id 1lDfy0-0007DI-Oz
        for linux-xfs@vger.kernel.org; Sun, 21 Feb 2021 04:03:32 +0000
Received: by mail-il1-f200.google.com with SMTP id s4so5653627ilv.23
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 20:03:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=88pmCQ8vIrazSRpj4ykaDBoNzGdmdnLrH/GPkMs2qJg=;
        b=CWF5qSd6YiZMpRq2jYShNSUJkUXVkuxP0nZDlmVa4eqvQPHOvJUKHwTwFKOZglYTxZ
         6V9ZhaEFb9JVyAX/om6A26S0eOsSHbJcjEoEA05WFHaVEFNnbOVvnhxeWObqxJSaBfH/
         +vgcatdS+QzcroVgD1/pT0s0KFiekl8n3Vc3tkHJBGWP7Vb7uQoRn5HK2c6bKh7XhKUP
         aVSce9Q5cmCfTa80n77O7Q0XKs86w1aDvdroTjM2mHxY1sJ6ScFdQMEHf+CozI7gUENv
         GZRMe0RQM5HrcnEKYuFyWWLRldz0CE3uxG7k9DZv3HGzMjkJvlNyuQK2sgPtGe3lN2Nr
         jn0Q==
X-Gm-Message-State: AOAM532q1DFpBqaq+BlZEZHJtr9C6qUasbDZSQYtpB6oDvwayS5UepQ6
        kElbD7dEjx9NzbDv7Amh5LzAOqex1HmKzTdWcPbPRl3JUWKdEvoT5E4MzvPg7FgiBNUlUyrXNf9
        MwLg5PyUkRnSnUxMEND3o07AiBgNYj3R3Ug/zQ68QjS6tbtjYJMdezA==
X-Received: by 2002:a5d:8d94:: with SMTP id b20mr10272392ioj.200.1613880211658;
        Sat, 20 Feb 2021 20:03:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxizyAspyB/Oa44LHVp8HNBEhWaXp6YG1Et5JSwYCCRNmOKD4uWgaWD6+nB1Dgu97zE5xJ7y4XrA7J3HlL7ZOg=
X-Received: by 2002:a5d:8d94:: with SMTP id b20mr10272375ioj.200.1613880211387;
 Sat, 20 Feb 2021 20:03:31 -0800 (PST)
MIME-Version: 1.0
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
 <20210220121610.3982-3-bastiangermann@fishpost.de> <20210221035943.GJ4662@dread.disaster.area>
In-Reply-To: <20210221035943.GJ4662@dread.disaster.area>
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Date:   Sun, 21 Feb 2021 04:02:55 +0000
Message-ID: <CADWks+Y93MB=fO42K4oQ2kKt=82bz9m=KDVHWeZmqxLV40-PdA@mail.gmail.com>
Subject: NACK Re: [PATCH 2/4] debian: Enable CET on amd64
To:     Dave Chinner <david@fromorbit.com>
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        linux-xfs@vger.kernel.org, Dimitri John Ledkov <xnox@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The patch in question is specific to Ubuntu and was not submitted by
me to neither Debian or Upstream.

Indeed, this is very distro specific, because of all the other things
that we turn on by default in our toolchain, dpkg build flags, and all
other packages.

This patch if taken at face value, will not enable CET. And will make
the package start failing to build from source, when using older
toolchains that don't support said flag.

It should not go upstream nor into debian.

NACK

On Sun, Feb 21, 2021 at 3:59 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sat, Feb 20, 2021 at 01:16:07PM +0100, Bastian Germann wrote:
> > This is a change introduced in 5.6.0-1ubuntu3.
> >
> > Reported-by: Dimitri John Ledkov <xnox@ubuntu.com>
> > Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
> > ---
> >  debian/changelog | 1 +
> >  debian/rules     | 8 +++++++-
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/debian/changelog b/debian/changelog
> > index 8320a2e8..c77f04ab 100644
> > --- a/debian/changelog
> > +++ b/debian/changelog
> > @@ -2,6 +2,7 @@ xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
> >
> >    [ Dimitri John Ledkov ]
> >    * Drop trying to create upstream distribution
> > +  * Enable CET on amd64
> >
> >   -- Bastian Germann <bastiangermann@fishpost.de>  Sat, 20 Feb 2021 11:57:31 +0100
> >
> > diff --git a/debian/rules b/debian/rules
> > index 8a3345b6..dd093f2c 100755
> > --- a/debian/rules
> > +++ b/debian/rules
> > @@ -23,8 +23,14 @@ pkgdev = DIST_ROOT=`pwd`/$(dirdev); export DIST_ROOT;
> >  pkgdi  = DIST_ROOT=`pwd`/$(dirdi); export DIST_ROOT;
> >  stdenv = @GZIP=-q; export GZIP;
> >
> > +ifeq ($(target),amd64)
> > +export DEB_CFLAGS_MAINT_APPEND=-fcf-protection
> > +export DEB_LDFLAGS_MAINT_APPEND=-fcf-protection
> > +endif
> > +include /usr/share/dpkg/default.mk
> > +
> >  options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
> > -       INSTALL_USER=root INSTALL_GROUP=root \
> > +       INSTALL_USER=root INSTALL_GROUP=root LDFLAGS='$(LDFLAGS)' \
> >         LOCAL_CONFIGURE_OPTIONS="--enable-editline=yes --enable-blkid=yes --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
> >  diopts  = $(options) \
> >         export OPTIMIZER=-Os LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --disable-ubsan --disable-addrsan --disable-threadsan --enable-lto" ;
>
> No. This is not the way to turn on build wide compiler/linker
> options/protections.
>
> IOWs, if you want to turn on control flow protections to make ROP
> exploits harder (why that actually matters for xfsprogs is beyond
> me), then it you need to add a configure option similar to
> --enable-lto. Then it can actually be enabled and used by other
> distros, not just Ubuntu, and it will also ensure that builds will
> fail at configure time if the compiler/linker does not support this
> functionality.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Dimitri.
