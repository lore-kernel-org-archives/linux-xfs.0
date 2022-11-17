Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27C4C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 21:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiKQVvd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 16:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239647AbiKQVvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 16:51:31 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D90F10FD8
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 13:51:30 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so6583004pjs.4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 13:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n9eQ0A/TvysUmX8LAkuVikayO1tSHhe9JBe0nDSvQWI=;
        b=nub1um7mI8BOuGT9d3740WMmNaoOZW9vqXqtUJpjaPqIKq6WSFO5Z4dx+S6hp4Pqeq
         j1QaTvOS02upTcN23sGvkiL/cfQt0Sr9vlEJ8fvTcZKDF0RwHNtSCpUJE5XH0DSFIwja
         RC2WN1hrbm820gncNdqozyi4ys8eyMJjVJhOKpxuYsPC/IlGJsIsK1i8Gt/G/ubdLKk+
         0DTzAVh5vM3sbZkPsQcGxArJYXp/oIP/+uz0ebvk67aKiLxcrK3qx3dOxhweqMVl/wMD
         Hag2M3ZVu02xv7WtdujkQG9I1wDq7yPiqGVoQ9dp7p7z5P9ySw2M5c8RK0d6c8D9V8WK
         HFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n9eQ0A/TvysUmX8LAkuVikayO1tSHhe9JBe0nDSvQWI=;
        b=1z3sAxpN3JPWIbpt5CZsWUHx8VRKPLNnli+OV4EBAk8+WYhvj3i2wz0WZYEWL4XqA/
         cjH66x8FpcFeQx5vIeddIYDIIJ3STKbbDrzSCV/EvKVE/WVgWZL5pcQtaupWdLOZpZ+C
         /i4h/+wHmCMTHvXsN23oL9bjGksjbIGLm2apdlZ8qt+SXT0S3VQLDz4tRnNnz10ZgWG9
         ONCNPu2GG9biRY5d1mcyyO0X1RgaDlfPEx0jGrh3l7Ct+FD6hV8kWeoz4YQO0jPgThoO
         YXcNdkDUEd1Gc9tMGRXQCurbrn0QVJ2tLKQWfC/ZFk4juc1xOm9w7zewHgdzLH1rPiBy
         birA==
X-Gm-Message-State: ANoB5plUwXaD3e8T8BHsVmPEXpF0WUTec94j6tLorPUHlmtvR4o+TjQ0
        tEZVsK61ILuMsfBea2/FdSyvu3XPw8fyhA==
X-Google-Smtp-Source: AA0mqf6urT23I3+TJ8F4IWDm3iP1DQ596VK7m7q40V86Zeys9lw8/51a+sCv4L2f4qJLRkg6DGhoKg==
X-Received: by 2002:a17:903:25d1:b0:176:71be:cc64 with SMTP id jc17-20020a17090325d100b0017671becc64mr4422734plb.141.1668721890050;
        Thu, 17 Nov 2022 13:51:30 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id c64-20020a624e43000000b0056bb36c047asm1630939pfb.105.2022.11.17.13.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 13:51:29 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ovmn7-00FRvT-U1; Fri, 18 Nov 2022 08:51:25 +1100
Date:   Fri, 18 Nov 2022 08:51:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] xfs_spaceman: add fsuuid command
Message-ID: <20221117215125.GH3600936@dread.disaster.area>
References: <20221109222335.84920-1-catherine.hoang@oracle.com>
 <Y3abjYmX//CF/ey0@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y3abjYmX//CF/ey0@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 17, 2022 at 12:37:33PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 09, 2022 at 02:23:35PM -0800, Catherine Hoang wrote:
> > Add support for the fsuuid command to retrieve the UUID of a mounted
> > filesystem.
> > 
> > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > ---
> >  spaceman/Makefile |  4 +--
> >  spaceman/fsuuid.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++
> >  spaceman/init.c   |  1 +
> >  spaceman/space.h  |  1 +
> >  4 files changed, 67 insertions(+), 2 deletions(-)
> >  create mode 100644 spaceman/fsuuid.c
> > 
> > diff --git a/spaceman/Makefile b/spaceman/Makefile
> > index 1f048d54..901e4e6d 100644
> > --- a/spaceman/Makefile
> > +++ b/spaceman/Makefile
> > @@ -7,10 +7,10 @@ include $(TOPDIR)/include/builddefs
> >  
> >  LTCOMMAND = xfs_spaceman
> >  HFILES = init.h space.h
> > -CFILES = info.c init.c file.c health.c prealloc.c trim.c
> > +CFILES = info.c init.c file.c health.c prealloc.c trim.c fsuuid.c
> >  LSRCFILES = xfs_info.sh
> >  
> > -LLDLIBS = $(LIBXCMD) $(LIBFROG)
> > +LLDLIBS = $(LIBXCMD) $(LIBFROG) $(LIBUUID)
> >  LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
> >  LLDFLAGS = -static
> >  
> > diff --git a/spaceman/fsuuid.c b/spaceman/fsuuid.c
> > new file mode 100644
> > index 00000000..be12c1ad
> > --- /dev/null
> > +++ b/spaceman/fsuuid.c
> > @@ -0,0 +1,63 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2022 Oracle.
> > + * All Rights Reserved.
> > + */
> > +
> > +#include "libxfs.h"
> > +#include "libfrog/fsgeom.h"
> > +#include "libfrog/paths.h"
> > +#include "command.h"
> > +#include "init.h"
> > +#include "space.h"
> > +#include <sys/ioctl.h>
> > +
> > +#ifndef FS_IOC_GETFSUUID
> > +#define FS_IOC_GETFSUUID	_IOR('f', 44, struct fsuuid)
> > +#define UUID_SIZE 16
> > +struct fsuuid {
> > +    __u32   fsu_len;
> > +    __u32   fsu_flags;
> > +    __u8    fsu_uuid[];
> 
> This is a flex array   ^^ which has no size.  struct fsuuid therefore
> has a size of 8 bytes (i.e. enough to cover the two u32 fields) and no
> more.  It's assumed that the caller will allocate the memory for
> fsu_uuid...
> 
> > +};
> > +#endif
> > +
> > +static cmdinfo_t fsuuid_cmd;
> > +
> > +static int
> > +fsuuid_f(
> > +	int		argc,
> > +	char		**argv)
> > +{
> > +	struct fsuuid	fsuuid;
> > +	int		error;
> 
> ...which makes this usage a problem, because we've not reserved any
> space on the stack to hold the UUID.  The kernel will blindly assume
> that there are fsuuid.fsu_len bytes after fsuuid and write to them,
> which will clobber something on the stack.
> 
> If you're really unlucky, the C compiler will put the fsuuid right
> before the call frame, which is how stack smashing attacks work.  It
> might also lay out bp[] immediately afterwards, which will give you
> weird results as the unparse function overwrites its source buffer.  The
> C compiler controls the stack layout, which means this can go bad in
> subtle ways.
> 
> Either way, gcc complains about this (albeit in an opaque manner)...
> 
> In file included from ../include/xfs.h:9,
>                  from ../include/libxfs.h:15,
>                  from fsuuid.c:7:
> In function ‘platform_uuid_unparse’,
>     inlined from ‘fsuuid_f’ at fsuuid.c:45:3:
> ../include/xfs/linux.h:100:9: error: ‘uuid_unparse’ reading 16 bytes from a region of size 0 [-Werror=stringop-overread]
>   100 |         uuid_unparse(*uu, buffer);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../include/xfs/linux.h: In function ‘fsuuid_f’:
> ../include/xfs/linux.h:100:9: note: referencing argument 1 of type ‘const unsigned char *’
> In file included from ../include/xfs/linux.h:13,
>                  from ../include/xfs.h:9,
>                  from ../include/libxfs.h:15,
>                  from fsuuid.c:7:
> /usr/include/uuid/uuid.h:107:13: note: in a call to function ‘uuid_unparse’
>   107 | extern void uuid_unparse(const uuid_t uu, char *out);
>       |             ^~~~~~~~~~~~
> cc1: all warnings being treated as errors
> 
> ...so please allocate the struct fsuuid object dynamically.

So, follow common convention and you'll get it wrong, eh? That a
score of -4 on Rusty's API Design scale.

http://sweng.the-davies.net/Home/rustys-api-design-manifesto

Flex arrays in user APIs like this just look plain dangerous to me.

Really, this says that the FSUUID API should have a fixed length
buffer size defined in the API and the length used can be anything
up to the maximum.

We already have this being added for the ioctl API:

#define UUID_SIZE 16

So why isn't the API definition this:

struct fsuuid {
    __u32   fsu_len;
    __u32   fsu_flags;
    __u8    fsu_uuid[UUID_SIZE];
};

Or if we want to support larger ID structures:

#define MAX_FSUUID_SIZE 256

struct fsuuid {
    __u32   fsu_len;
    __u32   fsu_flags;
    __u8    fsu_uuid[MAX_FSUUID_SIZE];
};

Then the structure can be safely placed on the stack, which means
"the obvious use is (probably) the correct one" (a score of 7 on
Rusty's API Design scale). It also gives the kernel a fixed upper
bound that it can use to validate the incoming fsu_len variable
against...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
