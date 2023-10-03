Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BF2E7544F
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Oct 2023 11:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjJCL6Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 07:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240317AbjJCLPu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2023 07:15:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3540CC8
        for <linux-xfs@vger.kernel.org>; Tue,  3 Oct 2023 04:15:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0688EC433C8;
        Tue,  3 Oct 2023 11:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696331732;
        bh=x68g4dzkKb6zTc6vIixMy8Zl5fHLoD9iqTFjCmphKuA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ug7k0gfDAzyo8E+owaWiu+vSa7wHml+bT7pPHRG+RU8cyB9/Cd8YA8wVxjflWvjsg
         8AslYBCn86zp8T+VMuRk5ohl6VJZeMOw4V54EeeTrYsBjAfXY6AYIUh+ueAt1rAkS6
         E7AVH7xE/sZJQHgaOKG7e8R5vVRHZhi8Ok0VNSTuQZSUqNdKAzUyjXfZsQVtmgM1f3
         Rf6LpL4JzcUzlBnuTrFpkmsRHl/FpaL76R32Pw8T8gWXBrhAeTIckWry+CTJ+OcXND
         epdTSjDx97Vnd+XE9Pfcet2Lh7WbGKjDk3bn8dTkMGrBAQV7RcYPbJ1UeMhcagEKvw
         Mwf6HZS4tKLnQ==
Date:   Tue, 3 Oct 2023 13:15:27 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Krzesimir Nowak <qdlacz@gmail.com>, linux-xfs@vger.kernel.org,
        Krzesimir Nowak <knowak@microsoft.com>
Subject: Re: [PATCH 1/1] libfrog: Fix cross-compilation issue with randbytes
Message-ID: <20231003111527.nkn3p2gpamfd5leh@andromeda>
References: <20230926071432.51866-1-knowak@microsoft.com>
 <20230926071432.51866-2-knowak@microsoft.com>
 <snPbvVemO-KACiVV0MsnX0uHqamLCj_w6t-8_yyeSjozjPfI6TuWV4XCSBFPaP-H6MJSAzfhAGlyAl3PmwkzZA==@protonmail.internalid>
 <20230926144100.GD11439@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926144100.GD11439@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 07:41:00AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 26, 2023 at 09:14:32AM +0200, Krzesimir Nowak wrote:
> > randbytes.c was mostly split off from crc32.c and, like crc32.c, is
> > used for selftests, which are run on the build host. As such it should
> > not include platform_defs.h which in turn includes urcu.h from
> > userspace-rcu library, because the build host might not have the
> > library installed.
> 
> Why not get rid of the build host crc32c selftest?  It's not that useful
> for cross-compiling and nowadays mkfs.xfs and xfs_repair have their own
> builtin selftests.  Anyone messing with xfsprogs should be running
> fstests (in addition to the maintainers) so I don't really see the point
> of running crc32cselftest on the *build* host.
> 
> (Carlos: any thoughts on this?)

/me back from holidays...

Yeah, sounds reasonable, IMO crc32selftest can go.

Carlos

> 
> --D
> 
> > Signed-off-by: Krzesimir Nowak <knowak@microsoft.com>
> > ---
> >  libfrog/randbytes.c | 1 -
> >  libfrog/randbytes.h | 2 ++
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/libfrog/randbytes.c b/libfrog/randbytes.c
> > index f22da0d3..2023b601 100644
> > --- a/libfrog/randbytes.c
> > +++ b/libfrog/randbytes.c
> > @@ -6,7 +6,6 @@
> >   *
> >   * This is the buffer of random bytes used for self tests.
> >   */
> > -#include "platform_defs.h"
> >  #include "libfrog/randbytes.h"
> >
> >  /* 4096 random bytes */
> > diff --git a/libfrog/randbytes.h b/libfrog/randbytes.h
> > index 00fd7c4c..fddea9c7 100644
> > --- a/libfrog/randbytes.h
> > +++ b/libfrog/randbytes.h
> > @@ -6,6 +6,8 @@
> >  #ifndef __LIBFROG_RANDBYTES_H__
> >  #define __LIBFROG_RANDBYTES_H__
> >
> > +#include <stdint.h>
> > +
> >  extern uint8_t randbytes_test_buf[];
> >
> >  #endif /* __LIBFROG_RANDBYTES_H__ */
> > --
> > 2.25.1
> >
