Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142C0C636CD
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Feb 2023 14:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbjBJOcD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Feb 2023 09:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjBJOcC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Feb 2023 09:32:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB6B73592
        for <linux-xfs@vger.kernel.org>; Fri, 10 Feb 2023 06:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676039479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CxCZdlgisbJF+70cUuNF+5Uw7zIaXlckpzFKUdliauo=;
        b=Ts4dhcV21EYL7PW4RuLWuKJo3NyO8h5zNKiHOo/6EBNH2PW48ZiNP32gE2cHbiJrWrI81E
        IxpIX37RQZXTISF887aVVci3TUHNHTjFhaSbclJhp8KG2UsDDPBFrJxdt41YPUW8TrM81V
        XdS5yGeNV6o+TDWW7f6Su/ga5ffsUV4=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-202-ceqjT5wyNOKC-1sf85JSQQ-1; Fri, 10 Feb 2023 09:31:17 -0500
X-MC-Unique: ceqjT5wyNOKC-1sf85JSQQ-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-16a0bd03b41so2805293fac.21
        for <linux-xfs@vger.kernel.org>; Fri, 10 Feb 2023 06:31:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CxCZdlgisbJF+70cUuNF+5Uw7zIaXlckpzFKUdliauo=;
        b=mvIBA++lyUP80YYUzB9IMBUVHDg9IrVCCWkONO4EZHjVLVGa/SLeP5SiIni3DrHKpa
         ItVCJrth76rWFdFjaIMOOHTAKYTQGWzTiPxFpM2goRL2xPIg9V2XdO3/UkQXm/OgjNy+
         DQod8tD8qmPsPFVccQdirBGtgjEqf0CzwrpAK9wPG5IxwvSA/5gn453ITHGEDnkIy6pr
         SPTG+yyRoh3qf13qiuXs4w+0mT2aEEZBqbMM5djZT7DgzudRpMnFNXJzv2fSGbxXgfLV
         6b7U+Z3OzqE7QYTdsUd+9IYdrjeTXYmOugYG3LwKfSsdL1A0y9OzuPKX49YNyXOPFhrc
         7csw==
X-Gm-Message-State: AO0yUKXn2L+3WxazMbFBAfZpuDJd4E5OmPQkAkZQcaADONOkXHAtX95a
        KnADm7C/x3zqtJxRwewqj3AnstrRkbj9LLo4jKdmz+GFWbvsakvUpoa36QTqj3s7Wqfk59ospFl
        VHiUWMLzLma6OJJ35vP5moIJd8QogxpCyDCsB
X-Received: by 2002:aca:2306:0:b0:378:3a69:fb63 with SMTP id e6-20020aca2306000000b003783a69fb63mr935659oie.290.1676039475665;
        Fri, 10 Feb 2023 06:31:15 -0800 (PST)
X-Google-Smtp-Source: AK7set85yUFXBU+9Mls6G16gOAHBd8KtZA87AooKVYyX11r0gffDjcKA5VQwnqejYOW84bLp4pozg7Y1SbyyHeURiUU=
X-Received: by 2002:aca:2306:0:b0:378:3a69:fb63 with SMTP id
 e6-20020aca2306000000b003783a69fb63mr935656oie.290.1676039475383; Fri, 10 Feb
 2023 06:31:15 -0800 (PST)
MIME-Version: 1.0
References: <20230208143416.425941-1-arjun@redhat.com> <Y+PPKBlzv6+DNfBf@magnolia>
In-Reply-To: <Y+PPKBlzv6+DNfBf@magnolia>
From:   Arjun Shankar <arjun@redhat.com>
Date:   Fri, 10 Feb 2023 15:31:04 +0100
Message-ID: <CAG_osaZ2xhdW=6S8fDXr7VQ6WMpyr_bT--LcwCSXCwvXQ1OV4A@mail.gmail.com>
Subject: Re: [PATCH v2] Remove several implicit function declarations
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 8, 2023 at 5:43 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Feb 08, 2023 at 03:34:16PM +0100, Arjun Shankar wrote:
> > During configure, several ioctl checks omit the corresponding include
> > and a pwritev2 check uses the wrong feature test macro.
> > This commit fixes the same.
> >
> > Signed-off-by: Arjun Shankar <arjun@redhat.com>
> > ---
> > We ran into these when trying to port Fedora to modern C:
> >
> > https://fedoraproject.org/wiki/Changes/PortingToModernC
> > https://fedoraproject.org/wiki/Toolchain/PortingToModernC
> >
> > v2 notes: Removed the changes to unicrash.c;
> >           it was already fixed by 5ead2de386d879
> > ---
> >  m4/package_libcdev.m4 | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> > index bb1ab49c..f987aa4a 100644
> > --- a/m4/package_libcdev.m4
> > +++ b/m4/package_libcdev.m4
> > @@ -117,6 +117,7 @@ AC_DEFUN([AC_HAVE_FIEMAP],
> >  #define _GNU_SOURCE
> >  #include <linux/fs.h>
> >  #include <linux/fiemap.h>
> > +#include <sys/ioctl.h>
> >       ]], [[
> >  struct fiemap *fiemap;
> >  ioctl(0, FS_IOC_FIEMAP, (unsigned long)fiemap);
> > @@ -153,7 +154,7 @@ AC_DEFUN([AC_HAVE_PWRITEV2],
> >    [ AC_MSG_CHECKING([for pwritev2])
> >      AC_LINK_IFELSE(
> >      [        AC_LANG_PROGRAM([[
> > -#define _BSD_SOURCE
> > +#define _GNU_SOURCE
>
> Could you update the pwritev2 manpage to document that _GNU_SOURCE is
> the feature test macro for pwritev2?

Thanks for pointing this out. I'm making a note to get this done. In
addition, there's a chance that pwritev2 might be made available under
_DEFAULT_SOURCE in future versions of glibc. Either way, current
versions of glibc do make this function available under _GNU_SOURCE
and that needs to be documented.

> >  #include <sys/uio.h>
> >       ]], [[
> >  pwritev2(0, 0, 0, 0, 0);
> > @@ -454,6 +455,7 @@ AC_DEFUN([AC_HAVE_SG_IO],
> >      AC_COMPILE_IFELSE(
> >      [        AC_LANG_PROGRAM([[
> >  #include <scsi/sg.h>
> > +#include <sys/ioctl.h>
> >       ]], [[
> >  struct sg_io_hdr hdr;
> >  ioctl(0, SG_IO, &hdr);
> > @@ -471,7 +473,8 @@ AC_DEFUN([AC_HAVE_HDIO_GETGEO],
> >    [ AC_MSG_CHECKING([for struct hd_geometry ])
> >      AC_COMPILE_IFELSE(
> >      [        AC_LANG_PROGRAM([[
> > -#include <linux/hdreg.h>,
>
> Gosh, how did that ever work with the trailing comma??

That surprised me as well. cpp seems to complain about it but is fine
with it for some reason.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks for the review!

