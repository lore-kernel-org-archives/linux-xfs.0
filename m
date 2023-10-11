Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A88FCD6E5C
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 11:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbjJKLfB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 07:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbjJKLfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 07:35:00 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB8BC0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:34:59 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-5068dab8c00so5651137e87.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697024097; x=1697628897; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULRVQUOrjIrYRk7mloXiNFxxy5U4rnHl2YSt/sL/c3U=;
        b=C8d/9zzZRu/dBlokDIaHf9gCbsS4JDiP3+yRivXrIFNi1pE1sMv8qDNkO2+bFCSb48
         I19ZRRmJ4vsdOdsP+JuZ6IUWLdpJm5uVaA8hnx05ZexYYZLWPeAIztrW8d0mSeFpU0qh
         fWhEZD/KbcvZoxgAkgiizQ9qQ24/uAeqiFfWnGp1cmEDvlJx+ZsBYZiUugqIBvp/c26+
         CQam0YW7sGsftwGlw7Kn07/Sm9LeobP+Llbg5K0hUrVkcq8TIsGiAy1rpAczDsw6Deto
         uaE5OiAqOg37lNpsAGa4Syiz9AHj1jAO21Mw92DzvlgOd0ir4osMzX3OErHoVmTu203o
         irwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697024097; x=1697628897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ULRVQUOrjIrYRk7mloXiNFxxy5U4rnHl2YSt/sL/c3U=;
        b=ialEUbALe0XsuqJYSI3+l5yWd7ytGI19ouE0POR7dwEQZy3Re8VOmamsAslZ1RjuQh
         Dz92Yue4y0g3FRM4r9zg4bxmSF8vNLwD8EDkwy//SqK65HG/Z1nScSWGi+v6Uvi1eehW
         6ueWo4WoMR3jfEqrWJAJ01QhxobYAlQukWgoo/+4U3qm5UEO7zFBKF6qkEybuc2RImaf
         giRTKj7J+O4WyNaXDlIZ+SNogXsxGWOjHzgsmY93rkzezkH7rpDRRLXFN7lrHv/f/D/K
         gGlpYZMWzrdgSt6IBxBr5iiuX95sWLmjSjsFDkN/f8awbyAViUYmrDGdlLKUOWiDLfkk
         hJmg==
X-Gm-Message-State: AOJu0Ywo/xogi3/49BPv4Bgnt8XjjCTe1lonvXUky/bgH5C/lrTaStY3
        WLsSOIhdtWhzuuwTEEXHTL1K+c1Jtx0MMbNYTCM=
X-Google-Smtp-Source: AGHT+IH4mZxixl9k0Y4Xk4R8wOWufThKHdVaoEY86TjLBIsbxUj+QndY+sqPnjchG7AkBnoGoNvaUrX+DqB0v5cHb40=
X-Received: by 2002:a05:6512:3c2:b0:4fe:15b5:a5f9 with SMTP id
 w2-20020a05651203c200b004fe15b5a5f9mr13233570lfp.54.1697024097132; Wed, 11
 Oct 2023 04:34:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230926071432.51866-1-knowak@microsoft.com> <20230926071432.51866-2-knowak@microsoft.com>
 <snPbvVemO-KACiVV0MsnX0uHqamLCj_w6t-8_yyeSjozjPfI6TuWV4XCSBFPaP-H6MJSAzfhAGlyAl3PmwkzZA==@protonmail.internalid>
 <20230926144100.GD11439@frogsfrogsfrogs> <20231003111527.nkn3p2gpamfd5leh@andromeda>
In-Reply-To: <20231003111527.nkn3p2gpamfd5leh@andromeda>
From:   Krzesimir Nowak <qdlacz@gmail.com>
Date:   Wed, 11 Oct 2023 13:34:45 +0200
Message-ID: <CANoGTXCQpQRztAZuXOipCkPXC4oJCb1Vn0sQO_EyjMW1Jno=aw@mail.gmail.com>
Subject: Re: [PATCH 1/1] libfrog: Fix cross-compilation issue with randbytes
To:     Carlos Maiolino <cem@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Krzesimir Nowak <knowak@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

wt., 3 pa=C5=BA 2023 o 13:15 Carlos Maiolino <cem@kernel.org> napisa=C5=82(=
a):
>
> On Tue, Sep 26, 2023 at 07:41:00AM -0700, Darrick J. Wong wrote:
> > On Tue, Sep 26, 2023 at 09:14:32AM +0200, Krzesimir Nowak wrote:
> > > randbytes.c was mostly split off from crc32.c and, like crc32.c, is
> > > used for selftests, which are run on the build host. As such it shoul=
d
> > > not include platform_defs.h which in turn includes urcu.h from
> > > userspace-rcu library, because the build host might not have the
> > > library installed.
> >
> > Why not get rid of the build host crc32c selftest?  It's not that usefu=
l
> > for cross-compiling and nowadays mkfs.xfs and xfs_repair have their own
> > builtin selftests.  Anyone messing with xfsprogs should be running
> > fstests (in addition to the maintainers) so I don't really see the poin=
t
> > of running crc32cselftest on the *build* host.
> >
> > (Carlos: any thoughts on this?)
>
> /me back from holidays...
>
> Yeah, sounds reasonable, IMO crc32selftest can go.

Hi,

There's a follow-up patch that I have sent - it drops the crc32 selftest:

https://marc.info/?l=3Dlinux-xfs&m=3D169590021227419&w=3D2

Not sure if there is anything else I should do. If so, please let me
know. Thanks!

Cheers,
Krzesimir

>
> Carlos
>
> >
> > --D
> >
> > > Signed-off-by: Krzesimir Nowak <knowak@microsoft.com>
> > > ---
> > >  libfrog/randbytes.c | 1 -
> > >  libfrog/randbytes.h | 2 ++
> > >  2 files changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/libfrog/randbytes.c b/libfrog/randbytes.c
> > > index f22da0d3..2023b601 100644
> > > --- a/libfrog/randbytes.c
> > > +++ b/libfrog/randbytes.c
> > > @@ -6,7 +6,6 @@
> > >   *
> > >   * This is the buffer of random bytes used for self tests.
> > >   */
> > > -#include "platform_defs.h"
> > >  #include "libfrog/randbytes.h"
> > >
> > >  /* 4096 random bytes */
> > > diff --git a/libfrog/randbytes.h b/libfrog/randbytes.h
> > > index 00fd7c4c..fddea9c7 100644
> > > --- a/libfrog/randbytes.h
> > > +++ b/libfrog/randbytes.h
> > > @@ -6,6 +6,8 @@
> > >  #ifndef __LIBFROG_RANDBYTES_H__
> > >  #define __LIBFROG_RANDBYTES_H__
> > >
> > > +#include <stdint.h>
> > > +
> > >  extern uint8_t randbytes_test_buf[];
> > >
> > >  #endif /* __LIBFROG_RANDBYTES_H__ */
> > > --
> > > 2.25.1
> > >
