Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B23C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 23:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiKUXeC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 18:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiKUXeB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 18:34:01 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D466630F60
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 15:34:00 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id n17so12541882pgh.9
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 15:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8J3UG6GPiaHAaAv9OsNNYpsjQQPlRXXEKz4REEZN1ZY=;
        b=iiJHfUrRlM+Kreltqu/PDw5sVCu1aTi07q9y/eo3w681r/GHJUqJDkncZW0feyBWyq
         3qAcQNNTePOcAtmYMcai5ZPmxe0Wgl+qAVb9pUI6uK5VImHRXhDL8sWy2HXeFfOmsEwH
         lY5pSpjQAZR37/V2BQQK8OM02Lx+T6KNLZIWya9znYAZ+ujZNgazFVMYtEAufF/sbHhU
         2eIiSf4fOHYxTpAlMjGw7gSp1NbhRjO9nJ/EPq1SfII3eE7iJes6hJ6ep9M3gtO8tRvh
         FeCidFJxDu8EAOgLPo9JvYZ39Qpr5PVPa32jq4HYa7p57VnXShnrQczC1/+1k8vzfuct
         9+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8J3UG6GPiaHAaAv9OsNNYpsjQQPlRXXEKz4REEZN1ZY=;
        b=K65CwJZrfTzaXrlK39/EAN/0ND9RqyT1kzGYlede1kjk5kCCMP2Xkb+DB2fYmitjcI
         Rj9ghjkHuOIUrotZb75kbP44KTKUmhn71yhnOOPHZThXIUsGHiK+CDMSKOI6lqadYwXr
         tqCX+rtafhrBogC7aUTA1e9wRSqaZ8om/oE34guVLu4SmMg7s0Ch3Y2dCwjKwc34kgvq
         LsvPkGyyfigUedi1IFqimhBZbWC9gz8Hd98Q5vElm5ceevFXMZIzMSB1RYnH7/+W5863
         Ps5lAlHevp/epHWLXBATuMuFnzzL0yz8TItpeXkBzEcA3ZCREKD/5JBJALIzRXd1XlDO
         qrKQ==
X-Gm-Message-State: ANoB5pmdeesR0Wk36webZRP8U02n64pXSjCHXturFloxDGcRxU0PCk+E
        CLOuLMkg6IzxNWgMFAxsTRVZMQ==
X-Google-Smtp-Source: AA0mqf5QLIu0dEFWJJiDoxqCb8ziSKm612jMjscOWFlXQaKcCOv9QPf6Buyd1n4avwN32C2l2V1JlQ==
X-Received: by 2002:a63:4c59:0:b0:476:c490:798a with SMTP id m25-20020a634c59000000b00476c490798amr871090pgl.564.1669073640347;
        Mon, 21 Nov 2022 15:34:00 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902650b00b00178b9c997e5sm10338331plk.138.2022.11.21.15.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 15:33:59 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oxGIX-00H3SV-11; Tue, 22 Nov 2022 10:33:57 +1100
Date:   Tue, 22 Nov 2022 10:33:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] xfs_spaceman: add fsuuid command
Message-ID: <20221121233357.GO3600936@dread.disaster.area>
References: <20221109222335.84920-1-catherine.hoang@oracle.com>
 <Y3abjYmX//CF/ey0@magnolia>
 <20221117215125.GH3600936@dread.disaster.area>
 <Y3bKjm2vOwy/jV4Z@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y3bKjm2vOwy/jV4Z@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 17, 2022 at 03:58:06PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 18, 2022 at 08:51:25AM +1100, Dave Chinner wrote:
> > On Thu, Nov 17, 2022 at 12:37:33PM -0800, Darrick J. Wong wrote:
> > > On Wed, Nov 09, 2022 at 02:23:35PM -0800, Catherine Hoang wrote:
> > > > Add support for the fsuuid command to retrieve the UUID of a mounted
> > > > filesystem.
> > > > 
> > > > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > > > ---
> > > >  spaceman/Makefile |  4 +--
> > > >  spaceman/fsuuid.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++
> > > >  spaceman/init.c   |  1 +
> > > >  spaceman/space.h  |  1 +
> > > >  4 files changed, 67 insertions(+), 2 deletions(-)
> > > >  create mode 100644 spaceman/fsuuid.c
> > > > 
> > > > diff --git a/spaceman/Makefile b/spaceman/Makefile
> > > > index 1f048d54..901e4e6d 100644
> > > > --- a/spaceman/Makefile
> > > > +++ b/spaceman/Makefile
> > > > @@ -7,10 +7,10 @@ include $(TOPDIR)/include/builddefs
> > > >  
> > > >  LTCOMMAND = xfs_spaceman
> > > >  HFILES = init.h space.h
> > > > -CFILES = info.c init.c file.c health.c prealloc.c trim.c
> > > > +CFILES = info.c init.c file.c health.c prealloc.c trim.c fsuuid.c
> > > >  LSRCFILES = xfs_info.sh
> > > >  
> > > > -LLDLIBS = $(LIBXCMD) $(LIBFROG)
> > > > +LLDLIBS = $(LIBXCMD) $(LIBFROG) $(LIBUUID)
> > > >  LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
> > > >  LLDFLAGS = -static
> > > >  
> > > > diff --git a/spaceman/fsuuid.c b/spaceman/fsuuid.c
> > > > new file mode 100644
> > > > index 00000000..be12c1ad
> > > > --- /dev/null
> > > > +++ b/spaceman/fsuuid.c
> > > > @@ -0,0 +1,63 @@
> > > > +// SPDX-License-Identifier: GPL-2.0
> > > > +/*
> > > > + * Copyright (c) 2022 Oracle.
> > > > + * All Rights Reserved.
> > > > + */
> > > > +
> > > > +#include "libxfs.h"
> > > > +#include "libfrog/fsgeom.h"
> > > > +#include "libfrog/paths.h"
> > > > +#include "command.h"
> > > > +#include "init.h"
> > > > +#include "space.h"
> > > > +#include <sys/ioctl.h>
> > > > +
> > > > +#ifndef FS_IOC_GETFSUUID
> > > > +#define FS_IOC_GETFSUUID	_IOR('f', 44, struct fsuuid)
> > > > +#define UUID_SIZE 16
> > > > +struct fsuuid {
> > > > +    __u32   fsu_len;
> > > > +    __u32   fsu_flags;
> > > > +    __u8    fsu_uuid[];
> > > 
> > > This is a flex array   ^^ which has no size.  struct fsuuid therefore
> > > has a size of 8 bytes (i.e. enough to cover the two u32 fields) and no
> > > more.  It's assumed that the caller will allocate the memory for
> > > fsu_uuid...
> > > 
> > > > +};
> > > > +#endif
> > > > +
> > > > +static cmdinfo_t fsuuid_cmd;
> > > > +
> > > > +static int
> > > > +fsuuid_f(
> > > > +	int		argc,
> > > > +	char		**argv)
> > > > +{
> > > > +	struct fsuuid	fsuuid;
> > > > +	int		error;
> > > 
> > > ...which makes this usage a problem, because we've not reserved any
> > > space on the stack to hold the UUID.  The kernel will blindly assume
> > > that there are fsuuid.fsu_len bytes after fsuuid and write to them,
> > > which will clobber something on the stack.
> > > 
> > > If you're really unlucky, the C compiler will put the fsuuid right
> > > before the call frame, which is how stack smashing attacks work.  It
> > > might also lay out bp[] immediately afterwards, which will give you
> > > weird results as the unparse function overwrites its source buffer.  The
> > > C compiler controls the stack layout, which means this can go bad in
> > > subtle ways.
> > > 
> > > Either way, gcc complains about this (albeit in an opaque manner)...
> > > 
> > > In file included from ../include/xfs.h:9,
> > >                  from ../include/libxfs.h:15,
> > >                  from fsuuid.c:7:
> > > In function ‘platform_uuid_unparse’,
> > >     inlined from ‘fsuuid_f’ at fsuuid.c:45:3:
> > > ../include/xfs/linux.h:100:9: error: ‘uuid_unparse’ reading 16 bytes from a region of size 0 [-Werror=stringop-overread]
> > >   100 |         uuid_unparse(*uu, buffer);
> > >       |         ^~~~~~~~~~~~~~~~~~~~~~~~~
> > > ../include/xfs/linux.h: In function ‘fsuuid_f’:
> > > ../include/xfs/linux.h:100:9: note: referencing argument 1 of type ‘const unsigned char *’
> > > In file included from ../include/xfs/linux.h:13,
> > >                  from ../include/xfs.h:9,
> > >                  from ../include/libxfs.h:15,
> > >                  from fsuuid.c:7:
> > > /usr/include/uuid/uuid.h:107:13: note: in a call to function ‘uuid_unparse’
> > >   107 | extern void uuid_unparse(const uuid_t uu, char *out);
> > >       |             ^~~~~~~~~~~~
> > > cc1: all warnings being treated as errors
> > > 
> > > ...so please allocate the struct fsuuid object dynamically.
> > 
> > So, follow common convention and you'll get it wrong, eh? That a
> > score of -4 on Rusty's API Design scale.
> > 
> > http://sweng.the-davies.net/Home/rustys-api-design-manifesto
> > 
> > Flex arrays in user APIs like this just look plain dangerous to me.
> > 
> > Really, this says that the FSUUID API should have a fixed length
> > buffer size defined in the API and the length used can be anything
> > up to the maximum.
> > 
> > We already have this being added for the ioctl API:
> > 
> > #define UUID_SIZE 16
> > 
> > So why isn't the API definition this:
> > 
> > struct fsuuid {
> >     __u32   fsu_len;
> >     __u32   fsu_flags;
> >     __u8    fsu_uuid[UUID_SIZE];
> > };
> > 
> > Or if we want to support larger ID structures:
> > 
> > #define MAX_FSUUID_SIZE 256
> > 
> > struct fsuuid {
> >     __u32   fsu_len;
> >     __u32   fsu_flags;
> >     __u8    fsu_uuid[MAX_FSUUID_SIZE];
> > };
> > 
> > Then the structure can be safely placed on the stack, which means
> > "the obvious use is (probably) the correct one" (a score of 7 on
> > Rusty's API Design scale). It also gives the kernel a fixed upper
> > bound that it can use to validate the incoming fsu_len variable
> > against...
> 
> Too late now, this already shipped in 6.0.  Changing the struct size
> would change the ioctl number, which is a totally new API.  This was
> already discussed back in July on fsdevel/api.

It is certainly not too late - if we are going to lift this to the
VFS, then we can simply make it a new ioctl. The horrible ext4 ioctl
can ber left to rot in ext4 and nobody else ever needs to care that
it exists.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
