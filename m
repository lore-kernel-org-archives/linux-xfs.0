Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03F5C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 19:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbiD0T71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 15:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbiD0T7W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 15:59:22 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EC57CDF0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 12:56:08 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id c17-20020a056830349100b00605ca7d1deeso1798001otu.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 12:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E27OOLHBK3f5pbxnO2jPGMRONaGueCYRKHPMGvRVzwo=;
        b=lkSyghlnWuTYmpGUqzBF3mvfP1EfuMdiQ3vLflrAtqk0T1GuW+OWhn7mc9CLxDHrQN
         7uCY6O563kuk7eiqRxwyQSOHT2ieZqWqZhu6wyQ+0ymsekBLMuneqSKUY9q+AqXSff4U
         Oc+iDGIMMDF6RlrUCDkzG7GbF9QX/2nP0r4d5CfcM8jL8310wBUG0KKu15VrdzmEtXuF
         hfES51h0OkM3duZQCx82rWHHNN4SKxbXCuxqeL+S2n8UV8f/XBlOOw16QfCg40fL8CAo
         8zdl7eBhViLu5BlUwrcRMBm+1hSB+KdAOKyvm6tkufLPFJLKqAo5H4c+cxvhNoNE3Q/N
         nkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E27OOLHBK3f5pbxnO2jPGMRONaGueCYRKHPMGvRVzwo=;
        b=QXeBssxxfjLVfA90zKfuYA00v3piOL5IzlhJLCeslsBvw+J+i1ML/5tvu9QCZhNmM/
         B0pxQsveh4nre1Y79rhSB7s6Kwmu+cInL7yCgc+SSl6jhj6PKFAXtfdlDhvSgTFvLiiJ
         L9MVV/ob3TmK/+nTcZVgZvftD2gjzkfP7UZslF+4X8c/5RnTsmMJCjx3d8dCtMay5wBz
         Xak2T2G8TEfVMUuqYQizeBPqtEkVVf0GGOa+yq5TWOZsc5dQPhVamTR+E5jCseU7zIl3
         5HLqdOkh2DZIx54ijBE4jIkZ7nZU3/MxUgTHCNUKisLpwJk1uKKZ4OtXlCJw/KIwyUXv
         haVQ==
X-Gm-Message-State: AOAM530CBuQqsljk2T3G4hJyXxfj3xdwGEQXd2ql2MyDZBr962xMtaCS
        dwvIYJj28IDgrHbFa6tUgkKM6+zL1fw3rsSfN6xVd+pG
X-Google-Smtp-Source: ABdhPJwLOqTDw2GDoReystdjGxROSyPCWja7QiOUEDPNr6yDJG66xG8VhfHYPRYChxIx6Q1kz7CHLsdhD0O/H/q/ibk=
X-Received: by 2002:a9d:740c:0:b0:605:db6f:1aca with SMTP id
 n12-20020a9d740c000000b00605db6f1acamr1874249otk.114.1651089368262; Wed, 27
 Apr 2022 12:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220418203606.760110-1-fontaine.fabrice@gmail.com> <20220418230222.GN1544202@dread.disaster.area>
In-Reply-To: <20220418230222.GN1544202@dread.disaster.area>
From:   Fabrice Fontaine <fontaine.fabrice@gmail.com>
Date:   Wed, 27 Apr 2022 21:54:02 +0200
Message-ID: <CAPi7W8206zDwkfbw4ruQ2B+TN+E3XX2NQ35mtzMT+aQ2+6BYAw@mail.gmail.com>
Subject: Re: [PATCH] io/mmap.c: fix musl build on mips64
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Were you able to go further in your tests?

Best Regards,

Fabrice


Le mar. 19 avr. 2022 =C3=A0 01:02, Dave Chinner <david@fromorbit.com> a =C3=
=A9crit :
>
> On Mon, Apr 18, 2022 at 10:36:06PM +0200, Fabrice Fontaine wrote:
> > musl undefines MAP_SYNC on some architectures such as mips64 since
> > version 1.1.20 and
> > https://github.com/ifduyue/musl/commit/9b57db3f958d9adc3b1c7371b5c6723a=
aee448b7
> > resulting in the following build failure:
> >
> > mmap.c: In function 'mmap_f':
> > mmap.c:196:33: error: 'MAP_SYNC' undeclared (first use in this function=
); did you mean 'MS_SYNC'?
> >   196 |                         flags =3D MAP_SYNC | MAP_SHARED_VALIDAT=
E;
> >       |                                 ^~~~~~~~
> >       |                                 MS_SYNC
> >
> > To fix this build failure, include <sys/mman.h> before the other
> > includes
> >
> > Fixes:
> >  - http://autobuild.buildroot.org/results/3296194907baf7d3fe039f59bcbf5=
95aa8107a28
> >
> > Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
> > ---
> >  io/mmap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/io/mmap.c b/io/mmap.c
> > index 8c048a0a..b8609295 100644
> > --- a/io/mmap.c
> > +++ b/io/mmap.c
> > @@ -4,9 +4,9 @@
> >   * All Rights Reserved.
> >   */
> >
> > +#include <sys/mman.h>
> >  #include "command.h"
> >  #include "input.h"
> > -#include <sys/mman.h>
> >  #include <signal.h>
> >  #include "init.h"
> >  #include "io.h"
>
> I can't see how this makes any difference to the problem, nor can I
> see why you are having this issues.
>
> From the configure output:
>
> ....
> checking for MAP_SYNC... no
> ....
>
> It is clear that the build has detected that MAP_SYNC does not exist
> on this platform, and that means HAVE_MAP_SYNC will not be defined.
> That means when xfs_io is built, io/Makefile does not add
> -DHAVE_MAP_SYNC to the cflags, and so when io/mmap.c includes
> io/io.h -> xfs.h -> linux.h we hit this code:
>
> #ifndef HAVE_MAP_SYNC
> #define MAP_SYNC 0
> #define MAP_SHARED_VALIDATE 0
> #else
> #include <asm-generic/mman.h>
> #include <asm-generic/mman-common.h>
> #endif /* HAVE_MAP_SYNC */
>
> Given that this is the last include in the io/mmap.c file, it should
> not matter what musl is doing - this define should be overriding it
> completely.
>
> Ooooh.
>
> input.h -> libfrog/projects.h -> xfs.h -> linux.h.
>
> Ok, we've tangled up header includes, and that's why moving the
> sys/mman.h header fixes the warning. Right, we need to untangle the
> headers.
>
> .... and my build + test rack just had a total internal power
> failure of some kind, so that's as far as I can go right now...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
